using System.Net;
using System.Security.Claims;
using System.Threading.RateLimiting;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using CIMSNextMCC.Infrastructure.Tenancy;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;

namespace CIMSNextMCC.API.DependencyResolution;

/// <summary>
/// DEVELOPMENT ONLY. POST /api/v1/dev/token mints the same HS256 token `dotnet user-jwts create --scheme DevJwt` would,
/// signed with the key already configured for the DevJwt scheme, so the SPA's sign-in page can get a dev token from
/// the API instead of a shell command. Program.cs registers and maps it only when the environment is Development; the
/// handler checks that again, and answers 404 to any request that did not come from this machine, so it looks like
/// a route that does not exist. The key is never generated here: without one the answer is 503 with the command to run.
/// </summary>
public static class DevTokenEndpoint
{
    public const string Route = "/api/v1/dev/token";
    public const string RateLimitPolicy = "dev-token";
    public const string Scope = "cims.nextmcc";
    public const string Tenant = "NextMCC";
    public const string DefaultAudience = "cims-nextmcc-api";
    public const int DefaultValidForHours = 8;
    public const int MaxValidForHours = 24;
    public const int MaxUserNameLength = 50; // dbo.PwInfo.UserName
    public const string UnknownUserMessage = "unknown user";

    public static IServiceCollection AddDevToken(this IServiceCollection services) =>
        services.AddRateLimiter(options =>
        {
            options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
            options.AddPolicy(RateLimitPolicy, context =>
            {
                // Requests from elsewhere are not counted: the handler answers them with 404 like a missing route.
                var remote = context.Connection.RemoteIpAddress;
                return remote is not null && IPAddress.IsLoopback(remote)
                    ? RateLimitPartition.GetFixedWindowLimiter(remote.ToString(), _ => new FixedWindowRateLimiterOptions
                    {
                        PermitLimit = 10,
                        Window = TimeSpan.FromMinutes(1),
                        QueueLimit = 0
                    })
                    : RateLimitPartition.GetNoLimiter("not-loopback");
            });
        });

    public static IEndpointRouteBuilder MapDevToken(this IEndpointRouteBuilder endpoints)
    {
        endpoints.MapPost(Route, HandleAsync)
            .AllowAnonymous()
            .RequireRateLimiting(RateLimitPolicy)
            .ExcludeFromDescription();
        return endpoints;
    }

    public sealed record DevTokenRequest(string? Username, int? ValidForHours);

    public sealed record DevTokenResponse(string Token, DateTimeOffset ExpiresAt, IReadOnlyDictionary<string, string> Claims);

    public static async Task<IResult> HandleAsync(
        HttpContext http,
        IOptionsMonitor<JwtBearerOptions> bearerOptions,
        IHostEnvironment environment)
    {
        if (!environment.IsDevelopment() || !IsLocalRequest(http))
        {
            return Results.NotFound();
        }

        DevTokenRequest? request;
        try
        {
            request = http.Request.HasJsonContentType()
                ? await http.Request.ReadFromJsonAsync<DevTokenRequest>(http.RequestAborted)
                : null;
        }
        catch (System.Text.Json.JsonException)
        {
            return Results.Problem(statusCode: StatusCodes.Status400BadRequest, title: "The request body is not valid JSON.");
        }

        var userName = request?.Username?.Trim();
        if (string.IsNullOrEmpty(userName) || userName.Length > MaxUserNameLength)
        {
            return Results.Problem(statusCode: StatusCodes.Status400BadRequest, title: "username is required (at most 50 characters).");
        }

        var validForHours = request?.ValidForHours ?? DefaultValidForHours;
        if (validForHours is < 1 or > MaxValidForHours)
        {
            return Results.Problem(statusCode: StatusCodes.Status400BadRequest, title: $"validForHours must be between 1 and {MaxValidForHours}.");
        }

        var validation = bearerOptions.Get(DevJwtExtensions.Scheme).TokenValidationParameters;
        var signingKey = FindSigningKey(validation);
        if (signingKey is null)
        {
            return Results.Problem(
                statusCode: StatusCodes.Status503ServiceUnavailable,
                title: "No DevJwt signing key is configured.",
                detail: "Run once, in the API project folder: dotnet user-jwts create --scheme DevJwt --audience cims-nextmcc-api "
                    + "--scope cims.nextmcc --name <user>. It stores the key in this API's user-secrets; then try again.");
        }

        // The tenant comes from the token's claim and an anonymous request has none: use the one dev tokens carry, and
        // ignore a stale X-Tenant header, which would be checked against a "tenants" claim that is not there.
        http.Request.Headers.Remove(TenantContext.TenantHeader);
        http.User = new ClaimsPrincipal(new ClaimsIdentity([new Claim(TenantContext.TenantClaim, Tenant)]));

        var users = http.RequestServices.GetRequiredService<ILegacyUserRepository>();
        var matches = await users.FindByUserNameAsync(userName, http.RequestAborted);
        if (matches.Count == 0)
        {
            return Results.Problem(statusCode: StatusCodes.Status404NotFound, title: UnknownUserMessage);
        }

        if (matches.Count > 1)
        {
            return Results.Problem(
                statusCode: StatusCodes.Status409Conflict,
                title: "ambiguous user",
                detail: "More than one PwInfo row has this user name, so the cookie bridge could not sign it in either.");
        }

        // The stored spelling, so the lookup in /legacy-session finds the same row.
        var name = matches[0].UserName ?? userName;
        var now = DateTimeOffset.UtcNow;
        var expires = now.AddHours(validForHours);
        var audience = validation.ValidAudiences?.FirstOrDefault(a => !string.IsNullOrWhiteSpace(a))
            ?? DefaultAudience;

        var claims = new Dictionary<string, object>
        {
            ["sub"] = name,
            ["unique_name"] = name,
            ["username"] = name,
            ["jti"] = Guid.NewGuid().ToString("N")[..8],
            ["scope"] = Scope,
            ["tenant"] = Tenant
        };

        var token = new JsonWebTokenHandler().CreateToken(new SecurityTokenDescriptor
        {
            Issuer = DevJwtExtensions.UserJwtsIssuer,
            Audience = audience,
            Claims = claims,
            NotBefore = now.UtcDateTime,
            IssuedAt = now.UtcDateTime,
            Expires = expires.UtcDateTime,
            SigningCredentials = new SigningCredentials(signingKey, SecurityAlgorithms.HmacSha256)
        });

        return Results.Ok(new DevTokenResponse(
            token,
            expires,
            new Dictionary<string, string>
            {
                ["sub"] = name,
                ["username"] = name,
                ["tenant"] = Tenant,
                ["scope"] = Scope,
                ["aud"] = audience,
                ["iss"] = DevJwtExtensions.UserJwtsIssuer
            }));
    }

    /// <summary>
    /// True when the TCP peer is this machine and, if a proxy forwarded the request (the dev gateway's nginx), so is
    /// every address it names as the original client.
    /// </summary>
    public static bool IsLocalRequest(HttpContext http)
    {
        var remote = http.Connection.RemoteIpAddress;
        if (remote is null || !IPAddress.IsLoopback(remote))
        {
            return false;
        }

        foreach (var header in new[] { "X-Forwarded-For", "X-Real-IP" })
        {
            foreach (var value in http.Request.Headers[header])
            {
                foreach (var part in (value ?? string.Empty).Split(',', StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries))
                {
                    if (!IPAddress.TryParse(part, out var address) || !IPAddress.IsLoopback(address))
                    {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    /// <summary>
    /// The first symmetric key the DevJwt scheme itself validates with: bound from Authentication:Schemes:DevJwt:SigningKeys
    /// (the entries `dotnet user-jwts` wrote) when the scheme's options were first built. Signing with these, not a fresh
    /// read of the configuration, means the token always matches the running validator, even if the key was re-created
    /// by another `dotnet user-jwts` call after this API started.
    /// </summary>
    private static SymmetricSecurityKey? FindSigningKey(TokenValidationParameters parameters) =>
        parameters.IssuerSigningKeys?.OfType<SymmetricSecurityKey>().FirstOrDefault(key => key.Key.Length >= 16);
}

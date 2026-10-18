using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.JsonWebTokens;

namespace CIMSNextMCC.API.DependencyResolution;

/// <summary>
/// DEVELOPMENT ONLY. Accepts tokens minted locally with `dotnet user-jwts create --scheme DevJwt ...` next to the
/// CIMS Identity tokens, for machines that cannot reach the Identity Server. A policy scheme becomes the default and
/// forwards each request by the token's issuer: "dotnet-user-jwts" to DevJwt, anything else to the normal Bearer scheme.
/// Issuer, audiences and signing key of DevJwt are bound from Authentication:Schemes:DevJwt, which `dotnet user-jwts`
/// writes (appsettings.Development.json and the project's user-secrets). Never registered outside Development.
/// </summary>
public static class DevJwtExtensions
{
    public const string Scheme = "DevJwt";
    public const string SelectorScheme = "BearerOrDevJwt";
    public const string UserJwtsIssuer = "dotnet-user-jwts";

    public static AuthenticationBuilder AddDevJwt(
        this AuthenticationBuilder builder,
        Func<TokenValidatedContext, Task> onTokenValidated)
    {
        builder.AddJwtBearer(Scheme, options =>
        {
            // Runs after the configuration binding, so this only adjusts what `dotnet user-jwts` configured.
            options.TokenValidationParameters.NameClaimType = "username";
            options.Events = new JwtBearerEvents { OnTokenValidated = onTokenValidated };
        });

        builder.AddPolicyScheme(SelectorScheme, "CIMS Identity or dotnet user-jwts", options =>
        {
            options.ForwardDefaultSelector = context =>
                IsUserJwtsToken(context.Request.Headers.Authorization.ToString())
                    ? Scheme
                    : JwtBearerDefaults.AuthenticationScheme;
        });

        return builder;
    }

    private static bool IsUserJwtsToken(string authorization)
    {
        const string prefix = "Bearer ";
        if (!authorization.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        var token = authorization[prefix.Length..].Trim();
        var handler = new JsonWebTokenHandler();
        return handler.CanReadToken(token) && handler.ReadJsonWebToken(token).Issuer == UserJwtsIssuer;
    }
}

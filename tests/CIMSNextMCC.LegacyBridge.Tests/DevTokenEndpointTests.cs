using System.Net;
using System.Text;
using CIMSNextMCC.API.DependencyResolution;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using CIMSNextMCC.Domain.Entities.Security;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;

namespace CIMSNextMCC.LegacyBridge.Tests;

/// <summary>
/// POST /api/v1/dev/token: the token must pass the DevJwt scheme's own validation parameters (bound from the same
/// Authentication:Schemes:DevJwt section `dotnet user-jwts` writes), and the endpoint must look absent to anyone but
/// this machine.
/// </summary>
public class DevTokenEndpointTests
{
    private static readonly string KeyBase64 = Convert.ToBase64String(Enumerable.Range(1, 32).Select(i => (byte)i).ToArray());

    private sealed class FakeUsers(params string[] names) : ILegacyUserRepository
    {
        public string? LastLookup { get; private set; }

        public Task<IReadOnlyList<LegacyUser>> FindByUserNameAsync(string userName, CancellationToken cancellationToken = default)
        {
            LastLookup = userName;
            IReadOnlyList<LegacyUser> rows = names
                .Where(n => string.Equals(n, userName, StringComparison.OrdinalIgnoreCase))
                .Select(n => new LegacyUser { UserName = n, UserId = "1", UserCategory = "Employee", UserLevel = "x" })
                .ToList();
            return Task.FromResult(rows);
        }
    }

    private sealed class DevEnvironment(string name) : IHostEnvironment
    {
        public string EnvironmentName { get; set; } = name;
        public string ApplicationName { get; set; } = "test";
        public string ContentRootPath { get; set; } = ".";
        public Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get; set; } = null!;
    }

    private static IConfiguration Config(bool withKey = true, string? audience = "cims-nextmcc-api") =>
        new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["Authentication:Schemes:DevJwt:ValidIssuer"] = "dotnet-user-jwts",
            ["Authentication:Schemes:DevJwt:ValidAudiences:0"] = audience,
            ["Authentication:Schemes:DevJwt:SigningKeys:0:Issuer"] = withKey ? "dotnet-user-jwts" : null,
            ["Authentication:Schemes:DevJwt:SigningKeys:0:Value"] = withKey ? KeyBase64 : null,
            ["Authentication:Schemes:DevJwt:SigningKeys:0:Length"] = withKey ? "32" : null
        }).Build();

    private static DefaultHttpContext Request(
        FakeUsers users,
        object? body = null,
        IPAddress? remote = null,
        string? forwardedFor = null)
    {
        var context = new DefaultHttpContext
        {
            RequestServices = new ServiceCollection().AddSingleton<ILegacyUserRepository>(users).BuildServiceProvider()
        };
        context.Connection.RemoteIpAddress = remote ?? IPAddress.Loopback;
        context.Request.Method = HttpMethods.Post;
        context.Request.ContentType = "application/json";
        context.Request.Body = new MemoryStream(Encoding.UTF8.GetBytes(
            body as string ?? System.Text.Json.JsonSerializer.Serialize(body ?? new { }) ));
        if (forwardedFor is not null)
        {
            context.Request.Headers["X-Forwarded-For"] = forwardedFor;
        }

        return context;
    }

    /// <summary>The DevJwt scheme exactly as Program.cs registers it, with its options bound from the configuration.</summary>
    private static IOptionsMonitor<JwtBearerOptions> BearerOptions(IConfiguration configuration)
    {
        var services = new ServiceCollection();
        services.AddLogging();
        services.AddSingleton(configuration);
        services.AddAuthentication().AddDevJwt(_ => Task.CompletedTask);
        return services.BuildServiceProvider().GetRequiredService<IOptionsMonitor<JwtBearerOptions>>();
    }

    private static Task<IResult> Call(HttpContext context, IConfiguration configuration, string environment = "Development") =>
        DevTokenEndpoint.HandleAsync(context, BearerOptions(configuration), new DevEnvironment(environment));

    private static ProblemHttpResult Problem(IResult result) => Assert.IsType<ProblemHttpResult>(result);

    [Fact]
    public async Task Token_is_accepted_by_the_DevJwt_scheme_validation_parameters()
    {
        var configuration = Config();
        var result = await Call(Request(new FakeUsers("Madhuka"), new { username = "madhuka", validForHours = 2 }), configuration);

        var ok = Assert.IsType<Ok<DevTokenEndpoint.DevTokenResponse>>(result).Value!;

        var parameters = BearerOptions(configuration).Get(DevJwtExtensions.Scheme).TokenValidationParameters;

        var validation = await new JsonWebTokenHandler().ValidateTokenAsync(ok.Token, parameters);

        Assert.True(validation.IsValid, validation.Exception?.Message);
        var identity = validation.ClaimsIdentity;
        Assert.Equal("Madhuka", identity.FindFirst("username")?.Value); // the stored spelling
        Assert.Equal("Madhuka", identity.FindFirst("sub")?.Value);
        Assert.Equal("Madhuka", identity.FindFirst("unique_name")?.Value);
        Assert.Equal("cims.nextmcc", identity.FindFirst("scope")?.Value);
        Assert.Equal("NextMCC", identity.FindFirst("tenant")?.Value);
        Assert.NotNull(identity.FindFirst("jti"));
        Assert.Equal("Madhuka", identity.Name); // NameClaimType = "username"

        var jwt = new JsonWebTokenHandler().ReadJsonWebToken(ok.Token);
        Assert.Equal("dotnet-user-jwts", jwt.Issuer);
        Assert.Contains("cims-nextmcc-api", jwt.Audiences);
        Assert.Equal("HS256", jwt.Alg);
        Assert.InRange(jwt.ValidTo, DateTime.UtcNow.AddHours(2).AddMinutes(-1), DateTime.UtcNow.AddHours(2).AddMinutes(1));
        Assert.Equal(jwt.ValidTo, ok.ExpiresAt.UtcDateTime, TimeSpan.FromSeconds(1));
        Assert.Equal("Madhuka", ok.Claims["username"]);
    }

    [Fact]
    public async Task Audience_is_the_first_configured_one_and_validForHours_defaults_to_eight()
    {
        var configuration = Config(audience: "my-api");
        var result = await Call(Request(new FakeUsers("jdoe"), new { username = "jdoe" }), configuration);

        var ok = Assert.IsType<Ok<DevTokenEndpoint.DevTokenResponse>>(result).Value!;
        var jwt = new JsonWebTokenHandler().ReadJsonWebToken(ok.Token);
        Assert.Contains("my-api", jwt.Audiences);
        Assert.InRange(jwt.ValidTo, DateTime.UtcNow.AddHours(8).AddMinutes(-1), DateTime.UtcNow.AddHours(8).AddMinutes(1));
    }

    [Fact]
    public async Task The_request_gets_the_dev_tenant_so_the_repository_can_open_the_tenant_database()
    {
        var context = Request(new FakeUsers("jdoe"), new { username = "jdoe" });
        context.Request.Headers["X-Tenant"] = "Whatever";

        await Call(context, Config());

        Assert.Equal("NextMCC", context.User.FindFirst("tenant")?.Value);
        Assert.False(context.Request.Headers.ContainsKey("X-Tenant"));
    }

    [Theory]
    [InlineData("203.0.113.9", null)]            // direct request from another machine
    [InlineData("127.0.0.1", "203.0.113.9")]     // via the gateway, but the original client is elsewhere
    [InlineData("127.0.0.1", "127.0.0.1, 10.1.2.3")]
    [InlineData("127.0.0.1", "not-an-address")]
    public async Task Requests_that_are_not_from_this_machine_get_404_without_a_body(string remote, string? forwardedFor)
    {
        var users = new FakeUsers("jdoe");
        var result = await Call(
            Request(users, new { username = "jdoe" }, IPAddress.Parse(remote), forwardedFor),
            Config());

        Assert.IsType<NotFound>(result);
        Assert.Null(users.LastLookup);
    }

    [Theory]
    [InlineData("127.0.0.1", null)]
    [InlineData("::1", null)]
    [InlineData("::ffff:127.0.0.1", null)]
    [InlineData("127.0.0.1", "127.0.0.1")]
    [InlineData("127.0.0.1", "::1")]
    public async Task Loopback_requests_are_served_also_through_the_gateway(string remote, string? forwardedFor)
    {
        var result = await Call(
            Request(new FakeUsers("jdoe"), new { username = "jdoe" }, IPAddress.Parse(remote), forwardedFor),
            Config());

        Assert.IsType<Ok<DevTokenEndpoint.DevTokenResponse>>(result);
    }

    [Fact]
    public async Task A_missing_remote_address_is_refused()
    {
        var context = Request(new FakeUsers("jdoe"), new { username = "jdoe" });
        context.Connection.RemoteIpAddress = null;

        Assert.IsType<NotFound>(await Call(context, Config()));
    }

    [Fact]
    public async Task Outside_Development_the_handler_answers_404_even_if_it_were_mapped()
    {
        var result = await Call(Request(new FakeUsers("jdoe"), new { username = "jdoe" }), Config(), "Production");

        Assert.IsType<NotFound>(result);
    }

    [Fact]
    public async Task Without_a_signing_key_the_answer_is_503_naming_the_command_to_run()
    {
        var users = new FakeUsers("jdoe");
        var problem = Problem(await Call(Request(users, new { username = "jdoe" }), Config(withKey: false)));

        Assert.Equal(StatusCodes.Status503ServiceUnavailable, problem.StatusCode);
        Assert.Contains("dotnet user-jwts create --scheme DevJwt", problem.ProblemDetails.Detail);
        Assert.Null(users.LastLookup);
    }

    [Fact]
    public async Task A_key_for_another_issuer_does_not_count()
    {
        var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["Authentication:Schemes:DevJwt:SigningKeys:0:Issuer"] = "someone-else",
            ["Authentication:Schemes:DevJwt:SigningKeys:0:Value"] = KeyBase64
        }).Build();

        var problem = Problem(await Call(Request(new FakeUsers("jdoe"), new { username = "jdoe" }), configuration));

        Assert.Equal(StatusCodes.Status503ServiceUnavailable, problem.StatusCode);
    }

    [Fact]
    public async Task An_unknown_user_is_404_unknown_user()
    {
        var problem = Problem(await Call(Request(new FakeUsers("jdoe"), new { username = "nobody" }), Config()));

        Assert.Equal(StatusCodes.Status404NotFound, problem.StatusCode);
        Assert.Equal("unknown user", problem.ProblemDetails.Title);
    }

    [Theory]
    [InlineData("{}")]
    [InlineData("""{"username":"   "}""")]
    [InlineData("""{"username":"jdoe","validForHours":0}""")]
    [InlineData("""{"username":"jdoe","validForHours":25}""")]
    [InlineData("{not json")]
    public async Task A_bad_request_is_400(string body)
    {
        var problem = Problem(await Call(Request(new FakeUsers("jdoe"), body), Config()));

        Assert.Equal(StatusCodes.Status400BadRequest, problem.StatusCode);
    }
}

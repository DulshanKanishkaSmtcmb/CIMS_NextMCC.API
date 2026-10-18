using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.DependencyResolution;
using CIMSNextMCC.API.Health;
using CIMSNextMCC.API.Middleware;
using CIMSNextMCC.Application;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Infrastructure;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Serilog;

// Bootstrap logger so start-up failures are logged before the host (and the configured Serilog) exists.
Log.Logger = new LoggerConfiguration().WriteTo.Console().CreateBootstrapLogger();

try
{
    var builder = WebApplication.CreateBuilder(args);

    builder.Host.UseSerilog((context, services, configuration) => configuration
        .ReadFrom.Configuration(context.Configuration)
        .ReadFrom.Services(services)
        .Enrich.FromLogContext());

    builder.Services.Configure<IdentitySettings>(builder.Configuration.GetSection("Identity"));
    builder.Services.Configure<AuthorizationSettings>(builder.Configuration.GetSection("Authorization"));

    builder.Services.AddMemoryCache();
    builder.Services.AddCors();
    builder.Services.AddApplication();
    builder.Services.AddInfrastructure(builder.Configuration);

    var identitySettings = builder.Configuration
        .GetSection("Identity")
        .Get<IdentitySettings>() ?? new IdentitySettings();

    if (string.IsNullOrWhiteSpace(identitySettings.Authority))
    {
        throw new InvalidOperationException("Identity:Authority is not configured.");
    }

    builder.Services
        .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddJwtBearer(options =>
        {
            options.Authority = identitySettings.Authority;
            options.Audience = identitySettings.Audience;
            options.RequireHttpsMetadata = identitySettings.RequireHttpsMetadata;
            options.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                NameClaimType = "username"
            };
            options.Events = new JwtBearerEvents
            {
                OnTokenValidated = context =>
                {
                    var requiredScope = identitySettings.RequiredScope;
                    if (string.IsNullOrWhiteSpace(requiredScope))
                    {
                        return Task.CompletedTask;
                    }

                    var scopes = context.Principal?.Claims
                        .Where(claim => claim.Type is "scope" or "scp")
                        .SelectMany(claim => claim.Value.Split(' ', StringSplitOptions.RemoveEmptyEntries))
                        .ToHashSet(StringComparer.OrdinalIgnoreCase) ?? [];

                    if (!scopes.Contains(requiredScope))
                    {
                        context.Fail($"Required scope '{requiredScope}' is missing.");
                    }

                    return Task.CompletedTask;
                }
            };
        });

    builder.Services.AddAuthorization(options =>
    {
        options.FallbackPolicy = new AuthorizationPolicyBuilder()
            .RequireAuthenticatedUser()
            .Build();
    });

    // [RequireMenu("<key>")]: menu-based authorization, log-only until Authorization:LogOnly is set to false.
    builder.Services.AddScoped<IAuthorizationHandler, MenuAuthorizationHandler>();

    builder.Services.AddHealthChecks()
        .AddCheck("self", () => HealthCheckResult.Healthy(), tags: ["live"])
        .AddCheck<TenantSqlHealthCheck>("sqlserver", tags: ["ready"]);

    builder.Services.ConfigureApiVersioning();
    builder.Services.AddSwaggerDocument();
    builder.Services.AddControllers();
    builder.Services.AddEndpointsApiExplorer();

    var app = builder.Build();

    app.UseMiddleware<ExceptionMiddleware>();

    if (app.Environment.IsDevelopment() || app.Configuration.GetValue<bool>("EnableSwagger"))
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }

    // HTTPS redirection stays off: TLS terminates at the Nginx gateway (container reverse proxy).
    // app.UseHttpsRedirection();

    app.UseSerilogRequestLogging();
    app.UseRouting();

    var allowedOrigins = app.Configuration
        .GetSection("Cors:AllowedOrigins")
        .Get<string[]>() ?? [];

    if (allowedOrigins.Length > 0)
    {
        app.UseCors(policy => policy
            .WithOrigins(allowedOrigins)
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials());
    }

    app.UseAuthentication();
    app.UseAuthorization();

    // After authentication: it needs the tenant, which comes from the token. Skips GETs and [SkipTransaction] endpoints.
    app.UseMiddleware<TransactionMiddleware>();

    app.MapHealthChecks("/health", new HealthCheckOptions
    {
        ResponseWriter = HealthResponseWriter.WriteAsync
    }).AllowAnonymous();

    app.MapHealthChecks("/health/live", new HealthCheckOptions
    {
        Predicate = check => check.Tags.Contains("live"),
        ResponseWriter = HealthResponseWriter.WriteAsync
    }).AllowAnonymous();

    app.MapHealthChecks("/health/ready", new HealthCheckOptions
    {
        Predicate = check => check.Tags.Contains("ready"),
        ResponseWriter = HealthResponseWriter.WriteAsync
    }).AllowAnonymous();

    app.MapControllers();

    app.Run();
}
catch (Exception ex) when (ex is not HostAbortedException)
{
    Log.Fatal(ex, "CIMSNextMCC.API terminated unexpectedly.");
    return 1;
}
finally
{
    Log.CloseAndFlush();
}

return 0;

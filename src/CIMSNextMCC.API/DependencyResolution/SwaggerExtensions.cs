using System.Reflection;
using Microsoft.OpenApi;

namespace CIMSNextMCC.API.DependencyResolution;

public static class SwaggerExtensions
{
    public static void AddSwaggerDocument(this IServiceCollection services)
    {
        services.AddSwaggerGen(options =>
        {
            options.SwaggerDoc("v1", new OpenApiInfo
            {
                Title = "CIMSNextMCC API Documentation",
                Description = "Documentation of CIMSNextMCC REST API.",
                Version = "v1",
                Contact = new OpenApiContact
                {
                    Name = "Speedmark Team",
                    Url = new Uri("https://www.speedmark.com")
                }
            });

            var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
            var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
            if (File.Exists(xmlPath))
            {
                options.IncludeXmlComments(xmlPath);
            }

            options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                Name = "Authorization",
                Type = SecuritySchemeType.Http,
                Scheme = "bearer",
                BearerFormat = "JWT",
                In = ParameterLocation.Header,
                Description = "Enter: Bearer {access token from CIMS.Identity}"
            });

            options.AddSecurityRequirement(document => new OpenApiSecurityRequirement
            {
                [new OpenApiSecuritySchemeReference("Bearer", document)] = []
            });
        });
    }
}

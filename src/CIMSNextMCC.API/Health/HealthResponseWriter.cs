using System.Text.Json;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace CIMSNextMCC.API.Health;

public static class HealthResponseWriter
{
    public static async Task WriteAsync(HttpContext context, HealthReport report)
    {
        context.Response.ContentType = "application/json";

        var response = new
        {
            status = report.Status.ToString(),
            totalDuration = report.TotalDuration.ToString(),
            entries = report.Entries.ToDictionary(
                entry => entry.Key,
                entry => new
                {
                    status = entry.Value.Status.ToString(),
                    description = entry.Value.Description,
                    duration = entry.Value.Duration.ToString()
                })
        };

        await context.Response.WriteAsync(JsonSerializer.Serialize(response));
    }
}

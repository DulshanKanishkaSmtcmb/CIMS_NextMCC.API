using CIMSNextMCC.Infrastructure.Tenancy;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;

namespace CIMSNextMCC.API.Health;

/// <summary>Opens each configured tenant's Main database and runs SELECT 1.</summary>
public class TenantSqlHealthCheck(IOptions<TenantOptions> options) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        var tenants = options.Value.Tenants
            .Where(t => !string.IsNullOrWhiteSpace(t.ConnectionStrings.Main))
            .ToList();

        if (tenants.Count == 0)
        {
            // Degraded (HTTP 200) rather than Unhealthy so a fresh checkout without secrets still reports "up".
            return HealthCheckResult.Degraded("No tenant Main connection string is configured.");
        }

        var failed = new List<string>();
        foreach (var tenant in tenants)
        {
            try
            {
                await using var connection = new SqlConnection(tenant.ConnectionStrings.Main);
                await connection.OpenAsync(cancellationToken);

                await using var command = connection.CreateCommand();
                command.CommandText = "SELECT 1";
                command.CommandTimeout = 5;
                await command.ExecuteScalarAsync(cancellationToken);
            }
            catch (Exception)
            {
                failed.Add(tenant.Key);
            }
        }

        return failed.Count == 0
            ? HealthCheckResult.Healthy($"SQL Server connection is healthy for {tenants.Count} tenant(s).")
            : HealthCheckResult.Unhealthy($"SQL Server connection failed for: {string.Join(", ", failed)}.");
    }
}

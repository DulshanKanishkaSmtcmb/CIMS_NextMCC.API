using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Domain.Tenancy;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;

namespace CIMSNextMCC.Infrastructure.Tenancy;

public sealed class TenantConnectionFactory(ITenantContext tenantContext, IOptions<TenantOptions> options)
    : ITenantConnectionFactory
{
    public IDbConnection Open(DbName database)
    {
        var tenantKey = tenantContext.Key;
        var tenant = options.Value.Find(tenantKey)
            ?? throw new InvalidOperationException($"Tenant '{tenantKey}' is not configured.");

        var connectionString = tenant.ConnectionStrings.Get(database);
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            // Name the setting, never the value.
            throw new InvalidOperationException(
                $"No connection string is configured for tenant '{tenant.Key}', database '{database}' " +
                $"(Tenants:<index>:ConnectionStrings:{database}).");
        }

        var connection = new SqlConnection(connectionString);
        try
        {
            connection.Open();
            return connection;
        }
        catch
        {
            connection.Dispose();
            throw;
        }
    }
}

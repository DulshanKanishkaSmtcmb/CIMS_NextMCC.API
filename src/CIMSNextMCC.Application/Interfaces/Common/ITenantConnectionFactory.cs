using System.Data;
using CIMSNextMCC.Domain.Tenancy;

namespace CIMSNextMCC.Application.Interfaces.Common;

public interface ITenantConnectionFactory
{
    /// <summary>Opens a connection to the given database of the current tenant. The caller disposes it.</summary>
    IDbConnection Open(DbName database);
}

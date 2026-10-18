using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>Ports the five queries of legacy DataApi/getRateInformation4Add (same projections and ORDER BY).</summary>
public class RateCardRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IRateCardRepository
{
    public async Task<IReadOnlyList<string>> GetContainerTypesAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.ContainerType FROM dbo.ContainerType t1 ORDER BY t1.ContainerType";
        return (await QueryAsync<string>(sql, cancellationToken)).AsList();
    }

    public async Task<IReadOnlyList<RatePort>> GetPortsAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.PortCode, t1.PortName FROM dbo.Ports t1 ORDER BY t1.PortCode";
        return (await QueryAsync<RatePort>(sql, cancellationToken)).AsList();
    }

    public async Task<IReadOnlyList<ClearanceRate>> GetClearanceRatesAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.CntrType, t1.RateInUSD FROM dbo.RateClearHaulageExport t1 ORDER BY t1.CntrType";
        return (await QueryAsync<ClearanceRate>(sql, cancellationToken)).AsList();
    }

    public async Task<IReadOnlyList<FreightRate>> GetFreightRatesAsync(CancellationToken cancellationToken = default)
    {
        const string sql =
            "SELECT t1.PortCode, t2.PortName, t1.CntrType, t1.RateInUSD FROM dbo.RateFreightExport t1 " +
            "INNER JOIN dbo.Ports t2 ON t2.PortCode = t1.PortCode ORDER BY t1.PortCode, t1.CntrType";
        return (await QueryAsync<FreightRate>(sql, cancellationToken)).AsList();
    }

    public async Task<IReadOnlyList<CfsRate>> GetCfsRatesAsync(CancellationToken cancellationToken = default)
    {
        const string sql =
            "SELECT t1.*, ISNULL(t2.PMDescription, '') AS PMDescription FROM dbo.RateCFSExport t1 " +
            "LEFT JOIN dbo.PMMaster t2 ON t2.PMCode = t1.MaterialCode ORDER BY t1.ChgCode";
        return (await QueryAsync<CfsRate>(sql, cancellationToken)).AsList();
    }

    private Task<IEnumerable<T>> QueryAsync<T>(string sql, CancellationToken cancellationToken) =>
        connection.QueryAsync<T>(new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
}

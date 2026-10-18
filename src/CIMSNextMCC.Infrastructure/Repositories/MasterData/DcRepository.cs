using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getDCList and getDCData (parameterized, same projections and order) and the two stored
/// procedures of SaveApi/SaveDCData (same names, parameters and types).
/// </summary>
public class DcRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IDcRepository
{
    public async Task<IReadOnlyList<DcMaster>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.DestWarehouse t1 ORDER BY t1.WhDes";
        var rows = await connection.QueryAsync<DcMaster>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<DcMaster?> FindAsync(string whDes, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.DestWarehouse t1 WHERE t1.WhDes = @WhDes";
        var parameters = new DynamicParameters();
        parameters.Add("@WhDes", whDes, DbType.String, size: 50);
        var rows = await connection.QueryAsync<DcMaster>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.FirstOrDefault();
    }

    public Task AddAsync(string whCode, string whDes, string countryCode, CancellationToken cancellationToken = default)
    {
        // CREATE procedure DestWarehouseAdd (@WhCode nvarchar(10), @WhDes nvarchar(50), @CountryCode nvarchar(10))
        return ExecuteProcedureAsync("dbo.DestWarehouseAdd", Parameters(whCode, whDes, countryCode), cancellationToken);
    }

    public Task UpdateAsync(string whCode, string whDes, string countryCode, CancellationToken cancellationToken = default)
    {
        // CREATE procedure DestWarehouseEdit (@WhCode nvarchar(10), @WhDes nvarchar(50), @CountryCode nvarchar(10));
        // the SP sets CountryCode only, where WhDes = @WhDes.
        return ExecuteProcedureAsync("dbo.DestWarehouseEdit", Parameters(whCode, whDes, countryCode), cancellationToken);
    }

    private static DynamicParameters Parameters(string whCode, string whDes, string countryCode)
    {
        var parameters = new DynamicParameters();
        parameters.Add("@WhCode", whCode, DbType.String, size: 10);
        parameters.Add("@WhDes", whDes, DbType.String, size: 50);
        parameters.Add("@CountryCode", countryCode, DbType.String, size: 10);
        return parameters;
    }

    private Task ExecuteProcedureAsync(string procedure, DynamicParameters parameters, CancellationToken cancellationToken) =>
        connection.ExecuteAsync(new CommandDefinition(
            procedure,
            parameters,
            unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
}

using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getOkToLoadResonListUpdate (parameterized) and the statements of
/// SaveApi/SaveOkToShipReason (the DELETE and the stored procedure, same names, parameters and types).
/// </summary>
public class OkToLoadReasonRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IOkToLoadReasonRepository
{
    public async Task<IReadOnlyList<OkToLoadReasonRow>> GetAsync(string? dc, CancellationToken cancellationToken = default)
    {
        var hasDc = !string.IsNullOrEmpty(dc);
        var sql = "SELECT t1.Reason, t1.DtlReson, t1.Warehouse AS DC FROM dbo.OkToLoadReason t1 " +
                  (hasDc ? "WHERE t1.Warehouse = @Dc " : string.Empty) +
                  "ORDER BY t1.Warehouse, t1.ReasonOrder";
        var parameters = new DynamicParameters();
        if (hasDc)
        {
            parameters.Add("@Dc", dc, DbType.String, size: 50);
        }

        var rows = await connection.QueryAsync<OkToLoadReasonRow>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<IReadOnlyList<string>> GetAllocatedReasonsAsync(string dc, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT DISTINCT t2.nApprvToShip FROM dbo.CargoReceived t2 WHERE t2.nApprvToShip <> '' AND t2.Warehouse = @Dc";
        var parameters = new DynamicParameters();
        parameters.Add("@Dc", dc, DbType.String, size: 50);
        var rows = await connection.QueryAsync<string>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public Task DeleteByDcAsync(string dc, CancellationToken cancellationToken = default)
    {
        const string sql = "DELETE FROM dbo.OkToLoadReason WHERE Warehouse = @Dc";
        var parameters = new DynamicParameters();
        parameters.Add("@Dc", dc, DbType.String, size: 50);
        return connection.ExecuteAsync(new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
    }

    public Task AddAsync(string reason, decimal reasonOrder, string dtlReson, string warehouse, CancellationToken cancellationToken = default)
    {
        // CREATE procedure OkToLoadReasonAdd (@Reason nvarchar(50), @ReasonOrder decimal, @DtlReson nvarchar(1000), @Warehouse nvarchar(50))
        var parameters = new DynamicParameters();
        parameters.Add("@Reason", reason, DbType.String, size: 50);
        parameters.Add("@ReasonOrder", reasonOrder, DbType.Decimal);
        parameters.Add("@DtlReson", dtlReson, DbType.String, size: 1000);
        parameters.Add("@Warehouse", warehouse, DbType.String, size: 50);
        return connection.ExecuteAsync(new CommandDefinition(
            "dbo.OkToLoadReasonAdd",
            parameters,
            unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
    }
}

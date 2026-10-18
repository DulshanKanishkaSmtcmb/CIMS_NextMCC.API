using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getPalletRacksList and getPalletRacksData (parameterized, same projections and order) and
/// the two stored procedures of SaveApi/SaveCargoPalletBuild (same names, parameters and types).
/// </summary>
public class PalletRackRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IPalletRackRepository
{
    public async Task<IReadOnlyList<PalletRack>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.PalletRacks t1 ORDER BY t1.RackNo";
        var rows = await connection.QueryAsync<PalletRack>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<PalletRack?> FindAsync(string rackNo, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.PalletRacks t1 WHERE t1.RackNo = @RackNo";
        var rows = await connection.QueryAsync<PalletRack>(
            new CommandDefinition(sql, LookupParameters(rackNo), unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.FirstOrDefault();
    }

    public async Task<IReadOnlyList<PalletRackPosition>> GetPositionsAsync(string rackNo, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.PalletRacksUtilization t1 WHERE t1.RackNo = @RackNo";
        var rows = await connection.QueryAsync<PalletRackPosition>(
            new CommandDefinition(sql, LookupParameters(rackNo), unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public Task AddRackAsync(string rackNo, decimal nofRows, decimal nofLayers, decimal nofPositions, CancellationToken cancellationToken = default)
    {
        // CREATE procedure PalletRacksAdd (@RackNo nvarchar(10), @NofRows decimal, @NofLayers decimal, @NofPositions decimal)
        var parameters = new DynamicParameters();
        parameters.Add("@RackNo", rackNo, DbType.String, size: 10);
        parameters.Add("@NofRows", nofRows, DbType.Decimal);
        parameters.Add("@NofLayers", nofLayers, DbType.Decimal);
        parameters.Add("@NofPositions", nofPositions, DbType.Decimal);
        return ExecuteProcedureAsync("dbo.PalletRacksAdd", parameters, cancellationToken);
    }

    public Task AddPositionAsync(string rackNo, string positionNo, CancellationToken cancellationToken = default)
    {
        // CREATE Procedure PalletRacksUtilizationAdd (@RackNo nvarchar(10), @PositionNo nvarchar(10))
        var parameters = new DynamicParameters();
        parameters.Add("@RackNo", rackNo, DbType.String, size: 10);
        parameters.Add("@PositionNo", positionNo, DbType.String, size: 10);
        return ExecuteProcedureAsync("dbo.PalletRacksUtilizationAdd", parameters, cancellationToken);
    }

    // The lookup value is not cut to the column size: a longer text must not match a rack by its first ten characters.
    private static DynamicParameters LookupParameters(string rackNo)
    {
        var parameters = new DynamicParameters();
        parameters.Add("@RackNo", rackNo, DbType.String, size: 4000);
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

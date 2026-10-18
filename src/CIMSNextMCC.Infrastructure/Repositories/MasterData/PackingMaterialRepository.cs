using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getPMList, getPMData, getPmCategoryData (parameterized, same projections and order) and
/// the two stored procedures of SaveApi/SavePMData (same names, parameters and types).
/// </summary>
public class PackingMaterialRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IPackingMaterialRepository
{
    public async Task<IReadOnlyList<PackingMaterial>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        // Legacy: select t1.* from PMMaster t1 Order By t1.PMCode
        const string sql = "SELECT t1.* FROM dbo.PMMaster t1 ORDER BY t1.PMCode";
        var rows = await connection.QueryAsync<PackingMaterial>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<PackingMaterial?> FindAsync(string pmCode, CancellationToken cancellationToken = default)
    {
        // Legacy: select t1.* from PMMaster t1 where t1.PMCode='<code>'
        const string sql = "SELECT t1.* FROM dbo.PMMaster t1 WHERE t1.PMCode = @PMCode";
        var parameters = new DynamicParameters();
        parameters.Add("@PMCode", pmCode, DbType.String, size: 12);
        var rows = await connection.QueryAsync<PackingMaterial>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.FirstOrDefault();
    }

    public async Task<IReadOnlyList<PackingMaterialCategory>> GetCategoriesAsync(CancellationToken cancellationToken = default)
    {
        // Legacy: select t1.* from PMCategories t1 (no order)
        const string sql = "SELECT t1.* FROM dbo.PMCategories t1";
        var rows = await connection.QueryAsync<PackingMaterialCategory>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public Task AddAsync(PackingMaterialValues values, CancellationToken cancellationToken = default) =>
        ExecuteProcedureAsync("dbo.PMMasterAdd", values, cancellationToken);

    public Task UpdateAsync(PackingMaterialValues values, CancellationToken cancellationToken = default) =>
        ExecuteProcedureAsync("dbo.PMMasterEdit", values, cancellationToken);

    private Task ExecuteProcedureAsync(string procedure, PackingMaterialValues values, CancellationToken cancellationToken)
    {
        // CREATE PROCEDURE PMMasterAdd / PMMasterEdit (@PMCode nvarchar(10), @PMDescription nvarchar(50), @PMCategory nvarchar(50),
        //   @ReorderLevel int, @PMWeight decimal(18,2), @CBM decimal(18,2), @GetJokersCount bit, @GetPartsCount bit, @IsActive bit)
        var parameters = new DynamicParameters();
        parameters.Add("@PMCode", values.PmCode, DbType.String, size: 10);
        parameters.Add("@PMDescription", values.PmDescription, DbType.String, size: 50);
        parameters.Add("@PMCategory", values.PmCategory, DbType.String, size: 50);
        parameters.Add("@ReorderLevel", values.ReorderLevel, DbType.Int32);
        parameters.Add("@PMWeight", values.PmWeight, DbType.Decimal, precision: 18, scale: 2);
        parameters.Add("@CBM", values.Cbm, DbType.Decimal, precision: 18, scale: 2);
        parameters.Add("@GetJokersCount", values.GetJokersCount, DbType.Boolean);
        parameters.Add("@GetPartsCount", values.GetPartsCount, DbType.Boolean);
        parameters.Add("@IsActive", values.IsActive, DbType.Boolean);
        return connection.ExecuteAsync(new CommandDefinition(
            procedure,
            parameters,
            unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
    }
}

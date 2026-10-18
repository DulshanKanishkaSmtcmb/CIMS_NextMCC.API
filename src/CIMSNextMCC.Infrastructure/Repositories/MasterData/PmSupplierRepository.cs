using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getPMSupplierList, getPMSupplierData and the last-code lookup of
/// SaveApi/SavePMSupplierData (parameterized, same projections and order) and its two stored procedures (same names,
/// parameters and types).
/// </summary>
public class PmSupplierRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IPmSupplierRepository
{
    public async Task<IReadOnlyList<PmSupplierMaster>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.PMSupplier t1 ORDER BY t1.PMSupplierCode";
        var rows = await connection.QueryAsync<PmSupplierMaster>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<PmSupplierMaster?> FindAsync(string code, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.PMSupplier t1 WHERE t1.PMSupplierCode = @PMSupplierCode";
        var parameters = new DynamicParameters();
        parameters.Add("@PMSupplierCode", code, DbType.String, size: 5);
        var rows = await connection.QueryAsync<PmSupplierMaster>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.FirstOrDefault();
    }

    public async Task<string?> GetLastCodeAsync(string prefix, CancellationToken cancellationToken = default)
    {
        // Legacy: select top 1 PMSupplierCode from PMSupplier where left(PMSupplierCode,1) = '<first letter of the name>' order by PMSupplierCode DESC.
        // UPDLOCK + HOLDLOCK: see SupplierRepository.GetLastCodeAsync.
        const string sql =
            "SELECT TOP 1 PMSupplierCode FROM dbo.PMSupplier WITH (UPDLOCK, HOLDLOCK) WHERE LEFT(PMSupplierCode, 1) = @Prefix ORDER BY PMSupplierCode DESC";
        var parameters = new DynamicParameters();
        parameters.Add("@Prefix", prefix, DbType.String, size: 1);
        return await connection.QueryFirstOrDefaultAsync<string>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
    }

    public Task AddAsync(PmSupplierWrite supplier, CancellationToken cancellationToken = default) =>
        ExecuteProcedureAsync("dbo.PMSupplierAdd", Parameters(supplier), cancellationToken);

    public Task UpdateAsync(PmSupplierWrite supplier, CancellationToken cancellationToken = default) =>
        ExecuteProcedureAsync("dbo.PMSupplierEdit", Parameters(supplier), cancellationToken);

    private static DynamicParameters Parameters(PmSupplierWrite s)
    {
        // CREATE PROCEDURE PMSupplierAdd / PMSupplierEdit (@PMSupplierCode nvarchar(5), @PMSupplierName nvarchar(50),
        // @PMSupplierAddress1..4 nvarchar(50), @PMSupplierContact1..3 nvarchar(50), @PMSupplierTel nvarchar(50),
        // @PMSupplierEmail nvarchar(50), @PMSupplierFax nvarchar(50), @CountryCode nvarchar(10))
        var p = new DynamicParameters();
        p.Add("@PMSupplierCode", s.PmSupplierCode, DbType.String, size: 5);
        p.Add("@PMSupplierName", s.PmSupplierName, DbType.String, size: 50);
        p.Add("@PMSupplierAddress1", s.PmSupplierAddress1, DbType.String, size: 50);
        p.Add("@PMSupplierAddress2", s.PmSupplierAddress2, DbType.String, size: 50);
        p.Add("@PMSupplierAddress3", s.PmSupplierAddress3, DbType.String, size: 50);
        p.Add("@PMSupplierAddress4", s.PmSupplierAddress4, DbType.String, size: 50);
        p.Add("@PMSupplierContact1", s.PmSupplierContact1, DbType.String, size: 50);
        p.Add("@PMSupplierContact2", s.PmSupplierContact2, DbType.String, size: 50);
        p.Add("@PMSupplierContact3", s.PmSupplierContact3, DbType.String, size: 50);
        p.Add("@PMSupplierTel", s.PmSupplierTel, DbType.String, size: 50);
        p.Add("@PMSupplierEmail", s.PmSupplierEmail, DbType.String, size: 50);
        p.Add("@PMSupplierFax", s.PmSupplierFax, DbType.String, size: 50);
        p.Add("@CountryCode", s.CountryCode, DbType.String, size: 10);
        return p;
    }

    private Task ExecuteProcedureAsync(string procedure, DynamicParameters parameters, CancellationToken cancellationToken) =>
        connection.ExecuteAsync(new CommandDefinition(
            procedure,
            parameters,
            unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
}

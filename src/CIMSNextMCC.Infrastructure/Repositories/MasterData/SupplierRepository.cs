using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getSupplierList, getSupplierData, findSupplierName and the last-code lookup of
/// SaveApi/SaveSupplierData (parameterized, same projections and order) and its two stored procedures (same names,
/// parameters and types).
/// </summary>
public class SupplierRepository(IDbConnection connection, IUnitOfWork unitOfWork) : ISupplierRepository
{
    public async Task<IReadOnlyList<SupplierMaster>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.Shipper t1 ORDER BY t1.ShipperCode";
        var rows = await connection.QueryAsync<SupplierMaster>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<SupplierMaster?> FindAsync(string shipperCode, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.Shipper t1 WHERE t1.ShipperCode = @ShipperCode";
        var parameters = new DynamicParameters();
        parameters.Add("@ShipperCode", shipperCode, DbType.String, size: 5);
        var rows = await connection.QueryAsync<SupplierMaster>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.FirstOrDefault();
    }

    public async Task<IReadOnlyList<SupplierNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default)
    {
        // Legacy: Left(t1.ShipperName, <name length>) = '<name>'  or  t1.ShipperName = '<name>', order by ShipperName.
        // The length is the .NET string length (as legacy), not LEN() (which ignores trailing spaces).
        const string columns =
            "SELECT t1.ShipperCode, t1.ShipperName, t1.ShipperAddress1, t1.ShipperAddress2, t1.ShipperAddress3, t1.ShipperAddress4 FROM dbo.Shipper t1";
        var sql = startsWith
            ? columns + " WHERE LEFT(t1.ShipperName, @Length) = @Name ORDER BY t1.ShipperName"
            : columns + " WHERE t1.ShipperName = @Name ORDER BY t1.ShipperName";
        var parameters = new DynamicParameters();
        parameters.Add("@Name", name, DbType.String, size: 4000);
        parameters.Add("@Length", name.Length, DbType.Int32);
        var rows = await connection.QueryAsync<SupplierNameHit>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<string?> GetLastCodeAsync(string prefix, CancellationToken cancellationToken = default)
    {
        // Legacy: select top 1 ShipperCode from Shipper where left(ShipperCode,1) = '<first letter of the name>' order by ShipperCode DESC.
        // UPDLOCK + HOLDLOCK keep the range locked until the transaction ends, so a concurrent save of the same letter waits
        // for this one and then reads the new code (the table has no unique key to catch a duplicate).
        const string sql =
            "SELECT TOP 1 ShipperCode FROM dbo.Shipper WITH (UPDLOCK, HOLDLOCK) WHERE LEFT(ShipperCode, 1) = @Prefix ORDER BY ShipperCode DESC";
        var parameters = new DynamicParameters();
        parameters.Add("@Prefix", prefix, DbType.String, size: 1);
        return await connection.QueryFirstOrDefaultAsync<string>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
    }

    public Task AddAsync(SupplierWrite supplier, string createBy, CancellationToken cancellationToken = default) =>
        ExecuteProcedureAsync("dbo.ShipperAdd", Parameters(supplier, "@CreateBy", createBy), cancellationToken);

    public Task UpdateAsync(SupplierWrite supplier, string updateBy, CancellationToken cancellationToken = default) =>
        ExecuteProcedureAsync("dbo.ShipperEdit", Parameters(supplier, "@UpdateBy", updateBy), cancellationToken);

    private static DynamicParameters Parameters(SupplierWrite s, string auditName, string auditUser)
    {
        // CREATE procedure ShipperAdd / ShipperEdit (@ShipperCode nvarchar(5), @ShipperName nvarchar(50), @ShipperAddress1..4 nvarchar(50),
        // @ShipperContact1..3 nvarchar(50), @CreateBy|@UpdateBy nvarchar(5), @ShipperCodeAir nvarchar(5), @ShipperCodeSea nvarchar(5),
        // @ShipperTel nvarchar(50), @ShipperEmail nvarchar(50), @ShipperFax nvarchar(50), @CountryCode nvarchar(10),
        // @LimaSupplierCode nvarchar(10), @REXNo nvarchar(50)). The PwInfo.UserId is longer than the 5 characters the audit
        // column holds; as in legacy, only the first 5 are stored.
        var p = new DynamicParameters();
        p.Add("@ShipperCode", s.ShipperCode, DbType.String, size: 5);
        p.Add("@ShipperName", s.ShipperName, DbType.String, size: 50);
        p.Add("@ShipperAddress1", s.ShipperAddress1, DbType.String, size: 50);
        p.Add("@ShipperAddress2", s.ShipperAddress2, DbType.String, size: 50);
        p.Add("@ShipperAddress3", s.ShipperAddress3, DbType.String, size: 50);
        p.Add("@ShipperAddress4", s.ShipperAddress4, DbType.String, size: 50);
        p.Add("@ShipperContact1", s.ShipperContact1, DbType.String, size: 50);
        p.Add("@ShipperContact2", s.ShipperContact2, DbType.String, size: 50);
        p.Add("@ShipperContact3", s.ShipperContact3, DbType.String, size: 50);
        p.Add(auditName, auditUser, DbType.String, size: 5);
        p.Add("@ShipperCodeAir", s.ShipperCodeAir, DbType.String, size: 5);
        p.Add("@ShipperCodeSea", s.ShipperCodeSea, DbType.String, size: 5);
        p.Add("@ShipperTel", s.ShipperTel, DbType.String, size: 50);
        p.Add("@ShipperEmail", s.ShipperEmail, DbType.String, size: 50);
        p.Add("@ShipperFax", s.ShipperFax, DbType.String, size: 50);
        p.Add("@CountryCode", s.CountryCode, DbType.String, size: 10);
        p.Add("@LimaSupplierCode", s.LimaSupplierCode, DbType.String, size: 10);
        p.Add("@REXNo", s.RexNo, DbType.String, size: 50);
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

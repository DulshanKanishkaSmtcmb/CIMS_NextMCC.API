using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getPortList, getPortData, findPortName (parameterized, same projections and order) and
/// the two stored procedures of SaveApi/SavePortData (same names, parameters and types).
/// </summary>
public class PortRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IPortRepository
{
    public async Task<IReadOnlyList<PortMaster>> GetAllAsync(string? countryCode, CancellationToken cancellationToken = default)
    {
        // Legacy: select t1.* from Ports t1 [Where t1.CountryCode='<country>'] Order By t1.PortCode
        const string sql = "SELECT t1.* FROM dbo.Ports t1 WHERE (@CountryCode IS NULL OR t1.CountryCode = @CountryCode) ORDER BY t1.PortCode";
        var parameters = new DynamicParameters();
        parameters.Add("@CountryCode", countryCode, DbType.String, size: 10);
        var rows = await connection.QueryAsync<PortMaster>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<PortMaster?> FindAsync(string portCode, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.Ports t1 WHERE t1.PortCode = @PortCode";
        var parameters = new DynamicParameters();
        parameters.Add("@PortCode", portCode, DbType.String, size: 10);
        var rows = await connection.QueryAsync<PortMaster>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.FirstOrDefault();
    }

    public async Task<IReadOnlyList<PortNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default)
    {
        // Legacy: Left(t1.PortName, <name length>) = '<name>'  or  t1.PortName = '<name>', order by PortName.
        // The length is the .NET string length (as legacy), not LEN() (which ignores trailing spaces).
        var sql = startsWith
            ? "SELECT t1.PortCode, t1.PortName, t1.CountryCode FROM dbo.Ports t1 WHERE LEFT(t1.PortName, @Length) = @Name ORDER BY t1.PortName"
            : "SELECT t1.PortCode, t1.PortName, t1.CountryCode FROM dbo.Ports t1 WHERE t1.PortName = @Name ORDER BY t1.PortName";
        var parameters = new DynamicParameters();
        parameters.Add("@Name", name, DbType.String, size: 4000);
        parameters.Add("@Length", name.Length, DbType.Int32);
        var rows = await connection.QueryAsync<PortNameHit>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public Task AddAsync(string portCode, string portName, string countryCode, bool isDivertable, string createBy, CancellationToken cancellationToken = default)
    {
        // CREATE Procedure PortsAdd (@PortCode nvarchar(10), @PortName nvarchar(50), @CountryCode nvarchar(10), @IsDivertable bit, @CreateBy nvarchar(10))
        var parameters = new DynamicParameters();
        parameters.Add("@PortCode", portCode, DbType.String, size: 10);
        parameters.Add("@PortName", portName, DbType.String, size: 50);
        parameters.Add("@CountryCode", countryCode, DbType.String, size: 10);
        parameters.Add("@IsDivertable", isDivertable, DbType.Boolean);
        parameters.Add("@CreateBy", createBy, DbType.String, size: 10);
        return ExecuteProcedureAsync("dbo.PortsAdd", parameters, cancellationToken);
    }

    public Task UpdateAsync(string portCode, string portName, string countryCode, bool isDivertable, string updateBy, CancellationToken cancellationToken = default)
    {
        // CREATE Procedure PortsEdit (@PortCode nvarchar(10), @PortName nvarchar(50), @CountryCode nvarchar(10), @IsDivertable bit, @UpdateBy nvarchar(10))
        var parameters = new DynamicParameters();
        parameters.Add("@PortCode", portCode, DbType.String, size: 10);
        parameters.Add("@PortName", portName, DbType.String, size: 50);
        parameters.Add("@CountryCode", countryCode, DbType.String, size: 10);
        parameters.Add("@IsDivertable", isDivertable, DbType.Boolean);
        parameters.Add("@UpdateBy", updateBy, DbType.String, size: 10);
        return ExecuteProcedureAsync("dbo.PortsEdit", parameters, cancellationToken);
    }

    private Task ExecuteProcedureAsync(string procedure, DynamicParameters parameters, CancellationToken cancellationToken) =>
        connection.ExecuteAsync(new CommandDefinition(
            procedure,
            parameters,
            unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
}

using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getCountryList, getCountryData, findCountryName (parameterized, same projections and
/// order) and the two stored procedures of SaveApi/SaveCountryData (same names, parameters and types).
/// </summary>
public class CountryRepository(IDbConnection connection, IUnitOfWork unitOfWork) : ICountryRepository
{
    public async Task<IReadOnlyList<CountryMaster>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.Country t1 ORDER BY t1.CountryCode";
        var rows = await connection.QueryAsync<CountryMaster>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<CountryMaster?> FindAsync(string countryCode, CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.* FROM dbo.Country t1 WHERE t1.CountryCode = @CountryCode";
        var parameters = new DynamicParameters();
        parameters.Add("@CountryCode", countryCode, DbType.String, size: 10);
        var rows = await connection.QueryAsync<CountryMaster>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.FirstOrDefault();
    }

    public async Task<IReadOnlyList<CountryNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default)
    {
        // Legacy: Left(t1.CountryName, <name length>) = '<name>'  or  t1.CountryName = '<name>', order by CountryName.
        // The length is the .NET string length (as legacy), not LEN() (which ignores trailing spaces).
        var sql = startsWith
            ? "SELECT t1.CountryCode, t1.CountryName, t1.CargoMovement FROM dbo.Country t1 WHERE LEFT(t1.CountryName, @Length) = @Name ORDER BY t1.CountryName"
            : "SELECT t1.CountryCode, t1.CountryName, t1.CargoMovement FROM dbo.Country t1 WHERE t1.CountryName = @Name ORDER BY t1.CountryName";
        var parameters = new DynamicParameters();
        parameters.Add("@Name", name, DbType.String, size: 4000);
        parameters.Add("@Length", name.Length, DbType.Int32);
        var rows = await connection.QueryAsync<CountryNameHit>(
            new CommandDefinition(sql, parameters, unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public Task AddAsync(string countryCode, string countryName, string cargoMovement, string enterBy, CancellationToken cancellationToken = default)
    {
        // CREATE PROCEDURE CountryAdd (@CountryCode nvarchar(10), @CountryName nvarchar(50), @CargoMovement nvarchar(10), @EnterBy nvarchar(10))
        var parameters = new DynamicParameters();
        parameters.Add("@CountryCode", countryCode, DbType.String, size: 10);
        parameters.Add("@CountryName", countryName, DbType.String, size: 50);
        parameters.Add("@CargoMovement", cargoMovement, DbType.String, size: 10);
        parameters.Add("@EnterBy", enterBy, DbType.String, size: 10);
        return ExecuteProcedureAsync("dbo.CountryAdd", parameters, cancellationToken);
    }

    public Task UpdateAsync(string countryCode, string countryName, string cargoMovement, string updateBy, CancellationToken cancellationToken = default)
    {
        // CREATE PROCEDURE CountryEdit (@CountryCode nvarchar(10), @CountryName nvarchar(50), @CargoMovement nvarchar(10), @UpdateBy nvarchar(10))
        var parameters = new DynamicParameters();
        parameters.Add("@CountryCode", countryCode, DbType.String, size: 10);
        parameters.Add("@CountryName", countryName, DbType.String, size: 50);
        parameters.Add("@CargoMovement", cargoMovement, DbType.String, size: 10);
        parameters.Add("@UpdateBy", updateBy, DbType.String, size: 10);
        return ExecuteProcedureAsync("dbo.CountryEdit", parameters, cancellationToken);
    }

    private Task ExecuteProcedureAsync(string procedure, DynamicParameters parameters, CancellationToken cancellationToken) =>
        connection.ExecuteAsync(new CommandDefinition(
            procedure,
            parameters,
            unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
}

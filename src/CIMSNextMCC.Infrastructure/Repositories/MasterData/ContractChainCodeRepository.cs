using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports the SQL of legacy DataApi/getChainCategoryData and getProductCategoryData (same projections, no ORDER BY) and the
/// stored procedure of SaveApi/SaveContractsChainCodes (same name, parameters and types).
/// </summary>
public class ContractChainCodeRepository(IDbConnection connection, IUnitOfWork unitOfWork) : IContractChainCodeRepository
{
    public async Task<IReadOnlyList<ContractChainCode>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        // Legacy: select t1.* from ContractsChainCodes t1
        const string sql = "SELECT t1.* FROM dbo.ContractsChainCodes t1";
        var rows = await connection.QueryAsync<ContractChainCode>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<IReadOnlyList<ChainRange>> GetRangesAsync(CancellationToken cancellationToken = default)
    {
        // Legacy: select t1.* from ContractsChainCodesCategory t1
        const string sql = "SELECT t1.* FROM dbo.ContractsChainCodesCategory t1";
        var rows = await connection.QueryAsync<ChainRange>(
            new CommandDefinition(sql, transaction: unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public Task AddAsync(string chainCode, string chainName, string tpPartnerName, string range, string rangeBoxEan, CancellationToken cancellationToken = default)
    {
        // CREATE PROCEDURE InsertContractsChainCodes (@ChainCode CHAR(1), @ChainName VARCHAR(50), @TPPartnerName VARCHAR(20),
        //   @Range VARCHAR(20), @RangeBoxEAN VARCHAR(10))
        var parameters = new DynamicParameters();
        parameters.Add("@ChainCode", chainCode, DbType.AnsiStringFixedLength, size: 1);
        parameters.Add("@ChainName", chainName, DbType.AnsiString, size: 50);
        parameters.Add("@TPPartnerName", tpPartnerName, DbType.AnsiString, size: 20);
        parameters.Add("@Range", range, DbType.AnsiString, size: 20);
        parameters.Add("@RangeBoxEAN", rangeBoxEan, DbType.AnsiString, size: 10);
        return connection.ExecuteAsync(new CommandDefinition(
            "dbo.InsertContractsChainCodes",
            parameters,
            unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
    }
}

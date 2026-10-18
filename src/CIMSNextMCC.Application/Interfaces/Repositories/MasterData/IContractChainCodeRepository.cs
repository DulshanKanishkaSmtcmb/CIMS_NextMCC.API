using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the Product Category page (legacy File/ProductCategory): the chain codes in dbo.ContractsChainCodes.
/// The write calls the same stored procedure with the same parameters as legacy SaveApi/SaveContractsChainCodes and runs
/// in the request's unit-of-work transaction.
/// </summary>
public interface IContractChainCodeRepository
{
    /// <summary>dbo.ContractsChainCodes, no ORDER BY, exactly like legacy DataApi/getChainCategoryData.</summary>
    Task<IReadOnlyList<ContractChainCode>> GetAllAsync(CancellationToken cancellationToken = default);

    /// <summary>dbo.ContractsChainCodesCategory in table order (legacy DataApi/getProductCategoryData).</summary>
    Task<IReadOnlyList<ChainRange>> GetRangesAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// SP InsertContractsChainCodes @ChainCode char(1), @ChainName varchar(50), @TPPartnerName varchar(20),
    /// @Range varchar(20), @RangeBoxEAN varchar(10).
    /// </summary>
    Task AddAsync(string chainCode, string chainName, string tpPartnerName, string range, string rangeBoxEan, CancellationToken cancellationToken = default);
}

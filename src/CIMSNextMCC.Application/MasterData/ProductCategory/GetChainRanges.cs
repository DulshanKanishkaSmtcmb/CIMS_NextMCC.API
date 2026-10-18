using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

namespace CIMSNextMCC.Application.MasterData.ProductCategory;

public sealed record GetChainRangesQuery;

/// <summary>
/// Replaces legacy DataApi/getProductCategoryData (<c>select t1.* from ContractsChainCodesCategory t1</c>, no order): the
/// choices of the Range select. The page selects the first one on load.
/// </summary>
public sealed class GetChainRangesHandler(IContractChainCodeRepository repository)
{
    public async Task<Result<IReadOnlyList<ChainRangeDto>>> HandleAsync(GetChainRangesQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        var rows = await repository.GetRangesAsync(cancellationToken);
        IReadOnlyList<ChainRangeDto> dtos = rows.Select(r => new ChainRangeDto(r.Category)).ToList();
        return Result<IReadOnlyList<ChainRangeDto>>.Success(dtos);
    }
}

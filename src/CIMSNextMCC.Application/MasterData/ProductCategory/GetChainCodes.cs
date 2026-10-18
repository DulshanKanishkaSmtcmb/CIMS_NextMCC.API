using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

namespace CIMSNextMCC.Application.MasterData.ProductCategory;

public sealed record GetChainCodesQuery;

/// <summary>
/// Replaces legacy DataApi/getChainCategoryData (<c>select t1.* from ContractsChainCodes t1</c>, no ORDER BY): the grid
/// under the Product Category form. The rows come in the table's own order, as before.
/// </summary>
public sealed class GetChainCodesHandler(IContractChainCodeRepository repository)
{
    public async Task<Result<IReadOnlyList<ChainCodeDto>>> HandleAsync(GetChainCodesQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        var rows = await repository.GetAllAsync(cancellationToken);
        IReadOnlyList<ChainCodeDto> dtos = rows
            .Select(r => new ChainCodeDto(r.ChainCode, r.ChainName, r.TpPartnerName, r.Range, r.RangeBoxEan))
            .ToList();
        return Result<IReadOnlyList<ChainCodeDto>>.Success(dtos);
    }
}

using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

namespace CIMSNextMCC.Application.MasterData.PMMaster;

public sealed record GetPmCategoriesQuery;

/// <summary>
/// Replaces legacy DataApi/getPmCategoryData (<c>select t1.* from PMCategories t1</c>, no order): the choices of the PM
/// Category select. The page selects the first one on load.
/// </summary>
public sealed class GetPmCategoriesHandler(IPackingMaterialRepository repository)
{
    public async Task<Result<IReadOnlyList<PmCategoryDto>>> HandleAsync(GetPmCategoriesQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        var rows = await repository.GetCategoriesAsync(cancellationToken);
        IReadOnlyList<PmCategoryDto> dtos = rows.Select(r => new PmCategoryDto(r.PmCategory)).ToList();
        return Result<IReadOnlyList<PmCategoryDto>>.Success(dtos);
    }
}

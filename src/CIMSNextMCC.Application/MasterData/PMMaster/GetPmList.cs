using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.MasterData.PMMaster;

public sealed record GetPmListQuery;

/// <summary>
/// Replaces legacy DataApi/getPMList (<c>select t1.* from PMMaster t1 Order By t1.PMCode</c>), used by the "Packing
/// Material Master Listing" dialog. The legacy action also takes <c>strCode</c> (the code typed in the page) and
/// ignores it; so does this.
/// </summary>
public sealed class GetPmListHandler(IPackingMaterialRepository repository)
{
    public async Task<Result<IReadOnlyList<PmMasterDto>>> HandleAsync(GetPmListQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        var rows = await repository.GetAllAsync(cancellationToken);
        IReadOnlyList<PmMasterDto> dtos = rows.Select(PmMasterMapping.ToDto).ToList();
        return Result<IReadOnlyList<PmMasterDto>>.Success(dtos);
    }
}

internal static class PmMasterMapping
{
    public static PmMasterDto ToDto(PackingMaterial p) =>
        new(p.PmCode, p.PmDescription, p.PmCategory, p.PmIssueType, p.QtyInHand, p.QtyReOrderLevel, p.PmWgt, p.PmCbm,
            p.GetJokerCount, p.GetPartCount, p.GetCtnCount, p.StockCbm, p.IsActive);
}

using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.MasterData.DC;

public sealed record GetDcListQuery;

/// <summary>
/// Replaces legacy DataApi/getDCList (<c>select t1.* from DestWarehouse order by WhDes</c>) for the DC page's "DC Listing"
/// dialog. The WhDes filter the legacy action parses is never applied, so none is taken. (The Confirm Arrivals page keeps
/// its own slim lookup, <c>GET api/v1/arrivals/confirm/dcs</c>.)
/// </summary>
public sealed class GetDcListHandler(IDcRepository repository)
{
    public async Task<Result<IReadOnlyList<DcDto>>> HandleAsync(GetDcListQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var rows = await repository.GetAllAsync(cancellationToken);
        IReadOnlyList<DcDto> dtos = rows.Select(DcMapping.ToDto).ToList();
        return Result<IReadOnlyList<DcDto>>.Success(dtos);
    }
}

internal static class DcMapping
{
    public static DcDto ToDto(DcMaster d) =>
        new(
            d.WhCode, d.WhDes, d.WhDesMain, d.CountryCode, d.LoadingOrder, d.OuterLabel, d.EanLabelScan, d.ReworkApply,
            d.RfidPriceTag, d.RfidPriceTagValidate, d.RemoveOriginalTag, d.JokerTagsForSets, d.CareWarningLabel,
            d.PreValidationRun, d.EanLabelOuterBox, d.EanDesCol, d.PackAdditionalBox, d.BoxPmCode, d.HangerUse,
            d.EanLabelPiece, d.PostValidation, d.StockUpdate, d.AuthorizedToPoPlan, d.ItemOptionFixedLength,
            d.ItemOptionManual, d.PriceSymble, d.PrintPriceTag, d.BoxPackSeperate, d.StorePick, d.IsRfidOrder,
            d.BrandText, d.BarcodeType, d.ProductCategory, d.VasCheck, d.EnaVerification, d.EanLblType, d.Address,
            d.LpnLblType);
}

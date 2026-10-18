using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.MasterData.Supplier;

public sealed record GetSupplierListQuery;

/// <summary>
/// Replaces legacy DataApi/getSupplierList (<c>select t1.* from Shipper order by ShipperCode</c>), used by the "Supplier
/// Listing" dialog. The legacy <c>strRtnPara</c> (which form fields the chosen row fills) is a page detail and is not taken.
/// </summary>
public sealed class GetSupplierListHandler(ISupplierRepository repository)
{
    public async Task<Result<IReadOnlyList<SupplierDto>>> HandleAsync(
        GetSupplierListQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var rows = await repository.GetAllAsync(cancellationToken);
        IReadOnlyList<SupplierDto> dtos = rows.Select(SupplierMapping.ToDto).ToList();
        return Result<IReadOnlyList<SupplierDto>>.Success(dtos);
    }
}

internal static class SupplierMapping
{
    public static SupplierDto ToDto(SupplierMaster s) =>
        new(
            s.ShipperCode,
            s.ShipperName,
            s.ShipperAddress1,
            s.ShipperAddress2,
            s.ShipperAddress3,
            s.ShipperAddress4,
            s.ShipperContact1,
            s.ShipperContact2,
            s.ShipperContact3,
            s.DateCreate,
            s.CreateBy,
            s.DateUpdate,
            s.UpdateBy,
            s.ShipperCodeAir,
            s.ShipperCodeSea,
            s.ShipperTel,
            s.ShipperEmail,
            s.ShipperFax,
            s.CountryCode,
            s.LimaSupplierCode,
            s.RexNo);
}

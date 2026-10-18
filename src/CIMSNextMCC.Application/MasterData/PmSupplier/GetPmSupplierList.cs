using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.MasterData.PmSupplier;

public sealed record GetPmSupplierListQuery;

/// <summary>
/// Replaces legacy DataApi/getPMSupplierList (<c>select t1.* from PMSupplier order by PMSupplierCode</c>), used by the
/// "Supplier Listing" dialog of the PM Supplier page. The legacy strRtnPara (which form fields the chosen row fills) is not taken.
/// </summary>
public sealed class GetPmSupplierListHandler(IPmSupplierRepository repository)
{
    public async Task<Result<IReadOnlyList<PmSupplierDto>>> HandleAsync(
        GetPmSupplierListQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var rows = await repository.GetAllAsync(cancellationToken);
        IReadOnlyList<PmSupplierDto> dtos = rows.Select(PmSupplierMapping.ToDto).ToList();
        return Result<IReadOnlyList<PmSupplierDto>>.Success(dtos);
    }
}

internal static class PmSupplierMapping
{
    public static PmSupplierDto ToDto(PmSupplierMaster s) =>
        new(
            s.PmSupplierCode,
            s.PmSupplierName,
            s.PmSupplierAddress1,
            s.PmSupplierAddress2,
            s.PmSupplierAddress3,
            s.PmSupplierAddress4,
            s.PmSupplierContact1,
            s.PmSupplierContact2,
            s.PmSupplierContact3,
            s.PmSupplierTel,
            s.PmSupplierEmail,
            s.PmSupplierFax,
            s.CountryCode);
}

using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.Arrivals;
using CIMSNextMCC.Domain.Entities.Arrivals;
using FluentValidation;

namespace CIMSNextMCC.Application.Arrivals.ConfirmArrival;

/// <summary>
/// Filter of the pending list, as on the legacy page:
/// <list type="bullet">
/// <item><see cref="CargoFrom"/>: the Shipment select ("Local" or "Import"); null or empty = no filter.</item>
/// <item><see cref="Dc"/>: DestWarehouse.WhDes; null or "All" = no filter.</item>
/// <item><see cref="Country"/>: Country.CountryCode; null or "All" = no filter.</item>
/// </list>
/// Any other value, including an empty DC or country, is an exact match, as in the legacy SQL.
/// </summary>
public sealed record GetPendingArrivalsQuery(string? CargoFrom, string? Dc, string? Country);

/// <summary>Lengths of the CargoReceived columns the filter compares with (CargoFrom 10, Warehouse 50, Country 20).</summary>
public sealed class GetPendingArrivalsValidator : AbstractValidator<GetPendingArrivalsQuery>
{
    public GetPendingArrivalsValidator()
    {
        RuleFor(q => q.CargoFrom).MaximumLength(10);
        RuleFor(q => q.Dc).MaximumLength(50);
        RuleFor(q => q.Country).MaximumLength(20);
    }
}

/// <summary>
/// Replaces legacy DataApi/getPendingPO4ConfirmArrival. Same filter (ConfirmArriveStatus = '' and IntakeStatus = '',
/// plus DC / Country / CargoFrom) and the same three result sets, parameterized instead of concatenated.
/// The legacy strMode, strArrivalDate and uid inputs were never used and are not taken.
/// </summary>
public sealed class GetPendingArrivalsHandler(
    IConfirmArrivalRepository repository,
    IValidator<GetPendingArrivalsQuery> validator)
{
    public const string AllValue = "All";

    public async Task<Result<PendingArrivalsDto>> HandleAsync(
        GetPendingArrivalsQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var filter = new PendingArrivalFilter(
            CargoFrom: string.IsNullOrEmpty(query.CargoFrom) ? null : query.CargoFrom,
            Warehouse: query.Dc is null || query.Dc == AllValue ? null : query.Dc,
            Country: query.Country is null || query.Country == AllValue ? null : query.Country);

        var set = await repository.GetPendingAsync(filter, cancellationToken);

        var dto = new PendingArrivalsDto(
            set.Contracts.Select(c => new PendingContractDto(
                c.RcvNo, c.ArrivalDate, c.ContractNo, c.ItemNo, c.ShipperCode, c.ShipperName, c.CargoType, c.Warehouse,
                c.Ctns, c.Pcs, c.GrossWgt, c.Cbm, c.InboundVesselOrderNo, c.InboundBookingDate, c.ConfirmArriveStatus,
                c.InboundEtd, c.InboundContainerOrderNo, c.Country)).ToList(),
            set.Suppliers.Select(s => new PendingSupplierDto(s.ShipperCode, s.ShipperName)).ToList(),
            set.Containers.Select(k => new PendingContainerDto(
                k.InboundEtd, k.InboundVesselOrderNo, k.InboundContainerOrderNo, k.VesselName, k.LoadReference,
                k.ContainerNo, k.ContainerType)).ToList());

        return Result<PendingArrivalsDto>.Success(dto);
    }
}

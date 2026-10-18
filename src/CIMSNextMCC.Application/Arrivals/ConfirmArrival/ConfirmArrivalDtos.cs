namespace CIMSNextMCC.Application.Arrivals.ConfirmArrival;

/// <summary>A DC for the DC select (legacy getDCList dtMain, column WhDes).</summary>
public sealed record ArrivalDcDto(string WhDes);

/// <summary>A country for the Country select and the read-only name box (legacy getCountryList dtMain).</summary>
public sealed record ArrivalCountryDto(string CountryCode, string CountryName);

/// <summary>Result of GET api/v1/arrivals/confirm/pending: the legacy dtMain, dtDtl1 and dtDtl2 tables, typed.</summary>
public sealed record PendingArrivalsDto(
    IReadOnlyList<PendingContractDto> Contracts,
    IReadOnlyList<PendingSupplierDto> Suppliers,
    IReadOnlyList<PendingContainerDto> Containers);

/// <summary>
/// One contract (dbo.CargoReceived row) pending arrival confirmation. Dates are ISO local date-times (no offset),
/// numbers are numbers. <see cref="Country"/> is new: the legacy query did not select it, so the legacy grid's
/// Country column was always blank (docs/13 section 1.8 Q1).
/// </summary>
public sealed record PendingContractDto(
    string RcvNo,
    DateTime? ArrivalDate,
    string ContractNo,
    string ItemNo,
    string ShipperCode,
    string? ShipperName,
    string CargoType,
    string Warehouse,
    decimal Ctns,
    decimal Pcs,
    decimal GrossWgt,
    decimal Cbm,
    decimal InboundVesselOrderNo,
    DateTime? InboundBookingDate,
    string ConfirmArriveStatus,
    DateTime? InboundEtd,
    decimal InboundContainerOrderNo,
    string Country);

/// <summary>A supplier with pending arrivals that are not on an import container.</summary>
public sealed record PendingSupplierDto(string ShipperCode, string? ShipperName);

/// <summary>An import vessel/container key with pending arrivals, with the editable container fields.</summary>
public sealed record PendingContainerDto(
    DateTime? InboundEtd,
    decimal InboundVesselOrderNo,
    decimal InboundContainerOrderNo,
    string VesselName,
    string LoadReference,
    string ContainerNo,
    string ContainerType);

/// <summary>Result of POST api/v1/arrivals/confirm.</summary>
public sealed record ConfirmArrivalResultDto(
    int ContractsConfirmed,
    bool ImportVesselUpdated,
    bool ImportContainerUpdated,
    string Message);

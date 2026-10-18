namespace CIMSNextMCC.Application.MasterData.RateCard;

/// <summary>A row of "Rate Structure - Export Clearance Charges" (legacy getRateInformation4Add dtMain): one per container type.</summary>
public sealed record ClearanceRateDto(string CntrType, decimal RateInUsd);

/// <summary>A row of "Rate Structure - Export Freight Charges" (legacy dtDtl1): one per port and container type.</summary>
public sealed record FreightRateDto(string PortCode, string PortName, string CntrType, decimal RateInUsd);

/// <summary>A row of "Rate Structure - CFS Charges" (legacy dtDtl2): a dbo.RateCFSExport row plus the material's description.</summary>
public sealed record CfsRateDto(
    string ChgCode,
    string ChgDescription,
    string UnitType,
    decimal Range1,
    decimal Range2,
    string? UnitCalType,
    decimal RateInUsd,
    bool IsActive,
    string FileCaption,
    string MaterialCode,
    decimal RateInUsdCost,
    string RateUpdateBy,
    DateTime? RateUpdateDate,
    string PmDescription);

/// <summary>The three tables of the Rate Card page.</summary>
public sealed record RateCardDto(
    IReadOnlyList<ClearanceRateDto> Clearance,
    IReadOnlyList<FreightRateDto> Freight,
    IReadOnlyList<CfsRateDto> Cfs);

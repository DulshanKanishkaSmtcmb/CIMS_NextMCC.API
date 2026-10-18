using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

namespace CIMSNextMCC.Application.MasterData.RateCard;

public sealed record GetRateCardQuery;

/// <summary>
/// Replaces legacy DataApi/getRateInformation4Add, the only call of the Rate Card page. The legacy action parses
/// <c>strDataArr=[{"strOption":"Add","uid":…}]</c> and uses neither value, so none is taken. It builds the clearance and
/// freight tables as a cross product: one row per container type (clearance) or per port and container type (freight),
/// carrying the stored rate or 0 when the rate table has none (the first match, case-insensitive like DataTable.Select);
/// the CFS table is the rate table itself.
/// </summary>
public sealed class GetRateCardHandler(IRateCardRepository repository)
{
    public async Task<Result<RateCardDto>> HandleAsync(GetRateCardQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var containerTypes = await repository.GetContainerTypesAsync(cancellationToken);
        var ports = await repository.GetPortsAsync(cancellationToken);
        var clearance = await repository.GetClearanceRatesAsync(cancellationToken);
        var freight = await repository.GetFreightRatesAsync(cancellationToken);
        var cfs = await repository.GetCfsRatesAsync(cancellationToken);

        IReadOnlyList<ClearanceRateDto> clearanceRows = containerTypes
            .Select(type => new ClearanceRateDto(
                type,
                clearance.FirstOrDefault(r => Same(r.CntrType, type))?.RateInUsd ?? 0m))
            .ToList();

        var freightRows = new List<FreightRateDto>(ports.Count * containerTypes.Count);
        foreach (var port in ports)
        {
            foreach (var type in containerTypes)
            {
                var rate = freight.FirstOrDefault(r => Same(r.PortCode, port.PortCode) && Same(r.CntrType, type))?.RateInUsd ?? 0m;
                freightRows.Add(new FreightRateDto(port.PortCode, port.PortName, type, rate));
            }
        }

        IReadOnlyList<CfsRateDto> cfsRows = cfs
            .Select(r => new CfsRateDto(
                r.ChgCode, r.ChgDescription, r.UnitType, r.Range1, r.Range2, r.UnitCalType, r.RateInUsd, r.IsActive,
                r.FileCaption, r.MaterialCode, r.RateInUsdCost, r.RateUpdateBy, r.RateUpdateDate, r.PmDescription))
            .ToList();

        return Result<RateCardDto>.Success(new RateCardDto(clearanceRows, freightRows, cfsRows));
    }

    // DataTable.Select("CntrType='x'") compares case-insensitively and ignores trailing blanks.
    private static bool Same(string a, string b) =>
        string.Equals(a.TrimEnd(), b.TrimEnd(), StringComparison.OrdinalIgnoreCase);
}

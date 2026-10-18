using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

namespace CIMSNextMCC.Application.MasterData.PalletRack;

/// <param name="RackNo">The rack to read.</param>
/// <param name="IncludePositions">Also read the rack's pallet positions (legacy: <c>strOption</c> not empty, the page always sends "All").</param>
public sealed record GetPalletRackDataQuery(string RackNo, bool IncludePositions);

/// <summary>
/// Replaces legacy DataApi/getPalletRacksData: the rack row and, when asked, the rows of dbo.PalletRacksUtilization of that
/// rack. Like legacy an unknown rack is not an error: the rack comes back null (the positions are still those stored under
/// that number, normally none). The page uses it to load a layout (Delete / View) and to check whether the rack exists.
/// </summary>
public sealed class GetPalletRackDataHandler(IPalletRackRepository repository)
{
    public async Task<Result<PalletRackDataDto>> HandleAsync(GetPalletRackDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var rack = await repository.FindAsync(query.RackNo, cancellationToken);
        var positions = query.IncludePositions ? await repository.GetPositionsAsync(query.RackNo, cancellationToken) : [];

        return Result<PalletRackDataDto>.Success(new PalletRackDataDto(
            rack is null ? null : new PalletRackDto(rack.RackNo, rack.NofRows, rack.NofLayers, rack.NofPositions),
            positions.Select(p => new PalletPositionDto(p.RackNo, p.PositionNo, p.GrnNo, p.PalletNo)).ToList()));
    }
}

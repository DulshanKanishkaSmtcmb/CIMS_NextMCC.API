namespace CIMSNextMCC.Application.MasterData.PalletRack;

/// <summary>A dbo.PalletRacks row (legacy getPalletRacksList / getPalletRacksData dtMain).</summary>
public sealed record PalletRackDto(string RackNo, decimal NofRows, decimal NofLayers, decimal NofPositions);

/// <summary>A dbo.PalletRacksUtilization row (legacy getPalletRacksData dtDtl1): a pallet position and what it holds.</summary>
public sealed record PalletPositionDto(string RackNo, string PositionNo, string GrnNo, string PalletNo);

/// <summary>
/// The answer of legacy getPalletRacksData: the rack and its positions. <paramref name="Rack"/> is null when no such rack
/// exists (legacy: an empty dtMain); <paramref name="Positions"/> is empty when they were not asked for.
/// </summary>
public sealed record PalletRackDataDto(PalletRackDto? Rack, IReadOnlyList<PalletPositionDto> Positions);

/// <summary>
/// Body of POST api/v1/master-data/pallet-racks (legacy SaveCargoPalletBuild: <c>strDataArr</c> + <c>strDataArrPallet</c>):
/// the rack and the positions that are in use (the ones the page has not disabled).
/// </summary>
public sealed record CreatePalletRackRequest(string RackNo, decimal NofRows, decimal NofLayers, decimal NofPositions, IReadOnlyList<string> Positions);

/// <summary>Result of a save (legacy SaveResult: msg; the legacy action returned no DocNo).</summary>
public sealed record CreatePalletRackResultDto(string RackNo, int Positions, string Message);

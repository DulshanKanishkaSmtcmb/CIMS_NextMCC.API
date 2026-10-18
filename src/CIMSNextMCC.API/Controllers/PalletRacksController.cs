using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.MasterData.PalletRack;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Pallet racks and their pallet positions. Replaces both legacy pages File/PalletRackBuild and Data/PalletRackBuildArr
/// ("Pallets Rack Build", CloudMenu 100.14 for the second) and their calls to DataApi/getPalletRacksList,
/// getPalletRacksData and SaveApi/SaveCargoPalletBuild. The two legacy pages call the same actions, so they share this
/// controller. Write-up: legacy repo docs/18-wave1-masterdata-d.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/pallet-racks")]
[RequireMenu(PalletRackMenu.Key)]
[Produces("application/json")]
public class PalletRacksController(
    GetPalletRackListHandler getList,
    GetPalletRackDataHandler getData,
    CreatePalletRackHandler create) : BaseController
{
    /// <summary>Every rack, ordered by rack number (legacy DataApi/getPalletRacksList). Feeds the "Pallets Area Listing" dialog.</summary>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<PalletRackDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetList(CancellationToken cancellationToken) =>
        ToActionResult(await getList.HandleAsync(new GetPalletRackListQuery(), cancellationToken));

    /// <summary>
    /// One rack and, unless <c>positions=false</c>, its pallet positions (legacy DataApi/getPalletRacksData). An unknown rack
    /// answers 200 with a null <c>rack</c> (legacy returned empty tables).
    /// </summary>
    /// <param name="rackNo">Rack number.</param>
    /// <param name="positions">Include the rack's positions. Default true.</param>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet("{rackNo}")]
    [ProducesResponseType<PalletRackDataDto>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetByRackNo(string rackNo, [FromQuery] bool positions = true, CancellationToken cancellationToken = default) =>
        ToActionResult(await getData.HandleAsync(new GetPalletRackDataQuery(rackNo, positions), cancellationToken));

    /// <summary>
    /// Adds a rack with its positions in one transaction (legacy SaveApi/SaveCargoPalletBuild: SP PalletRacksAdd, then SP
    /// PalletRacksUtilizationAdd per position). 409 when the rack already exists.
    /// </summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<CreatePalletRackResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] CreatePalletRackRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await create.HandleAsync(
            new CreatePalletRackCommand(request.RackNo, request.NofRows, request.NofLayers, request.NofPositions, request.Positions ?? []),
            cancellationToken));
}

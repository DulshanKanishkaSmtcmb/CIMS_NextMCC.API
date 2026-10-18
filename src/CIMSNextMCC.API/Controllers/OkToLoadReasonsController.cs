using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.MasterData.OkToLoadReason;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Ok to Ship / Hold reasons per DC. Replaces the legacy page File/OkToLoadReason ("Shipments Ok To Load / Hold Reasons",
/// CloudMenu 200.25.02) and its calls to DataApi/getOkToLoadResonListUpdate and SaveApi/SaveOkToShipReason (the DC select
/// uses api/v1/master-data/dcs). Write-up: legacy repo docs/18-wave1-masterdata-d.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/ok-to-load-reasons")]
[RequireMenu(OkToLoadReasonMenu.Key)]
[Produces("application/json")]
public class OkToLoadReasonsController(
    GetOkToLoadReasonsHandler getReasons,
    ReplaceOkToLoadReasonsHandler replace) : BaseController
{
    /// <summary>
    /// The reasons of a DC in their saved order (legacy DataApi/getOkToLoadResonListUpdate). Without <c>dc</c> the reasons
    /// of every DC are returned. With <c>checkAllocation</c> the reasons contracts already carry are marked
    /// (<c>isAllocated</c>) and may not be removed.
    /// </summary>
    /// <param name="dc">DC name (DestWarehouse.WhDes).</param>
    /// <param name="checkAllocation">Mark the reasons already allocated to contracts of the DC.</param>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<OkToLoadReasonDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> GetList([FromQuery] string? dc, [FromQuery] bool checkAllocation, CancellationToken cancellationToken) =>
        ToActionResult(await getReasons.HandleAsync(new GetOkToLoadReasonsQuery(dc, checkAllocation), cancellationToken));

    /// <summary>
    /// Replaces the reasons of the DC named in the body with the list sent (legacy SaveApi/SaveOkToShipReason: delete the
    /// DC's rows, then SP OkToLoadReasonAdd per line). 404 when the DC does not exist; 409 when a reason contracts already
    /// carry is left out.
    /// </summary>
    [HttpPut]
    [Consumes("application/json")]
    [ProducesResponseType<ReplaceOkToLoadReasonsResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Replace([FromBody] ReplaceOkToLoadReasonsRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await replace.HandleAsync(new ReplaceOkToLoadReasonsCommand(request.Dc, request.Reasons ?? []), cancellationToken));
}

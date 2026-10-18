using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Arrivals.ConfirmArrival;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Inbound arrivals. "confirm/*" replaces the legacy page Data/ConfirmArrival ("Contract - Confirm Arrivals", CloudMenu
/// 200.05.04) and its calls to DataApi/getDCList, DataApi/getCountryList, DataApi/getPendingPO4ConfirmArrival and
/// SaveApi/SaveContractConfirmArrival. Write-up: legacy repo docs/13-pilot-confirm-arrivals.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/arrivals")]
[RequireMenu(ConfirmArrivalMenu.Key)]
[Produces("application/json")]
public class ArrivalsController(
    GetConfirmArrivalDcsHandler getDcs,
    GetConfirmArrivalCountriesHandler getCountries,
    GetPendingArrivalsHandler getPending,
    ConfirmArrivalHandler confirm) : BaseController
{
    /// <summary>DCs for the DC select, ordered by name (legacy DataApi/getDCList). The page puts "All" first.</summary>
    [HttpGet("confirm/dcs")]
    [ProducesResponseType<IReadOnlyList<ArrivalDcDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetDcs(CancellationToken cancellationToken) =>
        ToActionResult(await getDcs.HandleAsync(new GetConfirmArrivalDcsQuery(), cancellationToken));

    /// <summary>Countries for the Country select, ordered by code (legacy DataApi/getCountryList). The page puts "All" first.</summary>
    [HttpGet("confirm/countries")]
    [ProducesResponseType<IReadOnlyList<ArrivalCountryDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetCountries(CancellationToken cancellationToken) =>
        ToActionResult(await getCountries.HandleAsync(new GetConfirmArrivalCountriesQuery(), cancellationToken));

    /// <summary>
    /// Contracts pending arrival confirmation, with the supplier and container lists used to pick them
    /// (legacy DataApi/getPendingPO4ConfirmArrival).
    /// </summary>
    /// <param name="cargoFrom">Shipment: "Local" or "Import". Omit or empty for no filter.</param>
    /// <param name="dc">DC (DestWarehouse.WhDes). Omit or "All" for no filter.</param>
    /// <param name="country">Country code. Omit or "All" for no filter.</param>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet("confirm/pending")]
    [ProducesResponseType<PendingArrivalsDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> GetPending(
        [FromQuery] string? cargoFrom,
        [FromQuery] string? dc,
        [FromQuery] string? country,
        CancellationToken cancellationToken) =>
        ToActionResult(await getPending.HandleAsync(new GetPendingArrivalsQuery(cargoFrom, dc, country), cancellationToken));

    /// <summary>
    /// Confirms the arrival of the selected contracts and, for the first ticked import container, saves its vessel name,
    /// container no/type and load reference (legacy SaveApi/SaveContractConfirmArrival). One transaction: all or nothing.
    /// </summary>
    [HttpPost("confirm")]
    [Consumes("application/json")]
    [ProducesResponseType<ConfirmArrivalResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> Confirm([FromBody] ConfirmArrivalCommand command, CancellationToken cancellationToken) =>
        ToActionResult(await confirm.HandleAsync(command, cancellationToken));
}

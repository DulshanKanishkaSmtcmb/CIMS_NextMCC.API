using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.Ports;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Ports master data. Replaces the legacy page File/Ports ("Ports Master Details", CloudMenu 100.06) and its calls to
/// DataApi/getPortList, getPortData, findPortName and SaveApi/SavePortData (its Country Code field also uses
/// api/v1/master-data/countries). Write-up: legacy repo docs/15-wave1-masterdata-a.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/ports")]
[RequireMenu(PortsMenu.Key)]
[Produces("application/json")]
public class PortsController(
    GetPortListHandler getList,
    GetPortDataHandler getData,
    FindPortNameHandler findName,
    SavePortDataHandler save) : BaseController
{
    /// <summary>Every port with every column, ordered by code (legacy DataApi/getPortList). Feeds the "Ports Listing" dialog.</summary>
    /// <param name="countryCode">Only the ports of this country. Omit or empty for all.</param>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<PortDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> GetList([FromQuery] string? countryCode, CancellationToken cancellationToken) =>
        ToActionResult(await getList.HandleAsync(new GetPortListQuery(countryCode), cancellationToken));

    /// <summary>
    /// Ports whose name starts with (or equals) the typed text, ordered by name (legacy DataApi/findPortName, the
    /// "Pre-Entered Ports Listing" box).
    /// </summary>
    /// <param name="name">The text typed in Port Name.</param>
    /// <param name="startsWith">True (default): names that start with the text. False: names equal to it.</param>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet("search")]
    [ProducesResponseType<IReadOnlyList<PortNameHitDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Search([FromQuery] string name, [FromQuery] bool startsWith = true, CancellationToken cancellationToken = default) =>
        ToActionResult(await findName.HandleAsync(new FindPortNameQuery(name ?? string.Empty, startsWith), cancellationToken));

    /// <summary>One port by code (legacy DataApi/getPortData). 404 when the code does not exist.</summary>
    [HttpGet("{portCode}")]
    [ProducesResponseType<PortDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetByCode(string portCode, CancellationToken cancellationToken) =>
        ToActionResult(await getData.HandleAsync(new GetPortDataQuery(portCode), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>Adds a port (legacy SaveApi/SavePortData with Option "New", SP PortsAdd). 409 when the code exists.</summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<SavePortResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] CreatePortRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(
            new SavePortDataCommand(SaveMode.New, request.PortCode, request.PortName, request.CountryCode, request.IsDivertable),
            cancellationToken));

    /// <summary>Changes a port (legacy SaveApi/SavePortData with Option "Change", SP PortsEdit). 404 when the code does not exist.</summary>
    [HttpPut("{portCode}")]
    [Consumes("application/json")]
    [ProducesResponseType<SavePortResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(string portCode, [FromBody] UpdatePortRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(
            new SavePortDataCommand(SaveMode.Change, portCode, request.PortName, request.CountryCode, request.IsDivertable),
            cancellationToken));
}

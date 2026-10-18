using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.DC;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// DC (destination warehouse) master data. Replaces the legacy page File/DC ("DC Master Details", CloudMenu 100.08) and its
/// calls to DataApi/getDCList, getDCData and SaveApi/SaveDCData (its Country Code field also uses
/// api/v1/master-data/countries). Write-up: legacy repo docs/15-wave1-masterdata-a.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/dcs")]
[RequireMenu(DcMenu.Key)]
[Produces("application/json")]
public class DcsController(
    GetDcListHandler getList,
    GetDcDataHandler getData,
    SaveDcDataHandler save) : BaseController
{
    /// <summary>Every DC with every column, ordered by name (legacy DataApi/getDCList). Feeds the "DC Listing" dialog.</summary>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<DcDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetList(CancellationToken cancellationToken) =>
        ToActionResult(await getList.HandleAsync(new GetDcListQuery(), cancellationToken));

    /// <summary>One DC by name (legacy DataApi/getDCData). 404 when the DC does not exist.</summary>
    [HttpGet("{whDes}")]
    [ProducesResponseType<DcDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetByName(string whDes, CancellationToken cancellationToken) =>
        ToActionResult(await getData.HandleAsync(new GetDcDataQuery(whDes), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>Adds a DC (legacy SaveApi/SaveDCData with Option "New", SP DestWarehouseAdd). 409 when the DC exists.</summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<SaveDcResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] CreateDcRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(new SaveDcDataCommand(SaveMode.New, request.WhDes, request.CountryCode), cancellationToken));

    /// <summary>Changes the country of a DC (legacy SaveApi/SaveDCData with Option "Change", SP DestWarehouseEdit). 404 when the DC does not exist.</summary>
    [HttpPut("{whDes}")]
    [Consumes("application/json")]
    [ProducesResponseType<SaveDcResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(string whDes, [FromBody] UpdateDcRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(new SaveDcDataCommand(SaveMode.Change, whDes, request.CountryCode), cancellationToken));
}

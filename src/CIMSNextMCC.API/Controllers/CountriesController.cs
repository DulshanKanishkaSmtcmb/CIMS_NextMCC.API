using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.Country;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Country master data. Replaces the legacy page File/Country ("Country Master Details", CloudMenu 100.02) and its calls
/// to DataApi/getCountryList, getCountryData, findCountryName and SaveApi/SaveCountryData.
/// Write-up: legacy repo docs/15-wave1-masterdata-a.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/countries")]
[RequireMenu(CountryMenu.Key)]
[Produces("application/json")]
public class CountriesController(
    GetCountryListHandler getList,
    GetCountryDataHandler getData,
    FindCountryNameHandler findName,
    SaveCountryDataHandler save) : BaseController
{
    /// <summary>Every country with every column, ordered by code (legacy DataApi/getCountryList). Feeds the "Countries Listing" dialogs.</summary>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<CountryDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetList(CancellationToken cancellationToken) =>
        ToActionResult(await getList.HandleAsync(new GetCountryListQuery(), cancellationToken));

    /// <summary>
    /// Countries whose name starts with (or equals) the typed text, ordered by name (legacy DataApi/findCountryName,
    /// the "Pre-Entered Supplier Listing" box).
    /// </summary>
    /// <param name="name">The text typed in Country Name.</param>
    /// <param name="startsWith">True (default): names that start with the text. False: names equal to it.</param>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet("search")]
    [ProducesResponseType<IReadOnlyList<CountryNameHitDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Search([FromQuery] string name, [FromQuery] bool startsWith = true, CancellationToken cancellationToken = default) =>
        ToActionResult(await findName.HandleAsync(new FindCountryNameQuery(name ?? string.Empty, startsWith), cancellationToken));

    /// <summary>One country by code (legacy DataApi/getCountryData). 404 when the code does not exist.</summary>
    [HttpGet("{countryCode}")]
    [ProducesResponseType<CountryDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetByCode(string countryCode, CancellationToken cancellationToken) =>
        ToActionResult(await getData.HandleAsync(new GetCountryDataQuery(countryCode), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>Adds a country (legacy SaveApi/SaveCountryData with Option "New", SP CountryAdd). 409 when the code exists.</summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<SaveCountryResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] CreateCountryRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(
            new SaveCountryDataCommand(SaveMode.New, request.CountryCode, request.CountryName, request.CargoMovement),
            cancellationToken));

    /// <summary>Changes a country (legacy SaveApi/SaveCountryData with Option "Change", SP CountryEdit). 404 when the code does not exist.</summary>
    [HttpPut("{countryCode}")]
    [Consumes("application/json")]
    [ProducesResponseType<SaveCountryResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(string countryCode, [FromBody] UpdateCountryRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(
            new SaveCountryDataCommand(SaveMode.Change, countryCode, request.CountryName, request.CargoMovement),
            cancellationToken));
}

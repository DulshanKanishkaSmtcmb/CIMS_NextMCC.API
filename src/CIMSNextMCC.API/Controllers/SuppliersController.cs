using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.Supplier;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Supplier master data (dbo.Shipper). Replaces the legacy page File/Supplier ("Suppliers Master Details", CloudMenu
/// 100.04) and its calls to DataApi/getSupplierList, getSupplierData, findSupplierName, getAirShipperList,
/// getAirShipperData, getSeaShipperList, getSeaShipperData and SaveApi/SaveSupplierData. The page's Country lookups use
/// api/v1/master-data/countries. Write-up: legacy repo docs/16-wave1-masterdata-b.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/suppliers")]
[RequireMenu(SupplierMenu.Key)]
[Produces("application/json")]
public class SuppliersController(
    GetSupplierListHandler getList,
    GetSupplierDataHandler getData,
    FindSupplierNameHandler findName,
    SaveSupplierDataHandler save,
    GetAirShipperListHandler getAirList,
    GetAirShipperDataHandler getAirData,
    GetSeaShipperListHandler getSeaList,
    GetSeaShipperDataHandler getSeaData) : BaseController
{
    /// <summary>Every supplier with every column, ordered by code (legacy DataApi/getSupplierList). Feeds the "Supplier Listing" dialog.</summary>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<SupplierDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetList(CancellationToken cancellationToken) =>
        ToActionResult(await getList.HandleAsync(new GetSupplierListQuery(), cancellationToken));

    /// <summary>
    /// Suppliers whose name starts with (or equals) the typed text, ordered by name (legacy DataApi/findSupplierName, the
    /// "Pre-Entered Supplier Listing" box).
    /// </summary>
    /// <param name="name">The text typed in Supplier Name.</param>
    /// <param name="startsWith">True (default): names that start with the text. False: names equal to it.</param>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet("search")]
    [ProducesResponseType<IReadOnlyList<SupplierNameHitDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Search([FromQuery] string name, [FromQuery] bool startsWith = true, CancellationToken cancellationToken = default) =>
        ToActionResult(await findName.HandleAsync(new FindSupplierNameQuery(name ?? string.Empty, startsWith), cancellationToken));

    /// <summary>
    /// The shippers of the AirFreight system for the "Air Shipper Listing" dialog (legacy DataApi/getAirShipperList). 503
    /// <c>AIR_DATABASE_UNAVAILABLE</c> when the tenant's Air database is not configured or not reachable.
    /// </summary>
    [HttpGet("air-shippers")]
    [ProducesResponseType<IReadOnlyList<FreightShipperDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<IActionResult> GetAirShippers(CancellationToken cancellationToken) =>
        ToActionResult(await getAirList.HandleAsync(new GetAirShipperListQuery(), cancellationToken));

    /// <summary>Code and name of one AirFreight shipper (legacy DataApi/getAirShipperData). 404 when the code does not exist.</summary>
    [HttpGet("air-shippers/{shCode}")]
    [ProducesResponseType<FreightShipperNameDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<IActionResult> GetAirShipper(string shCode, CancellationToken cancellationToken) =>
        ToActionResult(await getAirData.HandleAsync(new GetAirShipperDataQuery(shCode), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>
    /// The shippers of the SeaFreight system for the "Sea Shipper Listing" dialog (legacy DataApi/getSeaShipperList). 503
    /// <c>SEA_DATABASE_UNAVAILABLE</c> when the tenant's Sea database is not configured or not reachable.
    /// </summary>
    [HttpGet("sea-shippers")]
    [ProducesResponseType<IReadOnlyList<FreightShipperDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<IActionResult> GetSeaShippers(CancellationToken cancellationToken) =>
        ToActionResult(await getSeaList.HandleAsync(new GetSeaShipperListQuery(), cancellationToken));

    /// <summary>Code and name of one SeaFreight shipper (legacy DataApi/getSeaShipperData). 404 when the code does not exist.</summary>
    [HttpGet("sea-shippers/{shCode}")]
    [ProducesResponseType<FreightShipperNameDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<IActionResult> GetSeaShipper(string shCode, CancellationToken cancellationToken) =>
        ToActionResult(await getSeaData.HandleAsync(new GetSeaShipperDataQuery(shCode), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>One supplier by code (legacy DataApi/getSupplierData). 404 when the code does not exist.</summary>
    [HttpGet("{shipperCode}")]
    [ProducesResponseType<SupplierDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetByCode(string shipperCode, CancellationToken cancellationToken) =>
        ToActionResult(await getData.HandleAsync(new GetSupplierDataQuery(shipperCode), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>
    /// Adds a supplier (legacy SaveApi/SaveSupplierData with Option "New", SP ShipperAdd). The code is generated from the
    /// first character of the name and returned as <c>supplierCode</c>.
    /// </summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<SaveSupplierResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] SaveSupplierRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(ToCommand(SaveMode.New, string.Empty, request), cancellationToken));

    /// <summary>Changes a supplier (legacy SaveApi/SaveSupplierData with Option "Change", SP ShipperEdit). 404 when the code does not exist.</summary>
    [HttpPut("{shipperCode}")]
    [Consumes("application/json")]
    [ProducesResponseType<SaveSupplierResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(string shipperCode, [FromBody] SaveSupplierRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(ToCommand(SaveMode.Change, shipperCode, request), cancellationToken));

    private static SaveSupplierDataCommand ToCommand(SaveMode mode, string code, SaveSupplierRequest r) =>
        new(
            mode,
            code,
            r.ShipperName,
            r.ShipperAddress1,
            r.ShipperAddress2,
            r.ShipperAddress3,
            r.ShipperAddress4,
            r.ShipperContact1,
            r.ShipperContact2,
            r.ShipperContact3,
            r.ShipperTel,
            r.ShipperEmail,
            r.ShipperFax,
            r.CountryCode,
            r.ShipperCodeAir,
            r.ShipperCodeSea,
            r.LimaSupplierCode,
            r.RexNo);
}

using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.PmSupplier;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Packing-material supplier master data (dbo.PMSupplier). Replaces the legacy page File/PmSupplier ("PM Suppliers
/// Master Details", CloudMenu 100.16) and its calls to DataApi/getPMSupplierList, getPMSupplierData and
/// SaveApi/SavePMSupplierData. The page's Country lookups use api/v1/master-data/countries. Write-up: legacy repo
/// docs/16-wave1-masterdata-b.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/pm-suppliers")]
[RequireMenu(PmSupplierMenu.Key)]
[Produces("application/json")]
public class PmSuppliersController(
    GetPmSupplierListHandler getList,
    GetPmSupplierDataHandler getData,
    SavePmSupplierDataHandler save) : BaseController
{
    /// <summary>Every PM supplier with every column, ordered by code (legacy DataApi/getPMSupplierList). Feeds the "Supplier Listing" dialog.</summary>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<PmSupplierDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetList(CancellationToken cancellationToken) =>
        ToActionResult(await getList.HandleAsync(new GetPmSupplierListQuery(), cancellationToken));

    /// <summary>One PM supplier by code (legacy DataApi/getPMSupplierData). 404 when the code does not exist.</summary>
    [HttpGet("{pmSupplierCode}")]
    [ProducesResponseType<PmSupplierDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetByCode(string pmSupplierCode, CancellationToken cancellationToken) =>
        ToActionResult(await getData.HandleAsync(new GetPmSupplierDataQuery(pmSupplierCode), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>
    /// Adds a PM supplier (legacy SaveApi/SavePMSupplierData with Option "New", SP PMSupplierAdd). The code is generated
    /// from the first character of the name and returned as <c>pmSupplierCode</c>.
    /// </summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<SavePmSupplierResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] SavePmSupplierRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(ToCommand(SaveMode.New, string.Empty, request), cancellationToken));

    /// <summary>Changes a PM supplier (legacy SaveApi/SavePMSupplierData with Option "Change", SP PMSupplierEdit). 404 when the code does not exist.</summary>
    [HttpPut("{pmSupplierCode}")]
    [Consumes("application/json")]
    [ProducesResponseType<SavePmSupplierResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(string pmSupplierCode, [FromBody] SavePmSupplierRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(ToCommand(SaveMode.Change, pmSupplierCode, request), cancellationToken));

    private static SavePmSupplierDataCommand ToCommand(SaveMode mode, string code, SavePmSupplierRequest r) =>
        new(
            mode,
            code,
            r.PmSupplierName,
            r.PmSupplierAddress1,
            r.PmSupplierAddress2,
            r.PmSupplierAddress3,
            r.PmSupplierAddress4,
            r.PmSupplierContact1,
            r.PmSupplierContact2,
            r.PmSupplierContact3,
            r.PmSupplierTel,
            r.PmSupplierEmail,
            r.PmSupplierFax,
            r.CountryCode);
}

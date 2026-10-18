using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.PMMaster;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Packing Material (PM Master) master data. Replaces the legacy page File/PMMaster ("Packing Material Master Details",
/// CloudMenu 100.10) and its calls to DataApi/getPMList, getPMData, getPmCategoryData and SaveApi/SavePMData.
/// Write-up: legacy repo docs/17-wave1-masterdata-c.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/pm-masters")]
[RequireMenu(PmMasterMenu.Key)]
[Produces("application/json")]
public class PmMastersController(
    GetPmListHandler getList,
    GetPmDataHandler getData,
    GetPmCategoriesHandler getCategories,
    SavePmDataHandler save) : BaseController
{
    /// <summary>Every packing material with every column, ordered by code (legacy DataApi/getPMList). Feeds the "Packing Material Master Listing" dialog.</summary>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<PmMasterDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetList(CancellationToken cancellationToken) =>
        ToActionResult(await getList.HandleAsync(new GetPmListQuery(), cancellationToken));

    /// <summary>The choices of the PM Category select, in table order (legacy DataApi/getPmCategoryData).</summary>
    [HttpGet("categories")]
    [ProducesResponseType<IReadOnlyList<PmCategoryDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetCategories(CancellationToken cancellationToken) =>
        ToActionResult(await getCategories.HandleAsync(new GetPmCategoriesQuery(), cancellationToken));

    /// <summary>One packing material by code (legacy DataApi/getPMData). 404 when the code does not exist.</summary>
    [HttpGet("{pmCode}")]
    [ProducesResponseType<PmMasterDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetByCode(string pmCode, CancellationToken cancellationToken) =>
        ToActionResult(await getData.HandleAsync(new GetPmDataQuery(pmCode), cancellationToken), StatusCodes.Status404NotFound);

    /// <summary>Adds a packing material (legacy SaveApi/SavePMData with Option "New", SP PMMasterAdd). 409 when the code exists.</summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<SavePmMasterResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] CreatePmMasterRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(
            new SavePmDataCommand(
                SaveMode.New, request.PmCode, request.PmDescription, request.PmCategory, request.ReorderLevel,
                request.PmWeight, request.Cbm, request.GetJokersCount, request.GetPartsCount, request.IsActive),
            cancellationToken));

    /// <summary>Changes a packing material (legacy SaveApi/SavePMData with Option "Change", SP PMMasterEdit). 404 when the code does not exist.</summary>
    [HttpPut("{pmCode}")]
    [Consumes("application/json")]
    [ProducesResponseType<SavePmMasterResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(string pmCode, [FromBody] UpdatePmMasterRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(
            new SavePmDataCommand(
                SaveMode.Change, pmCode, request.PmDescription, request.PmCategory, request.ReorderLevel,
                request.PmWeight, request.Cbm, request.GetJokersCount, request.GetPartsCount, request.IsActive),
            cancellationToken));
}

using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.MasterData.ProductCategory;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Product Category (contract chain codes). Replaces the legacy page File/ProductCategory ("Product Category", CloudMenu
/// 100.20) and its calls to DataApi/getChainCategoryData, getProductCategoryData and SaveApi/SaveContractsChainCodes.
/// Write-up: legacy repo docs/17-wave1-masterdata-c.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/product-categories")]
[RequireMenu(ProductCategoryMenu.Key)]
[Produces("application/json")]
public class ProductCategoriesController(
    GetChainCodesHandler getChainCodes,
    GetChainRangesHandler getRanges,
    SaveChainCodeHandler save) : BaseController
{
    /// <summary>Every chain code with every column, in the table's own order (legacy DataApi/getChainCategoryData). Feeds the grid.</summary>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet]
    [ProducesResponseType<IReadOnlyList<ChainCodeDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetList(CancellationToken cancellationToken) =>
        ToActionResult(await getChainCodes.HandleAsync(new GetChainCodesQuery(), cancellationToken));

    /// <summary>The choices of the Range select, in table order (legacy DataApi/getProductCategoryData).</summary>
    [HttpGet("ranges")]
    [ProducesResponseType<IReadOnlyList<ChainRangeDto>>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetRanges(CancellationToken cancellationToken) =>
        ToActionResult(await getRanges.HandleAsync(new GetChainRangesQuery(), cancellationToken));

    /// <summary>Adds a chain code (legacy SaveApi/SaveContractsChainCodes, SP InsertContractsChainCodes). 409 when the chain code exists.</summary>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType<SaveChainCodeResultDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create([FromBody] CreateChainCodeRequest request, CancellationToken cancellationToken) =>
        ToActionResult(await save.HandleAsync(
            new SaveChainCodeCommand(request.ChainCode, request.ChainName, request.Range, request.TpPartnerName, request.RangeBoxEan),
            cancellationToken));
}

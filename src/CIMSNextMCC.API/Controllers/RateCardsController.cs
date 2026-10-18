using Asp.Versioning;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.MasterData.RateCard;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Rate card (export clearance, freight and CFS charges). Replaces the legacy page File/RateCardEntry ("Rate Card Entry",
/// CloudMenu 100.12) and its one data call, DataApi/getRateInformation4Add. The legacy page has no save, so there is no
/// write here. Write-up: legacy repo docs/18-wave1-masterdata-d.md.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/master-data/rate-cards")]
[RequireMenu(RateCardMenu.Key)]
[Produces("application/json")]
public class RateCardsController(GetRateCardHandler getRateCard) : BaseController
{
    /// <summary>
    /// The three rate tables: clearance (one row per container type), freight (one per port and container type, 0 when no
    /// rate is stored) and CFS charges (every stored row with its material's description).
    /// </summary>
    /// <param name="cancellationToken">Request cancellation.</param>
    [HttpGet]
    [ProducesResponseType<RateCardDto>(StatusCodes.Status200OK)]
    public async Task<IActionResult> Get(CancellationToken cancellationToken) =>
        ToActionResult(await getRateCard.HandleAsync(new GetRateCardQuery(), cancellationToken));
}

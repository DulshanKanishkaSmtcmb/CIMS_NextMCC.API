using Asp.Versioning;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.Application.Reference.FieldCaptions;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>Reference data shared by many pages.</summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/reference")]
public class ReferenceController(GetFieldCaptionsHandler getFieldCaptions) : BaseController
{
    /// <summary>
    /// Tenant-configurable captions for the system, contract, item, PO and delivery fields.
    /// Replaces legacy DataApi/getfldParas (a positional array) with named properties.
    /// </summary>
    [HttpGet("field-captions")]
    [ProducesResponseType<FieldCaptionsDto>(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetFieldCaptions(CancellationToken cancellationToken) =>
        ToActionResult(await getFieldCaptions.HandleAsync(new GetFieldCaptionsQuery(), cancellationToken));
}

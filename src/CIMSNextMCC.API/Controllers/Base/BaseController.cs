using CIMSNextMCC.Application.Common.Models;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers.Base;

[ApiController]
public abstract class BaseController : ControllerBase
{
    /// <summary>200 with the typed DTO on success, ProblemDetails (with a "code" extension) on failure.</summary>
    protected IActionResult ToActionResult<T>(Result<T> result, int failureStatusCode = StatusCodes.Status400BadRequest) =>
        result.IsSuccess ? Ok(result.Data) : ProblemFor(result, failureStatusCode);

    protected IActionResult ToActionResult(Result result, int failureStatusCode = StatusCodes.Status400BadRequest) =>
        result.IsSuccess ? NoContent() : ProblemFor(result, failureStatusCode);

    private ObjectResult ProblemFor(Result result, int statusCode)
    {
        var problem = new ProblemDetails
        {
            Status = statusCode,
            Title = result.MessageCode
        };
        problem.Extensions["code"] = result.MessageCode;
        problem.Extensions["traceId"] = HttpContext.TraceIdentifier;

        return StatusCode(statusCode, problem);
    }
}

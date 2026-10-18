using System.Diagnostics;
using CIMSNextMCC.Application.Common.Exceptions;
using FluentValidation;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Middleware;

/// <summary>Global exception handler: every failure leaves the API as RFC 9457 ProblemDetails.</summary>
public class ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await next(context);
        }
        catch (OperationCanceledException) when (context.RequestAborted.IsCancellationRequested)
        {
            // The client went away; nothing to write.
            logger.LogDebug("Request was cancelled by the client.");
        }
        catch (Exception ex)
        {
            if (context.Response.HasStarted)
            {
                logger.LogError(ex, "Unhandled exception after the response had started.");
                throw;
            }

            await WriteProblemAsync(context, ex);
        }
    }

    private async Task WriteProblemAsync(HttpContext context, Exception exception)
    {
        ProblemDetails problem;

        switch (exception)
        {
            case AppException appException:
                logger.LogWarning(exception, "Business exception {MessageCode}", appException.MessageCode);
                problem = new ProblemDetails { Status = appException.StatusCode, Title = appException.MessageCode };
                problem.Extensions["code"] = appException.MessageCode;
                break;

            case ValidationException validationException:
                logger.LogWarning(exception, "Validation failed");
                problem = new ProblemDetails { Status = StatusCodes.Status400BadRequest, Title = "One or more validation errors occurred." };
                problem.Extensions["code"] = "VALIDATION_FAILED";
                problem.Extensions["errors"] = validationException.Errors
                    .GroupBy(e => e.PropertyName)
                    .ToDictionary(g => g.Key, g => g.Select(e => e.ErrorMessage).ToArray());
                break;

            default:
                logger.LogError(exception, "Unhandled exception");
                problem = new ProblemDetails { Status = StatusCodes.Status500InternalServerError, Title = "An unexpected error occurred." };
                problem.Extensions["code"] = "UNEXPECTED_ERROR";
                break;
        }

        problem.Extensions["traceId"] = Activity.Current?.Id ?? context.TraceIdentifier;

        context.Response.Clear();
        context.Response.StatusCode = problem.Status ?? StatusCodes.Status500InternalServerError;
        await context.Response.WriteAsJsonAsync(problem, options: null, contentType: "application/problem+json");
    }
}

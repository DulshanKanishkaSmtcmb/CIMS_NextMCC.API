using CIMSNextMCC.Application.Interfaces.Common;

namespace CIMSNextMCC.API.Middleware;

/// <summary>Opts an endpoint out of the per-request database transaction (and of opening a tenant connection).</summary>
[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
public sealed class SkipTransactionAttribute : Attribute;

/// <summary>
/// One database transaction per mutating request, committed on a success status and rolled back otherwise
/// (same boundary as a legacy SaveApi action). The unit of work is resolved only when needed so that GETs,
/// health checks and [SkipTransaction] endpoints never open a tenant connection.
/// </summary>
public class TransactionMiddleware(RequestDelegate next)
{
    private static readonly HashSet<string> TransactionalMethods = new(StringComparer.OrdinalIgnoreCase)
    {
        HttpMethods.Post,
        HttpMethods.Put,
        HttpMethods.Patch,
        HttpMethods.Delete
    };

    public async Task InvokeAsync(HttpContext context)
    {
        var skip = !TransactionalMethods.Contains(context.Request.Method)
            || context.User.Identity?.IsAuthenticated != true
            || context.GetEndpoint()?.Metadata.GetMetadata<SkipTransactionAttribute>() is not null;

        if (skip)
        {
            await next(context);
            return;
        }

        var unitOfWork = context.RequestServices.GetRequiredService<IUnitOfWork>();

        try
        {
            unitOfWork.Begin();
            await next(context);

            if (context.Response.StatusCode < StatusCodes.Status400BadRequest)
            {
                unitOfWork.Commit();
                return;
            }

            unitOfWork.Rollback();
        }
        catch
        {
            unitOfWork.Rollback();
            throw;
        }
    }
}

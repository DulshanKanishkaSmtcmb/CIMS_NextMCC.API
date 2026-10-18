using System.Security.Claims;
using Asp.Versioning;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.API.Middleware;
using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using CIMSNextMCC.Infrastructure.LegacyBridge;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace CIMSNextMCC.API.Controllers;

/// <summary>
/// Cookie bridge (docs/09-modernization-plan.md section 4.3): lets the SPA's bearer-token login also sign the user in
/// to the not-yet-migrated legacy pages, by writing the legacy OWIN application cookie. Spike results and the
/// matching legacy settings: docs/11-cookie-bridge-spike.md in the legacy repo. Delete this controller, the
/// LegacyCookie scheme and the shared key ring in Phase 4.
/// </summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/legacy-session")]
[SkipTransaction]
public class LegacySessionController(
    IOptions<LegacyBridgeOptions> options,
    IWebHostEnvironment environment) : BaseController
{
    /// <summary>
    /// Exchanges the caller's bearer token for the legacy cookie: looks the user up in dbo.PwInfo and signs in the
    /// "LegacyCookie" scheme with the same four claims, in the same order and encoding, as AccountController.SignInUser.
    /// </summary>
    /// <response code="204">Set-Cookie carries the legacy cookie.</response>
    /// <response code="403">No unique PwInfo user for the token's username, or one the legacy login could not sign in either.</response>
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> Create(
        // Per action, not in the constructor: resolving it opens the tenant connection, which DELETE and inspect
        // (anonymous, no tenant claim) must not do.
        [FromServices] ILegacyUserRepository legacyUsers,
        CancellationToken cancellationToken)
    {
        var userName = User.FindFirstValue("username") ?? User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(userName))
        {
            throw new ForbiddenException("LEGACY_USERNAME_MISSING");
        }

        var matches = await legacyUsers.FindByUserNameAsync(userName, cancellationToken);
        if (matches.Count == 0)
        {
            throw new ForbiddenException("LEGACY_USER_NOT_FOUND");
        }

        if (matches.Count > 1)
        {
            // The legacy login also matches the password, so duplicate names work there; here they are ambiguous.
            throw new ForbiddenException("LEGACY_USER_AMBIGUOUS");
        }

        ClaimsIdentity identity;
        try
        {
            identity = LegacyClaims.CreateIdentity(matches[0]);
        }
        catch (Exception ex) when (ex is ArgumentOutOfRangeException or OverflowException)
        {
            // Empty UserId or non-ASCII UserCategory: the legacy login throws on these too.
            throw new ForbiddenException("LEGACY_USER_NOT_ENCODABLE");
        }

        // As SignInUser: IssuedUtc + ExpiresUtc only, not persistent (session cookie, ticket valid for one day).
        var issued = DateTimeOffset.UtcNow;
        var properties = new AuthenticationProperties
        {
            IssuedUtc = issued,
            ExpiresUtc = issued.AddHours(options.Value.ExpiryHours)
        };

        await HttpContext.SignInAsync(LegacyBridgeDefaults.Scheme, new ClaimsPrincipal(identity), properties);
        return NoContent();
    }

    /// <summary>Clears the legacy cookie (expired Set-Cookie). Anonymous: signing out needs no token.</summary>
    /// <response code="204">Set-Cookie expires the legacy cookie.</response>
    [HttpDelete]
    [AllowAnonymous]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Delete()
    {
        await HttpContext.SignOutAsync(LegacyBridgeDefaults.Scheme);
        return NoContent();
    }

    /// <summary>
    /// Development only: decodes the incoming legacy cookie with the LegacyCookie scheme and returns its claims in
    /// order, plus the values legacy code decodes from them. 404 outside Development.
    /// </summary>
    [HttpGet("inspect")]
    [AllowAnonymous]
    [ApiExplorerSettings(IgnoreApi = true)]
    public async Task<IActionResult> Inspect()
    {
        if (!environment.IsDevelopment())
        {
            return NotFound();
        }

        var result = await HttpContext.AuthenticateAsync(LegacyBridgeDefaults.Scheme);
        if (!result.Succeeded || result.Principal?.Identity is not ClaimsIdentity identity)
        {
            return Problem(
                title: "LEGACY_COOKIE_MISSING_OR_INVALID",
                detail: result.Failure?.Message,
                statusCode: StatusCodes.Status401Unauthorized);
        }

        var claims = identity.Claims.Select((claim, index) => new LegacyClaimView(index, claim.Type, claim.Value)).ToList();
        string? At(int index) => index < claims.Count ? claims[index].Value : null;

        return Ok(new LegacySessionView(
            identity.AuthenticationType,
            claims,
            At(0),
            At(1) is { Length: > 0 } sid ? LegacyClaimCodec.ReverseMiddle(sid) : null,
            At(2) is { } groupSid ? LegacyClaimCodec.ReConvertAsc(groupSid) : null,
            At(3),
            result.Properties?.IssuedUtc,
            result.Properties?.ExpiresUtc));
    }

    public sealed record LegacyClaimView(int Index, string Type, string Value);

    public sealed record LegacySessionView(
        string? AuthenticationType,
        IReadOnlyList<LegacyClaimView> Claims,
        string? UserName,
        string? UserId,
        string? UserCategory,
        string? UserLevel,
        DateTimeOffset? IssuedUtc,
        DateTimeOffset? ExpiresUtc);
}

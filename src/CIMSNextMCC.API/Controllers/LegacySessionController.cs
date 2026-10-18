using Asp.Versioning;
using CIMSNextMCC.API.Controllers.Base;
using CIMSNextMCC.API.Middleware;
using Microsoft.AspNetCore.Mvc;

namespace CIMSNextMCC.API.Controllers;

/// <summary>Cookie bridge: lets the SPA's bearer-token login also sign the user in to not-yet-migrated legacy pages.</summary>
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/legacy-session")]
[SkipTransaction]
public class LegacySessionController : BaseController
{
    /// <summary>Exchanges the caller's bearer token for the legacy OWIN application cookie. Not implemented yet.</summary>
    // TODO(docs/09-modernization-plan.md section 4.3): this is the Phase 1 cookie-bridge SPIKE, to be proven in week one.
    //   1. Reference Microsoft.Owin.Security.Interop and use the legacy app's cookie name, path and a shared Data Protection key ring.
    //   2. Write the OWIN-compatible cookie with the same four claims in the same order as AccountController.SignInUser:
    //      Name, Sid (scrambled UserId), GroupSid (obfuscated UserCategory), Surname (UserLevel).
    //   3. Logout must clear both the Identity session and this cookie; align cookie expiry with the token (legacy: one day).
    //   4. Delete this controller and the key ring in Phase 4.
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status501NotImplemented)]
    public IActionResult Create() =>
        Problem(
            title: "Not implemented",
            detail: "The legacy cookie bridge is a Phase 1 spike; see docs/09-modernization-plan.md section 4.3.",
            statusCode: StatusCodes.Status501NotImplemented);
}

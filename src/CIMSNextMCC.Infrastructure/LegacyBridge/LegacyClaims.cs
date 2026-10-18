using System.Security.Claims;
using CIMSNextMCC.Domain.Entities.Security;

namespace CIMSNextMCC.Infrastructure.LegacyBridge;

/// <summary>
/// Builds the identity the legacy AccountController.SignInUser builds. Legacy code reads these claims BY POSITION
/// (Claims.ElementAt(1) and ElementAt(2) in hundreds of places), so the order, types and encodings are fixed:
///   0 ClaimTypes.Name     = UserName
///   1 ClaimTypes.Sid      = ReverseMiddle(UserId)
///   2 ClaimTypes.GroupSid = ConvertAsc(UserCategory)
///   3 ClaimTypes.Surname  = UserLevel (as stored)
/// </summary>
public static class LegacyClaims
{
    /// <summary>Microsoft.AspNet.Identity.DefaultAuthenticationTypes.ApplicationCookie, the legacy identity's type.</summary>
    public const string AuthenticationType = "ApplicationCookie";

    /// <exception cref="ArgumentOutOfRangeException">Empty UserId (the legacy login fails the same way).</exception>
    /// <exception cref="OverflowException">Non-ASCII UserCategory (the legacy login fails the same way).</exception>
    public static ClaimsIdentity CreateIdentity(LegacyUser user)
    {
        ArgumentNullException.ThrowIfNull(user);

        // Convert.ToString(row[...]) in the legacy login turns NULL into "".
        var claims = new List<Claim>
        {
            new(ClaimTypes.Name, user.UserName ?? string.Empty),
            new(ClaimTypes.Sid, LegacyClaimCodec.ReverseMiddle(user.UserId ?? string.Empty)),
            new(ClaimTypes.GroupSid, LegacyClaimCodec.ConvertAsc(user.UserCategory ?? string.Empty)),
            new(ClaimTypes.Surname, user.UserLevel ?? string.Empty)
        };

        return new ClaimsIdentity(claims, AuthenticationType);
    }
}

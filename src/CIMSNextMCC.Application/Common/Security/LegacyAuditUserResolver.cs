using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;

namespace CIMSNextMCC.Application.Common.Security;

/// <summary>
/// The value the legacy save actions wrote into EnterBy / CreateBy / UpdateBy: the caller's dbo.PwInfo.UserId
/// (legacy <c>clsDBUtility.ReverseMiddle(claim 1)</c>), looked up by user name. A caller that is not exactly one
/// PwInfo row is refused (403) before anything is written.
/// </summary>
// TODO(docs/09 section 4.2 item 4): take the legacy UserId from ICurrentUser once its local lookup exists
// (the Confirm Arrivals handler has the same lookup inline).
public sealed class LegacyAuditUserResolver(ILegacyUserRepository legacyUsers, ICurrentUser currentUser)
{
    public const string LegacyUserNotFound = "LEGACY_USER_NOT_FOUND";

    public async Task<string> ResolveAsync(CancellationToken cancellationToken = default)
    {
        var users = await legacyUsers.FindByUserNameAsync(currentUser.UserName, cancellationToken);
        if (users.Count != 1 || string.IsNullOrEmpty(users[0].UserId))
        {
            throw new ForbiddenException(LegacyUserNotFound);
        }

        return users[0].UserId!;
    }
}

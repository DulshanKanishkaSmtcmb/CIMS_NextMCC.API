using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Common;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Options;

namespace CIMSNextMCC.API.Authorization;

/// <summary>
/// Requires the user to hold the given menu key (CloudMenu / CloudMenuAllocation). Put it on a controller or action:
/// <c>[RequireMenu("ConfirmArrival")]</c>. Honours Authorization:LogOnly, see <see cref="MenuAuthorizationHandler"/>.
/// </summary>
[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
public sealed class RequireMenuAttribute(string menuKey) : AuthorizeAttribute, IAuthorizationRequirementData
{
    public string MenuKey { get; } = menuKey;

    public IEnumerable<IAuthorizationRequirement> GetRequirements()
    {
        yield return new MenuRequirement(MenuKey);
    }
}

public sealed class MenuRequirement(string menuKey) : IAuthorizationRequirement
{
    public string MenuKey { get; } = menuKey;
}

/// <summary>
/// Allows the call when the current user holds the menu key. Otherwise: with Authorization:LogOnly = true the denial is
/// logged and the call is allowed (rollout mode, docs/09 section 4.2 item 5); with false the requirement fails (403).
/// </summary>
public sealed class MenuAuthorizationHandler(
    ICurrentUser currentUser,
    IOptions<AuthorizationSettings> settings,
    ILogger<MenuAuthorizationHandler> logger) : AuthorizationHandler<MenuRequirement>
{
    protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, MenuRequirement requirement)
    {
        if (currentUser.MenuKeys.Contains(requirement.MenuKey, StringComparer.OrdinalIgnoreCase))
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        if (settings.Value.LogOnly)
        {
            logger.LogWarning(
                "Menu authorization would deny user {UserName} access to menu {MenuKey}; allowed because Authorization:LogOnly is true.",
                currentUser.UserName,
                requirement.MenuKey);
            context.Succeed(requirement);
        }
        else
        {
            logger.LogWarning(
                "Menu authorization denied user {UserName} access to menu {MenuKey}.",
                currentUser.UserName,
                requirement.MenuKey);
        }

        return Task.CompletedTask;
    }
}

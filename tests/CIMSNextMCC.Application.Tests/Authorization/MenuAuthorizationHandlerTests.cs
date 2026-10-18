using System.Security.Claims;
using CIMSNextMCC.API.Authorization;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Common;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace CIMSNextMCC.Application.Tests.Authorization;

public class MenuAuthorizationHandlerTests
{
    private sealed class FakeCurrentUser(params string[] menuKeys) : ICurrentUser
    {
        public bool IsAuthenticated => true;
        public string UserKey => "user-1";
        public string UserName => "tester";
        public string? UserCategory => null;
        public string? UserLevel => null;
        public string Tenant => "NextMCC";
        public IReadOnlyList<string> AllowedDCs => [];
        public IReadOnlyList<string> AllowedShippers => [];
        public IReadOnlyList<string> MenuKeys { get; } = menuKeys;
    }

    private static async Task<bool> RunAsync(bool logOnly, params string[] userMenuKeys)
    {
        var handler = new MenuAuthorizationHandler(
            new FakeCurrentUser(userMenuKeys),
            Options.Create(new AuthorizationSettings { LogOnly = logOnly }),
            NullLogger<MenuAuthorizationHandler>.Instance);

        var requirement = new MenuRequirement("ConfirmArrival");
        var context = new AuthorizationHandlerContext([requirement], new ClaimsPrincipal(new ClaimsIdentity()), null);

        await handler.HandleAsync(context);

        return context.HasSucceeded;
    }

    [Fact]
    public async Task Allows_a_user_who_holds_the_menu_key() =>
        Assert.True(await RunAsync(logOnly: false, "confirmarrival"));

    [Fact]
    public async Task Denies_a_user_without_the_menu_key_when_enforcing() =>
        Assert.False(await RunAsync(logOnly: false, "Unloading"));

    [Fact]
    public async Task Allows_a_user_without_the_menu_key_when_log_only() =>
        Assert.True(await RunAsync(logOnly: true, "Unloading"));

    [Fact]
    public void RequireMenu_attribute_produces_a_menu_requirement()
    {
        var requirement = Assert.Single(new RequireMenuAttribute("ConfirmArrival").GetRequirements());

        Assert.Equal("ConfirmArrival", Assert.IsType<MenuRequirement>(requirement).MenuKey);
    }
}

namespace CIMSNextMCC.Application.Interfaces.Common;

/// <summary>The signed-in user, built from token claims plus (later) a cached local lookup.</summary>
public interface ICurrentUser
{
    bool IsAuthenticated { get; }

    /// <summary>Identity subject ("sub").</summary>
    string UserKey { get; }

    string UserName { get; }

    string? UserCategory { get; }

    string? UserLevel { get; }

    /// <summary>The tenant this request runs against (token claim, or a validated X-Tenant header).</summary>
    string Tenant { get; }

    IReadOnlyList<string> AllowedDCs { get; }

    IReadOnlyList<string> AllowedShippers { get; }

    IReadOnlyList<string> MenuKeys { get; }
}

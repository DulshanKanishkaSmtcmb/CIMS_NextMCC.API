using CIMSNextMCC.Domain.Tenancy;

namespace CIMSNextMCC.Infrastructure.Tenancy;

/// <summary>
/// Bound from the "Tenants" array in configuration. Connection strings never live in source:
/// use user-secrets locally and environment variables (Tenants__0__ConnectionStrings__Main) in containers.
/// </summary>
public sealed class TenantOptions
{
    public const string SectionName = "Tenants";

    public List<TenantConfig> Tenants { get; set; } = [];

    public TenantConfig? Find(string? key) =>
        string.IsNullOrWhiteSpace(key)
            ? null
            : Tenants.FirstOrDefault(t => string.Equals(t.Key, key, StringComparison.OrdinalIgnoreCase));
}

public sealed class TenantConfig
{
    /// <summary>"NextMCC" or "NextCFS".</summary>
    public string Key { get; set; } = string.Empty;

    public string DisplayName { get; set; } = string.Empty;

    public TenantConnectionStrings ConnectionStrings { get; set; } = new();
}

public sealed class TenantConnectionStrings
{
    public string Main { get; set; } = string.Empty;
    public string Cfs { get; set; } = string.Empty;
    public string Air { get; set; } = string.Empty;
    public string Sea { get; set; } = string.Empty;

    public string Get(DbName database) => database switch
    {
        DbName.Main => Main,
        DbName.Cfs => Cfs,
        DbName.Air => Air,
        DbName.Sea => Sea,
        _ => throw new ArgumentOutOfRangeException(nameof(database), database, "Unknown database.")
    };
}

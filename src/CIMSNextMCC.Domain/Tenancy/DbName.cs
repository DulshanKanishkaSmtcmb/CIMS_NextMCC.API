namespace CIMSNextMCC.Domain.Tenancy;

/// <summary>
/// The databases every tenant owns. Each tenant (NextMCC, NextCFS, ...) has its own
/// connection string per database; see Tenants in appsettings.json.
/// </summary>
public enum DbName
{
    Main,
    Cfs,
    Air,
    Sea
}

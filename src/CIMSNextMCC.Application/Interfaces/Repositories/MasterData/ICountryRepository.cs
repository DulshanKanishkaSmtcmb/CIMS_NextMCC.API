using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the Country master page (legacy File/Country). Writes call the same stored procedures with the same
/// parameters as legacy SaveApi/SaveCountryData and run in the request's unit-of-work transaction.
/// </summary>
public interface ICountryRepository
{
    /// <summary>All dbo.Country rows ordered by CountryCode (legacy DataApi/getCountryList).</summary>
    Task<IReadOnlyList<CountryMaster>> GetAllAsync(CancellationToken cancellationToken = default);

    /// <summary>The row whose CountryCode equals <paramref name="countryCode"/> (column collation), or null (legacy DataApi/getCountryData).</summary>
    Task<CountryMaster?> FindAsync(string countryCode, CancellationToken cancellationToken = default);

    /// <summary>Rows whose CountryName starts with (or equals) <paramref name="name"/>, ordered by CountryName (legacy DataApi/findCountryName).</summary>
    Task<IReadOnlyList<CountryNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default);

    /// <summary>SP CountryAdd @CountryCode, @CountryName, @CargoMovement, @EnterBy.</summary>
    Task AddAsync(string countryCode, string countryName, string cargoMovement, string enterBy, CancellationToken cancellationToken = default);

    /// <summary>SP CountryEdit @CountryCode, @CountryName, @CargoMovement, @UpdateBy.</summary>
    Task UpdateAsync(string countryCode, string countryName, string cargoMovement, string updateBy, CancellationToken cancellationToken = default);
}

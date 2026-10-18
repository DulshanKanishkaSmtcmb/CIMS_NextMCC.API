using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.MasterData.Country;

public sealed record GetCountryListQuery;

/// <summary>
/// Replaces legacy DataApi/getCountryList (<c>select t1.* from Country order by CountryCode</c>); used by the "Countries
/// Listing" dialogs of the Country, Ports and DC pages. The CountryCode filter the legacy action parses is never applied,
/// so none is taken.
/// </summary>
public sealed class GetCountryListHandler(ICountryRepository repository)
{
    public async Task<Result<IReadOnlyList<CountryDto>>> HandleAsync(
        GetCountryListQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var rows = await repository.GetAllAsync(cancellationToken);
        IReadOnlyList<CountryDto> dtos = rows.Select(CountryMapping.ToDto).ToList();
        return Result<IReadOnlyList<CountryDto>>.Success(dtos);
    }
}

internal static class CountryMapping
{
    public static CountryDto ToDto(CountryMaster c) =>
        new(c.CountryCode, c.CountryName, c.CargoMovement, c.DateEnter, c.EnterBy, c.DateUpdate, c.UpdateBy, c.ContractBlock);
}

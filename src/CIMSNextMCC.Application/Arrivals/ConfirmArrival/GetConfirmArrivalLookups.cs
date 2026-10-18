using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.Arrivals;

namespace CIMSNextMCC.Application.Arrivals.ConfirmArrival;

public sealed record GetConfirmArrivalDcsQuery;

public sealed record GetConfirmArrivalCountriesQuery;

/// <summary>
/// Replaces legacy DataApi/getDCList as used by the Confirm Arrivals page (select t1.* from DestWarehouse order by WhDes;
/// the WhDes filter the legacy action parses is never applied, and the page only reads WhDes). The page adds "All" itself.
/// </summary>
public sealed class GetConfirmArrivalDcsHandler(IConfirmArrivalRepository repository)
{
    public async Task<Result<IReadOnlyList<ArrivalDcDto>>> HandleAsync(
        GetConfirmArrivalDcsQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var rows = await repository.GetDcsAsync(cancellationToken);
        IReadOnlyList<ArrivalDcDto> dtos = rows.Select(r => new ArrivalDcDto(r.WhDes)).ToList();

        return Result<IReadOnlyList<ArrivalDcDto>>.Success(dtos);
    }
}

/// <summary>
/// Replaces legacy DataApi/getCountryList as used by the Confirm Arrivals page (select t1.* from Country order by
/// CountryCode; the CountryCode filter is parsed but never applied). The page reads CountryCode and CountryName.
/// </summary>
public sealed class GetConfirmArrivalCountriesHandler(IConfirmArrivalRepository repository)
{
    public async Task<Result<IReadOnlyList<ArrivalCountryDto>>> HandleAsync(
        GetConfirmArrivalCountriesQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var rows = await repository.GetCountriesAsync(cancellationToken);
        IReadOnlyList<ArrivalCountryDto> dtos = rows.Select(r => new ArrivalCountryDto(r.CountryCode, r.CountryName)).ToList();

        return Result<IReadOnlyList<ArrivalCountryDto>>.Success(dtos);
    }
}

using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Country;

/// <param name="Name">The text typed in Country Name.</param>
/// <param name="StartsWith">Legacy isStartChrOnly: true = names that start with the text, false = names equal to it.</param>
public sealed record FindCountryNameQuery(string Name, bool StartsWith);

public sealed class FindCountryNameValidator : AbstractValidator<FindCountryNameQuery>
{
    public FindCountryNameValidator()
    {
        RuleFor(q => q.Name).NotNull().MaximumLength(CountryRules.NameLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/findCountryName, which feeds the "Pre-Entered Supplier Listing" box under the Country Name
/// field in New mode: <c>CountryCode, CountryName, CargoMovement</c> of the countries whose name starts with the typed
/// text (or equals it), ordered by name. The legacy <c>strRtnPara</c> (the box layout) is not taken.
/// </summary>
public sealed class FindCountryNameHandler(ICountryRepository repository, IValidator<FindCountryNameQuery> validator)
{
    public async Task<Result<IReadOnlyList<CountryNameHitDto>>> HandleAsync(
        FindCountryNameQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var rows = await repository.SearchByNameAsync(query.Name, query.StartsWith, cancellationToken);
        IReadOnlyList<CountryNameHitDto> dtos = rows.Select(r => new CountryNameHitDto(r.CountryCode, r.CountryName, r.CargoMovement)).ToList();
        return Result<IReadOnlyList<CountryNameHitDto>>.Success(dtos);
    }
}

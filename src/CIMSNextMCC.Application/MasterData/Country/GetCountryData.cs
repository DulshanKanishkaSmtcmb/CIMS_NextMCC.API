using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Country;

public sealed record GetCountryDataQuery(string CountryCode);

public sealed class GetCountryDataValidator : AbstractValidator<GetCountryDataQuery>
{
    public GetCountryDataValidator()
    {
        RuleFor(q => q.CountryCode).NotNull().MaximumLength(CountryRules.CodeLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getCountryData (<c>select t1.* from Country where CountryCode = ...</c>), parameterized.
/// The page uses it to fill the form (Change / View) and to check whether a code exists before saving. Legacy returned an
/// empty table for an unknown code; this returns the failure code <see cref="NotFound"/> (HTTP 404).
/// </summary>
public sealed class GetCountryDataHandler(ICountryRepository repository, IValidator<GetCountryDataQuery> validator)
{
    public const string NotFound = "COUNTRY_NOT_FOUND";

    public async Task<Result<CountryDto>> HandleAsync(GetCountryDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var row = await repository.FindAsync(query.CountryCode, cancellationToken);
        return row is null ? Result<CountryDto>.Failure(NotFound) : Result<CountryDto>.Success(CountryMapping.ToDto(row));
    }
}

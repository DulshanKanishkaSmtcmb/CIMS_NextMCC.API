using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.PmSupplier;

public sealed record GetPmSupplierDataQuery(string PmSupplierCode);

public sealed class GetPmSupplierDataValidator : AbstractValidator<GetPmSupplierDataQuery>
{
    public GetPmSupplierDataValidator()
    {
        RuleFor(q => q.PmSupplierCode).NotNull().MaximumLength(PmSupplierRules.CodeLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getPMSupplierData (<c>select t1.* from PMSupplier where PMSupplierCode = ...</c>), parameterized.
/// The legacy action read the code from the first property of the posted JSON, whatever its name (the existence check sent
/// it under a misspelt name, "PMSuplierCode"); here it is the route. The page uses it to fill the form (Change / View) and to
/// check whether a code exists before saving. Legacy returned an empty table for an unknown code; this returns the failure
/// code <see cref="NotFound"/> (HTTP 404).
/// </summary>
public sealed class GetPmSupplierDataHandler(IPmSupplierRepository repository, IValidator<GetPmSupplierDataQuery> validator)
{
    public const string NotFound = "PM_SUPPLIER_NOT_FOUND";

    public async Task<Result<PmSupplierDto>> HandleAsync(GetPmSupplierDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var row = await repository.FindAsync(query.PmSupplierCode, cancellationToken);
        return row is null ? Result<PmSupplierDto>.Failure(NotFound) : Result<PmSupplierDto>.Success(PmSupplierMapping.ToDto(row));
    }
}

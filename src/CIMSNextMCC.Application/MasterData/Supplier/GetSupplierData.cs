using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Supplier;

public sealed record GetSupplierDataQuery(string ShipperCode);

public sealed class GetSupplierDataValidator : AbstractValidator<GetSupplierDataQuery>
{
    public GetSupplierDataValidator()
    {
        RuleFor(q => q.ShipperCode).NotNull().MaximumLength(SupplierRules.CodeLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getSupplierData (<c>select t1.* from Shipper where ShipperCode = ...</c>), parameterized. The
/// page uses it to fill the form (Change / View) and to check whether a code exists before saving. Legacy returned an
/// empty table for an unknown code; this returns the failure code <see cref="NotFound"/> (HTTP 404).
/// </summary>
public sealed class GetSupplierDataHandler(ISupplierRepository repository, IValidator<GetSupplierDataQuery> validator)
{
    public const string NotFound = "SUPPLIER_NOT_FOUND";

    public async Task<Result<SupplierDto>> HandleAsync(GetSupplierDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var row = await repository.FindAsync(query.ShipperCode, cancellationToken);
        return row is null ? Result<SupplierDto>.Failure(NotFound) : Result<SupplierDto>.Success(SupplierMapping.ToDto(row));
    }
}

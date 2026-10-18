using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.DC;

public sealed record GetDcDataQuery(string WhDes);

public sealed class GetDcDataValidator : AbstractValidator<GetDcDataQuery>
{
    public GetDcDataValidator()
    {
        RuleFor(q => q.WhDes).NotNull().MaximumLength(DcRules.NameLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getDCData (<c>select t1.* from DestWarehouse where WhDes = ...</c>), parameterized. The page
/// uses it to fill the form (Change / View) and to check whether a DC exists before saving. Legacy returned an empty table
/// for an unknown DC; this returns the failure code <see cref="NotFound"/> (HTTP 404).
/// </summary>
public sealed class GetDcDataHandler(IDcRepository repository, IValidator<GetDcDataQuery> validator)
{
    public const string NotFound = "DC_NOT_FOUND";

    public async Task<Result<DcDto>> HandleAsync(GetDcDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var row = await repository.FindAsync(query.WhDes, cancellationToken);
        return row is null ? Result<DcDto>.Failure(NotFound) : Result<DcDto>.Success(DcMapping.ToDto(row));
    }
}

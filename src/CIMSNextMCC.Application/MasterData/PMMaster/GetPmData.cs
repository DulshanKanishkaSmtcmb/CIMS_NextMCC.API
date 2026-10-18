using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.PMMaster;

public sealed record GetPmDataQuery(string PmCode);

public sealed class GetPmDataValidator : AbstractValidator<GetPmDataQuery>
{
    public GetPmDataValidator()
    {
        // The table column is nvarchar(12) but the save procedures take nvarchar(10), so no code longer than 10 can be saved.
        RuleFor(q => q.PmCode).NotNull().MaximumLength(PmMasterRules.CodeLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getPMData (<c>select t1.* from PMMaster t1 where t1.PMCode = ...</c>), parameterized. The page
/// uses it to fill the form (Change) and to check whether a code exists before saving. Legacy returned an empty table
/// for an unknown code; this returns the failure code <see cref="NotFound"/> (HTTP 404).
/// </summary>
public sealed class GetPmDataHandler(IPackingMaterialRepository repository, IValidator<GetPmDataQuery> validator)
{
    public const string NotFound = "PM_NOT_FOUND";

    public async Task<Result<PmMasterDto>> HandleAsync(GetPmDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var row = await repository.FindAsync(query.PmCode, cancellationToken);
        return row is null ? Result<PmMasterDto>.Failure(NotFound) : Result<PmMasterDto>.Success(PmMasterMapping.ToDto(row));
    }
}

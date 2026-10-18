using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;
using FluentValidation.Results;

namespace CIMSNextMCC.Application.MasterData.PMMaster;

/// <summary>Field sizes of dbo.PMMaster / the stored-procedure parameters.</summary>
public static class PmMasterRules
{
    /// <summary>PMMasterAdd / PMMasterEdit take @PMCode nvarchar(10) (the column is nvarchar(12)): longer codes would be cut silently.</summary>
    public const int CodeLength = 10;
    public const int DescriptionLength = 50;

    /// <summary>The PMCategory column is nvarchar(10).</summary>
    public const int CategoryLength = 10;
}

public sealed record SavePmDataCommand(
    SaveMode Mode,
    string PmCode,
    string PmDescription,
    string PmCategory,
    int ReorderLevel,
    decimal PmWeight,
    decimal Cbm,
    bool GetJokersCount,
    bool GetPartsCount,
    bool IsActive);

/// <summary>
/// Messages are the legacy page's toasts, in the legacy order: description, code (New only), then the three numbers.
/// The legacy page also showed "can not be select Get Jokers Count and Get Parts Count both check box" and then saved
/// anyway (a missing <c>return</c>); this refuses the save with that text. Lengths are the stored-procedure parameter
/// sizes (the legacy page had no limits and SQL Server cut the values silently).
/// </summary>
public sealed class SavePmDataValidator : AbstractValidator<SavePmDataCommand>
{
    public const string DescriptionRequired = "Enter Description";
    public const string CodeRequired = "Enter PM Code";
    public const string ReorderNegative = "Reorder Level must be positive number";
    public const string WeightNegative = "PM Weight must be positive number";
    public const string CbmNegative = "CBM must be positive number";
    public const string BothCounts = "can not be select Get Jokers Count and Get Parts Count both check box";

    public SavePmDataValidator()
    {
        RuleFor(c => c.PmDescription)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(DescriptionRequired)
            .MaximumLength(PmMasterRules.DescriptionLength);
        RuleFor(c => c.PmCode)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(CodeRequired).When(c => c.Mode == SaveMode.New)
            .MaximumLength(PmMasterRules.CodeLength);
        RuleFor(c => c.ReorderLevel).GreaterThanOrEqualTo(0).WithMessage(ReorderNegative);
        RuleFor(c => c.PmWeight).GreaterThanOrEqualTo(0).WithMessage(WeightNegative).PrecisionScale(18, 2, true);
        RuleFor(c => c.Cbm).GreaterThanOrEqualTo(0).WithMessage(CbmNegative).PrecisionScale(18, 2, true);
        RuleFor(c => c.PmCategory).NotEmpty().MaximumLength(PmMasterRules.CategoryLength);
        RuleFor(c => c).Must(c => !(c.GetJokersCount && c.GetPartsCount)).WithMessage(BothCounts).OverridePropertyName("GetJokersCount");
    }
}

/// <summary>
/// Replaces legacy SaveApi/SavePMData: SP PMMasterAdd (Option New) or PMMasterEdit (Option Change) with the nine page
/// values, inside the request's transaction. The SPs write no audit user. The legacy page checked first (getPMData) that
/// the code does not exist (New: "Meterial Code Already Exist") or does exist (Change: "Meterial Code not Exist"); the
/// server now enforces the same rule in the same transaction (409 / 404). The category must be one of PMCategories (the
/// legacy select offered nothing else).
/// </summary>
public sealed class SavePmDataHandler(IPackingMaterialRepository repository, IValidator<SavePmDataCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string AlreadyExists = "PM_CODE_EXISTS";
    public const string DoesNotExist = "PM_CODE_NOT_FOUND";
    public const string InvalidCategory = "Select a valid PM Category";

    public async Task<Result<SavePmMasterResultDto>> HandleAsync(SavePmDataCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        var categories = await repository.GetCategoriesAsync(cancellationToken);
        if (!categories.Any(c => string.Equals(c.PmCategory.TrimEnd(), command.PmCategory.TrimEnd(), StringComparison.OrdinalIgnoreCase)))
        {
            throw new ValidationException([new ValidationFailure(nameof(command.PmCategory), InvalidCategory)]);
        }

        var exists = await repository.FindAsync(command.PmCode, cancellationToken) is not null;
        if (command.Mode == SaveMode.New && exists)
        {
            throw new AppException(AlreadyExists, 409);
        }

        if (command.Mode == SaveMode.Change && !exists)
        {
            throw new NotFoundException(DoesNotExist);
        }

        var values = new PackingMaterialValues(
            command.PmCode, command.PmDescription, command.PmCategory, command.ReorderLevel, command.PmWeight, command.Cbm,
            command.GetJokersCount, command.GetPartsCount, command.IsActive);
        if (command.Mode == SaveMode.New)
        {
            await repository.AddAsync(values, cancellationToken);
        }
        else
        {
            await repository.UpdateAsync(values, cancellationToken);
        }

        return Result<SavePmMasterResultDto>.Success(new SavePmMasterResultDto(command.PmCode, SavedMessage));
    }
}

using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;
using FluentValidation.Results;

namespace CIMSNextMCC.Application.MasterData.ProductCategory;

/// <summary>Field sizes of dbo.ContractsChainCodes / the InsertContractsChainCodes parameters.</summary>
public static class ChainCodeRules
{
    public const int CodeLength = 1;
    public const int NameLength = 50;
    public const int TpPartnerLength = 20;
    public const int RangeLength = 20;
    public const int EanLength = 10;
}

public sealed record SaveChainCodeCommand(string ChainCode, string ChainName, string Range, string TpPartnerName, string RangeBoxEan);

/// <summary>
/// Messages are the legacy page's toasts, in the legacy order (code empty, code length, name, range, TP partner, EAN).
/// Maximum lengths are the stored-procedure parameter sizes; the legacy page had none and SQL Server cut longer values silently.
/// </summary>
public sealed class SaveChainCodeValidator : AbstractValidator<SaveChainCodeCommand>
{
    public const string CodeRequired = "Can not be empty Chain Code";
    public const string CodeLengthMessage = "Chain Code must be exactly 1 character long";
    public const string NameRequired = "Can not be empty Chain Name";
    public const string RangeRequired = "Can not be empty Range";
    public const string TpPartnerRequired = "Can not be empty TP Partner Name";
    public const string EanRequired = "Can not be empty Range Box EAN";

    public SaveChainCodeValidator()
    {
        RuleFor(c => c.ChainCode)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(CodeRequired)
            .Must(v => v.Length == ChainCodeRules.CodeLength).WithMessage(CodeLengthMessage);
        RuleFor(c => c.ChainName)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(NameRequired)
            .MaximumLength(ChainCodeRules.NameLength).WithMessage($"Chain Name can not be longer than {ChainCodeRules.NameLength} characters");
        RuleFor(c => c.Range)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(RangeRequired)
            .MaximumLength(ChainCodeRules.RangeLength).WithMessage($"Range can not be longer than {ChainCodeRules.RangeLength} characters");
        RuleFor(c => c.TpPartnerName)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(TpPartnerRequired)
            .MaximumLength(ChainCodeRules.TpPartnerLength).WithMessage($"TP Partner Name can not be longer than {ChainCodeRules.TpPartnerLength} characters");
        RuleFor(c => c.RangeBoxEan)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(EanRequired)
            .MaximumLength(ChainCodeRules.EanLength).WithMessage($"Range Box EAN can not be longer than {ChainCodeRules.EanLength} characters");
    }
}

/// <summary>
/// Replaces legacy SaveApi/SaveContractsChainCodes: SP InsertContractsChainCodes with the five page values inside the
/// request's transaction; the SP writes no audit user. The legacy page refused a chain code that is already in the grid
/// (compared case-insensitively, "Can not Duplicate same Chain Code") in the browser only; the server now enforces the same
/// rule in the same transaction (409). The range must be one of ContractsChainCodesCategory (the legacy select offered
/// nothing else).
/// </summary>
public sealed class SaveChainCodeHandler(IContractChainCodeRepository repository, IValidator<SaveChainCodeCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string AlreadyExists = "CHAIN_CODE_EXISTS";
    public const string InvalidRange = "Select a valid Range";

    public async Task<Result<SaveChainCodeResultDto>> HandleAsync(SaveChainCodeCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        var ranges = await repository.GetRangesAsync(cancellationToken);
        if (!ranges.Any(r => string.Equals(r.Category.TrimEnd(), command.Range.TrimEnd(), StringComparison.OrdinalIgnoreCase)))
        {
            throw new ValidationException([new ValidationFailure(nameof(command.Range), InvalidRange)]);
        }

        var existing = await repository.GetAllAsync(cancellationToken);
        if (existing.Any(r => string.Equals(r.ChainCode.TrimEnd(), command.ChainCode.TrimEnd(), StringComparison.OrdinalIgnoreCase)))
        {
            throw new AppException(AlreadyExists, 409);
        }

        await repository.AddAsync(command.ChainCode, command.ChainName, command.TpPartnerName, command.Range, command.RangeBoxEan, cancellationToken);
        return Result<SaveChainCodeResultDto>.Success(new SaveChainCodeResultDto(command.ChainCode, SavedMessage));
    }
}

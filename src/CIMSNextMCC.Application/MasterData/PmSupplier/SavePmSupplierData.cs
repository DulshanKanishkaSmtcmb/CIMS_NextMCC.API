using System.Linq.Expressions;
using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Application.MasterData.Supplier;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.PmSupplier;

/// <summary>Field sizes of dbo.PMSupplier / the stored-procedure parameters.</summary>
public static class PmSupplierRules
{
    public const int CodeLength = 5;
    public const int TextLength = 50;
    public const int NameLength = 50;
    public const int CountryCodeLength = 10;
}

/// <param name="PmSupplierCode">Empty for Mode New (the code is generated); the existing code for Mode Change.</param>
public sealed record SavePmSupplierDataCommand(
    SaveMode Mode,
    string PmSupplierCode,
    string PmSupplierName,
    string PmSupplierAddress1,
    string PmSupplierAddress2,
    string PmSupplierAddress3,
    string PmSupplierAddress4,
    string PmSupplierContact1,
    string PmSupplierContact2,
    string PmSupplierContact3,
    string PmSupplierTel,
    string PmSupplierEmail,
    string PmSupplierFax,
    string CountryCode);

/// <summary>
/// The legacy page only checked "Enter Supplier Name" (the Change code was checked by the existence lookup, which says
/// "Supplier Code not Exist"). Lengths are the stored-procedure parameter sizes (legacy let SQL Server truncate silently).
/// </summary>
public sealed class SavePmSupplierDataValidator : AbstractValidator<SavePmSupplierDataCommand>
{
    public const string NameRequired = "Enter Supplier Name";
    public const string CodeRequired = "Enter Supplier Code";

    public SavePmSupplierDataValidator()
    {
        RuleFor(c => c.PmSupplierName)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(NameRequired)
            .MaximumLength(PmSupplierRules.NameLength);
        RuleFor(c => c.PmSupplierCode)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(CodeRequired)
            .MaximumLength(PmSupplierRules.CodeLength)
            .When(c => c.Mode == SaveMode.Change);

        foreach (var text in new Expression<Func<SavePmSupplierDataCommand, string>>[]
                 {
                     c => c.PmSupplierAddress1, c => c.PmSupplierAddress2, c => c.PmSupplierAddress3, c => c.PmSupplierAddress4,
                     c => c.PmSupplierContact1, c => c.PmSupplierContact2, c => c.PmSupplierContact3,
                     c => c.PmSupplierTel, c => c.PmSupplierEmail, c => c.PmSupplierFax,
                 })
        {
            RuleFor(text).NotNull().MaximumLength(PmSupplierRules.TextLength);
        }

        RuleFor(c => c.CountryCode).NotNull().MaximumLength(PmSupplierRules.CountryCodeLength);
    }
}

/// <summary>
/// Replaces legacy SaveApi/SavePMSupplierData: SP PMSupplierAdd (Option New) or PMSupplierEdit (Option Change), inside the
/// request's transaction. Neither SP takes an audit user (and the table has no audit columns). New: the code is the first
/// character of the name plus the next four-digit number for that character (<see cref="SupplierCodeSequence"/>, read with
/// an update lock inside the transaction; legacy read it outside). Change: 404 when the code does not exist (legacy: the
/// page check "Supplier Code not Exist").
/// </summary>
public sealed class SavePmSupplierDataHandler(IPmSupplierRepository repository, IValidator<SavePmSupplierDataCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string DoesNotExist = "PM_SUPPLIER_CODE_NOT_FOUND";

    public async Task<Result<SavePmSupplierResultDto>> HandleAsync(SavePmSupplierDataCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        if (command.Mode == SaveMode.Change && await repository.FindAsync(command.PmSupplierCode, cancellationToken) is null)
        {
            throw new NotFoundException(DoesNotExist);
        }

        if (command.Mode == SaveMode.New)
        {
            var prefix = command.PmSupplierName[..1];
            var code = SupplierCodeSequence.Next(prefix, await repository.GetLastCodeAsync(prefix, cancellationToken));
            await repository.AddAsync(ToWrite(command, code), cancellationToken);
            return Result<SavePmSupplierResultDto>.Success(new SavePmSupplierResultDto(code, SavedMessage));
        }

        await repository.UpdateAsync(ToWrite(command, command.PmSupplierCode), cancellationToken);
        return Result<SavePmSupplierResultDto>.Success(new SavePmSupplierResultDto(command.PmSupplierCode, SavedMessage));
    }

    private static PmSupplierWrite ToWrite(SavePmSupplierDataCommand c, string code) =>
        new(
            code,
            c.PmSupplierName,
            c.PmSupplierAddress1,
            c.PmSupplierAddress2,
            c.PmSupplierAddress3,
            c.PmSupplierAddress4,
            c.PmSupplierContact1,
            c.PmSupplierContact2,
            c.PmSupplierContact3,
            c.PmSupplierTel,
            c.PmSupplierEmail,
            c.PmSupplierFax,
            c.CountryCode);
}

using System.Linq.Expressions;
using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Common.Security;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Supplier;

/// <summary>Field sizes of dbo.Shipper / the stored-procedure parameters.</summary>
public static class SupplierRules
{
    public const int CodeLength = 5;
    public const int TextLength = 50;
    public const int NameLength = 50;
    public const int CountryCodeLength = 10;
    public const int FreightCodeLength = 5;
    public const int LimaCodeLength = 10;
}

/// <param name="ShipperCode">Empty for Mode New (the code is generated); the existing code for Mode Change.</param>
public sealed record SaveSupplierDataCommand(
    SaveMode Mode,
    string ShipperCode,
    string ShipperName,
    string ShipperAddress1,
    string ShipperAddress2,
    string ShipperAddress3,
    string ShipperAddress4,
    string ShipperContact1,
    string ShipperContact2,
    string ShipperContact3,
    string ShipperTel,
    string ShipperEmail,
    string ShipperFax,
    string CountryCode,
    string ShipperCodeAir,
    string ShipperCodeSea,
    string LimaSupplierCode,
    string RexNo);

/// <summary>
/// Messages are the legacy page's, in the legacy order: "Enter Supplier Name", then (Change) "Supplier Name should be
/// Starting with X" (the browser compared the first character of the code with that of the name, case-sensitively) and
/// "Enter Supplier Code". Lengths are the stored-procedure parameter sizes (legacy let SQL Server truncate silently).
/// </summary>
public sealed class SaveSupplierDataValidator : AbstractValidator<SaveSupplierDataCommand>
{
    public const string NameRequired = "Enter Supplier Name";
    public const string CodeRequired = "Enter Supplier Code";

    public static string NameMustStartWith(char first) => $"Supplier Name should be Starting with {first}";

    public SaveSupplierDataValidator()
    {
        RuleFor(c => c.ShipperName)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(NameRequired)
            .MaximumLength(SupplierRules.NameLength);
        RuleFor(c => c.ShipperName)
            .Must((c, name) => name[0] == c.ShipperCode[0])
            .WithMessage(c => NameMustStartWith(c.ShipperCode[0]))
            .When(c => c.Mode == SaveMode.Change && !string.IsNullOrEmpty(c.ShipperName) && !string.IsNullOrEmpty(c.ShipperCode));
        RuleFor(c => c.ShipperCode)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(CodeRequired)
            .MaximumLength(SupplierRules.CodeLength)
            .When(c => c.Mode == SaveMode.Change);

        foreach (var text in new Expression<Func<SaveSupplierDataCommand, string>>[]
                 {
                     c => c.ShipperAddress1, c => c.ShipperAddress2, c => c.ShipperAddress3, c => c.ShipperAddress4,
                     c => c.ShipperContact1, c => c.ShipperContact2, c => c.ShipperContact3,
                     c => c.ShipperTel, c => c.ShipperEmail, c => c.ShipperFax, c => c.RexNo,
                 })
        {
            RuleFor(text).NotNull().MaximumLength(SupplierRules.TextLength);
        }

        RuleFor(c => c.CountryCode).NotNull().MaximumLength(SupplierRules.CountryCodeLength);
        RuleFor(c => c.ShipperCodeAir).NotNull().MaximumLength(SupplierRules.FreightCodeLength);
        RuleFor(c => c.ShipperCodeSea).NotNull().MaximumLength(SupplierRules.FreightCodeLength);
        RuleFor(c => c.LimaSupplierCode).NotNull().MaximumLength(SupplierRules.LimaCodeLength);
    }
}

/// <summary>
/// Replaces legacy SaveApi/SaveSupplierData: SP ShipperAdd (Option New: CreateBy) or ShipperEdit (Option Change: UpdateBy)
/// with the caller's PwInfo.UserId as the audit user, inside the request's transaction.
/// <para>
/// New: the code is generated here, as legacy did: the first character of the name plus the next four-digit number for
/// that character. Legacy read the highest code on a separate connection before opening the transaction (two saves at the
/// same moment got the same code, and the table has no unique key); here the read takes an update lock inside the
/// transaction, so the second save waits and gets the next number.
/// </para>
/// <para>
/// Change: the legacy page checked first (getSupplierData) that the code exists ("Supplier Code not Exist"); the server
/// now enforces it (404) in the same transaction.
/// </para>
/// </summary>
public sealed class SaveSupplierDataHandler(
    ISupplierRepository repository,
    LegacyAuditUserResolver auditUser,
    IValidator<SaveSupplierDataCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string DoesNotExist = "SUPPLIER_CODE_NOT_FOUND";

    public async Task<Result<SaveSupplierResultDto>> HandleAsync(SaveSupplierDataCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        if (command.Mode == SaveMode.Change && await repository.FindAsync(command.ShipperCode, cancellationToken) is null)
        {
            throw new NotFoundException(DoesNotExist);
        }

        var user = await auditUser.ResolveAsync(cancellationToken);
        if (command.Mode == SaveMode.New)
        {
            var prefix = command.ShipperName[..1];
            var code = SupplierCodeSequence.Next(prefix, await repository.GetLastCodeAsync(prefix, cancellationToken));
            await repository.AddAsync(ToWrite(command, code), user, cancellationToken);
            return Result<SaveSupplierResultDto>.Success(new SaveSupplierResultDto(code, SavedMessage));
        }

        await repository.UpdateAsync(ToWrite(command, command.ShipperCode), user, cancellationToken);
        return Result<SaveSupplierResultDto>.Success(new SaveSupplierResultDto(command.ShipperCode, SavedMessage));
    }

    private static SupplierWrite ToWrite(SaveSupplierDataCommand c, string code) =>
        new(
            code,
            c.ShipperName,
            c.ShipperAddress1,
            c.ShipperAddress2,
            c.ShipperAddress3,
            c.ShipperAddress4,
            c.ShipperContact1,
            c.ShipperContact2,
            c.ShipperContact3,
            c.ShipperCodeAir,
            c.ShipperCodeSea,
            c.ShipperTel,
            c.ShipperEmail,
            c.ShipperFax,
            c.CountryCode,
            c.LimaSupplierCode,
            c.RexNo);
}

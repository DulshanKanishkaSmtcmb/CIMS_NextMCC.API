using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Common.Security;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Country;

/// <summary>Field sizes of dbo.Country / the stored-procedure parameters, and the Cargo Movement choices of the page.</summary>
public static class CountryRules
{
    public const int CodeLength = 10;
    public const int NameLength = 50;

    /// <summary>The page's "Cargo Movement" select, in its order.</summary>
    public static readonly string[] CargoMovements = ["Imports", "Export", "Both"];
}

public sealed record SaveCountryDataCommand(SaveMode Mode, string CountryCode, string CountryName, string CargoMovement);

/// <summary>
/// Messages are the legacy page's toasts, in the legacy order (name is checked before code). Lengths are the stored
/// procedure parameter sizes (legacy let SQL Server raise a truncation error inside the transaction).
/// </summary>
public sealed class SaveCountryDataValidator : AbstractValidator<SaveCountryDataCommand>
{
    public const string NameRequired = "Enter Country Name";
    public const string CodeRequired = "Enter Country Code";
    public const string CargoMovementInvalid = "Cargo Movement must be Imports, Export or Both";

    public SaveCountryDataValidator()
    {
        RuleFor(c => c.CountryName)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(NameRequired)
            .MaximumLength(CountryRules.NameLength);
        RuleFor(c => c.CountryCode)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(CodeRequired)
            .MaximumLength(CountryRules.CodeLength);
        RuleFor(c => c.CargoMovement)
            .Must(v => v is not null && CountryRules.CargoMovements.Contains(v)).WithMessage(CargoMovementInvalid);
    }
}

/// <summary>
/// Replaces legacy SaveApi/SaveCountryData: SP CountryAdd (Option New: code, name, cargo movement, EnterBy) or CountryEdit
/// (Option Change: UpdateBy), with the caller's PwInfo.UserId as the audit user, inside the request's transaction.
/// The legacy page checked first (getCountryData) that the code does not exist (New: "Country Code Already Exist") or does
/// exist (Change: "Country Code not Exist"); the server now enforces the same rule in the same transaction
/// (409 / 404), so a second client or a race cannot hit the primary key error or update nothing.
/// </summary>
public sealed class SaveCountryDataHandler(
    ICountryRepository repository,
    LegacyAuditUserResolver auditUser,
    IValidator<SaveCountryDataCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string AlreadyExists = "COUNTRY_CODE_EXISTS";
    public const string DoesNotExist = "COUNTRY_CODE_NOT_FOUND";

    public async Task<Result<SaveCountryResultDto>> HandleAsync(SaveCountryDataCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        var exists = await repository.FindAsync(command.CountryCode, cancellationToken) is not null;
        if (command.Mode == SaveMode.New && exists)
        {
            throw new AppException(AlreadyExists, 409);
        }

        if (command.Mode == SaveMode.Change && !exists)
        {
            throw new NotFoundException(DoesNotExist);
        }

        var user = await auditUser.ResolveAsync(cancellationToken);
        if (command.Mode == SaveMode.New)
        {
            await repository.AddAsync(command.CountryCode, command.CountryName, command.CargoMovement, user, cancellationToken);
        }
        else
        {
            await repository.UpdateAsync(command.CountryCode, command.CountryName, command.CargoMovement, user, cancellationToken);
        }

        return Result<SaveCountryResultDto>.Success(new SaveCountryResultDto(command.CountryCode, SavedMessage));
    }
}

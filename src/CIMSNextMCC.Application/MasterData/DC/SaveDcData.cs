using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.DC;

/// <summary>Field sizes of dbo.DestWarehouse / the stored-procedure parameters.</summary>
public static class DcRules
{
    public const int NameLength = 50;
    public const int CountryCodeLength = 10;
    public const int CodeLength = 10;

    /// <summary>
    /// Legacy SaveDCData always sends WhCode " " (one space): the page has no DC code field. Kept so new rows look the same.
    /// </summary>
    public const string LegacyWhCode = " ";
}

public sealed record SaveDcDataCommand(SaveMode Mode, string WhDes, string CountryCode);

/// <summary>
/// The legacy page only checked "Enter DC Name" (the Country Code can stay empty). Lengths are the stored-procedure
/// parameter sizes.
/// </summary>
public sealed class SaveDcDataValidator : AbstractValidator<SaveDcDataCommand>
{
    public const string NameRequired = "Enter DC Name";

    public SaveDcDataValidator()
    {
        RuleFor(c => c.WhDes)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(NameRequired)
            .MaximumLength(DcRules.NameLength);
        RuleFor(c => c.CountryCode).NotNull().MaximumLength(DcRules.CountryCodeLength);
    }
}

/// <summary>
/// Replaces legacy SaveApi/SaveDCData: SP DestWarehouseAdd (Option New) or DestWarehouseEdit (Option Change; the SP only
/// updates CountryCode of the row with that WhDes), both with WhCode " ", inside the request's transaction. No audit user
/// is written (the SPs take none). The legacy page checked first (getDCData) that the DC does not exist (New: "DC Already
/// Exist") or does exist (Change: "DC not Exist"); the server now enforces the same rule in the same transaction (409 / 404).
/// </summary>
public sealed class SaveDcDataHandler(IDcRepository repository, IValidator<SaveDcDataCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string AlreadyExists = "DC_EXISTS";
    public const string DoesNotExist = "DC_NOT_FOUND";

    public async Task<Result<SaveDcResultDto>> HandleAsync(SaveDcDataCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        var exists = await repository.FindAsync(command.WhDes, cancellationToken) is not null;
        if (command.Mode == SaveMode.New && exists)
        {
            throw new AppException(AlreadyExists, 409);
        }

        if (command.Mode == SaveMode.Change && !exists)
        {
            throw new NotFoundException(DoesNotExist);
        }

        if (command.Mode == SaveMode.New)
        {
            await repository.AddAsync(DcRules.LegacyWhCode, command.WhDes, command.CountryCode, cancellationToken);
        }
        else
        {
            await repository.UpdateAsync(DcRules.LegacyWhCode, command.WhDes, command.CountryCode, cancellationToken);
        }

        return Result<SaveDcResultDto>.Success(new SaveDcResultDto(command.WhDes, SavedMessage));
    }
}

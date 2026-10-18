using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Common.Security;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Ports;

/// <summary>Field sizes of dbo.Ports / the stored-procedure parameters.</summary>
public static class PortRules
{
    public const int CodeLength = 10;
    public const int NameLength = 50;
}

public sealed record SavePortDataCommand(SaveMode Mode, string PortCode, string PortName, string CountryCode, bool IsDivertable);

/// <summary>
/// Messages are the legacy page's toasts, in the legacy order (name is checked before code). The legacy page did not
/// require a Country Code (a port can be saved with an empty one; the Test database has such a row), so neither does this.
/// Lengths are the stored-procedure parameter sizes.
/// </summary>
public sealed class SavePortDataValidator : AbstractValidator<SavePortDataCommand>
{
    public const string NameRequired = "Enter Port Name";
    public const string CodeRequired = "Enter Port Code";

    public SavePortDataValidator()
    {
        RuleFor(c => c.PortName)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(NameRequired)
            .MaximumLength(PortRules.NameLength);
        RuleFor(c => c.PortCode)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(CodeRequired)
            .MaximumLength(PortRules.CodeLength);
        RuleFor(c => c.CountryCode).NotNull().MaximumLength(PortRules.CodeLength);
    }
}

/// <summary>
/// Replaces legacy SaveApi/SavePortData: SP PortsAdd (Option New, CreateBy) or PortsEdit (Option Change, UpdateBy) with
/// the caller's PwInfo.UserId as the audit user, inside the request's transaction. The legacy page checked first
/// (getPortData) that the code does not exist (New: "Port Code Already Exist") or does exist (Change: "Port Code not
/// Exist"); the server now enforces the same rule in the same transaction (409 / 404).
/// </summary>
public sealed class SavePortDataHandler(
    IPortRepository repository,
    LegacyAuditUserResolver auditUser,
    IValidator<SavePortDataCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string AlreadyExists = "PORT_CODE_EXISTS";
    public const string DoesNotExist = "PORT_CODE_NOT_FOUND";

    public async Task<Result<SavePortResultDto>> HandleAsync(SavePortDataCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        var exists = await repository.FindAsync(command.PortCode, cancellationToken) is not null;
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
            await repository.AddAsync(command.PortCode, command.PortName, command.CountryCode, command.IsDivertable, user, cancellationToken);
        }
        else
        {
            await repository.UpdateAsync(command.PortCode, command.PortName, command.CountryCode, command.IsDivertable, user, cancellationToken);
        }

        return Result<SavePortResultDto>.Success(new SavePortResultDto(command.PortCode, SavedMessage));
    }
}

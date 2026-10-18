using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.Arrivals;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using FluentValidation;

namespace CIMSNextMCC.Application.Arrivals.ConfirmArrival;

/// <summary>Confirms the arrival of the selected contracts (legacy SaveApi/SaveContractConfirmArrival).</summary>
/// <param name="ArrivalDate">The "Arrival Date [dd/mm/yyyy hh:mm]" as a local date-time without offset, e.g. 2026-10-18T14:30:00.</param>
/// <param name="RcvNos">The RcvNo of every row in "PO Listing - Selected", in grid order (duplicates allowed, as on the legacy page).</param>
/// <param name="Container">
/// The first ticked container line, if any. Legacy posts every ticked container but saves only the first one
/// (docs/13 section 1.8 Q4); the page now sends just that one.
/// </param>
public sealed record ConfirmArrivalCommand(
    DateTime ArrivalDate,
    IReadOnlyList<string> RcvNos,
    ConfirmArrivalContainer? Container);

/// <summary>A ticked container line; ContainerNo may have been edited on the page.</summary>
public sealed record ConfirmArrivalContainer(
    DateTime? InboundEtd,
    decimal VesselOrderNo,
    string VesselName,
    decimal ContainerOrderNo,
    string LoadReference,
    string ContainerNo,
    string ContainerType);

/// <summary>
/// Legacy messages where the legacy page or action had one; lengths are the stored-procedure parameter sizes, which the
/// legacy code did not check (SQL Server raised a truncation error inside the transaction instead).
/// </summary>
public sealed class ConfirmArrivalValidator : AbstractValidator<ConfirmArrivalCommand>
{
    public const string ArrivalDateRequired = "Enter Confirm Arrival Date";
    public const string ArrivalDateLocal = "Send the arrival date as local time without an offset";
    public const string NoContracts = "Contract Data not found.[Empty List]";

    public ConfirmArrivalValidator()
    {
        RuleFor(c => c.ArrivalDate)
            .NotEqual(default(DateTime)).WithMessage(ArrivalDateRequired)
            .Must(d => d.Kind != DateTimeKind.Utc).WithMessage(ArrivalDateLocal);

        RuleFor(c => c.RcvNos)
            .NotEmpty().WithMessage(NoContracts);

        RuleForEach(c => c.RcvNos)
            .NotEmpty()
            .MaximumLength(10);

        When(c => c.Container is not null, () =>
        {
            RuleFor(c => c.Container!.VesselName).NotNull().MaximumLength(50);
            RuleFor(c => c.Container!.ContainerNo).NotNull().MaximumLength(20);
            RuleFor(c => c.Container!.ContainerType).NotNull().MaximumLength(10);
            RuleFor(c => c.Container!.LoadReference).NotNull().MaximumLength(50);
        });
    }
}

/// <summary>
/// Replaces legacy SaveApi/SaveContractConfirmArrival, step for step, inside the request's single transaction
/// (TransactionMiddleware: committed on success, rolled back on any error, like the legacy SqlTransaction):
/// <list type="number">
/// <item>container line with VesselOrderNo != 0: SP VesselRegistryImportConfirmArrival (vessel name);</item>
/// <item>container line with ContainerOrderNo != 0: SP ContainerDataImportEdit (container no/type, load reference,
/// UpdateBy = the caller's PwInfo.UserId, as legacy ReverseMiddle(claim 1));</item>
/// <item>every RcvNo in order: SP CargoReceivedConfirmArrival with ConfirmArriveStatus "Update", the arrival date
/// and ConfirmArriveBy "" (legacy always sent an empty string; kept for parity, docs/13 section 1.8 Q2).</item>
/// </list>
/// Like the legacy SP, a row that is no longer pending is updated again (no status check).
/// </summary>
public sealed class ConfirmArrivalHandler(
    IConfirmArrivalRepository repository,
    ILegacyUserRepository legacyUsers,
    ICurrentUser currentUser,
    IValidator<ConfirmArrivalCommand> validator)
{
    public const string ConfirmedStatus = "Update";
    public const string LegacyConfirmArriveBy = "";
    public const string SavedMessage = "Data Saved Successfully";
    public const string LegacyUserNotFound = "LEGACY_USER_NOT_FOUND";

    public async Task<Result<ConfirmArrivalResultDto>> HandleAsync(
        ConfirmArrivalCommand command,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        var vesselUpdated = false;
        var containerUpdated = false;
        var container = command.Container;

        if (container is not null)
        {
            if (container.VesselOrderNo != 0)
            {
                await repository.UpdateImportVesselAsync(
                    container.InboundEtd, container.VesselOrderNo, container.VesselName, cancellationToken);
                vesselUpdated = true;
            }

            if (container.ContainerOrderNo != 0)
            {
                var updateBy = await ResolveLegacyUserIdAsync(cancellationToken);
                await repository.UpdateImportContainerAsync(
                    new ImportContainerUpdate(
                        container.InboundEtd,
                        container.VesselOrderNo,
                        container.ContainerOrderNo,
                        container.ContainerNo,
                        container.ContainerType,
                        updateBy,
                        container.LoadReference),
                    cancellationToken);
                containerUpdated = true;
            }
        }

        foreach (var rcvNo in command.RcvNos)
        {
            await repository.ConfirmArrivalAsync(
                rcvNo, ConfirmedStatus, command.ArrivalDate, LegacyConfirmArriveBy, cancellationToken);
        }

        return Result<ConfirmArrivalResultDto>.Success(
            new ConfirmArrivalResultDto(command.RcvNos.Count, vesselUpdated, containerUpdated, SavedMessage));
    }

    // TODO(docs/09 section 4.2 item 4): take the legacy UserId from ICurrentUser once its local lookup exists.
    private async Task<string> ResolveLegacyUserIdAsync(CancellationToken cancellationToken)
    {
        var users = await legacyUsers.FindByUserNameAsync(currentUser.UserName, cancellationToken);
        if (users.Count != 1 || string.IsNullOrEmpty(users[0].UserId))
        {
            throw new ForbiddenException(LegacyUserNotFound);
        }

        return users[0].UserId!;
    }
}

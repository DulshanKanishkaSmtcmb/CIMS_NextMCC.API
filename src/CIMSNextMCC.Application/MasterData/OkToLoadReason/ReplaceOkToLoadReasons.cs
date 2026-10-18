using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.OkToLoadReason;

public sealed record ReplaceOkToLoadReasonsCommand(string Dc, IReadOnlyList<OkToLoadReasonLine> Reasons);

/// <summary>
/// Messages are the legacy page's and action's texts: "DC not selected" (page), "Contract Data not found.[Empty List]"
/// (the action refuses an empty list). "Enter Reason" is new: the legacy page happily saved blank reasons, which the page
/// then hid on the next load. Lengths are the stored-procedure parameter sizes (legacy: SQL Server cut longer values).
/// </summary>
public sealed class ReplaceOkToLoadReasonsValidator : AbstractValidator<ReplaceOkToLoadReasonsCommand>
{
    public const string DcRequired = "DC not selected";
    public const string EmptyList = "Contract Data not found.[Empty List]";
    public const string ReasonRequired = "Enter Reason";

    public ReplaceOkToLoadReasonsValidator()
    {
        RuleFor(c => c.Dc)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrWhiteSpace(v)).WithMessage(DcRequired)
            .MaximumLength(OkToLoadReasonRules.DcLength);
        RuleFor(c => c.Reasons)
            .Cascade(CascadeMode.Stop)
            .Must(v => v is { Count: > 0 }).WithMessage(EmptyList);
        RuleForEach(c => c.Reasons).ChildRules(line =>
        {
            line.RuleFor(l => l.Reason)
                .Cascade(CascadeMode.Stop)
                .Must(v => !string.IsNullOrWhiteSpace(v)).WithMessage(ReasonRequired)
                .MaximumLength(OkToLoadReasonRules.ReasonLength);
            line.RuleFor(l => l.DtlReson).MaximumLength(OkToLoadReasonRules.DetailLength);
        });
    }
}

/// <summary>
/// Replaces legacy SaveApi/SaveOkToShipReason: in one transaction every row of the DC is deleted and the list is inserted
/// again through SP OkToLoadReasonAdd, with ReasonOrder = the line's position (1, 2, …) and Warehouse = the DC. The SP
/// writes no audit user. Two rules the legacy page kept in the browser only are now enforced here: the DC must exist
/// (404 <see cref="DcNotFound"/>) and a reason that contracts of the DC already carry cannot be left out of the list
/// (409 <see cref="ReasonAllocated"/>, legacy toast "This Reason is already allocated into Contracts. So not allow to Remove").
/// </summary>
public sealed class ReplaceOkToLoadReasonsHandler(
    IOkToLoadReasonRepository repository,
    IDcRepository dcRepository,
    IValidator<ReplaceOkToLoadReasonsCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string DcNotFound = "DC_NOT_FOUND";
    public const string ReasonAllocated = "REASON_ALLOCATED";

    public async Task<Result<ReplaceOkToLoadReasonsResultDto>> HandleAsync(ReplaceOkToLoadReasonsCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        if (await dcRepository.FindAsync(command.Dc, cancellationToken) is null)
        {
            throw new NotFoundException(DcNotFound);
        }

        // A reason of the current list that contracts carry must stay in the new list.
        var current = await repository.GetAsync(command.Dc, cancellationToken);
        var kept = command.Reasons.Select(l => l.Reason).ToList();
        foreach (var name in await repository.GetAllocatedReasonsAsync(command.Dc, cancellationToken))
        {
            var index = GetOkToLoadReasonsHandler.FirstIndex(current.Select(r => r.Reason), name);
            if (index >= 0 && !kept.Any(k => GetOkToLoadReasonsHandler.Same(k, current[index].Reason)))
            {
                throw new AppException(ReasonAllocated, 409);
            }
        }

        await repository.DeleteByDcAsync(command.Dc, cancellationToken);
        for (var i = 0; i < command.Reasons.Count; i++)
        {
            var line = command.Reasons[i];
            await repository.AddAsync(line.Reason, i + 1, line.DtlReson ?? string.Empty, command.Dc, cancellationToken);
        }

        return Result<ReplaceOkToLoadReasonsResultDto>.Success(
            new ReplaceOkToLoadReasonsResultDto(command.Dc, command.Reasons.Count, SavedMessage));
    }
}

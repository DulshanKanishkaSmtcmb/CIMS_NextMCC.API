using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.PalletRack;

/// <summary>Limits of dbo.PalletRacks / dbo.PalletRacksUtilization and of the pages' layout (rows up to 99, layers up to 12).</summary>
public static class PalletRackRules
{
    public const int RackNoLength = 10;
    public const int PositionNoLength = 10;
    public const int MaxRows = 99;
    public const int MaxLayers = 12;
}

public sealed record CreatePalletRackCommand(string RackNo, decimal NofRows, decimal NofLayers, decimal NofPositions, IReadOnlyList<string> Positions);

/// <summary>
/// Messages are the legacy pages' toasts, in the legacy order (rack, rows, layers, then "Nothing to save any Pallet
/// Positions"). The two "must be less than" texts keep the legacy wording although the legacy check lets 99 rows and 12
/// layers through. Lengths are the stored-procedure parameter sizes: the legacy pages built position numbers of
/// <c>RackNo-RR-LL</c> and SQL Server cut them silently at ten characters when the rack number had more than four.
/// </summary>
public sealed class CreatePalletRackValidator : AbstractValidator<CreatePalletRackCommand>
{
    public const string RackNoRequired = "Enter Rack No";
    public const string RowsRequired = "Enter Nof of Rows in side Rack";
    public const string RowsTooMany = "Nof of Rows must be less than 99";
    public const string LayersTooMany = "Nof of Layers must be less than 12";
    public const string NothingToSave = "Nothing to save any Pallet Positions";

    public CreatePalletRackValidator()
    {
        RuleFor(c => c.RackNo)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage(RackNoRequired)
            .MaximumLength(PalletRackRules.RackNoLength).WithMessage($"Rack No can not be longer than {PalletRackRules.RackNoLength} characters");
        RuleFor(c => c.NofRows)
            .Cascade(CascadeMode.Stop)
            .Must(v => v != 0).WithMessage(RowsRequired)
            .Must(v => v is > 0 and <= PalletRackRules.MaxRows).WithMessage(RowsTooMany);
        RuleFor(c => c.NofLayers)
            .Must(v => v is >= 0 and <= PalletRackRules.MaxLayers).WithMessage(LayersTooMany);
        RuleFor(c => c.NofPositions).GreaterThanOrEqualTo(0);
        RuleFor(c => c.Positions)
            .Cascade(CascadeMode.Stop)
            .Must(v => v is { Count: > 0 }).WithMessage(NothingToSave);
        RuleForEach(c => c.Positions)
            .Cascade(CascadeMode.Stop)
            .Must(v => !string.IsNullOrEmpty(v)).WithMessage("Position No can not be empty")
            .MaximumLength(PalletRackRules.PositionNoLength).WithMessage($"Position No can not be longer than {PalletRackRules.PositionNoLength} characters");
    }
}

/// <summary>
/// Replaces legacy SaveApi/SaveCargoPalletBuild: SP PalletRacksAdd for the rack, then SP PalletRacksUtilizationAdd for each
/// position, all inside the request's transaction (neither SP writes an audit user). The legacy page meant to check first
/// that the rack does not exist ("Pallet Rack Already Exist") but never called its own check, so the same rack and
/// positions could be added again (the tables have no key); the server now refuses a rack that exists (409).
/// </summary>
public sealed class CreatePalletRackHandler(IPalletRackRepository repository, IValidator<CreatePalletRackCommand> validator)
{
    public const string SavedMessage = "Data Saved Successfully";
    public const string AlreadyExists = "PALLET_RACK_EXISTS";

    public async Task<Result<CreatePalletRackResultDto>> HandleAsync(CreatePalletRackCommand command, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(command);
        await validator.ValidateAndThrowAsync(command, cancellationToken);

        if (await repository.FindAsync(command.RackNo, cancellationToken) is not null)
        {
            throw new AppException(AlreadyExists, 409);
        }

        await repository.AddRackAsync(command.RackNo, command.NofRows, command.NofLayers, command.NofPositions, cancellationToken);
        foreach (var position in command.Positions)
        {
            await repository.AddPositionAsync(command.RackNo, position, cancellationToken);
        }

        return Result<CreatePalletRackResultDto>.Success(new CreatePalletRackResultDto(command.RackNo, command.Positions.Count, SavedMessage));
    }
}

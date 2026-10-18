using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Ports;

public sealed record GetPortDataQuery(string PortCode);

public sealed class GetPortDataValidator : AbstractValidator<GetPortDataQuery>
{
    public GetPortDataValidator()
    {
        RuleFor(q => q.PortCode).NotNull().MaximumLength(PortRules.CodeLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getPortData (<c>select t1.* from Ports where PortCode = ...</c>), parameterized. The page uses
/// it to fill the form (Change / View) and to check whether a code exists before saving. Legacy returned an empty table
/// for an unknown code; this returns the failure code <see cref="NotFound"/> (HTTP 404).
/// </summary>
public sealed class GetPortDataHandler(IPortRepository repository, IValidator<GetPortDataQuery> validator)
{
    public const string NotFound = "PORT_NOT_FOUND";

    public async Task<Result<PortDto>> HandleAsync(GetPortDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var row = await repository.FindAsync(query.PortCode, cancellationToken);
        return row is null ? Result<PortDto>.Failure(NotFound) : Result<PortDto>.Success(PortMapping.ToDto(row));
    }
}

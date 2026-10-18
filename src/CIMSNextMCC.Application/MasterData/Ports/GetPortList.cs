using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Ports;

/// <param name="CountryCode">Only the ports of this country; null or empty = all (legacy applies the filter only when it is non-empty).</param>
public sealed record GetPortListQuery(string? CountryCode);

public sealed class GetPortListValidator : AbstractValidator<GetPortListQuery>
{
    public GetPortListValidator()
    {
        RuleFor(q => q.CountryCode).MaximumLength(PortRules.CodeLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getPortList (<c>select t1.* from Ports [where CountryCode = ...] order by PortCode</c>), used
/// by the "Ports Listing" dialog. The page sends an empty country; the PortCode filter the legacy action parses is
/// commented out in the legacy code and is not taken.
/// </summary>
public sealed class GetPortListHandler(IPortRepository repository, IValidator<GetPortListQuery> validator)
{
    public async Task<Result<IReadOnlyList<PortDto>>> HandleAsync(GetPortListQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var rows = await repository.GetAllAsync(string.IsNullOrEmpty(query.CountryCode) ? null : query.CountryCode, cancellationToken);
        IReadOnlyList<PortDto> dtos = rows.Select(PortMapping.ToDto).ToList();
        return Result<IReadOnlyList<PortDto>>.Success(dtos);
    }
}

internal static class PortMapping
{
    public static PortDto ToDto(PortMaster p) =>
        new(p.PortCode, p.PortName, p.CountryCode, p.DateCreate, p.CreateBy, p.DateUpdate, p.UpdateBy, p.SeaOrAirPort, p.IsDivertable);
}

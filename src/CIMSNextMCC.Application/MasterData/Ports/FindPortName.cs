using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Ports;

/// <param name="Name">The text typed in Port Name.</param>
/// <param name="StartsWith">Legacy isStartChrOnly: true = names that start with the text, false = names equal to it.</param>
public sealed record FindPortNameQuery(string Name, bool StartsWith);

public sealed class FindPortNameValidator : AbstractValidator<FindPortNameQuery>
{
    public FindPortNameValidator()
    {
        RuleFor(q => q.Name).NotNull().MaximumLength(PortRules.NameLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/findPortName, which feeds the "Pre-Entered Ports Listing" box under the Port Name field in
/// New mode: <c>PortCode, PortName, CountryCode</c> of the ports whose name starts with the typed text (or equals it),
/// ordered by name. The legacy <c>strRtnPara</c> (the box layout) is not taken.
/// </summary>
public sealed class FindPortNameHandler(IPortRepository repository, IValidator<FindPortNameQuery> validator)
{
    public async Task<Result<IReadOnlyList<PortNameHitDto>>> HandleAsync(FindPortNameQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var rows = await repository.SearchByNameAsync(query.Name, query.StartsWith, cancellationToken);
        IReadOnlyList<PortNameHitDto> dtos = rows.Select(r => new PortNameHitDto(r.PortCode, r.PortName, r.CountryCode)).ToList();
        return Result<IReadOnlyList<PortNameHitDto>>.Success(dtos);
    }
}

using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Supplier;

/// <param name="Name">The text typed in Supplier Name.</param>
/// <param name="StartsWith">Legacy isStartChrOnly: true = names that start with the text, false = names equal to it.</param>
public sealed record FindSupplierNameQuery(string Name, bool StartsWith);

public sealed class FindSupplierNameValidator : AbstractValidator<FindSupplierNameQuery>
{
    public FindSupplierNameValidator()
    {
        RuleFor(q => q.Name).NotNull().MaximumLength(SupplierRules.NameLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/findSupplierName, which feeds the "Pre-Entered Supplier Listing" box under the Supplier Name
/// field in New mode: <c>ShipperCode, ShipperName, ShipperAddress1..4</c> of the suppliers whose name starts with the
/// typed text (or equals it), ordered by name. The legacy <c>strRtnPara</c> (the box layout) is not taken.
/// </summary>
public sealed class FindSupplierNameHandler(ISupplierRepository repository, IValidator<FindSupplierNameQuery> validator)
{
    public async Task<Result<IReadOnlyList<SupplierNameHitDto>>> HandleAsync(
        FindSupplierNameQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var rows = await repository.SearchByNameAsync(query.Name, query.StartsWith, cancellationToken);
        IReadOnlyList<SupplierNameHitDto> dtos = rows
            .Select(r => new SupplierNameHitDto(r.ShipperCode, r.ShipperName, r.ShipperAddress1, r.ShipperAddress2, r.ShipperAddress3, r.ShipperAddress4))
            .ToList();
        return Result<IReadOnlyList<SupplierNameHitDto>>.Success(dtos);
    }
}

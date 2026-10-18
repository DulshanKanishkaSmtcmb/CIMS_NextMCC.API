using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.OkToLoadReason;

/// <summary>Field sizes of dbo.OkToLoadReason / the OkToLoadReasonAdd parameters.</summary>
public static class OkToLoadReasonRules
{
    public const int ReasonLength = 50;
    public const int DetailLength = 1000;
    public const int DcLength = 50;
}

/// <param name="Dc">The DC whose reasons are wanted. Null or empty: the reasons of every DC (legacy: no WHERE).</param>
/// <param name="CheckAllocation">Mark the reasons contracts already carry (legacy <c>chkAllocated</c>, always true on the page).</param>
public sealed record GetOkToLoadReasonsQuery(string? Dc, bool CheckAllocation);

public sealed class GetOkToLoadReasonsValidator : AbstractValidator<GetOkToLoadReasonsQuery>
{
    public GetOkToLoadReasonsValidator()
    {
        RuleFor(q => q.Dc).MaximumLength(OkToLoadReasonRules.DcLength);
    }
}

/// <summary>
/// Replaces legacy DataApi/getOkToLoadResonListUpdate (and the identical query of the page's DC select): the reasons of a
/// DC in ReasonOrder. With <c>CheckAllocation</c> the reasons that contracts of the DC already carry
/// (<c>CargoReceived.nApprvToShip</c>) are marked. Like the legacy <c>DataTable.Select("Reason='…'")</c> the match ignores
/// case and trailing blanks, and only the first reason with that name is marked.
/// </summary>
public sealed class GetOkToLoadReasonsHandler(IOkToLoadReasonRepository repository, IValidator<GetOkToLoadReasonsQuery> validator)
{
    public async Task<Result<IReadOnlyList<OkToLoadReasonDto>>> HandleAsync(GetOkToLoadReasonsQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);

        var rows = await repository.GetAsync(query.Dc, cancellationToken);
        var allocated = new bool[rows.Count];
        if (query.CheckAllocation)
        {
            foreach (var name in await repository.GetAllocatedReasonsAsync(query.Dc ?? string.Empty, cancellationToken))
            {
                var index = FirstIndex(rows.Select(r => r.Reason), name);
                if (index >= 0)
                {
                    allocated[index] = true;
                }
            }
        }

        IReadOnlyList<OkToLoadReasonDto> dtos = rows
            .Select((r, i) => new OkToLoadReasonDto(r.Reason, r.DtlReson, r.Dc, allocated[i]))
            .ToList();
        return Result<IReadOnlyList<OkToLoadReasonDto>>.Success(dtos);
    }

    internal static int FirstIndex(IEnumerable<string> reasons, string name)
    {
        var index = 0;
        foreach (var reason in reasons)
        {
            if (Same(reason, name))
            {
                return index;
            }

            index++;
        }

        return -1;
    }

    internal static bool Same(string a, string b) =>
        string.Equals(a.TrimEnd(), b.TrimEnd(), StringComparison.OrdinalIgnoreCase);
}

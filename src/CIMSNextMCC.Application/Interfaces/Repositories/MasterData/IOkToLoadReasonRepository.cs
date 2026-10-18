using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the Ok to Ship / Hold Reasons page (legacy File/OkToLoadReason). The reads are the queries of
/// DataApi/getOkToLoadResonListUpdate; the writes are the statements of SaveApi/SaveOkToShipReason and run in the request's
/// unit-of-work transaction.
/// </summary>
public interface IOkToLoadReasonRepository
{
    /// <summary>
    /// dbo.OkToLoadReason ordered by Warehouse, ReasonOrder; only the rows of <paramref name="dc"/> unless it is null or
    /// empty (legacy: the WHERE is added only for a non-empty DC).
    /// </summary>
    Task<IReadOnlyList<OkToLoadReasonRow>> GetAsync(string? dc, CancellationToken cancellationToken = default);

    /// <summary>
    /// The reasons contracts have been given in <paramref name="dc"/>: <c>select distinct nApprvToShip from CargoReceived
    /// where nApprvToShip &lt;&gt; '' and Warehouse = @dc</c> (legacy "already allocated into Contracts").
    /// </summary>
    Task<IReadOnlyList<string>> GetAllocatedReasonsAsync(string dc, CancellationToken cancellationToken = default);

    /// <summary><c>DELETE from OkToLoadReason where Warehouse = @dc</c>.</summary>
    Task DeleteByDcAsync(string dc, CancellationToken cancellationToken = default);

    /// <summary>SP OkToLoadReasonAdd @Reason nvarchar(50), @ReasonOrder decimal, @DtlReson nvarchar(1000), @Warehouse nvarchar(50).</summary>
    Task AddAsync(string reason, decimal reasonOrder, string dtlReson, string warehouse, CancellationToken cancellationToken = default);
}

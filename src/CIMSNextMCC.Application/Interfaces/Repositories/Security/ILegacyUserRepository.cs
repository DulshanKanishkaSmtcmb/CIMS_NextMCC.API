using CIMSNextMCC.Domain.Entities.Security;

namespace CIMSNextMCC.Application.Interfaces.Repositories.Security;

/// <summary>Reads dbo.PwInfo for the legacy cookie bridge (docs/09 section 4.3). Deleted with the bridge in Phase 4.</summary>
public interface ILegacyUserRepository
{
    /// <summary>
    /// At most two rows whose UserName equals <paramref name="userName"/> (column collation decides case),
    /// so the caller can tell "not found", "unique" and "ambiguous" apart.
    /// </summary>
    Task<IReadOnlyList<LegacyUser>> FindByUserNameAsync(string userName, CancellationToken cancellationToken = default);
}

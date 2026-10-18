using CIMSNextMCC.Domain.Entities.Reference;

namespace CIMSNextMCC.Application.Interfaces.Repositories.Reference;

public interface IFieldCaptionsRepository
{
    /// <summary>The first dbo.FldCaptions row, or null when the table is empty.</summary>
    Task<FldCaptions?> GetAsync(CancellationToken cancellationToken = default);
}

using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the DC master page (legacy File/DC). Writes call the same stored procedures with the same parameters
/// as legacy SaveApi/SaveDCData and run in the request's unit-of-work transaction.
/// </summary>
public interface IDcRepository
{
    /// <summary>All dbo.DestWarehouse rows ordered by WhDes (legacy DataApi/getDCList).</summary>
    Task<IReadOnlyList<DcMaster>> GetAllAsync(CancellationToken cancellationToken = default);

    /// <summary>The row whose WhDes equals <paramref name="whDes"/> (column collation), or null (legacy DataApi/getDCData).</summary>
    Task<DcMaster?> FindAsync(string whDes, CancellationToken cancellationToken = default);

    /// <summary>SP DestWarehouseAdd @WhCode, @WhDes, @CountryCode.</summary>
    Task AddAsync(string whCode, string whDes, string countryCode, CancellationToken cancellationToken = default);

    /// <summary>SP DestWarehouseEdit @WhCode, @WhDes, @CountryCode (the SP updates CountryCode of the row with that WhDes).</summary>
    Task UpdateAsync(string whCode, string whDes, string countryCode, CancellationToken cancellationToken = default);
}

using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the Pallet Rack Build pages (legacy File/PalletRackBuild and Data/PalletRackBuildArr). The reads are the
/// queries of DataApi/getPalletRacksList and getPalletRacksData (parameterized); the writes call the stored procedures of
/// SaveApi/SaveCargoPalletBuild with the same parameters and run in the request's unit-of-work transaction.
/// </summary>
public interface IPalletRackRepository
{
    /// <summary><c>select t1.* from PalletRacks t1 Order By t1.RackNo</c>.</summary>
    Task<IReadOnlyList<PalletRack>> GetAllAsync(CancellationToken cancellationToken = default);

    /// <summary>The first dbo.PalletRacks row whose RackNo equals <paramref name="rackNo"/> (column collation), or null.</summary>
    Task<PalletRack?> FindAsync(string rackNo, CancellationToken cancellationToken = default);

    /// <summary>dbo.PalletRacksUtilization rows of the rack, no ORDER BY (legacy <c>select t1.* ... where t1.RackNo = ...</c>).</summary>
    Task<IReadOnlyList<PalletRackPosition>> GetPositionsAsync(string rackNo, CancellationToken cancellationToken = default);

    /// <summary>SP PalletRacksAdd @RackNo nvarchar(10), @NofRows decimal, @NofLayers decimal, @NofPositions decimal.</summary>
    Task AddRackAsync(string rackNo, decimal nofRows, decimal nofLayers, decimal nofPositions, CancellationToken cancellationToken = default);

    /// <summary>SP PalletRacksUtilizationAdd @RackNo nvarchar(10), @PositionNo nvarchar(10).</summary>
    Task AddPositionAsync(string rackNo, string positionNo, CancellationToken cancellationToken = default);
}

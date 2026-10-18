using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.Arrivals;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using CIMSNextMCC.Domain.Entities.Arrivals;
using CIMSNextMCC.Domain.Entities.Reference;
using CIMSNextMCC.Domain.Entities.Security;

namespace CIMSNextMCC.Application.Tests.Arrivals;

/// <summary>Records every call in order, so tests can assert the legacy SP sequence.</summary>
internal sealed class FakeConfirmArrivalRepository : IConfirmArrivalRepository
{
    public List<string> Calls { get; } = [];
    public PendingArrivalFilter? LastFilter { get; private set; }
    public List<DestWarehouse> Dcs { get; init; } = [];
    public List<Country> Countries { get; init; } = [];
    public PendingArrivalSet Pending { get; init; } = new([], [], []);
    public ImportContainerUpdate? LastContainerUpdate { get; private set; }
    public string? FailOnRcvNo { get; init; }

    public Task<IReadOnlyList<DestWarehouse>> GetDcsAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<DestWarehouse>>(Dcs);

    public Task<IReadOnlyList<Country>> GetCountriesAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<Country>>(Countries);

    public Task<PendingArrivalSet> GetPendingAsync(PendingArrivalFilter filter, CancellationToken cancellationToken = default)
    {
        LastFilter = filter;
        return Task.FromResult(Pending);
    }

    public Task UpdateImportVesselAsync(DateTime? bookingDate, decimal vesselOrderNo, string vesselName, CancellationToken cancellationToken = default)
    {
        Calls.Add($"VesselRegistryImportConfirmArrival({bookingDate:yyyy-MM-dd},{vesselOrderNo},{vesselName})");
        return Task.CompletedTask;
    }

    public Task UpdateImportContainerAsync(ImportContainerUpdate update, CancellationToken cancellationToken = default)
    {
        LastContainerUpdate = update;
        Calls.Add($"ContainerDataImportEdit({update.BookingDate:yyyy-MM-dd},{update.VesselOrderNo},{update.ContainerOrderNo},{update.ContainerNo},{update.ContainerType},{update.UpdateBy},{update.NextContainerNo})");
        return Task.CompletedTask;
    }

    public Task ConfirmArrivalAsync(string rcvNo, string confirmArriveStatus, DateTime arriveDate, string confirmArriveBy, CancellationToken cancellationToken = default)
    {
        if (rcvNo == FailOnRcvNo)
        {
            throw new InvalidOperationException("simulated SQL failure");
        }

        Calls.Add($"CargoReceivedConfirmArrival({rcvNo},{confirmArriveStatus},{arriveDate:yyyy-MM-ddTHH:mm},[{confirmArriveBy}])");
        return Task.CompletedTask;
    }
}

internal sealed class FakeLegacyUserRepository(params LegacyUser[] users) : ILegacyUserRepository
{
    public int Lookups { get; private set; }

    public Task<IReadOnlyList<LegacyUser>> FindByUserNameAsync(string userName, CancellationToken cancellationToken = default)
    {
        Lookups++;
        return Task.FromResult<IReadOnlyList<LegacyUser>>(users.Where(u => u.UserName == userName).Take(2).ToList());
    }
}

internal sealed class FakeCurrentUser(string userName) : ICurrentUser
{
    public bool IsAuthenticated => true;
    public string UserKey => "sub-1";
    public string UserName => userName;
    public string? UserCategory => null;
    public string? UserLevel => null;
    public string Tenant => "NextMCC";
    public IReadOnlyList<string> AllowedDCs => [];
    public IReadOnlyList<string> AllowedShippers => [];
    public IReadOnlyList<string> MenuKeys => [];
}

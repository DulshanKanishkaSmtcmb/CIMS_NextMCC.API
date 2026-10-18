using CIMSNextMCC.Domain.Entities.Arrivals;
using CIMSNextMCC.Domain.Entities.Reference;

namespace CIMSNextMCC.Application.Interfaces.Repositories.Arrivals;

/// <summary>
/// Data access for the Confirm Arrivals page (legacy Data/ConfirmArrival). The write methods call the same stored
/// procedures with the same parameters as legacy SaveApi/SaveContractConfirmArrival and run in the request's
/// unit-of-work transaction, so one save is all or nothing, like the legacy SqlTransaction.
/// </summary>
public interface IConfirmArrivalRepository
{
    /// <summary>dbo.DestWarehouse ordered by WhDes (legacy DataApi/getDCList).</summary>
    Task<IReadOnlyList<DestWarehouse>> GetDcsAsync(CancellationToken cancellationToken = default);

    /// <summary>dbo.Country ordered by CountryCode (legacy DataApi/getCountryList).</summary>
    Task<IReadOnlyList<Country>> GetCountriesAsync(CancellationToken cancellationToken = default);

    /// <summary>Contracts, suppliers and containers pending arrival confirmation (legacy DataApi/getPendingPO4ConfirmArrival).</summary>
    Task<PendingArrivalSet> GetPendingAsync(PendingArrivalFilter filter, CancellationToken cancellationToken = default);

    /// <summary>SP VesselRegistryImportConfirmArrival @BookingDate, @VesselOrderNo, @VesselName.</summary>
    Task UpdateImportVesselAsync(DateTime? bookingDate, decimal vesselOrderNo, string vesselName, CancellationToken cancellationToken = default);

    /// <summary>
    /// SP ContainerDataImportEdit @BookingDate, @VesselOrderNo, @ContainerOrderNo, @ContainerNo, @ContainerType,
    /// @DateUpdate (unused by the SP), @UpdateBy, @NextContainerNo.
    /// </summary>
    Task UpdateImportContainerAsync(ImportContainerUpdate update, CancellationToken cancellationToken = default);

    /// <summary>SP CargoReceivedConfirmArrival @RcvNo, @ConfirmArriveStatus, @ArriveDate, @ConfirmArriveBy.</summary>
    Task ConfirmArrivalAsync(string rcvNo, string confirmArriveStatus, DateTime arriveDate, string confirmArriveBy, CancellationToken cancellationToken = default);
}

/// <summary>Parameters of SP ContainerDataImportEdit as legacy SaveContractConfirmArrival fills them.</summary>
public sealed record ImportContainerUpdate(
    DateTime? BookingDate,
    decimal VesselOrderNo,
    decimal ContainerOrderNo,
    string ContainerNo,
    string ContainerType,
    string UpdateBy,
    string NextContainerNo);

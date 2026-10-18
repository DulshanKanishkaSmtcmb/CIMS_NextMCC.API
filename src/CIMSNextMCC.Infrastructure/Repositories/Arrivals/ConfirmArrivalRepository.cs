using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.Arrivals;
using CIMSNextMCC.Domain.Entities.Arrivals;
using CIMSNextMCC.Domain.Entities.Reference;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.Arrivals;

/// <summary>
/// Ports the SQL of legacy DataApi/getDCList, getCountryList, getPendingPO4ConfirmArrival (parameterized, same filter and
/// projections) and the three stored procedures of SaveApi/SaveContractConfirmArrival (same names, parameters and types).
/// </summary>
public class ConfirmArrivalRepository : IConfirmArrivalRepository
{
    // Legacy: " t1.ConfirmArriveStatus='' and t1.IntakeStatus=''" + optional Warehouse / Country / CargoFrom equality.
    private const string PendingFilter = """
        t1.ConfirmArriveStatus = N'' AND t1.IntakeStatus = N''
          AND (@Warehouse IS NULL OR t1.Warehouse = @Warehouse)
          AND (@Country IS NULL OR t1.Country = @Country)
          AND (@CargoFrom IS NULL OR t1.CargoFrom = @CargoFrom)
        """;

    // Three result sets in one round trip. Differences from the legacy text, none of which changes the rows:
    //  * ArrivalDate is returned as a datetime truncated to the minute instead of the string 'dd/MM/yyyy HH:mm' (or '').
    //  * InboundBookingDate is returned as a date instead of the string 'dd/MM/yyyy' (or '').
    //  * InboundVesselOrderNo is selected once (legacy selected it twice) and Country is added (legacy left it out).
    //  * The two DISTINCT lists get an ORDER BY on their own columns (legacy had none, so their order was the server's).
    private const string PendingSql = $"""
        SELECT t1.RcvNo,
               CASE WHEN t1.ArriveDate IS NULL THEN NULL ELSE DATEADD(minute, DATEDIFF(minute, 0, t1.ArriveDate), 0) END AS ArrivalDate,
               (t1.ContractNo + '-' + (CASE WHEN t1.DeliveryNo < 100 THEN RIGHT((t1.DeliveryNo + 100), 2) ELSE RIGHT((t1.DeliveryNo + 1000), 3) END)) AS ContractNo,
               t1.ItemNo, t1.ShipperCode, t2.ShipperName, t1.CargoType, t1.Warehouse,
               t1.Ctns, t1.PCS AS Pcs, t1.GrossWgt, t1.CBM AS Cbm, t1.InboundVesselOrderNo,
               CAST(t1.InboundBookingDate AS date) AS InboundBookingDate,
               t1.ConfirmArriveStatus, t1.InboundETD AS InboundEtd, t1.InboundContainerOrderNo, t1.Country
        FROM dbo.CargoReceived t1
        LEFT JOIN dbo.Shipper t2 ON t2.ShipperCode = t1.ShipperCode
        WHERE {PendingFilter}
        ORDER BY t1.RcvNo
        OPTION (RECOMPILE);

        SELECT DISTINCT t1.ShipperCode, t2.ShipperName
        FROM dbo.CargoReceived t1
        LEFT JOIN dbo.Shipper t2 ON t2.ShipperCode = t1.ShipperCode
        WHERE {PendingFilter} AND t1.InboundContainerOrderNo = 0
        ORDER BY t1.ShipperCode, t2.ShipperName
        OPTION (RECOMPILE);

        SELECT DISTINCT t1.InboundETD AS InboundEtd, t1.InboundVesselOrderNo, t1.InboundContainerOrderNo,
               ISNULL(t2.VesselName, '') AS VesselName, ISNULL(t3.NextContainerNo, '') AS LoadReference,
               ISNULL(t3.ContainerNo, '') AS ContainerNo, ISNULL(t3.ContainerType, '') AS ContainerType
        FROM dbo.CargoReceived t1
        LEFT JOIN dbo.VesselRegistryImport t2 ON t2.BookingDate = t1.InboundETD AND t2.VesselOrderNo = t1.InboundVesselOrderNo
        LEFT JOIN dbo.ContainerDataImport t3 ON t3.BookingDate = t1.InboundETD AND t3.VesselOrderNo = t1.InboundVesselOrderNo
                                            AND t3.ContainerOrderNo = t1.InboundContainerOrderNo
        WHERE {PendingFilter}
        ORDER BY InboundEtd, t1.InboundVesselOrderNo, t1.InboundContainerOrderNo, VesselName, LoadReference, ContainerNo, ContainerType
        OPTION (RECOMPILE);
        """;

    private readonly IDbConnection _connection;
    private readonly IUnitOfWork _unitOfWork;

    public ConfirmArrivalRepository(IDbConnection connection, IUnitOfWork unitOfWork)
    {
        _connection = connection;
        _unitOfWork = unitOfWork;
    }

    public async Task<IReadOnlyList<DestWarehouse>> GetDcsAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.WhDes FROM dbo.DestWarehouse t1 ORDER BY t1.WhDes";
        var rows = await _connection.QueryAsync<DestWarehouse>(
            new CommandDefinition(sql, transaction: _unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<IReadOnlyList<Country>> GetCountriesAsync(CancellationToken cancellationToken = default)
    {
        const string sql = "SELECT t1.CountryCode, t1.CountryName FROM dbo.Country t1 ORDER BY t1.CountryCode";
        var rows = await _connection.QueryAsync<Country>(
            new CommandDefinition(sql, transaction: _unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<PendingArrivalSet> GetPendingAsync(PendingArrivalFilter filter, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filter);

        var parameters = new DynamicParameters();
        parameters.Add("@Warehouse", filter.Warehouse, DbType.String, size: 50);
        parameters.Add("@Country", filter.Country, DbType.String, size: 20);
        parameters.Add("@CargoFrom", filter.CargoFrom, DbType.String, size: 10);

        using var grid = await _connection.QueryMultipleAsync(
            new CommandDefinition(PendingSql, parameters, _unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));

        var contracts = (await grid.ReadAsync<PendingArrival>()).AsList();
        var suppliers = (await grid.ReadAsync<PendingArrivalSupplier>()).AsList();
        var containers = (await grid.ReadAsync<PendingArrivalContainer>()).AsList();

        return new PendingArrivalSet(contracts, suppliers, containers);
    }

    public Task UpdateImportVesselAsync(
        DateTime? bookingDate,
        decimal vesselOrderNo,
        string vesselName,
        CancellationToken cancellationToken = default)
    {
        // CREATE PROCEDURE VesselRegistryImportConfirmArrival (@BookingDate DateTime, @VesselOrderNo decimal, @VesselName nvarchar(50))
        var parameters = new DynamicParameters();
        parameters.Add("@BookingDate", bookingDate, DbType.DateTime);
        parameters.Add("@VesselOrderNo", vesselOrderNo, DbType.Decimal, precision: 18, scale: 0);
        parameters.Add("@VesselName", vesselName, DbType.String, size: 50);

        return ExecuteProcedureAsync("dbo.VesselRegistryImportConfirmArrival", parameters, cancellationToken);
    }

    public Task UpdateImportContainerAsync(ImportContainerUpdate update, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(update);

        // CREATE PROCEDURE ContainerDataImportEdit (@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal,
        //   @ContainerNo nvarchar(20), @ContainerType nvarchar(10), @DateUpdate datetime, @UpdateBy nvarchar(10), @NextContainerNo nvarchar(50))
        // The SP sets DateUpdate = GETDATE() and ignores @DateUpdate; legacy passed "" (which SQL Server reads as 1900-01-01).
        var parameters = new DynamicParameters();
        parameters.Add("@BookingDate", update.BookingDate, DbType.DateTime);
        parameters.Add("@VesselOrderNo", update.VesselOrderNo, DbType.Decimal, precision: 18, scale: 0);
        parameters.Add("@ContainerOrderNo", update.ContainerOrderNo, DbType.Decimal, precision: 18, scale: 0);
        parameters.Add("@ContainerNo", update.ContainerNo, DbType.String, size: 20);
        parameters.Add("@ContainerType", update.ContainerType, DbType.String, size: 10);
        parameters.Add("@DateUpdate", null, DbType.DateTime);
        parameters.Add("@UpdateBy", update.UpdateBy, DbType.String, size: 10);
        parameters.Add("@NextContainerNo", update.NextContainerNo, DbType.String, size: 50);

        return ExecuteProcedureAsync("dbo.ContainerDataImportEdit", parameters, cancellationToken);
    }

    public Task ConfirmArrivalAsync(
        string rcvNo,
        string confirmArriveStatus,
        DateTime arriveDate,
        string confirmArriveBy,
        CancellationToken cancellationToken = default)
    {
        // CREATE PROCEDURE CargoReceivedConfirmArrival (@RcvNo nvarchar(10), @ConfirmArriveStatus nvarchar(10), @ArriveDate DateTime,
        //   @ConfirmArriveBy nvarchar(10)). Legacy passed ArriveDate as an "MM/dd/yyyy HH:mm" string; here it is a typed datetime.
        var parameters = new DynamicParameters();
        parameters.Add("@RcvNo", rcvNo, DbType.String, size: 10);
        parameters.Add("@ConfirmArriveStatus", confirmArriveStatus, DbType.String, size: 10);
        parameters.Add("@ArriveDate", arriveDate, DbType.DateTime);
        parameters.Add("@ConfirmArriveBy", confirmArriveBy, DbType.String, size: 10);

        return ExecuteProcedureAsync("dbo.CargoReceivedConfirmArrival", parameters, cancellationToken);
    }

    private Task ExecuteProcedureAsync(string procedure, DynamicParameters parameters, CancellationToken cancellationToken) =>
        _connection.ExecuteAsync(new CommandDefinition(
            procedure,
            parameters,
            _unitOfWork.CurrentTransaction,
            commandType: CommandType.StoredProcedure,
            cancellationToken: cancellationToken));
}

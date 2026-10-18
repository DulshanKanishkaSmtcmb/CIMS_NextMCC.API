namespace CIMSNextMCC.Domain.Entities.Arrivals;

/// <summary>
/// A dbo.CargoReceived row waiting for arrival confirmation (ConfirmArriveStatus = '' and IntakeStatus = ''),
/// projected the way legacy DataApi/getPendingPO4ConfirmArrival builds its dtMain table.
/// </summary>
public class PendingArrival
{
    public string RcvNo { get; set; } = string.Empty;

    /// <summary>ArriveDate truncated to the minute (legacy shows dd/MM/yyyy HH:mm).</summary>
    public DateTime? ArrivalDate { get; set; }

    /// <summary>ContractNo plus the two- or three-digit delivery suffix, e.g. "C1234-01".</summary>
    public string ContractNo { get; set; } = string.Empty;

    public string ItemNo { get; set; } = string.Empty;
    public string ShipperCode { get; set; } = string.Empty;
    public string? ShipperName { get; set; }
    public string CargoType { get; set; } = string.Empty;
    public string Warehouse { get; set; } = string.Empty;
    public decimal Ctns { get; set; }
    public decimal Pcs { get; set; }
    public decimal GrossWgt { get; set; }
    public decimal Cbm { get; set; }
    public decimal InboundVesselOrderNo { get; set; }

    /// <summary>Date part only (legacy formats it with style 103).</summary>
    public DateTime? InboundBookingDate { get; set; }

    public string ConfirmArriveStatus { get; set; } = string.Empty;
    public DateTime? InboundEtd { get; set; }
    public decimal InboundContainerOrderNo { get; set; }
    public string Country { get; set; } = string.Empty;
}

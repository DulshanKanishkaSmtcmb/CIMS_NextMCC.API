namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>
/// A dbo.OkToLoadReason row as the Ok to Ship / Hold Reasons page reads it (legacy getOkToLoadResonListUpdate:
/// <c>select t1.Reason, t1.DtlReson, t1.Warehouse DC</c>). The table has no key; the order within a DC is ReasonOrder.
/// </summary>
public class OkToLoadReasonRow
{
    public string Reason { get; set; } = string.Empty;
    public string DtlReson { get; set; } = string.Empty;
    public string Dc { get; set; } = string.Empty;
}

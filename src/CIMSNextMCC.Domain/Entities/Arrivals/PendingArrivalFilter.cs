namespace CIMSNextMCC.Domain.Entities.Arrivals;

/// <summary>
/// Filter of the pending-arrivals read. A null value means "no filter" (legacy: DC or Country "All", Shipment "").
/// </summary>
public sealed record PendingArrivalFilter(string? CargoFrom, string? Warehouse, string? Country);

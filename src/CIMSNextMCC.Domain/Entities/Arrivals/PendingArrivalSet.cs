namespace CIMSNextMCC.Domain.Entities.Arrivals;

/// <summary>The three result sets of one pending-arrivals read, all on the same filter.</summary>
public sealed record PendingArrivalSet(
    IReadOnlyList<PendingArrival> Contracts,
    IReadOnlyList<PendingArrivalSupplier> Suppliers,
    IReadOnlyList<PendingArrivalContainer> Containers);

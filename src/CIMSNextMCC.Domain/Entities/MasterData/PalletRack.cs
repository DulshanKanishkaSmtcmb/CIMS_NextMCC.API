namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>A dbo.PalletRacks row (legacy getPalletRacksList / getPalletRacksData dtMain, <c>select t1.*</c>). The table has no key.</summary>
public class PalletRack
{
    public string RackNo { get; set; } = string.Empty;
    public decimal NofRows { get; set; }
    public decimal NofLayers { get; set; }
    public decimal NofPositions { get; set; }
}

/// <summary>
/// A dbo.PalletRacksUtilization row (legacy getPalletRacksData dtDtl1, <c>select t1.*</c>): one pallet position of a rack,
/// with the GRN and pallet it currently holds (the Pallet Rack Build pages only ever write RackNo and PositionNo).
/// </summary>
public class PalletRackPosition
{
    public string RackNo { get; set; } = string.Empty;
    public string PositionNo { get; set; } = string.Empty;
    public string GrnNo { get; set; } = string.Empty;
    public string PalletNo { get; set; } = string.Empty;
}

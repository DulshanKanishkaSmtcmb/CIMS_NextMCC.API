namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>
/// A full dbo.Shipper row (legacy <c>select t1.*</c>, the "Supplier" of the Supplier master page and its listing dialog),
/// in the table's column order.
/// </summary>
public class SupplierMaster
{
    public string ShipperCode { get; set; } = string.Empty;
    public string ShipperName { get; set; } = string.Empty;
    public string ShipperAddress1 { get; set; } = string.Empty;
    public string ShipperAddress2 { get; set; } = string.Empty;
    public string ShipperAddress3 { get; set; } = string.Empty;
    public string ShipperAddress4 { get; set; } = string.Empty;
    public string ShipperContact1 { get; set; } = string.Empty;
    public string ShipperContact2 { get; set; } = string.Empty;
    public string ShipperContact3 { get; set; } = string.Empty;
    public DateTime? DateCreate { get; set; }
    public string CreateBy { get; set; } = string.Empty;
    public DateTime? DateUpdate { get; set; }
    public string UpdateBy { get; set; } = string.Empty;
    public string ShipperCodeAir { get; set; } = string.Empty;
    public string ShipperCodeSea { get; set; } = string.Empty;
    public string ShipperTel { get; set; } = string.Empty;
    public string ShipperEmail { get; set; } = string.Empty;
    public string ShipperFax { get; set; } = string.Empty;
    public string? CountryCode { get; set; }
    public string LimaSupplierCode { get; set; } = string.Empty;
    public string RexNo { get; set; } = string.Empty;
}

/// <summary>The six columns legacy DataApi/findSupplierName returns for the "pre-entered" box.</summary>
public class SupplierNameHit
{
    public string ShipperCode { get; set; } = string.Empty;
    public string ShipperName { get; set; } = string.Empty;
    public string ShipperAddress1 { get; set; } = string.Empty;
    public string ShipperAddress2 { get; set; } = string.Empty;
    public string ShipperAddress3 { get; set; } = string.Empty;
    public string ShipperAddress4 { get; set; } = string.Empty;
}

/// <summary>A row of the AirFreight / SeaFreight Shipper table as the shipper dialogs of the Supplier page list it (legacy getAirShipperList / getSeaShipperList).</summary>
public class FreightShipper
{
    public string ShCode { get; set; } = string.Empty;
    public string ShName { get; set; } = string.Empty;
    public string ShAdd1 { get; set; } = string.Empty;
    public string ShAdd2 { get; set; } = string.Empty;
    public string ShAdd3 { get; set; } = string.Empty;
    public string ShAdd4 { get; set; } = string.Empty;
}

/// <summary>The two columns legacy getAirShipperData / getSeaShipperData return (code and name of one shipper).</summary>
public class FreightShipperName
{
    public string ShCode { get; set; } = string.Empty;
    public string ShName { get; set; } = string.Empty;
}

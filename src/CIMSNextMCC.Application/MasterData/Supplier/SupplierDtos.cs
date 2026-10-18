namespace CIMSNextMCC.Application.MasterData.Supplier;

/// <summary>
/// A dbo.Shipper row (legacy getSupplierList / getSupplierData dtMain, <c>select t1.*</c>), in the table's column order.
/// Dates are ISO local date-times (no offset). CreateBy / UpdateBy hold the legacy PwInfo.UserId codes as stored.
/// </summary>
public sealed record SupplierDto(
    string ShipperCode,
    string ShipperName,
    string ShipperAddress1,
    string ShipperAddress2,
    string ShipperAddress3,
    string ShipperAddress4,
    string ShipperContact1,
    string ShipperContact2,
    string ShipperContact3,
    DateTime? DateCreate,
    string CreateBy,
    DateTime? DateUpdate,
    string UpdateBy,
    string ShipperCodeAir,
    string ShipperCodeSea,
    string ShipperTel,
    string ShipperEmail,
    string ShipperFax,
    string? CountryCode,
    string LimaSupplierCode,
    string RexNo);

/// <summary>A hit of the "Pre-Entered Supplier Listing" box (legacy findSupplierName dtMain).</summary>
public sealed record SupplierNameHitDto(
    string ShipperCode,
    string ShipperName,
    string ShipperAddress1,
    string ShipperAddress2,
    string ShipperAddress3,
    string ShipperAddress4);

/// <summary>A row of the "Air Shipper Listing" / "Sea Shipper Listing" dialogs (legacy getAirShipperList / getSeaShipperList dtMain).</summary>
public sealed record FreightShipperDto(string ShCode, string ShName, string ShAdd1, string ShAdd2, string ShAdd3, string ShAdd4);

/// <summary>Code and name of one Air or Sea shipper (legacy getAirShipperData / getSeaShipperData dtMain).</summary>
public sealed record FreightShipperNameDto(string ShCode, string ShName);

/// <summary>
/// Body of POST api/v1/master-data/suppliers (Option "New": the code is generated from the first character of the name)
/// and of PUT api/v1/master-data/suppliers/{shipperCode} (Option "Change"; the code comes from the route). The names are
/// those of the dbo.Shipper columns the page edits. A value that is left out is an empty string, like the legacy page sent.
/// </summary>
public sealed record SaveSupplierRequest(
    string ShipperName,
    string ShipperAddress1 = "",
    string ShipperAddress2 = "",
    string ShipperAddress3 = "",
    string ShipperAddress4 = "",
    string ShipperContact1 = "",
    string ShipperContact2 = "",
    string ShipperContact3 = "",
    string ShipperTel = "",
    string ShipperEmail = "",
    string ShipperFax = "",
    string CountryCode = "",
    string ShipperCodeAir = "",
    string ShipperCodeSea = "",
    string LimaSupplierCode = "",
    string RexNo = "");

/// <summary>Result of a save (legacy SaveResult: DocNo = the supplier code, DocType "Supplier", msg).</summary>
public sealed record SaveSupplierResultDto(string SupplierCode, string Message);

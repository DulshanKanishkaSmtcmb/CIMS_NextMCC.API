namespace CIMSNextMCC.Application.MasterData.PmSupplier;

/// <summary>A dbo.PMSupplier row (legacy getPMSupplierList / getPMSupplierData dtMain, select t1.*), in the table column order.</summary>
public sealed record PmSupplierDto(
    string PmSupplierCode,
    string PmSupplierName,
    string PmSupplierAddress1,
    string PmSupplierAddress2,
    string PmSupplierAddress3,
    string PmSupplierAddress4,
    string PmSupplierContact1,
    string PmSupplierContact2,
    string PmSupplierContact3,
    string PmSupplierTel,
    string PmSupplierEmail,
    string PmSupplierFax,
    string? CountryCode);

/// <summary>
/// Body of POST api/v1/master-data/pm-suppliers (Option "New": the code is generated from the first character of the
/// name) and of PUT api/v1/master-data/pm-suppliers/{pmSupplierCode} (Option "Change"; the code comes from the route).
/// A value that is left out is an empty string, like the legacy page sent.
/// </summary>
public sealed record SavePmSupplierRequest(
    string PmSupplierName,
    string PmSupplierAddress1 = "",
    string PmSupplierAddress2 = "",
    string PmSupplierAddress3 = "",
    string PmSupplierAddress4 = "",
    string PmSupplierContact1 = "",
    string PmSupplierContact2 = "",
    string PmSupplierContact3 = "",
    string PmSupplierTel = "",
    string PmSupplierEmail = "",
    string PmSupplierFax = "",
    string CountryCode = "");

/// <summary>Result of a save (legacy SaveResult: DocNo = the supplier code, msg).</summary>
public sealed record SavePmSupplierResultDto(string PmSupplierCode, string Message);

namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>A full dbo.PMSupplier row (legacy <c>select t1.*</c>), in the table's column order.</summary>
public class PmSupplierMaster
{
    public string PmSupplierCode { get; set; } = string.Empty;
    public string PmSupplierName { get; set; } = string.Empty;
    public string PmSupplierAddress1 { get; set; } = string.Empty;
    public string PmSupplierAddress2 { get; set; } = string.Empty;
    public string PmSupplierAddress3 { get; set; } = string.Empty;
    public string PmSupplierAddress4 { get; set; } = string.Empty;
    public string PmSupplierContact1 { get; set; } = string.Empty;
    public string PmSupplierContact2 { get; set; } = string.Empty;
    public string PmSupplierContact3 { get; set; } = string.Empty;
    public string PmSupplierTel { get; set; } = string.Empty;
    public string PmSupplierEmail { get; set; } = string.Empty;
    public string PmSupplierFax { get; set; } = string.Empty;
    public string? CountryCode { get; set; }
}

namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>
/// A full dbo.DestWarehouse row (legacy <c>select t1.*</c>). The DC master page edits only WhDes and CountryCode;
/// the listing dialog shows every column, so all of them are read.
/// </summary>
public class DcMaster
{
    public string WhCode { get; set; } = string.Empty;
    public string WhDes { get; set; } = string.Empty;
    public string WhDesMain { get; set; } = string.Empty;
    public string CountryCode { get; set; } = string.Empty;
    public decimal LoadingOrder { get; set; }
    public bool OuterLabel { get; set; }
    public bool EanLabelScan { get; set; }
    public bool ReworkApply { get; set; }
    public bool RfidPriceTag { get; set; }
    public string RfidPriceTagValidate { get; set; } = string.Empty;
    public bool RemoveOriginalTag { get; set; }
    public bool JokerTagsForSets { get; set; }
    public bool CareWarningLabel { get; set; }
    public bool PreValidationRun { get; set; }
    public bool EanLabelOuterBox { get; set; }
    public string EanDesCol { get; set; } = string.Empty;
    public bool PackAdditionalBox { get; set; }
    public string BoxPmCode { get; set; } = string.Empty;
    public bool HangerUse { get; set; }
    public bool EanLabelPiece { get; set; }
    public bool PostValidation { get; set; }
    public bool StockUpdate { get; set; }
    public bool AuthorizedToPoPlan { get; set; }
    public bool ItemOptionFixedLength { get; set; }
    public bool ItemOptionManual { get; set; }
    public string PriceSymble { get; set; } = string.Empty;
    public bool PrintPriceTag { get; set; }
    public bool BoxPackSeperate { get; set; }
    public bool StorePick { get; set; }
    public bool IsRfidOrder { get; set; }
    public string? BrandText { get; set; }
    public string BarcodeType { get; set; } = string.Empty;
    public bool ProductCategory { get; set; }
    public bool VasCheck { get; set; }
    public bool EnaVerification { get; set; }
    public string EanLblType { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string LpnLblType { get; set; } = string.Empty;
}

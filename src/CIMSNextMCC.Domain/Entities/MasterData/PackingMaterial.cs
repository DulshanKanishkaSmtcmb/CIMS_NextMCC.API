namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>
/// A full dbo.PMMaster row (legacy <c>select t1.*</c>), as the Packing Material (PM Master) page and its listing dialog
/// show it. The table has no key.
/// </summary>
public class PackingMaterial
{
    public string PmCode { get; set; } = string.Empty;
    public string PmDescription { get; set; } = string.Empty;
    public string PmCategory { get; set; } = string.Empty;
    public string PmIssueType { get; set; } = string.Empty;
    public decimal QtyInHand { get; set; }
    public decimal QtyReOrderLevel { get; set; }
    public decimal PmWgt { get; set; }
    public decimal PmCbm { get; set; }
    public bool GetJokerCount { get; set; }
    public bool GetPartCount { get; set; }
    public bool GetCtnCount { get; set; }
    public decimal StockCbm { get; set; }
    public bool IsActive { get; set; }
}

/// <summary>A dbo.PMCategories row (legacy DataApi/getPmCategoryData): the choices of the PM Category select.</summary>
public class PackingMaterialCategory
{
    public string PmCategory { get; set; } = string.Empty;
}

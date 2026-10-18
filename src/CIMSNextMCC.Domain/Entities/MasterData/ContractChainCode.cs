namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>
/// A full dbo.ContractsChainCodes row (legacy DataApi/getChainCategoryData, <c>select t1.*</c>): what the Product Category
/// page lists and adds to. The table has no key.
/// </summary>
public class ContractChainCode
{
    public string ChainCode { get; set; } = string.Empty;
    public string ChainName { get; set; } = string.Empty;
    public string TpPartnerName { get; set; } = string.Empty;
    public string Range { get; set; } = string.Empty;
    public string RangeBoxEan { get; set; } = string.Empty;
}

/// <summary>A dbo.ContractsChainCodesCategory row (legacy DataApi/getProductCategoryData): the choices of the Range select.</summary>
public class ChainRange
{
    public string Category { get; set; } = string.Empty;
}

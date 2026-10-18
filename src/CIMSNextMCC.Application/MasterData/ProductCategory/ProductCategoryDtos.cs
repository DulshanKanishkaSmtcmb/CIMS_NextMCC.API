namespace CIMSNextMCC.Application.MasterData.ProductCategory;

/// <summary>A dbo.ContractsChainCodes row (legacy getChainCategoryData dtMain, <c>select t1.*</c>); the grid of the page.</summary>
public sealed record ChainCodeDto(
    string ChainCode,
    string ChainName,
    string TpPartnerName,
    string Range,
    string RangeBoxEan);

/// <summary>A choice of the Range select (legacy getProductCategoryData dtMain: dbo.ContractsChainCodesCategory.Category).</summary>
public sealed record ChainRangeDto(string Category);

/// <summary>Body of POST api/v1/master-data/product-categories: one new chain code (the page only ever adds).</summary>
public sealed record CreateChainCodeRequest(
    string ChainCode,
    string ChainName,
    string Range,
    string TpPartnerName,
    string RangeBoxEan);

/// <summary>Result of a save (legacy SaveResult: msg; the legacy action returned no DocNo for this save).</summary>
public sealed record SaveChainCodeResultDto(string ChainCode, string Message);

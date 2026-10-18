namespace CIMSNextMCC.Application.MasterData.PMMaster;

/// <summary>
/// A dbo.PMMaster row (legacy getPMList / getPMData dtMain, <c>select t1.*</c>). Money and decimal columns are numbers,
/// bits are booleans.
/// </summary>
public sealed record PmMasterDto(
    string PmCode,
    string PmDescription,
    string PmCategory,
    string PmIssueType,
    decimal QtyInHand,
    decimal QtyReOrderLevel,
    decimal PmWgt,
    decimal PmCbm,
    bool GetJokerCount,
    bool GetPartCount,
    bool GetCtnCount,
    decimal StockCbm,
    bool IsActive);

/// <summary>A choice of the PM Category select (legacy getPmCategoryData dtMain: dbo.PMCategories.PMCategory).</summary>
public sealed record PmCategoryDto(string PmCategory);

/// <summary>Body of POST api/v1/master-data/pm-masters (Option "New").</summary>
public sealed record CreatePmMasterRequest(
    string PmCode,
    string PmDescription,
    string PmCategory,
    int ReorderLevel,
    decimal PmWeight,
    decimal Cbm,
    bool GetJokersCount,
    bool GetPartsCount,
    bool IsActive);

/// <summary>Body of PUT api/v1/master-data/pm-masters/{pmCode} (Option "Change"); the code comes from the route.</summary>
public sealed record UpdatePmMasterRequest(
    string PmDescription,
    string PmCategory,
    int ReorderLevel,
    decimal PmWeight,
    decimal Cbm,
    bool GetJokersCount,
    bool GetPartsCount,
    bool IsActive);

/// <summary>Result of a save (legacy SaveResult: DocNo = the code, DocType "PM", msg).</summary>
public sealed record SavePmMasterResultDto(string PmCode, string Message);

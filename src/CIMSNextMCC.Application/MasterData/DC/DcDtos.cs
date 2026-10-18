namespace CIMSNextMCC.Application.MasterData.DC;

/// <summary>
/// A dbo.DestWarehouse row (legacy getDCList / getDCData dtMain, <c>select t1.*</c>): the DC master page edits only
/// <see cref="WhDes"/> and <see cref="CountryCode"/>, the listing dialog shows every column.
/// </summary>
public sealed record DcDto(
    string WhCode,
    string WhDes,
    string WhDesMain,
    string CountryCode,
    decimal LoadingOrder,
    bool OuterLabel,
    bool EanLabelScan,
    bool ReworkApply,
    bool RfidPriceTag,
    string RfidPriceTagValidate,
    bool RemoveOriginalTag,
    bool JokerTagsForSets,
    bool CareWarningLabel,
    bool PreValidationRun,
    bool EanLabelOuterBox,
    string EanDesCol,
    bool PackAdditionalBox,
    string BoxPmCode,
    bool HangerUse,
    bool EanLabelPiece,
    bool PostValidation,
    bool StockUpdate,
    bool AuthorizedToPoPlan,
    bool ItemOptionFixedLength,
    bool ItemOptionManual,
    string PriceSymble,
    bool PrintPriceTag,
    bool BoxPackSeperate,
    bool StorePick,
    bool IsRfidOrder,
    string? BrandText,
    string BarcodeType,
    bool ProductCategory,
    bool VasCheck,
    bool EnaVerification,
    string EanLblType,
    string Address,
    string LpnLblType);

/// <summary>Body of POST api/v1/master-data/dcs (Option "New").</summary>
public sealed record CreateDcRequest(string WhDes, string CountryCode);

/// <summary>Body of PUT api/v1/master-data/dcs/{whDes} (Option "Change"); the DC name comes from the route.</summary>
public sealed record UpdateDcRequest(string CountryCode);

/// <summary>Result of a save (legacy SaveResult: DocNo = the DC name, DocType "DC", msg).</summary>
public sealed record SaveDcResultDto(string WhDes, string Message);

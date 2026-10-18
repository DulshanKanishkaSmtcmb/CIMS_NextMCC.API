namespace CIMSNextMCC.Application.MasterData.Country;

/// <summary>
/// A dbo.Country row (legacy getCountryList / getCountryData dtMain, <c>select t1.*</c>). Dates are ISO local date-times
/// (no offset). EnterBy / UpdateBy hold the legacy PwInfo.UserId codes exactly as stored.
/// </summary>
public sealed record CountryDto(
    string CountryCode,
    string CountryName,
    string CargoMovement,
    DateTime? DateEnter,
    string EnterBy,
    DateTime? DateUpdate,
    string UpdateBy,
    bool ContractBlock);

/// <summary>A hit of the "Pre-Entered Supplier Listing" box (legacy findCountryName dtMain).</summary>
public sealed record CountryNameHitDto(string CountryCode, string CountryName, string CargoMovement);

/// <summary>Body of POST api/v1/master-data/countries (Option "New").</summary>
public sealed record CreateCountryRequest(string CountryCode, string CountryName, string CargoMovement);

/// <summary>Body of PUT api/v1/master-data/countries/{countryCode} (Option "Change"); the code comes from the route.</summary>
public sealed record UpdateCountryRequest(string CountryName, string CargoMovement);

/// <summary>Result of a save (legacy SaveResult: DocNo = the code, DocType "Country", msg).</summary>
public sealed record SaveCountryResultDto(string CountryCode, string Message);

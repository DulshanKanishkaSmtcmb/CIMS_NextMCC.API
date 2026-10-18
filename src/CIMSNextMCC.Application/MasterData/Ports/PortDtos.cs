namespace CIMSNextMCC.Application.MasterData.Ports;

/// <summary>
/// A dbo.Ports row (legacy getPortList / getPortData dtMain, <c>select t1.*</c>). Dates are ISO local date-times (no
/// offset). CreateBy / UpdateBy hold the legacy PwInfo.UserId codes exactly as stored.
/// </summary>
public sealed record PortDto(
    string PortCode,
    string PortName,
    string CountryCode,
    DateTime? DateCreate,
    string CreateBy,
    DateTime? DateUpdate,
    string UpdateBy,
    string SeaOrAirPort,
    bool IsDivertable);

/// <summary>A hit of the "Pre-Entered Ports Listing" box (legacy findPortName dtMain).</summary>
public sealed record PortNameHitDto(string PortCode, string PortName, string CountryCode);

/// <summary>Body of POST api/v1/master-data/ports (Option "New").</summary>
public sealed record CreatePortRequest(string PortCode, string PortName, string CountryCode, bool IsDivertable);

/// <summary>Body of PUT api/v1/master-data/ports/{portCode} (Option "Change"); the code comes from the route.</summary>
public sealed record UpdatePortRequest(string PortName, string CountryCode, bool IsDivertable);

/// <summary>Result of a save (legacy SaveResult: DocNo = the code, DocType "Port", msg).</summary>
public sealed record SavePortResultDto(string PortCode, string Message);

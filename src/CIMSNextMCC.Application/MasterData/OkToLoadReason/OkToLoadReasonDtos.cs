namespace CIMSNextMCC.Application.MasterData.OkToLoadReason;

/// <summary>
/// A reason of a DC (legacy getOkToLoadResonListUpdate dtMain: Reason, DtlReson, DC and the computed isAttched).
/// <paramref name="IsAllocated"/> is true when contracts have already been given this reason in the DC (the page then
/// refuses to remove it); it is only filled when the allocation was asked for.
/// </summary>
public sealed record OkToLoadReasonDto(string Reason, string DtlReson, string Dc, bool IsAllocated);

/// <summary>One line of the list sent by the page: the reason and its detail. The order of the lines is the order saved.</summary>
public sealed record OkToLoadReasonLine(string Reason, string? DtlReson);

/// <summary>Body of PUT api/v1/master-data/ok-to-load-reasons: the complete list of reasons of one DC.</summary>
public sealed record ReplaceOkToLoadReasonsRequest(string Dc, IReadOnlyList<OkToLoadReasonLine> Reasons);

/// <summary>Result of the save (legacy SaveResult: msg; the legacy action returned no DocNo).</summary>
public sealed record ReplaceOkToLoadReasonsResultDto(string Dc, int Count, string Message);

using CIMSNextMCC.Application.Common.Exceptions;

namespace CIMSNextMCC.Application.MasterData.Supplier;

/// <summary>
/// The code of a new Supplier or PM Supplier: the first character of the name followed by a four-digit running number,
/// per first character (legacy SaveSupplierData / SavePMSupplierData: highest existing code with that first character,
/// plus one; <c>A0027</c> becomes <c>A0028</c>; the first one is <c>A0001</c>).
/// </summary>
public static class SupplierCodeSequence
{
    public const string Exhausted = "SUPPLIER_CODE_SEQUENCE_EXHAUSTED";

    /// <param name="prefix">The first character of the name (kept as typed, so a lower-case name gives a lower-case code, like legacy).</param>
    /// <param name="lastCode">The highest existing code that starts with the prefix, or null when there is none.</param>
    public static string Next(string prefix, string? lastCode)
    {
        if (lastCode is null)
        {
            return prefix + "0001";
        }

        // Legacy: Convert.ToDecimal(code.Substring(1)) + 1, then the last four digits of 10000000 + n. A suffix that is not a
        // number threw (HTTP 500) and a number above 9999 wrapped around to a code that already exists; both are refused here.
        var suffix = lastCode.Length > 1 ? lastCode[1..] : string.Empty;
        if (suffix.Length == 0 || suffix.Length > 4 || !suffix.All(char.IsAsciiDigit) || !int.TryParse(suffix, out var last) || last >= 9999)
        {
            throw new AppException(Exhausted, 409);
        }

        return prefix + (last + 1).ToString("D4");
    }
}

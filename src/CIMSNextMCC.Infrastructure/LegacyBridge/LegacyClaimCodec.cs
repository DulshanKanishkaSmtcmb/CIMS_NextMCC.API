using System.Text;

namespace CIMSNextMCC.Infrastructure.LegacyBridge;

/// <summary>
/// Byte-for-byte port of the claim encodings in the legacy clsDBUtility (CIMS_NextMCC/clsDBUtility.cs):
/// ReverseMiddle (Sid claim = UserId), ConvertAsc (GroupSid claim = UserCategory) and ReConvertAsc (its inverse).
/// Legacy controllers decode the cookie claims by position with these functions, so the bridge must produce
/// exactly what the legacy login produces. Do not "fix" anything here; delete it with the bridge in Phase 4.
///
/// The legacy code uses Encoding.Default, which on .NET Framework is the server's ANSI code page. That is 1252 on the
/// dev laptop and the current servers. .NET (Core) Encoding.Default is UTF-8, so the code page is named explicitly.
/// </summary>
public static class LegacyClaimCodec
{
    /// <summary>The ANSI code page the legacy servers run with (Encoding.Default there).</summary>
    public const int AnsiCodePage = 1252;

    // Same fallback as Encoding.Default on .NET Framework: best fit, then '?'.
    private static readonly Encoding Ansi = CodePagesEncodingProvider.Instance.GetEncoding(AnsiCodePage)
        ?? throw new InvalidOperationException($"Code page {AnsiCodePage} is not available.");

    /// <summary>
    /// First and last character kept, the characters in between reversed (per UTF-16 code unit, like the legacy
    /// Substring loop). "A" and "AB" come back unchanged. Self-inverse.
    /// </summary>
    /// <exception cref="ArgumentOutOfRangeException">For an empty string, like the legacy Substring(0, 1).</exception>
    public static string ReverseMiddle(string value)
    {
        ArgumentNullException.ThrowIfNull(value);
        if (value.Length == 0)
        {
            throw new ArgumentOutOfRangeException(nameof(value), "The legacy ReverseMiddle fails on an empty string.");
        }

        var first = value[0];
        var result = new StringBuilder(value.Length);
        result.Append(first);
        for (var i = value.Length - 2; i >= 1; i--)
        {
            result.Append(value[i]);
        }

        if (value.Length > 1)
        {
            result.Append(value[^1]);
        }

        return result.ToString();
    }

    /// <summary>
    /// Each character's ANSI byte doubled and decoded back with the ANSI code page ('A' 0x41 becomes 0x82, U+201A).
    /// </summary>
    /// <exception cref="OverflowException">
    /// For any character above U+007F, like the legacy code: it doubles the first ANSI, code page 437 and UTF-8 byte
    /// with Convert.ToByte, and one of them is always 0x80 or more for a non-ASCII character.
    /// </exception>
    public static string ConvertAsc(string value)
    {
        ArgumentNullException.ThrowIfNull(value);

        var result = new StringBuilder(value.Length);
        for (var i = 0; i < value.Length; i++)
        {
            var character = value.Substring(i, 1);

            var ansi = Ansi.GetBytes(character);
            ansi[0] = Convert.ToByte(ansi[0] * 2);

            // The legacy code also doubles the first code page 437, UTF-8 and ASCII bytes and discards the results.
            // Only the UTF-8 one matters: it is what throws for characters the ANSI code page best-fits into ASCII.
            _ = Convert.ToByte(Encoding.UTF8.GetBytes(character)[0] * 2);

            result.Append(Ansi.GetString(ansi));
        }

        return result.ToString();
    }

    /// <summary>Inverse of <see cref="ConvertAsc"/>: each character's ANSI byte halved (integer division).</summary>
    public static string ReConvertAsc(string value)
    {
        ArgumentNullException.ThrowIfNull(value);

        var result = new StringBuilder(value.Length);
        for (var i = 0; i < value.Length; i++)
        {
            var ansi = Ansi.GetBytes(value.Substring(i, 1));
            ansi[0] = Convert.ToByte(ansi[0] / 2);
            result.Append(Ansi.GetString(ansi));
        }

        return result.ToString();
    }
}

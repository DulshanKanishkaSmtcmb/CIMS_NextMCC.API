using CIMSNextMCC.Infrastructure.LegacyBridge;

namespace CIMSNextMCC.LegacyBridge.Tests;

/// <summary>
/// Expected values are derived from the legacy clsDBUtility source (ReverseMiddle, ConvertAsc, ReConvertAsc) with
/// code page 1252 as Encoding.Default, and were cross-checked by running that source on .NET Framework 4.8 on the
/// dev laptop (ANSI code page 1252), see docs/11-cookie-bridge-spike.md in the legacy repo.
/// </summary>
public class LegacyClaimCodecTests
{
    // ---- ReverseMiddle: first and last character kept, the middle reversed ----

    [Theory]
    [InlineData("A", "A")]                 // 1 char: only the first character
    [InlineData("AB", "AB")]               // 2 chars: first + last, empty middle
    [InlineData("ABC", "ABC")]             // a one-character middle does not move
    [InlineData("ABCD", "ACBD")]
    [InlineData("12345", "14325")]
    [InlineData("Employee", "Eeyolpme")]
    [InlineData("1202xQaHZ", "1HaQx202Z")] // UserId shape from CreateDateTimePW (9 chars)
    [InlineData("é", "é")]       // non-ASCII is just another character
    [InlineData("é日ü", "é日ü")]
    [InlineData("aé日b", "a日éb")]
    public void ReverseMiddle_matches_the_legacy_function(string input, string expected) =>
        Assert.Equal(expected, LegacyClaimCodec.ReverseMiddle(input));

    [Fact]
    public void ReverseMiddle_reverses_per_UTF16_code_unit_like_the_legacy_Substring_loop()
    {
        // U+1F600 is the surrogate pair D83D DE00; in the middle its halves swap, as in the legacy code.
        Assert.Equal("😀", LegacyClaimCodec.ReverseMiddle("😀"));
        Assert.Equal("a\uDE00\uD83Db", LegacyClaimCodec.ReverseMiddle("a😀b"));
    }

    [Fact]
    public void ReverseMiddle_of_an_empty_string_throws_like_the_legacy_Substring() =>
        Assert.Throws<ArgumentOutOfRangeException>(() => LegacyClaimCodec.ReverseMiddle(string.Empty));

    [Theory]
    [InlineData("A")]
    [InlineData("AB")]
    [InlineData("1202xQaHZ")]
    [InlineData("UPUL")]
    public void ReverseMiddle_is_its_own_inverse(string userId) =>
        Assert.Equal(userId, LegacyClaimCodec.ReverseMiddle(LegacyClaimCodec.ReverseMiddle(userId)));

    // ---- ConvertAsc: each ASCII byte doubled, decoded with code page 1252 ----

    [Theory]
    [InlineData("", "")]
    [InlineData("A", "‚")]                                       // 0x41 * 2 = 0x82 = U+201A
    [InlineData("AB", "‚„")]
    [InlineData("ABCD", "‚„†ˆ")]
    [InlineData("12345", "bdfhj")]                                    // below 0x40 the result stays ASCII
    [InlineData("H", "\u0090")]                                       // 0x90 is unassigned in 1252: maps to U+0090
    [InlineData("~", "ü")]
    [InlineData("CFS", "†Œ¦")]
    [InlineData("Employee", "ŠÚàØÞòÊÊ")]
    [InlineData("Shipper", "¦ÐÒààÊä")]
    public void ConvertAsc_matches_the_legacy_function(string input, string expected) =>
        Assert.Equal(expected, LegacyClaimCodec.ConvertAsc(input));

    [Fact]
    public void ConvertAsc_maps_every_ASCII_character_like_the_legacy_function()
    {
        var ascii = new string(Enumerable.Range(0, 128).Select(i => (char)i).ToArray());

        // 0x00..0x3F double to 0x00..0x7E, which 1252 decodes to the same code points.
        var lowerHalf = new string(Enumerable.Range(0, 64).Select(i => (char)(i * 2)).ToArray());
        // 0x40..0x7F double to 0x80..0xFE: the 1252 upper half (0x90 unassigned, kept as U+0090).
        const string upperHalf =
            "€‚„†ˆŠŒŽ\u0090’”–˜šœž" +
            " ¢¤¦¨ª¬®°²´¶¸º¼¾" +
            "ÀÂÄÆÈÊÌÎÐÒÔÖØÚÜÞ" +
            "àâäæèêìîðòôöøúüþ";

        Assert.Equal(lowerHalf + upperHalf, LegacyClaimCodec.ConvertAsc(ascii));
    }

    [Theory]
    [InlineData("é")]         // in 1252 (0xE9): 0xE9 * 2 overflows Convert.ToByte
    [InlineData("ā")]         // not in 1252, best-fits to 'a', but its UTF-8 lead byte 0xC4 * 2 overflows
    [InlineData("日")]         // CJK
    [InlineData("😀")]   // surrogate pair
    [InlineData("aé")]        // fails on the first non-ASCII character
    public void ConvertAsc_throws_on_non_ASCII_like_the_legacy_function(string input) =>
        Assert.Throws<OverflowException>(() => LegacyClaimCodec.ConvertAsc(input));

    // ---- ReConvertAsc: the decoder legacy controllers apply to Claims.ElementAt(2) ----

    [Theory]
    [InlineData("", "")]
    [InlineData("A", " ")]                                 // 0x41 / 2 = 0x20
    [InlineData("12345", "\u0018\u0019\u0019\u001A\u001A")]
    [InlineData("é", "t")]                            // 0xE9 / 2 = 0x74
    [InlineData("ā", "0")]                            // best fit to 'a' (0x61), / 2 = 0x30
    [InlineData("日", "\u001F")]                       // not in 1252: '?' (0x3F), / 2 = 0x1F
    [InlineData("😀", "\u001F\u001F")]           // each surrogate half becomes '?'
    public void ReConvertAsc_matches_the_legacy_function(string input, string expected) =>
        Assert.Equal(expected, LegacyClaimCodec.ReConvertAsc(input));

    [Theory]
    [InlineData("Employee")]
    [InlineData("CFS")]
    [InlineData("Shipper")]
    [InlineData("H-Stratagic")]
    public void ReConvertAsc_undoes_ConvertAsc(string category) =>
        Assert.Equal(category, LegacyClaimCodec.ReConvertAsc(LegacyClaimCodec.ConvertAsc(category)));

    [Fact]
    public void ReConvertAsc_undoes_ConvertAsc_for_every_ASCII_character()
    {
        var ascii = new string(Enumerable.Range(0, 128).Select(i => (char)i).ToArray());
        Assert.Equal(ascii, LegacyClaimCodec.ReConvertAsc(LegacyClaimCodec.ConvertAsc(ascii)));
    }
}

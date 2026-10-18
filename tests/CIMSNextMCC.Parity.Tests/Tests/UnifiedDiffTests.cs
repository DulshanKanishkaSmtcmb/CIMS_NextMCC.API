using CIMSNextMCC.Parity.Tests.Harness;

namespace CIMSNextMCC.Parity.Tests.Tests;

public class UnifiedDiffTests
{
    [Fact]
    public void Equal_texts_give_an_empty_diff() =>
        Assert.Equal(string.Empty, UnifiedDiff.Create("a\nb\r\nc", "a\r\nb\nc"));

    [Fact]
    public void A_changed_line_is_shown_with_context()
    {
        var oldText = string.Join('\n', Enumerable.Range(1, 20).Select(i => $"line {i}"));
        var newText = oldText.Replace("line 10", "line ten");

        var diff = UnifiedDiff.Create(oldText, newText);

        Assert.Equal(
            """
            --- legacy
            +++ new
            @@ -7,7 +7,7 @@
             line 7
             line 8
             line 9
            -line 10
            +line ten
             line 11
             line 12
             line 13
            """.ReplaceLineEndings("\n"),
            diff.ReplaceLineEndings("\n"));
    }

    [Fact]
    public void Added_and_removed_lines_and_separate_hunks()
    {
        var oldText = string.Join('\n', Enumerable.Range(1, 40).Select(i => $"l{i}"));
        var newText = string.Join('\n', Enumerable.Range(1, 40).Where(i => i != 3).Select(i => $"l{i}").Append("l41"));

        var diff = UnifiedDiff.Create(oldText, newText);

        Assert.Contains("-l3", diff);
        Assert.Contains("+l41", diff);
        Assert.Equal(2, diff.Split('\n').Count(l => l.StartsWith("@@", StringComparison.Ordinal)));
    }
}

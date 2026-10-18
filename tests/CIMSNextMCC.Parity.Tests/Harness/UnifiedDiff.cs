using System.Text;

namespace CIMSNextMCC.Parity.Tests.Harness;

/// <summary>Small line-based unified diff (LCS) for canonical JSON text. No dependencies.</summary>
public static class UnifiedDiff
{
    private const long MaxCells = 25_000_000;

    public static bool AreEqual(string a, string b) => SplitLines(a).SequenceEqual(SplitLines(b), StringComparer.Ordinal);

    /// <summary>Returns an empty string when the texts are equal.</summary>
    public static string Create(string oldText, string newText, string oldName = "legacy", string newName = "new", int context = 3)
    {
        var a = SplitLines(oldText);
        var b = SplitLines(newText);
        if (a.SequenceEqual(b, StringComparer.Ordinal))
        {
            return string.Empty;
        }

        var ops = Diff(a, b);
        var sb = new StringBuilder();
        sb.Append("--- ").AppendLine(oldName);
        sb.Append("+++ ").AppendLine(newName);

        var i = 0;
        while (i < ops.Count)
        {
            // find the next change
            while (i < ops.Count && ops[i].Kind == ' ')
            {
                i++;
            }

            if (i >= ops.Count)
            {
                break;
            }

            var start = Math.Max(0, i - context);
            var end = i;
            // extend the hunk while changes are within 2*context of each other
            var lastChange = i;
            var j = i;
            while (j < ops.Count)
            {
                if (ops[j].Kind != ' ')
                {
                    lastChange = j;
                }
                else if (j - lastChange > 2 * context)
                {
                    break;
                }

                j++;
            }

            end = Math.Min(ops.Count, lastChange + context + 1);

            var oldStart = ops[start].OldIndex;
            var newStart = ops[start].NewIndex;
            var oldCount = ops.Skip(start).Take(end - start).Count(o => o.Kind != '+');
            var newCount = ops.Skip(start).Take(end - start).Count(o => o.Kind != '-');
            sb.Append("@@ -").Append(oldStart + 1).Append(',').Append(oldCount)
                .Append(" +").Append(newStart + 1).Append(',').Append(newCount).AppendLine(" @@");
            for (var k = start; k < end; k++)
            {
                sb.Append(ops[k].Kind).AppendLine(ops[k].Text);
            }

            i = end;
        }

        return sb.ToString().TrimEnd('\r', '\n');
    }

    private readonly record struct Op(char Kind, string Text, int OldIndex, int NewIndex);

    private static List<Op> Diff(string[] a, string[] b)
    {
        var prefix = 0;
        while (prefix < a.Length && prefix < b.Length && a[prefix] == b[prefix])
        {
            prefix++;
        }

        var suffix = 0;
        while (suffix < a.Length - prefix && suffix < b.Length - prefix && a[a.Length - 1 - suffix] == b[b.Length - 1 - suffix])
        {
            suffix++;
        }

        var ops = new List<Op>();
        for (var i = 0; i < prefix; i++)
        {
            ops.Add(new Op(' ', a[i], i, i));
        }

        var n = a.Length - prefix - suffix;
        var m = b.Length - prefix - suffix;
        if ((long)(n + 1) * (m + 1) > MaxCells)
        {
            // Too large for an exact diff: report the whole middle as replaced.
            for (var i = 0; i < n; i++)
            {
                ops.Add(new Op('-', a[prefix + i], prefix + i, prefix));
            }

            for (var j = 0; j < m; j++)
            {
                ops.Add(new Op('+', b[prefix + j], prefix + n, prefix + j));
            }
        }
        else
        {
            var lcs = new int[n + 1, m + 1];
            for (var i = n - 1; i >= 0; i--)
            {
                for (var j = m - 1; j >= 0; j--)
                {
                    lcs[i, j] = a[prefix + i] == b[prefix + j] ? lcs[i + 1, j + 1] + 1 : Math.Max(lcs[i + 1, j], lcs[i, j + 1]);
                }
            }

            int x = 0, y = 0;
            while (x < n || y < m)
            {
                if (x < n && y < m && a[prefix + x] == b[prefix + y])
                {
                    ops.Add(new Op(' ', a[prefix + x], prefix + x, prefix + y));
                    x++;
                    y++;
                }
                else if (y >= m || (x < n && lcs[x + 1, y] >= lcs[x, y + 1]))
                {
                    ops.Add(new Op('-', a[prefix + x], prefix + x, prefix + y));
                    x++;
                }
                else
                {
                    ops.Add(new Op('+', b[prefix + y], prefix + x, prefix + y));
                    y++;
                }
            }
        }

        for (var s = 0; s < suffix; s++)
        {
            ops.Add(new Op(' ', a[a.Length - suffix + s], a.Length - suffix + s, b.Length - suffix + s));
        }

        return ops;
    }

    private static string[] SplitLines(string text) =>
        text.Split('\n').Select(l => l.TrimEnd('\r')).ToArray();
}

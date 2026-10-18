using System.Text.RegularExpressions;

namespace CIMSNextMCC.Database;

/// <summary>Offline parse of a script: splits on GO and counts the statements that matter for the baseline.</summary>
public sealed partial record ScriptSummary(
    int Batches,
    int EmptyBatches,
    int Tables,
    int Procedures,
    int Indexes,
    int CreateDatabaseStatements,
    int UseStatements)
{
    public static ScriptSummary Analyze(string sql)
    {
        var batches = SplitBatches(sql);
        var tables = 0;
        var procedures = 0;
        var indexes = 0;
        var empty = 0;

        foreach (var batch in batches)
        {
            var statement = StripLeadingComments(batch);
            if (statement.Length == 0)
            {
                empty++;
            }
            else if (CreateTable().IsMatch(statement))
            {
                tables++;
            }
            else if (CreateProcedure().IsMatch(statement))
            {
                procedures++;
            }
            else if (CreateIndex().IsMatch(statement))
            {
                indexes++;
            }
        }

        return new ScriptSummary(
            batches.Count,
            empty,
            tables,
            procedures,
            indexes,
            CreateDatabase().Count(sql),
            UseDatabase().Count(sql));
    }

    /// <summary>Splits on lines containing only GO (optionally followed by a repeat count), as DbUp and SSMS do.</summary>
    public static List<string> SplitBatches(string sql)
    {
        var batches = new List<string>();
        var current = new List<string>();

        foreach (var line in sql.Split('\n'))
        {
            if (GoLine().IsMatch(line))
            {
                batches.Add(string.Join('\n', current));
                current.Clear();
            }
            else
            {
                current.Add(line.TrimEnd('\r'));
            }
        }

        if (current.Any(l => l.Trim().Length > 0))
        {
            batches.Add(string.Join('\n', current));
        }

        return batches;
    }

    private static string StripLeadingComments(string batch)
    {
        var text = batch.TrimStart();
        while (true)
        {
            if (text.StartsWith("/*", StringComparison.Ordinal))
            {
                var end = text.IndexOf("*/", 2, StringComparison.Ordinal);
                text = end < 0 ? string.Empty : text[(end + 2)..].TrimStart();
            }
            else if (text.StartsWith("--", StringComparison.Ordinal))
            {
                var end = text.IndexOf('\n');
                text = end < 0 ? string.Empty : text[(end + 1)..].TrimStart();
            }
            else
            {
                return text;
            }
        }
    }

    [GeneratedRegex(@"^\s*GO\s*(\d+)?\s*$", RegexOptions.IgnoreCase)]
    private static partial Regex GoLine();

    [GeneratedRegex(@"^CREATE\s+TABLE\b", RegexOptions.IgnoreCase)]
    private static partial Regex CreateTable();

    [GeneratedRegex(@"^CREATE\s+PROC(EDURE)?\b", RegexOptions.IgnoreCase)]
    private static partial Regex CreateProcedure();

    [GeneratedRegex(@"^CREATE\s+(UNIQUE\s+)?((NON)?CLUSTERED\s+)?(COLUMNSTORE\s+)?INDEX\b", RegexOptions.IgnoreCase)]
    private static partial Regex CreateIndex();

    [GeneratedRegex(@"\bCREATE\s+DATABASE\b", RegexOptions.IgnoreCase)]
    private static partial Regex CreateDatabase();

    [GeneratedRegex(@"^\s*USE\s+\[", RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex UseDatabase();
}

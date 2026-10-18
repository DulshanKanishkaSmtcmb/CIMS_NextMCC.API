using System.Globalization;
using System.Text;

namespace CIMSNextMCC.Parity.Tests.Harness;

/// <summary>Renders a <see cref="ParityRun"/> as markdown (TestResults/parity-report.md).</summary>
public static class ParityReport
{
    public static string ToMarkdown(ParityRun run)
    {
        var sb = new StringBuilder();
        sb.AppendLine("# Parity report");
        sb.AppendLine();
        sb.AppendLine(CultureInfo.InvariantCulture, $"* Run (UTC): {run.StartedUtc:yyyy-MM-dd HH:mm:ss}");
        sb.AppendLine(CultureInfo.InvariantCulture, $"* Legacy: `{run.LegacyBaseUrl}`  New: `{run.NewBaseUrl}`");
        sb.AppendLine(CultureInfo.InvariantCulture,
            $"* Recorded lines read: {run.RecordedLines}; distinct calls replayed or classified: {run.Results.Count}");
        sb.AppendLine(CultureInfo.InvariantCulture,
            $"* Verdict: **{(run.HasFailures ? "FAIL" : "PASS")}**");
        sb.AppendLine();

        sb.AppendLine("## Summary");
        sb.AppendLine();
        sb.AppendLine("| Equal | Different | Error | Pending (not ported) | Unmapped | Skipped |");
        sb.AppendLine("|---:|---:|---:|---:|---:|---:|");
        sb.AppendLine(CultureInfo.InvariantCulture,
            $"| {run.Count(ParityOutcome.Equal)} | {run.Count(ParityOutcome.Different)} | {run.Count(ParityOutcome.Error)} | {run.Count(ParityOutcome.Pending)} | {run.Count(ParityOutcome.Unmapped)} | {run.Count(ParityOutcome.Skipped)} |");
        sb.AppendLine();

        sb.AppendLine("## Calls");
        sb.AppendLine();
        sb.AppendLine("| # | Legacy endpoint | Query | Seen | Result | Note |");
        sb.AppendLine("|---:|---|---|---:|---|---|");
        var n = 0;
        foreach (var r in run.Results)
        {
            n++;
            sb.AppendLine(CultureInfo.InvariantCulture,
                $"| {n} | `{r.Endpoint}` | {Cell(r.Call.Query.Length == 0 ? "(none)" : r.Call.Query, 80)} | {r.Occurrences} | {Label(r.Outcome)} | {Cell(r.Detail, 160)} |");
        }

        sb.AppendLine();

        var pending = run.Results.Where(r => r.Outcome is ParityOutcome.Pending or ParityOutcome.Unmapped)
            .GroupBy(r => (r.Endpoint, r.Outcome))
            .ToList();
        if (pending.Count > 0)
        {
            sb.AppendLine("## Pending endpoints");
            sb.AppendLine();
            sb.AppendLine("Recorded but not compared. These do not fail the run; they are the porting backlog.");
            sb.AppendLine();
            foreach (var g in pending)
            {
                var why = g.Key.Outcome == ParityOutcome.Pending ? "map says not-ported" : "no endpoint map";
                sb.AppendLine(CultureInfo.InvariantCulture, $"* `{g.Key.Endpoint}`: {g.Count()} distinct call(s), {why}");
            }

            sb.AppendLine();
        }

        var failures = run.Results.Where(r => r.Outcome is ParityOutcome.Different or ParityOutcome.Error).ToList();
        if (failures.Count > 0)
        {
            sb.AppendLine("## Differences and errors");
            sb.AppendLine();
            foreach (var r in failures)
            {
                sb.AppendLine(CultureInfo.InvariantCulture, $"### {Label(r.Outcome)}: `{r.Call.PathAndQuery}`");
                sb.AppendLine();
                if (r.NewRelativeUrl is not null)
                {
                    sb.AppendLine(CultureInfo.InvariantCulture, $"New request: `GET /{r.NewRelativeUrl}`");
                    sb.AppendLine();
                }

                if (r.Diff is not null)
                {
                    sb.AppendLine("```diff");
                    sb.AppendLine(r.Diff);
                    sb.AppendLine("```");
                }
                else
                {
                    sb.AppendLine(r.Detail);
                }

                sb.AppendLine();
            }
        }

        return sb.ToString();
    }

    public static void Write(ParityRun run, string path)
    {
        var dir = Path.GetDirectoryName(path);
        if (!string.IsNullOrEmpty(dir))
        {
            Directory.CreateDirectory(dir);
        }

        File.WriteAllText(path, ToMarkdown(run), new UTF8Encoding(false));
    }

    private static string Label(ParityOutcome o) => o switch
    {
        ParityOutcome.Equal => "EQUAL",
        ParityOutcome.Different => "DIFFERENT",
        ParityOutcome.Pending => "PENDING",
        ParityOutcome.Unmapped => "UNMAPPED",
        ParityOutcome.Skipped => "SKIPPED",
        _ => "ERROR",
    };

    private static string Cell(string text, int max)
    {
        var t = text.ReplaceLineEndings(" ").Replace("|", "\\|");
        return t.Length > max ? t[..max] + "..." : t;
    }
}

using CIMSNextMCC.Parity.Tests.Harness;

namespace CIMSNextMCC.Parity.Tests;

/// <summary>
/// Golden-master reads (docs/09-modernization-plan.md section 5, docs/12-parity-harness.md).
///
/// Skipped unless PARITY_LEGACY_URL and PARITY_NEW_URL are set (both must be localhost). Then it replays every call
/// recorded by the legacy ParityRecorder (PARITY_RECORDINGS, default tests/CIMSNextMCC.Parity.Tests/recordings) against the
/// legacy app and the new API, writes TestResults/parity-report.md and FAILS on any difference or error. Calls whose endpoint
/// map says "not-ported" are listed as pending and do not fail the test.
/// </summary>
public class GoldenMasterReadTests
{
    [ParityLiveFact]
    public async Task New_read_endpoints_return_the_same_data_as_the_legacy_endpoints()
    {
        var recordingsPath = ParityEnvironment.RecordingsPath;
        var recorded = RecordedCallReader.ReadPath(recordingsPath);
        Assert.True(recorded.Count > 0, $"No recorded calls found in '{recordingsPath}'. Record some first (docs/12-parity-harness.md).");

        var maps = EndpointMapSet.LoadFromDirectory(ParityEnvironment.MapsPath);
        using var runner = new ParityRunner(ParityEnvironment.ToOptions(), maps);

        var run = await runner.RunAsync(recorded);
        ParityReport.Write(run, ParityEnvironment.ReportPath);

        var failures = run.Results.Where(r => r.Outcome is ParityOutcome.Different or ParityOutcome.Error).ToList();
        Assert.True(
            failures.Count == 0,
            $"{failures.Count} of {run.Results.Count} distinct call(s) differ or failed; see {ParityEnvironment.ReportPath}.{Environment.NewLine}"
            + string.Join(Environment.NewLine, failures.Select(f => $"  {f.Outcome}: {f.Call.PathAndQuery}  {f.Detail}")));
    }
}

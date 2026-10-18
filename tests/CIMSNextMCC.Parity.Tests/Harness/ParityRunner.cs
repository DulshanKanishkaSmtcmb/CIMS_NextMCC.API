using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;

namespace CIMSNextMCC.Parity.Tests.Harness;

public enum ParityOutcome
{
    /// <summary>Legacy and new canonical JSON are identical.</summary>
    Equal,

    /// <summary>Both answered, the canonical JSON differs (Diff has the unified diff). Fails the test.</summary>
    Different,

    /// <summary>The map says "not-ported": nothing to compare yet. Does not fail.</summary>
    Pending,

    /// <summary>No endpoint map for this legacy endpoint. Reported, does not fail (v1 harness is opt-in per endpoint).</summary>
    Unmapped,

    /// <summary>Not replayed (not a GET). Does not fail.</summary>
    Skipped,

    /// <summary>Could not compare: HTTP failure, redirect to login, unmapped query parameter, unparsable body, safety guard. Fails the test.</summary>
    Error,
}

public sealed record CallResult(
    RecordedCall Call,
    int Occurrences,
    ParityOutcome Outcome,
    string Endpoint,
    string Detail,
    string? Diff = null,
    string? NewRelativeUrl = null);

public sealed class ParityRun
{
    public required IReadOnlyList<CallResult> Results { get; init; }

    public required int RecordedLines { get; init; }

    public required string LegacyBaseUrl { get; init; }

    public required string NewBaseUrl { get; init; }

    public DateTimeOffset StartedUtc { get; init; } = DateTimeOffset.UtcNow;

    public int Count(ParityOutcome outcome) => Results.Count(r => r.Outcome == outcome);

    public bool HasFailures => Results.Any(r => r.Outcome is ParityOutcome.Different or ParityOutcome.Error);
}

public sealed class ParityRunOptions
{
    public required string LegacyBaseUrl { get; init; }

    public required string NewBaseUrl { get; init; }

    /// <summary>Bearer token for the new API (PARITY_NEW_TOKEN). Never written to the report.</summary>
    public string? NewToken { get; init; }

    /// <summary>Optional X-Tenant header for the new API (PARITY_NEW_TENANT).</summary>
    public string? NewTenant { get; init; }

    /// <summary>Optional value of the legacy .AspNet.ApplicationCookie (PARITY_LEGACY_COOKIE) for [Authorize] endpoints. Never written to the report.</summary>
    public string? LegacyCookie { get; init; }

    public TimeSpan Timeout { get; init; } = TimeSpan.FromMinutes(2);
}

/// <summary>
/// Replays recorded legacy GET calls against the legacy app and the new API and compares the canonical JSON.
/// Safety: both base URLs must be localhost, only GET is ever sent, redirects are not followed (docs/12-parity-harness.md).
/// </summary>
public sealed class ParityRunner : IDisposable
{
    private readonly ParityRunOptions _options;
    private readonly EndpointMapSet _maps;
    private readonly Uri _legacyBase;
    private readonly Uri _newBase;
    private readonly HttpClient _legacy;
    private readonly HttpClient _new;

    /// <param name="legacyHandler">Test seam. Default: a real HttpClientHandler (no redirects, no cookie jar).</param>
    /// <param name="newHandler">Test seam. Default: a real HttpClientHandler.</param>
    public ParityRunner(ParityRunOptions options, EndpointMapSet maps, HttpMessageHandler? legacyHandler = null, HttpMessageHandler? newHandler = null)
    {
        _options = options;
        _maps = maps;
        _legacyBase = SafetyGuards.AssertLocalhost("PARITY_LEGACY_URL", options.LegacyBaseUrl);
        _newBase = SafetyGuards.AssertLocalhost("PARITY_NEW_URL", options.NewBaseUrl);
        _legacy = new HttpClient(new GuardedHandler(legacyHandler ?? NewRealHandler())) { Timeout = options.Timeout };
        _new = new HttpClient(new GuardedHandler(newHandler ?? NewRealHandler())) { Timeout = options.Timeout };
    }

    private static HttpClientHandler NewRealHandler() => new() { AllowAutoRedirect = false, UseCookies = false };

    public async Task<ParityRun> RunAsync(IReadOnlyList<RecordedCall> recorded, CancellationToken cancellationToken = default)
    {
        var results = new List<CallResult>();
        var unique = recorded
            .GroupBy(c => (c.Method.ToUpperInvariant(), c.Path, c.Query))
            .Select(g => (Call: g.First(), Count: g.Count()));

        foreach (var (call, count) in unique)
        {
            results.Add(await ReplayAsync(call, count, cancellationToken));
        }

        return new ParityRun
        {
            Results = results,
            RecordedLines = recorded.Count,
            LegacyBaseUrl = _legacyBase.GetLeftPart(UriPartial.Authority),
            NewBaseUrl = _newBase.GetLeftPart(UriPartial.Authority),
        };
    }

    private async Task<CallResult> ReplayAsync(RecordedCall call, int count, CancellationToken ct)
    {
        var endpoint = call.TryGetControllerAction(out var controller, out var action, out _) ? $"{controller}/{action}" : call.Path;

        if (!call.Method.Equals("GET", StringComparison.OrdinalIgnoreCase))
        {
            return new CallResult(call, count, ParityOutcome.Skipped, endpoint, $"{call.Method} is never replayed (v1 is read-only).");
        }

        var map = _maps.Find(call);
        if (map is null)
        {
            return new CallResult(call, count, ParityOutcome.Unmapped, endpoint, "No endpoint map in maps/*.json for this legacy endpoint.");
        }

        if (!map.IsPorted)
        {
            return new CallResult(call, count, ParityOutcome.Pending, endpoint, map.Notes ?? "Not ported yet.");
        }

        NewRequest newRequest;
        try
        {
            newRequest = map.BuildNewRequest(call);
        }
        catch (Exception ex) when (ex is UnmappedParameterException or InvalidOperationException)
        {
            return new CallResult(call, count, ParityOutcome.Error, endpoint, ex.Message);
        }

        var newUrl = newRequest.ToRelativeUrl();
        try
        {
            var (legacyStatus, legacyBody) = await SendAsync(_legacy, new Uri(_legacyBase, call.PathAndQuery), legacy: true, ct);
            if (legacyStatus is < 200 or >= 300)
            {
                return new CallResult(call, count, ParityOutcome.Error, endpoint,
                    DescribeFailure("legacy", legacyStatus, legacyBody), NewRelativeUrl: newUrl);
            }

            var (newStatus, newBody) = await SendAsync(_new, new Uri(_newBase, newUrl), legacy: false, ct);
            if (newStatus == 404 && map.NewShape.SingleRow)
            {
                // A lookup by key: "no such row" is a 404 on the new side and an empty table on the legacy side.
                (newStatus, newBody) = (200, "[]");
            }

            if (newStatus is < 200 or >= 300)
            {
                return new CallResult(call, count, ParityOutcome.Error, endpoint,
                    DescribeFailure("new", newStatus, newBody), NewRelativeUrl: newUrl);
            }

            string legacyCanonical, newCanonical;
            try
            {
                legacyCanonical = Normalizer.CanonicalizeLegacy(legacyBody, map);
                newCanonical = Normalizer.CanonicalizeNew(newBody, map);
            }
            catch (NormalizationException ex)
            {
                return new CallResult(call, count, ParityOutcome.Error, endpoint, $"Normalization failed: {ex.Message}", NewRelativeUrl: newUrl);
            }

            var drift = Sha256Hex(legacyBody) == call.Sha256 ? "recorded body unchanged" : "legacy data changed since the recording";
            var diff = UnifiedDiff.Create(legacyCanonical, newCanonical, "legacy (canonical)", "new (canonical)");
            return diff.Length == 0
                ? new CallResult(call, count, ParityOutcome.Equal, endpoint, drift, NewRelativeUrl: newUrl)
                : new CallResult(call, count, ParityOutcome.Different, endpoint, drift, diff, newUrl);
        }
        catch (ParitySafetyException ex)
        {
            return new CallResult(call, count, ParityOutcome.Error, endpoint, $"Safety guard: {ex.Message}", NewRelativeUrl: newUrl);
        }
        catch (Exception ex) when (ex is HttpRequestException or TaskCanceledException)
        {
            return new CallResult(call, count, ParityOutcome.Error, endpoint, $"HTTP failure: {ex.Message}", NewRelativeUrl: newUrl);
        }
    }

    private async Task<(int Status, string Body)> SendAsync(HttpClient client, Uri url, bool legacy, CancellationToken ct)
    {
        using var request = new HttpRequestMessage(HttpMethod.Get, url); // GET is the only method this class can construct
        request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        if (legacy)
        {
            if (!string.IsNullOrEmpty(_options.LegacyCookie))
            {
                request.Headers.TryAddWithoutValidation("Cookie", $".AspNet.ApplicationCookie={_options.LegacyCookie}");
            }
        }
        else
        {
            if (!string.IsNullOrEmpty(_options.NewToken))
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _options.NewToken);
            }

            if (!string.IsNullOrEmpty(_options.NewTenant))
            {
                request.Headers.TryAddWithoutValidation("X-Tenant", _options.NewTenant);
            }
        }

        using var response = await client.SendAsync(request, ct);
        var body = await response.Content.ReadAsStringAsync(ct);
        return ((int)response.StatusCode, body);
    }

    private static string DescribeFailure(string side, int status, string body)
    {
        var hint = status is >= 300 and < 400
            ? " (redirect, usually to the login page: the endpoint needs PARITY_LEGACY_COOKIE)"
            : status == 401 ? " (unauthorized: check PARITY_NEW_TOKEN / PARITY_LEGACY_COOKIE)" : string.Empty;
        var snippet = body.Length > 200 ? body[..200] + "..." : body;
        return $"{side} answered HTTP {status}{hint}. Body: {snippet.ReplaceLineEndings(" ")}";
    }

    internal static string Sha256Hex(string text) =>
        Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(text))).ToLowerInvariant();

    public void Dispose()
    {
        _legacy.Dispose();
        _new.Dispose();
    }
}

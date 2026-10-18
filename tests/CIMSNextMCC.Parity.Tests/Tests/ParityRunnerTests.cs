using System.Net;
using System.Text;
using CIMSNextMCC.Parity.Tests.Harness;

namespace CIMSNextMCC.Parity.Tests.Tests;

/// <summary>The runner against in-memory servers: always runs, needs no environment variables.</summary>
public class ParityRunnerTests
{
    private const string FieldMap = """
        {
          "legacy": { "controller": "DataApi", "action": "getfldParas" },
          "new": { "route": "api/v1/reference/field-captions" },
          "query": { "uid": null },
          "legacyShape": { "kind": "positionalArray", "names": ["sysCaption","contractNoCaption","poNoCaption","deliveryNoCaption","itemNoCaption"] }
        }
        """;

    private const string AlarmMap = """
        { "legacy": { "controller": "DataApi", "action": "getAlarmStatus" }, "status": "not-ported" }
        """;

    private const string LegacyCaptions = """["Sys","Contract","PO","Delivery","Item"]""";
    private const string NewCaptions = """{"sysCaption":"Sys","contractNoCaption":"Contract","itemNoCaption":"Item","poNoCaption":"PO","deliveryNoCaption":"Delivery"}""";

    private sealed class FakeServer(Func<HttpRequestMessage, (HttpStatusCode, string)> respond) : HttpMessageHandler
    {
        public List<HttpRequestMessage> Requests { get; } = [];

        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            Requests.Add(request);
            var (status, body) = respond(request);
            return Task.FromResult(new HttpResponseMessage(status) { Content = new StringContent(body, Encoding.UTF8, "application/json") });
        }
    }

    private static RecordedCall Call(string path, string query = "", string method = "GET", string body = LegacyCaptions) =>
        new(DateTimeOffset.UtcNow, "-", method, path, query, 200, body, ParityRunner.Sha256Hex(body), "test", 1);

    private static ParityRunner Runner(FakeServer legacy, FakeServer current, string? token = null, string? legacyUrl = null) =>
        new(new ParityRunOptions
            {
                LegacyBaseUrl = legacyUrl ?? "http://localhost:55243",
                NewBaseUrl = "http://localhost:5212",
                NewToken = token,
                NewTenant = "NextMCC",
            },
            new EndpointMapSet([EndpointMap.Parse(FieldMap), EndpointMap.Parse(AlarmMap)]),
            legacy,
            current);

    [Fact]
    public async Task Equal_and_pending_calls_pass_and_both_servers_are_called_as_planned()
    {
        var legacy = new FakeServer(_ => (HttpStatusCode.OK, LegacyCaptions));
        var current = new FakeServer(_ => (HttpStatusCode.OK, NewCaptions));
        using var runner = Runner(legacy, current, token: "secret-token-123");

        var run = await runner.RunAsync(
        [
            Call("/api/DataApi/getfldParas"),
            Call("/api/DataApi/getfldParas", "uid=U1&_=1"),
            Call("/api/DataApi/getfldParas", "uid=U1&_=2"),
            Call("/api/DataApi/getAlarmStatus", "Alarmid=A1", body: "1"),
        ]);

        Assert.False(run.HasFailures);
        Assert.Equal(3, run.Count(ParityOutcome.Equal));
        Assert.Equal(1, run.Count(ParityOutcome.Pending));
        Assert.Equal(4, run.RecordedLines);

        Assert.All(legacy.Requests.Concat(current.Requests), r => Assert.Equal(HttpMethod.Get, r.Method));
        Assert.All(current.Requests, r =>
        {
            Assert.Equal("/api/v1/reference/field-captions", r.RequestUri!.AbsolutePath);
            Assert.Equal(string.Empty, r.RequestUri.Query);
            Assert.Equal("Bearer secret-token-123", r.Headers.Authorization!.ToString());
            Assert.Equal("NextMCC", r.Headers.GetValues("X-Tenant").Single());
        });
        Assert.Equal(3, legacy.Requests.Count);
        Assert.DoesNotContain("secret-token-123", ParityReport.ToMarkdown(run));
    }

    [Fact]
    public async Task A_value_difference_is_reported_with_a_readable_diff()
    {
        var legacy = new FakeServer(_ => (HttpStatusCode.OK, LegacyCaptions));
        var current = new FakeServer(_ => (HttpStatusCode.OK, NewCaptions.Replace("\"Item\"", "\"Articles\"")));
        using var runner = Runner(legacy, current);

        var run = await runner.RunAsync([Call("/api/DataApi/getfldParas")]);

        var result = Assert.Single(run.Results);
        Assert.Equal(ParityOutcome.Different, result.Outcome);
        Assert.True(run.HasFailures);
        Assert.Contains("-  \"itemnocaption\": \"Item\"", result.Diff);
        Assert.Contains("+  \"itemnocaption\": \"Articles\"", result.Diff);
        var report = ParityReport.ToMarkdown(run);
        Assert.Contains("```diff", report);
        Assert.Contains("Verdict: **FAIL**", report);
    }

    [Fact]
    public async Task A_legacy_redirect_to_login_and_a_new_401_are_errors_with_hints()
    {
        var redirected = new FakeServer(_ => (HttpStatusCode.Redirect, string.Empty));
        var ok = new FakeServer(_ => (HttpStatusCode.OK, NewCaptions));
        using (var runner = Runner(redirected, ok))
        {
            var result = Assert.Single((await runner.RunAsync([Call("/api/DataApi/getfldParas")])).Results);
            Assert.Equal(ParityOutcome.Error, result.Outcome);
            Assert.Contains("PARITY_LEGACY_COOKIE", result.Detail);
        }

        var legacyOk = new FakeServer(_ => (HttpStatusCode.OK, LegacyCaptions));
        var unauthorized = new FakeServer(_ => (HttpStatusCode.Unauthorized, string.Empty));
        using (var runner = Runner(legacyOk, unauthorized))
        {
            var result = Assert.Single((await runner.RunAsync([Call("/api/DataApi/getfldParas")])).Results);
            Assert.Equal(ParityOutcome.Error, result.Outcome);
            Assert.Contains("PARITY_NEW_TOKEN", result.Detail);
        }
    }

    [Fact]
    public async Task Unmapped_endpoints_non_get_calls_and_unmapped_parameters_are_classified_without_touching_the_servers()
    {
        var legacy = new FakeServer(_ => throw new InvalidOperationException("must not be called"));
        var current = new FakeServer(_ => throw new InvalidOperationException("must not be called"));
        using var runner = Runner(legacy, current);

        var run = await runner.RunAsync(
        [
            Call("/api/DataApi/getSomethingNew"),
            Call("/api/SaveApi/SaveX", method: "POST"),
            Call("/api/DataApi/getfldParas", "surprise=1"),
        ]);

        Assert.Equal([ParityOutcome.Unmapped, ParityOutcome.Skipped, ParityOutcome.Error], run.Results.Select(r => r.Outcome));
        Assert.Empty(legacy.Requests);
        Assert.Empty(current.Requests);
        Assert.Contains("surprise", run.Results[2].Detail);
    }

    [Fact]
    public async Task A_legacy_data_change_since_the_recording_is_noted()
    {
        var legacy = new FakeServer(_ => (HttpStatusCode.OK, LegacyCaptions));
        var current = new FakeServer(_ => (HttpStatusCode.OK, NewCaptions));
        using var runner = Runner(legacy, current);

        var run = await runner.RunAsync(
        [
            Call("/api/DataApi/getfldParas", "uid=a"),
            Call("/api/DataApi/getfldParas", "uid=b", body: """["Old","Contract","PO","Delivery","Item"]"""),
        ]);

        Assert.Equal("recorded body unchanged", run.Results[0].Detail);
        Assert.Equal("legacy data changed since the recording", run.Results[1].Detail);
    }

    [Theory]
    [InlineData("http://192.168.100.20")]
    [InlineData("https://prod.example.com")]
    public void A_non_local_legacy_url_cannot_even_start_a_run(string url)
    {
        var server = new FakeServer(_ => (HttpStatusCode.OK, "[]"));
        Assert.Throws<ParitySafetyException>(() => Runner(server, server, legacyUrl: url));
    }

    [Fact]
    public async Task Post_put_and_delete_cannot_leave_the_http_clients()
    {
        var server = new FakeServer(_ => (HttpStatusCode.OK, "[]"));
        var guarded = new HttpClient(new GuardedHandler(server));

        foreach (var method in new[] { HttpMethod.Post, HttpMethod.Put, HttpMethod.Delete })
        {
            await Assert.ThrowsAsync<ParitySafetyException>(() =>
                guarded.SendAsync(new HttpRequestMessage(method, "http://localhost:5212/api/v1/x")));
        }

        await Assert.ThrowsAsync<ParitySafetyException>(() => guarded.GetAsync("http://example.com/"));
        Assert.Empty(server.Requests);
    }
}

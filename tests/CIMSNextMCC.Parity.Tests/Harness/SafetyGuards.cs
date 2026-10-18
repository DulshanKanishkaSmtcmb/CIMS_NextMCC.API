using System.Data.Common;

namespace CIMSNextMCC.Parity.Tests.Harness;

/// <summary>Guards that keep the harness away from anything but local, disposable systems (docs/12-parity-harness.md).</summary>
public static class SafetyGuards
{
    /// <summary>The URL must be absolute http(s) and its host localhost, 127.0.0.1, ::1 or *.localhost.</summary>
    public static Uri AssertLocalhost(string what, string? url)
    {
        if (string.IsNullOrWhiteSpace(url) || !Uri.TryCreate(url, UriKind.Absolute, out var uri)
            || (uri.Scheme != Uri.UriSchemeHttp && uri.Scheme != Uri.UriSchemeHttps))
        {
            throw new ParitySafetyException($"{what} must be an absolute http(s) URL, got '{url}'.");
        }

        if (!IsLocalHost(uri.Host))
        {
            throw new ParitySafetyException(
                $"{what} must point at localhost (localhost, 127.0.0.1, ::1 or *.localhost), got host '{uri.Host}'. The harness never talks to a non-local system.");
        }

        return uri;
    }

    public static bool IsLocalHost(string host)
    {
        var h = host.Trim('[', ']');
        return h.Equals("localhost", StringComparison.OrdinalIgnoreCase)
            || h.EndsWith(".localhost", StringComparison.OrdinalIgnoreCase)
            || h == "127.0.0.1"
            || h == "::1";
    }

    /// <summary>v1 is read-only: only GET is ever sent.</summary>
    public static void AssertReadOnlyMethod(HttpMethod method)
    {
        if (method != HttpMethod.Get)
        {
            throw new ParitySafetyException($"Parity harness v1 only sends GET, refusing {method}.");
        }
    }

    /// <summary>
    /// Any connection string the harness reads must name a database whose name ends in Test or Dev.
    /// (v1 reads none; v2 write-effect tests will.) The string itself is never echoed in the error.
    /// </summary>
    public static string AssertTestDatabase(string connectionString)
    {
        var builder = new DbConnectionStringBuilder();
        try
        {
            builder.ConnectionString = connectionString;
        }
        catch (ArgumentException)
        {
            throw new ParitySafetyException("The connection string could not be parsed, refusing to use it.");
        }

        string? database = null;
        foreach (var key in new[] { "Initial Catalog", "Database" })
        {
            if (builder.TryGetValue(key, out var value) && value is string s && s.Length > 0)
            {
                database = s;
                break;
            }
        }

        if (database is null
            || !(database.EndsWith("Test", StringComparison.OrdinalIgnoreCase) || database.EndsWith("Dev", StringComparison.OrdinalIgnoreCase)))
        {
            throw new ParitySafetyException(
                $"The harness only works against databases whose name ends in Test or Dev, got '{database ?? "(none)"}'.");
        }

        return database;
    }
}

public sealed class ParitySafetyException(string message) : Exception(message);

/// <summary>Last line of defence for every request the harness makes: GET only, localhost only (also for any redirect target).</summary>
internal sealed class GuardedHandler(HttpMessageHandler inner) : DelegatingHandler(inner)
{
    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        SafetyGuards.AssertReadOnlyMethod(request.Method);
        SafetyGuards.AssertLocalhost("Request URL", request.RequestUri?.ToString());
        return base.SendAsync(request, cancellationToken);
    }
}

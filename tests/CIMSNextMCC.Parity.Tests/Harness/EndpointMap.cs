using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace CIMSNextMCC.Parity.Tests.Harness;

/// <summary>
/// Maps one legacy endpoint (controller/action) to its replacement. One JSON file per endpoint in maps/*.json,
/// see docs/12-parity-harness.md for the schema.
/// </summary>
public sealed class EndpointMap
{
    public const string StatusPorted = "ported";
    public const string StatusNotPorted = "not-ported";

    public LegacyEndpoint Legacy { get; init; } = new();

    /// <summary>"ported" (replayed and compared) or "not-ported" (reported as pending, never fails).</summary>
    public string Status { get; init; } = StatusPorted;

    public NewEndpoint? New { get; init; }

    /// <summary>
    /// Legacy query parameter (case-insensitive) to the new query parameter name; a null value drops the parameter.
    /// A parameter that is not listed (and is not in <see cref="DefaultDroppedParameters"/>) makes the call an error,
    /// so nobody forgets to decide what a legacy parameter becomes. A legacy path id segment (api/{controller}/{action}/{id})
    /// is treated as a parameter named "id". If <see cref="NewEndpoint.Route"/> has a "{name}" placeholder, the mapped
    /// parameter of that name is substituted into the route instead of being sent as a query parameter.
    /// </summary>
    public Dictionary<string, string?> Query { get; init; } = new();

    /// <summary>
    /// Legacy query parameters that carry a JSON array/object (most DataApi reads: strData=[{...}]). Key = the legacy
    /// parameter name (case-insensitive), value = JSON property (case-insensitive) to new query name; null drops the
    /// property, an unlisted property is an error. The parameter itself is consumed and must not also appear in
    /// <see cref="Query"/>.
    /// </summary>
    public Dictionary<string, Dictionary<string, string?>> QueryJson { get; init; } = new();

    /// <summary>Query parameters always sent to the new endpoint.</summary>
    public Dictionary<string, string> ConstantQuery { get; init; } = new();

    public LegacyShape LegacyShape { get; init; } = new();

    public NewShape NewShape { get; init; } = new();

    public NormalizeOptions Options { get; init; } = new();

    public string? Notes { get; init; }

    /// <summary>Parameters that are dropped without being listed: jQuery's cache-buster.</summary>
    public static readonly string[] DefaultDroppedParameters = ["_"];

    public bool IsPorted => string.Equals(Status, StatusPorted, StringComparison.OrdinalIgnoreCase);

    public string Key => $"{Legacy.Controller}/{Legacy.Action}";

    /// <summary>Builds the new endpoint's route and query for a recorded legacy call.</summary>
    public NewRequest BuildNewRequest(RecordedCall call)
    {
        if (New is null || string.IsNullOrWhiteSpace(New.Route))
        {
            throw new InvalidOperationException($"{Key} has no 'new.route'.");
        }

        call.TryGetControllerAction(out _, out _, out var legacyId);
        var legacyParams = QueryString.Parse(call.Query);
        if (legacyId is not null)
        {
            legacyParams.Add(("id", legacyId));
        }

        var mapped = new Dictionary<string, string?>(StringComparer.OrdinalIgnoreCase);
        var newQuery = new List<(string Name, string Value)>();
        foreach (var (name, value) in legacyParams)
        {
            if (QueryJson.TryGetValue(name, out var propertyMap))
            {
                foreach (var (newJsonName, jsonValue) in ExpandJsonParameter(name, value, propertyMap))
                {
                    mapped[newJsonName] = jsonValue;
                    newQuery.Add((newJsonName, jsonValue));
                }

                continue;
            }

            if (!Query.TryGetValue(name, out var newName))
            {
                if (DefaultDroppedParameters.Contains(name, StringComparer.OrdinalIgnoreCase))
                {
                    continue;
                }

                throw new UnmappedParameterException(Key, name);
            }

            if (newName is null)
            {
                continue;
            }

            mapped[newName] = value;
            newQuery.Add((newName, value));
        }

        var route = New.Route.TrimStart('/');
        foreach (var placeholder in RoutePlaceholders(route))
        {
            if (!mapped.TryGetValue(placeholder, out var v) || v is null)
            {
                throw new InvalidOperationException(
                    $"{Key}: route '{New.Route}' needs a value for {{{placeholder}}} but the call does not carry it. Map a legacy parameter to '{placeholder}' under 'query'.");
            }

            route = route.Replace("{" + placeholder + "}", Uri.EscapeDataString(v), StringComparison.Ordinal);
            newQuery.RemoveAll(q => q.Name.Equals(placeholder, StringComparison.OrdinalIgnoreCase));
        }

        foreach (var (name, value) in ConstantQuery)
        {
            newQuery.Add((name, value));
        }

        return new NewRequest(New.Method, route, newQuery);
    }

    /// <summary>
    /// Splits a legacy parameter that carries JSON (e.g. strData=[{"strDC":"All",...}]): the value is parsed as a JSON
    /// array (first element) or object, and each property is mapped like a <see cref="Query"/> entry. A property that is
    /// not listed is an error; an empty parameter value yields nothing. Property values are sent as text (strings as
    /// they are, numbers invariant, booleans true/false, null as an empty string); empty values are still sent, so drop
    /// the property (null) when the new API should not see it.
    /// </summary>
    private IEnumerable<(string Name, string Value)> ExpandJsonParameter(string parameter, string json, Dictionary<string, string?> propertyMap)
    {
        if (string.IsNullOrWhiteSpace(json))
        {
            yield break;
        }

        System.Text.Json.JsonElement element;
        try
        {
            using var doc = System.Text.Json.JsonDocument.Parse(json);
            element = doc.RootElement.Clone();
        }
        catch (System.Text.Json.JsonException ex)
        {
            throw new InvalidOperationException($"{Key}: query parameter '{parameter}' is not valid JSON ({ex.Message}).");
        }

        if (element.ValueKind == System.Text.Json.JsonValueKind.Array)
        {
            if (element.GetArrayLength() == 0)
            {
                yield break;
            }

            element = element[0];
        }

        if (element.ValueKind != System.Text.Json.JsonValueKind.Object)
        {
            throw new InvalidOperationException($"{Key}: query parameter '{parameter}' must be a JSON object or an array of objects.");
        }

        foreach (var property in element.EnumerateObject())
        {
            if (!propertyMap.TryGetValue(property.Name, out var newName))
            {
                throw new UnmappedParameterException(Key, $"{parameter}.{property.Name}");
            }

            if (newName is null)
            {
                continue;
            }

            var text = property.Value.ValueKind switch
            {
                System.Text.Json.JsonValueKind.String => property.Value.GetString() ?? string.Empty,
                System.Text.Json.JsonValueKind.Number => property.Value.GetRawText(),
                System.Text.Json.JsonValueKind.True => "true",
                System.Text.Json.JsonValueKind.False => "false",
                System.Text.Json.JsonValueKind.Null => string.Empty,
                _ => throw new InvalidOperationException($"{Key}: '{parameter}.{property.Name}' is a nested JSON value, which queryJson does not support."),
            };
            yield return (newName, text);
        }
    }

    private static IEnumerable<string> RoutePlaceholders(string route)
    {
        var start = 0;
        while ((start = route.IndexOf('{', start)) >= 0)
        {
            var end = route.IndexOf('}', start);
            if (end < 0)
            {
                yield break;
            }

            yield return route.Substring(start + 1, end - start - 1);
            start = end + 1;
        }
    }

    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        ReadCommentHandling = JsonCommentHandling.Skip,
        AllowTrailingCommas = true,
        UnmappedMemberHandling = JsonUnmappedMemberHandling.Disallow, // a typo in a map must not silently weaken a check
    };

    public static EndpointMap Parse(string json, string source = "(inline)")
    {
        EndpointMap map;
        try
        {
            map = JsonSerializer.Deserialize<EndpointMap>(json, JsonOptions)
                ?? throw new InvalidDataException("empty map");
        }
        catch (JsonException ex)
        {
            throw new InvalidDataException($"Bad endpoint map {source}: {ex.Message}", ex);
        }

        map.Validate(source);
        return new EndpointMap
        {
            Legacy = map.Legacy,
            Status = map.Status.ToLowerInvariant(),
            New = map.New,
            Query = new Dictionary<string, string?>(map.Query, StringComparer.OrdinalIgnoreCase),
            QueryJson = map.QueryJson.ToDictionary(
                e => e.Key,
                e => new Dictionary<string, string?>(e.Value, StringComparer.OrdinalIgnoreCase),
                StringComparer.OrdinalIgnoreCase),
            ConstantQuery = map.ConstantQuery,
            LegacyShape = map.LegacyShape,
            NewShape = map.NewShape,
            Options = map.Options,
            Notes = map.Notes,
        };
    }

    private void Validate(string source)
    {
        string Fail(string why) => $"Bad endpoint map {source}: {why}";
        if (string.IsNullOrWhiteSpace(Legacy.Controller) || string.IsNullOrWhiteSpace(Legacy.Action))
        {
            throw new InvalidDataException(Fail("'legacy.controller' and 'legacy.action' are required."));
        }

        if (!string.Equals(Legacy.Method, "GET", StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidDataException(Fail("v1 only supports legacy.method GET."));
        }

        foreach (var name in QueryJson.Keys)
        {
            if (Query.Keys.Contains(name, StringComparer.OrdinalIgnoreCase))
            {
                throw new InvalidDataException(Fail($"'{name}' is listed under both 'query' and 'queryJson'."));
            }
        }

        var status = Status.ToLowerInvariant();
        if (status is not (StatusPorted or StatusNotPorted))
        {
            throw new InvalidDataException(Fail($"'status' must be '{StatusPorted}' or '{StatusNotPorted}'."));
        }

        if (status == StatusPorted)
        {
            if (New is null || string.IsNullOrWhiteSpace(New.Route))
            {
                throw new InvalidDataException(Fail("a ported endpoint needs 'new.route'."));
            }

            if (!string.Equals(New.Method, "GET", StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidDataException(Fail("v1 only supports new.method GET."));
            }
        }

        LegacyShape.Validate(source);
        NewShape.Validate(source);
    }
}

public sealed class LegacyEndpoint
{
    public string Controller { get; init; } = string.Empty;

    public string Action { get; init; } = string.Empty;

    public string Method { get; init; } = "GET";
}

public sealed class NewEndpoint
{
    public string Method { get; init; } = "GET";

    /// <summary>Route template relative to the new base URL, e.g. "api/v1/reference/field-captions" or "api/v1/x/{id}".</summary>
    public string Route { get; init; } = string.Empty;
}

/// <summary>How to read the legacy response body.</summary>
public sealed class LegacyShape
{
    public const string Json = "json";
    public const string PositionalArray = "positionalArray";
    public const string DataRtnCls = "dataRtnCls";

    /// <summary>"json" (the body is the value), "positionalArray" (JSON array turned into an object with <see cref="Names"/>) or "dataRtnCls" (the DataRtnCls envelope; compares <see cref="Tables"/>).</summary>
    public string Kind { get; init; } = Json;

    /// <summary>positionalArray: property name for each array position.</summary>
    public List<string> Names { get; init; } = [];

    /// <summary>dataRtnCls: envelope tables to compare, default ["dtMain"].</summary>
    public List<string> Tables { get; init; } = ["dtMain"];

    /// <summary>dataRtnCls: legacy column name to the new property name (case-insensitive); unlisted columns keep their name.</summary>
    public Dictionary<string, string> ColumnMap { get; init; } = new();

    internal void Validate(string source)
    {
        if (!Kind.Equals(Json, StringComparison.OrdinalIgnoreCase)
            && !Kind.Equals(PositionalArray, StringComparison.OrdinalIgnoreCase)
            && !Kind.Equals(DataRtnCls, StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidDataException($"Bad endpoint map {source}: legacyShape.kind '{Kind}' is not json, positionalArray or dataRtnCls.");
        }

        if (Kind.Equals(PositionalArray, StringComparison.OrdinalIgnoreCase) && Names.Count == 0)
        {
            throw new InvalidDataException($"Bad endpoint map {source}: legacyShape.names is required for positionalArray.");
        }
    }
}

/// <summary>How to read the new response body.</summary>
public sealed class NewShape
{
    public const string Json = "json";
    public const string Rows = "rows";

    /// <summary>"json" (the whole body) or "rows" (one array per legacy table, found at <see cref="RowsPaths"/>).</summary>
    public string Kind { get; init; } = Json;

    /// <summary>rows: dotted property path to the array for each legacy table, in the order of legacyShape.tables; "" means the body itself.</summary>
    public List<string> RowsPaths { get; init; } = [];

    internal void Validate(string source)
    {
        if (!Kind.Equals(Json, StringComparison.OrdinalIgnoreCase) && !Kind.Equals(Rows, StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidDataException($"Bad endpoint map {source}: newShape.kind '{Kind}' is not json or rows.");
        }
    }
}

/// <summary>Switches that tune the comparison for one endpoint; keep them at the defaults unless a documented difference requires otherwise.</summary>
public sealed class NormalizeOptions
{
    /// <summary>Treat null and "" as the same value (legacy status columns use "" where the new API may use null).</summary>
    public bool NullAsEmpty { get; init; }

    /// <summary>Compare rows as a set (sorted) instead of in order. Only for endpoints whose legacy SQL has no ORDER BY.</summary>
    public bool UnorderedRows { get; init; }

    /// <summary>Columns/properties dropped on both sides before comparing (case-insensitive), e.g. a timestamp that always differs.</summary>
    public List<string> IgnoreColumns { get; init; } = [];
}

public sealed record NewRequest(string Method, string Route, IReadOnlyList<(string Name, string Value)> Query)
{
    public string ToRelativeUrl()
    {
        var sb = new StringBuilder(Route);
        for (var i = 0; i < Query.Count; i++)
        {
            sb.Append(i == 0 ? '?' : '&')
                .Append(Uri.EscapeDataString(Query[i].Name)).Append('=').Append(Uri.EscapeDataString(Query[i].Value));
        }

        return sb.ToString();
    }
}

public sealed class UnmappedParameterException(string endpoint, string parameter)
    : Exception($"{endpoint}: legacy query parameter '{parameter}' has no entry under 'query' in the endpoint map (map it to a new name, or to null to drop it).");

internal static class QueryString
{
    /// <summary>Parses a raw query string (no leading '?') into decoded pairs, keeping order and repeats.</summary>
    public static List<(string Name, string Value)> Parse(string raw)
    {
        var result = new List<(string, string)>();
        foreach (var part in raw.Split('&', StringSplitOptions.RemoveEmptyEntries))
        {
            var eq = part.IndexOf('=');
            var name = eq < 0 ? part : part[..eq];
            var value = eq < 0 ? string.Empty : part[(eq + 1)..];
            result.Add((Decode(name), Decode(value)));
        }

        return result;
    }

    private static string Decode(string s) => Uri.UnescapeDataString(s.Replace('+', ' '));
}

/// <summary>All maps found in a folder, keyed by legacy controller/action.</summary>
public sealed class EndpointMapSet
{
    private readonly Dictionary<string, EndpointMap> _byKey;

    public EndpointMapSet(IEnumerable<EndpointMap> maps)
    {
        _byKey = new Dictionary<string, EndpointMap>(StringComparer.OrdinalIgnoreCase);
        foreach (var map in maps)
        {
            if (!_byKey.TryAdd(map.Key, map))
            {
                throw new InvalidDataException($"Two endpoint maps for {map.Key}.");
            }
        }
    }

    public IReadOnlyCollection<EndpointMap> Maps => _byKey.Values;

    public static EndpointMapSet LoadFromDirectory(string directory)
    {
        if (!Directory.Exists(directory))
        {
            throw new DirectoryNotFoundException($"Endpoint map folder not found: {directory}");
        }

        return new EndpointMapSet(
            Directory.EnumerateFiles(directory, "*.json")
                .OrderBy(f => f, StringComparer.OrdinalIgnoreCase)
                .Select(f => EndpointMap.Parse(File.ReadAllText(f), Path.GetFileName(f))));
    }

    public EndpointMap? Find(RecordedCall call) =>
        call.TryGetControllerAction(out var controller, out var action, out _)
        && _byKey.TryGetValue($"{controller}/{action}", out var map)
            ? map
            : null;
}

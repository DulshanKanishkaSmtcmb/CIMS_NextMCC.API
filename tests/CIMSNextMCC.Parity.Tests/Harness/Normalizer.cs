using System.Globalization;
using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace CIMSNextMCC.Parity.Tests.Harness;

/// <summary>
/// Turns a legacy response and a new response into the same canonical JSON text so they can be diffed line by line.
///
/// Canonical form (docs/12-parity-harness.md, "Normalization"):
///  * object property names lower-cased and sorted ordinally (legacy DataTable column names are case-insensitive and
///    unordered; the new API's casing and property order are irrelevant);
///  * strings trimmed (leading/trailing whitespace; SQL CHAR padding), and strings that are dates are rewritten as ISO:
///    "yyyy-MM-dd" when the time of day is midnight, else "yyyy-MM-ddTHH:mm:ss[.fff]". Recognised inputs are ISO 8601
///    (offsets are converted to UTC and dropped) and the legacy dd/MM/yyyy[ HH:mm[:ss]] strings;
///  * numbers rewritten with the invariant culture and no trailing zeros (1.50, 1.5 and 1.5e0 are all "1.5"; 10 and 10.0 are "10");
///    a number and a numeric string stay different on purpose (a type change is a real difference);
///  * array order is kept (SQL ORDER BY is part of the contract) unless NormalizeOptions.UnorderedRows is set;
///  * optional: null equals "" (NormalizeOptions.NullAsEmpty), ignored columns (NormalizeOptions.IgnoreColumns).
///
/// Envelope handling is per side: the legacy DataRtnCls envelope is reduced to the requested tables (dtMain by default;
/// dtHeading, strRtnPara, the is*Order flags and msg are deliberately not compared), a legacy positional array
/// (getfldParas) becomes an object with the names from the map, and the new typed JSON is read whole or from the
/// rows path(s) in the map.
/// </summary>
public static class Normalizer
{
    private static readonly string[] DateFormats =
    [
        "yyyy-MM-dd",
        "yyyy-MM-ddTHH:mm:ss",
        "yyyy-MM-ddTHH:mm:ss.FFFFFFF",
        "yyyy-MM-ddTHH:mm:ssK",
        "yyyy-MM-ddTHH:mm:ss.FFFFFFFK",
        "yyyy-MM-dd HH:mm:ss",
        "dd/MM/yyyy",
        "dd/MM/yyyy HH:mm",
        "dd/MM/yyyy HH:mm:ss",
    ];

    private static readonly JsonSerializerOptions Pretty = new()
    {
        WriteIndented = true,
        Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping,
    };

    /// <summary>Canonical text of the legacy body as described by the map.</summary>
    public static string CanonicalizeLegacy(string body, EndpointMap map)
    {
        var shape = map.LegacyShape;
        using var doc = Parse(body, "legacy");
        var root = doc.RootElement;
        var options = map.Options;

        JsonNode? result;
        if (shape.Kind.Equals(LegacyShape.PositionalArray, StringComparison.OrdinalIgnoreCase))
        {
            if (root.ValueKind != JsonValueKind.Array)
            {
                throw new NormalizationException($"legacy body is not a JSON array (positionalArray), it is {root.ValueKind}.");
            }

            if (root.GetArrayLength() != shape.Names.Count)
            {
                throw new NormalizationException(
                    $"legacy array has {root.GetArrayLength()} items but legacyShape.names lists {shape.Names.Count}.");
            }

            var obj = new JsonObject();
            var i = 0;
            foreach (var item in root.EnumerateArray())
            {
                obj[shape.Names[i++]] = JsonValue.Create(item.Clone());
            }

            result = Canonicalize(JsonSerializer.SerializeToElement(obj), options, rowColumns: null);
        }
        else if (shape.Kind.Equals(LegacyShape.DataRtnCls, StringComparison.OrdinalIgnoreCase))
        {
            if (root.ValueKind != JsonValueKind.Object)
            {
                throw new NormalizationException($"legacy body is not a DataRtnCls object, it is {root.ValueKind}.");
            }

            var columnMap = new Dictionary<string, string>(shape.ColumnMap, StringComparer.OrdinalIgnoreCase);
            var tables = new JsonObject();
            foreach (var table in shape.Tables)
            {
                tables[table.ToLowerInvariant()] = CanonicalRows(FindProperty(root, table), options, columnMap, $"legacy table '{table}'");
            }

            result = shape.Tables.Count == 1 ? tables[shape.Tables[0].ToLowerInvariant()] : tables;
        }
        else
        {
            result = Canonicalize(root, options, rowColumns: null);
        }

        return Render(result);
    }

    /// <summary>Canonical text of the new body as described by the map.</summary>
    public static string CanonicalizeNew(string body, EndpointMap map)
    {
        var shape = map.NewShape;
        using var doc = Parse(body, "new");
        var options = map.Options;
        JsonNode? result;

        if (shape.Kind.Equals(NewShape.Rows, StringComparison.OrdinalIgnoreCase))
        {
            var tables = map.LegacyShape.Tables;
            if (shape.RowsPaths.Count != tables.Count)
            {
                throw new NormalizationException(
                    $"newShape.rowsPaths has {shape.RowsPaths.Count} entries but legacyShape.tables has {tables.Count}.");
            }

            var byTable = new JsonObject();
            for (var i = 0; i < tables.Count; i++)
            {
                var element = ResolvePath(doc.RootElement, shape.RowsPaths[i]);
                byTable[tables[i].ToLowerInvariant()] = CanonicalRows(element, options, columnMap: null, $"new rows at '{shape.RowsPaths[i]}'", shape.SingleRow);
            }

            result = tables.Count == 1 ? byTable[tables[0].ToLowerInvariant()] : byTable;
        }
        else
        {
            result = Canonicalize(doc.RootElement, options, rowColumns: null);
        }

        return Render(result);
    }

    /// <summary>Canonical form of any JSON text with the given options (public for tests and ad-hoc use).</summary>
    public static string Canonicalize(string json, NormalizeOptions? options = null)
    {
        using var doc = Parse(json, "input");
        return Render(Canonicalize(doc.RootElement, options ?? new NormalizeOptions(), rowColumns: null));
    }

    private static string Render(JsonNode? node) => node is null ? "null" : node.ToJsonString(Pretty);

    private static JsonDocument Parse(string body, string side)
    {
        try
        {
            return JsonDocument.Parse(body, new JsonDocumentOptions { CommentHandling = JsonCommentHandling.Skip });
        }
        catch (JsonException ex)
        {
            throw new NormalizationException($"{side} body is not valid JSON: {ex.Message}");
        }
    }

    private static JsonElement FindProperty(JsonElement obj, string name)
    {
        foreach (var p in obj.EnumerateObject())
        {
            if (p.Name.Equals(name, StringComparison.OrdinalIgnoreCase))
            {
                return p.Value;
            }
        }

        throw new NormalizationException($"property '{name}' not found.");
    }

    private static JsonElement ResolvePath(JsonElement root, string dottedPath)
    {
        var current = root;
        foreach (var segment in dottedPath.Split('.', StringSplitOptions.RemoveEmptyEntries))
        {
            if (current.ValueKind != JsonValueKind.Object)
            {
                throw new NormalizationException($"cannot resolve '{dottedPath}': '{segment}' is not under an object.");
            }

            current = FindProperty(current, segment);
        }

        return current;
    }

    private static JsonNode CanonicalRows(JsonElement table, NormalizeOptions options, Dictionary<string, string>? columnMap, string what, bool singleRow = false)
    {
        if (table.ValueKind == JsonValueKind.Null)
        {
            return new JsonArray();
        }

        if (singleRow && table.ValueKind == JsonValueKind.Object)
        {
            return new JsonArray(Canonicalize(table, options, columnMap));
        }

        if (table.ValueKind != JsonValueKind.Array)
        {
            throw new NormalizationException($"{what} is not an array, it is {table.ValueKind}.");
        }

        return Canonicalize(table, options, columnMap)!;
    }

    private static JsonNode? Canonicalize(JsonElement element, NormalizeOptions options, Dictionary<string, string>? rowColumns)
    {
        switch (element.ValueKind)
        {
            case JsonValueKind.Object:
            {
                var ignored = new HashSet<string>(options.IgnoreColumns, StringComparer.OrdinalIgnoreCase);
                var props = new SortedDictionary<string, JsonNode?>(StringComparer.Ordinal);
                foreach (var p in element.EnumerateObject())
                {
                    var name = rowColumns is not null && rowColumns.TryGetValue(p.Name, out var renamed) ? renamed : p.Name;
                    if (ignored.Contains(name) || ignored.Contains(p.Name))
                    {
                        continue;
                    }

                    var key = name.ToLowerInvariant();
                    if (props.ContainsKey(key))
                    {
                        throw new NormalizationException($"two properties normalize to the name '{key}' (case-insensitive clash).");
                    }

                    props[key] = Canonicalize(p.Value, options, rowColumns);
                }

                var obj = new JsonObject();
                foreach (var (k, v) in props)
                {
                    obj[k] = v;
                }

                return obj;
            }

            case JsonValueKind.Array:
            {
                var items = element.EnumerateArray().Select(e => Canonicalize(e, options, rowColumns)).ToList();
                if (options.UnorderedRows)
                {
                    items = items.OrderBy(i => i?.ToJsonString() ?? "null", StringComparer.Ordinal).ToList();
                }

                var arr = new JsonArray();
                foreach (var item in items)
                {
                    arr.Add(item);
                }

                return arr;
            }

            case JsonValueKind.String:
                return JsonValue.Create(NormalizeString(element.GetString() ?? string.Empty));

            case JsonValueKind.Number:
                return JsonRaw(NormalizeNumber(element));

            case JsonValueKind.True:
                return JsonValue.Create(true);

            case JsonValueKind.False:
                return JsonValue.Create(false);

            default: // null / undefined
                return options.NullAsEmpty ? JsonValue.Create(string.Empty) : null;
        }
    }

    internal static string NormalizeString(string value)
    {
        var s = value.Trim();
        if (s.Length >= 8 && s.Length <= 40 && char.IsDigit(s[0])
            && DateTimeOffset.TryParseExact(s, DateFormats, CultureInfo.InvariantCulture,
                DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal, out var parsed))
        {
            var t = parsed.UtcDateTime;
            if (t.TimeOfDay == TimeSpan.Zero)
            {
                return t.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            }

            return t.Millisecond == 0
                ? t.ToString("yyyy-MM-dd'T'HH:mm:ss", CultureInfo.InvariantCulture)
                : t.ToString("yyyy-MM-dd'T'HH:mm:ss.fff", CultureInfo.InvariantCulture);
        }

        return s;
    }

    internal static string NormalizeNumber(JsonElement number)
    {
        if (number.TryGetDecimal(out var d))
        {
            // Dividing by 1.000...m drops trailing zeros without changing the value.
            d /= 1.0000000000000000000000000000m;
            return d.ToString(CultureInfo.InvariantCulture);
        }

        var dbl = number.GetDouble();
        return dbl.ToString("R", CultureInfo.InvariantCulture);
    }

    // A number node that prints exactly the text we computed (JsonValue.Create(decimal) would re-format it).
    private static JsonNode JsonRaw(string numberText) => JsonNode.Parse(numberText)!;
}

public sealed class NormalizationException(string message) : Exception(message);

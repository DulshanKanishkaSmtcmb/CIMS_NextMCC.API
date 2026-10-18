using System.Text.Json;

namespace CIMSNextMCC.Parity.Tests.Harness;

/// <summary>
/// One line of App_Data/Parity/recorded-{date}.jsonl written by the legacy ParityRecorder
/// (legacy workspace: Classes/ParityRecorder.cs). See docs/12-parity-harness.md.
/// </summary>
public sealed record RecordedCall(
    DateTimeOffset Utc,
    string User,
    string Method,
    string Path,
    string Query,
    int Status,
    string Body,
    string Sha256,
    string SourceFile,
    int SourceLine)
{
    /// <summary>Path plus raw query string, e.g. "/api/DataApi/getfldParas?uid=x".</summary>
    public string PathAndQuery => Query.Length == 0 ? Path : $"{Path}?{Query}";

    /// <summary>Legacy route segments: api/{controller}/{action}/{id?}.</summary>
    public bool TryGetControllerAction(out string controller, out string action, out string? id)
    {
        controller = action = string.Empty;
        id = null;
        var segments = Path.Split('/', StringSplitOptions.RemoveEmptyEntries);
        if (segments.Length < 3 || !segments[0].Equals("api", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        controller = segments[1];
        action = segments[2];
        if (segments.Length > 3)
        {
            id = Uri.UnescapeDataString(string.Join('/', segments.Skip(3)));
        }

        return true;
    }
}

/// <summary>Reads recorded-*.jsonl files. A malformed line is a hard error: a golden master must not be silently partial.</summary>
public static class RecordedCallReader
{
    /// <summary>Reads one file, or every *.jsonl in a folder, in file-name then line order.</summary>
    public static IReadOnlyList<RecordedCall> ReadPath(string fileOrDirectory)
    {
        if (Directory.Exists(fileOrDirectory))
        {
            return Directory.EnumerateFiles(fileOrDirectory, "*.jsonl")
                .OrderBy(f => f, StringComparer.OrdinalIgnoreCase)
                .SelectMany(ReadFile)
                .ToList();
        }

        if (File.Exists(fileOrDirectory))
        {
            return ReadFile(fileOrDirectory).ToList();
        }

        throw new FileNotFoundException($"Recordings path not found: {fileOrDirectory}");
    }

    public static IEnumerable<RecordedCall> ReadFile(string path)
    {
        var lineNo = 0;
        // FileShare.ReadWrite: the legacy app may still be appending while we read.
        using var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete);
        using var reader = new StreamReader(stream);
        while (reader.ReadLine() is { } line)
        {
            lineNo++;
            if (string.IsNullOrWhiteSpace(line))
            {
                continue;
            }

            yield return Parse(line, System.IO.Path.GetFileName(path), lineNo);
        }
    }

    public static RecordedCall Parse(string line, string sourceFile = "", int sourceLine = 0)
    {
        try
        {
            using var doc = JsonDocument.Parse(line);
            var root = doc.RootElement;
            return new RecordedCall(
                Utc: DateTimeOffset.Parse(Str(root, "utc"), System.Globalization.CultureInfo.InvariantCulture),
                User: Str(root, "user"),
                Method: Str(root, "method"),
                Path: Str(root, "path"),
                Query: Str(root, "query"),
                Status: root.GetProperty("status").GetInt32(),
                Body: Str(root, "body"),
                Sha256: Str(root, "sha256"),
                SourceFile: sourceFile,
                SourceLine: sourceLine);
        }
        catch (Exception ex) when (ex is JsonException or KeyNotFoundException or InvalidOperationException or FormatException)
        {
            throw new InvalidDataException($"Bad recorded call at {sourceFile}:{sourceLine}: {ex.Message}", ex);
        }
    }

    private static string Str(JsonElement root, string name)
    {
        var value = root.GetProperty(name);
        return value.ValueKind switch
        {
            JsonValueKind.String => value.GetString() ?? string.Empty,
            JsonValueKind.Null => string.Empty,
            _ => value.GetRawText(), // tolerate a recorder that wrote the body as a nested JSON value
        };
    }
}

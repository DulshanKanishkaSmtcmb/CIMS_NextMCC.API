using CIMSNextMCC.Parity.Tests.Harness;

namespace CIMSNextMCC.Parity.Tests.Tests;

public class RecordedCallReaderTests
{
    private const string Line =
        """{"utc":"2026-10-18T08:30:00.123Z","user":"-","method":"GET","path":"/api/DataApi/getfldParas","query":"uid=x&_=1","status":200,"body":"[\"a\",\"b\"]","sha256":"abc"}""";

    [Fact]
    public void A_recorder_line_is_parsed()
    {
        var call = RecordedCallReader.Parse(Line, "recorded-2026-10-18.jsonl", 7);

        Assert.Equal(new DateTimeOffset(2026, 10, 18, 8, 30, 0, 123, TimeSpan.Zero), call.Utc);
        Assert.Equal("-", call.User);
        Assert.Equal("GET", call.Method);
        Assert.Equal("/api/DataApi/getfldParas?uid=x&_=1", call.PathAndQuery);
        Assert.Equal(200, call.Status);
        Assert.Equal("[\"a\",\"b\"]", call.Body);
        Assert.Equal("abc", call.Sha256);
        Assert.True(call.TryGetControllerAction(out var controller, out var action, out var id));
        Assert.Equal(("DataApi", "getfldParas", null), (controller, action, id));
    }

    [Fact]
    public void The_path_id_segment_is_decoded()
    {
        var call = RecordedCallReader.Parse(Line.Replace("getfldParas", "getX/AB%2F1"));
        Assert.True(call.TryGetControllerAction(out _, out var action, out var id));
        Assert.Equal("getX", action);
        Assert.Equal("AB/1", id);
    }

    [Fact]
    public void Files_and_folders_are_read_in_order_skipping_blank_lines_and_a_bad_line_is_an_error()
    {
        var dir = Directory.CreateTempSubdirectory("parity-reader-").FullName;
        try
        {
            File.WriteAllText(Path.Combine(dir, "recorded-2026-10-19.jsonl"), Line.Replace("uid=x", "uid=second") + "\n");
            File.WriteAllText(Path.Combine(dir, "recorded-2026-10-18.jsonl"), Line + "\n\n" + Line.Replace("uid=x", "uid=y") + "\n");

            var calls = RecordedCallReader.ReadPath(dir);
            Assert.Equal(3, calls.Count);
            Assert.Equal(["uid=x&_=1", "uid=y&_=1", "uid=second&_=1"], calls.Select(c => c.Query));
            Assert.Equal(3, calls[1].SourceLine);

            File.AppendAllText(Path.Combine(dir, "recorded-2026-10-19.jsonl"), "{not json\n");
            var ex = Assert.Throws<InvalidDataException>(() => RecordedCallReader.ReadPath(dir));
            Assert.Contains("recorded-2026-10-19.jsonl:2", ex.Message);
        }
        finally
        {
            Directory.Delete(dir, recursive: true);
        }
    }

    [Fact]
    public void A_missing_path_is_an_error() =>
        Assert.Throws<FileNotFoundException>(() => RecordedCallReader.ReadPath(Path.Combine(Path.GetTempPath(), "no-such-parity-folder")));
}

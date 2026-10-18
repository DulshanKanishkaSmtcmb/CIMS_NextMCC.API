using CIMSNextMCC.Database;

namespace CIMSNextMCC.Database.Tests;

public class BaselineScriptTests
{
    private static readonly string Sql = ScriptCatalog.ReadScript(ScriptCatalog.BaselineName());
    private static readonly ScriptSummary Summary = ScriptSummary.Analyze(Sql);

    [Fact]
    public void Baseline_has_146_tables() => Assert.Equal(146, Summary.Tables);

    [Fact]
    public void Baseline_has_299_stored_procedures() => Assert.Equal(299, Summary.Procedures);

    [Fact]
    public void Baseline_has_37_indexes() => Assert.Equal(37, Summary.Indexes);

    [Fact]
    public void Baseline_has_no_database_level_statements()
    {
        Assert.Equal(0, Summary.CreateDatabaseStatements);
        Assert.Equal(0, Summary.UseStatements);
        Assert.DoesNotContain("USE [", Sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Baseline_excludes_the_backup_table() =>
        Assert.DoesNotContain("CargoReceived_Bkp_20261015", Sql, StringComparison.OrdinalIgnoreCase);

    [Fact]
    public void Every_batch_split_on_GO_is_non_empty()
    {
        var batches = ScriptSummary.SplitBatches(Sql);

        Assert.NotEmpty(batches);
        Assert.All(batches, batch => Assert.False(string.IsNullOrWhiteSpace(batch), "empty batch between GO separators"));
        Assert.Equal(0, Summary.EmptyBatches);
    }

    [Fact]
    public void Baseline_is_utf8_without_bom_resource()
    {
        using var stream = typeof(ScriptCatalog).Assembly.GetManifestResourceStream(ScriptCatalog.BaselineName())!;
        var first = new byte[3];
        _ = stream.Read(first, 0, 3);

        Assert.False(first[0] == 0xEF && first[1] == 0xBB && first[2] == 0xBF, "BOM found");
    }
}

using CIMSNextMCC.Database;

namespace CIMSNextMCC.Database.Tests;

public class ScriptCatalogTests
{
    [Fact]
    public void Scripts_are_discovered_in_name_order()
    {
        var names = ScriptCatalog.GetScriptNames();

        Assert.NotEmpty(names);
        Assert.Equal(names.OrderBy(n => n, StringComparer.OrdinalIgnoreCase), names);
    }

    [Fact]
    public void Baseline_is_the_first_script()
    {
        var names = ScriptCatalog.GetScriptNames();

        Assert.EndsWith(ScriptCatalog.BaselineSuffix, names[0], StringComparison.OrdinalIgnoreCase);
        Assert.Equal(names[0], ScriptCatalog.BaselineName());
    }

    [Fact]
    public void Script_names_start_with_a_four_digit_number()
    {
        // Resource name: <assembly>.Scripts.<file>; the file part decides the run order.
        Assert.All(ScriptCatalog.GetScriptNames(), name =>
        {
            var file = name[(name.IndexOf(".Scripts.", StringComparison.Ordinal) + ".Scripts.".Length)..];
            Assert.Matches(@"^\d{4}_", file);
        });
    }

    [Fact]
    public void Numbers_are_unique()
    {
        var numbers = ScriptCatalog.GetScriptNames()
            .Select(n => n[(n.IndexOf(".Scripts.", StringComparison.Ordinal) + ".Scripts.".Length)..][..4])
            .ToList();

        Assert.Equal(numbers.Count, numbers.Distinct().Count());
    }
}

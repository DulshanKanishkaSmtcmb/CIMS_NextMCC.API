using System.Reflection;

namespace CIMSNextMCC.Database;

/// <summary>The embedded SQL scripts, in the order DbUp runs them (by name, case-insensitive).</summary>
public static class ScriptCatalog
{
    public const string BaselineSuffix = "0001_Baseline_CFSInventory.sql";

    public static IReadOnlyList<string> GetScriptNames(Assembly? assembly = null) =>
        (assembly ?? typeof(ScriptCatalog).Assembly)
            .GetManifestResourceNames()
            .Where(IsScript)
            .OrderBy(name => name, StringComparer.OrdinalIgnoreCase)
            .ToList();

    public static bool IsScript(string resourceName) => resourceName.EndsWith(".sql", StringComparison.OrdinalIgnoreCase);

    public static string BaselineName(Assembly? assembly = null) =>
        GetScriptNames(assembly).Single(name => name.EndsWith(BaselineSuffix, StringComparison.OrdinalIgnoreCase));

    public static string ReadScript(string resourceName, Assembly? assembly = null)
    {
        assembly ??= typeof(ScriptCatalog).Assembly;
        using var stream = assembly.GetManifestResourceStream(resourceName)
            ?? throw new InvalidOperationException($"Embedded script not found: {resourceName}");
        using var reader = new StreamReader(stream);
        return reader.ReadToEnd();
    }
}

namespace CIMSNextMCC.Parity.Tests.Harness;

/// <summary>Configuration of the live parity run, all from environment variables (docs/12-parity-harness.md).</summary>
public static class ParityEnvironment
{
    public const string LegacyUrl = "PARITY_LEGACY_URL";
    public const string NewUrl = "PARITY_NEW_URL";
    public const string NewToken = "PARITY_NEW_TOKEN";
    public const string NewTenant = "PARITY_NEW_TENANT";
    public const string LegacyCookie = "PARITY_LEGACY_COOKIE";
    public const string Recordings = "PARITY_RECORDINGS";
    public const string Maps = "PARITY_MAPS";
    public const string Report = "PARITY_REPORT";

    public static string? Get(string name)
    {
        var value = Environment.GetEnvironmentVariable(name);
        return string.IsNullOrWhiteSpace(value) ? null : value;
    }

    public static bool IsConfigured => Get(LegacyUrl) is not null && Get(NewUrl) is not null;

    public static ParityRunOptions ToOptions() => new()
    {
        LegacyBaseUrl = Get(LegacyUrl) ?? throw new InvalidOperationException($"{LegacyUrl} is not set."),
        NewBaseUrl = Get(NewUrl) ?? throw new InvalidOperationException($"{NewUrl} is not set."),
        NewToken = Get(NewToken),
        NewTenant = Get(NewTenant),
        LegacyCookie = Get(LegacyCookie),
    };

    /// <summary>The test project's folder (found by walking up from the build output), or the build output if not found.</summary>
    public static string ProjectDirectory
    {
        get
        {
            var dir = new DirectoryInfo(AppContext.BaseDirectory);
            while (dir is not null)
            {
                if (dir.GetFiles("CIMSNextMCC.Parity.Tests.csproj").Length > 0)
                {
                    return dir.FullName;
                }

                dir = dir.Parent;
            }

            return AppContext.BaseDirectory;
        }
    }

    public static string RecordingsPath => Get(Recordings) ?? Path.Combine(ProjectDirectory, "recordings");

    /// <summary>maps/*.json are copied next to the test assembly by the csproj; PARITY_MAPS overrides.</summary>
    public static string MapsPath => Get(Maps) ?? Path.Combine(AppContext.BaseDirectory, "maps");

    public static string ReportPath => Get(Report) ?? Path.Combine(ProjectDirectory, "TestResults", "parity-report.md");
}

/// <summary>[Fact] that is skipped unless PARITY_LEGACY_URL and PARITY_NEW_URL are both set.</summary>
public sealed class ParityLiveFactAttribute : FactAttribute
{
    public ParityLiveFactAttribute()
    {
        if (!ParityEnvironment.IsConfigured)
        {
            Skip = $"Set {ParityEnvironment.LegacyUrl} and {ParityEnvironment.NewUrl} (both localhost) to run the live parity replay; see docs/12-parity-harness.md.";
        }
    }
}

using System.Reflection;
using CIMSNextMCC.Database;
using DbUp;
using DbUp.Engine;
using Microsoft.Data.SqlClient;

// Schema migration console for ONE tenant database (the databases already exist, so EnsureDatabase is never called).
//   status          list applied and pending scripts
//   migrate         apply pending scripts (one transaction per script, journal dbo.SchemaVersions)
//   baseline-mark   record 0001 as executed WITHOUT running it (databases that already have the schema)
//   validate-script parse the embedded baseline offline and print object counts (no connection needed)
// Connection: --connection "<connection string>" or the CIMS_DB environment variable. migrate and baseline-mark
// refuse databases whose name does not end in Test or Dev unless --allow-production is passed.
const string Usage = "Usage: CIMSNextMCC.Database <status|migrate|baseline-mark|validate-script> [--connection \"<cs>\"] [--allow-production]\n"
    + "  The connection string may also come from the CIMS_DB environment variable.";

var command = args.FirstOrDefault(a => !a.StartsWith("--", StringComparison.Ordinal))?.ToLowerInvariant();
var allowProduction = args.Contains("--allow-production", StringComparer.OrdinalIgnoreCase);
var connectionIndex = Array.FindIndex(args, a => a.Equals("--connection", StringComparison.OrdinalIgnoreCase));
var connectionString = connectionIndex >= 0 && connectionIndex + 1 < args.Length
    ? args[connectionIndex + 1]
    : Environment.GetEnvironmentVariable("CIMS_DB");

try
{
    switch (command)
    {
        case "validate-script":
            return ValidateScript();
        case "status" or "migrate" or "baseline-mark":
            break;
        default:
            Console.Error.WriteLine(Usage);
            return 2;
    }

    if (string.IsNullOrWhiteSpace(connectionString))
    {
        Console.Error.WriteLine("No connection string: pass --connection \"<...>\" or set CIMS_DB.");
        return 2;
    }

    var (server, database) = ConnectionGuard.Describe(connectionString);
    if (string.IsNullOrWhiteSpace(database))
    {
        Console.Error.WriteLine("The connection string has no database (Initial Catalog).");
        return 2;
    }

    Console.WriteLine($"Target: server '{server}', database '{database}'");

    if (command != "status" && !ConnectionGuard.IsAllowed(connectionString, allowProduction))
    {
        Console.Error.WriteLine($"Refusing to run '{command}': database '{database}' does not end with 'Test' or 'Dev'. Pass --allow-production to override.");
        return 3;
    }

    return command switch
    {
        "status" => Status(connectionString),
        "migrate" => Migrate(connectionString),
        _ => BaselineMark(connectionString),
    };
}
catch (Exception ex) when (ex is SqlException or ArgumentException or InvalidOperationException)
{
    // Messages from these exceptions do not contain the connection string.
    Console.Error.WriteLine($"Failed: {ex.Message}");
    return 1;
}

static int ValidateScript()
{
    var name = ScriptCatalog.BaselineName();
    var summary = ScriptSummary.Analyze(ScriptCatalog.ReadScript(name));
    Console.WriteLine($"Script: {name}");
    Console.WriteLine($"  batches (split on GO): {summary.Batches} ({summary.EmptyBatches} empty)");
    Console.WriteLine($"  CREATE TABLE:          {summary.Tables}");
    Console.WriteLine($"  CREATE PROCEDURE:      {summary.Procedures}");
    Console.WriteLine($"  CREATE INDEX:          {summary.Indexes}");
    Console.WriteLine($"  CREATE DATABASE:       {summary.CreateDatabaseStatements}");
    Console.WriteLine($"  USE [...]:             {summary.UseStatements}");
    return summary.CreateDatabaseStatements == 0 && summary.UseStatements == 0 && summary.EmptyBatches == 0 ? 0 : 1;
}

static UpgradeEngine BuildEngine(string connectionString) =>
    DeployChanges.To
        .SqlDatabase(connectionString)
        .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly(), ScriptCatalog.IsScript)
        .JournalToSqlTable("dbo", "SchemaVersions")
        .WithTransactionPerScript()
        .LogToConsole()
        .Build();

static int Status(string connectionString)
{
    var applied = JournalReader.GetAppliedScripts(connectionString);
    foreach (var script in ScriptCatalog.GetScriptNames())
    {
        Console.WriteLine($"{(applied.Contains(script) ? "applied" : "pending")}  {script}");
    }

    return 0;
}

static int Migrate(string connectionString)
{
    var applied = JournalReader.GetAppliedScripts(connectionString);
    if (!applied.Contains(ScriptCatalog.BaselineName()) && JournalReader.UserTableCount(connectionString) > 0)
    {
        Console.Error.WriteLine("The database already contains tables but the baseline is not recorded. Run 'baseline-mark' first (see Scripts/README.md).");
        return 4;
    }

    var result = BuildEngine(connectionString).PerformUpgrade();
    if (!result.Successful)
    {
        Console.Error.WriteLine(result.Error);
        return 1;
    }

    Console.WriteLine("Success.");
    return 0;
}

static int BaselineMark(string connectionString)
{
    var baseline = ScriptCatalog.BaselineName();
    if (JournalReader.GetAppliedScripts(connectionString).Contains(baseline))
    {
        Console.WriteLine("Baseline already recorded; nothing to do.");
        return 0;
    }

    BuildEngine(connectionString).MarkAsExecuted(baseline);
    Console.WriteLine($"Recorded {baseline} as executed (not run).");
    return 0;
}

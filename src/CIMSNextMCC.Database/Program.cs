using System.Reflection;
using DbUp;

// Applies the embedded, numbered SQL scripts (Scripts/*.sql) to ONE tenant database, in name order, once each.
// Run it per tenant database:
//   dotnet run --project src/CIMSNextMCC.Database -- "<connection string>"
// or set the DBUP_CONNECTION_STRING environment variable. The connection string is never printed.
var connectionString = args.FirstOrDefault() ?? Environment.GetEnvironmentVariable("DBUP_CONNECTION_STRING");

if (string.IsNullOrWhiteSpace(connectionString))
{
    Console.Error.WriteLine("Usage: CIMSNextMCC.Database \"<connection string>\"  (or set DBUP_CONNECTION_STRING)");
    return 2;
}

// The tenant databases already exist (they are the legacy databases), so EnsureDatabase is deliberately not called.
var upgrader = DeployChanges.To
    .SqlDatabase(connectionString)
    .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly(), name => name.EndsWith(".sql", StringComparison.OrdinalIgnoreCase))
    .JournalToSqlTable("dbo", "SchemaVersions")
    .LogToConsole()
    .Build();

var result = upgrader.PerformUpgrade();

if (!result.Successful)
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.Error.WriteLine(result.Error);
    Console.ResetColor();
    return 1;
}

Console.ForegroundColor = ConsoleColor.Green;
Console.WriteLine("Success!");
Console.ResetColor();
return 0;

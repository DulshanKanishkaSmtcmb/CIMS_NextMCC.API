using Microsoft.Data.SqlClient;

namespace CIMSNextMCC.Database;

/// <summary>Reads the target of a connection string and decides whether a mutating command may run against it.</summary>
public static class ConnectionGuard
{
    private static readonly string[] SafeSuffixes = ["Test", "Dev"];

    /// <summary>Server and database of the connection string. The password is never part of the result.</summary>
    public static (string Server, string Database) Describe(string connectionString)
    {
        var builder = new SqlConnectionStringBuilder(connectionString);
        return (builder.DataSource, builder.InitialCatalog);
    }

    /// <summary>True when the database name ends with "Test" or "Dev" (case-insensitive), or production was explicitly allowed.</summary>
    public static bool IsAllowed(string connectionString, bool allowProduction)
    {
        if (allowProduction)
        {
            return true;
        }

        var database = Describe(connectionString).Database;
        return SafeSuffixes.Any(suffix => database.EndsWith(suffix, StringComparison.OrdinalIgnoreCase));
    }
}

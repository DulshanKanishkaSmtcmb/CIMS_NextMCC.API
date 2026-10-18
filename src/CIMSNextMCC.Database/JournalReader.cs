using Microsoft.Data.SqlClient;

namespace CIMSNextMCC.Database;

/// <summary>Read-only look at dbo.SchemaVersions and the schema; unlike DbUp's own call it never creates the journal table.</summary>
public static class JournalReader
{
    public static HashSet<string> GetAppliedScripts(string connectionString)
    {
        var applied = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        using var connection = new SqlConnection(connectionString);
        connection.Open();

        using var command = connection.CreateCommand();
        command.CommandText = "IF OBJECT_ID(N'dbo.SchemaVersions', N'U') IS NOT NULL SELECT ScriptName FROM dbo.SchemaVersions";
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            applied.Add(reader.GetString(0));
        }

        return applied;
    }

    /// <summary>User tables other than the journal; a non-zero count means the schema is not empty.</summary>
    public static int UserTableCount(string connectionString)
    {
        using var connection = new SqlConnection(connectionString);
        connection.Open();

        using var command = connection.CreateCommand();
        command.CommandText = "SELECT COUNT(*) FROM sys.tables WHERE name <> N'SchemaVersions'";
        return (int)command.ExecuteScalar()!;
    }
}

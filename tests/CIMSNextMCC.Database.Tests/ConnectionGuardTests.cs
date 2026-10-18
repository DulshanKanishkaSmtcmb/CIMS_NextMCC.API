using CIMSNextMCC.Database;

namespace CIMSNextMCC.Database.Tests;

public class ConnectionGuardTests
{
    private static string Cs(string database) => $"Server=db01;Database={database};User Id=u;Password=p;TrustServerCertificate=True";

    [Theory]
    [InlineData("CFSInventoryNextMCCTest")]
    [InlineData("CFSInventoryNextMCCDev")]
    [InlineData("cfsinventorynextcfstest")]
    public void Test_and_dev_databases_are_allowed(string database) =>
        Assert.True(ConnectionGuard.IsAllowed(Cs(database), allowProduction: false));

    [Theory]
    [InlineData("CFSInventoryNextMCC")]
    [InlineData("CFSInventoryNextCFS")]
    [InlineData("TestCFSInventory")]
    public void Other_databases_are_refused_unless_production_is_allowed(string database)
    {
        Assert.False(ConnectionGuard.IsAllowed(Cs(database), allowProduction: false));
        Assert.True(ConnectionGuard.IsAllowed(Cs(database), allowProduction: true));
    }

    [Fact]
    public void Describe_returns_server_and_database_but_never_the_password()
    {
        var (server, database) = ConnectionGuard.Describe(Cs("CFSInventoryNextMCCTest"));

        Assert.Equal("db01", server);
        Assert.Equal("CFSInventoryNextMCCTest", database);
    }

    [Fact]
    public void Initial_catalog_synonym_is_understood() =>
        Assert.Equal("MyDevDb", ConnectionGuard.Describe("Data Source=s;Initial Catalog=MyDevDb;Integrated Security=True").Database);
}

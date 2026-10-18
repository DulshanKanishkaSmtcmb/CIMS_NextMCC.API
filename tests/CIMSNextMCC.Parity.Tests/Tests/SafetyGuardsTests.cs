using CIMSNextMCC.Parity.Tests.Harness;

namespace CIMSNextMCC.Parity.Tests.Tests;

public class SafetyGuardsTests
{
    [Theory]
    [InlineData("http://localhost:5212")]
    [InlineData("http://LOCALHOST:55243/")]
    [InlineData("https://127.0.0.1:5001")]
    [InlineData("http://[::1]:5212")]
    [InlineData("http://api.localhost:5212")]
    public void Local_urls_are_accepted(string url) =>
        Assert.NotNull(SafetyGuards.AssertLocalhost("url", url));

    [Theory]
    [InlineData("http://192.168.100.20")]
    [InlineData("http://example.com")]
    [InlineData("http://localhost.evil.com")]
    [InlineData("http://evil.com/localhost")]
    [InlineData("ftp://localhost")]
    [InlineData("localhost:5212")]
    [InlineData("")]
    [InlineData(null)]
    public void Everything_else_is_refused(string? url) =>
        Assert.Throws<ParitySafetyException>(() => SafetyGuards.AssertLocalhost("url", url));

    [Theory]
    [InlineData("POST")]
    [InlineData("PUT")]
    [InlineData("DELETE")]
    [InlineData("PATCH")]
    [InlineData("HEAD")]
    public void Only_get_is_allowed(string method) =>
        Assert.Throws<ParitySafetyException>(() => SafetyGuards.AssertReadOnlyMethod(new HttpMethod(method)));

    [Fact]
    public void Get_is_allowed() => SafetyGuards.AssertReadOnlyMethod(HttpMethod.Get);

    [Theory]
    [InlineData("Server=x;Database=CFSInventoryNextMCCTest;User Id=u;Password=p")]
    [InlineData("Data Source=x;Initial Catalog=CFSInventoryNextMCCtest;Integrated Security=true")]
    [InlineData("Server=x;Database=MyAppDev;Trusted_Connection=True")]
    public void Test_and_dev_databases_are_accepted(string connectionString) =>
        Assert.Matches("(?i)(test|dev)$", SafetyGuards.AssertTestDatabase(connectionString));

    [Theory]
    [InlineData("Server=x;Database=CFSInventoryNextMCC;User Id=u;Password=secret-value")]
    [InlineData("Server=x;Database=CFSInventoryNextMCCTest2;User Id=u;Password=secret-value")]
    [InlineData("Server=x;Integrated Security=true")]
    [InlineData("this is not a connection string; secret-value")]
    public void Other_databases_are_refused_without_echoing_the_connection_string(string connectionString)
    {
        var ex = Assert.Throws<ParitySafetyException>(() => SafetyGuards.AssertTestDatabase(connectionString));
        Assert.DoesNotContain("secret-value", ex.Message);
    }
}

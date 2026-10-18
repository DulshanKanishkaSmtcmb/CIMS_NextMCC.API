using CIMSNextMCC.Parity.Tests.Harness;

namespace CIMSNextMCC.Parity.Tests.Tests;

public class EndpointMapTests
{
    private static RecordedCall Call(string path, string query = "") =>
        new(DateTimeOffset.UtcNow, "-", "GET", path, query, 200, "[]", "", "test", 1);

    [Fact]
    public void Shipped_maps_load_and_cover_the_two_proof_endpoints()
    {
        var set = EndpointMapSet.LoadFromDirectory(ParityEnvironment.MapsPath);

        var fld = set.Find(Call("/api/DataApi/getfldParas"));
        Assert.NotNull(fld);
        Assert.True(fld.IsPorted);
        Assert.Equal("api/v1/reference/field-captions", fld.New!.Route);

        var alarm = set.Find(Call("/api/dataapi/GETALARMSTATUS", "Alarmid=A1"));
        Assert.NotNull(alarm);
        Assert.False(alarm.IsPorted);

        Assert.Null(set.Find(Call("/api/DataApi/somethingElse")));
        Assert.Null(set.Find(Call("/Home/Index")));
    }

    [Fact]
    public void Query_parameters_are_mapped_dropped_and_the_cache_buster_is_ignored()
    {
        var map = EndpointMap.Parse("""
            {
              "legacy": { "controller": "DataApi", "action": "getX" },
              "new": { "route": "api/v1/x" },
              "query": { "strRtnPara": null, "UID": null, "rcvNo": "bookingNo" }
            }
            """);

        var request = map.BuildNewRequest(Call("/api/DataApi/getX", "strRtnPara=%5B%5D&uid=u1&rcvNo=A%2FB+1&_=1700000000"));

        Assert.Equal("api/v1/x?bookingNo=A%2FB%201", request.ToRelativeUrl());
    }

    private const string JsonMap = """
        {
          "legacy": { "controller": "DataApi", "action": "getPending" },
          "new": { "route": "api/v1/arrivals/confirm/pending" },
          "query": { "uid": null },
          "queryJson": { "strData": { "strCargoFrom": "cargoFrom", "strDC": "dc", "strCountry": "country", "strMode": null, "strArrivalDate": null, "uid": null } }
        }
        """;

    [Fact]
    public void A_json_query_parameter_is_split_and_mapped_property_by_property()
    {
        var map = EndpointMap.Parse(JsonMap);
        var strData = Uri.EscapeDataString("""[{"strMode":"Sea","strArrivalDate":"","strCountry":"All","uid":"x","strDC":"All","strCargoFrom":"Import"}]""");

        var request = map.BuildNewRequest(Call("/api/DataApi/getPending", $"strData={strData}&uid=x&_=1"));

        Assert.Equal("api/v1/arrivals/confirm/pending?country=All&dc=All&cargoFrom=Import", request.ToRelativeUrl());
    }

    [Fact]
    public void A_json_object_is_accepted_and_an_empty_value_or_array_yields_nothing()
    {
        var map = EndpointMap.Parse(JsonMap);
        Assert.Equal("api/v1/arrivals/confirm/pending?dc=X",
            map.BuildNewRequest(Call("/api/DataApi/getPending", "strData=" + Uri.EscapeDataString("""{"strDC":"X"}"""))).ToRelativeUrl());
        Assert.Equal("api/v1/arrivals/confirm/pending", map.BuildNewRequest(Call("/api/DataApi/getPending", "strData=%5B%5D")).ToRelativeUrl());
        Assert.Equal("api/v1/arrivals/confirm/pending", map.BuildNewRequest(Call("/api/DataApi/getPending", "strData=")).ToRelativeUrl());
    }

    [Fact]
    public void An_unlisted_json_property_and_bad_json_are_errors()
    {
        var map = EndpointMap.Parse(JsonMap);
        var ex = Assert.Throws<UnmappedParameterException>(() =>
            map.BuildNewRequest(Call("/api/DataApi/getPending", "strData=" + Uri.EscapeDataString("""[{"strNew":"1"}]"""))));
        Assert.Contains("strData.strNew", ex.Message);
        Assert.Throws<InvalidOperationException>(() => map.BuildNewRequest(Call("/api/DataApi/getPending", "strData=%7Bnope")));
        Assert.Throws<InvalidOperationException>(() => map.BuildNewRequest(Call("/api/DataApi/getPending", "strData=5")));
    }

    [Fact]
    public void A_parameter_cannot_be_under_both_query_and_query_json() =>
        Assert.Throws<InvalidDataException>(() => EndpointMap.Parse("""
            { "legacy": { "controller": "A", "action": "b" }, "new": { "route": "r" },
              "query": { "strData": null }, "queryJson": { "STRDATA": { "x": "y" } } }
            """));

    [Fact]
    public void An_unlisted_query_parameter_is_an_error_not_silently_forwarded()
    {
        var map = EndpointMap.Parse("""
            { "legacy": { "controller": "DataApi", "action": "getX" }, "new": { "route": "api/v1/x" } }
            """);

        var ex = Assert.Throws<UnmappedParameterException>(() => map.BuildNewRequest(Call("/api/DataApi/getX", "surprise=1")));
        Assert.Contains("surprise", ex.Message);
    }

    [Fact]
    public void Route_placeholders_take_the_legacy_id_segment_or_parameter()
    {
        var map = EndpointMap.Parse("""
            {
              "legacy": { "controller": "DataApi", "action": "getX" },
              "new": { "route": "api/v1/x/{bookingNo}/lines" },
              "query": { "id": "bookingNo", "page": "page" },
              "constantQuery": { "pageSize": "100" }
            }
            """);

        var request = map.BuildNewRequest(Call("/api/DataApi/getX/AB%2F1", "page=2"));

        Assert.Equal("api/v1/x/AB%2F1/lines?page=2&pageSize=100", request.ToRelativeUrl());
        Assert.Throws<InvalidOperationException>(() => map.BuildNewRequest(Call("/api/DataApi/getX", "page=2")));
    }

    [Theory]
    [InlineData("""{ "legacy": { "controller": "A" }, "new": { "route": "r" } }""")]
    [InlineData("""{ "legacy": { "controller": "A", "action": "b", "method": "POST" }, "new": { "route": "r" } }""")]
    [InlineData("""{ "legacy": { "controller": "A", "action": "b" }, "status": "later" }""")]
    [InlineData("""{ "legacy": { "controller": "A", "action": "b" } }""")]
    [InlineData("""{ "legacy": { "controller": "A", "action": "b" }, "new": { "route": "r", "method": "POST" } }""")]
    [InlineData("""{ "legacy": { "controller": "A", "action": "b" }, "new": { "route": "r" }, "legacyShape": { "kind": "xml" } }""")]
    [InlineData("""{ "legacy": { "controller": "A", "action": "b" }, "new": { "route": "r" }, "legacyShape": { "kind": "positionalArray" } }""")]
    [InlineData("""{ "legacy": { "controller": "A", "action": "b" }, "new": { "route": "r" }, "typo": 1 }""")]
    public void Invalid_maps_are_rejected(string json) =>
        Assert.Throws<InvalidDataException>(() => EndpointMap.Parse(json));

    [Fact]
    public void Two_maps_for_one_endpoint_are_rejected()
    {
        const string json = """{ "legacy": { "controller": "A", "action": "b" }, "status": "not-ported" }""";
        Assert.Throws<InvalidDataException>(() => new EndpointMapSet([EndpointMap.Parse(json), EndpointMap.Parse(json)]));
    }
}

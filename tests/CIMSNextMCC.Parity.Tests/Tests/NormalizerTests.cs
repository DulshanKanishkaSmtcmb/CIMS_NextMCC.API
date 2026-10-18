using CIMSNextMCC.Parity.Tests.Harness;

namespace CIMSNextMCC.Parity.Tests.Tests;

public class NormalizerTests
{
    private static EndpointMap Map(string json) => EndpointMap.Parse(json);

    private const string RowsMap = """
        {
          "legacy": { "controller": "DataApi", "action": "getRows" },
          "new": { "route": "api/v1/rows" },
          "legacyShape": { "kind": "dataRtnCls", "tables": ["dtMain"], "columnMap": { "Booking No": "bookingNo", "QTY": "quantity" } },
          "newShape": { "kind": "rows", "rowsPaths": ["items"] }
        }
        """;

    [Fact]
    public void Property_names_are_lower_cased_and_sorted_and_strings_trimmed()
    {
        var a = Normalizer.Canonicalize("""{"B":"x  ","a":1}""");
        var b = Normalizer.Canonicalize("""{"a":1,"b":"  x"}""");
        Assert.Equal(a, b);
        Assert.True(a.IndexOf("\"a\"", StringComparison.Ordinal) < a.IndexOf("\"b\"", StringComparison.Ordinal));
    }

    [Theory]
    [InlineData("1.50", "1.5")]
    [InlineData("10", "10")]
    [InlineData("10.000", "10")]
    [InlineData("1.5e0", "1.5")]
    [InlineData("0.10", "0.1")]
    [InlineData("-3.0", "-3")]
    public void Numbers_are_canonical(string raw, string expected) =>
        Assert.Equal(expected, Normalizer.Canonicalize(raw));

    [Theory]
    [InlineData("2026-10-18T00:00:00", "2026-10-18")]
    [InlineData("2026-10-18", "2026-10-18")]
    [InlineData("18/10/2026", "2026-10-18")]
    [InlineData("18/10/2026 14:05:09", "2026-10-18T14:05:09")]
    [InlineData("2026-10-18T14:05:09", "2026-10-18T14:05:09")]
    [InlineData("2026-10-18T14:05:09.000", "2026-10-18T14:05:09")]
    [InlineData("2026-10-18T14:05:09.5", "2026-10-18T14:05:09.500")]
    [InlineData("2026-10-18T14:05:09Z", "2026-10-18T14:05:09")]
    [InlineData("2026-10-18T16:05:09+02:00", "2026-10-18T14:05:09")]
    public void Date_strings_become_iso(string raw, string expected) =>
        Assert.Equal($"\"{expected}\"", Normalizer.Canonicalize($"\"{raw}\""));

    [Theory]
    [InlineData("ContractNo")]
    [InlineData("12345678")]
    [InlineData("31/02/2026")]
    [InlineData("")]
    public void Other_strings_are_left_alone(string raw) =>
        Assert.Equal($"\"{raw}\"", Normalizer.Canonicalize($"\"{raw}\""));

    [Fact]
    public void A_number_and_a_numeric_string_stay_different()
    {
        Assert.NotEqual(Normalizer.Canonicalize("5"), Normalizer.Canonicalize("\"5\""));
    }

    [Fact]
    public void Array_order_is_kept_unless_unordered_rows_is_set()
    {
        Assert.NotEqual(Normalizer.Canonicalize("[1,2]"), Normalizer.Canonicalize("[2,1]"));
        var o = new NormalizeOptions { UnorderedRows = true };
        Assert.Equal(Normalizer.Canonicalize("[{\"a\":1},{\"a\":2}]", o), Normalizer.Canonicalize("[{\"a\":2},{\"a\":1}]", o));
    }

    [Fact]
    public void Null_equals_empty_only_when_asked()
    {
        Assert.NotEqual(Normalizer.Canonicalize("{\"a\":null}"), Normalizer.Canonicalize("{\"a\":\"\"}"));
        var o = new NormalizeOptions { NullAsEmpty = true };
        Assert.Equal(Normalizer.Canonicalize("{\"a\":null}", o), Normalizer.Canonicalize("{\"a\":\"\"}", o));
    }

    [Fact]
    public void Ignored_columns_are_dropped()
    {
        var o = new NormalizeOptions { IgnoreColumns = ["Stamp"] };
        Assert.Equal(Normalizer.Canonicalize("{\"a\":1}", o), Normalizer.Canonicalize("{\"a\":1,\"stamp\":\"x\"}", o));
    }

    [Fact]
    public void Positional_legacy_array_equals_the_named_new_object()
    {
        var map = Map(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "maps", "DataApi.getfldParas.json")));
        var legacy = Normalizer.CanonicalizeLegacy("""["Sys ","Contract","PO","Delivery","Item"]""", map);
        var current = Normalizer.CanonicalizeNew(
            """{"sysCaption":"Sys","contractNoCaption":"Contract","itemNoCaption":"Item","poNoCaption":"PO","deliveryNoCaption":"Delivery"}""", map);
        Assert.Equal(legacy, current);
    }

    [Fact]
    public void Positional_legacy_array_with_the_wrong_length_is_an_error()
    {
        var map = Map(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "maps", "DataApi.getfldParas.json")));
        Assert.Throws<NormalizationException>(() => Normalizer.CanonicalizeLegacy("""["a","b"]""", map));
    }

    [Fact]
    public void DataRtnCls_main_table_equals_the_new_rows_after_column_mapping()
    {
        var map = Map(RowsMap);
        var legacy = Normalizer.CanonicalizeLegacy(
            """{"dtMain":[{"Booking No":"B1 ","QTY":10.0,"Dated":"18/10/2026"}],"dtHeading":[{"ColName":"x"}],"strRtnPara":"[]","msg":""}""", map);
        var current = Normalizer.CanonicalizeNew(
            """{"items":[{"BookingNo":"B1","quantity":10,"dated":"2026-10-18T00:00:00"}],"total":1}""", map);
        Assert.Equal(legacy, current);
    }

    [Fact]
    public void DataRtnCls_difference_shows_up()
    {
        var map = Map(RowsMap);
        var legacy = Normalizer.CanonicalizeLegacy("""{"dtMain":[{"Booking No":"B1","QTY":10}]}""", map);
        var current = Normalizer.CanonicalizeNew("""{"items":[{"bookingNo":"B1","quantity":11}]}""", map);
        Assert.NotEqual(legacy, current);
        var diff = UnifiedDiff.Create(legacy, current);
        Assert.Contains("-    \"quantity\": 10", diff);
        Assert.Contains("+    \"quantity\": 11", diff);
    }

    [Fact]
    public void An_empty_or_null_table_is_an_empty_array()
    {
        var map = Map(RowsMap);
        Assert.Equal(
            Normalizer.CanonicalizeLegacy("""{"dtMain":[]}""", map),
            Normalizer.CanonicalizeNew("""{"items":null}""", map));
    }

    [Fact]
    public void Invalid_json_and_missing_paths_are_normalization_errors()
    {
        var map = Map(RowsMap);
        Assert.Throws<NormalizationException>(() => Normalizer.CanonicalizeLegacy("<html>login</html>", map));
        Assert.Throws<NormalizationException>(() => Normalizer.CanonicalizeNew("""{"other":[]}""", map));
        Assert.Throws<NormalizationException>(() => Normalizer.Canonicalize("""{"A":1,"a":2}"""));
    }
}

public class SingleRowLookupTests
{
    private const string LookupMap = """
        {
          "legacy": { "controller": "DataApi", "action": "getCountryData" },
          "new": { "route": "api/v1/master-data/countries/{code}" },
          "queryJson": { "strData": { "CountryCode": "code", "strRtnPara": null } },
          "legacyShape": { "kind": "dataRtnCls", "tables": ["dtMain"] },
          "newShape": { "kind": "rows", "rowsPaths": [""], "singleRow": true }
        }
        """;

    [Fact]
    public void A_single_object_is_compared_as_a_one_row_list()
    {
        var map = EndpointMap.Parse(LookupMap);

        var legacy = Normalizer.CanonicalizeLegacy("""{"dtMain":[{"CountryCode":"IND","CountryName":"INDIA"}]}""", map);
        var current = Normalizer.CanonicalizeNew("""{"countryCode":"IND","countryName":"INDIA"}""", map);

        Assert.Equal(legacy, current);
    }

    [Fact]
    public void An_object_that_differs_is_reported()
    {
        var map = EndpointMap.Parse(LookupMap);

        var legacy = Normalizer.CanonicalizeLegacy("""{"dtMain":[{"CountryCode":"IND","CountryName":"INDIA"}]}""", map);
        var current = Normalizer.CanonicalizeNew("""{"countryCode":"IND","countryName":"India"}""", map);

        Assert.NotEqual(legacy, current);
    }

    [Fact]
    public void An_object_without_single_row_is_still_an_error()
    {
        var map = EndpointMap.Parse(LookupMap.Replace(", \"singleRow\": true", string.Empty));

        Assert.Throws<NormalizationException>(() => Normalizer.CanonicalizeNew("""{"countryCode":"IND"}""", map));
    }
}

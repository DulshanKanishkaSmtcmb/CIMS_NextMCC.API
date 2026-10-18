namespace CIMSNextMCC.Parity.Tests;

public class GoldenMasterReadTests
{
    // Golden-master approach (docs/09-modernization-plan.md section 5, "Golden-master reads"):
    //   1. A recorder middleware in the LEGACY app captures real (endpoint, query string, user) -> response pairs
    //      from the usage log. Those recordings are the golden master.
    //   2. For every recorded input this test replays the request against the old endpoint and the new one, both
    //      running on a restored copy of the tenant's production database (SQL Server test instance, optionally anonymized).
    //   3. Both responses are normalized (column order, number and date formats, trims) and the ROW CONTENT is diffed;
    //      the envelope shape (DataRtnCls vs typed DTO) is deliberately not compared.
    //   4. Run it once per tenant database. Write endpoints get a separate "write effect" test (snapshot, call old,
    //      reset with Respawn, call new, diff the deltas), not this one.
    // The first replay will be field-captions: legacy DataApi/getfldParas vs GET api/v1/reference/field-captions
    // (legacy returns a positional array with Item/PO/Delivery crossed, see GetFieldCaptionsHandler).
    [Fact(Skip = "Placeholder: needs the legacy recorder, a restored tenant database and a running old + new pair.")]
    public void New_read_endpoints_return_the_same_rows_as_the_legacy_endpoints()
    {
    }
}

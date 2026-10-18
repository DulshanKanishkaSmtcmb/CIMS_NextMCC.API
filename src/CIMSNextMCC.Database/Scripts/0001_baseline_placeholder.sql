/*
    PLACEHOLDER BASELINE. This script intentionally changes nothing.

    The real baseline comes from DB_Script.sql in the legacy CIMS_NextMCC repository (the current schema of the
    tenant database). Replace this file's body with that script, or generate the baseline from each tenant
    database, once the schema is agreed (docs/09-modernization-plan.md sections 2.1 and 6).

    Rules for the numbered scripts that follow:
      * Name them 0002_..., 0003_...; DbUp runs each exactly once per database, in name order, and records it in dbo.SchemaVersions.
      * Never edit a script that has already been applied to any tenant database; add a new one instead.
      * The baseline must be marked as already applied on the existing production databases (they already contain the schema).
      * Run per tenant database; schema differences between NextMCC and NextCFS are aligned here before NextCFS is onboarded.
*/
PRINT 'CIMSNextMCC baseline placeholder: no changes applied.';

# Database scripts (DbUp)

`src/CIMSNextMCC.Database` applies the numbered, embedded `Scripts/*.sql` files to **one tenant database** at a time
(`CFSInventoryNextMCC`, `CFSInventoryNextCFS`), in name order, each exactly once, and records them in `dbo.SchemaVersions`.
Each script runs in its own transaction. Scripts are split on `GO`.

## Commands

```bash
dotnet run --project src/CIMSNextMCC.Database -- validate-script                       # offline, prints object counts
dotnet run --project src/CIMSNextMCC.Database -- status  --connection "<cs>"          # applied / pending
dotnet run --project src/CIMSNextMCC.Database -- migrate --connection "<cs>"           # apply pending scripts
dotnet run --project src/CIMSNextMCC.Database -- baseline-mark --connection "<cs>"     # record 0001 without running it
```

The connection string can also come from the `CIMS_DB` environment variable. The tool prints the target server and
database (never the password) before it acts. Exit codes: `0` success, `1` failure, `2` usage/missing connection,
`3` refused by the production guard, `4` database has tables but the baseline is not recorded.

## Production guard

`migrate` and `baseline-mark` only run when the database name ends with `Test` or `Dev` (case-insensitive), e.g.
`CFSInventoryNextMCCTest`. For any other database (the live tenants) pass `--allow-production` deliberately. `status`
and `validate-script` are read-only and unguarded.

## Regenerating the baseline (`0001_Baseline_CFSInventory.sql`)

Only needed when the agreed schema changes before any tenant has the baseline recorded. Once recorded anywhere,
**never edit 0001**; add a new numbered script instead.

1. SSMS: right-click the database, Tasks, Generate Scripts, whole database, **Schema only**, include indexes, keys,
   triggers, extended properties, "Script Full-Text" not required; save as one Unicode file (UTF-16).
2. Drop or rename scratch/backup tables first, or list them in `-ExcludeTable` in the next step.
3. Convert:

   ```bash
   powershell -NoProfile -File tools/convert-baseline.ps1 -Source "C:\path\to\dump.sql"
   ```

   The converter removes the `CREATE DATABASE`/`ALTER DATABASE` header, every `USE [...]`, the trailing
   `ALTER DATABASE ... READ_WRITE`, and the excluded backup table (default `CargoReceived_Bkp_20261015`); everything else is
   copied unchanged, as UTF-8 without BOM. It fails if an excluded table is still referenced.
4. `dotnet run --project src/CIMSNextMCC.Database -- validate-script` and `dotnet test tests/CIMSNextMCC.Database.Tests`.
   The tests pin the expected counts (146 tables, 299 procedures, 37 indexes); update them deliberately if the schema
   legitimately changed.

## Adding a script

1. Create `Scripts/0002_<Short_Description>.sql` (next free four-digit number; the file is embedded automatically).
2. Make it safe to read in review: one concern per script, `GO` between batches, no `USE`, no `CREATE DATABASE`.
3. Never edit a script after it has been applied to any database. Fix forward with a new script.
4. Both tenants share the same scripts, so a script must work on `CFSInventoryNextMCC` and `CFSInventoryNextCFS`.
5. Run `status` then `migrate` against a `...Test` / `...Dev` database first.

## Existing databases: `baseline-mark`

Databases that already contain the schema (the Test database and the live tenants) must **not** run 0001. For each:

1. Confirm the schema matches the baseline (compare against the SSMS dump, or `validate-script` plus a schema compare).
2. `status` (expect `pending 0001`), then
   `baseline-mark --connection "<cs>"` (add `--allow-production` for a live tenant; take a backup first).
3. `status` again (expect `applied 0001`), then `migrate` for anything after it.

A brand-new empty database just runs `migrate`. `migrate` refuses (exit 4) a database that already has tables but no
recorded baseline, so the baseline cannot be applied twice by accident.

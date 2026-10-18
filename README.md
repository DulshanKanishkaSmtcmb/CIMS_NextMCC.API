# CIMS_NextMCC.API

Backend of the modernized **CIMS Next MCC** warehouse / CFS application (ASP.NET Core 10 + Dapper). It replaces the legacy
ASP.NET MVC 5 / Web API 2 application (`CIMS_NextMCC`) page by page behind an Nginx gateway (strangler fig). The SQL Server
databases are unchanged and the same stored procedures are called. The API is **tenant-aware**, so the sibling system
Next CFS becomes tenant 2 instead of a second code base.

It follows the layering and conventions of `CIMS.Cargo.API`: JWT bearer against the central CIMS Identity Server, API
versioning by URL segment, Swagger, Dapper with `IDbConnection` + `IUnitOfWork`, CORS from configuration, `/health`.

The full design, phases and runbook: **`docs/09-modernization-plan.md` in the legacy `CIMS_NextMCC` repository**
(sections 2.1 layout, 2.3 backend conventions, 3 data access and tenancy, 4 authentication, 5 parity harness).
On the developer machine: `C:\Non Windows Files\Work\DotNet2015\NextMCCNew\CIMS_NextMCC\docs\09-modernization-plan.md`.
The front end lives in the sibling repository `CIMS_NextMCC.FE` (React, MUI, Vite).

## Layout

```
CIMS_NextMCC.API.sln
Directory.Build.props        net10.0, nullable, implicit usings, analyzers
Directory.Packages.props     central package versions
src/
  CIMSNextMCC.API/            host: Program.cs, controllers, middleware, health, Swagger, versioning, [RequireMenu]
  CIMSNextMCC.Application/    feature folders (Reference/FieldCaptions), interfaces, Result/PagedResult, exceptions, FluentValidation
  CIMSNextMCC.Domain/         entities and DbName
  CIMSNextMCC.Infrastructure/ Dapper repositories, UnitOfWork, TenantContext, TenantConnectionFactory, CurrentUser
  CIMSNextMCC.Database/       DbUp console app (numbered, embedded SQL scripts; run once per tenant database)
tests/
  CIMSNextMCC.Application.Tests/   unit tests (handlers, tenant resolution, menu authorization)
  CIMSNextMCC.Parity.Tests/        golden-master parity tests old vs new (placeholder)
deploy/
  Dockerfile, docker-compose.yml, azure-pipelines.yml
  nginx/nextmcc.conf              sample gateway: routing table and pilot cookie
CIMSNextMCC.API.http           sample requests
```

## Run locally

Requires the .NET 10 SDK. The API starts without any database; `GET /health` then reports `Degraded` and data endpoints fail until a
tenant connection string is configured.

```bash
dotnet restore
dotnet build -c Release
dotnet test -c Release
dotnet run --project src/CIMSNextMCC.API --launch-profile http
```

The API listens on `http://localhost:5212` (`https://localhost:7212` with the `https` profile). Swagger is at `/swagger` in Development.
Endpoints need a bearer token from CIMS Identity (default `https://localhost:7001`) with audience `cims-nextmcc-api`, scope `cims.nextmcc`
and a `tenant` claim. See `CIMSNextMCC.API.http`.

Connection strings are never committed. Use user-secrets (already initialised for the API project):

```bash
dotnet user-secrets set "Tenants:0:ConnectionStrings:Main" "<connection string>" --project src/CIMSNextMCC.API
```

Apply database scripts to one tenant database with DbUp:

```bash
dotnet run --project src/CIMSNextMCC.Database -- "<connection string>"
```

## Configuration keys

| Key | Meaning |
|---|---|
| `Identity:Authority`, `Audience`, `RequiredScope`, `RequireHttpsMetadata` | CIMS Identity Server the JWTs are validated against; the scope is checked in `OnTokenValidated` |
| `Tenants` | Array of `{ Key, DisplayName, ConnectionStrings { Main, Cfs, Air, Sea } }`; `Key` is `NextMCC` or `NextCFS`. Set values by index, e.g. `Tenants:0:ConnectionStrings:Main` or `Tenants__0__ConnectionStrings__Main` |
| `Authorization:LogOnly` | `true` (default): a `[RequireMenu("<key>")]` denial is logged and the call allowed. `false`: enforce (403) |
| `Cors:AllowedOrigins` | Allowed browser origins; empty means no CORS policy |
| `EnableSwagger` | `true` serves Swagger outside Development |
| `Serilog` | Standard Serilog configuration: console and a daily rolling file `logs/cims-nextmcc-api-.log` |
| `ConnectionStrings` | Reserved for non-tenant connections; unused today |

## Tenancy and auth in one paragraph

The tenant is taken from the token's `tenant` claim. A user allowed on several tenants can send `X-Tenant`; it is honoured only if that
value is in the token's `tenants` claim, otherwise the API answers 403. The resolved tenant selects the connection strings.
`ICurrentUser` is built from claims by name (`username`, `sub`, `category`, `level`). The menu, DC and shipper lookup from the local
database is still a TODO, so keep `Authorization:LogOnly` at `true` until it exists.

## Sample feature and not-yet-built parts

- `GET api/v1/reference/field-captions` replaces the legacy `getfldParas`. The legacy code crosses the Item, PO and Delivery captions;
  this API maps each caption from its own column (see the comment on `GetFieldCaptionsHandler`).
- `POST api/v1/legacy-session` returns 501: the legacy cookie bridge is a Phase 1 spike (plan section 4.3).
- `Scripts/0001_baseline_placeholder.sql` changes nothing; the real baseline comes from `DB_Script.sql` in the legacy repository.
- The Docker image, compose file and pipeline are written but have not been built or run on this machine.

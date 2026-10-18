# Local dev gateway (strangler fig on one laptop)

Nginx on `http://localhost:8080` in front of the legacy app, the new API and the SPA build. The same routing table
as the production sample `../nginx/nextmcc.conf`: `/Account/Login` is flipped to the SPA for everyone and
`/Data/ConfirmArrival` is flipped only for browsers carrying the `cims_pilot` cookie. One login serves both apps
through the cookie bridge (`POST /api/v1/legacy-session`). Full write-up: legacy workspace `docs/14-dev-gateway.md`.

```
Browser ── http://localhost:8080 ── nginx (deploy/dev-gateway/nginx.dev.conf)
             ├─ /api/v1/, /nextmcc-api/health ─────────────▶ API          http://localhost:5212   (C:\devgw\api, Development)
             ├─ /assets/, /login, /auth/callback, ─────────▶ SPA server   http://127.0.0.1:5031   (same nginx; C:\devgw\nginx\spa
             │  /Account/Login, /Data/ConfirmArrival (pilot)                                        = junction to FE apps/web/dist)
             ├─ /pilot/on, /pilot/off ─────────────────────▶ nginx itself (sets / clears cims_pilot)
             └─ everything else (pages, /api/DataApi/..., ─▶ legacy       http://localhost:55243  (IIS Express, C:\devgw\legacy)
                /Sounds/, /Content/, Crystal handlers)
```

## Commands (Windows PowerShell, from the API repo root)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\start-dev-gateway.ps1            # build + start (idempotent)
powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\start-dev-gateway.ps1 -Status    # does each upstream answer?
powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\verify-dev-gateway.ps1           # HTTP proof (a-g)
powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\verify-dev-gateway.ps1 -Browser  # + Playwright in Chrome, screenshots
powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\new-dev-token.ps1 -UserName Madhuka  # token -> clipboard
powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\stop-dev-gateway.ps1             # stop all three
```

Start switches: `-SkipSpaBuild`, `-SkipLegacyBuild`, `-SkipApiBuild` (reuse the last build), `-Restart` (stop first).
A component that already answers is left running; nginx is reloaded (`-s reload`) instead of restarted.

Then, in a browser: `http://localhost:8080/Home/Index` → legacy redirects to `/Account/Login?ReturnUrl=...` (the SPA) →
type your user name and press **Get dev token** (the API mints the token; Development and loopback only, no shell
command needed; or paste a token from `new-dev-token.ps1` under **Use dev token**) → back on the legacy page, signed in. `http://localhost:8080/pilot/on` → now
`/Data/ConfirmArrival` is the React page; `/pilot/off` goes back to the legacy one.

## What start-dev-gateway.ps1 does

| Step | Detail |
|---|---|
| SPA | `npm run build --workspace @cims/web -- --mode devgateway` in the FE repo. It writes the git-ignored `apps/web/.env.devgateway.local` first (`VITE_API_BASE_URL=` empty → same-origin `/api`, `VITE_ENABLE_DEV_TOKEN=true`, `VITE_DEV_BEARER_TOKEN=` blank so a token from `.env.local` is never baked in). Then it checks that no JWT ended up in the bundle. |
| Legacy | `robocopy /E` of the legacy **workspace** copy (`New Projects\Legacy\CIMS_NextMCC-work\CIMS_NextMCC`, its `ConnectionStrings.config` as it is, Test DB) to `C:\devgw\legacy\CIMS_NextMCC`, junction `C:\devgw\legacy\packages`, MSBuild 14 Release there. It refuses to use the user's own copy (`DotNet2015\NextMCCNew`). Checks `SharedKeyRingPath` = `C:\ProgramData\CIMS\keys`. |
| API | `dotnet build --artifacts-path C:\devgw\api` (the repo's own `bin/obj` are untouched, so an API run from Visual Studio or another session is not affected), then `dotnet CIMSNextMCC.API.dll` with `ASPNETCORE_ENVIRONMENT=Development`, `ASPNETCORE_URLS=http://localhost:5212`. User-secrets (Test connection string, DevJwt key) load as usual. |
| Start | API, then IIS Express (`/path:C:\devgw\legacy\CIMS_NextMCC /port:55243`), then nginx (`-p C:/devgw/nginx/ -c conf/nginx.conf`, a copy of `nginx.dev.conf`: nginx for Windows cannot take a path with spaces). |
| State | `C:\devgw\state.json` (pids). Logs: `C:\devgw\logs` (builds, `api.log`, `iisexpress.log`, `playwright.log`) and `C:\devgw\nginx\logs` (`access.log` shows `pilot=` and the upstream per request). The API and IIS Express are started through `cmd /c ... > log` with ShellExecute so they inherit none of the script's handles; the script can therefore be piped or logged without waiting for the servers. |

Nginx comes from winget: `winget install --id nginxinc.nginx --exact --scope user` (the official nginx.org zip; winget
checks its SHA-256). A zip unpacked under `deploy/dev-gateway/tools/` (git-ignored) is used first if present.

## Flip another page (dev)

1. The SPA has a route for the legacy path (`apps/web/src/routes`), served by the index.html fallback.
2. Add a block next to `/Data/ConfirmArrival` in `nginx.dev.conf` (and in `../nginx/nextmcc.conf`):
   ```nginx
   location = /File/Country {
       proxy_pass http://$pilot_upstream;          # pilot; full flip: http://nextmcc_spa; roll back: http://legacy_iis
       add_header X-Served-By $pilot_served_by always;
   }
   ```
3. `start-dev-gateway.ps1 -SkipLegacyBuild -SkipApiBuild` rebuilds the SPA, copies the config, runs `nginx -t` and reloads.

## Differences from the production sample (`../nginx/nextmcc.conf`)

| Here | Production |
|---|---|
| `listen 127.0.0.1:8080` and `[::1]:8080`, plain http | `listen 80`/443 with TLS on the real host name |
| `Host $http_host` (keeps `:8080`, so Katana's absolute login redirect stays on 8080) | `Host $host` (same on default ports) |
| SPA = a second server block in the same nginx (127.0.0.1:5031) over the local build | SPA container (`apps/web/nginx/default.conf`), same contract |
| `/assets/` cache headers set once, by the SPA server | gateway **and** container both add them (duplicate `Cache-Control`; see docs/14) |
| `/login`, `/auth/callback`, `/favicon.svg` routed to the SPA | not in the sample yet (needed for Identity sign-in) |
| `/pilot/on`, `/pilot/off`, `X-Served-By` response header | not in the sample |
| No `/identity/` (Identity is not reachable); sign-in with DevJwt tokens | CIMS Identity (PKCE) |

## Limitations

http only (cookies are not `Secure`); no CIMS Identity, so only `dotnet user-jwts` DevJwt tokens sign in (the build has
the dev-token form compiled in: never deploy it); loopback only; Windows only (IIS Express, MSBuild 14); the shared key
ring `C:\ProgramData\CIMS\keys` is unencrypted; `/pilot/on` is open to anyone who can reach the gateway (the cookie is
not a security control); legacy LogOff is not flipped, and while the SPA session lives a missing legacy cookie is
re-issued on the next legacy page. A full sign-out must clear both (`DELETE /api/v1/legacy-session` and the SPA
session); the SPA's sign-out button does not call the DELETE yet (`AppLayout.tsx` TODO), and a dev token lives until the
tab closes.

## Ports

8080 gateway, 5031 SPA (loopback), 5212 API, 55243 IIS Express. A parallel session may use 55244 / 5213 / 5173; this
gateway never touches those.

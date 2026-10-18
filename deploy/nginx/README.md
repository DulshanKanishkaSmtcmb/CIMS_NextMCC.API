# Gateway: flipping pages from legacy to the new app

`nextmcc.conf` is a sample for the Nginx gateway in front of three things on one hostname:

| Upstream | What it is |
|---|---|
| `legacy_iis` | the legacy CIMS_NextMCC on the Windows IIS host (default for everything) |
| `nextmcc_api` | the new API container (`/api/v1/`) |
| `nextmcc_spa` | the new React SPA container, served at the site root (`/assets/`, flipped page paths) |

The SPA's routes mirror the legacy page paths, so a menu link such as `/Data/ConfirmArrival` stays valid when the page moves.
Plan reference: `docs/09-modernization-plan.md` in the legacy repository, sections 2.2 and 4.3.

## The routing table

The table is the set of `location = <legacy page path>` blocks in `nextmcc.conf`, one per flipped page. A page that has no block
goes to legacy. A block does one of three things:

| `proxy_pass` | Meaning |
|---|---|
| `http://legacy_iis` | not flipped (or rolled back) |
| `http://$pilot_upstream` | pilot: users with cookie `cims_pilot=1` get the SPA, everyone else the legacy page |
| `http://nextmcc_spa` | flipped for everyone |

`/Account/Login` is the first flipped path. `/Data/ConfirmArrival` is the pilot example.

## Flip a page

1. In the SPA, make sure the route exists for the same path as the legacy page, and that the SPA container answers it with `index.html`
   (deep links and reloads must work).
2. Add a block to the routing table, starting in pilot mode:
   ```nginx
   location = /Data/Unloading {
       proxy_pass http://$pilot_upstream;
   }
   ```
3. Validate the configuration, then reload (reload keeps existing connections):
   ```bash
   nginx -t
   nginx -s reload
   ```
4. Verify: as a pilot user the SPA page loads (also on browser refresh); as a normal user the legacy page still loads;
   `GET /api/v1/...` calls from the page succeed and legacy pages still work (their `/api/<Controller>/...` calls stay on IIS).
5. When the pilot is accepted, change that block to `proxy_pass http://nextmcc_spa;` and repeat steps 3 and 4.

## Flip back

Change the block to `proxy_pass http://legacy_iis;` (or delete it), then `nginx -t` and `nginx -s reload`. The change takes effect for new
requests immediately; no data migration is involved because both apps use the same database.
Keep a flipped-back block in the file with a comment until the page is fixed, so the history of what was flipped stays visible.

## Pilot cookie

Pilot routing is per browser, selected by the cookie `cims_pilot` (value `1` or `true`). It only matters for blocks that use `$pilot_upstream`.

- **Enable for a user:** in the browser developer tools, Application, Cookies for the CIMS host, add a cookie named `cims_pilot` with value `1`, path `/`.
  Or run in the browser console on the CIMS site: `document.cookie = "cims_pilot=1; path=/; max-age=2592000"`.
- **Disable:** delete the cookie, or run `document.cookie = "cims_pilot=; path=/; max-age=0"`. The user is back on the legacy pages at the next request.
- **Add a pilot user to a flipped page:** none needed; the cookie applies to every `$pilot_upstream` block at once.
- The cookie is not a security control: anyone can set it. Pilot pages still need a valid login and the API enforces authorization.

## Things to know

- **`/api/` is not routed to the new API as a whole.** Only `/api/v1/` is. The legacy Web API uses `/api/<Controller>/<action>` and unflipped pages call it.
- **`/assets/`** is cached for a year (immutable): the SPA build must produce content-hashed file names (Vite does).
- **`/Sounds/`** and everything else not listed stay on legacy until its page is flipped.
- **One hostname** is required: the legacy cookie, the SPA and the cookie bridge (`POST /api/v1/legacy-session`) share the origin.
- This is a sample. Real host names, ports, TLS and the Identity path mapping must be filled in; it has not been run against a real Nginx.

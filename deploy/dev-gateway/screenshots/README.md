# Dev gateway screenshots (git-ignored)

Written by the FE repo's Playwright spec `apps/web/e2e/dev-gateway.spec.ts` when `E2E_SCREENSHOT_DIR` points here
(see `../README.md`, "Browser proof"). Every page was reached through `http://localhost:8080`:

| File | What it shows |
|---|---|
| `01-spa-login-at-account-login.png` | legacy `/Data/ConfirmArrival` without a session redirects to `/Account/Login`, which is the SPA sign-in |
| `02-legacy-confirm-arrival-via-8080.png` | after the dev-token sign-in: the LEGACY Confirm Arrivals page (no pilot cookie), logged in by the API-issued cookie |
| `03-legacy-home-via-8080.png` | legacy `/Home/Index` with its database menu |
| `04-spa-confirm-arrival-pilot-via-8080.png` | with `cims_pilot=1` the same path is the SPA page, contracts loaded from `/api/v1` |
| `05-signed-out-back-at-login.png` | after `DELETE /api/v1/legacy-session` and the SPA sign-out: back at the sign-in page |

// Regenerates confirm-arrivals.jsonl: golden inputs for the Confirm Arrivals pilot (legacy docs/13 section 2) in the
// legacy ParityRecorder line format, so the live replay (GoldenMasterReadTests) can run them:
//   PARITY_RECORDINGS=tests/CIMSNextMCC.Parity.Tests/golden/confirm-arrivals.jsonl
// The lines carry inputs only: body is "" and sha256 is "", so no customer data is stored in the repository and the
// report says "legacy data changed since the recording" for every line (expected).
//   node tests/CIMSNextMCC.Parity.Tests/golden/make-confirm-arrivals.mjs
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));

// [why, Shipment (strCargoFrom), DC (strDC), Country (strCountry), Arrival Date (ignored by legacy)]
const pending = [
  ['Local shipments: none pending in the Test DB (empty result)', 'Local', 'All', 'All', ''],
  ['Page default after switching to Import: every pending import row (multi-row, 3 sets)', 'Import', 'All', 'All', ''],
  ['DC whose rows have no import container (supplier list filled, container key 0/0)', 'Import', 'JO JO STORE', 'All', ''],
  ['DC and country together', 'Import', 'JO JO WEB', 'IND', '18/10/2026 14:30'],
  ['Largest single-DC set, all on import containers (empty supplier list)', 'Import', 'Aramex Fulfillment Centre', 'PAK', ''],
  ['One DC, several countries', 'Import', 'Nordstrom Online', 'All', ''],
  ['One DC and country, several rows', 'Import', 'Nordstrom Online', 'VN', ''],
  ['Single row', 'Import', 'Nordstrom Retail', 'MM', ''],
  ['Country only', 'Import', 'All', 'CHN', ''],
  ['Country spanning several DCs', 'Import', 'All', 'PAK', '01/01/2000 00:00'],
  ['Special characters in the DC (hyphen, spaces); no rows', 'Import', 'Re-Export', 'All', ''],
  ['Special characters in the DC; no rows', 'Import', 'XD - Elmsall Drive', 'All', ''],
  ["Apostrophe: legacy SQL breaks and ListTableLoad returns empty tables; new returns no rows", 'Import', "O'Brien DC", 'All', ''],
  ['Empty shipment = no CargoFrom filter (not reachable from the page, accepted by the action)', '', 'All', 'All', ''],
  ['Local with a DC and country (empty)', 'Local', 'JO JO STORE', 'IND', ''],
  ['Lower-case "all" is a value, not the wildcard (empty)', 'Import', 'all', 'All', ''],
];

// The legacy page always sends empty filters; the actions ignore them anyway, so other values must change nothing.
const dcFilters = ['', 'JO JO WEB', 'Nordstrom Online', 'UK', 'Re-Export', "O'Brien", 'XD - Elmsall Drive', 'All', 'zzz', ' '];
const countryFilters = ['', 'IND', 'PAK', 'CHN', 'UK', 'VN', "O'X", 'All', 'zzz', 'LKA'];

const lines = [];
const add = (action, strData, why) =>
  lines.push(
    JSON.stringify({
      utc: '2026-10-18T00:00:00.000Z',
      user: 'golden',
      method: 'GET',
      path: `/api/DataApi/${action}`,
      query: `strData=${encodeURIComponent(JSON.stringify([strData]))}`,
      status: 200,
      body: '',
      sha256: '',
      why,
    }),
  );

for (const [why, cargoFrom, dc, country, arrivalDate] of pending) {
  add(
    'getPendingPO4ConfirmArrival',
    { strMode: 'Sea', strArrivalDate: arrivalDate, strCountry: country, uid: 'golden', strDC: dc, strCargoFrom: cargoFrom },
    why,
  );
}
for (const whDes of dcFilters) {
  add('getDCList', { WhDes: whDes, strRtnPara: '[]' }, `WhDes filter "${whDes}" (ignored by legacy)`);
}
for (const code of countryFilters) {
  add('getCountryList', { CountryCode: code, strRtnPara: '[]' }, `CountryCode filter "${code}" (ignored by legacy)`);
}

writeFileSync(join(here, 'confirm-arrivals.jsonl'), lines.join('\n') + '\n', 'utf8');
console.log(`wrote ${lines.length} lines`);

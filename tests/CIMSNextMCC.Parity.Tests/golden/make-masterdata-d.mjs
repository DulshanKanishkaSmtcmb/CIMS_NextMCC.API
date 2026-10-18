// Regenerates ratecard.jsonl, oktoloadreason.jsonl and palletrack.jsonl: golden inputs for the wave-1 master-data pages
// Rate Card Entry, OK-to-Load Reason, Pallet Rack Build and Pallet Rack Build Arrangement (legacy docs/18 section
// "Golden inputs") in the legacy ParityRecorder line format, so the live replay (GoldenMasterReadTests) can run them:
//   PARITY_RECORDINGS=tests/CIMSNextMCC.Parity.Tests/golden/ratecard.jsonl   (or the folder, to run every golden file)
// The lines carry inputs only: body is "" and sha256 is "", so no customer data is stored in the repository and the
// report says "legacy data changed since the recording" for every line (expected).
//   node tests/CIMSNextMCC.Parity.Tests/golden/make-masterdata-d.mjs
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const utc = '2026-10-18T00:00:00.000Z';

const line = (action, query, why) =>
  JSON.stringify({ utc, user: 'golden', method: 'GET', path: `/api/DataApi/${action}`, query, status: 200, body: '', sha256: '', why });

const strData = (action, obj, why) => line(action, `strData=${encodeURIComponent(JSON.stringify([obj]))}`, why);

// ---------------------------------------------------------------- Rate Card Entry
// getRateInformation4Add?strDataArr=[{"strOption":"Add","uid":uid}] (CreateApiPara does not encode the JSON; the harness
// accepts both spellings). The action reads both properties and uses neither, so every input returns the same three tables.
const rc = [];
const rate = (obj, why) => rc.push(line('getRateInformation4Add', `strDataArr=${encodeURIComponent(JSON.stringify([obj]))}`, why));
rate({ strOption: 'Add', uid: 'Madhuka' }, 'The page load call (option Add, the signed-in user)');
rate({ strOption: 'Add', uid: 'madhuka' }, 'Lower-case user');
rate({ strOption: 'Add', uid: '' }, 'Empty user');
rate({ strOption: '', uid: 'Madhuka' }, 'Empty option');
rate({ strOption: 'Edit', uid: 'Madhuka' }, 'Another option value: ignored');
rate({ strOption: 'Add', uid: 'a b' }, 'User with a space');
rate({ strOption: 'Add', uid: "O'Brien" }, 'Apostrophe in the ignored user');
rate({ strOption: 'Add', uid: 'x'.repeat(60) }, 'Very long user');
rate({ strOption: 'Add', uid: '1' }, 'Numeric user');
rate({ strOption: 'ADD', uid: 'Madhuka' }, 'Upper-case option');
rate({ strOption: 'Add', uid: 'Dilini' }, 'Another user (the Load Rates button runs the same request again)');
rc.push(line('getRateInformation4Add', `strDataArr=${encodeURIComponent(JSON.stringify([{ strOption: 'Add', uid: 'Madhuka' }]))}&_=1760000000301`, 'Same call with the jQuery cache buster'));

writeFileSync(join(here, 'ratecard.jsonl'), `${rc.join('\n')}\n`);
console.log(`ratecard.jsonl: ${rc.length} inputs`);

// ---------------------------------------------------------------- OK-to-Load Reason
// getOkToLoadResonListUpdate?strData=[{"uid":…,"DC":dc,"chkAllocated":true,"strRtnPara":"[]"}]: the page sends it when the DC
// select changes (and once on load for the first DC). `uid` and `strRtnPara` are ignored by the action.
const ok = [];
const reasons = (dc, chk, why, uid = 'Madhuka') =>
  ok.push(strData('getOkToLoadResonListUpdate', { uid, DC: dc, chkAllocated: chk, strRtnPara: '[]' }, why));
// the DCs of DestWarehouse (the select offers these), with the allocation check the page always asks for
for (const [dc, why] of [
  ['Aramex Fulfillment Centre', 'DC without any reason'],
  ['Dubai - Alshaya', 'DC with a hyphen, no reasons'],
  ['Elmsall Drive', 'DC without reasons'],
  ['JO JO STORE', 'Reason without a detail'],
  ['JO JO WEB', 'Another reason without a detail'],
  ['Kohls Online', 'DC with contracts but no reasons'],
  ['Kohls Retail', 'One reason with a detail, one contract reason'],
  ['Logix Fzco', 'DC without reasons'],
  ['Myntra India', 'Five reasons, 8 distinct reasons on contracts'],
  ['Nordstrom Online', 'Ten reasons, five distinct reasons on contracts'],
  ['Nordstrom Online Split', 'DC with a contract reason but no reasons'],
  ['Nordstrom Retail', 'DC with contracts but no reasons'],
  ['Nordstrom Retail Eas Split', 'DC with contracts but no reasons'],
  ['Re-Export', 'DC with a hyphen'],
  ['Re-Ship To Origin Country', 'Long DC name'],
  ['UK', 'Two-letter DC'],
  ['V - Dearne Valley Boxed', 'DC with spaces around a hyphen'],
  ['XD - Elmsall Drive', 'DC with spaces around a hyphen'],
  ['Zalora Online', 'Ten reasons, twelve distinct reasons on contracts (the biggest DC)'],
]) {
  reasons(dc, true, `${why} (allocation checked, as the page asks)`);
}
reasons('Zalora Online', false, 'Allocation not asked: every isAttched stays false');
reasons('Myntra India', false, 'Allocation not asked, five reasons');
reasons('zalora online', true, 'Lower-case DC: the column collation finds it');
reasons('ZALORA ONLINE', true, 'Upper-case DC');
reasons('Zalora Online ', true, 'Trailing space in the DC (SQL ignores it)');
reasons('Nordstrom Retail Eas', true, 'An old DC name that only OkToLoadReason still has (five reasons, not in DestWarehouse)');
reasons('Nowhere DC', true, 'Unknown DC: no rows');
reasons('', true, 'Empty DC: every DC\'s reasons, allocation of the empty warehouse');
reasons('', false, 'Empty DC without the allocation check');
reasons("O'Brien DC", true, 'Apostrophe: the legacy SQL breaks and returns an empty table');
reasons('Kohls Retail', true, 'Another user', 'Dilini');
reasons('Zalora Online', true, 'Zalora with an empty user', '');

writeFileSync(join(here, 'oktoloadreason.jsonl'), `${ok.join('\n')}\n`);
console.log(`oktoloadreason.jsonl: ${ok.length} inputs`);

// ---------------------------------------------------------------- Pallet Rack Build / Pallet Rack Build Arrangement
// Both legacy pages call the same two reads, so they share the golden file.
const pr = [];
// getPalletRacksList: strRtnPara is the layout of the "Pallets Area Listing" dialog (RtnArr of the modules), echoed back only.
const rackLayout = JSON.stringify([
  { ele: 'RackNo', val: 'rackNo', eleType: 'val' },
  { ele: 'NofRows', val: 'nofRows', eleType: 'val' },
  { ele: 'NofLayers', val: 'nofLayers', eleType: 'val' },
  { ele: 'TotPltPositions', val: 'nofPositions', eleType: 'val' },
]);
for (const [layout, why] of [
  [rackLayout, 'The page call: the dialog layout of PalletRackBuild.js / PalletRackBuildArr.js'],
  ['[]', 'Empty layout'],
  ['', 'No layout at all'],
  [rackLayout.replace('RackNo', 'RackNo2'), 'A different layout'],
  ['null', 'The text null'],
  ['x'.repeat(300), 'A very long layout'],
  ["[{'bad':1}]", 'Not JSON, with apostrophes'],
  ['[{"ele":"RackNo","val":"rackNo","eleType":"val"}]', 'One column only'],
  ['{}', 'An object'],
  ['All', 'Text'],
]) {
  pr.push(strData('getPalletRacksList', { strRtnPara: layout }, why));
}
pr.push(line('getPalletRacksList', `strData=${encodeURIComponent(JSON.stringify([{ strRtnPara: rackLayout }]))}&_=1760000000401`, 'The page call with the jQuery cache buster'));
// getPalletRacksData: [why, rackNo, strOption]. The pages send {RackNo, strRtnPara "[]", strOption "All"}.
for (const [why, rackNo, option] of [
  ['The page default rack, as the Load and existence-check calls send it', 'A35', 'All'],
  ['Lower-case rack number (column collation)', 'a35', 'All'],
  ['Trailing space (SQL ignores it)', 'A35 ', 'All'],
  ['Leading space: no such rack', ' A35', 'All'],
  ['Prefix of the rack number', 'A3', 'All'],
  ['A position number is not a rack number', 'A35-01-01', 'All'],
  ['Unknown rack', 'ZZZ', 'All'],
  ['Unknown rack, a digit', '35', 'All'],
  ['Another rack that does not exist', 'B1', 'All'],
  ['Apostrophe: the legacy SQL breaks and returns empty tables', "A'35", 'All'],
  ['Longer than the column', 'ABCDEFGHIJKLMNOP', 'All'],
  ['A SQL wildcard is not a wildcard in an equality', 'A3%', 'All'],
  ['Any non-empty option returns the positions', 'A35', 'Positions'],
  ['A space is a non-empty option too', 'A35', ' '],
  ['Rack number with a hyphen', 'A-35', 'All'],
]) {
  pr.push(strData('getPalletRacksData', { RackNo: rackNo, strRtnPara: '[]', strOption: option }, why));
}

writeFileSync(join(here, 'palletrack.jsonl'), `${pr.join('\n')}\n`);
console.log(`palletrack.jsonl: ${pr.length} inputs`);

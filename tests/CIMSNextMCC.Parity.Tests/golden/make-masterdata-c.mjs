// Regenerates pmmaster.jsonl and productcategory.jsonl: golden inputs for the wave-1 master-data pages PM Master and
// Product Category (legacy docs/17 section "Golden inputs") in the legacy ParityRecorder line format, so the live replay
// (GoldenMasterReadTests) can run them:
//   PARITY_RECORDINGS=tests/CIMSNextMCC.Parity.Tests/golden/pmmaster.jsonl   (or the folder, to run every golden file)
// The lines carry inputs only: body is "" and sha256 is "", so no customer data is stored in the repository and the
// report says "legacy data changed since the recording" for every line (expected).
//   node tests/CIMSNextMCC.Parity.Tests/golden/make-masterdata-c.mjs
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const utc = '2026-10-18T00:00:00.000Z';

const line = (action, query, why) =>
  JSON.stringify({ utc, user: 'golden', method: 'GET', path: `/api/DataApi/${action}`, query, status: 200, body: '', sha256: '', why });

const strData = (action, obj, why) => line(action, `strData=${encodeURIComponent(JSON.stringify([obj]))}`, why);

// The "Return" layout the PM Master page passes to the list dialog in Change mode (a page detail; the API does not take it).
const rtnArr = JSON.stringify([
  { ele: 'PMCode', val: 'pmCode', eleType: 'val' },
  { ele: 'PMDescription', val: 'pmDescription', eleType: 'val' },
  { ele: 'PMIssueType', val: 'pmIssueType', eleType: 'val' },
]);

// ---------------------------------------------------------------- PM Master
const pm = [];
// getPMList: [why, strRtnPara, strCode]. The legacy action reads strCode and ignores it.
for (const [why, rtn, code] of [
  ['New mode: the dialog is opened with an empty layout and the typed code (empty)', '[]', ''],
  ['Change mode: the layout of the page and an empty code', rtnArr, ''],
  ['Change mode: the code typed so far is ignored', rtnArr, 'CT1'],
  ['New mode with a typed code', '[]', 'ZZT1'],
  ['Lower-case code', rtnArr, 'ct1'],
  ['Code with spaces', rtnArr, 'D 889'],
  ['Apostrophe in the ignored code', rtnArr, "O'X"],
  ['All', rtnArr, 'All'],
  ['A single space', '[]', ' '],
  ['A numeric code', rtnArr, '3315'],
  ['Code with a dot and a hyphen', rtnArr, 'C.W.S-ONLI'],
]) {
  pm.push(strData('getPMList', { strRtnPara: rtn, strCode: code }, why));
}
// getPMData: [why, code]. As LoadPMData calls it (strCode, strRtnPara); the existence check adds strCodeType.
for (const [why, code, withType] of [
  ['Carton with a weight and a CBM of 0.072 (the legacy page rounds the CBM to 0 on load)', 'CT1', false],
  ['Existing code as the existence check sends it (strCodeType Code)', 'CT1', true],
  ['Lower-case code matches (column collation)', 'ct1', false],
  ['Pallet', 'Plt1', false],
  ['Sticker with Get Joker Count', 'NEXT P. TA', false],
  ['Sticker with Get Part Count', 'COO', true],
  ['Code with spaces', 'D 889', false],
  ['Code with a dot and a hyphen', 'C.W.S-ONLI', false],
  ['Numeric code', '3315', false],
  ['Numeric code with a long description', '6008', true],
  ['Code with a trailing space in the key (SQL ignores trailing spaces)', 'A4 ', false],
  ['Hanger with a reorder level of 5000', '021006', false],
  ['Unknown code: legacy returns an empty table, new answers 404', 'ZZT1', true],
  ['Apostrophe: legacy SQL breaks and returns an empty table; new finds no row', "O'X", false],
  ['Longest legal code length, unknown', 'ABCDEFGHIJ', false],
  ['Tag Barbs', 'TagBarbs', false],
]) {
  const obj = withType ? { strCode: code, strRtnPara: '[]', strCodeType: 'Code' } : { strCode: code, strRtnPara: '[]' };
  pm.push(strData('getPMData', obj, why));
}
// getPmCategoryData has no parameters: the same call with different jQuery cache busters (`_`, ignored by the harness).
for (let i = 0; i < 10; i += 1) {
  pm.push(line('getPmCategoryData', i === 0 ? '' : `_=${1760000000000 + i}`, i === 0 ? 'The page load call (no parameters)' : `Same call, cache buster ${i}`));
}

// ---------------------------------------------------------------- Product Category
const pc = [];
for (let i = 0; i < 10; i += 1) {
  pc.push(line('getChainCategoryData', i === 0 ? '' : `_=${1760000000100 + i}`, i === 0 ? 'The grid load (no parameters)' : `Same call, cache buster ${i}`));
}
for (let i = 0; i < 10; i += 1) {
  pc.push(line('getProductCategoryData', i === 0 ? '' : `_=${1760000000200 + i}`, i === 0 ? 'The Range select load (no parameters)' : `Same call, cache buster ${i}`));
}

for (const [name, lines] of [['pmmaster', pm], ['productcategory', pc]]) {
  writeFileSync(join(here, `${name}.jsonl`), lines.join('\n') + '\n', 'utf8');
  console.log(`${name}.jsonl: ${lines.length} lines`);
}

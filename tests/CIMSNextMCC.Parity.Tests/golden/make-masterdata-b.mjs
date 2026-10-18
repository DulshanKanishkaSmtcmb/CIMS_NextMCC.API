// Regenerates supplier.jsonl and pm-supplier.jsonl: golden inputs for the wave-1 master-data pages Supplier and PM Supplier
// (legacy docs/16 section "Golden inputs") in the legacy ParityRecorder line format, so the live replay
// (GoldenMasterReadTests) can run them:
//   PARITY_RECORDINGS=tests/CIMSNextMCC.Parity.Tests/golden/supplier.jsonl   (or the folder, to run every golden file)
// The lines carry inputs only: body is "" and sha256 is "", so no customer data is stored in the repository and the
// report says "legacy data changed since the recording" for every line (expected).
//   node tests/CIMSNextMCC.Parity.Tests/golden/make-masterdata-b.mjs
//
// Not here: getAirShipperList/Data and getSeaShipperList/Data. They read the AirFreight / SeaFreight databases, which are
// separate (live) systems; the Test environment has no connection to them (the workspace points legacy at a database that
// does not exist and the API's Air/Sea connection strings are empty), so there is nothing to compare. Unit tests cover them.
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const utc = '2026-10-18T00:00:00.000Z';

const line = (action, query, why) =>
  JSON.stringify({ utc, user: 'golden', method: 'GET', path: `/api/DataApi/${action}`, query, status: 200, body: '', sha256: '', why });

const strData = (action, obj, why) => line(action, `strData=${encodeURIComponent(JSON.stringify([obj]))}`, why);

// The "pre-entered" box layout the Supplier page sends (a page detail; the API does not take it).
const boxLayout = JSON.stringify([
  {
    Data: 'dtMain', Headings: 'dtHeading', _tblNameBox: 'tblPdata', _divBox: 'PData', _divFrame: 'divPreviousData',
    _BoxHeading: 'Pre-Entered Supplier Listing', isNewBtn: false, isEditBtn: false, isDelBtn: false, isSelectBtn: false,
    koArr: ['', '', ''], arrObj: [], arrRoVisible: [],
  },
]);
const findName = (name, startsWith, why) =>
  line('findSupplierName', `strName=${encodeURIComponent(name)}&isStartChrOnly=${startsWith}&strRtnPara=${encodeURIComponent(boxLayout)}`, why);

// getSupplierList / getPMSupplierList take only strRtnPara (which form field the chosen row fills); the data does not depend on it.
const supplierRtn = JSON.stringify([{ ele: 'SupplierCode', val: 'shipperCode', eleType: 'val' }]);
const pmRtn = JSON.stringify([{ ele: 'SupplierCode', val: 'pmSupplierCode', eleType: 'val' }]);
const listLines = (action, rtn, rtnOther) => [
  line(action, `strRtnPara=${encodeURIComponent(rtn)}`, 'Change/View: the dialog with the return layout of the page'),
  line(action, 'strRtnPara=', 'New: the page sends an empty array, which becomes an empty parameter'),
  line(action, 'strRtnPara=%5B%5D', 'Explicit empty JSON array'),
  line(action, `strRtnPara=${encodeURIComponent(rtnOther)}`, 'A different return layout (ignored)'),
  line(action, 'strRtnPara=x', 'Free text (ignored)'),
  line(action, `strRtnPara=${encodeURIComponent("o'x")}`, 'Apostrophe in the parameter (never reaches SQL)'),
  line(action, 'strRtnPara=%20', 'A space'),
  line(action, `strRtnPara=${encodeURIComponent(rtn)}&_=1760000000000`, 'jQuery cache-buster (dropped by the harness)'),
  line(action, `strRtnPara=${encodeURIComponent('[]')}&_=1760000000001`, 'Empty array with a cache-buster'),
  line(action, `strRtnPara=${encodeURIComponent(JSON.stringify([{ ele: 'A', val: 'b', eleType: 'text' }]))}`, 'A text-type return layout'),
];

// ---------------------------------------------------------------- Supplier (Shipper)
const supplier = [];
supplier.push(...listLines('getSupplierList', supplierRtn, pmRtn));
// [why, code]: getSupplierData as the page calls it (the existence check also sends strCodeType).
for (const [why, code] of [
  ['Existing supplier, the first of its letter', 'A0001'],
  ['Lower-case code matches (column collation is case-insensitive)', 'a0001'],
  ['Highest code of the largest letter (S has 41)', 'S0041'],
  ['The row whose code starts with a space (its name starts with a space too)', ' 0001'],
  ['Last row of the table', 'Z0001'],
  ['Newest row (created in 2026)', 'W0001'],
  ['Name with an ampersand and a country that differs from J0001', 'J0005'],
  ['Name of the maximum length (50)', 'E0022'],
  ['Name with a double space', 'A0007'],
  ['Unknown code (legacy empty table, API 404)', 'Q0001'],
  ['Apostrophe in the code (legacy SQL breaks, empty)', "A'01"],
  ['Five characters, unknown, with a trailing space (insignificant in comparisons)', 'A001 '],
  ['Digit-only code', '00001'],
  ['Mixed-case code of another letter', 'm0015'],
]) {
  supplier.push(strData('getSupplierData', { ShipperCode: code, strRtnPara: '[]' }, why));
}
// The existence check adds strCodeType.
supplier.push(strData('getSupplierData', { ShipperCode: 'S0001', strRtnPara: '[]', strCodeType: 'Code' }, 'The existence check of the save sends strCodeType (ignored)'));
// [why, name, startsWith]: findSupplierName as the pre-entered box calls it (always startsWith).
for (const [why, name, starts] of [
  ['First keystroke, a letter with many suppliers', 'S', true],
  ['First keystroke in lower case', 's', true],
  ['Two letters', 'SA', true],
  ['Two letters, mixed case', 'Sa', true],
  ['A prefix shared by three suppliers', 'SPEEDMARK', true],
  ['A prefix shared by several names with an ampersand', 'JEENA & CO', true],
  ['A leading space and a letter (matches the name that starts with a space; a lone space is a legacy 500, see docs/16)', ' J', true],
  ['One trailing space (SQL ignores it in the comparison)', 'ACS ', true],
  ['Double space inside a name', 'ACS  L', true],
  ['A character that is not a letter', 'M/S', true],
  ['No match', 'QQQ', true],
  ["Apostrophe (legacy SQL breaks, empty)", "O'N", true],
  ['Exact name, upper case (isStartChrOnly false)', 'ZYTA APPARELS LTD', false],
  ['Exact name, lower case', 'zyta apparels ltd', false],
  ['Exact name that matches nothing', 'ZYTA', false],
  ['Prefix equal to a whole 50-character name', 'EV CARGO GLOBAL FORWARDING (SHENZHEN) LIMITED NING', true],
]) {
  supplier.push(findName(name, starts, why));
}

// ---------------------------------------------------------------- PM Supplier
const pm = [];
pm.push(...listLines('getPMSupplierList', pmRtn, supplierRtn));
// The legacy action reads the code from the first property of the posted array, whatever it is called.
for (const [why, code] of [
  ['Existing PM supplier, the first row', 'A0001'],
  ['Lower-case code (collation)', 'a0001'],
  ['Two suppliers of one letter: the first', 'F0001'],
  ['Two suppliers of one letter: the second', 'F0002'],
  ['Row with an almost empty address block', 'P0001'],
  ['Last row of the table', 'T0002'],
  ['Letter with four suppliers', 'M0004'],
  ['Supplier with one contact person and a long address', 'E0001'],
  ['Code that exists in Shipper but not in PMSupplier (the tables are separate)', ' 0001'],
  ['Code that exists in Shipper but not in PMSupplier', 'S0041'],
  ['Unknown code (legacy empty table, API 404)', 'Q0001'],
  ["Apostrophe in the code (legacy SQL breaks, empty)", "A'01"],
]) {
  pm.push(strData('getPMSupplierData', { PMSupplierCode: code, strRtnPara: '[]' }, why));
}
// The existence check posts the code under a misspelt name; the legacy action reads the first property anyway.
for (const [why, code] of [
  ['The existence check names the property PMSuplierCode (read by position)', 'B0001'],
  ['The existence check with an unknown code', 'Q0002'],
]) {
  pm.push(strData('getPMSupplierData', { PMSuplierCode: code, strRtnPara: '[]', strCodeType: 'Code' }, why));
}

writeFileSync(join(here, 'supplier.jsonl'), supplier.join('\n') + '\n');
writeFileSync(join(here, 'pm-supplier.jsonl'), pm.join('\n') + '\n');
console.log(`supplier.jsonl: ${supplier.length} lines, pm-supplier.jsonl: ${pm.length} lines`);

// Regenerates country.jsonl, ports.jsonl and dc.jsonl: golden inputs for the wave-1 master-data pages Country, Ports and DC
// (legacy docs/15 section "Golden inputs") in the legacy ParityRecorder line format, so the live replay
// (GoldenMasterReadTests) can run them:
//   PARITY_RECORDINGS=tests/CIMSNextMCC.Parity.Tests/golden/country.jsonl   (or the folder, to run every golden file)
// The lines carry inputs only: body is "" and sha256 is "", so no customer data is stored in the repository and the
// report says "legacy data changed since the recording" for every line (expected).
//   node tests/CIMSNextMCC.Parity.Tests/golden/make-masterdata-a.mjs
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const utc = '2026-10-18T00:00:00.000Z';

const line = (action, query, why) =>
  JSON.stringify({ utc, user: 'golden', method: 'GET', path: `/api/DataApi/${action}`, query, status: 200, body: '', sha256: '', why });

const strData = (action, obj, why) => line(action, `strData=${encodeURIComponent(JSON.stringify([obj]))}`, why);

// The "pre-entered" box layout the pages send (a page detail; the API does not take it).
const boxLayout = (heading) =>
  JSON.stringify([
    {
      Data: 'dtMain', Headings: 'dtHeading', _tblNameBox: 'tblPdata', _divBox: 'PData', _divFrame: 'divPreviousData',
      _BoxHeading: heading, isNewBtn: false, isEditBtn: false, isDelBtn: false, isSelectBtn: false,
      koArr: ['', '', ''], arrObj: [], arrRoVisible: [],
    },
  ]);
const findName = (action, heading, name, startsWith, why) =>
  line(
    action,
    `strName=${encodeURIComponent(name)}&isStartChrOnly=${startsWith}&strRtnPara=${encodeURIComponent(boxLayout(heading))}`,
    why,
  );

// ---------------------------------------------------------------- Country
const country = [];
// The legacy list ignores its CountryCode filter, so other values must change nothing.
for (const code of ['', 'IND', 'PAK', 'CHN', 'UK', 'VN', "O'X", 'All', 'zzz', 'LKA', ' ']) {
  country.push(strData('getCountryList', { CountryCode: code, strRtnPara: '[]' }, `CountryCode filter "${code}" (ignored by legacy)`));
}
// [why, code]: getCountryData as the page calls it (existence check also sends strCodeType).
for (const [why, code] of [
  ['Existing country, Both', 'IND'],
  ['Existing country, Export only (MALAYSIA)', 'MYS'],
  ['Existing country with mixed-case name', 'UK'],
  ['Lower-case code matches (column collation is case-insensitive)', 'ind'],
  ['Two-letter code (VIETNAM)', 'VN'],
  ['First row of the table', 'AE'],
  ['Lower-case two-letter code', 'vn'],
  ['Unknown code: legacy returns an empty table, new answers 404', 'ZZT1'],
  ['Apostrophe: legacy SQL breaks and ListTableLoad returns an empty table; new finds no row', "O'X"],
  ['Trailing space: SQL Server ignores trailing spaces in = comparisons', 'IND '],
  ['Longest legal code length, unknown', 'ABCDEFGHIJ'],
  ['Sri Lanka', 'LKA'],
]) {
  country.push(strData('getCountryData', { CountryCode: code, strRtnPara: '[]', strCodeType: 'Code' }, why));
}
// [why, name, startsWith]: findCountryName as the pre-entered box calls it (first keystroke, then longer text).
for (const [why, name, starts] of [
  ['First keystroke "I"', 'I', true],
  ['Two characters "IN"', 'IN', true],
  ['Lower case prefix matches', 'in', true],
  ['Prefix of a mixed-case name', 'United', true],
  ['Prefix shared by two countries (UAE and UK/US)', 'U', true],
  ['Prefix shared by MYANMAR and MALAYSIA', 'M', true],
  ['Exact name', 'SRI LANKA', false],
  ['Exact name, other case', 'sri lanka', false],
  ['Prefix equal to the whole name', 'India', true],
  ['No country starts with Z', 'Z', true],
  ['Apostrophe: legacy SQL breaks and returns an empty table; new finds nothing', "O'Brien", true],
  ['Full name of the longest entry', 'United States of America', true],
  ['Exact match that matches nothing', 'INDIA!', false],
]) {
  country.push(findName('findCountryName', 'Pre-Entered Supplier Listing', name, starts, why));
}

// ---------------------------------------------------------------- Ports
const ports = [];
// getPortList: CountryCode is applied when not empty; PortCode is ignored.
for (const [why, portCode, countryCode] of [
  ['What the page sends: no filters (all ports)', '', ''],
  ['PortCode is ignored by legacy', 'DEL', ''],
  ['One country, many ports', '', 'IND'],
  ['One country, several ports', '', 'CHN'],
  ['Lower-case country matches (collation)', '', 'ind'],
  ['Country with one port', '', 'AE'],
  ['US', '', 'US'],
  ['UK (a divertable port)', '', 'UK'],
  ['Country code with no ports of its own spelling', '', 'USA'],
  ['Malaysia', '', 'MYS'],
  ['Unknown country: empty', '', 'ZZ'],
  ['Apostrophe: legacy SQL breaks and returns an empty table; new finds nothing', '', "O'X"],
  ['Bangladesh', '', 'BDG'],
]) {
  ports.push(strData('getPortList', { strRtnPara: '[]', PortCode: portCode, CountryCode: countryCode }, why));
}
for (const [why, code] of [
  ['Existing port', 'DEL'],
  ['Lower-case code matches (collation)', 'del'],
  ['Code with spaces and a hyphen', 'USNWK - AP'],
  ['Prefix of the previous code is a different row', 'USNWK'],
  ['Divertable port', 'GBLGP'],
  ['Divertable port (LOGI)', 'LOGI'],
  ['Port without a country code', 'DAC'],
  ['Code with a digit', 'INMAA1'],
  ['Unknown code: legacy returns an empty table, new answers 404', 'ZZT1'],
  ['Apostrophe: legacy SQL breaks and returns an empty table; new finds no row', "O'X"],
  ['Three-letter airport code', 'KUL'],
  ['Last row by code', 'WSP'],
]) {
  ports.push(strData('getPortData', { PortCode: code, strRtnPara: '[]', strCodeType: 'Code' }, why));
}
for (const [why, name, starts] of [
  ['First keystroke "N"', 'N', true],
  ['Prefix shared by two NEWARK rows and Newark new jersey', 'Newark', true],
  ['Upper-case prefix, case-insensitive match', 'NEWARK', true],
  ['"Ho" matches HONG KONG port and HO CHI MINH', 'Ho', true],
  ['Name with a double space', 'HONG KONG  port', false],
  ['Single letter S', 'S', true],
  ['Exact name', 'Shanghai', false],
  ['Exact name, other case', 'shanghai', false],
  ['Nothing starts with Z', 'Z', true],
  ['Apostrophe: legacy SQL breaks and returns an empty table; new finds nothing', "O'X", true],
  ['Exact name with spaces', 'KUALA LUMPUR', false],
  ['Prefix of a long name', 'John F', true],
  ['Name that is a prefix of nothing exactly', 'Mumbai', false],
]) {
  ports.push(findName('findPortName', 'Pre-Entered Ports Listing', name, starts, why));
}

// ---------------------------------------------------------------- DC
const dc = [];
// The legacy list ignores its WhDes filter, so other values must change nothing.
for (const whDes of ['', 'JO JO WEB', 'Nordstrom Online', 'UK', 'Re-Export', "O'Brien", 'XD - Elmsall Drive', 'All', 'zzz', ' ']) {
  dc.push(strData('getDCList', { strRtnPara: '[]', WhDes: whDes }, `WhDes filter "${whDes}" (ignored by legacy)`));
}
for (const [why, whDes] of [
  ['Existing DC with a WhCode and a main group', 'Kohls Online'],
  ['DC without a WhCode', 'JO JO WEB'],
  ['Lower-case name matches (collation)', 'nordstrom online'],
  ['Name that is a prefix of another DC', 'Nordstrom Online'],
  ['The longer DC with the shared prefix', 'Nordstrom Online Split'],
  ['Hyphen', 'Re-Export'],
  ['Hyphen and spaces', 'XD - Elmsall Drive'],
  ['Name equal to a country code', 'UK'],
  ['DC in Malaysia', 'Zalora Online'],
  ['DC in Sri Lanka', 'Myntra India'],
  ['Unknown DC: legacy returns an empty table, new answers 404', 'Nowhere DC'],
  ["Apostrophe: legacy SQL breaks and returns an empty table; new finds no row", "O'Brien DC"],
  ['Trailing space: SQL Server ignores trailing spaces in = comparisons', 'Re-Export '],
  ['DC whose name starts with a different letter and has a hyphen', 'V - Dearne Valley Boxed'],
]) {
  dc.push(strData('getDCData', { WhDes: whDes, strRtnPara: '[]', strCodeType: 'Code' }, why));
}

for (const [name, lines] of [['country', country], ['ports', ports], ['dc', dc]]) {
  writeFileSync(join(here, `${name}.jsonl`), lines.join('\n') + '\n', 'utf8');
  console.log(`${name}.jsonl: ${lines.length} lines`);
}

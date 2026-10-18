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

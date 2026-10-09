# Isolated JASS codec checkpoint

2026-10-08. `experiments/Forsaken/Forsaken-save-codec.j` implements the reference
FSV envelope as library TForsakenSaveCodec. It has no initializer, triggers,
gameplay mutation, file IO, multiplayer messages or save commands. It is not
included by build_forsaken.py or inside BT. Saving remains blocked. This is the
implementation/compile portion of Step 4; real-engine execution and limits remain open.

## Format and validation

The module reads canonical base-32 varints carried by the existing alphabet,
checks lengths/counts/checksum/account, rejects duplicate sections and validates
known schema1 payloads for sections1–9. Definitions remain in
[SAVE_VNEXT_REFERENCE.md](SAVE_VNEXT_REFERENCE.md) and
[SAVE_PROGRESSION_MIGRATION.md](SAVE_PROGRESSION_MIGRATION.md).

Inventory validation includes unique ordinals/positions, all57 holder positions,
seven-bit quantities, binding flags and unique length-delimited metadata. Life
words are validated as finite positive binary32 encodings, including positive
subnormals; zero, negative, NaN and infinity fail. **This validates bits only;
it does not capture or restore a JASS real.** Unknown optional metadata, sections
and versions remain exact encoded payloads; unknown required data rejects.

Counted job, core, Gaya, upgrade, title, Armory and dormant records use reference
ranges and duplicate rules. Optional profile validation enforces required
sections, frozen job/upgrade IDs, core/Gaya presence, mastery implications and
life/flag presence for new captures. Migration evidence is shape-checked only,
not replayed through an in-game legacy decoder. It does not establish semantic
equality or runtime eligibility. Unknown IDs remain data and grant nothing here.

Research bounds: payload16384 characters, sections32, aggregate opaque data4096,
items57, metadata16/item, scalar records2048, dormant records256, original-code
evidence4096 characters. Counts are checked before loops. Duplicate tracking
uses distinct per-context hashtable namespaces, cleared on returned success
or failure. Uint decoding checks the seventh group before multiplying and never
computes an eighth factor. Maximum scalar2147483647; checksum intermediates also
fit signed32. No live job count, rawcode or item handle drives parsing.

## State and API

Human player IDs0–7 are validated before array access. Contexts1–8 hold accepted
data,9–16 decoder scratch and17–24 writer buffers. Section arrays use
context*32+sectionIndex (maximum799); profile arrays also fit the classic8192
bound. Per-player busy/writer flags reject competing operations. The module does
not yield or call gameplay. One shared hashtable initializes lazily.

| Call | Result |
|---|---|
| FSC_Decode(pid, encoded, expectedAccount, requireProfile) | Validate in scratch; success replaces accepted sections; returned false preserves previous accepted data |
| FSC_Reencode(pid) | Reconstruct accepted framing/sections byte-for-byte; null if no accepted data |
| FSC_Begin(pid, account) | Open an independent writer; refuse already open/busy player |
| FSC_Add(pid, sectionId, schemaVersion, required, payload) | Append bounded encoded section; invalid add poisons writer so its valid prefix cannot export |
| FSC_Finish(pid, requireProfile) | Encode, close writer, validate through decoder; return new code or null, preserving prior accepted data on failure |
| FSC_Abort(pid) | Discard writer without changing accepted data |
| FSC_Reset(pid) | Clear player's buffers; refuse busy player |

`expectedAccount=-1` disables comparison **for research only**. Future runtime
routes must supply the validated account hash. `requireProfile=false` validates
a generic envelope, not a character. Runtime loading needs profile, mode,
ownership, legacy evidence/default and eligibility checks before gameplay mutation.

Accepted sections are in FSC_Account[pid+1], FSC_Count[pid+1] and
FSC_Id/Version/Required/Payload[(pid+1)*32+index]; FSC_Code[pid] is accepted input.
These arrays are internal storage: callers must not mutate them or call internal
context/parser functions. The adapter still needs staged logical items.

This buffer replacement is not a gameplay transaction. Returned parser failures
are tested; forced engine thread termination/operation-budget exhaustion is not.
The synchronous full-string implementation must be measured in Warcraft and,
if necessary, changed to bounded work units before integration. Busy cleanup,
recovery and synchronized promotion under that execution model need verification.
No string/file/chat/latency capacity is claimed.

## Evidence and reproduction

test_save_jass.py executes actual source functions through the existing limited
JASS control-flow harness with mocked string/hashtable natives. The independent
Python codec supplies expected acceptance and bytes. Array accesses/stored
integer ranges are checked; Python arithmetic is not the Warcraft VM. Compilation
is a separate pjass check, not inferred from the harness.

13 JASS tests PASS:3 original and8 migration goldens; full/sparse inventories and
both rings; quantities0/120/121/127; binary32 boundaries; known ranges; malformed
nested records; required/optional data; evidence/opaque budgets; all truncations
of the494-character H golden;150 seeded differential envelopes, writer outputs
and150 mutations; eight players' simultaneous writers; returned-failure
preservation; profile requirements; near-limit payloads; invalid players; CRLF,
array bounds and isolation. Standalone compilation passes against bundled and
classic1.29.2 libraries.

Read-only probes also pass for standalone, BT playable script plus inert codec,
and BT editor-source flattening plus inert codec. Editor probes omit disabled
DevCommands as check_map.py does. BT's hash remains its manifest's
4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2.
No archive, trigger list, release or gameplay source was changed.

Local report: build/save-codec-compile-zl7pgdq8/report.json and three generated
scripts. It records compiler/source/map/library hashes. Libraries are existing
extracted ../war3.w3mod/scripts/common.j and blizzard.j, not a fresh client-version
verification. Their SHA256 values respectively:
6948e88800a3903afd995322f1b8516329d28eee75587977f6f731c3cfa438da;
8398e1852cfed3660c3a2f473a89ecfb48efec32898eca290f5216c742e1595f.

```powershell
& $ffPython experiments/Forsaken/test_save_jass.py
& $ffPython experiments/Forsaken/check_save_jass.py --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

Each probe creates fresh build/save-codec-compile-* scripts/report, never a map.
Compiler DLL loading failed in the Codex sandbox (Windows623); checks passed
outside it. No checks were skipped/relaxed. Actual compilation also caught local
names code/version colliding with native types; renamed before final passing probes.

Other focused suites rerun:13 reference codec tests (1000 seeded round trips),
16 migration tests (250 seeded round trips) and13 legacy decoder tests PASS.
Total55 tests. Legacy's existing itemtable ResourceWarning remains unchanged.
No real-engine, playable-codec build, restart, multiplayer or transport acceptance.

Next: measured engine execution/work scheduling, exact real capture/default
resolution, staged restoration/rollback, in-game legacy evidence/account linkage,
then entry routes and transport. BU remains unused; AS and baseline Z unchanged.

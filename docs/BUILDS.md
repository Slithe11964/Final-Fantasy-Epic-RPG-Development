# Repeatable source builds (stages T/U)

Run from the FFERPG repository in PowerShell:

```powershell
.\build.ps1 -Stage X -Base release/FFERPG_0.9.7.3-r16-stageW.w3x
```

Use a stage that does not exist yet. The command selects changed enabled modules, syncs their code,
orders libraries, runs every gate, adds the HM3W header and publishes three new files in release/:
the map, `checks-r16-stageV.txt`, and `build-r16-stageV.json`. Existing files are refused, including
reports and manifests. Any failed check stops publication. Scratch maps and logs remain in build/.
Only one process can build the same stage at a time; its lock is removed on normal exit. If a process
is forcibly terminated, verify no build is running before removing its leftover stage lock.

For the confirmed baseline, `-Base` may be omitted. `tools/build-config.json` pins stage S and its
SHA256 `923dc01ea5be419299ce02ac802ab34825c28f7e7aad3a3c262d9aa2d87b30ef`.
An explicit base's hash is recorded instead of silently changing that pinned baseline. For incremental
development, supply the newest reviewed map. No stage is selected or overwritten automatically.

## Inputs and setup

- Python 3.9+; the PowerShell wrapper finds this PC's bundled Python or python on PATH. An explicit
  `-PythonPath C:\path\python.exe` is supported. The portable entry point is
  `python tools/build_stage.py W --base release/FFERPG_0.9.7.3-r16-stageV.w3x`.
- `tools/bin/pjass.exe`, `common.j`, `blizzard.j` (or the locations accepted by check_map.py).
- Sibling `../MapToolkit/tools/add_header.py`. Its exact hash is recorded and header finalization
  must preserve the checked archive bytes. JassHelper is needed for World Editor saves; this command
  uses sync_module/vjass_lite instead, and records that distinction.
- Git and an identified baseline map, including its terrain/objects/assets. Maps are ignored by Git;
  cloning the repository alone cannot recreate those assets. Keep the baseline and manifests backed up.

The manifest records base/output hashes, Git commit/dirty status, source and tool hashes, Python
version/platform, and compiler/native-file identities. pjass has no embedded version here, so its
SHA256 identifies the exact binary. JassHelper's identity is recorded if installed at the historical
tool location, with `used: false`. Header-only finalization is checked before publication.

## Mandatory gates

| Gate | What it protects |
|---|---|
| check_map.py | Playable/editor compilation, startup wiring/order, globals, native-save string size. |
| check_editor_sources.py | All repository modules compile, including disabled developer tools. |
| check_sources.py | Every enabled library function agrees with embedded source and runtime, or its exact tested historical pair. |
| check_quests.py | Definitions, capacities, map references, dependencies and synchronous waits in hooks. |
| check_content.py | Duplicate object IDs and typed literal item/unit/ability references. |
| check_save_compat.py | Append-only item indexes <=500, item charge/base/class preservation, job order, armory mappings, serializers and fixed G/H vectors. |
| tests/run_tests.py | 38 regression tests, including actual quest lifecycle/event source with mocked natives. |
| savecode.py selftest | 2,000 randomized encode/decode/rename/checksum cases. |

For intentionally new/removed triggers, pass `-AllowNew REGEX` / `-AllowRemoved REGEX` (Python:
`--allow-new` / `--allow-removed`). These only scope the startup comparison; all other gates still run.

## Scope and existing differences

This is a module-source builder. New modules or changed trigger layouts need add_module/remove_module
or World Editor first. Changed map-header code and changed global declarations that sync_module cannot
handle require a World Editor compile/export. Object, terrain and asset edits must already be in the
chosen base map; this command does not invent or update Object Editor data.

Semantic module changes are selected using normalized tokens. Comment/formatting changes and disabled
modules update editor source without replacing playable bodies. This matters because tested stage S
contains 1,283 historical source/runtime differences among 10,915 enabled functions. Some are compiler
optimizations; no general claim of semantic equivalence is made. `runtime-baseline-differences.json`
allows only the exact source/runtime hash pair for each existing difference. A changed source body
must agree with its synced runtime; a newly edited module can also replace historical bodies in that
module, so review its full playable diff. Never resync all modules merely to eliminate the old pairs.

Content references are checked by typed native/BJ signatures, including valid buff removal/query IDs
and object base IDs. Five existing locations remain unresolved by this map's object tables. The
location/count contract preserves them without declaring them correct. A new stock ID absent from
these tables needs explicit stock-data verification and a reviewed contract entry. Computed IDs,
dynamic calls, and object-field references are outside this literal-call check.

Contracts in `tools/contracts/` are reviewed compatibility policy, not generated build output. Builds
never refresh them. The once-only `--record-tested-baseline` commands refuse existing contracts.
Do not delete/regenerate a contract to silence a failure. World Editor/JassHelper may introduce new
optimized source/runtime pairs; review those differences before accepting a new baseline contract.

After each build, record a new STAGES.md row and update HANDOFF.md and ../RESUME_PROMPT.txt. These docs
are deliberately maintained by the developer rather than treating a passing build as user play-test
confirmation. Run focused in-game tests for gameplay changes and preserve actual player save codes
when extending the save format.

## Current result

Stage T established the workflow; stage U strengthened expression-call tracing, buff/base reference
resolution and inherited item/save-count guards. Stage S is user-confirmed working. Stage U's playable
script is byte-identical to S; of 521 listed archive files, only war3map.wct changed (the disabled
DevCommands inspector). T and U have identical MPQ archives, with different outer map-name headers.
Proof: release/preservation-r16-stageU.json. All U checks, 35 tests and 2,000 codec cases pass.
An isolated source-copy smoke build also selected and synced a changed enabled QuestEngine module,
then passed the full pipeline; release/smoke-r16-stageU.json records it. No real repository source
was changed by that test. Reusing stage U was separately verified to refuse the existing release.
The documented bugs were left unchanged at the user's request.

Worked new-content examples: [CONTENT_DEVELOPMENT.md](CONTENT_DEVELOPMENT.md).

Stage V is the current incremental base: six gameplay functions now own temporary context in
TrueIceAge/Cartographer. All gates/38 tests pass; preservation-r16-stageV.txt verifies exact
reversal and unchanged other archive files. Focused gameplay testing is in QUEST_TESTS.md.

## Editor pairing repair (stage W)

Stage W is the editing base. Older post-engine builds have a folder/source storage mismatch:
an enabled trigger can display another module, causing missing TQuestEngine on editor save.
editor_layout.py preserves name/source pairs while canonicalizing WTG/WCT into folder order;
build_stage runs it before order_libraries/check_map. check_map rejects layout mismatches and
custom source without its own InitTrig. add_module also normalizes. Runtime compilation alone
does not detect this editor-association issue. Actual World Editor Save As remains required.

W carries the user's Intro.j wording edits and otherwise preserves every gameplay function.
41 tests and all gates pass; preservation-r16-stageW.json includes an isolated module-add smoke.

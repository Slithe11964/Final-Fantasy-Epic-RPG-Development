# FF Epic RPG handoff

Read this first. Keep it short: it says where things stand, not what happened. Build-by-build
notes go in one row of [STAGES.md](STAGES.md); details go in the doc for that feature. The long
logs up to 2026-10-10 are in [history/](history/).

## Where things stand (2026-10-16)

PAIR012 is the checked gameplay follow-up, installed in the Warcraft TEST folder
as FFERPG-PAIR012-Forsaken.w3x and FFERPG-PAIR012-1.29.2.w3x (hash verified): proximity turn-in for Eidolon
Challenge; separate per-player travel dialogs with ten destinations per page and
unchanged unlock IDs; native quest searches across all carried slots; charged-item
stacking across the full inventory; Gather consolidation of existing hero/Gaya/house
stacks and matching house-ground items; equipped-only Hero Medicine refill and
Sleipnir stale-marker/aura cleanup. Both inventory interfaces and the shared save
format are retained. See BACKPACK.md for behavior and engine acceptance checks.
The first private PAIR012 attempt stopped at an outdated native quest test fixture;
the corrected fixture passes against both profiles. No incomplete pair was published.

The user reproduced a Forsaken PAIR007 multiplayer desync during `-loadf dev`.
The seven-player report/replay narrows this attempt to private preparation/first
send: the command is present without a subsequent FSCU packet for that request.
The user confirmed PAIR010 Forsaken multiplayer import no longer desynchronizes.
That private-IO separation remains: synchronized receivers validate content, export
checksums run before private writing, and file bytes/inventory interfaces are retained.

PAIR011 is the checked performance follow-up, installed in the Warcraft TEST folder
as FFERPG-PAIR011-Forsaken.w3x and FFERPG-PAIR011-1.29.2.w3x (hash verified). It reclaims unrooted save
fragments through bounded shared/private queues, releases finished projectile hit
groups, guards exhausted motion pools, caches native UI searches/render reads and
invalidates Armory/Chronicle totals on changes. Cross-module save assignments retain
roots, preserving active work and screenshot pages. The canonical source and paired
runtime maintenance carry these changes into future editor-master builds without
rewriting the master. See PERFORMANCE_AUDIT.md and SAVE_129.md.

The freeze report was after loading, with three players questing and about four
quests completed; another player had a medium-progress import. These changes repair
concrete audit findings but do not identify the engine's freezing instruction.
Extended multiplayer quest/combat acceptance remains required. PAIR008/PAIR009 and
the interrupted first PAIR011 attempt did not publish output pairs.

The large imported-character Warcraft menu checkpoint passed in PAIR004 Reforged
but still crashed in 1.29.2 Simple after quests and a complete restart. That classic
checkpoint fix remains unresolved; CheckpointNoItems.txt is installed separately
for isolation (SAVE_129.md). Earlier failed checkpoints embed the old map.

[PERFORMANCE_AUDIT.md](PERFORMANCE_AUDIT.md) distinguishes confirmed resource/work
issues from unmeasured startup opportunities. Preserve combat timer timing and
preloads unless profiling supports another change.

| Line | Map | State |
|---|---|---|
| Reforged gameplay | `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenEN.w3x` | EN lets hero/Gaya curse scrolls find matching gear across their native quick, bag and equipment slots; inventory failure keeps the original and scroll. Curse acceptance pending. EM unlocks Phoenix and Annoying Monster directly when Ao Madoushi starts; in-game quest acceptance pending. EL uses the standard gold Secrets category counter and removes the outdated Simple load warning. EK recreates Bazaar/Stats/Talents frames after Warcraft menu loads, defers initial panel setup and supplies fallback button access. UI acceptance pending; fresh-versus-saved-game clarification is still unanswered. EI validation work/timeout rollback remain; preserves DW native inventory and the FSVB format. Import and Warcraft menu checkpoint acceptance pending. EH is superseded before tester acceptance. EF Tiny import/checkpoint cycle passed. Classic Backpack/SaveSlots modules are rejected by the builder. Gameplay features and prior acceptance are recorded in SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |
| 1.29.2 development | `release/1.29.2/FFERPG_0.9.7.3-r16-stageATV.w3x` | ATV adds curses across all seven classic pages, both scroll users, and shared Ao Madoushi side offers/Simple text; in-game acceptance pending. ATU splits validation into bounded execution steps after ATT -loadf dev hung for over a minute. It drains one cache packet/player/tick and recovers stopped imports using verified rollback. Exact format, interrupted-work and load/recapture models pass; in-game import and Warcraft menu checkpoint acceptance pending. ATS Tiny import/checkpoint cycle passed. The long-string isolation probe failed with an intact container; native checkpoint acceptance for endgame profiles remains unresolved. Backpack pages, cooldowns, water projectiles, equip routing, Armory/Bazaar, autosave and collection changes remain (BACKPACK.md, SAVE_129.md). The corresponding release/...stageATV.w3x is an authoring intermediate, not the Reforged gameplay map. |
| Public baseline | `baseline/Reforged/` and `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` (stage Z) | Tracked in Git; confirmed working 2026-10-06. |

| New save system | Forsaken EN (Reforged) and ATV (1.29.2) | Shared FSVB format and permanent IDs; native Reforged equipment maps to classic equipment pages. Tiny full checkpoint round-trip confirmed in ATS/EF; ATU/EI need an endgame import test first, then a new-checkpoint test. ATT stalled during import in classic; the Python data model did not model Warcraft's thread execution budget. DW/DZ round-trip, multiplayer delivery, endgame slots, cleanup/retry, one-load and fifteen-minute cutoff passed. Priest reset, Chronicle restoration and three-second portals remain. DX is the separate multi-file test. See SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |

All 93 quests run on QuestEngine (QUEST_ENGINE.md). Bugs are deferred by user request (BUGS.md).

## Building

User editing workflow: [editor/README.md](../editor/README.md). Open/save the shared
Reforged-format `editor/FFERPG-Editor-Master.w3x`, then run `.\build-pair.ps1`.
The checked initial pair is `release/pairs/PAIR004/` (native 110 tests, classic 201
tests with 8 skipped, compiler/content/startup/save gates passed). Actual World
Editor Save As and gameplay acceptance remain pending.
The pinned authoring reference is ATV and the pinned native reference is EN;
`editor/pair-config.json` verifies their hashes. Keep these ignored binary files
with the master when backing up. Outputs publish together in `release/pairs/`.
Root `src/`, the master and reference maps are never rewritten by the paired builder.
The master uses classic/shared inventory while authoring; only the native output
contains the native Forsaken inventory and panels. Do not use a generated map as
a replacement master. Compatibility conflicts stop with retained private build logs.

1.29.2 authoring build (Windows PowerShell, from this folder):

```powershell
.\build.ps1 -Stage <next unused> -Base release/FFERPG_0.9.7.3-r16-stageATV.w3x
```

It finds changed modules in `src/`, syncs them into the base map, orders libraries, checks the
result and writes `release/<name>-stage<X>.w3x` **and** the matching 1.29.2 map in
`release/1.29.2/` (same name). The 1.29.2 conversion is part of the checks: shared code must
compile against 1.29.2, and Reforged-only UI lives in add-ons the converter swaps for dialogs
(`BazaarFrame_`, `TalentFrame_`). `-NoClassic` skips it. Existing files are never overwritten.
For a World Editor save, `.\make_129.ps1 -Map release/<map>.w3x` still converts one map.
Details and failure handling: BUILDS.md.

Design rule (user, 2026-10-10): edit in the Reforged editor, but the default map and every change
target 1.29.2 where possible; Reforged gets nicer UI on top (Bazaar 3 panels, talent panel,
the native Forsaken inventory). Saves must stay compatible between the two. Reforged gameplay
uses the Forsaken branch; paged Backpack/SaveSlots modules belong only to the classic line.
Build the native Reforged update with `python experiments/Forsaken/build_dw_update.py --stage <next>`;
its builder rejects classic inventory modules.

- The 96 regression tests and the base-map checks only rerun when `tools/`, `src/`, `baseline/`
  or the base map changed since they last passed (cache in `%USERPROFILE%\.cache\fferpg-build`).
  The output map is always fully checked. Add `-FullChecks` to force a full rerun.
- Forsaken gameplay build: `python experiments/Forsaken/build_forsaken.py --stage <X>`.
- Save diagnostic build: `python experiments/Forsaken/build_save_probe.py --stage <X> --gear-probe`
  (or `--house-probe`). Default base is ForsakenBT.
- Complete private round trip: `python experiments/Forsaken/build_save_roundtrip.py --stage <X>`.
- World Editor: enable JassHelper/vJass, Save As a new file, then `python tools/export_sources.py`
  and review the source diff before committing.

## Rules

- `.j` sources stay CRLF; one vJass library per trigger under `src/triggers/<folder>/`.
- Comment calculations only when they are not trivial (CONTRIBUTING.md).
- Keep dialogue, rewards and behaviour unless the change asks for it. Keep save item/job indexes
  append-only (tools/contracts).
- After a build: add one STAGES.md row, update this page only if "where things stand" changed,
  commit. Don't paste test counts, hashes or scratch paths into docs; the build writes them to
  `release/checks-*.txt` and `build-*.json` next to the map.
- Future Forsaken builds use the r17 metadata in experiments/Forsaken/map-presentation.json
  and the current src/triggers/06 Quests and story/Intro.j, including private test maps.
- When a map is superseded, it can be moved out of `release/`; keep the current AS pair and any
  Forsaken map a doc names as the current test.

## Next

1. PAIR012: test the inventory/travel/equipment cases in BACKPACK.md, then start a fresh multiplayer game with the same endgame/medium imports; complete more than four quests and exercise projectile combat. Check inventory, inspection, stats/talents and collection updates after gains/removals. Confirm normal save screenshot pages remain available and file saves still import. Report whether a freeze affects one or every client and the last activity. PAIR010 loading desync acceptance passed; PAIR011 freezing acceptance is pending. The 1.29.2 large-import Warcraft-menu checkpoint issue remains unresolved; compare the separately installed CheckpointNoItems diagnostic and test only newly created checkpoints. Tiny checkpoint success does not prove the endgame case. Future edits remain in the editor master; the paired builder applies reviewed maintenance to both profiles.
2. Armory ATP/EC: root total only, each category button has its own progress and opens the right page; Close/Back has no counts. Bazaar: prepare consumes parts, purchase pays and delivers, rewards reveal and recipe-ready text returns.
3. Forsaken: load a DW save in EC and reset Priest talents: the hero/job/gear must remain, the point returns, and the Shrine positions and milestone totals match. DX remains the separate multi-file test; multiplayer timings remain pending. See SAVE_FRESH_LOAD_TEST.md.
4. Talents: user is writing each job's list (Priest first); Shrine sells Reset Talents. New content on ASC: CONTENT_DEVELOPMENT.md has worked quest/boss/item examples.
5. Optional cleanup of shared temp variables: PHASE16.md.

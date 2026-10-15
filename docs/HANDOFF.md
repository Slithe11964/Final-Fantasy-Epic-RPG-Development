# FF Epic RPG handoff

Read this first. Keep it short: it says where things stand, not what happened. Build-by-build
notes go in one row of [STAGES.md](STAGES.md); details go in the doc for that feature. The long
logs up to 2026-10-10 are in [history/](history/).

## Where things stand (2026-10-15)

| Line | Map | State |
|---|---|---|
| Reforged gameplay | `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenEM.w3x` | EM unlocks Phoenix and Annoying Monster directly when Ao Madoushi starts; in-game quest acceptance pending. EL uses the standard gold Secrets category counter and removes the outdated Simple load warning. EK recreates Bazaar/Stats/Talents frames after Warcraft menu loads, defers initial panel setup and supplies fallback button access. UI acceptance pending; fresh-versus-saved-game clarification is still unanswered. EI validation work/timeout rollback remain; preserves DW native inventory and the FSVB format. Import and Warcraft menu checkpoint acceptance pending. EH is superseded before tester acceptance. EF Tiny import/checkpoint cycle passed. Classic Backpack/SaveSlots modules are rejected by the builder. Gameplay features and prior acceptance are recorded in SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |
| 1.29.2 development | `release/1.29.2/FFERPG_0.9.7.3-r16-stageATU.w3x` | ATU splits validation into bounded execution steps after ATT -loadf dev hung for over a minute. It drains one cache packet/player/tick and recovers stopped imports using verified rollback. Exact format, interrupted-work and load/recapture models pass; in-game import and Warcraft menu checkpoint acceptance pending. ATS Tiny import/checkpoint cycle passed. The long-string isolation probe failed with an intact container; native checkpoint acceptance for endgame profiles remains unresolved. Backpack pages, cooldowns, water projectiles, equip routing, Armory/Bazaar, autosave and collection changes remain (BACKPACK.md, SAVE_129.md). The corresponding release/...stageATU.w3x is an authoring intermediate, not the Reforged gameplay map. |
| Public baseline | `baseline/Reforged/` and `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` (stage Z) | Tracked in Git; confirmed working 2026-10-06. |

| New save system | Forsaken EM (Reforged) and ATU (1.29.2) | Shared FSVB format and permanent IDs; native Reforged equipment maps to classic equipment pages. Tiny full checkpoint round-trip confirmed in ATS/EF; ATU/EI need an endgame import test first, then a new-checkpoint test. ATT stalled during import in classic; the Python data model did not model Warcraft's thread execution budget. DW/DZ round-trip, multiplayer delivery, endgame slots, cleanup/retry, one-load and fifteen-minute cutoff passed. Priest reset, Chronicle restoration and three-second portals remain. DX is the separate multi-file test. See SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |

All 93 quests run on QuestEngine (QUEST_ENGINE.md). Bugs are deferred by user request (BUGS.md).

## Building

1.29.2 authoring build (Windows PowerShell, from this folder):

```powershell
.\build.ps1 -Stage <next unused> -Base release/FFERPG_0.9.7.3-r16-stageATU.w3x
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

1. Native UI (EK): start a fresh game, import the character file, verify Secrets text/count, three-panel Bazaar prepare/purchase and Stats/Talents; make a NEW Warcraft menu save, restart/load it, then verify those panels again and confirm talent choices persist. Saved games made in EI embed the old code. Save (ATU/EK): first confirm -loadf dev completes in a fresh game (ATT hung in classic). Then create a NEW Warcraft menu save, fully exit/restart and load it. Earlier menu saves embed the old map. The isolated long-string probe failed; bounded storage is the current candidate, not yet confirmed in-game. Run `python experiments/Forsaken/test_save_strings.py` after changing its lowering/helper. Legacy whole-code preload files retain their previous checkpoint limitation. Also retest autosave with a populated backpack and reload the autosave file; check the New Game Plus notice on an eligible endgame load. Difficulty: save an Easy-origin character in Nightmare, then confirm Easy accepts it and Inferno rejects it; resave an Inferno-origin character in Nightmare and confirm it loads anywhere. Test both clients. After any change to the experiments/Forsaken save modules, rerun `python tools/save_port.py <built map>`.
2. Armory ATP/EC: root total only, each category button has its own progress and opens the right page; Close/Back has no counts. Bazaar: prepare consumes parts, purchase pays and delivers, rewards reveal and recipe-ready text returns.
3. Forsaken: load a DW save in EC and reset Priest talents: the hero/job/gear must remain, the point returns, and the Shrine positions and milestone totals match. DX remains the separate multi-file test; multiplayer timings remain pending. See SAVE_FRESH_LOAD_TEST.md.
4. Talents: user is writing each job's list (Priest first); Shrine sells Reset Talents. New content on ASC: CONTENT_DEVELOPMENT.md has worked quest/boss/item examples.
5. Optional cleanup of shared temp variables: PHASE16.md.

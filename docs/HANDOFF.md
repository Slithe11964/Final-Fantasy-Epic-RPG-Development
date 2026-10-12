# FF Epic RPG handoff

Read this first. Keep it short: it says where things stand, not what happened. Build-by-build
notes go in one row of [STAGES.md](STAGES.md); details go in the doc for that feature. The long
logs up to 2026-10-10 are in [history/](history/).

## Where things stand (2026-10-12)

| Line | Map | State |
|---|---|---|
| Normal development | `release/FFERPG_0.9.7.3-r16-stageASF.w3x` (Reforged, edit this one) and `release/1.29.2/FFERPG_0.9.7.3-r16-stageASF.w3x` | ASF (same content as ASE) = ASB + job talents (TALENTS.md). ASB = user's editor save ASA (`baseline/Reforged/...stageASA.w3x`, not tracked) + Esc closes Bazaar + classic tooltip-level fix. ASA's object tables and script were taken from AS (identical content; the editor save only re-optimized them) except the enlarged Shipyard region. Base for the next normal build. |
| Public baseline | `baseline/Reforged/` and `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` (stage Z) | Tracked in Git; confirmed working 2026-10-06. |
| Forsaken gear (native 3.0 bag/equipment) | `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x` | Last gameplay checkpoint. Saving is disabled in Forsaken maps. See experiments/Forsaken/README.md. |
| New save system | `release/Forsaken/...ForsakenDU.w3x` (private test; DV = multi-file test copy) | Real round-trip, multiplayer delivery, endgame slots, cleanup/retry, one-load and fifteen-minute cutoff passed. Inactive Freelancer portrait fixed. DU: no standing still to save, loads replace the starter in place, loaded masteries restore food/titles/total level. Screenshot colors/layout confirmed. DT retains r17 presentation and file-only legacy save messages; the town shrine is always visible, unmastered Freelancer attempts are silent, and mastered loads restore shrine menus. Screen saves, numbered chat loads and exact-name legacy/new file detection await real-client acceptance; multiplayer timings remain pending. Public saving stays off. See SAVE_FRESH_LOAD_TEST.md. |

All 93 quests run on QuestEngine (QUEST_ENGINE.md). Bugs are deferred by user request (BUGS.md).

## Building

Normal build (Windows PowerShell, from this folder):

```powershell
.\build.ps1 -Stage <next unused> -Base release/FFERPG_0.9.7.3-r16-stageASF.w3x
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
later the Forsaken inventory). Saves must stay compatible between the two.

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

1. Save system: test DU mastery/food restore, in-place load and chat loading (save_test_helper.py); verify
   multi-file loading and missing-part rejection in DV and collect multiplayer size/timing observations. No live-swap rollback or quest/era saving; see SAVE_SYSTEM_PLAN.md.
2. Talents: user is writing each job's list (Priest first); Shrine sells Reset Talents. New content on ASC: CONTENT_DEVELOPMENT.md has worked quest/boss/item examples.
3. Optional cleanup of shared temp variables: PHASE16.md.

# FF Epic RPG handoff

Read this first. Keep it short: it says where things stand, not what happened. Build-by-build
notes go in one row of [STAGES.md](STAGES.md); details go in the doc for that feature. The long
logs up to 2026-10-10 are in [history/](history/).

## Where things stand (2026-10-10)

| Line | Map | State |
|---|---|---|
| Normal development | `release/FFERPG_0.9.7.3-r16-stageAS.w3x` (Reforged, edit this one) and `release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x` | User reports everything in AS works. Base for the next normal build. |
| Public baseline | `baseline/Reforged/` and `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` (stage Z) | Tracked in Git; confirmed working 2026-10-06. |
| Forsaken gear (native 3.0 bag/equipment) | `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x` | Last gameplay checkpoint. Saving is disabled in Forsaken maps. See experiments/Forsaken/README.md. |
| New save system | `release/Forsaken/...ForsakenCB.w3x` (house test, user PASS); `...CT` (boots/equipment test, user PASS) | Private diagnostics passed. Next: real fresh-character file save/restart/load prototype (CU); SAVE_SYSTEM_PLAN.md. Full new-format save/load stays off. |

All 93 quests run on QuestEngine (QUEST_ENGINE.md). Bugs are deferred by user request (BUGS.md).

## Building

Normal build (Windows PowerShell, from this folder):

```powershell
.\build.ps1 -Stage <next unused> -Base release/FFERPG_0.9.7.3-r16-stageAS.w3x
```

It finds changed modules in `src/`, syncs them into the base map, orders libraries, checks the
result and writes `release/<name>-stage<X>.w3x`. Existing files are never overwritten.
Classic copy: `.\make_129.ps1 -Map release/<map>.w3x`. Details and failure handling: BUILDS.md.

- The 96 regression tests and the base-map checks only rerun when `tools/`, `src/`, `baseline/`
  or the base map changed since they last passed (cache in `%USERPROFILE%\.cache\fferpg-build`).
  The output map is always fully checked. Add `-FullChecks` to force a full rerun.
- Forsaken gameplay build: `python experiments/Forsaken/build_forsaken.py --stage <X>`.
- Save diagnostic build: `python experiments/Forsaken/build_save_probe.py --stage <X> --gear-probe`
  (or `--house-probe`). Default base is ForsakenBT.
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
- When a map is superseded, it can be moved out of `release/`; keep the current AS pair and any
  Forsaken map a doc names as the current test.

## Next

1. Save system: build CU for one real file save/restart/fresh-character load and size/timing
   measurements. No live-swap rollback or quest/era saving; see SAVE_SYSTEM_PLAN.md.
2. New content on AS: CONTENT_DEVELOPMENT.md has worked quest/boss/item examples.
3. Optional cleanup of shared temp variables: PHASE16.md.

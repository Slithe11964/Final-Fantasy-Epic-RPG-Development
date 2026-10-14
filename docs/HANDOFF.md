# FF Epic RPG handoff

Read this first. Keep it short: it says where things stand, not what happened. Build-by-build
notes go in one row of [STAGES.md](STAGES.md); details go in the doc for that feature. The long
logs up to 2026-10-10 are in [history/](history/).

## Where things stand (2026-10-14)

| Line | Map | State |
|---|---|---|
| Reforged gameplay | `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenEE.w3x` | EE keeps native inventory and retires replaced starter bodies as hidden, paused neutral units for the imported-character Warcraft checkpoint crash retest. ED merchant notices confirmed. EC Armory/Bazaar behavior confirmed in classic; native gameplay checks pending. EB routes autosave through the read-only file-save pipeline; eligible fresh loads announce/enable New Game Plus. Autosave acceptance pending. Classic Backpack/SaveSlots modules are rejected by the builder. Retest `-loadf dev` and cross-version saves. ATM Reforged is superseded for gameplay. |
| 1.29.2 development | `release/1.29.2/FFERPG_0.9.7.3-r16-stageATR.w3x` | ATR retires replaced starter bodies as hidden, paused neutral units for the imported-character checkpoint crash retest. ATQ merchant notices confirmed. ATP Armory category tooltips and Bazaar prepare/purchase/reveal confirmed; Warcraft menu load still crashes after -loadf, so snapshot release did not resolve it. Fresh characters load after restarting Warcraft but same-session reload can exhaust memory. Imported characters still crash after restart in ATQ and Reforged ED; ATR/EE are candidates, not confirmed fixes. ATO fixed legacy autosave routing, adds the New Game Plus load notice, Secrets tooltip/summary total, and Armory category/subcategory totals. Classic Chronicle counters otherwise confirmed. ATN added explicit classic collection-tooltip levels, `-armory`/`-chronicle` category and collection totals, and `-equipment` for all nine slots; in-game check pending. ATM preserves imported difficulty tiers through Nightmare saves. Backpack pages, cross-page cooldowns, water projectiles, item checks and wearing rules remain (BACKPACK.md, SAVE_129.md). The corresponding `release/...stageATR.w3x` is an authoring intermediate for classic conversion, not the Reforged gameplay map. |
| Public baseline | `baseline/Reforged/` and `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` (stage Z) | Tracked in Git; confirmed working 2026-10-06. |

| New save system | Forsaken EE (Reforged) and ATR (1.29.2) | Shared FSVB format and permanent IDs; native Reforged equipment maps to classic equipment pages. Retest this pair in game. DW/DZ round-trip, multiplayer delivery, endgame slots, cleanup/retry, one-load and fifteen-minute cutoff passed. Priest reset, Chronicle restoration and three-second portals remain. DX is the separate multi-file test. See SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |

All 93 quests run on QuestEngine (QUEST_ENGINE.md). Bugs are deferred by user request (BUGS.md).

## Building

1.29.2 authoring build (Windows PowerShell, from this folder):

```powershell
.\build.ps1 -Stage <next unused> -Base release/FFERPG_0.9.7.3-r16-stageATR.w3x
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

1. Save (EC/ATP): test a new Warcraft saved game after importing a character (ATO crashed); retest autosave with a populated backpack and reload the autosave file; check the New Game Plus notice on an eligible endgame load. Difficulty: save an Easy-origin character in Nightmare, then confirm Easy accepts it and Inferno rejects it; resave an Inferno-origin character in Nightmare and confirm it loads anywhere. Test both clients. After any change to the experiments/Forsaken save modules, rerun `python tools/save_port.py <built map>`.
2. Armory ATP/EC: root total only, each category button has its own progress and opens the right page; Close/Back has no counts. Bazaar: prepare consumes parts, purchase pays and delivers, rewards reveal and recipe-ready text returns.
3. Forsaken: load a DW save in EC and reset Priest talents: the hero/job/gear must remain, the point returns, and the Shrine positions and milestone totals match. DX remains the separate multi-file test; multiplayer timings remain pending. See SAVE_FRESH_LOAD_TEST.md.
4. Talents: user is writing each job's list (Priest first); Shrine sells Reset Talents. New content on ASC: CONTENT_DEVELOPMENT.md has worked quest/boss/item examples.
5. Optional cleanup of shared temp variables: PHASE16.md.

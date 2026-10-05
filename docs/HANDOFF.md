# Handoff: where FF Epic RPG stands (2026-10-05, after Claude's stage Q)

Read this first, then docs/STAGES.md (one row per build) and docs/QUEST_ENGINE.md.

## Current map
- **Play / edit:** `release/FFERPG_0.9.7.3-r16-stageQ.w3x` (Reforged format, with the HM3W header so it is
  listed in 1.29.2 too). Copy also in Documents/Warcraft III/Maps/Download.
- Stage P was play-tested by the user and works. Stage Q = P + the Kalm Siege fix (below).
- Git: FFERPG repo on the user's PC (WarcraftMapExtractor/FFERPG) is the source of truth; commit there.
- **Sources** are `src/triggers/<folder>/<Module>.j` (CRLF, one vJass library per trigger), `src/map-header.j`,
  `src/trigger-list.json`. The playable script (war3map.j) is inside the map.

## How a change gets into the map (no World Editor needed)
```
python tools/sync_module.py BASE.w3x OUT1.w3x ModuleA ModuleB ...   # put changed modules into the map
python tools/order_libraries.py OUT1.w3x OUT2.w3x                   # libraries after the ones they call
python tools/check_map.py OUT2.w3x --baseline BASE.w3x [--allow-removed 'gg_trg_(X|Y)']   # all must PASS
python ../MapToolkit/tools/add_header.py OUT2.w3x release/NAME.w3x --from release/FFERPG_0.9.7.3-r16-stageN.w3x --name "Final Fantasy Epic RPG 0.9.7.3-r16 stageX (Reforged)"
```
- Base for the next change: the header-less map of the last stage (on Claude's side `build/base-R.w3x` = stage Q
  without header; on the PC you can use the stage Q release, or strip its first 512 bytes).
- New module: `tools/add_module.py`; module that became empty: `tools/remove_module.py` (then `git rm` its
  source and remove its `RegisterTriggers_X` call in MapBootstrap.j).
- World Editor Save As also works (JassHelper orders libraries itself); then re-export sources with
  `tools/export_sources.py`.
- 1.29.2 build: `MapToolkit/downgrade_129.bat` (drag the map on it). **Known issue (BUGS.md #7):** the
  1.29.2-format build shows game markers (Chemist blue glow, circle+line under Gaya) when played in Reforged.
  Play the Reforged build in Reforged.

## Quest engine (docs/QUEST_ENGINE.md)
- Module `06 Quests and story/QuestEngine.j`. A quest = Quest_Define + steps (Talk, Return, Kill, Hunt,
  Deliver, Reach, Custom) + dialogue (Quest_Say...) + rewards + hooks (Quest_OnDone "Function").
  Complex quests use Quest_Custom steps finished by the module's own triggers with Quest_StepDone.
- Hooks must not wait: use `TimerStart(CreateTimer(),secs,false,function X)`.
- **90 quests converted** (stages M, N, O, P). Play-test list with boxes: docs/QUEST_TESTS.md.
- **Not converted (3):**
  - Cartographer (Cartographer.j): log entry created before its dialogue, can complete inside its first talk,
    rewards computed over repeated reports (Reward_GiveAll), marker [82] shared with the Hunt Festival.
    Would need the engine to support "complete during step 1" and repeatable reward talks.
  - True Ice Age (TrueIceAge.j, MainQuest[20]): one log entry shared with MainQuest 8/9/11/19, entry created
    before the summon cinematic and announced ~15 s later. Would need an engine "create silently, announce later".
  - Ao Madoushi (MainQuest[4]; Cid, Quest_AoMadoushi, Turks, AoMadoushi, Cine): not examined yet; likely
    custom steps like the other main quests (see Quest_EyeOfJenova.j / Quest_DarkKnight.j for the pattern).
- Recipe for converting one: build/CONVERSION_BRIEF.md (rules: same dialogue word for word, same rewards and
  order, only the owned files, report external edits) - this file is on Claude's side; its content is
  summarised in QUEST_ENGINE.md "Converting an old quest".

## Stage Q fix
Kalm Siege I and II (KalmSiege1.j / KalmSiege2.j): the Complete trigger now disables itself after the
"cinematic busy" retry check, so it no longer re-gives the reward and "Quest Completed" each time the
siege timer runs out later.

## Other tools and docs
- Save codes: tools/savecode.py (decode, rename to a new account name incl. armory part) + web page
  tools/web/name-swap.html; docs/SAVE_CODES.md.
- docs/BUGS.md (open bugs), docs/NEXT_STEPS.md, docs/SYSTEMS.md, CONTRIBUTING.md (code style: comments on
  calculations only when non-trivial).

## Suggested next steps
1. Play-test stage Q with docs/QUEST_TESTS.md (tick boxes).
2. Convert Ao Madoushi; then decide whether Cartographer / True Ice Age are worth engine extensions.
3. Fix BUGS.md #7 for the 1.29.2 build (compare what Reforged does differently with a classic-format map).
4. Publish the repository (GitHub) if wanted.

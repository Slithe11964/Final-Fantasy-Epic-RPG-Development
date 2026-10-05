# Handoff: where FF Epic RPG stands (2026-10-05, after Codex stage R)

Read this first, then docs/STAGES.md (one row per build) and docs/QUEST_ENGINE.md.

## Current map
- **Play / edit:** `release/FFERPG_0.9.7.3-r16-stageR.w3x` (Reforged format, with the HM3W header so it is
  listed in 1.29.2 too). This build is in release/; it has not been copied to Documents/Warcraft III/Maps/Download.
- Stage P was play-tested by the user and works. Stage Q = P + the Kalm Siege fix (below).
- Stage R = Q + Ao Madoushi on the quest engine. All automated checks pass; gameplay testing is pending.
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
- Base for the next change: `release/FFERPG_0.9.7.3-r16-stageR.w3x` (the tools accept its header),
  or `build/stageR-ordered.w3x` from this build.
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
- **91 quests converted** (stages M, N, O, P, R). Play-test list with boxes: docs/QUEST_TESTS.md.
- **Not converted (2):**
  - Cartographer (Cartographer.j): log entry created before its dialogue, can complete inside its first talk,
    rewards computed over repeated reports (Reward_GiveAll), marker [82] shared with the Hunt Festival.
    Would need the engine to support "complete during step 1" and repeatable reward talks.
  - True Ice Age (TrueIceAge.j, MainQuest[20]): one log entry shared with MainQuest 8/9/11/19, entry created
    before the summon cinematic and announced ~15 s later. Would need an engine "create silently, announce later".
- Recipe for converting one: build/CONVERSION_BRIEF.md (rules: same dialogue word for word, same rewards and
  order, only the owned files, report external edits) - this file is on Claude's side; its content is
  summarised in QUEST_ENGINE.md "Converting an old quest".

## Stage R conversion
Ao Madoushi (MainQuest[4]) uses five custom steps: Cid's request, obtaining the flute, summoning the sage,
the first talk, and the later report if needed. If Hashmalum is already free at the first talk, that talk
finishes both remaining steps and starts Eye of Jenova. Otherwise the Stone-break cinematics update the
log and the report finishes the quest. The engine creates the log and handles normal completion/counting;
the existing triggers retain every dialogue line, reward, wait, marker and playing-player announcement.
No story-progress increment. True Ice Age's existing direct completion override remains as before (no
announcement or quest-count increment). No triggers were added or removed.

Changed modules: Quest_AoMadoushi, Cid, Turks, AoMadoushi, Cine. Built from Q with sync_module ->
order_libraries -> check_map (all PASS) -> add_header (stage N template). Results:
release/checks-r16-stageR.txt. Tests: docs/QUEST_TESTS.md, stage R section.

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
1. Play-test stage R with docs/QUEST_TESTS.md (tick boxes), especially both Ao Madoushi paths and both sieges.
2. Decide whether Cartographer / True Ice Age are worth engine extensions.
3. Fix BUGS.md #7 for the 1.29.2 build (compare what Reforged does differently with a classic-format map).
4. Publish the repository (GitHub) if wanted.

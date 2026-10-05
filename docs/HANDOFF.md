# Handoff: where FF Epic RPG stands (2026-10-05, after Codex stage W)

Read this first, then docs/STAGES.md (one row per build) and docs/QUEST_ENGINE.md.

## Current map
- **Play / edit:** `release/FFERPG_0.9.7.3-r16-stageW.w3x` (Reforged format, with the HM3W header so it is
  listed in 1.29.2 too). This build is in release/; it has not been copied to Documents/Warcraft III/Maps/Download.
- Stage P was play-tested by the user and works. Stage Q = P + the Kalm Siege fix (below).
- Stage R = Q + Ao Madoushi on the quest engine; the user reports it works great.
- Stage S = R + Cartographer and True Ice Age on the engine. **User reports S is working.**
- Stages T/U implement readiness priorities 2/3/4: repeatable builds, quest validation/inspection/tests,
  and content/save safeguards. U's playable script is byte-identical to S. Only embedded disabled
  developer-tool source and the outer map-list name changed; all checks and 35 tests pass.
- The user asked to ignore the documented bugs in the current map; no bug fixes were made.
- Git: FFERPG repo on the user's PC (WarcraftMapExtractor/FFERPG) is the source of truth; commit there.
- **Sources** are `src/triggers/<folder>/<Module>.j` (CRLF, one vJass library per trigger), `src/map-header.j`,
  `src/trigger-list.json`. The playable script (war3map.j) is inside the map.

## How a change gets into the map (no World Editor needed)
Preferred one-command workflow (details/limitations in **docs/BUILDS.md**):
```powershell
.\build.ps1 -Stage X -Base release/FFERPG_0.9.7.3-r16-stageW.w3x
```
It selects changed enabled modules, runs sync/order/check/header plus quest/content/save/source gates,
and saves a new map, report and hash/tool manifest. Existing outputs are refused. Default base without
`-Base` remains the SHA256-pinned, user-tested stage S. Maps/assets and sibling MapToolkit are required
in addition to a Git clone. Record every build in STAGES.md and update this handoff/resume checkpoint.

The underlying manual pipeline remains:
```
python tools/sync_module.py BASE.w3x OUT1.w3x ModuleA ModuleB ...   # put changed modules into the map
python tools/order_libraries.py OUT1.w3x OUT2.w3x                   # libraries after the ones they call
python tools/check_map.py OUT2.w3x --baseline BASE.w3x [--allow-removed 'gg_trg_(X|Y)']   # all must PASS
python ../MapToolkit/tools/add_header.py OUT2.w3x release/NAME.w3x --from release/FFERPG_0.9.7.3-r16-stageN.w3x --name "Final Fantasy Epic RPG 0.9.7.3-r16 stageX (Reforged)"
```
- Base for the next incremental change: `release/FFERPG_0.9.7.3-r16-stageW.w3x` (the tools accept its header).
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
- `tools/check_quests.py --map MAP --quest TEXT` inspects definitions; `--json` is machine-readable.
  DevCommands adds read-only `-queststate [engine number]` in a separately enabled single-player dev
  copy. DevCommands stays disabled in V. See DEBUG_COMMANDS.md and QUEST_ENGINE.md.
- **All 93 quests converted** (stages M, N, O, P, R, S). Play-test list: docs/QUEST_TESTS.md.
- Recipe for converting one: build/CONVERSION_BRIEF.md (rules: same dialogue word for word, same rewards and
  order, only the owned files, report external edits) - this file is on Claude's side; its content is
  summarised in QUEST_ENGINE.md "Converting an old quest".

## Stage S conversions and engine additions
Cartographer (SideQuest[61]) uses a silent custom start before its first conversation and an open custom
step for repeat reports. Its existing exploration scan, unpaid-tier calculations, Reward_Give versus
Reward_GiveAll, shared Hunt Festival marker and fog-reveal failure stay unchanged. It can complete at
90% exploration in the first talk with only the original completion message, or after repeat reports.
The engine completes its existing requirement after the log and before counting, preserving the order.

True Ice Age (MainQuest[20]) starts silently before the summon cinematic, with one shared log aliased
to slots 8/9/11/19. It announces at the original post-cinematic point. Echele retries leave the final
custom step active; victory completes/counts once. Both existing story-progress increments remain in
the module at their original times. Other interrupted quests retain their existing direct overrides.

New APIs: Quest_StartSilent, Quest_AnnounceStart, Quest_AliasMain, Quest_CompletionItem. Defaults for
existing quests are preserved. Changed modules: QuestEngine, Cartographer, TrueIceAge; no triggers
added/removed. Built from R with sync_module -> order_libraries -> check_map -> add_header (N template).
All checks PASS (1503 triggers, no startup reorder); seven focused tests run actual lifecycle/report
source with mocked Warcraft natives; preservation audit verifies all other actions unchanged.
Results: release/checks-r16-stageS.txt. Tests: docs/QUEST_TESTS.md, stage S section.

## Stages T/U development safeguards
One-command build: build.ps1 / tools/build_stage.py, with automatic module selection, all gates,
exclusive stage locks, no overwrite, failure logs and source/tool/native hashes. T was the first
verified build; U adds tracing of waits in nested expressions, valid buff/base resolution and save
item-base/count preservation. No enabled gameplay module changed.

Quest gates cover 97 definition variants for the 93 logical quests, 466 dialogue declarations, 16
steps/quest, classic array capacity, indexes, targets/rawcodes, requires and non-waiting hooks. Tests
execute actual talk/kill/partial-deliver event code and failure cleanup with mocked Warcraft natives.
The dev inspector also reports log completion/failure separately from engine state, exposing existing
direct interruption overrides without altering them. All editor source, including DevCommands, compiles.

Save/content gates preserve 351 item indexes/charges/base/classes, 22 job entries, existing serializer
functions and armory mappings, and reject new duplicate/missing literal references. Three fixed G/H
vectors are synthetic, not real player codes; H armory data is opaque checksum/link test data. Exact
historical source/runtime differences and unresolved stock calls are frozen in reviewed contracts,
never auto-refreshed. Limits are documented in BUILDS.md and SAVE_CODES.md.

U: release/checks-r16-stageU.txt, build-r16-stageU.json, preservation-r16-stageU.json. All checks pass,
35 tests pass, 2,000 randomized codec cases pass. An isolated enabled-module sync smoke build also
passes all gates (release/smoke-r16-stageU.json); existing-release refusal is verified.
Playable-script SHA256 is unchanged from S:
5f47e53413d1133d66da5cd6804f445c43a970460d5c65c96ed7b9900c585780. Of 521 listed files, only
war3map.wct changed since S; T/U archives are identical. U map SHA256:
93a5ffa58996aacbb0a244e85c1cae63bfefda2441d4b01b6b61cca6e4f04d7d.

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
1. Play-test stage V using QUEST_TESTS.md; use CONTENT_DEVELOPMENT.md for new content.
2. Package the identified base map/assets/tools for another developer (NEXT_STEPS.md #8).
3. Capture real player G/H codes and test World Editor/save-load/multiplayer when adding new content.
4. Continue shared temporary-state cleanup one subsystem at a time; documented bugs are deferred.

## Stage V: readiness priorities 6/7

Focused shared-context cleanup in six functions, two modules: TrueIceAge owns its selected
summoner, nearby-hero group and drop location across waits/callbacks; its group helper takes
explicit context. Cartographer owns scan player/location and report reward accumulator;
its exploration helper takes explicit parameters. Cleanup/native calls remain in the same
order. No dialogue, reward, world/story effect, object data or trigger registration changed.
Other cross-module handoffs (including SpawnBrave, arena, jobs and title/victory paths)
remain for separate reviewed passes. The refreshed PHASE16 snapshot has 1,431 retained pairs;
the conservative analyzer finds none suitable for automatic conversion.

Built from U via build.ps1: sync TrueIceAge/Cartographer -> order -> all checks -> header.
All gates, 38 tests and 2,000 codec cases pass; 1503 triggers, no startup reorder. An explicit
reversal audit verifies all 10,971 playable functions match U after undoing only the declared
local/parameter changes. All listed archive files except war3map.j/war3map.wct are unchanged.
Proof: release/preservation-r16-stageV.txt; report/manifest: checks-r16-stageV.txt/build-r16-stageV.json.
Map SHA256: a4b851237bf735a71dd3198bdb6f3bcc9c07ff5ecb528e0b6b7a73c2f4ac5b65.
Stage V still needs the focused in-game test in QUEST_TESTS.md; S remains the user-tested baseline.

CONTENT_DEVELOPMENT.md gives worked quest/boss/item/reward examples and integration/test steps;
no example content was added. TRIGGER_INDEX/GLOBALS/DEAD_CODE and phase16-handoffs.csv are refreshed.
LIBRARY_DEPENDENCIES.md lists 731 declared editor libraries, regenerated with gen_dependencies.py.

## Stage W: World Editor source pairing repair

User's enabled QuestEngine displayed TWave, and Save As reported missing TQuestEngine.
QuestEngine was appended to physical WTG/WCT storage instead of its folder position.
World Editor traverses the folders when pairing source; 118 entries shifted, and the
actual engine appeared under disabled DevCommands. Prior compilation checks flattened
the complete source list and missed this association error. Do not use V or earlier
post-engine maps as World Editor editing bases; use W. Existing playable scripts still work.

W canonicalizes WTG/WCT together into folder order, preserving each trigger's properties,
GUI actions and associated source bytes. It also carries the user's existing Intro.j text
edits verbatim (new welcome/tips/patch notes/credits); that one action is the only changed
playable function. No quest dialogue, rewards, objects, save formats or startup order changed.
734 editor entries, 1503 runtime triggers; DevCommands remains disabled. check_map now rejects
wrong folder/source order or mismatched InitTrig ownership. Builds normalize layout before
ordering/checking; add_module does the same. Name-based syncing accepts historical base layouts.

All gates, 41 tests and 2,000 codec cases PASS. Isolated actual add_module smoke PASS.
Proof: release/preservation-r16-stageW.json; checks/manifest: checks-r16-stageW.txt/build-r16-stageW.json.
Needs user confirmation: reopen W, QuestEngine starts library TQuestEngine, then Save As
with JassHelper/vJass enabled. The user's TEST editor copy has not been overwritten; preserve
any unsaved GUI edits and transfer them after confirming the repaired map saves.

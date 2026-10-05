# FF Epic RPG: readying the map for new development

Updated 2026-10-05, stage U. Current release: release/FFERPG_0.9.7.3-r16-stageU.w3x.
The user reports stage S is working. All 93 quests are on QuestEngine. Priorities **2, 3 and 4 below
are implemented** in stages T/U; BUILDS.md describes the new workflow and its limits. U's playable
script is byte-identical to S. Read HANDOFF.md for the exact build and STAGES.md for history.
The user asked to ignore the documented bugs in the current map; bug work is deferred.

## Recommended order

1. **Tested development baseline established.** Stage S is user-confirmed working and SHA256-pinned
   in build-config.json. Future gameplay changes still need their focused checklist, including save/load
   and multiplayer where relevant. A future World Editor Save As needs its own checks/play test.

2. **Done: repeatable one-command builds.** build.ps1 selects changed modules, runs sync/order/all
   checks/header, refuses existing output, and records map/source/tool hashes and runtime/compiler
   identities. Full enabled-function drift checks preserve exact historical hash pairs while rejecting
   new differences. Fresh clones still need the identified map/assets and sibling header tool.

3. **Done: quest-definition checks and inspection.** check_quests.py validates capacities, indexes,
   targets, requires and synchronous waits, including nested expressions/callbacks. The harness now
   exercises ordinary talk/kill/partial-deliver flows and failure cleanup. Disabled DevCommands includes
   read-only -queststate inspection, displaying engine state and legacy log overrides separately.
   Unusual dynamic hooks and branching/shared-log behavior still deserve content-specific review.

4. **Done: save/content guards.** Append-only item indexes <=500, charge/base/class preservation,
   save-count agreement, job order, serializers and armory mappings are guarded. Typed literal
   references and duplicate object IDs are checked. Three synthetic fixed G/H vectors and 2,000 random
   cases protect codec behavior; capture real player codes before changing formats/progression.

5. **Deferred by user request: documented bugs.** If revisited later, reproduce Greed's high-level item lookup,
   arena team-selection recursion, repeatable arena-boss death triggers, and duplicated arena reward
   logic. BUGS.md records suspected issues; reproduce each before changing behavior. Investigate the
   1.29.2-format marker issue only if that release target is needed; the active build is Reforged.

6. **Reduce shared temporary-variable handoffs where they are risky.** docs/PHASE16.md and
   phase16-handoffs.csv identify remaining cases. Start with functions that wait, nested callbacks and
   frequently fired combat/arena paths. Use locals or explicit context where appropriate, one system
   at a time, with behavior comparison and focused tests. Splitting large data tables has lower value.

7. **Write a small content-development guide.** Give one worked example each for a new quest, boss,
   item and reward: source module, object IDs, prerequisites, registration, build and test. Explain when
   custom quest steps are appropriate and why hooks must not wait. Refresh stale reference docs and
   the module dependency index as content changes; keep HANDOFF.md/STAGES.md current.

8. **Package the project for another developer.** Supply tested maps through release artifacts,
   retain source history/backups, and document where baseline/assets/tool versions come from. Publish
   the repository if wanted. Automated release checks can then run whenever source changes are proposed.

## Tools already available

- tools/check_map.py: compile, startup wiring/order, globals and native-save string checks.
- build.ps1 / tools/build_stage.py: complete build/gate/header pipeline with manifests.
- tools/check_sources.py, check_editor_sources.py, check_quests.py, check_content.py, check_save_compat.py:
  read-only development safeguards; limits in BUILDS.md.
- tools/tests/run_tests.py: 35 regression tests (10 lifecycle/event tests execute actual quest source
  with mocked Warcraft natives, plus inspector and build/quest/content/save guard tests).
- tools/tests/verify_stage_s.py: stage S conversion preservation audit against stage R commit 800ed48.
- tools/disable_check.py: module dependency/disabling audit.
- tools/gen_docs.py: regenerate source reference docs.
- tools/savecode.py and docs/SAVE_CODES.md: save-code inspection and compatibility details.
- tools/objects.py, tools/objdata.py and docs/OBJECTS.md: object data/reference tools.

Remaining work is mainly #7 (worked content examples) and #8 (developer packaging), with #6 as a
separate optional cleanup effort. No gameplay or bug fixes were made in stages T/U.

# FF Epic RPG: readying the map for new development

Updated 2026-10-05, stage S. Current release: release/FFERPG_0.9.7.3-r16-stageS.w3x.
The user reports stage R works great. All 93 quests are on QuestEngine. Stage S passes automated checks;
gameplay validation is pending. Read HANDOFF.md for the exact build and STAGES.md for history.

## Recommended order

1. **Establish a tested development baseline.** Play the stage S checklist in QUEST_TESTS.md, including
   both new quests, retries/failure, cinematics on/off, multiplayer and native save/load. Save As through
   World Editor with JassHelper/vJass enabled, check that saved map, then test it. Preserve the confirmed
   map and its hash; editor compilation alone is not gameplay proof.

2. **Make builds repeatable with one command.** Wrap sync_module -> order_libraries -> check_map ->
   add_header in a build command that stops on any failure, creates a new stage, and saves hashes/check
   results. Record the Python/pjass/JassHelper versions and the required base map. Maps are ignored by
   Git, so a fresh clone also needs an identified base archive and its assets. Add a source/runtime drift
   check for all module bodies; the present check_map agreement checks focus on startup and globals.

3. **Add quest-definition checks and better test tools.** Validate per-quest step limits, array capacity,
   quest indexes, missing NPC/item references, dependency requirements, and hooks that wait. Extend the
   lifecycle harness to ordinary talk/kill/deliver flows and engine failure cleanup. Add development-only
   quest-state inspection. Audit direct interrupted-quest overrides and shared log replacement before
   introducing new branching story content; their original counting behavior was preserved here.

4. **Protect save-code and content tables.** Add automated guards for the documented item-index/armory
   collision above index 500 (BUGS #6), duplicate object IDs and missing item/unit/ability references.
   Keep known save codes as compatibility fixtures when extending jobs, items, armory or progression.

5. **Confirm and fix the documented bugs separately.** Prioritize Greed's high-level item lookup,
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
- tools/tests/test_quest_lifecycle.py: seven source-level lifecycle/report tests (mocked Warcraft natives).
- tools/tests/verify_stage_s.py: stage S conversion preservation audit against stage R commit 800ed48.
- tools/disable_check.py: module dependency/disabling audit.
- tools/gen_docs.py: regenerate source reference docs.
- tools/savecode.py and docs/SAVE_CODES.md: save-code inspection and compatibility details.
- tools/objects.py, tools/objdata.py and docs/OBJECTS.md: object data/reference tools.

These are priorities for subsequent work, not additional gameplay changes made in stage S.

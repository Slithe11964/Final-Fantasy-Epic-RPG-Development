# FF Epic RPG: what's left before handing the map to a new developer

Current maps:

- Reforged: `release/FFERPG_0.9.7.3-r16-stageK.w3x` (r15 + developer commands + phase 16 tidy-up).
- 1.29.2: `release/FFERPG_0.9.7.3-r16-stageK-1.29.2.w3x` (build with `downgrade.py --fill-from`, see LEGACY_129.md).
- Baseline: your r14 editor save.

**What each stage changed, and what still needs testing: `docs/STAGES.md`.** Read `README.md` first.

## Quick wins (small, low risk)
1. ~~**Release naming.**~~ Done: the map name and loading-screen title say `0.9.7.3-r15`. Once r15 passes its play test, tag it in Git (`git tag r15`) and make it the new baseline.
2. ~~**Archive the old tooling.**~~ Done: experiment outputs are in `../_archive/2026-10-02_handoff/`. `../Builder24/` keeps only the extractor app's code, tools (pjass, JassHelper) and notes. The reusable tools are in `../MapToolkit/`.
3. ~~**`CONTRIBUTING.md`.**~~ Done (repo root).
4. **Publish the repo** (GitHub, private or public) so other people can get it. Share maps through GitHub Releases rather than Git.

## Medium (worth doing next)
5. ~~**Variable Editor.**~~ Done: 576 shared variables are in the Variable Editor ("Shared variables" folder, one sub-folder per code folder). 356 stay in the map header (groups, timers, forces, hashtables, string arrays, variables with a starting value).
6. ~~**Document the gameplay systems.**~~ Done: `docs/SAVE_CODES.md`, `JOBS.md`, `SPAWNS.md`, `LOOT.md`, `BOSSES.md`, `ARENA.md`. Next candidates: quests (`Quest_*` chains), Chocobos, Gaya.
7. **Wider play test.** Checklist: `docs/PHASE8_TEST_CHECKLIST.md` (damage, jobs, late-game bosses, arena, Chocobo breeding).
8. ~~**Rename `Hero_Part01` and `Player_Part01`.**~~ Done: now `Hero_Skills` and `Player_Hero` (`tools/rename_module.py`).

## Large (optional projects)
9. **Data-driven quest framework.** Quests are currently chains of triggers turning each other on. Prototype one quest first.
10. **Legacy 1.29 version.** Study done: `docs/LEGACY_129.md`. The code already works with 1.29.2. The world and object files need a converter (a `downgrade.py` in MapToolkit), which can only be built and proven with a 1.29.2 install to test in.
11. **Split giant functions.** `Trig_Damage_Engine_CalcDamage` is done: 19 step functions with a per-hit context stack (`DmgCtx_*`), so nested hits stay safe. Left: `MonsterData_Init_*` and `Bazaar` (data tables; splitting them gains little).

12. **Done in the long run (stages A–G):**
    - suspected bugs list (`BUGS.md`);
    - developer test commands (`DEBUG_COMMANDS.md`);
    - save code reader/writer (`tools/savecode.py`);
    - object reference (`OBJECTS.md`);
    - first 1.29.2 map (`LEGACY_129.md`);
    - quest map (`QUESTS.md`);
    - guides: Chocobos, Gaya, Summons/Shadows, Crafting, Hunts.
13. **Next:**
    - play-test results for stages B/C/E;
    - confirm or fix the items in `BUGS.md`;
    - ~~phase 16 code tidy-up~~ first pass done (stage K, `docs/PHASE16.md`): 509 functions use locals now;
      the 1,452 real hand-offs left are listed in `docs/phase16-handoffs.csv` for module-by-module work;
    - check a real save code with `savecode.py` (needs `itemtable.txt` from `-dumpitems` for items);
    - `savecode.py rename` moves a code to a new account name (done, stage K).
14. **Reusable toolkit.** `../MapToolkit` runs deprotect → split → document on other protected JASS maps (tested on one). Ideas: carry module variables into the modules automatically, and support Reforged-format output.

## How to resume with Claude or ChatGPT
Point the assistant at `README.md`, `docs/READABILITY_GAMEPLAN.md` and this file. Tools:
- `tools/check_map.py` runs all the automated checks.
- `tools/disable_check.py` checks whether a module can be switched off.
- `tools/gen_docs.py` regenerates the reference docs.
- `tools/refactor/*.py` holds the scripts behind each past change.

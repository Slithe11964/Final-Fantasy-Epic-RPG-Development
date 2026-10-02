# FF Epic RPG: what's left before handing the map to a new developer

Current map: `release/FFERPG_0.9.7.3-r15.w3x` (baseline: your r14 editor save). Read `README.md` first.

## Quick wins (small, low risk)
1. **Make a release folder.**
   - r14 (your editor save) is now the baseline. Once r15test passes its play test, copy it to `release/` as the next numbered version.
   - Update the map name in Map Properties. It still says `0.9.7.3-r11`.
   - Tag it in Git (`git tag r15`).
2. **Archive the old tooling.** Move `../Builder24/`, `../CONTINUE_PROJECT.md` and `../RESUME_PROMPT.txt` into an `archive/` folder. A new developer then only sees `FFERPG/`.
3. **Add a `CONTRIBUTING.md`:** the editor settings (JassHelper + vJass on), save -> `check_map.py` -> play -> `export_sources.py` -> commit, and the naming conventions (`Register_X`, `RegisterTriggers_X`, module `globals` blocks).
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

12. **Reusable toolkit.** `../MapToolkit` runs deprotect → split → document on other protected JASS maps (tested on one). Ideas: carry module variables into the modules automatically, and support Reforged-format output.

## How to resume with Claude or ChatGPT
Point the assistant at `README.md`, `docs/READABILITY_GAMEPLAN.md` and this file. Tools:
- `tools/check_map.py` runs all the automated checks.
- `tools/disable_check.py` checks whether a module can be switched off.
- `tools/gen_docs.py` regenerates the reference docs.
- `tools/refactor/*.py` holds the scripts behind each past change.

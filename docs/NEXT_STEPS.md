# FF Epic RPG: what's left before handing the map to a new developer

Current map: `release/FFERPG_0.9.7.3-r13-cleanup.w3x`. Read `README.md` first.

## Quick wins (small, low risk)
1. **Make a release folder.**
   - Copy the tested cleanup map to `release/FFERPG_0.9.7.3-r14.w3x`.
   - Update the map name in Map Properties. It still says `0.9.7.3-r11`.
   - Tag it in Git (`git tag r14`).
2. **Archive the old tooling.** Move `../Builder24/`, `../CONTINUE_PROJECT.md` and `../RESUME_PROMPT.txt` into an `archive/` folder. A new developer then only sees `FFERPG/`.
3. **Add a `CONTRIBUTING.md`:** the editor settings (JassHelper + vJass on), save -> `check_map.py` -> play -> `export_sources.py` -> commit, and the naming conventions (`Register_X`, `RegisterTriggers_X`, module `globals` blocks).
4. **Publish the repo** (GitHub, private or public) so other people can get it. Share maps through GitHub Releases rather than Git.

## Medium (worth doing next)
5. **Variable Editor.** All 932 shared `udg_` variables are declared in code. Moving the ones GUI users need into the Variable Editor would let non-coders use them in GUI triggers.
6. **Document the gameplay systems a new dev touches first.** Use the ffepic wiki for intent. Cover save codes (`Save`/`Load`/`Code`), the job system (`Job`, `Shrine`), and spawns (`Spawn`, `MonsterData`).
7. **Wider play test.** So far there's been one multiplayer run plus targeted checks. Do a full playthrough including the late-game bosses, the arena and Chocobo breeding.
8. **Rename `Hero_Part01` and `Player_Part01`.** These are leftover split names. Renaming means editing both the trigger tree and the library names; the tools in `tools/` can do it.

## Large (optional projects)
9. **Data-driven quest framework.** Quests are currently chains of triggers turning each other on. Prototype one quest first.
10. **Legacy 1.29 compatibility study.** The map format, `Blz*` natives and object data all differ from Reforged.
11. **Split giant functions.** `Trig_Damage_Engine_CalcDamage` is commented step by step now. Split it only with care, because it calls itself recursively.

## How to resume with Claude or ChatGPT
Point the assistant at `README.md`, `docs/READABILITY_GAMEPLAN.md` and this file. Tools:
- `tools/check_map.py` runs all the automated checks.
- `tools/disable_check.py` checks whether a module can be switched off.
- `tools/gen_docs.py` regenerates the reference docs.
- `tools/refactor/*.py` holds the scripts behind each past change.

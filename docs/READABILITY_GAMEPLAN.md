# FF Epic RPG — Readability Gameplan (r12test → developer-ready)

Written 2026-10-02 (Claude). Baseline: `FFERPG_0.9.7.3-r12test.w3x`.

## Status (updated 2026-10-02)

| Phase | Status | Result |
|---|---|---|
| 0 | Done | New `FFERPG/` developer folder: Git history (baseline → phase 1 → phase 2), `src/` export, tools (`check_map`, `startup_audit`, `export_sources`, `build_map`), docs. The 10 leftover experiment folders on the cleanup list were moved to `_archive/`. |
| 1 | Done | 1,607 generated functions re-indented; 8 noise comments removed. Code tokens unchanged; map `r13-phase1` has a byte-identical playable script. |
| 2 | Done, user-tested | main_old is now 11 named steps. 1,613 string dispatches became 571 `RegisterTriggers_*` group calls. 1,602 helpers renamed `Register_<Trigger>`, guards removed. The startup audit proves the same statements run and event firing order is kept. Map: `r13-phase2`. |
| 3 | Done, awaiting play test | 1,581 trigger variables + 422 single-module variables moved into their modules' globals blocks; 932 shared variables grouped by folder in the map header with "used by" notes. Map `r13-phase3`. |
| 4 | Done, awaiting play test | 480 registration helpers moved next to their trigger code; RegisterTriggers calls annotated (starts off / enabled-disabled-run by); legacy spells registered by their modules; generic locals renamed; CalcDamage documented step by step; developer guide in the map header; docs/SYSTEMS.md, TRIGGER_INDEX.md, GLOBALS.md, DEAD_CODE.md. Giant functions were deliberately not split (CalcDamage runs nested; MonsterData/Bazaar are data tables). The only generic names (`_FuncNNN`) were in dead code. Map `r13-phase4`. |
| 5–6 | Not started | After the phase 3–4 test round. |

## 0. What r12test is

- SHA256 `7583754261997a20dbb01bf844a4b20c189076be1fe79c79858f37114706d6a1`, the same file as `Builder24/NeutralOwnership-fix01/FFERPG_SAVE_SAFE.w3x`.
- Its editor source (war3map.wct) has 739 custom-text modules. Every one of them matches `Builder24/StartupFinalSources-test01/*.j` exactly (newline-normalized), so **StartupFinalSources-test01 is the editable source of this map**.
- The user tested it in Reforged: three-player multiplayer, the main questline and most quests through Ice Age. This is the **golden baseline**. Every step below must keep its gameplay unchanged.

## 1. r12test vs r11: measured comparison

Both were measured from their own WCT/custom-script headers. r11 comes from `Builder24/R11Review/`.

| Metric | r11 (author) | r12test (ours) |
|---|---:|---:|
| Editor trigger entries holding code | 1,695 (one per gameplay trigger) | 739 modules (several triggers each) |
| Folders | 22 | 10 |
| Functions | 9,866 | 10,558 |
| Comment lines | 0 | 5,903 (+9,213 object-name annotations) |
| Auto "Calculation N:" formula comments | 0 | 379 (8 in main_old, the rest explain gameplay formulas) |
| `main_old` size (non-blank lines) | 3,735 | 3,735 (same) |
| `ExecuteFunc("…")` startup dispatches | 1,613 | 1,613 (same) |
| InitTrig functions | 1,695 (93 empty) | 739 (**all empty**) |
| Registration helpers | inside InitTrig_X | 1,602 `RegisterR11_*` |
| `udg_InitTrigFromMain` guards | 1,602 | 1,602 |
| Hand-declared `gg_trg_` trigger globals in header | 0 (World Editor generates them) | 1,581 |
| `udg_` globals in the one custom-script header | 1,230 | 1,230 |
| vJass libraries / `requires` | 0 / 0 | 739 / 512 |
| Functions with GUI-converted names (`Trig_X_Actions`) | 7,923 | 7,923 |
| Functions over 100 / 300 lines | 97 / 18 | 99 / 19 |
| Double-spaced, unindented functions | ~0 | 1,607 (all RegisterR11 helpers, main_old, 4 Units setup) |

The gameplay logic matches (see GAMEPLAY_AUDIT.md: 8,112 of 8,171 original functions are identical and the rest are explained). The two maps differ in **how the code is packaged**, not in what it does:

- **r11 follows the World Editor's own convention**: one trigger per editor entry, and World Editor generates its `gg_trg_` variable. A developer who knows WE can find "Agrias ShowMarker" in the trigger list.
- **r12 adds documentation r11 lacks**: object names, formula explanations, subject folders, library dependencies. But it also adds machine scaffolding a newcomer has to decode: `RegisterR11_*` names, 739 empty InitTrig stubs, 1,581 hand-declared trigger globals, and double-spaced generated code.
- **Neither has fixed the central problem.** Startup is a 3,735-line `main_old` that calls registrations by string name, 1,613 times. A developer can't tell from reading a module when or whether its triggers get created. Disabling a trigger in WE can break the map.

## 2. Biggest obstacles for a new developer, in priority order

1. **The startup is hidden.** 1,613 string-name `ExecuteFunc` calls in main_old, plus 825 `SetPlayerTechResearched` lines, sounds and preloads inline. In 88 modules the registrations are interleaved with other modules' registrations, so moving them requires care: triggers that share an event fire in the order they were registered.
2. **Hidden build step.** After any editor save, Build Play Copy has to run, or native save/load crashes on long quest-log text. A newcomer won't know this.
3. **Global state lives in one 2,945-line header.** 358 `udg_` globals are used by only one module, so they could move into that module. 186 are shared by more than 5 modules.
4. **Generated noise:** double spacing, a few pointless "Calculation N" comments in main_old, empty InitTrig stubs, and names that describe our migration history (`RegisterR11_`, `Part01`) rather than gameplay.
5. **Cross-module trigger chains.** 775 of 1,602 trigger handles are enabled, disabled or run from other modules. The quest flow is mostly trigger chains, and these need documenting.
6. **Workspace sprawl.** ~50 Builder24 experiment folders, a 374 KB Program.cs, and no Git. A new developer can't tell which files matter.

## 3. Gameplan

Each phase ends with the same gate: (a) automated checks pass (compile, the registration order/count audit `audit_gameplay_baseline.py`, function-body equivalence against r12test), (b) Build Play Copy, (c) a short smoke play (multiplayer start, a quest turn-in, a teleport camera, a Chocobo, damage text, a native save/load). Phases are ordered so the riskiest work lands on a cleaner codebase, and each phase is one reviewable batch.

### Phase 0 — Freeze and make the project navigable (no map changes)
- Tag r12test as `baseline-r12` and keep a copy under `Release/baseline/`.
- Put the module sources (`StartupFinalSources-test01`) and the tools in a **Git repository**. Every later phase becomes a readable diff.
- Create one clean layout: `src/` (modules + header), `tools/` (Build Play Copy, audits, pjass), `release/`, `docs/`. Move Builder24 experiments to `_archive/`. Nothing gets deleted; the cleanup manifest is respected.
- Turn the existing audit scripts into one command, `check_baseline`, that compares any new map against r12test.

### Phase 1 — Mechanical cleanup (compiled script token-identical)
- Re-indent and remove double spacing in the 1,602 registration helpers, main_old, and the 4 Units setup functions.
- Remove the 8 camera-bounds "Calculation N" comments in main_old. The other 371 explain gameplay formulas and stay.
- Replace the stub comment "Registration ownership; called at the original bootstrap positions" with an accurate one-line note. The stubs themselves must stay because WE calls them.
- Proof: the compiled runtime is token-identical to the previous one. A smoke test is optional.

### Phase 2 — Make startup readable (main: 3,735 → about 100 lines)
- Extract the inline world setup from main_old into named functions in `02 Map setup`: tech/upgrade rules (825 lines, likely tables or loops), sounds, preloads, music.
- Replace the 1,613 `ExecuteFunc("RegisterR11_…")` strings with **direct calls to one `<Module>_Register()` per module**, in the original order. For the 88 interleaved modules, first run an event-collision analysis: only triggers sharing the same event kind need to keep their relative order. Interleaving is kept only where that analysis requires it.
- Rename `RegisterR11_<Module>_<Trigger>` → `Register_<Trigger>`, then drop the 1,602 `udg_InitTrigFromMain` guards once nothing else calls those functions.
- Result: main reads like a table of contents, e.g. "setup world → load shared systems → register Jobs → register Quests …".
- **This phase changes runtime structure and needs a full multiplayer test pass.**

### Phase 3 — Each module owns its state
- Move the 358 single-module `udg_` globals into a `globals … endglobals` block inside their library. Make them `private` where nothing else needs them.
- Move each module's hand-declared `gg_trg_` handles into the owning library.
- Group the remaining shared globals into a few documented "state" libraries (Player state, Cinematics, Temp values, Quest flags) instead of one undifferentiated header.
- Proof: compile, then audit that every global is declared exactly once and keeps its initial value.

### Phase 4 — Explain the systems (documentation, small targeted renames)
- Add a header comment to each of the ten folders and each module: what the system does, its entry points, which globals it owns, and which other modules' triggers it enables or disables. The 775 cross-module trigger links can be generated automatically.
- Rename the generic GUI names only in the core systems a developer touches first: Damage engine, Save/Load codes, Jobs, Items/Shops, Spawns, the Quest framework. Leave the 7,000+ `Trig_X_Actions` names elsewhere; they're still WE-recognizable.
- Split the giant functions into named steps: `Damage_Engine_CalcDamage` (1,106 lines) and `MonsterData_Init_3_Actions` (616 lines).
- Write `docs/DEVELOPER_GUIDE.md`: how to open and save safely (JassHelper/vJass on), how to add a quest, item, spell or job, how startup works, and how to build and test.

### Phase 5 — Remove the hidden build step
- Find a way to keep long quest-log text native-save-safe without post-processing. Candidates: WTS-backed strings that WE preserves, or storing the text in object-editor tooltips.
- If none works, keep Build Play Copy but make it hard to miss: a top-level `BUILD.bat`, and a WE trigger comment in Map setup explaining the step.

### Phase 6 — Later and optional
- Make individual triggers safe to disable (needs the Phase 2/3 ownership first).
- Look at Legacy 1.29 compatibility (deferred by the user).
- Replace the trigger-chain quest flow with a data-driven quest framework (a large redesign, only if it's wanted).

## 4. Guardrails (carried over from CONTINUE_PROJECT.md)
- Keep the ten folders, the comments, MainDeprotected and the disabled PreplacedUnitRefs entry, plus the long-text native-save fix and the corrected neutral placement data.
- Keep JassHelper and vJass enabled. Never package compiler-harness output. Never overwrite r12test or user-saved maps.
- Do one phase per batch, verify it, then hand off for a play test. Don't refactor speculatively in between.

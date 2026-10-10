<!-- NEWEST CHECKPOINT (Claude, 2026-10-05) -->
# NEWEST CHECKPOINT - Claude: quest engine done for 90 quests, stage Q (2026-10-05)
Read FFERPG/docs/HANDOFF.md first (current map, build commands, quest engine, what is left), then
FFERPG/docs/STAGES.md (stages K..Q) and FFERPG/docs/QUEST_ENGINE.md.
- Current map: FFERPG/release/FFERPG_0.9.7.3-r16-stageQ.w3x (Reforged; play it in Reforged and 1.29.2).
  Stage P was play-tested by the user and works; Q adds the Kalm Siege I/II repeat-reward fix.
- 90 quests run on the quest engine (QuestEngine.j). Not converted: Cartographer, True Ice Age, Ao Madoushi
  (reasons in HANDOFF.md). Play-test list: FFERPG/docs/QUEST_TESTS.md.
- Change workflow without World Editor: sync_module.py -> order_libraries.py -> check_map.py -> add_header.py.
- Open bug: BUGS.md #7 (1.29.2-format build shows game markers in Reforged).
- The user works with both Claude and ChatGPT; keep docs/HANDOFF.md and this checkpoint current.
<!-- END NEWEST CHECKPOINT -->

<!-- RUN CHECKPOINT START -->
# RUN CHECKPOINT (newest; updated after every stage of the long autonomous run, 2026-10-02)
The user asked for as many of phases 10–17 as possible, each saved as a separate stage.
Stage log with commit, map and status: FFERPG/docs/STAGES.md (read it first).
Done so far:
- A: docs/BUGS.md
- B: DevCommands module (test commands), map release/FFERPG_0.9.7.3-r16-stageB.w3x
- C: tools/savecode.py (save code reader/writer, selftest OK), -dumpitems dev command, tools/sync_module.py.
  Map release/FFERPG_0.9.7.3-r16-stageC.w3x (newest Reforged map, also in TEST)
- D: tools/objects.py + objdata.py -> docs/OBJECTS.md, docs/objects/ (docs only)
- E: MapToolkit/tools/downgrade.py; first 1.29.2 map release/FFERPG_0.9.7.3-r16-stageE-1.29.2.w3x (also in TEST).
  Converters checked against r7 (terrain byte-identical, doodads 12036/12043 identical). Includes classic trigger editor, regions, cameras.
- F: tools/quest_map.py -> docs/QUESTS.md + docs/quest-graph.mmd (docs only)
- G: docs/CHOCOBOS.md, GAYA.md, SUMMONS_AND_SHADOWS.md, CRAFTING.md, HUNTS.md (docs only)
Next ideas (not started): phase 16 code tidy-up (behaviour-preserving, module by module), toolkit on more maps.
Pending user tests: r15 checklist; stages B/C (-dev, -dumpitems, savecode.py decode); stage E in 1.29.2 (docs/LEGACY_129.md).
<!-- RUN CHECKPOINT END -->

# NEWEST CHECKPOINT — Claude: Phase 9 hand-off + MapToolkit + 1.29 study (2026-10-02)

Read WarcraftMapExtractor/README.md first (new): it says what each folder is.
- Map: FFERPG/release/FFERPG_0.9.7.3-r15.w3x (copy in TEST). It replaces r15test; the only extra changes are the
  map name/loading title (0.9.7.3-r15) and 9 sub-folders in "Shared variables". All 7 check_map checks pass vs r14.
  Git HEAD ba47da7.
- PENDING (user): World Editor Save As of r15 and the play test in FFERPG/docs/PHASE8_TEST_CHECKLIST.md.
- New FFERPG docs: CONTRIBUTING.md, docs/LOOT.md, BOSSES.md, ARENA.md, LEGACY_129.md.
- 1.29 study (docs/LEGACY_129.md): the map's own code compiles against 1.29.2 (but not 1.29.0). Only World Editor-generated
  code uses newer natives. Blocker: every world/object file is in Reforged format (w3i 39, w3e 12, doo 13,
  objects v3, wtg/wct Reforged). r7 world/object files are classic, except w3i v31. Next: a downgrade.py converter,
  which needs a 1.29.2 install to test.
- Archive: unused Builder24 folders, old sources and test maps, logs/bin/obj, old releases ->
  _archive/2026-10-02_handoff/ (nothing deleted). Builder24 keeps the app's C# files, Python step scripts, notes,
  tools/ (pjass, JassHelper, CASC), reference-libraries/ (jassdoc libs with @patch tags) and ObjectReferenceData/.
- New MapToolkit/ (own Git repo): deprotect.py -> split_modules.py -> format_modules.py -> export_sources.py ->
  document.py; checked by check_editable.py; compat_report.py + version_libs.py give per-patch API checks.
  pipeline.py runs everything. Tested end to end on the protected map HVH Reloaded 1.7: all 1012 functions unchanged
  and it compiles for 1.29.2/1.31.1/Reforged. That map contains an injected -cheats backdoor.
  PLAYBOOK.md describes the whole process and FF Epic RPG's history.

# NEWEST CHECKPOINT — Claude: Phase 8 developer hand-off (2026-10-02)

New baseline: the user's r14 editor save, FFERPG/baseline/FFERPG_0.9.7.3-r14.w3x
(SHA256 9d84d734ed04854a5ab0a9010d00e49f4cfdd9ae24cac18e1dd83a12b6a735f2; also TEST/FFERPG_0.9.7.3-r14.w3x).
Test map: FFERPG/release/FFERPG_0.9.7.3-r15test.w3x (copy in TEST). Git HEAD c327a1f.
- Renamed Hero_Part01 -> Hero_Skills and Player_Part01 -> Player_Hero (tools/rename_module.py).
- Trig_Damage_Engine_CalcDamage split into 19 step functions, Trig_Damage_Engine_StepNN_*. Per-hit values live in
  DmgCtx_* arrays with a slot per nested call (DmgCtx_Depth). Step04_Cover returns true to end the hit early.
  Step bodies verified token-identical to the original (tools/refactor/phase8_split_damage.py). This is the only
  gameplay-script change.
- 576 shared udg_ variables moved into the Variable Editor ("Shared variables" folder at the top of the trigger tree).
  356 stay in the map header: groups, timers, forces, hashtables, string arrays, and variables with starting values.
  Moved by tools/refactor/phase8_variable_editor.py; the list is in src/variables.json.
- New docs: FFERPG/docs/SAVE_CODES.md, JOBS.md, SPAWNS.md, PHASE8_TEST_CHECKLIST.md. README, SYSTEMS, NEXT_STEPS and
  READABILITY_GAMEPLAN are updated.
- check_map passes all 7 checks against r14.
- PENDING: World Editor Save As of r15test (the first save with Variable Editor vars and the damage split), then the
  late-game play test from PHASE8_TEST_CHECKLIST.md. Damage and Knight Cover matter most.

# NEWEST CHECKPOINT — Claude: dead-code cleanup (2026-10-02)

User confirmed phase6 (save/load without Build Play Copy works; module disabling tested). Removed all dead code:
89 unused functions + 4 unused variables; 6 empty triggers deleted (MapSetup, InitCustomTeams, config, DEMissiles,
Unused, Healing). Map: FFERPG/release/FFERPG_0.9.7.3-r13-cleanup.w3x (copy in TEST). Script:
FFERPG/tools/refactor/phase7_dead_code.py; report FFERPG/build/dead-code-removed.json (cloud only) and git commit 3fd45fe.
All checks pass; every remaining function unchanged. PENDING: World Editor Save As + quick play test.

# NEWEST CHECKPOINT — Claude: Phases 5–6 (2026-10-02)

User confirmed r13-phase4 works (their World Editor save TEST/FFERPG.w3x compiled with library globals; copy kept as
FFERPG/baseline/FFERPG_r13-phase4_editor-save.w3x). New: FFERPG/release/FFERPG_0.9.7.3-r13-phase6.w3x (copy in TEST),
built on that editor save. Read FFERPG/docs/PHASE56_TEST_CHECKLIST.md, DISABLING.md, STARTUP.md.
- Phase 5: quest-log help texts are "Create Quest" actions in new GUI trigger QuestLog_Entries (02 Map setup); text in
  war3map.wts via TRIGSTR; ModuleLongText helpers removed; quest log verified identical. Editor saves should now be directly
  playable with native save/load -> Build Play Copy optional (needs user confirmation in game). tools/wtg.py edits the trigger tree.
- Phase 6 (user chose safe disabling only; Legacy 1.29 + quest framework not started): static if LIBRARY_T<Module> guards
  + requires optional in Startup_* and RegisterTriggers_* (compiled script unchanged); tools/disable_check.py; docs/DISABLING.md
  (334 of 739 modules can be switched off alone).
- tools: build_map compacts archives (maps back to ~11 MB).
- PENDING: World Editor Save As of phase6 (first static if / optional requires), native save/load of the editor save
  without Build Play Copy, quest log check, Healing/Fishing_Casting disable test.

# NEWEST CHECKPOINT — Claude: readability Phases 3–4 (2026-10-02)

User confirmed r13-phase2 works (their World Editor save TEST/FFERPG.w3x compiled; its JassHelper output matched our
generated runtime token-for-token except the unfinalized ModuleLongText helpers). Phase 3 and 4 are done in FFERPG/
(commits 0f09a66, d14b8f8). Test map: FFERPG/release/FFERPG_0.9.7.3-r13-phase4.w3x (copy in Maps/Download/TEST);
phase3 map is the fallback. Read FFERPG/docs/PHASE34_TEST_CHECKLIST.md, SYSTEMS.md, STARTUP.md.
- Phase 3: gg_trg_ declarations + single-module udg_ variables live in each module's library globals block; shared
  variables grouped by folder in the map header. Phase 4: Register_* helpers live with their trigger code (parents keep
  RegisterTriggers_* lists, annotated); legacy spells registered by RegisterLegacy_*; CalcDamage documented; developer
  guide atop the map header; docs generated by tools/gen_docs.py.
- Proof: check_map passes (incl. new 4b globals check; check 5 now flags unfinalized long text);
  tools/refactor/verify_functions.py: all non-startup functions token-identical to r12test (3 local renames reversed).
- PENDING: play test + first World Editor Save As with library globals blocks + Build Play Copy. Phases 5-6 not started.

# NEWEST CHECKPOINT — Claude: readability Phases 0–2 (2026-10-02)

The developer workspace is now **FFERPG/** (Git repository; read FFERPG/README.md, docs/STARTUP.md,
docs/READABILITY_GAMEPLAN.md, docs/PHASE2_TEST_CHECKLIST.md). Baseline = FFERPG/baseline/FFERPG_0.9.7.3-r12test.w3x
(SHA256 7583754261997a20dbb01bf844a4b20c189076be1fe79c79858f37114706d6a1; identical to NeutralOwnership-fix01/FFERPG_SAVE_SAFE.w3x;
its WCT == Builder24/StartupFinalSources-test01). Editable trigger text lives in FFERPG/src (exported from the map; the map is the source of truth).

- Phase 1 map FFERPG/release/FFERPG_0.9.7.3-r13-phase1.w3x: formatting-only editor text; playable script byte-identical to r12test.
- Phase 2 map FFERPG/release/FFERPG_0.9.7.3-r13-phase2.w3x (copies also in Maps/Download/TEST): main_old is 11 Startup_* steps;
  RegisterR11_<T> renamed Register_<T> (guards removed); each module ends with RegisterTriggers_<Module>[_PartN];
  Startup_RegisterTriggers starts 571 groups via ExecuteFunc. udg_InitTrigFromMain removed. Runtime and WCT both updated
  (playable directly; the runtime keeps r12test's finalized long-text fix).
- Proof: FFERPG/tools/check_map.py (pjass runtime, vjass_lite source compile, wiring, source/runtime agreement, literal sizes)
  and tools/startup_audit.py (all 2,120 startup statements identical in order; 1,602 triggers identical; no reorder between
  triggers sharing an event/trigger variable). Results in FFERPG/release/checks-*.txt.
- Builder24/PlayCopyUi.cs CheckPlayScript24 updated to validate Register_/RegisterTriggers_ (old RegisterR11_ still accepted);
  original saved as PlayCopyUi.cs.before-phase2.txt. NOT yet compiled — run `dotnet build` and report errors.
- 10 remaining cleanup-manifest folders moved (not deleted) to _archive/.
- PENDING: user play test of r13-phase2 + World Editor Save As + Build Play Copy. Phases 3-6 not started.

**Single-map requirement (2026-10-01):** Ship ONE identical map for Warcraft 1.32 and current Reforged. The only active release candidate is `Builder24/FinishedCandidate-play01/FFERPG_UNIFIED_CANDIDATE.w3x` (SHA256 `2ad2b221bee57a6db0ba5f84fe54042149dcfde3957b86b3eda257d0f3ac0c1c`). It is byte-identical to the earlier older-format candidate, including cleaned editor source and finalized r11-based runtime/world data. This is a candidate selection, not a newly implemented compatibility fix. Test this SAME file in BOTH versions. Compatibility is pending on both for this exact artifact. FINISHED_CURRENT and FINISHED_LEGACY_TEST are superseded diagnostic checkpoints, not separate releases. Do not distribute version-specific maps. Do not Save As through the newer editor before testing; any future regenerated release must again satisfy both targets. Preserve ten folders, 739 modules, and comments. Existing source-only cleanup/runtime-preservation limitations still apply.

# NEWEST CHECKPOINT — Reforged first (2026-10-02)

GUI workflow updated: see BUILD_PLAY_COPY.md. Program.cs supports `dotnet run -- --play-copy`; normal launch remains GUI. Builder24/PlayCopyUi.cs adds progress, durable reports, classic-format evidence-based neutral repair, modern-format generated ownership checks, unique functions, registration dispatch and runtime text validation before compilation/publication. Modern placement ownership problems require editor correction; do not claim universal automated repair. Working-map workflow and classic repair exercised through the same CLI backend.

Latest review: user reports successful three-player main questline and most quests through Ice Age, and says the follow-up checks worked. Extended later encounters remain pending. Read Builder24/NeutralOwnership-fix01/GAMEPLAY_AUDIT.md. New read-only audit script audit_gameplay_baseline.py confirms1,602 unique registration dispatches and all5,680 original startup registration/action/condition statements in exact order. 8,112/8,171 original functions match ignoring formatting/comments/local renames;51 have string-only differences;4 are editor-world handoffs;1 is QuestLog long-text handling;3 original names are startup/editor boundaries. No additional gameplay change made. Useful next work is integrating regression checks into Build Play Copy and clarifying the release workflow, not speculative refactoring.

This checkpoint supersedes the older candidate and compatibility instructions above and below. User reports the neutral ownership correction works after World Editor Save As, and the finalized copy seems to work in Reforged. Active playable baseline: `Builder24/NeutralOwnership-fix01/FFERPG_SAVE_SAFE.w3x`, SHA256 `7583754261997a20dbb01bf844a4b20c189076be1fe79c79858f37114706d6a1`. Editor-saved input: external `TEST/FFERPG.w3x`; preserved. Finalization converted six long passages to text-table references and passed archive preservation checks and pjass.

User now identifies their Legacy installation as 1.29, not 1.32, and defers Legacy compatibility until Reforged is stable. Do not produce a separate Legacy release or claim compatibility. Preserve the long-term shared-community goal; assess feasibility later. Renaming .w3x to .w3m does not perform a compatibility conversion.

Regression check completed: all 739 custom modules and custom globals in the finalized map exactly match StartupFinalSources-test01 after newline normalization; no duplicate runtime function names. Regenerated neutral buildings/critters correctly use PLAYER_NEUTRAL_PASSIVE, with no CreateBuildingsForPlayer15/CreateUnitsForPlayer15 routines. The ownership repair changed 198 old slot15 placement owners to27, each matched to original r11 neutral-passive creation; all other placement bytes preserved. Repair script: Builder24/repair_neutral_ownership.py. Retain corrected placement data on future builds.

Next: test Reforged multiplayer and representative gameplay regressions before further refactoring. Treat user report as a successful initial check, not comprehensive multiplayer testing. Further editor saves require Build Play Copy again before native save/load testing. Keep ten folders, all full-code modules and comments, and normal GUI startup.

# WarcraftMapExtractor: resume here (historical details follow)

Snapshot: 2026-10-01. Read the current checkpoint first. Older entries are historical and superseded wherever they conflict with it.

## Current checkpoint: editor save confirmed; prepare thorough testing

**NEWEST CHECKPOINT — startup cleanup finished (2026-10-01):** user reports the map seems to work, authorized the inactive-startup cleanup and downloaded Warcraft Legacy for later testing. New editable source **Builder24/StartupFinalSources-test01/**. Current-version play copy **Builder24/FinishedCandidate-play01/FINISHED_CURRENT.w3x**; separate older-format candidate **Builder24/FinishedCandidate-play01/FINISHED_LEGACY_TEST.w3x**. Read that folder's README and validation.json. The paragraphs below remain the frozen-input history, not the newest source paths.

Verified external SolidCandidate still matches the frozen recovery hash. Created SOLID_BASELINE_PLAY.w3x through Build Play Copy; finalization and pjass passed. Its 739 saved modules exactly matched R11RestoredSources-test03 before cleanup. Removed2326 unreachable startup-family functions (Start_, Register_, MapBootstrap_, MapSetup_ where unreferenced), neutralized479 old phase dispatchers, removed712 phase globals. The only old phase writer was the removed MapBootstrap_InitializeTriggers. All1602 RegisterR11_* helpers and active function bodies/comments retained. Moved480 helpers into related original modules within their folders so no module is empty. All739names/order andtenfolders retained. SourceJassHelper passed using actualSavedgeneratedglobals; maxliteral978. Scripts finish_startup_cleanup.py and check_finished_startup.py; retired-startup.j.txt and cleanup-validation.json preserve audit/recovery. Never package compile-check/output.j.

FINISHED_CURRENT packages only cleaned WCT over finalized realSolidCandidate runtime/world data. FINISHED_LEGACY_TEST packages equivalentcleaned classicWCT over FULL_MODULES_FIXED's r11-based oldercontainer/world/runtime; its runtime isbyteidentical tothatpriorcandidate, withnonewnativesvsr11. These runtimes intentionally retain oldcompiledunusedfunctions; this was editor-source cleanup, not a regeneratedworld/runtime rewrite. CurrentSavedruntime adds7 newer-editor native identifiers versusr11, so don't assume samefileisLegacycompatible. ActualLegacytest pending; userwilltestfinishedcopy andshouldreportversion. Do not saveLegacycandidate through3.0beforetesting. Generaldowngradeexporter remainsunimplemented. Nootherrefactorbeforetestround. Cleanupmanifestdeletionsremainblocked/notperformed; GUIunchanged.

The user confirmed the duplicate-declaration fix worked and World Editor Save As succeeded. Their saved baseline is **C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST/SolidCandidate.w3x**, 11,701,205 bytes (displayed as 11,427 KB). They explicitly identified this file and said it should be the only map in TEST.

A byte-identical recovery copy is now at **Builder24/TestingBaseline/SolidCandidate-world-editor.w3x**. Both SHA256 hashes are `530CF0BAA5DC5993F49B94AB8C344717BC4715823BC74AD6F77FFE16CF7B15C8`. This is the confirmed editor-saved baseline, not yet a finalized or thoroughly gameplay-tested play copy. Preserve both files.

Current editable modules: **Builder24/R11RestoredSources-test03/**. Pre-save candidate: Builder24/R11Restored-play02/FULL_MODULES_FIXED.w3x. Preserve the 739 full-code modules, their order, ten folders, and comments. The user rejected the 2,355-entry initializer-heavy layout. Keep RegisterR11_* registration helpers INSIDE their owning modules. Retain the disabled PreplacedUnitRefs GUI helper; it causes World Editor to generate required unit declarations.

The last fix removed exactly 21 custom gg_trg declarations also generated by the editor. Module files, runtime, WTG and WTS were unchanged. Validation formerly deduplicated declarations and missed overlaps; the new preflight detects them. Fresh automated JassHelper compilation timed out, but actual World Editor Save As is now user-confirmed successful. Do not describe Save As as blocked, or confuse this success with gameplay/native save-load testing.

r11's world/object data, 831 placement records, 712 regions, 18 cameras, and older-format reference are retained. 11,277 original function/comment bodies were preserved, with five world/bootstrap adaptations. Legacy Start_/InitTrig dispatch scaffolding remains for continuity but is not the active registration path; main_old calls RegisterR11_* helpers. Avoid another broad cleanup before testing.

Next priority: prepare a separate finalized play copy from confirmed SolidCandidate using the existing Build Play Copy workflow. That finalization has NOT yet been performed on SolidCandidate. Preserve the editor-saved file. Never package a synthetic compile-editor-source-check/output.j as gameplay. Keep JassHelper and vJass enabled. Follow TESTING_PLAN.md for smoke tests, prior regressions, native save/load, and feature coverage. Actual Warcraft 1.32 execution remains unverified; newer-editor saves can rewrite older formats. A general downgrade exporter and universally safe independent trigger disabling are not implemented.

Preserve normal dotnet build/run GUI behavior. Older import/grouping helpers still have classic-container limitations; use the integration packager or extend those parsers deliberately.

Cleanup: **NO FILES DELETED**. cleanup-manifest-2026-10-01.json lists 192 reviewed targets totaling 2,033,745,219 bytes (about 1.89 GiB): superseded drafts, failed auxiliary checks, and raw archives byte-matched to retained packaged maps. Four unproven archives were excluded. The deletion command was rejected before execution because sandbox approval is disabled. Do not bypass this restriction or claim cleanup completed. See CLEANUP_STATUS.md. Keep source, tools, inputs, current maps, and recovery checkpoints.

Latest user request: finish the handoff, new resume prompt, permitted cleanup, and recommendations before thorough testing. RESUME_PROMPT.txt is updated for this checkpoint. Do not restart the refactor or repeat old failed experiments.

### Latest update (supersedes checkpoint status below)

Duplicate-fix validation completion: R11Restored-play02/validation.json records exact21 removals, no remainingcustom/generatedcollision,739 modules andruntime/WTG/WTS byteidentical. pjass passed priorcompiled unchangedmodulebodies augmented withall741editortriggerglobals (generated-globals-check.j). FreshfullJassHelperharness timedout at180s; do NOT claimfreshsourcecompilepassed. Earlier experimentalpostcompileinsertion matched a COMMENT containingendglobals; corrected to anchored^endglobals andfinalpjasspassed. No map affectedbythatvalidation-onlymistake. Referenced-only auxiliarycompiler returned0withoutoutput, NOTaccepted. Finalmap FULL_MODULES_FIXED.w3x readyforuserSaveAs confirmation. No gameplayregressiontest needed solelyforthisglobalsfix. ApplicationGUIunchanged.

LATEST DUPLICATE GLOBAL FIX (2026-10-01): user reports21 pjass multiply-defined gg_trg handles withJassHelper/vJass ON. Foundexact21 overlap between originalcustomglobals and739 moduleWTGnames. Removedonlythese21 customtriggerdeclarationlines; WorldEditorgenerates correspondinghandles. Candidate Builder24/R11Restored-play02/FULL_MODULES_FIXED.w3x; sources Builder24/R11RestoredSources-test03/. All739 modulefiles/comments,WTG,runtime,WTS byteidentical topreviousrestoredcandidate. Updated restore_r11_module_layout.py filters editorownedhandles; generated-trigger-declarations.json lists21. validate_restored_r11.py previouslydeduplicatedgeneratedglobalsandmissedthis; now checksallWTGnames independently and rejectsoldtest02withsame21collisionnames. Packagingpassed. This isrealduplicate-declarationbug, NOT uncheckedJassHelper. Compiler status see candidatevalidation/sourcecheckresult (complete before handoff). Keep tenfolders/fullcode/r11worlddata/native-savefix. No app changes. Prior741entrylayout remains739custom+2GUI. User needsSaveAs ofnewcandidatewithbothJassHelper/vJass enabled.

LATEST FULL MODULE RESTORATION (2026-10-01): user disliked added initialization-only entries and requested full code layout from VERIFIED_OBJECT_NAMES. Preferred candidate Builder24/R11Restored-play01/FULL_MODULES_RESTORED.w3x; canonical sources Builder24/R11RestoredSources-test02/. Restored739 original custom module names/order and all ten folders. 11277 original function/comment bodies unchanged; only main_old and4 Units_Create* keep r11 world/setup adaptations. Internal1602 RegisterR11_* helpers placed in owners instead of separateeditorentries; MainDeprotected + disabledPreplacedUnitRefs retained. Old Start_/InitTrig staged wrappers preserved for source continuity but inactive under r11 main_old (do not treat edits there as current startup edits; actual registrations are RegisterR11_*). Full r11 world/object payloads and finalized priorruntime preserved; runtime changes only initializer names, proven reversible. Generator restore_r11_module_layout.py; validate_restored_r11.py sourceJassHelper passes max978; runtimepjass passes; extractedWCT exacttext roundtrip/allCRLF; archive verification passes. No app/GUI changes this turn. IMPORTANT user confirmed screenshot94400errors were because JassHelper/vJass unchecked; enablingJassHelper allowedSaveAs. Do not attribute confirmedfailure to CRLF. PriorintegratedWCT had loneLF; writer now usesCRLF matchingknown-good aspreventive fix. User shouldinspect familiar modules andSaveAs withJassHelper/vJass enabled; no repeatedfullgameplaytest solelyforlayoutchange. Actual1.32 and integratedgameplay/native-load checkpoint stillpending. NewcandidateREADME details caveats and BuildPlayCopy aftersaves. Source test01 is intermediate. The classicWTG/WCT limitations of olderimport/groupingtools stillapply.

LATEST R11 INTEGRATION (2026-10-01): user authorized all reviewed r11 changes while retaining ten folders/comments. New candidate Builder24/R11Integrated-play02/R11_INTEGRATED.w3x; canonical modules Builder24/R11IntegratedSources-test03/. Original maps untouched. r11 supplies classic-format world/object/terrain/pathing/imported payloads; our 739 existing custom module names retained, new InitTrig ownership entries bring count to2355 custom + MainDeprotected and disabled PreplacedUnitRefs GUI records. Preserve the latter: it forces generated unit declarations. All ten folders retained. Existing gameplay bodies/comments and eight constant formula helpers retained; five world/bootstrap source functions replaced by r11 versions, old Start/phase dispatch retired, matching-statement comments transferred, old setup archived in retired-setup-comments.txt. Direct runtime based on r11 original world generation with our commented gameplay functions; exact1602 initializer blocks factored out of main, new guardflagtrue set before startup. audit_r11_candidate.py proves expansion matches r11 startup exactly and registration inventory unchanged; no new native dependencies. Source JassHelper compilation uses r11 runtime globals plus GUI-record unit refs as harness; not an actual WE SaveAs. Runtime pjass passes; six ModuleLongText helpers finalized; maxliteral902. Added missingWTS95/96 from r11 map metadata. Actual WE SaveAs, finalized saved-copy native save/load, gameplay and actual1.32 testing PENDING; user checkpoint ready. No generic downgrade of future3.0 saves implemented; don't claim1.32 proven or independent disabling universally safe. README has exact steps/limits. R11Integrated-play01 and test01/test02 are superseded. New CLI package-r11 in R11Integration.cs, built Builder24/r11-app (chocobo-app locked by running process; no user process stopped). Root GUI startup untouched. Existing source-import/grouping parsers only understand ReforgedWTG/WCT and cannot directly reuse classic integrated container; use newpackager/generator until extending them. Never package synthetic source-check output. integrate_r11.py refuses overwrite; generator now includes constant funcs and metadata IDs. validate_r11_integration.py and audit_r11_candidate.py pass. User's latest 'pick up and finish' requests completion of this integration, not a new scope.

LATEST OBJECT NAME RESOLUTION (2026-10-01): preferred map Builder24/ObjectNamesResolved-play01/VERIFIED_OBJECT_NAMES.w3x; canonical sources Builder24/ObjectNamesResolvedSources-test01/. Resolved 178 previously unknown codes at 525 references in 141 files: 175 via map buff tooltips/WTS editor labels, three standard ability references (AInv, Avul, Aneu) via published OpenWarcraft3 documentation. Each label states evidence type; editor labels are not necessarily custom gameplay names. See object-name-provenance.json and object-name-validation.json (330 unresolved codes). Generator resolve_additional_object_comments.py uses ObjectReferenceData/verified-additional-names.json produced from read_extended_object_names.py plus WTS editor comments. Installed CASC access failed; no installed-version name verification claimed. All executable source tokens identical, JassHelper passes max literal978, WCT roundtrip/WTG/518 archive payloads preserved. Runtime dumped and byte-identical to CLEAN_SYSTEMS. No routine Save As/native-load test needed. Existing ten folders retained. GUI code untouched. 1.32 and independent disabling remain unfinished.

LATEST SYSTEM CLEANUP: preferred map Builder24/SystemCleanup-play01/CLEAN_SYSTEMS.w3x; canonical sources Builder24/SystemCleanupSources-test01/. Removed403 remaining Math used by headings, including wrapped lines; verified zero Math used by/to heading lines across all source files. explain_all_calculations.py now suppresses both prefixes. Useful explanations retained. Further split Legend/Gaya/Shadow/Summon/Hunt into51 new feature modules; moved598 functions including13 single-owner startup blocks; no new local renames. All ten folders preserved, dependencies cycle-free. Generator split_remaining_systems.py, cleaned baseline SystemCleanupSources-stage01. JassHelper passes max literal978. compiled-equivalence.json verifies all11,234 original compiled functions identical and51 new empty InitTrig entrypoints. Packaged740 triggers; WTG/WCT/archive checks pass; runtime separately dumped and byte-compared identical to CleanFeatures. MODULES.md/README in final folder. No Save As/native-load test requested, visual editor layout unverified. App code untouched. Independent disabling and Warcraft1.32 still unfinished. Initial verification used character-token lexer against word-token expected no-op function; corrected verifier lexer and all checks passed; map code was unchanged.

LATEST CLEAN FEATURE MODULES: preferred map Builder24/CleanFeatures-play01/CLEAN_FEATURES.w3x, canonical sources Builder24/CleanFeatureSources-test01/. Removed exactly 1,127 "Math used to..." headings (including wrapped headings) and 966 Increase/Decrease by1 boilerplate comments. Existing formula explanations retained. Explain-all generator now suppresses these styles. Comment-clean stage: CleanFeatureSources-stage01 (baseline for split). split_gameplay_features.py separates Spell/Chocobo/Fishing/Item/Hero into52 new modules, moving603 functions including16 single-owner startup blocks. Shared non-dispatch functions go into Owner_Shared to avoid dependency cycles. Resolved library-name collision by naming Hero_MedicineEvents rather than Hero_Medicine (existing HeroMedicine). All ten folders retained, dependencies cycle-free. No new local renames in this pass. Full original compiled-function comparison verifies11,182 bodies exactly unchanged;52 new InitTrig entries empty. JassHelper passes (max literal978). WTG/WCT/archive import passes; actual runtime separately dumped and byte-identical to FocusedModules. No Save As/native-load retest requested; user can inspect layout. MODULES.md and README in map folder. 1.32 and individual disabling still unfinished. No application code changes this turn. Initial comment validation regex falsely matched by1.2; corrected end-of-line matching and final verification passes (no map defect).

LATEST FOCUSED MODULE REFACTOR: preferred map Builder24/FocusedModules-play01/FOCUSED_MODULES.w3x; canonical sources Builder24/FocusedModulesSources-test01/. User authorized splitting Quest/Boss/Arena and improving local names. Added 109 coherent feature modules in same ten folders; moved 2,042 original functions including 77 single-owner startup blocks, leaving original owner dispatchers and multi-feature startup blocks. Libraries/dependencies recomputed, cycle-free. Renamed 201 locals/parameters across 127 functions using explicit names or native initializer evidence; corrected Zone integer l_target to targetUnitCount after type review. Globals/function names/startup order unchanged. Updated comments with renamed identifiers. split_focused_modules.py validates every original function via inverse rename token comparison; source compile passes (max literal978), compiled-equivalence.json verifies all 11,073 original compiled functions identical after inverse renames, plus109 empty new InitTrig entries. GroupEditorModules.cs now accepts explicit module-additions.json, preserves existing records, adds enabled custom entries with no init events, allocates trigger IDs from existing trigger-ID range skipping reserved/deleted IDs. Archive/source checks pass; separately dumped runtime byte-identical to CLEANER_COMMENTS. Canonical MODULES.md/README in map directory. Draft folders FocusedModules-play01-initial and FocusedModules-play01-id-draft are superseded; do not use. Root app build passed before final ID allocator change; bundled app build passed after it (existing nullable warnings only), no GUI launch logic changed. Next user check is editor layout only; no routine Save As/native-load request. Independent disabling and 1.32 remain unfinished. Future import-module-sources works on final map with expanded trigger list; do not rerun --group-modules with additions manifest against a map that already contains those additions without adapting it.

LATEST COMMENT CLEANUP: preferred map Builder24/FormulaReadable-play04/CLEANER_COMMENTS.w3x; canonical sources Builder24/FormulaReadableSources-test04/. User requested removal of repetitive "Math used by this call:" headings. Removed exactly 1,741 headings across 169 modules, preserving all actual explanations, all other comments, library wrappers and approved folder structure. Updated explain_all_calculations.py not to regenerate this specific heading. All source executable tokens unchanged, grouped source compile passes (max literal 978), import/archive checks pass, dumped runtime byte-identical to play03. No Save As/native-load retest needed. User also asked what cleanup should come next; recommended splitting large Quest (1,019 functions), Boss (598), Arena (444) into focused owner modules within current folders, then descriptive local-variable renames. Recommendation only: no structural split or variable rename performed in this turn. Preserve compile dependencies/startup order/native-load safeguards on future splitting. 1.32 and independent disabling remain unfinished.

LATEST MAP-WIDE CALCULATION COMMENTS: preferred map Builder24/FormulaReadable-play03/EXPLAINED_CALCULATIONS.w3x; canonical sources Builder24/FormulaReadableSources-test03/. User requested same readability treatment for every readable calculation. Added 4,581 explained lines in 307 modules via explain_all_calculations.py: parses expressions with operator precedence, tracks numeric/string types and integer division, describes arithmetic and recognized math calls, splits long expressions into numbered results. Existing curated comments preserved. 6,985 candidate lines classified: 4,581 new comments, 180 already commented, 2,224 text joins/nonmath/signed literals excluded. Zero unparsed candidate statements. Unknown function purposes keep original function/variable names; comments explain arithmetic without inventing gameplay meaning. Actual function implementations elsewhere get their own calculations explained. Does not claim semantic review of every opaque helper call. Single-letter numeric literals decoded, four-character object IDs preserved. All source executable tokens unchanged. Grouping/order/dependencies byte-preserved. JassHelper compile passed (max literal 978); WCT roundtrip, archive preservation passed; playable runtime separately byte-compared unchanged from FormulaReadable-play02. No new Save As/native save-load test needed. FormulaReadable-play03-initial is superseded intermediate, not preferred. GUI untouched. Continue retaining approved folder structure; 1.32 and independently disableable modules unfinished.

LATEST EXPANDED FORMULA COMMENTS: preferred map Builder24/FormulaReadable-play02/READABLE_FORMULAS_2.w3x, canonical sources Builder24/FormulaReadableSources-test02/. Added 131 new explanation locations across 18 modules, preserving all 55 previous comments. Covers Heal, MaxHp, Regen, Potion, Steal, Fishing, Loot, Arena, Knock, Missile, Counter, Chocobo, Meteor, Fire, Blizzard, Cooldown, Damage (63 additional amount-scaling explanations), Food. Comments address chances, loot indices, square-root rolls, cooldown multipliers, knockback, distance falloff, bribe prices, and battle-point timing. Generator explain_more_formulas.py uses curated comments and a tightly bounded scalar-multiplier pattern for named damage/health variables. All 528 executable-token streams, grouping/order/dependency metadata preserved; source compile passed (978-byte max literal), WCT roundtrip/archive preservation passed; packaged runtime independently dumped and byte-compared identical to FormulaReadable-play01. No Save As or native save/load test needed. Not all formulas are explained yet; continue targeted passes without generic boilerplate. Ten approved folders and vJass library declarations retained. GUI untouched; 1.32 and independently disableable modules still unfinished.

LATEST FORMULA READABILITY: preferred map Builder24/FormulaReadable-play01/READABLE_FORMULAS.w3x, sources Builder24/FormulaReadableSources-test01/. User strongly wants existing 10-folder structure retained. Scanned 527 custom modules; largest are Quest/Boss/Arena, and many simple repeated predicates remain deliberately owner-specific (cleanup-scan.json). Added 55 plain-language comment locations across CombatFormulas, AttackSpeed, MagicDefense, Armor, Prof, Loc, Reward, Exp, Damage: describe weighted stats, multiplier order, truncation, percentage bonuses, mana fraction, XP scaling, and adaptive barriers with small arithmetic examples. Reindented 710 Start_ functions from extra 8-space body indentation to normal 4-space body indentation. All 528 source executable-token streams identical to GroupedSources baseline; trigger-order/grouping/compile-dependencies JSON copied byte-for-byte. JassHelper source compile passes (max literal 978), WCT round trip and WTG/archive preservation pass. Packaged playable runtime separately dumped and byte-compared identical to GROUPED_MODULES. No Save As/native-load test needed for comment/whitespace changes. Generator explain_formulas.py. This is a targeted initial explanation pass, not every formula in the map. Grouped library dependencies and original native-load text fix retained; 1.32 and independent disabling remain unfinished. GUI code untouched.

LATEST SUBJECT GROUPING: preferred map Builder24/GroupedModules-play01/GROUPED_MODULES.w3x; canonical sources Builder24/GroupedSources-test01/. All 528 editor triggers now in ten subject folders. FOLDERS.md in map folder lists membership. Raw subject reordering initially failed undeclared-function checks; resolved by wrapping 527 custom sources in JassHelper libraries (TName, underscores stripped) with explicit function-owner dependencies. Verified dependency graph has only backward edges in prior source order. Grouped source check passes, source bodies unchanged after stripping wrappers, and all 11,073 compiled functions match TriggerNames output with zero changes. Playable runtime and WTS are byte-preserved from TriggerNames map. WTG parent fields/order changed; trigger flags, IDs, descriptions and GUI ECA payloads preserved; WCT matched/reordered by name. Map archive/source round trips pass. No new Save As/native load testing needed; actual World Editor folder display is still unverified. Classification has explicit core/job/item groups plus quest/dialogue/encounter evidence; membership can be refined with user feedback. Tools: group_modules.py (first generation only), group_dependencies.py, verify_grouping.py, GroupEditorModules.cs / --group-modules INPUT SOURCE NEW_OUTPUT. Grouping sources are now canonical, retain library wrappers on future edits. GUI dotnet build/run behavior unchanged; root build passes. Independent disabling and Warcraft 1.32 still unfinished. User approved grouping step; no gameplay test result yet for this candidate.

LATEST TRIGGER NAMING/SEPARATION: Builder24/TriggerNames-play01/TRIGGER_NAMES.w3x is the latest candidate; editable sources Builder24/TriggerNamesSources-test01/. User requested simpler names, dislikes module phase/initphase terminology. Renamed 710 MODULE_PHASE_Owner_NN constants to t_Owner_NN, udg_ModuleInitPhase to udg_StartingTrigger, udg_ModuleInitDone to udg_TriggerStarted, MapBootstrap_InitializeModules to MapBootstrap_InitializeTriggers (713 identifiers). Extracted 710 guarded branch bodies into Start_Owner_NN functions inside each owning module, declared before its InitTrig dispatcher. Dispatch order, numeric IDs, guards, gameplay instructions and object-reference comments preserved. Generator simplify_trigger_names.py verifies expanded executable tokens match renamed baseline for all 528 sources and actual runtime. Source JassHelper and runtime pjass pass; max compiled literal 978. Imported editor sources and packaged matching transformed real runtime (never synthetic source-check runtime); all unrelated archive payloads including WTS preserved. Final native-long-text fix retained. No new natives, but 1.32 remains unverified. Gameplay not yet user tested. User prefers direct play with substantial batches, no routine Save As/save-load test. Independent disabling is still unfinished; this change does not claim to enable it. Prior ObjectAnnotated map retained.

LATEST OBJECT COMMENT PASS (supersedes rejected DeveloperReadable pass): User rejected generic developer headers/navigation comments. New preferred map: Builder24/ObjectAnnotated-play01/OBJECT_REFERENCES.w3x. Sources: Builder24/ObjectAnnotatedSources-test01/. Rebuilt from SetupOwnership sources, keeping obsolete-comment removal but none of the added generic headers/dispatcher comments. Added verified object names beside 9,941 references (3,063 unique IDs), and decimal equivalents for 5,384 numeric hex references across 528 files. 508 distinct IDs have no verified name in the extracted map data and are explicitly marked unresolved; do not guess. See object-reference-validation.json. Names from packaged war3mapSkin object records plus WTS; parser/data in Builder24/annotate_object_codes.py and ObjectReferenceData/. Source executable tokens exactly preserved, source compilation passed (max literal 978), WCT round-trip/archive preservation passed, packaged runtime SHA256 identical to tested SetupOwnership baseline. No Save As or native-load test needed for this comment-only batch. Root dotnet build passes and GUI launch unchanged. DeveloperReadable artifacts are historical/superseded, not preferred. Warcraft 1.32 and independent module disabling remain unfinished.

LATEST READABILITY PASS: `Builder24/DeveloperReadable-play01/DEVELOPER_READABLE.w3x` contains documentation headers in 528 source files; executable tokens are unchanged and the packaged runtime/WTS are byte-preserved from the tested SetupOwnership map. No new gameplay test required. Sources and onboarding: `Builder24/DeveloperReadableSources-test01/`, especially DEVELOPER_START_HERE.md, MODULE_INDEX.md, module-catalog.json. Generator: document_modules.py. Obsolete split-file and initializer boilerplate removed. Source compile/archive/editor-data checks pass. This is now the preferred editable/source baseline. Build Play Copy GUI remains available; interactive GUI validation still unconfirmed. Independent disabling and 1.32 remain unfinished.

LATEST APP CHANGE: user confirmed SetupOwnership gameplay works. Added **Build Play Copy** GUI tab via `Builder24/PlayCopyUi.cs` and `BuildPlayCopyTab()` in Program.cs. CLI counterpart `--build-play-copy INPUT.w3x NEW_OUTPUT.w3x` invokes the same backend. It finalizes, validates with supplied pjass/common/blizzard, preserves input, refuses overwrite, and publishes only on compiler success. Build runs asynchronously in GUI; no no-argument launch behavior changed. Finalizer now accepts already-finalized ModuleLongText helpers and checks their WTS IDs. Tests passed for raw editor input, finalized input with identical runtime, and overwrite rejection with identical output hash. Normal dotnet build passes; interactive GUI visual test pending. Read Builder24/BUILD_PLAY_COPY.md. No new gameplay change in this turn; SetupOwnership is the latest confirmed baseline. Do not use the EDITOR_INPUT_PIPELINE_TEST artifact as latest gameplay: it was only a regression fixture based on older CLEAN.

CURRENT CHECKPOINT: user confirmed LegacySpells works. Candidate `Builder24/SetupOwnership-play01/SAVE_SAFE_PLAY.w3x`, sources `Builder24/SetupOwnershipSources-test01/`. Thirty-nine setup helpers (2,165 lines) now live in MapSetup/Drop/Units/Init rather than MapBootstrap, with matching names. Function inventory and body/reference renamings are verified reversible; source order and runtime compilation and archive checks pass. The dependency report was refreshed in that source folder. Gameplay pending. No Save As/save-load handoff requested. Existing finalized text-table fix retained; independent disabling and 1.32 remain unfinished. Read the candidate README and setup-ownership.json.

CURRENT: user confirmed GameplaySetup works. Latest candidate `Builder24/LegacySpells-play01/SAVE_SAFE_PLAY.w3x`, source `Builder24/LegacySpellSources-test01/`. Ten legacy spell registration blocks (11 local triggers) now belong to Spell/Boss modules with their filters and preloads; bootstrap only dispatches them in original order. Exact reconstruction, source/runtime compilation, and archive selftests pass. Gameplay pending. No Save As/save-load handoff requested; finalized WTS retained. Read its README and legacy-registration-ownership.json. Independent disabling and 1.32 remain unfinished.

NEWEST CHECKPOINT: user confirmed WorldSetup works. Candidate `Builder24/GameplaySetup-play01/SAVE_SAFE_PLAY.w3x`, source `Builder24/GameplaySetupSources-test01/`, replaces gameplay-state setup with four ordered sections plus 25 named array initialization helpers. Exact statement reconstruction and local-boundary checks pass, as do source/runtime compilation and archive selftests. Gameplay pending; no Save As or native save/load handoff requested. Text-table repair retained. Read its README and gameplay-setup-validation.json. Independent disabling and 1.32 remain unfinished.

NEWEST: user confirmed NamedInitializers works. Next candidate is `Builder24/WorldSetup-play01/SAVE_SAFE_PLAY.w3x`, source `Builder24/WorldSetupSources-test02/`. It splits world creation into five responsibilities and deduplicates 924 player technology statements into 84 shared statements plus 11 calls. Expansion audits preserve all player expressions, values, and order. Source/runtime compilation and archive checks pass; gameplay is pending. Existing finalized WTS is retained. Read this candidate's README before resuming. No Save As or native save/load test requested. Independent disabling and 1.32 remain unfinished.

The user returned on the same account after using a reset and confirmed StartupCleanup gameplay worked. The low-usage constraint is no longer current. Latest candidate: `Builder24/NamedInitializers-play01/SAVE_SAFE_PLAY.w3x`; source: `Builder24/NamedInitializersSources-test01/`. This replaces 710 numeric phase IDs with named integer constants in 479 modules and renames helper-local variables in three setup functions. A token-inverse check proves the renaming preserves prior code, and source/runtime compilation and archive self-tests pass. Existing finalized WTS and TRIGSTR references are preserved. No new natives added. Gameplay for this new candidate is pending; routine Save As and native save/load are not requested. `INITIALIZATION_INDEX.md` and `named-phases.json` in the source folder document each phase. StartupCleanup is now the last user-confirmed checkpoint. Independent disabling and 1.32 support remain unfinished.

## User's goal and preferences

Turn Final Fantasy Epic RPG r7 into clean, readable, genuinely modular Warcraft III World Editor triggers, preserving gameplay. Eventually modules should own initialization and support dependency-aware disabling. Keep the C# extractor GUI usable through normal `dotnet build` and `dotnet run`.

Warcraft 1.32 compatibility is REQUIRED, in addition to the current Reforged installation (build 24268 / 3.0). It is NOT established yet. The original r7 author is collaborating and may supply his registration ownership mapping later. Do not wait for it: preserve our manifests so they can be compared later.

The user prefers substantial autonomous batches, concise progress explanations, and fewer test handoffs. Initially they enjoyed testing after every small change; their latest instruction overrides that: avoid routine World Editor Save As and native save/load testing. Make direct play copies where possible, and reserve those tests for meaningful milestones or relevant changes. They had 6% weekly usage remaining and requested an efficient handoff. Do not assume this percentage applies to the new account.

Do not spawn subagents unless newly authorized. Do not kill the GUI, Warcraft, or World Editor. Preserve originals and user-saved maps. Outputs should be separate and verified. No need to ask permission for ordinary project edits already in scope.

## Environment

- Workspace: `C:/Users/jaked/WarcraftMapExtractor`
- Windows PowerShell; .NET 10 WinForms; War3Net.IO.Mpq 6.0.3.
- No Git repository or AGENTS.md was found previously; check if this has changed.
- Python used: `C:/Users/jaked/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe` (rediscover if missing).
- Read/write access was limited to this workspace; Warcraft Maps/Errors folders were readable. New chat must obtain its own workspace access.
- User maps: `C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST/`
- User crash reports: `C:/Users/jaked/Documents/Warcraft III/Errors/`
- User often MOVES generated maps into the TEST folder rather than copying them. If an artifact is missing, search there and the relevant Builder24 folders. Do not regenerate unnecessarily.
- Always use explicit UTF-8 in Python read_text/write_text. Windows default encoding previously produced false mojibake findings. In generated C# use Unicode escapes for non-ASCII repair patterns if necessary.

## Exact current status

LATEST CANDIDATE (automated checks passed, user has NOT yet reported gameplay results):

`Builder24/StartupCleanup-play01/SAVE_SAFE_PLAY.w3x`

It is directly playable. Do NOT tell the user to Save As or perform a native save/load test routinely. This candidate contains the editable WTG/WCT and a separately assembled, finalized runtime. Future editor saving still requires finalization.

Its sources: `Builder24/StartupCleanupSources-test01/`.
Packaged editable candidate: `Builder24/StartupCleanup-editor01/OWNED_REGISTRATIONS_EDITOR_TEST.w3x`.
Runtime before finalization: `Builder24/StartupCleanupSources-test01/play-runtime.j`.
Finalized runtime and WTS: `Builder24/StartupCleanup-play01-source/runtime.j` and `runtime.wts`.
Checkpoint README: `Builder24/StartupCleanup-play01/README.md`.

LAST USER-CONFIRMED WORKING checkpoint:

`Builder24/CleanBootstrap-play01/SAVE_SAFE_PLAY.w3x` (may have been moved).
Editor-saved input: `Builder24/CleanBootstrap-test01/CLEAN.w3x`.
Sources: `Builder24/CleanBootstrap-test01/`.

The user confirmed the earlier ownership and staged-initializer maps including native save/load; also confirmed CleanBootstrap worked. Do not incorrectly mark StartupCleanup gameplay-tested.

## Architecture and completed work

Original: `FFERPG_0.9.7.3-r7.w3x`; preserve it. Root `common.j` and `blizzard.j` are supplied current game libraries, not verified 1.32 libraries. Do not use old sanitized experimental reference libraries.

The map was deprotected into editor custom-text triggers. Shared globals stay in map custom script. Most gameplay function bodies have been preserved while organizing/formatting/grouping systems. Splits like Dana_part01 and Dana_part02 were consolidated where function dependencies permitted. Hero/Player retained some splits to avoid ordering cycles. Folder organization and formatting were gameplay-tested.

Current structure:

- Approximately 527 custom modules plus the MainDeprotected GUI initialization trigger.
- MainDeprotected calls `main_old()` exactly once. Keep the GUI ECA/WTG startup consistent with the script; renaming main_old alone breaks it.
- 1,602 named gg_trg registration blocks moved to `Register_*` helper functions in 479 owning modules. Original statement text/order preserved.
- 479 InitTrig functions now dispatch those helpers through 710 ordered phases.
- `udg_ModuleInitPhase` defaults to zero. Automatic early World Editor InitTrig calls return without doing work.
- main_old/bootstrap sets a phase, calls the owning InitTrig, then resets phase to zero at the original position.
- `udg_ModuleInitDone[phase]` prevents duplicate registration.
- This is NOT independent module disabling: unchecking an editor module may omit referenced functions and break compilation. Dependency-aware activation is still pending.
- Original author's count was 1,606 registrations; our 1,602 is specifically named gg_trg creation blocks. Other local-variable trigger creation sites still exist. Do not claim the discrepancy resolved.

CleanBootstrap extracted five named setup functions: environment, sounds, rectangles, module initialization, initial trigger execution.

Latest StartupCleanup extracts four MORE phases: world objects (1,807 lines), Blizzard support (77), shared systems (11), gameplay state (574). main_old is now 12 lines instead of 2,488. Helper-local variables are assigned before first use; all startup statements reconstruct in original order. Function boundaries/local lifetimes changed and need eventual gameplay confirmation. The world-object phase remains large. No new game natives were added by this cleanup.

## Critical bug history: do not repeat

### Native Warcraft save/load crash: confirmed fix

This is native game saving, NOT character save codes (-save/-savef).

User created fresh saves using the same rebuilt map; loading crashed with invalid read 0x104 in Warcraft.exe. Original r7 save/load worked. Swapping the original runtime into the rebuilt archive also worked, isolating a runtime-script issue.

These attempts FAILED:

- Disabling JassHelper optimizer.
- Replacing the GameLoad event action with a diagnostic message.
- Removing 527 unused generated trigger variables.
- Bypassing the editor's startup wrapper/duplicate initialization.
- Splitting long strings into helper functions that concatenate short fragments. Compiled literals were all under 1,000 bytes, but native loading STILL crashed.

The WORKING fix moves long text into war3map.wts and leaves TRIGSTR references in the final runtime. Five oversized literals originally found (up to 2,131 bytes); current finalizer converts six fragment helpers, including a near-limit passage. User has repeatedly confirmed this text-table approach works.

JassHelper folds adjacent quoted fragments back together; World Editor saving can expand text references. Therefore finalize AFTER editor save/runtime assembly. The maximum-literal compiler guard is useful but NOT sufficient proof of native save safety.

`FinalizeNativeSave24` in `Builder24/RepairLongText.cs`:
- Reconstructs exact text from ModuleLongText_* helpers and replaces their bodies with returned TRIGSTR references.
- Converts oversized literal strings where applicable.
- Appends WTS entries without colliding with existing IDs.
- Repairs known double-encoded Cuchulainn spellings using Unicode escapes (proper spelling has u-acute).
- Packages separate `SAVE_SAFE_PLAY.w3x`; original input/editor sources preserved.
- Requires fresh output/staging directories; refuses if they exist.
- Finalized play maps can be played directly, but saving them again in WE requires rerunning finalization.

### Text cleanup

36 string expressions had doubled percent escaping cleaned once in CleanModuleText-test01. Includes difficulty/titles/-atkspd/-handicap and generated -savef batch content. Replace %% with % ONCE in that migration: intentional batch %%a must remain after decoding %%%%a. Do not repeatedly apply the cleanup to its own output.

Editor encoding can corrupt Cuchulainn text during Save As; finalizer repairs the actual runtime/WTS. Verify with UTF-8 decoding, not Windows default Python encoding.

### Damage text / quest / camera regression

An earlier workaround incorrectly made -damagetext off set udg_InCinematicMode=true and globally alter udg_ShowDamageText. It broke Shimmerweed and Cid/Mid quest turn-ins and teleport camera repositioning. Repaired by restoring original per-player preference updates and gating the floating-text renderer via udg_TrackedPlayers. Never reintroduce cinematic state changes for damage text. User verified the repair.

### GUI

Earlier dotnet run GUI launch failures and 0xe0434352 crashes were fixed. Preserve no-argument GUI startup. Special CLI commands are routed through --chocobo-editor. Rebuild the SAME output DLL you invoke; previously normal bin output was updated while stale Builder24/chocobo-app DLL was run.

## Build and tool commands

Run from workspace root. Commands below are examples; choose new output folders and verify paths before mutation.

```powershell
dotnet build --no-restore -v quiet
dotnet run
dotnet build --no-restore -o Builder24/chocobo-app -v quiet
```

No-argument dotnet run opens GUI. Two existing nullable warnings at Program.cs:884 and :4931 can appear on a full rebuild; these are not new map errors.

CLI prefix:

```powershell
dotnet Builder24/chocobo-app/WarcraftMapExtractor.dll --chocobo-editor
```

Append one of:

```text
--dump-script <input.w3x> <output.j>
--dump-wts <input.w3x> <output.wts>
--selftest <input.w3x>
--import-module-sources <input.w3x> <source-folder> <new-output-folder>
--probe-original-runtime <input.w3x> <original-map-or-script.j> <new-output-folder>
--finalize-native-save <editor-saved-or-runtime-assembled.w3x> <new-output-folder>
```

`--import-module-sources` replaces WCT sources by trigger name, preserves WTG and other archive payloads, emits source snapshots. Its default map filename is OWNED_REGISTRATIONS_EDITOR_TEST.w3x even for later stages.

`--probe-original-runtime` is a historically named general runtime packager: accepts a .j file and optional same-basename .wts companion, replaces only those payloads, verifies other archive hashes/locales including unnamed files, preserves preamble. Output default is ORIGINAL_RUNTIME_LOAD_TEST.w3x. Its console/report wording still mentions original/isolation even for a general replacement; interpret according to actual inputs.

`--finalize-native-save` produces SAVE_SAFE_PLAY.w3x and sibling `<output>-source/runtime.j`/runtime.wts. Do not accidentally ship an unfinalized candidate just because it compiled.

Compiler checks:

```powershell
& 'C:/Users/jaked/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe' Builder24/check_chocobo_order.py <folder-relative-to-Builder24>
& Builder24/tools/JassHelper/pjass.exe common.j blizzard.j <final-runtime.j>
```

Ordering harness concatenates shared source + custom modules in trigger-order.json and SYNTHETIC main/config. It verifies source order, not full WE code generation. Never package its output as a real runtime: its config is empty. Actual direct runtime assembly uses the real saved map runtime, preserving main/config and other generated functions.

Latest runtime assembly: dump CLEAN.w3x, replace ONLY function main_old with four new source helper definitions plus the 12-line main_old, syntax-check, inject into the updated editable archive, finalize, syntax-check final output, archive selftest. Keep unrelated saved functions/config unchanged. Real source ordering and saved-runtime ordering can differ due to JassHelper optimization.

## Code / metadata locations

Root Program.cs and Builder23.cs contain GUI and common archive helpers. csproj excludes Builder24/**/*.cs by default and explicitly includes production experiment files; add an explicit Compile Include when introducing another C# partial.

- Builder24/ChocoboEditor.cs: CLI routing, WTG/WCT readers/writers, Function24 regex.
- Builder24/NativeLoadProbe.cs: verified generic runtime/WTS packager and old diagnostic.
- Builder24/RepairLongText.cs: finalizer, earlier fragment source builder, one-time text cleanup.
- Builder24/ImportModuleSources.cs: source import/package validation.
- Builder24/move_registration_ownership.py: first registration move.
- Builder24/stage_module_initializers.py: guarded phase dispatch.
- Builder24/clean_bootstrap_sections.py: five-section extraction.
- Builder24/finish_bootstrap_cleanup.py: latest four phases + dependency report.
- Builder24/check_chocobo_order.py: ordering compile + literal-length guard.

WTG parser supports Reforged subversion 0x80000004 / format 7, no GUI variable records, and the known MainDeprotected initialization ECA. WCT format 1 with subversion 0x80000004. Helpers preserve unnamed MPQ payloads by name hash/locale. Use existing verified packaging rather than rebuilding archives from only visible filenames.

Collaboration manifests:

- Builder24/OwnedRegistrationSources-test01/registration-moves.json (exact blocks and owner/helper mapping)
- Builder24/StagedInitializerSources-test01/initialization-phases.json
- Builder24/StartupCleanupSources-test01/bootstrap-validation.json
- Builder24/StartupCleanupSources-test01/module-dependencies.json (static function references, literal ExecuteFunc targets, shared global users; not proof disabling is safe)
- Builder24/RegistrationAudit/compatibility.json
- Builder24/PROJECT_REQUIREMENTS.md (chronological requirements; later sections supersede earlier pending status)

## Unfinished priorities / suggested resumption

1. Confirm file access and read current candidate README + manifests; no need to re-read every historical experiment. State the current checkpoint briefly and continue.
2. User may provide gameplay results for StartupCleanup; do not require save/load or Save As just to proceed with independent work.
3. Clean numeric phase dispatch and remaining world/game-state setup, while preserving initialization ordering and keeping diffs auditable.
4. Use dependency report to design meaningful activation/disabling controls. Static ownership alone is insufficient: cross-module functions, globals, trigger handles, startup actions, and delayed callbacks matter. Editor-unchecking can remove function definitions entirely.
5. Make 1.32 support concrete. The editor-saved runtime added these native calls relative to r7: BlzSetTerrainFogDrawOverSky, BlzSetTerrainFogMaxLinearDensity, SetHDWaterParamsEx, SetPlayerRaceSkin, SetTerrainFogExV. These are audit candidates, not a complete compatibility verdict. Obtain/check actual 1.32 libraries and map format/object data; current compiler success is NOT 1.32 proof. Avoid blindly deleting calls or claiming support.
6. Improve repeatable direct build/finalization workflow and GUI integration if useful; most recent functionality is CLI tooling under Builder24, not necessarily exposed as GUI buttons.
7. Compare author's mapping when it arrives; user authorized continuing without it.

Do not restore old failed diagnostics as the working branch. Preserve latest tested maps and report limitations honestly. Account switching itself does not supply this conversation or workspace permissions: this file plus the project folder is the continuation mechanism.

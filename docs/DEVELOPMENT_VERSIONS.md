# Development test versions



From2026-11-05,the owner requests V1,V2,V3... for full development test maps. Current: V46 (FFERPG-V46.w3x, load verification and cleanup), next: V47. The current replacement backpack test is B17. Continue counting upward once per new full test build. Do not resume QuickUI100/QuickUI101 naming.



V1 is built from QuickUI99 with the production autosave repair. Includes all Dragoon,Thief,regional monsters and Ancient Forest work already in99. Same10minute autosave cadence after initial15minute load window,deferred busy/cinematic saves,unchanged profile writer/format. All objects,imports and monster/job gameplay match99. CreatureReview03g,master and productiongpair unchanged.



Builder:tools/build_v1.py;autosave implementation:tools/autosave100.py. Thirteen focused tests plus playable/editor/startup/source/globals/native-text/content/save-compatibility checks pass. Live autosave file timestamp and multiplayer confirmation pending. Installed in Warcraft Maps/Download/TEST as FFERPG-V1.w3x. Prior QuickUI tests are retained.



V2 (2026-11-06): aura-owner visuals, rooted ancient mobility/range, permanent spider family/stacked venom, active Cover Archers, delayed Infernal and non-rewarding mirror expiration. Includes requested Normal Icy Realm and Dark Dragon Marsh changes. Creature Review 03h rebuilt with -split for Broodling and readable current spell tooltips. See V2.md. Both installed in TEST; 26 focused tests and all map/editor/content/save gates pass. Native visual/AI/multiplayer acceptance pending. Production g/master/V1 preserved.



Standing owner instruction (2026-11-06): every requested production change must also be applied to the current full development project in the same task, while retaining development-only content. See AGENTS.md.



V3 (2026-11-06): V2 plus all accepted production h fixes: hidden Maiden Eye sight; aim-only item refresh; B/X latch and echo recovery; own-backpack/read-only-inspect separation; inspect tooltips outside the grid, revision-based refresh and saved-game singleton reconstruction; teleporter Cancel above HUD; staged/default-on autosave with first scheduled capture at20minutes then every10minutes. All V2 jobs/creatures/items/arenas/imports preserved; only aMEy object coordinates change. Source tools/build_v3.py. Installed TEST FFERPG-V3.w3x; next full version V4. Four focused timing/forwardport/content tests and all production/classic/dev map/editor/save/content gates PASS. Owner confirms preceding H02 single-player tests/autosave work; multiplayer explicitly not tried.



V4 (2026-11-06): loading-isolation candidate from V3 after modern h network desync on turn616. Suppress UI inventory reads during any profile restoration and defer affected hero gear reconciliation. Same fix as h Hotfix03; all development content retained. Four focused tests and both map/editor/save gates pass. Installed TEST; native multiplayer cause/fix unconfirmed. See LOAD_H03.md. Plain production h and classic unchanged.



V5 (2026-11-06): creature corrections; real mobile ancient definitions, rooted structure/collision toggling, Sylph Imperil30s,10% sustained Ice Beam, correct native breath order and800long/150to300cone, frost/fork/black flame art. Creature Review03i rebuilt. Full V4 load-isolation candidate retained; production unchanged. See V5.md. Native/multiplayer acceptance pending. NextV6.



V6 (2026-11-06): real temporary ground footprints for rooted ancients; review exhibit pathing enabled; icy native fire-breath model and dark Carrion Swarm Omni model; physical lifesteal3% and spell5%. Dusk breath preserved after owner acceptance. CreatureReview03j. See V6.md. Native/multiplayer pending; nextV7.



V7 (2026-11-06): restore ghosted review exhibits except rooted ancients; ribbon-free accepted Omni model, native wide Frost Breath art, Queen1900MP, cancellable/reentrant-safe Ice Beam with reduced status allocations;8read-only selected-unit stack badges using existing1Hz; requested difficulty factors replace legacy NPCspell factor once,123tooltips. CreatureReview03k rebuilt.8tests +map/editor/content/save gates pass. Native layout/visual/stability/MP pending. See V7.md; nextV8.



V8 (2026-11-06): Hotfix04 shared-load pause and private file-transfer hardening applied to V7, preserving all development content. Five focused tests and paired map/editor/save checks pass. Hotfix03 multiplayer failure recorded; V8/Hotfix04 multiplayer fix unconfirmed. See SYNC_H04.md. NextV9.



V9 (2026-11-07): Hotfix05 shared inventory-presentation snapshots, dirty item/load refresh on existing UI timer; preserves V8 gameplay. Badge aligned to bottom-right of buff bar, remaining Omni particle emitter omitted. CreatureReview03l rebuilt with collision enabled. Nine focused tests +all3map/editor checks +bothfullsave checks pass. Hotfix04 failed live multiplayer after loaded-player drop with another player unloaded; no local report for that incident. H05/V9 multiplayer and native visuals unconfirmed. See INVENTORY_H05.md. NextV10.



V10 (2026-11-07): recovery after owner H05 Squire-selection desync. Recommended production returns to byte-exact retained g (StableRollback filename, modern/classic). V10 restores fifteen corresponding pre-H V2 system libraries and removes H03/04/05 helpers, retaining every V9 object/import and creature/job/difficulty/arena change. H-era autosave/UI refinements intentionally rolled back. Source/runtime/asset parity, map/editor and save gates pass. No new live multiplayer guarantee. Review03m rebuilt from V10. See G_RECOVERY.md. NextV11.



V11 (2026-11-07): owner clarifies retain accepted Maiden Eye, teleporter and autosave; exclude later inventory changes. Built from V10 with ONLY travel_h02 +autosave_h02/twenty; object Maiden Eye fix already retained. All inventory/gear/F-G/preview/job/load/stat functions match rollback baseline. Production gRecovery01 modern/classic from retained g with same selective fixes. Six focused groups +all3map/editor/save gates pass. Latest combo not live-MPverified. Review03m unchanged. See G_RECOVERY01.md. NextV12.



V12 (2026-11-07): owner reports Recovery01 seems working; requests only Talents/panel/X drop flash. Exactlyonefunction Inventory94_ClearLocal changes: four talent/X hides and panel-open reset only during existing pause/cinematic flags. All other functions/assets unchanged fromV11; no newhelpers/globals/timers/getters. ProductiongRecovery02 samepatch onRecovery01;classic/review unchanged. Five focused checks +bothmap/editor/save gates PASS. Native visual and multiplayer unverified. See TALENT_FLASH_RECOVERY02.md. NextV13.



V13 (2026-11-07): Omni still has lines after emitter removals. Asset-only remove animated creature geoset520vertices from dark Carrion model, retain wave72+4vertices, remap GEOA/BONE associations. ALLscripts/objects/textures/otherassets unchanged fromV12. Review03n sameasset-only correction from03m. Binary/archive parity checks PASS; native appearance pending. ProductionRecovery02 unchanged. See OMNI_V13.md. NextV14.



V14 (2026-11-08): ownergNormalallcutscenesblank,noportrait,finishimmediately. PreQuest74dialoguefns identical; nullfilterseparate. Candidate removesInventory94CineEnterForceUICancel+guardsCine_OnSkipactiveflags. Twofnsmodern/dev,oneclassic;alltext/questdata/inventory/otherresources exact. Sixfocusedgroups +all3map/editor/save gates PASS. Native cause/rendering/MP unconfirmed. ProductiongRecovery03 pair samepatch,Review03nunchanged. See CINEMATIC_TEXT_RECOVERY03.md. NextV15.



V15 (2026-11-08): owner confirms actual workinggTEST/TESTER SHA9ca785, NOTlatestretainedg. Recovery03failsloadMP. Restore exact confirmedg FreshLoadguard/close/tick/init and canonical manual-save capture; retain defaultON/20then10 schedule on shared callback, existing guard gates capture, defer/startretry retained. All other Recovery03/V14features/assets unchanged. Six focused groups +all3map/editor/save gatesPASS; actualdesyncrootcause/MPunconfirmed. ProductiongRecovery04pair installed. AGENTS.md pinscorrectreference. See CONFIRMED_G_RECOVERY04.md. NextV16.





V16: 2026-11-08: Owner explicitly requested rollback of all inventory/loading/saving changes to the exact October 30 10:16 f. Completed Recovery05 modern/classic, V16 and CreatureReview03o; distinct files installed in TEST. Production restored whole dated f inventory/profile libraries; dev uses corresponding UI74 inventory controls with authored balance/stat readouts retained. All later Inventory94/FFL94/idle/six-slot helpers and autosave worker removed. Later 20/10/default-on autosave repairs deliberately rolled back. Existing save formats compatible. All four map/editor checks and three full-map save checks PASS; source identity/removal/archive/content checks PASS. Exact dated f TEST file untouched, SHA da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93. f and candidates NOT yet confirmed multiplayer-stable; no root-cause claim. See docs/F1030_INVENTORY_ROLLBACK.md and GRecovery05/installed.json. Current full development V16, next V17. Older hold and recommendations below are historical and superseded by this authorized rollback.



V16: 2026-11-08: Owner explicitly requested rollback of all inventory/loading/saving changes to the exact October 30 10:16 f. Completed Recovery05 modern/classic, V16 and CreatureReview03o; distinct files installed in TEST. Production restored whole dated f inventory/profile libraries; dev uses corresponding UI74 inventory controls with authored balance/stat readouts retained. All later Inventory94/FFL94/idle/six-slot helpers and autosave worker removed. Later 20/10/default-on autosave repairs deliberately rolled back. Existing save formats compatible. All four map/editor checks and three full-map save checks PASS; source identity/removal/archive/content checks PASS. Exact dated f TEST file untouched, SHA da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93. f and candidates NOT yet confirmed multiplayer-stable; no root-cause claim. See docs/F1030_INVENTORY_ROLLBACK.md and GRecovery05/installed.json. Current full development V16, next V17. Older hold and recommendations below are historical and superseded by this authorized rollback.


V17: 2026-11-08: Selective restoration completed on dated-f rollback: production Recovery06 modern/classic and full V17, installed distinct TEST names. User chose native backpack ownership/event routing, not synchronized UI state. Retained verified house7% HP/MP, hidden Maiden Eye, teleporterCancel, quest-null spacer filter, Legendary+10 and no Minus-unlock text. Restored NG+ by removing only action replacement; Blizzaga Gaya waves resolve to hero. Shared cinematic flags set before preparation and gate inventory/stat/UI entry callbacks before initialized getters; no Inventory94/FFL94/local catalogue/load isolation restored. Profile codec/capture/transport/load state machine unchanged. Autosave20min then10, defaultON/off respected, pending busy/cine, one capture/heartbeat through f FFL_BeginSave. Modern uses existing shared1Hz; classic adds one shared1Hz timer at startup; legacySave_Autosave routes same scheduler. Six behavior tests, all3map/editor/save checks, scope/archive/content PASS. Native/multiplayer/cross-bag cause and candidate fix UNVERIFIED. docs/SELECTIVE_F_RESTORE06.md; hashes GRecovery06/installed.json. CurrentfullV17,nextV18. CreatureReview03o/master/published maps unchanged.


V18: 2026-11-08: V18 + CreatureReview03p installed TEST; production Legendary-only Recovery07 modern/classic installed. Remove Forest Black Spider night spawn + Forest Devour eligibility; Highroad day/night retained, arenas/loot/hunt untouched. Whirlwind ngnv300 physical/sec; Aerial Assault ngnw120 wind/physical perbounce; ability/copied unit tooltips updated. Entire D7_Badge UI removed (8fns/globals/events/frame init/draw), stack gameplay and D7ReviewNoCollision/difficulty retained. Modern Legendary passives were classified as gear-only by Forsaken_ElementAbilityLevel; now native present passive matching A02F rank5..9 returns before item scans. Classic already native and no gameplay changes. LastStand/Focus/Adrenaline/Serenity/Spellbreaker damage-step tests PASS; +10cached, all5jobpassives, shrine switches and loaded default tests PASS across all3maps. Save records tier only, loads default+10, not selected upgrade; optional question pending/no format change. Eight behavior groups, all4map/editor and all3save gates +source/archive/pool/tooltip scopePASS. FullV18 EXACT7changedfns+8removed; unrelated Kalm/Gafgarion runtime inlining explicitly retained; inventory/autosave/profile/load/cine/arena unchanged. Review646exhibits436unique, no nspb unused/forest exhibit; Highroad rSP3 and arena preserved. Live gameplay/MP unverified. docs/V18.md; source-verification and installed.json in V18. CurrentfullV18,nextV19; prior builds/master preserved.


V19: 2026-11-08: V19 + CreatureReview03q + productionRecovery08 modern/classic installed TEST. Dark Marsh dragons select actual visible nonillusion hero800 and prioritize offense/fallback; Shadowdancer hero600 despite nearer pet. F99 AI and rooted Tree/AoW production require enemywithin2000; missed production resetsnow+5, no catchup. Mastery A02F Ihid5..9 false with native DataD pointer4 (rank1hidden). Userconfirmed keep saveformat/reselectLegendary upgrades afterload. Furthersteering: native6slots hero/Gaya wave preview restored ONLY75/slots76/77 delta onto currentTEquip withCinegates; noIdle76/staticcatalogue/loadguards. Broad HideInventory removed frompoll, explicitcloseonlyownboundtrio; noallcontext scan. Cross-bag cause/fix remainsUNVERIFIED. NG+XP factor1+.1*count (NG9+90%); monsters/bankedcredit, questReward and BPconversion; bankredeem/deathpenaltyunchanged. Visible zero-effectselfaura aE19/bE01..10 hero/Gaya viaexistingstats2s; verifiedTomeOfRetrainingDDS. Existingstatsone-shot rearmedbeforeCineguard toresumeaftercutscene. NOsave/load/capture/transport/autosaveformat changes or newgameplaytimer. 7AI/object+9session/previewtests, all4map/editor/native-text and all3savefixturesPASS; scope/object/archive/readbackPASS. Native/MP notguaranteed. docs/V19.md; V19/source-verification.json and installed.json. CurrentfullV19,nextV20; allpriorbuilds/master/publishedmaps preserved.


V20 (2026-11-08): V19 plus global cinematic handoff before selection, staged 10Hz automatic capture, order-routing/panel recovery and native creature cast/copy fixes. Production Recovery09 modern/classic and CreatureReview03s. See V20.md; live multiplayer/native behavior pending.


V21 (2026-11-09): Two-function native backpack display correction from V20, also production Recovery10. Live-pane authority and missing-backdrop fallback keep Talents/X/Move and board hiding aligned. See V21.md. Native/multiplayer confirmation pending; classic/review unchanged.


V22 (2026-11-09): Native bound-pane recovery candidate and model-free F/G cooldown rendering, remaining cinematic callback gates. Production Recovery11. See V22.md. All gameplay/profile/objects/imports preserved; native/multiplayer pending. Classic/review unchanged.


V23 (2026-11-09): Owner rejects V22/Recovery11. From V21/Recovery10, retain native models and no forced-pane recovery; complete common cinematic input/model/image/timer suspension and resume, explicit owner-input early exits. Production Recovery12 modern/classic. Native cross-player bag closure still unresolved. See V23.md.


V24 (2026-11-09): Recovery12 failed multiplayer; owner says single-player equipped scene works. Diagnostic only: from V23 change UI hide/show fade to0, production Recovery13 same. NativeInventoryCheck02 isolates native bags/equipped cinematic without custom UI/polling. Both issues unresolved; see RENDER_INVESTIGATION24.md. Do not promote as stable.


V25 (2026-11-09): NativeCheck02 confirms cross-closing even after -bare; its equipped scene passes without F/G. Regular-frame F/G candidate from V23 (normal fade), production Recovery14; normal icons/keys/model/cast paths retained. NoFG-Test full-production companion isolates dock from other UI. Native acceptance pending. See V25.md.
2026-11-11 V37 applies regional creature balance, reduces Ancient Forest per-hit refresh work, and corrects dragon breath AI. Rebuilt Creature Review 03t (646 exhibits) and Arena Creature Test 01 (188 teams, ten cups and Special Battles) from V37. All three installed and hash-verified in TEST. Map/editor checks, four creature regressions and V37 save compatibility passed. In-game casting and performance await playtesting.

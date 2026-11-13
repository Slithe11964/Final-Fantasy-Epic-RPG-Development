2026-11-10 Autosave stuck reported published h, NG+10 extensive plus earlier player, last autosave30min, -unstuck helps (cycles cine/resumes profile timers). User requests60sec cleanup and capture mutation safety. hSave01 from canonicalh +V36fromV35 built/installed: existing shared scheduler drains completed captures, expires softautosave60active sec excludingcine, aborts writer, releases lock/requeues30sec; retrybackoff/failedstart skips tootherplayer; capture/exportfailuresretry10sec. FRC_Timeout clears stalled decoder Busy before ownedwriter Abort. Profile existing timers explicitly rearmed afterscene, watchdogremaining preserved. Sixexistingfns+oneusedcallback-order helper only; no newtimers/globals/codec/UI/inventory changes. Seven regression tests incl drop/move/property rejection, queue progress, timeout/cine/load exclusion, export failure, resume PASS. Both finalmap/editor/startup/source/globals/text+savecompat PASS and archive/runtime isolation. ActualNG+10/native/MP pending. Canonicalh/classic/master/review preserved. CurrentV36,nextV37. docs/V36.md.
2026-11-10 Owner: native Check03 cross-closes in all attempted modes; 04 also appeared to cross-close but looked native, no Drop held item. 04 replacement not established as exercised. Standalone Backpack05 removes ASpc from Zi78/zi78 object ability lists, retains fBag/fGer/storage, splits shared slot setup into 15-slot batches, distinct Test Bag 05 and X 05, explicit -bagstate open/visible/slots/native-levels/transitions. No additional timer/poll/gameplay/item/sync changes, no RPG integration. Map/editor/startup/source/globals/text and 5 existing boundary tests PASS; native/MP pending. docs/INDEPENDENT_BACKPACK05.md. h/hDialogue01/V35 untouched.
2026-11-10 Owner confirms rebuilt h multiplayer test great incl repeated Kalm. Requests restore animated dialogue. Separate hDialogue01 +V35 restore90 original nonnull Text_Say speaker calls from QuickUI30 (Kalm1=19,2=23,3=39,Gilgamesh=9 incl summon/combat/exit). Current text/forced/order matches; genuine narration kept. No shared Text/Cine/UI/inventory/save changes, runtime direct call edits preserve optimized wave/summon logic; unrelated archive exact. Both map/editor/startup/source/globals/text PASS. Restored-portrait native/MP pending; tested canonical h retained. CurrentV35,nextV36. docs/V35.md.
2026-11-10 Owner confirms hUI06 works great in SOLO incl post-cutscene controls; multiplayer testing starts next, PENDING. At explicit request, label-only UI06 packaged as canonical modern 0.9.7.5h, installed TEST/FFERPG-0.9.7.5h.w3x. VersionHUI0620261110 manifest/installed.json, prior canonical modern map/j/json/README preserved before-promotion. Non-string script and unrelated archive exact; authored description/Discord/loading credits exact; all map/editor/startup/source/global/text gates PASS. No new gameplay/UI changes, classic untouched (modern-only fix). Development remains V34 same UI06 logic, next V35.
2026-11-10 UI05 owner: works before cutscene, missing companion controls/boards overlap after. Native cache live yes/yes/yes, contextyes, cine/inspectno, wantedyes but lastopenno. Stale native handles not supported by this sample; stopped heartbeat vs aborted helper unproven. UI06/V34 candidate ONLY C20_UIPause/C20_UIResume/QuickGear_Diagnostic: detect existing repeating timer by lifetime (other pause is destroying reset), restart SAME .1 UI72_Tick timer before optional control/layout restores; existing paused guard/gates retained. Explicit timer diagnostic. No new timer/pollstream, no inventory/cast/save/game/renderer changes. Both map/editor/startup/source/globals/text+builder isolation PASS. Native/MP pending. Current V34,nextV35. docs/V34.md.
2026-11-10 UI04 owner screenshot: all companion handle IDs nonzero, cache1/1/1, open=no despite visible bag. Startup-incompletion hypothesis NOT supported; no fix acceptance. UI05/V33 narrow candidate: move existing isolated Forsaken_PollPanels before gear helpers in UI72_Tick; add explicit -gearcheck cached live visibility/context/cine/inspect readout. Prior-helper abort hypothesis UNCONFIRMED. ONLY2functions, no globals/timers/discovery/pollfrequency/game/item/save/cast/renderer changes. Builder unrelated function/archive and authored strings parity PASS; both map/editor checks PASS. Native/MP pending. Current V33,nextV34. docs/V33.md.
2026-11-10 Owner confirms hUI03 F/G visible/casting at correct right position; missing Talents/X/Move and boards overlap. Separate hUI04/V32 candidate changes ONLY Register_Forsaken_PanelAccess (ExecuteFunc isolate existing backpack/gear setup), debug-loop index reset and explicit -gearcheck setup/cache diagnostics. Startup budget hypothesis UNCONFIRMED. No new timer/poll or visibility/game/input/save/cast/renderer changes; UI03 F/G exact. Both all map/editor/startup/source/global/text gates and builder scope/archive/description checks PASS. Native/MP pending; current V32 next V33. docs/V32.md.
2026-11-10 UI Layer03 owner-confirmed bottom-right position(.812,.085), .04square/.046gap. Layer01solo startupcrash sameCRenderBatchRVA2c5ed4, fixture02aboveonly, fixture03rightvisible. Fixture04 nativeLeaderboardhost regularTEXT+STATUSBARcooldownmodel survived .5fade solo scene, hidandreturnedbutCOMPARISONmodebugreturnedABOVE; NOTpostsceneplacementacceptance. Built+installedSEPARATEhUI03+V31 fromhUI01/V29: ONLYQuickGear_Init/QuickGear_Layout/QuickGear_Poll+2UIglobals. Sharedone-timepersistentnativeleaderboardhost, preserveplayerboardassociation, hidehostdecorations; localexistingpollonlyrestoreemptyhostwhenwanted, no gameplay/localalloc/timers/cast/input/inventory/savechanges. Fixedconstantconfirmedcoords. Bothallmap/editor/startup/source/globals/textchecks+archive/runtimeisolationPASS. Fullnative/MP/bag/Hunt/Festival/CDacceptancePENDING. Canonicalh/classic/master/reviewpreserved. V30uninstalleddiagnostic; currentcandidateV31,nextV32. docs/V31.md.
2026-11-10 UI Layer01 native solo startup CRASH confirmed report12.00.17 16de141c, War3Log exactfixture; same native CRenderBatch fault RVA0x2c5ed4. NOT an RPG load/autosave/poll reproduction. Seven layouts all created at startup means culprit unisolated. Do not promote. UI01 actual F12 log retrieved: wanted/root/active/anchor yes; ancestor3hidden unnamed; root parent visibility semantics not proven causal. UI Layer02 separate single regular FRAME tree under WORLD_FRAME, only two BUTTON/BACKDROP children; no fonts/models/SIMPLEFRAME/TOC/board/cross-tree anchors/polls. Compiles allgates, installed QA; native testpending. h/V29 unmodified; V30/hUI02 earlier diagnosticbuiltNOTinstalled.
2026-11-10 owner clarification: In modern h, F/G buttons are invisible BOTH with backpack OPEN and CLOSED, including own hero selected. Hotkeys still work. Do not treat bag-open visibility as the trigger or add bag-dependent fixes from this report. Actual root/ancestor visibility still unknown; hUI01/V29 -gearcheck Gear UI/UI parent readout pending. No additional code/map changes from this clarification.
2026-11-10 owner forbids replacing authored map description/Discord and test explanations in labels. COMPLETED exact dated-f WTS38790 and loadingtext005 restoration across14recentcanonicalmaps+10existinginstalledcopies; no lockpending. Compact names(FFERPG V28 etc), loadingtestpurpose subtitle removed, no codeotherthanstring changes; all14map/editor checksPASS and archive/nonstringparity. DescriptionRestore20261110/installed.json+before-restoration backups. Future helpers/builders corrected to preserve description; technicalnotesonlyworkspace. docs/DESCRIPTION_RESTORE_20261110.md. OVERRIDES earlier requestinterpretation broad labels. Latestowner also confirms hBUTTONSENTIRELYINVISIBLE,hOTKEYSWORK: portraitparentrendercandidateFAILEDvisibility; no crash/MP inference. Optional question pending: invisible bagclosed ownhero selected too? Installed SEPARATE hUI01 andfullV29diagnostic fromtext-restoredh/V28: ONLYQuickGear_Init/Diagnostic/Reset changed, cachemax8existingancestorframes/names inSHAREDstartup, countinvalidatedreset; existing -gearcheck printswanted/root/active/anchor andcachedancestorvisibility/sizes. No local frame/parent/name lookups added, no poll/timer/UIcreation/renderer/cast/input/sync/item/save/scene/gameplaychanges.2focused tests +bothfinalmap/editor/startup/source/globals/textPASS. Usercanrunsolo -gearcheck/sendGearUI+UIparentlines. DiagnosticNOTfix,noproductionhpromotion. Old h-Hotfix01 name collision detected BEFORE anywrite; usedunique H20261110UI01/FFERPG-0.9.7.5h-UI01.w3x. CurrentfullV29nextV30. docs/V29.md; V29/installed.json. Allpreviousmaps/master/classic/reviewpreserved exceptexplicittextrestoration.
2026-11-10 owner rejects abovecommand position(Recovery16/V27), supplied screenshot original F/Grightofspells; explicitly requests this versionh. Intermediate Recovery17 from16 +V28from27 changeONLYQuickGear_Init rootparent existingnativeportraitparent (sharedstartup lookup, no nativeframe alteration) +QuickGear_Layout exactoriginalcommand7right+.012, same.04/.046controls. Tasyen primary guidance supports portraitparentoutside4:3;ConsoleBackdrop lowerlayer explanation; nativeactualunverified. KeepC20resume reapplylayout/hide/disable/model/types/allcasting+sync+item+save+timers exact. Package requested canonical0.9.7.5h modernlabelonlyfrom17; classic1.29.2labelonlyfromClassicRecovery12(samematchinggameplaybaseline,modernframechangesnotapplicable),NOT oldhfailedguards. FullV28labelFFERPG V28 - 0.9.7.5h retainsallcontent. All3finalnative/editor/startup/source/global/textPASS incl1.29.2actualcommon/blizzard. Allnonstringtokens+unrelatedarchivepayloadparityPASS. Correctallinternalidentities. PublishedTESThpair+V28; earliercanonicalhpair+sidecars/prepromotionV28preservedVersionHRightDock20261110/before-promotion. docs/V28.md +installed.json. CurrentfullV28nextV29. Intermediate17notinstalled. Nativeclipping/CD/postscene/MPacceptancePENDING; userversionnamehNOTstabilityproof. Nativebackpackcrosscloseunresolved,prototypesnotintegrated. Prior14twoscenepasshadinvisiblebuttons. Older tests/master/review03s preserved.
2026-11-10 Recovery15 owner result: about1/3gearicon visible behindnativeUI, then invisible afterscene. No MP/crashstability inference. Built Recovery16 from labelled15 + fullV27 fromlabelled26. ONLY3nonlabel functions: QuickGear_Init regularroot backunderGAME_UI; QuickGear_Layout absolute(.748,.265)size(.040,.086), within4:3x.748-.788,y.179-.265 aboveconsole.176; C20_UIResume reapplylayoutbeforeexistingtimerresume. No ConsoleUIBackdrop ancestor dependency, nativecommandanchor gone. Exactregular types/icons/key/model/cooldown/input/casting/sync/UIpollfrequency/inventory/save/autosave/cineentry+exit/fades/gameplay/objects/imports preserved. Displayheader/scenario/loading/welcome/scoreboard/diagnosticsactualRecovery16/V27.2focused lifecycle tests+bothmap/editor/startup/source/globals/textPASS; editornewlinenormalizationcaught/fixedbeforeinstall,intermediatearchived. Nativevisibility/CD/postscene/MPacceptancePENDING. Nativecrossbagstillunresolved; native03/independent04NOTintegrated. docs/V27.md; V27/installed.json. CurrentfullV27nextV28. Earlier mapsincluding15/Labeled preserved;classic12/review03s/masterunchanged.
2026-11-10 display identity fix: Eight current tests relabeled across HM3W header, scenario/WTS map name, loading title/subtitle, existing welcome/scoreboard/F-G diagnostics and standalone help/F9 title. Found V26 still WTS V7 plus welcome/board0.9.7.5d. No gameplay edits: all non-string JASS tokens identical, unrelated archive payloads exact; all8 playable/editor/startup/source/globals/text checks PASS. Installed in existing TEST/Current Test/TESTER locations and updated matching release copies. Recovery15 original is locked by active Warcraft, so it remains unchanged; NEW Current Test/FFERPG-0.9.7.5g-Recovery15-Labeled.w3x has corrected labels and identical gameplay. Use that copy next session. Exact pre-label maps+sidecars preserved TestMapLabels20261110/before-labels; manifest+installed.json before/after hashes/actual locations. docs/TEST_MAP_LABELS_20261110.md. Current full remainsV26 nextV27; no fix-status promotion. Standing packaging requirement: every future build must label INTERNAL scenario, loading screen, welcome, scoreboard and diagnostic prefixes with its actual version/test identity, not just filename/header. tools/test_map_identity.py reusable; verify actual internal strings before installation.
2026-11-09 correction: Owner clarifies Recovery14 F/G HOTKEYS WORK BUT BUTTONS ARE INVISIBLE. Two equipped multiplayer scenes passed without visible dock; do NOT claim actual visible-widget/cooldown-model rendering passed. Built Recovery15 from14 and full V26 from25: ONLY QuickGear_Init root owner expression GAME_UI origin -> BlzGetFrameByName(ConsoleUIBackdrop,0), native regular backdrop supporting outside4:3 display, lookup shared startup. Exactly one expression; all other functions/globals/timers/messages/input/casting/saves/inventory/cinematic/model/types/anchors/objects/imports/content unchanged, archive/function parity enforced. Four frontend tests and both map/editor/startup/source/globals/text PASS. Native visibility/cooldown/MP acceptance pending; no crash fix claim. Native backpack crossclose still unresolved; independent04/native03 NOT integrated. docs/V26.md; V26/installed.json. Current full V26 next V27;14/25/classic12/review03s/master/prior files preserved.
2026-11-09 owner live result: Recovery14 survived two multiplayer cutscenes with mage items equipped; testing ended because the other participant left. This is a limited multiplayer pass, not extensive stability confirmation, and does not prove the first corruption cause. V25 carries the same frontend implementation but has not separately received this live confirmation. Owner wants visible gear hotkey buttons and/or clear cooldown displays retained. Preserve the Recovery14 regular-frame F/G implementation and original animated cooldown display in future full-map work; hide/disable during scenes and restore afterward. NoFG remains diagnostic only; do not adopt its missing dock for production. Independent Backpack04 deliberately lacks F/G as a standalone bag prototype; a full replacement must integrate visible gear/cooldown controls. No map rebuild or release promotion from this report. Current full V25, next V26; native backpack cross-closing unresolved.
2026-11-09 backpack follow-up: Owner authorizes an independent replacement panel if it retains native appearance, still prefers native fix. Built separate NativeCheck03 (allied/shared vision off default; -baseline/-visionoff/-isolated synchronized modes; unchanged native UI/objects/no polls) and IndependentBackpack04 (one precreated regular frame tree, native item storage, ASpc removed shared startup; cached shared event-driven item data; local-only view state; validated synced item moves/equips/drop). PROTOTYPES ONLY: no production/dev source/map changes. Current V25 next V26 unchanged. Native03 hypothesis unproven; Independent04 appearance/portrait/native extended-slot/ring movement/MP/casting integration unverified; NO RPG talents/F-G/casting/saves in standalone. Five executable boundary tests + both playable/editor/source/startup/globals/text checks PASS. Windows automation runtime initialization failed (kernel assets missing path), so no live native visual QA. docs/INDEPENDENT_BACKPACK04.md. Never claim fix from compile/mocks, and do not forward to full maps before native/MP evidence. Installed distinct TEST maps; manifest InventoryPanel04/installed.json. Prior maps/master preserved.
2026-11-09: Owner NativeCheck02 result: bags stillcrossclose; -scene withmagegear worked, notesF/Gnotpresent(intentional). Followup BOTH-bare stillcrossclose -> native/config reproduction independentofcustomUI/poll/F-G and mageitems. No verifiednative-preservingfix, doNOTaddpane-reopen orclaimguardfix. docs/NATIVE_BACKPACK_REPRO.md preparedlocalNOTsent. FullsceneFGintegrationstillunprovenlead. V25/Recovery14 fromV23/Recovery12 (normal.5fade, NOT13/24): ONLYQuickGear_Init/Reset/RepaintIcons changed to regular FRAME/BUTTON/BACKDROP/TEXT FG controls, sameiconpaths/keys/coords/nativeSTATUSBARmodel; modelnowchildregularoverlay, child-firstreset; inplaceiconupdate no rootflash. NOsave/profile/inventory/cast/send/receive/targeting/rune/CDlogic/timer/message/gameplay/object/import changes. NoFG-Test productioncompanion removesFGframesfromstartup+Poll/Requestnoops, preservescommonUI72heartbeat/backpackbuttons/otherUI forisolation; diagnosticonly.4focusedtests+all3map/editor/startup/source/globals/text +archive/runtimeisolationPASS. Nativeappearance/input/MP/cutsceneacceptancePENDING; doNOTpromoteasstable. Installedall3TEST; V25/installed.json. docs/V25.md. CurrentfullV25nextV26. ClassicRecovery12/review03s/master/prior maps preserved. ExistingBlzGetItemAbilityByIndex UIstathelpercalls localityleadUNPROVEN andunchanged.

2026-11-09: Owner confirms Recovery12 still crashes/desyncs on equippedmagecutscene AND bags crossclose; explicitanswer SAMEGEARSCENEWORKSINSINGLEPLAYER, multiplayerrequired. Latest13.26.32report modernRecovery12 sevenhumans ACCESS_VIOLATION sameRVA2c5ed4 asRecovery10. Read-only minidump AMD64 context +matchingPE RTTI: R12 CRenderBatch, stack+20 CSimpleTop, stack+0 BATCHEDRENDERFONTDESC allocator; fault mov[rdi+20],ebx, RDI0100000000000010. NativeUIrenderbatch failure, NOTidentifiedfirstcorruptingoperation/widget, notprovenJASS/nativegettercause. tools/analyze_render_crash.py, RenderInvestigation20261109/evidence+analysis. ExpandedlocalUIgraph116fns noexplicitframe/unit/group/timercreation/frame-lookups; DOESinclude BlzGetItemAbilityByIndex in3stathelpers Active/Element/StatUncached; localityleadunproven, doNOTclaimnohandlegetters. NativeInventoryCheck02 exactRec12mageitems/abilitydefs, eighttesters99+autoIceWandU/Depths; NOcustomframeAPI/F-G/poll/RPG/save/sync, oneinitoneshot. -scene3s .5UI fade, -instant0fade, -bare/-mage calleronly. Need2humans, no loadcode. Recovery13/V24 DIAGNOSTICONLY changeexact2ShowInterfaceconstants .5->0, allnormalF/Gmodels/renderer/item/profile/gameplay/scene content preserved. All3map/editor/startup/source/globals/textPASS+archiveisolation. Nativebagroot/fix andrendertransitionhypothesisUNCONFIRMED; no stableproductionpromotion. Installedall3inTEST, RenderInvestigation20261109/installed.json; docs/RENDER_INVESTIGATION24.md. LatestfullV24 diagnostic,nextV25. Classic12,Review03s,master/prior maps preserved.

2026-11-09: Owner REJECTS Recovery11/V22 pane-restoring workaround and changed cooldown renderer; explicitly go back10. Recovery12 modern/classic + V23 built from Recovery10/V21 (classicRecovery09). Native renderer/models/Icon/UI21observer and close/toggle remainexact; NO Bag22/forced pane reopening. Common CineEnter all309+scenes: existing shared flags/timers/gear-event/profile/cooldownpause before selection retained. Add22controltrigger snapshotsDisable/Enable, actualF/GbuttonDisable/restore, explicitstandalonemodel+texture hiding, exhaustive previewimage/rune hide, queuedCarryDrop/UIRebuild defer, remaininggetterentrygates. ExistingChronicles anonymous1s timer nowcapturedsameallocation andpaused/resumed; shielddisplaytimerpaused/resumed. Queuedpassive/statsevent cannotrearmduringcine; sharedDirty schedulesfreshstatsatExitwhenneeded. No waits/scene/content/codec/autosave/routingchanges. Explicitremoteplayer rejection beforehero/frameaccess ininputcallbacks/helper. CRITICAL nativecross-playerbackpackclosure remainsUNRESOLVED; existingownerchecks +mockaudit doNOTproveengine independence, no verifiednativeworkaround. 9testsallPASS; all3map/editor/startup/source/global/native-text and source/profile/archive/rendererparityPASS. Native cutscene/MP acceptancePENDING. docs/V23.md, V23/source-verification.json, installed.json. CurrentfullV23nextV24. Review03s/master/prior maps preserved;11/V22notrecommended.

2026-11-09: Owner confirms crossbag persists; castable wand+book basicintro crashes. Latest12.02.13report ACCESS_VIOLATION inRecovery10,notprovenJASS/desynccause. V22/Recovery11 fromV21/Recovery10: presentation-only Bag22 cached verifiedliveownpair restored iff unexpectedlyhidden+sameownheroselected+openintent+ninspect/ncine; max1attempt/sec, explicitB/X/ESC/resetcleararm, existing.2sclose-settle. NoForceUI/framecreate/lookup/itemread/rebind inrecovery. Nativebinding preservation/MP unverified; doNOTclaimenginefixed. Native gear STATUSBAR cooldownmodels removed (oldroot-hiding missed standalonewheels); existing65radialTGAs render samedeadline+numbers, noextratimer/frame/assets. Cinematic hide defensivelegacywheel/error/pendingclear; 8remaininghover/command/spell/iconcallbacks gatedbeforegetter. No scene timing/waits, game/item/unit/ability/profile/save/autosave/routing changes. ONLYTEquip2resources15existingfunctions+6privatepresentationglobals; unrelatedruntime/archiveexact. 8tests+bothmap/editor/startup/source/globals/textPASS. docs/V22.md; evidenceCrash/log; installed.json. CurrentfullV22nextV23. ClassicRecovery09,Review03s,master/prior maps preserved. NativeMP/cutsceneacceptancePENDING.

2026-11-09: Owner Recovery09 open-bag own-hero-selected item housepickup/drop hides Talents/X/Move and restores boards; ESC/reopen recovers. V21 + production Recovery10 installed distinct TEST names. ONLY Forsaken_BackpackVisible and Forsaken_PollPanels changed: either live contentpane counts as open, decorative backdrop not prerequisite, stale explicitclosed no veto, fallback anchor livegear/bag retained throughpoll. Ownership/selection/inspect/cine gates unchanged. No native frame show/lookup/create, inventory/item/unit/stat/gameplay/save/autosave/gear hotkey/event routing/timer changes. All other archive payloads and runtime functions exact baseline V20/Recovery09. Seven tests incl actualold rejection/new recovery, bothmap/editor/startup/source/globals/native-text checks PASS. Native cause/path and multiplayer fix unconfirmed. Classic Recovery09 unchanged (no native panels); CreatureReview03s/master/prior files preserved. docs/V21.md; V21/installed.json. Currentfull V21,next V22.

2026-11-08: V20 / production Recovery09 modern+classic / CreatureReview03s built from V19/Recovery08. Shared cinematic entry pauses existing stat/hero/UI/inventory/profile capture+poll/cooldown timers and disables gear events BEFORE unit pause/selection; closes/hides bag, F/G, talents/X/Move/inspect; resumes original active states on exit, defers bag rebinds; queued callbacks and save/load commands gated. No ForceUICancel. Profile clock/network transport retained. Autosave uses existing staged FRC_Start at 10Hz, watchdog60, shared validation retry10s; old synchronous400step pump retained only for manual capture. Schedule20/10 default-on and codecs unchanged. OnEquip ordinary order fastpath only CarryOrder; no worn ability rescans on move/attack/spell orders. Native panel adoption short rejection removed; own/inspect guards retained. Cross-bag cause/fix UNVERIFIED. Dev dragons use native h01B proxy casts against hero, real mana/CD only on accepted order; Shadowdancer native item-target wand iC20/zCI9 enemy hero copy with type check/owner cleanup. No real hero item changes. 11 focused tests, all4 map/editor/text checks, all3 save checks and scope verification PASS. Actual report AV does not prove exact desync cause. Native AI/cutscene/MP/smooth autosave unconfirmed. docs/V20.md, source-verification.json, installed.json. Current full V20, next V21; prior maps/master preserved.

2026-11-08: V19 + CreatureReview03q + productionRecovery08 modern/classic installed TEST. Dark Marsh dragons select actual visible nonillusion hero800 and prioritize offense/fallback; Shadowdancer hero600 despite nearer pet. F99 AI and rooted Tree/AoW production require enemywithin2000; missed production resetsnow+5, no catchup. Mastery A02F Ihid5..9 false with native DataD pointer4 (rank1hidden). Userconfirmed keep saveformat/reselectLegendary upgrades afterload. Furthersteering: native6slots hero/Gaya wave preview restored ONLY75/slots76/77 delta onto currentTEquip withCinegates; noIdle76/staticcatalogue/loadguards. Broad HideInventory removed frompoll, explicitcloseonlyownboundtrio; noallcontext scan. Cross-bag cause/fix remainsUNVERIFIED. NG+XP factor1+.1*count (NG9+90%); monsters/bankedcredit, questReward and BPconversion; bankredeem/deathpenaltyunchanged. Visible zero-effectselfaura aE19/bE01..10 hero/Gaya viaexistingstats2s; verifiedTomeOfRetrainingDDS. Existingstatsone-shot rearmedbeforeCineguard toresumeaftercutscene. NOsave/load/capture/transport/autosaveformat changes or newgameplaytimer. 7AI/object+9session/previewtests, all4map/editor/native-text and all3savefixturesPASS; scope/object/archive/readbackPASS. Native/MP notguaranteed. docs/V19.md; V19/source-verification.json and installed.json. CurrentfullV19,nextV20; allpriorbuilds/master/publishedmaps preserved.

2026-11-08: V18 + CreatureReview03p installed TEST; production Legendary-only Recovery07 modern/classic installed. Remove Forest Black Spider night spawn + Forest Devour eligibility; Highroad day/night retained, arenas/loot/hunt untouched. Whirlwind ngnv300 physical/sec; Aerial Assault ngnw120 wind/physical perbounce; ability/copied unit tooltips updated. Entire D7_Badge UI removed (8fns/globals/events/frame init/draw), stack gameplay and D7ReviewNoCollision/difficulty retained. Modern Legendary passives were classified as gear-only by Forsaken_ElementAbilityLevel; now native present passive matching A02F rank5..9 returns before item scans. Classic already native and no gameplay changes. LastStand/Focus/Adrenaline/Serenity/Spellbreaker damage-step tests PASS; +10cached, all5jobpassives, shrine switches and loaded default tests PASS across all3maps. Save records tier only, loads default+10, not selected upgrade; optional question pending/no format change. Eight behavior groups, all4map/editor and all3save gates +source/archive/pool/tooltip scopePASS. FullV18 EXACT7changedfns+8removed; unrelated Kalm/Gafgarion runtime inlining explicitly retained; inventory/autosave/profile/load/cine/arena unchanged. Review646exhibits436unique, no nspb unused/forest exhibit; Highroad rSP3 and arena preserved. Live gameplay/MP unverified. docs/V18.md; source-verification and installed.json in V18. CurrentfullV18,nextV19; prior builds/master preserved.

2026-11-08: Selective restoration completed on dated-f rollback: production Recovery06 modern/classic and full V17, installed distinct TEST names. User chose native backpack ownership/event routing, not synchronized UI state. Retained verified house7% HP/MP, hidden Maiden Eye, teleporterCancel, quest-null spacer filter, Legendary+10 and no Minus-unlock text. Restored NG+ by removing only action replacement; Blizzaga Gaya waves resolve to hero. Shared cinematic flags set before preparation and gate inventory/stat/UI entry callbacks before initialized getters; no Inventory94/FFL94/local catalogue/load isolation restored. Profile codec/capture/transport/load state machine unchanged. Autosave20min then10, defaultON/off respected, pending busy/cine, one capture/heartbeat through f FFL_BeginSave. Modern uses existing shared1Hz; classic adds one shared1Hz timer at startup; legacySave_Autosave routes same scheduler. Six behavior tests, all3map/editor/save checks, scope/archive/content PASS. Native/multiplayer/cross-bag cause and candidate fix UNVERIFIED. docs/SELECTIVE_F_RESTORE06.md; hashes GRecovery06/installed.json. CurrentfullV17,nextV18. CreatureReview03o/master/published maps unchanged.

2026-11-08: Owner explicitly requested rollback of all inventory/loading/saving changes to the exact October 30 10:16 f. Completed Recovery05 modern/classic, V16 and CreatureReview03o; distinct files installed in TEST. Production restored whole dated f inventory/profile libraries; dev uses corresponding UI74 inventory controls with authored balance/stat readouts retained. All later Inventory94/FFL94/idle/six-slot helpers and autosave worker removed. Later 20/10/default-on autosave repairs deliberately rolled back. Existing save formats compatible. All four map/editor checks and three full-map save checks PASS; source identity/removal/archive/content checks PASS. Exact dated f TEST file untouched, SHA da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93. f and candidates NOT yet confirmed multiplayer-stable; no root-cause claim. See docs/F1030_INVENTORY_ROLLBACK.md and GRecovery05/installed.json. Current full development V16, next V17. Older hold and recommendations below are historical and superseded by this authorized rollback.

2026-11-08: Owner explicitly requested rollback of all inventory/loading/saving changes to the exact October 30 10:16 f. Completed Recovery05 modern/classic, V16 and CreatureReview03o; distinct files installed in TEST. Production restored whole dated f inventory/profile libraries; dev uses corresponding UI74 inventory controls with authored balance/stat readouts retained. All later Inventory94/FFL94/idle/six-slot helpers and autosave worker removed. Later 20/10/default-on autosave repairs deliberately rolled back. Existing save formats compatible. All four map/editor checks and three full-map save checks PASS; source identity/removal/archive/content checks PASS. Exact dated f TEST file untouched, SHA da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93. f and candidates NOT yet confirmed multiplayer-stable; no root-cause claim. See docs/F1030_INVENTORY_ROLLBACK.md and GRecovery05/installed.json. Current full development V16, next V17. Older hold and recommendations below are historical and superseded by this authorized rollback.



LATEST2026-11-08: STOPPATCH/FREEZE. OwnerRecovery04SprintShoesBUYdesyncNOLOAD;ownerpanelsclosed,othersunknown;14:33:37/38reports7playerssamegame turns5481/5544Recovery04. THEN EXACToldgTEST/TESTER9ca785alsoDESYNCafterCHARLOAD,14:41:05reportturn1535sevenplayers (NOTaccessviolation). PriorstablebaselineclaimREVOKED. No newmodifiedmap/candidate/fallbackinstalledafterthese;workspaceConfirmedGOriginalcopyhistoricalnotstable. SprintShoeobjectsI00E/f003/q003/A0MU+genericpickup/conversioncodeexactg;commoninventory/passivehandlingLEADNOTCAUSE. OwnerNOWgoingBEFOREUI96 totrycontrol. Holdchangeswhiletesting,pinactualfilehash(notjustglabel);workspacehistory/2026-11-04-before-ui96g iscandidatebackupbutuserfileidentityunconfirmed. docs/MULTIPLAYER_BASELINE_HOLD.md;reports/auditConfirmedGOriginal/evidence andsprint-shoes-audit.json. AGENTSupdatedhistoricalrefNOTsafe. CurrentdevV15preserved/frozen,nextV16onlyifactualchangeauthorized/justified;Review03n/masterallcontentpreserved. DoNOTclaimWarcraftenginecauseorUI96causefromunprovencontrol.



LATEST2026-11-08: 6MPFAILS,Recovery03loadedotherguydesync. CRITICALFOUNDWRONGBASELINE: ownerYES TEST/TESTER/g isworking (SHA9ca78509bad9e88a436a8871a407567dd1b813bd40f6fdacf5428c87ab089844,13,850,451;matcheshistory/2026-11-05-before-autosave). LatestreleasegSHAf6e884ISNEWERhasauto100changes;olderStableRollbackcopyNOTconfirmedstable. AGENTS.mdnowpinscorrecthash. Latest03:55reportturn2023sixplayerSDh-TEST SHA45516matchesRecovery03;preservedGRecovery04/evidence. Concreteauto100REMOVEDautosavetrigfromFFLGuard+changedCloseWindow/init,autoH02changedFFLTick/defaultforces/capture. BuildinstalledRecovery04pair+V15: EXACTconfirmedgFFL_Guard/CloseWindow/Tick/Init and ALLcommonFRC/FSC/FST/FSS/FFP/Load/TrigCmdLoad/FFL(exceptAutosaveentry) referenceparity. ScheduledsaveusesGFFL_BeginSave->FRCStartNow writer,removeAutoInFlight/completionrequeue;startretryretained. 20/30/40directSave_Autosavecallback soqueueworkswhileguardcapturegated;TrychecksIsTriggerEnabled(udgAutosaveTrig),retrytimerallocatedSHAREDqueueonlynotLoadInit. Forceinitall8removed;matchstartactiveforces+defaultoffarrays preserved. AllotheracceptedUI/cine/Eye/Travel/20-10settings/creatures/assets exactRecovery03/V14. LocalUI99fns auditnoexplicitgameplaymutators/alloc/RNG;NOTformalnativeproof. Sixfocusedgroups inclloadguarddefer/due1200/restore/samequeuesdifferentviewers/actualGparity/acceptedassetparityPASS;all3map/editor/startup/source/globals/text/save358/22PASS. Rootcause/MPnotproven;DO NOTclaimfixedfromtestsoraskanotherMPsolelycompile. docs/CONFIRMED_G_RECOVERY04.md;tools/confirmed_g_load_recovery04.py/build_confirmed_g_recovery04.py;tests/test_confirmed_g_recovery04.py. CurrentV15nextV16;actualworkingGTESTER/releasedmaps/master/Review03n untouched. HashesGRecovery04/installed.json.



LATEST2026-11-08: Ownerinitialnullfixremovedquesttext,clarifiesgALLNormalcutscenesblank,noportrait,FINISHIMMEDIATELY. ComparedpreQuest74FHotfix04: TextTransmission/Caption/Say/CaptionSay EXACTcurrent;nullnotificationhelperseparate,subtitlesalreadyforcedinit. NO provenrootcause. HypothesisforcedUIcancelatentry/offsceneESCpoisonSkip: builtinstalledgRecovery03modern/classic+V14. MODERN Inventory94_CineEnter ONLYremoveForceUICancel(keepClearLocalEXACT);Cine_OnSkip returnunlessbothbjAlreadyIn+udgInCinematicMode;activeESCunchanged.ClassiconlySkipguard. EXACT2fnsmodern/dev,1classic;alltextspeeds/dialogue/questdata/rewards/notificationfilter/InvClearLocal/dropUI/autosave/Travel/Eye/effects/assets exactbaseline. SixexecgroupsPASSnormalportrait/text+realduration/offsceneESC/activeESC+forced/Instant/caption/entrycleanup/scope+archive;all3map/editor/startup/source/globals/text/save358/22PASS. Testharnessrealdivisionpatchedlocally,notgamecode. Nativeeventscheduling/rendering/rootcause/MPUNVERIFIED;doNOTclaimconfirmednullregressionorForceUItriggersskip. NeeduseroneNormalquestconfirmation. docs/CINEMATIC_TEXT_RECOVERY03.md;tools/cinematic_text_recovery03.py/build_cinematic_text_recovery03.py;tests/test_cinematic_text_recovery03.py;hashesGRecovery03/installed.json. CurrentV14nextV15;Review03n/master/canonicalreleasesunchanged.



LATEST2026-11-07: Omni STILLlines;V12assetalreadyNORIBB/NOPRE2 soearlieremitterfixdidNOTsolve. V13+Review03n installed assetONLY: importedDarkSwarmBreathV7.mdx removeGEOS0(520v,material3creatureskin);keepoldGEOS1(72vwave)+2(4vglow)EXACT;removeGEOA0,remapremaininggeoids,BONEgeoset/animid70unusedNONE,NONE+6/1live0/1. ALLnodeids/hierarchy/animationtracks/textures/materials/SEQ/EVTS exact. ActualvisualUNCONFIRMED!DoNOTclaimlinegone. ScriptsJ/WCT+ALLotherresourcesbyteexact V12/Review03m;no spell/damage/AI/Dusk/inventory/global/timerchange. Archive/chunk/boneid/retainedgeometrychecksPASS,bothmapsidenticalasset. Outerheader/filenamesV13/03n,internalreviewtextstayspriorversionintentionalassetonly. ProductiongRecovery02/classic/master unchanged. docs/OMNI_V13.md;tools/omni_wave_v13.py/build_omni_v13.py;hashesV13/installed.json. CurrentV13nextV14.



LATEST2026-11-07: OwnerRecovery01seemsworking;wantsONLYTalents/button/X/paneldropflash,earlierfixNOTMPtested. BuiltinstalledgRecovery02+V12. EXACTONEFUNCTION Inventory94_ClearLocal: fourhideconditions(ForsakenTalentRoot,TalentToggle,BackpackClose,LinkedBagClose)+ForsakenPanelOpenfalse guardedexistingPaused/CinematicActive/udgCineflags. No newfunc/global/timer/frame/event/getter/cache. Cine_Enter setsflagsBEFORE ExecuteFuncInventory94_CineEnter->ClearLocal verified. OrdinaryChanged+1HzReconcile samecleanup nohide;closedcontrolsnevershown. All input/aim/F-G/inspect/carrycleanup andowner guard+.2settle unchanged. Allotherfunctions+everyobject/asset bytesbaselineRecovery01/V11exact inclacceptedEye/Travel/autosave20/10,devcreatures/jobs. FiveexecchecksPASS(old/newcleanup,closed,3cinematicflags,otherplayerguard,scope/archive),bothmap/editor/startup/source/globals/text/save358/22PASS. MP/nativevisualUNVERIFIED;Recovery01fallbackpreserved;classicRecovery01/review03m/master unchanged. docs/TALENT_FLASH_RECOVERY02.md;tools/talent_flash_recovery02.py/build_talent_flash_recovery02.py;tests/test_talent_flash_recovery02.py;hashesGRecovery02/installed.json. CurrentV12,nextV13. DoNOTreapplyHinventorylayers.



LATEST2026-11-07: Ownerclarifies KEEP MaidenEye,teleporter,autosave acceptedfixes;EXCLUDEinventorychanges. SelectiveGRecovery01 installedTEST modern/classic+V11. gbaselines/currentV10;applyONLY travel_h02/autosave_h02/autosave_twenty(no backpackB,itemrefresh,H03,H04,H05). aMEy alreadyhiddenobjects unchanged. Nineautofns+2modernTravelfns ONLY existingchanges;4autohelpers; everyinventory/backpack/F-G/preview/job/load/statfn EXACTBASELINE. NoInventory05/InventoryH03/Load04/KeepFrames/ClearAim. Autosave defaultON,20/30/40...,explicitoff,stagedretryownerfile unchanged. ClassicnativeTravelnoTravelPanel. ALLobjects/assets/devcreatures/jobs/arena/difficulty/badges/Omni unchanged;onlyj/wctresources. Sixfocusgroups(reusedexecacceptedtiming/defaultoptout/busyfailureretry/filepath/travelgeometry+sync)PASS;all3playable/editor/startup/source/globals/text/save358/22PASS. No newliveMP/rootcauseclaim;dontasktestssolelycompile. docs/G_RECOVERY01.md;tools/build_g_recovery01.py;tests/test_recovery01.py;hashesGRecovery01/installed.json. RecommendedselectiverecoveryfileFFERPG-0.9.7.5g[-1.29.2]-Recovery01.w3x replacesplainStableRollbackrecommendation perowner;olderfilespreserved. CurrentV11nextV12. Review03m unchanged(noactiveautosave/travel),masterunchanged.



LATEST2026-11-07: OWNER FEDUP H05 selectingSquire disconnected;askscompareLASTSTABLEg;stopaddinglayers.09:58reportH05networkdesync turn5860sixplayers preservedStableGRecovery/report...;NOT provenAccessViolation/JASSroot. Production EXACTBYTEretainedg rollback copies installed TEST namesFFERPG-0.9.7.5g[-1.29.2]-StableRollback.w3x (hashes README/installed.json). No newH06. H05/V9 withdrawn stabilityrecommendation. Diffg->H0562changed29added scopegrewbeyondvisibility; no exactrootcauseclaim. V10fromV9 restores15systemlibs toV2preH source+EXACTV2runtimeinclcompilerinlining;removesH03/H04/H05header/helpers/globals,KeepFrames,Hautosavescheduler;TMonsterDataonlyremoveLoad04guardbadge. ALLV9objects/imports/creatures/jobs/difficulty/arena/Dusk/Omni/badgepositions preserved. g-eraUI/autosave returns, laterH20/10/B/inspect/cancel/refinementsONHOLD;minorquirkscanreturn. Fifteenruntimeparity+archiveonlyj/wct+creature/job/arena checks PASS;V10map/editor/startup/source/globals/textPASS;bothg+V10save358/22PASS. Productionrollbackbyteexactg(ownerreportedstable),V10NOTliveMPverified. DoNOTaskmoreMPbasedmerelycompile. docs/G_RECOVERY.md;tools/build_g_recovery.py;Review03mfromV10 tools/build_review03_revision_v10.py. CurrentV10nextV11;master/releasedg/h/oldertests preserved.



Latest2026-11-07: Owner H04FAILED anotherplayerdesynced afterload/openbackpack/drop;otherplayernew/unloaded,ownerstayed. NO new localreportforincident (doNOTassign03:04errorfolderwithout evidence). BuiltinstalledH05+V9+Review03l. Inventory05 sharedhashtable startup; readonlyUIwrappers use syncedsix/bag/equipsnapshot; nativegameplayretained. SharedexistingUI72.1tick onlydirty/identityrefresh beforelocalUIflag,sharedselectioncaptureNPC,Load04Resumemarkall8dirty,Inventory94Changedexistingactualitemclassifier(no move/attackrefresh),cleanupoldunitcaches;gateLoad04Busy+cinepaused. UIflagwrappers restore nested state onearlyreturn. Unknownsnapshotfailsclosed;bagkeys128+ separateequip64..72 supportslargebackpacks. NativeF/GReceive/casts/savecodec+20/10autosave unchanged. F/GlocalhoverIDresidualunchanged. V9Badge TOPLEFTroot anchoredBuffBarBOTTOMRIGHT+.003,.018 (ownerwantsbesideStatusnotdamage);PRE2removedfromV7darkmodel(mainGEOS/MTLS/textures/animationssame,noRIBB);visualnotyetconfirmed,Duskexact. Review03l647/437fromV9: Review_Addpathtrue,ReviewNoCollisionfalse;rootfootprintsremain. Ninefocusedtests incl2clientsloaded/unloaded dropmodel,all3map/editor/source/globals/startup/textPASS,bothfullsave358/22PASS,reviewparityPASS. DO NOTclaimrootcause/fixedMP/nativevisualacceptance. docs/INVENTORY_H05.md;tools/inventory_snap_h05.py/build_inventory_h05.py/build_review03_revision_v9.py;tests/test_inventory_h05.py;hashesVersionHHotfix05/installed.json. Plainh/classic/master/priorreleasespreserved. CurrentV9,nextV10.



Latest (2026-11-06): hHotfix03 FAILED multiplayer load, latest20:46report turn758 sixplayers preserved. Built/installed separate hHotfix04+V8 fromH03/V7; shared Load04_Busy gates allplayers locks/phases2/3/5/6+.5sresume afterCommit/Restore; observer/passive/status/inventory/UImaintenance paused, passiveoneshot retries1s. OwnerlocalBJindex removed; FSTprivatepacketconcats explicitprivatearena; legacyprivatehash immutable read helper(no lazyinit). Wavepreview removes localworldhover query. F/GMouse+Receive EXACTUNCHANGED: proposed sharedclicktargetnative DOESNOTEXIST; excluded. Residual localmousefocus/rawtargetidentifier boundary remains; doNOTclaim everythingserver/confirmedrootcause. No newtimers/objects/assets; autosave20/10+codec retained. Five tests and playable/editor/startup/source/globals/text+save358/22pass; archive onlyj/wct changed. Docs/SYNC_H04.md and installed.json. MP/nativeacceptancePENDING, oldh/classic/master/review03k/V7preserved. CurrentV8,nextV9.



Latest (2026-11-06): V7 fromV6 +Review03k installed. Ownerclarifies collisiononlyrootedancients, otherreviewghostingokay ->restoreReview_Addpathfalse, sharedD7ReviewNoCollision=truebeforeReview02Load, RootEndSetPathing(notflag). V6footprintsretained. OwnerlikesOmni bodynotlonglines ->stripRIBBONLY newDarkSwarmBreathV7; allotherchunksmatch. Frost DAMAGEWORKSvisualmissing -> actualCASCnativeOther/BreathOfFrost/BreathOfFrostMissile (notFreezingBreathdart/customicyfire). Queen n02Bmax/initial1900,Devourbonusesretained. NearcrashIceBeam(no newreport) ->Ncl5disableothersOFFforcancel;first/endstatusmarkeronly;deadlinebeforestackadd,revalidateaftercallbackbeforeMoveLightning;clear22onend. Bluebeam+10s/-10%/30sstacksexisting. Owneroptsstackbadge->8typesIceSlow,BroodPoison,binding,DryadAccuracy,EntFury,SpiderFury,Sonic/5,ownThiefdaggers.17framesstaticallclients,selection+existing1Hz,read-onlyGetAbilityIcon/rawcounts,noninteractive,noitem/abilityhandlequeries/localalloc/noperiodictimer;oneshot0GameLoadedframerebuild. ScalarrequestednewNPCspells Simple.7 Easy.9 Normal1 Hard1.1 Inferno1.2 Nightmare1.4 replacesStep14legacyoutgoingfactorONCE forPlayer11->activeplayers,nonattack,newregional/summons;attacks/oldboss/heal/mana/pure/player/incoming/Eternityunchanged.123tooltipsfactorline +unittexts.8focusedtestsallPASS,finalbothnative/editor/startup/source/globals/text/content +fullsave358items22jobsPASS. Reviewbehavior/assets/factors/1900MPmatched. Nativevisual/badgeplacement/collision/beamstability/multiplayerUNTESTED. DoNOTclaimhdesyncfixed;H03guardinherited. tools/creatures_v7.py/build_v7.py/build_review03_revision_v7.py;experiments/V7/StackBadges.j;docs/V7.md. CurrentV7 nextV8. Productionh/classic/master/oldermapsunchanged. Installed [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-V7.w3x", "bytes": 14531398, "sha256": "626bb432021756a47854e1d5b9ef7a4ee719afda7e3af1d207f036886f8cf735"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-Creature-Review-03k.w3x", "bytes": 14516308, "sha256": "3bf5ebec920a42354e2134fcd1d41bdfc1ca62ce6d0058f11dfda2de1b402758"}]



Latest (2026-11-06): Owner reports rooted collision still absent, Frost looked single dart, Black breath invisible; Dusk fork accepted FANTASTIC and muststayexact. Adds3%physicalaura (spell5%). Built V6 fromV5 andReview03j. Rootsolidfootprint4invulnerable stockYTpc groundblockers at+/-32 ->192square, F99Data unitkeys600..603, idempotentcleanup beforeRootEnd earlyreturn andD2Cleanup->death/devour/remove. Rootedarchers/wispsspawn160outside. StockYTpc verifiedCASCnonrenderednonselectable4x4Default;mapnooverride. Critical REVIEWbug all Review_Add units hadSetUnitPathingfalse, so moversignored allcollision;Review03jchangescreatortrue. Actualnativefirebreathmesh recoloredicy (noFreezingBreathdart),BlacknativeCarrionSwarmmeshcharcoal/purple alphablend+neutralizedgreen/GEOA/PRE2/RIBBtracks, sourceGEOS/BONE/HELP/PIVT/SEQSbyteexact;noextra damageprojectile;noLITE. DuskabilityandD5Forkruntimeexactpreserved, allbreathmechanicsnumbers/beamunchanged. M2Lifesteal.01->.03onlyphysical,spell.05retained;ability/buff/unittooltipsupdated.6focusedtests +bothnative/editor/startup/source/globals/text/content +fullsave358items22jobsPASS. Reviewpathingenabled andgameplay/assetsmatched;nativevisual/collision/multiplayerPENDING. No newtimers/localgameplay,productionh/hHotfix03/classic/master/priorVmapsunchanged. tools/assets_v6.py/creatures_v6.py/build_v6.py/build_review03_revision_v6.py;docs/V6.md. CurrentV6,nextV7. Installed [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-V6.w3x", "bytes": 14469602, "sha256": "541c6a7d04ac2864c33a5441bfb127f0c4ba6da7099253eeedfcdc54a59cec6c"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-Creature-Review-03j.w3x", "bytes": 14443793, "sha256": "50f9364cf3ca0fc5ec168941d3e07b7e3991a39561860c14b667a6948458d484"}]



Final V5/Review03i installed manifest: [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-V5.w3x", "bytes": 14177438, "sha256": "42f4901aeb001eb015746e8e125f1d80ab385d12518d457f48054c9b7581498f"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-Creature-Review-03i.w3x", "bytes": 14151688, "sha256": "7fe4549116e580d4481b6ffe35eadf74ef7aa4036ba7f49922bf5735d4a5b434"}]



Latest (2026-11-06): Full V5 fromV4 +CreatureReview03i. Ancientstillimmobile rootcause inherited nenp buildingmove: authoredubdg0/umvtfoot/270speed/96collision/upatblank; root UnitAddType structure+buildingfieldtrue/pathingtrue/disableAmov; uprootremove structure/fieldfalse/explicitfoot/pathingtrue/enableAmov/storedspeed. Existingroot bonuses/rangedProtector/spawns retained. SylphzIM9CD30 +tooltip. Icybeam10%persecond10s,30sindependentexpiry,DRAM+cystargetZ; endcastsharedtrigger cleanup +existing1Hz death/stun/order/rangechecks. Nativebreathmetadata verifiedwrongAI breathoffrost vsactualbreathoffire, wrongUcs3width vsdistance. All5creaturebreaths corrected800distance/150start/300endUcs4; unchangeddamagecostCD; Frostnativeice missile,Dusk3FORK arcs/.4oneshot cleanup,Blacknativefiremodelcharcoaltextures/alphablendnoLITE.7focusedtests andbothmap/editor/startup/source/globals/text +save/contentPASS. Review gameplaymatches exceptreadabletooltip. Productionh/V4hashunchanged. Nativevisual/collision/move/multiplayerPENDING. docs/V5.md. CurrentV5 nextV6.



Owner clarification (2026-11-06): final h desync occurred AFTER entering character load code, NOT during map loading. h Hotfix03/V4 load-restoration isolation remains the current test candidate; native multiplayer cause/fix unconfirmed. No additional map changes from this clarification.



Latest (2026-11-06): Owner reports final h crash while loading. Newest local report13:18:57 is NETWORK DESYNC turn616,6players,SD,modernh; older12:00 ACCESS_VIOLATION is rejectedH01. No script attribution; do NOT claim proven root cause. Clarification map-loading vs character-load pending. Built/installed separate h Hotfix03 and V4 load-isolation candidates; production h/V3/classic/master preserved. Exactly Inventory94_Blocked +Inventory71_Reconcile changed, read-only shared InventoryH03_LoadBusy helper. Pause UI inventory reads for ANY FFP_Locked or FFLphase2/3/5/6; affectedhero maintenance defers; savingphase1 unaffected. Existing ticks resume after completion/failure; no newtimers/sync/gameplaywrites. Allotherarchivesbyteexact. Four executable8client/phase/reconcile/scope tests +bothmap/editor/startup/global/text/save358items22jobs PASS. Native multiplayer cause/fix unconfirmed. docs/LOAD_H03.md, tools/build_load_h03.py/load_quiet_h03.py. Current developmentV4 nextV5. Installed TEST hHotfix03 SHA bf4a299ce6da7c49777f9035aa3cc1f98a981bd89bb7413eb2a53ac4f4204c79 bytes13856187;V4 SHA3643067fce7f314926d20b9900b34c051985dda086c647aa5f20882dd148dd75 bytes14127141. Report/replay/logs preserved VersionHHotfix03/report-2026-11-06-131857.



Latest (2026-11-06): Owner confirms H02 autosave works and tests great; multiplayer explicitly NOT tried. Requests first autosave20min thenevery10, plain h promotion, and standing rule ANY production request must also go into current development. Added AGENTS.md policy. Filesystem currentwasV2, now built/installed V3 fromV2 with all accepted h fixes (not failed H01 gate), hidden aMEy,20/10schedule. V3 retains Preview75Caster reset, all jobs/creatures/items/buffs/arenas/imports; only aMEy ability coordinates change. Production h pair fromacceptedH02 with exactly3function changes (FFL_AutoStart1200one-shot; firstAutoSchedule switches same timer to600repeating; statuswording), plus1bool; otherarchivesexact. -autosave now does not shift schedule. Fourfocusedtests dispatchactualSave_Autosave->Schedule at1200/1800/2400seconds for8players and proveforwardport/contentisolation. All3native/editor/startup/source/global/text/save/content PASS. Promoted production h+classic andinstalledV3TEST. Production beforepromotion inclTESTcopies at release/0.9.7.5h/history/2026-11-06-before-approved-final20;datedapproved-final20. Builders tools/build_h_final20.py/tools/build_v3.py; helpers autosave_twenty.py/item_refresh_h02.py plusacceptedH02 helpers. docs/V3.md +DEVELOPMENT_VERSIONS currentV3 nextV4. Master/review/previousmaps preserved. Native20mininterval/devintegration andmultiplayerpending; singleplayerH02 owneraccepted. Installed [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5h.w3x", "bytes": 13856491, "sha256": "affc09d784ec5615e4f997a147a517ea9f660c2ef55498583cfaedf09586a5d5"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5h-1.29.2.w3x", "bytes": 11344255, "sha256": "ceb662e140edfa536407f7fbf7bdd038f0c4a5da6f8a743e8fc847a97dfa89db"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-V3.w3x", "bytes": 14123676, "sha256": "f97833fedf693b789d6abf96cc9d3299567a0dfa69bf0afcaec42c4b563ba127"}].



Latest (2026-11-06): Hotfix02 modern+1.29.2 TEST candidate installed, original production h restored at owner request (known autosave bug still awaiting live repair confirmation). Owner rejected Hotfix01 hard Wanted-gate: B could not open, X/B/mouse desynced state; item aim-only refresh WAS better and retained. DO NOT carry ui_stable_h hard closed-intent gate into future maps. H02 restores original h native observer basis, recovers missed B key-up and allows physical B through synthetic-X echo debounce, clears close latch. Adds strict own selected hero/Gaya native context, hides native while inspecting/foreign selected, suppresses duplicate native cached frames, singleton talent/inspect roots with stale-root reset on Warcraft saved-game rebuild. Inspect tooltip outside grid/noninteractive; no redundant39slot refresh during stats draw; target-owner item-settle checks. Full teleporter Cancel was under HUD; compact rows/max.40height/top.585/foreground80 preserve10dest/page and unchanged click/ESC/sync logic. Autosave: ON by default via authoritative explicit opt-out array; bare -autosave status only, on/off explicit, now immediate queue. Enabled timer starts600s at GameStart, queuesallactive players every600s; existing1Hz active-only retry startsmax1capture/sec. Missing/busy/cine defers; failed capture/export requeues30s backoff. Uses staged FRC_Start not400inlineStartNow; FRC/FSC/FST codec/writer/readback unchanged. Existing Hardcore no-saving restriction retained. 22focusedtests +both native/editor/startup/source/global/text/content/save PASS. Final saved-game-root adjustment rechecked. Native timestamp/B/UI/two-client acceptance pending; no network stability guarantee. Tools autosave_h02.py/backpack_b_h02.py/travel_h02.py/build_autosave_h02.py; docs/HOTFIX_H02.md. Frozen H02 input backup release/0.9.7.5h/history/2026-11-06-before-autosave-h02 contains rejectedH01 source; stable h frombefore-ui-stability restored. Master/V2/review unchanged. NextdevV3 requires deliberate forwardport of latest good fixes, never H01 hard gate. Installed [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5h-Hotfix02.w3x", "bytes": 13856699, "sha256": "ca827e672575411e2ac43632f321594cb3d5965fc4a67ea528faa31ae82ab895"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5h-1.29.2-Hotfix02.w3x", "bytes": 11344410, "sha256": "f76671aafbe258bcded1cb67ff9a07d6200845ddb51b06ca61fc690e30a8a6dd"}].



Latest (2026-11-06): Production h modern item-event UI flicker candidate. Inventory94_Changed used full cinematic ClearLocal, hiding talents/toggle/X/inspection/carry/F/G every pickup/drop for .2s; new Inventory94_ClearAim resets stale aim/readiness only and preserves panel state. Full ClearLocal still used for CineEnter. BackpackVisible requires explicit Wanted intent; UI72 blocked branch hides closed native frames using existing reserved handles during settle. No new timer/local gameplay/allocations; safety delay and casting/equip/objects/stats/save logic unchanged. Four existing functions +one helper in TEquip only. Six executable/isolation tests and native/editor/startup/source/global/native-text/save gates PASS. Native visual/MP acceptance pending. Builder tools/build_ui_stable_h.py uses frozen backup source; helper ui_stable_h.py; candidate VersionHHotfix01. Production h updated SHA 13aae0f70d9739a5708c7ccc956b7dc933ec3767981f43d3ff7ce02a37ab5d4d. Plain TEST h file WinError32 locked by running Warcraft; corrected TEST file is FFERPG-0.9.7.5h-Hotfix01.w3x, hashverified. Backups release/0.9.7.5h/history/2026-11-06-before-ui-stability; dated ui-stability snapshot. Classic lacks Inventory94/TalentRoot and unchanged. V2/review/master unchanged; carry Maiden Eye +ui_stable_h fixes into next V3.



Latest (2026-11-06): Owner names Maiden Eye production fix 0.9.7.5h. tools/package_version_h.py builds modern +1.29.2 from corrected g; map header/WTS/runtime/editor strings g->h only. All other archive files, objects, gameplay and save format byteexact; both full map/editor/startup/source/global/native-text checks PASS. Installed h pair in TEST, g pair preserved. Production current h; development V2/review03h/master unchanged, next devV3. Installed [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5h.w3x", "bytes": 13852325, "sha256": "9df2e4301f3184a7c677d32ec55b5120f8b95ea53d1426cd26394cff59653a9c"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5h-1.29.2.w3x", "bytes": 11341907, "sha256": "5552de88b5df6fd83eb4fc7edc831d05119ad364f451a0a5ba4a5e3280f6b804"}].



Latest (2026-11-06): Production g Maiden's Eye hidden-button fix, modern +1.29.2, installed TEST under unchanged g filenames. aMEy clone of native Atru inherited visible command location and displaced Q when carried; only abpx0/abpy-11 now authored. Native Atru, item I0HS, sight radius, all scripts, possession handling, saves/gameplay/timers unchanged byteexact. Canonical tools/maidens_eye.py generator updated idempotently; five existing tests + both map/editor/startup/source/global/native-text gates PASS; live HUD acceptance pending. Builder tools/build_maiden_eye_g.py; candidates VersionGHotfix03; release/date archive and full before/TEST backups in release/0.9.7.5g/history/2026-11-06-before-maiden-eye-hidden. V2/review/master untouched. Carry this object-only fix into next V3 build derived from V2. Installed hashes: [('f6e884899267949f7f6678442a3cb4888cec1892e8888ef7b4c55b205bca9139', 13852324), ('52c56ac38ba879aecc5a82a730db273f7bbbe78b5d30acf5a6818a61cfe3dd92', 11341907)].



Latest (2026-11-06): V2 + Creature Review03h installed in TEST. Full V1 baseline; owner aura art corrected; AP rooted ranged1000/permanent roots with reposition and all3 ancients restore Amov before speed; timed carried eggs/permanent Broodling40 and Spiderling30/stacked poison/death AS; active Cover30s/CD45; Inferno native landing; mirrorCD60 and no reward on expiration. Icy Realm and Dark Dragon Marsh Normal stats/spells added in isolated definitions, existing1Hz heartbeat, no new local gameplay or always-on polling timers. 26 focused tests plus both map/editor/source/startup/global/native-text/content checks and full-map save compatibility pass. Native assets/archive readback pass. Production g/V1 hashes unchanged. Full details docs/V2.md. Next full test V3. Live visual/AI/XP/multiplayer pending. V2 SHA 38867ccb4aa5eb2b48e006a190b4450c3b3e4601d2c9dd4f7cd4d446b0b2f57d; Review03h SHA 4b856cdb4030ede0db32ad12d282c7384d74b245d027f8cd4abd5c9c67626d35.



# FF Epic RPG handoff



Latest (2026-11-05): User requests same autosavefix in plannedUI100 and rename full dev sequence V1 then countup. Built release/development/V1/FFERPG-V1.w3x from QuickUI99 via autosave100.refresh modern, label/header/WTS38788 FFERPG V1. NEXTFULLDEVVERSION V2 thenV3... DO NOT createQuickUI100. tools/build_v1.py reuses build_preview68 packager allowedTEquip/TForsakenFreshLoad. Exactly5existingfunctions changed +2autosavehelpers; everyobject/asset/import/monster/job/gameplayresource matchesUI99,saveformatandwriterunchanged. Newhelpers identicalproductiongautosavefix. 13focusedtests(11autosaveinherited+scope/naming)PASS plus native/editor/startup/source/globals/nativesavetext/content/save358items22jobsPASS. Native10minphysicalfile/AI/MPacceptancepending. CreatureReview03g/master/productiongunchanged. PriorUI99maps retained. DocsDEVELOPMENT_VERSIONS.md currentV1 nextV2; READMEinV1. TESTinstalled {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-V1.w3x", "bytes": 14086670, "sha256": "1defec2cefb8a7a403266dcf7951b9f0e568060302dd4b6fdc3126fd15592eb3"}.



Latest (2026-11-05): User back to production asks autosave15min, then explicitly accepts existing10min. Audited releasedgmodern+classic. Rootcausemodern Forsaken_PrepareInventories cleared udg_AutosaveTimerTrig actions when blocking retiredwriter; FFL_BindCommands only restoredmanualsave,so autoenabledbutdead. Classic lacksPrepare routine,actionintact. RestoredmodernactionbyremovingonlythatClearActionsline. Save_Autosave/Save_InitCommands unchanged:60second x10slots(8humans+2unused)=10minperplayer;initiallydisableduntilold15minloadwindow,firstsavestaggerednextcycle,then10min. FFL_CloseWindow nowexplicitEnableAutoifHardcoreOff; FFL_Guard no longerdisablesperiodictimer(index2256releasedmaps vscanonical2242),gateshandleloads. Added FFL_TryAutosave/FFL_RetryAutosaves sharedpendingqueue:eligibleactive/opt-in/nonHardcore withHero+Gaya+House; deferCine/FFLphase/FFPlock/FRCphase/FSCWritingBusy/FSTPending; modernalsoInventory94Paused andnativeBlzUnitExtendedInventorySize30,classicexistingSaveSlots_Ready. Existingfullcapture FFL_BeginSave(pid,true,true),FSTStemautosave, unchangedFSTWrite/localownerfile/readback;missingcharacter/off/left/HCskip. One1Hzretrytimerstartedonlywhilepending,oneprofilecaptureperretrytick,pauseswhenempty; no newalwayspoll/noclocalgameplay. ExistingFFL20Hzpoll untouched. AllSave_/Load_/FRC_/FSC_/FST_ funcs tokenexact;2archivefilesonlyj/wct;allobjects/assets/WTS/rosters/gameplayunchanged. Currentuserautosave.txtmetadataoldOct14fileuntouchedbytools;noGameRun/physicalwriteclaim.11focusedtestsPASS incl30simulatedticks10minspacing,actualPreparecallbackretainsaction,capturepath,allbusygates,queuepause/onepersec,optout/missing/HC,windowenable,unchangedserializers,andmockedownerlocalPreloadGenEndrealpathautosave.txt. Bothnative/editor/startup/source/globals/textsafety/content/save358items22jobs PASS. Native10minphysicaltimestamp+MPconfirmationpending.

Candidates release/development/VersionGHotfix02; publicgpairreplacedandTESThashverified, previousRELallfiles+TESTcopies preserved release/0.9.7.5g/history/2026-11-05-before-autosave;datedpair2026-11-05-autosave. BuilderSOURCE_DIRfreezesbackupafterpromotion. NoQuickUI100created;UI99/masterunchanged,andNEXTdevelopmentbuildshouldapplymodern autosave100.refresh tobringfixforward. tools/autosave100.py/build_autosave100.py/package_autosave100.py/tests/test_autosave100.py;docs/AUTOSAVE100.md. Finalinstalled [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5g.w3x", "bytes": 13852307, "sha256": "33ba902678c9c76ab9308aa541fc678026258299b896a18ab5fd22d0bfbc10fa"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5g-1.29.2.w3x", "bytes": 11341892, "sha256": "cf08ee64d373aa0d910ba6093d5876351311f56ba982e03a7d1aeaa4866ed723"}].



Latest (2026-11-05): QuickUI99 + CreatureReview03g fromUI98. UserNaga corrections: FrostArmor realarmorfieldUfa2 notUfa1 (nFA8 nowUfa2=50,Ufa1cold5,buff30,ice50%rankunchanged); imported bakedpurpleBrilliance andgreenEndurance models/TGA because runtimevertexmultiplicationcannotrecolorbluepixels. tools/aura_assets99.py readsnativeCASCmodelgeometry+textures,TGAusesmaxRGBintensity×chosenRGB,GEOSanimstaticwhite,MDXtexturefixed260paths;4assetswar3mapImported registeredwar3map.impflag13.N98TrackcasterduplicateFXremoved,bMP8/bE90ftatimported;VortexpersistDarkPortalTarget2s viaone-shot, existing250radius/10Hz1spullunchanged.

AncientForest14Normalunitstats inbuild_ancient99.STATS and7newSUMMONS qL99wisp/qD99Dryad/qS99Sylph/qE99egg/qI99Infernal/qT99Ent/qA99Archer. Rawpoolregion7(Lothlorien), noTSpawn/roster/arena/item/jobs/olderabilities changesexceptnFA8. Fullrolesin docs/ANCIENT_FOREST99.md + runtime experiments/Ancient99/Ancient99.j. Rootedforms ANcl+samehandle/alternatebuildinganims/removeAmov+speed0/propwindowPI+anchor; combatcreature type retained (avoid allspellfilters excludingstructures); Uprootrestoreoldmovement/armor/damage/range/dice preservingexternalgains. Tree+100armor30s,sixwisps5..30s; AWsixarcherssame;Protector+100base/sides62/range1000->451-512for30s thenrestore351-362/128. RootAW/APtake25%extra. CoverArchersclosestlivingallyGuardian800halfsharedaftermodifiers,oneguardian,recursionguard,puretransferletsroot1.25apply. TreeThorns native0BrilliancebuffbTH9 custom10%phys/magicsharedreflectwithF99/B88crossguards. DevourinjuredfriendlyF99pool/noheroes/illusions/special/summons,QueenM89Absorb2uses/CD20;SYnormalavailable(notdevourlocked). TreeAI prioritizesvalidDevour,Dryad,Sylph,thenrootifbothsummonCD>0andvictimexists. Wispsnearestcachedenemyhero acrossplayers/fallbackreviewenum;approach<=250explodes3000fire500;canbekilled. Mosttemporarysummons60schosen. MotherSpider n010rename49/10000/64/376-400;removeA0PI/A018, shell10s/destructionandMotherdeath3originalnsbm(eachsourceonce),-splitMotheraddedalongHydras. IndependentFIFOstackrecords separateHashtableF99Stacks:Dryadkind1-1acc30seach,Bindingkind2-10%AS/MS45each(movementcap90)at15clears+native5stun,Entkind3+20%AS20sperdeath600. Existing1Hz heartbeatpopsFIFOexpiryandupdates/removesnativebufflevels;slowrecasterfriendlyselfallowedandoldbSL9removedbeforelowerlevelrecast. Accuracy3readersinlineLoadInteger105,pure,nohelperlibrarycycle.

SoulDrains5ticks1Hz,currentorder/range<=800/alive/channel/pausedcancel,DRAL/DRAMlightningupdates;1000HP/s andhealself+eachfriendly600halfactualHPdrained;MPmin300actualdrained,2×damage/casterMPreturn;Cura1500allCD30. Trickstermirror1/.5out/1.5in; nativeAOmi event+fallbacktagbool40 andexistingzeroillusiondamageexceptiononlytagged.WandAIilzCI9Iild.2/Iilw1 createsShadowDoublehostileheroalliedSatyr30s;nativeeventdummykeys41/42 +one-shot.1sclosestunflaggedillusionfallback,NoInventory/save/jobcloninglogic;taggedillusionsactivegroupcleanup ondeath/removal. HellAccum50%HP/+200attack/+50armor20s;Infernal45/4k/20Demon/200-243chaos/2000fire300impact;5staunt+60armor20sCD30 usesexistingGayaBreaktaunt. Entdeath3×temporarysummonsstackfury. ExplicitFlan1750lightning3targets/2000ice200AOE/waterprojectile1500+3sstun,zQB9helperexplicitwater. AllrequestedNightMight/removalsincluded. DeathcleanupaddedbeforeForestearlyreturn,Alertnsty20sregion7/60s2x,pausecorpseclear. FXpersist1.5/2sone-shotsincludingEgg/EntBirth/Infernal/Wisp; nonewalwayspoll. Allnewruntime/icons/modelsvalidatednativeassets.

16focusedexecutable/data tests PASS (stacksindividual,15stun,entexpiry,shellonce,6productions,statsrestore,poisonchance/heroLevel,closestguardian/sharedguard,actualHP/MPdrainmath,etc). Bothplayable/editorcompile/startup/source/globals/nativesafetext/content/save358items22jobsPASS;archiveunchangedresourcesreadbackpass. Review647exhibits437unique,65area7;8summonexhibitslocalized7not11;Mothername/split/readablespells/currenthook/assetbytechecksPASS. Nativegraphics/AI/MPacceptancepending. Oldg/classic/master/oldermapsuntouched. FinalTESTinstalled [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-QuickUI99.w3x", "bytes": 14085298, "sha256": "c877478f4a58fcd24d853539519f58fbd9372a19f77f728f2094afa731a612e0"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-Creature-Review-03g.w3x", "bytes": 14043433, "sha256": "c015923a6fbc795306f3b29be614862ac5cba0e9c09c2b3e54dc0e676a674e0e"}]. Build tools build_ancient99.py/build_review03_revision99.py/install_ancient99.py. Default-empty EXTRA_EXHIBITS added review95builder; legacydefaults unchanged. Intermediatecandidatespreservedunderbuild/candidates/ancient99-*.



Latest (2026-11-04): QuickUI98 / CreatureReview03f from UI97. Completed Naga Islands15 raw types + nhyh hatchling Normal stats, all requested spells/tooltips/AI; user clarified n01P Lesser Flan stays Highroad, n01O regular Flan Naga, Witch Maelstrom unlock only after Devour, EACH Wyrm image death grants full bonuses. New raw n...8/9 isolated abilities/buffs, no previous ability changes. Regional Devour injured friendly N98 pool, Queen M89Absorb2uses/CD20 (250mana chosen); unlocked Maelstrom1800/CD60 native15s1%maxHP/s. Witch1600 base means must absorb>=200maxmana to afford. Aura purpleBrilliance800/+30%magic; FrostArmor50/ice>=rank5; Regen maxHP/60×60. Vortex250 active10Hz1s pull only. Naga callers20szone6/60s2xwavefrequency+amount. Guard noNightMight/wave2000water/bolt1000stun5s; Turtle block10->60/5staunt10sbuff/flat100min1. Naga flans native fork1750CD15/2000CD20/3targets; Aqua wave2000enemy1000ally once per target1000path/200radius nativeMissile engine via named bridge avoids library cycle. Image nativeAOmi2nearby(.25out/1.5in), tracked parent, EACHdeath+50%atkSpeed+1500max/currentHP+120baseDamage, idempotent, outside gains preserved; engine zero-illusion exemption only linkednwgs; summoned/one-shot fallback bind and existing1Hz group handles expired/removed children, ForestAI removal cleans N98Data/effect. nhyh20/2000/35/83-97,25%30+4attackerLevel/s10s110@20; oldA0PHremoved. nsnp poison victimheroLevel unlikehydra attacker; oldpoison/crit/pulverize removed affectedunits. All new assets verified. Tidal Wave user report: shared Famfrit/Shinryu A0ZX proxy h01B hidden before nativeorder; nowLIVE alpha0/noPathing, isolated nTW8 cloneA0PZ with validCrushingWaveMissile and dummyMP0/CD0; existingA0PZ untouched, exact5rows/damageformula/spacing/groupdedupe6slifetime2swait preserved. No new local gameplay or always-on polling; existing1Hz heartbeat + active-only10HzVortex andone-shotmirrorbind. Gear UI untouched except pure FrostArmor resistance stat reader. TSpawn/poolscript/loot/Arena modules byteexact; audited movednsgn/nsgh/nsgb/nsel/nrel/n01Ozone6not3, n01Pzone5not6. Eleven focused tests PASS plus both maps playable/editor/startup/source/globals/native-save-text/content + save358items22jobs; Review current roles/readable formulas/-split bothsizes checked. Nativevisual/AI/multiplayer acceptance pending. Productiong/classic/master/oldermaps preserved. tools/build_naga98.py/tidal_wave98.py/build_review03_revision98.py; docs/NAGA98.md; final TEST-installed hashes: [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-QuickUI98.w3x", "bytes": 14046155, "sha256": "18b9b6faac80104e599d001b008f4440cb66a0da04aca0cd5da500629abb30a7"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-Creature-Review-03f.w3x", "bytes": 13991310, "sha256": "acb56fba9a91bdf119aa9d77ccfe404d3fd15d3c374844cdd3ac1d36433cabc7"}].



Latest (2026-11-04): UI97/Review03e from96: nhyd direct AncientHydraoffspring lvl25 HP3000 armor41 135-140atk; replaceA0PH withcPH7 20%50+5*attackerLevel/s10s (175@25). Explicit C97SplitDeath shareddeathhandler nahy2nhyd ->each2nhyh; removeAspy/Aspt toavoidduplicates, cSP7Divide marker. Sameowner/facing/zone/wave group; C95Pool includesnhyd regionalmembership notworldspawnweights. -split originallyonlynahy/nativeKillUnittrust; nowcase/trailingspacenormalization/livingnahy ORnhyd andfeedback, actualsharedDeathhandler; hatchlingsdontsplit/statsunchanged. Reviewoffspring+hatchlings localizedCentralSummons, noarea11dup. Useralso ngnvmissingWhirlwind andngrkAvatarvoice: oldOrcWhirlwindmodelabsentindex; actualBladestormTarget.mdl+spinanim,persistingexisting120effectcleanup;500physical/s5s250cost150CD20unchanged. hAV0 nativeAHav stillvoiceafteraefs/aeflclear; replacewithsilentANclorderavatar andC97AvatarStart/End +100baseatk/+1000maxHP/currentHP+1000/Amim(onlyremoveifnew),reusehA25+25%/scale1.5/105duration30/cost150CD45. FlagsForest86Data171/172 notC95Data sothatCentralbuffcleanupcannotleakbonuses. Endidempotent,expiry/deathrestoresandpreservesexternalstatgains/innateimmunity. NoNewTimers/Localgameplay. Eightfocusedexecutable/data/command/scopechecks +allbothnative/editor/startup/source/global/content+normalSave358items22jobs PASS. Nativevisual/audio/multiplayeracceptancepending. Productiong/classic/master/previousmapsuntouched. tools/build_hydra97.py/build_review03_revision97.py; review95builderparameterizedwithsameolddefaults +POSTHOOK. docs/HYDRA97.md. TESTinstalledhashverified [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-QuickUI97.w3x", "bytes": 14013363, "sha256": "f33ab94d1285320fcc5fb41952861676ebc209ef049be074339bf7185b313f8a"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-Creature-Review-03e.w3x", "bytes": 13960185, "sha256": "1445686405412ced4d506eaa4178b39c3157ad179c1aa3c72e46447faad93a79"}].



Latest (2026-11-04): Owner reports g Talents/X/F-G/MoveToHero flashing especially on rightclick; missingMoveToHero in recording. Rootfound: ForsakenEquipment trigger subscribes3order events; Inventory94Changed unconditionallyhidUI .2s onEVERYorder. tools/ui_flash96.py gatesChanged to4actualitemevents + targetedslotmove852002..852007withitem; old CarryOrder bookkeeping retained forordinaryorders. Only3TEquipfnschange: OnEquip, ClearLocal nowCarryUI_Close resetsOpenflag, CarryUIInit setsaccesslevel60. Owner explicitly saysKEEP MoveToHero originalbackpacklocation: allcoordinates/anchors/size/parent andCarryUIShowAccess unchanged, verifiedexacttests. Noobjects/gameplay/casting/icon/cooldown/scenechanges/newtimers. Updatedgpairrequested: modernrelease fromVersionGHotfix01; Classicg byteidentical e68264d... existing7%housebuild because nocustomNativecontrols. QuickUI96 from95 keepsallCentral/Dragoon. NoCreatureReview03d/masterupdate. Fivefocusedtests incl360orders noUIreset +actualslotnotify/positionexact/scope/castfunctions pass; all3native/editor/startup/source/globals/save +moderncontent pass. Nativevisualrecording/multiplayeracceptancepending. Productiong andTESTreplacedwithbackups release/0.9.7.5g/history/2026-11-04-before-ui96;datedpair2026-11-04-ui96. Build/testproductionbaseline frozen tobackup. TESTinstalledhashverified [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5g.w3x", "sha256": "9ca78509bad9e88a436a8871a407567dd1b813bd40f6fdacf5428c87ab089844", "bytes": 13850451}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-0.9.7.5g-1.29.2.w3x", "sha256": "e68264d09479b02d5f7180adfecd1cc713473b8f51808eed559cfc89bbebb7c2", "bytes": 11338766}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-QuickUI96.w3x", "sha256": "419f506e17280f410923deb152697561ce581efc24b8e3f7b09436cf781ad198", "bytes": 14014237}]. See docs/UI_FLASH96.md, tools/build_ui96.py/package_ui96.py.



Latest (2026-11-04): QuickUI95 + CreatureReview03d Central Islands fromUI94. Ownerclarified duplicate njgb30caster/njga27crit. 23Normalstats tuples in build_central95.STATS; Adaman ntrd/ntrg. Newrole c...5ids with ownpoolicons verifiednativeassets/differentearlierNPCroles; matchingstatusicons intentional. Hydra poison attackerlevel (notvictim): nahy25%10+6*level10s, nehy33%100+5*level10s; removeoldA0PH; nativeAspy2nhyd retained. TurtleslegacyACrkremoved fornew15/10%phys+spellguard. Alertntrs/njg1zone3 15scountdown5..1/60s2xrate+amount/cap usesexistingzoneclock. njgbCommand15%melee600 nativeEar2=1/Ear3=0; Pair1400Water+ImperilB057 then2s1000Earth+3sstun ifwithin300; DevourinjuredfriendlyCentralpool2uses/statabsorbQueen20CD200MP; unlockElementa45CD1100MP existingFire/Ice/Bolt paths overridden2xbaseattack onlynewraw,20MPregen setup. njga20%normalhitcrit2.5+20%slows5s. NativeFan1600Earth/600,waterShuriken1400blueSentinel/existingNinjaengine,WaterWave1200Water1000path/radius200. Otherrolesperdocs. NetnativeAHtb0dmg4sorangeEnsnare/custombNT5/GayaBreakremoves; BlindusesexistingB00P/Crs0 torespectBlindproof/Dragoon. Burrowhide/invulnerable5s/fullheal/80eva3s; HealingRain200/s600/10s nativechannelstopcancels; earthwhirl800/s5s250; charge1000physical+100+7*victimherolevelbleed5; shoutsblock10pctpoints andWarCry100+Earthmelee/Waterranged20s,haste30passive. Existing1Hzheartbeat+active10Hzcharge+nativeprojectileloops; noNEWpolling/noLocalgameplay/syncdata,Paironeshot2s destroys. EarlyC95state guard. Arena modules/rosters+worldpools exact; productiong/classic/master preserved. Review03d currentNPCstats/readableC95tooltips; nhyd+cWE5localizedCentralSummons (noextraarea11duplicates); -split KillUnitnahy nativeoffspring; callbackShurikenDamage/Remove and read-onlyInventory94 catalogue initialized. Bothnative/editor/startup/source/global/content checks+normal save358items22jobs+22focusedbehavior/data/review/iconchecks PASS; archiveexactunchangedresources checks. Nativevisual/AI/multiplayeracceptancepending. See docs/CENTRAL_ISLANDS95.md and tools/build_central95.py/build_review03_revision95.py. TESTinstalled/hashverified [{"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-QuickUI95.w3x", "bytes": 14014999, "sha256": "9c2ced004382a24fa17871897568ad52e2a7e7eed4a908a78b5dec235c1c735c"}, {"path": "C:\\Users\\jaked\\Documents\\Warcraft III\\Maps\\Download\\TEST\\FFERPG-Creature-Review-03d.w3x", "bytes": 13958735, "sha256": "81f80dc8e2831ae7af1704486c4e76a8d664a0707cc2918cca9517b7936a79ae"}]. Intermediatecandidates preserved underbuild/candidates/central95-* and review95-*.



Latest (2026-11-04): Requested production g 1.29.2 created from retained classic f (not modern native-UI downgrade). tools/build_version_g_classic.py: house-only hH79/hM79 native7%maxHP/MP percent flags,350range,bothhouse links,stockfountain unchanged; versionlabels f->g; LuciferGeneral minusannouncement/Chronicleclaims/bonusclaim removed,SaveCondMinus=false; Plus eligibility/resetwriter and serializers unchanged. Four changedfunctions plus scoreboardlabelglobal; allotherresources except explicitobjects/text exact. Playable/editor compile with1.29.2common/blizzard; startup/source/global/save/content/archive/objectisolationchecks PASS. TESTinstalled C:\Users\jaked\Documents\Warcraft III\Maps\Download\TEST\FFERPG-0.9.7.5g-1.29.2.w3x SHA256 e68264d09479b02d5f7180adfecd1cc713473b8f51808eed559cfc89bbebb7c2 bytes 11338766. Modern g/UI94/master and priorf preserved. Nativeclassic/multiplayeracceptancepending.



Latest (2026-11-04): Owner requests house healing/mana buff in g again. Added house-only hH79/hM79 clones at .07 fraction/maxHP and maxMP per second with DataA1/DataB2 native percent flags; h006/h00N links updated,350range/targets retained; tooltips7%. Scripts/editor/item/save/fountain/otherunits byteexact. All native/editor/save/content/archive/object-isolation checks pass. Replaced production and TEST FFERPG-0.9.7.5g.w3x SHA256 4deb94ce427c02a881be53c6ae417f1e7f2ccb1ddc261412cb46f49abae30113. Prior g and TEST copy preserved release/0.9.7.5g/history/2026-11-04-before-house-regen. tools/build_version_g_house.py. UI94/classic/master unchanged; inherited crash acceptance still pending.



Latest (2026-11-04): Owner requests Hotfix10 as production 0.9.7.5g. tools/package_version_g.py label-only promotion; TEquip diagnostics/TIntro welcome/TMultiboard prefix plus WTS/outer title updated. Exact runtime/module comparisons allow only f->g string changes; other archive resources byte-identical. Native/editor/startup/source/global/save/content checks pass. Installed TEST C:\Users\jaked\Documents\Warcraft III\Maps\Download\TEST\FFERPG-0.9.7.5g.w3x SHA256 95190c53f1a2a97f631b82f7c8cd0bdba696e3a35ea659837934a7ed54a64b16 bytes 13851455. Earlier f/Hotfix10/UI94/classic/master unchanged. Inherited crash/native multiplayer acceptance remains pending.



Latest (2026-11-04): Inventory crash hardening for exact reported public f and QuickUI93 -> modern Hotfix10/QuickUI94. Both reports same native stack/read FFFFFFFFFFFFFFFF, no script attribution; NOT confirmed native fixes. Pause custom UI, inventory maintenance, Chronicle/passive/status checks, shield readouts and load application BEFORE cinematic pause/selection; resume refresh/timers after interface/selection. Bounded static item ability/icon/tooltip catalogue, null/retired guards, pre-bind passive prep, detach-before-strip. No object/stat/scene rewrites/new poll timers. Restore original -newgameplus action (inventory bootstrap was replacing it with unavailable); original reset-code writer and eligibility unchanged. Minus stays blocked; remove Lucifer General unlock announcement plus bonus and16Chronicle claims, retain stat rewards. Both map/editor/save/content/archive checks +16focused pass; native/multiplayer acceptance pending. See INVENTORY_CRASH94.md. Production/classic split preserved: modern f retains Lancer/oldThief; QuickUI94 preserves93 content; classic/master/review unchanged.



Latest (2026-10-30): Hero6slot/GayaWateraga/IceU previews requested. Hotfix06/UI75

extend read-only screen observer with200..205 quickslotcodes, staticoriginbutton0

width/visibility, ownselectedhero/Gaya caster. F/G/Calculatorforcedhero; native

waveoriginfollowcaster. Hero dockhide no longercancelsGaya nativeaim; Gaya spell

queuesexistingdeferredcleanupwithoutoverwritingherodiagnostics. No newtimers/

nativehooks/overlays/localallocations/gameplaychanges. Sevenfocused +allbothmap/

editor/content/save/archive gates pass. QUICK75.md. AbsoluteHUDanchor/mixed

selection/native/multiplayeracceptancepending. fpair/master unchanged; classic

notapplicable. Firstcompile-ordercandidatepreserved.



Latest (2026-10-30): Quest(null) popup/Beastslayer: audit54QuestMessageBJ sites

across35modules. Route to TText QuestText_Message: remove stock single-space

spacer, suppress null/empty/null-literal, retain13styles realtext/sound/delay/

flash/audience. 37canonicalmodules updated incldependencies. SeekDestroy Kelk/

Kinoc/Mika no longer explicitly grantedA102; objectlistslackA102already. Five

focused+sevenlifecycle tests, all3candidate and2finalrelease gates pass.

Ownerrequestsnamefagain: final0.9.7.5f and1.29.2 updatedfromHotfix05; oldernamed

artifacts/manifests archivedhistory/2026-10-29-before-quest-fixes; datedcopies

2026-10-30. UI74 development separate. QUESTS74.md. Nativeinheritsunconfirmed

Hotfix04 desynccandidate; doNOTclaimnetworkfix. Masterunchanged.



Latest (2026-10-30): Finalf NOT multiplayer-stable: owner loaded staff/offhand,

previewed both, castBookofDepths viaG, thenpent984 desynced (screenshot). Latest

localDesync09:16:57 turn2831,6players,SD,f; report/replay preserved. Hotfix04/UI73

candidate moves owner-local ExecuteFunc cleanup out of shared spell observer;

eventrecordsnotice,10HzUIclearslater withaimrevisionguard. Only4TEquip functions

change; actualwave/damage/castreceiver/cooldown/input/icons/assets untouched.

Five regressions/allbothmap/editor/content/save/archive gates pass. CAST73.md.

Unproven cause; multiplayer test needed. Do not call reducedpolling a desync fix

or old "seemsworks" stabilityproof. Priorf/master unchanged.



Latest (2026-10-29): Owner says optimized candidate seems to work and requests

release0.9.7.5f. package_final_f.py promotes retained-jobs Hotfix03 to

release/0.9.7.5f/FFERPG-0.9.7.5f.w3x, noForsakenmoniker. Only WTS38788 public

title +outerheader change; every script/editor/object/asset byte is identical

to testedHotfix03. Allfinalmap/editor/content/save/archive checks pass.

Classicf retainedunchanged (modernUIoptimizations notapplicable); UI72 remains

developmentDragoon/Thief. TESTalreadyhad Hotfix03 renamedasf, hashverified;

preserve it before installing final. Priorreleases/master untouched.



Latest (2026-10-29): User asks10Hz cap/caching/active-only UI. Hotfix03/UI72

consolidate4UI timers(100+20+10+10Hz) intoone10Hz UI72_Tick. Remove unconditional

icons; use existing revisions/load/job/Draw/Paint +1s slot fallback. Bag fallback

visible/moving only; cursor/runes armed only; wave draw throttled10Hz even mouse

events; idle clears skipimage loops. Development DG_UIUpdate moved offcombat

tick ontoheartbeat; statusglows retained, idle runehides cached. Combat timing

unchanged. Seven regressions/allbothmap/editor/content/save/archive checks pass.

UI72.md. Originalbase/master preserved; multiplayer/nativeinput acceptance and

desync resolution still unconfirmed. Do not claimallgameplay timers capped.



Latest (2026-10-29): Owner authorizes speculative but concrete culprit change

for multiplayer test; cannot release crashing f. Hotfix02/UI71 gate synchronized

1s inventory maintenance by exact per-player hero/slot handles+types/size/level/

dual/grip/missing-ability snapshot; record post-conversion state. EnableHero only

adds inventory abilities if missing. Local input/icons/previews/cast code left

identical for isolation. Seven regressions/all both map/editor/content/save/

archive checks pass. INVENTORY71.md includes periodic workload frequencies and

test sequence. No proven desync fix; runtime acceptance pending. Original master

and base release unchanged. Hotfix02 retained jobs; UI71 Dragoon/Thief.



CORRECTION (2026-10-29): Second player LEFT normally after seeing owner drop;

they did NOT crash. Only owner desynced; no spells were cast. Owner loaded gear,

opened inventory/tested changed previews; typing blocked F/G, alt-tab restored

them. Gear/preview/chat-focus path is primary lead. Hotfix01/UI70 leave guard

is unrelated to initiating desync, NOT a solution for this report. New actual

released-script mock regression covers chat/focus/preview-only3wave spells,

zero cast requests, ignores other player's key; passes. Does not prove engine

multiplayer safety. No new candidate from this audit. Do not keep asking for a

second player's crash report on withdrawn account. DESYNC70_AUDIT.md updated.



Latest (2026-10-29): Release f owner reports in-game crash during normal load,

gear/inventory/rune tests, no indicator active at disconnect. Latest report

19:38:54 explicitly NETWORK DESYNC turn2265, 7players, SD, map0.9.7.5f.w3x.

Owner later confirms others saw owner disconnect THEN crashed; their failure

type/delay/dumps unknown. Secondary cleanup lead: leave removes all player units

but leaves udg_PlayerHero populated; 1s PrepareInventories only checks nonnull

then EnableHero modifies removed hero's native inventory. Missing lifecycle

guard is concrete, but cannot explain FIRST desync. Separate19:30AV has old0x2c5ed4 stack.

Read-only polling/input/panel/tooltip call-graph audit found no reachable direct

gameplay mutations/allocations/random calls; does NOT prove natives harmless.

Need second client's SAME-match Desync.txt/*_Desync.log to compare checksum tree.

Narrow removed-hero guards built as f Hotfix01 and UI70 (3TEquip functions only).

Four regressions/all both map/editor/content/save/archive checks pass. Normal

polling rate, casts/icons/previews/combat unchanged; initial desync unresolved.

Owner only one with loaded active test items; separate synced1s maintenance is

mutating, unlike local read/render call graph. docs/DESYNC70_AUDIT.md,

build/desync70-audit.json. Original release preserved.

User naming preference: omit Forsaken in future public builds; base version and

base version plus1.29.2. Current files deliberately preserved unchanged.



Latest (2026-10-29): 0.9.7.5f release pair / development UI69. Owner reports

Legendary Shrine +10 missing after loading/job changes. Job constructors and

loaders already include 100 Legendary mastery stats; activation previously

added another10 while departure stripped10. Keep All Stats on each cached

hero by removing only six job-change +/-10 calls. Shrine choice switching and

the other five passive activation/removal paths are unchanged. Six actual-source

regressions pass (load/job/cache/shrine/passives/save/content), along with all

three map/editor/content/save/archive gates. Native f based on Hotfix16; classic

f based on Hotfix04 plus scene59 caption parity. Release f excludes Dragoon/new

Thief; UI69 keeps them. Original master/previous releases preserved. Existing

save codec stores mastery tier, NOT optional bonus selection: Legendary reload

defaults to +10; no new selection persistence claimed. Live stat acceptance and

scene crash resolution remain unconfirmed. See release/0.9.7.5f/RELEASE_NOTES.md.



Latest (2026-10-29): Owner likes UI67 but native rune aim still sometimes flashes

then disappears; right cancel/retry succeeds second time. UI68/native Hotfix16

remove native-mode left-coordinate/time cancellation, end native previews on

matching spell channel/effect (not ANY hero effect), and distinguish right aim

cancel from item pickup so next click isn't suppressed as placement. Keep all

accepted geometry/visuals, chat/FG receiver/icons/damage. -gearcheck now logs last

active clear source/cast and invalid state flags for remaining reports. Four

focused regressions/all both-branch release checks pass; actual client behavior

still unconfirmed. PREVIEW68.md. First-pass uninstalled candidates preserved.



Latest (2026-10-29): Owner likes UI66; water middle only2x, ice smaller damage

envelope, preview flicker especially no active F/G gear. Concrete cause found:

QuickGear_Poll cancels ALL previews when dock show=false due to both active

gear flags false. UI67/native Hotfix15 separates dock hiding from native aiming;

actual poll regression20 ticks preserves no-gear bag preview, still cancels

invalid pending FG/deselection. Native equipped primary/offhand screen reads

added safely via slot100/101 (runtime geometry acceptance pending). A08X/A0Q2

center17 glyphs96 vsboundary48; ice three96 paths kept +64 dim48 envelope marks

computed from actual main r200 pulse circles, no random shard prediction.

Five tests/all both-branch release gates pass. Chat/FG/casting/icons/warning/

mouse dispatch/combat preserved. PREVIEW67.md. Not all intermittent native

click/geometry behavior can be declared solved from static/mocked checks.



Latest (2026-10-29): UI65 no-blocking bag input mostly works but rune arming

intermittent/flashes after moving items. Owner rejects oversized ice circles,

sees both old/new indicators; native-warning comparison provided. UI66/native

Hotfix14 use direct mouse events plus deduplicated polled fallback and pickup

identity; recognized bag UI clicks skip stale-world-coordinate cancel path.

Duplicate generic Wave_Draw/Wave_Poll in TDamage retired (24-unit DG_Rune old

lines); actual Dragoon UI kept. Ice now three 96-unit-glyph paths vs water48,

range1200 includes last pulse radius; water footprint unchanged. Warning font

.037 and native center(.4,.20). F/G post-clear fix still preserved verbatim.

Water actual damage verified800 travel, 100->300 width + target collision;

VFX overhang does not extend damage. Four tests and all both-branch release

checks pass. Runtime visuals/bag reliability remain UNVERIFIED. PREVIEW66.md.



Latest (2026-10-29): Owner CONFIRMS UI64 F/G after -clear; preserve that exact

code. Backpack rune detection still fails. UI65/native Hotfix13 remove ALL

owned inventory overlay/button/tooltip initialization, use read-only native

console/bag dimensions + screen-coordinate slot mapping; bounds/HUD scaling

UNVERIFIED and diagnostic available. No native input interception possible

from this observer. Warning slightly higher Y .155/font .027. Water gets

48-unit glyphs outlining actual widening 800-range footprint, ice gets 15

400-visible-diameter circles matching 200-radius pulses at 200..1000 along

authored three angles. Random middle-wave shard branches omitted, no RNG or

damage changes. Five focused tests and both map/editor/content/save/archive

checks pass. Native client preview/appearance acceptance still required.

See PREVIEW65.md. Do not mistake UI63's temporary rune success for a safe UI.



Latest (2026-10-29): UI63 wave paths briefly confirmed, then owner identifies

severe proxy regression: no native tooltips/pickup/equip/drop or placement onto

wave slots; alt-tab changes stacking and trades native input vs previews. Use

right-click pickup then left OR right placement. UI64/native Hotfix12 remove

proxy click/sync handlers, disabled SIMPLEBUTTON + owned SIMPLEFRAME tooltip

hover observation hides hovered/pressed/moving-slot detectors and arms visuals

only. Native input restoration and hover delivery remain UNVERIFIED. -clear

explicit local reset, bounded recovery without Return-release dependency,

physical F/G edge fallback with shared dedupe clock; warning lower Y .14.

Do not claim UI63 accepted beyond rune appearance. See INPUT64.md. Current

cinematic implementation unchanged. Failed builds preserved in candidates.



Latest (2026-10-29): UI62 hover detector also failed. Owner reports -clear

blocks F/G until alt-tab; warning accepted except too high. UI63/native Hotfix11

adds delayed post-chat edit-focus/latch recovery and lowers warning Y .22.

Wave bag slots now use owned SIMPLEBUTTON click entry points into GearWave,

with independent validated FFBagWave63 shared receiver; existing F/G receiver,

request, icons and accepted cyan cursor preserved. This is a new candidate,

NOT native client proof: stacking/geometry/cast delivery/tooltips/drag need

acceptance. Four tests and both map/editor/save/content/archive gates pass.

Separate read-only early-vs-late scene audit finds shared helpers, valid early

portraits vs current later captions, conditional Kalm defender creation and

Gilgamesh summon/equip/revive/death-registration differences. No proven cause

or new cinematic patch. Mixed reports remain unresolved. See BAGCAST63.md and

CINEMATIC_COMPARISON63.md; audit_cinematics63.py emits exact packaged metrics.



Latest (2026-10-28): Owner UI61 screenshot proves tooltip detector failed:

4 buffers, empty last text, zero hover/preview, correct Depths lookup. Owner

accepts cyan cursor; preserve it. UI62/native Hotfix10 retire tooltip discovery,

add 30 shared-initialized owned hover probes that disable themselves before

native click, arm existing water/ice preview on verified item click. Native

click-through/geometry/event delivery remain UNVERIFIED. Warning enabled with

IGNORETRACKEVENTS, explicit gold, .024 font, client pixel center/.507 height.

Five focused tests and both map/editor/content/save/archive checks pass;

transitive local UI audit forbids handle allocation/gameplay mutation. No live

multiplayer/crash-free guarantee. Casts/icons/cursor/objects/scenes preserved.

See PREVIEW62_MULTIPLAYER.md. Prior tooltip mocks were not native acceptance.



Latest (2026-10-28): Owner rejects UI60 missing cursor and still no native bag

wave runes. Actual asset error found: selected DDS UV row y32..64 is transparent.

UI61/native Hotfix09 package exact cyan native cell (32,96)-(64,128) as TGA on

UI58's visible BACKDROP route. Pointer stays enabled for missing/invisible frame;

yellow/shadowed error at (.4,.295) follows screenshot. Stop native inventory

hover hooks. Passive cached tooltip text maps wave item names; pre-click .2s /

12px snapshot survives tooltip disappearance and arms existing wave renderer.

Only direct children of normal tooltip roots cached at shared init, no inventory

pane traversal or local frame discovery. -gearcheck gains tooltip diagnostics.

F/G casts/icons/object data/Dragoon skin/scenes unchanged. Exact native G mode

still unresolved. Five tests and map/editor/content/save/archive checks pass;

real tooltip readback and UI appearance remain UNVERIFIED. Computer-use skill

attempt failed initializing runtime before any UI action. See TARGET61_RECOVERY.md.



Latest (2026-10-28): UI60/native Hotfix08 follow owner's cyan native-vs-yellow

script cursor screenshots and invisible Classic Dragoon. Native item target

mode from G still UNRESOLVED; do not say exact engine click activation works.

Use stock HumanCursor.dds target UV via FDF, cyan tint, dedicated .01s owned UI

timer; empty ground retains unit targeting, no cast, own error-style TEXT+sound.

UI60 also sets H00C valid Footman fallback and applies built-in hctg skin once

in shared Dragoon tick; installed skin has file:sd Footman / file:de+hd CityGuard.

No stat/type/ability/save changes. Four focused tests plus both map/editor/

content/save checks pass. Appearance, latency and native skin selection require

client proof. Owner has no time to test UI59 Kalm/Gilgamesh crash candidate;

clarified cutscenes retained, only talking portraits replaced with captions.

See TARGET60_GRAPHICS.md. Native activation limitation is not solved by this UI.



Latest (2026-10-28): Owner says exit crashes only seen in FFERPG so far; also

hears all three Kalm Siege quests and arena Gilgamesh II summon crash. UI59 /

native Hotfix07 are focused scene candidates based on UI58/Hotfix06: all Kalm

and Boss_Gilgamesh dialogue uses text-only captions with original timing/skip;

shared narrator no longer requests a rawcode-0 portrait; normal Cine_Exit ends

the scene before restoring interface. No F/G, icons, previews, orders, gameplay

objects, quest logic, boss spawn/loot or save changes. Both map/editor/content/

save gates and four focused tests pass. Actual scene stability, caption layout,

and exit crash resolution UNCONFIRMED. See SCENE_SAFETY59.md. Original master

preserved; do not call CRenderBatch lead a proven JASS cause.



Latest (2026-10-28): Owner reports ACCESS_VIOLATION address FFFFFFFFFFFFFFFF;

clarifies most personal crashes are when exiting the map. Read-only audit of

81 local Crash.txt reports finds 37 with identical fault RVA 0x2c5ed4, reaching

back to 0.9.7.5c (Oct21), plus UI53-57/Hotfix04. No local UI58 crash report yet.

Dump/RTTI gives renderer-batch/container teardown lead, not proven cause. Do not

roll back equipment changes or claim latest patch caused all reports based on

this generic error. Other players' versions/actions/reports pending owner.

Asked whether unrelated map exit also crashes. No new map/teardown workaround

installed. See EXIT_CRASH_AUDIT.md; preserve current build and original master.



Latest (2026-10-28): Owner REJECTED UI57: previews appear but Ice Wand U cannot

cast; single-target cursor still absent. UI58 / native VersionEHotfix06 restore

UI55's synchronized F/G dispatch, retain its confirmed icon paint functions,

draw an explicit noninteractive screen reticle for unit targets, and add passive

hover + mouse-button polling for native equipment/bag wave preview arming.

NO native inventory CONTROL_CLICK registration or synthetic native clicks.

Wateraga materia has an independent item->spell table (not just F/G gear table).

Thirty Channel item spells now receive distinct, unused built-in cast orders in

object data, addressing carried-Gaya/Nirvana ambiguity without runtime item

mutation. Damage/mana/cooldown/target fields/tooltips unchanged. Earlier job,

Gaya, silence-backpack, travel and focus fixes retained; original master intact.

Client acceptance of cursor appearance, hover delivery and order collision fix

remains required. See GEAR_INPUT58.md. Do not call mocked tests proof of engine

behavior. UI57/Hotfix05 are failed candidates; use UI58/Hotfix06 next.



Latest (2026-10-28): UI56 primary binding workaround REJECTED by owner screenshot:

Final Wand expected A0V1, engine cast Gaya's Rod instead. Owner confirms manually

left-clicking equipped upper-panel staff/book opens the correct native cursor.

Hotfix05 native / UI57 now route F/G to those exact cached native equipment

controls, retaining UI55 confirmed icon functions unchanged. No manual sync item

order from mouse clicks, active-ability rebinding, item movement or fake unit

target rune. First unbound hero requests native Backpack once and guards delayed

click by exact hero/item/selection; this can open Backpack on first use.

Standalone wave images cover Wateraga/Depths and Blizzaga (Calculator/Ice Wand U),

including non-Dragoon Hotfix05; command-selection events still need client proof.

All three builds pass map/editor/startup/content/save gates; six focused tests

pass. Classic gameplay unchanged from Hotfix04. See NATIVE_GEAR57.md. Native

cursor dispatch, hidden-panel clicking and multiplayer acceptance UNVERIFIED.



Latest (2026-10-28): UI55 icons CONFIRMED. Prepared VersionEHotfix04 native/Classic

without new jobs, and UI56 from UI55 with Dragoon/Cuts. Job change preserves Gaya,

uses local transaction identity/per-player guards; native ASpc item-class utility

override for Silence; TravelPanel rebuilt on Warcraft checkpoint load. Native

release also gets confirmed UI53/55 input/icons. User's concurrent tests exposed

missing unit cues, carried-Gaya-Rod interfering with primary casts, and alt-tab

input lock. Native candidates add a unit selection ring, focus-state reset and

cast-time primary-unit active-binding attempt plus expected/actual spell trace.

The latter is an unconfirmed engine workaround. Ten tests and all three map/

editor/content/save gates pass; new client/multiplayer acceptance pending.

See SESSION_HOTFIX56.md; preserve UI55 icon/input behavior and original master.



Latest (2026-10-28): UI54 icons rejected; everything else confirmed working.

Owner's diagnostic proves current G item/cast is Tremors f221/A090 while art

remains Depths. UI55 changes only icon repaint/scheduling and icon diagnostics:

refresh before native cooldown rendering/idle return on existing wheel timer,

invalidate existing visible owned panel after texture change, no recreated UI

or item mutation. All F/G input/cast/load/cooldown calculations, gameplay and

wave code preserved. Checks pass; client acceptance pending. Icon task remains

priority; backpack-click indicators deferred. See QUICKUI55_REPAINT.md.



Latest (2026-10-28): Owner confirms UI53 F/G casting, including freshly loaded

characters; keep its input/casting/load behavior locked. UI54 is an icon-only

candidate built directly on UI53: independent texture refresh from live equipped

items and compiled object art, bypassing cached panel redraw/instance art. Only

QuickGear_Draw/Poll/Init existing functions change; every other existing function,

module and gameplay/object/asset resource is preserved. Focused and map/editor/save

checks pass; icon acceptance pending. Owner wants icons fixed FIRST and backpack

click indicators handled separately afterward. See QUICKUI54_ICONS.md.



Latest (2026-10-28, UI52 rejected): QuickUI53 removes all Wave native inventory

button/frame discovery hooks and all loaded-item mutation/re-seating. It keeps

Calculator/F/G rune rendering, tries input/chat recovery and live slot invalidation,

and adds `-gearcheck` for real-client evidence if F/G still fail. Native bag-click

preview remains deferred. Four regressions and map/editor/content/save checks

pass; client acceptance pending. Separate Editor-Recovery01 preserves all code

and map content while changing trigger containers; its compile/source checks pass,

opening unverified. Original master unchanged. See QUICKUI53_RECOVERY.md.



Latest (2026-10-28): QuickUI52 supersedes failed UI51 for loaded F/G and icon/bag

preview testing. Both loader formats use job-style same-item re-seating; dock

redraws live slots every tick; native bag mouse-down/nested button observers and

same-click cancellation guard added. Calculator/Aqualung/Sonic/Cuts gameplay kept.

Automated checks pass; client/multiplayer acceptance pending. Editor master still

has its 10/20 hash and valid layout but crashes in 3.0.1 while opening with HD

assets; owner asked to test SD/Classic. Master untouched. See

[QUICKUI52_LOADED_EQUIPMENT.md](QUICKUI52_LOADED_EQUIPMENT.md).



Read this first. Keep it short: it says where things stand, not what happened. Build-by-build

notes go in one row of [STAGES.md](STAGES.md); details go in the doc for that feature. The long

logs up to 2026-10-10 are in [history/](history/).



## Current development (2026-10-26)



QuickUI46 is the latest native RPG test, retaining UI45 fixes. Drakesbane reach is400 with its180-degree cone and matching rune preview; Rise base cooldown is90 seconds with normal CDR. Thief shrine lists1000 Cuts; its20 MP/second upkeep now uses an independent running clock; active stacking glow anchors middle-row/second-column and clears on rip/cleanup. See THIEF_UI45.md.21 focused integration checks pass; earlier13 Cuts regressions retained; native game acceptance pending. Earlier maps preserved.



## Where things stand (2026-10-21)



0.9.7.5c (paired stage V0975C2) is the latest public package in release/0.9.7.5c.

Both profiles pass full paired gates; see RELEASE_0.9.7.5c.md for counts/hashes.

The editor master is unchanged. src/armory-hints.json is authoritative for both

hint tooltips and click messages in the paired builder (53 updated entries).

Backpack follows cached native panel visibility without forced alternate panes;

item changes do not recreate the display or its cooldown overlays. Bazaar keeps

its original layout and native console, with shared-startup SIMPLEBUTTON click

surfaces and menu-button hover. Selected talents have gold borders.

Acid Rain is 1-second healing/damage, 2,000 each at master; skip invulnerable

Gaya in direct healing to avoid aborting the pulse before enemy damage.

Shielding is 25% overheal, independently expiring 30-second FIFO contributions,

white VFX and raised/left world text. Cure uses PriestMissile. Greens/nuts omit

obsolete Not Savable labels. Published MPQs are compacted, approximately12MB.

Recent native changes were confirmed by user gameplay testing. Final public

files still need real-client/multiplayer acceptance; legacy large-import native

Warcraft checkpoint reload remains a separate unresolved report. Save format

unchanged. Routine work uses focused checks; explicit releases run both gates.



0.9.7.5a is the previous hotfix, packaged in release/0.9.7.5a and installed/hash-

verified in Maps/Download/TEST. The 19:27 local report confirms a network desync

after Backpack opening in multiplayer, on the exact native 0.9.7.5 release.

Remove on-open native-child discovery and timer-generated command clicks;

reserve known native panel handles at shared delayed startup, then use cached

references for local visibility. The gear-header X still closes both panes;

real native input binds a new hero, with a user retry hint if no opening arrives.

Attack-tooltip origin frame is also cached at shared startup. New multi-client

and transitive local UI safety regressions run in native builds. All paired

gates pass: native266/classic366 tests, 2/13 expected skips, plus final helper,

content and install audits. Master, gameplay/object values and portable saves

unchanged; Classic MPQ body is byte-identical to 0.9.7.5. Original release kept.

Real multiplayer acceptance is REQUIRED; automated checks do not reproduce the

Warcraft network engine. See RELEASE_0.9.7.5a_BACKPACK_DESYNC.md.



0.9.7.5 is the previous named build from the user's edited master, packaged in

release/0.9.7.5 and installed/hash-verified in Maps/Download/TEST as

FFERPG-0.9.7.5-Forsaken.w3x and FFERPG-0.9.7.5-1.29.2.w3x. Both filenames and

map-list titles omit PAIR/stage labels. Internal build V0975 passes all paired

gates (native258/classic362 tests, 2/12 expected skips), including the native

deprecated-API removal check. Final archives are identical to their checked

builds after excluding the map-list header; both edited Intro and Reminder

functions match the saved master. Input SHA256 is

f7108fa827f36f0c73773308b0d464c468c14a2ff3b58b5afde25f492e4a4e7e.

See release/0.9.7.5/release-report.json for final hashes and provenance. This

build retains PAIR038's compatibility changes; no Warcraft gameplay was run.



PAIR038 is the latest test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. User reports PAIR019 also locks after the 3.0.1 client

update. Installed 3.0.1.24371 headers/defaults were extracted read-only; official

notes change rank>4 default handling. PAIR019's reported spells leave ranks>4

sparse while base ANcl has 180-second follow-through and other abilities disabled.

PAIR038 retains PAIR037's explicit authored Channel rank inheritance correction;

Warcraft acceptance is still needed to confirm control restoration. It migrates

95 calls across 11 deprecated inventory API names to supported Blz names in both

published native scripts, automatically on every paired build. All 19 announced

aliases are covered; final native/editor compilation passes with their old

declarations removed. Classic keeps its own APIs. Installed headers now drive

compiler checks; separate legacy headers still gate conversion. Native258 and

classic362 tests pass (2/12 expected skips), plus four focused API tests. Final

archive/API audits pass; both TEST copies verified; editor master/dev.txt and

save format unchanged. Legacy large-profile menu checkpoint issue remains

unresolved. See PAIR038_WARCRAFT_301_COMPATIBILITY.md. First acceptance: master

Fan of Knives, Bahamut summons, Death Screech, Tornado, Dragon Breath, Rave Kick

and Assault, including select-away/return and second casts.



PAIR037 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Explicit Backpack close now persists until a deliberate

Backpack/B reopen, suppressing native refreshes after combat/selection. Priest

row2 is Acid Rain/Holy Bolts/Swiftmend; row3 Shielding/Blessed Rain/Prolonged

Cleansing; row4 Healing Bolts/Tranquility of Life/Refresh. Effect gates, cooldown

and tooltip metadata follow the new slots. Holy/Healing Bolts use magic damage

icons; Shielding uses Cure. Holy Bolts has the user's exact short description.

Shielding's current pool appears in Defenses in both clients and beside the first

hero health bar in Forsaken. Acid Rain heals on the authored pulse interval and

damages once per second at half the authored HP/sec: master 200 HP/.1 seconds and

2000 base magic damage/second. Channel object inheritance is materialized from

earlier authored ranks across main/skin ability tables; active casts defer live

calculation tooltip writes until matching cast-end. PAIR019 comparison found the

reported Channel data unchanged and sparse in PAIR036, with live writes added

later: this is a protected engine hypothesis, not an in-game diagnosis. Retest

all reported high-rank summons, Death Screech, Tornado, Dragon Breath, Fan of

Knives, Rave Kick and Assault for restored control, plus genuine channels.

All paired gates pass: native258/classic358, 2/12 expected skips; final archive,

master/tool hashes and both TEST copies verified. dev.txt read-only check passes,

file unchanged. Editor master unchanged. PAIR036 armory behavior retained.

Legacy large-profile menu checkpoint issue remains unresolved. See

PAIR037_PRIEST_CASTING_AND_BACKPACK.md for exact changes and acceptance tests.



PAIR036 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Native Backpack retains a confirmed binding to the same hero

across closes/reopens, uses a real owned button after binding, and hides both

panes without toggling the engine on close. Initial/new-hero binding stays native

and bounded. Armory indexes category entries once, clears only visible stock per

shop, and uses a separate single-rank Back ability. Holy Bolts now uses full

Prof_StaffPower plus healing buffs/Rejuvenation, including White Robe and equipped

Staff/house proficiency. Priest Legendary row: Healing Bolts (25% of actual basic

health damage heals allies along its path), Tranquility of Life (death-location

revival with full HP/MP), Prolonged Cleansing (ten seconds of repeated negative

status cleansing after Esuna). Native row 4 icons/purchase checks and selected

spell/Attack tooltip sections are included. All paired gates pass: native246/

classic346 regressions, 1/11 expected skips; final archive/master/tool hashes and

both TEST copies verified. dev.txt passes the read-only check and is unchanged.

Editor master unchanged. Actual Warcraft acceptance remains required, especially

repeat Backpack opens, White Robe withdrawal then Back, ordinary-unit resurrection

and status protection. Legacy large-profile menu checkpoint issue remains unresolved.

See PAIR036_PRIEST_LEGENDARY_AND_INVENTORY.md.



PAIR035 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Speedrun imports omit all seven chocobo nuts/greens across

all holders; final readback permits exactly those omissions and keeps retained

items/metadata strict. The existing dev.txt passed a read-only bounded-codec check

with Silkis Greens/Zeio Nut removed; the file is unchanged. Hardcore remains

save/load-disabled, and difficulty provenance is preserved. Native Backpack

restores the real button/B hotkey without an input overlay, observes opening,

closes both panes and the engine on X/Escape, and adds input counters to -bagdebug.

Armory Back rebuilds after Channel returns and preserves category Back/Close

labels. Repeated damage-calculation and armory-hint sentences are removed.

Priest row 3 now offers Shielding (final Cure/Regen/Tranquility overheal stacks,

30 seconds after last addition), Blessed Rain (10% damage reduction in active

Tranquility) and Holy Bolts (healing increases boost basic attacks; Rejuvenation

alone +50%, same attack type, native Attack tooltip). Food cannot inherit expired

Regen's shield eligibility. All paired build gates passed (native 237/classic337

regressions, 1/11 expected skips), final archive/master/tool/output hashes were

verified, and both TEST installs match. Editor master unchanged. Actual Warcraft

acceptance is still needed for backpack focus/opening, armory navigation, Speedrun

placement and new combat talents. The separate older legacy large-profile menu

checkpoint issue remains unresolved. See PAIR035_PRIEST_INVENTORY_AND_SPEEDRUN.md.



PAIR034 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Normal, Eternity and Speedrun character loads are compatible

in both directions; the saved Speedrun tag remains informational. The user

explicitly confirmed Hardcore saving/loading must remain disabled. Preflight

and creation recheck no longer require Speedrun mode to match. Final readback

allows only boolean core field15 to differ, retaining strict section metadata,

record count/order/IDs, all other core values and existing payloads. Difficulty

provenance/Inferno restrictions, Hardcore/manual/autosave gates, capture writer

and codec ranges are unchanged. All paired gates and final archive checks passed.

The existing dev.txt passed a read-only Normal-to-Speedrun bounded-codec readback

check without file modification. Editor master unchanged; PAIR033 UI retained.

Actual Warcraft acceptance remains required: -loadf dev in fresh Speedrun, then

resave/import in Normal/Eternity, and verify Hardcore and difficulty gates.

See PAIR034_SAVE_MODE_COMPATIBILITY.md.



PAIR033 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. User reports PAIR032 still fails to open by mouse and B,

temporarily improves with alt-tab, and behaves as desired once visible. PAIR033

uses one owned transparent input over the native Backpack button and clears only

Forsaken's competing native ASpc B hotkey. Every explicit open invalidates the

cached binding and waits for a real native result. Frame visibility and internal

engine open state are modeled independently; one bounded retry reconciles a

script-hidden but internally open panel. No poll click loop; failed open clears

intent so the next press retries. -bagdebug privately reports UI state. Current

layout, Talents preference, gear controls and item behavior remain unchanged.

Full paired gates and final archive verification passed; both TEST copies match.

Classic runtime is token-identical to PAIR032, and the editor master is unchanged.

Engine acceptance remains essential: fresh PAIR033 plus -loadf, repeated mouse/B

opens without alt-tab, then focus changes/drop/use/selection/job changes. If it

still disappears, capture -bagdebug immediately afterward. See

PAIR033_BACKPACK_OPENING.md. The older legacy checkpoint issue remains separate.



PAIR032 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Follows the user's PAIR031 flickering report (temporarily

improved by alt-tab). B input latches until release; mouse-up is separate from

native/scripted command clicks. Already user-opened native panes are adopted;

hero rebind waits between native close/open/resolve and stops on timeout instead

of repeatedly clicking. Actual selection wins over stale selection-event cache.

Move to hero is now at the lower right above ring/offhand. Both profiles gain

optional current-rank calculations for Armor Breaker, Chakra, Mirage and summon

Mega/Giga/Tera Flare, Hellfire, Final Smash, Diamond Dust and Release. Summon

commands honor calculation visibility even when the hero lacks those abilities.

All paired gates and final archive checks passed; editor master unchanged.

Engine acceptance is pending, especially backpack B/mouse/held-key/alt-tab,

linked panes after drop/use/job changes, lower transfer button and new tooltips.

See PAIR032_BACKPACK_INPUT_AND_CALCULATIONS.md. No combat/save changes.



PAIR031 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Native shared item cooldowns snapshot one current-rank,

adjusted duration for the visible cooldown and shared deadline; rejected casts

do not extend it. The remaining-time message reports seconds. Native inventory

binding now uses the actual ASpc Backpack controller; explicit close intent stays

closed despite late native visibility. Move to hero supplies a synchronized,

validated gear-to-empty-hero-slot picker below Talents. Native drag itself is not

claimed repaired. Carried gear retains actives without equipped stat bonuses.

The talent header is two lines: Points: 3/4 then Level Ultimate. Both profiles

use Mana regen, omit the Heavens Forged Axe proficiency row, and label Axe training

as Axe. Fishing prompts players to wait for ! and ignores premature directions.

Paired compilation, regression, compatibility and final archive checks passed.

Editor master is unchanged. Engine acceptance remains required for cooldowns,

Move to hero, persistent closing, fishing guidance and independent multiplayer

UI actions. See PAIR031_INVENTORY_FOLLOWUP.md. PAIR030 save and Acid Rain fixes

below remain in both profiles.



PAIR030 is the previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Fixes PAIR029's older-save final readback comparison: existing

payloads stay exact; the optional trial section alone permits missing defaults

and already-Legendary trial inference. Real bounded codec rejects unrelated

profile mutations. Existing local dev.txt (2,053 characters, seven sections)

passed normalized readback without changing its file. Original saves stay intact.

Section11 now also persists per-job Proof of Strength, IDs39..61. -legendary shows

the solo level90+ boss proof and Spring of Life/Grand Crystal Spiritual Ritual.

Native Backpack/B toggle shared intent; binding clicks are guarded. Talent icons

have no overlaid names, hover boxes are inset/aligned within the panel, and the

heading shows earned points /4 plus Novice/Master/Ultimate/Legendary. Locked icons

remain hoverable; click eligibility remains enforced. Gear drags to empty hero

slots allocate a carried alias directly, preserving properties and withholding

passive stats. Acid Rain retains current-rank half-split pulses, master200 HP +

200 base magic damage each0.1sec; Chaos attack type avoids native attack-table

scaling, with map magic/healing modifiers retained. A second Priest does not

restart the active shared timer. Tooltip shows both pulse and per-second amounts.

Native215 tests (one reference-only skip), classic315 (11 expected skips), all

compiler/editor/startup/content/save/armory/bazaar gates and conversion PASS.

Final archives/master/tool/output/TEST hashes verified; editor master unchanged.

Actual Warcraft acceptance still required: original -loadf, Backpack/B/X/Escape,

Holy Book/Tournesol drag into empty quick slots plus normal equipping, icon hover,

and measured Acid Rain with two Priests. See PAIR030_SAVE_UI_FIXES.md.

The older large-character legacy Warcraft-menu reload issue remains unresolved.



PAIR029 is superseded: its final byte comparison rejected older seven-section

profiles after adding optional trial progress; PAIR030 corrects this. Other

PAIR029 commands/calculation sections, persistent Talents preference and open

armory refresh are retained. See PLAYER_COMMANDS_AND_LEGENDARY.md.



PAIR028 is a previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Resolves the actual native inventory bag frame, links both

panes, and rebinds the native preview when the selected hero changes. Fishing

spots unlock from carried/loaded rods across all storage/Gaya; fishing requires

a worn matching rod. Explicit quick-slot gear moves create ordinary carried

copies with suspended passives and retained actives; native save/load restores

those same copies. All276 canonical mappings verified in the final archive.

Acid Rain converts half Tranquility healing to damage (master2000 base HP/sec +

2000 magic damage/sec); healing flags clear after every target. Refresh base CD45.

Cure/Pray/Tranquility/Blessing of Light show formulas and current-caster amounts.

Both paired gates PASS: native196, classic296 tests (10 expected skips), all

compiler/editor/startup/content/save/armory/bazaar checks and classic conversion.

Final archive/input/tool/output/TEST hashes verified; editor master unchanged.

PAIR027 was an internal candidate, superseded after its final audit found a

quick-slot load binding issue. Actual engine acceptance remains pending: linked

panes/current job model, rods, quick-slot actives without bonuses, healing split.

See INVENTORY_PANEL_FISHING.md. The older legacy large-character Warcraft-menu

reload crash remains separate and unresolved.



PAIR026 is a previous test pair, installed and hash-verified in Warcraft

Maps/Download/TEST. Native bag/equipment panes share persistent open/close intent;

the portrait fallback close control is removed. Includes equipped-only native

passives/regen display, Prototype classification, worn cloak/fishing adapters,

synchronized gear/food cooldown vetoes, scripted Myriad/Meteor waves, nongear

carrying levels, 280-entry armory guards, Pram breeding and six-form Freelancer

capture/load. Existing nonpersistent developer gear is still omitted from saves.

Both paired gates PASS: native191 and classic291 tests (10 expected skips), all

compiler/editor/startup/content/save/armory/bazaar checks and classic conversion.

Final archives, tool provenance, unchanged master and TEST hashes verified.

Focused actual-JASS tests also cover all six Freelancer load variants. Actual

Warcraft acceptance is pending, especially native frame discovery/linking, fishing,

projectile visuals and multiplayer item cooldowns. See EQUIPMENT_INTEGRITY.md.

The earlier large-character legacy Warcraft-menu reload issue remains separate.



PAIR025 is the previous test pair, installed and hash-verified in Warcraft Maps/Download/TEST.

Adds rank-specific damage formulas for all requested abilities (40 families, 87 IDs),

including Finisher outcomes/chances, all Noxious Mixture consumables, per-hit/wave/pulse

amounts and combo/distance/HP scaling. Old numeric claims that contradicted scripted

values were corrected. Scroll of Shadows and 25 Curse-prefixed scrolls have no Gaya

holding-level gate; curse tooltips distinguish resulting gear's equip requirement.

Both paired gates PASS: native179 and classic279 tests (10 expected skips), compilation,

startup/content/save compatibility. Every covered rank verified in final object layers.

All non-tooltip object fields and every runtime function except the scroll level-check

predicate are unchanged from PAIR024, including combat/save/inventory. Master unchanged;

output/tool/TEST hashes match. Actual Warcraft tooltip layout and carrying acceptance

remain pending. See DAMAGE_TOOLTIPS.md. No combat damage balance changes.



PAIR024 is the previous test pair, installed and hash-verified in Warcraft Maps/Download/TEST.

Adds Priest Master choices Acid Rain, Refresh and Swiftmend. Refresh resets food/stat

buffs; special hero effects gain 3 seconds of remaining duration, including existing

Runic/Divine script timers. Esuna base cooldown20 retains normal cooldown modifiers.

Swiftmend doubles Regen healing for half its current-rank duration; the numeric Regen

tooltip explains the unchanged INT/Staff/target-STR formula. Native talent hover text

and selected-talent ability descriptions are included; classic retains text dialogs.

Both paired gates PASS: native173 tests, classic273 (10 expected skips), compilation,

startup/content/save compatibility. Final runtime/object/profile separation, tool

provenance, output hashes and unchanged editor master verified. Save transport,

combat engine and native backpack/rebind functions are token-identical to PAIR023.

Actual Warcraft acceptance of the new talents/buff replays is pending. Test each

choice, reset, lower/master ranks, food/stat refresh, Runic +3 seconds and multiple

players; see TALENTS.md. Runtime lives in TRegen to avoid classic dependency cycles.



PAIR023 is the previous test pair, installed in Warcraft Maps/Download/TEST.

It bundles PAIR022 master summon level40 nonhero templates, corrected Rage tooltips,

Trance/Mirage/Aim rows, requested stat ordering/percentages and Hold Position-only

Defend display (the user revoked connecting 30% to Sentinel). White Robe explains

its +6 Staff proficiency and displays the current relative Life-power bonus.

Maxed house research keeps read-only proficiency icons/descriptions. Page5 shows

effective proficiencies; native Back/Next wraps five pages including conditions;

classic supports -stats 5/next/back. Native Hunt Club hides/restores with inventory.

Native 162 and classic 262 regressions (10 expected skips) plus all build gates PASS.

Final archives and TEST hashes verified; editor master unchanged. Combat/save-read

functions are unchanged from PAIR021, as are native equip/rebind/backpack handlers.

In-game acceptance is pending. See JOB_EFFECTS.md and STAGES.md for mechanics.

PAIR022 passed as an internal candidate but was superseded before installation.



PAIR021 is the previous test pair, installed in Warcraft Maps/Download/TEST.

The user reported a fresh native backpack closing within one second. The native

UI now remembers open intent until B, Escape or explicit close, through idle and

item refreshes; selection retains intent for the hero. A shared-startup close

control overlays a discovered native X or appears as Close bag beside Talents.

No local handle allocations or gameplay writes were added. Item listeners are

not duplicated on checkpoint UI rebuild. Ten focused UI tests, native 144 and

classic 244 regressions (10 expected skips), compiler/map gates, archive and

installation hashes PASS. Classic runtime is token-identical to PAIR020; native

inventory/gameplay/save functions are unchanged. Fresh-game idle/drop/use/close

and saved-game UI restoration still need actual engine acceptance.



PAIR020 adds read-only omission of unregistered/nonpersistent and foreign-bound

items from -save/-savef/autosave. These produce empty saved slots without moving

or deleting live items; eligible items retain exact positions. Record counts use

emitted records only. Capture/bounded-string tests and both paired gates passed.

The master remains the user-edited authoring map; paired transforms carry these

runtime fixes automatically without overwriting it.



PAIR019 is the public release candidate: PAIR018 with the scenario name set to 0.9.7.4.

PAIR018: the user's editor master (0.9.7.4 patch notes in

Intro and the quest log, Reminder links, quest and map edits) plus PAIR017's backpack fix.

Its object data matches PAIR017's. Not copied to TEST; outputs are in release/pairs/PAIR018.

The master was saved by a newer World Editor (no HM3W header, fields moved into skin tables,

default-valued fields dropped); build_pair.py now normalizes that, see EDITOR_PAIR.md.



PAIR017 is the checked backpack-visibility pair, installed in TEST as

FFERPG-PAIR017-Forsaken.w3x and FFERPG-PAIR017-1.29.2.w3x (hash verified).

The user reports PAIR016 working well and is preparing a public release. Dropping

backpack items was the clearest automatic-close case. Native UI now restores an

already open backpack through a short drop/use/unequip refresh window; B/Escape,

selection changes and checkpoint rebuilding cancel restoration. Inventory/gameplay

handlers are unchanged, verified against PAIR016. All gates passed (native 139;

classic 239 with 10 expected skips), including five local UI regressions. In-game

backpack drop/use acceptance is pending. The saved editor master is snapshotted by

the builder; user edits made after the snapshot belong to the next build.



After PAIR018 all build scratch, old crash checkpoints and superseded release maps

(3.7 GB) moved to ../_delete/2026-10-16-after-PAIR018 with a manifest, for the user to

delete. Kept: pinned references, PAIR016-018, and older maps experiment tests read.



PAIR016 is the checked job behavior/stat pair, installed in the Warcraft TEST folder

as FFERPG-PAIR016-Forsaken.w3x and FFERPG-PAIR016-1.29.2.w3x (hash verified).

It covers Necromancer/Skeleton Champion moon markers, mana healing, 90-second

Undying, Aim, channeled Myriad/Meteor proxies, full-bag Chemist consumers and

rank-aware stat rows for Archer, Rage, Dark Knight, Wizard, Calculator and Prophet.

Divine Shield retains the user-approved 2-to-5 blocked damage per mana efficiency,

with clean two-caster handoff. Exact row allocation preserves space for gear bonuses.

All gates passed: native 134 tests; classic 234 tests with 10 expected skips. Ten

focused JASS/object regressions pass; final archives and editor-master hash verified.

PAIR014/015 were checked internal candidates and were not installed in TEST.

See JOB_EFFECTS.md for behavior and required engine acceptance. In-game casting,

revival, icons and panel presentation still need user testing; mocks are not engine proof.



PAIR013 is the checked passive-art/bridge pair, installed in the Warcraft TEST folder

as FFERPG-PAIR013-Forsaken.w3x and FFERPG-PAIR013-1.29.2.w3x (hash verified). The user reports PAIR012 fixes working.

Custom Amgl dummy passives now explicitly suppress inherited attachment art while

preserving authored art, extending the Ninja/Chemist fix to Dark Knight, The Reaper

and Arena circles/hints. Elysium's bridge is absent while locked, then recreated

longer/raised on Andre's unlock with a narrow walkable approach corridor. Engine

appearance/walking acceptance is pending. See LEGACY_129.md for evidence and tests.



PAIR012 is the checked gameplay follow-up, installed in the Warcraft TEST folder

as FFERPG-PAIR012-Forsaken.w3x and FFERPG-PAIR012-1.29.2.w3x (hash verified): proximity turn-in for Eidolon

Challenge; separate per-player travel dialogs with ten destinations per page and

unchanged unlock IDs; native quest searches across all carried slots; charged-item

stacking across the full inventory; Gather consolidation of existing hero/Gaya/house

stacks and matching house-ground items; equipped-only Hero Medicine refill and

Sleipnir stale-marker/aura cleanup. Both inventory interfaces and the shared save

format are retained. See BACKPACK.md for behavior and engine acceptance checks.

The first private PAIR012 attempt stopped at an outdated native quest test fixture;

the corrected fixture passes against both profiles. No incomplete pair was published.



The user reproduced a Forsaken PAIR007 multiplayer desync during `-loadf dev`.

The seven-player report/replay narrows this attempt to private preparation/first

send: the command is present without a subsequent FSCU packet for that request.

The user confirmed PAIR010 Forsaken multiplayer import no longer desynchronizes.

That private-IO separation remains: synchronized receivers validate content, export

checksums run before private writing, and file bytes/inventory interfaces are retained.



PAIR011 is the checked performance follow-up, installed in the Warcraft TEST folder

as FFERPG-PAIR011-Forsaken.w3x and FFERPG-PAIR011-1.29.2.w3x (hash verified). It reclaims unrooted save

fragments through bounded shared/private queues, releases finished projectile hit

groups, guards exhausted motion pools, caches native UI searches/render reads and

invalidates Armory/Chronicle totals on changes. Cross-module save assignments retain

roots, preserving active work and screenshot pages. The canonical source and paired

runtime maintenance carry these changes into future editor-master builds without

rewriting the master. See PERFORMANCE_AUDIT.md and SAVE_129.md.



The freeze report was after loading, with three players questing and about four

quests completed; another player had a medium-progress import. These changes repair

concrete audit findings but do not identify the engine's freezing instruction.

Extended multiplayer quest/combat acceptance remains required. PAIR008/PAIR009 and

the interrupted first PAIR011 attempt did not publish output pairs.



The large imported-character Warcraft menu checkpoint passed in PAIR004 Reforged

but still crashed in 1.29.2 Simple after quests and a complete restart. That classic

checkpoint fix remains unresolved; CheckpointNoItems.txt is installed separately

for isolation (SAVE_129.md). Earlier failed checkpoints embed the old map.



[PERFORMANCE_AUDIT.md](PERFORMANCE_AUDIT.md) distinguishes confirmed resource/work

issues from unmeasured startup opportunities. Preserve combat timer timing and

preloads unless profiling supports another change.



| Line | Map | State |

|---|---|---|

| Reforged gameplay | `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenEN.w3x` | EN lets hero/Gaya curse scrolls find matching gear across their native quick, bag and equipment slots; inventory failure keeps the original and scroll. Curse acceptance pending. EM unlocks Phoenix and Annoying Monster directly when Ao Madoushi starts; in-game quest acceptance pending. EL uses the standard gold Secrets category counter and removes the outdated Simple load warning. EK recreates Bazaar/Stats/Talents frames after Warcraft menu loads, defers initial panel setup and supplies fallback button access. UI acceptance pending; fresh-versus-saved-game clarification is still unanswered. EI validation work/timeout rollback remain; preserves DW native inventory and the FSVB format. Import and Warcraft menu checkpoint acceptance pending. EH is superseded before tester acceptance. EF Tiny import/checkpoint cycle passed. Classic Backpack/SaveSlots modules are rejected by the builder. Gameplay features and prior acceptance are recorded in SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |

| 1.29.2 development | `release/1.29.2/FFERPG_0.9.7.3-r16-stageATV.w3x` | ATV adds curses across all seven classic pages, both scroll users, and shared Ao Madoushi side offers/Simple text; in-game acceptance pending. ATU splits validation into bounded execution steps after ATT -loadf dev hung for over a minute. It drains one cache packet/player/tick and recovers stopped imports using verified rollback. Exact format, interrupted-work and load/recapture models pass; in-game import and Warcraft menu checkpoint acceptance pending. ATS Tiny import/checkpoint cycle passed. The long-string isolation probe failed with an intact container; native checkpoint acceptance for endgame profiles remains unresolved. Backpack pages, cooldowns, water projectiles, equip routing, Armory/Bazaar, autosave and collection changes remain (BACKPACK.md, SAVE_129.md). The corresponding release/...stageATV.w3x is an authoring intermediate, not the Reforged gameplay map. |

| Public baseline | `baseline/Reforged/` and `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` (stage Z) | Tracked in Git; confirmed working 2026-10-06. |



| New save system | Forsaken EN (Reforged) and ATV (1.29.2) | Shared FSVB format and permanent IDs; native Reforged equipment maps to classic equipment pages. Tiny full checkpoint round-trip confirmed in ATS/EF; ATU/EI need an endgame import test first, then a new-checkpoint test. ATT stalled during import in classic; the Python data model did not model Warcraft's thread execution budget. DW/DZ round-trip, multiplayer delivery, endgame slots, cleanup/retry, one-load and fifteen-minute cutoff passed. Priest reset, Chronicle restoration and three-second portals remain. DX is the separate multi-file test. See SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |



All 93 quests run on QuestEngine (QUEST_ENGINE.md). Bugs are deferred by user request (BUGS.md).



## Building



User editing workflow: [editor/README.md](../editor/README.md). Open/save the shared

Reforged-format `editor/FFERPG-Editor-Master.w3x`, then run `.\build-pair.ps1`.

The checked initial pair is `release/pairs/PAIR004/` (native 110 tests, classic 201

tests with 8 skipped, compiler/content/startup/save gates passed). Actual World

Editor Save As and gameplay acceptance remain pending.

The pinned authoring reference is ATV and the pinned native reference is EN;

`editor/pair-config.json` verifies their hashes. Keep these ignored binary files

with the master when backing up. Outputs publish together in `release/pairs/`.

Root `src/`, the master and reference maps are never rewritten by the paired builder.

The master uses classic/shared inventory while authoring; only the native output

contains the native Forsaken inventory and panels. Do not use a generated map as

a replacement master. Compatibility conflicts stop with retained private build logs.



1.29.2 authoring build (Windows PowerShell, from this folder):



```powershell

.\build.ps1 -Stage <next unused> -Base release/FFERPG_0.9.7.3-r16-stageATV.w3x

```



It finds changed modules in `src/`, syncs them into the base map, orders libraries, checks the

result and writes `release/<name>-stage<X>.w3x` **and** the matching 1.29.2 map in

`release/1.29.2/` (same name). The 1.29.2 conversion is part of the checks: shared code must

compile against 1.29.2, and Reforged-only UI lives in add-ons the converter swaps for dialogs

(`BazaarFrame_`, `TalentFrame_`). `-NoClassic` skips it. Existing files are never overwritten.

For a World Editor save, `.\make_129.ps1 -Map release/<map>.w3x` still converts one map.

Details and failure handling: BUILDS.md.



Design rule (user, 2026-10-10): edit in the Reforged editor, but the default map and every change

target 1.29.2 where possible; Reforged gets nicer UI on top (Bazaar 3 panels, talent panel,

the native Forsaken inventory). Saves must stay compatible between the two. Reforged gameplay

uses the Forsaken branch; paged Backpack/SaveSlots modules belong only to the classic line.

Build the native Reforged update with `python experiments/Forsaken/build_dw_update.py --stage <next>`;

its builder rejects classic inventory modules.



- The 96 regression tests and the base-map checks only rerun when `tools/`, `src/`, `baseline/`

  or the base map changed since they last passed (cache in `%USERPROFILE%\.cache\fferpg-build`).

  The output map is always fully checked. Add `-FullChecks` to force a full rerun.

- Forsaken gameplay build: `python experiments/Forsaken/build_forsaken.py --stage <X>`.

- Save diagnostic build: `python experiments/Forsaken/build_save_probe.py --stage <X> --gear-probe`

  (or `--house-probe`). Default base is ForsakenBT.

- Complete private round trip: `python experiments/Forsaken/build_save_roundtrip.py --stage <X>`.

- World Editor: enable JassHelper/vJass, Save As a new file, then `python tools/export_sources.py`

  and review the source diff before committing.



## Rules



- Owner preference (2026-10-27): every damage/balance change must update its corresponding in-game tooltips in the same build, including object fields and any runtime tooltip calculator. Verify the values in the packaged map.



- `.j` sources stay CRLF; one vJass library per trigger under `src/triggers/<folder>/`.

- Comment calculations only when they are not trivial (CONTRIBUTING.md).

- Keep dialogue, rewards and behaviour unless the change asks for it. Keep save item/job indexes

  append-only (tools/contracts).

- After a build: add one STAGES.md row, update this page only if "where things stand" changed,

  commit. Don't paste test counts, hashes or scratch paths into docs; the build writes them to

  `release/checks-*.txt` and `build-*.json` next to the map.

- Future Forsaken builds use the r17 metadata in experiments/Forsaken/map-presentation.json

  and the current src/triggers/06 Quests and story/Intro.j, including private test maps.

- When a map is superseded, it can be moved out of `release/`; keep the current AS pair and any

  Forsaken map a doc names as the current test.



## Next



Latest candidate: QuickUI51 keeps the released F/G controls/casting handlers and adds only live-item redraw invalidation plus a shared post-load active-spell rebind. A job change refreshing stale icons was the owner's key reproduction. Native bag rune observers are installed with panel creation/rebuild; actual item abilities identify wave spells and Calculator Blizzaga gains E/button previews. Confirmed Aqualung/Sonic/shrine color and gameplay objects remain unchanged. See QUICKUI51_GEAR_LOAD.md; Warcraft acceptance pending.



Latest candidate: QuickUI50 restores the released 0.9.7.5e F/G functions, declarations and UI assets exactly, with a packaged equality audit. Future normal equipment_quickcast.refresh builds keep that pinned implementation. Wateraga/Book of Depths one-line runes and Ice Wand U three-line runes reuse DG_Rune/DG_UIUpdate independently of F/G. Owner confirms UI49 Aqualung, Sonic push5 and shrine purple; keep these unchanged. See QUICKUI50_RELEASE_GEAR.md. In-client UI50 rune/gear acceptance remains pending.



Latest candidate: QuickUI49 supersedes owner-rejected UI48. F/G invokes the native equipment item controls; the dock no longer mixes simple-button artwork with ordinary backdrop icons. Native inventory/command preview hooks replace the limited quick-slot-only hooks. Aqualung uses explicit water pulses, Sonic push is 5, Dragoon tier purple matches `|cff8040ff`, and 1000 Cuts proficiency is 5% with matching packaged tooltips. See QUICKUI49_NATIVE_ITEMS.md. Live client acceptance is pending; the active older session was preserved.



Latest content candidate (2026-10-27): QuickUI48 supersedes owner-rejected UI47. See [QUICKUI48_GEAR_WAVES.md](QUICKUI48_GEAR_WAVES.md) for exact F/G icon/cursor fixes, wave rune geometry, Aqualung channel correction, current 1000 Cuts object tooltips and Dragoon shrine tier footer. Compiler/save/content and focused behavior checks pass; Warcraft engine acceptance remains pending. Preserve UI47 as a failed test reference.



1. PAIR013: check the reported moon effects and cross the Elysium bridge in both directions after Andre unlocks it (LEGACY_129.md); then start a fresh multiplayer game with the same endgame/medium imports; complete more than four quests and exercise projectile combat. Check inventory, inspection, stats/talents and collection updates after gains/removals. Confirm normal save screenshot pages remain available and file saves still import. Report whether a freeze affects one or every client and the last activity. PAIR010 loading desync acceptance passed; PAIR011 freezing acceptance is pending. The 1.29.2 large-import Warcraft-menu checkpoint issue remains unresolved; compare the separately installed CheckpointNoItems diagnostic and test only newly created checkpoints. Tiny checkpoint success does not prove the endgame case. Future edits remain in the editor master; the paired builder applies reviewed maintenance to both profiles.

2. Armory ATP/EC: root total only, each category button has its own progress and opens the right page; Close/Back has no counts. Bazaar: prepare consumes parts, purchase pays and delivers, rewards reveal and recipe-ready text returns.

3. Forsaken: load a DW save in EC and reset Priest talents: the hero/job/gear must remain, the point returns, and the Shrine positions and milestone totals match. DX remains the separate multi-file test; multiplayer timings remain pending. See SAVE_FRESH_LOAD_TEST.md.

4. Talents: user is writing each job's list (Priest first); Shrine sells Reset Talents. New content on ASC: CONTENT_DEVELOPMENT.md has worked quest/boss/item examples.

5. Optional cleanup of shared temp variables: PHASE16.md.



## Content development direction (2026-10-25)



Retain **0.9.7.5d** as the released bugfix reference; changes based specifically on that release require the owner's explicit request. New content continues from **QuickUI30**. Dragoon replaces Lancer in the planned content work, retaining job/save identity and a Classic-compatible model fallback. See [DRAGOON_PROTOTYPE.md](DRAGOON_PROTOTYPE.md) for the three-variant standalone test design; implementation and playable test maps are pending.



Dragoon01 native arena is built from QuickUI30, compile/readback checked, with focused flat-stacking/precision-formula checks passing. Installed in Maps/Download/TEST/TESTER as FFERPG-Dragoon-01.w3x. Q/W/E/R/D cast thrust/sweep/Jump/Rise/dragon; -variant 1/2/3, -reset, -proc on/off/random, -combo, -accuracy N, -evasion N, -hp N and -life control testing. Accuracy/evasion are simulated arena stats, stacks persist until reset, Jump and companion are prototype substitutes. Main RPG and 0.9.7.5d unchanged. Real-client acceptance and Classic arena remain pending.



## Current bugfix candidates (2026-10-25)



QuickUI33 supersedes UI30 for continued development, retaining 1000 Cuts and adding the same fixes as the separate 0.9.7.5d Hotfix03 copies. All three are installed/hash-verified in Maps/Download/TEST. Chronicle stats now apply once on initial fresh load; teleporter Escape has explicit handling; armory shop proxies are transparent; Divine Shield clears its inherited Drunken Haze miss/slow at all ranks. Kalm II opening/restart uses portrait-free dialogue as an unconfirmed crash workaround. Compile/editor/startup/save gates pass; real-client acceptance pending. See VERSION_D_HOTFIX_AND_UI33.md. Original 0.9.7.5d and editor master remain unchanged; Dragoon arena is separate.



Latest correction: QuickUI34 and 0.9.7.5d Hotfix04 (both profiles) supersede UI33/Hotfix03 and are installed/hash-verified in TEST. Own armory shop stays at own house; read-only visitor interfaces are created/repositioned only at the inspected house, never near the visitor's hero. Owner shop visible; guest interface transparent; independent visitor state and read-only protections preserved. All prior hotfixes retained. See VERSION_D_HOTFIX_AND_UI33.md.



Latest: QuickUI35 and 0.9.7.5d Hotfix05 (both profiles), installed/hash-verified in TEST. Keg Hunter -> Barrel Collector with identical title/save identity. Monographs count from quick/bag/equipment/Gaya/house; native bag scanning and revision-independent polling fix missing backpack credit. All three Kalm quests audited; shared GUI wave counters replaced by local counters/explicit predicate arguments; portrait-free dialogue workaround extended throughout I/II/III. No confirmed direct desync source or reproduced engine crash; in-game multiplayer replay required. All three playable/editor/startup/save checks and 12 focused tests pass. See BARREL_COLLECTOR_KALM_AUDIT.md. Earlier fixes retained.



Latest TEST maps: QuickUI37 and 0.9.7.5d Hotfix07 (both profiles), installed/hash-verified. Initial fresh load now calls the same full Hero_EndlessGrowth routine as job switching, replacing the previous partial title-only loop and including NG+ growth. Shared temp context restored; repeat refresh modeled as idempotent for Holy Swordsman at NG+ 0/1/10. Barrel Collector uses exact '-Increases rare drops in all areas' text in both profiles, with missing Classic tooltip fields restored. Earlier fixes retained. Script/editor/startup/save checks and focused behavior/load-recovery tests pass; real-client comparison still needed. See INITIAL_LOAD_GROWTH_FIX.md.



## Named release 0.9.7.5e (2026-10-25)



Owner-requested release/0.9.7.5e packages the Version D Hotfix07 pair as FFERPG-0.9.7.5e-Forsaken.w3x and FFERPG-0.9.7.5e-1.29.2.w3x. Both installed/hash-verified in TEST. Final playable/editor/startup/save checks pass, with startup unchanged from Hotfix07. Latest bugfixes included; Dragoon/1000 Cuts experiments excluded. Original 0.9.7.5d retained; QuickUI37 stays the separate development continuation. Kalm crash workaround and live multiplayer acceptance still pending. See RELEASE_0.9.7.5e.md and the release report.



Latest installed TEST candidates: 0.9.7.5e Hotfix01 (both profiles) and QuickUI38. Native Escape uses direct OSKEY input -> synchronized FFTravelClose callback with menu generation guard; Classic script remains unchanged. Divine Shield previous Ndh1/Ndh2 fix was incorrect: installed metadata confirms ANdh uses Nsi1..4. Correct fields now zeroed at all 11 ranks; bogus fields removed; future job object adapter updated. All three map/editor/startup/save checks pass; local UI safety and focused tests pass. Owner confirmation still required for Escape in a real modal dialog and shielded ranged Freelancer gun/ammo. See VERSION_E_ESCAPE_DIVINE_SHIELD.md; earlier Ndh claims are superseded.



Latest native TEST candidates: Version E Hotfix02 and QuickUI39, installed/hash-verified. Reforged teleporter now uses a modeless frame panel preserving destinations/paging/hotkeys; modal dialog is never opened, removing that input-capture dependency. Shared startup frames; local input -> generation-checked FFTravelPick sync, validated page/unlocks before teleport; Escape hides only the owner's panel. QuickGear hotkeys suppressed during browsing, chat preserved. All prior fixes retained. Both map/editor/startup/save checks, UI safety audit and 3 panel behavior tests pass; actual Warcraft Escape/layout confirmation pending. Classic unchanged. See TELEPORTER_PANEL_ESCAPE.md.



Latest native TEST maps: Version E Hotfix03 and QuickUI40. Owner confirmed Escape works in Hotfix02/UI39 but dislikes the custom appearance. Restored built-in ScriptDialog border/background/title/button dimensions on the same modeless input implementation. Escape/Cancel/navigation/travel logic and key/sync registrations are unchanged from the confirmed version. Both map/editor/startup checks, UI safety and three panel tests pass; assets/import paths verified; TEST hashes match. Original-style appearance needs in-game acceptance. See TELEPORTER_ORIGINAL_STYLE.md. Classic unchanged.



2026-10-26: Owner confirms latest native fixes working. Matching Version E Hotfix03 Classic map now installed/hash-verified in TEST as FFERPG-0.9.7.5e-Hotfix03-1.29.2.w3x. All shared fixes included; original Classic dialog retained because native frame/OSKEY UI is unavailable. Final Classic map/editor/startup/save gates pass; real 1.29.2 gameplay/Escape acceptance remains pending. See TELEPORTER_ORIGINAL_STYLE.md and adjacent Classic report.



Dragoon03 (2026-10-26): Owner revision of standalone TESTER arena: campaign Sweeping Strike cone/effects, Valiant Charge path damage extending 150 past selected target, target-only stacking -10 evasion, Rise matching radius cursor, Jump 15s, clearer three styles; fiery Life aura retained. Five behavior checks and final map/editor/startup gates pass. Native engine acceptance pending; main RPG releases unchanged. See DRAGOON_PROTOTYPE.md.



Dragoon05 (2026-10-26): TESTER owner-feedback correction: sweep no-auto-walk plus collision-overlap hits; Sonic stops before target, stab extends behind, no fire; visible horizontal Jump arc; explicit mouse-tracking ground rune cone/circle and corrected Rise targeting-image flag. Nine behavior tests and final map/editor/startup checks pass; game acceptance pending. Main RPG/releases unchanged. See DRAGOON_PROTOTYPE.md.



Dragoon06 (2026-10-26): TESTER effects comparison; all styles share variant1 mechanics. Locked target-facing charge with campaign audio, nonfire cast bursts and Q path/extension indicator; sweep90deg/450; Rise one continuous circle. Campaign/Thunder/Arcane effect sets, shared fiery Life aura. Twelve tests and final map/editor/startup checks pass; native gameplay acceptance pending. Main RPG unchanged. See DRAGOON_PROTOTYPE.md.



Dragoon07 (2026-10-26): Owner locks approved Jump and selects variant1 effects. TESTER selected kit restores native Rise single targeting rune, adds buff/cooldown-driven autocast-style icon glow; bounded gold Drakesbane mesh matches90deg/450; Sonic centre-line-only runes, selected-target10-unit nudge and separate stab sound after start whoosh.16 behavior checks and final map/editor/startup gates pass; visuals/audio still need gameplay acceptance. See DRAGOON_PROTOTYPE.md. Main RPG unchanged.



Dragoon08 (2026-10-26): Owner locks Rise after1000 max cast range (all other07 behavior retained); Jump still locked. Sonic pushback25; Dragoon melee sound ucs1 MetalMediumSlice. Fix invisible custom sweep risks: correct material flags, native BLP2 alpha, initial visibility and explicit Stand playback.18 tests and map/editor/startup gates pass; sweep/sound engine confirmation pending. TESTER latest Dragoon08. See DRAGOON_PROTOTYPE.md and experiments/Dragoon/locked-kit.json. Main RPG unchanged.



Dragoon10 (2026-10-26): Latest TESTER selected kit. Whole-unit Sonic push20 with movement-capable idle targets (previous logical-only model issue suspected); actual Garek sweep restored at1.0 (custom arc removed); Rise range800 otherwise locked. Owner-requested Jump action/facing lock fixes midair autoattack spin while preserving approved arc/timing/damage/CD/landing.20 tests and map/editor/startup gates pass; engine acceptance pending.09 was intermediate, not installed. See DRAGOON_PROTOTYPE.md/locked-kit.json. Main RPG unchanged.



QuickUI47 (2026-10-27): Latest native TEST candidate from QuickUI40. 1000 Cuts tracks dagger blades/counters/rip state per casting Thief, leaves stacks on the target for 30 seconds after walking away, and permits a rip only from that owner within 250 range on an intentional recast. Rip is `(100 + 0.3 x AGI)` per dagger with existing Dagger proficiency and 25% rear bonus; 20 MP/second upkeep remains. Sonic Thrust knockback is 10. Quick gear rechecks both equipped slots every UI poll so F/G icons update and hide reliably; target-targeted gear receives a local cursor reticle in addition to authored ground runes. Aqualung now orders its visible dummy before hiding/expiry. Map/editor/startup/save/content checks and focused Dragoon/Thief/Aqualung tests pass; Warcraft gameplay acceptance remains needed for weapon reticles, Aqualung impact and gear-slot swapping.


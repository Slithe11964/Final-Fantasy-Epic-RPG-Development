# Recovery04 / V15: restore the actual owner-confirmed working g lifecycle

2026-11-08. Owner reports another player desyncs immediately after their character loads in Recovery03 and100%failure across6multiplayer sessions. Other changes work. We incorrectly compared earlier recoveries to a newer file also named g.

## Confirmed reference and failed map

Owner explicitly confirms TEST/TESTER/FFERPG-0.9.7.5g.w3x is the working multiplayer g. SHA2569ca78509bad9e88a436a8871a407567dd1b813bd40f6fdacf5428c87ab089844,13,850,451bytes. It exactly matches release/0.9.7.5g/history/2026-11-05-before-autosave/FFERPG-0.9.7.5g.w3x. The current release/0.9.7.5g file SHA f6e884... is later and contains autosave changes; it is NOT the user-confirmed stable baseline. Earlier StableRollback maps copied that newer file and must not be described as the confirmed stable g.

Latest report03:55 Nov8 is network desync turn2023,sixplayers,SD,filenameh-TEST. Its current fileSHA45516c... matches modernGRecovery03. The report does not identify a script root cause. Preserved in evidence/report-2026-11-08-035511; reference confirmation in evidence/confirmed-reference.json. TESTER working g remains untouched.

## Material differences found

The first autosave repair (autosave100) removed udg_AutosaveTimerTrig from FFL_Guard, changed FFL_CloseWindow and added retry allocation in FreshLoad initialization. Later autosave_h02 also changed FFL_Tick, initialized autosave force membership during FreshLoad init and used a different capture entry for scheduled saves. Those changes were absent from the actual working g but present in our alleged rollback/reference. These are concrete differences, not proof of the exact desync cause.

## Recovery04 changes

Restore FFL_Guard,FFL_CloseWindow,FFL_Tick,InitTrig_ForsakenFreshLoad to EXACT confirmed-g runtime bodies, and matching editor source. Native-profile classic uses its corresponding retained pre-autosave reference. Every common FRC/FSC/FST/FSS/FFP/Load/Trig_Cmd_Load_Code function and every common FFL function except the autosave scheduling entry now matches the confirmed reference token-for-token. This includes profile reader, snapshot/apply/rollback, account checks, commit, load triggers, trigger disable/restore and manual save capture/writer.

Keep the accepted defaultON/explicitoff/20then10minute schedule. Scheduled autosaves now call the existing g FFL_BeginSave(pid,true,true) path, which uses g FRC_StartNow; remove the newer phase-completion bookkeeping and FFL_AutoInFlight flag from the shared tick. Deferred start retries remain; the newer automatic requeue after asynchronous export failure is removed along with that completion bookkeeping. Errors retain g's existing save-failure handling.

Keep autosave scheduling separate from load capture: the existing schedule timer calls Save_Autosave directly at20/30/40minutes; no duplicate trigger-expiration event. The confirmed-g autosave trigger remains the synchronized capture gate and is disabled/restored by FFL_Guard. FFL_TryAutosave waits while that gate is disabled. Thus a scheduled callback during a load can queue work without entering capture, and its20-minute one-shot is not lost. Retry timer is allocated only on the shared queue path when first needed, rather than during FreshLoad initialization. No new owner-local allocation or UI polling. Init default arrays remain false; active-player autosave-force membership is handled at match start, not by adding all8players during load-system init.

All other Recovery03/V14 functions and all archive objects/assets remain exact: Maiden Eye,teleporter,drop-flash presentation fix,normal-speed cinematic change,all quests and development creatures/jobs/effects/difficulty. No further inventory/UI refactor or global profile-read pause is added.

## Local-state audit and limits

Callgraph audit of the retained talent drawing/polling/cleanup paths covers99functions and finds no reachable explicit unit/item creation,unit/item mutations,stat changes,RNG,group/force/timer/hashtable/location construction in those paths. The visibility patch adds only conditions around existing owner-local frame visibility/panel flags. This is not formal proof of every native engine side effect or the entire map's multiplayer safety.

Autosave queue/gate/start/capture entry changes have no GetLocalPlayer branch and execute from shared timer/chat events. UI presentation and private save-file output must remain local. Their original confirmed-g routines are preserved; do not claim all local code was removed or a central server now runs the map.

## Validation and delivery

Six focused groups PASS: owner-confirmed reference hash and exact common load/save/codec pipeline; due autosave while another player loads; shared guard disabled/restored plus queue resumes1capture/tick;20/30/40callback persists when capture gate disabled; explicitoff/departures and canonical g save entry; two viewers produce identical shared queue/allocation state; all accepted non-load functions/resources retained. Both modern/classic and V15 PASS playable/editor compilation,startup/source/global pairing,native save/load text and358item/22job compatibility. No live multiplayer confirmation of Recovery04. The restored exact lifecycle is evidence of a narrower change, not proof of fixed desync.

Installed TEST FFERPG-0.9.7.5g-Recovery04.w3x,FFERPG-0.9.7.5g-1.29.2-Recovery04.w3x,FFERPG-V15.w3x. Hashes installed.json. Current full developmentV15,nextV16. WorkingTESTERg,canonicalreleases,master,Review03n andoldercandidates untouched. Do not ask for yet another multiplayer run merely because compilation passed; accurately report this identified baseline/guard mismatch.

Implementation tools/confirmed_g_load_recovery04.py,tools/build_confirmed_g_recovery04.py; tests/tools/tests/test_confirmed_g_recovery04.py.

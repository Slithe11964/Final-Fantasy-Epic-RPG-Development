# g Recovery03 / V14: premature cinematic skip candidate

2026-11-08. Owner initially associates missing quest text with the old(null) notification fix. Clarifications: productiong, all normal-speed cutscenes; no portrait visible; cutscenes finish almost immediately. This is an early-return/skip symptom, not merely a hidden caption lasting its normal duration. No live engine reproduction has yet established the exact cause.

Compared retained pre-Quest74 VersionFHotfix04 with current production: Text_Transmission,Text_Caption,Text_Say,Text_CaptionSay are token-identical. Quest74 only added a separate notification renderer and replaced QuestMessageBJ call sites. Its(null) filter does not handle those dialogue helpers. No missing dialogue text/data or removed normal-speed branch was identified. Native subtitles were already forced on at initialization. Do not falsely state the(null) filter was proven to remove cinematics.

Found a candidate boundary: Inventory94_CineEnter calls ForceUICancel(), while the common cinematic Escape handler unconditionally ends the current native scene and sets udg_CinematicSkipped=true, including outside active cinematics. Text_Transmission returns immediately for normal non-forced lines when that flag is true. Whether ForceUICancel actually causes the skip event in the owner's run is NOT verified. Web references establish that Escape/END_CINEMATIC is used for skip callbacks, not that this forced native necessarily caused this report.

Minimal candidate:
* Modern Inventory94_CineEnter retains Inventory94_ClearLocal() and removes only ForceUICancel(). The custom aim/input/panel cleanup stays exact.
* Cine_OnSkip now returns unless BOTH bj_cineModeAlreadyIn and udg_InCinematicMode are true. Real in-scene Escape skipping retains the original StopSound/EndCinematicScene/skip flag behavior.
* Classic has no Inventory94_CineEnter; only its Cine_OnSkip guard changes.

Exactly two existing functions change in modern and V14; one in classic. No new helpers/globals/events/timers/scans/frames. Text-speed voting/commands, all dialogue functions, original texts, durations, speaker names/portraits, notification(null) filter, every quest function and reward, autosave, teleporter and talent-drop visibility patch remain exact. Native UI cancellation at scene entry is intentionally removed; this is a hypothesis-driven candidate, not a confirmed restoration. No H snapshot/loading/UI polling refactor is restored.

Six test groups PASS: normal-speed portrait/full-text output and positive duration; off-scene Escape does not set skip; real active skip and forced-line behavior; Instant/caption timing; scene entry performs existing cleanup without forced native cancel; exact function scope and all other archive resources unchanged. Test harness uses real division for the dialogue timing helpers (the common quest harness otherwise treats division as integer). All three maps PASS playable/editor compilation, startup/source/global pairing, native save/load text and358item/22job save compatibility. Tests do not simulate native event scheduling or prove live scene rendering/multiplayer stability.

Installed TEST FFERPG-0.9.7.5g-Recovery03.w3x, FFERPG-0.9.7.5g-1.29.2-Recovery03.w3x and FFERPG-V14.w3x. Hashes in GRecovery03/installed.json. Modern baselineRecovery02; classicRecovery01; developmentV13. Previous outputs preserved. Review03n unchanged because story quests are disabled there; production/master releases unchanged. Current full developmentV14,nextV15.

Native acceptance needed: one ordinary quest at normal speed, portrait/text visible and dialogue holds for expected duration; intentional Escape still skips; existing native/custom item targeting followed by a cutscene remains usable. Do not claim the issue is fixed until tested.

Sources tools/cinematic_text_recovery03.py,tools/build_cinematic_text_recovery03.py,tools/tests/test_cinematic_text_recovery03.py. Native skip registration reference: https://www.hiveworkshop.com/threads/how-do-i-make-cinematic-transmissions-unskippable.298641/ .

# g Recovery02 / V12: talent and X visibility only

2026-11-07. Owner reports Recovery01 seems to work and requests ONLY the Talents button, talent panel and X flashing on dropped items. The earlier visibility variant was not multiplayer tested. Do not reapply inventory/loading/snapshot refactors or treat the earlier failed H series as a source baseline.

Baseline production GRecovery01; developmentV11. Exactly ONE existing function changes: Inventory94_ClearLocal. Zero functions, globals, timers, frames, events, scans, native getters or snapshot state added.

The existing item-change routine Inventory94_Changed calls the same cleanup used by cinematic entry. That cleanup explicitly hides ForsakenTalentRoot,ForsakenTalentToggle,ForsakenBackpackClose and ForsakenLinkedBagClose, and resets ForsakenPanelOpen=false. Those four hide calls and the panel-open reset are now conditional on the existing cinematic/pause flags Inventory94Paused OR InventoryCinematicActive OR udg_InCinematicMode. Ordinary item cleanup preserves their current visibility/open state; it never forces a closed control visible.

Cine_Enter already sets all those flags before ExecuteFunc(Inventory94_CineEnter), which calls the same cleanup. Full cinematic teardown remains. Existing owner-only guard,0.2second item-settle timing, pending casts/aim clearing, F/G cleanup, input state, inspection and carry cleanup are untouched. Existing item-event classifier and periodic reconciliation both use that same function, so a later reconciliation does not repeat the talent/X hide. This also applies to ordinary pickup/equipment cleanup through the same existing routine, without altering inventory gameplay.

Only war3map.j and war3map.wct differ in the archives. Every other function, global declaration, object, import, job, creature, arena, save/load/stat calculation, accepted autosave20/10 and teleporter/Maiden Eye fix matches Recovery01/V11. No earlier ClearAim/snapshot/guard/binding changes are included. Classic Recovery01 has none of these custom frame controls; it is unchanged. CreatureReview03m is unchanged; production fixes are forwarded to current full developmentV12 per AGENTS.md.

Five executable checks PASS: old-vs-new item cleanup and unchanged stale-input reset; closed controls never opened; each cinematic flag retains exact previous teardown; another player's item event does not mutate the viewer's controls; and exact one-function/archive/cinematic-call-order isolation. Both maps pass playable/editor compilation, startup/source/global pairing, native save/load text and358item/22job compatibility. These are script checks, not a live visual or multiplayer confirmation. Recovery01 stays preserved as fallback.

Installed TEST FFERPG-0.9.7.5g-Recovery02.w3x and FFERPG-V12.w3x. Hashes in GRecovery02/installed.json. Current full developmentV12,nextV13. No promotion to canonical released g/h filenames.

Implementation tools/talent_flash_recovery02.py,tools/build_talent_flash_recovery02.py; tests/tools/tests/test_talent_flash_recovery02.py.

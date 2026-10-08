# FF Epic RPG handoff - 2026-10-07, stage AS travel regions

Read this first, then STAGES.md and QUEST_ENGINE.md. Z remains the confirmed public baseline.
User requests Chronicle paging/counters, Secrets/Keg Hunter, monograph effects and Bazaar reopening.
Next unused stage: BH. Normal development stays on AS; Forsaken BG replaces failed BF conversion, labels gear slots and improves Inspect/Talents/scoreboard controls.

## Separate experiment - Forsaken BG

- BF failed native testing: its UnitAddItemToSlotById path generated copies at the hero's feet when equipment was redirected into native storage rather than the requested quick slot. BG removes that native call from conversion. Create/track the actual replacement handle, preserve charges/userdata/item life/proficiency/owner, vacate the original and use UnitAddItem. Verify actual possession in quick6 OR native bag rather than trusting the return value or a requested slot. Accepted replacements delete the original; rejected replacements are always deleted and the original restored (or retained on ground). Mark each attempted original to avoid failed conversion retries; synchronous busy guard prevents pickup recursion. Native equipment variants already have iequ metadata for normal matching-slot highlights/manual equipping. No automatic UnitEquipItem. Existing bag variants/actually equipped items untouched. Preparation handles quick6 and original gear in native bag, runs on current-player-hero pickups plus the periodic scan for starting gear; Gaya/NPC inventories are not converted.
- Only the experimental object overlay adds Forsaken slot: Helm/Chest/Gloves/Boots/Ring/Weapon/Offhand/Trinket immediately after the Required level line (append if no such line exists). All276 original mapped gear tooltips and their copied native variants receive the label. Original iequ/abilities/requirements/rewards/prices and all other original fields remain intact; four Materia unchanged. Canonical sources/maps and exact AS classic fallback retain original descriptions and inventory behavior.
- Inspect moves from the middle of the world view to immediately above native command-card slot3 (top-right), with tooltip anchored to the button. Use the user's offered alternative instead of inserting a real ability into NPC/boss command cards. A local Talents toggle sits beside the native character backpack (or inspected inventory); Stats label on NPCs, toggles only the FF side panel, preserves native gear/bag and independent X. BE automatic opening on each native Backpack opening remains, toggle can reopen after X. No gameplay abilities granted to NPCs for inspection.
- Experimental Multiboard overlay owns local ForsakenBoardHidden/ForsakenBoardCovered state; TEquip adds TMultiboard dependency. Entire scoreboard, including minimized title, hides during native backpack or inspection display. Existing two-second refresh respects those flags so it cannot immediately force the title back. Restore after closing unless manually hidden. Board button at top-right is available outside those windows to toggle full hiding. UI preferences/events remain per-client; board contents/gameplay are unchanged. Existing NPC read-only stats/talents/inventory behavior and sparse job transfer retained.
- All build/editor/map/source gates,96 regressions,2,000 codec cases,38 experimental tests, archive audit and additional installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Regression covers100 consecutive scans accepting quick/bag or rejecting conversion with only one replacement created, rejection cleanup/original retention, state/proficiency/owner preservation, recursion guard, all276 tooltip/object-field boundaries, new toggle/open/close/persistent board preferences and existing inspection/bag/talent paths. Archive audit allows only requested gear tooltip changes on originals and verifies world/NPC/imports unchanged and classic exact AS; JASS CRLF. An unfinished BG attempt was stopped to include subsequent user UI requests. Native acceptance pending: fresh BG game with no copy pile; pickup/drag matching-slot highlight; manual equip/unequip; slot tooltips; job/bag positions; Inspect above top-right card cell; Talents/Stats toggle beside backpack; full title hiding/restoration/manual Board toggle. BF must not be used for further play. Saving remains disabled; normal development AS, next BH.

## Separate experiment - Forsaken BF (failed native testing; superseded by BG)

- BF removes Equip gear and its FFERPGEQUIP sync hook. Once each second, prepare only mapped original gear in the current player's six quick slots: replace it with its native equipment variant in the same slot without UnitEquipItem. Preserve charges, user data, item life/proficiency and item owner. Delete the original only after verifying the variant occupies the intended slot; failed placement restores the original or leaves it safely on the ground. Existing native variants, bag contents and equipped items are untouched. Native manual equipping needs no command/button; unequipping stays unequipped. Legacy -forsaken-equip remains an optional diagnostic only. Shared sparse bag/job transfer unchanged.
- Inspect now accepts any visible, non-hidden, non-deleted selected unit except the viewer's own current hero, including NPCs and bosses for solo tests. Changing selection/loss of visibility closes inspection. Native nine equipment slots and30 bag slots remain read only. Units without a backpack show their six ordinary inventory items in the first bag row and label the remainder No backpack; no abilities/bag/items are granted. Use GetUnitLevel for NPC level.
- NPC inspection refreshes the four stats pages and HP/MP/level summary every0.1sec using read-only queries. Hide FF talent buttons/links and state No FF job talents instead of borrowing owner/job data; restore controls on player-hero rendering. NPC base HP/MP regeneration reads native base fields and is explicitly labeled; no player regeneration cache or udg_MagicDefense is used. NPC magical damage uses native armor in canonical Damage.j, so show Native armor basis/reduction and explain attack/damage types/scripted effects can alter the result. NPC cooldown omits the player hero AGI denominator, retaining live Haste/Slow/gear modifiers. Existing resistance/block/element/healing rows expose applicable layers, not a guaranteed final damage result. Own/other current-player-hero stats and talents retain BE behavior. NPC UI reads no RNG, probes, gameplay mutation or shared regeneration scratch.
- All build/editor/map/source gates,96 regressions,2,000 codec cases,35 experiment tests, archive audit and extra installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Tests cover no equip UI/sync/auto-equip, exact quick slot conversion with state/proficiency/owner preservation, rejected conversion retaining original, NPC visibility/deleted guards, NPC six-slot hover inventory, own/player versus NPC stat isolation and cooldown, local refresh, read-only callbacks and existing bag/talent/access behavior. Original objects/world/NPC/imports intact; canonical AS unchanged, classic fallback exact AS, Gaya unchanged, saving blocked; experimental JASS CRLF. An unfinished first build was stopped and restarted to include item-life/proficiency preservation. Native acceptance pending: manually equip converted quick-slot gear, unequip stays empty, job/bag order/charges, solo NPC/boss inspect/icon/inventory/live stats and player inspection. Next BG.

## Separate experiment - Forsaken BE

- BD accepted in game. BE removes the recurring automatic conversion/equip call from the one-second inventory preparation; empty equipment slots stay empty. Existing -forsaken-equip remains explicit. Add Equip gear button shown beside the standard inventory while the owner's native Backpack is visible; sends FFERPGEQUIP sync to the existing TestEquip trigger, resolves only sender's own current hero. Converts original carried gear into native variants and equips accepted empty slots; existing native variants can be equipped by the normal gear UI. No unsolicited pickup/init equip. Shared job transfer still restores only actually equipped items; bag order/handles/charges unchanged.
- Own talents/stats automatically open on each native SimpleEquipmentPanel visibility rising edge, polled every0.1sec. B/command-card access also opens them; no longer guesses native state by toggling the custom window. Independent custom X hides only talents/stats and latches the current native opening, so polling does not instantly reopen it. Closing and reopening Backpack restores talents. Esc/selection close displays. Native visibility/control behavior needs in-game acceptance; native gear/bag remain authoritative.
- Selecting another player's visible current hero displays a portrait Inspect icon above standard inventory. Click opens a separate read-only equipment/backpack window alongside the existing twelve talents/four stats pages. Nine named equipment positions + thirty bag positions with actual icons and hovered item names/descriptions/charges. Name/job/level identify target. Inspect panel's X/Esc closes inspection; talent X leaves gear/bag view open. Native body model is not cloned; this is a separate read-only view. No other player's abilities/control/inventory modified.
- Local selection/inspection state controls UI only. Current-hero and visibility predicates exclude self/NPC/Gaya/inactive jobs/fog targets. Changing selection or losing target validity closes inspection. Target owner/job key drives talent state, borrowed skills, mastery and stat cache, refreshed each second. New inspection hides old talent/stats until target refresh, preventing stale self-details. Inspection disables talent buttons and click sender guard blocks purchases; sync still validates sender's own current hero. Manual equip UI refuses inspection requests. Talent focus reset is local/owned only. Item hover slots have no action events. Creates frames uniformly at startup, no local gameplay handles/objects/RNG/probes.
- All build/editor/source/map gates,96 regressions,2,000 codec cases,33 experiment tests, archive audit and extra installed3.0.1.24342 check_map PASS;0 new source/runtime differences. Original objects/world/NPC/imports intact; canonical AS unchanged, classic fallback exact AS, Gaya unchanged, saving blocked. JASS CRLF. First unpublished build stopped on local button colliding with native button type; renamed slotButton without relaxing checks. Native acceptance pending: unequip stays empty; native drag/manual Equip gear; talent close/reopen via B/mouse; second-player icon/gear/bag hover/stats/choices/read-only/selection/fog/job changes. Next BF.

## Separate experiment - Forsaken BD

- BC UI and sparse bag transfer accepted in game. BD removes STR/AGI/INT/maxHP/maxMP from the displayed stats. Wider .21 x .49 panel, .028 side insets, centered3x4 talent grid/title, inset close button;12 reusable rows and More stats cycles four local pages, retaining talent state.
- Combat: health/mana regeneration, Magic Defense raw/%, live armor and armor defense%, evasion/accuracy ratings, physical/magical block%, cooldown reduction%. Resistances: six elemental states, non-elemental, random absorption proc separately. Elements: six attack/spell bonus pairs including omni contribution. Other bonuses: physical/magic buffs, HP/MP healing buffs, healing received, Staff/healing/Rod/Inner Mana power, flat damage guard and movement speed.
- Copied read-only accuracy/evasion/element/proficiency queries are generated from canonical sources with an active ability lookup: current unit level first, else quick6/equipped9 item abilities; bag excluded. Random absorption roll deliberately removed from resistance query; separate15% row, no UI RNG/combat probes/stat mutations. Imperil displays one lower resistance tier. Block combines independent rolls as1-product(miss); includes Interceptor, Runic, Defend and Sword fallback; attacker bypass cannot be folded into a universal chance. Evasion/accuracy remain ratings, not standalone hit probabilities.
- Cooldown reduction mirrors Cooldown.j's AGI denominator, multiplicative gear .7/.8, Hastera .67 > Haste/Auto-Haste .75 > Slowra1.5 > Slow1.3. Refresh every second and on gear events; gear/passive/buff/HP/MP changes reflected. Skill exceptions/Pharmacology's specific base cooldown remain conditional. Armor uses map DefenseArmor0.02 and native live armor; negative armor exponential vulnerability. Per-player regen cache prevents local page clicks borrowing another player's last regen. HP/MP regeneration limits from BC remain.
- Bonuses show separate applicable layers, not one promised final damage/heal multiplier. Staff power includes proficiency/current mana/Mind Charge/Concentration; physical/magic buffs include bravery/faith/pain/fog, HP-dependent Focus/Adrenaline/Serenity/Spellbreaker, Night Might/Inner Fire/Oversoul where applicable. General HP/MP healing buffs and incoming Rejuvenation/Death Screech are separate. Target/position/skill/proc-specific effects are not represented as unconditional percentages. Existing item-ID/proc/save migration remains future work; no gameplay/equipment/talent/save mechanics changed.
- All build/editor/source/map gates,96 regressions,2,000 codec cases,26 experiment tests, archive audit and additional installed3.0.1.24342 check_map PASS;0 new source/runtime differences. Original ability/item fields/world/NPC/imports intact; classic fallback exact AS, canonical AS untouched, Gaya unchanged, saving disabled. Experimental JASS CRLF. Unpublished attempts were stopped on declaration order and incorrect native equipment-slot signature/type; corrected without relaxing checks. Native page controls/readability/live buff acceptance pending. Next BE.

## Separate experiment - Forsaken BC

- User confirmed BB preserves sparse bag positions. User rejected stat/talent display: mana regeneration stayed22 despite Sorcerer's60/120 aura; Magic Defense labels/values absent; native talent icons2x4 placeholders. Do not describe BB's custom UI as accepted. Keep its successful bag transfer unchanged.
- BC creates an independent normal-frame FF panel at startup; no dependency on native stat-row handles, mixed simple/normal anchors or an all-or-nothing native frame lookup. Hero receives only fBag/fGer/ASpc; no ASde/ATal assignment. Native equipment/body and30-slot bag remain. Existing unused preview object definitions stay dormant. Obsolete ForsakenPanels.fdf/toc imports removed; baseline import table preserved.
- B/command-button4 toggles FF panel with debounce; Esc/X closes FF panel, changing selected unit hides it. -forsaken-panels provides an independent fallback if stock mouse-frame event forwarding fails. A native EquipmentPanelBackdrop found across contexts supplies alignment; otherwise fixed screen anchor. All presentation state local. Native B/mouse/key positioning and closing require play-test.
- Nine live FF labels: Strength, Agility, Intelligence, max HP/MP, health/mana regeneration, Magic Defense/raw + %. Regeneration reads live passive and active item ability levels/fields. Base plus attributes use map IntRegenBonus0.04/default StrRegenBonus0.05; Arel flatHP, AIrm/AIrn mana%, AHab/AUau auraamount/flatpercent flags, strongest own same-buff aura once. Scan hero non-item abilities plus6 active slots/9 equipped positions, excluding bag and duplicate unit/item enumeration. Sorcerer A033/Hab1 rank11=>60, rank22=>120 during Burst, added to intrinsic/gear regen. No gameplay regen changed. Instant restoration, scripted heal-over-time ticks and nearby external auras are not modeled; no claim of full combat-stat migration.
- Preserve BB equipped-variant MagicDefense helper and exact formula100*defense/(defense+50), canonical shield priority and shared calc-context restoration. Raw100=>66.67%. No native resistance stacking.
- Twelve own buttons3 columns x4 rows. Canonical A02F ranks1/2/3/4 unlock Normal/Master/Ultimate/Legendary rows. One choice per row; immediate parent required (G needs C). Row1 starts available, then one additional choice per mastery tier. Sync validation rejects wrong job, duplicate/same-row alternative, missing parent and locked rank; local visuals reflect per-player/job state. No actual skills, stats, elements or save-format changes.
- All gates,96 regressions,2,000 codec cases,20 experiment tests, final archive audit and extra installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Original objects/world/NPC/imports intact, classic exact AS. Scratch build/ForsakenBC-pu1xpnba/FFERPG. First unpublished BC-ekunknmk failed reserved JASS identifiers effect/buff; renamed regenAbility/buffId, no compiler/check relaxation. Experimental JASS CRLF retained.
- Native acceptance pending: B opens native gear/bag + FF3x4 panel and9 labels; position/readability, mouse B and Esc/X; Sorcerer normal/Burst changes after passive sync/1sec refresh; active/bag gear; Absorber defense/%; mastery rows/one choice/G parent; jobs/players, no real bonuses. Bag/Gaya/normal AS behavior preserved. Save export remains blocked.

## Separate experiment - Forsaken BB

- User confirmed BA working. Preserve exact30-slot bag positions across jobs, including gaps: snapshot source, move real handles in ascending slots, fill gaps with temporary fGap items (no abilities/charges/use), then remove only spacers. Existing destination-AInv suspension/restoration, quick-slot distinction, all9 equipped slots, charges and failed-add ground fallback retained. Gaya still has no native bag/panels.
- Add FF Magic Defense/raw and Magic Defense % text overlays to native ASde rows (replace Ability Vamp % and Magic Resistance display only). Import ForsakenPanels.fdf/toc with war3map.imp entries so editor saves retain them. Percentage uses the actual Damage.j layer: defense/(defense+50)*100; total100=>66.67%. Absorber contributes100 plus Intelligence/upgrades/other gear. Do not set native resistance modifiers, which would add a second damage-reduction layer.
- Isolated MagicDefense overlay checks original six-slot item IDs and equipped native variants, excluding unequipped bag variants. Preserve original calculation/priority, including the shield elseif chain. Build initialization belongs inside Register_Forsaken_Equipment; do not add statements to existing RegisterTriggers_MagicDefense (first attempt failed strict startup comparison). Preserve udg_CurrentHero/udg_StatCalcValue around periodic refresh. Other item-ID/proc/Armory migration remains pending.
- Replace six-cell preview with native ATal shell plus custom4x3 path buttons. Paths A-D-H-K / B-F-I-L / C-G-J-M; immediate parent required,1 point each,4 preview points per player/job. Sync validated purchases, no duplicate/wrong-job/overspending/cross-player grants. State persists only in match across job changes. Uses first3 job/borrowed icons; purchased green, available gold, locked dim. Empty native tier lists prevent native purchases. No real abilities/stats/upgrades/save fields granted; real talents are future design.
- All changes isolated in experiments/Forsaken and scratch Job/MagicDefense/Equip overlays. Native data2, ability-only Backpack/B and disabled saving retained; normal AS/src intact, classic fallback exact AS.
- Native acceptance needed: sparse bag gaps/order/charges across jobs and back; own-hero Magic Defense raw/% changes when equipping Absorber and falls when removed; bagged equipment gives no defense; talent4x3 render within native shell, G rejects before C, three paths/four points/duplicate protection, job and player isolation; closing Backpack hides overlay. No automated test claims native UI rendering.
- Validation: all build/map/editor/source gates,96 regressions,2,000 codec cases,18 experiment tests and final archive audit PASS;0 new source/runtime differences. Additional final check_map against freshly extracted installed3.0.1.24342 common.j/blizzard.j PASS, startup1508 triggers/no independent reorder. Original objects/world/NPC payloads preserved, UI import entries retained, classic exact AS. Scratch build/ForsakenBB-2qswbikv/FFERPG. First unpublished attempt build/ForsakenBB-inqj2kfm failed startup-order check; corrected without relaxing contracts. Native UI acceptance pending.

## Separate experiment - Forsaken BA

- User accepted AZ gear transfer/automatic slotting, but Greater Nectar moved from the30-slot bag to quick inventory on job change. UnitAddItem uses free quick slots first. Move the shared transfer hook after the destination's six slots are cleared and before canonical saved-item restoration. Disable only that empty destination's stock AInv during native transfer; restore its level/permanence before quick items return. Never disable the source's quick inventory. Snapshot bag items, move in source order, clear temporary references; retain equipped gear/charges and failed-add ground fallback.
- User requested stat/talent panels, selected FF job/mastery, and clarified only the visual preview matters; functional elemental upgrade paths are future work. Add fSta/ASde with installed default17 stat modifiers. Add8 player-specific ATal preview trees, each2 rows of3 cosmetic Aamk cells with all attribute bonuses0. Icons/descriptions/current ranks reflect existing5 job skills + Mastery; Freelancer uses4 borrowed skills, future-path cell + Mastery. Sync cosmetic learned indicators; update tooltip presentation locally. Never learn/upgrade actual skills or grant new talent points.
- Native stat panel reports engine modifiers; FF scripted crit/damage calculations remain independent and are not claimed as fully reflected. Talent clicks can only affect cosmetic zero-bonus indicators; existing job/mastery progression remains authoritative.
- Per user request, Gaya keeps canonical six-slot inventory: no native bag/panels supplied. Hero Backpack remains ASpc/B ability only. Saving disabled, canonical src/AS pair intact, exact AS classic fallback.
- Builder declares stock AInv with an empty modification record so new direct calls pass strict typed-reference checks; no contract relaxation or stock behavior changes. Source and panel object data remain isolated in experiments/Forsaken.
- Build/check results in STAGES. Native acceptance: Nectar remains bagged across jobs/back; quick items stay quick, charges/order retained, full30 bag/both rings, Gaya has no bag, stat/talent panels render and follow jobs, preview does not grant real skills/bonuses, multiplayer.
- Validation: all build/map/editor/source gates,96 regressions,2,000 codec cases,14 experiment tests and final archive/object audit PASS;0 new source/runtime differences. Original ability/item fields/world/NPC payloads preserved, stock AInv empty declaration, native panel bases/zero-bonus cells verified; classic exact AS. Scratch: build/ForsakenBA-x1dx47oq/FFERPG. Earlier BA-ey2p1j5m failed strict stock-AInv reference checks before declaration; no release from that attempt.

## Separate experiment - Forsaken AZ

- User confirmed AY native panel and -forsaken-equip work. AZ removes the physical Backpack object/supply; ASpc remains visible at0,1 with B hotkey, and fBag/fGer remain direct permanent hero abilities.
- Automatic one-second scan fills empty matching native slots from mapped original items in visible inventory/bag. Both ring slots supported; occupied slots never automatically replaced. Retain AY's accepted/equipped/IsItemEquipped checks before deleting originals; failed conversions retain charges/ownership and original items.
- Separate Forsaken-job.j and builder Job overlay capture the previous hero before the canonical change. After existing six-slot transfer and before stat recalculation, move equipped gear (all9 slots) then bag contents backwards using the same item handles. Enable native abilities on the new job immediately. Charges use canonical zero-during-transfer convention. Failed additions leave the item beside the current hero with a message, never delete it. No cyclic Equip/Job dependency.
- Register_Forsaken_TestEquip is now a separate startup registration helper; optional manual rescan and -forsaken diagnostic remain. Saving blocked, Forsaken data2 and exact AS classic fallback retained. Source overlays only; canonical src/release AS untouched.
- Validation/build results recorded in STAGES. Native AZ acceptance pending: automatic slots/bonuses, full bag and both rings across jobs and back, ability-only access, two-player separation and NPC gear. Remaining item-ID/proc/Armory/save migration is in experiments/Forsaken/README.md.
- Scratch source: build/ForsakenAZ-stqnkwnu/FFERPG.
- Validation: all build/map/editor/source gates,96 regressions,2,000 codec cases and11 experiment tests PASS (including full30-slot bag, both rings, job round trip and other-player isolation). Complete source/runtime agreement has0 new differences; both new triggers explicitly registered. Final preservation audit: only script/editor text, abilities/items and expansion selector differ; original item fields/world/NPC payloads retained, physical Backpack absent, classic byte-identical AS.

## Separate experiment - Forsaken AY

- AX user test: Backpack missing and carried items disappeared without stats. Confirmed code defects: conversion deleted originals after bag acceptance without equipping; periodic Backpack supply searched only six slots, while UnitAddItem may place it in the bag; stock ASpc button was hidden by the earlier abpy=-11 override.
- AY stops automatic conversion and restores canonical pickup restrictions for original items. Visible ASpc Backpack button at0,1 with B hotkey; physical fBpk carries only ASpc, direct hero abilities supply storage/equipment. Supply uses UnitAddItemToSlotById for an empty visible slot, checks both visible inventory and bag, and never overwrites gear. Full visible inventory waits; command button remains available.
- Explicit -forsaken-equip converts mapped originals in both visible inventory and bag. Remove original only when UnitAddItem AND UnitEquipItem succeed and IsItemEquipped confirms it remains equipped after restrictions; otherwise delete replacement and retain original charges/owner/stats. New chat trigger gg_trg_Forsaken_TestEquip explicitly allowed.
- Saving blocked, Forsaken data2 retained, classic exact AS. Native panel/active bonuses still need user testing; this is the experiment, not normal progression. Tests/build status in STAGES.
- Validation: all gates,96 regressions,2,000 codec cases,8 experiment tests PASS. Extra execution audit confirms manual chat registered for8 players. Native controller visibility/expansion2 and world/NPC preservation audited. Scratch build/ForsakenAY-ry_o2gzc/FFERPG.

## Separate experiment - Forsaken AX

- AW native test FAILED: capacity0, direct fBag/fGer/ASpc all0, legacy AInv1. Investigation found AS and every earlier experimental map still use war3map.w3i Game Data Version1 (Frozen Throne). Installed new ability records have version2; editor strings identify expansion2 as Forsaken Kingdom.
- AX changes only that four-byte expansion selector to2 in map info. Format39 has extra race-HUD and height-fog fields; explicit version-aware parsing preserves all other metadata bytes. This is separate from Game Data Set and installed executable version. Earlier builds missed this prerequisite.
- Object preparation now always enables expansion2 for Forsaken modern maps; manifest records it. Regression verifies selector1->2 and all surrounding bytes identical. Existing original item bases were audited against installed stock data: none inherit native equipment types; source has no stock ChooseRandomItem/ChooseRandomCreep calls, using explicit drop lists.
- AW direct native setup, Backpack item, variants, legacy AInv retention and save blocking retained. Normal AS and byte-identical classic fallback remain Frozen Throne/current behavior.
- Final checks in STAGES; native Backpack click/bag capacity still needs acceptance.
- Validation: all gates,96 regressions,2,000 codec cases,6 experiment tests PASS. Final AX vs AW audit confirms only map expansion selector and diagnostic stage text changed; object/world/NPC payloads identical. Scratch build/ForsakenAX-nmj40hbx/FFERPG.

## Separate experiment - Forsaken AW

- AV user test FAILED: Backpack visible in slot1, capacity0, queried hero levels fBgi/fGer/ASpc all0, clicking did not open UI. GetUnitAbilityLevel on a holder is not a reliable proof about item-attached abilities; zero native capacity is the confirmed failure.
- AW bypasses item attachment by giving the player hero fBag, fGer and stock ASpc directly/permanently. fGer is a unit ability (aite0); Backpack remains present. Original stock ASpc receives a name/icon and hidden command-card position to keep existing job buttons. Its native behavior is unchanged.
- Diagnostic reports direct hero ability levels and stock AInv legacy level. Legacy inventory/item definitions are retained; no inventory-removal experiment or global NPC changes. Conversion still waits for native bag capacity and successful variant acceptance.
- Release/check results in STAGES. Normal AS and exact AS classic fallback retained; saving blocked in modern experiment. Native acceptance pending.
- Validation: full gates,96 regressions,2,000 codec cases,6 experiment tests PASS. Scratch build/ForsakenAW-d1e4ofp7/FFERPG. Native Backpack click and direct ability levels need user testing.

## Separate experiment - Forsaken AV

- AU user test restored original items/NPC gear, but Backpack click did not open the panel; diagnostic showed backpack=1, bag capacity=0. Do not treat AU's native UI as accepted.
- AV adds explicit custom item abilities fBgi (AIni) and fGer (AEqu). Installed 3.0 AbilityMetaData defines inv6/equ1 as Data F (pointer6); AV writes level1 bag capacity30 and equipment level threshold0 instead of relying on inherited stock defaults. Backpack carries fBgi,fGer,ASpc to include the native interface controller. Gaya uses the explicitly configured fBag.
- This is a candidate correction, not a reproduced in-game fix. Native acceptance must confirm clicking Backpack opens the equipment/bag panel. The -forsaken diagnostic includes custom bag/gear and ASpc ability levels plus bag capacity.
- Original items/NPCs, isolated variant conversion, save blocking and exact AS classic fallback retained. Full build results in STAGES; normal development remains AS.
- Validation: full build gates,96 regressions,2,000 codec cases and5 experiment tests PASS. Scratch source: build/ForsakenAV-rp5wnkdm/FFERPG. Native play-test pending.

## Separate experiment - Forsaken AU

- User play-test rejected AT: no backpack controls and map-wide NPC/hero gear dropped. Global changes to existing equipment item types were unsafe for legacy inventories; adding the native abilities directly did not expose usable UI in that test.
- AU preserves every original item definition and adds276 native equipment variants plus a visible fBpk Backpack based on stock ebac with AIni,AEqu. Hero gets the item once there is a free six-slot slot; click it to open the native UI. Gaya gets stock AInx. `-forsaken` reports Backpack slot/native bag capacity for diagnosis.
- Only the player's hero's carried mapped gear converts, after native bag capacity is available. Variant must be accepted before deleting original; charges/ownership retained. NPC/preplaced item definitions stay untouched. Existing equip level/mastery checks retained.
- Pair under release/Forsaken/ with basename FFERPG_0.9.7.3-r16-ForsakenAU.w3x; classic fallback remains exact AS classic. Test line only, saving still blocked. New variants do not yet map back to Armory or other item-ID-based features; migration remains necessary.
- Source/builder/tests remain isolated in experiments/Forsaken. Build/native acceptance status is recorded in STAGES; automated compilation does not prove native UI rendering. Test visible Backpack click, NPC gear retention, conversion/full-bag failure and native slots. Normal development stays AS.
- AU validation: full build gates,96 regressions,2,000 codec cases and5 experiment tests PASS. Every existing item object and NPC/unit/terrain/region payload retained exactly; classic fallback byte-identical to AS. Native acceptance still pending. Generated source tree: build/ForsakenAU-riidd9k2/FFERPG.

## Separate experiment - Forsaken AT

- User requested the actual 3.0 native bag/loadout, with Armory gear assigned to its slots, and explicitly asked to keep these maps in a separate `Forsaken` release folder.
- Reforged test: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenAT.w3x`. Classic fallback: same basename under `release/Forsaken/1.29.2/`, byte-identical to the working AS classic map. Do not downgrade this native test using the regular shortcut.
- Reproducible isolated source overlay/build/tests: `experiments/Forsaken/`. Canonical `src` and ordinary releases remain unchanged; generated source tree under `build/ForsakenAT-y4rpudog/FFERPG`.
- 276 Armory gear objects receive native `iequ` slot types; four Materia remain inventory items. Add native-based fBag/fGer abilities; heroes receive both, Gaya gets the bag. Equip event runs existing level/mastery gates. Mapping is in `release/Forsaken/gear-slots-AT.json`.
- This is a UI/basic-equipment preview. Save/savef/autosave/New Game exports are blocked by replacing trigger actions, with a message; existing serializers/readers/Armory indexes remain unchanged. Expanded inventory saving, item procs/queries, crafting/quests/transfers/job changes and Ninja dual-wield migration are still required before progression play. See the experiment README.
- Full Reforged gates,96 regressions,2,000 codec cases and4 experiment tests PASS. No native in-game acceptance yet; verify actual UI, slotting/bonuses, unequipping, restrictions, Gaya, hero recreation and multiplayer. Classic fallback hash equality verified.

## Current development build - AS

- Pair: release/FFERPG_0.9.7.3-r16-stageAS.w3x and release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x.
- Base is the user's World Editor saved AR from Documents/Warcraft III/Maps/Download/TEST. It already contains both new regions and compiled Travel entries; the earlier stale-script diagnosis does not apply to that saved copy.
- Editor save produced 557 source/runtime differences from JassHelper transformations. Integration preserves editor terrain/regions/units and generated map functions, retaining checked AR library bodies before syncing Travel/Warp. No historical-difference contracts were relaxed.
- World Editor split unit/item display fields into skin files, omitted default-valued fields and externalized tooltips into WTS. The build copies missing skin fields into the main unit/item tables, restores omitted AR defaults and resolves WTS text there; skins and original editor input retained.
- Shipyard region bounds: (3040,-5984) to (3328,-5696). ArenaDarkness: (26176,-24608) to (26496,-24320).
- Append Shipyard and Arena of Darkness at indexes12/13; original indexes1..11 stay fixed, including Ice Realm9 and Elysium11.
- Warp entry selects GetTriggeringRegion instead of rechecking IsUnitInRegion. This avoids dependence on membership timing at the entry boundary; the reported native failure is not yet reproduced or confirmed fixed.
- Hero-only entry, shared per-game unlock, one effect per destination and menu behavior retained. Test both new destinations in game, including ordinary walking, repeat visits, both clients and multiplayer.
- Validation: all Reforged build gates,classic check_map,96 regressions and2,000 codec cases PASS; source/runtime agreement has0 new differences. Final editor preservation audit PASS: only script/editor text and normalized unit/item tables differ; region placements and all other named payloads retained.
- New source regressions exercise stale membership, repeat visits and fixed destination indexes. For future incremental builds use AS or another map containing these regions; the original baseline lacks them.

## Current development build - AQ

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAQ.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAQ.w3x (AE Bazaar UI).
- Chronicle category buttons now show only their names; unlocked/maximum counters remain in the descriptions.
- Secrets and its Keg Hunter entry are hidden until title59 is completed. Keg Hunter displays the standard green title and rare-drop effect wording.
- Next page uses a navigation icon and has no category preview description.
- Next page now uses `ReplaceableTextures\\CommandButtons\\BTNMove.blp`, the standard move-arrow icon.
- Full gates,94 regressions,2,000 codec cases,classic check_map and preservation PASS;1508 startup triggers,0 independent reorder.
- Elysium report remains under investigation: the east rainbow bridge is `gg_dest_DTsb_0068`, hidden during preparation and shown when Andre's reveal completes. Confirm whether the failure occurs in a fresh game after the reveal or only after loading.

## Current development build - AP

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAP.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAP.w3x (AE Bazaar UI).
- Chronicles: first10 categories + Next page; nested page2 has Time Trial and Secrets; Secrets
  contains Keg Hunter. Additive abilities cPg2/cSec/cKeg, distinct spellbook orders. Only existing
  A0AR spell list and A10C button position changed. Each category shows unlocked titles / maximum,
  including root total63. Count force membership rather than internal weighted ability levels.
  Local tooltip update1sec; synchronized pickup/inventory paths own progression.
- Keg Hunter: collect all10 books one at a time with your own hero/Gaya in one game. Duplicates,
  other units/players and rejected pickups do not count. Completion grants title59; partial
  progress stays in this game per user choice. Existing dedicated title59 save bit already read/
  written: no serializer, field, contract or inventory index changes. Restores after load/Gaya
  recreation. Full title applies all monograph bonuses without inventory space; no stacking.
- Regional books already worked on hero OR Gaya. Shared Loot predicate adds earned title59 and
  zone0 for Knight's previously excluded ordinary-loot effect. Preserve drop tables/chances,
  charged/powerup/Spider Leg rules, hero-kill restriction and essence region1..8 behavior.
  Detailed effects/region table in docs/CHRONICLES.md.
- User also reports Bazaar will not reopen after closing once. Recipe entry now explicitly
  removed/re-added at full stock after each purchase, preventing exhausted stock from blocking
  reopening. UI/session/crafting code unchanged. Source regression opens/closes3 times and
  rejects old Close packets; in-game cause/fix acceptance still needs confirmation.
- Full gates,93 regressions,2,000 codec cases,classic check_map and scoped preservation PASS.
  New pickup trigger allowed explicitly;1508 startup triggers, no existing pair reorder.
  Objects/items/recipes/quests/rewards/save format outside requested changes unchanged.
- Test native nested page navigation/Cancel and counters in both clients, sequential10 books,
  two-player isolation, completion save/load/recreation, Knight/regional loot and repeated Bazaar
  reopening from hero/Gaya/shops. Multiplayer and World Editor Save As remain unconfirmed.
  AO blue-girl timing and concurrent hunts still need user confirmation. AN/AM retained.
- Next incremental: .\build.ps1 -Stage AQ -Base release/FFERPG_0.9.7.3-r16-stageAP.w3x.
  Fresh objects/build: docs/BUILDS.md. Chronicle implementation: Titles/Loot/GameLoad/Gaya_Shared.

## Previous development build - AO

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAO.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAO.w3x (AE Bazaar UI).
- Completing Kollin's opening Arachnophobia conversation schedules Harpy Hunt availability
  two seconds later. Spider completion still unlocks Thextera only; both hunts can run together.
  Caroline: "Hello. Since you're helping Kollin, could you help me too?" Her next line drops
  "As such,". Hunt targets, 15/20 counts, rewards, logs and rare hunts are unchanged.
- Blue girl: AN source AND compiled map already had a 300-second timer on all three town visits.
  User saw her at about15:10 and absent by17:20 before talking. Early removal was not reproduced.
  Her object inherits Archer movement; AO pauses her and sets propulsion window0 on each spawn,
  preventing her walking away (including after cinematics unpause units). This is a stationarity
  safeguard, not a confirmed diagnosis of that report. Existing300-second timer, spawn chance,
  dialogue, conversation exits, gifts and ending sequence remain unchanged.
- Full gates,84 regressions,2,000 codec cases,classic check_map and scoped preservation pass.
  No objects/save serializers/startup or other modules changed. Prior AN/AM features retained.
- Test: talk to Kollin, visit Caroline before killing15 spiders; run both hunts concurrently,
  verify separate counters/rewards and rare hunts. With cinematics on/off, verify her introduction.
  Blue girl should stay at her town spawn from appearance until five minutes later when untouched;
  approach/select her during that window and check normal conversation/gift. Test with intervening
  cinematics, both clients and multiplayer. Her reported early disappearance still needs play-test.
- Next incremental: .\build.ps1 -Stage AP -Base release/FFERPG_0.9.7.3-r16-stageAO.w3x.

## Previous development build - AN

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAN.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAN.w3x.
  Classic retains AE Bazaar presentation. Develop from the Reforged map.
- Seven active chocobo foods appended at inventory indexes 352..358: Pram Nut/I045,
  Luchil Nut/I07F, Carob Nut/I07G, Zeio Nut/I07H, Gysahl Greens/I027,
  Mimett Greens/I07Q and Silkis Greens/I0KE. Charged classification recorded; quantities saved.
  BP/bazaar purchase proxies, information items and unused OLD greens remain unsavable.
- ItemAllowed checks udg_SpeedrunMode, not difficulty. All other modes/difficulties allow the
  seven items. Inventory save count and payload both skip food in Speedrun; load consumes its
  charge bits and discards it through the existing rejection path. Other inventory still loads.
  Shared inventory functions cover hero, house, Gaya and other serialized inventory containers;
  manual/autosaving use the same mode check. Ownership and legacy F rejection retained.
- Old 351 inventory IDs, jobs, fields and existing G/H fixtures unchanged; SaveFlagCount now358.
  No new armory flag/proxy: counter stays280. AM's four appended materia bits retain their order;
  its helper already places future inventory indexes after them. No object/ability/item edits.
- Only Save_EncodeInventory and Cmd LoadInventory gain mode predicates. Separate reviewed
  tools/contracts/chocobo-food-save-extension.json pins exact body/helper hashes and appended
  item/charge mappings. Original compatibility contract and AM extension remain unchanged.
  Reverse only mode predicates to recover original serializer fingerprints. Older saves remain valid.
  New saves containing food need AN+ to restore it outside Speedrun.
- Full gates, 82 regressions, 2,000 codec cases, classic compile/check_map and scoped preservation
  pass. Original objects/rewards/Bazaar/travel/Gaya behavior and other modules unchanged.
  Tests execute actual source across every difficulty, all seven quantities, skipped-item alignment,
  mixed/all-food inventories, ownership, legacy rejection and reviewed-policy refusal.
- AM Materia storage/hints/N / 280 and earlier UI/Gaya/dev changes retained; no new in-game
  confirmation has been reported. Test each food quantity outside Speedrun, then load the same
  mixed inventory into Speedrun: food absent, other items/quantities correct. Test Speedrun saves
  omit food, hero/house/Gaya, old codes, both clients/multiplayer and World Editor Save As.
- Incremental: .\build.ps1 -Stage AP -Base release/FFERPG_0.9.7.3-r16-stageAO.w3x.
  Fresh clone workflow: docs/ARMORY.md / BAZAAR.md. Food policy: docs/SAVE_CODES.md.

Git attribution: the user requested all repository history and future commits use Slithe with
338753050+Slithe11964@users.noreply.github.com. Historical comparison references were updated after
rewriting author/committer metadata; all 47 tests pass. The original history bundle is kept outside
this repository in ../_archive/FFERPG-before-slithe-attribution-2026-10-06/. Map bytes are unchanged.

## Confirmed public baseline

- **Develop/edit:** baseline/Reforged/FFERPG_0.9.7.3-r16.w3x.
- **Play in 1.29.2 or Reforged:** baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x.
- baseline/manifest.json records hashes and provenance. build-config.json pins the development
  master. Both maps are tracked; generated release builds are ignored.

The user chose the parent-folder r16 as the starting point, then agreed to carry its edits into the
Reforged master and generate the matching classic copy. That input was already classic format.
Its substantive differences from Y were quest-log GUI/text and pathing; object field values were
unchanged. Most script differences came from JassHelper inlining. Z carries the quest-log/pathing
edits and complete object data into W's repaired editor layout, retaining the latest user-authored
Intro.j welcome wording. No new gameplay, dialogue or reward changes were made.

All 93 quests use QuestEngine. S is user-confirmed working. Later safeguards, V shared-context
cleanup and W editor pairing remain included. Bugs remain deferred by user request. The Chemist/
Ninja passive-art fix remains; Gaya selection settings are preserved. Flying Gaya/crow lines are
the client's Air-to-Ground Indicators, independent of conversion.

## Workflow

```powershell
.\build.ps1 -Stage AQ -Base release/FFERPG_0.9.7.3-r16-stageAP.w3x
```

The builder selects changed enabled modules, syncs, normalizes pairing, orders libraries, runs
all map/source/quest/content/save checks, regressions and codec tests, then adds the header and
publishes new files without overwrite. Use -Base with the newest reviewed Reforged build for
incremental work. World Editor edits: enable JassHelper/vJass, Save As a new file, check it,
export/review source changes, then convert that saved file:

```powershell
.\make_129.ps1 -Map release/<editor-saved-map>.w3x
```

The converter uses the tracked classic baseline for map-info template/missing object defaults,
compiles the runtime against 1.29.2, preserves editor files and outputs the same basename under
release/1.29.2/. The local batch accepts the same arguments. Bazaar frame UI is converted to the AE dialog
in both runtime and editor source. No sibling toolkit/r7 dependency.

Keep .j sources CRLF; comment calculations only when non-trivial. Preserve behavior/dialogue/
rewards unless requested. Record builds in STAGES.md and update this handoff and local parent
RESUME_PROMPT.txt. Commit relevant changes. Read BUILDS.md before resolving source/runtime failures:
exact historical contracts are intentional; never regenerate them to silence new differences.

## Verification and pending tests

Z passes all gates and 2,000 codec cases. Packaging has 47 passing regression tests. Both editor
formats round-trip byte-exact with valid pairing. The classic baseline compiles for 1.29.2 and
passes check_map against the master: 1,503 startup triggers, no reorder. Selected r16 quest-log
GUI actions/pathing are preserved in both; object files/WTS are byte-identical in the Reforged
master. Classic runtime exactly matches the converter transform of the master.

The user confirms both paired maps are working great on 2026-10-06. This is the confirmed
development starting point for Reforged and 1.29.2. Specific multiplayer/save-load/cinematic coverage
was not itemized. A separate editor Save As was not explicitly confirmed. Test each future change
in both clients and use QUEST_TESTS.md for focused content.

GitHub readiness checked: baseline pair, sources, toolchain, contracts, fixtures and guides are
tracked. The local downgrade_129.bat/make_129.ps1 and every conversion dependency are included.
No MapToolkit installation or parent-folder r7 map is needed. Use Python 3; JassHelper/World Editor
are external requirements for editor saves. Historical source regressions require full Git history.

## Repository and archive

Keep baseline/, src/, tools/, docs/, wrappers and release/ for future outputs. Retain contracts,
fixtures, PHASE16.md/handoff CSV, system/content guides and source/object references. Historical
auditors remain: current regressions depend on the V auditor and Git history.

Old stages, reports, obsolete surveys/readability plan and scratch files are preserved at
`../_archive/FFERPG-before-r16-baseline-2026-10-06/`, including the original user r16, previous docs,
pre-cleanup diff and eleven already-deleted reports recovered from Git. The paired baseline/source repository is now published under Slithe11964.
Next: play-test AC, then requested content; bugs remain deferred.

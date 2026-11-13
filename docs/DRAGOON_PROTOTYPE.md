# Dragoon development and play-test specification

Updated 2026-10-26. Status: native Dragoon03 arena built and checked; gameplay acceptance pending. Current implementation below supersedes the initial tuning proposal.

## Branch references

0.9.7.5d is a retained release, not the content-development base. Keep both released archives and their release report unchanged. Only base a fix on it when the owner specifically requests a 0.9.7.5d fix. New content continues from release/development/QuickUI30. Preserve existing uncommitted Thief and asset-gallery work.

## Shared Dragoon contract

Rename Lancer to Dragoon while retaining H00C and job/save index 7. Make its basic attack melee. Resolve hctg City Guard from installed native object data before setting the native model; do not guess a file path. Classic 1.29.2 retains the existing Lancer model. Future native-only models/effects get explicit working Classic substitutes; imperfect animation or appearance is acceptable to the owner. Gameplay must remain equivalent.

Keep the existing summon dragon behavior. Keep Jump, move it to an ordinary ability slot and halve each existing rank's cooldown. Preserve its targeting and landing behavior. Check command-card space for all five abilities and existing job controls.

Sonic Thrust: target-unit dash ending at melee distance, followed by one thrust hit. Reduce target evasion by a flat 20 per hit, stacking. Arena stacks persist until reset; effective evasion floors at zero. Use the RPG evasion calculation when integrating; armor reduction is not a substitute. Stop safely on target death/removal or blocked landing; never teleport through arena boundaries.

Drakesbane: aim at a ground point; face that direction and hit enemies within a total 60-degree cone (30 degrees each side). Roll exactly once per successful cast that hits at least one enemy, with a 50% chance to grant Life of the Dragon for 5 seconds. More targets must not increase proc probability. Reapplication refreshes duration. Show the buff and remaining duration clearly.

Rise of the Dragon: ground-target circle, proposed radius 300. Requires active Life of the Dragon at execution; consume it on successful cast. Hit and stun enemies in the circle. Check each enemy's HP percentage BEFORE dealing damage; strictly below 30% receives 50% bonus damage. Proposed stun: 1.5 seconds. Invalid casts do not spend the buff. Death/reset removes proc state.

All numbers below are initial test tuning, not final RPG balance. Damage uses INT to emphasize melee spellcasting; test all variants at the same stats.

## Three selectable versions

| Property | 1: Swift spear | 2: Heavy impact | 3: Flowing dragon |
|---|---|---|---|
| Sonic Thrust | 0.15s dash, immediate stab | 0.25s windup, 0.20s dash, strong impact | 0.25s dash with a spectral trail |
| Thrust damage / cooldown | 100 + 2 INT / 4s | 150 + 3 INT / 6s | 100 + 2 INT / 4s |
| Drakesbane | immediate single sweep | 0.35s readable windup, broad VFX | 0.20s sweeping spear trail |
| Cone reach | 325 | 400 | 350 |
| Sweep damage / cooldown | 120 + 2 INT / 5s | 180 + 3 INT / 7s | 120 + 2 INT / 5s |
| Rise presentation | immediate rising burst | 0.45s marked eruption | 0.25s spiral into rising burst |
| Rise damage / cooldown | 250 + 4 INT / 10s | 350 + 5 INT / 14s | 250 + 4 INT / 10s |

Keep targeting, proc odds, buff duration, evasion reduction, ultimate radius and stun identical across versions. Version 3 allows movement promptly after each hit; it does not add extra proc rolls or extra damage ticks. Avoid long forced animation locks in every version.

## Standalone test arena

Use the working Thief template builder workflow; build_thief_daggers.py prototype 01 is quarantined for map-browser crashes and must not be reused as a playable base.

One Dragoon; a central durable dummy; cone-boundary dummies at +/-29 and +/-31 degrees; circle-boundary dummies; and a small enemy pack. Provide a damage/target-count log, target evasion display, proc success/failure message, five-second buff countdown and ultimate bonus indicator. Dummies should survive repeated testing and have resettable HP.

Q Sonic Thrust, W Drakesbane, E Jump, R Rise of the Dragon, D summon dragon. Chat commands avoid using additional command-card slots:

- -variant 1/2/3: switch presentation/tuning, clear buffs, cooldowns, damage logs and summons.
- -solo thrust/sweep/rise: isolate the named spell and show its targets.
- -combo: enable all five spells, normal costs/cooldowns and genuine 50% proc rolls.
- -proc on/off/random: force outcomes in isolated tests; combo always restores random.
- -hp 29/30/31/100: set enemy health percentage to check the strict execute threshold.
- -reset: restore positions, HP/MP, cooldowns, targets, proc state and summons.

First compare each spell across versions, then run each full kit. Include forced-proc isolated Rise testing so a tester never has to fish for a random buff to examine it. Test no-hit sweeps, multiple targets, buff expiry during targeting, repeated dash casts, target death mid-dash, Jump cooldown and dragon persistence.

## Acceptance before delivery

Build/read back and compile both target-profile scripts for any delivered pair; verify target model resolution and Classic fallback. Test cone/radius boundaries, one proc roll per cast, strict HP threshold, evasion expiration and reset cleanup with behavioral checks. A prototype uses an explicit evasion simulation until wired into the RPG damage engine. Label that distinction in its test instructions. Actual Warcraft gameplay acceptance remains with the owner. Do not claim a playable test exists until its map has been built and checked.

Owner update: Drakesbane and Rise add max(0, caster accuracy - target current evasion) as flat damage per target. Arena exposes both stats for isolated testing.


## Dragoon03 owner revision (2026-10-26)

Playable native arena: release/development/Dragoon03/FFERPG-Dragoon-03.w3x, installed in TEST/TESTER. Earlier maps and the main RPG releases remain untouched. Dragoon02 was an intermediate build, not delivered.

Drakesbane now uses campaign AHsw (Garek Sweeping Strike) with native 60-degree cone targeting. Native damage/talent effects are zeroed; scripted damage and the once-per-successful-cast proc remain authoritative. Campaign SweepingStrike and SweepingStrikeTarget effects are used. The static ability geometry for each variant matches its damage cone; Rise uses a native Channel AoE circle matching its damage radius. Local installed campaign definitions and exact asset bindings are retained in experiments/Dragoon/campaign-reference.json.

Sonic Thrust uses ValiantCharge art and hits each enemy along the swept path once, continuing 150 units beyond the selected target. Only the selected target receives flat stacking -10 evasion, floored at zero. Jump cooldown is now 15 seconds. Preserve the fiery ImmolationRedTarget Life aura and its five-second duration.

| Command | Style | Charge speed / half-width | Sweep reach / delay | Rise radius / delay |
|---|---|---|---|---|
| -variant 1 | Campaign Spear | 1000 / 100 | 350 / 0.1s | 300 / 0.1s |
| -variant 2 | Heavy Impact | 750 / 140 | 450 / 0.5s | 350 / 0.65s |
| -variant 3 | Lightning Flow | 2200 / 80 | 550 / 0.15s | 300 / 0.15s |

Heavy retains higher damage/cooldowns. Flow uses a blue double sweep visual. A persistent hero label and reset announcement identify the active variant. Reset dummies include path targets, one behind the selected target, one beyond the charge, and cone inside/outside targets. Use -proc on for isolated Rise checks; -combo restores random procs.

Validation: five automated checks pass (swept hits and target-only debuff, cone boundaries/static cursor geometry, one proc roll with fiery buff, Jump cooldown, distinct charge durations). Test interpreter uses real division for vector calculations. Final archive readback, playable/editor compilation, editor pairing, startup/global consistency and text safety pass. Native cursor appearance, animation feel, movement and effects still need Warcraft gameplay confirmation. This remains a standalone native prototype with simulated accuracy/evasion and simplified Jump/dragon companion; RPG and Classic integration are separate work.


## Dragoon05 correction (2026-10-26)

Owner gameplay feedback supersedes the Dragoon03 charge/Jump/indicator implementation. Deliver release/development/Dragoon05/FFERPG-Dragoon-05.w3x into TEST/TESTER. Dragoon04 is an intermediate build, not installed.

- Drakesbane no longer walks toward the clicked aim point before casting (native cast range is decoupled from sweep reach). Damage uses the same 60-degree ground cone and includes unit collision bodies touching its edges. All seven interior targets are hit in the behavioral check. Previous native-only targeting and center-only checks were insufficient.
- Sonic Thrust stops 90 units in front of the selected target, runs its attack animation on arrival, and extends only the final stab hit segment to 150 beyond that target. Path targets are hit once; only the selected target receives -10 stacking evasion, on impact. No Valiant Charge aura, fiery spell trail or fire impact is spawned. Life of the Dragon's fiery aura remains unchanged.
- Jump now interpolates horizontal position over the same 0.8-second vertical arc; it no longer rises/falls at the origin and teleports on landing. Cooldown remains 15 seconds.
- W/R aiming draws explicit cyan ground runes along the cone/circle boundaries, following mouse aim. W/R hotkeys and command-button click handlers activate the respective preview; click, Escape, cast and reset clear it. Rise also now enables Channel's targeting-image bit (Ncl3=19, retaining visible/unique flags); previous 17 omitted that bit. Rune image texture DragoonRune.tga is embedded and checked in archive readback. Rise's liked FlameStrike visual remains unchanged. Arena is single-human-player only; preview state is not suitable as multiplayer RPG UI without local-only rendering and synchronized gameplay separation.

Final playable/editor compilation, editor pairing, startup/global consistency, archive readback and text safety pass. Nine behavioral checks cover path/behind-target damage without passing the target or fire, target-only stacks, all interior sweep targets and collision overlap, matching rune geometry in all variants and hide behavior, unchanged fiery proc and once-per-cast roll, Jump midpoint travel/height and landing, 15-second cooldown, and distinct charge timings. Rune visibility/frame input/native animation and overall feel still require Warcraft gameplay acceptance.


## Dragoon06 effects comparison (2026-10-26)

Latest owner instructions supersede the earlier mechanical variant differences. Deliver release/development/Dragoon06/FFERPG-Dragoon-06.w3x in TEST/TESTER. Use variant 1 speed/timing/balance for every style: Sonic speed1000, width100, 100+2INT damage, 4s cooldown; sweep 0.1s, 120+2INT+precision, 5s cooldown; Rise 0.1s, 250+4INT+precision, radius300, 10s cooldown. Sweep is intentionally widened from60 to90 degrees and extended350 to450 in every style. Jump remains0.8s travel/15s cooldown. Life's fiery buff remains shared and unchanged.

- -variant 1 Campaign Dragon: dust cast burst, campaign sweep, liked FlameStrike Rise, WarStomp Jump landing.
- -variant 2 Thunder Spear: Defend cast burst, Relentless Cleave sweep, ThunderClap/Monsoon Rise, ThunderClap landing.
- -variant 3 Arcane Dragon: Blink cast burst, blue sweep swing/Blink, Blink/HolyThunderClap Rise, Blink landing.

Sonic casts play the actual installed ValiantCharge.ogg (retained in experiments/Dragoon/ValiantCharge.ogg and embedded as DragoonCharge.ogg). Cast visuals are brief nonfire bursts; no sustained Valiant Charge fiery aura. Clear prior orders, pause hero for the dash, select deterministic City Guard Walk1 animation index3, and enforce instantaneous target-facing each tick with moving-target destination updates. Arrival unpauses, clears queued orders and selects Attack1 index1, avoiding random attack/spell selection. Death and reset also release the lock. Path damage and selected-target-only stacking -10 evasion remain intact; hero stops90 before target and final stab segment reaches150 beyond it.

Q aiming now shows a target-following path corridor and centre line through the target to the stab extension; mouse focus snaps aim to the enemy centre. W ground cone matches90 degrees/450 reach. Rise uses one continuous600-diameter image (DragoonCircle.tga), with the many small rune-ring markers hidden; native Channel duplicate targeting image is disabled (Ncl3=17). All indicators use shared mechanics across styles. This arena has one human player; local mouse preview must be redesigned for multiplayer integration.

Validation: twelve behavior checks pass, including action lock/facing/release on arrival and death, equal timings and distinct model sets, wider cone and object geometry, one Rise circle/Q extension, unchanged hit/debuff/proc rules and Jump motion/CD. Final playable/editor compilation, editor pairing, startup/global consistency, text safety and embedded archive readback pass. Campaign sound source and City Guard animation sequence names were read from installed native assets. Real animation, audio and indicator appearance still require Warcraft gameplay confirmation. Main RPG release archives remain untouched.


## Dragoon07 selected kit (2026-10-26)

Owner locks Jump from Dragoon06 and selects variant1 effects for all spells. Latest playable build is release/development/Dragoon07/FFERPG-Dragoon-07.w3x, installed in TEST/TESTER. Legacy variant commands now reset to selected campaign kit. Damage, speed, cooldowns, fiery Life aura and approved Jump remain unchanged.

Rise: remove custom always-rendered RiseRing image entirely and restore native Channel targeting-image bit (Ncl3=19) on all Rise ability objects, radius300. This returns to the native single large rune available before Dragoon06 rather than 64 perimeter markers or a persistent custom circle. Add native UI/Feedback/Autocast/UI-ModalButtonOn.mdl sprite anchored to R command button: visible only while Life is unexpired, cooldown ready, hero alive and selected. Refresh on proc, consumption, timer and reset. Sprite is noninteractive; it does not toggle autocast orders. Actual rune/glow visibility remains an engine acceptance item.

Drakesbane: installed campaign SweepingStrike is a Popcorn emitter with hard-coded broad particle geometry; uniform scaling cannot clip it to the damage sector. Replace the oversized origin sweep with an additive gold ribbon/wake mesh bounded exactly to90 degrees/450 reach, with short opacity animation. tools/dragoon_effects.py builds embedded DragoonSweep.mdx and DragoonSweep.tga. Keep the campaign SweepingStrikeTarget hit flashes, timings and proc rules. Mesh boundary and archive structure are checked; actual rendering/appearance needs native acceptance.

Sonic: only32 centre-line runes remain (no corridor boundaries), continuing150 beyond selected target. Selected-target hit nudges that target10 units away from charge direction and plays embedded DragoonStab.ogg (installed metalmediumsliceflesh1.ogg) exactly once. Preserve ValiantCharge start whoosh, nonfire cast dust, locked target-facing movement,90-unit stop, path damage and selected-only stacking -10 evasion. Side targets are neither nudged nor given the primary impact sound.

Validation:16 behavior checks pass, including unchanged approved Jump block/default landing, sound order and one10-unit selected-only nudge, ready-glow lifecycle, selected effect consistency, native Rise object flag/radius, centre-line-only visibility, mesh sector containment/archive structure, existing charge/proc/damage rules. Final playable/editor compilation, pairing, startup/global consistency, text safety and full archive readback pass. Owner gameplay confirmation remains required for restored Rise cursor, ready sprite, custom sweep mesh and audio mix. Main RPG/releases unchanged.


## Dragoon08 locked Rise and sweep rendering fix (2026-10-26)

Owner approves Rise's Dragoon07 targeting/effects/ready icon and locks it after changing max cast range to1000. All three Rise object ids now have aran1000; otherwise their object fields and RiseVisual, RiseRadius, UpdateRiseReady, Resolve and Cast source match approved07. Jump remains locked to approved06. Persistent approval record: experiments/Dragoon/locked-kit.json. Do not retune or restyle either spell without an owner request.

Sonic primary pushback is now25 units instead of10; whoosh/stab timing, only-primary nudge/sound, damage, charge lock and indicators remain unchanged. Dragoon auto-attacks now use metadata-verified ucs1 (weapType1) = MetalMediumSlice, restoring melee contact sound after the Lancer projectile attack conversion.

Drakesbane07's custom arc was reported invisible. Corrected the material bitmask:0x13 accidentally included SphereEnvMap (0x2), rather than Unfogged (0x20). It now uses0xB1 (unshaded/two-sided/unfogged/no depth writes), AddAlpha blending, native BLP2 texture with explicit8-bit alpha, visible initial opacity, and explicit Stand playback at effect creation. Geometry remains bounded90deg/450. Material definitions cross-checked against primary parser source: https://github.com/flowtsohg/mdx-m3-viewer/blob/master/src/parsers/mdlx/layer.ts . This fixes concrete rendering risks; real engine visibility remains unconfirmed.

Latest map: release/development/Dragoon08/FFERPG-Dragoon-08.w3x, installed/hash-verified in TEST/TESTER.18 tests pass, adding locked Rise range-only equality, melee sound object check,25-unit primary pushback and sweep material/BLP alpha/playback checks to previous coverage. Final playable/editor compilation, pairing, startup/global consistency, text safety and full archive readback pass. Check restored sweep visibility and auto-attack sound in Warcraft. Main RPG/releases unchanged.


## Dragoon10 campaign sweep and movement correction (2026-10-26)

Owner revisions supersede08: Rise cast range800 (all three ids), Sonic pushback20, restore Garek campaign SweepingStrike visual.09 was a checked intermediate build and was not installed before additional Jump feedback. Latest installed TESTER map is release/development/Dragoon10/FFERPG-Dragoon-10.w3x.

Test targets inherited movement type empty and had speed0. This can separate logical relocation from model movement. Set dummy movement to foot/speed1 (no attacks/acquisition/orders, so they remain idle). Sonic now uses whole-unit SetUnitPosition with pathing temporarily disabled/restored to avoid collision changing the requested20-unit displacement. Only the selected target moves, once; hit/debuff/audio rules are retained. Confirm actual model follows its hitbox in engine.

Drakesbane now uses the actual Abilities/Spells/Human/SweepingStrike/SweepingStrike.mdl at original1.0 scale; remove custom mesh/BLP imports and enlarged1.5 scale. Keep campaign target flashes. Existing damage and ground target cone stay90degrees/450. The campaign particle footprint is authored in the asset, so similarity to the cone is an engine acceptance item rather than a claim of exact clipping. Custom generation tool is retained only as unused development history.

Owner explicitly requests Jump's airborne facing fix despite its prior lock. Capture landing point, clear current orders and pause hero during flight, select steady City Guard Stand Ready1 (index5) rather than random attack/spell, enforce instantaneous facing toward landing point every tick. Landing and airborne death clear height/lock/orders; death causes no landing damage. Preserve the approved0.8s interpolation/350-height sine arc, damage,15s cooldown and WarStomp landing effect. Object animation is stand ready to prevent a pre-flight spell spin. Reset also releases lock.

20 tests pass: movement-capable dummy object fields, whole-unit20 push/pathing restoration, campaign VFX selection/scale, Rise range-only object/runtime preservation, Jump movement/landing preservation plus action lock/facing/release and airborne death, existing damage/proc/audio/indicator checks. Final playable/editor compilation, pairing, startup/global consistency, text safety and full archive readback pass. Engine model pushback, campaign sweep footprint and Jump animation require user confirmation. Main RPG/releases unchanged.

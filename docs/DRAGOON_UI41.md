# UI41 Dragoon integration (2026-10-26)

Latest full RPG development map: release/development/QuickUI41/FFERPG-QuickUI41-Forsaken.w3x. Base is the confirmed QuickUI40, retaining teleporter, Chronicle/load, Divine Shield, armory, Barrel Collector and Kalm fixes plus 1000 Cuts. This is a native-only test; no Classic output was requested. Original releases and standalone Dragoon10 remain unchanged. candidate01 is a preserved internal build, not installed.

## Gameplay

Replace Lancer with melee Dragoon, H00C/job7 unchanged, native City Guard model and MetalMediumSlice auto-attack sound. Preserve job unlock requirements, growth/mastery, learned rank counts and saved job/skill indices. New spell costs remain zero and damage/cooldowns use the approved arena tuning for this first integration test; rank/MP balance is not finalized.

| Saved skill | New ability | Key | Behavior |
|---|---|---|---|
| A11R /36 | Sonic Thrust | Q | Locked target-facing 1000-speed charge; stops90 before target, hits each path enemy once, stab extends150 beyond selected target. Selected target only: stacking flat -10 evasion until death, whole-unit20 push, stab sound after starting whoosh. Damage100+2INT; CD4s. |
| A03M /37 | Drakesbane | W | 180-degree forward half-disc, reach450; native Garek sweep. Damage120+2INT+max(0,accuracy-effective evasion); CD5s. |
| A14G /38 | Dragon Ally | D | Original ranked summon, powerup, permanence, old-dragon replacement behavior and mastery retained. |
| A1E6 /39 | Jump | E | Approved0.8s/350-height arc, landing radius150, damage300+3INT, CD15s. Locked facing/actions during flight; safe landing/death/job-swap cleanup. Replaces Attack Speed Burst in the same saved slot. |
| A14D /40 | Rise of the Dragon | R | Requires/consumes Life; cast range800/radius300, stun1.5s, damage250+4INT+precision, +50% strictly below30% pre-hit HP; CD10s. Same native targeting rune, FlameStrike effect and ready glow. |

One50% proc roll per Drakesbane that hits at least one valid enemy, not per target. Three consecutive failed rolls guarantee the next landed cast. A whiff does not roll or consume a guarantee. Success resets the failure count; death/job replacement clears transient state. Life lasts5s and retains the fiery aura. Each player's state is independent.

Eye of the Dragon replaces the innate Dragon Eye (A11S visible/A11T hidden): Farsight eye icon, Blind/Total Blind immunity via the existing Blindproof cleanup and explicit hit-roll immunity. The old ranged distance damage multiplier is removed. No dedicated dragon-eye icon was found in the installed catalogue. The job shop and skill proxies reflect the new names/icons.

Damage uses the real RPG combat pipeline (non-elemental magical spell damage, no basic-attack proc/crit or extra accuracy roll), real accuracy/evasion, and the normal native stun/immunity handling. Sonic's evasion stacks affect combat and the native stats display, with dead/deleted-target cleanup and handle-reuse protection. These are no longer simulated arena stats.

## Source and safety

Canonical integration sources: experiments/Dragoon/DragoonRPG.j and DragoonUI.j, composed by tools/dragoon_rpg.py and tools/build_dragoon_ui41.py. Do not build UI41 from standalone Dragoon.j; it remains the earlier arena source. New helpers are embedded in the existing Damage module and initialized by its existing registration. Original Lancer summon and dragon mastery functions remain in TLancer; retired spell event conditions are disabled to avoid double execution. Periodic spell-calculator text is updated, legacy attack-speed passive and ranged Dragon Eye behavior removed, old cooldown scaling excluded for the four new spells.

All players create the same UI handles at shared startup. Local mouse/key state only moves/hides presentation images/frames; it never controls damage, orders or unit allocation. Gameplay comes from synchronized native spell events. New effects use shared timers for cleanup; action locks clear on completion, death and hero replacement. Local call-graph checks pass. Multiplayer engine acceptance is still required.

The master, saved item/job tables, skill rawcodes, serializer/reader functions and equipment/teleporter/1000 Cuts logic are preserved. Artifact report lists changed modules/functions and SHA256. Unrelated MPQ resources remain byte-identical. Old outputs are preserved.

## Validation

13 new behavior/object checks pass: proc streak/reset/whiff/multi-target rules, half-disc boundaries, per-player isolation, action cleanup, real stacked evasion/death cleanup, path hits/primary-only push/audio, Jump arc/landing, Rise buff consumption/pre-hit threshold, blind immunity, rank/summon retention and local UI safety.13 Thousand Cuts regression tests also pass.

Final playable/editor compilation, editor pairing, startup/global consistency, save/load text safety, full archive readback, save compatibility (358 items/22 job identities/fixed G/H vectors), typed object references and full compiled UI call-graph checks pass. Teleporter, 1000 Cuts and save/load/code functions are token-identical to UI40. In-game load/job-switch, native effects/targeting, knockback, boss stun interactions and multiplayer remain pending.

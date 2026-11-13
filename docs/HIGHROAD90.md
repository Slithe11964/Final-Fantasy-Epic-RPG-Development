# QuickUI90: Galbados Highroad

Full Dragoon test from QuickUI89. These are Normal authored base stats, retaining existing difficulty/player scaling. Shared unit IDs receive the changes wherever they occur. Previous candidates, production, editor master, classic and creature-review maps are preserved. House regeneration remains 7% maximum health/mana per second.

## Follow-up adjustments

- Ogre Berserker `n0MO` Roar and `nogl` Accumulate now grant **+150 attack damage**, using their private shared bonus ability. Accumulate's 50% heal/+40 armor/20-second duration and Roar's other settings remain. Ability/unit tooltips updated.
- `nhdc` private Mirror Image uses native cast range **96** and area **128**, replacing the test's range 600/area 0, for a closer split. Native image damage/lifetime/other settings remain. In-game separation still needs acceptance.
- Every Devour ability has **20-second cooldown**, including Forest, Barrens, Mountain, new Highroad and original Nerubian Queen `A0YR`; unused authored ranks are also consistent. Regional injury/friendly/pool checks and confirmed two-use stat absorption remain.
- Gaya's Break Stun now clears **all added monster taunts** from its owner's current hero: removes that hero from the forced-target group, clears taunter/expiry fields, and stops the existing forced attack order. The periodic/order hooks cannot reapply the old taunt. Other heroes and the enemy caster's defensive bonuses remain intact. Existing Stun/Freeze/Sleep/Daze dispels are retained. All three rank descriptions mention Taunt. No immunity to a later new Taunt is added.

## Galbados Highroad Normal base stats

An em dash retains the previous value. Attack ranges include dice.

| Unit | Level | HP | Armor | Attack | Mana |
|---|---:|---:|---:|---|---:|
| nsgg | 25 | 3500 | 160 | 160–178 | — |
| narg | 15 | 2500 | — | 110–131 | — |
| Lesser Flan n01P | 18 | 2000 | 3 | 80–96 | — |
| nwld | 22 | 3100 | 49 | 172–195 | — |
| nwlg | 20 | 1900 | 33 | 149–156 | — |
| nspb | 23 | 2900 | 48 | 170–192 | — |
| ngns | 19 | 2300 | 28 | 130–136 | — |
| ngna | 16 | 2100 | 42 | 121–143 | — |
| ngno | 19 | 2500 | 52 | — | — |
| ngnv | 24 | 4100 | 54 | 161–185 | — |
| ngnw | 23 | 2750 | 45 | 210–219 | — |
| ngrk | 17 | 2000 | 58 | 135–148 | — |
| ngst | 23 | 3800 | — | 183–197 | — |
| nggr | 24 | 4000 | — | 135–149 | 1000 |
| nwrg | 21 | 3200 | — | 165–173 | — |

narg, nwld and ngst receive a 500 mana pool if their previous pool was below 300. nggr's 1000 initial/maximum mana supports both Devour and the 400-mana unlock. Highroad actor spawns start with full mana, as do the earlier role prototypes.

## Abilities and starting defaults

Requested values are implemented. Unspecified durations/costs/cooldowns/ranges below are prototype starting values, included in the tooltips. Existing spells are retained unless replaced explicitly or an old block marker would add an unwanted second block roll.

| Creature | Behavior |
|---|---|
| nsgg | Taunt forces enemies within 450 to attack for 5 seconds. Caster stands still and takes 50% less damage for 5 seconds. 30-second cooldown, no mana cost. Natural physical block chance 30%; old A07A block marker removed. Death/expiry releases only this added self-pause. |
| narg | Natural physical block 20%, replacing A07A. Head Butt: 800 spell damage and 3-second stun, range 180, 100 mana, 30-second cooldown. |
| Lesser Flan | Native Entangling Roots: 3-second root and 400 spell damage/sec, 200 mana, 12-second cooldown. |
| nwld | Bite: 1000 physical damage; -30 flat evasion and -20% movement for 5 seconds. 150 mana, 15-second cooldown, range 180. Gameplay and stat panel share the evasion change and existing zero floor. |
| nwlg | Howl: allies within 800 gain +200 attack damage and +20% attack speed for 20 seconds; 30-second cooldown, no mana cost. Recasts refresh rather than stack the same bonus. |
| nspb | Private Bio at 100 mana, existing 20-second cooldown, with exactly Stinger's reduced damage and poison rank. Calculation uses the original 200-mana baseline for both payload and rank: 0.8 × floor(200/3) × Inner Mana spell power per tick. Stinger and Poison Wand remain unchanged. Basic-attack poison now has 30% chance, 100 + 5 × poisoned hero level DPS for 10 seconds. |
| ngns | Existing Night Might retained. Basic poison now has 25% chance, 50 + 7 × poisoned hero level DPS for 10 seconds. |
| ngna | Highroad Alert: attacking a hero or taking hero damage starts a 15-second call, final 5–1 countdown. Kill caller to cancel. Doubles zone 5 spawn frequency, wave amount and population cap for 60 seconds. Once per caller; further successes refresh instead of multiplying beyond ×2. Other regional Alerts remain independent. Existing spawn pool makes this creature night-only. |
| ngno | Field Kit: 1000 immediate healing plus 100/sec for 5 seconds. 50 mana, 20-second cooldown, range 800. AI chooses the lowest health-fraction injured ally. Previous Bite retained as a fallback. |
| ngnv | Whirlwind: 500 physical damage/sec for 5 seconds within 250. 150 mana, 20-second cooldown. Existing taunt retained. During a whirlwind the scripted AI does not interrupt it with another cast; timed effect is cleaned on expiry/death. |
| ngnw | Aerial Assault reuses Liquid Steel's existing movement/bounce engine, with 150 wind-elemental physical damage per bounce and 5 bounces. 100 mana, 15-second cooldown. A separate instance flag preserves original Liquid Steel's damage, water element, bounces and visuals. Wind visual on the new instance only. Prior thunder attacks/Shock retained. |
| ngrk | Native Avatar: +100 attack damage, +1000 maximum HP and spell immunity for 30 seconds; scripted +25% attack speed and 1.5 scale for the same duration. 150 mana, 45-second cooldown. Bonus attack speed/size clean up on expiry/death; native Avatar manages its own native bonuses. |
| ngst | Ground Slam: immediate 800 earth spell damage within 300, followed 2 seconds later by 800 earth spell damage within 500 at the original center. 200 mana, 15-second cooldown. Moving caster does not move the second explosion. |
| nggr | Base evasion 50, natural physical/magical block 33%. Native Endurance Aura buff/visual (Ancient Janggo family) grants nearby allies +20% evasion, radius 600. Caster retains its specified 50 base instead of multiplying its own aura. External evasion bonuses/debuffs still apply. |
| nggr Devour | Injured friendly Highroad pool creatures only, no heroes/special quest units. Absorbs the Queen stat bundle and heals remaining target HP. Maximum two successful uses; second removes only Devour. 350 mana, 20-second cooldown, range 350. Unlocks Rocky Defense. |
| Rocky Defense | Sets base evasion to 100 and physical/magical block chance to 60% for 10 seconds. 400 mana, 30-second cooldown. Returns to base 50 / 33% block on expiry; usual anti-block and evasion reductions still work. |
| nwrg | Natural 15% physical/magical block, replacing A07A. Metal Fist: 1200 physical damage, -25% target attack damage for 10 seconds; 100 mana, 30-second cooldown, range 180. |

Poison retains the previous non-stacking shared monster-poison slot and stronger/refresh rule. Damage/healing numbers are base calculations before ordinary modifiers/defenses unless the existing direct-heal helper is used (Field Kit). Aura uses a native buff, so evasion reads do not scan nearby units. Evasion display order matches gameplay for the aura, Bite, prior percentage debuff and Sonic Thrust reductions.

## Validation and performance

18 behavior tests pass: all requested Normal stats and attack ranges; native fields/data pointers; 150-damage bonus tooltips, close Mirror settings and all Devour cooldowns; exact Stinger/Highroad Bio payload and rank at different actual mana costs; poison chances/formulas; zone 5 Alert timing; passive/Rocky block expiry; evasion/aura/debuff agreement between combat and stat panel; Field Kit's five ticks and handle cleanup; fixed-center two-stage slam; Whirlwind's five ticks/radius/effect cleanup; self-root taunt timing; Avatar size/attack-speed expiry; injured/pool/two-use Devour unlock; separate Aerial Assault and original Liquid Steel branches; AI cast orders; Gaya clearing all added taunt families only from its owner's hero; source/runtime parity and preserved player/item data.

Playable/editor scripts compile. Editor pairing, startup wiring, globals, native text safety, object references and save compatibility (358 items, 22 jobs) pass. Archive readback matches intended changes. Native gameplay/visual/multiplayer acceptance remains pending.

No new inventory polling or periodic timer. Timed Highroad effects reuse the existing shared one-second monster heartbeat. Aerial Assault reuses the existing active Liquid Steel engine/timer; no separate idle updater. No local-client reads drive monster gameplay or taunt cleanup. Existing material stacking fix, hero spells, house 7%, release/classic/master/review maps remain intact.

Build: `tools/build_highroad90.py`. Runtime: `experiments/GuardiaForest/Highroad90.j`. Tests: `tools/tests/test_highroad90.py`. Earlier candidates preserved at `build/candidates/highroad90-first` and `highroad90-second`.

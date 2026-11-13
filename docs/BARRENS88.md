# QuickUI88: forest follow-up and Barrens monster roles

Full Dragoon test from QuickUI87. These are authored Normal-mode base stats; existing difficulty/player scaling remains. No editor master, normal release, classic build or creature-review map is replaced. House regeneration remains 7% maximum health/mana per second. Existing Dragoon, Thief and equipment UI work is preserved.

## Forest follow-up

- Dark Goblin (`ndtr`) gains existing Night Might. From 18:00 to 06:00, the existing damage engine gives +60% outgoing damage and multiplies incoming damage by 0.625 (37.5% less). Forest Wolf and Razorback Scout use the same ability; daytime has no bonus.
- Forest Gnoll: +70 evasion for 10 seconds after Taunt. Forced targeting stays 3 seconds; cooldown 20 seconds, cost 25 mana.
- Bandit Lord: Evasive Action grants +80 evasion for 10 seconds; cooldown 30 seconds. Also has 15% physical / 10% magical block chance.
- `nspb`: 33% poison chance on landed basic attacks against heroes; base DPS = 10 + 3 × poisoned hero level, for 10 seconds. Uses the existing shared monster-poison slot: non-stacking; equal/stronger applications refresh, weaker ones do not replace stronger active poison.
- `nban`: 25% physical / 15% magical block chance. New block chances use the existing block resolution and respect anti-block rules and Spear Proficiency.
- Stinger retains its private `fI86` Bio with 20% reduction. Original `A10N`, other Bio objects and their shared formula remain unchanged. Tests execute both original and Stinger paths.
- Etem is unchanged: within 800 range, its three native aura objects provide +40 armor, +30% movement and attack speed, and +150 flat attack damage. This is existing map behavior, not a new balance change.

## Barrens Normal base stats

An em dash means the previous value is retained. Attack ranges include the configured dice.

| Unit | Level | Health | Armor | Attack | Mana |
|---|---:|---:|---:|---|---:|
| nqbh | 12 | 1000 | 27 | 35–44 | 500 |
| nowe | 10 | 1500 | — | — | — |
| nowb | 8 | 1000 | — | — | — |
| nrzb | 9 | 800 | — | 35–42 | — |
| nrzg | 11 | 1100 | — | 50–57 | — |
| nltl | 7 | — | 30 | 44–45 | — |
| nthl | 10 | 900 | 44 | — | — |
| nstw | 12 | 1700 | — | 60–65 | — |
| nrzt | 8 | 750 | 24 | 33–37 | — |
| nrzs | 7 | 800 | 22 | 25–30 | — |
| nrzm | 10 | — | 20 | — | 500 if previous pool was below 300 |
| nhrw | 7 | 700 | 5 | 30–33 | — |
| nhrr | 9 | 600 | 20 | — | — |
| nhrq | 10 | 800 | 10 | — | — |
| Harpy Trickster n0L0 | 12 | — | 10 | — | — |
| ncea | 7 | 900 | 15 | 30–40 | — |
| ncen | 9 | — | — | 28–38 | — |
| ncer | 7 | 1000 | — | 20–32 | — |
| ncim | 9 | — | 21 | 30–35 | — |
| ncks | 9 | — | — | — | 500 if previous pool was below 300 |
| ncnk | 11 | 1600 | 50 | — | 500 if previous pool was below 300 |
| nhar | 7 | 600 | 3 | 23–27 | — |
| nhrh | 8 | — | 6 | — | — |

The request's `nzrb` is interpreted as `nrzb`, the actual creature in the Barrens pool. Uppercase N in the request is normalized to existing lowercase unit IDs.

## Abilities and test defaults

All changed active abilities have matching descriptions/calculations. Unspecified values below are starting values for this prototype, explicitly shown in tooltips.

| Creature | Behavior |
|---|---|
| nqbh | Native Trueshot Aura: +15% ranged attack damage within 600; no melee bonus. Devour Barrens Creature costs 250 mana, cooldown 15 seconds, range 350. Only Barrens day/night pool types; no heroes or special quest units. Removes food without loot; unlocks private Rapid Fire. |
| nqbh Rapid Fire | Reuses Archer's existing 16-arrow engine, effects and spread. Creature-only damage per arrow is 93.75–100% of (0.02 × maximum health + base attack damage), before ordinary modifiers. Costs 100 mana, cooldown 20 seconds. Archer `A0AE` ability data and original formula are unchanged; both branches are tested. |
| nowe | Taunt: forced targeting 3 seconds, 10% physical and spell damage reflection for 5 seconds, 20-second cooldown, no mana cost, 450 radius. Passive 15% physical block. Reflection uses final received damage and a recursion guard. |
| nowb | Shout: nearby enemies deal 20% less physical/magical damage for 5 seconds; cooldown 30 seconds, radius 450, no mana cost. |
| nrzb | Swipe: 300 physical damage plus 1% of target maximum health per second for 3 seconds. Cooldown 15 seconds, no mana cost, range 180. One active bleed per target; recasts refresh. |
| nrzg | Dash to target; evasion ×0.9 for 5 seconds. 50 mana, 15-second cooldown. |
| nltl | Private Chain Lightning: 450 damage to primary target; prior one-target behavior preserved. 120 mana, cooldown 30 seconds. |
| nthl | Same Chain Lightning; private Lightning Shield 40 damage/sec for 20 seconds, 75 mana/15-second cooldown. Slam: 100 damage, -33% movement/attack speed for 5 seconds, 250 radius, 15-second cooldown, no mana cost. |
| nstw | Chain Lightning and Lightning Shield removed. Faith: +50% magic damage to a friendly creature for 15 seconds, 150 mana, 30-second cooldown. Existing other abilities retained. |
| nrzt | Three visible homing quill projectiles, each 120 physical damage, 50 mana, 15-second cooldown. Uses native proxy damage attribution and cleanup. |
| nrzs | Existing Night Might. |
| nrzm | Autocast Heal restores 75 for 50 mana, 1-second cooldown. Existing ability retained. |
| nhrw | Private Faerie Fire: -8 armor, 30-second duration, 35 mana, 5-second cooldown. |
| nhrr | Alert: attacking a hero or taking hero damage begins a 15-second call; Calling Reinforcements and final 5–1 countdown. Killing caller cancels. Doubles Barrens spawn frequency, wave amount and population cap for 60 seconds. Once per caller; subsequent successful calls refresh, do not multiply beyond ×2. Independent of forest Alert. |
| nhrq | Howl of Terror and Power Break removed. Rejuvenation 600 health over 9 seconds (75 mana/15-second cooldown); Faerie Fire -8 armor; Mana Burn up to 200 (50 mana/15-second cooldown). Other defenses retained. |
| Harpy Trickster | Fog retains existing 33% magic damage reduction, confirmed by owner; 20-second duration, 50 mana, 30-second cooldown. Unique channel order applies the native Fog buff through a simple dummy, avoiding conflict with its existing Curse/Pain spell. Existing spell retained. |
| ncea | Steady Shot: arrow, 100 spell damage and 2-second stun. 15-second cooldown, no mana cost. |
| ncen | Dash: 400 physical damage; -25% attack speed for 5 seconds. Cooldown 20 seconds, no mana cost. |
| ncer | Shout: enemies within 450 take 10% increased damage for 10 seconds. Cooldown 20 seconds, no mana cost. |
| ncim | Rage: +80% attack speed and +25% incoming damage for 10 seconds. Cooldown 30 seconds, no mana cost. |
| ncks | Autocast can be toggled; +30 ally accuracy for 20 seconds, 100 mana/30-second cooldown. Both gameplay and stat panel read the timed bonus. Existing Haste retained. |
| ncnk | Taunt forces attacks for 3 seconds and grants +50 armor for 15 seconds. 150 mana, 30-second cooldown, radius 450. Native timed armor ability; expiry/death removes only this new bonus. |

Barrens spawn-pool membership/weights are unchanged, including night forms and Harpy Trickster. New active monsters start their mana pools full when spawned, enabling AI casts in day or night. Scripted AI acts only for shared hostile owner Player(11), respects pause/cinematics, cooldown/mana and suitable targets. Native passive mechanics remain available on other owners.

## Validation and performance

15 behavior tests pass: requested stats and attack ranges; native field values/data pointers and target masks; Stinger isolation; Night Might/Etem preservation; poison chance/formula/duration; block values/evasion expiry; independent Alert countdowns and spawn factors; Devour allow-list/refund/unlock; bleed ticks/quills/accuracy expiry; reflection recursion; charge movement/facing/impact; monster-only Rapid Fire with Archer branch retained; three quill proxy payloads; AI cast orders; every changed editor function matching playable code; preserved hero/UI functions and shared-only callbacks.

Playable and editor scripts compile. Editor pairing, startup wiring, globals, native save text, content reference and save compatibility checks pass (358 items, 22 jobs). Archive readback matches intended changes. Native gameplay, visuals and multiplayer acceptance remain pending.

No inventory or preview callbacks are added. Reuses the existing one-second shared forest heartbeat for AI/buffs/bleed. One additional charge timer runs at 10 Hz only while a charge is active, then pauses. Rapid Fire retains its existing 10 Hz active spell timer. No local-client reads drive gameplay. The previously reported backpack cross-player interaction is outside this balance change.

Build: `tools/build_barrens88.py`; runtime extension: `experiments/GuardiaForest/Barrens88.j`; tests: `tools/tests/test_barrens88.py`. Earlier uninstalled candidates retained in `build/candidates/barrens88-first`, `barrens88-second`, `barrens88-third`.

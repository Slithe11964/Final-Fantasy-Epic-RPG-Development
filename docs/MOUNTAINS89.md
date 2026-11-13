# QuickUI89: Northern Mountains and material/Devour fixes

Full Dragoon test from QuickUI88. Normal authored base stats; existing difficulty/player scaling remains. Previous map candidates, original editor master, production release, classic build and creature-review map are preserved. House regeneration remains 7% maximum health/mana per second.

## Material pickup and stacking

Scroll of Shadows (`I073`, stock base `sand`) inherits Miscellaneous classification. Power Sphere (`I071`, stock base `infs`) inherits Artifact classification. Installed Warcraft ItemData.slk was read to verify both start with one charge. The prior equipment restriction mistook these non-equipment classes for accessory gear, while ItemStack_Eligible accepted only Charged items or Exotic Stone.

Both raw IDs now bypass the legacy equipment restrictions and are explicitly eligible for the existing stack merger. Same-item stacks merge through Carry_At, retaining the 99-charge cap, overflow and binding rules. No item object identities, classes, bases, save table or serialization changes. Tests exercise 1+1 merging in six native slots for both materials and 98+5 overflow.

## Regional Devour

Owner explicitly identified Nerubian Queen `n02B` and confirmed its two-use limit. Forest, Barrens and Mountain Devours require a living injured friendly creature from their corresponding day/night pool. Heroes and special quest creatures are excluded. AI selection and cast resolution both check injury. A full-health, wrong-pool or otherwise invalid target refunds mana and cooldown.

Each successful use permanently adds the victim's two native base attack damage values, maximum health, maximum mana and armor, and heals the caster by the victim's remaining health. The second successful use removes only the cast Devour ability. The unlocked spell remains. Consumption removes food without loot and removes its spawn-group membership.

| Region | Caster | Mana | Cooldown / range | Unlock |
|---|---|---:|---|---|
| Guardia Forest | nfsh | 200 | 15 seconds / 350 | Blizzaga |
| Barrens | nqbh | 250 | 15 seconds / 350 | Creature-only Rapid Fire |
| Northern Mountains | nwzd | 300 | 15 seconds / 350 | Aeroaga |

Forest AI falls back to Blizzaga when Devour is ready but no injured food exists. Regional costs/range/cooldowns and spell unlocks are retained independently of the Queen's stat absorption and confirmed use limit. Queen's original ability and script are unchanged.

## Northern Mountains Normal base stats

An em dash retains the previous value. Attack ranges include configured dice. Unit IDs shared with other areas receive these base changes in those other areas too; the reinforcement Alert itself is gated to Northern Mountains spawn zone 4.

| Unit | Level | HP | Armor | Attack | Mana |
|---|---:|---:|---:|---|---:|
| Apprentice Dark Wizard nwiz | 10 | 1200 | 13 | 45–50 | 800 |
| Cultist nhfp | 12 | 1400 | 20 | 50–55 | — |
| Ogre Berserker n0MO | 15 | 2000 | — | 70–82 | — |
| nass | 13 | — | — | — | — |
| nban | 11 | 1500 | 42 | 50–64 | — |
| nbld | 18 | 2600 | — | — | 800 |
| nbrg | 14 | 1800 | 55 | 120–136 | — |
| nenf | 17 | 2400 | 66 | — | — |
| ngno | 12 | 1750 | 33 | 75–92 | — |
| ngns | 15 | 1400 | 36 | 100–122 | — |
| ngnv | 19 | 3150 | 62 | 150–164 | — |
| ngnw | 14 | 1500 | 32 | 106–136 | — |
| nhdc | 15 | 2200 | 30 | 79–92 | — |
| nhhr | 19 | 2300 | 27 | 120–135 | — |
| nkob | 10 | 1200 | 32 | 90–113 | — |
| nkog | 15 | 1500 | 42 | 72–89 | — |
| nkol | 18 | 2300 | 41 | 135–153 | — |
| nkot | 13 | 1500 | 22 | — | — |
| nogl | 20 | 3400 | 73 | 160–182 | — |
| nogm | 17 | 2200 | — | 120–134 | — |
| nogr | 13 | 1700 | 42 | 80–89 | — |
| nomg | 18 | 1600 | 33 | 72–83 | — |
| nrog | 13 | 1600 | — | 72–78 | — |
| nwzd | 20 | 3100 | 52 | 145–162 | — |
| nwzg | 18 | 2400 | 29 | 125–134 | — |
| nwzr | 14 | 1800 | 26 | 82–94 | — |

New mana-cost casters n0MO, nkot, nogm and nogr receive 500 maximum/initial mana if their previous pool was below 300. nban/nenf receive the same reserve although their new defensive cast has no mana cost. Spawned regional actors start with full mana, preserving the previous test's casting policy.

## Abilities and starting defaults

Requested values are implemented; unspecified costs, durations, ranges and cooldowns below are prototype starting values. Unit and ability tooltips describe the resulting behavior.

| Unit | Ability |
|---|---|
| nwiz | Darkness: 10% of each enemy's current HP as base spell damage within 600. 100 mana, 15-second cooldown. Ordinary damage modifiers/defenses apply. Existing Slow retained. |
| Cultist | Renamed from Kultist. Dark portal rune summons Demon Hound: level 10, 1000 HP, 25 Fortified armor, 30–40 Chaos attack, native Felhound model. 200 mana, 30-second cooldown; hound lasts 45 seconds. |
| n0MO | Roar grants self +300 attack damage for 20 seconds. 125 mana, 30-second cooldown. Existing other passives retained. |
| nass | 25% landed-attack poison chance against heroes; 10 + 5 × poisoned hero level DPS for 10 seconds. Old A0PH removed to avoid a second poison proc. |
| nban | Defensive Stance: 20% less incoming damage for 10 seconds; +30 physical and +25 magical block percentage points. With existing 25/15 baseline, active chances are 55%/40%, before normal anti-block rules. 30-second cooldown, no mana cost. |
| nbld | Evasive Action +80 evasion for 15 seconds, 200 mana, existing 30-second cooldown. Retains existing passive physical/magical block. |
| nbrg and nkob | Alert on attacking a hero or taking hero damage in Northern Mountains: 15-second call, final 5–1 countdown. Killing caller cancels. Surviving doubles zone 4 wave frequency, wave amount and population cap for 60 seconds. Refreshes rather than multiplying beyond ×2; once per caller. Forest/Barrens Alerts remain independent. nbrg's existing poison retained. nkob also gains +40 evasion. |
| nenf | Taunt forces attacks for 3 seconds and grants 66% physical / 50% magical block for 10 seconds. Radius 450, 25-second cooldown, no mana cost. |
| ngno | Bite: 600 base spell damage to enemy in 180 range, restoring 250 HP to caster. 15-second cooldown, no mana cost. |
| ngns | Night Might plus 25% poison chance, 10 + 4 × poisoned hero level DPS for 10 seconds. Old A0PH removed. |
| ngnv | Taunt forces attacks for 5 seconds. 50% reduction to magical or elemental damage for 15 seconds, applied once to elemental spells. 125 mana, 30-second cooldown, radius 450. |
| ngnw | Thunder-elemental basic attacks; 10% chance to apply existing Shock on a landed basic attack, including hits against enemy summons. |
| nhdc | Mirror Image creates one image: 50% outgoing damage, 150% incoming damage, 30-second lifetime, 100 mana, 30-second cooldown. The existing map blanket zero-illusion-damage rule now exempts only hostile nhdc images. Images are excluded from the new caster AI. |
| nhhr | Slow/Blind removed. Private Carrion Swarm: 600 damage per target, 2400 total cap, 100 mana, 8-second cooldown. Existing Haste retained. |
| nkog | Slow and old Cura removed. Cure targets the lowest health-fraction injured ally within 800, sending the existing healing projectile: 600 target healing, 300 along the path, path radius 128. 300 mana, 8-second cooldown. Player Cure formula/normal splash and hostile Blinding Light behavior remain unchanged and are separately tested. |
| nkol | 35% critical chance, ×2.5 physical damage. Old native ACct removed to avoid an additional 20% ×2 roll. Uses the map's existing critical resolution. |
| nkot | Armor Shout grants +20 armor to allies within 800 for 15 seconds. 250 mana, 30-second cooldown. |
| nogl | Private Accumulate: heal 50% maximum HP; +300 attack damage and +40 armor for 20 seconds. Retains 150 mana / 45-second cooldown. Other Accumulate abilities unchanged. |
| nogm | Slam: 600 earth spell damage and 3-second stun within 300. 125 mana, 15-second cooldown. |
| nogr | Earth-elemental attacks. Rock projectile deals 400 earth spell damage and applies -33% attack/movement speed for 5 seconds on impact. 75 mana, 10-second cooldown. |
| nomg | Existing Haste plus autocast-toggle Bravery: +50% physical damage for 20 seconds, 100 mana, 15-second cooldown. AI respects the autocast toggle. |
| nrog | Night Might. |
| nwzd | Injured-only two-use Mountain Devour, native Brilliance Aura +75% mana regeneration within 600, private Chain Lightning 750 thunder damage to primary target (120 mana/15-second cooldown), Forked Lightning 450 thunder damage (100 mana/15-second cooldown). Original Protect/Shell retained. Devour unlocks Aeroaga. |
| nwzd Aeroaga | Wind pulses at 3, 6 and 9 seconds; each base damage = 1000 + base attack damage + 0.001 × maximum health, sampled at cast after absorbed stats. Radius 300 at target point, cast range 800. 200 mana, 20-second cooldown. |
| nwzg | Private Chain Lightning 600 thunder damage to primary target (120 mana/15-second cooldown); Lightning Shield 150 thunder DPS for 20 seconds (100 mana/15-second cooldown). Aeroaga available immediately: three 500-wind-damage pulses at 3, 6 and 9 seconds, radius 300/range 800, 200 mana/20-second cooldown. |
| nwzr | Firebolt projectile: 800 fire spell damage and 3-second stun, 200 mana/10-second cooldown. |

Poison uses the previous shared monster-poison slot and non-stacking stronger/refresh rule. Native or scripted damage values above are before ordinary defenses, evasion/block and damage modifiers. Private projectile proxies preserve original caster attribution and explicit Fire/Earth elements; only marked new proxies use the new element/slow fields.

## Validation and performance

Behavior checks exercise all requested Normal stats and damage ranges; native data fields/pointers; material pickup and stacking/overflow; injured/friendly/pool Devour checks and Queen stat absorption/two-use removal; zone-specific Alert timing; new poison/chances and Shock; defensive block/evasion expiry; Darkness/Bite/Accumulate/Slam payloads; exactly three Aeroaga pulses and caster-specific scaling; projectile element/slow payloads; player Cure preservation; ready AI cast orders; Mirror Image exception; editor/playable parity for every changed function; and absence of local-client gameplay reads or new timers.

Playable/editor compilation, editor pairing, startup wiring, globals, content references and save compatibility (358 items, 22 jobs) pass. Archive readback matches the intended changes. Live gameplay, visual and multiplayer acceptance remain pending.

No inventory polling, preview callbacks or new timers. AI and timed monster effects share the existing one-second heartbeat. Existing Cure projectile machinery and native spells retain their existing engines. Original hero Rapid Fire, Poison Wand Bio, Queen Devour, normal release and editor master are unchanged.

Build: `tools/build_mountains89.py`. Runtime: `experiments/GuardiaForest/Mountains89.j`. Tests: `tools/tests/test_mountains89.py`. Earlier uninstalled candidates remain under `build/candidates/mountains89-first` through `mountains89-sixth`.

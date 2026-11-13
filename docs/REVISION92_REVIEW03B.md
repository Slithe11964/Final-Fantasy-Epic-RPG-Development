# QuickUI92 and Creature Review 03b

Continues the full Dragoon QuickUI91 and isolated Creature Review 03. Earlier maps, releases, classic build and master are preserved. The separate review-source intermediate is not a playable release.

## Regional Black Spiders in the review

The old review displayed one shared `nspb` object in both areas. Highroad's later edits therefore overwrote the Forest exhibit. Review 03b restores `nspb` from QuickUI88 for Forest and makes a separate Highroad object (`rSP3`) with the current Highroad values. Arena copies retain the current Highroad values via that clone. The separate Highroad poison card (`rPS3`) now also displays its correct formula.

| Version | Normal baseline | Poison | Additional spell |
|---|---|---|---|
| Guardia Forest | Level 5, 450 HP, 4 Medium armor; prior attack and mana data | 33% per landed hit; 10 + 3 × poisoned hero level each second for 10 seconds | None |
| Galbados Highroad | Level 23, 2900 HP, 48 Medium armor, 170–192 attack | 30% per landed hit; 100 + 5 × poisoned hero level each second for 10 seconds | Bio: current Stinger-derived formula, 100 mana |

This regional split is review-only. QuickUI92 retains the production candidate's shared spider definition; it does not introduce world loot/quest/taxonomy changes for the clone. Both spiders' actual poison branches and tooltips are separately verified in the review.

## Monster corrections in both maps

- Harpy Trickster `n0L0`: 1600 base HP. `nowe`: 1800 base HP.
- Removed Ogre Berserker `n0MO`'s extra `A1C5` Roar (200 mana). Its private 125-mana Roar, +150 attack bonus and other authored behavior remain.
- Cleared inherited Channel caster, target, special and effect art on the new regional monster spells. Existing intentional scripted visuals remain, including the two shouts' Howl caster effect. This covers Charging Strike, Trample, Quill Darts, Weakening/War/Armor/Pack shouts, Roar, Evasive Action, Defensive Stance, taunts, Field Kit, Aeroaga, Accumulate, Earth Slam, Ground Slam, bites, Throw Rock, Firebolt and Metal Fist. Evasive Action's additional Mirror Image caster effect was also removed.
- Charging Strike and Trample explicitly target enemies. Both use the existing shared active-only 10 Hz dash timer, face their target and stop at melee range. Completion effects require reaching the target, rather than applying remotely when a chase expires. Charging Strike retains -10% evasion for five seconds; Trample retains 400 physical damage and -25% attack speed for five seconds.
- Native projectile casters for Quill Darts, Firebolt, Throw Rock and supporting status effects stay active and transparent rather than hidden. Hidden units can fail to cast their native projectile ability. Dart/fire/rock missile art is explicit; damage and spell costs remain unchanged.
- Carrion Swarm `mCS9`: explicit Carrion Swarm wave art/speed, starting radius 100, travel distance 800, ending radius 300. Retains 600 damage per target and 2400 total cap, 100 mana, eight-second cooldown.
- Darkness reuses the Dark Knight's Obsidian aura caster effect and Animate Dead target effect across its actual 600-radius damage area. Retains 10% current-health damage.
- Whirlwind of Steel uses the standard Orc Whirlwind model, retaining the existing five-second effect-handle cleanup and damage ticks.
- Defensive Stance uses Footman Defend art and its sound label. Damage/block bonuses and duration remain unchanged.
- Both Bite variants use a native Devour bite impact and attack animation. Metal Fist uses an attack animation and Thunderclap dazed hit effect. Head Butt retains native 800 damage/three-second stun, with no hammer missile or Channel art.
- Wind bounces release their instance immediately after the final hit; effect/dummy cleanup remains in the shared remover. The no-neighbor repeat branch now keeps Wind damage instead of accidentally using Water. Player Liquid Steel's Water branch is retained.

## Review projectile repair

Review 03 omitted the path probe and wrapper callbacks that its shared missile engines require. Consequently Cure projectiles could disappear on their first path test, and the wind projectile could fail to release its visual/instance. Review 03b initializes the path probe and Missile collision/damage/impact, Liquid Steel removal and Rapid Fire removal callbacks during its single combat startup. It still does not start quests, world spawning, inventory UI, save/load or boss encounter phases. No additional periodic polling is introduced.

`nkog`'s Cure keeps the Priest missile engine/model and 600 target / 300 path healing, 300 mana, eight-second cooldown and 800 cast range.

## Readable calculations

In-game tooltips and `-abilities` retain concise native effect values or human-readable damage/healing formulas. Pasted script calculations, temporary variables, raw action calls and the misleading hero-caster preamble are removed. Repeated descriptions are not appended twice. `-spells` uses the authored monster role description and a brief indication of extra scripted effects. Exact raw conditional traces remain in `Detailed-Script-Audit.json` for technical review; unidentified boss phases are not represented as unconditional damage totals.

Example: Corpse Release now states that it sacrifices the corpse, damages enemies within 256 based on the corpse's remaining HP, and heals nearby allies for 93.75%–100% of that health, capped by missing HP. It no longer prints the temporary groups, assignment statements and native calls.

## Verification and remaining acceptance

Eight focused checks cover HP and extra Roar removal, clean Channel art and enemy filters, separate spider poison probabilities/formulas, actual dash movement/facing/completion for both units, projectile visibility configuration, retained damage/stun values, required review startup callbacks, readable tooltips and intentional replacement visuals. Both maps pass playable/editor compilation, startup/source/global consistency and content checks. QuickUI92 passes save compatibility for 358 items and 22 jobs. These checks do not replace native visual, sound, AI or multiplayer acceptance in Warcraft III.

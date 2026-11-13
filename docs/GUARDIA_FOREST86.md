# QuickUI86: Guardia Forest monster-role prototype

Full Dragoon map only, from QuickUI85. No creature-review build requested. The owner states the listed values are Normal-mode stats. These are authored Normal base values; existing higher difficulty/player-count modifiers remain. Other Dragoon, Thief, Zodiac, poison-spear, F/G and inventory work is preserved.

| Creature | Normal base changes | Ability behavior |
|---|---|---|
| Forest Goblin Great Shaman (nfsh) | Level5, attack15-23, armor5 Unarmored, mana300 | Devour Forest Creature costs200MP and only consumes another living, nonhero, nonspecial creature whose type is in the exact Guardia Forest day/night union. AI prefers allied food within350. Successful consumption removes the creature without loot and permanently unlocks Blizzaga for this shaman. Devotion Aura grants10% armor to allies within600. |
| Forest Wolf (nwlt) | Other stats retained | Existing Night Might: +60% outgoing damage and -37.5% incoming damage at night. |
| Forest Goblin Berserker (nftb) | Level5, HP350, armor10 | Rage grants30% attack speed and30% increased damage taken for10s, cooldown30s, cost0. |
| Forest Goblin Shaman (nfsp) | HP200, attack6-12 | Blind/Curse ACcs removed. Heal begins on autocast, restores25 for10MP, cooldown1s, range600. AI prioritizes wounded allies. |
| Dark Goblin Shaman (ndtp) | HP350, armor7 | Existing Curse retained; AI attempts ready casts in combat. |
| Dark Goblin (ndtr) | Other stats retained | Alert begins on attacking a hero or positive damage from a hero in Guardia Forest. Stops to channel, displays Calling Reinforcements and5,4,3,2,1 during the final five seconds. Kill/removal cancels. Survival completes the call. Once per goblin. |
| Forest Spider (nspg) | Other stats retained |33% chance on landed basic attack against a hero: poison base DPS5+25*victim hero level,5ticks/5seconds. |
| Forest Gnoll (ngnb) | Level4, HP440, armor11, mana100 | Taunt costs25MP, cooldown15s, radius450; forces enemies to attack it for5s and reduces its incoming damage20%. Orders to move/cast/attack another target are redirected while active. Death cancels control. |
| Forest Goblin Trapper (nftt) | Other stats retained | Original Ensnare cooldown15s/range500 and duration are preserved. The target also receives a zero-damage1s stun. |
| Bandit Assassin (nbrg) | Other stats retained |15% poison chance on landed basic attack against a hero: base DPS5+35*victim hero level for5ticks/5seconds. |
| Bandit Lord (nbld) | Other stats retained | Evasive Action grants40evasion for10s; cooldown30s, cost0. Both damage engine and stat panel read the bonus. |
| Stinger (n0BS), existing hunt encounter | Other stats retained | Its Bio poison spell has20% lower calculated damage, using a private clone so other Bio users are unchanged. Its separate Deadly Poison passive is retained. |

Successful Alert doubles only Guardia Forest spawning for60s: existing wave timer30->15seconds, wave amountx2, population cap20->40. Subsequent successful goblin alerts refresh60s and never multiply beyondx2. The wave timer returns to30s when the effect ends. Existing excess living enemies are not deleted on expiry. Alerts work for spawned forest goblins or fixed goblins inside the forest spawn rectangles; dark goblins elsewhere do not change other areas.

Blizzaga is the existing three-wave/shard implementation, registered for a private monster ability. Cost100MP, cooldown12s, range900. Wave base damage (65+1.5*INT)*Rod spell power; shard base(25+INT)*Rod spell power. Nonhero INT is0. Great Shamans and Gnolls start their newly specified mana pools full in day or night, enabling the requested casts. Devour cooldown15s. Unspecified defaults are documented here for review.

The new spider/assassin poison uses the poisoned hero's level, as confirmed by the owner. A target has one active instance of this new monster poison; equal/stronger procs refresh it and weaker procs do not overwrite a stronger active instance. Existing Poison Spear/Bio mechanics remain separate. Damage is before ordinary defenses and damage modifiers, cannot critically hit and does not reroll evasion after a successful proc.

House auras now restore7%maximumHP/MP persecond, with native percentage fields/data indices and tooltip text updated. Original fountain unchanged.

Implementation: experiments/GuardiaForest/Forest86.j is embedded in TMonsterData with a single shared1Hz heartbeat. Actors are registered once on world entry and removed/cleared on death; AI does not scan the entire map each tick. Readiness gates use cooldown, mana and suitable targets. Player-controlled creatures are not forced by this hostile AI. Event-driven spell, damage, attack and order hooks provide the active mechanics. World-entry/death mutations ignore unrelated/local cosmetic units. No GetLocalPlayer/visibility-dependent gameplay paths, inventory callbacks, preview polling or F/G changes. This is a code audit, not a multiplayer stability guarantee.

Validation:13 executable behavior tests cover Normal object stats, genuine native field data pointers, Devour allow-list/unlock, Alert countdown/success/death/once-per-creature behavior, forest-only spawning/amount/cap/period hooks, victim-level poison chances/five ticks, taunt orders/expiry/defense, evasion expiry, ready AI orders, Stinger-specific20% reduction, unrelated-world-event isolation, shared-only callbacks and preserved hero fixes. Full playable/editor compilation, editor layout, startup wiring/parity, globals, string safety, object references, save compatibility and archive readback pass.

Native acceptance remains pending. Test first in Normal: watch a shaman devour and cast Blizzaga; injure its allies to test Heal; kill an alert goblin during countdown, then let another finish; verify taunt releases after5seconds and after gnoll death. Test night for wolves and the Dark Goblin night pool. Stinger remains in the existing hunt system and is not added to ordinary forest spawns.

Original editor master, normal release,1.29.2 and CreatureReview02 are unchanged. Prior uninstalled forest candidates are preserved in build/candidates/forest86-first through forest86-fourth. The known cross-player native bag closure/desync investigation is not fixed by this prototype.

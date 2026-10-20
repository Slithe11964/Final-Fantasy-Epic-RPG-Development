# Final Fantasy Epic RPG 0.9.7.4 — Changes since PAIR019

Combined patch notes for PAIR020–PAIR032. Shared gameplay and tooltip changes apply to both Forsaken/Reforged and 1.29.2. Custom inventory and panel changes apply to Forsaken/Reforged unless stated otherwise.

## Saving and legendary progression

- Saving now treats monster parts, monographs, other unsupported items, and gear bound to another player as empty saved slots instead of failing the entire save. These items remain in your live inventory; they are simply excluded from the character save.
- Added save/load support for all six Freelancer forms, including the ranged variants.
- Fixed a compatibility error that rejected older character saves with “full profile readback differs” after legendary-progress tracking was introduced.
- Character saves now retain supported completed job trials, Wizard and Calculator elemental milestones, Summoner milestones, and each job's Proof of Strength.
- Timed or combo-based challenges still require a valid single attempt. Older saves cannot restore progress that was never recorded.
- Added `-legendary` for characters at level 99 or higher on their current job. It lists that job's requirements and highlights completed requirements in green.
- The checklist includes **Proof of Strength**—defeat a level 90+ boss solo—and the **Spiritual Ritual**, directing players to bring a Grand Crystal to the Spring of Life after completing both proofs.

## Equipment and item use

- Corrected equipment checks so gear in the hero's six normal inventory slots does not grant equipped stat bonuses. Its active item ability can still be used.
- Added **Move to hero** to transfer backpack gear into an empty hero inventory slot. Select the item, then select its destination slot. The button sits at the lower right of the gear panel, above the ring/offhand row.
- Corrected character loading so gear saved in the hero's normal inventory returns as carried gear rather than equipped gear.
- Corrected equipped-item checks for Prominent Cloak and related cloak/belt effects, and corrected Prototype Crossbow's equipment classification.
- Strengthened shared cooldown enforcement for active weapons, offhands, books, and Materia, including use through Gaya. Food and potions use their own shared consumable cooldown pool.
- Aligned the shared cooldown lock with the adjusted visible cooldown, including applicable Agility, Haste, Slow, and cooldown modifiers. Rejected casts no longer extend the lock, and the recovery message shows the remaining seconds.
- Potions, food, monster parts, curse scrolls, and Scroll of Shadows no longer have a carrying-level restriction. Equipment requirements for the resulting cursed gear still apply.
- House armory deposits now accept only items belonging to the 280-item armory collection. Unrelated cargo is no longer consumed as an armory deposit.
- Corrected Pram Nut's basic chocobo breeding behavior.

## Fishing

- Fishing-spot discovery now checks rods across backpack storage, loaded inventories, and Gaya.
- Carrying a rod reveals fishing access; starting fishing requires the matching rod to be equipped.
- Added a prompt to wait for the **!** bite indicator before pulling toward shore.
- Pressing a direction before the bite now repeats the guidance instead of ending the fishing attempt.

## Priest Master talents and healing

- Added three level-50 Priest Master talent choices:
  - **Acid Rain:** Converts half of Tranquility's healing into magic damage against enemies in the same area. At master rank, each 0.1-second pulse supplies **200 base healing and 200 base magic damage**, before target modifiers. Lower ranks split their own healing values in half.
  - **Refresh:** Esuna refreshes supported timed beneficial buffs, including food and stat buffs. Special effects such as Runic Shield gain **3 seconds** instead of a full duration reset. Esuna's base cooldown becomes **45 seconds**.
  - **Swiftmend:** Regen delivers the same total healing in half the time—**30 seconds instead of 60 at master rank**.
- Corrected Acid Rain's pulse timing and prevented duplicate native/scripted healing. A second Priest no longer restarts the active shared rain timer.
- Tranquility retains its normal description until Acid Rain is selected. Selected talent effects appear in a separate section on affected ability tooltips.
- Regen now explains its healing formula and current-rank duration instead of only saying it regenerates health.

## Combat abilities and summons

- Reworked Archer's Myriad Arrows and Time Mage's Meteor to restore their falling-wave visuals and damage when the previous projectile casts failed. Completed waves clean up their effects and tracking.
- Master-rank Animal Companion, Dragon Ally, Golem, Shiva, Ifrit, Cyclops, Bahamut, Neo Bahamut, Raise Dead skeletons, and Battle Wards now use **monster level 40** templates. Bahamut Zero already met that level.
- These summons remain ordinary creatures, not heroes. They meet the level threshold to avoid Deathbringer's level-based execution; lower-rank summons retain their existing levels.
- Corrected Rage's attack-speed descriptions to match its existing values: **+120% at master rank** for the transferable version and **+100%** for self-Rage. This corrects the text rather than increasing the bonus.

## Ability descriptions and calculations

- Added rank-specific calculation sections across **119 ability entries and variants**, retaining the original descriptions of targeting and effects.
- Physical and technique coverage includes Armor Breaker, Fan of Knives, Knot of Rust, Shock, Rapid Fire, Arrowwave, Myriad Arrows, Wave Fist, Rave Kick, Gaya Rage, Iainuki, Mineuchi, Tatsumaki, Dragon Breath, Dragon Slam, Jump, Ambush, Yuffie's Shuriken, Liquid Steel, Eclipse, Finisher, and Minus Strike.
- Magic coverage includes Darkness, Noxious Mixture, Molotov Cocktail, Bolt, Ice, Fire, Tornado, Meteor, Spell Shot, Scourge, Firaga, Thundaga, Blizzaga, Holy Blast, Flare, Holy, and Oblivion.
- Healing and recovery coverage includes Cure, Cura/Curaga, Tranquility, Pray, Regen, Blessing of Light, Chakra, Osmose, and Drain. Current-caster or self-target amounts are shown where applicable.
- Summon ability coverage includes Mega Flare, Giga Flare, Tera Flare, Hellfire, Final Smash, Diamond Dust, and the Necromancer corpse's Release. Release explains both its enemy damage and nearby ally healing.
- Mirage now explains its **+40 physical evasion** and **0.8 multiplier to the adjusted incoming physical hit chance**, with its current-rank duration. This is not a flat 40% dodge chance.
- Finisher lists its possible outcomes, damage formulas, and rank-dependent chances. Noxious Mixture explains its ingredient-dependent potency. Multi-hit abilities distinguish damage per hit, wave, or pulse from total damage.
- Corrected conflicting descriptive numbers for Holy Blast travel damage, Meteor waves, Liquid Steel hits, and Thundaga targets.
- Added `-spellcalculations on` and `-spellcalculations off`. This per-player setting shows or hides the extra calculation sections, including summon command calculations, while keeping the original ability description and selected talent effects.

## Stats, proficiencies, and talents

- Added a fifth stat page for **Proficiencies**.
- Added reversible **Back/Next** navigation in Forsaken. In 1.29.2, use `-stats 1` through `-stats 5`, `-stats next`, or `-stats back`.
- Reordered damage, defense, resistance, and other-bonus rows for easier comparison.
- Standardized percentage signs for physical/magical block and percentage defenses. Positive healing/mana efficiency bonuses include a plus sign, and Flat damage appears only when above zero.
- Simplified Accuracy and Evasion labels, changed “Mana Regen” to **Mana regen**, renamed “Axe training” to **Axe**, and removed the Heavens Forged Axe line from the proficiency page.
- Added active-effect defense entries for **Trance's lethal-damage protection**, **Mirage**, and **Squire's Defend**. Defend shows its existing 20% block, rising to 30% during Hold Position; Sentinel does not grant that increase.
- White Robe now explains its Staff-proficiency contribution to Life spell power. Other bonuses shows the resulting current bonus rather than implying a fixed percentage in every situation.
- Fully upgraded house proficiencies retain an informational icon describing their effect.
- Talent choices now display icons without overlaid names; names and descriptions appear on mouseover. Hover text fits within the panel more cleanly.
- The talent heading uses two lines, such as **Points: 3/4** and **Level Ultimate**, showing earned milestone points and the current tier.

## Forsaken inventory and interface

- Reworked the backpack and equipment panes to follow a shared open/close state, with a shared header **X** and Escape support.
- Revised item-use/drop handling, hero preview binding, and selection handling to address closing, split panels, and stale hero previews.
- PAIR032 specifically addresses repeated B input and overlapping native button actions that could cause flickering. Holding B now counts as one press until release, and native refreshes wait between steps instead of repeatedly clicking in one callback.
- Talents remembers its toggle when the inventory closes and reopens.
- Armory withdrawals request a refresh of an already-open backpack.
- Hunt Club hides while the custom inventory or inspection panels cover it and restores its appropriate visibility afterward.
- Added `-bazaarreveal` to reveal recipe reward names for the requesting player. It does not prepare recipes, spend ingredients, or bypass purchase requirements.

## Known issues and testing

- The latest backpack opening/closing changes and shared cooldown adjustments have passed automated checks but still need final in-game verification, including multiplayer and window switching.
- Native dragging from the backpack into the hero's six slots remains unresolved. Use **Move to hero**, or transfer through Gaya.
- The previously reported 1.29.2 Warcraft-menu saved-game failure with large imported characters remains unresolved. This is separate from character-code/file import.
- Use the updated paired maps for newly written character saves; older map builds may not understand the added legendary-progress data.

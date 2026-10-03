# Summons and Shadows

## Summons

Modules (folder 04):

- `Summon`: registration list.
- `Summon_Lifecycle`: detect and clean up.
- `Summon_Scaling`: the stat boost.
- `Summon_Transfusion`
- `Summon_Ifrit`, `Summon_Shiva`, `Summon_Bahamut`, `Summon_Golem`, `Summon_Cyclops`: one per summon.
- Boss-summoning items (`Summon_Items`) are a different thing: see [BOSSES.md](BOSSES.md).

### What players see

The Summoner job's spells call an Eidolon (Ifrit, Shiva, Bahamut …) or a golem that fights for a
limited time. Summons grow stronger with the player's summoner titles and Gaya's -gaya spells.

### How it works in code

- **One module per summon spell.** For example `Trig_Summon_Ifrit_Actions` (ability `'A1FP'`):
  1. Kills the previous Ifrit (`udg_Eidolon2`).
  2. Creates `udg_IfritUnitType[ability level]` at the caster.
  3. Gives it Summon Poof Death (`'A14I'`) and a 90 s timed life.
  4. Runs `Summon_Powerup`.
  5. Adds damage from the caster's Intelligence and the Inner Mana upgrade (`'R00L'`, read with
     `Prof_GetLevel`).
- **Other summoned units:** any unit entering the map with "Summon Auto-Powerup" (`'A009'`) that
  belongs to a player is boosted the same way (`Summon_Detect`).
- **The boost (`Trig_Summon_Powerup_Actions`, runs once per unit; marker ability `'A122'`):**
  - `udg_StatCalcValue` starts at 10. It gains points from titles (`udg_TitleForce` 30–34, 49–51:
    Apprentice/High Summoner, Exorcists, Final Arbiter, Extreme Challenger, Magic God, Monster
    Hunter …).
  - Damage, armor and max HP are then multiplied by `udg_StatCalcValue/10`.
  - Gaya's Tarugaya adds +3 to the damage multiplier, Sukugaya adds +20% attack speed, and
    Rakugaya adds +20 armor and a bonus ability.
- **Clean-up (`Summon_Death_Cleanup`):** clears `udg_SummonUnit[player]` / `udg_PetUnit[player]`
  when they die.
- **Transfusion (`Summon_Transfusion`):** abilities `'A0RM'`, `'A0RK'`, `'A13L'`, `'A13U'`
  consume a summon (not verified).

### Adding a summon

1. **Object Editor:** make the unit (one per ability level if it scales) and the spell.
2. **Module:** copy `Summon_Ifrit` to `Summon_<Name>`. Change the ability id, the unit-type table
   (or a single unit), the "previous summon" variable, the timed life and the damage bonus.
3. **Register it:** add `optional TSummon<Name>` and a `static if` block in the `Summon` module's
   registration list.
4. **Auto-boost (optional):** give the unit "Summon Auto-Powerup" (`'A009'`) instead of running
   `Summon_Powerup` yourself.

## Shadows

Modules (folder 06):

- `Shadow`: registration list.
- `Shadow_Lifecycle`: spawn, intro, leave, respawn, death.
- `Shadow_Hiring`: hire, disband.
- `Shadow_Loyalty`
- `Shadow_Combat`: Fuma Shuriken.
- `Shadow_Support`: Hero Drink.

### What players see

A wandering ninja, the Shadow (`'n04K'`, owned by the town-NPC player, `Player(8)`), appears at one of
several spots. Players can hire him for gold, or for free once he trusts them, and he then fights
for the party as an "Assassin" (`'E00S'`). His trust ("loyalty") rises when the party fights and
heals with him, and falls if the party attacks him or refuses to pay. If it drops too low, he
leaves for good.

### How it works in code

- **Spawning:** `Shadow_Init` (2 s after start) and `Shadow_Respawn` create him at
  `udg_ShadowSpawnPoint[n]`. The selling unit stocks hire offers:
  `udg_ShadowHireOffer[udg_ShadowOfferTier .. +2]` (`AddUnitToStockBJ`). The offer's price is the
  sold unit's point value.
- **Hiring (`Trig_Shadow_Hire_Actions`):**
  - Party level: it adds up the party's hero levels (`udg_TempInteger`) and compares them with
    `udg_ShadowLoyalty`. Too little pay or trust: he refuses, the gold is refunded, loyalty goes
    −6, and he respawns in 60 s or disbands.
  - Accepted: he is replaced by the Assassin, owned by `Player(10)`.
  - Gear: he gets gear for the party level, from `udg_ShadowKatana/Dagger/Armor/Helmet/Potion[tier]`.
  - Dancing Daggers: its level follows the number of players (`udg_DancingDaggersAbility[players]`).
  - Leaving: `udg_ShadowTimer` sets when he leaves (`Shadow_Leave`).
- **Loyalty (`Shadow_Loyalty`):**
  - `Shadow_KillCount`: rises with enemy kills.
  - `Shadow_HealedBonus`: rises when party healing spells hit him.
  - `Shadow_AttackedByParty`: falls when the party attacks him.
  - `Shadow_LoyaltyTick`: runs every 10 s.
  - Side quest 44 (`udg_SideQuest[44]`) changes how the tick moves loyalty around 100. The hiring
    code uses 160 and 280 as free-hire thresholds (exact rules not verified).
- **Skills:** `Shadow_FumaShuriken` (`'A0WS'`) and `Shadow_HeroDrink` (`Shadow_Support`).

### Adding a second shadow-like mercenary

The code assumes **one** shadow: `udg_ShadowUnit`, `udg_ShadowLoyalty`, `udg_ShadowTimer` are
single variables. A second mercenary needs its own copies of the six modules with renamed
variables, or turning those variables into arrays first.

## Gotchas

- **One summon at a time:** each summon spell keeps its last unit in one variable (`udg_Eidolon2`
  for Ifrit …) and kills it on recast. Two summons sharing a variable would kill each other.
- **Boost once:** `Summon_Powerup` boosts a unit only once (`'A122'`). Changing a summon's stats
  afterwards must not remove that marker.
- **Shared temp variables:** shadow hiring uses `udg_TempInteger` across `ForForce` callbacks, so
  keep those calls together.

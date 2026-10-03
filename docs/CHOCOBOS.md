# Chocobos: tame, ride, breed and dig

Modules (folder 09):

- `Chocobo`: start-up registration only.
- `Chocobo_Population`: tables, wild spawns, respawn.
- `Chocobo_Taming`: taming and breeding.
- `Chocobo_Breeding`: breed score.
- `Chocobo_Digging`: Dead Pepper digging.
- `Chocobo_Upgrades`: greens, Defend.
- `Chocobo_TechCopy`
- `Chocobo_Bribing`
- `Chocobo_WildBehavior`: wild AI, death, retaliation.

## What players do

- **Tame:** feed a wild chocobo a nut, which casts a "Chocobo Tame" ability. Up to 5 live chocobos
  per player.
- **Ride:** tamed chocobos get Chocobo Ride, Start/Stop Riding and Join Fast.
- **Breed:** use a nut on your own chocobo while another player-owned chocobo is within 512. A chick
  hatches; its colour and ability depend on both parents and the nut.
- **Dig:** Dead Pepper makes a chocobo dig. Digging on a dig spot gives that spot's item.
  Every so often a dig gives chocobo greens instead.
- **Upgrade:** Gysahl / Mimett / Silkis Greens evolve a chocobo to a stronger colour and keep
  its ability. The item "Chocobo Defending" raises its Defend.
- **Tech Copy** and **Bribe** are chocobo abilities (`Chocobo_TechCopy`, `Chocobo_Bribing`).

## How it works in code

### Taming (`Trig_Chocobo_Tame_Breed_Actions`)

Each nut has its own "Chocobo Tame" ability:

| Nut | Ability | Tame power (`udg_TempInteger`) |
|---|---|---|
| Pram | `'A0A8'` | 1 |
| Luchil | `'A0CT'` | 21 |
| Carob | `'A0CU'` | 31 |
| Zeio | `'A0CV'` | 100 |

- **Success rule:** taming succeeds if the power is above the chocobo's level, or if a random
  number from power to power+29 is above it.
- **On success:** the unit changes owner, its move speed is varied by ±20, and its wild
  abilities (Choco-Shell, Choco-Protect) are swapped for the riding abilities.
- **Map flag:** the first tame ever sets `udg_GameStateHash` key 2/20.
- **Limit:** `Chocobo_Tame_Limit` refuses taming at 5 chocobos. It counts units whose *name* is
  "Chocobo".

### Breeding (`Chocobo_Breeding` → `Trig_Chocobo_Breed_Score_Actions`)

1. **Starting score:** the nut sets `udg_ChocoboAbilityIndex`: Luchil 1, Carob 2, Zeio 3.
2. **Parent tiers:** the score then gets +1…+6 for each parent's tier.

   | Tier | Unit types |
   |---|---|
   | 1 | `n02J` |
   | 2 | `n02S` |
   | 3 | `n02T`, `n035`, `n036` |
   | 4 | `n02U` |
   | 5 | `n037` |
   | 6 | `n038` |

3. **Chick type from the score:**

   | Score | Chick |
   |---|---|
   | 15 | `n038` |
   | 14 | `n037` |
   | 12+ | `n036` |
   | lower | other types |

   (The lower branches are further down the same function.)
4. **Chick ability:** the chick gets Chocobo Tech Copy, plus `udg_ChocoboAbility[score]` at a
   level that grows with the tier.

### Abilities table (`Trig_Chocobo_Init_Actions`)

`udg_ChocoboAbility[3..15]`: Quick Join Fast, Shadow Mimic, Trickster's Sprint, Regeneration,
Teleport, Feather Aura, Chocry, Choco-Armor Aura, Chocobo Slow, Bribe, Chocobo Haste,
Chocommando Aura, Attack.

### Digging (`Chocobo_Digging`)

- **Dig spots:** `udg_ChocoboDigSpot[1..34]`, plus 99 (special).
  - 1–20 are random points in the monster spawn areas (`udg_SpawnRectHashRef`); see
    [SPAWNS.md](SPAWNS.md).
  - 21–34 are fixed regions.
- **Rewards:** `udg_ChocoboDigItem[i]` / `udg_ChocoboDigItemCharges[i]`: X-Potion, Turbo Ether,
  Elixir, nuts, Crystal Shard, gold and more.
- **Casting Dead Pepper (`'A0DJ'`):**
  - The nearest spot is found by `Chocobo_DigSpot_Nearest`. A cast within 256 of it digs it up.
  - Charges grow with the chocobo's level.
  - A dug common spot moves to a new random place. Its reward is re-rolled from entries 14–20,
    with double charges.
- **Greens:** every few digs (`udg_ChocoboDigCount`) the dig gives Gysahl, Silkis or Mimett Greens.

### Upgrades (`Chocobo_Upgrades`)

The greens cast `'A15X'` (Gysahl), `'A15Y'` (Mimett) or `'A15Z'` (Silkis) on your own chocobo.

- **Evolution:** `ReplaceUnitBJ` swaps the chocobo for the next type (for example Gysahl → `n036`).
- **Abilities:** it finds the chocobo's `udg_ChocoboAbility` and re-adds it, plus Join Fast,
  Sprint and Attack if missing.

### Wild chocobos

- `Chocobo_Spawn_Periodic` adds wild chocobos while there are fewer than 15 town NPC units and
  spawns aren't paused.
- `Chocobo_Wild_AI` makes them cast Shell/Protect and fight back.
- `Chocobo_Respawn` replaces them.

## Common changes

| Change | Where |
|---|---|
| Change a dig reward | `udg_ChocoboDigItem[i]` / `...Charges[i]` in `Trig_Chocobo_Init_Actions` (spots 1–20 are common, 21+ rare). |
| Add a dig spot | Add `set udg_ChocoboDigSpot[35]=GetRectCenter(gg_rct_...)` plus its item, and raise `udg_ChocoboDigSpotCount`. |
| Change taming odds | The power values in `Trig_Chocobo_Tame_Breed_Actions`, and the `+29` in `..._TameRollSucceeds`. |
| Change breeding results | The tier bonuses in `Trig_Chocobo_Breed_Score_Actions`, and the score thresholds in `Trig_Chocobo_Tame_Breed_Actions`. |
| Add a chocobo ability | `udg_ChocoboAbility[16]`. Also check every loop over 3..15 (Upgrades, TechCopy). |

## Gotchas

- **Chocobos are recognised by name.** The code checks `GetUnitName(...)=="Chocobo"`, so a new
  chocobo type must keep that name, and no other unit may use it.
- **Shared variables:** `udg_TempInteger` / `udg_TempGroup` / `udg_TempPoint` carry values between
  functions in the same trigger. Don't call other triggers in between.
- **One breeding at a time:** the breed score lives in one global (`udg_ChocoboAbilityIndex`).
- **Not saved:** chocobos are not in save codes.

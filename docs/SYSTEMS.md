# Systems guide

A map of where things live, for someone opening the Trigger Editor for the first time.
Every code module is one World Editor trigger with the same name. Inside the code it is a vJass
library called `T<Module>`.

Reference lists generated from the code (re-run `python tools/gen_docs.py` after changes):

- [TRIGGER_INDEX.md](TRIGGER_INDEX.md): every trigger, what fires it, and which modules turn it on, off or run it.
- [GLOBALS.md](GLOBALS.md): every variable, where it is declared, and who uses it.
- [DEAD_CODE.md](DEAD_CODE.md): functions nothing uses.
- [STARTUP.md](STARTUP.md): how the map starts.
- [DISABLING.md](DISABLING.md): which modules can be switched off on their own.

System explainers (written by hand):

- [SAVE_CODES.md](SAVE_CODES.md): `-save` / `-load`, what a code holds, how to change the format safely.
- [JOBS.md](JOBS.md): one hero per job, job change, unlock tree, mastery, the Shrine.
- [SPAWNS.md](SPAWNS.md): spawn zones, monster pools, the monster data table.
- [LOOT.md](LOOT.md): item indexes, monster drop chances, chests, steal.
- [BOSSES.md](BOSSES.md): how boss fights start, fight, die and drop; adding a boss.
- [ARENA.md](ARENA.md): cups, team data, Battle Points, the duel arena.
- [OBJECTS.md](OBJECTS.md): every custom unit, item, ability, buff and upgrade, with the code that uses it.
- [BUGS.md](BUGS.md): suspected bugs to check. [DEBUG_COMMANDS.md](DEBUG_COMMANDS.md): test commands.
- [../CONTRIBUTING.md](../CONTRIBUTING.md): the routine for every change and naming rules.

## How a module is laid out

```
library TQuestSaveTimmy requires ...      <- modules it calls into
globals                                   <- variables this module owns
    trigger gg_trg_Quest_SaveTimmy_Start=null
    boolean udg_FarmGateOpen=false
endglobals
function Trig_Quest_SaveTimmy_Start_Conditions ...   <- trigger code (GUI-style names)
function Trig_Quest_SaveTimmy_Start_Actions ...
function InitTrig_Quest_SaveTimmy ...      <- empty; World Editor requires it
// ---- Trigger registration ----
function Register_Quest_SaveTimmy_Start ...  <- creates the trigger: events, conditions, actions
endlibrary
```

Some parent modules (Quest, Boss, Arena, Hunt, Item …) hold only `RegisterTriggers_*` lists.
Those lists decide the startup order of their feature modules' triggers. Each call carries a note
saying whether the trigger starts off and which modules enable, disable or run it.

## The folders

### 01 Shared helpers
Small utilities with no gameplay of their own:
- `Wait`: polled waits.
- `Loc`: locations.
- `Filter`: common boolexpr filters.
- `Group` and `Force`: unit groups and player groups.
- `Path`: pathing checks.
- `Knock`: knockback.
- `Missile`: projectile system, used by many spells.
- `Code`: save-code bit buffer.
- `Number`, `Loop`, `Link`, `Wrap` and `Remove`: small helpers. `Remove` holds the shared
  "remove buffs/debuffs" triggers.

### 02 Map setup
- `Units` creates the script-placed units and buildings at startup.
- `Init` holds the timed initialization triggers: job tables, player colors, alliances,
  quest log, and so on.
- `QuestLog_Entries` is a GUI trigger with the quest log (F9) help texts. Edit them there.
- `Preload` preloads models.

### 03 Jobs and progression
- **Job change:** `Job` changes a hero's job when a job is bought at a shrine. `Shrine`,
  `Promotion` and `DarkJobs` hold the unlock menus. `JobLevels`, `Levels`, `Exp` and `Prof`
  cover experience and weapon proficiency.
- **Jobs:** one module per job, such as `Lancer`, `Geomancer`, `Ninja`, `Samurai` and `Chemist`.
  `Legend` and the `Legend_*` modules cover legendary job abilities.
- **Hero lifecycle:** the `Hero_*` modules handle selecting, ordering, levelling, death and
  revival, and medicine use. `Hero_Skills` holds shared skill helpers (learning skills to a
  level), and `Player_Hero` holds `Player_GetHero(p)`, the player's current hero.
- Details: [JOBS.md](JOBS.md).

### 04 Combat and abilities (the largest folder)
- **Damage engine (`Damage`):** every damage event runs through `Trig_Damage_Engine_CalcDamage`.
  Its header comment lists the parameters. It calls 19 step functions in order:
  `Trig_Damage_Engine_Step01_Setup` … `Step19_Apply` (Cover, Defense, Elements, Accuracy,
  Evasion and blocking, Magic …). Each step reads and changes the hit's values in the
  `DmgCtx_*` arrays (slot `c`, one per nested hit). To change a rule, find its step.
  - `CombatFormulas`, `Armor`, `MagicDefense`, `AttackSpeed`, `Evade`, `Block`, `Counter`
    and `Element` supply the numbers it uses.
  - `Dps` is the damage meter. `Text` (09) draws floating damage numbers.
- **Spells:** `Spell_*` modules hold one spell each. `Spell`, `Spell_Shared` and `Spell_Tables`
  hold shared spell code. A few spells register through `RegisterLegacy_*` during startup step 8.
- **Passive and status abilities:** the many small modules (`Regen`, `Protect`, `Shell`,
  `Haste`, `Sleep` …) each handle one ability or status.
- **Bosses:** `Boss` holds the registration lists. Each boss has a `Boss_*` module.
  Details: [BOSSES.md](BOSSES.md).
- **Summons:** `Summon` and the `Summon_*` modules handle lifecycle, scaling, items and the
  individual summons.
- **Gaya:** the Spirit of Gaya companion, in `Gaya` and the `Gaya_*` modules: inventory, orders,
  scanning and stats.

### 05 Items, crafting and shops
- **Loot:** `Loot` holds the drop tables (`Loot_Drop*`, `Loot_Vault_*` …). `Drop` holds
  special drops. Details: [LOOT.md](LOOT.md).
- **Item handling:** `Item` and the `Item_*` modules handle stacking, upgrades and cooldowns.
- **Armory:** `Armory` is the item storage and code-saved equipment.
- **Crafting and selling:** `Craft`, `Recipe`, `Forge`, `Bazaar`, `Materia`, `Cooking` and
  `Dismantle` cover crafting. `Merchant`, `Buy` and `Sale` cover shops.
- **Consumables:** `Potion`, `Elixir`, `Vial`, `Food` and the medicine modules.

### 06 Quests and story
- **Quests:** each `Quest_*` module is one quest's code. `Quest` holds the shared quest code and
  the startup registration lists. `QuestCount`, `QuestTotal` and `QuestUnits` track progress.
- **Story and NPCs:** named modules such as `Cid`, `Mid`, `Kalm`, `KalmSiege*`, `IceAge`,
  `TrueIceAge`, `Ending` and `Epilogue` hold story chapters, NPC dialogue and sieges.
  `Talk` and `Npc` hold shared NPC interaction.
- **Shadows:** `Shadow` and the `Shadow_*` modules are the hireable shadow companions.

### 07 Hunts and encounters
- **Spawns:** `Spawn` holds the spawn pools and timers. `MonsterData` holds the monster data
  tables. `Wave` holds wave spawns. Details: [SPAWNS.md](SPAWNS.md).
- **Hunts:** `Hunt` and the `Hunt_*` modules are the hunt board: contracts, encounters, rewards
  and shop. `HuntFestival` is the festival event.
- **Arena:** `Arena` and the `Arena_*` modules cover access, team selection, cups, rounds,
  duels and rewards. Details: [ARENA.md](ARENA.md).

### 08 World and travel
- **Zones:** `Zone` and `Zone1`…`Zone8` hold per-zone spawning and effects.
- **Travel:** `Travel`, `Warp`, `Teleport`, `Teleporters`, `Portal`, `Gate`, `Transport` and
  `Unstuck`.
- **Camera and cinematics:** `Cam` and `Cine`.
- **Time and weather:** `Time`, `Hour` and `Weather`.
- **Houses:** `House` holds player houses.

### 09 Player features
- **Commands:** `Cmd` holds the chat commands. `Help`, `Handicap` and `DamageText` cover
  `-help`, `-handicap` and `-damagetext`.
- **Save/load:** `Save` and `Load` hold the save/load codes and files (`-save`, `-load`,
  `-savef`, `-loadf`). `Code` (01) holds the bit encoding. `Autosave` and `SaveDebug` are
  related. Details: [SAVE_CODES.md](SAVE_CODES.md).
- **Titles and progress:** `Title`, `Titles`, `Speedrun`, `News` and `BattleLog`.
- **Game options:** `Vote` and `GameMode` handle game-mode voting.
- **Chocobos:** `Chocobo` and the `Chocobo_*` modules cover taming, breeding, digging, bribing,
  upgrades and wild behaviour.
- **Fishing:** `Fishing` and the `Fishing_*` modules.
- **Other:** `Music`, `Sound`, `Multiboard`, `Ping`, `PlayerTimer1`…`8`, and `Cheat` (cheat
  detection).

### 11 Developer tools
`DevCommands`: single-player test commands (`-dev`). Untick it for a public release. See
[DEBUG_COMMANDS.md](DEBUG_COMMANDS.md).

### 10 Startup coordinator
`MapBootstrap` holds `main_old`, the startup sequence (see STARTUP.md).

## Things that are easy to get wrong

- **Player numbers:** code uses 0-based ids. `Player(0)`…`Player(7)` are the human players,
  `Player(8)` holds quest/town NPCs, and `Player(11)` is the enemy. GUI shows them as Player 1–12.
- **Variables:** shared variables are in the Variable Editor (Ctrl+B), in the "Shared
  variables" folder. GUI shows them without the prefix; code uses them with `udg_`. Variables
  only one module uses are declared at the top of that module. A few shared ones stay in the
  map header (groups, timers, forces, hashtables, string arrays and variables with a starting
  value). Don't create a Variable Editor variable with the same name as one declared in code;
  GLOBALS.md lists where each one lives.
- **Starting state:** a trigger noted "starts off" is turned on by quest/story progress. Check
  TRIGGER_INDEX.md for who enables it before assuming it is unused.
- **Long text:** a very long string in custom script breaks loading saved games. Put long
  text in GUI actions, as `QuestLog_Entries` does. `check_map.py` warns about strings over 1000 bytes.
- **Switching a system off:** run `tools/disable_check.py` first (see `DISABLING.md`).

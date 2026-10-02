# How the map starts

## The sequence

1. Warcraft runs the World Editor-generated `main`. It creates the pre-placed units, regions
   and cameras, then calls every trigger's `InitTrig_<Name>` function.
   - For the 739 code modules, these functions are **empty on purpose**.
   - For any **new** trigger you add, World Editor's normal behaviour applies (see below).
2. The GUI trigger **MainDeprotected** has a *Map Initialization* event. It calls `main_old`
   once.
3. `main_old` (module `10 Startup coordinator/MapBootstrap`) runs these steps, in this order:

| Step | Function | What it does |
|---|---|---|
| 1 | `Startup_MapEnvironment` | Camera bounds, fog, ambient sound, music |
| 2 | `Startup_CreateSounds` | Creates the `gg_snd_*` sounds |
| 3 | `Startup_ApplyTechRules` | Upgrade rules for each player slot. The list is in `Startup_ApplyTechRulesForPlayer`. |
| 4 | `Startup_CreateDestructables` | Script-placed destructables, plus loot triggers for breakable barrels and crates |
| 5 | `Startup_CreateUnits` | Script-placed buildings, critters and units (`Units` module) |
| 6 | `Startup_BlizzardSupport` | Blizzard library state: player forces, stock, single-player flag |
| 7 | `Startup_InitSharedSystems` | Shared tables: paths, job heroes, music, save codes, missiles, recipes |
| 8 | `Startup_LegacySpellTriggers` | A few spell triggers the original author registered inline |
| 9 | `Startup_InitGameplayState` | Initial values of shared `udg_` variables |
| 10 | `Startup_RegisterTriggers` | Creates every gameplay trigger (see below) |
| 11 | `Startup_RunMapInitTriggers` | Runs the "initialization" triggers: quest setup, hiding NPCs, and so on |

**Keep this order.** Later steps use what earlier steps create.

## How existing triggers are created

Each trigger has a **registration helper** in its own module:

```jass
function Register_Agrias_ShowMarker takes nothing returns nothing
    set gg_trg_Agrias_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_Agrias_ShowMarker)
    call TriggerAddAction(gg_trg_Agrias_ShowMarker,function Trig_Agrias_ShowMarker_Actions)
endfunction
```

At the bottom of each module, `RegisterTriggers_<Module>` calls that module's helpers in order.
`Startup_RegisterTriggers` starts each `RegisterTriggers_*` once, using `ExecuteFunc`. That
gives each module its own thread, as in the original map: a heavy module can't use up the
startup thread's operation limit, and an error in one module doesn't stop the others.

**Why some modules have `_Part1`, `_Part2` …** When several triggers react to the same event
(for example "a unit starts the effect of an ability"), Warcraft runs them in the order they
were registered. To keep the original behaviour exactly, a module's triggers are split into
parts wherever keeping them together would change that order relative to another module.
`tools/startup_audit.py` proves this for every build. 49 modules are split. Quest (21 parts)
and Boss (14) are the largest.

**To change an existing trigger's events:** edit its `Register_*` helper.

**To find a trigger:** search for `Register_<TriggerName>` or `gg_trg_<TriggerName>`.

## Adding new triggers

Create a new trigger in World Editor, as GUI or custom text. World Editor creates and
registers it automatically through its `InitTrig_` function, so you don't need to touch
MapBootstrap.

Two cautions:
- Your trigger's `InitTrig_` runs **before** `main_old`. Don't rely on values that
  `Startup_InitGameplayState` sets, such as `udg_PlayingPlayers`, inside `InitTrig_` itself.
  Using them in the trigger's actions later in the game is fine.
- A new GUI trigger with a *Map Initialization* event runs before `main_old` if it sits above
  MainDeprotected in the trigger list (almost every position does). If it needs the map to
  be fully set up, use the event *Time - Elapsed game time is 0.00 seconds* instead.
- If your trigger must run in a specific order relative to existing triggers on the same event,
  register it from the relevant module's `RegisterTriggers_*` instead.

## Keep these as they are

- **MainDeprotected** (GUI): starts everything.
- **PreplacedUnitRefs** (a disabled GUI trigger): makes World Editor generate the `gg_unit_*`
  variables the code uses. Don't delete it or enable it.
- **ModuleLongText_*** helpers (QuestLog): long quest-log text. Build Play Copy moves this
  text into the string table so that native save/load works.

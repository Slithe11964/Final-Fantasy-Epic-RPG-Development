# Phase 16: shared `udg_Temp*` variables turned into locals (stage K)

## What changed

The map used 17 shared scratch variables (`udg_TempPoint`, `udg_TempInteger`, `udg_TempGroup` ...)
in about 1,000 functions. Shared scratch variables break when something runs in the middle and
uses the same variable:

- a `TriggerSleepAction`/`Wait_Polled`, during which other triggers run;
- an event fired by the function itself, e.g. creating a unit, dealing damage or killing a unit runs
  other triggers before the next line;
- a `ForGroup`/`ForForce`/filter callback.

Stage K converts every use that is provably private to one function into a local (`l_tempPoint`,
`l_tempInteger` ...): **509 functions in 321 modules**. Handle locals (location, group, force, unit,
player) are set to `null` before every `return` and at the end, as JASS needs.

It also fixes two leaks found while checking: `Trig_Trickster_Reveal_Actions` never removed its
location, and `Trig_Boss_DemiFiend_Summon_Actions` never destroyed its group.

## How it was proven safe

`tools/refactor/phase16_temps.py` converts a function's use of a variable only if all of these hold:

1. The function's first use of the variable is a plain `set` outside any if/loop, and that `set`
   doesn't read the old value.
2. Nothing the function calls uses the variable. This covers direct calls, callbacks
   (`ForGroup`, filters, timers), `ExecuteFunc` and `TriggerExecute` targets, and everything they
   call in turn.
3. No caller reads the variable after the call before setting it again.
4. The function has no computed `ExecuteFunc`/`TriggerExecute`.
5. It is not part of the startup sequence.
6. For handle variables, no `return` value uses it.

It was repeated until nothing more qualified (3 passes; each pass frees more functions).

Checks:

- **`verify_phase16.py --src`:** every changed function equals the old one once the change is undone.
  The undo drops the new `local` and `set …=null` lines and renames each local back to its global.
  Only the two leak fixes differ.
- **`verify_phase16.py CONTROL NEW`:** the same check on the compiled `war3map.j`. CONTROL is built from
  the old sources the same way.
- **`check_map.py`:** all checks pass, including the startup-order audit.

## What is left: real hand-offs (`docs/phase16-handoffs.csv`)

1,452 function/variable pairs still share a global, each with the reason:

| Reason | Count | Meaning, and how to fix it by hand |
|---|---|---|
| read before it is set | 592 | The value comes from outside: a callback (`ForGroup`, filters) reading what its caller set, often `udg_TempPlayer`/`udg_TempInteger` as a filter parameter. Fix: give the callback its own clearly named global (e.g. `udg_FilterPlayer`), or turn the callback loop into a `FirstOfGroup` loop with locals. |
| a called function also uses it | 441 | The other side of the same hand-off: the function sets it for a callee. |
| first set is inside an if/loop | 388 | Often still private to the function, but proving it needs flow analysis. Fix by reading the function. |
| computed ExecuteFunc/TriggerExecute | 28 | The target isn't known statically. |
| first set reads the old value | 5 | Accumulators (`set udg_TempInteger = udg_TempInteger + 1`) filled by callbacks. |

Most-affected modules: Title, Job, Titles, Fishing_ReelingAndCatch, Shrine, Shadow_Hiring, Freelancer,
Arena_Rounds. Work through them one module at a time. After each change, run `check_map.py` and
play-test that system.

## Re-running

    python tools/refactor/phase16_temps.py report            # what could still be converted
    python tools/refactor/phase16_temps.py apply [MODULE...]  # convert (all modules if none given)
    python tools/refactor/verify_phase16.py --src             # check the source change
    python tools/sync_module.py BASE.w3x OUT.w3x MODULE...    # put changed modules into a map

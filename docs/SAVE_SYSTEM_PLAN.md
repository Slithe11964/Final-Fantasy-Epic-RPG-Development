# Durable save system plan

## Current milestone

Private CZ provides the complete file save/restart/fresh-character load path
on BT gameplay. Meta Fragment validation is fixed; CZ shortens file-writing chunks
after CY exposed engine truncation. Repeat export, then complete the round trip and
size/timing measurements. Public
new-format saving remains off. Instructions: [SAVE_FRESH_LOAD_TEST.md](SAVE_FRESH_LOAD_TEST.md).
House and boots diagnostics previously passed, but do not prove this complete path.

## Format and scope

- Permanent append-only IDs: items, jobs, Chronicles/titles and Armory.
- Account-bound checksummed envelope; counted, versioned, length-delimited sections.
  Fully validate account, IDs, values, capacities and supported schemas before writes.
- Actual job level and mastery tier stay separate. Target cap150 with room for999;
  current engine cap99 stays until XP/growth rules are implemented. Legacy100 means
  level99/enhanced mastery. Frozen E/F/G/H migration remains required; the prototype
  can export a character loaded with the existing legacy reader.
- Include active job and job progression, equipment/bag/quick slots, Gaya, existing
  house contents, currencies, upgrades, Chronicle/title flags, Armory and durable flags.
  Preserve exact positions, duplicates, binding and persistent item metadata.
  Normal charge cap120; imported121..127 remain lossless.
- Exclude quests, eras and story checkpoints. A future activatable Chronicle sets
  story completions through its already-saved title flag; no quest section is needed.
- Refresh cooldowns. Below50, normal-job skills reset with refunded points; at50+,
  regular skills are rank11 and the ultimate rank6. Talents and Freelancer borrowed
  skills remain per-game choices. No new NG Minus export; keep legacy decoding.
- Older maps reading newer saves is not a goal. Unknown preservation is reserved
  for classic's later inaccessible backpack/equipment storage, without duplicates.

## Fresh load

Load once, early, onto untouched starting state. Parse the entire profile first,
then create the player's hero, Gaya and items and fill the assigned existing house.
Track only attempt-created objects and loader-written player state. On failure,
remove those creations, undo setup, leave HasLoadedCode false and permit retry.
Retain tracking and block retries if cleanup cannot finish. Confirm full readback
before consuming the load; creation and application remain synchronized.

Reuse the registry/aliases, codec and migration validation, read-only capture,
job/Gaya/Freelancer rules, slot planning, metadata/life helpers, stored-passive
knowledge and tracked allocation cleanup. Set aside live reference switching,
body recovery, original-item quarantine, session rollback, ownership preparation
and contained replacement-house/activation pipelines; they are not dependencies.

## Next

Run the real restart round trip, then measure that same code's actual length,
file-read estimate and multiplayer transfer/validation time on real clients.
Use the result to decide format/transport changes before further diagnostics.
If an engine diagnostic is needed, batch alternatives into one map and one summary.
Then finish legacy/durable-state edge cases and multiplayer failure/retry coverage,
enable public Reforged saving, and implement classic's inaccessible storage later.

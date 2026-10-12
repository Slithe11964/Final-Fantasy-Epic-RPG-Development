# Durable save system plan

## Current milestone

Private DI completed the real file export/restart/fresh-load round trip on
2026-10-11: Warcraft reported an exact full-profile match for the same
1,010-character save. Observed transfer/validation:0.500 s; load/verify:3.148 s.
The ~0 ms file-read result is limited by game-timer resolution.
Users also confirmed successful `-newsave`/`-newload` with different characters in
a real multiplayer DI game. Multiplayer timings were not supplied.
DK confirmed intentional failure cleanup, successful retry with exact profile,
and rejection of a second load. DL adds the approved r17 description and Intro.
Broader engine tests passed on Normal and Inferno, with exact inventory positions,
all jobs level99, many recipes, a different selected job and about2,000 characters.
The fifteen-minute load cutoff also passed.
DQ connects normal save/load commands to the new format in the private Forsaken
line, adding paged screen codes, numbered chat assembly, exact named files and automatic
legacy/new file imports with fresh-load safeguards. Command routing,
account/difficulty rejection and named multifile integrity have modeled checks;
next is real-client command acceptance and remaining multiplayer size/timing
coverage before public release.
Instructions: [SAVE_FRESH_LOAD_TEST.md](SAVE_FRESH_LOAD_TEST.md).

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

Test DS using file-free screenshot/chat codes and exact-name legacy/new files.
Collect multiplayer transfer time for the same larger profile and confirm missing
or damaged files reject without consuming the load. Keep all parts of multifile
saves together; real-client multifile acceptance remains pending.
If an engine diagnostic is needed, batch alternatives into one map and one summary.
Then finish legacy/durable-state edge cases and multiplayer failure/retry coverage,
enable public Reforged saving, and implement classic's inaccessible storage later.

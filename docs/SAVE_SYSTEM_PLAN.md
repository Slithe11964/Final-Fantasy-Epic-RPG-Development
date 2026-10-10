# Durable save system plan

## Current direction

Reforged first; updated 1.29.2 later. BT is the gameplay base, CB passed house
storage, and CT passed the contained boots diagnostic. Those results inform the
implementation but do not prove a complete character save. New-format gameplay
saving/loading is still disabled. The next milestone is a private real file
save/restart/load round trip, before more separate layer diagnostics.

## Format and scope

- Keep permanent, append-only IDs for items, jobs, Chronicles/titles and Armory.
  Never recycle IDs or serialize runtime aliases as permanent identities.
- Keep the account-bound, checksummed envelope and versioned, length-delimited
  sections with explicit record counts. Reject malformed, duplicate, truncated,
  overflowing or unsupported data before changing gameplay. A checksum detects
  corruption; it is not proof against forged codes.
- Store actual job level separately from mastery tier. Target cap150, with numeric
  room for999. Implement and verify matching engine/XP/growth rules before raising
  the gameplay cap; the format alone does not raise it. Preserve the legacy100
  sentinel's level99/mastery meaning during migration.
- Keep automatic E/F/G/H migration using frozen layouts and existing account,
  mode, difficulty, Hardcore/Speedrun, item eligibility and one-load rules.
- Save jobs/progression, current job, gear and inventory, Gaya, house contents,
  currencies, upgrades, Chronicles/titles, Armory and existing durable flags.
  Preserve exact quick6, bag30, equipment9, Gaya6 and house6 positions, legitimate
  identical items, binding and reviewed persistent metadata. Normal charges stay
  capped at120; imported121..127 remain lossless.
- Quest progress, quest completions, eras and story checkpoints are NOT save data.
  A future activatable Chronicle supplies story completions. Its existing saved
  Chronicle/title flag needs no quest section or quest/era ID registry.
- Cooldowns refresh. Below job level50, reset learned skills and refund points;
  mastered jobs receive regular skills at rank11 and ultimate at rank6. Talents
  are per-game choices. Keep reviewed Freelancer/Gaya policies. No new NG Minus
  export; retain legacy decoding.
- Older maps reading newer saves is not a goal. Reject unsupported schemas rather
  than building general unknown-section/progression preservation. Classic later
  retains backpack/equipment records it cannot display as inaccessible logical
  storage, re-emitting each exactly once without a materialized duplicate.

## Fresh-character load

1. Read the entire code into a detached profile. Validate format, account, IDs,
   values, eligibility, capacities and placement plan before gameplay mutation.
2. Recheck the early load window and HasLoadedCode immediately before applying.
   Only one successful load per game is allowed; no mid-game live replacement.
3. Create the hero and Gaya for that player, apply progression, and create/place
   their items and house contents. Use the map's existing assigned house where
   applicable; do not invent replacement buildings or restore a prior live hero.
   Stored gear must not grant passives; equipped gear and retained active items
   must work through the actual gameplay item path.
4. Track every load-created handle and loader-written player/house state. On
   failure remove only this attempt's creations, undo its setup changes, show a
   useful error and leave HasLoadedCode unset. Allow retry while the window remains
   open. If cleanup is incomplete, retain tracking and block another attempt until
   cleanup succeeds. Never delete unrelated items or leave a duplicate.
5. Verify the resulting character against the validated profile and documented
   load defaults, then set HasLoadedCode. Keep creation/application synchronized;
   local file access must not cause different gameplay state between clients.

## Reuse and set aside

Reuse the identity/alias registry, reference and JASS codec, detached legacy
migration/profile validation, job/Gaya/Freelancer policies, inventory capture and
slot planning, metadata/life helpers, stored-passive knowledge and tracked
allocation cleanup. Adapt only the parts needed for fresh creation; they are not
all wired into a working load yet.

Set aside the live reference-switch, body recovery, original-item quarantine,
original hero/session rollback, ownership-preparation and contained replacement
house/activation pipeline. Keep their sources as reference; stop extending them
unless the fresh-load flow needs a specific helper. Stop hidden/paused temporary
boots rounds. Do not import their recovery dependencies merely to reuse a helper.

## Next build: CU — real end-to-end prototype

Build the thinnest complete private path from BT: capture a real character's job,
level/progression, equipment and bag gear, quick slots, Gaya and house; write the
new code to a file; restart Warcraft; load in the early window onto fresh units.
Re-capture and compare all included state, allowing only declared load defaults.
Include preserved durable flags so this prototype does not silently lose them.
If an unsupported state cannot be preserved yet, reject export explicitly.

Report actual encoded length, file-read time, total validate/create/verify time,
and multiplayer send-to-verified-receipt time for that SAME code. Measure real
clients, including a real multiplayer session; simulations are not timings.
Use those results to decide whether payload size, encoding or transport needs
changes before expanding the implementation.

If engine alternatives are needed, put several candidates in one map and produce
one summary per run. Reuse valid cached base/regression checks; always check the
output map. Record one sentence per build in STAGES.md, short feature details,
and update HANDOFF.md only when the current state changes. Build reports retain
technical validation details; do not copy hashes, counts or scratch paths here.

After this round trip: finish remaining durable-state/legacy cases and failed-load
retry tests, validate multiplayer and restart behavior, then enable public
Reforged saving. Implement classic's inaccessible inventory preservation later.

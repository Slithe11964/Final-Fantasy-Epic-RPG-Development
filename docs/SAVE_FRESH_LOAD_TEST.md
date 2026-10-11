# Private save/restart/fresh-load test - DI

Map: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDI.w3x`.
Built on BT gameplay; legacy export remains disabled. Private commands use
`Forsaken CU.txt`, separate from legacy saves.

Engine milestone (2026-10-11): exact export/readback followed by restart and
**PASS: exact full profile after fresh load** in DI, using the same real profile.
Code length:1,010 characters. Reported file read:~0 ms (game-timer resolution);
transfer/validation:0.500 s; load/verify:3.148 s. These are one observed run;
multiplayer timings were not supplied.

Multiplayer milestone (2026-10-11): users reported successful `-newsave` and
`-newload` for different players' characters in a real DI multiplayer game.
Next: record multiplayer code lengths/timings and visually check restored inventory
and effects, then review failed-load retry and one-load/window enforcement.
No new build is needed to collect these observations.

File chunks use separate temporary player-name slots with checked headers, restoring
every name after reading. Larger saves need `Forsaken CU part N.txt` beside the main file.

## One round trip

1. Fully exit Warcraft, then start DI with the same account, difficulty and Speedrun setting as the character.
   Load your old character with `-loadf` or the usual legacy code command. Put gear in both
   equipment and the bag, and include quick-slot, Gaya and house items.
2. Stand still and enter `-newsave`. Wait for **file written and read back exactly**.
   Record the reported character count; a capture failure leaves the file unverified.
3. Fully exit Warcraft, restart DI with the same settings, and use `-newload`
   within the first fifteen minutes. Leave the starting character, Gaya and house
   untouched: no items, purchases, job changes or leveling before loading.
4. Stand still until **PASS: exact full profile after fresh load** or an error.
   Send the final message and check job/level, equipped effects, bag positions,
   quick slots, Gaya, house quantities and Chronicle/Armory flags visually.

Below level50, normal-job skills reset and points are refunded. At level50+,
regular skills become rank11 and the ultimate rank6. Freelancer's borrowed skills
and talents remain per-game choices. Cooldowns refresh. Quests/eras are excluded.
The current gameplay cap is99; the format's future150/999 space does not raise it.

## Timing and multiplayer

The final message reports the same code's length, file-read game-timer estimate,
ordered transfer/validation time, and complete load/readback time. File timing can
show zero within one game frame; it is not a precise wall-clock IO measurement.
After the restart round trip, use that same file in a real multiplayer DI game to
measure multiplayer delivery and confirm that players see the same loaded state.
The successful multiplayer report establishes delivery for the tested characters;
it does not provide multiplayer timing measurements.

## Implementation and failure handling

The complete profile is validated before creation. The loader creates owned hero,
Gaya and items, fills the existing assigned house, and checks a fresh full capture
before consuming the player's load. Stored gear passes through the new hero's
active slots so native abilities can be read and passives removed before storage.
Inventory handlers are excluded only during synchronous setup/cleanup.

Failure removes only the attempt's creations and restores loader-written player
state; HasLoadedCode stays false. If cleanup remains blocked, `-newcleanup` retries
it before another load. An unsupported profile is rejected rather than partly loaded.
Live-swap recovery modules are not imported. The private builder uses the checked BT
regression expectations and trigger names from BT; newer gameplay modules and
their tests stay outside this private build. Unrelated normal-map edits stay
out of this gameplay checkpoint. Exact fresh-load verification and user-reported multiplayer save/load passed;
multiplayer timings and visual gameplay acceptance remain.

## World Editor saving

Forsaken's `Job` library must list `TUnit` in its `requires` line because the
stored-item helpers belong to `TUnit`. The gameplay and round-trip builders now
add this dependency. For the user's r17 editor save, the separate
`release/Forsaken/FFERPG_0.9.7.3-r17-editor-fixed.w3x` preserves the saved Intro and
scenario description, changing only this dependency. Open it in World Editor and
save successfully before playing: its runtime still comes from the failed save.

# Private save/restart/fresh-load test - DM

Map: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDM.w3x`.
Built on BT gameplay; legacy export remains disabled. Private commands use
`Forsaken CU.txt`, separate from legacy saves.

Engine milestone (2026-10-11): exact export/readback followed by restart and
**PASS: exact full profile after fresh load** in DI, using the same real profile.
Code length:1,010 characters. Reported file read:~0 ms (game-timer resolution);
transfer/validation:0.500 s; load/verify:3.148 s. These are one observed run;
multiplayer timings were not supplied.

Multiplayer milestone (2026-10-11): users reported successful `-newsave` and
`-newload` for different players' characters in a real DI multiplayer game.
DK engine milestone: intentional failure after full item placement cleaned up
without using the load; retry produced an exact full-profile PASS; a second load
was rejected. Observed code:1,111 characters; transfer/validation:0.360 s;
load/verify:3.086 s; file read:~0 ms (game-timer resolution). Session mode was not
specified, so these timings are not labeled multiplayer measurements.

DL retained the verified loader with the user's r17 description and Intro. A user
reported an exact full-profile PASS with all Forsaken equipment slots occupied:
code1,300 characters, transfer0.602 s, load/verify3.250 s; session mode unspecified.

Broader engine acceptance (2026-10-12): user reported successful endgame loading
with all jobs level99, many recipes, a different selected job and a save of about
2,000 characters. Inventory positions matched exactly across the reported runs.
Normal and Inferno were tested successfully; loading after fifteen minutes was
correctly rejected. Timings for the endgame profile were not supplied.

DM carries the updated DevCommands editor module: `-allitems` creates copies of
all distinct saveable item types; `-allchronicles` awards missing Chronicles,
including Time Trial progress. Enable DevCommands in a separate World Editor
single-player development copy and save before use; release maps keep it disabled.
Use these helpers after a successful load or to prepare a character before export,
not on the untouched starter that will receive a load.

`-newretrycheck` deliberately fails after all saved items are placed, then confirms
cleanup without consuming the load. Persistent cleanup failures retain tracking
and block retry. Existing verified files remain compatible.

File chunks use separate temporary player-name slots with checked headers, restoring
every name after reading. Larger saves need `Forsaken CU part N.txt` beside the main file.

## Tester checklist

1. Existing verified DI files can be reused. For a new character, load it with the
   legacy reader, enter `-newsave` while standing still, and wait for exact file
   readback. Restart Warcraft before testing the new load.
2. Start DM with matching account, difficulty and Speedrun settings. Leave the
   starting hero, Gaya and house untouched. Within fifteen minutes run
   `-newretrycheck`: the intentional **FAIL** is expected. Wait for
   **created objects cleaned, load unused; retry allowed**. If cleanup stays blocked,
   use `-newcleanup` and send the error; do not treat that result as a pass.
3. Run `-newload` in that same game and wait for **PASS: exact full profile**.
   Run it again: another load must be rejected. Other players must still load normally.
4. Check job/level, equipped effects, bag/quick positions, quantities and binding,
   Gaya, house, Chronicle and Armory flags. Include different jobs and fuller inventories.
5. Send the final message screenshot (code length and timings), job, settings,
   player count, and any mismatch seen by either client. Stand still during verification.

Optional window check: in a separate untouched game, wait past fifteen minutes;
`-newload` must report that the window closed without creating anything.

Below level50, normal-job skills reset and points are refunded. At level50+,
regular skills become rank11 and the ultimate rank6. Freelancer's borrowed skills
and talents remain per-game choices. Cooldowns refresh. Quests/eras are excluded.
The current gameplay cap is99; the format's future150/999 space does not raise it.

## Timing and multiplayer

The final message reports the same code's length, file-read game-timer estimate,
ordered transfer/validation time, and complete load/readback time. File timing can
show zero within one game frame; it is not a precise wall-clock IO measurement.
After the restart round trip, use that same file in a real multiplayer DM game to
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
state; HasLoadedCode stays false. Cleanup is rechecked briefly on later ticks.
If it remains blocked, `-newcleanup` retries it before another load. An unsupported profile is rejected rather than partly loaded.
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

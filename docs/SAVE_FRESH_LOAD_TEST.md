# Private save/restart/fresh-load test - DO

Map: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDO.w3x`.
Built on BT gameplay; normal commands now use the new format in this private
Forsaken test. Legacy imports remain available; public maps are unchanged.

| Command | File or behavior |
|---|---|
| `-save` or `-savef` | Write and verify `FFERPG/Forsaken.txt`. |
| `-savef Endgame` | Write `FFERPG/Forsaken Endgame.txt`. |
| `-load` or `-loadf` | Fresh-load `Forsaken.txt`. |
| `-loadf Forsaken Endgame` | Fresh-load that named new-format file. |
| `-loadf Last save` / `-load OLD_CODE` | Existing legacy file/code import. |
| `-newsave` / `-newload` | Retained aliases using the verified `Forsaken CU.txt`. |

New filenames reserve the Forsaken prefix and accept letters, digits, spaces,
underscores and hyphens, up to64 characters including the prefix. NG Plus/Minus
commands and autosave remain disabled in this private line.

Engine acceptance: real file export/restart/fresh load and different players'
multiplayer loading passed. Intentional failure cleanup allowed retry, a second
load refused, and the fifteen-minute cutoff worked. Normal/Inferno, all equipment
slots and endgame profiles with all jobs99, recipes and a different selected job
matched exactly; the largest reported profile was about2,000 characters.
Observed single or unspecified-mode examples:1,010 characters transferred in
0.500 s and loaded/verified in3.148 s;1,300 characters took0.602 s and3.250 s.
File read showed~0 ms at game-timer resolution; multiplayer timings remain pending.

DO carries the updated DevCommands editor module: `-allitems` creates copies of
all distinct saveable item types; `-allchronicles` awards missing Chronicles,
including Time Trial progress. Enable DevCommands in a separate World Editor
single-player development copy and save before use; release maps keep it disabled.
Use these helpers after a successful load or to prepare a character before export,
not on the untouched starter that will receive a load.

`-newretrycheck` deliberately fails after all saved items are placed, then confirms
cleanup without consuming the load. Persistent cleanup failures retain tracking
and block retry. Existing verified files remain compatible.

File chunks use separate temporary player-name slots with checked headers, restoring
every name after reading. Larger saves need matching `<filename> part N.txt` files beside the main file;
keep the complete set when copying saves. Missing parts refuse loading.

## Tester checklist

1. In DO, import an existing character using `-loadf Last save` (or your actual
   legacy filename) or a pasted legacy code. Run `-save` while standing still;
   wait for exact file readback. Also run `-savef Endgame` for a named copy.
2. Restart Warcraft. Start DO with matching account, difficulty and Speedrun
   settings. Leave the starter, Gaya and house untouched. Within fifteen minutes
   run `-load`; expect **PASS: exact full profile**. A second `-load` must refuse.
3. In another fresh game, run `-loadf Forsaken Endgame` and expect the same match.
   Existing CU files still use `-newload`; the previous intentional retry check
   remains `-newretrycheck` followed by `-newload` after verified cleanup.
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
After the restart round trip, use that same file in a real multiplayer DO game to
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

# Private save/restart/fresh-load test - DU

Map: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDU.w3x`.
Multi-file test map: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDV.w3x` (see below).
Built on BT gameplay; normal commands now use the new format in this private
Forsaken test. Legacy imports remain available; public maps are unchanged.

| Command | File or behavior |
|---|---|
| `-save` | Capture and display numbered code lines; no file writes. |
| `-savepage 2` | Display another page of the last captured code. |
| `-load FSVB:...` | Paste each displayed numbered line in a fresh game, in any order. |
| `-savef Endgame` | File only: write exactly `FFERPG/Endgame.txt`. |
| `-savef` | File only: write `FFERPG/Last save.txt`. |
| `-loadf Endgame` | Detect and import either a legacy or new-format file. |
| `-loadf` / bare `-load` | Detect/import `Last save.txt`. |
| `-load OLD_CODE` / `-loada (ARMORY)` | Retained legacy chat import. |
| `-newsave` / `-newload` | Retained aliases using `Forsaken CU.txt`. |

Screenshot every numbered code page; use `-savepage NUMBER` to display it again.
Each page shows three complete command parts, with80 code characters per part.
Yellow PAGE X OF Y banners appear above and below the commands, state the total
screenshots required and show the exact next `-savepage` command. Viewing a page
clears only that player's previous on-screen messages to avoid mixed pages.
The user confirmed DR's screenshot layout and colors. Legacy colors are preserved: uppercase gray, lowercase yellow, digits blue,
symbols green. Colors are display-only; the original parts and screenshots remain
load-compatible. A26-part code now needs9 screenshots so every part fits. Paste each complete displayed command; duplicates are harmless and order
is flexible. No objects are created until every part and the full account-bound
profile validate. New codes include Armory in the same assembly. Legacy `-loada`
remains for legacy codes. A mistyped part can be replaced; checksum failure asks
for all parts again without using the load. Only `-save` captures/displays screenshot pages; file saves leave that cached code
unchanged. `-savef` uses the legacy path message, then "Saved successfully" only
after exact readback, or the legacy unverified-file warning on failure. If file
access fails, use `-save` for a separate file-free capture and manual load.

Named files use exactly the requested name, with letters, digits, spaces,
underscores and hyphens, up to64 characters. Keep all matching part files together.
NG Plus/Minus commands and autosave remain disabled in this private line.

DP's extra-portrait fix was confirmed by the user: after verified loading, the inactive
Freelancer becomes Neutral Passive, matching legacy job storage. The active hero
and Gaya remain player-owned; the inactive Freelancer stays available for jobs.

Engine acceptance: real file export/restart/fresh load and different players'
multiplayer loading passed. Intentional failure cleanup allowed retry, a second
load refused, and the fifteen-minute cutoff worked. Normal/Inferno, all equipment
slots and endgame profiles with all jobs99, recipes and a different selected job
matched exactly; the largest reported profile was about2,000 characters.
Observed single or unspecified-mode examples:1,010 characters transferred in
0.500 s and loaded/verified in3.148 s;1,300 characters took0.602 s and3.250 s.
File read showed~0 ms at game-timer resolution; multiplayer timings remain pending.

DT carries the updated DevCommands editor module: `-allitems` creates copies of
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

## Changes in DU

- Saving no longer needs the hero to stand still: `-save` and `-savef` read the
  whole character within one game frame, so a later autosave can run during play.
  Load verification still checks over a few seconds after the new units settle.
- A load replaces the starter in place: the starter and its Gaya are hidden while
  the saved hero is created on the same spot, then removed on success (the new
  hero is selected) or shown again if the load fails.
- Files load whatever page size wrote them: reading takes the chunk lengths from
  the file instead of this build's constant, so a save from the normal build also
  loads in the small-page test build and the other way round. Length and checksum
  still verify the assembled code, and a missing or damaged part is still refused.
- Loaded masteries count again: food used is set to the number of jobs at 99
  (Freelancer included), every saved title reruns its unlock effect (Shrine, dark
  jobs and their food cap, Legendary), and total job level is recalculated. Titles
  14 and 20 skip their unlock so the legacy NG+/NG- exporters stay off. Title
  stats are not added again because the saved stats already include them.
  Check: a save with all 23 jobs at 99 shows food 23/23 and total level 2277.

## Multi-file test map (DV)

Real profiles stay under one 3,680-character file page, so DV is the same as DU
except that each file page holds 920 characters. A normal endgame save then spans
several files. Build it with
`python experiments/Forsaken/build_save_roundtrip.py --stage DV --small-file-pages`.
Test: `-savef Multi`, restart, `-loadf Multi` must PASS; then move
`Multi part 1.txt` out of the folder and `-loadf Multi` must refuse without
creating anything. Extra files are numbered from 1, so a two-file save is
`Multi.txt` plus `Multi part 1.txt`. Never ship a small-page build.

## Chat-load helper

`python experiments/Forsaken/save_test_helper.py chat "Last save.txt" --out lines.txt`
turns a new-format save file into shuffled `-load FSVB:` lines with one duplicate,
for testing chat loading without retyping screenshots.

## Shrine availability

DT keeps the town Shrine of Individuality visible from startup. Before the mastery
title is earned, a Freelancer purchase silently removes the selection token and
leaves the hero unchanged. Successful loads with the saved mastery title also run
the original shrine unlock, restoring its ability menus. Existing saves need no
conversion. Check a fresh unmastered starter, then load your mastered character
in another game and switch to Freelancer and back.

## Tester checklist

1. Import your old character in DT using `-loadf YOUR_NAME` or the legacy chat
   code. Run `-save`, screenshot every page using `-savepage NUMBER`, and confirm
   this works without allowing file writes. Run `-savef Endgame` to test file export.
2. Restart Warcraft. Start DT with matching account/difficulty/Speedrun settings
   and an untouched starter. Within fifteen minutes paste the numbered `-load`
   lines, including a duplicate and some out of order; expect exact-profile PASS
   only after all parts arrive. A second load must refuse.
3. In separate fresh games, test `-loadf Endgame` for the new file and `-loadf`
   with your legacy filename for an old file. No Forsaken prefix is added. Existing
   CU files still use `-newload`; `-newretrycheck` still verifies cleanup/retry.
4. Check job/level, equipped effects, bag/quick positions, quantities and binding,
   Gaya, house, Chronicle and Armory flags. Include different jobs and fuller inventories.
5. Send the final message screenshot (code length and timings), job, settings,
   player count, and any mismatch seen by either client.

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
After the restart round trip, use that same file in a real multiplayer DT game to
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

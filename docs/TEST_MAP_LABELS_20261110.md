# Test-map identities, November 10, 2026

The recent builders changed filenames/archive headers but inherited internal
scenario strings. V26 was still named V7 in the scenario and still welcomed
players to 0.9.7.5d. Production candidates shared the same plain 0.9.7.5g name.

The eight current test maps now have distinct map-list/lobby names, loading
titles/subtitles, welcome text where present, scoreboard prefixes where present,
and F/G diagnostic prefixes. Standalone bag tests also identify themselves in
their existing help and F9 quest title. Creature Review is explicitly 03s.

| Filename | Visible identity |
| --- | --- |
| FFERPG-0.9.7.5g-Recovery14.w3x | FFERPG 0.9.7.5g Recovery14 |
| FFERPG-0.9.7.5g-Recovery15.w3x | FFERPG 0.9.7.5g Recovery15 |
| FFERPG-0.9.7.5g-NoFG-Test.w3x | FFERPG 0.9.7.5g No F-G Test |
| FFERPG-V25.w3x | FFERPG V25 - Gear Frontend |
| FFERPG-V26.w3x | FFERPG V26 - Gear Display |
| FFERPG-Inventory-Multiplayer-Check-03.w3x | FFERPG Native Inventory Check03 |
| FFERPG-Independent-Backpack-04.w3x | FFERPG Independent Backpack04 |
| FFERPG-Creature-Review-03s.w3x | FFERPG Creature Review03s |

Existing filenames and folder locations are retained, including Current Test
and TESTER. Workspace release copies receive the same labels for future builds.
Exact originals and sidecars are preserved under
release/development/TestMapLabels20261110/before-labels; the manifest records
before/after hashes and actual installed locations. This is not a new gameplay
version: current full development remains V26, next V27.

Only runtime/editor string literals, scenario display fields, WTS display
entries and the archive display header are changed. Non-string script tokens
are verified identical; all other archive payloads are byte-identical. No UI,
inventory, casting, save, sync, timer or cinematic behavior changes.

Future builds must label internal scenario/welcome/scoreboard/diagnostics as
well as the filename/header. Reusable string/scenario helpers are in
tools/test_map_identity.py. Packaging verification must compare actual map
identity, not assume the archive header controls all in-game names.

Installation exception: Warcraft holds Current Test/FFERPG-0.9.7.5g-Recovery15.w3x open. It was preserved, and the corrected map is Current Test/FFERPG-0.9.7.5g-Recovery15-Labeled.w3x. Use the Labeled copy for the next session. All eight new labelled maps passed the full map/editor checks. No native session was stopped.

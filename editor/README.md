# Edit once, build both maps

Open `FFERPG-Editor-Master.w3x` in your configured Warcraft Reforged World Editor.
This is a Reforged-format authoring map. Its current starting point includes the
ATV classic gameplay fixes and approved r17 introduction/scenario text.

1. Make your map edits in that master. Keep JASS/vJass and JassHelper enabled as
   required by this project's triggers. Save the map and wait for compilation to finish.
2. In PowerShell, from `C:\Users\jaked\WarcraftMapExtractor\FFERPG`, run:

   ```powershell
   .\build-pair.ps1
   ```

   Alternatively run `editor/Build Both Maps.ps1`. Each run gets a dated build name.
   To choose your own name or use a separate editor Save As file:

   ```powershell
   .\build-pair.ps1 -Map "C:\path\My Edited Map.w3x" -Stage CUSTOM001
   ```

3. The command prints the new folder under `release/pairs/<build name>/`.
   It contains two playable maps:

   | File | Client |
   |---|---|
   | `FFERPG-<build name>-Forsaken.w3x` | Reforged/Forsaken with native inventory, Bazaar panels and Stats/Talents UI |
   | `FFERPG-<build name>-1.29.2.w3x` | Warcraft 1.29.2 with paged backpack/equipment and compatible dialogs |

4. Start a fresh game in each client and test your changes. Keep editing the master
   for the next build. Generated playable maps are outputs, not replacement masters.

There is no manual source export or separate 1.29 editor step. The master is never
modified by the builder. Both maps publish together only after their checks pass.
The build report records the exact editor-input hash and both output hashes.

## How edits carry over

The master owns terrain, doodads, placed units, pathing, regions, cameras, sounds,
scenario properties, edited object fields, imported files and shared trigger edits.
Compatible scenario settings include bounds, dimensions, player/team settings,
loading/prologue text, fog and weather. Object fields you deliberately reset to
default are excluded from the classic fallback data, so conversion does not put
their previous custom values back. Stock defaults can differ between clients.
The native profile retains its own inventory/UI modules and object fields. Item edits
also update the corresponding native equipment variants and generated item lookups.
World Editor string-table references are resolved before merging object edits.

The master uses the shared/classic inventory implementation while authoring. The
Forsaken inventory and custom panels are applied to the generated native map. Test
that interface in the Forsaken output; copying its triggers back over the master
would mix the two inventory implementations.

Edits are compared against the pinned reference maps in `pair-config.json`.
Those references must remain available and unchanged. Back up the master, config,
reference maps and project tools together. Updating a reference pair requires an
explicit rebase of the master so existing editor changes are retained.

## When a build stops

The error names the conflicting module/field or prints a private build-log path.
No half-built pair is published. Retain your master; fix the reported compatibility
issue and run again. A build name is never overwritten.

Reforged-only APIs/assets do not automatically gain a 1.29 implementation. Changes
to a profile-specific inventory module, conflicting native overrides, unknown GUI
action formats or unsupported vJass constructs require an adaptation before both
maps can build. Existing save item/job IDs stay append-only; new collectible gear
and slot changes require the project's catalogue/save-migration steps. These checks
prevent an editor change from being silently ignored or an incompatible map being
presented as a working classic copy.

This workflow is tested with automated merges and compiler checks. Actual World
Editor Save As behavior and gameplay in both clients still need user acceptance.
The initial checked pair is in `release/pairs/PAIR004/`.

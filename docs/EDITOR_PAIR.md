# Paired editor build implementation

The user workflow is in [editor/README.md](../editor/README.md). `build-pair.ps1`
snapshots the saved master and runs `tools/build_pair.py`. Its schema-1 config pins
the ATV shared editor reference and EN native reference by SHA256. Neither reference
advances automatically: rebase intentionally when platform maintenance changes.

`tools/editor_pair.py` applies the editor delta to each profile. World files come
from the master. Trigger libraries and object fields use three-way merges; conflicts
fail instead of choosing an arbitrary side. Strings are resolved before object
comparison. Item changes regenerate native variants and item lookups without
replacing the native equipment module. The fresh-load trigger guard is refreshed
from actual runtime declarations. Semantic save-codec edits and structural equipment
slot migrations require explicit review.

The builder also refreshes the reviewed bounded-string runtime helper and local
file-reader adapter from `tools/save_strings.py` / `SaveStrings.j`. Local file
assembly uses its own storage; shared validation uses deterministic shared IDs.
This runtime safeguard changes neither the serialized codec nor the pinned master.

Each profile gets a private source export and the normal compiler/content/regression
gates. Native regression fixtures match the native implementation rather than
asserting the classic backpack layout. Classic conversion compiles against the old
native declarations, retains compatible edited scenario settings, and prunes explicit
field resets from its private fallback template. Other omitted Reforged fields still
receive the classic fallback needed by existing abilities. The report records reset
count, input/reference hashes, changed modules/files and output hashes.

Only after both builds pass does the ready directory move into `release/pairs/STAGE`.
An exclusive per-stage lock prevents duplicate publication; a failed run leaves its
snapshot and logs in `build/EditorPairSTAGE-*`. Confirm no build is running before
removing a lock left by a forcibly terminated process. Stages never overwrite outputs.

The optional edited-scenario conversion in `tools/downgrade.py` follows the binary
layout documented by [War3Net MapInfo](https://github.com/Drake53/War3Net/blob/master/src/War3Net.Build.Core/Serialization/Binary/Info/MapInfo.cs)
and [PlayerData](https://github.com/Drake53/War3Net/blob/master/src/War3Net.Build.Core/Serialization/Binary/Info/PlayerData.cs).
It removes fields without a v25 representation (modern HUD, height fog, graphics/data
version, camera zoom extensions and HD water) and retains the compatible scenario
and player/force data. Lua is rejected. The normal template-based downgrade remains
unchanged unless this option is selected.

Validation includes function/global edits, profile conflicts, native ability retention,
skin overrides, item lookup/alias propagation, GUI/world runtime preservation,
trigger enable/disable wiring, codec/macro rejection, added-trigger load guards,
explicit default resets and scenario conversion. A synthetic edited real map also
checks item text, derived accuracy lookups, pathing, shared intro text and an import
in both profiles. User acceptance must still exercise an actual editor save and
play both outputs. The unresolved endgame Warcraft-menu checkpoint issue remains
separate; this build workflow does not claim to repair it.

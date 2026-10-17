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
file-IO boundary from `tools/save_strings.py`, `SaveStrings.j` and the canonical
`Forsaken-save-transport.j`. Local file assembly uses its own storage; shared
validation uses deterministic shared IDs. Reading/packet preparation does not enter
the shared scanner; checksum and profile validation run on synchronized receivers.
Export checksums run before private writing. Native/classic sync adapters stay
profile-specific. These runtime safeguards change neither the serialized codec
nor the pinned master.

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


Reviewed performance maintenance is also applied automatically to both outputs:
projectile lifetime guards, deferred rooted save-fragment reclamation and collection
change tracking. Native output additionally caches its panel handles and display
reads. These changes live in tools/performance_runtime.py and the canonical save
helpers; editing the master does not require manually repeating them per profile.
The master and pinned references are not rewritten. Pair provenance includes the
maintenance and save-string transform hashes. Future changes to their anchors fail
closed if the edited source no longer matches the reviewed transformation.


Shared quest/travel/inventory maintenance is carried by tools/gameplay_runtime.py
and the reviewed CarrySupport/TravelPages fragments. It applies to both outputs
from the editor master. Native quest searches and Sleipnir cleanup use native storage;
classic compiles only its own backpack adapter. The added file is included in pair
provenance. Item IDs, save layouts and the pinned authoring/native references remain
unchanged. Keep using the same editor master and paired build command.


The paired runtime also carries the reviewed Elysium crossing repair. Object
maintenance in tools/world_visuals.py suppresses inherited attachment art on custom
Amgl dummy passives in both output profiles, preserving explicitly authored art.
The pair report lists changed marker abilities and records the maintenance tool hash.

Job behavior/stat maintenance is applied by tools/job_runtime.py and
tools/job_objects.py to both profiles after their source/object merge. Native stat
frames keep their cached display adapter; classic keeps its text pages. Effect
snapshots are written on synchronized spell events and read by either UI. The job
object pass updates both main and skin records, including Undying's cooldown text
and the inert Necromancer/Skeleton Champion marker bases. See JOB_EFFECTS.md.

Native backpack visibility maintenance in tools/inventory_ui.py preserves an open
panel across drop/use/unequip UI refreshes. Its short restore window is local
presentation state only; it never controls shared inventory operations. B, Escape,
selection changes and checkpoint panel rebuilding cancel the window. Classic keeps
its own paged inventory. The maintenance tool is recorded in pair provenance.

## Newer World Editor saves

A newer World Editor may save the master without the HM3W header, move display fields between
war3map.* and war3mapSkin.* tables, and drop fields whose value it treats as a default. The
builder (editor_pair.relayout) places every field in the table the editor reference uses, keeps
the reference's value for a dropped field, and takes the header from the reference when the save
has none. To reset a field to its default, give it the default value explicitly.


Save capture omission policy (PAIR020): tools/save_strings.py refreshes FRC_Read in
both profiles from Forsaken-save-capture.j, retaining each profile's FRC_At storage
adapter. An item absent from the permanent save registry or bound to another
player emits no record. Only emitted records count in the inventory header;
positions of other records remain unchanged. Live items are never modified.
Registered eligible items still require valid charges, life and flags. The two-pass
inventory/progression consistency checks remain active. This applies to -save,
-savef and autosave because they use the same capture path. The serialized format
and previously saved files are unchanged. Gameplay acceptance: hold monster parts,
monographs and borrowed bound gear alongside owned gear; save, load in a fresh game,
confirm only eligible items return in the same slots, with no save failure.

Armory hints in the editor master:
- Trigger Editor -> 05 Items crafting and shops -> Armory -> Armory_InitHints:
  edit the matching ArmoryHint[index] string for the click message.
- Object Editor -> Units: the matching missing-entry unit has rawcode zNNN,
  where NNN is the same zero-padded index (for example z012). Edit its extended
  tooltip for the hover hint as well. Keep its IDs and item mapping unchanged.
  Reforged may expose display fields through skin data; edit the effective tooltip
  shown by the editor. The paired builder merges the authored base/skin fields.
- src/armory-hints.json is the source catalogue mapping item names to indexes and
  hint text. Keep it aligned with the edited trigger and object text: build validation checks
  those against the catalogue. The ordinary
  paired build does not regenerate hints from this JSON over the editor master.

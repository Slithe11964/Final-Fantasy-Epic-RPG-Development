# QuickUI52: loaded equipment and native item previews

2026-10-28. Owner confirms Calculator preview in UI51 works; loaded F/G casting,
live icon changes and native bag previews still fail. UI51 is not accepted.

UI52 preserves released F/G input, synchronized request validation and casting.
Both legacy V2/V3 load completions and fresh-load commit now queue the equipment
refresh. The old remove/add-active-ability attempt is replaced by the same
unequip/remove/pickup/equip lifecycle used by job transfer, using the same item
handles. Quick slot zero is temporarily reserved and restored so a full inventory
has space. Charges are zero during pickup and restored afterward, matching job
transfer; item identity, owner, userdata and other metadata are not rewritten.
The conversion guard suppresses replacement recursion; stored effects are then
reconciled. The local dock reads/redraws both live slots each 0.1-second tick,
regardless of equipment events or revision counters.

Wave previews keep the working Calculator path and Dragoon rune renderer.
Native bag controls also observe mouse-down, include nested row children, and
are discovered in bounded shared timer batches after initial construction.
An item click cannot cancel its own preview through the same-tick world mouse
notification with stale coordinates. Subsequent world clicks and right-click
still cancel. Wateraga/Book of Depths retain the 800-unit line; Ice Wand U and
Calculator Blizzaga retain the same three authored ice rays. Aqualung, Sonic
Thrust, Cuts damage and gameplay object tables are unchanged from UI51.

Validation: four UI52 regressions (full inventory lifecycle/data, both loader
hooks/live redraw and packaged unchanged combat, native click/mouse ordering,
nested bag controls), six wave regressions, playable/editor compilation, editor
pairing/startup/global/text checks, content IDs and save compatibility pass.
These checks simulate native behavior; real client and multiplayer acceptance
remain required. Previous maps are preserved.

## Separate World Editor crash

The master SHA256 is still
`f7108fa827f36f0c73773308b0d464c468c14a2ff3b58b5afde25f492e4a4e7e`.
Its 747 paired trigger/source entries and folder layout parse correctly.
Two 2026-10-28 editor reports show the same access violation executing address
0x2 during loading, after HD model loading and doodad metadata messages.
The last warning is not sufficient to identify the cause. Editor preferences
have Misc assetMode=2 and hd=1. Owner asked to try SD/Classic before opening the
master. No master, preferences or installed game files were changed.
Computer-use initialization failed twice with `failed to write kernel assets:
The system cannot find the path specified`, including after a kernel reset;
direct editor validation is unavailable this turn. Do not call this crash fixed.

Authoring remains editor/FFERPG-Editor-Master.w3x once it opens. The owner can
place a uniquely named arena vendor and terrain/regions there. Wave design can
be supplied as a numbered list of unit names/counts, bosses and special rules;
implement the purchase/start and wave progression after the owner's saved edit.
Current UI test builders are based on UI40: merge new master content explicitly
before building the arena so placed units/terrain are not silently omitted.

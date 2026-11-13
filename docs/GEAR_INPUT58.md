# UI58 / native Hotfix06 casting recovery

The owner reports that UI57 arms wave runes but cannot cast Ice Wand U, and
single-target shortcuts still lack a cursor. Backpack Wateraga, Depths and Ice
Wand U must start the same moving rune paths as F/G.

Restore the UI55 Request/Mouse/Receive casting design: local selection sends an
exact equipped-item request, validated and executed in the synchronized receiver.
Remove UI56's active-ability rebinding and UI57's simulated native frame clicks.
UI55 icon paint/repaint/refresh/draw functions are token-identical. No item is
moved, re-seated, or stripped of abilities at runtime.

Single-target F/G explicitly draws the packaged QuickGearTarget.tga screen
reticle using current native pixel-to-frame coordinates, hiding the ordinary
pointer while armed and restoring it on cancellation/cast. This is a custom
reticle, not a native cursor mode. Its disabled BACKDROP cannot receive clicks.
Point/range spell previews continue to draw their authored circle/line shapes.

Native inventory click handling is left intact. Shared initialization caches
known InventoryButton/EquipmentButton names by context and installs hover
events only. The existing 50ms wheel timer observes a rising left button and
reads the live hovered item. A separate all-wave-item lookup includes Wateraga
materia, which the F/G equipment table does not include. Arming native bag
previews never sends a cast request; the real item click owns the cast. Clicking
another native item clears any old F/G request to prevent two casts on one
target. No hierarchy walking, per-poll frame discovery or click overlays.

The native frame limitation is an inference from the owner's regression and
firsthand UI author reports: [native event replacement example](https://www.hiveworkshop.com/threads/how-can-i-add-frame-events-to-the-default-ui.354804/),
[Reforged simplebutton hover support](https://www.hiveworkshop.com/threads/the-big-ui-frame-tutorial.335296/).
Command-selection events are not used for inventory items; Calculator retains
E and its ordinary command-selection observer. Water is one 800-unit rune line;
Blizzaga uses the existing three authored rays to 1000 units.

The map's item Channel spells reuse flamestrike, thunderbolt, acidbomb, frostnova
and inherited channel orders. This matches the reported correct item/expected
spell but wrong actual spell while another staff is carried. Thirty Channel
item spells get unique Ncl6 orders at build time. Allocation excludes authored
ability orders, scripted order strings, stock base orders, and stock abilities
referenced by runtime/unit/item data. Names come from the installed game's
AbilityFunc tables. All other fields, including target modes, damage, mana,
cooldowns and tooltips, remain identical. Fixed-base native spells are unchanged.
This object-data approach still needs engine acceptance for the reported case.

Outputs: QuickUI58 with Dragoon/Cuts and native 0.9.7.5e Hotfix06 without them,
based on UI56 and Hotfix04 respectively. Earlier job/Gaya/silence/travel repairs
remain; original master SHA256 is still
f7108fa827f36f0c73773308b0d464c468c14a2ff3b58b5afde25f492e4a4e7e.
Classic Hotfix05 is unchanged; there is no new classic-only UI repair here.

Validation: playable and editor-source compilation, startup/global agreement,
archive readback and unchanged unrelated assets; content/save compatibility;
focused tests cover passive Wateraga arming, no native click replacement,
dispatch restoration, confirmed icon preservation, only-Ncl6 object changes,
unique item commands, cursor visibility/cancellation, and wave geometry.
All checks and four focused tests passed on the final archives; both maps were
installed into Documents/Warcraft III/Maps/Download/TEST with matching hashes.

Still unverified in client: delivery of native hover events for generated bag
buttons, short clicks between 50ms samples, cursor appearance/click-through,
actual correct item spell after command reassignment, and multiplayer. If a bag
preview fails, -gearcheck now includes bag preview count and hovered slot; use
these values as evidence rather than assuming event delivery from mocks.

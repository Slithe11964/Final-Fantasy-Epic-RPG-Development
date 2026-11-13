# UI65 / native Hotfix13 candidate

2026-10-29: owner confirms F/G work after -clear in UI64. Preserve that fix.
Owner rejects UI64 backpack previews: no rune paths. Requests warning slightly
higher/larger and larger Wateraga/Depths/Ice Wand U/Calculator Blizzaga indicators
matching damage footprint; asks about optional ice branches.

## No inventory overlays

Retire owned proxy/detector initialization entirely: no BagCastRoot, buttons,
tooltip frames, click handlers, bag sync channel or native item hooks are created.
Only cache the always-existing ConsoleBottomBar at shared initialization.
BagScreen_Poll65 reads mouse screen coordinates and cached native frame sizes,
then maps a click to row-major six-by-five bag slots. Installed inventorybar.fdf
anchors SimpleEquipmentInventoryPanel BOTTOMRIGHT to ConsoleBottomBar TOPRIGHT
with (0,.03); the observer uses that layout, panel dimensions and .01 grid inset.
It does not show/hide/move native UI, synthesize a click, or cast any item.
Right-click pickup/drop is observed solely to avoid showing a cast preview
while moving items. Native engine controls own actual clicks, tooltips and moves.

**Unverified:** absolute bounds in the current client/HUD scaling. This method
cannot intercept inventory input, but misestimated bounds can omit or mislabel
a visual preview. -gearcheck reports current screen slot, bounds, cell size and
preview count. If it still fails, capture that while hovering the wave item;
do not reintroduce blocking overlays to manufacture successful rune arming.

## Preview dimensions from actual damage

Packaged TSpellWater's Forsaken_WaterTouches uses 800-unit travel and width
100 + 200*along/800; target collision size adds tolerance. Display uses twice
the old glyph size (48 vs 24), a center path, widening boundary rows and end
caps. It shows the nominal wave footprint rather than only its narrow center.

Packaged TSpellBlizzaga advances 200 per tick and only damages while distance
<1200: pulse centers are 200/400/600/800/1000 along each of three authored angles
(-11.25, +11.25, +33.75 degrees). Every pulse enumerates a 200 radius. Show 15
large rune circles at those centers. GearWaveRune.tga's opaque extent is 58 of
64 pixels, so a 442-wide image gives approximately 400 visible diameter. This
includes Ice Wand U and Calculator Blizzaga via their existing shared mode.
Preview is the unobstructed nominal footprint: actual ice can stop at terrain.

Middle-wave shards use GetRandomReal(0,360) when launched, with additional
missile travel/collision/splash logic. Their eventual directions are not known
while aiming. Do not show fixed branch lines or consume synchronized randomness
in a local preview. Optional branch paths are deliberately omitted. No damage,
randomness, mana, cooldown or other spell logic is changed.

Warning: Y .155 (was .14), font .027 (was .024); same gold/shadow/cyan cursor.
All confirmed UI64 chat/physical-key recovery, F/G requests/receiver, icon
refresh and shared mouse dispatch are token-identical. Only TEquip and new
warning FDF/TOC imports change. Both original master and prior maps retained.

Five focused tests pass: grid bounds, native pickup/drop observation, 63 water
markers, all 15 ice pulse positions, transitive local safety and packaged
preservation. Screen test uses real arithmetic because the existing quest
harness otherwise floors all divisions. Both maps pass playable/editor
compilation, source/globals/startup, save compatibility, content, archive
readback and unrelated-resource byte checks. Actual appearance, slot bounds
and multiplayer runtime still require client acceptance; no crash-free claim.

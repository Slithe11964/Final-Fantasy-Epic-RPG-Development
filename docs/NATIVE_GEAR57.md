# Hotfix05 and UI57 native equipment targeting

Owner confirmed that clicking the equipped staff/book in the upper equipment
panel opens the normal targeting cursor. F/G now call the corresponding native
equipment control for the current bound hero, keeping the working UI55 shortcut
art and cooldown presentation. The engine owns target validation and the cast.

Removed UI56's failed primary active-ability rebinding and substitute unit rune.
The mouse callback only tracks preview position/cancellation; it never sends a
second manual item-use order. The old legacy sync receiver remains dormant.

Controls are reserved at shared initialization by their known native names and
contexts; no child traversal, per-tick discovery, or inventory item movement.
When a fresh hero is not bound, a single native Backpack input starts binding;
the queued click expires after 1.5 seconds and cancels on selection/hero/item or
focus changes. First use may open Backpack. A failed bind tells the player to
open Backpack once. Disabled native controls are respected.

Both native branches have an independent 64-image rune bank. Water previews
draw 32 runes ending at 800 units. Blizzaga draws three 21-rune paths ending at
1000 units, using the existing authored angles. Calculator E/button, native
water/ice command-selection events, and equipped item click observers arm the
same renderer. Escape/right-click, world click, focus loss and spell effect
clear it. Single-target items get the engine cursor, not an area circle.

There is no Ice Wand K object in these maps. Ice Wand U (I0DY, A0UY) is the
three-wave Blizzaga item. Regular Ice Wand (I01G, A0Q9) stays single-target.

Builds:

- VersionEHotfix05 native: based on Hotfix04, without Dragoon/new Thief ultimate.
- QuickUI57 native: based on UI56, retaining Dragoon and new Thief ultimate.
- VersionEHotfix05 1.29.2: Hotfix04 classic gameplay unchanged, release label only.

Job/Gaya transaction, silence-resistant backpack and checkpoint teleporter
repairs from Hotfix04/UI56 remain. Objects and unrelated resources match their
bases byte for byte. Both native archives add only the existing rune art under
the standalone GearWaveRune.tga import. Original master and earlier maps remain.

Validation: all three playable/editor-source compilations, startup/source/global
checks, archive readback, content references and save compatibility pass. Six
focused tests cover correct native control selection, disabled controls, binding
queue cancellation, no manual cast/frame discovery in local input paths, UI55
icon preservation, and wave geometry/range. These are mocked/static checks.

Still requires actual Warcraft acceptance: BlzFrameClick opening a native cursor
when the panel is hidden, first-load binding, native command-selection event
timing for backpack previews, alt-tab recovery and multiplayer behavior. Test
Final Wand/Siphoning/Life Staff with Gaya's Rod and Nirvana carried together;
confirm the native cursor and expected/actual spell IDs agree. Do not claim
these engine behaviors were proven by compilation or mocks.

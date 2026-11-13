# UI55: icon repaint scheduling

2026-10-28. Owner rejects UI54 for stale G art and confirms everything else
works. Their -gearcheck screenshot shows slot1 Book of Tremors, raw1714565681
(`f221`), spell1093679408 (`A090`); load/native phases0, selectedyes, keys enabled.
The UI53 label on that diagnostic is inherited by UI54, not version evidence.
This confirms the live item/cast lookup is correct; it does not show whether the
UI54 painter ran or which texture reached the rendered button.

UI55 is built directly from UI54 and changes only icon repaint scheduling plus
diagnostics. The existing .05-second wheel timer refreshes icons before any
native cooldown-frame drawing or idle return. Changed textures invalidate the
existing owned simple-frame panel with a hide/show pair only when already
visible. Hidden panels stay hidden. No frames/timers/items are created or moved
by this refresh. Input, casting/sync, target state, cooldown calculations,
gameplay, objects, wave indicators and inventory behavior remain unchanged.
The only changed existing functions are QuickGear_PaintIcon,
QuickGear_WheelTick (icon call before its unchanged animation body) and
QuickGear_Diagnostic. The latter now reports UI55 and painted/lookup icon paths.

Four regressions pass: idle repaint after swapping without job change; texture
update precedes a simulated native cooldown draw failure; hidden visibility is
preserved; packaged function/resource scope. Map/editor compile/pair/startup/
globals/native-text and save compatibility checks pass. These are simulated
render regressions, not proof of the Warcraft renderer's root cause or a real
client fix. In-game icon acceptance is still required.

Next check: Depths to Tremors on the same job. If G stays blue, -gearcheck now
shows Icon slot1 painted/lookup paths to distinguish a missing painter callback
from a frame display failure. UI53 F/G casting is locked. Backpack-click previews
remain explicitly deferred until icons work. Original maps and master preserved.

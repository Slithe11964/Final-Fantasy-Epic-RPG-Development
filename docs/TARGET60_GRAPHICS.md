# UI60 / native Hotfix08 — target feedback and Dragoon graphics fallback

Owner rejection/follow-up: cursor disappears. UI60's UV row was fully
transparent; corrected in UI61/Hotfix09 with exact native cyan bitmap on the
previously visible BACKDROP route. Backpack hooks also failed; replaced by
passive pre-click tooltip sampling. See TARGET61_RECOVERY.md. The model fallback
has no new owner acceptance report yet and is retained unchanged.

Owner showed native inventory targeting with a cyan crosshair versus the yellow,
visibly delayed scripted shortcut overlay. They want G to behave exactly like
the inventory item, including native-style invalid-target feedback. They also
showed Dragoon invisible except for its shadow in modern Classic graphics.

Native limitation remains unresolved: installed common.j exposes UnitUseItem /
Point / Target, but no begin-item-targeting-mode operation. The previously tried
BlzFrameClick path did not start real casting in owner testing. A firsthand
[inventory click experiment](https://www.hiveworkshop.com/threads/simulate-clicks-on-inventory-items.326712/)
also distinguishes firing frame callbacks from invoking native inventory input.
Do not claim the replacement overlay is the actual native cursor mode, or that
this proves all possible native approaches impossible.

Target changes on both native branches:

- The yellow QuickGearTarget.tga overlay is no longer used. A SIMPLEFRAME texture
  displays the actual HumanCursor.dds target cell (top-origin UV rectangle
  0..0.125, 0.25..0.5), tinted cyan. No generated approximation or cursor texture
  override is imported; ordinary native inventory cursor behavior is untouched.
- A dedicated shared 0.01-second presentation timer updates the screen cursor
  independently of the existing 0.05-second gear wheel poll. It reads local mouse
  position and changes owned UI only. This is still script-driven and is not a
  promise of hardware-cursor latency. Both timer and owned frames are cleaned up
  on the existing UI reset lifecycle.
- Clicking empty ground for unit-target F/G sends no cast, keeps the item armed,
  plays the existing InterfaceError sound, and shows "Must target a unit with
  this action." in an owned error-style TEXT frame instead of chat/messages.
  The next valid unit click uses the unchanged synchronized item receiver.
- This reproduces only the specified empty-ground feedback; it does not claim
  to duplicate every native target restriction/error. Casting, icons, shared
  cooldown handling, rune previews and item order assignments remain unchanged.

Dragoon model findings and fix (UI60 only):

The installed Units/UnitSkin.txt entry [hctg] explicitly defines:

    file:sd=units\human\footman\footman
    file:de=Units\Human\CityGuard\CityGuard
    file:hd=Units\Human\CityGuard\CityGuard

The previous H00C umdl directly named CityGuard, bypassing the per-style fallback.
Its object model is now a valid Footman fallback. The existing shared Dragoon
tick applies BlzSetUnitSkin(hero,'hctg') once when the current hero is H00C and
its skin is not already hctg. Warcraft selects the appropriate art on each
client; there is no graphics-dependent hero creation or gameplay branch. The
hero type, abilities, name, stats, level and save identity remain H00C. This uses
the modern engine's built-in skin definition, not imported model files.

The separate 1.29.2 release has no new Dragoon/Thief integration yet; no new
1.29.2 build is produced here. Future backports of Dragoon must use a valid
legacy object model and omit skin APIs, as originally agreed.

Retained UI59/Hotfix07 scene candidate: Kalm and arena Gilgamesh cutscenes still
run camera moves, timings, pauses and scripted events. Animated talking portraits
are replaced with timed captions. Crash resolution and caption appearance remain
unverified; owner has no time to test them now. No additional scene edits here.

Validation: both playable/editor-source scripts compile; startup/global/source,
content/save and archive checks pass. Four focused tests cover empty-ground
retention and valid follow-up cast, one-time Dragoon skin change, owned error UI
and timer cleanup, native cursor art packaging and preserved casting/icons/scene
functions. In-game texture crop/tint/layering, perceived latency, error layout,
and City Guard in DE versus Footman in SD still require client acceptance.
Original master and earlier maps remain intact.

# UI66 / native Hotfix14 candidate

Owner feedback: UI65 native backpack input remains usable, but previews are
intermittent, sometimes appear after alt-tab, and can flash/disappear after
moving items. Two water/ice indicators are visible. Oversized ice circles are
unreadable; requests water-style paths with 2x water glyph size. Warning needs
native comparison styling; supplied desired/current screenshots show a larger,
higher, left-of-screen-center native warning.

## Changes

- Keep read-only screen-coordinate bag observation; no inventory overlays,
  native child traversal, item movement, synthetic clicks or local item casts.
- Add direct native mouse-down event observation using the current screen
  position. Existing polled rising-edge observer remains a fallback, suppressed
  for .12s after a native event to avoid replaying it. Record pickup item/source
  slot and notice already-completed native moves; placement does not arm casts.
- UI bag clicks return before QuickGear_Mouse's world-confirm/cancel path.
  Existing code treated a UI click with stale nonzero world coordinates as a
  world confirmation once its .08s grace expired. This is a concrete path that
  can immediately clear a newly armed bag preview. The slot geometry still
  needs actual client acceptance; no claim of complete reliability from mocks.
- Duplicate found in TDamage: Wave_Poll/Wave_Draw still render 24-unit DG_Rune
  images for the same water/ice spells. Retire those two generic functions and
  their DG_UIUpdate branch. Actual Dragoon skill rendering remains. No combat
  damage functions changed in that module. Native/no-new-jobs branch has no
  such functions, so only TEquip changes there.
- Ice: replace fifteen 442-wide image circles with 63 small glyphs on three
  authored directions. Each glyph is 96 units, exactly twice water's 48.
  Paths reach 1200, including the last 1000-distance pulse's 200 radius. This
  trades full overlapping pulse disks for readability; it is not a shaded
  complete union of damage areas. Random shard directions remain unpredicted.
  Water widening footprint presentation is retained unchanged.
- Warning font .037 (previous .027), height .055; center at (.4,.20), using
  native 4:3 center rather than full-window pixel center. This addresses size,
  higher placement and left shift seen in reference. Exact match unverified.

## Water range answer

Packaged Forsaken_WaterTick caps travel at 800 and destroys its effect at the
endpoint. Forsaken_WaterTouches requires along-collision <=800 and uses radius
100+200*along/800. A target center at 801 with collision 0 is not hit; center
816 with collision16 can touch the endpoint, but 817 cannot. At the end, across
300 is hit and 301 is not (collision0). VFX geometry can project beyond its
origin/path; this does not extend the damage predicate. Actual damage, VFX,
mana, cooldowns, randomness and save data are unchanged.

Validation: four focused tests pass for event/poll deduplication and fallback,
pickup/place handling, UI events bypassing stale world coordinates, water range
and width boundaries, single generic renderer, 96-unit ice glyphs, local UI
safety, unchanged confirmed post-clear F/G recovery/casting/icons, and packaged
object identity. Both maps pass playable/editor compilation, source/startup/
globals, content, save compatibility, archive readback and unrelated-resource
checks. Prior maps and original master retained.

Unverified: actual mouse-event delivery/slot bounds across focus changes,
backpack preview persistence, visual clarity/range perception, warning matching
and multiplayer runtime. Do not describe them as confirmed fixes yet.

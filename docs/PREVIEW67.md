# UI67 / native Hotfix15

Owner likes UI66 style. Requests only Wateraga/Book of Depths middle row doubled,
smaller ice damage-area boundary around the three projectile paths, and reports
native clicks stop previewing especially with no castable equipment. Equipped
item clicks also do not arm the preview. Keep native movement/tooltips and the
confirmed post-clear F/G fix.

## Concrete preview lifetime bug

QuickGear_Poll computed dock visibility using `(QuickGearActive[0] or
QuickGearActive[1])`, then called QuickGear_ClearPreview whenever false. That
function clears GearWave too, including native backpack/Calculator previews.
Thus an empty/non-castable loadout reliably cleared native aiming every .1s.

Keep hiding the dock when neither slot has a castable item, but cancel aiming
only for cinematic/deselection or an actual pending F/G request whose matching
slot lost its castable item. Existing invalid hero/load-state cancellation is
retained. No new overlay, no synthetic clicks and no direct local casting.
Regression executes the actual packaged poll 20 times with both slots inactive:
the native wave preview persists. A stale F/G request or deselection still clears.

## Native equipped item clicks

The observer previously checked only the six-by-five bag grid. Add read-only
primary/offhand rectangles flanking the bottom center of the native equipment
panel, following installed inventorybar.fdf (.03125 button, .0115 bottom offset).
Use preview slot codes 100/101; BagScreen_Item67 resolves those via QuickGear_Item
and bounds-checks native bag slots. Pickup tracking uses the same safe resolver.
No actual item order/handler changes. Actual panel scaling/positions remain
unverified on the client; this is an additional aim-observation candidate.

## Appearance

- Track the armed wave ability. For A08X (Depths) and A0Q2 (Wateraga), replace
  only the 17 center markers with 96-unit glyphs, up from48. Other water glyphs
  and boundary/caps remain48. Other water spells retain their existing center.
- Ice keeps the accepted three 96-unit projectile paths. Add64 dimmer 48-unit
  markers around the outer main-wave damage envelope. Precompute ray/circle
  intersections with all fifteen authored pulse circles (r200, centers200..1000,
  angles -11.25/+11.25/+33.75). Each nonzero sampled marker lies on an actual
  main pulse boundary; radius never exceeds1200. The boundary shows the wider
  area surrounding and between projectile paths without oversized filled disks.
  Random shards and terrain interruptions are not predicted. No damage changes.
- Extra images are allocated in fixed shared initialization order and destroyed
  during the shared existing reset, hidden during clear. Local draw only moves
  or shows existing images; no handles/gameplay are allocated locally.

Five focused tests pass: empty-loadout native preview persistence/stale F/G
cancellation, exact sampled ice boundary geometry, selective water-center size,
safe equipped/bag item reads, packaged preservation/lifecycle/local callback
audit. Both maps pass playable/editor compilation, startup/source/globals,
content references, save compatibility, archive readback and unrelated-resource
byte identity. Confirmed chat/physical-key recovery, casting receiver, icon
refresh, native mouse dispatch, warning/cursor, combat and object data remain
unchanged. Only TEquip changes from UI66/Hotfix14. Master/prior maps retained.

Client acceptance still required for native item click detection and appearance.
The corrected dock-cancellation path is proven in the regression, but do not
claim all intermittent native event/geometry issues are solved without play.

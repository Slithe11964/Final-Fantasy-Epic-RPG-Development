# UI68 / native Hotfix16

Owner likes UI67 layout; remaining native clicks can show runes briefly then
lose them. Right-click and retry works on the second attempt. Preserve artwork,
sizes, ice envelope, native inventory ownership and confirmed F/G/chat recovery.

Remaining concrete cancellation paths:

- With QuickGearPending<0 (native item aiming), QuickGear_Mouse cleared waves
  on any left mouse-down with nonzero world coordinates after .08 seconds.
  Delayed UI input / stale coordinates could cancel a newly armed preview.
- QuickGear_RecordSpell cleared every preview on ANY spell-effect event from
  the player's hero, irrespective of the armed ability. Unrelated triggered
  effects could therefore dismiss native aim.
- BagScreen_Click66 treated a right-click over an item as pickup even while
  targeting was active. Native right-click first cancels targeting; marking
  BagMoving true caused the next left click to be treated as placement.

Changes:

1. Native-mode left clicks no longer clear the wave based on coordinates/time.
   Scripted F/G target confirmation still sends and clears exactly as before.
   Right-click and Escape remain cancellation controls; focus/cinematic/
   selection/load guards remain.
2. Shared spell observer also listens to SPELL_CHANNEL. Active native wave
   preview clears only when that exact GearWaveCast67 starts/channel/effect,
   rather than on unrelated hero effects. Actual-spell diagnostic still updates
   only on SPELL_EFFECT. No new local handles/orders/gameplay mutations.
   While native targeting remains queued and the hero walks into range, the
   indicator can remain until the spell starts. Other incidental spell effects
   deliberately do not dismiss it.
3. Snapshot wasAiming before right-click cleanup. When true, reset pickup/source
   state rather than inventing a pickup; otherwise retain normal pickup/place
   observation. Native item handling itself is untouched.
4. -gearcheck adds last wave clear source + armed spell ID. Selected cancellation
   points record chat/cinematic/focus/selection flags if present. Logs change
   only while a wave is active, so opening chat after a failed preview should
   not overwrite its last cancellation. If still failing, use this evidence
   instead of another speculative timer increase.

Four focused regressions pass: late native left click retention and unchanged
F/G send; unrelated hero effect retention and matching spell-channel cleanup;
right cancel followed by first-click re-arm with normal pickup/place preserved;
accepted visual/combat/chat/object preservation and transitive local UI safety.
Both maps pass playable/editor compilation, source/globals/startup, content,
save compatibility, archive readback and unrelated-resource byte checks.

Only TEquip changes from UI67/Hotfix15. Visuals/warning/cursor and spell damage
are unchanged. Uninstalled first-pass maps are preserved under
build/candidates/Preview68-pass1; delivered candidates include right-click fix.
Original master and previous test maps remain. Actual intermittent client
behavior still needs acceptance; these regressions do not prove it exhausted
all possible cancellation sources.

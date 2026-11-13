# UI64 / native Hotfix12 candidate

2026-10-29 owner confirms UI63 wave backpack casting/paths work, but all three
wave items lose tooltips, cannot be right-click picked/equipped/moved, and block
placement of other items into their slots. Alt-tab can change which panel is
on top: native interactions return but rune preview disappears. This is NOT
full acceptance of UI63. Owner's controls: right click pickup, then left OR
right click destination. No intended inventory-control change.

Owner also confirms -clear still blocks F/G; alt-tab sometimes requires two
tries to restore it. Exact native versus latched-chat cause is not proven.

Changes:

- Remove all proxy CONTROL_CLICK and bag sync registrations from initialization;
  proxy click/receiver/poll functions are now empty. Never replace native item
  handlers or mutate items. Existing F/G request/receiver/icons are unchanged.
- Owned SIMPLEBUTTON detectors are disabled and use owned empty SIMPLEFRAME
  tooltip visibility as the hover signal. Hide the hovered detector, all
  detectors while either mouse button is held, and during tracked pickup/drop.
  Native controls own casting, pickup, placement and normal tooltips. Passive
  left-click observation arms only GearWave visuals; no pending proxy cast.
- This differs from UI62's failed normal BUTTON mouse-enter detector:
  SIMPLEBUTTON does not support those enter/leave events. The reference author
  documents empty SIMPLEFRAME tooltips as the supported hover observation.
  https://www.hiveworkshop.com/threads/ui-frameevents-and-frametypes.318309/
  https://www.hiveworkshop.com/threads/ui-frames-and-tooltips.316665/
- Chat recovery no longer waits for BlzIsKeyPressed(Return) to become false.
  That dependency can leave the recovery pending if key release is lost. It
  clears edit focus/latch once after .1s, using NativeCDClock. -clear explicitly
  calls the local reset helper after clearing messages, independent of generic
  chat-event ordering. No claim that a missed release was observed live.
- Add physical F/G rising-edge fallback to the existing .05s UI poll. Shares
  .25s last-press gate with native events to prevent duplicates. Polls releases
  even during chat, so a held typed letter cannot cast on chat close. Respects
  travel, cinematic, focus and modifier guards. All actual casts still go
  through the original synchronized receiver.
- Warning lower: Y .14 instead of .22; accepted font/color/art preserved.

Validation: four tests cover physical-key fallback/deduplication, held chat
letters, recovery even with Return reported stuck, explicit Clear reset hook,
no proxy registrations, passive local callback safety, unchanged F/G handlers,
objects and cursor. Both finished maps pass playable/editor compilation,
source/startup/global wiring, content references, save compatibility and archive
readback/unrelated-resource checks. Installed copies are hash verified.

Unverified in actual client: disabled SimpleButton tooltip hover tracking,
mouse pass-through, native pickup/drop/tooltips, passive wave appearance and
-clear recovery. Mixed prior report demonstrates that passing mocks is not
native proof. Do not call these confirmed fixes or guarantee multiplayer
crash safety. Existing cinematic candidate is unchanged.

Build note: preserved failed compiler outputs under build/candidates/Input64-
pass1/pass2. Initial helper placement required correction. A later parser stack
failure occurred in accumulated blank lines; collapse blank runs in playable
runtime only. This is whitespace normalization, not a gameplay change.

# Backpack isolation follow-up, November 9, 2026

Owner confirms native Check02 cross-closes even after both players use `-bare`.
The clean map contains no RPG/custom-frame/F-G/polling/save runtime. No safe,
verified native-preserving solution has been found. Do not call the new tests
confirmed fixes or assume their success from compilation or mocked tests.

Owner authorized a replacement panel if it retains the current appearance,
while still preferring a native solution. Two **standalone** tests are prepared.
Production Recovery14 and full development V25 remain unchanged. Next full
development number remains V26; neither test is a new RPG release.

## Native Check03

`FFERPG-Inventory-Multiplayer-Check-03.w3x` starts allied with shared vision off.
The native UI, objects, inventory, items, scene commands and equipment are
unchanged from Check02. There are no custom frames, polls, synthetic keys,
saves, recurring callbacks or locally conditional gameplay mutations.

Two people open their bags, leave them open and alternate B/open/close.

- `-baseline`: original allied/shared-vision configuration.
- `-visionoff`: still allied, but no shared vision or control.
- `-isolated`: also removes passive alliance.

Any player invokes a mode for everyone through a synchronized chat action.
Close and reopen both bags after changing modes. Test whether interference
depends on alliance/vision settings. This hypothesis is **unproven**; it is not
a recommendation to remove shared vision from the RPG.

## Independent Backpack04

`FFERPG-Independent-Backpack-04.w3x` bypasses the native global open controller.
It retains the actual native item storage, bag capacity and equipment system.
One regular-frame tree is constructed on every client at shared startup.
Opening and closing changes only that viewer's precreated frames and sends no
sync message. Remote frame/key events are rejected before touching local state.

The layout uses the native equipment positions, six columns/five bag rows,
native EscMenuBackdrop border/background, X/Talents/Move to hero buttons, and
a Footman portrait sprite for the diagnostic tester. There is an additional
six-slot mirror beside the bag and a Drop held item control for the test.
**The portrait, pixel-level appearance and native input have not been visually
verified. Do not promise an exact visual match.** The Windows automation runtime
failed initialization (`failed to write kernel assets`, missing path), so no
native game screenshots or live single-player checks were obtained.

- B or the backpack icon opens; X/ESC closes.
- Right-click an item, then left- or right-click a destination to request a move.
- Drop held item requests a ground drop.
- `-scene` hides/access-disables the panel and restores each viewer's previous
  open state afterward.
- No save codes, RPG talents, item casting, F/G, cooldown UI or rune previews are
  included. The Talents control explains this limitation.

Item snapshots (IDs, icons, tooltip text and charges) are captured on shared
startup and inventory events, not on a poll or local hover. Local UI handlers
read only the published cache. Actual moves/equips/drops are sent separately;
the shared receiver validates sender ownership, current source slot/identity,
destination bounds, life and scene state before calling native item operations.
There is no item deletion/recreation, local item mutation, new repeating timer,
or native pane reopening. Never describe this as server execution: Warcraft is
lockstep and these operations execute identically on all clients.

Native `UnitDropItemSlot` acceptance for extended slot numbers and exact ring
placement still require in-game checks. Failed placement reports failure and
refreshes the actual state; it never deletes an item. A worn item may have been
unequipped into the native bag even if subsequent exact-slot placement fails.

Before forwarding this design to the full maps, check simultaneous bags in two
human slots, B/icon/X/ESC, hover/tooltips, drag/slot placement, equip/unequip/drop,
native portrait appearance, and scene hide/resume. Then implement/verify the
remaining RPG integrations. This prototype is not suitable as a release map.

## Checks completed

Both playable scripts and editor sources compile; startup/source/global/text
checks pass. Object/item/ability/map-configuration payloads are identical to
Check02. Independent04 adds one-time frames and event callbacks but no repeating
work. Five executable tests cover independent two-client view state, remote
input rejection, stale/foreign/out-of-range/cinematic sync rejection, valid
own-item drop routing, and separation of local UI handlers from native item
getters/mutators. These tests do not simulate native UI or prove network safety.

Builders: `tools/build_native_inventory_check03.py`,
`tools/build_inventory_panel04.py`; source:
`experiments/InventoryPanel04/Panel.j`. Installation and hashes are recorded in
`release/development/InventoryPanel04/installed.json`.

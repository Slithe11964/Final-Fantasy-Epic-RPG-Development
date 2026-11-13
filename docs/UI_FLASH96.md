# Inventory UI flashing — updated g and QuickUI96

Owner reports Talents, Move to hero, X and F/G flashing in g, particularly while
right-clicking move/attack. Move to hero can appear absent in a player recording.
Owner explicitly wants its existing backpack position retained.

The equipment trigger subscribes to pickup/drop/equip/unequip **and all three
order events**, because it also handles item-transfer orders. The inventory94
crash patch inserted Inventory94_Changed(holder) before distinguishing the event.
Consequently every movement/attack order started a 0.2-second quiet window and
hid custom frames/reset targeting. Repeated right-clicks continually restarted it.

Three TEquip functions change, with no objects, spell math or new timers:

- Forsaken_OnEquip: call Inventory94_Changed only for the four item events and
  targeted item-slot move orders 852002–852007 with an actual item target. Ordinary
  move, attack, smart, stop and item-use orders keep the original item-transfer
  bookkeeping without invoking the UI shutdown.
- Inventory94_ClearLocal: use CarryUI_Close when closing its panel, so CarryUIOpen
  becomes false as well. Avoid a hidden panel with a stale open flag that makes
  the next button click close it again.
- CarryUI_Init: set the existing access button's frame level to 60 so the native
  inventory backdrop does not cover it. Its size, parent and **all coordinates,
  anchors and offsets are unchanged**. CarryUI_ShowAccess is byte-for-byte the
  same function as before; Move to hero remains inside the backpack.

Cinematic shutdown/resume, real gear-change safety, working F/G casting,
icon refresh, cooldown handling and carry-transfer behavior remain intact.
QuickUI96 is based on QuickUI95 and retains all Central Islands/Dragoon changes.
Modern production g retains its existing Lancer/older Thief and 7% house auras.

The accompanying 1.29.2 g is byte-identical to the current checked classic g:
the classic interface has none of these custom frames/order-driven UI resets.
It already includes the 7% house HP/MP recovery and Plus/Minus release settings.
Do not transplant modern extended-inventory natives into the classic map.

Five focused tests execute 360 movement/attack/item-use order events without a
UI reset, confirm actual slot moves still notify, compare exact unchanged
positioning and casting/cinematic functions, and verify only these three functions
change with identical objects/assets and timer counts. Both modern maps and classic
map pass playable/editor/source/startup checks. Save/content checks pass.
Native recording reproduction and player acceptance remain pending.

Build: tools/build_ui96.py; transformer: tools/ui_flash96.py;
tests: tools/tests/test_ui96.py; logs: build/ui96-*.log.
Prior g files and TEST copies are preserved under
release/0.9.7.5g/history/2026-11-04-before-ui96. Current g pair is also dated under
release/0.9.7.5g/2026-11-04-ui96. No update to editor master or Creature Review 03d.

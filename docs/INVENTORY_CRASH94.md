# Inventory/cinematic crash candidate — 2026-11-04

Requested outputs: modern production 0.9.7.5f (retained Lancer/old Thief) and
QuickUI94 from QuickUI93. Classic 1.29.2 and editor master are unchanged.

## Evidence and limits

Both named reports under Documents/Warcraft III/Errors (`Demi Fiend Crash` and
`Equipment Crash`) identify Warcraft III 3.0.1 build 24371 and the exact public
0.9.7.5f map. Report SHA1 `e24c6402dbd37b022f29baac2de2372073f87057` matches
the pre-fix production file. Both native stacks begin at offsets 0x2c5ed4,
0x2c680b, 0x2e4922; both fail reading 0xFFFFFFFFFFFFFFFF. There are no script
symbols in the reports. Identical stacks support investigating common native UI
paths, but do not prove which script call caused the crash. Filtered evidence:
`build/inventory94-crash-evidence.json`. Reports and dump files were not modified.

Owner reproduction: castable equipment when starting Demi Fiend; Nirvana pickup
followed by hovering Sprint Boots. Noncastable gear reportedly avoids the former.
These scenarios have not yet been reproduced and validated in the native game.

## Changes

- Shared cinematic flags are set before unit pausing, selection clearing, or
  hiding the interface. Cancel targeting and clear pending shortcuts, previews,
  hover/drag references, custom bag/stat/inspection UI and custom attack tooltip.
- Suspend UI polling/input, synchronous inventory maintenance/reconciliation,
  equipment snapshots, Chronicle checks, periodic passive stat refresh, pending
  status refresh, shield readouts, and load application during the cinematic.
  Deferred bag/drop callbacks perform cleanup without mutating inventory then.
- After the normal interface and hero selection return, release suspension,
  refresh inventory/Chronicles, restart the existing passive/status refresh
  timers, and allow UI rebind after a short settling window. No new polling
  timer. Hold-key state is sampled so exiting a cinematic does not cast F/G.
  Active save/load deadlines exclude cinematic time.
- Replace all item-ability index enumeration with a bounded catalogue from the
  map's effective item definitions, with installed stock-item inheritance.
  Preserve ability removal/restoration and pooled cooldown behavior. Guard
  native equipment-type reads and inventory access against null/retired handles.
- Replace native per-item icon and extended-tooltip lookup with cached object
  data. Fill eight missing inherited-icon entries, including Nirvana and its
  carry aliases. Prepare passives on newly created stored copies before adding
  those copies to native inventory; detach rebound bag items before stripping
  passives. Restore snapshots only if they match the current item type.
- Keep shared gameplay suspension independent of local UI focus/quiet-window
  state. The local shutdown performs no item/unit mutation, handle allocation,
  trigger destruction, or sync transmission. Gameplay inventory changes remain
  synchronized; other players do not share a local bag-visibility flag.

Demi Fiend's actual intro, dialogue, combat, rewards and cinematic remain intact.
Object data, monster updates, spell math, items, arena teams and assets are
byte-identical to each branch's base. This is native crash hardening, not a
claim of a confirmed root cause or guaranteed multiplayer stability.

## New Game Plus / Minus

The inventory setup previously replaced **both** New Game Plus and Minus actions
with Forsaken_SaveUnavailable. It now leaves Plus's original action intact.
Original eligibility, maximum cycle, and Save_WriteNewGameCode are unchanged.
That writer creates the existing fresh-start code: reset job levels, inventories,
house/proficiency upgrades, and other reset progression according to its existing
rules, retaining only what the established New Game Plus rules allow. The player
loads that code to start the next cycle; this is not an immediate live-world reset.
Normal save serializers and fixed G/H fixtures remain unchanged.

Minus remains blocked. Remove its Lucifer's General announcement/enable action,
the bonus-text claim, and all 16 Chronicle description claims. Keep the title's
stat reward and Dark Knight/Necromancer unlock lines intact.

## Verification and delivery

16 focused regression tests pass on both branches: native guards, null holders,
catalogue/icon coverage, ordering, paused callbacks, owner isolation, shared/local
separation, restoration checks, unchanged serializers/resources, save/load deadline
adjustment, Plus wiring and Minus announcement removal. Both playable and editor
scripts compile; startup/source/global pairing and native save text checks pass.
Existing save/content contract checks also pass (358 items, 22 jobs, fixed G/H
fixtures). Archive readback and unchanged-resource comparison pass for both maps.

Build: `tools/build_inventory94.py`; transformer: `tools/inventory_crash94.py`;
tests: `tools/tests/test_inventory94.py`; packaging: `tools/package_inventory94.py`.
Logs: `build/inventory94-*.log`; candidate manifests beside each map.

Production prior files preserved in
`release/0.9.7.5f/history/2026-11-04-before-inventory94`; current production and
dated 2026-11-04 copies are byte-identical to checked modern Hotfix10. TEST receives
unique FFERPG-0.9.7.5f-Hotfix10.w3x and FFERPG-QuickUI94.w3x. Never overwrite older
TEST maps, classic map, master, or creature review. Build candidates before each
refinement are retained under build/candidates/inventory94-*.

Acceptance still needed: load castable staff/book, open bag/preview then start and
finish Demi Fiend; confirm F/G and stats resume. Pick up Nirvana and repeatedly
hover Sprint Boots/other gear. Test with another player. Check eligible
-newgameplus produces and loads its fresh-start code with expected resets.

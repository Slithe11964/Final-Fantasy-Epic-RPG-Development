# UI54: F/G icons only

2026-10-28. Owner confirms UI53 F/G casting works, including a freshly loaded
character. Keep this behavior locked. Remaining priority is stale icon art when
equipping different gear: Book of Tremors casts correctly with indicators and
cooldown but still displays Book of Depths until job change.

Built directly from the checked UI53 map, not the older development chain.
Only three existing functions change: QuickGear_Draw delegates texture painting;
QuickGear_Init initializes the icon lookup; QuickGear_Poll independently checks
the two equipped textures every tick, outside the cached panel redraw condition.
The new helpers use this map's explicit object icon paths (including f/g aliases)
and cache the last painted item/path/owned texture handle. Unauthored inherited
stock icons retain native fallback. Only texture setters run on the local UI;
no item edits/movement, new timers, native frame discovery or input changes.
Lookup initialization runs in bounded batches of 32 SaveStr calls.

All other existing runtime functions are token-identical to UI53. All other
modules, object data, imports and unrelated named resources are byte-identical.
F/G key/mouse/sync/receiver, loaded-state fix, cooldowns, rune renderers and
gameplay are unchanged. Master's file and UI53 output remain untouched.

Four focused regressions pass: swap both slots with intentionally stale native
art while panel redraw is blocked, retain cooldown/pending state, same-handle
art changes/owned texture recreation/idle no-op, inherited fallback/empty-slot
cache, and packaged scope/book icon/resource invariants. Full map/editor source,
startup/global/native-text checks and save compatibility pass. Icon behavior
still needs Warcraft acceptance; no in-game test was performed this turn.

Next client check: load UI54, change between Depths and Tremors without changing
jobs, then swap the primary weapon; verify each icon updates and F/G still cast.
Owner explicitly deferred backpack-click indicators until icons are confirmed.
Do not reintroduce native inventory-button hooks in this test. Use UI54 as the
base for that later task, preserving the confirmed UI53 cast/input functions.
For a later normal paired build, apply gear_icons54.refresh using the actual
merged native item object definitions; this focused builder does so from UI53.

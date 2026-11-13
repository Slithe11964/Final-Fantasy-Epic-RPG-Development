# Update: dated f rollback authorized and completed

2026-11-08: Owner explicitly requested rollback of all inventory/loading/saving changes to the exact October 30 10:16 f. Completed Recovery05 modern/classic, V16 and CreatureReview03o; distinct files installed in TEST. Production restored whole dated f inventory/profile libraries; dev uses corresponding UI74 inventory controls with authored balance/stat readouts retained. All later Inventory94/FFL94/idle/six-slot helpers and autosave worker removed. Later 20/10/default-on autosave repairs deliberately rolled back. Existing save formats compatible. All four map/editor checks and three full-map save checks PASS; source identity/removal/archive/content checks PASS. Exact dated f TEST file untouched, SHA da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93. f and candidates NOT yet confirmed multiplayer-stable; no root-cause claim. See docs/F1030_INVENTORY_ROLLBACK.md and GRecovery05/installed.json. Current full development V16, next V17. Older hold and recommendations below are historical and superseded by this authorized rollback.

The hold below records the preceding state; it is not the current instruction.

# Multiplayer investigation on hold for pre-UI96 control test

2026-11-08. STOP recommending any current map as multiplayer-stable. Owner now reproduced a network desync in the exact originalg previously considered stable: SHA9ca78509bad9e88a436a8871a407567dd1b813bd40f6fdacf5428c87ab089844. Report14:41:05, turn1535,7players, TEST/TESTER/FFERPG-0.9.7.5g.w3x, after entering a character load. This is a network desync, not a recorded ACCESS_VIOLATION. Historical identity is confirmed; stability is disproven for this session.

Earlier same-day14:33:37/38 reports are Recovery04, same game,7players,turns5481/5544. Owner says no character load, people bought Sprint Shoes; owner's backpack/talents were closed, other players' state unknown. Two different paths reproduce failures. Originalg failure means recent recovery edits are not a necessary condition; it does not prove they are harmless or that Warcraft alone is responsible.

Source audit confirms Sprint Shoes raw I00E/f003/q003 and move abilityA0MU match originalg exactly. Generic pickup/conversion handlers and passive suspension are also common. These are investigation leads, not a proven root cause. Readonly audit data sprint-shoes-audit.json; its earlier fallback recommendation is superseded here.

No new production code candidate issued after Recovery04 failure. No fallback map installed or promoted after originalg also failed. The workspace exactg copy is a historical analysis artifact, NOT a known-safe map. Existing V15 and CreatureReview03n retained; all pending feature requests/content preserved. Do not create V16 merely to relabel an unverified rollback.

Latest owner action: going back to BEFORE UI96 to see if it behaves better. Hold changes while this control test runs. Pin the exact file/hash used before comparing; user may have a different local copy. Workspace backup release/0.9.7.5g/history/2026-11-04-before-ui96/FFERPG-0.9.7.5g.w3x is a candidate reference, NOT yet owner-confirmed identical to the test file. No multiplayer test result for preUI96 yet.

# UI45 Thief follow-up (2026-10-26)

Thief Shrine of Battle ability list now says1000 Cuts instead of Thievery. Resolved Thief job description confirmed in final map strings (3368).

Existing scripted20 MP/second upkeep is retained, now timed by its own CutsClock started in Cuts_Init rather than the shared item cooldown clock. Activation remains free, ripping300 MP, with prior ranked damage/cooldown behavior preserved. Existing tests cover20/second, catch-up, stop on rip and insufficient mana cleanup. This removes the shared clock dependency; the reported native-game drain failure has not yet been reproduced in-engine.

A presentation-only toggle sprite anchors native command5 (middle row, second column) and shows only for the selected hero while CutsActive, not CutsRipping. It clears on rip, exhaustion, death or hero replacement. Separate sprite from Rise, so each follows its own active hero/state. Shared UI handle allocation; local visibility only.

Build tools/build_thief_ui45.py composes current Dragoon and thousand_cuts refreshes from confirmed UI40. Prior maps preserved.13 Cuts tests and20 integration/UI tests pass; final playable/editor/startup/save-text checks pass. Native gameplay acceptance pending.

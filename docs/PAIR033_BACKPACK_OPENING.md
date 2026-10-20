# PAIR033 backpack opening

The user reports that both B and mouse opening still disappear in PAIR032, with
alt-tab temporarily allowing the panels to remain visible. Once visible, the
layout, linked panes and Talents preference behave as requested. This patch
changes native opening/input only, retaining that layout and item behavior.

## Input and binding

The native ASpc hotkey and custom B handler previously both controlled inventory.
The mouse handler also depended on notifications from an origin command button.
PAIR033 clears only the native ASpc hotkey in Forsaken ability data and places a
transparent owned button over the existing Backpack command. The icon/layout is
retained. Mouse input and B now request the same explicit open/close transition;
scripted native clicks cannot generate a second owned-button event. The overlay
clears keyboard focus after use and hides when another unit/inspection owns the
card. Frames and triggers are created at shared startup and cleaned on rebuild.

Every explicit open invalidates the cached binding, including the same hero after
closing. Hiding frames does not prove the engine inventory is internally closed.
The binding pass hides stale presentation, dispatches one native command, then
waits for the engine to expose a panel before binding the hero and restoring the
linked pair. If the engine was internally open, the first command can close it;
one bounded retry opens it. Each attempt waits up to one second, avoiding repeated
in-flight commands. Exhausted attempts show a retry message, clear open intent,
and stop. The next press retries directly. No stale visible pane is accepted as
proof that the current hero was bound. A close cancels an in-flight open and
suppresses a late native result. Once bound, existing drop/use/link restoration
and Talents preference are retained.

`-bagdebug` displays only the requester's current intent, binding phase, bound
hero match, selection, panel visibility, and command/input availability. It is
read-only and provides evidence if the engine still behaves differently from the
modeled paths. Its trigger joins the existing fresh-load guard.

## Verification

The old UI mocks inferred engine open state from frame visibility. Replacement
regressions explicitly model independent engine state and delayed native command
completion. They cover repeated reopen after scripted hiding, cached same-hero
binding, delayed opens, bounded retry, late completion after close, job preview,
drop/use, linked panes, selection/inspection, held keys, explicit closing, remote
input isolation, armory refresh, overlay lifetime, native-only hotkey data,
read-only diagnostics and transform idempotence.

Focused tests, full paired regression/compiler/editor/startup/content/save/
armory/bazaar checks, classic conversion, final archive verification and
hash-verified TEST installation passed. Final classic runtime is token-identical
to PAIR032; the editor master and existing calculation/gear/save data are retained.
Engine acceptance remains necessary: fresh game and
-loadf, mouse/B open/close repeatedly without alt-tab, then window switching,
held B, drop/use, hero/Gaya selection, job changes, armory withdrawal and two
players independently opening/closing. Reopening may briefly wait for native
state reconciliation. If opening still fails, capture -bagdebug output directly
after the attempt. Classic inventory and save/combat behavior are unchanged.

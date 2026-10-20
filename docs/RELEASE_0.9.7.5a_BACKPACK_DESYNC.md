# 0.9.7.5a: multiplayer Backpack desync correction

## Evidence

The local report at Errors/2026-10-20 19.27.36 65f237b0/Desync.txt identifies a
network desync at turn 11692 on Warcraft 3.0.1.24371. The user reports opening
Backpack after importing a character in a lobby with four other people; others
also disconnected or crashed. Their renamed TEST/FFERPG-0.9.7.5.w3x has SHA256
dd1106f46352cc9fbf55794783848ff65e3529eb03eebb125fc9fad31d16b4f3, exactly the
validated 0.9.7.5 native release. This identifies the tested code despite the
changed filename. The report has no JASS instruction trace or other clients'
state dumps; it does not prove a unique originating instruction.

The local Backpack path recursively called BlzFrameGetChild to locate native
close buttons only when that player opened their UI. Its panel lookup could
also expose native frame handles on demand. Native UI frame getters can reserve
JASS handle IDs, so first exposure on just one client is unsafe. The author of
the [UI frame tutorial](https://www.hiveworkshop.com/threads/the-big-ui-frame-tutorial.335296/)
documents this under “Frames and HandleId.” The prior tests mocked visibility
but did not model or reject this allocation side effect.

The binding timer also simulated clicks on a native command-card cell. A cell
can belong to a different command when the card changes, so the hotfix removes
that automation instead of assuming it is a presentation-only operation.

## Correction

- Reserve the three known native inventory panel families during shared delayed
  UI startup. Enumerate the same 256 contexts for each family on every client,
  without visibility-based early exits. Store all non-null candidates in shared
  frame-handle caches. Local presentation selects visible candidates from that
  cache and otherwise retains its previous panel; it never queries a new handle.
- Remove the recursive native-child search and its secondary close-button hook.
  The existing gear-header X closes both linked panes; B and Escape remain.
- Remove synthetic command-card clicks and automatic binding retries. Real
  mouse/hotkey input binds the engine preview. The script observes the result;
  if no opening arrives, it requests a real user retry. Reopening a confirmed
  same-hero binding remains a local presentation toggle.
- Cache the Attack command frame at shared startup for the Holy Bolts tooltip.
- Retain linked panes, explicit close persistence, job-specific engine binding,
  Move to hero and the Talents preference. No units, items, player progression,
  portable save data or save-code formats are changed by the UI correction.

## Regression protection

test_backpack_sync.py checks fixed shared discovery order despite different local
visibility, one-client-only open/close without frame registration or commands,
and absence of hierarchy walks/command clicks in binding and close controls.
Its native-profile check traverses local UI entry points across all source
modules and rejects frame discovery/allocation, command activation, several
gameplay mutations and gameplay scratch writes anywhere in the reachable graph.
This runs in paired native builds, alongside the existing open/close/selection/
drop/use tests and supported-native API removal checks.

## Build and installation

Internal stage V0975A passes all paired gates: native 266 tests (2 expected
skips), classic 366 tests (13 expected skips), compiler/editor/source/startup,
save compatibility, content, Armory, Bazaar and legacy conversion. The final
native map also passes the supported-API check with retired declarations removed.
Its reachable local UI graph passes the safety audit; every compiled Backpack
helper matches the corrected source. Both edited Intro/Reminder messages match
the unchanged master (SHA256 f7108fa827f36f0c73773308b0d464c468c14a2ff3b58b5afde25f492e4a4e7e).

Final content comparison against 0.9.7.5 finds native playable/editor script
changes and an ordering-only difference in war3mapSkin.w3a; every object and
field value is identical. Classic MPQ content is byte-identical. Naming changes
only the map-list headers. No gameplay/object/progression/save-format change was
introduced by this hotfix.

Installed and hash-verified in Maps/Download/TEST:

- FFERPG-0.9.7.5a-Forsaken.w3x — cee85ff86ba81ad97939933fa74ea449731ccc0b0ef50a9729126e3d98b6118f
- FFERPG-0.9.7.5a-1.29.2.w3x — 95d023297dac4dcfe3b57b7ab35ec70312b37de6abba5bd07b2d1b5d19878daa

Release files and provenance are in release/0.9.7.5a/release-report.json. Additional
audits: build/V0975A-final-audit.json, V0975A-content-audit.json and
V0975A-TEST-install.json. No Warcraft gameplay or real multiplayer session was
executed during this fix.

Compilation and mocked multi-client tests cannot reproduce Warcraft's network
engine. Required acceptance is a real multiplayer lobby: import multiple
profiles; have only one player open first; have a different player open next;
repeat B/mouse/X/Escape, item use/drop, job change, Move to hero, and Talents.
Verify other players remain connected and their UI stays independent. Also
verify initial native binding and legitimate spell channels. The original
0.9.7.5 files remain intact so this hotfix can be compared separately.

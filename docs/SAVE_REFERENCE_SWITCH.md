# Reversible hero references — isolated checkpoint, 2026-10-09

Forsaken-save-references.j adds a reversible reference switch to the owned-unit
staging experiment. It has no map entry route or successful-load commit.

The journal captures 26 positions: 22 cached jobs, the cached Freelancer, the
Freelancer global, Gaya and the active hero. It preserves typed handle presence,
including absent cache entries. Other hashtable types and other players remain
unchanged. Present handles that cannot be represented as units are rejected.

Planning accepts only units owned by the replacement staging batch and assigns
them to their recorded roles. Freelancer updates both references. An active
alias follows its replacement; a job or Freelancer can also be explicitly made
active. Gaya cannot be selected as the active hero through this API.

States are idle, planning, switched, blocked and reversed. Apply locks the
recovery journals, blocks new staging and codec publication, writes 23 table
entries and three globals, then reads them back. Failed writes retain recovery
state. Original heroes are never deleted or modified by this module. Targets
remain neutral, hidden, paused, invulnerable and empty; this is not activation.

Reverse restores original references and typed presence before original-state
recovery and replacement cleanup. Changed table identity, original raw type or
owner, and third-party references prevent recovery from overwriting unknown
state. A failed reverse can be retried. Replacement cleanup refuses heroes still
published through live references. Release requires verified reversal, completed
replacement cleanup and the original item journal's verification, then clears
only this module's guards. Cancelling a plan uses the same recovery path.

Validation: 15 new tests and all 249 earlier save-system checks PASS (264 total).
Tests cover all 23 table-write fault positions in both directions and all three
global assignment faults in both directions (52 cases), reentrancy, aliases,
typed absence, foreign changes, independent guards and player 7/index 207.
Standalone, BT runtime and BT editor compilation PASS; retained report:
build/save-codec-compile-2seobnrz/report.json. Compile with check_save_jass.py
--references and the BT map/native libraries as documented in
[FORSAKEN_REAPPLICATION.md](FORSAKEN_REAPPLICATION.md).

Still open: successful-load ownership/activation and commit, body/combat state,
derived effects, staged progression, synchronized gameplay-hook exclusion,
native operation limits/scheduling and interrupted-controller recovery. A
prepared-state controller must explicitly permit item placement and progression
while reference guards are active. File output, restart and multiplayer
acceptance remain open. Cooldown refresh remains permitted.

BT and private BU are unchanged; BV is unused. BU remains the inventory/codec
diagnostic described in [SAVE_ENGINE_TEST.md](SAVE_ENGINE_TEST.md). Full new
character saving/loading remains blocked.

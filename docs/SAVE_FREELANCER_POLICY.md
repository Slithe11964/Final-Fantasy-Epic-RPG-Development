# Saved Freelancer preparation

2026-10-09, isolated H02L checkpoint; no map build or gameplay load route.

The accepted hero policy now resolves Freelancer level, mastery marker and base
attributes for the staged Strength variant H02L. Level0 materializes as1; saved100
retains enhanced mastery4 with native target99. The current BT object data explicitly
sets MaxHeroLevel99. Native XP and exact level still require engine readback;
future caps must use the separately reviewed level/mastery schema.

The detached attribute calculation matches the existing Freelancer stat routine:
base10 each; own mastery bonus20/50/100 at saved50+/99/100; existing inherited
bonuses from reviewed jobs whose saved levels are99+, then H02L Strength receives
native level+39 and the other attributes receive integer half-level. Permanent
job IDs resolve to frozen legacy indexes0–21; unknown future jobs grant nothing.
The existing inheritance threshold99 is retained independently of the user's
normal-job skill mastery at50. No new bonus threshold is introduced.

The policy emits four zero borrowed-choice targets. They remain per-game and
must be applied by the future session controller, with original choices recovered
on a failed load. Forsaken-save-freelancer-policy.j does not change those global
choices. It accepts only owned staged role22/rawH02L, requires native Versatility
at rank1, and rejects any of the110 reviewed job skills already on the fresh unit
before recording the core/mastery plan. Missing skill-table IDs, wrong roles,
invalid levels/points/stats and repeated plans refuse without partial planning.
The caller supplies reviewed XP/points and derived H02L attributes; FHP_Apply
verifies the absolute owned core and mastery writes. No normal-job skill menu or
borrowed choices are guessed or automatically maxed by this bridge.

H02M–H02Q variants, additional ability-set projections, combat/group effects,
player session target application, equipment/controller/commit and engine
acceptance remain open. The current allocation module stages H02L only, so this
checkpoint does not claim other variants are supported. Original heroes and
choices remain protected by the existing journals. Cooldown refresh is permitted.

Evidence: eight new checks and61 focused Gaya/normal-job/migration/format/registry
regressions PASS (69 unique checks this checkpoint). A mock executes the actual
canonical Freelancer stat routine for160 level/job vectors, including each
individual inherited job and mixed sets, and agrees with the detached calculation.
The test supplies missing engine loop globals and expands JASS one-byte 'd' to
integer100; it does not replace the stat algorithm. Native mocks test milestones,
alias publication, exact core/rank readback, fresh-choice rejection, player7 and
plan disposal. BT H02L ability bindings and the level99 map constant also pass.
Standalone/BT runtime/editor compile PASS:
build/save-codec-compile-932yb14c/report.json. These are mocks/object/compile checks,
not engine or transport acceptance. The entire older suite was not rerun for this
additive bridge. BT/BU unchanged; BV unused; full saves remain blocked.

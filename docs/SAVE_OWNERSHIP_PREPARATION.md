# Contained replacement ownership — isolated checkpoint

2026-10-09. Forsaken-save-ownership.j adds reversible player ownership for the
staged active hero (job or Freelancer) and staged Gaya. This prepares later
player-specific progression and abilities; it does not activate a playable hero.
All targets remain hidden, paused, invulnerable and empty. Originals are untouched.

## Preparation

FSO_Begin requires published replacement references (FSR state 2), a living-body
journal in captured state, an open owned-unit batch and an idle writer. It audits
the whole batch for living hero identity, exact rawcode, neutral ownership,
containment and empty native inventories. Both active hero and Gaya must be
distinct tracked replacements with the correct roles. A job or Freelancer may
be active; Gaya cannot. Missing/foreign/uncontained targets refuse read-only
capture and partial references are cleared.

The journal retains the two owned handles, rawcodes, staging indexes and batch
count. States: idle, captured, assigned, blocked and neutralized. Its independent
guards block new staging, placement, public codec operations, reference reversal
and owned-unit deletion until verified release. This also covers cancellation
before assignment; guards are established on successful capture.

FSO_Assign writes SetUnitOwner for the pair to Player(pid), then verifies actual
owners and containment. There is no arbitrary player or unit argument. Dormant
jobs are not assigned. The color-change parameter is false; team-color and
visual preparation remain separate. A rejected assignment leaves the journal
blocked. Locks exclude reentrant public journal operations during setters.

## Failure recovery order

FSO_Neutralize requires unchanged original/published reference context, owned
target identity, living targets and empty inventories. Before any setter, both
owners must be either the selected player or neutral passive. A third-party
owner, destroyed/dead target, changed reference or carried item refuses the
whole pair rather than overwriting unknown state.

Recovery hides, pauses and protects each owned replacement, returns it to neutral
ownership, then reads back all four fields. Silent setter rejection retains
blocked state for retry. FSO_Release requires verified neutralized state and
clears only ownership guards and references.

The controller must neutralize and release ownership before FSR_Reverse. It can
then clean the owned units, release the reference journal and recover original
items/progression/abilities/session/body as required by those journals. Reference
and body guards remain independent; completing ownership is not a load commit.
If replacement inventories have been populated, their separate item cleanup
must precede neutralization. This checkpoint deliberately accepts empty units.

## Validation and remaining work

13 actual-source harness tests cover the two assignment fault positions, all
eight containment/neutral-owner recovery faults, retry, whole-pair foreign-owner
refusal, invalid targets/items, missing Gaya, dormant jobs, Freelancer aliases,
reentrancy, strict recovery order, independent guards and player 7/keys 14–15.
All 281 prior save-system checks also pass (294 total).

Standalone/BT runtime/BT editor compilation passes:
build/save-codec-compile-va2hotyc/report.json. The compiler needs execution outside
the sandbox for its existing Windows DLL loading limitation. Run
test_save_ownership.py and check_save_jass.py --ownership with the documented
BT/native-library arguments in FORSAKEN_REAPPLICATION.md.

These are native mocks and compilation probes, not engine acceptance. The caller
must hold synchronized gameplay exclusion and suppress ownership/gameplay hooks.
The existing Job_GetHero/Gaya_RecreateSpirit path is not called: it can recreate
and remove original Gaya. Staged progression/ability preparation, safe spawn and
visual/pathing policy, original-unit retirement, activation, prepared-state item
placement, scheduling and full load/commit remain open. No original deletion,
usable code export, file/restart or multiplayer acceptance is provided.

BT and private BU are unchanged; BV is unused. Full new saving/loading remains
blocked. BU remains the inventory/codec diagnostic.

Following checkpoint: [SAVE_PREPARED_HEROES.md](SAVE_PREPARED_HEROES.md) prepares
owned replacement progression/ability plans while retaining containment. Its
prepared pending guard now blocks ownership neutralization until FHP_Discard
clears the target plan; ownership and reference guards continue to protect the
remaining cleanup. No visible activation or successful commit is added.

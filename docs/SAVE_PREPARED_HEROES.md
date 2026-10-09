# Owned replacement hero preparation — isolated checkpoint

2026-10-09. Forsaken-save-prepared-heroes.j prepares exact XP/level, base primary
attributes, skill points and selected ability ranks on owned replacement heroes.
It has no parser translation, gameplay route, visible activation or load commit.
Original heroes are never modified by this module.

## Target plan and containment

FHP_Begin requires assigned active/Gaya ownership, an open 2–24-unit staging
batch, idle item staging/writer and no original recovery already underway.
It records each owned handle/rawcode/owner, freezes the five live skill IDs for
each of the 22 normal jobs, and verifies the complete batch remains living,
hidden, paused, invulnerable and empty. Active/Gaya owners are Player(pid);
dormant jobs/Freelancer stay neutral. Invalid capture clears partial references.

Each staged unit needs one core plan before application: exact XP, expected
native level (1–100), base Strength/Agility/Intelligence and skill points.
Negative values, repeated core plans and incomplete batches refuse. Up to 40
additional runtime ability IDs/ranks per unit are accepted; zero IDs, duplicate
IDs, ranks outside 1–255 and overflow refuse. These are internal controller plans,
not a rawcode persistence format. The controller must resolve reviewed logical
IDs to actual objects and construct the complete load policy before using them.

## User skill policy

For normal jobs below level 50, fresh replacements retain all five native job
skills at rank zero and regain the available points (one per level, including
the starting point). Saved/per-game learned ranks and unspent points do not carry
over into a successful load. Unexpected learned job skills on these fresh units
refuse preparation rather than removing their native learning menu.

At level 50 or above, four regular job skills are learned to rank 11 and the
ultimate to rank 6. Their total cost is 50 points; remaining points are level−50.
The module uses SelectHeroSkill and verifies each one-rank increase, granting
only missing preparation points when needed. This preserves native hero learning
semantics instead of adding ordinary copies of the five job skills. Partial
learning failures retain the plan and can retry without overlearning.

Generic ability plans cannot override these five policy-controlled skills.
Skill-table identity changes or duplicate/zero policy IDs refuse. Freelancer's
borrowed choices and Gaya support abilities have separate semantics and retain
explicit target plans; their full load-policy translation remains open.
Original skill choices/points still recover on failed loads through the original
hero/session journals. Cooldown refresh remains permitted.

## Apply, verification and failure disposal

States: idle, planning, prepared, blocked. FHP_Apply requires every core plan and
the owned reference/owner/containment context. Lower levels are explicitly stripped
before SetHeroXP; both XP and level must read back exactly. It never guesses XP
or forces SetHeroLevel to hide a mismatch. Planned additional abilities may be
added only on owned replacements; actual handles/ranks must appear in readback.
Base attributes and final points are then set and verified with the skill policy.
Unplanned native defaults are retained; this is not an exhaustive ability-set
projection audit. Native addition/rank clamping or rejected progression setters
leave blocked state; an unchanged plan may retry.

Independent prepared guards block new staging/placement and public codec
operations. A pending guard prevents item-journal disposal, ownership
neutralization, reference reversal and owned-unit cleanup. Setters lock the
journals against reentrancy. FHP_Verify checks the complete prepared readback.

FHP_Discard clears only this target plan/its guards and has no native setters.
It does not approve or publish partially prepared heroes. Existing ownership and
reference guards remain: neutralize/release ownership, reverse references, clean
owned units, then recover/release originals in the established journal order.
There is no successful commit/release API for this plan yet.

## Evidence and remaining work

14 actual-source tests plus all 294 prior checks pass (308 total). Coverage
includes all 18 fixture core/addition/rank setter faults, six learning-failure
boundaries, missing preparation points, rank caps, level 49/50 skill rules,
incomplete/invalid/overflow plans, XP/level mismatch, unknown objects, reentrancy,
foreign identity/ownership/items/skill tables and cleanup ordering. The maximum
fixture prepares 24 units with 40 additional ability plans each at player 7/index
7679, with 2,064 modeled writes. Native mocks do not establish engine limits.

Standalone, BT runtime and BT editor compile probes pass:
build/save-codec-compile-ze0vosm3/report.json. Run test_save_prepared_heroes.py and
check_save_jass.py --prepared-heroes with the BT/native-library arguments in
FORSAKEN_REAPPLICATION.md. Compiler DLL loading needs outside-sandbox execution.

Still open: detached profile-to-core/ability translation (including mastery
bonuses/markers, Freelancer and Gaya), other derived combat effects, equipment
projections, safe spawn/visual/pathing policy, synchronized hook exclusion,
operation-budget scheduling, prepared item placement, activation and full
capture/load/commit. Native learning/point/refund behavior must receive engine
acceptance. No full save export, file/restart or multiplayer acceptance yet.
BT/private BU unchanged, BV unused; full new saving/loading remains blocked.

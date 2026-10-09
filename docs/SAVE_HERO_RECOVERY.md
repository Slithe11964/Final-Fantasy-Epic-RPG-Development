# Original hero progression and ability recovery

2026-10-09. Isolated `Forsaken-save-heroes.j` adds read-only capture and verified
same-unit recovery for existing job heroes, Freelancer, Gaya and the active hero.
It requires the item and progression journals. There is no initializer, gameplay
entry route, new-unit allocation, accepted-data publication or playable map build.

## Scope and identity

25 reference positions cover the frozen 22 job cache entries, FreelancerHero,
SpiritOfGaya and PlayerHero. Null cache/Freelancer references remain null. Actual
aliases are recorded; a unit shared by two references is restored once. The
JobHeroHash table and Freelancer cache entry must retain their identities. A
non-null Freelancer cache that differs from FreelancerHero refuses capture.

Job, Freelancer and Gaya rawcodes are checked against their reviewed roles.
The active hero must be a frozen job or Freelancer. Hero ownership can be the
player or neutral passive player; exact original owners must remain unchanged.
Inactive jobs are neutral-owned after existing Job changes. FPG now captures
their actual owners instead of assuming every cached hero belongs to Player(pid).
PlayerHero and SpiritOfGaya must match FSJ's captured inventory holders.

Capture records exact XP, level, unspent skill points, base Strength/Agility/
Intelligence and their native totals including bonuses. Up to 40 native abilities
per unique unit retain actual ability handles, IDs and ranks. Duplicate IDs,
zero IDs/ranks, missing instances, unsupported rosters, foreign ownership,
nonhero units, invalid XP/points and overflow refuse. Arrays support player 7;
the largest ability-array index is 7999, below 8192.

## Recovery

`FHU_Begin(pid)` requires ready FPG/FQR capture journals and verified original
items/progression. Capture is read-only and rechecked before acceptance. States:
0 idle, 1 captured, 2 core restored, 3 blocked. A ready journal cannot be replaced.

`FHU_Recover(pid)` checks every reference/rawcode/owner and original ability
instance before the first setter. Missing/replaced/destroyed originals refuse;
the module never creates units or recreates an original ability. Added abilities,
such as newly granted Gaya supports, are removed with native readback. Removal
attempts are bounded at 40, including a stale native enumerator; failure retains
the journal rather than looping forever. Native order may change without changing
membership.

Excess levels are explicitly removed with UnitStripHeroLevel and verified before
SetHeroXP restores the exact XP. Recovery never guesses XP from a level or uses
SetHeroLevel to hide a mismatch. Ability ranks, base attributes and skill points
are restored afterward. Actual readback verifies each field and the entire ability
set/instance identity. Silent rejection, level/XP mismatch or changed instances
remain blocked and retryable when the original state is still recoverable.

`FHU_Verify(pid, false)` checks core state; `true` also checks native total
Strength/Agility/Intelligence. `FHU_Release` requires state 2, totals, original-item
verification and completed FPG/FQR recovery or their verified releases. When FPG
is still held, its readback must also pass. The three journals can release in
any order after verification; each clears only its own guards/references.

`FSN_HeroBlocked` independently prevents staging, preparation and placement after
a hero recovery attempt, until verified release. `FSJ_HeroPending` prevents item
journal disposal. Hero setters lock the other journals against reentrancy. These
are internal guards, not a synchronized gameplay freeze or operation-cap scheduler.
Cooldown refresh is explicitly permitted and never an equality requirement.

## Engine and session limits

The caller must suppress level/effect/inventory hooks and hold synchronized
gameplay exclusion. Original ability instances must survive the mutation sequence.
Item/research-granted unit ability projections need an audited source policy and
native testing: a changed projection is conservatively blocked here, not accepted
as an equivalent recreated instance. Items may recover before heroes; hero XP/
mastery must recover before FPG's current unit boundary can verify. Total primary
stats are checked after the other state and original equipment are restored.

This is not complete unit/session restoration. HP/MP, buffs, position, visibility,
orders, selections, talent/session tables, other ability fields, research queues,
regeneration/resistances/damage effects and remaining table keys are not journaled
here. Newly created/replaced units need separate owned-allocation cleanup and
non-destructive reference promotion. Existing Gaya_RecreateSpirit and Job_GetHero
must not be reused as a rollback-safe staging backend without redesign: they can
replace originals. No engine or full-state acceptance is claimed.

## Evidence

27 actual-source harness tests pass, including all 28 progression setter failures
and three added-support removal failures; both level directions with an XP setter
that deliberately cannot lower levels; original-instance loss, reference/owner
changes, neutral jobs/Freelancer, alias deduplication, exact XP/ranks/skill points,
derived primary-stat mismatch, item recovery failure, all six release orders,
cooldown refresh, bounded stale enumeration and 25 distinct units with 40 abilities
at player 7/index 7999. These are native mocks, not Warcraft execution.

All 174 prior checks pass (164 save tests plus 10 identity preflights), giving 201
checks total. Legacy's pre-existing unclosed item-table ResourceWarning remains
unchanged. Standalone/BT-runtime/BT-editor read-only compile probes pass with
extracted local libraries. `build/save-codec-compile-f7upkafj/report.json` records
source/map/library/compiler hashes and scripts. Compiler DLL loading required
outside-sandbox execution; no fresh installed-client-version claim is made.

```powershell
& $ffPython experiments/Forsaken/test_save_heroes.py
& $ffPython experiments/Forsaken/check_save_jass.py --heroes --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

BT SHA256 remains `4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2`;
AS/Z unchanged, BU unused, exports blocked. Next: remaining session/effect state,
owned unit allocation and reference promotion, live policy/default/filler objects,
synchronized containment/scheduling and the full capture/load/commit controller.
Real restart/multiplayer/transport acceptance remains required.

Following checkpoint: [SAVE_SESSION_RECOVERY.md](SAVE_SESSION_RECOVERY.md) adds
talent choices, selected skills, partial monographs and accepted-code recovery.
It checks original hero references without replacing them; body/combat effects,
owned new units and the complete controller remain open.

Following body checkpoint: [SAVE_BODY_RECOVERY.md](SAVE_BODY_RECOVERY.md) captures
current health/mana, position/facing and hidden/paused/invulnerable flags on living
originals with alias deduplication and exact readback. It requires reference
reversal and recovered maxima before body setters; remaining combat effects,
orders/buffs and the complete controller remain open.

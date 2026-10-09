# FF Epic RPG handoff - 2026-10-07, stage AS travel regions

## Saved Gaya support policy — 2026-10-09 (isolated; no map build)

Latest checkpoint: SAVE_GAYA_POLICY.md, extended save_hero_policy.py and
Forsaken-save-gaya-policy.j. Preserves purchased support ranks/chant ownership,
derives exact Spiritual Power and separate research/availability targets. Zero
support purchases retain the locked native rank1 menu; mastered fields must be
consistent. Fresh role23 preflight precedes core/ability plans; no player writes.
Native XP/grown attributes/points remain explicit reviewed caller inputs.
10 new tests and 51 focused regressions PASS; three compile probes PASS:
build/save-codec-compile-ytmg1kff/report.json. BT object bindings also checked.
Player target application/readback, remaining Gaya effects, Freelancer,
inventory/controller/full commit remain open. BT/BU unchanged, BV unused; full
saving/loading remains blocked.

## Saved normal-job policy — 2026-10-09 (isolated; no map build)

Previous checkpoint: SAVE_JOB_POLICY.md, save_hero_policy.py and
Forsaken-save-job-policy.j. Validates accepted logical profile/account, retains
unknown/evidence data and maps reviewed normal jobs to prepared core/mastery
plans. Below50 resets/refunds; four rank11 skills and rank6 ultimate at50+.
Existing saved100 sentinel remains native99/mastery4/+100 base attributes;
saved99 is mastery3/+50, 50–98 mastery2/+20. Native XP/natural grown stats still
require reviewed caller inputs; no curve or rounding guessed. 12 new tests and
53 focused regressions PASS; all three compile probes PASS:
build/save-codec-compile-zgse3g26/report.json. Gaya/Freelancer, derived combat
effects, native evidence/controller/inventory and full commit remain open.
Future user requirement: cap150 with format headroom999; separate actual level
and mastery tier in a new versioned schema, preserving old sentinel meaning.
No level-cap change or engine999 acceptance claimed. BT/BU unchanged, BV unused;
full saving/loading remains blocked.

## Reversible pair exposure — 2026-10-09 (isolated; no map build)

Previous checkpoint: SAVE_ACTIVATION.md and Forsaken-save-activation.j. Protects
the original active/Gaya pair, verifies replacement positions, then exposes the
prepared empty pair with readback. Recontainment restores staged poses before
prepared/ownership/reference/unit cleanup; original body recovery restores flags.
No original owner/item/progression mutation, deletion or successful commit.
Activation guards prevent disposal while exposed; core/body/dormant-flag drift
does not prevent safe containment of known owned targets. 12 new plus all 308
prior checks PASS (320), including 18 exposure/12 recovery setter faults and
player 7/keys 14–15. Standalone/BT runtime/editor compile PASS:
build/save-codec-compile-ths3v4mz/report.json. Full profile/inventory integration,
spawn/pathing/visual policy, synchronized exclusion/scheduling, original
retirement and complete controller/commit remain open. BT/BU unchanged, BV unused;
full saving/loading remains blocked.

## Owned hero core/ability preparation — 2026-10-09 (isolated; no map build)

Previous checkpoint: SAVE_PREPARED_HEROES.md and Forsaken-save-prepared-heroes.j.
Owned hidden replacements receive exact XP/level, base stats, skill points and
bounded explicit ability plans. Below-50 normal jobs keep five skills unlearned
and refund level points; mastered jobs learn four rank-11 skills/ultimate rank 6
(50 points spent). Policy skill IDs are frozen and cannot be overridden.
Readback, bounded native learning and independent guards retain failed plans;
discard must precede ownership neutralization/reference reversal/unit cleanup.
Original heroes remain untouched. 14 new plus all 294 prior checks PASS (308),
including 18 setter faults, six learning boundaries and 24×40 plans at player
7/index 7679. Standalone/BT runtime/editor compile PASS:
build/save-codec-compile-ze0vosm3/report.json. Profile translation/mastery bonuses,
other effects, item placement, spawn/activation/scheduling/controller remain open.
BT/BU unchanged, BV unused; full saving/loading blocked.

## Contained replacement ownership — 2026-10-09 (isolated; no map build)

Previous checkpoint: SAVE_OWNERSHIP_PREPARATION.md and Forsaken-save-ownership.j.
After reference publication, assigns only owned active/Gaya replacements to the
player while keeping them hidden/paused/invulnerable/empty. Originals remain
untouched. Neutralization/readback and ownership release must precede reference
reversal and owned-unit deletion. Foreign owners/identity/items refuse setters;
independent guards retain failed recovery. 13 new tests plus all 281 prior checks
PASS (294), including two assignment/eight recovery setter fault positions,
Freelancer aliases and player 7/keys 14–15. Standalone/BT runtime/editor compile
PASS: build/save-codec-compile-va2hotyc/report.json. Staged progression/abilities,
placement, visual/pathing/spawn policy, activation, scheduling and full controller
remain open. BT/BU unchanged, BV unused; full saves remain blocked.

## Living hero body recovery — 2026-10-09 (isolated; no map build)

Previous checkpoint: SAVE_BODY_RECOVERY.md and Forsaken-save-body.j. Captures 25
original hero reference positions with alias deduplication, health/mana,
position/facing and visibility/pause/invulnerability. Recovery requires original
living identities and restored maxima; reference reversal precedes setters.
Eight writes per unique hero receive exact readback, independent guards and retry.
17 new tests plus all 264 prior checks PASS (281 total), including 24 setter-fault
positions and 25 distinct heroes/200 writes at player 7/index 199.
Standalone/BT runtime/editor compilation PASS:
build/save-codec-compile-0cy567c4/report.json. Buffs/orders/other combat effects,
replacement activation, prepared-state controller, native scheduling and full
load/commit remain open. BT/BU unchanged, BV unused, full saving/loading blocked.

## Reversible hero references — 2026-10-09 (isolated; no map build)

Previous checkpoint: SAVE_REFERENCE_SWITCH.md and Forsaken-save-references.j.
Captures 26 live/cache references and typed presence, plans owned replacements,
switches with readback and restores originals before replacement cleanup.
Independent guards survive other journal release. Original heroes stay alive;
targets remain hidden/neutral/paused/invulnerable/empty. No activation or commit.
15 new tests plus all 249 earlier checks PASS (264), including 52 reference-write
fault cases. Standalone/BT-runtime/BT-editor compilation PASS:
build/save-codec-compile-2seobnrz/report.json. Body/combat effects, prepared-state
controller, ownership/activation, synchronized hooks and native scheduling remain
open. BT/BU unchanged, BV unused, full saving/loading still blocked.

## First engine diagnostic — 2026-10-09 (private map BU)

Previous checkpoint: SAVE_ENGINE_TEST.md, Forsaken-save-probe.j and
build_save_probe.py. BU adds -savecheck/-saveverify for live 57-position inventory
capture, native metadata checks, codec round trip and unchanged/changed readback.
Only a tracked temporary fGap receives flag setters/deletion; no original item
or hero mutation, progression application, usable code export or full load.
Per-position timer work and a timeout make engine limits observable. 10 new probe
tests plus all 239 prior save-system checks PASS (249). Mandatory map gates,
96 repository tests and 2,000 legacy codec cases also PASS. See the report beside
the map for final hashes and preserved archive members. Canonical sources/BT
unchanged; BU is now the private diagnostic, BV next. Saving stays blocked.
Human tests now include PASS with 1, 19 and 18 items, boots-move CHANGED and
explicit check/sell-8-Nethril/verify CHANGED. See SAVE_ENGINE_TEST.md for limits
and the capture-failure/retry observation. Full load acceptance remains open.

## Owned replacement-unit staging — 2026-10-09 (isolated; no map build)

Previous checkpoint: SAVE_UNIT_STAGING.md and Forsaken-save-units.j. Direct native
allocation tracks up to 24 job/Freelancer/Gaya heroes, verifies neutral ownership,
hidden/paused/invulnerable state and empty inventories, and preserves originals.
Cleanup refuses published/item-carrying heroes, verifies deletion and retains
failed handles for retry. Independent unit guards block staging/codec publication
and item-journal disposal until verified cleanup. No promotion/commit API yet.
20 new tests plus all 219 prior checks PASS (239 total), including all 24 deletion
fault positions, creation/flag faults, cross-player references and release guards.
Standalone/BT-runtime/BT-editor compilation PASS:
build/save-codec-compile-5anxjlgn/report.json. Reference promotion, body/combat state,
hook suppression/scheduling and the full controller remain open. Batch operation
limits and native behavior still require engine acceptance. Cooldown refresh
permitted. BT unchanged, BU unused, saving blocked.

## Session recovery — 2026-10-09 (isolated module; no map build)

Previous checkpoint: SAVE_SESSION_RECOVERY.md and Forsaken-save-session.j. Talent
choices preserve typed presence/value across all 23 jobs; six skill slots,
partial monographs and prior accepted codec state restore with readback. These
choices remain per-game, never serialized. Independent guards retain journals
and block staging/codec publication after recovery begins. Read-only hero/table
identities refuse changes; writer Abort remains allowed for cleanup/retry.
18 new tests plus all 201 prior checks PASS (219 total), including all 299 talent
write faults, player 7, unknown optional sections and all 24 release orders.
Standalone/BT-runtime/BT-editor compilation PASS:
build/save-codec-compile-jzm76o6b/report.json. Wider combat/body effects, owned
new-unit cleanup/reference promotion, gameplay guards/scheduling and full load/
publication remain open. Cooldown refresh permitted. BT unchanged, BU unused,
saving blocked; native projections and full engine acceptance remain required.

## Original hero recovery — 2026-10-09 (isolated module; no map build)

Previous checkpoint: SAVE_HERO_RECOVERY.md and Forsaken-save-heroes.j. Original
job/Freelancer/Gaya/active hero XP, levels, skill points, ability ranks/instances
and base attributes restore with readback; release also checks total primary
stats. Aliased references restore once. FPG now captures actual cached owners,
including neutral inactive jobs. Missing/replaced originals refuse; no unit or
original ability recreation. Added Gaya supports can be removed with verification.
Independent hero guards retain all journals after failure; all six release orders
tested. 27 new tests and all 174 prior checks PASS (201 total), including 28 setter
and three support-removal faults, both level directions and player 7/index 7999.
Standalone/BT-runtime/BT-editor compilation PASS:
build/save-codec-compile-f7upkafj/report.json. Wider derived effects, session state,
owned new-unit cleanup/reference promotion, gameplay guards/scheduling and full
load/publication remain open. Cooldown refresh permitted. BT unchanged, BU unused,
saving blocked. Native item-derived ability projections still require acceptance.

## Live progression journal — 2026-10-09 (isolated module; no map build)

Previous checkpoint: SAVE_PROGRESSION_JOURNAL.md, Forsaken-save-progression.j.
Actual per-player globals/eligibility, gold/shards/food used, 18 research levels,
644 title/Armory/policy force slots and 22 stored job entries captured/restored
with native readback. Missing table entries stay missing. Job hero handles/XP/
levels/mastery are read-only boundaries; changed heroes refuse before setters.
Independent progression guards retain both journals and block staging after
failed recovery; releasing item recovery does not clear progression protection.
19 new tests and all 145 prior save tests PASS (164), plus 10 identity tests;
coverage includes all 54 native write failures/retry and both release orders.
Standalone/BT-runtime/BT-editor compilation PASS:
build/save-codec-compile-x01z46c2/report.json. Actual job/Gaya/Freelancer unit
recovery, derived effects, other session state, gameplay guards/scheduling and
publication remain next. Cooldown refresh is permitted. BT unchanged, BU unused,
saving blocked. See the checkpoint document for exact scope and remaining gates.

## Original-item recovery — 2026-10-09 (isolated module; no map build)

Previous checkpoint: SAVE_ORIGINAL_RECOVERY.md and Forsaken-save-recovery.j.
Quarantine/recovery preserve original handles across all 57 positions, actual
ability instances and known passive bookkeeping. Failed recovery retains the
journal, blocks staging and allows retry; verified items stay blocked until
internal release. Originals are never deleted. The user permits cooldown refresh
on character changes, including failed-change recovery; cooldowns are never saved
or an equality gate. 20 new tests and all 125 previous tests PASS (145 total).
Standalone/BT-runtime/BT-editor compilation PASS:
build/save-codec-compile-3e9quhly/report.json. Full progression/session rollback,
derived stats/effects, live policy/filler objects, gameplay guards, publication
and engine acceptance remain open. BT unchanged, BU unused, saving blocked.

## Prepared abilities/equipment — 2026-10-09 (isolated modules; no map build)

Previous checkpoint: SAVE_EQUIPMENT_RESTORE.md, Forsaken-save-effects.j and
Forsaken-save-equipment.j. Classified staged ability lists (max16), verified
bag-passive removal, retained active/marker abilities, complete-batch preparation
before placement and exact equipment readback. A lone Ring5 uses a tracked
reviewed inert ring filler; no such filler is installed in BT yet. Ability policy
loader/defaults also remain future integration work; tests use synthetic inputs.
Original equipment refuses before mutation; full rollback and actual
stats remain unimplemented/unverified. Original-item recovery follows above;
cooldown refresh is permitted. No gameplay guard/routes/publication.
19 new tests and all 106 previous tests PASS (125 total), including a full modeled
57-item batch. Standalone/BT-runtime/BT-editor compilation PASS with extracted
libraries: build/save-codec-compile-h6pyfqj1/report.json. BT unchanged, BU unused,
saving blocked. Native original/session journal and quarantine/recovery are next.

## Item journal/storage placement — 2026-10-09 (isolated modules; no map build)

Previous checkpoint: SAVE_ITEM_JOURNAL.md, Forsaken-save-journal.j and
Forsaken-save-position.j. Read-only journal preserves actual handles and metadata
across all 57 positions, both rings and sparse gaps. Requires an external verified
droppability capability; actual original flags remain an engine gate. House owner
is recorded rather than assumed equal to the player. Ready journals cannot be
overwritten or released after a failed equivalence check.
Exact placement covers 48 storage positions with tracked fillers and actual-item
readback. Equipment refuses before mutation; native quarantine/full rollback,
passives/cooldowns/progression and publication remain open. FSN state 4 means
placement started; use FSP_Verify, not hidden-only FSN_Verify. Abort cleans tracked
items/fillers and retains failures. Caller gameplay exclusion is not implemented.
19 new tests plus all 87 previous tests PASS (106 total). Standalone/BT runtime/
BT editor read-only probes PASS: build/save-codec-compile-8rx50iid/report.json.
No native-engine execution claim; BT unchanged, BU unused, saving blocked.

## Save-system continuation — 2026-10-08 (isolated source/tools; no map build)

Previous native staging foundation: SAVE_NATIVE_STAGING.md and
experiments/Forsaken/Forsaken-save-native.j. Native CreateItem/metadata readback
and owned-allocation cleanup implemented; no original inventory mutations,
placement, promotion, initializer or entry route. Each new handle probes the
droppability getter across false/true before accepting metadata. Failed deletion
retains the handle and blocks reuse; failed hiding is not claimed contained.
13 native staging tests plus all 74 previous tests PASS (87 total). Standalone/
BT-runtime/BT-editor read-only probes PASS with extracted local libraries:
build/save-codec-compile-26ozv4tt/report.json. Actual native behavior, synchronized
gameplay guard, original flags/journal, placement/passives/progression/rollback
and publication remain required. Modern-only staging; classic codec/life unchanged.
BT unchanged, BU unused, saving blocked; no playable build or engine test claim.

Previous capture/restore foundation: SAVE_RESTORE_PROTOCOL.md, Forsaken-save-life.j
and save_transaction.py. JASS real/word conversion plus read-only life capture;
reference inventory capture and staged restore controller with verified rollback,
unavailable reservations and post-commit cleanup quarantine. Native inventory/
flag capture and Warcraft restoration backend remain unimplemented.
5 life tests (6282 binary32 patterns) and14 capture/transaction tests (417 injected
failure positions) PASS, plus13 JASS codec,13 reference,16 migration and13 legacy
tests:74 total. Codec+life standalone/BT-runtime/BT-editor probes PASS with
extracted libraries; bundled/classic standalone also PASS. Evidence:
build/save-codec-compile-otuota82/report.json. No map writes/build integration;
BT unchanged, BU unused, saving blocked. Native execution/work scheduling,
droppability getter/journal verification, reviewed defaults and native rollback
remain required. Model success does not establish Warcraft restoration.

Earlier isolated codec checkpoint: `SAVE_JASS_CODEC.md` and
`experiments/Forsaken/Forsaken-save-codec.j` implement FSV envelope/schema1
sections1–9 in JASS; per-player accepted/scratch/writer buffers, profile checks,
exact re-emission, bounded unknown retention and failed-parse preservation.
No initializer/routes/build wiring. Life bits validate; real conversion, legacy
semantic replay and gameplay restoration remain unimplemented.
13 JASS tests (150 seeded differential envelopes+150 mutations) plus13 reference,
16 migration and13 legacy tests PASS,55 total. Standalone compiles with bundled
and classic1.29.2 libraries; standalone/BT-runtime/BT-editor read-only probes pass
with extracted local libraries. Report: build/save-codec-compile-zl7pgdq8/report.json.
Compiler needed outside-sandbox execution due DLL error623; no relaxed checks.
BT hash unchanged; no playable build; BU unused; saving blocked. Next: engine
execution/work scheduling limits, exact real/default capture, staged restore and
rollback, legacy evidence/account linkage and entry-route transport tests.

Progression checkpoint: `SAVE_PROGRESSION_MIGRATION.md`, `save_progression.py` and
`migrate_save.py` add core/Gaya/upgrades/title/Armory sections, required-field
profiles, frozen migration policy1 and required original-code provenance.
All eight synthetic E/F/G/H fixtures translate with62 passing comparison entries.
Hero gear goes to deterministic bag slots without equipping; Gaya/house stay
separate; V2/Speedrun exclusions are reported and retained in evidence. Missing
legacy item metadata/defaults remain explicit and unresolved. Incomplete Armory
and cheat status refuse export. NG+ source reset tested; no successor Minus route.
16 migration tests (250 seeded progression round trips and CLI validation),13 codec tests
(1000 seeded inventory round trips),13 legacy and10 identity tests PASS.
Full synthetic logical profile:2803 characters; with full opaque budget6704.
No gameplay/release changes; saving blocked, BU unused. JASS implementation is
covered above; default resolution, transactional adapters and transport remain.

New-format foundation: `ITEM_SAVE_METADATA.md` audits item life as gameplay data,
charges, account-relative binding and reconstructable runtime passive state.
`SAVE_VNEXT_REFERENCE.md` specifies the isolated `save_vnext.py` prototype:
bounded/versioned length-delimited sections; canonical signed-JASS-safe varints;
full 57 sparse inventory positions; explicit seven-bit quantities; exact binary32
life words; counted job IDs and dormant extension progression; bounded unknown
optional retention and required-schema rejection. Progression/translation is now
covered above; no JASS adapter or runtime routes yet.13 prototype tests with
1000 seeded round trips and13 legacy migration tests PASS. Synthetic sizes1453
characters inventory-only,1804 with42 jobs/50 dormant records,5705 with full opaque
budget. Reproduce with measure_save_vnext.py; these are not engine capacity claims.
Progression, legacy translation and fuller equality/size reports are now implemented
as a detached reference checkpoint; see above for remaining runtime gates.

Next checkpoint: `LEGACY_SAVE_LEDGER.md`, frozen `legacy-layouts.json`, eight
synthetic E/F/G/H fixtures and read-only `legacy_snapshot.py` now exist.13 focused
migration tests pass, including actual JASS main-reader control flow with mocked
world operations and current/historical Armory writer cases. Corrected initial
plan: V2 has22 jobs with three-job permutation, not19. JASS low short-level is0
(Python inspector displays1); legacy sparse gaps are not encoded. User chooses
gameplay quantities<=120; keep seven bits and preserve imported121..127 exactly.
Source-tested finding: NG− writer emits NG bits9, which current reader marks as
cheating; BT playable writer token-equal. User retired NG− from the replacement
system: no new Minus export/command or repair work. Keep old decoding/audit evidence;
no change to legacy runtime. Real-code/restart/multiplayer acceptance remains open.

Read `SAVE_SYSTEM_PLAN.md` for the phased implementation and release gates, and
`FORSAKEN_REAPPLICATION.md` for exact checkpoint inputs, commands, overlays,
outputs and checks. First milestone adds a read-only frozen registry for 358 item
IDs and 22 job IDs, with source/variant/offhand preflight and negative tests under
experiments/Forsaken. No game serializer, release or baseline changes; export
blocking stays in place. Real fixture coverage and expanded NG+/default semantics
remain open. Real native/legacy/multiplayer acceptance is outstanding.
BU remains unused. Shared base stays AS, latest experimental map BT/fa6ed31.

Read this first, then STAGES.md and QUEST_ENGINE.md. Z remains the confirmed public baseline.
User requests Chronicle paging/counters, Secrets/Keg Hunter, monograph effects and Bazaar reopening.
Next unused stage: BU. Normal development stays on AS; Forsaken BT is the current gear/stat test checkpoint.

BT is a labels-only patch of BS: Cat's Bell reads HP regen not in combat / 1%; Deathbringer reads Kill Commons below 40 / 5%. Playable and embedded editor sources updated together; gameplay unchanged. Map: release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x. BT validation PASS: 87 focused tests, 96 regressions, 2,000 codec cases, editor/playable compilation against installed libraries, source agreement, quests/save/content/armory/Bazaar checks and all-276 gear audit. Log: build/BT-checks.txt.

## Forsaken BS - 2026-10-08

Fresh external pickup clears a prior full-bag conversion failure marker, allowing the same original gear to convert and equip after space is freed. Internal replacement events remain guarded, preventing duplicate loops; charges/user data/life/owner survive rollback and retry. In-game acceptance still required for the reported Armory/full-bag sequence.

Long stat labels retain right-aligned values. Add Dagger/Platinum Dagger Backstab 1.5x, Storm Lance Chance to Shock 10%, and Reflect Shield Movement speed penalty -20%; revise Molotov, Cat's Bell, Blue Amulet (two mana rows), White Materia and Deathbringer wording. Deathbringer reads Execute common enemies below lvl 40 / 5%, disabled in Eternity. Equipment-aware effect reads and summaries are shared with player inspection. Ammo math remains canonical: flat bonus scales by (10 + proficiency)/10; arrow percentage applies to incoming damage before the separate flat term, not to the flat bonus itself.

Validation: 87 focused tests, 96 repository regressions, 2,000 codec cases, all build/source/editor/map gates, installed 3.0.1.24342 compilation and all-276 item/ability audit PASS. Complete source/runtime agreement has 0 new differences. Scratch: build/ForsakenBS-hz94mr9k/FFERPG. Map: release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBS.w3x. Native UI/equip/multiplayer acceptance remains; saving disabled, canonical AS and exact AS classic fallback unchanged.

## Separate experiment - Forsaken BR

BR corrects BQ's doubled lance accuracy. Tooltip accuracy contributes only the residual missing from the original formula, and that residual now reaches actual combat as well as the panel. Source-aware equipment queries prevent stale item markers from bagged/unequipped gear, while preserving innate and shrine passives. Requested trinket hooks (drop rolls, mana on kill, gold-for-MP, enhanced buffs and summon scaling) read native equipment.

All 276 native gear variants keep a zero-stat fGmk marker while their real passive abilities are suspended in storage. Its AGI/INT/STR fields are explicitly zero with the installed metadata's data pointers 1/2/3. This addresses the reported passive-only claws, fists, helmets and shields losing native equip interaction; actual in-game equip acceptance remains to be confirmed. Real level/mastery restrictions, original/Gaya items, active book spells and cooldown groups are preserved. No automatic equipping.

Damage bonuses adds base gun Critical Chance/multiplier (including Canister multiplier), katana combo chance/minimum total hits, elemental weakness damage, Deathbringer execute chance (disabled in Eternity), bow-only technique bonuses, gun-only perfect accuracy and shot effects, Chimes and Setzer's Coin. Ammo element highlighting follows actual equipped bow/gun and the existing elemental priority. Flat ammunition damage includes current proficiency. Rock/Piercing Shot adds armor-piercing damage rather than subtracting armor. Gun proficiency/time buildup still applies on top of the displayed base critical chance. Molotov's text follows its original tooltip; its existing proc cadence is unchanged.

Other bonuses adds Cat's Bell, Blue Amulet (the item referred to as Blue Gorget), Turtleshell Choker, White Materia, Bag of Tricks (+20 percentage points to the normal drop roll) and Summoner's Horn. Existing outgoing-damage rows dynamically show Leather/Steel Gorget at <=30% HP and Magic Gloves at >=99% HP. Armguard's halved-damage row appears only at <=30% HP. Defenses has no blank accuracy row. The talent grid is smaller and raised, leaving 16 stat rows with the same text size, gold-border padding and HUD clearance.

Repeatable audit: `experiments/Forsaken/audit_gear.py`; full 276-entry report: `docs/FORSAKEN_GEAR_AUDIT.md`. Checks compare all original gear ability definitions/numeric fields and every native variant's abilities, slots, charges, cooldown groups and requirements. Lifecycle tests cycle all 276 items between stored/equipped states while retaining active abilities. These do not substitute for native in-game equip and damage testing.

Validation: all build/editor/playable/source gates, 85 focused Forsaken tests, 96 repository regressions, 2,000 codec cases, all-276 final gear/object audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. JASS CRLF and byte-identical AS classic fallback verified. Scratch: build/ForsakenBR-qbnzzpyu/FFERPG. Reforged output: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBR.w3x`. Normal sources/AS and exact AS classic fallback remain unchanged; saving is disabled. Native acceptance: equip the reported claws/hats/shields after meeting their requirements; repeat equip/unequip and job changes; check lance accuracy, gun/katana/ammunition rows, low/full-HP effects, trinkets and panel spacing. Next unused stage BS.


## Separate experiment - Forsaken BQ

BQ keeps BP's independent talent rows and bagged active book abilities, but replaces the Depths/Wateraga proxy with a direct scripted Crushing Wave missile sweep. It preserves the original mana and rod-power formula, handles ground and unit targets, applies one water hit per target, and cleans its timer/groups/effect. The startup hashtable is initialized outside the water trigger registration so the baseline startup audit remains exact.

The stat panel now shows Accuracy rating on Damage bonuses. Build-time item descriptions are audited for accuracy bonuses and stored by original, Forsaken equipment-variant and offhand type ID; only active equipped Forsaken slots are read, so six-slot and 30-slot bag storage remain stat-free. The armory catalogue maps all 280 entries, including 276 equipment items and four unchanged Materia.

Validation: all source/editor/playable/map gates, 80 focused Forsaken tests, 96 repository regressions, 2,000 codec cases, armory/Bazaar checks, startup preservation and installed 3.0.1.24342 compilation PASS. Reforged output: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBQ.w3x`; the classic path is the unchanged AS fallback. Native acceptance remains: cast Depths and Wateraga at ground and units, verify visible wave/damage, equip Storm Lance and confirm Accuracy rating updates, and verify bagged gear still grants no static stats. Saving remains disabled in the experiment.

## Separate experiment - Forsaken BP

BP removes the same-column prerequisite from talent purchases. Each mastery-unlocked row independently permits one of its three choices; job/player isolation, mastery gates and cosmetic-only behavior remain unchanged.
Native testing of BO reported that equipped-then-bagged Storms/Winds stopped casting and sharing cooldowns, and Depths/Wateraga lost their water wave. BP queues one zero-delay bag owner refresh after native unequip completes, suspending passives before removing/re-adding the same item handles. Keep sparse bag positions, charges and the six quick slots; never recreate real items, mutate active ability lists or automatically equip. Ignore a delayed refresh for a hero that is no longer the player's current job. Original and variant book active abilities and shared Acdh cooldown groups stay identical.
Experimental Abil/Cooldown overlays fall back to the actual spell event when a bagged item has no legacy unit ability rank, and apply cooldown scaling to the event ability handle. Water uses a local proxy reference, explicit zero proxy mana cost/cast point, and the existing invisible-model/Locust dummy without engine ShowUnitHide, so native proxy casting/projectiles are not gated by hidden-unit state. Keep original source damage formulas, book spell IDs, targets and rewards. These are fixes for the reported symptoms; native success is not established by mocked tests or compilation.
All changes stay in experiments/Forsaken and isolated scratch/release/Forsaken. Canonical AS, exact AS classic fallback, original item/gameplay object fields and world/import assets remain unchanged; saving disabled.

Validation: all stage source/editor/playable/map gates, 77 experimental tests, 96 regression tests, 2,000 codec cases, final object/skin/archive isolation audit and installed 3.0.1.24342 compilation PASS. Complete source/runtime agreement: 0 new differences. JASS CRLF and exact AS classic fallback verified. Scratch: build/ForsakenBP-205nu15d/FFERPG. Native acceptance required in a fresh BP game: equip Storms and Winds, unequip to bag, cast both and verify the original shared book cooldown; repeat through multiple cycles and job changes. Cast Depths and Wateraga at ground and units and confirm visible wave/damage; verify bagged passive stats remain off, equipped bonuses restore, sparse bag order/charges survive and Gaya carrying remains intact. Next unused stage BQ.

## Separate experiment - Forsaken BO

BO supersedes BN after native testing showed +605 INT and other bonuses from bagged books/Firefly despite Equipment classification. The class correction alone was insufficient. Add per-item passive ability suspension in the 30-slot bag, driven by bundled base ability codes and the actual map ability definitions. Snapshot/remove only passive abilities (attributes, damage, armor, regeneration, movement/attack speed, evasion, auras and scripted passive markers). Leave active abilities installed: Book of Storms Bolt, other book spells and item casts retain their actual ability handles, cooldowns, charges and spell triggers. Restore passives for equipped/quick-slot items, pickup/drop/Gaya transfer and equipped job transfers; re-suspend stored items on native equip/unequip/pickup and the existing inventory refresh. Conversion disposal clears snapshots. Hero gear still routes out of six slots; Gaya storage and native bag order remain unchanged. No automatic equipping.
Move mana regeneration and cooldown reduction from Defenses to Other bonuses. Show owned condition protections on Resistances (Blind, Disease, Sleep, Slow, Pain, Fog, Deprotect, Deshell; bosses' Stun/Freeze), with Dark Knight Ailment Defense shown as the verified 80% knockback reduction, not an invented stun percentage. Show only present protections; more than four gets a condition continuation through More stats, within the Resistances stage of the four-page cycle. Format split elemental values as physical% | magical% with explicit percent signs, preserving a single percentage for matching values. Widen the stats value space and panel to keep values inside the gold border. Place inspection Stats inside the border to the left of X. Shorten both custom panels to .415 high (bottom .170) and reflow talent icons, stats, summary and inspection slots above the normal HUD; retain font sizes and all 30 inspection bag positions.
All changes remain in experiments/Forsaken and isolated scratch/release/Forsaken. Canonical AS and exact AS classic fallback remain unchanged; saving disabled. Validation: all build/editor/source/map gates, 96 regression tests, 2,000 codec cases, 74 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Test coverage includes 100 stored/equipped cycles, actual book/Firefly passive classifications, untouched Bolt/Fire ability and cooldown state, conditional protections, stat-page moves and panel border geometry. JASS CRLF and exact AS classic fallback verified. Scratch: build/ForsakenBO-jnou7c1o/FFERPG. Native acceptance pending: fresh BO game, compare bag-only vs equipped book/Firefly stats, cast Bolt from the bag and check cooldown persistence, equip/unequip repeatedly, Gaya transfer, sparse job bag transfer, conditional protections and panel/HUD clearance. Next unused stage BP.

## Separate experiment - Forsaken BN

BN gives every native Forsaken gear variant the actual Equipment item class used by installed Forsaken stock gear. The previous variants retained legacy Permanent/PowerUp/Artifact/etc classes. Native testing after BN confirmed the class correction alone does not suppress bagged bonuses; BO addresses passive abilities directly. Keep original items unchanged for Gaya/ground/shop use, and keep variant abilities/values/slots unchanged. Add Forsaken_GearClass and per-variant original category metadata, including 25 bundled inherited base-item classes, so original proficiency/Monk/Two-Handed/equipment/forge/Loki/ItemShared comparisons retain their existing semantics despite the native class change. Patch these queries only in experimental scratch modules.
Hero six-slot gear carrying is removed: convert legacy gear to native variants, route any six-slot gear into the 30-slot bag using guarded temporary spacers, and preserve the actual item handle and its data. If the bag is full, leave the item safely beside the hero with one message. Consumables remain in the six slots; no auto-equip. Gaya retains legacy six-slot pickup/give/drop behavior and no backpack. Active-gear queries exclude mapped gear in hero quick slots immediately.
Elemental combat, basic-attack element and UI queries use a shared source-aware lookup for 41 gear-provided elemental properties. Recompute from currently equipped items rather than trusting a possibly stale unit ability rank; exclude bagged/quick-slot gear, preserve genuine innate unit abilities and NPC/summon/copied abilities. Keep original additive rates, type-specific attack/spell boosts, Omni equipment contributions, enchant stacking and BM Gaya33% correction. Test Book of Flames through100 equip/unequip cycles, all elemental gear across six elements and physical/magical types, source clearing, native item classification/original category compatibility, safe full-bag routing and Gaya carrying.

Validation: all build/editor/source/map gates, 96 regression tests, 2,000 codec cases, 71 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Tests cover native Equipment classification and original category compatibility, Book of Flames through 100 equip/removal cycles, all elemental gear across six elements and physical/magical damage, safe six-slot routing/full-bag preservation and unchanged Gaya carrying. CRLF JASS and exact AS classic fallback verified. Scratch: build/ForsakenBN-f9f6lmy6/FFERPG. Native acceptance pending in a fresh BN game: compare INT with books equipped, bagged and held by Gaya, repeat Book of Flames removal, and check ordinary consumables and job bag order. Saving disabled. Next unused stage BO.

## Previous experiment - Forsaken BM

BM excludes internal conversions and fGap bag-position spacers from legacy accessory restrictions. Shared Two-Handed eligibility explicitly rejects an occupied native offhand and is reused by the attack event, damage query and panel. Clear an existing swing buff when eligibility is lost; retain original I0GK attack-triggered speed and weapon-life damage formulas. Damage bonuses shows Two-Handed conditional damage/speed, Monk Brawler Active/Inactive and its scripted attack multiplier. Warcraft's normal damage tooltip does not include these scripted hit bonuses. Monk barehanded/fist eligibility and existing60/90 proficiency formulas are unchanged; shields/tomes cancel the bonus. Remove talent letter labels; selected + and mouse/mastery rules remain; Escape still closes.
Correct Gaya Strength's duplicate count in experimental combat and display: remove only its duplicate half33% from the Omni lookup when evaluating a specific element. Actual Omni equipment bonuses remain (Magus Rod variants A0MG, Force of Nature A0MI); Geomancer receives no Omni ability. Omni-element attacks retain one33% Gaya bonus; enchant stacking preserved. Canonical AS, exact AS classic fallback, world/imports/dialogue/rewards and original object gameplay fields unchanged; saving disabled.

Validation: all build/editor/source/map gates, 96 regression tests, 2,000 codec cases, 66 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Tests cover spacer restrictions, Monk native shield/fist attack multipliers, Two-Handed offhand cancellation/restoration and speed, matching combat/display33% with aura/enchant/real Omni bonus, and no talent letter bindings. CRLF JASS and exact AS classic fallback verified. Scratch: build/ForsakenBM-dr4l_j5b/FFERPG. Fresh-game native acceptance pending. Next unused stage BN.

## Previous experiment - Forsaken BL

- BL includes all BK changes and the subsequently requested live basic-attack element highlight. Damage bonuses is page1; its matching Fire/Ice/Thunder/Water/Earth/Wind label turns green using Element_GetOfUnit(hero,true), the same function combat calls. Existing enchantment priority is preserved: an active enchantment overrides the weapon element, and expiration restores the weapon indication. Non-elemental attacks clear the highlight; Omni uses a separate green Basic attack element: Omni indicator rather than incorrectly coloring six unrelated bonus rows. Refresh follows the existing one-second panel clock and inspected target.
- Add Forsaken_ActiveAbilityLevel to the TUnit scratch overlay: read native unit/buff rank first, then abilities of six quick-slot and nine equipped items; never include thirty-slot bag storage. Use it only in selected original Prof weapon/armor/proficiency queries, Element_GetOfUnit and Damage elemental bonus/resistance queries. This makes native equipment elemental properties and proficiency dummies participate in combat as well as display, including Geomancer elemental bonuses. Preserve original precedence, rates/formulas, buffs, rolls and other combat functions; no probes or UI gameplay mutations. Existing Monk empty-hand/Striker checks, Holy Swordsman Two-Handed checks and Ninja offhand manual equipping from BK remain.
- Validation: all build/editor/source/map gates, 96 regressions, 2,000 codec cases, 61 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Tests cover native weapon elements, enchantment priority/expiration, non-elemental reset, Omni and green-row refresh, as well as preceding inventory/UI/passive cases. World/imports and original gameplay object fields preserved except requested tooltips; CRLF JASS and exact AS classic fallback verified. Scratch: build/ForsakenBL-vvf5pf1l/FFERPG. Source changes stay exclusively in the experimental overlay/scratch. Canonical AS, world/imports, rewards/dialogue and exact AS 1.29.2 fallback remain unchanged. Saving disabled. Native acceptance pending: fresh BL game; extended-only Armory slot hints and Firefly Ring; Talents closed on B/bag open then clickable near corner; new stat page order/attack speed; equip primary then manually equip highlighted Ninja offhand weapon, unequip without automatic refilling, job switches with bag positions and metadata; Monk hands empty vs weapon/tome; Holy Swordsman one weapon/no offhand vs occupied offhand; Geomancer elemental weapon/Enfire and expiration; green row follows actual basic-attack element. Next unused stage BM.

## Separate experiment - Forsaken BK (superseded by BL)

- BK responds to BJ in-game feedback. Armory slot text now appears only in extended descriptions below the requirement; restore the untouched basic unit title, including Reforged skin title overrides. Firefly is a Forsaken Ring. Talents opens only with its custom button; remove native Backpack B/command-button/chat activation and automatic open-on-bag visibility. Move its button nearer the upper-right corner (-.010,-.010), clear V row markers while preserving prerequisite rules, and keep independent close/toggle. Stats pages: Damage bonuses (1, includes live attack speed), Defenses (2), Resistances (3), Other bonuses (4). Attack speed reuses the canonical read-only -atkspd calculation and active gear queries, plus Haste/Hastera/Slow effects; no gameplay state mutation.
- Add a shared active-gear view of six quick slots plus nine equipment slots, excluding the bag. Patch only relevant Unit/Prof/Damage/TwoHanded functions in scratch: Monk empty-hand/Striker checks, Two-Handed detection and proficiency-derived damage now see equipped native gear and preserve existing formulas. Proficiency and Versatility gear contributions include native equipment. Ninja Dual Wield (A0HP, including borrowed passive) receives equivalent offhand weapon variants; with a primary equipped, bag weapons become offhand-compatible for manual equipping. Removing the primary restores primary-compatible bag weapons. No auto-equip. Non-dual jobs reject/unequip offhand weapons. Full transaction uses actual handles, preserves charges/user data/proficiency life/owner and bag index, fills earlier empty positions with removable spacers, verifies replacement position and rolls back rejected additions. Conversion is guarded against recursion; six-slot Gaya carry and shared sparse job bag remain intact.
- All changes remain in experiments/Forsaken and scratch/release/Forsaken. Validation: all build/editor/map/source gates, 96 regressions, 2,000 codec cases, 59 experiment tests, final object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Skin change boundary is 552 unit extended tooltip fields plus 276 item extended tooltip fields; basic titles unchanged. Native offhand variants match primary variants except equipment type. World/imports/canonical AS unchanged, JASS CRLF, classic fallback exact AS. First unpublished run stopped on a forward function declaration and was corrected without relaxing checks. Scratch: build/ForsakenBK-6qbf8dge/FFERPG. Native acceptance remains pending for the UI position, native bag conversions/equip/unequip, job swaps and passives. Saving disabled. Next BL incorporates the subsequently requested active basic-attack element highlight.

## Separate experiment - Forsaken BJ (superseded by BK)

- BJ fixes the Armory tooltip override and Gaya inspection reported after BI. BI already contained slot labels in war3map.w3u/w3t, but the Reforged war3mapSkin.w3u/w3t files retained TRIGSTR references to older tooltips. Mirror the prepared gear unit basic/extended tooltips and item extended descriptions into the existing skin tooltip modifications, across every modification set. Other skin fields, names, icons, gameplay values, hints, catalog order and rewards remain unchanged. Germinas Boots now has Forsaken slot: Boots below Required level: 14 in both object layers. No shared WTS changes.
- Explicitly reject Spirit of Gaya rawcode H01D before the hero/boss inspection predicate, so selection cannot show Inspect and clicks cannot open it even if Gaya qualifies as a hero or belongs to the boss group. Existing hero/boss inspection and Gaya six-slot carrying are preserved. Changes remain exclusively in the Forsaken experiment; canonical AS and its exact classic fallback remain unchanged. Saving remains disabled.
- Validation: all build/editor/source/map checks, 96 regression tests, 2,000 codec cases, 53 experimental tests, final archive/object isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. The final skin audit verifies exactly 1,104 unit tooltip fields and 276 item extended tooltip fields changed, with every other skin field identical. CRLF JASS and byte-identical AS classic fallback verified. Scratch: build/ForsakenBJ-sku2xngk/FFERPG. Native acceptance pending: start a fresh BJ game, hover stored Germinas Boots and a missing Armory entry, verify the slot line, select Gaya and verify no Inspect, and verify another hero/boss still supports Inspect. Next unused stage BK.

## Separate experiment - Forsaken BI (superseded by BJ)

- BI responds to user feedback that BH mostly works. Stat page1 retains mana regeneration/combat stats and now includes Flat damage guard; page3 labels each element simply Ice damage/Earth damage/etc, removes the Split values legend and adds Physical damage/Magical damage; page4 now contains Health regen with healing/movement rows. Preserve actual combat calculations, current penalty colors and same-row elemental physical/magical values where they differ.
- Armory BH archive inspection confirmed Forsaken slot labels were already in extended unit descriptions, including Germinas Boots/Jackboots and missing entries. BI also appends the explicit label to the basic utip hover title for all276 gear entries plus their276 missing placeholders, retaining the extended line. This addresses visibility in the stock hover header; it is not claimed that BH lacked object data. Only Armory utip/utub are changed on those original units; all other unit fields/hints/prices/order, item data boundaries, four Materia and world/import payloads remain intact.
- Add isolated Forsaken-carry.j and reverse native-variant-to-original raw mapping. Explicit native gear drags to hero quick slots use the original six-slot-compatible form, preserve charges/user data/item life (proficiency)/owner, reuse UnitDropItemSlot with the actual created handle and verify the requested slot. Failed addition/placement deletes only the replacement and restores the original (including previously equipped state); no UnitAddItemToSlotById. Mark explicit legacy carry handles in hash parent51 so the existing periodic native preparation honors occupied six-slot storage, while unmarked starting gear retains prior native preparation. Legacy gear picked up by Gaya receives the same marker; it survives transfer/job changes on the same handle. Putting that gear into the30-slot bag allows native preparation again. Mapped legacy items bypass the old one-item-per-type pickup restriction to allow carrying; native equip still runs the existing level/job restrictions. Legacy gear in quick slots retains its canonical active item effects; this experiment does not claim six-slot storage is inert.
- Gaya retains its original six slots and receives no backpack, gear abilities or panels. Native gear ground pickup orders for hero/Gaya convert to the compatible carry form and retarget pickup, without changing attack orders. Track same-owner give-item recipients through the existing Equipment trigger's order events; deferred dropped-item handling converts unowned native gear or gear held by the intended recipient. Already-owned gear without that recipient is left untouched so scripted job transfers are not rewritten. Busy guard prevents recursion; rejected/full recipient retains the one item on the ground, not deleted/duplicated. Existing sparse bag transfer/manual native equipping remain. No new trigger or canonical module edits; all changes stay in experiments/Forsaken/scratch/release/Forsaken.
- Validation: all build/editor/map/source gates,96 regressions,2,000 codec cases,51 experimental tests, archive/object isolation audit and installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Tests cover explicit carry persistence, native-to-legacy metadata and rejection, quick-slot/give/pickup order handling, Gaya marking, owned job-transfer exclusion, requested stat pages and552 Armory basic/extended tooltip-only boundaries. Exact AS classic fallback and CRLF JASS verified. First BI run was stopped before publication to retain native starting-gear preparation alongside explicit carry choices. Final scratch: build/ForsakenBI-557ox66h/FFERPG. Saving remains disabled; normal development AS; next BJ. Native acceptance pending: fresh BI game, all four stat pages, Armory Boots hover title/description, native equipped/bag gear dragged into an occupied/free hero quick slot, give to Gaya and back, Gaya ground pickup, full inventories, charges/proficiency/ownership, job changes and no item copies/losses.

## Separate experiment - Forsaken BH (superseded by BI)

- BH addresses BG native-test feedback only in experiments/Forsaken and release/Forsaken. Remove the Board button/manual preference; keep full scoreboard/title hiding during backpack or inspection and restoration after closing. Custom Inspect/Talents/X/More-stats callbacks now have a direct frame-only action on the existing TalentClick trigger, separate from unit/key access events. Elevate Inspect and Talents to frame level60; Inspect sits .024 above the top-right command button with a stock Far Sight icon. Find visible native frame contexts first. Anchor Talents inside the character panel's upper-right gold border and only reset its points when the anchor changes, rather than every0.1sec. Independent talent close/reopen and native backpack remain.
- Inspect is restricted to visible, non-hidden other heroes and members of the existing BossGroup; structures, houses, ordinary NPCs and shops excluded. Read-only boss/hero inspection does not grant abilities or mutate gear. Armory stock and missing-item hint unit tooltips now also receive the same Forsaken slot label as the276 gear items (552 unit tooltips); all other unit/item fields, original hints/order/costs/requirements, four Materia and canonical source/maps remain unchanged.
- Regeneration now has generated raw-ID metadata from the actual prepared map, including original/native equipment variants, authored ability values for every rank and audited inherited stock defaults in regen-defaults.json. Scan only active quick6/equipped9; direct GetUnitAbilityLevel reads current job/passive ranks even when native ability-handle enumeration omits them. Item raw-ID links include45HP/sec helmet A0OE, Sorcerer A033 rank11=60 and rank22=120MP/sec, and inherited A062=50% normal mana regeneration. Deduplicate item effects also exposed on the hero and strongest same-buff auras; bag items excluded. Existing map attribute coefficients and synchronized per-hero caches retained. This is passive regeneration, not net HP/MP change from damage, costs or instant healing; external aura sources and dynamic native field overrides are not reconstructed by the authored metadata.
- Consolidate each element into one damage-increased row; equal physical/magical values show one percentage, differing values show Physical/Magical in that same row with a legend (these are different combat calculations, not additive bonuses). Remove Staff/Rod/Inner Mana rows; rename Physical/Magical damage. Existing stat values turn red for Blind/Total Blind/Oil accuracy, Deprotect/Deshell effective defense, Imperil resistance tiers, Pain/Painra and Fog/Fogra damage, Slow cooldown/movement, healing-received penalty and evasion penalty. Blind halves the target-independent displayed accuracy rating; actual hit chance still depends on target evasion and combat's hit-margin thresholds. No extra debuff rows. Deprotect/Deshell and their auto forms multiply remaining damage by1.5, not raw armor/MagicDefense; effective defense percentages compose this multiplier, retain Protect/Shell/stronger versions' precedence and defense inversion. Raw ratings remain the actual raw ratings. Combat behavior is unchanged.
- Validation: all build/editor/map/source gates,96 regressions,2,000 codec cases,44 experimental tests, archive/object isolation audit and installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Tests cover missing native regen handles,45HP helmet,60/120MP Sorcerer, inherited mana ring, bag exclusion/item deduplication, existing toggles/read-only inspection,552 Armory tooltip-only changes and penalty/defense precedence. Exact AS classic fallback, CRLF JASS, world/NPC/imports preserved. Scratch: build/ForsakenBH-jfs5ejom/FFERPG. Saving remains disabled; normal development stays AS; next BI. Native acceptance pending: new BH game, Inspect only heroes/bosses, higher Inspect, upper-right working Talents toggle, automatic board hiding/restoration without Board button, Armory slot hints, live gear/passive regen, same-row red penalties and consolidated elemental rows.

## Separate experiment - Forsaken BG (superseded by BH)

- BF failed native testing: its UnitAddItemToSlotById path generated copies at the hero's feet when equipment was redirected into native storage rather than the requested quick slot. BG removes that native call from conversion. Create/track the actual replacement handle, preserve charges/userdata/item life/proficiency/owner, vacate the original and use UnitAddItem. Verify actual possession in quick6 OR native bag rather than trusting the return value or a requested slot. Accepted replacements delete the original; rejected replacements are always deleted and the original restored (or retained on ground). Mark each attempted original to avoid failed conversion retries; synchronous busy guard prevents pickup recursion. Native equipment variants already have iequ metadata for normal matching-slot highlights/manual equipping. No automatic UnitEquipItem. Existing bag variants/actually equipped items untouched. Preparation handles quick6 and original gear in native bag, runs on current-player-hero pickups plus the periodic scan for starting gear; Gaya/NPC inventories are not converted.
- Only the experimental object overlay adds Forsaken slot: Helm/Chest/Gloves/Boots/Ring/Weapon/Offhand/Trinket immediately after the Required level line (append if no such line exists). All276 original mapped gear tooltips and their copied native variants receive the label. Original iequ/abilities/requirements/rewards/prices and all other original fields remain intact; four Materia unchanged. Canonical sources/maps and exact AS classic fallback retain original descriptions and inventory behavior.
- Inspect moves from the middle of the world view to immediately above native command-card slot3 (top-right), with tooltip anchored to the button. Use the user's offered alternative instead of inserting a real ability into NPC/boss command cards. A local Talents toggle sits beside the native character backpack (or inspected inventory); Stats label on NPCs, toggles only the FF side panel, preserves native gear/bag and independent X. BE automatic opening on each native Backpack opening remains, toggle can reopen after X. No gameplay abilities granted to NPCs for inspection.
- Experimental Multiboard overlay owns local ForsakenBoardHidden/ForsakenBoardCovered state; TEquip adds TMultiboard dependency. Entire scoreboard, including minimized title, hides during native backpack or inspection display. Existing two-second refresh respects those flags so it cannot immediately force the title back. Restore after closing unless manually hidden. Board button at top-right is available outside those windows to toggle full hiding. UI preferences/events remain per-client; board contents/gameplay are unchanged. Existing NPC read-only stats/talents/inventory behavior and sparse job transfer retained.
- All build/editor/map/source gates,96 regressions,2,000 codec cases,38 experimental tests, archive audit and additional installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Regression covers100 consecutive scans accepting quick/bag or rejecting conversion with only one replacement created, rejection cleanup/original retention, state/proficiency/owner preservation, recursion guard, all276 tooltip/object-field boundaries, new toggle/open/close/persistent board preferences and existing inspection/bag/talent paths. Archive audit allows only requested gear tooltip changes on originals and verifies world/NPC/imports unchanged and classic exact AS; JASS CRLF. An unfinished BG attempt was stopped to include subsequent user UI requests. Native acceptance pending: fresh BG game with no copy pile; pickup/drag matching-slot highlight; manual equip/unequip; slot tooltips; job/bag positions; Inspect above top-right card cell; Talents/Stats toggle beside backpack; full title hiding/restoration/manual Board toggle. BF must not be used for further play. Saving remains disabled; normal development AS, next BH.

## Separate experiment - Forsaken BF (failed native testing; superseded by BG)

- BF removes Equip gear and its FFERPGEQUIP sync hook. Once each second, prepare only mapped original gear in the current player's six quick slots: replace it with its native equipment variant in the same slot without UnitEquipItem. Preserve charges, user data, item life/proficiency and item owner. Delete the original only after verifying the variant occupies the intended slot; failed placement restores the original or leaves it safely on the ground. Existing native variants, bag contents and equipped items are untouched. Native manual equipping needs no command/button; unequipping stays unequipped. Legacy -forsaken-equip remains an optional diagnostic only. Shared sparse bag/job transfer unchanged.
- Inspect now accepts any visible, non-hidden, non-deleted selected unit except the viewer's own current hero, including NPCs and bosses for solo tests. Changing selection/loss of visibility closes inspection. Native nine equipment slots and30 bag slots remain read only. Units without a backpack show their six ordinary inventory items in the first bag row and label the remainder No backpack; no abilities/bag/items are granted. Use GetUnitLevel for NPC level.
- NPC inspection refreshes the four stats pages and HP/MP/level summary every0.1sec using read-only queries. Hide FF talent buttons/links and state No FF job talents instead of borrowing owner/job data; restore controls on player-hero rendering. NPC base HP/MP regeneration reads native base fields and is explicitly labeled; no player regeneration cache or udg_MagicDefense is used. NPC magical damage uses native armor in canonical Damage.j, so show Native armor basis/reduction and explain attack/damage types/scripted effects can alter the result. NPC cooldown omits the player hero AGI denominator, retaining live Haste/Slow/gear modifiers. Existing resistance/block/element/healing rows expose applicable layers, not a guaranteed final damage result. Own/other current-player-hero stats and talents retain BE behavior. NPC UI reads no RNG, probes, gameplay mutation or shared regeneration scratch.
- All build/editor/map/source gates,96 regressions,2,000 codec cases,35 experiment tests, archive audit and extra installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Tests cover no equip UI/sync/auto-equip, exact quick slot conversion with state/proficiency/owner preservation, rejected conversion retaining original, NPC visibility/deleted guards, NPC six-slot hover inventory, own/player versus NPC stat isolation and cooldown, local refresh, read-only callbacks and existing bag/talent/access behavior. Original objects/world/NPC/imports intact; canonical AS unchanged, classic fallback exact AS, Gaya unchanged, saving blocked; experimental JASS CRLF. An unfinished first build was stopped and restarted to include item-life/proficiency preservation. Native acceptance pending: manually equip converted quick-slot gear, unequip stays empty, job/bag order/charges, solo NPC/boss inspect/icon/inventory/live stats and player inspection. Next BG.

## Separate experiment - Forsaken BE

- BD accepted in game. BE removes the recurring automatic conversion/equip call from the one-second inventory preparation; empty equipment slots stay empty. Existing -forsaken-equip remains explicit. Add Equip gear button shown beside the standard inventory while the owner's native Backpack is visible; sends FFERPGEQUIP sync to the existing TestEquip trigger, resolves only sender's own current hero. Converts original carried gear into native variants and equips accepted empty slots; existing native variants can be equipped by the normal gear UI. No unsolicited pickup/init equip. Shared job transfer still restores only actually equipped items; bag order/handles/charges unchanged.
- Own talents/stats automatically open on each native SimpleEquipmentPanel visibility rising edge, polled every0.1sec. B/command-card access also opens them; no longer guesses native state by toggling the custom window. Independent custom X hides only talents/stats and latches the current native opening, so polling does not instantly reopen it. Closing and reopening Backpack restores talents. Esc/selection close displays. Native visibility/control behavior needs in-game acceptance; native gear/bag remain authoritative.
- Selecting another player's visible current hero displays a portrait Inspect icon above standard inventory. Click opens a separate read-only equipment/backpack window alongside the existing twelve talents/four stats pages. Nine named equipment positions + thirty bag positions with actual icons and hovered item names/descriptions/charges. Name/job/level identify target. Inspect panel's X/Esc closes inspection; talent X leaves gear/bag view open. Native body model is not cloned; this is a separate read-only view. No other player's abilities/control/inventory modified.
- Local selection/inspection state controls UI only. Current-hero and visibility predicates exclude self/NPC/Gaya/inactive jobs/fog targets. Changing selection or losing target validity closes inspection. Target owner/job key drives talent state, borrowed skills, mastery and stat cache, refreshed each second. New inspection hides old talent/stats until target refresh, preventing stale self-details. Inspection disables talent buttons and click sender guard blocks purchases; sync still validates sender's own current hero. Manual equip UI refuses inspection requests. Talent focus reset is local/owned only. Item hover slots have no action events. Creates frames uniformly at startup, no local gameplay handles/objects/RNG/probes.
- All build/editor/source/map gates,96 regressions,2,000 codec cases,33 experiment tests, archive audit and extra installed3.0.1.24342 check_map PASS;0 new source/runtime differences. Original objects/world/NPC/imports intact; canonical AS unchanged, classic fallback exact AS, Gaya unchanged, saving blocked. JASS CRLF. First unpublished build stopped on local button colliding with native button type; renamed slotButton without relaxing checks. Native acceptance pending: unequip stays empty; native drag/manual Equip gear; talent close/reopen via B/mouse; second-player icon/gear/bag hover/stats/choices/read-only/selection/fog/job changes. Next BF.

## Separate experiment - Forsaken BD

- BC UI and sparse bag transfer accepted in game. BD removes STR/AGI/INT/maxHP/maxMP from the displayed stats. Wider .21 x .49 panel, .028 side insets, centered3x4 talent grid/title, inset close button;12 reusable rows and More stats cycles four local pages, retaining talent state.
- Combat: health/mana regeneration, Magic Defense raw/%, live armor and armor defense%, evasion/accuracy ratings, physical/magical block%, cooldown reduction%. Resistances: six elemental states, non-elemental, random absorption proc separately. Elements: six attack/spell bonus pairs including omni contribution. Other bonuses: physical/magic buffs, HP/MP healing buffs, healing received, Staff/healing/Rod/Inner Mana power, flat damage guard and movement speed.
- Copied read-only accuracy/evasion/element/proficiency queries are generated from canonical sources with an active ability lookup: current unit level first, else quick6/equipped9 item abilities; bag excluded. Random absorption roll deliberately removed from resistance query; separate15% row, no UI RNG/combat probes/stat mutations. Imperil displays one lower resistance tier. Block combines independent rolls as1-product(miss); includes Interceptor, Runic, Defend and Sword fallback; attacker bypass cannot be folded into a universal chance. Evasion/accuracy remain ratings, not standalone hit probabilities.
- Cooldown reduction mirrors Cooldown.j's AGI denominator, multiplicative gear .7/.8, Hastera .67 > Haste/Auto-Haste .75 > Slowra1.5 > Slow1.3. Refresh every second and on gear events; gear/passive/buff/HP/MP changes reflected. Skill exceptions/Pharmacology's specific base cooldown remain conditional. Armor uses map DefenseArmor0.02 and native live armor; negative armor exponential vulnerability. Per-player regen cache prevents local page clicks borrowing another player's last regen. HP/MP regeneration limits from BC remain.
- Bonuses show separate applicable layers, not one promised final damage/heal multiplier. Staff power includes proficiency/current mana/Mind Charge/Concentration; physical/magic buffs include bravery/faith/pain/fog, HP-dependent Focus/Adrenaline/Serenity/Spellbreaker, Night Might/Inner Fire/Oversoul where applicable. General HP/MP healing buffs and incoming Rejuvenation/Death Screech are separate. Target/position/skill/proc-specific effects are not represented as unconditional percentages. Existing item-ID/proc/save migration remains future work; no gameplay/equipment/talent/save mechanics changed.
- All build/editor/source/map gates,96 regressions,2,000 codec cases,26 experiment tests, archive audit and additional installed3.0.1.24342 check_map PASS;0 new source/runtime differences. Original ability/item fields/world/NPC/imports intact; classic fallback exact AS, canonical AS untouched, Gaya unchanged, saving disabled. Experimental JASS CRLF. Unpublished attempts were stopped on declaration order and incorrect native equipment-slot signature/type; corrected without relaxing checks. Native page controls/readability/live buff acceptance pending. Next BE.

## Separate experiment - Forsaken BC

- User confirmed BB preserves sparse bag positions. User rejected stat/talent display: mana regeneration stayed22 despite Sorcerer's60/120 aura; Magic Defense labels/values absent; native talent icons2x4 placeholders. Do not describe BB's custom UI as accepted. Keep its successful bag transfer unchanged.
- BC creates an independent normal-frame FF panel at startup; no dependency on native stat-row handles, mixed simple/normal anchors or an all-or-nothing native frame lookup. Hero receives only fBag/fGer/ASpc; no ASde/ATal assignment. Native equipment/body and30-slot bag remain. Existing unused preview object definitions stay dormant. Obsolete ForsakenPanels.fdf/toc imports removed; baseline import table preserved.
- B/command-button4 toggles FF panel with debounce; Esc/X closes FF panel, changing selected unit hides it. -forsaken-panels provides an independent fallback if stock mouse-frame event forwarding fails. A native EquipmentPanelBackdrop found across contexts supplies alignment; otherwise fixed screen anchor. All presentation state local. Native B/mouse/key positioning and closing require play-test.
- Nine live FF labels: Strength, Agility, Intelligence, max HP/MP, health/mana regeneration, Magic Defense/raw + %. Regeneration reads live passive and active item ability levels/fields. Base plus attributes use map IntRegenBonus0.04/default StrRegenBonus0.05; Arel flatHP, AIrm/AIrn mana%, AHab/AUau auraamount/flatpercent flags, strongest own same-buff aura once. Scan hero non-item abilities plus6 active slots/9 equipped positions, excluding bag and duplicate unit/item enumeration. Sorcerer A033/Hab1 rank11=>60, rank22=>120 during Burst, added to intrinsic/gear regen. No gameplay regen changed. Instant restoration, scripted heal-over-time ticks and nearby external auras are not modeled; no claim of full combat-stat migration.
- Preserve BB equipped-variant MagicDefense helper and exact formula100*defense/(defense+50), canonical shield priority and shared calc-context restoration. Raw100=>66.67%. No native resistance stacking.
- Twelve own buttons3 columns x4 rows. Canonical A02F ranks1/2/3/4 unlock Normal/Master/Ultimate/Legendary rows. One choice per row; immediate parent required (G needs C). Row1 starts available, then one additional choice per mastery tier. Sync validation rejects wrong job, duplicate/same-row alternative, missing parent and locked rank; local visuals reflect per-player/job state. No actual skills, stats, elements or save-format changes.
- All gates,96 regressions,2,000 codec cases,20 experiment tests, final archive audit and extra installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Original objects/world/NPC/imports intact, classic exact AS. Scratch build/ForsakenBC-pu1xpnba/FFERPG. First unpublished BC-ekunknmk failed reserved JASS identifiers effect/buff; renamed regenAbility/buffId, no compiler/check relaxation. Experimental JASS CRLF retained.
- Native acceptance pending: B opens native gear/bag + FF3x4 panel and9 labels; position/readability, mouse B and Esc/X; Sorcerer normal/Burst changes after passive sync/1sec refresh; active/bag gear; Absorber defense/%; mastery rows/one choice/G parent; jobs/players, no real bonuses. Bag/Gaya/normal AS behavior preserved. Save export remains blocked.

## Separate experiment - Forsaken BB

- User confirmed BA working. Preserve exact30-slot bag positions across jobs, including gaps: snapshot source, move real handles in ascending slots, fill gaps with temporary fGap items (no abilities/charges/use), then remove only spacers. Existing destination-AInv suspension/restoration, quick-slot distinction, all9 equipped slots, charges and failed-add ground fallback retained. Gaya still has no native bag/panels.
- Add FF Magic Defense/raw and Magic Defense % text overlays to native ASde rows (replace Ability Vamp % and Magic Resistance display only). Import ForsakenPanels.fdf/toc with war3map.imp entries so editor saves retain them. Percentage uses the actual Damage.j layer: defense/(defense+50)*100; total100=>66.67%. Absorber contributes100 plus Intelligence/upgrades/other gear. Do not set native resistance modifiers, which would add a second damage-reduction layer.
- Isolated MagicDefense overlay checks original six-slot item IDs and equipped native variants, excluding unequipped bag variants. Preserve original calculation/priority, including the shield elseif chain. Build initialization belongs inside Register_Forsaken_Equipment; do not add statements to existing RegisterTriggers_MagicDefense (first attempt failed strict startup comparison). Preserve udg_CurrentHero/udg_StatCalcValue around periodic refresh. Other item-ID/proc/Armory migration remains pending.
- Replace six-cell preview with native ATal shell plus custom4x3 path buttons. Paths A-D-H-K / B-F-I-L / C-G-J-M; immediate parent required,1 point each,4 preview points per player/job. Sync validated purchases, no duplicate/wrong-job/overspending/cross-player grants. State persists only in match across job changes. Uses first3 job/borrowed icons; purchased green, available gold, locked dim. Empty native tier lists prevent native purchases. No real abilities/stats/upgrades/save fields granted; real talents are future design.
- All changes isolated in experiments/Forsaken and scratch Job/MagicDefense/Equip overlays. Native data2, ability-only Backpack/B and disabled saving retained; normal AS/src intact, classic fallback exact AS.
- Native acceptance needed: sparse bag gaps/order/charges across jobs and back; own-hero Magic Defense raw/% changes when equipping Absorber and falls when removed; bagged equipment gives no defense; talent4x3 render within native shell, G rejects before C, three paths/four points/duplicate protection, job and player isolation; closing Backpack hides overlay. No automated test claims native UI rendering.
- Validation: all build/map/editor/source gates,96 regressions,2,000 codec cases,18 experiment tests and final archive audit PASS;0 new source/runtime differences. Additional final check_map against freshly extracted installed3.0.1.24342 common.j/blizzard.j PASS, startup1508 triggers/no independent reorder. Original objects/world/NPC payloads preserved, UI import entries retained, classic exact AS. Scratch build/ForsakenBB-2qswbikv/FFERPG. First unpublished attempt build/ForsakenBB-inqj2kfm failed startup-order check; corrected without relaxing contracts. Native UI acceptance pending.

## Separate experiment - Forsaken BA

- User accepted AZ gear transfer/automatic slotting, but Greater Nectar moved from the30-slot bag to quick inventory on job change. UnitAddItem uses free quick slots first. Move the shared transfer hook after the destination's six slots are cleared and before canonical saved-item restoration. Disable only that empty destination's stock AInv during native transfer; restore its level/permanence before quick items return. Never disable the source's quick inventory. Snapshot bag items, move in source order, clear temporary references; retain equipped gear/charges and failed-add ground fallback.
- User requested stat/talent panels, selected FF job/mastery, and clarified only the visual preview matters; functional elemental upgrade paths are future work. Add fSta/ASde with installed default17 stat modifiers. Add8 player-specific ATal preview trees, each2 rows of3 cosmetic Aamk cells with all attribute bonuses0. Icons/descriptions/current ranks reflect existing5 job skills + Mastery; Freelancer uses4 borrowed skills, future-path cell + Mastery. Sync cosmetic learned indicators; update tooltip presentation locally. Never learn/upgrade actual skills or grant new talent points.
- Native stat panel reports engine modifiers; FF scripted crit/damage calculations remain independent and are not claimed as fully reflected. Talent clicks can only affect cosmetic zero-bonus indicators; existing job/mastery progression remains authoritative.
- Per user request, Gaya keeps canonical six-slot inventory: no native bag/panels supplied. Hero Backpack remains ASpc/B ability only. Saving disabled, canonical src/AS pair intact, exact AS classic fallback.
- Builder declares stock AInv with an empty modification record so new direct calls pass strict typed-reference checks; no contract relaxation or stock behavior changes. Source and panel object data remain isolated in experiments/Forsaken.
- Build/check results in STAGES. Native acceptance: Nectar remains bagged across jobs/back; quick items stay quick, charges/order retained, full30 bag/both rings, Gaya has no bag, stat/talent panels render and follow jobs, preview does not grant real skills/bonuses, multiplayer.
- Validation: all build/map/editor/source gates,96 regressions,2,000 codec cases,14 experiment tests and final archive/object audit PASS;0 new source/runtime differences. Original ability/item fields/world/NPC payloads preserved, stock AInv empty declaration, native panel bases/zero-bonus cells verified; classic exact AS. Scratch: build/ForsakenBA-x1dx47oq/FFERPG. Earlier BA-ey2p1j5m failed strict stock-AInv reference checks before declaration; no release from that attempt.

## Separate experiment - Forsaken AZ

- User confirmed AY native panel and -forsaken-equip work. AZ removes the physical Backpack object/supply; ASpc remains visible at0,1 with B hotkey, and fBag/fGer remain direct permanent hero abilities.
- Automatic one-second scan fills empty matching native slots from mapped original items in visible inventory/bag. Both ring slots supported; occupied slots never automatically replaced. Retain AY's accepted/equipped/IsItemEquipped checks before deleting originals; failed conversions retain charges/ownership and original items.
- Separate Forsaken-job.j and builder Job overlay capture the previous hero before the canonical change. After existing six-slot transfer and before stat recalculation, move equipped gear (all9 slots) then bag contents backwards using the same item handles. Enable native abilities on the new job immediately. Charges use canonical zero-during-transfer convention. Failed additions leave the item beside the current hero with a message, never delete it. No cyclic Equip/Job dependency.
- Register_Forsaken_TestEquip is now a separate startup registration helper; optional manual rescan and -forsaken diagnostic remain. Saving blocked, Forsaken data2 and exact AS classic fallback retained. Source overlays only; canonical src/release AS untouched.
- Validation/build results recorded in STAGES. Native AZ acceptance pending: automatic slots/bonuses, full bag and both rings across jobs and back, ability-only access, two-player separation and NPC gear. Remaining item-ID/proc/Armory/save migration is in experiments/Forsaken/README.md.
- Scratch source: build/ForsakenAZ-stqnkwnu/FFERPG.
- Validation: all build/map/editor/source gates,96 regressions,2,000 codec cases and11 experiment tests PASS (including full30-slot bag, both rings, job round trip and other-player isolation). Complete source/runtime agreement has0 new differences; both new triggers explicitly registered. Final preservation audit: only script/editor text, abilities/items and expansion selector differ; original item fields/world/NPC payloads retained, physical Backpack absent, classic byte-identical AS.

## Separate experiment - Forsaken AY

- AX user test: Backpack missing and carried items disappeared without stats. Confirmed code defects: conversion deleted originals after bag acceptance without equipping; periodic Backpack supply searched only six slots, while UnitAddItem may place it in the bag; stock ASpc button was hidden by the earlier abpy=-11 override.
- AY stops automatic conversion and restores canonical pickup restrictions for original items. Visible ASpc Backpack button at0,1 with B hotkey; physical fBpk carries only ASpc, direct hero abilities supply storage/equipment. Supply uses UnitAddItemToSlotById for an empty visible slot, checks both visible inventory and bag, and never overwrites gear. Full visible inventory waits; command button remains available.
- Explicit -forsaken-equip converts mapped originals in both visible inventory and bag. Remove original only when UnitAddItem AND UnitEquipItem succeed and IsItemEquipped confirms it remains equipped after restrictions; otherwise delete replacement and retain original charges/owner/stats. New chat trigger gg_trg_Forsaken_TestEquip explicitly allowed.
- Saving blocked, Forsaken data2 retained, classic exact AS. Native panel/active bonuses still need user testing; this is the experiment, not normal progression. Tests/build status in STAGES.
- Validation: all gates,96 regressions,2,000 codec cases,8 experiment tests PASS. Extra execution audit confirms manual chat registered for8 players. Native controller visibility/expansion2 and world/NPC preservation audited. Scratch build/ForsakenAY-ry_o2gzc/FFERPG.

## Separate experiment - Forsaken AX

- AW native test FAILED: capacity0, direct fBag/fGer/ASpc all0, legacy AInv1. Investigation found AS and every earlier experimental map still use war3map.w3i Game Data Version1 (Frozen Throne). Installed new ability records have version2; editor strings identify expansion2 as Forsaken Kingdom.
- AX changes only that four-byte expansion selector to2 in map info. Format39 has extra race-HUD and height-fog fields; explicit version-aware parsing preserves all other metadata bytes. This is separate from Game Data Set and installed executable version. Earlier builds missed this prerequisite.
- Object preparation now always enables expansion2 for Forsaken modern maps; manifest records it. Regression verifies selector1->2 and all surrounding bytes identical. Existing original item bases were audited against installed stock data: none inherit native equipment types; source has no stock ChooseRandomItem/ChooseRandomCreep calls, using explicit drop lists.
- AW direct native setup, Backpack item, variants, legacy AInv retention and save blocking retained. Normal AS and byte-identical classic fallback remain Frozen Throne/current behavior.
- Final checks in STAGES; native Backpack click/bag capacity still needs acceptance.
- Validation: all gates,96 regressions,2,000 codec cases,6 experiment tests PASS. Final AX vs AW audit confirms only map expansion selector and diagnostic stage text changed; object/world/NPC payloads identical. Scratch build/ForsakenAX-nmj40hbx/FFERPG.

## Separate experiment - Forsaken AW

- AV user test FAILED: Backpack visible in slot1, capacity0, queried hero levels fBgi/fGer/ASpc all0, clicking did not open UI. GetUnitAbilityLevel on a holder is not a reliable proof about item-attached abilities; zero native capacity is the confirmed failure.
- AW bypasses item attachment by giving the player hero fBag, fGer and stock ASpc directly/permanently. fGer is a unit ability (aite0); Backpack remains present. Original stock ASpc receives a name/icon and hidden command-card position to keep existing job buttons. Its native behavior is unchanged.
- Diagnostic reports direct hero ability levels and stock AInv legacy level. Legacy inventory/item definitions are retained; no inventory-removal experiment or global NPC changes. Conversion still waits for native bag capacity and successful variant acceptance.
- Release/check results in STAGES. Normal AS and exact AS classic fallback retained; saving blocked in modern experiment. Native acceptance pending.
- Validation: full gates,96 regressions,2,000 codec cases,6 experiment tests PASS. Scratch build/ForsakenAW-d1e4ofp7/FFERPG. Native Backpack click and direct ability levels need user testing.

## Separate experiment - Forsaken AV

- AU user test restored original items/NPC gear, but Backpack click did not open the panel; diagnostic showed backpack=1, bag capacity=0. Do not treat AU's native UI as accepted.
- AV adds explicit custom item abilities fBgi (AIni) and fGer (AEqu). Installed 3.0 AbilityMetaData defines inv6/equ1 as Data F (pointer6); AV writes level1 bag capacity30 and equipment level threshold0 instead of relying on inherited stock defaults. Backpack carries fBgi,fGer,ASpc to include the native interface controller. Gaya uses the explicitly configured fBag.
- This is a candidate correction, not a reproduced in-game fix. Native acceptance must confirm clicking Backpack opens the equipment/bag panel. The -forsaken diagnostic includes custom bag/gear and ASpc ability levels plus bag capacity.
- Original items/NPCs, isolated variant conversion, save blocking and exact AS classic fallback retained. Full build results in STAGES; normal development remains AS.
- Validation: full build gates,96 regressions,2,000 codec cases and5 experiment tests PASS. Scratch source: build/ForsakenAV-rp5wnkdm/FFERPG. Native play-test pending.

## Separate experiment - Forsaken AU

- User play-test rejected AT: no backpack controls and map-wide NPC/hero gear dropped. Global changes to existing equipment item types were unsafe for legacy inventories; adding the native abilities directly did not expose usable UI in that test.
- AU preserves every original item definition and adds276 native equipment variants plus a visible fBpk Backpack based on stock ebac with AIni,AEqu. Hero gets the item once there is a free six-slot slot; click it to open the native UI. Gaya gets stock AInx. `-forsaken` reports Backpack slot/native bag capacity for diagnosis.
- Only the player's hero's carried mapped gear converts, after native bag capacity is available. Variant must be accepted before deleting original; charges/ownership retained. NPC/preplaced item definitions stay untouched. Existing equip level/mastery checks retained.
- Pair under release/Forsaken/ with basename FFERPG_0.9.7.3-r16-ForsakenAU.w3x; classic fallback remains exact AS classic. Test line only, saving still blocked. New variants do not yet map back to Armory or other item-ID-based features; migration remains necessary.
- Source/builder/tests remain isolated in experiments/Forsaken. Build/native acceptance status is recorded in STAGES; automated compilation does not prove native UI rendering. Test visible Backpack click, NPC gear retention, conversion/full-bag failure and native slots. Normal development stays AS.
- AU validation: full build gates,96 regressions,2,000 codec cases and5 experiment tests PASS. Every existing item object and NPC/unit/terrain/region payload retained exactly; classic fallback byte-identical to AS. Native acceptance still pending. Generated source tree: build/ForsakenAU-riidd9k2/FFERPG.

## Separate experiment - Forsaken AT

- User requested the actual 3.0 native bag/loadout, with Armory gear assigned to its slots, and explicitly asked to keep these maps in a separate `Forsaken` release folder.
- Reforged test: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenAT.w3x`. Classic fallback: same basename under `release/Forsaken/1.29.2/`, byte-identical to the working AS classic map. Do not downgrade this native test using the regular shortcut.
- Reproducible isolated source overlay/build/tests: `experiments/Forsaken/`. Canonical `src` and ordinary releases remain unchanged; generated source tree under `build/ForsakenAT-y4rpudog/FFERPG`.
- 276 Armory gear objects receive native `iequ` slot types; four Materia remain inventory items. Add native-based fBag/fGer abilities; heroes receive both, Gaya gets the bag. Equip event runs existing level/mastery gates. Mapping is in `release/Forsaken/gear-slots-AT.json`.
- This is a UI/basic-equipment preview. Save/savef/autosave/New Game exports are blocked by replacing trigger actions, with a message; existing serializers/readers/Armory indexes remain unchanged. Expanded inventory saving, item procs/queries, crafting/quests/transfers/job changes and Ninja dual-wield migration are still required before progression play. See the experiment README.
- Full Reforged gates,96 regressions,2,000 codec cases and4 experiment tests PASS. No native in-game acceptance yet; verify actual UI, slotting/bonuses, unequipping, restrictions, Gaya, hero recreation and multiplayer. Classic fallback hash equality verified.

## Current development build - AS

- Pair: release/FFERPG_0.9.7.3-r16-stageAS.w3x and release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x.
- Base is the user's World Editor saved AR from Documents/Warcraft III/Maps/Download/TEST. It already contains both new regions and compiled Travel entries; the earlier stale-script diagnosis does not apply to that saved copy.
- Editor save produced 557 source/runtime differences from JassHelper transformations. Integration preserves editor terrain/regions/units and generated map functions, retaining checked AR library bodies before syncing Travel/Warp. No historical-difference contracts were relaxed.
- World Editor split unit/item display fields into skin files, omitted default-valued fields and externalized tooltips into WTS. The build copies missing skin fields into the main unit/item tables, restores omitted AR defaults and resolves WTS text there; skins and original editor input retained.
- Shipyard region bounds: (3040,-5984) to (3328,-5696). ArenaDarkness: (26176,-24608) to (26496,-24320).
- Append Shipyard and Arena of Darkness at indexes12/13; original indexes1..11 stay fixed, including Ice Realm9 and Elysium11.
- Warp entry selects GetTriggeringRegion instead of rechecking IsUnitInRegion. This avoids dependence on membership timing at the entry boundary; the reported native failure is not yet reproduced or confirmed fixed.
- Hero-only entry, shared per-game unlock, one effect per destination and menu behavior retained. Test both new destinations in game, including ordinary walking, repeat visits, both clients and multiplayer.
- Validation: all Reforged build gates,classic check_map,96 regressions and2,000 codec cases PASS; source/runtime agreement has0 new differences. Final editor preservation audit PASS: only script/editor text and normalized unit/item tables differ; region placements and all other named payloads retained.
- New source regressions exercise stale membership, repeat visits and fixed destination indexes. For future incremental builds use AS or another map containing these regions; the original baseline lacks them.

## Current development build - AQ

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAQ.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAQ.w3x (AE Bazaar UI).
- Chronicle category buttons now show only their names; unlocked/maximum counters remain in the descriptions.
- Secrets and its Keg Hunter entry are hidden until title59 is completed. Keg Hunter displays the standard green title and rare-drop effect wording.
- Next page uses a navigation icon and has no category preview description.
- Next page now uses `ReplaceableTextures\\CommandButtons\\BTNMove.blp`, the standard move-arrow icon.
- Full gates,94 regressions,2,000 codec cases,classic check_map and preservation PASS;1508 startup triggers,0 independent reorder.
- Elysium report remains under investigation: the east rainbow bridge is `gg_dest_DTsb_0068`, hidden during preparation and shown when Andre's reveal completes. Confirm whether the failure occurs in a fresh game after the reveal or only after loading.

## Current development build - AP

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAP.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAP.w3x (AE Bazaar UI).
- Chronicles: first10 categories + Next page; nested page2 has Time Trial and Secrets; Secrets
  contains Keg Hunter. Additive abilities cPg2/cSec/cKeg, distinct spellbook orders. Only existing
  A0AR spell list and A10C button position changed. Each category shows unlocked titles / maximum,
  including root total63. Count force membership rather than internal weighted ability levels.
  Local tooltip update1sec; synchronized pickup/inventory paths own progression.
- Keg Hunter: collect all10 books one at a time with your own hero/Gaya in one game. Duplicates,
  other units/players and rejected pickups do not count. Completion grants title59; partial
  progress stays in this game per user choice. Existing dedicated title59 save bit already read/
  written: no serializer, field, contract or inventory index changes. Restores after load/Gaya
  recreation. Full title applies all monograph bonuses without inventory space; no stacking.
- Regional books already worked on hero OR Gaya. Shared Loot predicate adds earned title59 and
  zone0 for Knight's previously excluded ordinary-loot effect. Preserve drop tables/chances,
  charged/powerup/Spider Leg rules, hero-kill restriction and essence region1..8 behavior.
  Detailed effects/region table in docs/CHRONICLES.md.
- User also reports Bazaar will not reopen after closing once. Recipe entry now explicitly
  removed/re-added at full stock after each purchase, preventing exhausted stock from blocking
  reopening. UI/session/crafting code unchanged. Source regression opens/closes3 times and
  rejects old Close packets; in-game cause/fix acceptance still needs confirmation.
- Full gates,93 regressions,2,000 codec cases,classic check_map and scoped preservation PASS.
  New pickup trigger allowed explicitly;1508 startup triggers, no existing pair reorder.
  Objects/items/recipes/quests/rewards/save format outside requested changes unchanged.
- Test native nested page navigation/Cancel and counters in both clients, sequential10 books,
  two-player isolation, completion save/load/recreation, Knight/regional loot and repeated Bazaar
  reopening from hero/Gaya/shops. Multiplayer and World Editor Save As remain unconfirmed.
  AO blue-girl timing and concurrent hunts still need user confirmation. AN/AM retained.
- Next incremental: .\build.ps1 -Stage AQ -Base release/FFERPG_0.9.7.3-r16-stageAP.w3x.
  Fresh objects/build: docs/BUILDS.md. Chronicle implementation: Titles/Loot/GameLoad/Gaya_Shared.

## Previous development build - AO

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAO.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAO.w3x (AE Bazaar UI).
- Completing Kollin's opening Arachnophobia conversation schedules Harpy Hunt availability
  two seconds later. Spider completion still unlocks Thextera only; both hunts can run together.
  Caroline: "Hello. Since you're helping Kollin, could you help me too?" Her next line drops
  "As such,". Hunt targets, 15/20 counts, rewards, logs and rare hunts are unchanged.
- Blue girl: AN source AND compiled map already had a 300-second timer on all three town visits.
  User saw her at about15:10 and absent by17:20 before talking. Early removal was not reproduced.
  Her object inherits Archer movement; AO pauses her and sets propulsion window0 on each spawn,
  preventing her walking away (including after cinematics unpause units). This is a stationarity
  safeguard, not a confirmed diagnosis of that report. Existing300-second timer, spawn chance,
  dialogue, conversation exits, gifts and ending sequence remain unchanged.
- Full gates,84 regressions,2,000 codec cases,classic check_map and scoped preservation pass.
  No objects/save serializers/startup or other modules changed. Prior AN/AM features retained.
- Test: talk to Kollin, visit Caroline before killing15 spiders; run both hunts concurrently,
  verify separate counters/rewards and rare hunts. With cinematics on/off, verify her introduction.
  Blue girl should stay at her town spawn from appearance until five minutes later when untouched;
  approach/select her during that window and check normal conversation/gift. Test with intervening
  cinematics, both clients and multiplayer. Her reported early disappearance still needs play-test.
- Next incremental: .\build.ps1 -Stage AP -Base release/FFERPG_0.9.7.3-r16-stageAO.w3x.

## Previous development build - AN

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAN.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAN.w3x.
  Classic retains AE Bazaar presentation. Develop from the Reforged map.
- Seven active chocobo foods appended at inventory indexes 352..358: Pram Nut/I045,
  Luchil Nut/I07F, Carob Nut/I07G, Zeio Nut/I07H, Gysahl Greens/I027,
  Mimett Greens/I07Q and Silkis Greens/I0KE. Charged classification recorded; quantities saved.
  BP/bazaar purchase proxies, information items and unused OLD greens remain unsavable.
- ItemAllowed checks udg_SpeedrunMode, not difficulty. All other modes/difficulties allow the
  seven items. Inventory save count and payload both skip food in Speedrun; load consumes its
  charge bits and discards it through the existing rejection path. Other inventory still loads.
  Shared inventory functions cover hero, house, Gaya and other serialized inventory containers;
  manual/autosaving use the same mode check. Ownership and legacy F rejection retained.
- Old 351 inventory IDs, jobs, fields and existing G/H fixtures unchanged; SaveFlagCount now358.
  No new armory flag/proxy: counter stays280. AM's four appended materia bits retain their order;
  its helper already places future inventory indexes after them. No object/ability/item edits.
- Only Save_EncodeInventory and Cmd LoadInventory gain mode predicates. Separate reviewed
  tools/contracts/chocobo-food-save-extension.json pins exact body/helper hashes and appended
  item/charge mappings. Original compatibility contract and AM extension remain unchanged.
  Reverse only mode predicates to recover original serializer fingerprints. Older saves remain valid.
  New saves containing food need AN+ to restore it outside Speedrun.
- Full gates, 82 regressions, 2,000 codec cases, classic compile/check_map and scoped preservation
  pass. Original objects/rewards/Bazaar/travel/Gaya behavior and other modules unchanged.
  Tests execute actual source across every difficulty, all seven quantities, skipped-item alignment,
  mixed/all-food inventories, ownership, legacy rejection and reviewed-policy refusal.
- AM Materia storage/hints/N / 280 and earlier UI/Gaya/dev changes retained; no new in-game
  confirmation has been reported. Test each food quantity outside Speedrun, then load the same
  mixed inventory into Speedrun: food absent, other items/quantities correct. Test Speedrun saves
  omit food, hero/house/Gaya, old codes, both clients/multiplayer and World Editor Save As.
- Incremental: .\build.ps1 -Stage AP -Base release/FFERPG_0.9.7.3-r16-stageAO.w3x.
  Fresh clone workflow: docs/ARMORY.md / BAZAAR.md. Food policy: docs/SAVE_CODES.md.

Git attribution: the user requested all repository history and future commits use Slithe with
338753050+Slithe11964@users.noreply.github.com. Historical comparison references were updated after
rewriting author/committer metadata; all 47 tests pass. The original history bundle is kept outside
this repository in ../_archive/FFERPG-before-slithe-attribution-2026-10-06/. Map bytes are unchanged.

## Confirmed public baseline

- **Develop/edit:** baseline/Reforged/FFERPG_0.9.7.3-r16.w3x.
- **Play in 1.29.2 or Reforged:** baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x.
- baseline/manifest.json records hashes and provenance. build-config.json pins the development
  master. Both maps are tracked; generated release builds are ignored.

The user chose the parent-folder r16 as the starting point, then agreed to carry its edits into the
Reforged master and generate the matching classic copy. That input was already classic format.
Its substantive differences from Y were quest-log GUI/text and pathing; object field values were
unchanged. Most script differences came from JassHelper inlining. Z carries the quest-log/pathing
edits and complete object data into W's repaired editor layout, retaining the latest user-authored
Intro.j welcome wording. No new gameplay, dialogue or reward changes were made.

All 93 quests use QuestEngine. S is user-confirmed working. Later safeguards, V shared-context
cleanup and W editor pairing remain included. Bugs remain deferred by user request. The Chemist/
Ninja passive-art fix remains; Gaya selection settings are preserved. Flying Gaya/crow lines are
the client's Air-to-Ground Indicators, independent of conversion.

## Workflow

```powershell
.\build.ps1 -Stage AQ -Base release/FFERPG_0.9.7.3-r16-stageAP.w3x
```

The builder selects changed enabled modules, syncs, normalizes pairing, orders libraries, runs
all map/source/quest/content/save checks, regressions and codec tests, then adds the header and
publishes new files without overwrite. Use -Base with the newest reviewed Reforged build for
incremental work. World Editor edits: enable JassHelper/vJass, Save As a new file, check it,
export/review source changes, then convert that saved file:

```powershell
.\make_129.ps1 -Map release/<editor-saved-map>.w3x
```

The converter uses the tracked classic baseline for map-info template/missing object defaults,
compiles the runtime against 1.29.2, preserves editor files and outputs the same basename under
release/1.29.2/. The local batch accepts the same arguments. Bazaar frame UI is converted to the AE dialog
in both runtime and editor source. No sibling toolkit/r7 dependency.

Keep .j sources CRLF; comment calculations only when non-trivial. Preserve behavior/dialogue/
rewards unless requested. Record builds in STAGES.md and update this handoff and local parent
RESUME_PROMPT.txt. Commit relevant changes. Read BUILDS.md before resolving source/runtime failures:
exact historical contracts are intentional; never regenerate them to silence new differences.

## Verification and pending tests

Z passes all gates and 2,000 codec cases. Packaging has 47 passing regression tests. Both editor
formats round-trip byte-exact with valid pairing. The classic baseline compiles for 1.29.2 and
passes check_map against the master: 1,503 startup triggers, no reorder. Selected r16 quest-log
GUI actions/pathing are preserved in both; object files/WTS are byte-identical in the Reforged
master. Classic runtime exactly matches the converter transform of the master.

The user confirms both paired maps are working great on 2026-10-06. This is the confirmed
development starting point for Reforged and 1.29.2. Specific multiplayer/save-load/cinematic coverage
was not itemized. A separate editor Save As was not explicitly confirmed. Test each future change
in both clients and use QUEST_TESTS.md for focused content.

GitHub readiness checked: baseline pair, sources, toolchain, contracts, fixtures and guides are
tracked. The local downgrade_129.bat/make_129.ps1 and every conversion dependency are included.
No MapToolkit installation or parent-folder r7 map is needed. Use Python 3; JassHelper/World Editor
are external requirements for editor saves. Historical source regressions require full Git history.

## Repository and archive

Keep baseline/, src/, tools/, docs/, wrappers and release/ for future outputs. Retain contracts,
fixtures, PHASE16.md/handoff CSV, system/content guides and source/object references. Historical
auditors remain: current regressions depend on the V auditor and Git history.

Old stages, reports, obsolete surveys/readability plan and scratch files are preserved at
`../_archive/FFERPG-before-r16-baseline-2026-10-06/`, including the original user r16, previous docs,
pre-cleanup diff and eleven already-deleted reports recovered from Git. The paired baseline/source repository is now published under Slithe11964.
Next: play-test AC, then requested content; bugs remain deferred.

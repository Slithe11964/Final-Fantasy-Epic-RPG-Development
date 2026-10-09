# Durable save system implementation plan

Status: identity foundation, detached legacy decoder, logical progression profile,
reference migration/equality reports, isolated JASS codec, life/native staging,
item journal, prepared abilities, storage/equipment placement and original-item
quarantine/recovery, bounded live progression journal, original hero recovery,
session choices/accepted-code recovery and owned replacement-unit staging
implemented, 2026-10-09. Runtime saving remains
blocked in Forsaken. Public baseline Z, shared development AS, experimental BT
(`fa6ed31`) remain unchanged. BU is now a private live inventory/codec diagnostic,
documented in [SAVE_ENGINE_TEST.md](SAVE_ENGINE_TEST.md); BV is next. Full character
save/load is not yet enabled.
Reapply with [FORSAKEN_REAPPLICATION.md](FORSAKEN_REAPPLICATION.md).

## Decisions and release boundary

Maintain one shared logical progression model with inventory adapters. Develop
the new format in the isolated Forsaken experiment first; promote reviewed shared
pieces at deliberate checkpoints. Do not simply re-enable Save_WriteCode.
Public Forsaken requires verified legacy migration and a full native inventory
round trip. Updated classic 1.29.2 support is a subsequent explicit milestone.
Older published maps cannot be expected to read expanded saves.
User decisions: normal quantities need not exceed120; retain seven-bit quantity
fields and preserve imported121..127. New Game Minus is retired from the
replacement system; keep existing-code decoding, but no new Minus export/command.
Cooldowns are per-game and never serialized. User explicitly permits refreshed
cooldowns on new-game load/character changes, including rollback after a failed
change. Cooldown equality is not a restoration acceptance gate.
User skill decision (2026-10-09): normal jobs below level50 reset learned skills
and refund available skill points on successful load. At mastery (level50+),
four regular skills are rank11 and the ultimate rank6. Failed-load recovery still
restores original per-game choices/points. These are load defaults, not durable
per-skill allocations. Freelancer/Gaya policy is handled separately.
Gaya support/chant unit plans and separate research/availability targets now
resolve through [SAVE_GAYA_POLICY.md](SAVE_GAYA_POLICY.md); player application
and remaining derived effects still require the synchronized controller.
The staged H02L Freelancer level/mastery/attribute plan is now resolved in
[SAVE_FREELANCER_POLICY.md](SAVE_FREELANCER_POLICY.md), with fresh borrowed-choice
targets. Other variants and all player target application remain pending.
The narrow Gaya purchase/skill-choice target now applies and recovers through
[SAVE_PLAYER_TARGET.md](SAVE_PLAYER_TARGET.md). Broader player state, ability
availability verification and the complete controller remain pending.
Future level requirement (2026-10-09): allow a later cap150, with save-format
headroom for999. Separate actual level from mastery tier in a new reviewed job
schema; migrate the existing value100 sentinel to native level99/tier4 instead
of changing its meaning. Engine/cap/XP/growth/transport acceptance remains required.

Keep E/F and G/H meanings, item eligibility, account/owner restrictions, difficulty,
Speedrun and Hardcore rules, load window/once-per-game rules, jobs/mastery,
Freelancer/Gaya abilities, upgrades, title/Chronicle flags, Armory, currencies,
New Game parity/level, Speedrun level, Miracle stage, fragments and Guardian state.
Completed Keg Hunter is already title59. Partial monographs remain unsaved.
All talent choices are per-game only; mastery determines available rows on load.
Do not infer that every quest or Chronicle is currently saved: inventory the
writer/reader's actual fields and preserve precisely those semantics first.

Future items/jobs/quests/Chronicles/eras/checkpoints receive permanent IDs with
separate namespaces. Tombstone retired IDs; never recycle or derive them from
rawcodes, array order, display text or runtime quest indexes. Era/checkpoint load
locations resolve through a reviewed safe-town fallback when unavailable; no
terrain, time-travel or content expansion is part of this work.

## Audited constraints and remaining measurements

| Evidence | Current behavior | Required change |
|---|---|---|
| Save_EncodeInventory / Cmd LoadInventory | Count 3 bits; six slots per holder; item 9 bits; charged quantity 7 bits | Explicit sparse positions and canonical item IDs; keep seven-bit quantities, gameplay limit120 |
| Armory.j / compatibility contracts | 358 inventory IDs; legacy practical ceiling 500; category records 501..540 | Separate inventory and Armory namespaces; freeze old interpretation |
| Init.j / V2 and V3 readers | 22 jobs; readers loop to live udg_JobCount; V2 reorders indexes5..7 as7,5,6 | Frozen per-version layouts before adding jobs; new ID-keyed counted jobs |
| Save.j stream allocator | Stream ID wraps after 8190; five display chunks reserved per stream | Bounded independent new buffers, no cross-stream overwrite |
| Save.j / Code.j | Colored chunks split around 1000 characters; chat warning above 121 plain characters | Measured segmented transport, no truncation; warning is not a proven engine limit |
| Save_WriteCodeFile / Load.j | Whole code in preload/player-name handoff; multiplayer uses two UI keystrokes per character | Measure file/string/UI latency and limits on each target client |
| Forsaken carry/dual overlays | Conversion copies charges, user data, widget life and item owner | Audit gameplay meaning, then persist applicable data explicitly |

Existing codec tests are 2,000 Python round trips and synthetic G/H vectors.
They do not demonstrate E/F migration, real Armory decoding, native inventory,
file transport or multiplayer behavior. tools/savecode.py currently decodes G/H,
so E/F fixtures require a separate reviewed reference decoder.

No capacity promise yet for +20 jobs, +1,000 items or +50 quests. A dictionary can
address them, but max populated payload, memory, JASS operation limits, strings,
chunk count and actual transport must be measured before claiming support.

## Architecture to implement and review

1. **Identity registry:** freeze legacy item IDs 1..358 as canonical item IDs;
   freeze job indexes 0..21 as permanent IDs 1..22. New records explicitly allocate
   IDs; existing legacy indexes never move. Runtime fNNN/gNNN aliases resolve to
   the original item's permanent ID through each build's mapping, including
   offhand variants. Do not serialize experimental aliases. The initial registry
   is experiments/Forsaken/save-identities.json; its preflight is save_registry.py.
   Quest/Chronicle/upgrade registries require a field audit before allocation.
2. **Detached logical snapshot:** schema-bound account/mode/progression records;
   item records with canonical ID, holder, exact slot, seven-bit quantity (including zero),
   binding and reviewed persistent metadata. Containers are quick 6, sparse bag
   30, equipment 9 (both rings separately), Gaya 6 and house 6. Use per-save record
   ordinals to detect repeated references; identical legitimate items are allowed.
   Cooldowns and temporary passive-suspension state are not automatically durable.
   Audit life/proficiency and ownership separately; do not persist opaque handles
   or owner player numbers as transferable authority.
3. **Independent sections:** reserve a new dispatch marker only after format
   review (I/J is unused in current docs, not yet a committed format). Envelope:
   magic, envelope version, account binding, payload length, section count and
   checksum. Each section has permanent section ID, schema version, flags,
   length and payload; records carry explicit counts/IDs. Use canonical unsigned
   base-32 varints carried in the existing 64-character alphabet (continuation
   bit), checked before JASS integer overflow. Proposed scalar range 0..2^31-1,
   max seven groups, shortest representation required. Defaults are specified
   per schema, never inferred from the live content count. Duplicate singleton
   sections/IDs, trailing data and unsupported required sections fail validation.
   Checksum detects corruption; do not claim protection against forged saves.
4. **Bounded preservation:** provisional limits are 16,384 encoded payload
   characters, 32 sections, 4,096 characters total unknown optional section data,
   256 unknown progression records and 57 item records. These are reference
   parser limits to test, not proven runtime capacities. Unknown records retain
   original ID/version/bytes in validated opaque storage, grant no rewards or
   bonuses, and re-emit exactly once. Unsupported required schema, overflow,
   malformed length/checksum or exhausted preservation capacity rejects the
   entire load/save before mutation. Never silently truncate or discard.
   Unknown item records occupy their original logical slot and remain inaccessible;
   classic preservation storage must prevent a second materialized copy. Revisit
   limits from measurements; lowering limits must reject oversized saves safely.
5. **Adapters:** native capture/restoration uses actual bag/equipment APIs and
   preserves sparse order, quantities, bindings and metadata. Stored gear remains
   passive-free, active books usable, equipped gear grants bonuses. Legacy hero
   items first enter a migration snapshot: eligible gear goes to deterministic
   free bag positions, never auto-equips; consumables use deterministic quick-slot
   positions. Legacy provides packed order, not original empty slot positions.
   Gaya and house remain their own inventories. Fail if placement cannot be
   preserved. Classic later materializes only representable quick/Gaya/house
   items and retains bag/equipment as inaccessible logical storage; define explicit
   transfer rules before exposing those records in classic.

## Ordered milestones and acceptance gates

| Step | Deliverable | Exit criteria |
|---|---|---|
| 1 — identity foundation (complete) | Frozen registry, source/mapping checker, negative tests, this plan and reapplication guide | All 358 items/22 jobs pinned; all generated original/variant/offhand identities resolve; mismatches fail; runtime unchanged |
| 2 — full save contract and fixtures (in progress) | Field-by-field E/F/G/H ledger (width, order, default, rule, target state); reviewed permanent progression IDs; legacy reference decode to detached snapshot | Real consented anonymized E/F/G/H examples plus synthetic edge vectors; independent expected fields; actual Armory contents; no mutation; fixed22-value V2/V3 layouts with the three-job V2 permutation confirmed from source |
| 3 — new reference codec (reference checkpoint implemented; runtime/default acceptance open) | Envelope/inventory/jobs, logical progression, bounded dormant extension, automated legacy translation, provenance and 62-entry equality report implemented | Golden vectors; truncation/corruption/overflow/duplicate/unknown tests; >500 item IDs, 42 jobs and50 dormant IDs; quantities0..120 plus lossless imported121..127; full 57 slots and sparse layouts; no manual legacy conversion; exact bound rejection; runtime/default verification remains with Steps2/5 |
| 4 — isolated JASS codec (implementation/compile checkpoint; engine gates open) | Experimental module, per-player accepted/scratch/writer buffers, differential source-harness vectors and read-only compile probes implemented | Standalone/playable/editor probes pass with extracted libraries, plus classic standalone; real-engine execution/work scheduling limits and source/map integration still required |
| 5 — transactional adapters (reference protocol/life/native staging foundation implemented; full backend open) | JASS exact-life arithmetic and hidden native allocation/metadata/cleanup; Python capture/restore controller with failure injection; original capture, placement, synchronization and rollback remain required | Full native inventory/progression equivalence; no drops/duplication; failed create/equip/placement rolls back all items/progression; failed load does not consume eligibility; actual native tests required |
| 6 — all entry routes | One snapshot/parser/serializer for chat, files, autosave, NG+, full load and Armory-only load | Segmented/reordered/replayed/missing/wrong-owner messages rejected; NG intentional resets enumerated; -loada never materializes inventory; file readback verified; prior successful save retained on failure |
| 7 — public Forsaken gate | New uniquely staged map, reports, fixtures, human acceptance log and release notes | Real legacy and new code/file restart tests plus multiplayer matrix below; no unresolved data-loss route; only then remove export block and release |
| 8 — updated classic | Shared logical model and classic preservation adapter, 1.29.2 transport | Real old-save → Forsaken → UPDATED classic → save → Forsaken equality, including all bag/equipment/unknown data; native runtime not used in classic |

Step2 verified22 jobs in both versions; V2 permutes three positions. The earlier
19-job assumption was corrected before decoder implementation. Keep published legacy routines/contracts intact;
new staging decoder must match their supported interpretation. Do not regenerate
compatibility fingerprints to force a passing build.

## Failure-safe persistence and multiplayer

Parse complete input, validate account/mode/eligibility, all section lengths,
counts, checksums, bindings and destinations before changing heroes or inventory.
Stage required items without pickup rewards; guard conversion and passive hooks.
Commit in synchronized code with a rollback journal, then set HasLoadedCode.
An unexpected placement failure restores original handles/state and destroys only
staged replacements. No ground-drop fallback counts as a successful load.
Saving captures once, validates, encodes, then decodes/compares before output.
Do not bind item ownership or replace a valid file until output validation succeeds.
Use alternating generation files with verified readback and recoverable previous
generation; do not assume Warcraft provides atomic rename. Autosave rotates only
after success. NG+ creates a transformed snapshot with reviewed intentional
resets and uses the same writer, rather than a second serializer.

Chat transport needs numbered bounded segments with format/session/player identity,
total length/count and whole-payload checksum; tolerate out-of-order input but reject
conflicting duplicates and expire incomplete transfers. Enforce sender ownership,
size/time budgets and per-player isolation. File/preload acquisition is local;
transfer validated input to synchronized gameplay before commit. No local UI or
local file result may independently create items, advance quests or allocate
gameplay handles. Retain existing name hash behavior and test non-ASCII names.

Acceptance matrix (record map hashes, client builds, hosts, player count, input
fixture, expected/actual state, pass/fail and tester/date): solo restart; two humans;
eight supported human slots; concurrent different-player loads/saves; same-player
replay; disconnect during input; local-file-disabled/error; another owner's code;
foreign-bound item; Hardcore/refused window/already-loaded; each difficulty/mode;
Speedrun food consumed-but-discarded; both ring positions, offhand, active books,
full/sparse bag, quantities0/120 and imported127; Gaya/house; cached job changes; Armory-only;
NG+; autosave rotation; corrupted last chunk and preservation overflow.
Automated mocks/codec tests and compilation are separate evidence columns from
real Warcraft legacy/native/multiplayer acceptance. Public release requires both.

## Current milestone evidence

The identity tool is read-only and opt-in. It pins source mappings and checks
builder alias allocation; it is not a migration decoder or save implementation.
No release map or gameplay source is changed. Runtime gates remain the existing
Forsaken save blockers. Step2's field ledger is [LEGACY_SAVE_LEDGER.md](LEGACY_SAVE_LEDGER.md).
Its detached decoder and synthetic fixtures are implemented; real-data and runtime
acceptance remain open. Item metadata audit: [ITEM_SAVE_METADATA.md](ITEM_SAVE_METADATA.md).
First new-format prototype: [SAVE_VNEXT_REFERENCE.md](SAVE_VNEXT_REFERENCE.md).
Progression/translation checkpoint: [SAVE_PROGRESSION_MIGRATION.md](SAVE_PROGRESSION_MIGRATION.md).
Isolated JASS checkpoint: [SAVE_JASS_CODEC.md](SAVE_JASS_CODEC.md).
Next: measured engine execution/work scheduling, default resolution and transactional adapters;
continue real-fixture/default-semantics work before enabling runtime integration.

Validation on 2026-10-08: 10 identity tests and 87 existing Forsaken tests PASS.
Preflight against `build/ForsakenBS-hz94mr9k/gear-slots.json` resolves 750 runtime
identities (358 canonical + 276 equipment + 116 offhand). BT changes only labels;
this is a check of the retained BS mapping, not a newly built BT/BU map. Existing
MPQ file-handle ResourceWarnings appear in the focused suite; tests pass. No
in-game, multiplayer or new-code save validation has been performed here.

Legacy foundation checkpoint:13 migration tests and2,000 existing codec cases
PASS;95 repository tests passed in the main run and the remaining build-overwrite
test passed when rerun with a writable workspace temporary directory. Full details
and the legacy-only NG− discrepancy are recorded in LEGACY_SAVE_LEDGER.md.

Reference prototype checkpoint:13 new-format tests (1000 seeded round trips) and
13 legacy migration tests PASS. Full 57-item inventory profile1453 characters;
inventory+42 jobs+50 dormant records1804 characters; same plus full opaque budget
5705 characters. These are partial-schema Python measurements, not Warcraft limits.

Progression/migration checkpoint:16 new migration tests PASS (250 seeded
progression round trips, CLI validation and eight pinned successor codes), plus
13 codec tests (1000 seeded round trips),13 legacy tests and10 identity tests.
Every synthetic migration passes62 comparison entries. Full logical profile
with57 items/42 jobs/31 titles/280 Armory/50 dormant records measures2803 characters;
with the full unknown-data allowance6704. Details and unresolved default/runtime
semantics: [SAVE_PROGRESSION_MIGRATION.md](SAVE_PROGRESSION_MIGRATION.md).

JASS checkpoint:13 differential/source-harness tests,13 reference codec,16
migration and13 legacy tests PASS (55 total). Standalone compiler checks pass
with bundled/classic1.29.2 libraries. Standalone/BT-runtime/BT-editor read-only
probes pass with extracted local libraries. No map integration or release yet.
Exact report paths, hashes, API and unverified engine limits: SAVE_JASS_CODEC.md.

Capture/restore foundation: [SAVE_RESTORE_PROTOCOL.md](SAVE_RESTORE_PROTOCOL.md).
5 life tests cover6282 binary32 patterns;14 reference transaction/capture tests
cover417 injected failure positions. These plus13 JASS codec,13 reference,
16 migration and13 legacy tests PASS (74 total). Codec+life compilation passes
standalone and read-only BT runtime/editor probes; no native restore backend or
engine acceptance yet. Droppability query semantics remain unverified; flag
capture must be authoritative, never silently copied from object defaults.

Native staging foundation: [SAVE_NATIVE_STAGING.md](SAVE_NATIVE_STAGING.md).
13 actual-source staging tests plus all 74 previous tests PASS (87 total).
Modern hidden allocation/metadata verification/cleanup implemented; read-only
standalone/BT runtime/editor compilation passes. This is not native restoration
acceptance; original capture, placement, passives, progression and publication
remain unimplemented, with no route or map integration.

Item journal/storage placement: [SAVE_ITEM_JOURNAL.md](SAVE_ITEM_JOURNAL.md).
19 tests plus all 87 previous tests PASS (106 total); standalone/BT runtime/editor
compilation passes. Read-only 57-position journal and exact 48-position storage
placement implemented, with tracked filler cleanup. Native equipment, complete
session/progression journal, original quarantine/rollback and publication remain
open. Actual getter behavior and gameplay guards still need engine integration.

Prepared abilities/equipment: [SAVE_EQUIPMENT_RESTORE.md](SAVE_EQUIPMENT_RESTORE.md).
19 new tests plus all 106 previous tests PASS (125 total); full modeled 57-item
batch and standalone/BT runtime/editor compilation pass. Original quarantine,
session/progression journal and verified rollback remain open. Live policy/default
loader and reviewed inert ring filler are not installed; actual stat
and engine behavior remain acceptance gates. No entry route/publication enabled.

Original-item recovery: [SAVE_ORIGINAL_RECOVERY.md](SAVE_ORIGINAL_RECOVERY.md).
20 new tests plus all 125 prior tests PASS (145 total); standalone/BT runtime/editor
compilation passes. Original handles, ability instances, known passive bookkeeping
and exact 57 positions are verified, retaining recovery blocks on failure.
Cooldown refresh on character changes is permitted, including rollback. Complete
session/progression, derived effects, gameplay guards, live policy/filler objects,
publication and engine acceptance remain open.

Live progression journal: [SAVE_PROGRESSION_JOURNAL.md](SAVE_PROGRESSION_JOURNAL.md).
19 new and all 145 prior save tests PASS (164), plus 10 identity tests; coverage
includes all 54 modeled native write failures/retry. Actual scalar,
currency/research/force/table state is restored and read back. Original item and
progression guards are independent. Job heroes are read-only boundaries; actual
unit recovery, Gaya/Freelancer, derived effects and other session state remain
open. Standalone/BT runtime/editor compilation passes; no route or map build.

Original hero recovery: [SAVE_HERO_RECOVERY.md](SAVE_HERO_RECOVERY.md). 27 new tests
and all 174 prior checks PASS (201), including both level directions, existing
ability instances/ranks, skill points, base/total primary attributes and all six
journal release orders. Actual cached owners support neutral inactive jobs.
Wider effects/session data, owned new units/reference promotion and the full
guarded controller remain open. Standalone/BT runtime/editor compilation passes;
no entry route, map build or engine acceptance. Cooldown refresh remains allowed.

Session recovery: [SAVE_SESSION_RECOVERY.md](SAVE_SESSION_RECOVERY.md). 18 new
tests plus all 201 prior checks PASS (219 total), including all 299 typed talent
write faults, accepted-code/unknown-section recovery and all 24 release orders.
Talent choices, six selected skills and partial monographs remain per-game;
independent guards preserve the journal and prevent codec publication until
verified release. Hero/table references are read-only boundaries. Standalone/BT
runtime/editor compilation passes, build/save-codec-compile-jzm76o6b/report.json.
Wider body/combat effects, owned new units/reference promotion, synchronized
containment/scheduling and the full load/commit controller remain open. No map
build or saving enabled; engine acceptance remains required.

Owned unit staging: [SAVE_UNIT_STAGING.md](SAVE_UNIT_STAGING.md). 20 new tests plus
all 219 prior checks PASS (239 total). Up to 24 job/Freelancer/Gaya replacements
are tracked and verified hidden/paused/invulnerable with empty inventories.
Original/live/journal references cannot be adopted; cleanup refuses published
or item-carrying units and retains failed deletions for retry. Independent unit
guards survive other journal release. Standalone/BT runtime/editor compilation
passes, build/save-codec-compile-5anxjlgn/report.json. No promotion/commit API,
map build or saving enabled. Native operation limits, synchronized hook exclusion,
reference promotion, body/combat state and the full controller remain open.

First engine diagnostic: [SAVE_ENGINE_TEST.md](SAVE_ENGINE_TEST.md). Private BU
adds -savecheck/-saveverify for incremental live inventory capture, exact codec
round trip, invalid-input rejection and unchanged/changed comparisons. 10 new
tests plus all 239 prior checks PASS (249); mandatory map gates, 96 repository
regressions and 2,000 legacy codec cases also PASS. 517 original archive members
and all original editor source are preserved. BT/shared sources unchanged.
Human native/operation-limit testing can start; full character restoration,
progression/profile capture, file output and multiplayer transport remain open.

Reversible hero references: [SAVE_REFERENCE_SWITCH.md](SAVE_REFERENCE_SWITCH.md).
15 new tests and all 249 earlier checks PASS (264), including 52 reference-write
fault cases. Captures 26 references with typed presence, switches only owned
replacement roles, and restores original references before replacement cleanup.
Original heroes remain alive; targets stay hidden/neutral/paused/invulnerable/empty.
Standalone/BT runtime/editor compilation PASS,
build/save-codec-compile-2seobnrz/report.json. No activation/commit or map build.
Prepared-state controller, body/combat effects, ownership/activation, synchronized
hooks, native scheduling, file/restart and multiplayer acceptance remain open.
BT/BU unchanged, BV unused, full character saving/loading remains blocked.

Living original hero body recovery: [SAVE_BODY_RECOVERY.md](SAVE_BODY_RECOVERY.md).
17 new tests plus all 264 prior checks PASS (281), including all 24 fixture setter
faults and 25 distinct heroes/200 writes at player 7/index 199. Health/mana,
position/facing and hidden/paused/invulnerable flags restore on living originals
with native readback and independent guards. Maximum health/mana must first
recover; switched references must reverse. Standalone/BT runtime/editor compile
PASS, build/save-codec-compile-0cy567c4/report.json. No map build or activation.
Buffs/orders/remaining combat effects, replacement activation, prepared-state
controller, native scheduling, full commit and file/restart/multiplayer acceptance
remain open. BT/BU unchanged, BV unused; full saving/loading remains blocked.

Contained replacement ownership: [SAVE_OWNERSHIP_PREPARATION.md](SAVE_OWNERSHIP_PREPARATION.md).
13 new plus all 281 prior checks PASS (294), including two assignment/eight
neutralization setter faults. Published owned active/Gaya targets can be assigned
to Player(pid) while hidden/paused/invulnerable/empty. Originals are untouched.
Verified neutralization and ownership release must precede reference reversal
and owned-unit cleanup; independent guards retain recovery state. Standalone/BT
runtime/editor compile PASS, build/save-codec-compile-va2hotyc/report.json. No
activation or map build. Staged progression/abilities, safe spawn/visual/pathing
policy, placement/controller/scheduling and full commit/file/restart/multiplayer
acceptance remain open. BT/BU unchanged, BV unused; full saves remain blocked.

Owned replacement preparation: [SAVE_PREPARED_HEROES.md](SAVE_PREPARED_HEROES.md).
14 new plus all 294 prior checks PASS (308), including 18 fixture setters, six
learning-failure boundaries and 24 units×40 ability plans at player 7/index 7679.
Exact XP/level, base stats and bounded ability ranks prepare only owned contained
units; originals stay untouched. Below-50 normal jobs retain unlearned skills and
refund level points; mastered jobs receive four rank-11 skills and rank-6 ultimate
(50 points spent). Independent guards retain failures/retry; plan discard precedes
ownership/reference/unit cleanup. Standalone/BT runtime/editor compile PASS,
build/save-codec-compile-ze0vosm3/report.json. Profile translation/mastery bonuses,
other effects, native learning/point acceptance, placement/spawn/activation,
scheduling and full commit/file/restart/multiplayer remain open. BT/BU unchanged,
BV unused; full saves remain blocked.

Reversible empty active-hero/Gaya exposure: [SAVE_ACTIVATION.md](SAVE_ACTIVATION.md).
12 new plus 308 prior checks PASS (320). Both originals are contained before
replacement positions are verified and the prepared pair is exposed. All 18
exposure and 12 containment setter failures retain recovery guards; containment
can recover despite prepared-stat drift without approving the changed plan.
Activation release requires containment and retains all preceding journals.
Standalone/BT runtime/editor compile PASS, build/save-codec-compile-ths3v4mz/report.json.
The module still requires synchronized gameplay exclusion. Profile translation,
prepared inventory integration, spawn/pathing policy, scheduling and full
commit/file/restart/multiplayer acceptance remain open. BT/BU unchanged, BV unused;
full new saves remain blocked.

Accepted normal-job translation: [SAVE_JOB_POLICY.md](SAVE_JOB_POLICY.md).
The detached profile resolves reviewed job identities while retaining unknown
records and original evidence. The native planning bridge preserves mastery
markers/base bonuses and user skill defaults, using caller-reviewed XP/grown
attributes without guesses. 12 new tests and 53 focused regressions PASS; all
three compile probes PASS, build/save-codec-compile-zgse3g26/report.json.
Gaya/Freelancer and remaining derived effects/native evidence/controller/item
integration remain open. Future caps require separate actual-level/mastery-tier
records before relaxing schema1 limits. No map build; full saves remain blocked.

# Live progression journal and verified recovery

2026-10-09. `Forsaken-save-progression.j` journals and restores a bounded subset
of the actual BT progression globals, native player state, research, forces and
job-level table. It uses no substitute logical-state table. There is no initializer,
entry route, accepted-data publication, file write or map build.

This follows [original-item recovery](SAVE_ORIGINAL_RECOVERY.md). It is not full
character/session rollback. Hero units, Gaya/Freelancer state, talents, derived
effects and other session data still need their own journal/recovery work.
Cooldown refresh on character changes, including rollback, remains permitted.

## Captured state

| State | Capture and restoration |
|---|---|
| Per-player scalars | CodeDifficulty, NewGamePlusLevel, MiracleStage, MetaFragments, SpeedrunLevel, ArmoryItemCount, TotalJobLevel and HighestJobLevel use player ID+1; ArmoryCodeSegment uses player ID |
| Eligibility | HasLoadedCode uses player ID; exact prior value restored |
| Native player state | Gold, lumber/shards and food used, separately and without legacy gold/shard conversion |
| Research | Frozen 15 upgrade rawcodes plus Resi, R00F, R00G (Gaya purchase prerequisites); exact GetPlayerTechCount(..., true) readback |
| Membership | TitleForce slots 0–100, SaveFlagForce slots 0–540, LegendaryGuardianForce and CheaterForce: actual force identities and only the affected player's membership |
| Stored jobs | All 22 frozen canonical job rawcodes; actual JobLevelHash identity, HaveSavedInteger presence and exact integer value |
| Job unit boundary | Actual JobHeroHash identity and each existing job-unit handle, rawcode, owner, XP, level and mastery rank are checked; these units are not modified/reconstructed |

Missing job-table entries remain missing; a present zero remains present.
The raw backing table is captured independently of `Job_GetSavedLevel`, which
can read an existing hero instead. A changed/replaced/destroyed job hero refuses
recovery rather than restoring only the fallback value and claiming success.
Other unit properties such as skill points, stats, abilities and Gaya/Freelancer
progression are outside this checkpoint's equality check.

All 644 force positions are bounded, including null entries, sparse title groups,
Armory category groups and aliasing to shared forces. Membership changes affect
only Player(pid); other players and Player 9 policy markers remain intact. Forces
are never destroyed or replaced. Category membership is session state here;
it does not become durable Armory ownership. Null slots must remain null.

World difficulty, SpeedrunTitleBase, global MiracleStage[0], Speedrun/Hardcore/GameRunning state,
SaveFlagCount, the 22-job roster and table/force identities are read-only context.
Changes refuse recovery before any setters; shared world values are not rolled
back for one player. Unsupported job counts/order or flag counts above 540 refuse
capture. Future content must extend the reviewed adapter deliberately.

## Lifecycle and coordination

`FPG_Begin(pid)` requires FSJ's verified original view and FQR state 1 (captured),
with no concurrent staging operation. It captures read-only, then reads the
state again before accepting it. States: 0 idle, 1 captured, 2 recovered,
3 blocked. A ready journal cannot be overwritten.

`FPG_Recover(pid)` verifies context before mutation, restores scalar values,
resources, research, membership and stored jobs, then checks actual readback.
Silent native failure blocks and keeps the journal for retry. The caller must
hold synchronized gameplay exclusion, suppress side effects and exclude queued
research; these primitives do not restore research queues or guarantee a freeze.
Native tech clamping and derived effects still require engine acceptance.

`FSN_ProgressionBlocked` independently blocks new staging, effect preparation and
placement after a recovery attempt, including verified recovery until release.
`FSJ_ProgressionPending` prevents discarding the original item journal. FQR's
item guards remain independent: releasing one journal cannot release the other.
Recovery setters lock the existing item/staging operations against reentrancy.

`FPG_Release(pid)` requires state 2, full progression readback, verified original
items and FQR state 5 or a completed FQR release. It clears references and its own
guards only. Either journal can release first after both recoveries verify; the
other guard remains held. This does not release an external gameplay guard or
publish a successful load. Prior accepted codec data and last-good save files
are untouched.

## Evidence and next work

19 actual-source harness tests pass: read-only capture, exact recovery, all 644
force positions, all 54 modeled native write failures with retry, missing versus
present-zero job keys, player 7/max force index 5151, both release orders, shared
context/table/force changes, job-hero mutations, aliased groups, original-item
failure, busy/reentrant calls, unsupported bounds and frozen source mappings.
These are native mocks, not Warcraft engine execution.

All 145 prior save tests rerun and pass: 71 native/item suites, 61 codec/life/
transaction/migration tests and 13 legacy tests. With 19 new tests, 164 save tests
pass; the 10 identity preflight tests also pass (174 checks total). Legacy's
pre-existing unclosed item-table ResourceWarning remains unchanged.

Read-only standalone/BT-runtime/BT-editor compile probes pass. Standalone external
global declarations are extracted from the actual BT runtime rather than guessed.
Report: `build/save-codec-compile-x01z46c2/report.json`, with source, library,
compiler and map hashes. The compiler required outside-sandbox DLL loading;
this is not a fresh installed-client-version claim.

```powershell
& $ffPython experiments/Forsaken/test_save_progression_journal.py
& $ffPython experiments/Forsaken/check_save_jass.py --progression --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

Next: actual job/Gaya/Freelancer unit progression and ability recovery, derived
effects/stat equality, remaining session/reservation/accepted-data journals,
live policy/default/filler objects, synchronized scheduling/containment and
commit/publication. Follow with real restart/multiplayer/transport acceptance.
BT SHA256 remains `4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2`;
AS/Z unchanged, BU unused, save exports blocked.

Following checkpoint: [SAVE_HERO_RECOVERY.md](SAVE_HERO_RECOVERY.md) restores
existing unit progression/ability ranks/base attributes and checks total primary
stats. FPG now records exact cached owners, including neutral inactive heroes.
Wider effects and complete session/controller acceptance remain open.

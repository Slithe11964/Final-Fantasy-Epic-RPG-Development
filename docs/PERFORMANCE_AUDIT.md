# Performance and stability audit - 2026-10-15

## Scope and limits

Read-only review of shared source, Forsaken runtime support, and the actual PAIR007
playable maps in `Documents/Warcraft III/Maps/Download/TEST`. No gameplay changes or
new test build were produced by this audit. Source locations below identify the
implementation; fixes must also reach the editor-master/paired-build workflow,
rather than changing generated maps independently.

| Profile | PAIR007 SHA-256 |
|---|---|
| Forsaken/Reforged | b88d7a7605b4255f3365527644d2215ebd829c13e028395d920879677c70df3b |
| 1.29.2 | e9b7bfb521e77d51b243ebf3847adb5104f10df6cdcf304afff5f224e56955f6 |

The classic imported-character Warcraft checkpoint crash remains unresolved.
PAIR007's separation of local and synchronized save fragments still needs a
multiplayer long-import test. Findings here do not establish either crash's cause.
No engine CPU, RAM, or cold/warm loading times were measured.

## Prioritized findings

### 1. Projectile hit groups leak in both profiles - confirmed

`src/triggers/01 Shared helpers/Missile.j:88` creates a group on every allocation.
`Missile_Free` at line 95 runs the impact callback and returns the slot to the free
list without destroying that group. The impact cleanup removes units/effects but
also does not destroy it. All references to `udg_MissileHitGroup` were checked;
there is no indirect group cleanup. Both actual PAIR007 runtime scripts contain
the same omission.

This leaks a group for each completed projectile, even when missile slots are
recycled. Prolonged combat therefore accumulates handles and potentially retained
unit references. This is a concrete memory-management defect, but its RAM cost
and relationship to the reported crashes have not been measured.

Recommended fix: destroy and null the hit group after the final impact callback,
before returning the slot to the free list. Validate single-hit behavior, final
splash damage, talent hooks, repeated free calls, and slot reuse. Keep this shared
combat change in both outputs.

### 2. Save fragment arenas grow across operations - confirmed

`experiments/Forsaken/SaveStrings.j` allocates monotonically increasing IDs in
`FSS_Store` and `FSS_LocalStore`. Long concatenations retain intermediate immutable
objects. Neither actual PAIR007 runtime flushes these arenas. PAIR007 correctly
separates owner-local file assembly from synchronized decode allocation, but that
does not reclaim completed operations' temporary data.

Measured using the actual helper's bounded JASS interpreter, assembling text in
160-character pieces:

| Text length | IDs after one assembly | Retained entries | Entries after a second assembly |
|---|---:|---:|---:|
| 2,053 characters | 7 | 22 | 44 |
| 17,000 characters | 101 | 1,103 | 2,206 |

These are hashtable counts, not RAM estimates. Native string interning can reuse
identical contents; the retained object metadata still grows. Shared save capture
and validation also create intermediates.

Recommended fix: introduce operation ownership and release temporary objects after
completion/rollback. Local and shared cleanup need separate lifecycles. Preserve
live screenshot codes and concurrent players' sessions. Do not indiscriminately
flush the shared table. Test repeated imports, saves, screenshot paging, failures,
timeouts, retries, and two simultaneous players.

### 3. Repeated frame searches - confirmed, Forsaken only

`experiments/Forsaken/Forsaken-panels.j:125` searches contexts 0 through 255 for a
frame. It returns early only for a visible match; an invisible fallback still
causes the remaining contexts to be searched. `Forsaken_PollPanels` at line 342
performs two such searches every 0.1 seconds (timer at line 512). These functions
also occur in the actual native PAIR007 script.

The upper bound is **5,120 frame-name lookups per second per client** when hidden
or missing frames do not yield an early visible match. This is a static bound,
not measured CPU time or the average workload.

Recommended fix: cache resolved handles, retry absent frames less often, and avoid
unchanged layout/text updates. Invalidate caches after saved-game load and frame
recreation; stale frame pointers could reintroduce the missing-panel problems.
Test inventory, inspection, Bazaar, talents, and checkpoint reloads.

### 4. Collection counters repeatedly rescan unchanged data - confirmed

`src/triggers/05 Items crafting and shops/Armory.j:1075` runs once per second.
It calls both `Armory_CollectionText` (line 1026) and `Armory_CountProgress`
(line 1043), each scanning save flags; the latter walks category ancestry.
It then builds category strings even though only changed tooltip writes are
suppressed. Chronicle upkeep also checks every player's hero/spirit inventories
and reapplies Secrets availability every second.

Recommended fix: cache counts with a collection revision and invalidate on deposit,
grants, import, and other collection changes. Refresh category tooltips from that
cache. Retain a modest fallback refresh until every mutation path is covered.
These counters are presentation scratch; the reviewed usages do not establish a
local-player-to-gameplay desync defect.

### 5. Allocation limits need fail-closed behavior - defensive improvement

Missile and knockback allocators reject indices above 8190 by returning zero, but
their constructors continue writing slot zero and may create/register objects.
Under pool exhaustion this can corrupt the sentinel or active lists. Pools do
recycle: this is extreme simultaneous allocation pressure, not a failure after
8190 lifetime casts. Guard every constructor/caller and avoid advancing exhausted
counters. Test with a deliberately reduced pool limit rather than thousands of
live combat objects.

## Desync review

The active Forsaken talent handler sends a choice through synchronization and
validates/applies it there. Reviewed Bazaar gameplay mutations likewise occur in
the synchronized handler. Local camera, selection, tooltip and panel work should
not be treated as a defect solely because it uses `GetLocalPlayer`.

A latent race exists in the alternative `TalentFrame_` implementation in
`src/triggers/03 Jobs and progression/Talents.j`: its synchronized choice handler
checks a panel-open flag that the local close handler changes. A queued choice
followed by close could make clients disagree. **That interface is disabled in the
actual native PAIR007 (`TalentUseFrames=false`) and is not the classic interface.**
It cannot explain the current loading desync. Remove the local-open gameplay gate
before enabling that alternative interface in a future build.

This audit found no additional proven active desync cause. Multiplayer engine
acceptance is still necessary, especially long imports and simultaneous imports.

## Loading and packaging

| Measurement | Forsaken | 1.29.2 |
|---|---:|---:|
| Archive size | 11.50 MiB | 10.78 MiB |
| Expanded named members | 36.90 MiB | 31.55 MiB |
| Runtime script | 8.62 MiB | 8.35 MiB |
| Compressed WCT + WTG editor payload | 1.94 MiB | 1.91 MiB |

Expanded member totals describe archive contents, not live memory consumption.
Unknown unnamed members are outside those totals. Runtime script and object data
are substantial; startup registration and ability/unit preload deserve profiling
before changing their order or removing work.

A play-only packaging mode could omit editor WCT/WTG data after validation to reduce
download/disk size by approximately the compressed payload amounts above. Archive
rewriting may change the exact saving. This has no demonstrated CPU loading-time
benefit: editor trigger source is not executed by the game. Preserve the complete
master and authoring/reference maps, and test the stripped output before release.

Do not strip WTS strings or classic fallback ability fields: they support real
object tooltips/spells and compatibility. The existing bounded unit/ability
preloads may prevent first-use hitches. Missile/knockback timers already pause
when idle; slowing all combat timers would change behavior. Save pumps perform
small idle checks and are a lower optimization priority than frame searches.

## Recommended implementation and acceptance order

1. Fix projectile group lifetime in the shared master/runtime and test combat.
2. Add ownership-aware save scratch reclamation with repeated-operation and
   concurrent-player coverage.
3. Cache Forsaken frame handles with checkpoint invalidation; then cache collection
   progress without changing unlock behavior.
4. Add allocator failure guards and disable the latent alternative talent race.
5. Measure startup times and process memory before choosing preload, registration,
   or play-only packaging changes.

Each runtime change should produce both profiles from the editor master and pass
the existing compiler, content, startup and save gates. Engine checks must include
Tiny and endgame imports, multiple clients, repeated imports after rollback,
Warcraft menu save/load after a complete restart, and an extended combat session.
Keep classic checkpoint investigation separate from unproven performance theories;
the pending CheckpointNoItems comparison is documented in SAVE_129.md.

## Follow-up requested by the user

PAIR007 multiplayer still desynchronized on `-loadf dev`. Address that first;
see SAVE_129.md for the private-IO boundary candidate and replay evidence.
Subsequent requested behavior: projectile hit tracking ends after impact or
expiry; UI frame searches use a cache refreshed on opening/recreation; collection
counts update when collection membership changes (including import), otherwise
retain the last totals. Save scratch cleanup must preserve live sessions. These
performance changes await multiplayer acceptance of the desync candidate.

## PAIR011 implementation follow-up

The user confirmed that PAIR010 no longer desynchronized during Forsaken imports.
Three players subsequently experienced freezing while questing, after about four
quests; another player had imported a medium-progress profile. No engine trace
identifies the freezing instruction. PAIR011 addresses the concrete audit findings;
acceptance still requires an extended multiplayer quest/combat session.

Finished missiles now release their hit groups after the final impact callback,
clear retained handles and stop further travel work after removal. Missile and
knockback pools reject exhausted allocations before creating objects; reentrant
cleanup cannot free a slot twice. Existing combat timer/iteration timing is retained.

Save strings use separate shared/private root tables and deferred reclamation queues.
Each collector turn examines a bounded number of objects, preserving persistent
codes, active transfers, validation plans and screenshot pages. Dropped roots are
reclaimed between non-yielding event stacks. Private file IO retains PAIR010's
isolation from shared scanner state. The private send buffer is released after its
final packet, and export readback also checks the stored checksum header.

Native frame searches are cached, requested by panel interaction, retried sparingly
while an open panel lacks handles, and invalidated after Warcraft checkpoint loads.
Visible stats redraw at a bounded rate and repeated ability reads are cached within
one render pass. Pure display redraws do not run gameplay magic-defense calculations.
Armory and Chronicle membership changes invalidate cached totals; unchanged idle
ticks do not rescan the collection. Inventory changes and replacement heroes also
invalidate Chronicle reconciliation. A latent alternative talent sync path now
checks gameplay eligibility independently of private panel-open state.

The paired builder applies reviewed maintenance to both outputs from the unchanged
editor master, retaining each inventory interface and the shared save format.
Regression coverage exercises repeated/concurrent save operations with collection,
projectile cleanup/reentrancy/exhaustion, collection invalidation and native UI caching.
No startup-time or FPS improvement is claimed without engine measurements. The
classic large-import Warcraft-menu checkpoint issue remains a separate open issue.


PAIR011 engine acceptance: use a fresh multiplayer session with the same three-player
mix of endgame and medium imports. Complete more than four quests and spend time in
projectile-heavy combat. Check that Armory/Chronicle counts change after gains or
removals, and that native inventory, inspection, stats and talents still open and
update. Check screenshot-page navigation after a normal save and file export/import.
Record whether a freeze affects one client or all clients and its last activity.
This test cannot be replaced by the modeled cleanup/caching regressions.

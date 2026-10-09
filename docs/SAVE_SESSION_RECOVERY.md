# Session choices and accepted-code recovery

Isolated checkpoint, 2026-10-09. `Forsaken-save-session.j` adds same-game recovery
for talent choices, selected skills, partial monographs and the prior accepted
codec state. No initializer, gameplay route, map build or export is added. BT
remains unchanged; BU remains unused. Talents and partial monographs remain
per-game state and are never serialized. Cooldown refresh remains permitted.

## Captured state

- Actual `ForsakenTalentState` identity and 23 job parents (22 jobs plus
  Freelancer), at `pid*100+job`. Boolean choices use children 0..11; the spent
  count uses integer child 20. Capture records typed presence and value.
- Six selected-skill arrays at `pid+1`: AbilitySlot1..4, MainSkillSlot and
  SubSkillSlot.
- ChroniclesMonographCount at `pid+1` and all ten Seen entries at
  `(pid+1)*10+slot`.
- `FSC_Code[pid]`, the accepted codec context at **pid+1**, all ten context
  fields, all 32 section slots (including unused slots), and both 16-entry
  Spec/Gaya caches. Unknown optional section payloads are retained exactly.
- Independent read-only copies of the 25 job/Freelancer/Gaya/active hero
  references, their raw types and owners, the JobHeroHash identity and cached
  Freelancer reference. The frozen 22-job roster must remain unchanged.

This journals existing values; it does not validate talent entitlement or choose
new talents. Restoration uses typed Save/Remove operations, preserving absent
entries, present false and present zero without flushing a table parent. Other
players, unrelated keys and other value types at the same key remain untouched.

## Recovery and release

States are 0 idle, 1 captured, 2 recovered and 3 blocked. Begin requires verified
original-item, progression and original-hero journals, an idle codec writer, a
non-null talent table and bounded counts. Capture performs no live writes and
rechecks the captured state.

Recover first blocks staging and public codec mutation/re-encoding. A changed
table/unit reference, raw type, owner or roster refuses before any restoration
write. A pending writer must be aborted by its owner; codec Abort remains allowed
for cleanup and recovery can then retry. Accepted state is restored without
altering parser/writer scratch contexts. Recovery holds the other journals and
codec busy during setters, applies 299 typed talent writes/removals and verifies
all captured values through readback. A failure retains the journal and guards.

Release requires exact session readback, verified original items, completed or
already released item/progression/hero recovery and total primary-stat checks
while the hero journal is held. Each journal clears only its own guards; all 24
release orders are tested. Item-journal disposal stays blocked until session
release. Release clears retained unit/player/table/string references.

## Evidence and limits

18 actual-source harness tests pass: all 299 native table fault positions and
retry, typed absence/value preservation, other-player isolation, all accepted
section/cache slots, unknown sections, empty accepted state, writer cleanup,
reentrancy, changed identities, release gates/order, player 7 and array bounds.
All 201 prior checks also pass, giving 219 checks total. Tests use native mocks;
they do not claim Warcraft execution. The legacy decoder's pre-existing unclosed
item-table ResourceWarning remains unchanged.

Standalone, BT-runtime and BT-editor compilation pass with extracted local
libraries: `build/save-codec-compile-jzm76o6b/report.json`. This records source,
map, library and compiler hashes. Compiler DLL loading required execution outside
the sandbox; no installed-current client version is claimed.

```powershell
& $ffPython experiments/Forsaken/test_save_session.py
& $ffPython experiments/Forsaken/check_save_jass.py --session --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

This does not restore replaced hero references or dispose of newly allocated
units. Remaining work includes owned-unit allocation/reference promotion, HP/MP,
buffs, position/visibility/orders, local selection/UI refresh, other ability and
combat-effect fields, remaining table keys and research queues. Live effect
policy/filler objects, synchronized gameplay exclusion, bounded scheduling, the
full load/commit controller and file/publication/transport acceptance remain
required. Actual item/research-derived ability projections still need engine
acceptance. Saving remains blocked.

BT SHA256 remains
`4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2`.

Latest private diagnostic: CB; human house gate PASS, including six exact slots,
metadata and temporary cleanup; -savecheck/-saveverify also user-confirmed PASS.
See SAVE_HOUSE_ENGINE_TEST.md. CA passed item
metadata, then failed sparse house slot5; cleanup/originals/release and saveverify
passed. CB reserves earlier empty slots before insertion and reports precise
placement failures. CC next unused.
Reproduce a new private house diagnostic with build_save_probe.py --house-probe
and a fresh stage. Published maps are never overwritten.

# Repeatable Forsaken checkpoint reapplication

Run from `C:\Users\jaked\WarcraftMapExtractor\FFERPG`. Shared development remains
AS; public baseline Z is not an input to overwrite. Latest gear baseline is BT at
`fa6ed31`; BS full scratch is `build/ForsakenBS-hz94mr9k/FFERPG`. Scratch trees and
generated releases are evidence, not editable sources of truth. Private BU now
provides -savecheck/-saveverify; see SAVE_ENGINE_TEST.md. BV is next.

## Prerequisites and checkpoint review

- Clean/reviewed Git changes; retain the exact shared source commit and overlay
  commit. Keep both map input files backed up with SHA256 hashes.
- Python 3.9+, PowerShell and tools/bin compiler/native libraries required by
  docs/BUILDS.md; use installed 3.0 libraries for an additional native compile.
- Shared Reforged/classic pair from the same reviewed checkpoint. AS defaults:
  `release/FFERPG_0.9.7.3-r16-stageAS.w3x` and
  `release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x`.
- The Reforged input must contain current Armory/Bazaar/Chronicle objects.
  When preparing a new shared pair follow docs/BUILDS.md first. Do not run the
  ordinary downgrade converter on a Forsaken output.
- Choose a genuinely unused stage. BV is next at this handoff; do not reuse BT
  or overwrite any existing map/report/manifest. No map is needed for docs/tools.

## Commands

On this PC `python` may resolve to an unavailable Store alias. Use the bundled
runtime explicitly (or substitute a working Python 3 path):

```powershell
$ffPython = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
git status --short
git rev-parse HEAD
Get-FileHash -Algorithm SHA256 release/FFERPG_0.9.7.3-r16-stageAS.w3x
Get-FileHash -Algorithm SHA256 release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x
& $ffPython experiments/Forsaken/save_registry.py
& $ffPython experiments/Forsaken/test_save_registry.py
& $ffPython experiments/Forsaken/test_legacy_snapshot.py
& $ffPython experiments/Forsaken/test_save_vnext.py
& $ffPython experiments/Forsaken/test_save_migration.py
& $ffPython experiments/Forsaken/test_save_jass.py
& $ffPython experiments/Forsaken/test_save_life.py
& $ffPython experiments/Forsaken/test_save_transaction.py
& $ffPython experiments/Forsaken/test_save_native.py
& $ffPython experiments/Forsaken/test_save_position.py
& $ffPython experiments/Forsaken/test_save_equipment.py
& $ffPython experiments/Forsaken/test_save_recovery.py
& $ffPython experiments/Forsaken/test_save_progression_journal.py
& $ffPython experiments/Forsaken/test_save_heroes.py
& $ffPython experiments/Forsaken/test_save_session.py
& $ffPython experiments/Forsaken/test_save_units.py
& $ffPython experiments/Forsaken/test_save_references.py
& $ffPython experiments/Forsaken/test_save_body.py
& $ffPython experiments/Forsaken/test_save_ownership.py
& $ffPython experiments/Forsaken/test_save_prepared_heroes.py
& $ffPython experiments/Forsaken/test_save_activation.py
& $ffPython experiments/Forsaken/test_save_hero_policy.py
& $ffPython experiments/Forsaken/test_save_gaya_policy.py
& $ffPython experiments/Forsaken/test_save_freelancer_policy.py
& $ffPython experiments/Forsaken/test_save_player_target.py
& $ffPython experiments/Forsaken/test_save_inventory_plan.py
& $ffPython experiments/Forsaken/test_save_cargo.py
& $ffPython experiments/Forsaken/test_save_cargo_placement.py
& $ffPython experiments/Forsaken/test_save_inventory_profile.py
& $ffPython experiments/Forsaken/test_save_inventory_projection.py
& $ffPython experiments/Forsaken/test_save_house.py
& $ffPython experiments/Forsaken/test_save_house_cargo.py
& $ffPython experiments/Forsaken/test_house_probe.py
& $ffPython experiments/Forsaken/test_save_probe.py
& $ffPython experiments/Forsaken/measure_save_vnext.py
& $ffPython experiments/Forsaken/test_forsaken.py
# Read-only codec compile probes; use reviewed extracted library paths.
& $ffPython experiments/Forsaken/check_save_jass.py --activation --job-policy --gaya-policy --freelancer-policy --player-target --cargo --inventory-profile --house --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
# Only when an actual new experimental map is needed; check BV is still unused.
& $ffPython experiments/Forsaken/build_forsaken.py --stage CC --base release/FFERPG_0.9.7.3-r16-stageAS.w3x --classic release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x
& $ffPython experiments/Forsaken/save_registry.py --mapping release/Forsaken/gear-slots-BV.json
& $ffPython experiments/Forsaken/audit_gear.py --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenCC.w3x --mapping release/Forsaken/gear-slots-BV.json --output build/ForsakenCC-gear-audit.md
Get-FileHash -Algorithm SHA256 release/Forsaken/1.29.2/FFERPG_0.9.7.3-r16-ForsakenCC.w3x
```

For a later shared checkpoint replace both explicit inputs and choose a fresh
stage. First review shared changes against overlay match points, item category
policy, job transfers and eligibility. An identity mismatch requires a reviewed
append/tombstone allocation, never automatic registry regeneration. Legacy job
layout changes are blocked until version-specific staging readers exist.
The current all-276 audit hardcodes the AS comparison input: it is appropriate
for this AS-based command. Before auditing a later shared base, extend that tool
to accept the explicit shared comparison input and review its expectations; do
not interpret an AS comparison as proof of a later base's preservation.

## What the existing builder reapplies

`experiments/Forsaken/build_forsaken.py` is the supported implementation. It runs
focused tests, creates `build/Forsaken<stage>-<random>/FFERPG`, copies `src`,
`tools`, `baseline` and build.ps1, and patches only that scratch source tree.
prepare_objects creates native inventory/equipment abilities, zero-stat marker,
equipment variants and original→variant/offhand/slot mapping, plus map-info
Forsaken Kingdom selector 2. It retains original items for Gaya/ground use.
Variant fNNN and gNNN allocations follow src/armory-hints.json insertion order;
save identities must always resolve through canonical originals, never persist
these generated codes. Nine native positions are Head0, Chest1, Gloves2, Boots3,
Ring4/5, Primary6, Offhand7, Trinket8. Four Materia stay Inventory.

Source overlays include Equip plus the Forsaken-*.j fragments; Job sparse bag and
equipment transfer; MagicDefense and Multiboard; Unit/Prof/Damage/TwoHanded/Element
gear-aware reads; Item_Shared/Forge/Loki category reads; Abil/Cooldown/Spell_Water
casts; Loot/Recharge/Summon_Scaling/ManaRefund/Haste/Oracle/Protect/Shell equipment
effect reads. Initialization is generated from current objects and mappings.
JASS is written CRLF. Review build_forsaken.py main when adding overlays; never
hand-patch a scratch tree and claim the change is reproducible.

The scratch tools/build_stage.py runs the existing source/quest/content/save,
Armory/Bazaar/editor/playable gates, regression suite and 2,000 codec cases;
syncs changed modules, orders libraries and finalizes the map header. The wrapper
copies successful outputs to release/Forsaken and copies the supplied classic
input byte-for-byte. A failed build leaves scratch for diagnosis. It does not
produce an updated classic save adapter.

## Outputs and required review

For stage CC retain:

- `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenCC.w3x`
- `release/Forsaken/1.29.2/FFERPG_0.9.7.3-r16-ForsakenCC.w3x` (unchanged input fallback)
- `release/Forsaken/checks-r16-stageBV.txt`, `build-r16-stageBV.json`
- `release/Forsaken/gear-slots-BV.json`, `forsaken-manifest-BV.json`
- Scratch path printed by the builder, full logs and additional object/gear audits.

Inspect every gate result and verify modern/editor source agreement, native
library compilation, full original object/world/import preservation audit and
the all-276 audit above. For an additional installed-library check, supply the
extracted installed `common.j` and `blizzard.j` paths to
`tools/check_map.py MAP --common COMMON --blizzard BLIZZARD`; record their hashes
and client build. Do not call the bundled files installed-current without checking.
Check classic input/output SHA256 equality. Check the Forsaken manifest says
save_export_disabled and confirm the generated Equip blocker still covers chat,
file, autosave and NG+/− routes. The manifest is a declaration; verify code too.
Run the identity checker against the generated gear mapping. Record actual test
counts from this run; historical BT counts are not a substitute.

The wrapper refuses existing map files; it does not preflight every sidecar or
provide a wrapper-wide concurrent publication lock. Run one builder at a time,
check all six destinations are absent before starting, and retain successful
scratch if copying output fails. Do not delete/reuse an existing release to retry.

After a map build update docs/STAGES.md, docs/HANDOFF.md and the repository's
current resume document if present; record source/input/output hashes, changes,
checks and human tests still pending. Review git diff for canonical source drift
and commit only intended files. Promotion to shared sources/baseline is separate.
Public save release requires SAVE_SYSTEM_PLAN.md Steps 2–7, including real legacy
and multiplayer testing. Until then keep exports blocked.

# October 30 f inventory and loading rollback

2026-11-08. Owner reports the pre-UI96 test also failed and explicitly requests removal of all inventory/loading changes since `FFERPG-0.9.7.5f` dated October 30 at 10:16. This supersedes the earlier investigation hold. No new synchronization mechanism was added.

## Pinned reference

The TEST file is byte-identical to `release/0.9.7.5f/2026-10-30/FFERPG-0.9.7.5f.w3x`: 13,247,631 bytes, SHA256 `da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93`, timestamp October 30 10:16:30 EDT. The classic dated counterpart is SHA256 `4a5197ae2a041629fdce19af05ce02eedd42b58be41e051ae548725390a2c446`. The undated f release folder contains newer files and is not this reference. Both dated originals remain untouched. The owner expects f to work; multiplayer safety is not yet confirmed.

## What changed

Recovery05 modern/classic restore the dated f source for TUnit, TEquip, TItemCooldown, TSave, TLoad, TAutosave, TGame, and every existing TForsaken profile/capture/cache/transport/commit/recovery library. Related talent/passive/status/chronicle ticks and cinematic enter/exit use the dated f implementations. The later Inventory94/FFL94 guards, static item-ability catalogue, load suspension, snapshots, idle/six-slot preview additions and alternate autosave worker are absent. Source verification checks both module identity and removed identifiers.

This intentionally restores old inventory behavior, including any old display or indicator limitations. Autosave and new-game management also return to f behavior; the later default-on, first-at-20-minutes/every-10-minutes repair is not retained. No promise is made that autosave is working in this rollback. Existing save formats and character codes remain compatible.

V16 applies the same rollback to V15. Its TUnit/TEquip controls come from the contemporaneous QuickUI74 development source, preserving the Dragoon/Thief branch rather than importing production Lancer controls. Only current authored stat readouts, spear proficiency mana bonuses and the Icy Realm healing debuff are overlaid. The existing shared spear update remains; no post-f inventory catalogue or guard is retained. Job/monster definitions, difficulty, object data, models, imports and accepted unrelated fixes are preserved. Creature Review03o is rebuilt from V16.

## Outputs and checks

- Production candidates: `release/development/GRecovery05/FFERPG-0.9.7.5g-Recovery05.w3x` and `FFERPG-0.9.7.5g-1.29.2-Recovery05.w3x`.
- Full development: `release/development/V16/FFERPG-V16.w3x`; next full version V17.
- Creature review: `release/development/CreatureReview03o/FFERPG-Creature-Review-03o.w3x` (647 exhibits, 437 unique types).
- All four playable/editor compilation, source/global/startup and native text checks pass. All three full-map save compatibility checks pass (358 items, 22 jobs and retained fixtures).
- Full-map archive parity permits changes only to playable script and trigger-editor source. Development job/monster source parity is checked; the removed inventory-pause flag is the only monster module adjustment.

Builder: `tools/build_f1030_inventory_rollback.py`; review builder: `tools/build_review03_revision_v16.py`. Detailed source comparison: `release/development/GRecovery05/source-verification.json`; installed file hashes: `release/development/GRecovery05/installed.json`.

These checks establish the rollback and build validity. They do not establish the cause of prior desyncs or prove multiplayer stability. Published release files, editor master and the exact f test file are not replaced.

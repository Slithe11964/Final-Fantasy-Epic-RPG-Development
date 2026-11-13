REFERENCE CORRECTION2026-11-08: retained latest-g below was NOT the owner-confirmed working g. See CONFIRMED_G_RECOVERY04.md and pinned hash in AGENTS.md.

Superseded by G_RECOVERY01.md: owner retained accepted Maiden Eye/teleporter/autosave fixes while excluding inventory changes. StableRollback files remain exact g references.

# Recovery to the owner-reported stable g baseline

2026-11-07. Owner reports selecting Squire in Hotfix05 disconnected them. Local09:58 report confirms H05 network desync on turn5860/sixplayers; it does not name a JASS function or establish a native access-violation cause. Preserved under report-2026-11-07-095828. This is distinct from the previous H04 drop disconnect, which produced no report on the owner's client.

## Production: exact rollback

FFERPG-0.9.7.5g-StableRollback.w3x is a byte-for-byte copy of release/0.9.7.5g/FFERPG-0.9.7.5g.w3x, SHA256 f6e884899267949f7f6678442a3cb4888cec1892e8888ef7b4c55b205bca9139. The1.29.2 copy is also byte exact, SHA25652c56ac38ba879aecc5a82a730db273f7bbbe78b5d30acf5a6818a61cfe3dd92. Internal title/version remain g. These are retained maps, not another new hotfix or an H05 rebuild with more guards.

The retained g includes its house regeneration, Minus removal/Plus support, Maiden Eye hidden command, original gear hotkeys/previews and g-era UI/autosave implementation. H-era20/10 autosave refinements, B/inspect/Cancel changes, loading suspensions, private-transport modifications and snapshot wrappers are intentionally not included. The g UI quirks can return. Do not quietly reapply H layers while calling this the stable rollback.

## What drifted

The runtime comparison found62existing function changes and29new functions between retained g and H05. Relevant expansion included loading/rollback, file transport, shared passive/stat/status loops, UI opening/closing/binding, native inventory reads and autosave scheduling. This scope exceeded the original visibility request. The compiler/static tests did not exercise the actual engine multiplayer lifecycle. No exact desync root cause has been proven; do not present conjecture about the snapshot cache as a demonstrated cause.

Comparison details: build/production-recovery-comparison.json and build/development-recovery-comparison.json. These list differences before rollback; no source mutation was required to make the production copies.

## Development: V10 recovery

V10 is derived from V9, restores fifteen system libraries to their corresponding pre-H full-developmentV2 source AND exact V2 playable runtime functions, and removes the H03/H04/H05 header/global/helper layers. The libraries are TTalents,TUnit,TPassive,TRegen,TStatus,TArmory,TEquip,TTravel,TSave,TLoad,TGame,TTitles,TAutosave,TForsakenSaveTransport,TForsakenFreshLoad. V2 retains the Dragoon/Thief/spear development integrations that production g does not have; using it avoids overwriting those with production definitions.

TMonsterData changes only by removing the now-deleted Load04_Busy guard from badge drawing. All V9 unit/item/ability/buff/upgrade definitions, assets, arenas, jobs, monster changes, difficulty scaling, collision implementation and latest badge/Omni display work remain byte exact. Dusk Wyrm's accepted effect remains unchanged. Only war3map.j and war3map.wct differ from V9 inside the archive.

V10 contains no Inventory05, InventoryH03, Load04, KeepInventoryFrames or H autosave scheduler helper. It restores g-era scheduling/UI behavior too; do not claim the latest H autosave timing remains.

## Validation and status

Exact hash/full-byte identity proves production rollback equals the retained release; this is stronger for baseline restoration than another modified candidate merely compiling. V10 passes playable/editor compilation, startup/source/global pairing and native save/load text checks. Fifteen restored runtime libraries match the reference exactly; all objects/imports remain unchanged; creature/job/arena parity checked. Both g copies and V10 pass358item/22job save compatibility.

The owner calls g the last stable version. There is no new live multiplayer verification of V10 and no claim to have identified or fixed every desync. Do not ask for repeated multiplayer sessions based only on compilation. Recommended production choice is the unchanged g rollback, not H03/H04/H05. H05 and V9 are withdrawn as stability recommendations.

Installed TEST copies/hashes in installed.json. Previous releases remain preserved. Current full developmentV10, nextV11. Creature review rebuilt separately from recovered V10 as03m so its current exhibits do not inherit the withdrawn H inventory layer.

Builder tools/build_g_recovery.py; review tools/build_review03_revision_v10.py. Editor master and released g/h sources preserved.

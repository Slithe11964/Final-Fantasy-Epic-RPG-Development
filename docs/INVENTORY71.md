# Inventory-maintenance desync isolation candidate

Owner requests a concrete test after a confirmed release-f desync during loaded
gear/inventory/preview use, with no spell cast. Chat blocked F/G; alt-tab restored
them. Other player left normally. This candidate tests one plausible culprit,
not a proven root cause or confirmed multiplayer fix.

## Change

Previously Forsaken_PrepareInventories called Forsaken_EnableHero for every
loaded hero each second. That path repeatedly added inventory abilities and
processed gear conversion, dual-wield variants and stored passive abilities.

Now a synchronized snapshot checks actual item handles/types in quick, backpack
and equipment slots, current hero, bag size, level, dual-wield/grip traits and
required inventory abilities. Reconciliation runs only when those change. The
snapshot records the final post-conversion state. No hashing/collision shortcuts
or dependence on local visibility, pointer, focus or selection. Native slot
movements are detected even without pickup/equip events. Departed heroes are
rejected and their cached item references cleared.

Forsaken_EnableHero also adds fBag/fGer/ASpc only when absent, rather than
reapplying them on every gear change. F/G icons, key/chat/focus recovery, cursor,
rune layout/aiming and item casting remain byte/token-identical. The original
editor master and prior releases remain preserved.

## Remaining periodic work

- GearCursor_Draw60: .01s (100Hz), cursor/chat recovery/error expiry.
- QuickGear_WheelTick: .05s (20Hz), F/G physical edges, focus reset, icons,
  native bag click observation, active rune drawing, visible cooldown wheel.
- QuickGear_Poll: .1s (10Hz), gear dock state and cooldown revisions/icons.
- Forsaken_PollPanels: .1s (10Hz), panel state; expensive panel draw gated .5s.
- Forsaken_PrepareInventories: 1s, now read/check then reconcile only changes.
- Chronicles_Tick and Armory_PollCounter: 1s, existing revision-based work.
- Forsaken_WaterTick: .03s only during an actual water spell, not idle previews.

Callback frequency alone is not evidence of desync. The local rendering/native
read paths remain possible leads if this isolated change does not help.

## Builds and checks

- `release/development/VersionFHotfix02/FFERPG-0.9.7.5f-Hotfix02.w3x`:
  retained release jobs, based on Hotfix01.
- `release/development/QuickUI71/FFERPG-QuickUI71.w3x`: retains Dragoon/Thief,
  based on UI70.

Seven focused regressions pass:120 unchanged preview-only ticks cause one
reconciliation; native gear/quick/bag moves and in-place type changes detected;
load/job/level/trait changes detected; post-conversion cache stable; per-player
state independent; removed hero skipped/cleared; existing inventory abilities
not re-added. Input/preview/combat functions remain unchanged. Both candidates
pass playable/editor compilation, source pairing, startup/globals/text checks,
save compatibility, content checks, archive readback and unrelated resource
byte comparisons. Logs: build/inventory71-*.txt. Multiplayer acceptance pending.

Test Hotfix02 with the same save and inventory/previews, including typing and
alt-tab, with another player present. Also confirm moving/equipping/unequipping
and F/G still work. If the desync repeats, preserve the newly generated report;
that makes this maintenance hypothesis weaker and leaves local preview work
for the next isolated test. Do not call the unchanged base release fixed.

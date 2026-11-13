# UI62 / native Hotfix10 candidate

Owner's UI61 screenshot confirms `Bag tooltip buffers=4 previews=0 last=` and
`Bag previews=0 hover=0`, while Book of Depths item/ability/icon lookup is correct.
The tooltip text approach failed in the real client. It is retired, including
its native tooltip child discovery. Owner accepts UI61 cyan cursor appearance.

Only TEquip changes from UI61 / native Hotfix09. Cursor bitmap/rendering,
F/G request/receiver and icon update functions are preserved. Object files,
balance, jobs, existing scene crash candidate and skin fallback are unchanged.
Original master and all previous maps are preserved.

## Changes

- Thirty map-owned invisible bag-slot hover probes. Each disables itself FIRST
  on hover so the underlying native inventory retains the actual click, cursor,
  tooltip and cast. On left-button rise, verify the same hero/item raw ID and
  arm the existing water/ice rune renderer. No synthetic native click or item
  movement. No native inventory child traversal or native control hooks.
- Derive probe positions from the already cached bag root dimensions, six
  columns and five rows, with .01 inset. This geometry is an assumption requiring
  client validation. `-gearcheck` reports probe enters/arms/slot/raw/width/height.
- Own warning TEXT now remains enabled with IGNORETRACKEVENTS; disabling TEXT
  could apply disabled gray styling. Explicit gold markup, .024 font (previously
  .018), shadow, actual client pixel center and .507 client-height placement.
  Exact visual match to native error text still requires client acceptance.

## Multiplayer audit and limits

Shared initialization allocates the same 30 probes and one trigger in fixed
order on every client; shared reset destroys only these owned frames/trigger.
Local callbacks modify owned presentation/preview state only. They do not walk
native children, allocate/destroy handles, issue orders, mutate items, or change
gameplay scratch globals. Actual F/G casts retain the existing synchronized
receiver; native bag clicks remain responsible for native casts.

Five focused tests pass: hover releases input before arming, item/hero/focus/bag
guards, divergent simulated clients, fixed shared allocation order, transitive
local-call audit and packaged preservation of casting/icons/cursor/objects.
Both maps pass playable and editor compilation, source/global/startup checks,
save compatibility, content references, archive readback and unrelated-resource
byte comparison. These are static/mocked checks, not native client proof.

**Unverified:** actual hover event delivery, native click-through after disabling
an owned probe, grid geometry/root dimensions, moving rune appearance, exact
warning placement and multiplayer/exit crash behavior. Computer-use runtime
failed initialization earlier, so no live game test is claimed. Do not call
this crash-free or present the backpack preview as confirmed working.

Outputs:

- `release/development/QuickUI62/FFERPG-QuickUI62-Forsaken.w3x`
- `release/development/VersionEHotfix10/FFERPG-0.9.7.5e-Hotfix10-Forsaken.w3x`

Hotfix10 contains no new Dragoon or Thief ultimate. Separate 1.29.2 output was
not requested for this candidate and is unchanged.

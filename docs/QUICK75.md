# Water/ice previews from hero and Gaya quick inventory

Owner asks for Wateraga and Ice Wand U previews when clicking items in the
hero's six native quick slots or the Spirit of Gaya's inventory. Hotfix06/UI75
extend the existing read-only click observer; original releasef remains intact.

## Behavior

Quick slots have separate200..205 observer codes; native item controls retain
all clicks, tooltips, pickup/drop and casts. Cached static origin item-button0
provides visibility/width only. No native event hooks, child-frame walking,
overlay controls, synthesized clicks, new timers or local game-object allocations.
The existing10Hz fallback now observes visible quick slots as well as backpack.
Mouse event handling remains the existing route. The same lookup also recognizes
Book of Depths and other already-supported wave items.

Preview75_Selected chooses the player's selected hero or own Gaya (last selected
eligible unit is preferred for mixed selection). Native preview stores its
caster; water/ice rune geometry originates from that unit. F/G and Calculator
explicitly retain the hero caster. Hero dock hiding no longer clears a valid
native Gaya wave aim. Shared spell observer retains hero diagnostics and queues
deferred owner-local cleanup for the actual preview caster, including Gaya.

Quick slot geometry uses ConsoleBottomBar centering, origin-button width scaling
and native two-column/.03125-button/.04-column/.03815-row layout. Cached installed
inventorybar.fdf supplies the relative button sizes/offsets; absolute HUD anchor
alignment still needs client acceptance. No live client interaction was claimed.
If alignment is off, native item behavior remains unchanged; only preview arming
may be missed. Selection subgroup priority also needs acceptance.

## Validation and outputs

Seven focused regressions pass: selected caster ownership, all six grid centers
and gaps, Gaya native item click/normal right pickup and placement, Gaya-centered
water geometry, deferred Gaya cast cleanup without hero diagnostic corruption,
unchanged F/G/cast receiver/icon logic with no unsafe allocations/hooks, and
hidden hero dock preserving Gaya aim. Both maps pass playable/editor compilation,
source pairing/startup/globals/text checks, content/save compatibility, archive
readback and unrelated resource byte comparisons. Logs build/quick75-*.txt.
First uninstalled compile-order candidate source preserved in
build/candidates/quick75-first-pass.j.

- release/development/VersionFHotfix06/FFERPG-0.9.7.5f-Hotfix06.w3x
- release/development/QuickUI75/FFERPG-QuickUI75.w3x (Dragoon/Thief retained)

These native UI changes do not apply to1.29.2. Existing release pair and original
editor master preserved. Test left-click Wateraga/Ice Wand U from each of the
six slots with hero selected, then Gaya; confirm rune origin, targeting/casting,
right-click movement, and F/G/backpack behavior. Existing multiplayer desync
investigation remains unresolved; this is not a crash-resolution claim.

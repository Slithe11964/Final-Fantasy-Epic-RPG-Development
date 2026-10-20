# PAIR036: Priest Legendary talents and repeated inventory use

The editor master remains the authoring input for both profiles. Shared gameplay,
armory and tooltip changes are generated for both maps; Backpack frames/input are
Forsaken-specific. Save identities, talent persistence and save-code format are unchanged.

## Backpack

Retain a confirmed native inventory binding while the current hero is unchanged.
Closing hides both panes and the talent/stat panel without clicking the native
toggle or discarding that binding. Reopening the same hero restores both panes
without another synthetic native click. Initial opening and a changed hero still
require an observed native binding, with the existing bounded retry.

A real ScriptDialogButton over the Backpack command handles repeat mouse opens
and closes after a successful binding. Before that, the native command remains
accessible. B still has its native hotkey and the debounced custom intent; X and
Escape close both panes. Existing layout, Move to hero and Talents preference remain.
All frames are allocated during shared startup; local visibility never mutates
units/items or synchronized gameplay. A native opening can recover a previous
failed binding even when its mouse event was not delivered to the observer.

## Armory

Index the 280 collectible entries into category lists once. Navigation removes
only the current shop's visible stock and adds the destination page, rather than
removing hundreds of possible items on every click. Player shops track stock
independently. Ownership is read each time a page is shown, so withdrawing or
storing an item still updates that page.

Back uses a dedicated single-rank Channel ability, aRBk. Close remains A0MX on the
root page. Navigation still runs after the Channel callback returns and stops
that order before rebuilding. No navigation changes the currently casting
ability's rank. Existing category labels and progress counters are retained.

## Holy Bolts

Use the real Prof_StaffPower multiplier, together with the existing health-healing
buff/Rejuvenation multiplier, for basic attack damage and the native Attack tooltip.
This includes White Robe, house Staff proficiency, equipped Staff proficiency,
current mana fraction and other existing Life-power modifiers. The attack damage
type remains unchanged. White Robe contributes 30 percentage points at full mana;
ten Staff levels contribute 50 at full mana before the other multipliers.

## Priest Legendary row (level 100)

Choose one:

- **Healing Bolts:** heal living friendly non-structure units along the straight
  basic-attack path for 25% of the health damage actually dealt, after shields
  and capped at the victim's remaining health. The path has the Cure-style
  128-unit radius. Resolution is deferred until the original hit finishes, so
  healing cannot corrupt that hit's damage context. It does not recursively
  trigger on spell damage, healing or mana damage. The native Attack tooltip
  describes the selected talent.
- **Tranquility of Life:** allied heroes killed inside the active channel's radius
  revive at their death position with full health and mana. This intercepts the
  normal town-revival handler. Ordinary corpses use a short-lived Resurrection
  proxy followed by resource restoration. Ending the channel or leaving its
  radius removes eligibility; the caster cannot revive itself through its own
  interrupted channel.
- **Prolonged Cleansing:** Esuna grants a refreshed ten-second protection window.
  Native negative buffs and the map's scripted ailments are cleared immediately
  and every 1/32 second during that window; damage processing also clears them
  before reading target buffs. Beneficial buffs are retained. The timer pauses
  when no protected units remain. This is continuous cleansing rather than an
  engine-wide buff-application interception, so native status application and
  corpse resurrection require Warcraft acceptance testing.

The native fourth row has icons, names/descriptions on hover and the existing
Legendary purchase gate. Classic uses its existing talent dialog. Tranquility and
Esuna append only the selected talent description, independently of calculation
visibility.

## Acceptance checks

Repeatedly open/close Backpack with mouse/B/X/Escape before and after alt-tab,
use/drop items, withdraw from the armory, and switch jobs. Confirm both panes stay
linked and the preview follows the current hero. Withdraw White Robe, then navigate
Body Armors to Armors to root repeatedly and reopen the armory.

Compare Holy Bolts with/without White Robe, house Staff levels and an equipped
Staff at different mana fractions. Test each Legendary choice separately: several
allies on/off the attack path, shields/overkill on the enemy, hero and ordinary
ally deaths inside/outside Tranquility, full revival resources/location, and
negative statuses during/after the ten-second Esuna protection.

Engine and multiplayer acceptance remains required. This does not resolve the
older legacy large-profile Warcraft-menu checkpoint issue.

## Validation and delivery

Both profiles passed the complete build gates: native 246/classic 346 regression
checks with 1/11 expected skips, playable/editor compilation, source/startup
agreement, native-save text safety, save compatibility, content, armory/bazaar and
classic conversion. The final archive audit verifies the new navigation ability,
Priest hooks, linked Backpack input, existing save behavior and all 119 calculation
entries. Both new TEST copies match their release hashes. The original dev.txt
also passed the read-only bounded-codec check and remains unchanged.

The editor master remains SHA256
ae4b422d24c8a5bc5f67250b7ff290b00873cdf1031f7be12071a4e1876e1276.
Forsaken output SHA256:
ecefc08fa82ab9d819d3941cb8cc9115e66ebf5572f3b772aeabc50d46fad596.
Classic output SHA256:
de67aeb2751d2b41095323fa5181c07014accfd4f3400fa136b8bd854f7c7c48.

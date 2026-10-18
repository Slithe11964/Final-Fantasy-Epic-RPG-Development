# PAIR032 backpack input and ability calculations

Build transforms apply to both profiles from the unchanged editor master.

## Backpack controls (Forsaken)

PAIR031 assumed native command clicks finished synchronously, and could click
the Backpack controller multiple times in one callback before hiding an unbound
panel. It also toggled on repeated B key-down events and listened to native
control clicks that could overlap hotkey/scripted commands. These are concrete
input paths that can explain flickering; actual engine acceptance remains needed.
The user reported alt-tabbing temporarily improved the behavior.

A B press now toggles once until key release. Releases with all modifier masks
clear the latch. Native mouse input uses mouse-up rather than control-click,
separating physical mouse input from hotkey and scripted command notifications.
A real user-opened native pane is adopted without clicking it closed. A changed
hero rebind yields between closing, opening and resolving native frames; it
does not issue a burst of clicks in one callback. Missing bindings time out and
stop retrying until deliberate interaction. Explicit close cancels a pending
binding and still keeps both panes closed. Actual selected hero state takes
precedence over stale selection-event cache data.

The Move to hero button is anchored at the lower right above the ring/offhand
row. Its synchronized transfer validation and carried-item behavior are unchanged.
Native drag itself remains unresolved; the explicit picker is the supported path.

## Ability tooltips (both profiles)

Authored prose is retained. Optional calculations now cover:

- Armor Breaker: five times current-rank mana cost plus three times Strength,
  multiplied by Sword technique proficiency; armor reduction precedes the hit.
- Chakra: floor((max(three times target level, target Strength) + 300) times
  rank multiplier / two) HP; MP is one quarter of that. Learned rank multiplier
  is rank plus two, or fifteen at master. Alternate casting uses eight if no
  learned Chakra exists. A self-target preview uses current learned rank/stats.
- Mirage: forty physical evasion score and physical hit chance times 0.8 after
  normal low-chance adjustments when the chance is at least two percent. The
  duration follows rank. Magical checks are unaffected.
- Mega/Giga/Tera Flare, Hellfire, Final Smash and Diamond Dust: their actual
  summon base-attack/level and current-rank mana formulas, with hero-caster
  branches where supported. Bahamut flares include Inner Mana spell power.
- Release: enemy damage based on floor(current corpse HP), plus independent
  93.75–100% HP restoration rolls for nearby allies; enemy/ally radii differ.

The summon command tooltips also respond to -spellcalculations on/off without
requiring the player's hero to own those command abilities. No combat formulas,
spell ranks, summon types or save payloads change.

## Validation

Focused regressions cover repeated key input, modifier releases, delayed engine
commands, bounded failure, native-open adoption, stale selection data, lower
button anchoring, per-rank calculation data and summon tooltip preferences.
Full paired build, regression suites, compiler/editor-source/startup/content/save
compatibility/armory/bazaar gates and classic conversion passed. Final archive
checks verified the controls, lower button, all calculation texts and preserved
save/gear mappings in both outputs. Both TEST copies are hash-verified against
the pair manifest. Actual Warcraft engine acceptance remains pending.

In a fresh PAIR032 game, test B/mouse open and close repeatedly, hold B, switch
windows, drop/use items, switch jobs, and verify both panes remain linked. Check
the lower Move to hero button and all requested spell/summon tooltips with
calculations on/off in both clients. Old Warcraft checkpoints embed old map code.

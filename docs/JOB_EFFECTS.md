# Shared job effects and statistics

PAIR016 maintenance lives in `tools/job_runtime.py` and `tools/job_objects.py`.
The paired builder applies it after merging the editor master with each profile.
The editor master and pinned references remain untouched. Changes also live in
the canonical gameplay sources. Native frame rendering remains read-only and uses
the existing per-render cache; classic keeps its text stat pages.

## Behavior changes

- Necromancer's Undying, Endure, collateral-healing marker and Skeleton Champion's
  Undead Touch use zero-evasion markers instead of Moon Glaive. Their rawcodes,
  authored icons and descriptions remain. This removes upgrade-indicator behavior
  without granting evasion. Direct life healing still hurts undead; mana restoration
  bypasses that conversion. Undying prevents a lethal hit, restores 25% health and
  starts a separate 90-second timer, rather than sleeping inside the damage event.
- Aim's attack-speed penalty runs from 30% at rank 1 through 90% at rank 11, matching
  its descriptions. Its damage marker now supports all 15 mana-derived levels:
  rank 1 uses 3 x 50 flat damage; master uses 15 x 50. The existing 20% multiplier,
  accuracy and 30%/20% damage-taken rules are retained.
- Myriad Arrows and Meteor proxies retain their invisible model and Locust but are
  no longer hidden before starting a channeled Blizzard order. The same correction
  covers Wide Meteor. Their mana is filled before the order.
- Both Chemist consumers use one full-inventory search, starting with quick slots.
  The helper returns its chosen item ID through the shared result expected by
  Pharmacology and Noxious Mixture. It consumes one charge of the first match.
- Divine Shield retains its rank efficiency (2 through 5 blocked damage per mana)
  and redirects up to half of life damage, bounded by the caster's mana. Fractional
  payments work; mana damage is not redirected; dead/missing/invalid casters and
  exhausted shields expire cleanly. A missing spell target falls back to the caster.
  A 600-damage hit with sufficient mana becomes 300 damage and costs 150 mana at
  rank 1 or 60 mana at master. This is intentionally not 3,000 mana.
  Replacing another Prophet's shield also disconnects the previous caster and
  clears the cancelled timer's stored unit references. The old caster can then
  shield someone else without removing the new caster's protection.

## Presentation

Damage, defense and other-bonus pages show the active effects of Aim, Rage,
Dark Power, Drain Attack, Mana Spring, Concentration, Mind Charge, Blessing of
Might, Divine Shield and Infinity. Rank-dependent rows use current ability rank;
transferable Rage snapshots the casting ability and rank so an ally's display does
not substitute their own learned skill. Snapshotting happens on synchronized spell
events, never inside a local UI callback. Snapshots are discarded on unit death.

Dark Power's reduction is 90% times the missing-health fraction, not a fixed armor
bonus. Drain Attack's loss is 42%-2% per rank (25% at master); lifesteal is 50%.
Mind Charge doubles spell potency and its self buff removes 30 armor. Infinity
nullifies covered damage rather than providing an ordinary armor bonus.

Imperil moves each resistance down one tier, not by a universal percentage:
Absorb -> Immune -> 50% -> 20% -> 0% -> -60% -> -100% -> Lethal. Negative
resistance increases elemental damage taken. Lethal kills ordinary units; heroes
and resistant units take double damage instead. The description states this ladder;
the resistance page continues to show each element's resulting resistance.

## Verification and engine acceptance

`tools/tests/test_job_effects.py` executes the changed JASS paths with mocked
natives: mana/life separation, last-bag-slot selection and priority, shield payments,
90-second cooldown cleanup and lethal-hit gating, two-Prophet shield handoff,
rank-dependent buff speeds and stat rows, visible proxy orders, and idempotent marker/Aim object edits. Paired compiler and content
checks must pass before publication. These checks do not prove Warcraft rendering,
channel completion or combat timing.

In both clients, test lower and master ranks; cast Myriad/Meteor on enemies; test
Undying twice within 90 seconds and again after 90 seconds; use mana potions/food
on Necromancer; toss a Chemist item from the final bag slot; and inspect each panel
while applying, expiring and removing its buff. Check a shield with ample and nearly
empty mana, including when protecting an ally. Multiplayer spell-event snapshots
must remain synchronized. The separate classic large-character Warcraft checkpoint
crash is not addressed by this job patch.

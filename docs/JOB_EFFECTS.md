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


PAIR022: master summons and effect text
-------------------------------------
Master-rank Animal Companion, Dragon Ally, Golem, Shiva, Ifrit, Cyclops,
Bahamut, Neo Bahamut, Raise Dead (both skeleton types), and Battle Ward use
isolated ordinary-unit templates with ulev=40. They keep lowercase raw IDs,
stock nonhero bases, stats, abilities, models and classifications; no hero
conversion or runtime hero-level setter is used. Lower rank templates and
world/enemy uses of the originals are untouched. Bahamut Zero already has level
40 at all ranks and remains unchanged. Summon tables use rank11, while Bahamut
and Neo Bahamut use their actual maximum rank6. The paired object pass adds
both main and skin template records after authored data merging; the master
is unchanged. Reserved generated IDs sM00-sM0A are not save identities.

Deathbringer's A10X execution check is strictly target level <40, independent
of hero conversion. The execution rule is unchanged. Other level-based effects
still use their own original conditions.

Rage A070 uses Blo1=0.60 at rank1, 0.85 at rank6, 1.20 at master (rank11):
+60%, +85%, +120% attack speed. Self-Rage A025 uses bsk2=0.40, 0.65, 1.00:
+40%, +65%, +100%. Both old tooltip progressions incorrectly doubled these
values; aub1/arut now match current-rank gameplay and the existing stat rows.
No attack-speed or damage balance change.

While B06L is active, Defenses shows Protection from lethal damage: Trance.
While B06W is active, Defenses shows Mirage physical evasion +40 and physical
hit chance x0.8. Mirage's physical-only hit calculation subtracts40 before its
existing compression steps and then multiplies the remaining chance by0.8
when the chance is at least2; this is not a universal +40% dodge chance.
These bonuses are constant across ranks; Mirage duration scales with rank.
Aim's master defense entry is explicitly +20%, with +30% at lower ranks.
Rows disappear when their associated buffs end. Classic text stats and native
panels use the same effect-row template.

Validation: sixteen actual-JASS/object regression tests pass. Full paired gates
and native/legacy archive verification are recorded in STAGES.md; in-game
summon/UI acceptance remains separate from mocked execution.


PAIR023: ordered stats, proficiencies and White Robe
--------------------------------------------------
Both profiles use the requested Damage/Defenses/Resistance/Other row ordering.
Accuracy/Evasion omit "rating". Physical/Magical Block and defense percentages
always include %. Flat damage appears only above zero; positive healing and mana
efficiency include +. Legacy regeneration rows explicitly say Unavailable because
1.29.2 has no safe live regeneration getter. Native short percent values get enough
width to keep their percent sign visible.

Defend displays 20% physical block, rising to 30% only while the existing
udg_DefendingUnits Hold Position membership is active. The user revoked the
suggested Sentinel connection; Sentinel has no additional block. Damage engine
and order detection remain unchanged.

White Robe grants 6 Staff proficiency (9 after High Proficiency), not a fixed
Life damage percentage. Its item/equipped-variant/Armory text explains the 6
levels and +30% of base spell power at full mana before other bonuses. Other
bonuses displays the current relative increase from those levels, using the
same mana-weighted Staff spell factor. Common Concentration/Mind Charge factors
cancel in that relative calculation. No abilities, mana or gear are temporarily
removed/modified to calculate it. Unequipping hides its effect row.

Page5 lists effective proficiency levels for the displayed hero, including worn
gear, passives and the existing Greatsword contribution. Axe training is explicitly
labelled separately: the legacy R008 research is not an effective Prof_GetLevel
weapon family. Both ordinary Axe and Heavens Forged Axe are retained. Native
Back/Next buttons wrap all five pages and traverse the extra conditions view in
both directions. Legacy uses -stats 1..5, -stats next and -stats back, with page
state per player.

Completed house research gains a zero-effect, non-item AIev passive icon using
the master upgrade's max-rank icon and description (without purchase requirement).
It does not increase the research limit or offer another purchase. A synchronized
selection/research-finish/spell-finish listener reconciles the owner's actual
house type/caps, including loaded research and house option switching. No
periodic polling, local gameplay writes or changed save IDs.

Native inventory/inspection covers Hunt Club as well as the scoreboard. Original
Hunt show/hide requests set a shared desired flag; local UI cover uses that flag
to restore only a board the game still wants displayed. Closing inventory after
all hunts finish does not resurrect an empty board. Legacy board behavior stays
unchanged. Presentation and focused execution tests are separate from actual
engine acceptance.

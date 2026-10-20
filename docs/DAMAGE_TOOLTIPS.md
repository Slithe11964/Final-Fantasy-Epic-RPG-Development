# Damage descriptions (PAIR025)

The paired builder applies tools/damage_tooltips.py after the editor/profile object
merges. Authored targeting, effects and duration text are retained; a gold Damage
details section supplies the rank-specific numeric mana term and actual attribute /
proficiency formula. Both base and skin ability tables receive the same text.
This changes presentation, not damage, cooldowns, costs, targeting or save identities.
The saved editor master is not modified. Subsequent editor changes still flow into
both builds; damage constants/wave counts are derived from its saved object fields.

PAIR035 removes the repeated STR/AGI/INT, mana-fraction and rounding footer from
all generated damage tooltips and dynamic calculation data. The explanations
below remain developer reference; each ability retains its own calculation.

STR, AGI and INT include bonuses. Technique proficiency is the effective value,
including equipment/house bonuses. Spell power uses current MP / maximum MP at
cast time, the listed proficiency weight, Mind Charge and Concentration. Integer
JASS divisions round down. These are base damage formulas: damage bonuses, target
defenses, hit rolls and spell-specific random rolls still affect the final result.
For example master Fan of Knives lists (600 + 4 x AGI) x (1 + 10% x Dagger
proficiency), rather than implying a fixed result for every character.

## Coverage

Arrowwave is the map's spelling of the requested Arrowweave. Minus Strike is the
actual ability name corresponding to the requested mina strike. There are 40
formula families covering 87 player/item spell IDs, including scripted variants.
Invisible damage-only proxies are not relabeled as player abilities.

| Formula family | Ability IDs |
|---|---|
| fan | A0QS |
| knot | A0SP A17D A0SQ |
| shock | A13K A15A |
| rapid | A0AE |
| arrows | A0QQ |
| myriad | A0R0 |
| wave | A01L A0ZN |
| rave | A0QO |
| gaya | A05P |
| gaya_limit | A0TR |
| iai | A18P |
| mineuchi | A02E A0XR |
| tatsumaki | A18H A1AT |
| breath | A11R A0EL A0SL |
| slam | A03M |
| jump | A14D |
| ambush | A156 |
| shuriken | A0AD |
| liquid | A0QH A01Q |
| eclipse | A0QJ |
| finisher | A0HN |
| darkness | A0KS A0U5 A183 |
| minus | A0Z5 |
| mixture | A0GZ |
| molotov | A0ZZ |
| bolt | A00O A0TO A07O A19R |
| ice | A0Q7 A0Q9 A19Q A0IO A0UT A0BG |
| fire | A0PU A0QA A19P A0SH |
| tornado | A149 A00A |
| meteor | A0QM A0QN A12I A1F2 |
| wide_meteor | A028 |
| shot | A171 |
| scourge | A0VM A12M A0VL A0X5 |
| firaga | A0QD A0UX A0SG |
| thundaga | A0QF A0UZ A0TN |
| blizzaga | A17S A0TM A0UY |
| blast | A039 A0UF |
| flare | A0TB A0TD A0TC A0TF A0TE |
| holy | A04K A01V A0E5 A11X A0UE A0XI A0CY A11L |
| oblivion | A0ZV |

## Source-specific details

- Fan/Knot/Shock/Arrowwave use their original proxy-damage snapshots. Knot uses
  current HP, not missing or maximum HP. Shock sums Sword and Axe proficiency.
- Rapid Fire shows the per-arrow 93.75%-100% roll and 16 arrows. Myriad and Meteor
  show damage per wave and actual authored wave counts at that rank; Meteor's
  damage per wave is independent of rank, while wave count scales with mana cost.
- Wave Fist and Rave Kick describe unarmed and disabled-target multipliers and
  High Proficiency. Wave Fist collision can deal the same damage a second time.
- Iainuki explains its 10%-per-recorded-combo-hit multiplier; Jump shows capped
  starting distance and half-damage splash excluding the main target. Ambush
  shows its 420-range boundary and triple close-range damage.
- Tatsumaki distinguishes the final hit from 10% spinning ticks. Liquid Steel
  and Eclipse use the existing Hybrid proficiency formula. Yuffie's Shuriken
  states damage per contact, avoiding an unconditional total across movement.
- Finisher lists Failed, Mighty Swipe, Holy Strike and Elemental Quartet, with
  damage, rank-dependent chances out of 26, missing-element failure and Holy
  Power's guaranteed Holy Strike. The original x(10 + Hybrid) is intentional;
  it must not be changed to the ordinary x(1 + 10% x proficiency) multiplier.
- Noxious Mixture lists all 12 consumables by family/quality and the actual
  80/125/200/300/500 potency branches, Ether's integer 5/4 bonus and Nectar/Hero
  Drink's halved INT term with pure-damage difficulty scaling. Damage is per
  cloud pulse, rather than an invented guaranteed total for a moving enemy.
- Molotov states damage per victim attack. Fire/Dragon Breath/Scourge distinguish
  repeated damage from an initial hit. Bolt outgoing missiles are 30% of direct
  damage; Holy Blast travel hits use the actual 66% for both player variants.
- Blizzaga distinguishes three main waves and shard damage. Holy lists enemy
  damage and allied healing. Darkness states its maximum-HP sacrifice. Minus
  Strike shows its square-root current-HP-percent denominator and fixed +500.
- Oblivion describes its 0.8-second pulses, enemy proxy damage and rolled undead
  healing separately; it retains the original eight-second lifetime.

## Scroll carrying requirements

Scroll of Shadows (I073) and all 25 Curse-prefixed scrolls are exempted from the
Gaya level check in TEquip, including scrolls already held with older saved item
life values. Item HP/durability, subtype, class, prices, abilities and result gear
are unchanged. Curse descriptions label their old Required level line as Resulting
gear required level, and explicitly state no level requirement to carry the scroll.
Lady Curse proximity, required source gear and resulting gear equipment requirements
are unchanged. 1.29.2 keeps its existing unrestricted carry-space behavior.

## Validation

Six focused regressions cover every requested family/rank in both object layers,
numeric rank/wave data, unchanged combat object fields, Finisher/mixture branches,
contradictory authored numbers, idempotence and unrestricted scroll carrying while keeping ordinary gear gated.
Paired build, final archive and installation results are recorded in STAGES.md.
Actual tooltip layout/wording acceptance still needs Warcraft testing.

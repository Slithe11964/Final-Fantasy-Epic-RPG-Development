# Central Islands — QuickUI95 / Creature Review 03d

Full Dragoon development only, based on QuickUI94. Production 0.9.7.5g,
classic, editor master, previous tests and arena team/roster scripts stay intact.
All requested levels, HP, armor and attack ranges are authored Normal values.
`tools/build_central95.py` records the exact 23-unit stat table in its manifest.
Owner clarified the duplicate ID: **njgb** is the level 30 caster, **njga** is
the level 27 critical-strike attacker.

## Requested roles

- Adaman Tortoise **ntrd**: level 45, 17,500 HP, 400 armor, 917–932 attack;
  15% physical/spell block. Adamanchelid **ntrg**: level 30, 7,000 HP, 250 armor,
  300–312 attack; 10% physical/spell block. Old native Hardened Skin removed so
  its separate reduction does not stack with or obscure the specified guard.
- **nahy**: level 30, 5,000 HP, 58 armor, 252–281 attack, 40 evasion. Native
  Spawn Hydra retained: two nhyd offspring on death. Poison: 25%, 10 + 6 ×
  attacking hydra level per second for 10 seconds.
- **nehy**: level 26, 4,000 HP, 44 armor, 200–218 attack, 40 evasion, Night Might.
  Poison: 33%, 100 + 5 × attacking hydra level per second for 10 seconds.
  Both hydras lose the old A0PH poison to avoid a second independent poison.
  Equal/stronger applications refresh existing poison rather than stack.
- **ntrs**: level 20, 3,200 HP, 47 armor, 176–181 attack, 10% physical/spell block,
  Central Islands Alert. **njg1**: level 20, 3,700 HP, 38 armor, 171–183 attack,
  40 evasion, the same regional Alert. Existing 15-second call/final 5–1 countdown;
  kill caller to cancel; 60 seconds of doubled frequency, amount and population
  cap in zone 3 only. Repeated alerts refresh the window; they do not multiply it.
- **njgb**: level 30, 7,400 HP, 62 armor, 306–332 attack, 1,000 mana. Command Aura
  gives melee allies within 600 +15% attack damage. 1–2 Punch costs 150 mana,
  cooldown 30: first 1,400 water damage + one-rank Imperil for 10 seconds; after
  exactly two seconds, 1,000 earth damage and a three-second stun if the enemy
  remains alive and within 300. Devour costs 200, cooldown 20, two injured friendly
  Central pool creatures maximum; same stat absorption as Nerubian Queen.
  Unlocks Elementa. See the chosen unspecified values below.
- **njga**: level 27, 6,100 HP, 52 armor, 250–259 attack. A single 20% roll on a
  landed normal attack gives ×2.5 damage and 20% attack/movement slow for five seconds.
- **nlkl**: level 29, 6,800 HP, 212–243 attack; existing armor retained. Stone Knives
  uses native Fan of Knives, 1,600 earth damage within 600; 200 mana, 15-second CD.
- **nlsn**: level 26, 4,420 HP, 51 armor, 197–205 attack. Tidal Shuriken follows
  the Ninja's spinning/returning path and hit groups, with a blue Sentinel glaive;
  1,400 water damage per contact, 200 mana, 15-second CD. Ninja's spell unchanged.
- **nltc**: level 24, 3,340 HP, 28 armor, 157–192 attack. Water Wave: 1,200 water
  damage along a 1,000-unit path, 200 collision radius; 100 mana.
- **nlds**: level 25, 4,800 HP, 34 armor, 238–247 attack. Berserk: +80% attack speed,
  +20% damage taken for 10 seconds; 20-second CD.
- **nlrv**: level 29, 4,100 HP, 7 armor, 193–211 attack. Shielding Shout grants
  allies within 600 +10 percentage points physical/spell block for 20 seconds.
  Raise Shield grants +40 physical block for 10 seconds, 30-second CD. Bonuses stack.
- **ndrv**: level 27, 3,600 HP, 5 armor, ranged 152–189 magic attack, range 600.
  Native self-Banish lasts 15 seconds (ethereal physical-attack immunity, including
  physical ranged attacks). While banished, Summon Tidal Guardians is usable:
  two guardians, 60-second life, 2,000 HP, 3 Divine armor, 125–139 magic attack,
  range 600. Frost attacks slow movement 30% and attack speed 20% for three seconds.
- **nsrv**: level 23, 2,900 HP, 10 armor, 184–187 attack. Binding Net: a genuine
  four-second native stun with orange Ensnare art/projectile; prevents all actions.
  Gaya's Break Stun removes its custom buff. 300 mana, 20-second CD.
- **ntrv**: level 20, 1,900 HP, 4 armor, 127–129 attack. Blind costs 200 mana and
  uses the map's normal Blind status, respecting Blindproof and Eye of the Dragon.
- **nsc2**: level 27, 5,000 HP, 38 armor, 157–182 attack. Pinch: 1,200 physical
  damage and −30 accuracy for 10 seconds; 200 mana, 15-second CD.
- **nsc3**: level 24, 4,200 HP, 32 armor, 172–201 attack. AI burrows at half HP;
  hidden/invulnerable for five seconds, then full healing and +80 evasion for three
  seconds. Restores its previous invulnerability state. 200 mana, 30-second CD.
- **nscb**: level 21, 2,800 HP, 29 armor, 170–191 attack. Earthen Whirlwind:
  800 earth damage per second for five seconds within 250; 200 mana, 30-second CD.
- **nmsc**: level 27, 4,100 HP, 29 armor, 161–189 attack. Blind removed. Healing
  Rain channels Tranquility-style rain: 200 healing per second to allies within 600
  for ten seconds; moving/stopping ends it. 200 mana, 20-second CD.
- **nmtw**: level 24, 3,150 HP, 44 armor, 210–231 attack. A real dash, then
  1,000 physical damage and 100 + 7 × wounded hero level physical bleed per second
  for five seconds; 250 mana, 20-second CD.
- **nmcf**: level 22, 2,800 HP, 41 armor, 135–154 attack. Elemental War Cry:
  allies within 600 gain +100 attack damage for 20 seconds; melee attacks become
  earth, ranged attacks water. Native attack bonus and elemental override expire
  together. 30-second CD.
- **nmbg**: level 20, 3,150 HP, 32 armor, 154–193 attack; permanent +30% attack speed.

## Chosen unspecified values

Elementa uses the existing Fire, Ice and Bolt effect paths. Each primary hit is
**2 × current base attack damage**, including Devour's base-damage gains. Existing
Fire/Ice splash and Bolt's 30% secondary projectiles remain. Cooldown 45, cost
1,100 mana as requested. The caster has 20 mana regeneration per second so its
larger post-Devour pool can refill; initial maximum mana stays 1,000.

Water Wave cooldown 20 seconds. Critical slow five seconds. Shielding Shout:
20-second duration/30-second CD/no mana. Self-Banish: 100 mana/30-second CD;
guardians: 150 mana/30-second CD. Pinch accuracy loss lasts ten seconds. Blind uses
the map's existing half-hit-chance, 30-second duration and ten-second CD. Newly
mana-using units with an insufficient pool receive 600 mana; specified pools win.

## Presentation, safety and test workflow

New front-facing spell icons are verified against installed assets and differ
from differently named role icons used by earlier monster pools. Matching
status icons intentionally follow their corresponding spell. Familiar roar and
Defend families remain for shouts/guards. Central effects include Crushing Wave,
blue glaive, earthy dust, brown tornado, healing rain, orange net, Banish and
element-specific punches. No inherited purple Channel target art on new channels.
All affected unit/spell tooltips contain readable effect and damage/healing values.

The existing shared one-second role heartbeat drives new AI and active buff/DOT
work. Charges reuse the active-only 10 Hz charge timer. Shuriken and waves reuse
existing projectile engines. The punch's two-second delay is a one-shot timer
that destroys itself. No new polling timer, local gameplay state, inventory
observer, mouse callback or sync traffic. Native/editor compilation and regression
checks do not establish multiplayer or visual acceptance in the actual game.

Creature Review 03d keeps Normal stats and the existing regional/boss layout.
Smaller Hydras and Tidal Guardians are beside Central Islands in the summons
section; they are not added to regular world pools. Select Ancient Hydra and type
**-split** to kill it and show the native split. Selection remains silent; use
**-info**, **-abilities**, **-spells**, **-enemy**, **-wound**, **-refresh** as before.
Review initializes the Shuriken wrapper callbacks and the read-only item catalogue
needed by current combat/stat helpers; actual Fire/Ice/Bolt/Shuriken events register.

Build tools: `tools/build_central95.py`, `tools/build_review03_revision95.py`.
Runtime fragment: `experiments/GuardiaForest/Central95.j`.
Tests: `tools/tests/test_central95.py`. Logs: `build/central95-*.log`.
Both outputs use unique TEST filenames and preserve all previous maps. Native
AI, animations, sounds, damage pacing and multiplayer play still need user testing.

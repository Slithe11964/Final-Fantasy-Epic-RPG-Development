# Phase 8–9 test checklist: r15

Map: `release/FFERPG_0.9.7.3-r15.w3x`. It replaces r15test; the differences are only the map name and the variable sub-folders.

What changed since r14:

- **Damage formula split:** `Trig_Damage_Engine_CalcDamage` is now 19 step functions.
- **Variable Editor:** 576 shared variables moved into it.
- **Renamed modules:** `Hero_Part01` → `Hero_Skills` and `Player_Part01` → `Player_Hero`.

The playable script is the same as r14, except for the damage split.

Use a late-game save code (high-level jobs, a Master job, Gaya, armory) so most systems are
reachable.

## 1. World Editor (5 min)

- [ ] The map opens with no errors.
- [ ] The Trigger Editor has a **Shared variables** folder at the top, with 9 sub-folders (Shared helpers … Player features).
- [ ] The map name and loading screen say **0.9.7.3-r15**.
- [ ] Ctrl+B (Variable Editor) lists the variables (e.g. `PlayerHero`, `JobUnitType`, `TempPoint`).
- [ ] **Save As** works with no JassHelper errors. Play test from that saved copy.
- [ ] Pick a GUI action such as "Set Variable". The shared variables appear in the list.

## 2. Load and save (5 min)

- [ ] `-load <your late-game code>`: heroes, job levels, items, Gaya, house items, upgrades
  and titles all come back.
- [ ] `-save`, then restart and `-load` the new code. Everything is the same.
- [ ] `-savef test` then `-loadf test` (single player) works.
- [ ] The in-game Save Game menu works: save, quit, then load the saved game.

## 3. Damage engine (the main thing to test, 20 min)

Turn on `-damagetext` to see numbers.

- [ ] **Melee:** normal hits, critical hits (critical effect) and cleave work.
- [ ] **Ranged:** Archer or Gun hits. Misses and evades show ("Miss" / evade text).
- [ ] **Block / parry:** a shield or block ability sometimes blocks.
- [ ] **Magic:** a Wizard spell of each element. A monster weak or resistant to an element
  takes more or less.
- [ ] **Healing:** Priest Cure / Regen heal. Healing an undead monster damages it.
- [ ] **Holy / pure damage:** Holy Swordsman skills hit hard and ignore what they should.
- [ ] **Cover (Knight):** an ally with Cover takes the hit for the target. *This is the step
  that can end a hit early. Make sure the covered unit takes no damage and the Knight does.*
- [ ] **Protect / Shell, Haste, Berserk:** damage taken and dealt changes as expected.
- [ ] **Marked for Death / damage-over-time / counter-attack:** a hit that causes another hit.
  No freeze, and numbers look normal.
- [ ] **Mana damage:** a spell or attack that burns mana takes mana, not life.
- [ ] **Difficulty:** compare damage taken on two difficulties if you can (it should scale as
  before).
- [ ] **Long fight:** fight for 5+ minutes. No slowdown or freeze.
- [ ] **Damage meter:** the `Dps` meter and battle log (`-battlelog`) still count damage.

## 4. Jobs (10 min)

- [ ] Change job at the shrine a few times. Items, life % and mana % carry over.
- [ ] A Master job gets its +stats. Learning skills at level 50+ still works (`Hero_Skills`).
- [ ] Freelancer: Shrine of Individuality slots 1–4 work. A Master job swaps a skill.
- [ ] A locked job shows its requirement text.

## 5. Late game (as much as you can)

- [ ] **Bosses:** try 2–3 bosses you can reach (for example Belias, Zalera, Odin, Ultima, Chaos).
  - Their spells hit.
  - They die and drop loot (`Boss_Drop`).
- [ ] **Arena:** enter, pick a team, and play a round or cup. Rewards are given.
- [ ] **Hunts:** take a contract from the hunt board, kill the target, and get the reward.
- [ ] **Chocobos:** tame one, ride it, dig, breed if you have two, and use the upgrades.
- [ ] **Summons and Gaya:** summon and fight. Gaya follows, heals and levels.
- [ ] **Spawns:** walk into 2–3 zones (one at night). Monsters appear, respawn and drop items.
- [ ] **Crafting:** forge or craft one item. Sell and buy at a merchant.
- [ ] **Quests:** turn in a quest. The quest log (F9) still shows the help entries.

## If something breaks

Write down:

- what you did;
- the message, if any;
- the job and the target.

For damage problems, the step functions are in the `Damage` trigger (folder 04):
`Trig_Damage_Engine_Step01_Setup` … `Step19_Apply`. Most bugs will be in the step named after
the feature (Cover = Step04, Evasion = Step10, Magic = Step17).

# Jobs: how heroes, job change and mastery work

Modules (all in folder 03): `Job`, `Shrine`, `JobLevels`, `Promotion`, `DarkJobs`,
`Hero_Skills`, `Player_Hero`, one module per job (`Lancer`, `Ninja` …), and `Legend` /
`Legend_*`. The tables are filled in `Init` (02).

The system follows Final Fantasy Tactics: you start as Squire or Chemist, and levelling jobs
unlocks new ones.

## One hero unit per job

- **Separate hero units.** Each job is its own hero unit type (`'H000'` Squire, `'H003'`
  Knight …). A player owns one hero per job they have used. They are kept in
  `udg_JobHeroHash[jobTypeId][playerId]` (`Job_GetHero` creates one the first time).
- **The current hero:** `udg_PlayerHero[player number]`. Code reads it through
  `Player_GetHero(p)` (module `Player_Hero`).
- **Unused jobs:** heroes of jobs you aren't using are hidden, invulnerable and owned by
  Neutral Passive, at the player's start location. They keep their own level and experience.
- **Job levels from a code:** a job not yet created in this game takes its saved level from
  `udg_JobLevelHash` (filled by `-load`). The hero is created at that level when you first
  switch to it.

## Changing job (`Job_Change`, module `Job`)

The job shrine "sells" a dummy unit for each job. `Trig_Job_Change_Actions`:

1. Removes the sold unit and checks:
   - the buyer is the player's own hero;
   - the job is different from the current one;
   - the job is unlocked (table below).
2. Saves the old hero's items, life %, mana %, position and facing.
3. Hides the old hero. Then it moves the new hero there, gives it to the player, and moves the
   6 items across.
4. Moves mastery bonuses, Freelancer/borrowed abilities, the Dark Knight boss-group flag, and so
   on from the old hero to the new one.

### Unlock requirements

A job is unlocked once its saved level is above 1 or when the rule below holds:

| Job | Needs |
|---|---|
| Squire, Chemist | always |
| Knight, Archer | Squire 8 |
| Monk | Knight 8 |
| Thief | Archer 8 |
| Wizard, Priest | Chemist 8 |
| Summoner | Wizard 8 |
| Time Mage | Priest 8 |
| Geomancer | Monk 8 + Archer 8 |
| Samurai | Thief 8 + Knight 8 |
| Lancer | Geomancer 8 + Thief 8 |
| Ninja | Samurai 8 + Monk 8 |
| Mediator | Summoner 8 + Priest 8 |
| Oracle | Time Mage 8 + Wizard 8 |
| Calculator | Mediator 8 + Time Mage 8 |
| Prophet | Oracle 8 + Summoner 8 |
| Holy Swordsman | all warrior jobs at 15 (title `udg_TitleForce[1]`) |
| Sorcerer | all mage jobs at 15 (title `udg_TitleForce[4]`) |
| Dark Knight | main questline done + Holy Swordsman 20 |
| Necromancer | main questline done + Sorcerer 20 |
| Freelancer | any job mastered (title `udg_TitleForce[10]`) |

The requirement text shown to the player is set in the same place (`udg_JobRequirementText`).

## Tables (mostly set in `Init`)

| Variable | Meaning |
|---|---|
| `udg_JobUnitType[0..21]` | Hero unit type of each job, in this order: Squire, Knight, Archer, Monk, Thief, Geomancer, Samurai, Lancer, Ninja, Holy Swordsman, Chemist, Wizard, Priest, Summoner, Time Mage, Mediator, Oracle, Calculator, Prophet, Sorcerer, Dark Knight, Necromancer. |
| `udg_JobCount` | 22, the number of jobs above. Freelancer is not in the table: `Job_GetIndex` returns 22 for it (its "Versatility" ability). |
| `udg_JobSkill[i*5+1 .. i*5+5]` | The 5 skills of job `i`. |
| `udg_MasteryBonusAbility[5..9]` | Legendary mastery bonuses (Last Stand, Focus, Adrenaline, Serenity, Spellbreaker), set in `Shrine_Create`. |

`Job_GetIndex(unit)` turns a hero into its job index `i`.

**Order matters.** The save code stores job levels in `udg_JobUnitType` order. Read
[SAVE_CODES.md](SAVE_CODES.md) before adding or reordering jobs.

## Levels and mastery

- **Mastery ability:** mastery is the level of the "Mastery" ability `'A02F'` on the hero:
  - level 2 at hero level 50 (+20 to all stats);
  - level 3 at 99 (+50);
  - level 4 = Master (+100), saved as job level 100.
  - levels 5–9: a legendary bonus picked at the Shrine. The hero gets
    `udg_MasteryBonusAbility[level]`.
- **Learning skills:** at hero level 50 or higher, `Job_MaxSkills` learns all 5 job skills.
- **Totals:** `JobLevels` keeps the per-player total of job levels, used by titles and the
  multiboard.
- **Promotion:** gives promotion rewards. `Exp`, `Levels` and `Prof` cover experience and
  weapon proficiency.

## Shrine of Individuality (`Shrine`)

The shrine lets a hero use skills from other jobs:

- **Freelancer:** picks any 4 job skills into slots 1–4
  (`udg_AbilitySlot1..4[player number]`). A skill can only be picked from a job the player has
  mastered.
- **Other jobs:** once Master, a job can swap one of its own skills for a skill of another
  mastered job (`udg_MainSkillSlot` / `udg_SubSkillSlot`).
- **Legendary mastery:** gives a legendary bonus (`Legend_*`).
- **Special skills:** Alchemy (Chemist) and Enchantment have special handling, because they add
  extra abilities.
- **Unlocking:** `Shrine_Unlock` reveals the shrine when the story reaches it. There are two
  shrine locations, each with its own set of menu units (`udg_ShrineMenuUnit`).

## Adding a new job: checklist

1. In the Object Editor, create the hero unit and its 5 abilities. Add the unit to the job
   shrine's "units sold".
2. In `Init`, append the unit to `udg_JobUnitType` and its skills to `udg_JobSkill`. Raise
   `udg_JobCount`.
3. Add an unlock rule in `Trig_Job_Change_Actions`.
4. Give the job's own passives a module in folder 03 (copy a small one, such as `Lancer`).
5. Update the save code. It needs a new version, see [SAVE_CODES.md](SAVE_CODES.md).
6. Run `python tools/check_map.py` and test switching to and from the job, saving and loading.

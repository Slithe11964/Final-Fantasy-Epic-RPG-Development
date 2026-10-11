# Job talents

Module `src/triggers/03 Jobs and progression/Talents.j`; objects added by `tools/talents_catalog.py`.

## How it works

- Every player hero gets a **Talents** button (`tTal`, hotkey T) in command-card slot (0,1).
- Four rows of three choices per job. Row 1 is open from the start, row 2 at mastery (level 50),
  row 3 at ultimate mastery (level 99), row 4 at legendary master (level 100). Rows follow the
  Mastery ability `A02F` (levels 1-4; legendary bonus levels 5-9 count as 4).
- One choice per row. Picks last for the current game (not saved). The Shrine of Individuality
  (`n04U`) sells **Reset Talents** (`nTRt`, 1000 gold for testing, bottom-right slot): it clears the
  current job's picks only and refunds the gold if there was nothing to reset. The Legendary Bonus
  Menu moved one slot left to make room.
- A talent only works while the hero's **current job** is the talent's job **and** the hero has the
  spell it changes: `Talent_Active(hero, job, row, choice, spell)`. A Freelancer or another job
  with the spell swapped in gets nothing; a mastered hero who swapped the spell out gets nothing.
- The dialog (used by the 1.29.2 build) shows one row at a time: names and descriptions wrapped to
  30 characters (dialogs do not wrap text), "Learn <name>" buttons, Next row, Close. Reforged has a
  frame panel for now; the plan is to replace it with the Forsaken-style panel later.

## Adding talents for a job

1. In `Talents_InitData`, set `TalentName[Talent_Index(job,row,choice)]` and `TalentText[...]`.
   Job indexes are `udg_JobUnitType` order (JOBS.md); Priest is 12 (`TALENT_JOB_PRIEST`).
   A choice with no name shows "Not written yet" and cannot be picked.
2. Put the effect where the spell is handled, guarded by `Talent_Active(...)`. If the talent lets a
   spell target something it normally can't, widen the spell's targets in `talents_catalog.py`
   and stop the cast in `Talents_GuardCast` when the talent is missing.
3. Add a test in `tools/tests/test_talents.py`.

## Priest (job 12)

| Row | Choice | Talent | Effect |
|---|---|---|---|
| 1 | 1 | Deprotect | "Protect can be cast on an enemy." Dummy casts `tDpr` (Deprotect buff `B06J`, 15 s). |
| 1 | 2 | Deshell | "Shell can be cast on an enemy." Dummy casts `tDsh` (Deshell buff `B06K`, 15 s). |
| 1 | 3 | Blinding Light | "Enemies Cure affects are blinded." The enemy Cure is cast on: `tBln` (Blind `B00P`, 15 s); enemies the sphere passes: `tBl5` (5 s). Cast on an enemy it heals no one (`MissileNoDamage`). |
| 2-4 | | not written yet | |

Protect, Shell and Cure list enemies as targets; without the talent, `Talents_GuardCast` stops the
cast before it costs anything. Cure (`A00M`) used to be Holy Light-based, and Warcraft only lets
Holy Light target allies or undead enemies, so `talents_catalog.py` rebases it on Channel with
the same order string (`holybolt`), costs, cooldowns, range and text; its healing was already
scripted (Spell_Cure). Every Channel field is set on all 11 levels (1.29.2 can freeze casters on
Channel levels with missing fields).

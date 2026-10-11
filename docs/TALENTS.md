# Job talents

Module `src/triggers/03 Jobs and progression/Talents.j`; objects added by `tools/talents_catalog.py`.

## How it works

- Every player hero gets a **Talents** button (`tTal`, hotkey T) in command-card slot (0,1).
- Four rows of three choices per job. Row 1 is open from the start, row 2 at mastery (level 50),
  row 3 at ultimate mastery (level 99), row 4 at legendary master (level 100). Rows follow the
  Mastery ability `A02F` (levels 1-4; legendary bonus levels 5-9 count as 4).
- One choice per row. Picks last for the current game (not saved). A talent trainer in town will
  reset them for a cost (not built yet).
- A talent only works while the hero's **current job** is the talent's job **and** the hero has the
  spell it changes: `Talent_Active(hero, job, row, choice, spell)`. A Freelancer or another job
  with the spell swapped in gets nothing; a mastered hero who swapped the spell out gets nothing.
- Reforged shows a panel (point at a talent to read it; Esc or Close closes it). The 1.29.2
  conversion (`tools/bazaar_legacy.py convert_talents`) removes the `TalentFrame_` functions and
  uses a dialog: one row at a time, three choice buttons, Next row, Close.

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
| 1 | 1 | Deprotect | Protect (`A00G`) can target an enemy: dummy casts `tDpr` (Deprotect buff `B06J`, 15 s). |
| 1 | 2 | Deshell | Shell (`A0TZ`) can target an enemy: dummy casts `tDsh` (Deshell buff `B06K`, 15 s). |
| 1 | 3 | Blinding Light | Cure (`A00M`) sphere blinds each enemy it passes (`tBln`, Blind buff `B00P`, 15 s). Cast on an enemy, it heals no one (`MissileNoDamage`). |
| 2-4 | | not written yet | |

Protect and Shell now list enemies as targets; without the talent, `Talents_GuardCast` stops the
cast before it costs anything. Cure could already target enemies (as Holy Light: likely undead
only); Blinding Light does not change that.

# Job talents

Module `src/triggers/03 Jobs and progression/Talents.j`; objects added by `tools/talents_catalog.py`.

## How it works

- Every player hero gets a **Talents** button (`tTal`, hotkey T) in command-card slot (0,1).
- Four rows of three choices per job. Row 1 is open from the start, row 2 at mastery (level 50),
  row 3 at ultimate mastery (level 99), row 4 at legendary master (level 100). Rows follow the
  Mastery ability `A02F` (levels 1-4; legendary bonus levels 5-9 count as 4).
- One choice per row. Picks last for the current game (not saved). The Shrine of Individuality
  (`n04U`) sells **Reset Talents** (`nTRt`, 1000 gold for testing, bottom-left slot): it clears the
  current job's picks only and refunds the gold if there was nothing to reset. The Legendary Bonus
  Menu retains its bottom-right slot.
- A talent only works while the hero's **current job** is the talent's job **and** the hero has the
  spell it changes: `Talent_Active(hero, job, row, choice, spell)`. A Freelancer or another job
  with the spell swapped in gets nothing; a mastered hero who swapped the spell out gets nothing.
- The dialog (used by the 1.29.2 build) shows one row at a time: names and descriptions wrapped to
  30 characters (dialogs do not wrap text), "Learn <name>" buttons, Next row, Close. Forsaken/Reforged uses its native
  panel, with hover descriptions for implemented Priest choices.

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
| 2 | 1 | Acid Rain | Tranquility also deals magical damage to enemies in its healing radius, equal to 50% of the current rank's native healing value. |
| 2 | 2 | Refresh | Esuna fully resets food/stat buffs; special hero effects gain 3 seconds of remaining duration. Base Esuna cooldown becomes 20 seconds, with normal cooldown modifiers. |
| 2 | 3 | Swiftmend | Regen heals at twice the rate for half its rank-specific duration: master 30 seconds instead of 60. Same total healing with unchanged stats. |
| 3-4 | | not written yet | |

Protect, Shell and Cure list enemies as targets; without the talent, `Talents_GuardCast` stops the
cast before it costs anything. Cure (`A00M`) used to be Holy Light-based, and Warcraft only lets
Holy Light target allies or undead enemies, so `talents_catalog.py` rebases it on Channel with
the same order string (`holybolt`), costs, cooldowns, range and text; its healing was already
scripted (Spell_Cure). Every Channel field is set on all 11 levels (1.29.2 can freeze casters on
Channel levels with missing fields).

## Blinding Light aimed at an enemy

Aimed straight at an enemy the Cure sphere is set to heal no one, and the missile only runs
its impact hooks when it carries a non-zero amount, so the blind never landed on the unit it
was aimed at. The blind is applied at the cast instead. Enemies the sphere merely passes are
still blinded on contact, for the shorter time. This was never a 1.29.2 difference: the
functions involved are byte-identical in both builds.

Enemies the sphere passed were still not blinded, and `-blindcheck` reported the hook as
registered but never run. It had been added as a second condition on `udg_MissileDamageTrig`,
the trigger the missile system evaluates for every unit a missile touches - and a second
condition there is never reached, because that condition list belongs to the map's own damage
handler. The missile system now offers a hook of its own, `MissileHitHook`, which it evaluates
after the damage handler, and the talent registers there. `-blindcheck` also reports how many
times a missile has touched a unit at all, so a hook that still sees nothing can be told apart
from a missile that touches nothing.

With the hook running, the count read sixteen touches, sixteen of them a blinding sphere, and
nobody blinded. The sphere's own area is 128 and belongs to its healing splash, which is a
fraction of what a player watches it fly past, and most of those touches are the caster
standing where the sphere was launched. Blinding Light no longer waits to be told what the
sphere touched: a sweep follows each blinding sphere twenty times a second and blinds the
enemies within 250 of it. `-blindcheck` reports how many units the sweep looked at and which
test turned each one down - not an enemy, already blinded, or dead - so a sphere that blinds
nobody says why.

## Forsaken Priest (DZ)

The Forsaken tree's Priest choices use the same Deprotect, Deshell and Blinding
Light picks and spell effects as the normal talent module, including the Cure
missile blind hook. The Beginner and Master Priest rows are selectable; later Priest
rows remain unavailable. Earned points follow levels 1, 50, 99 and legendary 100;
the panel shows unspent and total points. Shrine Reset Talents clears only the
current job's picks, preserving the hero and gear. Reset sits bottom-left, with
Legendary Bonus restored to bottom-right.
Picks remain per game. Other jobs retain their existing preview behavior.


## PAIR024 shared Master implementation

The maintained transform is tools/priest_master.py; the shared runtime fragment is
experiments/Forsaken/PriestMaster.j. The pair builder reads rank data and base spell
text from the saved editor master and adds generated buff-proxy objects to both main
and skin ability tables. Spell runtime lives in TRegen, above the inventory/proficiency dependencies; TTalents
keeps choice data and UI only. TCooldown reads a cast-time base-cooldown override,
avoiding a legacy inventory/talent dependency cycle.
The authoring master is never overwritten. No save identity
or talent-persistence format is changed.

Acid Rain derives Etq1 (per-pulse healing), Etq2 (pulse period), area and duration
from A0OM. Current native healing is 500 HP/sec at rank1 and 4000 at rank6, so base
rain damage is 250 and 2000 HP/sec respectively, before target damage modifiers.
The rain runs only while its caster is alive, channeling Tranquility and still has
the active Priest choice. It ends on finish, interruption, death or loss of the
choice; its timer pauses when no rain remains. Allies and magic-immune/dead targets
are excluded. It does not replace or reduce Tranquility's healing.

Refresh follows the user's revised rules. Haste, Protect, Shell, Bravery, Faith,
Regen, Growth, Sharp Eye, Mirage, Praise, Blessing of Might, Surge, Rage and timed
food/stat effects reset to their original current-rank duration. Special effect IDs
B06L/B082/B052/B06N/B076/B051/B07R/B07S/B018/B04B (Trance, Dark Power, Infinity,
Mind Charge, Inner Fire, Divine Shield, Runic effects, Holy Power and Drain Attack)
gain exactly 3 seconds of remaining duration. It does not revive expired buffs.
Original spell/rank metadata is captured in synchronized spell events; Protect,
Shell and Haste player wrappers are excluded so their actual proxy casts supply
the correct rank/duration. Replays use separate free copies and preserve the
existing buff rank. These copies do not invoke the original gameplay action.
Combined source spells use separate per-buff proxies, so an expired companion buff
is not recreated. Special native buff durations are governed by tracked deadlines;
repeated Refresh extends those deadlines by 3 seconds, not the full duration.
A new original cast cancels the old special expiry timer. Script Divine/Runic timers
also gain 3 seconds without changing links, efficiency or accumulated power.
Hero Drink's existing stacks wait until 60 seconds after the latest Refresh without
adding another stack. Permanent/aura effects are not converted into timed buffs.
The engine-free tests are separate from actual Warcraft acceptance of proxy orders,
combined buffs, native duration replacement and checkpoint serialization.

Swiftmend copies A00L with half duration at every rank and retains native heal data.
The existing scripted Regen amount (including target Strength) doubles before other
healing channels are added. Cast generations prevent a deferred short-duration
application from replacing a newer Regen cast. A normal cast clears Swiftmend.
Regen's unchanged formula is (25 + floor(caster INT/3)) * Staff power + target STR/4,
with the existing 93.75%-100% tick roll and normal healing modifiers. Rank previously
changed duration, not that per-second formula; the new tooltip states this and shows
the current numeric caster contribution and current rank's duration. Swiftmend
shows doubled contribution/Strength rate and halved duration.

Forsaken talent buttons now have hover descriptions, and the selected talent is
appended to the affected ability tooltip in both profiles. This includes Beginner
Priest choices as well as the new Master row. Classic retains its text dialog.
Tooltip writes are local presentation only; spell casts, buff records, damage and
expiry timers are synchronized. Base tooltips are retained so a reset removes the
appended talent text. Ability text uses the appropriate setter level offset for
each client. Initialization tables are split into bounded ExecuteFunc batches.

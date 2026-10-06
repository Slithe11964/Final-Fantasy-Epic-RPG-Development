# Adding content to FF Epic RPG

Start from the paired r16 Reforged master: `baseline/Reforged/FFERPG_0.9.7.3-r16.w3x`. Keep a working copy and
give every release build a fresh stage letter. These examples describe a **future**
"Grove Trial" quest, its Sentinel boss and a Sentinel Charm. They add no actual
content to the current map. Names, balance and unused IDs must be chosen when implementing it.

## 1. A new quest: talk, kill, return

Use `src/triggers/06 Quests and story/Quest_KillElmdor.j` as the worked reference.
Create `Quest_GroveTrial.j` in that folder, with `library TQuestGroveTrial requires
TQuestEngine` (plus the boss library if its functions are called). Keep CRLF line endings.
Rename every quest-owned global, function, trigger and library when copying a module.
Keep functions called through hook strings public and give them unique names.

Choose an unused side-log index after searching **all** source for direct assignments,
Quest_Define calls and aliases. An engine number is not a log index. Do not copy Elmdor's
slot 6, global quest flags, news text or Brothers prerequisite into the new quest.
The following definition body assumes `GROVE_LOG_INDEX` has been allocated, `GroveBoss`
is an existing living unit, and `GROVE_QUEST` is a module-owned integer initialized to 0:

```jass
local integer q=Quest_Define("Grove Trial",QUEST_SIDE,GROVE_LOG_INDEX,"ReplaceableTextures\\CommandButtons\\BTNChaosBlademaster.blp")
set GROVE_QUEST=q
call Quest_Talk(q,gg_unit_h007_0089,"Defeat the Sentinel and return to Biggs.")
call Quest_Say(q,gg_unit_h007_0089,"The Sentinel is waiting in the grove.")
call Quest_OnDone(q,"GroveTrial_ReleaseBoss")
call Quest_Kill(q,GroveBoss,"Return to Biggs for your reward.")
call Quest_OnDone(q,"GroveTrial_SentinelSlain")
call Quest_Return(q,gg_unit_h007_0089,"")
call Quest_Say(q,gg_unit_h007_0089,"You have passed the trial. Here is your reward.")
call Quest_Reward(q,1500,1500)
```

Biggs is a real existing NPC used here as an example; select a suitable quest giver for
actual content. Put the boss creation before the definition, since Quest_Kill needs a
real unit handle. `GroveTrial_ReleaseBoss` reveals/unpauses/removes invulnerability;
`GroveTrial_SentinelSlain` removes its ping/combat-group membership and drops the charm.
These hooks take nothing and return nothing. Copy useful actions, not Elmdor's unrelated
story effects. The engine handles discovery, progression, completion and quest counting.

Availability is a separate function: define once (`GROVE_QUEST==0`), then call
`Quest_MakeAvailable(GROVE_QUEST)`. Pick one real prerequisite, for example the final
hook of the intended preceding quest, and call availability there exactly once. Do not
make the parent Quest library a dependency of the child if the parent requires that child.

Register the new module's triggers through the existing Quest registration structure:
add `optional TQuestGroveTrial` to Quest.j's requires and guarded registration calls to an
appropriate `RegisterTriggers_Quest_Part*`. If an initialization action is needed, wire
its execution in the existing startup sequence as well; creating a trigger does not run
it. Kill Elmdor's two registration helpers are called in Part9. Preserve the existing
calls and their order. A pure callable definition/availability module may need no new
triggers, but it still needs to be embedded in the map.

Use Talk/Kill/Return/Deliver/Hunt/Reach for ordinary events. Use Custom for a siege result,
branching cinematic, repeated report or another module-owned event, then finish it with
`Quest_StepDone(q,player,unit)`. Keep the completing player/unit local to that event.
Custom steps do not implement their own event detection. Guard against duplicate callbacks.
For examples, read Quest_EyeOfJenova, Quest_DarkKnight, Cartographer and TrueIceAge.

Hooks must not wait or call transmitting text helpers. Ordinary dialogue belongs in
Quest_Say rows. Delayed work uses a timer and owned context; capture QuestDonePlayer and
QuestDoneUnit immediately if needed later. Long existing custom cinematics remain in
their own event actions, rather than synchronous Quest_OnDone hooks.

## 2. A new boss: the Sentinel

For this small, once-only quest encounter, the quest module can own the boss handle and
the two hooks above. In World Editor, clone an appropriate **unit** into an unused rawcode,
set its stats, abilities and model, and place it or create it during the quest's setup.
Keep it hidden, paused and invulnerable before acceptance, like Elmdor. A dynamically
created unit should be assigned directly from CreateUnit to GroveBoss; do not recover it
later through shared temporary variables or bj_lastCreatedUnit after nested calls.

On acceptance, reveal it and add it to `udg_BossUnits` if it should be pinged. Decide
explicitly whether it needs `udg_BossGroup`: that group changes stun/daze behavior and is
different from the ping group. On death, remove only the memberships you added and create
the charm at GetUnitX/GetUnitY of GroveBoss. Use a verified item rawcode for CreateItem.
Let the engine's kill step call the drop hook once; do not also pay/drop from a second
death trigger. Keep unrelated world-liberation counters, titles and old boss flags out.

For an encounter with independent death/intro mechanics, create `Boss_GroveSentinel.j`
under `04 Combat and abilities`. Follow Boss_Ultima/Boss_Agrias registration in Boss.j:
optional library requirement and guarded Register_* calls. Give the quest a dependency
on the boss library when calling it; use a designed callback boundary to avoid cycles.
Boss_Ultima's existing narrative and reward amounts are not a template for new balance.

An arena summon requires the separate summon-item, cleanup, gate and arena-state work
in BOSSES.md and ARENA.md. This grove example is a field encounter; do not graft the
arena globals into it. Test a second death/cleanup callback deliberately if repeatable.

## 3. A new item: Sentinel Charm

Create the item in World Editor with an unused rawcode. Choose its base item/class,
tooltip, icon, abilities and charges intentionally. Inspect existing equipment behavior
in source and item entries in docs/objects/ITEMS.md; creating an item object alone does not
implement every stat, equipment restriction, recipe, shop entry or drop source.

For a charm that players can save, append its rawcode to the actual initialization of
`udg_ItemIdTable`: the current final index is **351**, so the next is **352**. Search the
source for that assignment to find its owner. Set `udg_SaveFlagCount` to 352. Keep every
existing index/rawcode and charge classification unchanged; flags 501..540 are reserved,
so item-table indexes cannot exceed 500. Do not insert the charm into the middle.

After the object/table change, use a separately enabled DevCommands copy to run
`-dumpitems`, and replace `src/itemtable.txt` with the real output. Confirm the new entry
has the intended charged/noncharged classification. The release keeps DevCommands disabled.
If the item belongs in the armory, implement a new mapping deliberately without changing
existing mappings. See SAVE_CODES.md; do not alter serializer contracts to silence failures.

Test picking up/equipping/dropping the charm, inventory limits and its actual effects.
Save/load both an old character code and a character with the new item; compare old
inventories, charge counts and armory contents. Keep real before/after codes for review.

## 4. A reward: 1500 gold and 1500 XP on return

The definition above puts Quest_Reward immediately after Biggs's return line. Its position
sets reward timing within the dialogue. The engine still pays with cinematics disabled.
Do not also call Reward_Give in the final hook. Quest rewards use the existing TReward
policy; they are party rewards, rather than a direct payment only to QuestDonePlayer.

Reward_Give applies Eternity's positive gold/XP adjustment (for each amount <=6000, round up to a
multiple of 500 when needed, then add 2000). Reward_GiveAll applies each active player's
existing title multiplier, gold accounting, main/Gaya XP rules and Pointless XP banking.
Thus 1500 is the declared base XP, not necessarily every player's final gain. Preserve
those helpers instead of replacing them with direct gold/XP natives.

For a non-quest event use `Reward_Give(gold,xp,speaker)` or deliberately choose
`Reward_GiveAll` if Eternity adjustment should be bypassed. A non-null speaker can transmit
dialogue and wait. In a non-waiting hook, null suppresses reward text; udg_NarratorUnit
uses ordinary non-waiting text. Alternatively keep payment in Quest_Reward; review the
exact helper branch. Existing Cartographer intentionally uses
different helpers for initial and repeat reports.

Test payment once, cinematics on/off, party members with different titles, and the relevant
Eternity/Pointless/Gaya paths when changing reward rules. A second NPC approach must not pay again.

## Integrate, build, test

For edits to existing modules the normal command is:

```powershell
.\build.ps1 -Stage AB
```

AB is an example next stage; check STAGES.md and release/ before using it. The wrapper
syncs changes, orders libraries, runs all gates and adds the outer map header. It refuses
an existing release name. See BUILDS.md for dependencies and complete limits.

**New modules and object data need preparation first.** The wrapper does not create either.
Use World Editor on a copy, or `tools/add_module.py BASE OUT "06 Quests and story"
Quest_GroveTrial` after creating its source. add_module embeds source and its startup
InitTrig call; it does not add the parent registration/availability calls above. For new
objects, the base must already contain the new object data. Retain and compare against the
original release; using a prepared base does not itself audit how that base was made.

After an editor save, export sources using tools/export_sources.py and review the diff.
After archive-editing tools, restore the HM3W header with the sibling
`tools/add_header.py` before using the prepared map as a build.ps1 base
if that header is absent. Use check_map against the original release too, with narrowly
named --allow-new triggers where appropriate. Review any new source/runtime optimizations;
never reset a compatibility contract simply to make the check green.

Refresh references with `python tools/gen_docs.py` and `python tools/gen_dependencies.py`.
The dependency index lists declared requires, including disabled editor modules; dynamic
ExecuteFunc calls and startup event wiring still need review. Update OBJECTS/quest reference
outputs if their data changed. Record the stage, map, checks and focused test checklist in
STAGES.md/HANDOFF.md and update ../RESUME_PROMPT.txt, then commit the owned changes.

Play the whole new quest in Reforged with cinematics on and off and in a two-player game:
availability only after its prerequisite; correct markers/log; boss hidden before acceptance;
one spawn, one drop and one payment; correct return NPC; save/load unchanged old content.
Automated compilation and mocked tests supplement that play test.

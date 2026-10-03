# Quest engine: writing quests as data

Module: `06 Quests and story/QuestEngine` (library `TQuestEngine`).

A quest is a list of steps. The quest's own module describes it once, as data. The engine then runs it:

- it shows the "!" over the quest giver, and the "?" while the quest is active;
- it creates and updates the quest-log entry, and announces new, updated and completed quests;
- it waits for each step, plays its dialogue (skipped when cinematics are off), and gives the rewards;
- it counts the quest (`udg_QuestsCompleted`, `udg_StoryProgress`, quest-count milestones).

The quest-log entry is still `udg_SideQuest[n]` / `udg_MainQuest[n]`, so the about 100 places that check
`IsQuestCompleted(...)` keep working.

**Converted so far:** Kill Elmdor (`Quest_KillElmdor`) and Wolf Fangs (`Quest_WolfFangs`), stage M.
`docs/QUEST_SURVEY.md` lists all quests and how each would convert.

## A quest, step by step

```
function QuestKillElmdor_Define takes nothing returns nothing
    local integer q=Quest_Define("Kill Elmdor",QUEST_SIDE,6,"ReplaceableTextures\\CommandButtons\\BTNChaosBlademaster.blp")
    set QUEST_KILL_ELMDOR=q
    // 1. Talk to Biggs
    call Quest_Talk(q,gg_unit_h007_0089,"Biggs, captain in Kalm, promised reward for killing Elmdor the Corrupted Samurai.")
    call Quest_Say(q,gg_unit_h007_0089,"Greetings. My name is Biggs and I am the captain here.")
    call Quest_Say(q,null,"His life is forfeit.")
    call Quest_OnDone(q,"QuestKillElmdor_ElmdorAppears")
    // 2. Kill Elmdor
    call Quest_Kill(q,gg_unit_Nbbc_0006,"Come back to Biggs for reward.")
    call Quest_OnDone(q,"QuestKillElmdor_ElmdorSlain")
    // 3. Report back to Biggs
    call Quest_Return(q,gg_unit_h007_0089,"")
    call Quest_Say(q,null,"Elmdor is dead.")
    call Quest_Say(q,gg_unit_h007_0089,"So you killed him? That is great to hear. Here's your reward.")
    call Quest_Reward(q,1500,1500)
    call Quest_OnDone(q,"QuestKillElmdor_Done")
endfunction
```

Then, when the quest becomes available (another module's story step), call `Quest_MakeAvailable(q)`.

| Call | What it does |
|---|---|
| `Quest_Define(name, QUEST_SIDE or QUEST_MAIN, n, icon)` | A new quest. Its log entry will be `udg_SideQuest[n]` or `udg_MainQuest[n]`; side quests are cyan, main quests gold. Returns the quest number. |
| `Quest_Talk(q, npc, text)` | Step: select the NPC while a hero is near it (`udg_TalkRange`). |
| `Quest_Return(q, npc, text)` | Step: a hero walks up to the NPC (within 450). |
| `Quest_Kill(q, unit, text)` | Step: the unit dies. |
| `Quest_Deliver(q, npc, itemType, n, label, text)` | Step: a hero walks up to the NPC carrying the item; its charges are handed over until n are delivered. The quest log shows "label: x/n". |
| `Quest_Custom(q, text)` | Step: the quest's own code calls `Quest_StepDone(q, player, unit)` when it is done (a siege won, a timer ran out ...). |
| `Quest_Say(q, speaker, line)` | A dialogue line for the step just added, said when the step is done. `null` speaker = the hero of the player who did the step. |
| `Quest_Reward(q, gold, xp)` | Reward for the step just added, given at this point of its dialogue (`Reward_Give`, so Eternity mode rules apply). |
| `Quest_OnDone(q, "FunctionName")` | Custom code for the step just added, run when the step is done (spawn a boss, open a gate, update the news). It can read `QuestDonePlayer` / `QuestDoneUnit`. |
| `Quest_NotStory(q)` | Completing it does not count toward `udg_StoryProgress` and the quest-count milestones. |
| `Quest_MakeAvailable(q)` | Show the "!" and start waiting for the first step. Ignored if the quest already started. |
| `Quest_IsActive(q)`, `Quest_IsDone(q)` | The quest's state. |

**Step text** is the quest-log description after that step. The first step's text is the description the
quest starts with. An empty text keeps the description, which is usual for the last step.

## Converting an old quest

1. **Read it.** List its triggers and what each waits for. `docs/QUEST_SURVEY.md` and `docs/quest-survey.csv`
   give the steps and modules.
2. **Write the definition** in the quest's module, keeping all dialogue lines word for word. Put anything
   special in small `Quest_OnDone` functions in the same module: units appearing, items dropped, news text,
   other quests becoming available.
3. **Keep the entry points** other modules use. A trigger they run, such as `gg_trg_Quest_KillElmdor_Available`,
   now calls `Quest_MakeAvailable`. A trigger they enable directly has to become a function call; for Wolf
   Fangs, `Valera` now calls `QuestWolfFangs_Available` through `ExecuteFunc`.
4. **Remove the old step triggers** from the parent registration list (`Quest` module).
5. **Build and check:** `tools/sync_module.py`, then `tools/check_map.py` with
   `--allow-removed 'gg_trg_Quest_X_(Start|...)'` for the removed triggers.
6. **Play-test** the quest from start to finish, with cinematics on and off.

## Limits and next step types

- `Quest_StepDone` and `Quest_OnDone` functions must not wait (`TriggerSleepAction`): the engine runs them in
  the middle of its own work. Dialogue waits are fine; they belong in `Quest_Say`.
- Quests are shared by the party, as before: one log entry, every player sees it.
- Step types still to add for the next batch: kill N units of some types (hunt quests with the leaderboard),
  pick up an item, reach a place. `docs/QUEST_SURVEY.md` shows which quests need them.

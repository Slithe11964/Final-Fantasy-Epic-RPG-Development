# Quest engine: writing quests as data

Module: `06 Quests and story/QuestEngine` (library `TQuestEngine`).

A quest is a list of steps. The quest's own module describes it once, as data. The engine then runs it:

- it shows the "!" over the quest giver, and the "?" while the quest is active;
- it creates and updates the quest-log entry, and announces new, updated and completed quests;
- it waits for each step, plays its dialogue (skipped when cinematics are off), and gives the rewards;
- it counts the quest (`udg_QuestsCompleted`, `udg_StoryProgress`, quest-count milestones).

The quest-log entry is still `udg_SideQuest[n]` / `udg_MainQuest[n]`, so the about 100 places that check
`IsQuestCompleted(...)` keep working.

**Converted:** 90 of the map's quests (stages M, N, O, P). Not converted: Cartographer, True Ice Age and Ao Madoushi. The play-test list is `docs/QUEST_TESTS.md`.

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
| `Quest_Hunt(q, row, n, label, text)` | Step: the party kills n units of the types added with `Quest_HuntTarget(q, 'type')` (the killer's owner must be in `udg_ActivePlayers`). The count shows on the hunt leaderboard in row `row` (`udg_HuntCounter[row]`, `udg_HuntBoardLabel[row]`, the row of `Player(row-1)`), which the hunt festival also restores. |
| `Quest_Deliver(q, npc, itemType, n, label, text)` | Step: a hero (the Spirit of Gaya too) walks up to the NPC carrying the item; its charges are handed over until n are delivered. The quest log shows "label: x/n"; label `""` = a single hand-in with no counter. |
| `Quest_Reach(q, gg_rct_x, text)` | Step: a hero (not the Spirit of Gaya) walks into the region. |
| `Quest_Custom(q, text)` | Step: the quest's own code calls `Quest_StepDone(q, player, unit)` when it is done (a siege won, a timer ran out ...). |
| `Quest_Say(q, speaker, line)` | A dialogue line for the step just added, said when the step is done. `null` speaker = the hero of the player who did the step. |
| `Quest_SayAs(q, speaker, name, sound, line)` | A line shown under another name (e.g. "Fire" instead of the unit's name), with a sound or `null`. |
| `Quest_SayIfSideQuestDone(q, n, speaker, line)` | A line said only if `udg_SideQuest[n]` is completed. |
| `Quest_Camera(q, gg_cam_x)` | The step's dialogue uses this camera for all players instead of panning to the NPC. |
| `Quest_Message(q, text)` | The announcement when the step is done, when it should differ from the step's log text. |
| `Quest_PingUnit(q)` | While the step waits, its unit is pinged on the minimap with the bosses (`udg_BossUnits`). For return steps after a hunt, and kill steps. |
| `Quest_PingItem(q)` | Deliver step: every 15 s, ping the item while it lies on the ground, else the NPC. |
| `Quest_OnPickup(q, note, "Function")` | Deliver step: the first time any unit picks up the item, its player sees `note`, the log text becomes `note`, and the function (or `""`) runs. |
| `Quest_Reward(q, gold, xp)` | Reward for the step just added, given at this point of its dialogue (`Reward_Give`, so Eternity mode rules apply). |
| `Quest_OnDone(q, "FunctionName")` | Custom code for the step just added, run when the step is done (spawn a boss, open a gate, update the news). It can read `QuestDonePlayer` / `QuestDoneUnit`. |
| `Quest_Color(q, udg_QuestTitleColor)` | The colour code before the name in the quest log (default cyan for side quests, `udg_ColorGold` for main quests). |
| `Quest_NoMarker(q)` | No "!" / "?" markers (the module shows its own, or none). |
| `Quest_NotStory(q)` | Completing it does not count toward `udg_StoryProgress` and the quest-count milestones. |
| `Quest_MakeAvailable(q)` | Show the "!" and start waiting for the first step. Ignored if the quest already started. |
| `Quest_IsActive(q)`, `Quest_IsDone(q)`, `Quest_IsFailed(q)`, `Quest_CurrentStep(q)` | The quest's state; the step it waits for. |
| `Quest_Start(q, player, unit)` | Start now, with no "!": for quests begun by an event. If step 1 is a custom step it is done at once (log entry created, hook run). |
| `Quest_StepDone(q, player, unit)` | Finish the current custom step. |
| `Quest_SetLog(q, text, announce)` | Change the quest-log text at any time; `announce` also shows it as a quest update. |
| `Quest_Fail(q)` | Fail the quest: it stops waiting, markers go, "Quest Failed" and the log shows it failed. |

**Step text** is the quest-log description after that step. The first step's text is the description the
quest starts with. An empty text keeps the description (and announces nothing), which is usual for the last step.

**Markers:** the "!" is over the first NPC while the quest is available. Once it is accepted, the "?" is over
the NPC of the next talk / return / deliver step (it moves from Wedge to Zack and back in Deliver Letter), and
stays where it is during kill and hunt steps.

## Converting an old quest

1. **Read it.** List its triggers and what each waits for. `docs/QUEST_SURVEY.md` and `docs/quest-survey.csv`
   give the steps and modules.
2. **Write the definition** in the quest's module, keeping all dialogue lines word for word. Put anything
   special in small `Quest_OnDone` functions in the same module: units appearing, items dropped, news text,
   other quests becoming available.
3. **Keep the entry points** other modules use. A trigger they run, such as `gg_trg_Quest_KillElmdor_Available`,
   now calls `Quest_MakeAvailable`. A trigger they enable directly has to become a function call; for Wolf
   Fangs, `Valera` now calls `QuestWolfFangs_Available` through `ExecuteFunc`.
4. **Remove the old step triggers** from the parent registration list (`Quest` module) or the module's own
   `RegisterTriggers_X` (and its MapBootstrap call if the module has no triggers left). A module that is left
   with nothing (Greed is Good's `GreedIsGood` and `PortalStone`) is taken out with `tools/remove_module.py`.
5. **Build and check:** `tools/sync_module.py` for the changed modules, `tools/remove_module.py` for emptied
   ones, then `tools/check_map.py --baseline <previous stage>` with `--allow-removed 'gg_trg_(Quest_X_Start|...)'`
   for the removed triggers. The engine must come before every quest module in the playable script:
   `tools/add_module.py ... QuestEngine --before TElixir,TGnollHunt,...` (see docs/STAGES.md, stage N).
6. **Play-test** the quest from start to finish, with cinematics on and off.

## Limits and next step types

- `Quest_StepDone` and `Quest_OnDone` / `Quest_OnPickup` functions must not wait (`TriggerSleepAction`,
  `Wait_Polled`): the engine runs them in the middle of its own work. Dialogue waits are fine; they belong in
  `Quest_Say`. For something later, start a timer: `call TimerStart(CreateTimer(),2.,false,function X)` and
  `call DestroyTimer(GetExpiredTimer())` in X (Arachnophobia offering Harpy Hunt, Melaniya teleporting away,
  Fire selling Elixirs after 3 minutes).
- Quests are shared by the party, as before: one log entry, every player sees it.
- Step types still to add when a quest needs them: reach a place, attack a unit. `docs/QUEST_SURVEY.md` shows
  which quests need them.
- An entry point another module enables directly becomes a function it calls through `ExecuteFunc`, guarded by
  `static if LIBRARY_T...` (Valera -> Wolf Fangs, Kiros -> Gnoll Hunt, Melaniya -> Greed is Good).

## Play-test list (stage N)

Play each with cinematics on, and at least one with cinematics off (reward still given, no dialogue).

| Quest | How it becomes available | What to check |
|---|---|---|
| Find Shimmerweed | Cid gives "Find Mid" (Elena gets the "!") | Picking up a Shimmerweed in the forest shows "Bring the Shimmerweed to Elena." to that player; minimap ping every 15 s (the weed, then Elena); one charge handed in; 400 gold / 300 XP |
| Arachnophobia | same time (Kollin) | "Spiders to kill: 15" on the hunt board, counts down; at 0 the board row goes, Kollin is pinged; 600 / 400; Thextera hunt in Kollin's shop; 2 s later the "!" over Caroline |
| Harpy Hunt | after Arachnophobia | "Harpys to kill: 20"; return to Caroline; 1500 / 1500; Cactuar hunt |
| Gnoll Hunt | after Save Timmy (Kiros) | "Gnolls to kill: 40"; Priest X can appear; 3500 / 2500; Cu Chulainn hunt; does not raise the story count |
| Phoenix | 6 story quests done (Alma) | Dialogue uses the Alma camera; the egg lies on the western islands and is pinged; picking it up removes "Information: Phoenix" from the shop; 2000 / 2000; Fire Golem alert a minute later |
| Deliver Letter | Cid gives "Ao Madoushi" (Wedge) | Wedge's first line plays his sound; the talker gets the letter; "?" moves to Zack; Zack's extra line only if Save Timmy is done; his letter and 150 gold coins go to the hero who delivered; "?" back on Wedge; 500 / 500; Kiros appears, the five farmers get names, news "A Tribute to our Farmers" |
| Greed is Good | from the start (Melaniya) | Guards appear after the talk; the hideout boss is pinged; it drops the Portal Stone; pickup note; 2500 / 2500; Melaniya teleports away 3 s after the dialogue; Phantom Dancer hunt at Kiros |
| Elixir | 4 story quests done (Fire) | Lines show "Fire" as the speaker; one Elixir charge taken; 4000 / 500; Fire buys rare potions; 3 minutes later "Fire's stock contains a new item for sale" and the news |
| Kill Elmdor, Wolf Fangs | as in stage M | Still work; the Spirit of Gaya can now hand in fangs too |

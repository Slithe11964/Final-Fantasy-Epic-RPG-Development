library TGoblinChief
function Trig_GoblinChief_Death_ShouldDropArtifact takes nothing returns boolean
    return(udg_HashmalumStage<=0)and(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_GoblinChief_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_CidQuestStage=4
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_QuestUnits)
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    call SaveIntegerBJ(1,2,97,udg_GameStateHash)
    call EnableTrigger(gg_trg_Artifact_Ping)
    if(Trig_GoblinChief_Death_ShouldDropArtifact())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('sehr',udg_TempPoint) // 'sehr': item "Mysterious Artifact"
        call RemoveLocation(udg_TempPoint)
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        set udg_QuestItem[$B]=GetLastCreatedItem() // $B = 11
        call EnableTrigger(gg_trg_Artifact_PickedUp)
        call EnableTrigger(gg_trg_Artifact_Carrier)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_GoblinChief automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GoblinChief (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GoblinChief takes nothing returns nothing
endfunction

function Register_GoblinChief_Death takes nothing returns nothing
    set gg_trg_GoblinChief_Death=CreateTrigger()
    call DisableTrigger(gg_trg_GoblinChief_Death)
    call TriggerAddAction(gg_trg_GoblinChief_Death,function Trig_GoblinChief_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GoblinChief takes nothing returns nothing
    call Register_GoblinChief_Death()
endfunction

endlibrary

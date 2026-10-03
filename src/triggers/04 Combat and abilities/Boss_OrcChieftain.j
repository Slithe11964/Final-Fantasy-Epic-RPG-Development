library TBossOrcChieftain
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_OrcChieftain_Death=null
endglobals

function Trig_Boss_OrcChieftain_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_RecruitedAllies)
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    call SaveIntegerBJ(1,2,'k',udg_GameStateHash)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I00B',l_tempPoint) // 'I00B': item "Touph Ring"
    call RemoveLocation(l_tempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Boss_OrcChieftain takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part3 (module Boss),
// which keeps the original registration order.

function Register_Boss_OrcChieftain_Death takes nothing returns nothing
    set gg_trg_Boss_OrcChieftain_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_OrcChieftain_Death,gg_unit_Opgh_0169,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_OrcChieftain_Death,function Trig_Boss_OrcChieftain_Death_Actions)
endfunction

endlibrary

library TBossOrcChieftain
function Trig_Boss_OrcChieftain_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_RecruitedAllies)
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    call SaveIntegerBJ(1,2,'k',udg_GameStateHash)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I00B',udg_TempPoint) // 'I00B': item "Touph Ring"
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_OrcChieftain takes nothing returns nothing
endfunction

endlibrary

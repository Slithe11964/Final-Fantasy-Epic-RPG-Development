library TDemon
function Trig_Demon_Drop_Magatama_IsEvenKill takes nothing returns boolean
    // The remainder after dividing (udg_DemonKillCount) by (2).
    return(ModuloInteger(udg_DemonKillCount,2)==0)
endfunction

function Trig_Demon_Drop_Magatama_KillsBelowFive takes nothing returns boolean
    return(udg_DemonKillCount<5)
endfunction

function Trig_Demon_Drop_Magatama_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Demon_Drop_Magatama_KillsBelowFive())then
        set udg_DemonKillCount=(udg_DemonKillCount+1)
        if(Trig_Demon_Drop_Magatama_IsEvenKill())then
            call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
        endif
        call RemoveLocation(udg_TempPoint)
    else
        call DisableTrigger(GetTriggeringTrigger())
        call CreateItemLoc('I0F0',udg_TempPoint) // 'I0F0': item "Magatama"
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        call RemoveLocation(udg_TempPoint)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Demon takes nothing returns nothing
endfunction

function RegisterR11_Demon_Drop_Magatama takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Demon_Drop_Magatama=CreateTrigger()

call TriggerAddAction(gg_trg_Demon_Drop_Magatama,function Trig_Demon_Drop_Magatama_Actions)

endfunction




endlibrary

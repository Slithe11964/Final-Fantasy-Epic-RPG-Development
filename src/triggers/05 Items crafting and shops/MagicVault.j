library TMagicVault
function Trig_MagicVault_Dim_Actions takes nothing returns nothing
    call SetUnitVertexColorBJ(gg_unit_n03M_0166,'d','d','d',100.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MagicVault_Death_Cond_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_MagicVault_Death_Cond_SeitengratAvailable takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_MagicVault_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ReplaceUnitBJ(GetTriggerUnit(),'nmgv',bj_UNIT_STATE_METHOD_RELATIVE) // 'nmgv': editor label "Magic Vault"
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_MagicVault_Death_Cond_SeitengratAvailable())then
        call CreateItemLoc('I0IO',udg_TempPoint) // 'I0IO': item "Seitengrat"
    else
        if(Trig_MagicVault_Death_Cond_CoinFlip())then
            call CreateItemLoc('I004',udg_TempPoint) // 'I004': item "100 Gold Coins"
        else
            call CreateItemLoc('phea',udg_TempPoint) // 'phea': item "Potion"
        endif
    endif
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_MagicVault takes nothing returns nothing
endfunction
function RegisterR11_MagicVault_Dim takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_MagicVault_Dim=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_MagicVault_Dim,2.)
    call TriggerAddAction(gg_trg_MagicVault_Dim,function Trig_MagicVault_Dim_Actions)
endfunction
function RegisterR11_MagicVault_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_MagicVault_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MagicVault_Death,gg_unit_n03M_0166,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_MagicVault_Death,function Trig_MagicVault_Death_Actions)
endfunction




endlibrary

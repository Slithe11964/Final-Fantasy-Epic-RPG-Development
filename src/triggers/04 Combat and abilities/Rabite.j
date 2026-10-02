library TRabite requires TGroup
function Trig_Rabite_Area_Init_IsNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Rabite_Area_Init_Actions takes nothing returns nothing
    call DestroyGroup(udg_RabiteAreaUnits)
    call DestroyGroup(udg_NeutralPassiveUnits)
    set udg_RabiteAreaUnits=Group_UnitsInRectOfPlayer(gg_rct_693,Player(PLAYER_NEUTRAL_PASSIVE))
    set udg_NeutralPassiveUnits=Group_UnitsOfPlayer(Player(PLAYER_NEUTRAL_PASSIVE),Condition(function Trig_Rabite_Area_Init_IsNotStructure))
    call EnableTrigger(gg_trg_Rabite_Hunt_Unlock)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Rabite_Hunt_Unlock_RabiteUnlockReady takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_RabiteAreaUnits))and(CountUnitsInGroup(udg_NeutralPassiveUnits)<$A) // $A = 10
endfunction

function Trig_Rabite_Hunt_Unlock_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_RabiteAreaUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_NeutralPassiveUnits)
    if(Trig_Rabite_Hunt_Unlock_RabiteUnlockReady())then
        call DisableTrigger(GetTriggeringTrigger())
        call DestroyGroup(udg_RabiteAreaUnits)
        call DestroyGroup(udg_NeutralPassiveUnits)
        call AddUnitToStockBJ('n0LT',gg_unit_n0BV_0229,1,1) // 'n0LT': unit "Hunt: Black Rabite"
        set udg_HuntStock[5]=(udg_HuntStock[5]+1)
        call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Rabite_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$B6 // $B6 = 182
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Rabite takes nothing returns nothing
endfunction
function RegisterR11_Rabite_Area_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Rabite_Area_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Rabite_Area_Init,20.)
    call TriggerAddAction(gg_trg_Rabite_Area_Init,function Trig_Rabite_Area_Init_Actions)
endfunction
function RegisterR11_Rabite_Hunt_Unlock takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Rabite_Hunt_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Rabite_Hunt_Unlock)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Rabite_Hunt_Unlock,Player(PLAYER_NEUTRAL_PASSIVE),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Rabite_Hunt_Unlock,function Trig_Rabite_Hunt_Unlock_Actions)
endfunction
function RegisterR11_Rabite_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Rabite_Death=CreateTrigger()
    call TriggerAddAction(gg_trg_Rabite_Death,function Trig_Rabite_Death_Actions)
endfunction




endlibrary

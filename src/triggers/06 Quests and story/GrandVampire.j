library TGrandVampire
function Trig_GrandVampire_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Uvng_0076)
    call PauseUnitBJ(true,gg_unit_Uvng_0076)
    set udg_GhoulMasterDisabled=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GrandVampire_Awaken_Cond_InfoAlreadyStocked takes nothing returns boolean
    return(udg_QuestFlag[2])
endfunction

function Trig_GrandVampire_Awaken_Actions takes nothing returns nothing
    call ShowUnitShow(gg_unit_Uvng_0076)
    call PauseUnitBJ(false,gg_unit_Uvng_0076)
    call EnableTrigger(gg_trg_Ghoul_Master_Decay)
    if(Trig_GrandVampire_Awaken_Cond_InfoAlreadyStocked())then
        call RemoveItemFromStockBJ('I05E',gg_unit_n02Y_0052) // 'I05E': item "Information: Grand Vampire"
    else
        set udg_QuestFlag[2]=true
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GrandVampire_Death_Cond_VampireDropRoll takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_GrandVampire_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Ghoul_Master_Decay)
    call DestroyTrigger(gg_trg_Ghoul_Master_Decay)
    set udg_GhoulMasterDisabled=true
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_GrandVampire_Death_Cond_VampireDropRoll())then
        call CreateItemLoc('I02P',udg_TempPoint) // 'I02P': item "Dark Claw"
    else
        call CreateItemLoc('I02Q',udg_TempPoint) // 'I02Q': item "Unholy Claw"
    endif
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint)
    call SaveIntegerBJ(1,2,89,udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_GrandVampire takes nothing returns nothing
endfunction
function RegisterR11_GrandVampire_Hide takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_GrandVampire_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_GrandVampire_Hide,function Trig_GrandVampire_Hide_Actions)
endfunction
function RegisterR11_GrandVampire_Awaken takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_GrandVampire_Awaken=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_GrandVampire_Awaken,gg_unit_nbsm_0080,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_GrandVampire_Awaken,function Trig_GrandVampire_Awaken_Actions)
endfunction
function RegisterR11_GrandVampire_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_GrandVampire_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_GrandVampire_Death,gg_unit_Uvng_0076,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_GrandVampire_Death,function Trig_GrandVampire_Death_Actions)
endfunction




endlibrary

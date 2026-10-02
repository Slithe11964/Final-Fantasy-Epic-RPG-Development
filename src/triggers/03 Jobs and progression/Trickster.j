library TTrickster requires TWait
function Trig_Trickster_Decoy_Spawn_Actions takes nothing returns nothing
    set udg_TricksterReal=GetLastCreatedUnit()
    call GroupRemoveUnitSimple(GetLastCreatedUnit(),udg_HuntMonsters)
    call ShowUnitHide(GetLastCreatedUnit())
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call CreateNUnitsAtLoc(1,'n04I',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n04I': unit "Trickster"; $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_388)
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",udg_TempPoint)
    set udg_TricksterDecoy=GetLastCreatedUnit()
    call SetUnitVertexColorBJ(GetLastCreatedUnit(),'d','d','d',90.)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Trickster_Reveal,90.,GetLastCreatedUnit())
    call EnableTrigger(gg_trg_Trickster_Reveal)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Trickster_Reveal_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Trickster_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call IssueImmediateOrderBJ(udg_TricksterDecoy,"stop")
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(udg_TricksterDecoy)
    call SetUnitPositionLocFacingBJ(udg_TricksterReal,udg_TempPoint,GetUnitFacing(udg_TricksterDecoy))
    call RemoveUnit(udg_TricksterDecoy)
    call ShowUnitShow(udg_TricksterReal)
    call PauseUnitBJ(false,udg_TricksterReal)
    call SetUnitInvulnerable(udg_TricksterReal,false)
    call GroupAddUnitSimple(udg_TricksterReal,udg_HuntMonsters)
    call SetUnitVertexColorBJ(udg_TricksterReal,'d','d','d',75.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Trickster takes nothing returns nothing
endfunction

function RegisterR11_Trickster_Decoy_Spawn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Trickster_Decoy_Spawn=CreateTrigger()

call DisableTrigger(gg_trg_Trickster_Decoy_Spawn)

call TriggerAddAction(gg_trg_Trickster_Decoy_Spawn,function Trig_Trickster_Decoy_Spawn_Actions)

endfunction




function RegisterR11_Trickster_Reveal takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Trickster_Reveal=CreateTrigger()

call DisableTrigger(gg_trg_Trickster_Reveal)

call TriggerAddCondition(gg_trg_Trickster_Reveal,Condition(function Trig_Trickster_Reveal_Conditions))

call TriggerAddAction(gg_trg_Trickster_Reveal,function Trig_Trickster_Reveal_Actions)

endfunction




endlibrary

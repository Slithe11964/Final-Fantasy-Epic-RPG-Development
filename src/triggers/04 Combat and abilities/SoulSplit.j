library TSoulSplit
function Trig_SoulSplit_Clone_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_MirrorCloneGroup))
endfunction

function Trig_SoulSplit_Clone_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_MirrorCloneGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(GetTriggerUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_SoulSplit takes nothing returns nothing
endfunction

function RegisterR11_SoulSplit_Clone_Death takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_SoulSplit_Clone_Death=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_SoulSplit_Clone_Death,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_SoulSplit_Clone_Death,Condition(function Trig_SoulSplit_Clone_Death_Conditions))

call TriggerAddAction(gg_trg_SoulSplit_Clone_Death,function Trig_SoulSplit_Clone_Death_Actions)

endfunction




endlibrary

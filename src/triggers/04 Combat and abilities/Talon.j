library TTalon
function Trig_Talon_Leash_Gate_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_TalonUnit)and(GetOwningPlayer(GetTriggerUnit())==Player($A)) // $A = 10
endfunction

function Trig_Talon_Leash_Gate_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_636)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,.0)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Talon_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_TalonUnit)
endfunction

function Trig_Talon_Death_Cond_TalonInParty takes nothing returns boolean
    return(udg_TalonGone==false)
endfunction

function Trig_Talon_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Talon_Death_Cond_TalonInParty())then
        call DisplayTextToForce(GetPlayersAll(),"Talon is dead.")
        set udg_TalonGone=true
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Talon takes nothing returns nothing
endfunction

function RegisterR11_Talon_Leash_Gate takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Talon_Leash_Gate=CreateTrigger()

call DisableTrigger(gg_trg_Talon_Leash_Gate)

call TriggerRegisterEnterRectSimple(gg_trg_Talon_Leash_Gate,gg_rct_638)

call TriggerRegisterEnterRectSimple(gg_trg_Talon_Leash_Gate,gg_rct_631)

call TriggerAddCondition(gg_trg_Talon_Leash_Gate,Condition(function Trig_Talon_Leash_Gate_Conditions))

call TriggerAddAction(gg_trg_Talon_Leash_Gate,function Trig_Talon_Leash_Gate_Actions)

endfunction




function RegisterR11_Talon_Death takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Talon_Death=CreateTrigger()

call DisableTrigger(gg_trg_Talon_Death)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Talon_Death,Player($A),EVENT_PLAYER_UNIT_DEATH) // $A = 10

call TriggerAddCondition(gg_trg_Talon_Death,Condition(function Trig_Talon_Death_Conditions))

call TriggerAddAction(gg_trg_Talon_Death,function Trig_Talon_Death_Actions)

endfunction




endlibrary

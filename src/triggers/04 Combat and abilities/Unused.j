library TUnused requires THolySwordsman, TMedicine
function Unused_Func001 takes nothing returns nothing
    local timer tm=GetExpiredTimer()
    local integer i=0
    loop
        exitwhen i>=8 or tm==udg_SpellCooldownTimer[i]
        set i=i+1
    endloop
    if i<8 then
        call Medicine_AutoApply(Player(i))
    endif
    set tm=null
endfunction

function Unused_Func002 takes nothing returns nothing
    set gg_trg_HolySwordsman_Finisher=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HolySwordsman_Finisher,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_HolySwordsman_Finisher,Condition(function Trig_HolySwordsman_Finisher_Conditions))
    call TriggerAddAction(gg_trg_HolySwordsman_Finisher,function Trig_HolySwordsman_Finisher_Actions)
endfunction

function InitTrig_Unused takes nothing returns nothing
endfunction

endlibrary

library TPreload
function Trig_Preload_HeroChronicles_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('A0AR',gg_unit_n02Y_0052) // 'A0AR': ability "Hero Chronicles"
    call UnitRemoveAbilityBJ('A0AR',gg_unit_n02Y_0052) // 'A0AR': ability "Hero Chronicles"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Preload_DrinkPowerup_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('A0FM',gg_unit_Hdgo_0097) // 'A0FM': ability "Hero Drink Powerup"
    call UnitRemoveAbilityBJ('A0FM',gg_unit_Hdgo_0097) // 'A0FM': ability "Hero Drink Powerup"
    call UnitAddAbilityBJ('A17Q',gg_unit_Hdgo_0097) // 'A17Q': ability "Hero Drink Powerup"
    call UnitRemoveAbilityBJ('A17Q',gg_unit_Hdgo_0097) // 'A17Q': ability "Hero Drink Powerup"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Preload_AgiAttackSpeed_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('A0KK',gg_unit_n02Y_0052) // 'A0KK': ability "Agility to Attack Speed - 50% Steps"
    call UnitRemoveAbilityBJ('A0KK',gg_unit_n02Y_0052) // 'A0KK': ability "Agility to Attack Speed - 50% Steps"
    call UnitAddAbilityBJ('A0KJ',gg_unit_n02Y_0052) // 'A0KJ': ability "Agility to Attack Speed - 2% Steps"
    call UnitRemoveAbilityBJ('A0KJ',gg_unit_n02Y_0052) // 'A0KJ': ability "Agility to Attack Speed - 2% Steps"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Preload_JobUnits_Actions takes nothing returns nothing
    local integer i=0
    local unit u
    loop
        exitwhen udg_JobUnitType[i]==null
        // (i) minus (((i) divided by (8); drop the remainder) times (8)).
        set u=CreateUnit(Player(i-(i/ 8)*8),udg_JobUnitType[i],GetUnitX(gg_unit_Hpb1_0013),GetUnitY(gg_unit_Hpb1_0013),bj_UNIT_FACING)
        call RemoveUnit(u)
        set i=i+1
    endloop
    call RemoveUnit(CreateUnit(Player(0),'H01D',GetUnitX(gg_unit_Hpb1_0013),GetUnitY(gg_unit_Hpb1_0013),bj_UNIT_FACING)) // 'H01D': unit "Spirit of Gaya"
    set u=CreateUnit(Player(0),'Uear',GetUnitX(gg_unit_Hpb1_0013),GetUnitY(gg_unit_Hpb1_0013),bj_UNIT_FACING) // 'Uear': unit "Dark Knight"
    call UnitAddAbility(u,'A0FM') // 'A0FM': ability "Hero Drink Powerup"
    call RemoveUnit(u)
    call DestroyTrigger(GetTriggeringTrigger())
    set u=null
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Preload takes nothing returns nothing
endfunction

function RegisterR11_Preload_HeroChronicles takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Preload_HeroChronicles=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Preload_HeroChronicles,4.)

call TriggerAddAction(gg_trg_Preload_HeroChronicles,function Trig_Preload_HeroChronicles_Actions)

endfunction




function RegisterR11_Preload_DrinkPowerup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Preload_DrinkPowerup=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Preload_DrinkPowerup,3.)

call TriggerAddAction(gg_trg_Preload_DrinkPowerup,function Trig_Preload_DrinkPowerup_Actions)

endfunction




function RegisterR11_Preload_AgiAttackSpeed takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Preload_AgiAttackSpeed=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Preload_AgiAttackSpeed,2.)

call TriggerAddAction(gg_trg_Preload_AgiAttackSpeed,function Trig_Preload_AgiAttackSpeed_Actions)

endfunction




function RegisterR11_Preload_JobUnits takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Preload_JobUnits=CreateTrigger()

call TriggerAddAction(gg_trg_Preload_JobUnits,function Trig_Preload_JobUnits_Actions)

endfunction




endlibrary

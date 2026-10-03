library TWirts requires TAbil, TForce, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Wirts_Leg_Club=null
endglobals

function Trig_Wirts_Leg_Club_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0UA') // 'A0UA': ability "Club"
endfunction

function Trig_Wirts_Leg_Club_LastCharge takes nothing returns boolean
    return(GetItemCharges(GetSpellTargetItem())<=1)
endfunction

function Trig_Wirts_Leg_Club_IsChargedItem takes nothing returns boolean
    return(GetItemType(GetSpellTargetItem())==ITEM_TYPE_CHARGED)
endfunction

function Trig_Wirts_Leg_Club_OutsideTowns takes nothing returns boolean
    return(RectContainsLoc(gg_rct_373,udg_TempPoint)==false)and(RectContainsLoc(gg_rct_496,udg_TempPoint)==false)
endfunction

function Trig_Wirts_Leg_Club_IsPortalItem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='stwp')or(GetItemTypeId(GetSpellTargetItem())=='I034') // 'stwp': item "Scroll of Portal"; 'I034': item "Portal Stone"
endfunction

function Trig_Wirts_Leg_Club_CanOpenPortal takes nothing returns boolean
    return(GetSpellTargetItem()!=null)and(Trig_Wirts_Leg_Club_IsPortalItem())and(udg_PortalRitualActive==false)
endfunction

function Trig_Wirts_Leg_Club_HasTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()!=null)
endfunction

function Trig_Wirts_Leg_Club_Actions takes nothing returns nothing
    if(Trig_Wirts_Leg_Club_HasTargetUnit())then
        set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*2))
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*2))
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
        set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
        set udg_IsPhysicalAttack=true
        call UnitDamageTarget(GetTriggerUnit(),GetSpellTargetUnit(),I2R(udg_TempInteger),true,false,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_HEAVY_BASH)
    else
        if(Trig_Wirts_Leg_Club_CanOpenPortal())then
            set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
            if(Trig_Wirts_Leg_Club_OutsideTowns())then
                if(Trig_Wirts_Leg_Club_IsChargedItem())then
                    if(Trig_Wirts_Leg_Club_LastCharge())then
                        call RemoveItem(GetSpellTargetItem())
                    else
                        call SetItemCharges(GetSpellTargetItem(),(GetItemCharges(GetSpellTargetItem())-1))
                    endif
                endif
                set udg_WirtsLegItem=GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FP') // 'I0FP': item "Wirt's Leg"
                call ConditionalTriggerExecute(gg_trg_CowPortal_Open)
            else
                call RemoveLocation(udg_TempPoint)
                set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000This action cannot be performed in this location!|r")
                call DestroyForce(udg_TempForce)
            endif
        endif
    endif
endfunction

// World Editor calls InitTrig_Wirts automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Wirts (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Wirts takes nothing returns nothing
endfunction

function Register_Wirts_Leg_Club takes nothing returns nothing
    set gg_trg_Wirts_Leg_Club=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Wirts_Leg_Club,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Wirts_Leg_Club,Condition(function Trig_Wirts_Leg_Club_Conditions))
    call TriggerAddAction(gg_trg_Wirts_Leg_Club,function Trig_Wirts_Leg_Club_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Wirts takes nothing returns nothing
    call Register_Wirts_Leg_Club()
endfunction

endlibrary

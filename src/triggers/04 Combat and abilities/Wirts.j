library TWirts requires TAbil, TForce, TProf
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
        // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
        // (4).
        set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
        // (udg_TempInteger) plus ((Strength of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*2))
        // (udg_TempInteger) plus ((Agility of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*2))
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
        // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R000'))).
        set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
        set udg_IsPhysicalAttack=true
        // Udg_TempInteger treated as a decimal-capable number.
        call UnitDamageTarget(GetTriggerUnit(),GetSpellTargetUnit(),I2R(udg_TempInteger),true,false,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_HEAVY_BASH)
    else
        if(Trig_Wirts_Leg_Club_CanOpenPortal())then
            set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
            if(Trig_Wirts_Leg_Club_OutsideTowns())then
                if(Trig_Wirts_Leg_Club_IsChargedItem())then
                    if(Trig_Wirts_Leg_Club_LastCharge())then
                        call RemoveItem(GetSpellTargetItem())
                    else
                        // (item charges of GetSpellTargetItem()) minus (1).
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Wirts takes nothing returns nothing
endfunction
function RegisterR11_Wirts_Leg_Club takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Wirts_Leg_Club=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Wirts_Leg_Club,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Wirts_Leg_Club,Condition(function Trig_Wirts_Leg_Club_Conditions))
    call TriggerAddAction(gg_trg_Wirts_Leg_Club,function Trig_Wirts_Leg_Club_Actions)
endfunction




endlibrary

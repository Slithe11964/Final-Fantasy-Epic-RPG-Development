library TRune requires TGroup, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Rune_Pickup=null
endglobals

function Trig_Rune_Pickup_IsRuneItem takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rhe1')or(GetItemTypeId(GetManipulatedItem())=='rman')or(GetItemTypeId(GetManipulatedItem())=='rhe2')or(GetItemTypeId(GetManipulatedItem())=='rdis')or(GetItemTypeId(GetManipulatedItem())=='rsps')or(GetItemTypeId(GetManipulatedItem())=='rma2')or(GetItemTypeId(GetManipulatedItem())=='rhe3')or(GetItemTypeId(GetManipulatedItem())=='rres') // 'rhe1': item "Heal"; 'rman': item "Mana"; 'rhe2': item "Healara"; 'rdis': item "Bravega"; 'rsps': item "Faithga"; 'rma2': item "Greater Mana"; 'rhe3': item "Healaga"; 'rres': item "Restoration"
endfunction

function Trig_Rune_Pickup_Conditions takes nothing returns boolean
    return(Trig_Rune_Pickup_IsRuneItem())
endfunction

function Trig_Rune_Pickup_NotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Rune_Pickup_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Rune_Pickup_AliveNonStructure takes nothing returns boolean
    return GetBooleanAnd(Trig_Rune_Pickup_NotStructure(),Trig_Rune_Pickup_IsAlive())
endfunction

function Trig_Rune_Pickup_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Rune_Pickup_ValidUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Rune_Pickup_AliveNonStructure(),Trig_Rune_Pickup_NotInvulnerable())
endfunction

function Trig_Rune_Pickup_IsAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Rune_Pickup_NotPlayer8 takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(8))
endfunction

function Trig_Rune_Pickup_NotNeutral takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Rune_Pickup_NotNeutralOwner takes nothing returns boolean
    return GetBooleanAnd(Trig_Rune_Pickup_NotPlayer8(),Trig_Rune_Pickup_NotNeutral())
endfunction

function Trig_Rune_Pickup_AllyNotNeutral takes nothing returns boolean
    return GetBooleanAnd(Trig_Rune_Pickup_IsAlly(),Trig_Rune_Pickup_NotNeutralOwner())
endfunction

function Trig_Rune_Pickup_ValidRuneTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Rune_Pickup_ValidUnit(),Trig_Rune_Pickup_AllyNotNeutral())
endfunction

function Trig_Rune_Pickup_IsHealaga takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rhe3') // 'rhe3': item "Healaga"
endfunction

function Trig_Rune_Pickup_IsTier2Rune takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rhe2')or(GetItemTypeId(GetManipulatedItem())=='rma2') // 'rhe2': item "Healara"; 'rma2': item "Greater Mana"
endfunction

function Trig_Rune_Pickup_Cond_Tier2Rune takes nothing returns boolean
    return(Trig_Rune_Pickup_IsTier2Rune())
endfunction

function Trig_Rune_Pickup_IsTier1Rune takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rhe1')or(GetItemTypeId(GetManipulatedItem())=='rman')or(GetItemTypeId(GetManipulatedItem())=='rres') // 'rhe1': item "Heal"; 'rman': item "Mana"; 'rres': item "Restoration"
endfunction

function Trig_Rune_Pickup_Cond_Tier1Rune takes nothing returns boolean
    return(Trig_Rune_Pickup_IsTier1Rune())
endfunction

function Trig_Rune_Pickup_HasLifeGain takes nothing returns boolean
    return(udg_TempReal>.0)
endfunction

function Trig_Rune_Pickup_HealEnum takes nothing returns nothing
    // Result 1: udg_TempInteger treated as a decimal-capable number.
    // Result 2: (result 1) divided by (20).
    // Result 3: (maximum health of the unit being visited) times (result 2).
    set udg_TempReal=(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEnumUnit())*(I2R(udg_TempInteger)/ 20.))
    if(Trig_Rune_Pickup_HasLifeGain())then
        // (current health of the unit being visited) plus (udg_TempReal).
        call SetUnitLifeBJ(GetEnumUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEnumUnit())+udg_TempReal))
        call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        // ((udg_TempReal) plus (0.5)) with its decimal part removed.
        call CreateTextTagLocBJ(I2S(R2I((udg_TempReal+.5))),udg_TempPoint,0,12.,.0,'d',.0,.0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),.1)
    endif
endfunction

function Trig_Rune_Pickup_IsLifeRune takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rhe1')or(GetItemTypeId(GetManipulatedItem())=='rhe2')or(GetItemTypeId(GetManipulatedItem())=='rhe3')or(GetItemTypeId(GetManipulatedItem())=='rres') // 'rhe1': item "Heal"; 'rhe2': item "Healara"; 'rhe3': item "Healaga"; 'rres': item "Restoration"
endfunction

function Trig_Rune_Pickup_Cond_LifeRune takes nothing returns boolean
    return(Trig_Rune_Pickup_IsLifeRune())
endfunction

function Trig_Rune_Pickup_HasManaGain takes nothing returns boolean
    return(udg_TempReal>.0)
endfunction

function Trig_Rune_Pickup_ManaEnum takes nothing returns nothing
    // Result 1: udg_TempInteger treated as a decimal-capable number.
    // Result 2: (result 1) divided by (20).
    // Result 3: (maximum mana of the unit being visited) times (result 2).
    set udg_TempReal=(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetEnumUnit())*(I2R(udg_TempInteger)/ 20.))
    if(Trig_Rune_Pickup_HasManaGain())then
        // (current mana of the unit being visited) plus (udg_TempReal).
        call SetUnitManaBJ(GetEnumUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetEnumUnit())+udg_TempReal))
        call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-64.)
        call RemoveLocation(udg_TempPoint)
        // ((udg_TempReal) plus (0.5)) with its decimal part removed.
        call CreateTextTagLocBJ((I2S(R2I((udg_TempReal+.5)))+" MP"),udg_TempPoint2,0,12.,.0,'d',.0,.0)
        call RemoveLocation(udg_TempPoint2)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),.1)
    endif
endfunction

function Trig_Rune_Pickup_IsManaRune takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rman')or(GetItemTypeId(GetManipulatedItem())=='rma2')or(GetItemTypeId(GetManipulatedItem())=='rres') // 'rman': item "Mana"; 'rma2': item "Greater Mana"; 'rres': item "Restoration"
endfunction

function Trig_Rune_Pickup_Cond_ManaRune takes nothing returns boolean
    return(Trig_Rune_Pickup_IsManaRune())
endfunction

function Trig_Rune_Pickup_CastFaith takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0N0',GetLastCreatedUnit()) // 'A0N0': ability "Faith"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",GetEnumUnit())
    set l_tempPoint=null
endfunction

function Trig_Rune_Pickup_IsFaithRune takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rsps') // 'rsps': item "Faithga"
endfunction

function Trig_Rune_Pickup_CastBravery takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0MZ',GetLastCreatedUnit()) // 'A0MZ': ability "Bravery"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"innerfire",GetEnumUnit())
    set l_tempPoint=null
endfunction

function Trig_Rune_Pickup_IsBraveryRune takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='rdis') // 'rdis': item "Bravega"
endfunction

function Trig_Rune_Pickup_Actions takes nothing returns nothing
    local group l_tempGroup
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set l_tempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Rune_Pickup_ValidRuneTarget))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Rune_Pickup_IsBraveryRune())then
        call ForGroupBJ(l_tempGroup,function Trig_Rune_Pickup_CastBravery)
    else
        if(Trig_Rune_Pickup_IsFaithRune())then
            call ForGroupBJ(l_tempGroup,function Trig_Rune_Pickup_CastFaith)
        else
            set udg_TempInteger=0
            if(Trig_Rune_Pickup_Cond_Tier1Rune())then
                set udg_TempInteger=5
            else
                if(Trig_Rune_Pickup_Cond_Tier2Rune())then
                    set udg_TempInteger=8
                else
                    if(Trig_Rune_Pickup_IsHealaga())then
                        set udg_TempInteger=$C // $C = 12
                    endif
                endif
            endif
            if(Trig_Rune_Pickup_Cond_LifeRune())then
                call ForGroupBJ(l_tempGroup,function Trig_Rune_Pickup_HealEnum)
            endif
            if(Trig_Rune_Pickup_Cond_ManaRune())then
                call ForGroupBJ(l_tempGroup,function Trig_Rune_Pickup_ManaEnum)
            endif
        endif
    endif
    call DestroyGroup(l_tempGroup)
    call Wait_Polled(1.)
    call RemoveItem(GetManipulatedItem())
    set l_tempGroup=null
endfunction

// World Editor calls InitTrig_Rune automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Rune (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Rune takes nothing returns nothing
endfunction

function Register_Rune_Pickup takes nothing returns nothing
    set gg_trg_Rune_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Rune_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Rune_Pickup,Condition(function Trig_Rune_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Rune_Pickup,function Trig_Rune_Pickup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Rune takes nothing returns nothing
    call Register_Rune_Pickup()
endfunction

endlibrary

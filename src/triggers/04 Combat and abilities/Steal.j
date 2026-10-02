library TSteal requires TForce, TItemShared
function Trig_Steal_Cast_RollSteal takes nothing returns nothing
    local integer l_roll
    local integer l_slot=2
    local real l_elapsed=TimerGetElapsed(udg_GameClock)
    // Turn elapsed seconds into whole milliseconds, then keep the remainder after division by 400.
    local integer l_seed=ModuloInteger(R2I(l_elapsed*1000.),400)
    local unit thief=GetTriggerUnit()
    local unit victim=GetSpellTargetUnit()
    local integer l_victimType=GetUnitTypeId(victim)
    local integer abilityLevel=GetUnitAbilityLevel(thief,GetSpellAbilityId())
    // Starting value for l_victimLevel:
    // (unit level of victim) plus (1).
    local integer l_victimLevel=GetUnitLevel(victim)+1
    // Start with half of (thief level + 1), dropping fractions, plus 5 per Steal ability level.
    local integer successChance=((GetUnitLevel(thief)+1)/ 2)+(abilityLevel*5)
    set thief=null
    if(GetUnitAbilityLevel(victim,'A0MS')>0)then // 'A0MS': ability "Unstealable"
        set victim=null
        return
    endif
    if(IsUnitIllusion(victim)or IsUnitInGroup(victim,udg_MirrorCloneGroup))then
        call UnitAddAbility(victim,'A0MS') // 'A0MS': ability "Unstealable"
        set victim=null
        return
    endif
    if(LoadInteger(udg_MonsterDataHash,l_victimType,2)<=0 and(LoadInteger(udg_MonsterDataHash,l_victimType,3)<=0 and LoadInteger(udg_MonsterDataHash,l_victimType,4)<=0))then
        call UnitAddAbility(victim,'A0MS') // 'A0MS': ability "Unstealable"
        set victim=null
        return
    endif
    if(abilityLevel>$A)then // $A = 10
        // Increase chance by 10.
        set successChance=successChance+$A // $A = 10
    endif
    if(successChance<=l_victimLevel)then
        set successChance=40
    else
        // Start at 40% success, then add 2 percentage points for each point above the victim's level score.
        set successChance=(successChance-l_victimLevel)*2+40
    endif
    // Roll from 1 to 100 and fail if the roll is above the chance. A chance of 100 or more skips this failure roll.
    if(successChance<'d' and GetRandomInt(1,'d')>successChance)then
        set victim=null
        return
    endif
    // The remainder after dividing ((udg_DropRollSeed) plus (7)) by (20).
    set udg_DropRollSeed=ModuloInteger(udg_DropRollSeed+7,20)
    // Mix the seeds and a random number, then wrap the result into the range 1 to 20.
    set l_roll=ModuloInteger(l_seed+udg_DropRollSeed+R2I(l_elapsed)+GetRandomInt(0,19),20)+1
    // Choose loot slot 2 on rolls 1-14 (70%), slot 3 on 15-19 (25%), or slot 4 on 20 (5%).
    if(l_roll<=$E)then // $E = 14
        set l_slot=2
    elseif(l_roll<=19)then
        set l_slot=3
    else
        set l_slot=4
    endif
    set l_slot=LoadInteger(udg_MonsterDataHash,l_victimType,l_slot)
    if(l_slot>0)then
        call UnitAddAbility(victim,'A0MS') // 'A0MS': ability "Unstealable"
        set udg_LootItemID=Item_IdFromIndex(l_slot)
    endif
    set victim=null
endfunction

function Trig_Steal_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0MR') // 'A0MR': ability "Steal"
endfunction

function Trig_Steal_Cast_IsWinterKeyTarget takes nothing returns boolean
    return(GetSpellTargetUnit()==gg_unit_U00L_0207)and(GetUnitAbilityLevelSwapped('A0MS',GetSpellTargetUnit())<=0) // 'A0MS': ability "Unstealable"
endfunction

function Trig_Steal_Cast_IsUnstealable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0MS',GetSpellTargetUnit())>0) // 'A0MS': ability "Unstealable"
endfunction

function Trig_Steal_Cast_GotItem takes nothing returns boolean
    return(udg_LootItemID!='tkno') // 'tkno': object name not found in map data
endfunction

function Trig_Steal_Cast_Actions takes nothing returns nothing
    if(Trig_Steal_Cast_IsWinterKeyTarget())then
        call UnitAddAbilityBJ('A0MS',gg_unit_U00L_0207) // 'A0MS': ability "Unstealable"
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectTargetUnitBJ("chest",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call CreateItemLoc('I0IM',udg_TempPoint) // 'I0IM': item "Winter Key"
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        call CreateTextTagLocBJ(("Stole |cffffcc00"+(GetItemName(GetLastCreatedItem())+"|r!")),udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        call RemoveLocation(udg_TempPoint)
        call UnitAddItemSwapped(GetLastCreatedItem(),GetTriggerUnit())
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),3.)
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
        call DestroyForce(udg_TempForce)
        return
    endif
    set udg_LootItemID='tkno' // 'tkno': object name not found in map data
    call Trig_Steal_Cast_RollSteal()
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Steal_Cast_GotItem())then
        call AddSpecialEffectTargetUnitBJ("chest",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call CreateItemLoc(udg_LootItemID,udg_TempPoint)
        call CreateTextTagLocBJ(("Stole |cffffcc00"+(GetItemName(GetLastCreatedItem())+"|r!")),udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        call RemoveLocation(udg_TempPoint)
        call UnitAddItemSwapped(GetLastCreatedItem(),GetTriggerUnit())
    else
        if(Trig_Steal_Cast_IsUnstealable())then
            call CreateTextTagLocBJ("Nothing to steal.",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        else
            call CreateTextTagLocBJ("Couldn't steal...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        endif
        call RemoveLocation(udg_TempPoint)
    endif
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),3.)
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Steal takes nothing returns nothing
endfunction

function RegisterR11_Steal_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Steal_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Steal_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Steal_Cast,Condition(function Trig_Steal_Cast_Conditions))

call TriggerAddAction(gg_trg_Steal_Cast,function Trig_Steal_Cast_Actions)

endfunction




endlibrary

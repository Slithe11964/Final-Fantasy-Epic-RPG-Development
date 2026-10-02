library TSpiritScroll requires TForce, TWait
function Trig_SpiritScroll_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0EV') // 'I0EV': item "Spirit Scroll"
endfunction

function Trig_SpiritScroll_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call AddItemToStockBJ('I0HC',gg_unit_n02Y_0052,1,1) // 'I0HC': item "Information: Spirit Scroll"
    call EnableTrigger(gg_trg_SpiritScroll_Cleanse)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_SpiritScroll_Cleanse_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0IN') // 'A0IN': ability "Spirit Scroll"
endfunction

function Trig_SpiritScroll_Cleanse_QuestNotStarted takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_SpiritScroll_Cleanse_AllSpiritsCleansed takes nothing returns boolean
    return(udg_SpiritsCleansed>=3)
endfunction

function Trig_SpiritScroll_Cleanse_IsCorruptedSpirit takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n089')and(GetOwningPlayer(GetSpellTargetUnit())==Player($B)) // 'n089': unit "Forest Spirit"; $B = 11
endfunction

function Trig_SpiritScroll_Cleanse_Actions takes nothing returns nothing
    if(Trig_SpiritScroll_Cleanse_IsCorruptedSpirit())then
        call RemoveItemFromStockBJ('I0HC',gg_unit_n02Y_0052) // 'I0HC': item "Information: Spirit Scroll"
        call SetUnitOwner(GetSpellTargetUnit(),Player(9),false)
        call SetUnitVertexColorBJ(GetSpellTargetUnit(),'d','d','d',0)
        call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_SpiritsCleansed=(udg_SpiritsCleansed+1)
        if(Trig_SpiritScroll_Cleanse_AllSpiritsCleansed())then
            call DisableTrigger(GetTriggeringTrigger())
            if(Trig_SpiritScroll_Cleanse_QuestNotStarted())then
                call Wait_Polled(60.)
                call DisplayTextToForce(GetPlayersAll(),"|cff00ffffGaladriel has something to tell you !!!|r")
                call GroupAddUnitSimple(gg_unit_Etyr_0155,udg_BossUnits)
                set udg_SpecialEffect[85]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Etyr_0155,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                call EnableTrigger(gg_trg_VoiceOfForest_Start)
            endif
            call DestroyTrigger(GetTriggeringTrigger())
        endif
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"The scroll appears to have no effect.")
        call DestroyForce(udg_TempForce)
        call PauseUnitBJ(true,GetTriggerUnit())
        call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
        call PauseUnitBJ(false,GetTriggerUnit())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_SpiritScroll takes nothing returns nothing
endfunction

function RegisterR11_SpiritScroll_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_SpiritScroll_Pickup=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_SpiritScroll_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_SpiritScroll_Pickup,Condition(function Trig_SpiritScroll_Pickup_Conditions))

call TriggerAddAction(gg_trg_SpiritScroll_Pickup,function Trig_SpiritScroll_Pickup_Actions)

endfunction




function RegisterR11_SpiritScroll_Cleanse takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_SpiritScroll_Cleanse=CreateTrigger()

call DisableTrigger(gg_trg_SpiritScroll_Cleanse)

call TriggerRegisterAnyUnitEventBJ(gg_trg_SpiritScroll_Cleanse,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_SpiritScroll_Cleanse,Condition(function Trig_SpiritScroll_Cleanse_Conditions))

call TriggerAddAction(gg_trg_SpiritScroll_Cleanse,function Trig_SpiritScroll_Cleanse_Actions)

endfunction




endlibrary

library TLoki requires TCam, TCine, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Loki_Talk_Enable=null
    trigger gg_trg_Loki_Reforge_Unlock=null
    trigger gg_trg_Loki_Reforge_Offer=null
    trigger gg_trg_Loki_Reforge_Drop=null
    trigger gg_trg_Loki_Forge_Text_Clear=null
    trigger gg_trg_Loki_Reforge_Confirm=null
    // Variables only this module uses.
    integer udg_ReforgeResultType=0
endglobals

function Trig_Loki_Talk_Enable_Actions takes nothing returns nothing
    set udg_SpecialEffect[88]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H00P_0260,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_OreSupplies_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Loki_Reforge_Unlock_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_H00P_0260,true,true,true))
endfunction

function Trig_Loki_Reforge_Unlock_PlayUnlockScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Loki_Reforge_Unlock_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[88])
    if(Trig_Loki_Reforge_Unlock_PlayUnlockScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H00P_0260,"Lali-ho again. Sorry I wasn't trusting you before.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Don't worry about it. Would you be willing to lend us your skills now?",false)
        call Text_Say(gg_unit_H00P_0260,"Aye, for sure. Here's what I can offer you: bring me a piece of low quality gear, and I can forge some crystal shards into it, strengthening it considerably.",false)
        call Text_Say(gg_unit_H00P_0260,"I'll need Crystal Shards for the procedure, and I can't reforge every kind of gear, but hope this'll be of use to you. Oh and the gear I strengthen can also be further enhanced with special materials, but that's my brother Bali's domain, not mine.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds great! We'll make good use of your skills.",false)
        call Text_Say(gg_unit_H00P_0260,"|n|cffffcc00Loki can now reforge gear below Level 45 at the cost of up to 3 Crystal Shards!|r",true)
        call Cine_ExitAction()
    else
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Loki can now reforge gear below Level 45 at the cost of up to 3 Crystal Shards!|r")
    endif
    call EnableTrigger(gg_trg_Loki_Reforge_Offer)
    call UnitAddAbilityBJ('A03S',gg_unit_H00P_0260) // 'A03S': ability "Forge Inventory"
    set udg_LokiForgeText=CreateTextTagUnitBJ(" ",gg_unit_H00P_0260,0,12.,'d','d','d',0)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Loki_Reforge_Offer_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H00P_0260)
endfunction

function Trig_Loki_Reforge_Offer_ItemNotAccepted takes nothing returns boolean
    return(udg_LokiReforgeItem!=null)or(GetItemType(GetManipulatedItem())==ITEM_TYPE_CHARGED)or(GetItemType(GetManipulatedItem())==ITEM_TYPE_CAMPAIGN)or(GetItemType(GetManipulatedItem())==ITEM_TYPE_MISCELLANEOUS)
endfunction

function Trig_Loki_Reforge_Offer_HelmetLevel2 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==2)
endfunction

function Trig_Loki_Reforge_Offer_HelmetLevel1 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==1)
endfunction

function Trig_Loki_Reforge_Offer_ArmorLevel3 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==3)
endfunction

function Trig_Loki_Reforge_Offer_ArmorLevel2 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==2)
endfunction

function Trig_Loki_Reforge_Offer_ArmorLevel1 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==1)
endfunction

function Trig_Loki_Reforge_Offer_IsArmorItem takes nothing returns boolean
    return(GetItemType(udg_LokiReforgeItem)==ITEM_TYPE_PURCHASABLE)
endfunction

function Trig_Loki_Reforge_Offer_IsHelmetItem takes nothing returns boolean
    return(GetItemType(udg_LokiReforgeItem)==ITEM_TYPE_ARTIFACT)
endfunction

function Trig_Loki_Reforge_Offer_OffhandLevel12 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==1)or(GetItemLevel(udg_LokiReforgeItem)==2)
endfunction

function Trig_Loki_Reforge_Offer_OffhandAccepted takes nothing returns boolean
    return(Trig_Loki_Reforge_Offer_OffhandLevel12())
endfunction

function Trig_Loki_Reforge_Offer_IsOffhandItem takes nothing returns boolean
    return(GetItemType(udg_LokiReforgeItem)==ITEM_TYPE_POWERUP)
endfunction

function Trig_Loki_Reforge_Offer_WeaponLevel7 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==7)
endfunction

function Trig_Loki_Reforge_Offer_WeaponLevel6 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==6)
endfunction

function Trig_Loki_Reforge_Offer_WeaponLevel5 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==5)
endfunction

function Trig_Loki_Reforge_Offer_WeaponLevel2 takes nothing returns boolean
    return(GetItemLevel(udg_LokiReforgeItem)==2)
endfunction

function Trig_Loki_Reforge_Offer_IsWeaponItem takes nothing returns boolean
    return(GetItemType(udg_LokiReforgeItem)==ITEM_TYPE_PERMANENT)
endfunction

function Trig_Loki_Reforge_Offer_GearTooStrong takes nothing returns boolean
    return(GetItemLifeBJ(udg_LokiReforgeItem)>=45.)
endfunction

function Trig_Loki_Reforge_Offer_GearMidTier takes nothing returns boolean
    return(GetItemLifeBJ(udg_LokiReforgeItem)>=30.)
endfunction

function Trig_Loki_Reforge_Offer_GearLowTier takes nothing returns boolean
    return(GetItemLifeBJ(udg_LokiReforgeItem)>=20.)
endfunction

function Trig_Loki_Reforge_Offer_ResultChosen takes nothing returns boolean
    return(udg_ReforgeResultType!='tkno') // 'tkno': object name not found in map data
endfunction

function Trig_Loki_Reforge_Offer_ItemRejected takes nothing returns boolean
    return(Trig_Loki_Reforge_Offer_ItemNotAccepted())
endfunction

function Trig_Loki_Reforge_Offer_Actions takes nothing returns nothing
    if(Trig_Loki_Reforge_Offer_ItemRejected())then
        call UnitRemoveItemSwapped(GetManipulatedItem(),GetTriggerUnit())
        call SetItemPositionLoc(GetManipulatedItem(),udg_LokiForgeSpot)
    else
        set udg_LokiReforgeItem=GetManipulatedItem()
        set udg_ReforgeResultType='tkno' // 'tkno': object name not found in map data
        if(Trig_Loki_Reforge_Offer_GearTooStrong())then
            call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: Sorry, I am not able to reforge something of this high a quality.",12.)
        else
            if(Trig_Loki_Reforge_Offer_IsWeaponItem())then
                if(Trig_Loki_Reforge_Offer_WeaponLevel2())then
                    set udg_ReforgeResultType='I0L7' // 'I0L7': item "Shimmering Sword"
                else
                    if(Trig_Loki_Reforge_Offer_WeaponLevel5())then
                        set udg_ReforgeResultType='I0L6' // 'I0L6': item "Shimmering Spear"
                    else
                        if(Trig_Loki_Reforge_Offer_WeaponLevel6())then
                            set udg_ReforgeResultType='I0L8' // 'I0L8': item "Shimmering Axe"
                        else
                            if(Trig_Loki_Reforge_Offer_WeaponLevel7())then
                                set udg_ReforgeResultType='I0L9' // 'I0L9': item "Shimmering Katana"
                            else
                                call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: Sorry, I can't reforge this type of weapon.",12.)
                            endif
                        endif
                    endif
                endif
            else
                if(Trig_Loki_Reforge_Offer_IsOffhandItem())then
                    if(Trig_Loki_Reforge_Offer_OffhandAccepted())then
                        set udg_ReforgeResultType='I0LN' // 'I0LN': item "Shimmering Shield"
                    else
                        call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: Sorry, I can't reforge this type of offhand gear.",12.)
                    endif
                else
                    if(Trig_Loki_Reforge_Offer_IsHelmetItem())then
                        if(Trig_Loki_Reforge_Offer_HelmetLevel1())then
                            set udg_ReforgeResultType='I0LO' // 'I0LO': item "Shimmering Helmet"
                        else
                            if(Trig_Loki_Reforge_Offer_HelmetLevel2())then
                                set udg_ReforgeResultType='I0L4' // 'I0L4': item "Glimmering Hat"
                            else
                                call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: Sorry, I can't reforge this type of helmet.",12.)
                            endif
                        endif
                    else
                        if(Trig_Loki_Reforge_Offer_IsArmorItem())then
                            if(Trig_Loki_Reforge_Offer_ArmorLevel1())then
                                set udg_ReforgeResultType='I0LM' // 'I0LM': item "Shimmering Cloth"
                            else
                                if(Trig_Loki_Reforge_Offer_ArmorLevel2())then
                                    set udg_ReforgeResultType='I01S' // 'I01S': item "Shimmering Mail"
                                else
                                    if(Trig_Loki_Reforge_Offer_ArmorLevel3())then
                                        set udg_ReforgeResultType='I0KQ' // 'I0KQ': item "Glimmering Robe"
                                    else
                                        call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: Sorry, I can't reforge this type of armor.",12.)
                                    endif
                                endif
                            endif
                        else
                            call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: Sorry, I can't reforge this type of item.",12.)
                        endif
                    endif
                endif
            endif
        endif
        if(Trig_Loki_Reforge_Offer_ResultChosen())then
            call PauseTimerBJ(true,udg_LokiForgeTextTimer)
            call UnitAddAbilityBJ('Ane2',GetTriggerUnit()) // 'Ane2': object name not found in map data
            call AddItemToStockBJ(udg_ReforgeResultType,GetTriggerUnit(),0,0)
            if(Trig_Loki_Reforge_Offer_GearLowTier())then
                if(Trig_Loki_Reforge_Offer_GearMidTier())then
                    call AddUnitToStockBJ('n0MJ',GetTriggerUnit(),1,1) // 'n0MJ': unit "Loki Reforge Gear"
                    call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: I can reforge this piece of gear with 1 Crystal Shard with this result. Sound good?",12.)
                else
                    call AddUnitToStockBJ('n0MI',GetTriggerUnit(),1,1) // 'n0MI': unit "Loki Reforge Gear"
                    call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: I can reforge this piece of gear with 2 Crystal Shards with this result. Sound good?",12.)
                endif
            else
                call AddUnitToStockBJ('n0AA',GetTriggerUnit(),1,1) // 'n0AA': unit "Loki Reforge Gear"
                call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: I can reforge this piece of gear with 3 Crystal Shards with this result. Sound good?",12.)
            endif
            set udg_LokiForgeText=GetLastCreatedTextTag()
            call AddUnitToStockBJ('n0AD',GetTriggerUnit(),1,1) // 'n0AD': unit "Forge Cancel"
            call EnableTrigger(gg_trg_Loki_Reforge_Confirm)
            call EnableTrigger(gg_trg_Loki_Reforge_Drop)
        else
            call StartTimerBJ(udg_LokiForgeTextTimer,false,5.)
            call UnitRemoveItemSwapped(udg_LokiReforgeItem,GetTriggerUnit())
            call SetItemPositionLoc(udg_LokiReforgeItem,udg_LokiForgeSpot)
            set udg_LokiReforgeItem=null
        endif
    endif
endfunction

function Trig_Loki_Reforge_Drop_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H00P_0260)and(GetManipulatedItem()==udg_LokiReforgeItem)
endfunction

function Trig_Loki_Reforge_Drop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Loki_Reforge_Confirm)
    call StartTimerBJ(udg_LokiForgeTextTimer,false,.01)
    call UnitRemoveAbilityBJ('Ane2',GetTriggerUnit()) // 'Ane2': object name not found in map data
    call RemoveItemFromStockBJ(udg_ReforgeResultType,GetTriggerUnit())
    call RemoveUnitFromStockBJ('n0AA',GetTriggerUnit()) // 'n0AA': unit "Loki Reforge Gear"
    call RemoveUnitFromStockBJ('n0MI',GetTriggerUnit()) // 'n0MI': unit "Loki Reforge Gear"
    call RemoveUnitFromStockBJ('n0MJ',GetTriggerUnit()) // 'n0MJ': unit "Loki Reforge Gear"
    call RemoveUnitFromStockBJ('n0AD',GetTriggerUnit()) // 'n0AD': unit "Forge Cancel"
    set udg_LokiReforgeItem=null
endfunction

function Trig_Loki_Forge_Text_Clear_Actions takes nothing returns nothing
    call SetTextTagTextBJ(udg_LokiForgeText," ",12.)
endfunction

function Trig_Loki_Reforge_Confirm_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H00P_0260)
endfunction

function Trig_Loki_Reforge_Confirm_CancelChosen takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0AD') // 'n0AD': unit "Forge Cancel"
endfunction

function Trig_Loki_Reforge_Confirm_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Loki_Reforge_Drop)
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.21,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    call UnitRemoveAbilityBJ('Ane2',GetTriggerUnit()) // 'Ane2': object name not found in map data
    call RemoveItemFromStockBJ(udg_ReforgeResultType,GetTriggerUnit())
    call RemoveUnitFromStockBJ('n0AA',GetTriggerUnit()) // 'n0AA': unit "Loki Reforge Gear"
    call RemoveUnitFromStockBJ('n0MI',GetTriggerUnit()) // 'n0MI': unit "Loki Reforge Gear"
    call RemoveUnitFromStockBJ('n0MJ',GetTriggerUnit()) // 'n0MJ': unit "Loki Reforge Gear"
    call RemoveUnitFromStockBJ('n0AD',GetTriggerUnit()) // 'n0AD': unit "Forge Cancel"
    if(Trig_Loki_Reforge_Confirm_CancelChosen())then
        call StartTimerBJ(udg_LokiForgeTextTimer,false,.01)
        call UnitRemoveItemSwapped(udg_LokiReforgeItem,GetTriggerUnit())
        call SetItemPositionLoc(udg_LokiReforgeItem,udg_LokiForgeSpot)
    else
        call StartTimerBJ(udg_LokiForgeTextTimer,false,5.)
        call SetTextTagTextBJ(udg_LokiForgeText,"|cffffcc00Loki|r: Here you go. Use it well.",12.)
        call CreateItemLoc(udg_ReforgeResultType,udg_LokiForgeSpot)
        call SetItemUserData(GetLastCreatedItem(),GetItemUserData(udg_LokiReforgeItem))
        call RemoveItem(udg_LokiReforgeItem)
    endif
    set udg_LokiReforgeItem=null
endfunction

// World Editor calls InitTrig_Loki automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Loki_Part1 / RegisterTriggers_Loki_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Loki takes nothing returns nothing
endfunction

function Register_Loki_Talk_Enable takes nothing returns nothing
    set gg_trg_Loki_Talk_Enable=CreateTrigger()
    call DisableTrigger(gg_trg_Loki_Talk_Enable)
    call TriggerAddAction(gg_trg_Loki_Talk_Enable,function Trig_Loki_Talk_Enable_Actions)
endfunction

function Register_Loki_Reforge_Unlock takes nothing returns nothing
    set gg_trg_Loki_Reforge_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Loki_Reforge_Unlock)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Loki_Reforge_Unlock,Player(7),true)
    call TriggerAddCondition(gg_trg_Loki_Reforge_Unlock,Condition(function Trig_Loki_Reforge_Unlock_Conditions))
    call TriggerAddAction(gg_trg_Loki_Reforge_Unlock,function Trig_Loki_Reforge_Unlock_Actions)
endfunction

function Register_Loki_Reforge_Offer takes nothing returns nothing
    set gg_trg_Loki_Reforge_Offer=CreateTrigger()
    call DisableTrigger(gg_trg_Loki_Reforge_Offer)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Loki_Reforge_Offer,Player(9),EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Loki_Reforge_Offer,Condition(function Trig_Loki_Reforge_Offer_Conditions))
    call TriggerAddAction(gg_trg_Loki_Reforge_Offer,function Trig_Loki_Reforge_Offer_Actions)
endfunction

function Register_Loki_Reforge_Drop takes nothing returns nothing
    set gg_trg_Loki_Reforge_Drop=CreateTrigger()
    call DisableTrigger(gg_trg_Loki_Reforge_Drop)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Loki_Reforge_Drop,Player(9),EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Loki_Reforge_Drop,Condition(function Trig_Loki_Reforge_Drop_Conditions))
    call TriggerAddAction(gg_trg_Loki_Reforge_Drop,function Trig_Loki_Reforge_Drop_Actions)
endfunction

function Register_Loki_Forge_Text_Clear takes nothing returns nothing
    set gg_trg_Loki_Forge_Text_Clear=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Loki_Forge_Text_Clear,udg_LokiForgeTextTimer)
    call TriggerAddAction(gg_trg_Loki_Forge_Text_Clear,function Trig_Loki_Forge_Text_Clear_Actions)
endfunction

function Register_Loki_Reforge_Confirm takes nothing returns nothing
    set gg_trg_Loki_Reforge_Confirm=CreateTrigger()
    call DisableTrigger(gg_trg_Loki_Reforge_Confirm)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Loki_Reforge_Confirm,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Loki_Reforge_Confirm,Condition(function Trig_Loki_Reforge_Confirm_Conditions))
    call TriggerAddAction(gg_trg_Loki_Reforge_Confirm,function Trig_Loki_Reforge_Confirm_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Loki_Part1 takes nothing returns nothing
    call Register_Loki_Talk_Enable()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Loki_Part2 takes nothing returns nothing
    call Register_Loki_Reforge_Unlock()
    call Register_Loki_Reforge_Offer()
    call Register_Loki_Reforge_Drop()
    call Register_Loki_Forge_Text_Clear()
    call Register_Loki_Reforge_Confirm()
endfunction

endlibrary

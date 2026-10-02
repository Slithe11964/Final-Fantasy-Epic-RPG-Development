library TDefiledFountain requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_DefiledFountain_Prepare_Actions takes nothing returns nothing
    set udg_SpecialEffect[42]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e007_0154,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_DefiledFountain_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DefiledFountain_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e007_0154,true,true,true))
endfunction

function Trig_DefiledFountain_Start_Cond_HealingWatersKnown takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[$F])) // $F = 15
endfunction

function Trig_DefiledFountain_Start_Cond_ShowFeanorTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DefiledFountain_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[42])
    if(Trig_DefiledFountain_Start_Cond_ShowFeanorTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello. Say, what's wrong with that fountain of yours? It's green and it smells bad.",false)
        if(Trig_DefiledFountain_Start_Cond_HealingWatersKnown())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I was asked to bring waters from the Fountain of Restoration to help a sick child. Where can I find it?",false)
            call Text_Say(gg_unit_e007_0154,"Alas, my friend, you came too late. Our precious Fountain of Restoration that was defiled by foul Satyrs.",false)
        else
            call Text_Say(gg_unit_e007_0154,"Alas, my friend, you are witnessing what has become with our precious Fountain of Restoration that was defiled by foul Satyrs.",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What do you mean defiled?",false)
        call Text_Say(gg_unit_e007_0154,"Despite the magical protection of Lothlorien that wards off most evil spell our corrupted brethren - Satyrs - were somehow able to corrupt the Fountain. What was once the source of life and health is now but a stinking pool of death and decay.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Is there any way to revert the corruption and cleanse the Fountain of Restoration?",false)
        call Text_Say(gg_unit_e007_0154,"Yes, there is a way to restore the Fountain. I can perform such a ritual but I require special reagents in order to complete it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And what are these reagents?",false)
        call Text_Say(gg_unit_e007_0154,"First of all I need Satyr's hoof that will represent the source of corruption during the ritual.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And where can I get one?",false)
        call Text_Say(gg_unit_e007_0154,"Isn't that obvious? Find a Satyr (there are plenty in the forest nearby) , kill him and cut off the hoof.",false)
        call Text_Say(gg_unit_e007_0154,"Celeborn and Galadriel think that Satyrs may still be saved from their wretched existence but they are wrong. Satyrs are corrupt to the core. So don't hesitate to slay them.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I won't. But what are other reagents?",false)
        call Text_Say(gg_unit_e007_0154,"I'll tell you once you bring me the hoof. And remember that the hoof must not be damaged too much - so maybe you'll have to check out more than one Satyr to get a hoof that I need.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"OK.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Defiled Fountain|r")
    set udg_SideQuest[23]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Defiled Fountain"),"Feanor, wizard from Lothlorien, asked you to bring him Satyr's Hoof that is required for the ritual that will cleanse the Defiled Fountain of Restoration.","ReplaceableTextures\\CommandButtons\\BTNFountainOfLifeDefiled.blp")
    set udg_SpecialEffect[42]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e007_0154,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_DefiledFountain_Hoof)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DefiledFountain_Hoof_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0DX'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0DX': item "Satyr's Hoof"
endfunction

function Trig_DefiledFountain_Hoof_Cond_HasSpareHoof takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0DX'))>=2) // 'I0DX': item "Satyr's Hoof"
endfunction

function Trig_DefiledFountain_Hoof_Cond_ShowHoofTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DefiledFountain_Hoof_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DefiledFountain_Hoof_Cond_HasSpareHoof())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0DX')) minus (1).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0DX'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0DX'))-1)) // 'I0DX': item "Satyr's Hoof"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0DX')) // 'I0DX': item "Satyr's Hoof"
    endif
    if(Trig_DefiledFountain_Hoof_Cond_ShowHoofTalk())then
        call DestroyEffectBJ(udg_SpecialEffect[42])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e007_0154,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here's the hoof you asked for.",false)
        call Text_Say(gg_unit_e007_0154,"Brilliant. That's exactly what I need.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So, what now?",false)
        call Text_Say(gg_unit_e007_0154,"Now you'll have to search for an item called Thunderbloom Bulb. You can find it in Barrens.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Ok, I am going to find it.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[42]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e007_0154,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Find Thunderbloom Bulb in Barrens and bring it to Feanor.")
    call QuestSetDescriptionBJ(udg_SideQuest[23],"Find Thunderbloom Bulb in Barrens and bring it to Feanor.")
    call EnableTrigger(gg_trg_DefiledFountain_PingBulb)
    call EnableTrigger(gg_trg_DefiledFountain_BulbPickup)
    call EnableTrigger(gg_trg_Quest_Fountain_Bulb)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DefiledFountain_PingBulb_Conditions takes nothing returns boolean
    return(udg_ThunderbloomItem!=null)
endfunction

function Trig_DefiledFountain_PingBulb_Cond_BulbCarried takes nothing returns boolean
    return(IsItemOwned(udg_ThunderbloomItem))
endfunction

function Trig_DefiledFountain_PingBulb_Actions takes nothing returns nothing
    if(Trig_DefiledFountain_PingBulb_Cond_BulbCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_e007_0154)
    else
        set udg_TempPoint=GetItemLoc(udg_ThunderbloomItem)
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_DefiledFountain_BulbPickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0FN') // 'I0FN': item "Thunderbloom Bulb"
endfunction

function Trig_DefiledFountain_BulbPickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Thunderbloom Bulb to Feanor.")
    call DestroyForce(udg_TempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[23],"Bring the Thunderbloom Bulb to Feanor.")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DefiledFountain takes nothing returns nothing
endfunction

function RegisterR11_DefiledFountain_Prepare takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DefiledFountain_Prepare=CreateTrigger()

call DisableTrigger(gg_trg_DefiledFountain_Prepare)

call TriggerAddAction(gg_trg_DefiledFountain_Prepare,function Trig_DefiledFountain_Prepare_Actions)

endfunction




function RegisterR11_DefiledFountain_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DefiledFountain_Start=CreateTrigger()

call DisableTrigger(gg_trg_DefiledFountain_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DefiledFountain_Start,Player(7),true)

call TriggerAddCondition(gg_trg_DefiledFountain_Start,Condition(function Trig_DefiledFountain_Start_Conditions))

call TriggerAddAction(gg_trg_DefiledFountain_Start,function Trig_DefiledFountain_Start_Actions)

endfunction




function RegisterR11_DefiledFountain_Hoof takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DefiledFountain_Hoof=CreateTrigger()

call DisableTrigger(gg_trg_DefiledFountain_Hoof)

call TriggerRegisterUnitInRangeSimple(gg_trg_DefiledFountain_Hoof,450.,gg_unit_e007_0154)

call TriggerAddCondition(gg_trg_DefiledFountain_Hoof,Condition(function Trig_DefiledFountain_Hoof_Conditions))

call TriggerAddAction(gg_trg_DefiledFountain_Hoof,function Trig_DefiledFountain_Hoof_Actions)

endfunction




function RegisterR11_DefiledFountain_PingBulb takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DefiledFountain_PingBulb=CreateTrigger()

call DisableTrigger(gg_trg_DefiledFountain_PingBulb)

call TriggerRegisterTimerEventPeriodic(gg_trg_DefiledFountain_PingBulb,15.)

call TriggerAddCondition(gg_trg_DefiledFountain_PingBulb,Condition(function Trig_DefiledFountain_PingBulb_Conditions))

call TriggerAddAction(gg_trg_DefiledFountain_PingBulb,function Trig_DefiledFountain_PingBulb_Actions)

endfunction




function RegisterR11_DefiledFountain_BulbPickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DefiledFountain_BulbPickup=CreateTrigger()

call DisableTrigger(gg_trg_DefiledFountain_BulbPickup)

call TriggerRegisterAnyUnitEventBJ(gg_trg_DefiledFountain_BulbPickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_DefiledFountain_BulbPickup,Condition(function Trig_DefiledFountain_BulbPickup_Conditions))

call TriggerAddAction(gg_trg_DefiledFountain_BulbPickup,function Trig_DefiledFountain_BulbPickup_Actions)

endfunction




endlibrary

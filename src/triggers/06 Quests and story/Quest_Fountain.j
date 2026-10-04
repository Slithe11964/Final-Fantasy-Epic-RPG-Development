library TQuestFountain requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText, TWait
// Side quest "Defiled Fountain", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Feanor needs reagents to cleanse the Fountain of Restoration. All steps are cinematics in modules
// DefiledFountain and Quest_Fountain: Feanor's talk (DefiledFountain, QuestFountain_Started), the Satyr's
// Hoof (DefiledFountain, QuestFountain_HoofDone), the Thunderbloom Bulb (Bulb) and the Scroll of
// Rejuvenation (Complete). Picking up the bulb updates the log (QuestFountain_BulbTaken). The "!" and
// "?" over Feanor are DefiledFountain's own effects. It does not count toward the story progress.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Fountain_Bulb=null
    trigger gg_trg_Quest_Fountain_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_FOUNTAIN=0
endglobals

function QuestFountain_Define takes nothing returns nothing
    local integer q=Quest_Define("Defiled Fountain",QUEST_SIDE,23,"ReplaceableTextures\\CommandButtons\\BTNFountainOfLifeDefiled.blp")
    set QUEST_FOUNTAIN=q
    call Quest_NoMarker(q)
    call Quest_NotStory(q)
    // 1. Talk to Feanor (DefiledFountain's Start calls QuestFountain_Started)
    call Quest_Custom(q,"Feanor, wizard from Lothlorien, asked you to bring him Satyr's Hoof that is required for the ritual that will cleanse the Defiled Fountain of Restoration.")
    // 2. Bring him a Satyr's Hoof (DefiledFountain's Hoof calls QuestFountain_HoofDone)
    call Quest_Custom(q,"Find Thunderbloom Bulb in Barrens and bring it to Feanor.")
    // 3. Bring him the Thunderbloom Bulb (gg_trg_Quest_Fountain_Bulb)
    call Quest_Custom(q,"Find Scroll of Rejuvenation carried by evil wizard and bring it to Feanor. Evil wizards are said to reside in the Mountains region.")
    // 4. Bring him the Scroll of Rejuvenation (gg_trg_Quest_Fountain_Complete)
    call Quest_Custom(q,"")
endfunction

// Called by DefiledFountain (through ExecuteFunc) after Feanor's first talk.
function QuestFountain_Started takes nothing returns nothing
    if QUEST_FOUNTAIN==0 then
        call QuestFountain_Define()
    endif
    call Quest_Start(QUEST_FOUNTAIN,null,null)
endfunction

// Called by DefiledFountain (through ExecuteFunc) when the Satyr's Hoof was handed in.
function QuestFountain_HoofDone takes nothing returns nothing
    call Quest_StepDone(QUEST_FOUNTAIN,null,null)
endfunction

// Called by DefiledFountain (through ExecuteFunc) when the Thunderbloom Bulb is picked up for the first time.
function QuestFountain_BulbTaken takes nothing returns nothing
    call Quest_SetLog(QUEST_FOUNTAIN,"Bring the Thunderbloom Bulb to Feanor.",false)
endfunction

function Trig_Quest_Fountain_Bulb_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0FN'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0FN': item "Thunderbloom Bulb"
endfunction

function Trig_Quest_Fountain_Bulb_Cond_ExtraCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FN'))>=2) // 'I0FN': item "Thunderbloom Bulb"
endfunction

function Trig_Quest_Fountain_Bulb_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Fountain_Bulb_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_Fountain_Bulb_Cond_ExtraCharges())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FN'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FN'))-1)) // 'I0FN': item "Thunderbloom Bulb"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FN')) // 'I0FN': item "Thunderbloom Bulb"
    endif
    call DisableTrigger(gg_trg_DefiledFountain_PingBulb)
    call DestroyTrigger(gg_trg_DefiledFountain_PingBulb)
    call DisableTrigger(gg_trg_DefiledFountain_BulbPickup)
    call DestroyTrigger(gg_trg_DefiledFountain_BulbPickup)
    if(Trig_Quest_Fountain_Bulb_Cond_CinematicsEnabled())then
        call DestroyEffectBJ(udg_SpecialEffect[42])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e007_0154,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Is this what you asked for?",false)
        call Text_Say(gg_unit_e007_0154,"Yes. That's the Thunderbloom Bulb I asked you to find.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Was that the last reagent?",false)
        call Text_Say(gg_unit_e007_0154,"Actually, I need a dozen more reagents: ",false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web","Actually, I need a dozen more reagents: ",null,0,false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather","Actually, I need a dozen more reagents: Sword Spider's Web",null,0,false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather",null,0,false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life",null,0,false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey, Gerard's Ledger","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey",null,0,false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey, Gerard's Ledger, Manticore's Poison","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey, Gerard's Ledger",null,0,false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey, Gerard's Ledger, Manticore's Poison, Dwarf's Beard","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey, Gerard's Ledger, Manticore's Poison",null,0,false)
        call Text_Transmission(gg_unit_e007_0154,"Feanor","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey, Gerard's Ledger, Manticore's Poison, Dwarf's Beard.....","Actually, I need a dozen more reagents: Sword Spider's Web, Kodo Beast's Leather, Flower of Life, Mechanical Bird of Prey, Gerard's Ledger, Manticore's Poison, Dwarf's Beard",null,0,false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"W H A T ???",false)
        call Text_Say(gg_unit_e007_0154,"Just kidding.",false)
        call Text_Say(gg_unit_e007_0154,"In truth I have most of the reagents already. You didn't really think I'd make you find all of them? Other Night Elves too are worried about the Fountain too and they helped me find the reagents. They are many different herbs and plants mostly.",false)
        call Text_Say(gg_unit_e007_0154,"Now there's only one more item I need before performing the rejuvenation ritual. And I hope that you'll be able to find it because none of us Night Elves could.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"And what is it?",false)
        call Text_Say(gg_unit_e007_0154,"It's a Scroll of Rejuvenation. We've forgotten how to cast the Rejuvenation spell so now we need a scroll to cast it.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"And where can it be found?",false)
        call Text_Say(gg_unit_e007_0154,"Many evil human spellcasters may be found in the Mountains region north from Lothlorien. This is just speculation, but some of them might have it.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"OK, I'll look for evil magicians that reside in the Mountains north-west from Kalm.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[42]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e007_0154,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call Quest_StepDone(QUEST_FOUNTAIN,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call EnableTrigger(gg_trg_Quest_Fountain_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Fountain_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I02G'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I02G': item "Scroll of Rejuvenation"
endfunction

function Trig_Quest_Fountain_Complete_Cond_ExtraCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02G'))>=2) // 'I02G': item "Scroll of Rejuvenation"
endfunction

function Trig_Quest_Fountain_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Fountain_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[42])
    if(Trig_Quest_Fountain_Complete_Cond_ExtraCharges())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02G'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02G'))-1)) // 'I02G': item "Scroll of Rejuvenation"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02G')) // 'I02G': item "Scroll of Rejuvenation"
    endif
    if(Trig_Quest_Fountain_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e007_0154,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here's the Scroll of Rejuvenation you asked for. Don't you dare tell me you forgot something.",false)
        call Text_Say(gg_unit_e007_0154,"Worry not. I now have all reagents and will purify the fountain immediately.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Good luck then.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_ndfl_0144)
        call SetUnitFacingToFaceLocTimed(gg_unit_e007_0154,udg_TempPoint,.5)
        call SetUnitAnimation(gg_unit_e007_0154,"spell")
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_ndfl_0144)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ResetUnitAnimation(gg_unit_e007_0154)
        call Wait_Polled(.5)
        call ReplaceUnitBJ(gg_unit_ndfl_0144,'nfnp',bj_UNIT_STATE_METHOD_MAXIMUM) // 'nfnp': unit "Fountain of Restoration"
        call Wait_Polled(.5)
        call Text_Say(gg_unit_e007_0154,"Great! Our precious Fountain of Restoration is once again pure and undefiled.",false)
        call SetUnitFacingToFaceUnitTimed(gg_unit_e007_0154,GetTriggerUnit(),.5)
        call Text_Say(gg_unit_e007_0154,"Thank you very much. Without you we wouldn't have made it. Please accept this gold as a sign of our gratitude.",false)
        call Reward_Give($FA0,$BB8,gg_unit_e007_0154) // $FA0 = 4000; $BB8 = 3000
        call Text_Say(gg_unit_e007_0154,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(gg_unit_ndfl_0144)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ReplaceUnitBJ(gg_unit_ndfl_0144,'nfnp',bj_UNIT_STATE_METHOD_MAXIMUM) // 'nfnp': unit "Fountain of Restoration"
        call Reward_Give($FA0,$BB8,gg_unit_e007_0154) // $FA0 = 4000; $BB8 = 3000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call AddItemToStockBJ('I02C',gg_unit_n00L_0153,1,1) // 'I02C': item "Dragon Wand"
    call Quest_StepDone(QUEST_FOUNTAIN,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call AddUnitToStockBJ('n0BI',gg_unit_e012_0227,1,1) // 'n0BI': unit "Hunt: Malboro"
    set udg_HuntStock[7]=(udg_HuntStock[7]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Fountain takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_Fountain_Bulb takes nothing returns nothing
    set gg_trg_Quest_Fountain_Bulb=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Fountain_Bulb)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Fountain_Bulb,450.,gg_unit_e007_0154)
    call TriggerAddCondition(gg_trg_Quest_Fountain_Bulb,Condition(function Trig_Quest_Fountain_Bulb_Conditions))
    call TriggerAddAction(gg_trg_Quest_Fountain_Bulb,function Trig_Quest_Fountain_Bulb_Actions)
endfunction

function Register_Quest_Fountain_Complete takes nothing returns nothing
    set gg_trg_Quest_Fountain_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Fountain_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Fountain_Complete,450.,gg_unit_e007_0154)
    call TriggerAddCondition(gg_trg_Quest_Fountain_Complete,Condition(function Trig_Quest_Fountain_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_Fountain_Complete,function Trig_Quest_Fountain_Complete_Actions)
endfunction

endlibrary

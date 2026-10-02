library TQuestFountain requires TCam, TCine, TPlayerPart01, TReward, TText, TWait
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
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0FN')) minus (1).
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
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Find Scroll of Rejuvenation carried by evil wizard and bring it to Feanor. Evil wizards are said to reside in the Mountains region.")
    call QuestSetDescriptionBJ(udg_SideQuest[23],"Find Scroll of Rejuvenation carried by evil wizard and bring it to Feanor. Evil wizards are said to reside in the Mountains region.")
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
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I02G')) minus (1).
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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Defiled Fountain|r")
    call QuestSetCompletedBJ(udg_SideQuest[23],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0BI',gg_unit_e012_0227,1,1) // 'n0BI': unit "Hunt: Malboro"
    set udg_HuntStock[7]=(udg_HuntStock[7]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Fountain takes nothing returns nothing
endfunction

endlibrary

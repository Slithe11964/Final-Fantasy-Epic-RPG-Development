library TArenaIntroduction requires TCam, TCine, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_LeoIntro=null
endglobals

function Trig_Arena_LeoIntro_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h02I_0167,true,true,true))
endfunction

function Trig_Arena_LeoIntro_IsArenaCinematicAllowed takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Arena_LeoIntro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[64])
    set udg_ArenaIntroSeen=1
    if(Trig_Arena_LeoIntro_IsArenaCinematicAllowed())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h02I_0167,"Welcome, fair adventurers, to Kalm's Battle Arena!",false)
        call Text_Say(gg_unit_h02I_0167,"This Arena is located on islands far away from Kalm, but thanks to our jesters Zorn and Thorn, travelling between the town and this arena is easy.",false)
        call Text_Say(gg_unit_h02I_0167,"You can fight all sorts of monsters here, in tournaments or battle simulators.",false)
        call Text_Say(gg_unit_h02I_0167,"Talk to the Cup Organizer if you want to start a tournament. Eight teams will battle each other in a 3-round-KO-system until only one remains as the victor! The fee for entering a cup is 10 Gold.",false)
        call Text_Say(gg_unit_h02I_0167,"If you'd rather test your might in a different way, you can also do these same cups in Survival Mode format. This pits you against 7 consecutive battles with higher rewards the longer you go.",false)
        call Text_Say(gg_unit_h02I_0167,"Alternatively, you can talk to the Battle Organizers if you want to utilize our Battle Simulator to fight one specific team. Only certain teams can be fought like this, though. The fee is 20 Gold.",false)
        call Text_Say(gg_unit_h02I_0167,"During cups, make sure you don't step outside the lightning barrier! The lightning is harsh and will strike you repeatedly until you go back inside.",false)
        call Text_Say(gg_unit_h02I_0167,"If you win a cup you get a bulk of BP and you may gain access to new cups with even harder opponents.",false)
        call Text_Say(gg_unit_h02I_0167,"It's best to just try it and see how you fare. But beware: the cups may become more difficult the more you fight in them!",false)
        call Text_Say(gg_unit_h02I_0167,"You can give up a fight by telling the jester to teleport you back to town. Death is not simulated, so don't be afraid to back down if you are outclassed!",false)
        call Text_Say(gg_unit_h02I_0167,"Finally, any and all items you find here but do not need I will glady buy from you.",false)
        call Text_Say(gg_unit_h02I_0167,"And with that, I bid you good luck. Fight your way through the cups - and you shall be rewarded.",false)
        call Cine_ExitAction()
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Arena_Introduction takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2 (module Arena),
// which keeps the original registration order.

function Register_Arena_LeoIntro takes nothing returns nothing
    set gg_trg_Arena_LeoIntro=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(7),true)
    call TriggerAddCondition(gg_trg_Arena_LeoIntro,Condition(function Trig_Arena_LeoIntro_Conditions))
    call TriggerAddAction(gg_trg_Arena_LeoIntro,function Trig_Arena_LeoIntro_Actions)
endfunction

endlibrary

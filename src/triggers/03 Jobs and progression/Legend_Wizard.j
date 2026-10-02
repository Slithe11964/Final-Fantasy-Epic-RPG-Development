library TLegendWizard requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Wizard_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[$B],true,true,true)) // $B = 11
endfunction

function Trig_Legend_Wizard_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Wizard_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Wizard_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Wizard_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Wizard_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Wizard_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Wizard_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=$B // $B = 11
    if(Trig_Legend_Wizard_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Wizard_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Wizard_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[$B],"Greetings travelers. I am Rubicante, here as the Legendary Wizard.",false) // $B = 11
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings, Rubicante. Do you have any advice for apprentice wizards?",false)
            call Text_Say(udg_NpcUnit[$B],"Certainly. The Wizard is a very specialized class - your power lies entirely in your mastery of the elements. Familiarize yourself with them and where they are most effective. You can wield four elements innately, but make sure to round out your arsenal with Materia. You can use them directly from your Spirit of Gaya without having them take up a slot of gear as well.",false) // $B = 11
            call Text_Say(udg_NpcUnit[$B],"The Wizard's specialty is important as well there; your spells deal significantly more damage if you cast them while your MP is maxed out. Your Mana Spring ability allows you to cast many spells in a row with this bonus, so make good use of it, but also remember to keep your MP high with consumable items as much as possible.",false) // $B = 11
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Right, it's not only maxed out MP that matters, is it?",false)
            call Text_Say(udg_NpcUnit[$B],"Precisely. Your spells draw power from your latent energy, so if you're stuck with almost no MP, even the spells you do get off will be weak. Keep your MP high at all times and you'll do much better. A good Robe will help you recover MP simply by landing attacks as well, so make use of them.",false) // $B = 11
            call Text_Say(udg_NpcUnit[$B],"Once you have your MP economy settled, however, you are faced with two possible paths: you either choose one element and make it your own entirely, or you use all of them at once.",false) // $B = 11
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You chose the Fire element as your specialty yourself I take it.",false)
            call Text_Say(udg_NpcUnit[$B],"Indeed, and as a result my Fire spells are much stronger than anything else, but my other spells are not nearly as strong. It is up to you to choose if you want to wield everything, or simply push one element as far as it goes. Both paths are viable and better or worse depending on what you're up against.",false) // $B = 11
            call Text_Say(udg_NpcUnit[$B],"There is one very important facet to the elements however: the Technical. Each element is powered up significantly on enemies afflicted with a particular ailment. It is of utmost importance that you learn the proper Technical ailment for the element you choose to wield.",false) // $B = 11
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds right. Thanks for all the advice. I can see you earned your title well.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Wizard_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[$B],"Greetings again. You wish to receive my blessing, I presume?",false) // $B = 11
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes. How would you have us prove our worth?",false)
            call Text_Say(udg_NpcUnit[$B],"I'm sure you recall the importance of Technical bonuses through ailments. It is of utmost importance that you have them all memorized by heart, if you are to become a Legendary Master of elemental wizardry.",false) // $B = 11
            call Text_Say(udg_NpcUnit[$B],"So my task for you is very simple: while a Wizard, deal Technical damage in each of the 6 elements. Fire, Ice, Thunder, Water, Earth and Wind. Find out their respective connected ailments and make use of them.",false) // $B = 11
            call Text_Say(udg_NpcUnit[$B],"There is no time limit. You can simply check off all six of them one at a time at your own leisure.",false) // $B = 11
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So what are the ailments for each of the six elements then?",false)
            call Text_Say(udg_NpcUnit[$B],"If you do not know yet, I would have you try and figure it out on your own. But as simple examples, for Fire element it is Oil, and for Thunder element it is Cripple. But the rest is up to you to find out yourself.",false) // $B = 11
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds like a good learning exercise as well. Thanks, Rubicante.",false)
            call Text_Say(udg_NpcUnit[$B],"Good luck on your quest.",false) // $B = 11
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Wizard takes nothing returns nothing
endfunction

endlibrary

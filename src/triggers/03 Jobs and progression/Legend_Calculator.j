library TLegendCalculator requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Calculator_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[17],true,true,true))
endfunction

function Trig_Legend_Calculator_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Calculator_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Calculator_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Calculator_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Calculator_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Calculator_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Calculator_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=17
    if(Trig_Legend_Calculator_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Calculator_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Calculator_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello. You are the Legendary Calculator, correct?",false)
            call Text_Say(udg_NpcUnit[17],"Oh don't you recognize me? I'm Mid, Mid from Kalm.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"What the hell? You look absolutely nothing like Mid!",false)
            call Text_Say(udg_NpcUnit[17],"It's just makeup. It comes with the job.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Whatever you say. But what are you doing here as a mage? I thought you were training to be an engineer.",false)
            call Text_Say(udg_NpcUnit[17],"Surely you realize the name of this job. Elemental magic is nothing so esoteric. It is very scientific in fact. You learn to manipulate the world's elements to call forth desired effects. Predictable input, predictable output. You wouldn't cast a Firaga spell if you couldn't rely on what it did, would you?",false)
            call Text_Say(udg_NpcUnit[17],"Once I got over my preconceptions of magic being something full of mystique, I could simply calculate efficient use of MP to orchestrate incredibly powerful spells. And so I attained the title of Legendary Calculator. This is a great many years beyond the me you know, however.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wow, interesting. So elemental magic and engineering are not too far from one another in the end.",false)
            call Text_Say(udg_NpcUnit[17],"Exactly. And with that in mind, if you want to cast your spells effectively, use Rods, and use Ethers. Spells grow more powerful with your own latent MP, and boosting an element further is vital in making your magic truly effective. If you let your MP drop low you're only hurting yourself double.",false)
            call Text_Say(udg_NpcUnit[17],"Both Mind Charge and Imperil amplify your damage further, so make sure to use them together when you want to do truly enormous damage. Imperil of course works not just for yourself but also for any allies of yours using elemental attacks, so use it well.",false)
            call Text_Say(udg_NpcUnit[17],"And don't even try to do anything other than elemental magic with this job. It's your specialty, learn it, wield it, master it. Go all-in on it. Otherwise another job will do you better.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Calculator_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[17],"You're trying to become Legendary Calculator yourself, are you?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I am. You got a task for us?",false)
            call Text_Say(udg_NpcUnit[17],"I never thought you'd end up the one asking me for a task someday. But sure. There's an interesting fact about Imperil that you may have already noticed. It drops the enemy's resistance to all elements by one level. Absorbers become immunes, immunes become vulnerable, vulnerable become weak, but what if the enemy is already weak?",false)
            call Text_Say(udg_NpcUnit[17],"If that happens, against non-resistant enemies, the element will turn completely lethal. It is immensely satisfying.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I believe it. So is that what you want us to do? That doesn't sound hard.",false)
            call Text_Say(udg_NpcUnit[17],"That alone would be a bit too easy. I want you to cause an instant death on enemies using Imperil and hitting them with an element they're already weak to, but not merely once - do it once for every one of the six elements.",false)
            call Text_Say(udg_NpcUnit[17],"Time does not matter, merely that you do it for all six elements. If you know your enemy's weaknesses this should be no problem at all for you.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see, so you're testing our knowledge of enemy weaknesses. Alright, I'll do it.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Calculator takes nothing returns nothing
endfunction

endlibrary

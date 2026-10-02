library TAndre requires TCam, TCine, TForce, TMusic, TPlayerPart01, TText, TUnit, TWait
function Trig_Andre_Elysium_Reveal_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_H00O_0259,true,true,true))
endfunction

function Trig_Andre_Elysium_Reveal_Cond_NoUltimateMastery takes nothing returns boolean
    return(GetPlayerState(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_FOOD_USED)<=0)
endfunction

function Trig_Andre_Elysium_Reveal_ClearDest_Rct672 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Andre_Elysium_Reveal_ShowLegend_NoCine takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_Andre_Elysium_Reveal_ShowLegend_Cine takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_Andre_Elysium_Reveal_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Andre_Elysium_Reveal_ClearDest_Rct669 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Andre_Elysium_Reveal_ClearDest_Rct670 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Andre_Elysium_Reveal_ShowHiddenUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_Andre_Elysium_Reveal_Cond_NoGhostYet takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_Andre_Elysium_Reveal_Actions takes nothing returns nothing
    if(Trig_Andre_Elysium_Reveal_Cond_NoUltimateMastery())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,"You feel as though you need to be |cffffcc00Ultimate Master|r to dare speak to this being...")
        call DestroyForce(udg_TempForce)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_LegendMarker[22])
    call EnumDestructablesInRectAll(gg_rct_672,function Trig_Andre_Elysium_Reveal_ClearDest_Rct672)
    set udg_ElysiumWeather=AddWeatherEffectSaveLast(gg_rct_671,'LRaa') // 'LRaa': object name not found in map data
    if(Trig_Andre_Elysium_Reveal_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H00O_0259,"So you have made your way to this place after all.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Who are you? What is hidden in this remote place?",false)
        call Text_Say(gg_unit_H00O_0259,"This is the Elysium; a conceptual plane separated from the reality of Gaya, manifested through the Spring of Life.",false)
        set udg_TempPoint=GetRectCenter(gg_rct_675)
        call IssuePointOrderLocBJ(gg_unit_H00O_0259,"move",udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        call Cam_PanToUnit(GetTriggerUnit(),.9)
        call Wait_Polled(1.)
        call EnableWeatherEffect(udg_ElysiumWeather,true)
        call SetUnitVertexColorBJ(gg_unit_H00O_0259,'d',90.,20.,20.)
        call ForGroupBJ(udg_DarkShopGroup,function Trig_Andre_Elysium_Reveal_ShowLegend_Cine)
        call Wait_Polled(1.)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Whoa, it's beautiful.",false)
        call Text_Say(gg_unit_H00O_0259,"The Spring of Life. It's a spring capable of capturing the ideals of concepts and manifest them as spirits. Heroes of legend from all over time and space, concentrated in one space, to be able to impart their wisdom on aspiring adventurers.",false)
        call Text_Say(gg_unit_H00O_0259,"All created by none other than the Zodiac Braves of Soul and Poison themselves.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Demons created this place?",false)
        call Text_Say(gg_unit_H00O_0259,"Do not fret. This place is shut away from the outside world. On the contrary, you may find this place useful to develop your own skills and abilities even further.",false)
        call BlzSetHeroProperName(gg_unit_H00O_0259,"Andre")
        call Text_Say(gg_unit_H00O_0259,"As for myself, I am Andre, the Legendary Freelancer. Pleased to meet you, adventurers. Do speak to some of the heroes around here. You may yet find what they have to say intriguing.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, well then I will take a look around. This place definitely seems... gentle. There's no malice or corruption to be felt here.",false)
        call Text_Say(gg_unit_H00O_0259,"Yes, this is a place purified of any mere physicality. Perhaps speaking with the heroes that align with your own class of choice will help you understand this place more.",false)
        call Cine_ExitAction()
    else
        call EnableWeatherEffect(udg_ElysiumWeather,true)
        call SetUnitVertexColorBJ(gg_unit_H00O_0259,'d',90.,20.,20.)
        call BlzSetHeroProperName(gg_unit_H00O_0259,"Andre")
        call ForGroupBJ(udg_DarkShopGroup,function Trig_Andre_Elysium_Reveal_ShowLegend_NoCine)
    endif
    set udg_DarkShopsVisible=true
    set udg_QuestStage[22]=5
    call EnableTrigger(gg_trg_Elysium_MarkerTick)
    call StartTimerBJ(udg_UnitUpdateTimer,false,.5)
    call BlzSetUnitName(gg_unit_H00O_0259,StringIdentity("Legendary Freelancer"))
    call SetUnitOwner(gg_unit_H00O_0259,Player(9),false)
    set udg_TempPoint=GetRectCenter(gg_rct_675)
    call SetUnitPositionLocFacingBJ(gg_unit_H00O_0259,udg_TempPoint,90.)
    call RemoveLocation(udg_TempPoint)
    call ShowDestructableBJ(true,gg_dest_DTsb_0068)
    call EnumDestructablesInRectAll(gg_rct_669,function Trig_Andre_Elysium_Reveal_ClearDest_Rct669)
    call EnumDestructablesInRectAll(gg_rct_670,function Trig_Andre_Elysium_Reveal_ClearDest_Rct670)
    call ShowUnitShow(gg_unit_n0M2_0264)
    call ForGroupBJ(udg_SecondShrineUnits,function Trig_Andre_Elysium_Reveal_ShowHiddenUnit)
    if(Trig_Andre_Elysium_Reveal_Cond_NoGhostYet())then
        set udg_TempPoint=GetRectCenter(gg_rct_691)
        call CreateNUnitsAtLoc(1,'u01P',Player(8),udg_TempPoint,350.) // 'u01P': unit "Ghost"
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(GetLastCreatedUnit(),.0,.0,.0,80.)
    endif
    call Music_SetZoneTrack(48)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Andre_Legendary_Rules_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_H00O_0259,true,true,true))
endfunction

function Trig_Andre_Legendary_Rules_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Andre_Legendary_Rules_Cond_TimeMage_State5 takes nothing returns boolean
    return(udg_QuestStage[$E]==5) // $E = 14
endfunction

function Trig_Andre_Legendary_Rules_Cond_TimeMage_State6 takes nothing returns boolean
    return(udg_QuestStage[$E]==6) // $E = 14
endfunction

function Trig_Andre_Legendary_Rules_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_LegendMarker[22])
    if(Trig_Andre_Legendary_Rules_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H00O_0259,"Welcome once more. What do you think of this place?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It's fascinating. It feels like being in a realm of both known and unknown heroes. I never imagined something like this existed in this world.",false)
        call Text_Say(gg_unit_H00O_0259,"The history of Gaya is a tumultuous one. Piecing it together from the fragments remaining would be impossible for any normal person. But leaving that aside for the time being, there's something else that may interest you.",false)
        call Text_Say(gg_unit_H00O_0259,"As you can tell, the spirits manifested here are that of the Legendary representatives of their respective classes. And with a bit of work on your end, you may gain their blessing so that you may ascend to a level beyond Ultimate Master.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ascend beyond... are you serious?",false)
        call Text_Say(gg_unit_H00O_0259,"Indeed I am. All you need to do is prove your mastery of this class and then finally enter the Spring of Life itself for the purifying ritual. But of course, proving your mastery is no trivial matter.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'm ready for anything. How do I prove myself to this spring?",false)
        call Text_Say(gg_unit_H00O_0259,"There are four requirements you must fulfill.",false)
        call Text_Say(gg_unit_H00O_0259,"1. You must achieve the rank of Ultimate Master before anything else.",false)
        call Text_Transmission(gg_unit_H00O_0259,GetHeroProperName(gg_unit_H00O_0259),"1. You must achieve the rank of Ultimate Master before anything else.\r\n2. You must defeat a Hero enemy of Level 90 or higher all by yourself.","1. You must achieve the rank of Ultimate Master before anything else.",null,0,false)
        call Text_Transmission(gg_unit_H00O_0259,GetHeroProperName(gg_unit_H00O_0259),"1. You must achieve the rank of Ultimate Master before anything else.\r\n2. You must defeat a Hero enemy of Level 90 or higher all by yourself.\r\n3. You must clear a special task given to you by the Legendary Hero of your chosen class. Talk to them directly to obtain it.","1. You must achieve the rank of Ultimate Master before anything else.\r\n2. You must defeat a Hero enemy of Level 90 or higher all by yourself.",null,0,false)
        call Text_Transmission(gg_unit_H00O_0259,GetHeroProperName(gg_unit_H00O_0259),"1. You must achieve the rank of Ultimate Master before anything else.\r\n2. You must defeat a Hero enemy of Level 90 or higher all by yourself.\r\n3. You must clear a special task given to you by the Legendary Hero of your chosen class. Talk to them directly to obtain it.\r\n4. Finally, you must hold a Grand Crystal to be allowed to enter this hallowed spring.","1. You must achieve the rank of Ultimate Master before anything else.\r\n2. You must defeat a Hero enemy of Level 90 or higher all by yourself.\r\n3. You must clear a special task given to you by the Legendary Hero of your chosen class. Talk to them directly to obtain it.",null,0,false)
        call Text_Say(gg_unit_H00O_0259,"If you fulfill all these requirements, you will be able to ascend beyond Ultimate Mastery - to Legendary Mastery of your job class.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Phew... that's a lot. But if it's what's needed then so be it.",false)
        call Text_Say(gg_unit_H00O_0259,"I will keep track of your given tasks. I bid you good luck on your journey towards a new level of mastery.",false)
        call Cine_ExitAction()
    endif
    call UnitAddAbilityBJ('A1CH',gg_unit_H00O_0259) // 'A1CH': ability "Legendary Mastery Process"
    call UnitAddAbilityBJ('Ane2',gg_unit_H00O_0259) // 'Ane2': object name not found in map data
    set udg_QuestStage[22]=7
    if(Trig_Andre_Legendary_Rules_Cond_TimeMage_State6())then
        set udg_QuestStage[$E]=2 // $E = 14
    else
        if(Trig_Andre_Legendary_Rules_Cond_TimeMage_State5())then
            set udg_QuestStage[$E]=6 // $E = 14
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,.5)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Andre takes nothing returns nothing
endfunction

function RegisterR11_Andre_Elysium_Reveal takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Andre_Elysium_Reveal=CreateTrigger()

call DisableTrigger(gg_trg_Andre_Elysium_Reveal)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Elysium_Reveal,Player(7),true)

call TriggerAddCondition(gg_trg_Andre_Elysium_Reveal,Condition(function Trig_Andre_Elysium_Reveal_Conditions))

call TriggerAddAction(gg_trg_Andre_Elysium_Reveal,function Trig_Andre_Elysium_Reveal_Actions)

endfunction




function RegisterR11_Andre_Legendary_Rules takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Andre_Legendary_Rules=CreateTrigger()

call DisableTrigger(gg_trg_Andre_Legendary_Rules)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Andre_Legendary_Rules,Player(7),true)

call TriggerAddCondition(gg_trg_Andre_Legendary_Rules,Condition(function Trig_Andre_Legendary_Rules_Conditions))

call TriggerAddAction(gg_trg_Andre_Legendary_Rules,function Trig_Andre_Legendary_Rules_Actions)

endfunction




endlibrary

library TQuestEyeOfJenova requires TCine, TForce, TMusic, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_Quest_EyeOfJenova_PickUp_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='gmfr') // 'gmfr': item "Eye of Jenova"
endfunction

function Trig_Quest_EyeOfJenova_PickUp_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(Force_OfPlayer(GetOwningPlayer(GetManipulatingUnit())),bj_QUESTMESSAGE_UPDATED,"Bring the Eye of Jenova to Ao Madoushi.")
    call QuestSetDescriptionBJ(udg_MainQuest[5],"Bring the Eye of Jenova to Ao Madoushi.")
    call EnableTrigger(gg_trg_Quest_EyeOfJenova_Deliver)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01B',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01B': unit "Infernal Templar"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_EyeOfJenova_Deliver_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'gmfr'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'gmfr': item "Eye of Jenova"
endfunction

function Trig_Quest_EyeOfJenova_Deliver_CameraOnHandover takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_003,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_EyeOfJenova_Deliver_ShowHandoverScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_EyeOfJenova_Deliver_GiveDemiMateria takes nothing returns nothing
    call UnitAddItemByIdSwapped('I03L',Player_GetHero(GetEnumPlayer())) // 'I03L': item "Demi Materia"
endfunction

function Trig_Quest_EyeOfJenova_Deliver_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Ping_EyeOfJenova)
    call DestroyTrigger(gg_trg_Ping_EyeOfJenova)
    call DestroyEffectBJ(udg_SpecialEffect[21])
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'gmfr')) // 'gmfr': item "Eye of Jenova"
    call GroupRemoveUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
    call SetUnitPositionLoc(gg_unit_Othr_0106,udg_AoMadoushiLoc)
    call SetUnitFacingTimed(gg_unit_Othr_0106,udg_AoMadoushiFacing,0)
    if(Trig_Quest_EyeOfJenova_Deliver_ShowHandoverScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_EyeOfJenova_Deliver_CameraOnHandover)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well, we have defeated the huge undead guy and took the Eye of Jenova.",false)
        call Text_Say(gg_unit_Othr_0106,"I am glad. Give me this artifact and I will immediately start conjuring a spell that will protect us from the mind dominating powers of Hashmalum. The spell will have to be constantly maintained so I will be busy and unable to help you. You will have to contact Cid and Mid and decide what to do.",false)
        call Reward_Give($7D0,$7D0,gg_unit_Othr_0106) // $7D0 = 2000
        call Text_Say(gg_unit_Othr_0106,"|n|cffffcc00All players get a piece of Demi Materia.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give($7D0,$7D0,gg_unit_Othr_0106) // $7D0 = 2000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00All players get a piece of Demi Materia.|r")
    endif
    call ForForce(udg_PlayingPlayers,function Trig_Quest_EyeOfJenova_Deliver_GiveDemiMateria)
    call SetUnitAnimationWithRarity(gg_unit_Othr_0106,"spell",RARITY_FREQUENT)
    call EnableTrigger(gg_trg_Loop_MadoushiChanneling)
    set udg_SpecialEffect[55]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_Othr_0106,"Abilities\\Spells\\Orc\\Voodoo\\VoodooAura.mdl")
    set udg_SpecialEffect[56]=AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_Othr_0106),"Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Eye of Jenova|r")
    call QuestSetCompletedBJ(udg_MainQuest[5],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call Music_SetZoneTrack(7)
    call Wait_Polled(4.)
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Talk to Cid.")
    set udg_SpecialEffect[21]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_NightElves_Start)
    call GroupAddUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_EyeOfJenova takes nothing returns nothing
endfunction

endlibrary

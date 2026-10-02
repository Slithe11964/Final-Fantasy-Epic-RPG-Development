library TGate requires TCam, TCine, TForce, TMusic, TPlayerPart01, TText, TWait
function Trig_Gate_Codeword_Demesne_Cond_NotAtGate takes nothing returns boolean
    return(udg_InCinematicMode)or(RectContainsUnit(gg_rct_630,Player_GetHero(GetTriggerPlayer()))==false)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_ShouldAbort takes nothing returns boolean
    return(Trig_Gate_Codeword_Demesne_Cond_NotAtGate())
endfunction

function Trig_Gate_Codeword_Demesne_Enum_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),15.)
endfunction

function Trig_Gate_Codeword_Demesne_Enum_ClearCameraNoise takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_Gate_Codeword_Demesne_Cond_TalonWaiting takes nothing returns boolean
    return(udg_ZodiacQuestStage==6)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_QuestActive takes nothing returns boolean
    return(udg_ZodiacQuestStage>0)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_PendantNpcStage2 takes nothing returns boolean
    return(udg_DanaQuestStage==2)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_StageMeetAtGate takes nothing returns boolean
    return(udg_ZodiacQuestStage==6)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_StagePendantGiven takes nothing returns boolean
    return(udg_ZodiacQuestStage==5)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_StageFindLeverage takes nothing returns boolean
    return(udg_ZodiacQuestStage==4)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_StageAskTalon takes nothing returns boolean
    return(udg_ZodiacQuestStage==3)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_StageAskCeleborn takes nothing returns boolean
    return(udg_ZodiacQuestStage==2)
endfunction

function Trig_Gate_Codeword_Demesne_Cond_QuestStarted takes nothing returns boolean
    return(udg_ZodiacQuestStage>0)
endfunction

function Trig_Gate_Codeword_Demesne_Actions takes nothing returns nothing
    call Wait_Polled(.2)
    if(Trig_Gate_Codeword_Demesne_Cond_ShouldAbort())then
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Gate_Codeword_Demesne_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(Player_GetHero(GetTriggerPlayer()),0)
        call ForForce(GetPlayersAll(),function Trig_Gate_Codeword_Demesne_Enum_ShakeCamera)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,100.,0)
        set udg_TempPoint=GetDestructableLoc(gg_dest_DTg7_0013)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        set udg_TempPoint=GetDestructableLoc(gg_dest_DTg7_0013)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        call ForForce(GetPlayersAll(),function Trig_Gate_Codeword_Demesne_Enum_ClearCameraNoise)
        call Wait_Polled(1.)
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_DTg7_0013)
        call Wait_Polled(1.)
        if(Trig_Gate_Codeword_Demesne_Cond_QuestActive())then
            call DestroyEffectBJ(udg_SpecialEffect[43])
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"It's open! Hashmalum, we're coming for you!",false)
            if(Trig_Gate_Codeword_Demesne_Cond_TalonWaiting())then
                call Text_Say(gg_unit_e015_0238,"What...? You didn't... need me at all. Heh...",false)
                set udg_TempPoint=GetUnitLoc(gg_unit_e015_0238)
                call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint)
                call Wait_Polled(.5)
            endif
        endif
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetDestructableLoc(gg_dest_DTg7_0013)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_DTg7_0013)
    endif
    if(Trig_Gate_Codeword_Demesne_Cond_QuestStarted())then
        call DestroyEffectBJ(udg_SpecialEffect[43])
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Venture forth into the Icy Realm.")
        call QuestSetDescriptionBJ(udg_MainQuest[18],"Venture forth into the Icy Realm.")
        if(Trig_Gate_Codeword_Demesne_Cond_StageAskCeleborn())then
            call GroupRemoveUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
            call DisableTrigger(gg_trg_Quest_ZodiacAge_AskCeleborn)
            call DestroyTrigger(gg_trg_Quest_ZodiacAge_AskCeleborn)
        else
            if(Trig_Gate_Codeword_Demesne_Cond_StageAskTalon())then
                call GroupRemoveUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
                call DisableTrigger(gg_trg_Quest_ZodiacAge_AskTalon)
                call DestroyTrigger(gg_trg_Quest_ZodiacAge_AskTalon)
            else
                if(Trig_Gate_Codeword_Demesne_Cond_StageFindLeverage())then
                    call GroupRemoveUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
                    call DisableTrigger(gg_trg_Quest_ZodiacAge_ShowPendant)
                    call DestroyTrigger(gg_trg_Quest_ZodiacAge_ShowPendant)
                    if(Trig_Gate_Codeword_Demesne_Cond_PendantNpcStage2())then
                        call DestroyEffectBJ(udg_SpecialEffect[70])
                        call GroupRemoveUnitSimple(gg_unit_n0BN_0171,udg_QuestUnits)
                        call DisableTrigger(gg_trg_Quest_ZodiacAge_GetPendant)
                        call DestroyTrigger(gg_trg_Quest_ZodiacAge_GetPendant)
                        set udg_DanaQuestStage=1
                    endif
                else
                    if(Trig_Gate_Codeword_Demesne_Cond_StagePendantGiven())then
                        call GroupRemoveUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
                        call DisableTrigger(gg_trg_Quest_ZodiacAge_ShowPendant)
                        call DestroyTrigger(gg_trg_Quest_ZodiacAge_ShowPendant)
                    else
                        if(Trig_Gate_Codeword_Demesne_Cond_StageMeetAtGate())then
                            call GroupRemoveUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
                            call DisableTrigger(gg_trg_Quest_ZodiacAge_TalonOpensGate)
                            call DestroyTrigger(gg_trg_Quest_ZodiacAge_TalonOpensGate)
                            call RemoveUnit(gg_unit_e015_0238)
                        endif
                    endif
                endif
            endif
        endif
    endif
    set udg_TalonGone=true
    call ConditionalTriggerExecute(gg_trg_IcyRealm_GateOpened_Setup)
    call Music_SetZoneTrack($E) // $E = 14
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Gate_WinterKey_Unlock_Cond_HasKeyOrNotSpirit takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0IM'))or(GetUnitTypeId(GetTriggerUnit())!='H01D') // 'I0IM': item "Winter Key"; 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Gate_WinterKey_Unlock_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false)and(Trig_Gate_WinterKey_Unlock_Cond_HasKeyOrNotSpirit()))!=null
endfunction

function Trig_Gate_WinterKey_Unlock_Cond_QuestActive takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[18]))and(udg_HashmalumEncountered==false)
endfunction

function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_A takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_B takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_C takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_D takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_E takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0IM')) // 'I0IM': item "Winter Key"
endfunction

function Trig_Gate_WinterKey_Unlock_Actions takes nothing returns nothing
    if(Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey())then
        call DisableTrigger(GetTriggeringTrigger())
        call Music_SetTrack(19)
        set udg_ShadowForcedSpawn=46
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0IM')) // 'I0IM': item "Winter Key"
        call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" used the Winter Key to unlock the south gate to the Icy Realm."))
        if(Trig_Gate_WinterKey_Unlock_Cond_QuestActive())then
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Confront Hashmalum.")
            call QuestSetDescriptionBJ(udg_MainQuest[18],"Confront Hashmalum.")
        endif
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_LTg2_0021)
        call EnumDestructablesInRectAll(gg_rct_494,function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_A)
        call EnumDestructablesInRectAll(gg_rct_495,function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_B)
        call EnumDestructablesInRectAll(gg_rct_666,function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_C)
        call EnumDestructablesInRectAll(gg_rct_667,function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_D)
        call EnumDestructablesInRectAll(gg_rct_668,function Trig_Gate_WinterKey_Unlock_Enum_ClearRubble_E)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"The gate is firmly sealed and will not budge to attacks or magic. You notice a large key hole in the door.")
        call DestroyForce(udg_TempForce)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Gate takes nothing returns nothing
endfunction

function RegisterR11_Gate_Codeword_Demesne takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gate_Codeword_Demesne=CreateTrigger()

call DisableTrigger(gg_trg_Gate_Codeword_Demesne)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(0),"Demesne",false)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(1),"Demesne",false)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(2),"Demesne",false)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(3),"Demesne",false)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(4),"Demesne",false)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(5),"Demesne",false)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(6),"Demesne",false)

call TriggerRegisterPlayerChatEvent(gg_trg_Gate_Codeword_Demesne,Player(7),"Demesne",false)

call TriggerAddAction(gg_trg_Gate_Codeword_Demesne,function Trig_Gate_Codeword_Demesne_Actions)

endfunction




function RegisterR11_Gate_WinterKey_Unlock takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gate_WinterKey_Unlock=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Gate_WinterKey_Unlock,gg_rct_631)

call TriggerAddCondition(gg_trg_Gate_WinterKey_Unlock,Condition(function Trig_Gate_WinterKey_Unlock_Conditions))

call TriggerAddAction(gg_trg_Gate_WinterKey_Unlock,function Trig_Gate_WinterKey_Unlock_Actions)

endfunction




endlibrary

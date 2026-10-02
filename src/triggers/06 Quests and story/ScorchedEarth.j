library TScorchedEarth requires TCam, TCine, TForce, TPlayerPart01, TText, TWait
function Trig_ScorchedEarth_Omen_Cond_IcyRealmUnbeaten takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[19])==false)
endfunction

function Trig_ScorchedEarth_Omen_Cond_SceneBusy takes nothing returns boolean
    return(udg_InCinematicMode)or(udg_SceneBusy)
endfunction

function Trig_ScorchedEarth_Omen_Cond_ShouldWait takes nothing returns boolean
    return(Trig_ScorchedEarth_Omen_Cond_SceneBusy())
endfunction

function Trig_ScorchedEarth_Omen_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),15.)
endfunction

function Trig_ScorchedEarth_Omen_ClearCameraShake takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_ScorchedEarth_Omen_Actions takes nothing returns nothing
    if(Trig_ScorchedEarth_Omen_Cond_IcyRealmUnbeaten())then
        call StartTimerBJ(udg_ScorchedEarthTimer,false,120.)
        return
    endif
    if(Trig_ScorchedEarth_Omen_Cond_ShouldWait())then
        call StartTimerBJ(udg_ScorchedEarthTimer,false,10.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call Cine_Enter()
    call PlaySoundBJ(gg_snd_SargerasLaugh)
    call ForForce(GetPlayersAll(),function Trig_ScorchedEarth_Omen_ShakeCamera)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,0,0)
    call Wait_Polled(2)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,0,0)
    call Wait_Polled(2)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,0,0)
    call Wait_Polled(2)
    call ForForce(GetPlayersAll(),function Trig_ScorchedEarth_Omen_ClearCameraShake)
    call ConditionalTriggerExecute(gg_trg_Quest_52_Scorching)
    set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
    call Text_Say(Player_GetHero(udg_TempPlayer),"What the hell was that sensation...!? It feels like it came from the northeast. Maybe I should go check on the Icy Realm.",true)
    call Cine_ExitAction()
    set udg_TempPoint=GetRectCenter(gg_rct_646)
    set gg_dest_Dofv_0001=CreateDestructableLoc('Dofv',udg_TempPoint,.0,1,0) // 'Dofv': object name not found in map data
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_ScorchedEarth_EnterRegion)
    call EnableTrigger(gg_trg_ScorchedEarth_TowerAttack)
    call GroupAddUnitSimple(gg_unit_U00Q_0023,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ScorchedEarth_EnterRegion_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false)
endfunction

function Trig_ScorchedEarth_EnterRegion_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetTriggerUnit()))
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call ConditionalTriggerExecute(gg_trg_Quest_ScorchedEarth_Start)
endfunction

function Trig_ScorchedEarth_TowerAttack_Cond_AttackerIsInfernal takes nothing returns boolean
    return(GetUnitTypeId(GetAttacker())=='u009')or(GetUnitUserData(GetAttacker())==8) // 'u009': unit "Infernal Tower"
endfunction

function Trig_ScorchedEarth_TowerAttack_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(Trig_ScorchedEarth_TowerAttack_Cond_AttackerIsInfernal())and(udg_InCinematicMode==false)
endfunction

function Trig_ScorchedEarth_TowerAttack_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetTriggerUnit()))
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call ConditionalTriggerExecute(gg_trg_Quest_ScorchedEarth_Start)
endfunction

function Trig_ScorchedEarth_HeatFade_Cond_AttackerIsInfernal takes nothing returns boolean
    return(GetUnitTypeId(GetAttacker())=='u009')or(GetUnitUserData(GetAttacker())==8) // 'u009': unit "Infernal Tower"
endfunction

function Trig_ScorchedEarth_HeatFade_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(Trig_ScorchedEarth_HeatFade_Cond_AttackerIsInfernal())and(udg_InCinematicMode==false)
endfunction

function Trig_ScorchedEarth_HeatFade_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,4.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,0,50.)
    call Wait_Polled(30.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_ScorchedEarth_Barrier_Cond_CanEnterTop takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0BY'))or(GetUnitTypeId(GetTriggerUnit())!='H01D') // 'I0BY': item "Hell Gate's Flame"; 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_ScorchedEarth_Barrier_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false)and(Trig_ScorchedEarth_Barrier_Cond_CanEnterTop()))!=null
endfunction

function Trig_ScorchedEarth_Barrier_Cond_FlameHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0BY'))>=2) // 'I0BY': item "Hell Gate's Flame"
endfunction

function Trig_ScorchedEarth_Barrier_Cond_HasHellFlame takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0BY')) // 'I0BY': item "Hell Gate's Flame"
endfunction

function Trig_ScorchedEarth_Barrier_Actions takes nothing returns nothing
    if(Trig_ScorchedEarth_Barrier_Cond_HasHellFlame())then
        call DisableTrigger(GetTriggeringTrigger())
        if(Trig_ScorchedEarth_Barrier_Cond_FlameHasCharges())then
            // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0BY')) minus (1).
            call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0BY'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0BY'))-1)) // 'I0BY': item "Hell Gate's Flame"
        else
            call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0BY')) // 'I0BY': item "Hell Gate's Flame"
        endif
        call KillDestructable(gg_dest_Dofv_0001)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" used a Hell Gate's Flame to erase the barrier to the top of the Infernal Mountain."))
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Approach the mountain's top.")
        call QuestSetDescriptionBJ(udg_SideQuest[52],"Approach the Infernal Mountain's top to confront the entity who caused this inferno.")
        call EnableTrigger(gg_trg_McBurn_TrueForm_Reveal)
        call AddUnitToStockBJ('n0NF',gg_unit_nsw2_0056,1,1) // 'n0NF': unit "Hunt: Okuu"
        set udg_HuntStock[$A]=(udg_HuntStock[$A]+1) // $A = 10
        call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"It seems you need a |cffffcc00Hell Gate's Flame|r to remove this barrier.")
        call DestroyForce(udg_TempForce)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_ScorchedEarth takes nothing returns nothing
endfunction
function RegisterR11_ScorchedEarth_Omen takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ScorchedEarth_Omen=CreateTrigger()
    call DisableTrigger(gg_trg_ScorchedEarth_Omen)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_ScorchedEarth_Omen,udg_ScorchedEarthTimer)
    call TriggerAddAction(gg_trg_ScorchedEarth_Omen,function Trig_ScorchedEarth_Omen_Actions)
endfunction
function RegisterR11_ScorchedEarth_EnterRegion takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ScorchedEarth_EnterRegion=CreateTrigger()
    call DisableTrigger(gg_trg_ScorchedEarth_EnterRegion)
    call TriggerRegisterEnterRectSimple(gg_trg_ScorchedEarth_EnterRegion,gg_rct_592)
    call TriggerRegisterEnterRectSimple(gg_trg_ScorchedEarth_EnterRegion,gg_rct_593)
    call TriggerRegisterEnterRectSimple(gg_trg_ScorchedEarth_EnterRegion,gg_rct_594)
    call TriggerRegisterEnterRectSimple(gg_trg_ScorchedEarth_EnterRegion,gg_rct_595)
    call TriggerRegisterEnterRectSimple(gg_trg_ScorchedEarth_EnterRegion,gg_rct_596)
    call TriggerRegisterEnterRectSimple(gg_trg_ScorchedEarth_EnterRegion,gg_rct_597)
    call TriggerAddCondition(gg_trg_ScorchedEarth_EnterRegion,Condition(function Trig_ScorchedEarth_EnterRegion_Conditions))
    call TriggerAddAction(gg_trg_ScorchedEarth_EnterRegion,function Trig_ScorchedEarth_EnterRegion_Actions)
endfunction
function RegisterR11_ScorchedEarth_TowerAttack takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ScorchedEarth_TowerAttack=CreateTrigger()
    call DisableTrigger(gg_trg_ScorchedEarth_TowerAttack)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ScorchedEarth_TowerAttack,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_ScorchedEarth_TowerAttack,Condition(function Trig_ScorchedEarth_TowerAttack_Conditions))
    call TriggerAddAction(gg_trg_ScorchedEarth_TowerAttack,function Trig_ScorchedEarth_TowerAttack_Actions)
endfunction
function RegisterR11_ScorchedEarth_HeatFade takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ScorchedEarth_HeatFade=CreateTrigger()
    call DisableTrigger(gg_trg_ScorchedEarth_HeatFade)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ScorchedEarth_HeatFade,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_ScorchedEarth_HeatFade,Condition(function Trig_ScorchedEarth_HeatFade_Conditions))
    call TriggerAddAction(gg_trg_ScorchedEarth_HeatFade,function Trig_ScorchedEarth_HeatFade_Actions)
endfunction
function RegisterR11_ScorchedEarth_Barrier takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ScorchedEarth_Barrier=CreateTrigger()
    call DisableTrigger(gg_trg_ScorchedEarth_Barrier)
    call TriggerRegisterEnterRectSimple(gg_trg_ScorchedEarth_Barrier,gg_rct_646)
    call TriggerAddCondition(gg_trg_ScorchedEarth_Barrier,Condition(function Trig_ScorchedEarth_Barrier_Conditions))
    call TriggerAddAction(gg_trg_ScorchedEarth_Barrier,function Trig_ScorchedEarth_Barrier_Actions)
endfunction




endlibrary

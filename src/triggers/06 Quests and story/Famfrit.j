library TFamfrit requires TAbil, TCam, TCine, TLoc, TMusic, TPlayerPart01, TProf, TText, TWait
function Trig_Famfrit_Prepare_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00N_0205)
    call PauseUnitBJ(true,gg_unit_U00N_0205)
    call SetUnitInvulnerable(gg_unit_U00N_0205,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Famfrit_Encounter_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Famfrit_Encounter_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Famfrit_Encounter_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Famfrit_Encounter_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So he really came, the Zodiac Brave of Water, Famfrit.",false)
        call Cam_PanToUnit(gg_unit_U00N_0205,.2)
        call SetUnitFacingToFaceUnitTimed(gg_unit_U00N_0205,GetTriggerUnit(),.0)
        call Text_Say(gg_unit_U00N_0205,"Human. What in Gaya's name have you done!?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We've lured you out in the open, Zodiac Brave of Water, Famfrit!",false)
        call Text_Say(gg_unit_U00N_0205,"Monsters. There was nary a being in the world that did not respect Lady Dana. Her rule of Lothlorien is what made the Night Elf race flourish, and even after being cast out, she has worked tirelessly to keep this world safe.",false)
        call Text_Say(gg_unit_U00N_0205,"In the name of the entire world. I will destroy you for what you did, humans.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Now, here he comes! Do not let Dana's sacrifice be in vain!",false)
        call Cine_ExitAction()
    endif
    call SetUnitInvulnerable(gg_unit_U00N_0205,false)
    call Music_SetTrack($D) // $D = 13
    call EnableTrigger(gg_trg_Boss_Famfrit_Death)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat Famfrit, the Zodiac Brave of Water.")
    call QuestSetDescriptionBJ(udg_MainQuest[$F],"Defeat Famfrit, the Zodiac Brave of Water.") // $F = 15
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Famfrit_TidalWave_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZX') // 'A0ZX': ability "!Tidal Wave"
endfunction

function Trig_Famfrit_TidalWave_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Famfrit_TidalWave_Actions takes nothing returns nothing
    local group l_hitGroup=CreateGroup()
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (15).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*$F) // $F = 15
    if(Trig_Famfrit_TidalWave_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (3)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*3))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
    // (facing in degrees of the triggering unit) plus (180).
    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,80.,(GetUnitFacing(GetTriggerUnit())+180.))
    call RemoveLocation(udg_TempPoint2)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Calculation 1:
        // (150) times ((loop counter A) minus (3) treated as a decimal-capable number).
        // Calculation 2:
        // (facing in degrees of the triggering unit) plus (90).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,(150.*I2R((GetForLoopIndexA()-3))),(GetUnitFacing(GetTriggerUnit())+90.))
        call CreateNUnitsAtLoc(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetUnitFacing(GetTriggerUnit())) // 'h01B': unit "Proxy Dummy"
        set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
        call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
        // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
        call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
        call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
        call SaveGroupHandleBJ(l_hitGroup,6,udg_TempHandleId,udg_ProxyDamageHash)
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A0M4',GetLastCreatedUnit()) // 'A0M4': ability "Water-elemental Damage"
        call UnitAddAbilityBJ('A0PZ',GetLastCreatedUnit()) // 'A0PZ': ability "Water"
        set udg_RetreatPoint=Loc_PolarOffset(udg_TempPoint2,100.,GetUnitFacing(GetTriggerUnit()))
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"carrionswarm",udg_RetreatPoint)
        call RemoveLocation(udg_RetreatPoint)
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2)
    call DestroyGroup(l_hitGroup)
endfunction

// World Editor calls InitTrig_Famfrit automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Famfrit (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Famfrit takes nothing returns nothing
endfunction

function Register_Famfrit_Prepare takes nothing returns nothing
    set gg_trg_Famfrit_Prepare=CreateTrigger()
    call TriggerAddAction(gg_trg_Famfrit_Prepare,function Trig_Famfrit_Prepare_Actions)
endfunction

function Register_Famfrit_Encounter takes nothing returns nothing
    set gg_trg_Famfrit_Encounter=CreateTrigger()
    call DisableTrigger(gg_trg_Famfrit_Encounter)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Famfrit_Encounter,700.,gg_unit_U00N_0205)
    call TriggerAddCondition(gg_trg_Famfrit_Encounter,Condition(function Trig_Famfrit_Encounter_Conditions))
    call TriggerAddAction(gg_trg_Famfrit_Encounter,function Trig_Famfrit_Encounter_Actions)
endfunction

function Register_Famfrit_TidalWave takes nothing returns nothing
    set gg_trg_Famfrit_TidalWave=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Famfrit_TidalWave,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Famfrit_TidalWave,Condition(function Trig_Famfrit_TidalWave_Conditions))
    call TriggerAddAction(gg_trg_Famfrit_TidalWave,function Trig_Famfrit_TidalWave_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Famfrit takes nothing returns nothing
    call Register_Famfrit_Prepare()
    call Register_Famfrit_Encounter()
    call Register_Famfrit_TidalWave()
endfunction

endlibrary

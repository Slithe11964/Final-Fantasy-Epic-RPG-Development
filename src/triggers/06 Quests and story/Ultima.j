library TUltima requires TAbil, TCam, TCine, TGroup, TLoc, TMusic, TPlayerHero, TProf, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ultima_Cast=null
    trigger gg_trg_Ultima_Prepare=null
    trigger gg_trg_Ultima_Possession=null
    trigger gg_trg_Ultima_Holyja=null
endglobals

function Trig_Ultima_Cast_IsUltima takes nothing returns boolean
    return(GetSpellAbilityId()=='A0UG')or(GetSpellAbilityId()=='A0V1') // 'A0UG': ability "!Ultima"; 'A0V1': ability "!Ultima"
endfunction

function Trig_Ultima_Cast_Conditions takes nothing returns boolean
    return(Trig_Ultima_Cast_IsUltima())
endfunction

function Trig_Ultima_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Ultima_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Ultima_Cast_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local real l_tempReal
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,3.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",0,100.,0,50.)
    if(Trig_Ultima_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ $A) // $A = 10
    if(Trig_Ultima_Cast_IsHero())then
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 2))
    else
        set l_tempInteger=(l_tempInteger+(GetUnitLevel(GetTriggerUnit())*3))
    endif
    set l_tempReal=Prof_InnerManaPower(GetTriggerUnit())
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(20.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0FD',GetLastCreatedUnit()) // 'A0FD': ability "Ultima"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Ultima_Prepare_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00F_0221)
    call PauseUnitBJ(true,gg_unit_U00F_0221)
    call SetUnitInvulnerable(gg_unit_U00F_0221,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Ultima_Possession_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_AlmaUnit,true,true,false))
endfunction

function Trig_Ultima_Possession_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Ultima_Possession_Actions takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[50])
    if(Trig_Ultima_Possession_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alma!",false)
        call SetUnitFacingToFaceUnitTimed(Player_GetHero(GetTriggerPlayer()),udg_AlmaUnit,.5)
        call Text_Say(udg_AlmaUnit,". . . . .",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alma...? What's wrong?",false)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.5,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,80.,0,0)
        call SetUnitColor(udg_AlmaUnit,PLAYER_COLOR_YELLOW)
        call AddSpecialEffectTargetUnitBJ("origin",udg_AlmaUnit,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(1.)
        set udg_TempPoint=GetRectCenter(gg_rct_640)
        set udg_TempPoint2=GetUnitLoc(gg_unit_U00F_0221)
        call SetUnitPositionLocFacingLocBJ(gg_unit_Eill_0119,udg_TempPoint,udg_TempPoint2)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_Eill_0119)
        call Text_Say(gg_unit_Eill_0119,"No! Stay away from her!",false)
        call Text_Say(udg_AlmaUnit,"Brother...?",false)
        call Text_Say(gg_unit_Eill_0119,"Alma!",false)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.5,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,80.,0,0)
        call ShowUnitHide(udg_AlmaUnit)
        call ShowUnitShow(gg_unit_U00F_0221)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00F_0221,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00F_0221,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("chest",gg_unit_U00F_0221,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(.5)
        call SetUnitFacingToFaceUnitTimed(gg_unit_U00F_0221,gg_unit_Eill_0119,.5)
        call Wait_Polled(.5)
        call Text_Transmission(gg_unit_U00F_0221,"Alma?","Finally... a new host body.","(null)",null,0,false)
        call Text_Say(gg_unit_Eill_0119,"No...! You didn't-",false)
        call Wait_Polled(.3)
        call SetUnitAnimation(gg_unit_U00F_0221,"spell")
        call QueueUnitAnimationBJ(gg_unit_U00F_0221,"stand")
        call Wait_Polled(.2)
        set udg_TempPoint=GetUnitLoc(gg_unit_Eill_0119)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$F // $F = 15
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,96.,(I2R(GetForLoopIndexA())*24.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call SetUnitAnimation(gg_unit_Eill_0119,"death")
        call SetUnitFacingToFaceUnitTimed(Player_GetHero(GetTriggerPlayer()),gg_unit_Eill_0119,.5)
        call Text_Say(gg_unit_Eill_0119,"Argh!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ramza! No!",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_Eill_0119)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.75)
        set udg_TempPoint=GetUnitLoc(gg_unit_Eill_0119)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.75)
        set udg_TempPoint=GetUnitLoc(gg_unit_Eill_0119)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2.)
        set udg_TempPoint=GetUnitLoc(gg_unit_Eill_0119)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveUnit(gg_unit_Eill_0119)
        call Wait_Polled(1.)
        call Text_Transmission(gg_unit_U00F_0221,"Alma?","Foolish humans... rising up against the Zodiac Braves that govern this land. Such hubris and disrespect. Have you no shame?","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're not Alma. Who the hell are you, demon!?",false)
        call SetUnitFacingToFaceUnitTimed(Player_GetHero(GetTriggerPlayer()),gg_unit_U00F_0221,.5)
        call Text_Say(gg_unit_U00F_0221,"You are outsiders, are you not? My name is Ultima, the final executioner. I am the Zodiac Brave of Holy. I bring down the light of judgment upon those who shall be struck down.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"The executioner? Why have you taken over Alma's body!?",false)
        call Text_Say(gg_unit_U00F_0221,"I do not have a physical body of my own. My power manifests through possessing the bodies of others. That holy knight was filled with anger and grief, so she could not use my full power. But this is an exceptional host... this girl has such a pure heart and sense of justice.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Enough. You killed Ramza. You will give Alma her body back.",false)
        call Text_Say(gg_unit_U00F_0221,"That I cannot do. I may usually lay low until I am called for, but now I must take up arms for my fellow Braves myself.",false)
        call Text_Say(gg_unit_U00F_0221,"You were able to strike down that knight. You are certainly powerful. I cannot have you enact your own twisted justice against us.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_U00F_0221)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$F // $F = 15
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,96.,(I2R(GetForLoopIndexA())*24.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(gg_unit_U00F_0221)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$F // $F = 15
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,96.,(I2R(GetForLoopIndexA())*24.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call Text_Say(gg_unit_U00F_0221,"By the holy light I vow that I will be the last opponent you will ever face!",false)
        call Cine_ExitAction()
    else
        call RemoveUnit(gg_unit_Eill_0119)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.5,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,80.,0,0)
        call ShowUnitHide(udg_AlmaUnit)
        call ShowUnitShow(gg_unit_U00F_0221)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00F_0221,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00F_0221,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("chest",gg_unit_U00F_0221,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint=GetUnitLoc(gg_unit_U00F_0221)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$F // $F = 15
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,96.,(I2R(GetForLoopIndexA())*24.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
    endif
    call GroupAddUnitSimple(gg_unit_U00F_0221,udg_BossUnits)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat Ultima, the Zodiac Brave of Holy.")
    call QuestSetDescriptionBJ(udg_MainQuest[16],"Defeat Ultima, the Zodiac Brave of Holy, to avenge Ramza, and to get Alma her body back!")
    call PauseUnitBJ(false,gg_unit_U00F_0221)
    call SetUnitInvulnerable(gg_unit_U00F_0221,false)
    call Music_SetTrack($D) // $D = 13
    call EnableTrigger(gg_trg_Boss_Ultima_Death)
endfunction

function Trig_Ultima_Holyja_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0YN') // 'A0YN': ability "!Holyja"
endfunction

function Trig_Ultima_Holyja_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Ultima_Holyja_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Ultima_Holyja_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Ultima_Holyja_FilterAlive(),Trig_Ultima_Holyja_FilterEnemy())
endfunction

function Trig_Ultima_Holyja_FilterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Ultima_Holyja_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Ultima_Holyja_FilterAliveEnemy(),Trig_Ultima_Holyja_FilterVulnerable())
endfunction

function Trig_Ultima_Holyja_NoBerserkBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B05T')==false) // 'B05T': buff tooltip "Zombie"
endfunction

function Trig_Ultima_Holyja_TargetAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetEnumUnit()))
endfunction

function Trig_Ultima_Holyja_DamageTarget takes nothing returns nothing
    local real l_tempReal
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempReal=(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEnumUnit())*.3)
    set udg_DmgFlagPure=true
    set udg_IgnoresReduction=true
    set udg_DmgFlagUnavoidable=-1
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),l_tempReal,true,true,ATTACK_TYPE_HERO,DAMAGE_TYPE_UNIVERSAL,null)
    if(Trig_Ultima_Holyja_TargetAlive())then
        if(Trig_Ultima_Holyja_NoBerserkBuff())then
            set udg_TempPoint=GetUnitLoc(GetEnumUnit())
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call RemoveLocation(udg_TempPoint)
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A0Y5',GetLastCreatedUnit()) // 'A0Y5': ability "Zombie"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"faeriefire",GetEnumUnit())
        endif
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A11Y',GetLastCreatedUnit()) // 'A11Y': ability "Regen"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"rejuvination",GetEnumUnit())
        call SaveRealBJ(500.,1,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)
        call GroupAddUnitSimple(GetEnumUnit(),udg_RegenGroup)
    endif
endfunction

function Trig_Ultima_Holyja_Actions takes nothing returns nothing
    local group l_tempGroup
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,300.,(I2R(GetForLoopIndexA())*30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,600.,((I2R(GetForLoopIndexA())*30.)-15.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set l_tempGroup=Group_UnitsInRangeOfLoc(728.,udg_TempPoint,Condition(function Trig_Ultima_Holyja_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(l_tempGroup,function Trig_Ultima_Holyja_DamageTarget)
    call DestroyGroup(l_tempGroup)
    set l_tempGroup=null
endfunction

// World Editor calls InitTrig_Ultima automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ultima_Part1 / RegisterTriggers_Ultima_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ultima takes nothing returns nothing
endfunction

function Register_Ultima_Cast takes nothing returns nothing
    set gg_trg_Ultima_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ultima_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ultima_Cast,Condition(function Trig_Ultima_Cast_Conditions))
    call TriggerAddAction(gg_trg_Ultima_Cast,function Trig_Ultima_Cast_Actions)
endfunction

function Register_Ultima_Prepare takes nothing returns nothing
    set gg_trg_Ultima_Prepare=CreateTrigger()
    call TriggerAddAction(gg_trg_Ultima_Prepare,function Trig_Ultima_Prepare_Actions)
endfunction

function Register_Ultima_Possession takes nothing returns nothing
    set gg_trg_Ultima_Possession=CreateTrigger()
    call DisableTrigger(gg_trg_Ultima_Possession)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ultima_Possession,Player(7),true)
    call TriggerAddCondition(gg_trg_Ultima_Possession,Condition(function Trig_Ultima_Possession_Conditions))
    call TriggerAddAction(gg_trg_Ultima_Possession,function Trig_Ultima_Possession_Actions)
endfunction

function Register_Ultima_Holyja takes nothing returns nothing
    set gg_trg_Ultima_Holyja=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ultima_Holyja,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ultima_Holyja,Condition(function Trig_Ultima_Holyja_Conditions))
    call TriggerAddAction(gg_trg_Ultima_Holyja,function Trig_Ultima_Holyja_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Ultima_Part1 takes nothing returns nothing
    call Register_Ultima_Cast()
    call Register_Ultima_Prepare() // run by MapBootstrap
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Ultima_Part2 takes nothing returns nothing
    call Register_Ultima_Possession() // starts off; enabled by Quest_LightOfJudgment
    call Register_Ultima_Holyja()
endfunction

endlibrary

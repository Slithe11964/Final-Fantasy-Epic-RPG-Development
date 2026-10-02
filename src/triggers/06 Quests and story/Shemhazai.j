library TShemhazai requires TCam, TCine, TGroup, TLoc, TMusic, TPlayerPart01, TText, TWait
function Trig_Shemhazai_Prepare_FreezeBaseUnit takes nothing returns nothing
    call PauseUnitBJ(true,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),true)
    call UnitAddAbilityBJ('A0VJ',GetEnumUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Trig_Shemhazai_Prepare_MakeDestInvulnerable takes nothing returns nothing
    call SetDestructableInvulnerableBJ(GetEnumDestructable(),true)
endfunction

function Trig_Shemhazai_Prepare_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00I_0210)
    call PauseUnitBJ(true,gg_unit_U00I_0210)
    call SetUnitInvulnerable(gg_unit_U00I_0210,true)
    call ShowUnitHide(gg_unit_U019_0253)
    call PauseUnitBJ(true,gg_unit_U019_0253)
    call SetUnitInvulnerable(gg_unit_U019_0253,true)
    call UnitAddAbilityBJ('ACrk',gg_unit_ncpn_0025) // 'ACrk': object name not found in map data
    set udg_ShemhazaiPhase=0
    call GroupAddUnitSimple(gg_unit_Opgh_0169,udg_RecruitedAllies)
    set udg_RedBeastGroup=Group_UnitsInRectOfPlayer(gg_rct_637,Player($B)) // $B = 11
    call GroupRemoveUnitSimple(gg_unit_nbfl_0170,udg_RedBeastGroup)
    call ForGroupBJ(udg_RedBeastGroup,function Trig_Shemhazai_Prepare_FreezeBaseUnit)
    call EnumDestructablesInRectAll(gg_rct_642,function Trig_Shemhazai_Prepare_MakeDestInvulnerable)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Shemhazai_Appears_Quest20NotFound_Clones takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Shemhazai_Appears_Quest20NotFound_Reveal takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Shemhazai_Appears_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Shemhazai_Appears_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Shemhazai_Appears_SetupSoulClone takes nothing returns nothing
    call SetUnitLifePercentBJ(GetEnumUnit(),'d')
    call BlzSetHeroProperName(GetEnumUnit(),("Soul "+GetHeroProperName(GetEnumUnit())))
    call UnitRemoveAbilityBJ('AInv',GetEnumUnit()) // 'AInv': standard ability reference "Inventory"
    call UnitAddAbilityBJ('S00I',GetEnumUnit()) // 'S00I': ability "Soul Migration"
    call PauseUnitBJ(false,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

function Trig_Shemhazai_Appears_Quest20NotFound_Fight takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Shemhazai_Appears_Quest20Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_Shemhazai_Appears_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_nbfl_0170,udg_BossUnits)
    if(Trig_Shemhazai_Appears_Quest20Discovered())then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Corrupted Orcs|r")
        call QuestSetCompletedBJ(udg_MainQuest[$D],true) // $D = 13
        set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    else
        set udg_ShemhazaiPhase=1
        call Music_SetTrack(31)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call SetUnitPositionLocFacingBJ(gg_unit_U00I_0210,udg_TempPoint,bj_UNIT_FACING)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call UnitAddAbilityBJ('Abun',gg_unit_U00I_0210) // 'Abun': object name not found in map data
        if(Trig_Shemhazai_Appears_CinematicsEnabled())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            if(Trig_Shemhazai_Appears_KillerIsPlayer())then
                set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
            else
                set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
            endif
            call Wait_Polled(1.)
            set udg_TempPoint=GetUnitLoc(gg_unit_U00I_0210)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            call ShowUnitShow(gg_unit_U00I_0210)
            call Wait_Polled(1.)
            call Text_Say(udg_CinematicActor,"Demon! What have you done to these orcs!?",false)
            call Text_Say(gg_unit_U00I_0210,"Hee hee, welcome to this remote island. My name is Shemhazai, and I am known as the Zodiac Brave of Soul.",false)
            call Text_Say(udg_CinematicActor,"Zodiac Brave of Soul... so you turned all these orcs twisted, didn't you. How dare you.",false)
            call Text_Say(gg_unit_U00I_0210,"Now aren't you a rude one. All I did was unleash their potential and release them from their mental barricades. How demonic of me! While you on the other hand slaughtered them all without a second thought.",false)
            call Text_Say(udg_CinematicActor,"You demon... you turned these orcs into mindless slaves and then you speak like that!?",false)
            call Text_Say(gg_unit_U00I_0210,"Hahaha, what a delightful fellow you are. Such an admirable hero.",false)
            call Text_Say(gg_unit_U00I_0210,"And who better to strike down a hero than their own reflection?",false)
            call ConditionalTriggerExecute(gg_trg_Shemhazai_Spawn_SoulClones)
            call Wait_Polled(2)
            call Text_Say(udg_CinematicActor,"What the!?",false)
            call Text_Say(gg_unit_U00I_0210,"I am a shadow, the true self ... never heard that one before?",false)
            call Text_Say(udg_CinematicActor,"Shemhazai, the Zodiac Brave of Soul... so your power comes in cloning the souls of others. But we won't be deceived, these are again nothing more than your mindless puppets.",false)
            call Text_Say(gg_unit_U00I_0210,"I'm flattered you're that impressed by me, but sorry, I'm not interested.",false)
            call Text_Say(udg_CinematicActor,"Stop fooling around you jester!",false)
            call Text_Say(gg_unit_U00I_0210,"Alright, time for you to die then. Let's dance.",false)
            call Cine_ExitAction()
        else
            call Wait_Polled(1.)
            set udg_TempPoint=GetUnitLoc(gg_unit_U00I_0210)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            if(Trig_Shemhazai_Appears_Quest20NotFound_Reveal())then
                call ShowUnitShow(gg_unit_U00I_0210)
                call Wait_Polled(1.)
                if(Trig_Shemhazai_Appears_Quest20NotFound_Clones())then
                    call ConditionalTriggerExecute(gg_trg_Shemhazai_Spawn_SoulClones)
                endif
            endif
        endif
        if(Trig_Shemhazai_Appears_Quest20NotFound_Fight())then
            call PauseUnitBJ(false,gg_unit_U00I_0210)
            call ForGroupBJ(udg_ShemhazaiSoulClones,function Trig_Shemhazai_Appears_SetupSoulClone)
            call GroupAddUnitSimple(gg_unit_U00I_0210,udg_BossUnits)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Destroy Shemhazai, the Zodiac Brave of Soul.")
            call QuestSetDescriptionBJ(udg_MainQuest[$D],"Destroy Shemhazai, the Zodiac Brave of Soul.") // $D = 13
            set udg_ShemhazaiPhase=2
            call EnableTrigger(gg_trg_Shemhazai_Phase2_Cuchulainn)
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Shemhazai_Spawn_SoulClones_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(gg_unit_U00I_0210)
    // (facing in degrees of gg_unit_U00I_0210) plus (330).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(GetUnitFacing(gg_unit_U00I_0210)+330.))
    call CreateNUnitsAtLoc(1,'H003',Player($B),udg_TempPoint2,GetUnitFacing(gg_unit_U00I_0210)) // 'H003': unit "Knight"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShemhazaiSoulClones)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetUnitVertexColorBJ(GetLastCreatedUnit(),.0,.0,.0,0)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetHeroLevelBJ(GetLastCreatedUnit(),45,false)
    set bj_forLoopAIndex=6
    set bj_forLoopAIndexEnd=9
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ(udg_JobSkill[GetForLoopIndexA()],GetLastCreatedUnit())
        call SetUnitAbilityLevelSwapped(udg_JobSkill[GetForLoopIndexA()],GetLastCreatedUnit(),$A) // $A = 10
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call UnitAddAbilityBJ(udg_JobSkill[$A],GetLastCreatedUnit()) // $A = 10
    call SetUnitAbilityLevelSwapped(udg_JobSkill[$A],GetLastCreatedUnit(),5) // $A = 10
    call UnitAddAbilityBJ('A0SF',GetLastCreatedUnit()) // 'A0SF': ability "Command AI"
    call SetUnitAbilityLevelSwapped('A0SF',GetLastCreatedUnit(),17) // 'A0SF': ability "Command AI"
    // (BlzGetUnitArmor(GetLastCreatedUnit())) plus (80).
    call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+80.))
    call UnitAddAbilityBJ('A0I0',GetLastCreatedUnit()) // 'A0I0': ability "Magicdamage Reduction"
    call ModifyHeroStat(bj_HEROSTAT_STR,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
    call ModifyHeroStat(bj_HEROSTAT_AGI,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_INT,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    // ((maximum health of GetLastCreatedUnit()) plus (750)) times (2).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())+750)*2))
    // (facing in degrees of gg_unit_U00I_0210) plus (30).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(GetUnitFacing(gg_unit_U00I_0210)+30.))
    call CreateNUnitsAtLoc(1,'H001',Player($B),udg_TempPoint2,GetUnitFacing(gg_unit_U00I_0210)) // 'H001': unit "Archer"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShemhazaiSoulClones)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetUnitVertexColorBJ(GetLastCreatedUnit(),.0,.0,.0,0)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetHeroLevelBJ(GetLastCreatedUnit(),45,false)
    set bj_forLoopAIndex=$B // $B = 11
    set bj_forLoopAIndexEnd=$E // $E = 14
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ(udg_JobSkill[GetForLoopIndexA()],GetLastCreatedUnit())
        call SetUnitAbilityLevelSwapped(udg_JobSkill[GetForLoopIndexA()],GetLastCreatedUnit(),$A) // $A = 10
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call UnitAddAbilityBJ(udg_JobSkill[$F],GetLastCreatedUnit()) // $F = 15
    call SetUnitAbilityLevelSwapped(udg_JobSkill[$F],GetLastCreatedUnit(),5) // $F = 15
    call UnitAddAbilityBJ('A0SF',GetLastCreatedUnit()) // 'A0SF': ability "Command AI"
    call SetUnitAbilityLevelSwapped('A0SF',GetLastCreatedUnit(),2) // 'A0SF': ability "Command AI"
    // (BlzGetUnitArmor(GetLastCreatedUnit())) plus (60).
    call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+60.))
    call UnitAddAbilityBJ('A0I0',GetLastCreatedUnit()) // 'A0I0': ability "Magicdamage Reduction"
    call ModifyHeroStat(bj_HEROSTAT_STR,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_AGI,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
    call ModifyHeroStat(bj_HEROSTAT_INT,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    // ((maximum health of GetLastCreatedUnit()) plus (1500)) times (2).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())+$5DC)*2)) // $5DC = 1500
    // (facing in degrees of gg_unit_U00I_0210) plus (270).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(GetUnitFacing(gg_unit_U00I_0210)+270.))
    call CreateNUnitsAtLoc(1,'H004',Player($B),udg_TempPoint2,GetUnitFacing(gg_unit_U00I_0210)) // 'H004': unit "Wizard"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShemhazaiSoulClones)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetUnitVertexColorBJ(GetLastCreatedUnit(),.0,.0,.0,0)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetHeroLevelBJ(GetLastCreatedUnit(),45,false)
    set bj_forLoopAIndex=56
    set bj_forLoopAIndexEnd=59
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ(udg_JobSkill[GetForLoopIndexA()],GetLastCreatedUnit())
        call SetUnitAbilityLevelSwapped(udg_JobSkill[GetForLoopIndexA()],GetLastCreatedUnit(),$A) // $A = 10
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call UnitAddAbilityBJ(udg_JobSkill[60],GetLastCreatedUnit())
    call SetUnitAbilityLevelSwapped(udg_JobSkill[60],GetLastCreatedUnit(),5)
    call UnitAddAbilityBJ('A0SF',GetLastCreatedUnit()) // 'A0SF': ability "Command AI"
    call SetUnitAbilityLevelSwapped('A0SF',GetLastCreatedUnit(),24) // 'A0SF': ability "Command AI"
    // (BlzGetUnitArmor(GetLastCreatedUnit())) plus (40).
    call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+40.))
    call UnitAddAbilityBJ('A0ET',GetLastCreatedUnit()) // 'A0ET': ability "Magicdamage Reduction"
    call ModifyHeroStat(bj_HEROSTAT_STR,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_AGI,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_INT,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
    // ((maximum health of GetLastCreatedUnit()) plus (500)) times (2).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())+500)*2))
    // (facing in degrees of gg_unit_U00I_0210) plus (90).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(GetUnitFacing(gg_unit_U00I_0210)+90.))
    call CreateNUnitsAtLoc(1,'H005',Player($B),udg_TempPoint2,GetUnitFacing(gg_unit_U00I_0210)) // 'H005': unit "Priest"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShemhazaiSoulClones)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetUnitVertexColorBJ(GetLastCreatedUnit(),.0,.0,.0,0)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetHeroLevelBJ(GetLastCreatedUnit(),45,false)
    call UnitAddAbilityBJ(udg_JobSkill[61],GetLastCreatedUnit())
    call SetUnitAbilityLevelSwapped(udg_JobSkill[61],GetLastCreatedUnit(),$A) // $A = 10
    call UnitAddAbilityBJ(udg_JobSkill[62],GetLastCreatedUnit())
    call SetUnitAbilityLevelSwapped(udg_JobSkill[62],GetLastCreatedUnit(),$A) // $A = 10
    call UnitAddAbilityBJ('A09K',GetLastCreatedUnit()) // 'A09K': ability "Protect"
    call UnitAddAbilityBJ('A08H',GetLastCreatedUnit()) // 'A08H': ability "Shell"
    call UnitAddAbilityBJ(udg_JobSkill[65],GetLastCreatedUnit())
    call SetUnitAbilityLevelSwapped(udg_JobSkill[65],GetLastCreatedUnit(),5)
    // (BlzGetUnitArmor(GetLastCreatedUnit())) plus (40).
    call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+40.))
    call UnitAddAbilityBJ('A0ET',GetLastCreatedUnit()) // 'A0ET': ability "Magicdamage Reduction"
    call ModifyHeroStat(bj_HEROSTAT_STR,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_AGI,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_INT,GetLastCreatedUnit(),bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
    // ((maximum health of GetLastCreatedUnit()) plus (500)) times (2).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())+500)*2))
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Shemhazai_SurpriseMechanic_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A112') // 'A112': ability "!Surprise Mechanic"
endfunction

function Trig_Shemhazai_SurpriseMechanic_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Shemhazai_SurpriseMechanic_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Shemhazai_SurpriseMechanic_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // A random decimal number between 999 and 9999.
    call SaveRealBJ(GetRandomReal(999.,9999.),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A111',GetLastCreatedUnit()) // 'A111': ability "Surprise Mechanic"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"creepthunderbolt",GetSpellTargetUnit())
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_ShemhazaiSoulClones))
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_KnowsCuchulainn takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[5]))and(LoadIntegerBJ(2,$8B,udg_GameStateHash)==0) // $8B = 139
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_MetCuchulainn takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[5]))or(Trig_Shemhazai_Phase2_Cuchulainn_KnowsCuchulainn())
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_MetCuchulainn_Line takes nothing returns boolean
    return(Trig_Shemhazai_Phase2_Cuchulainn_MetCuchulainn())
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_AllSoulsDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_ShemhazaiSoulClones))
endfunction

function Trig_Shemhazai_Phase2_Cuchulainn_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShemhazaiSoulClones)
    if(Trig_Shemhazai_Phase2_Cuchulainn_AllSoulsDead())then
        call DisableTrigger(GetTriggeringTrigger())
        call BlzSetHeroProperName(gg_unit_U019_0253,"Soul Cúchulainn")
        set udg_TempPoint=GetUnitLoc(gg_unit_U00I_0210)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,GetUnitFacing(gg_unit_U00I_0210))
        call RemoveLocation(udg_TempPoint)
        call SetUnitPositionLocFacingBJ(gg_unit_U019_0253,udg_TempPoint2,GetUnitFacing(gg_unit_U00I_0210))
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Shemhazai_Phase2_Cuchulainn_CinematicsEnabled())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_U00I_0210,.0)
            call Text_Say(gg_unit_U00I_0210,"So you are still standing. Your powers are quite impressive indeed.",false)
            call Text_Say(gg_unit_U00I_0210,"But I'm far from out of tricks. Let's go for round two!",false)
            call ShowUnitShow(gg_unit_U019_0253)
            call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U019_0253,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U019_0253,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call Wait_Polled(2)
            if(Trig_Shemhazai_Phase2_Cuchulainn_KillerIsPlayer())then
                set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
            else
                set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
            endif
            call Text_Say(udg_CinematicActor,"Another demon!?",false)
            if(Trig_Shemhazai_Phase2_Cuchulainn_MetCuchulainn_Line())then
                call Text_Transmission(udg_CinematicActor,udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(udg_CinematicActor))],"Another demon!? Wait...","Another demon!?",null,0,false)
                call Text_Transmission(udg_CinematicActor,udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(udg_CinematicActor))],"Another demon!? Wait... this one looks awfully familiar.","Another demon!? Wait...",null,0,false)
                call Text_Say(gg_unit_U00I_0210,"That's right, you are the ones who stole the Eye of Jenova, are you not. Tee hee, then allow me to clear up your doubts.",false)
            endif
            call Text_Say(gg_unit_U00I_0210,"This is the soul of the Zodiac Brave of Poison, Cúchulainn.",false)
            call Text_Say(udg_CinematicActor,"You robbed the soul of even your own comrade!? You demons truly are monstrous beyond comprehension.",false)
            call Text_Say(gg_unit_U00I_0210,"Spare me the preaching, heroes. I've just about had it with your arrogance.",false)
            call Text_Say(udg_CinematicActor,"We will never fall to the likes of you!",false)
            call Cine_ExitAction()
        else
            call ShowUnitShow(gg_unit_U019_0253)
            call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U019_0253,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U019_0253,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
        call PauseUnitBJ(false,gg_unit_U019_0253)
        call SetUnitInvulnerable(gg_unit_U019_0253,false)
        call Music_SetTrack($D) // $D = 13
        set udg_ShemhazaiPhase=3
        call EnableTrigger(gg_trg_Cuchulainn_Soul_Death)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Shemhazai_SoulSplit_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A12F')and(IsUnitGroupEmptyBJ(udg_MirrorCloneGroup)) // 'A12F': ability "Soul Split"
endfunction

function Trig_Shemhazai_SoulSplit_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Shemhazai_SoulSplit_TrackedCaster takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Shemhazai_SoulSplit_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Shemhazai_SoulSplit_IsRealSlot takes nothing returns boolean
    return(udg_TempInteger==GetForLoopIndexA())
endfunction

function Trig_Shemhazai_SoulSplit_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    if(Trig_Shemhazai_SoulSplit_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateTextTagLocBJ("|cffffcc00SOUL SPLIT",udg_TempPoint,0,13.,'d','d','d',0)
    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    // A random whole number from 0 through 3.
    set udg_TempInteger=GetRandomInt(0,3)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=3
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A) times (90) treated as a decimal-capable number.
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,220.,I2R((GetForLoopIndexA()*90)))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Shemhazai_SoulSplit_IsRealSlot())then
            call SetUnitPositionLocFacingLocBJ(GetTriggerUnit(),udg_TempPoint2,udg_TempPoint)
        else
            call CreateNUnitsAtLocFacingLocBJ(1,GetUnitTypeId(GetTriggerUnit()),GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,udg_TempPoint)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_MirrorCloneGroup)
            if(Trig_Shemhazai_SoulSplit_TrackedCaster())then
                call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
            endif
            call UnitAddAbilityBJ('A0QY',GetLastCreatedUnit()) // 'A0QY': ability "Devalued"
            call UnitAddAbilityBJ('A0ZN',GetLastCreatedUnit()) // 'A0ZN': ability "Wave Fist"
            call UnitRemoveAbilityBJ('A112',GetLastCreatedUnit()) // 'A112': ability "!Surprise Mechanic"
            call UnitRemoveAbilityBJ('A0SF',GetLastCreatedUnit()) // 'A0SF': ability "Command AI"
            call UnitApplyTimedLifeBJ(30.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            if(Trig_Shemhazai_SoulSplit_CasterIsHero())then
                call SetHeroLevelBJ(GetLastCreatedUnit(),GetHeroLevel(GetTriggerUnit()),false)
                call ModifyHeroSkillPoints(GetLastCreatedUnit(),bj_MODIFYMETHOD_SET,0)
                set bj_forLoopBIndex=1
                set bj_forLoopBIndexEnd=6
                loop
                    exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
                    call UnitAddItemByIdSwapped(GetItemTypeId(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexB())),GetLastCreatedUnit())
                    call SetItemDroppableBJ(GetLastCreatedItem(),false)
                    set bj_forLoopBIndex=bj_forLoopBIndex+1
                endloop
            endif
            // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
            // missing or its maximum is 0).
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),GetUnitLifePercent(GetTriggerUnit()))
            // Result 1: current mana divided by maximum mana for the triggering unit, times 100 (or 0 if the unit is
            // missing or its maximum is 0).
            call SetUnitManaPercentBJ(GetLastCreatedUnit(),GetUnitManaPercent(GetTriggerUnit()))
        endif
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call UnitRemoveAbilityBJ('A12F',GetTriggerUnit()) // 'A12F': ability "Soul Split"
    call Wait_Polled(45.)
    call UnitAddAbilityBJ('A12F',GetTriggerUnit()) // 'A12F': ability "Soul Split"
endfunction

// World Editor calls InitTrig_Shemhazai automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Shemhazai_Part1 / RegisterTriggers_Shemhazai_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Shemhazai takes nothing returns nothing
endfunction

function Register_Shemhazai_Prepare takes nothing returns nothing
    set gg_trg_Shemhazai_Prepare=CreateTrigger()
    call TriggerAddAction(gg_trg_Shemhazai_Prepare,function Trig_Shemhazai_Prepare_Actions)
endfunction

function Register_Shemhazai_Appears takes nothing returns nothing
    set gg_trg_Shemhazai_Appears=CreateTrigger()
    call DisableTrigger(gg_trg_Shemhazai_Appears)
    call TriggerRegisterUnitEvent(gg_trg_Shemhazai_Appears,gg_unit_nbfl_0170,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Shemhazai_Appears,function Trig_Shemhazai_Appears_Actions)
endfunction

function Register_Shemhazai_Spawn_SoulClones takes nothing returns nothing
    set gg_trg_Shemhazai_Spawn_SoulClones=CreateTrigger()
    call DisableTrigger(gg_trg_Shemhazai_Spawn_SoulClones)
    call TriggerAddAction(gg_trg_Shemhazai_Spawn_SoulClones,function Trig_Shemhazai_Spawn_SoulClones_Actions)
endfunction

function Register_Shemhazai_SurpriseMechanic takes nothing returns nothing
    set gg_trg_Shemhazai_SurpriseMechanic=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shemhazai_SurpriseMechanic,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shemhazai_SurpriseMechanic,Condition(function Trig_Shemhazai_SurpriseMechanic_Conditions))
    call TriggerAddAction(gg_trg_Shemhazai_SurpriseMechanic,function Trig_Shemhazai_SurpriseMechanic_Actions)
endfunction

function Register_Shemhazai_Phase2_Cuchulainn takes nothing returns nothing
    set gg_trg_Shemhazai_Phase2_Cuchulainn=CreateTrigger()
    call DisableTrigger(gg_trg_Shemhazai_Phase2_Cuchulainn)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Shemhazai_Phase2_Cuchulainn,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Shemhazai_Phase2_Cuchulainn,Condition(function Trig_Shemhazai_Phase2_Cuchulainn_Conditions))
    call TriggerAddAction(gg_trg_Shemhazai_Phase2_Cuchulainn,function Trig_Shemhazai_Phase2_Cuchulainn_Actions)
endfunction

function Register_Shemhazai_SoulSplit takes nothing returns nothing
    set gg_trg_Shemhazai_SoulSplit=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shemhazai_SoulSplit,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shemhazai_SoulSplit,Condition(function Trig_Shemhazai_SoulSplit_Conditions))
    call TriggerAddAction(gg_trg_Shemhazai_SoulSplit,function Trig_Shemhazai_SoulSplit_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Shemhazai_Part1 takes nothing returns nothing
    call Register_Shemhazai_Prepare()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Shemhazai_Part2 takes nothing returns nothing
    call Register_Shemhazai_Appears()
    call Register_Shemhazai_Spawn_SoulClones()
    call Register_Shemhazai_SurpriseMechanic()
    call Register_Shemhazai_Phase2_Cuchulainn()
    call Register_Shemhazai_SoulSplit()
endfunction

endlibrary

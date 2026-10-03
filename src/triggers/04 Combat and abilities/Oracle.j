library TOracle requires TAbil, TProf, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Oracle_Jinx=null
    trigger gg_trg_Oracle_Blind=null
    trigger gg_trg_Oracle_PredictStrength=null
    trigger gg_trg_Oracle_PredictMagic=null
    trigger gg_trg_Oracle_Scourge=null
    trigger gg_trg_Oracle_NeoBahamut=null
    // Variables only this module uses.
    unit udg_JinxTarget=null
endglobals

function Trig_Oracle_Jinx_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14A') // 'A14A': ability "Jinx"
endfunction

function Trig_Oracle_Jinx_TargetHasHaste takes nothing returns boolean
    return(UnitHasBuffBJ(udg_JinxTarget,'B00F'))or(UnitHasBuffBJ(udg_JinxTarget,'B08T'))or(UnitHasBuffBJ(udg_JinxTarget,'B07F')) // 'B00F': buff "Haste"; 'B08T': buff "Hastera"; 'B07F': buff "Haste"
endfunction

function Trig_Oracle_Jinx_HasHaste takes nothing returns boolean
    return(Trig_Oracle_Jinx_TargetHasHaste())
endfunction

function Trig_Oracle_Jinx_TargetHasBravery takes nothing returns boolean
    return(UnitHasBuffBJ(udg_JinxTarget,'B01W'))or(UnitHasBuffBJ(udg_JinxTarget,'B08P'))or(UnitHasBuffBJ(udg_JinxTarget,'B07I')) // 'B01W': buff "Bravery"; 'B08P': buff "Bravera"; 'B07I': buff "Bravery"
endfunction

function Trig_Oracle_Jinx_HasBravery takes nothing returns boolean
    return(Trig_Oracle_Jinx_TargetHasBravery())
endfunction

function Trig_Oracle_Jinx_TargetHasFaith takes nothing returns boolean
    return(UnitHasBuffBJ(udg_JinxTarget,'B05A'))or(UnitHasBuffBJ(udg_JinxTarget,'B08Q'))or(UnitHasBuffBJ(udg_JinxTarget,'B07J')) // 'B05A': buff "Faith"; 'B08Q': buff "Faithra"; 'B07J': buff "Faith"
endfunction

function Trig_Oracle_Jinx_HasFaith takes nothing returns boolean
    return(Trig_Oracle_Jinx_TargetHasFaith())
endfunction

function Trig_Oracle_Jinx_TargetHasProtect takes nothing returns boolean
    return(UnitHasBuffBJ(udg_JinxTarget,'B007'))or(UnitHasBuffBJ(udg_JinxTarget,'B08R'))or(UnitHasBuffBJ(udg_JinxTarget,'B07G')) // 'B007': buff "Protect"; 'B08R': buff "Protectra"; 'B07G': buff "Protect"
endfunction

function Trig_Oracle_Jinx_HasProtect takes nothing returns boolean
    return(Trig_Oracle_Jinx_TargetHasProtect())
endfunction

function Trig_Oracle_Jinx_TargetHasShell takes nothing returns boolean
    return(UnitHasBuffBJ(udg_JinxTarget,'B005'))or(UnitHasBuffBJ(udg_JinxTarget,'B08S'))or(UnitHasBuffBJ(udg_JinxTarget,'B07H')) // 'B005': buff "Shell"; 'B08S': buff "Shellra"; 'B07H': buff "Shell"
endfunction

function Trig_Oracle_Jinx_HasShell takes nothing returns boolean
    return(Trig_Oracle_Jinx_TargetHasShell())
endfunction

function Trig_Oracle_Jinx_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_JinxTarget=GetSpellTargetUnit()
    set l_tempPoint=GetUnitLoc(udg_JinxTarget)
    if(Trig_Oracle_Jinx_HasHaste())then
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A1FK',GetLastCreatedUnit()) // 'A1FK': ability "Slow"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"slow",udg_JinxTarget)
    endif
    if(Trig_Oracle_Jinx_HasBravery())then
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A1FL',GetLastCreatedUnit()) // 'A1FL': ability "Pain"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",udg_JinxTarget)
    endif
    if(Trig_Oracle_Jinx_HasFaith())then
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A1FM',GetLastCreatedUnit()) // 'A1FM': ability "Fog"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",udg_JinxTarget)
    endif
    if(Trig_Oracle_Jinx_HasProtect())then
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A1FN',GetLastCreatedUnit()) // 'A1FN': ability "Deprotect"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"faeriefire",udg_JinxTarget)
    endif
    if(Trig_Oracle_Jinx_HasShell())then
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A1FO',GetLastCreatedUnit()) // 'A1FO': ability "Deshell"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"faeriefire",udg_JinxTarget)
    endif
    call RemoveLocation(l_tempPoint)
    set udg_DispelTarget=udg_JinxTarget
    call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
    set l_tempPoint=null
endfunction

function Trig_Oracle_Blind_IsBlindSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A02O')or(GetSpellAbilityId()=='A09C')or(GetSpellAbilityId()=='A08K')or(GetSpellAbilityId()=='Acrs')or(GetSpellAbilityId()=='ACcs')or(GetSpellAbilityId()=='A09G') // 'A02O': ability "Blind"; 'A09C': ability "Blind"; 'A08K': ability "Blind"; 'Acrs': ability "Blind"; 'ACcs': ability "Blind"; 'A09G': ability "Blind"
endfunction

function Trig_Oracle_Blind_Conditions takes nothing returns boolean
    return(Trig_Oracle_Blind_IsBlindSpell())
endfunction

function Trig_Oracle_Blind_MasteryCountReached takes nothing returns boolean
    return(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20)
endfunction

function Trig_Oracle_Blind_MasteryCountsThisCast takes nothing returns boolean
    return(GetSpellAbilityId()=='A02O')and(UnitHasBuffBJ(GetSpellTargetUnit(),'B00P')==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[16])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3)and(GetUnitTypeId(GetTriggerUnit())=='H00I') // 'A02O': ability "Blind"; 'B00P': buff tooltip "Blind"; 'A02F': ability "Mastery"; 'H00I': unit "Oracle"
endfunction

function Trig_Oracle_Blind_TargetIsBlindproof takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RA',GetSpellTargetUnit())>0) // 'A0RA': ability "Blindproof"
endfunction

function Trig_Oracle_Blind_Actions takes nothing returns nothing
    if(Trig_Oracle_Blind_TargetIsBlindproof())then
        call GroupAddUnitSimple(GetSpellTargetUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    else
        if(Trig_Oracle_Blind_MasteryCountsThisCast())then
            set udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
            if(Trig_Oracle_Blind_MasteryCountReached())then
                call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[16])
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
            else
                call Wait_Polled(60.)
                set udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-1)
            endif
        endif
    endif
endfunction

function Trig_Oracle_PredictStrength_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0L5') // 'A0L5': ability "Predict Strength"
endfunction

function Trig_Oracle_PredictStrength_HasExpertiseEnemy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Oracle_PredictStrength_HasExpertiseAlly takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Oracle_PredictStrength_TargetIsEnemy takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Oracle_PredictStrength_MasteryCountReached takes nothing returns boolean
    return(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20)
endfunction

function Trig_Oracle_PredictStrength_MasteryCountsThisCast takes nothing returns boolean
    return(udg_TempBoolean==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[16])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3)and(GetUnitTypeId(GetTriggerUnit())=='H00I') // 'A02F': ability "Mastery"; 'H00I': unit "Oracle"
endfunction

function Trig_Oracle_PredictStrength_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempBoolean=IsUnitEnemy(GetSpellTargetUnit(),GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Oracle_PredictStrength_TargetIsEnemy())then
        if(Trig_Oracle_PredictStrength_HasExpertiseEnemy())then
            call UnitAddAbilityBJ('A101',GetLastCreatedUnit()) // 'A101': ability "Painra"
            call SetUnitAbilityLevelSwapped('A101',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A101': ability "Painra"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B08W') // 'B08W': buff "Painra"
        else
            call UnitAddAbilityBJ('A0P5',GetLastCreatedUnit()) // 'A0P5': ability "Pain"
            call SetUnitAbilityLevelSwapped('A0P5',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0P5': ability "Pain"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B06H') // 'B06H': buff "Pain"
        endif
    else
        if(Trig_Oracle_PredictStrength_HasExpertiseAlly())then
            call UnitAddAbilityBJ('A0QL',GetLastCreatedUnit()) // 'A0QL': ability "Bravera"
            call SetUnitAbilityLevelSwapped('A0QL',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0QL': ability "Bravera"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B08P') // 'B08P': buff "Bravera"
        else
            call UnitAddAbilityBJ('A083',GetLastCreatedUnit()) // 'A083': ability "Bravery"
            call SetUnitAbilityLevelSwapped('A083',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A083': ability "Bravery"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B01W') // 'B01W': buff "Bravery"
        endif
    endif
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"innerfire",GetSpellTargetUnit())
    if(Trig_Oracle_PredictStrength_MasteryCountsThisCast())then
        set udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
        if(Trig_Oracle_PredictStrength_MasteryCountReached())then
            call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[16])
            call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        else
            call Wait_Polled(60.)
            set udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-1)
        endif
    endif
    set l_tempPoint=null
endfunction

function Trig_Oracle_PredictMagic_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0L6') // 'A0L6': ability "Predict Magic"
endfunction

function Trig_Oracle_PredictMagic_HasExpertiseEnemy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Oracle_PredictMagic_HasExpertiseAlly takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Oracle_PredictMagic_TargetIsEnemy takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Oracle_PredictMagic_MasteryCountReached takes nothing returns boolean
    return(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20)
endfunction

function Trig_Oracle_PredictMagic_MasteryCountsThisCast takes nothing returns boolean
    return(udg_TempBoolean==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[16])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3)and(GetUnitTypeId(GetTriggerUnit())=='H00I') // 'A02F': ability "Mastery"; 'H00I': unit "Oracle"
endfunction

function Trig_Oracle_PredictMagic_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempBoolean=IsUnitEnemy(GetSpellTargetUnit(),GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Oracle_PredictMagic_TargetIsEnemy())then
        if(Trig_Oracle_PredictMagic_HasExpertiseEnemy())then
            call UnitAddAbilityBJ('A155',GetLastCreatedUnit()) // 'A155': ability "Fogra"
            call SetUnitAbilityLevelSwapped('A155',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A155': ability "Fogra"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B08X') // 'B08X': buff "Fogra"
        else
            call UnitAddAbilityBJ('A0P4',GetLastCreatedUnit()) // 'A0P4': ability "Fog"
            call SetUnitAbilityLevelSwapped('A0P4',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0P4': ability "Fog"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B06I') // 'B06I': buff "Fog"
        endif
    else
        if(Trig_Oracle_PredictMagic_HasExpertiseAlly())then
            call UnitAddAbilityBJ('A0QZ',GetLastCreatedUnit()) // 'A0QZ': ability "Faithra"
            call SetUnitAbilityLevelSwapped('A0QZ',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0QZ': ability "Faithra"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B08Q') // 'B08Q': buff "Faithra"
        else
            call UnitAddAbilityBJ('A0RW',GetLastCreatedUnit()) // 'A0RW': ability "Faith"
            call SetUnitAbilityLevelSwapped('A0RW',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0RW': ability "Faith"
            set udg_TempBoolean=UnitHasBuffBJ(GetSpellTargetUnit(),'B05A') // 'B05A': buff "Faith"
        endif
    endif
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",GetSpellTargetUnit())
    if(Trig_Oracle_PredictMagic_MasteryCountsThisCast())then
        set udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
        if(Trig_Oracle_PredictMagic_MasteryCountReached())then
            call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[16])
            call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        else
            call Wait_Polled(60.)
            set udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_OracleMasteryCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-1)
        endif
    endif
    set l_tempPoint=null
endfunction

function Trig_Oracle_Scourge_IsScourgeSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0VM')or(GetSpellAbilityId()=='A12M')or(GetSpellAbilityId()=='A0VL')or(GetSpellAbilityId()=='A0X5') // 'A0VM': ability "Scourge"; 'A12M': ability "Scourge"; 'A0VL': ability "Scourge"; 'A0X5': ability "Scourge"
endfunction

function Trig_Oracle_Scourge_Conditions takes nothing returns boolean
    return(Trig_Oracle_Scourge_IsScourgeSpell())
endfunction

function Trig_Oracle_Scourge_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Oracle_Scourge_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (3).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 3)
    if(Trig_Oracle_Scourge_CasterIsHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) divided by (2); drop the remainder).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 2))
    endif
    set l_tempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0VK',GetLastCreatedUnit()) // 'A0VK': ability "Scourge"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
    set l_tempPoint=null
endfunction

function Trig_Oracle_NeoBahamut_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A147') // 'A147': ability "!Neo Bahamut"
endfunction

function Trig_Oracle_NeoBahamut_HasNeoBahamut takes nothing returns boolean
    return(udg_NeoBahamutSummon!=null)
endfunction

function Trig_Oracle_NeoBahamut_Actions takes nothing returns nothing
    local location l_tempPoint
    local real l_tempReal
    if(Trig_Oracle_NeoBahamut_HasNeoBahamut())then
        call KillUnit(udg_NeoBahamutSummon)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'n00G',GetOwningPlayer(GetSpellAbilityUnit()),l_tempPoint,bj_UNIT_FACING) // 'n00G': unit "Neo Bahamut"
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set udg_NeoBahamutSummon=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitApplyTimedLifeBJ(60.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00L'))).
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00L')) // $A = 10; 'R00L': upgrade "Inner Mana"
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.6).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.6)))),0)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.6).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.6)))),1)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (9) times (l_tempReal).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (maximum health of GetLastCreatedUnit()) plus (result 4).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(9.*l_tempReal)))))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call Abil_CopyPassives(GetTriggerUnit(),bj_lastCreatedUnit)
    set udg_NeoBahamutBaseArmor=BlzGetUnitArmor(GetLastCreatedUnit())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Oracle automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Oracle_Part1 ... RegisterTriggers_Oracle_Part3 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Oracle takes nothing returns nothing
endfunction

function Register_Oracle_Jinx takes nothing returns nothing
    set gg_trg_Oracle_Jinx=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oracle_Jinx,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Oracle_Jinx,Condition(function Trig_Oracle_Jinx_Conditions))
    call TriggerAddAction(gg_trg_Oracle_Jinx,function Trig_Oracle_Jinx_Actions)
endfunction

function Register_Oracle_Blind takes nothing returns nothing
    set gg_trg_Oracle_Blind=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oracle_Blind,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Oracle_Blind,Condition(function Trig_Oracle_Blind_Conditions))
    call TriggerAddAction(gg_trg_Oracle_Blind,function Trig_Oracle_Blind_Actions)
endfunction

function Register_Oracle_PredictStrength takes nothing returns nothing
    set gg_trg_Oracle_PredictStrength=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oracle_PredictStrength,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Oracle_PredictStrength,Condition(function Trig_Oracle_PredictStrength_Conditions))
    call TriggerAddAction(gg_trg_Oracle_PredictStrength,function Trig_Oracle_PredictStrength_Actions)
endfunction

function Register_Oracle_PredictMagic takes nothing returns nothing
    set gg_trg_Oracle_PredictMagic=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oracle_PredictMagic,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Oracle_PredictMagic,Condition(function Trig_Oracle_PredictMagic_Conditions))
    call TriggerAddAction(gg_trg_Oracle_PredictMagic,function Trig_Oracle_PredictMagic_Actions)
endfunction

function Register_Oracle_Scourge takes nothing returns nothing
    set gg_trg_Oracle_Scourge=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oracle_Scourge,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Oracle_Scourge,Condition(function Trig_Oracle_Scourge_Conditions))
    call TriggerAddAction(gg_trg_Oracle_Scourge,function Trig_Oracle_Scourge_Actions)
endfunction

function Register_Oracle_NeoBahamut takes nothing returns nothing
    set gg_trg_Oracle_NeoBahamut=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oracle_NeoBahamut,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Oracle_NeoBahamut,Condition(function Trig_Oracle_NeoBahamut_Conditions))
    call TriggerAddAction(gg_trg_Oracle_NeoBahamut,function Trig_Oracle_NeoBahamut_Actions)
endfunction

// Creates part 1 of 3 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Oracle_Part1 takes nothing returns nothing
    call Register_Oracle_Jinx()
endfunction

// Creates part 2 of 3 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Oracle_Part2 takes nothing returns nothing
    call Register_Oracle_Blind()
endfunction

// Creates part 3 of 3 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Oracle_Part3 takes nothing returns nothing
    call Register_Oracle_PredictStrength()
    call Register_Oracle_PredictMagic()
    call Register_Oracle_Scourge()
    call Register_Oracle_NeoBahamut()
endfunction

endlibrary

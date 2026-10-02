library TMediator requires TAbil, TForce, TGroup, TLoc, TProf, TUnit
function Trig_Mediator_Clone_Reject_TargetNotCloneable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1DH',GetSpellTargetUnit())>0)or(GetUnitAbilityLevelSwapped('A122',GetSpellTargetUnit())<=0) // 'A1DH': ability "Cloned"; 'A122': ability "Summoned Powerup"
endfunction

function Trig_Mediator_Clone_Reject_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A175')and(Trig_Mediator_Clone_Reject_TargetNotCloneable()) // 'A175': ability "Clone"
endfunction

function Trig_Mediator_Clone_Reject_TargetIsClone takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1DH',GetSpellTargetUnit())>0) // 'A1DH': ability "Cloned"
endfunction

function Trig_Mediator_Clone_Reject_Actions takes nothing returns nothing
    call PauseUnitBJ(true,GetTriggerUnit())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
    call PauseUnitBJ(false,GetTriggerUnit())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Mediator_Clone_Reject_TargetIsClone())then
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000You cannot clone a clone!|r")
    else
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000This target cannot be cloned!|r")
    endif
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Mediator_Clone_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A175') // 'A175': ability "Clone"
endfunction

function Trig_Mediator_Clone_TargetIsClone takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1DH',GetSpellTargetUnit())>0) // 'A1DH': ability "Cloned"
endfunction

function Trig_Mediator_Clone_SourceCanJoin takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A04F',udg_SpellTargetUnit)>0) // 'A04F': ability "Join Fast"
endfunction

function Trig_Mediator_Clone_Actions takes nothing returns nothing
    if(Trig_Mediator_Clone_TargetIsClone())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000You cannot clone a clone!|r")
        call DestroyForce(udg_TempForce)
        return
    endif
    set udg_SpellTargetUnit=GetSpellTargetUnit()
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,GetUnitTypeId(udg_SpellTargetUnit),GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetUnitFacing(GetTriggerUnit()))
    call RemoveLocation(udg_TempPoint)
    call UnitApplyTimedLifeBJ(30.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1DH',GetLastCreatedUnit()) // 'A1DH': ability "Cloned"
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitAddTypeBJ(UNIT_TYPE_SUMMONED,GetLastCreatedUnit())
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    call SetUnitLifeBJ(GetLastCreatedUnit(),GetUnitStateSwap(UNIT_STATE_LIFE,udg_SpellTargetUnit))
    call SetUnitManaBJ(GetLastCreatedUnit(),GetUnitStateSwap(UNIT_STATE_MANA,udg_SpellTargetUnit))
    if(Trig_Mediator_Clone_SourceCanJoin())then
        call UnitAddAbilityBJ('A04F',GetLastCreatedUnit()) // 'A04F': ability "Join Fast"
    endif
endfunction

function Trig_Mediator_SpellShot_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A171') // 'A171': ability "Spell Shot"
endfunction

function Trig_Mediator_SpellShot_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Mediator_SpellShot_CasterHasHaste takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B00F'))or(UnitHasBuffBJ(GetTriggerUnit(),'B08T'))or(UnitHasBuffBJ(GetTriggerUnit(),'B07F')) // 'B00F': buff "Haste"; 'B08T': buff "Hastera"; 'B07F': buff "Haste"
endfunction

function Trig_Mediator_SpellShot_HasHaste takes nothing returns boolean
    return(Trig_Mediator_SpellShot_CasterHasHaste())
endfunction

function Trig_Mediator_SpellShot_CasterHasBravery takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B01W'))or(UnitHasBuffBJ(GetTriggerUnit(),'B08P'))or(UnitHasBuffBJ(GetTriggerUnit(),'B07I')) // 'B01W': buff "Bravery"; 'B08P': buff "Bravera"; 'B07I': buff "Bravery"
endfunction

function Trig_Mediator_SpellShot_HasBravery takes nothing returns boolean
    return(Trig_Mediator_SpellShot_CasterHasBravery())
endfunction

function Trig_Mediator_SpellShot_CasterHasFaith takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B05A'))or(UnitHasBuffBJ(GetTriggerUnit(),'B08Q'))or(UnitHasBuffBJ(GetTriggerUnit(),'B07J')) // 'B05A': buff "Faith"; 'B08Q': buff "Faithra"; 'B07J': buff "Faith"
endfunction

function Trig_Mediator_SpellShot_HasFaith takes nothing returns boolean
    return(Trig_Mediator_SpellShot_CasterHasFaith())
endfunction

function Trig_Mediator_SpellShot_CasterHasProtect takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B007'))or(UnitHasBuffBJ(GetTriggerUnit(),'B08R'))or(UnitHasBuffBJ(GetTriggerUnit(),'B07G')) // 'B007': buff "Protect"; 'B08R': buff "Protectra"; 'B07G': buff "Protect"
endfunction

function Trig_Mediator_SpellShot_HasProtect takes nothing returns boolean
    return(Trig_Mediator_SpellShot_CasterHasProtect())
endfunction

function Trig_Mediator_SpellShot_CasterHasShell takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B005'))or(UnitHasBuffBJ(GetTriggerUnit(),'B08S'))or(UnitHasBuffBJ(GetTriggerUnit(),'B07H')) // 'B005': buff "Shell"; 'B08S': buff "Shellra"; 'B07H': buff "Shell"
endfunction

function Trig_Mediator_SpellShot_HasShell takes nothing returns boolean
    return(Trig_Mediator_SpellShot_CasterHasShell())
endfunction

function Trig_Mediator_SpellShot_HasSharpEye takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B06T')) // 'B06T': buff tooltip "Sharp Eye"
endfunction

function Trig_Mediator_SpellShot_HasMirage takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B06W')) // 'B06W': buff tooltip "Mirage"
endfunction

function Trig_Mediator_SpellShot_HasRunicShield takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B07R')) // 'B07R': buff "Runic Shield"
endfunction

function Trig_Mediator_SpellShot_HasRegen takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B006')) // 'B006': buff "Regen"
endfunction

function Trig_Mediator_SpellShot_MasteryReached takes nothing returns boolean
    return(udg_TempInteger2>=6)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[$F])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3)and(GetUnitTypeId(GetTriggerUnit())=='H00G') // $F = 15; 'A02F': ability "Mastery"; 'H00G': unit "Mediator"
endfunction

function Trig_Mediator_SpellShot_TargetNegatesHeal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',udg_SpellTargetUnit)>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Mediator_SpellShot_TargetIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(udg_SpellTargetUnit,GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Mediator_SpellShot_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("overhead",GetSpellTargetUnit(),"Abilities\\Weapons\\FlyingMachine\\FlyingMachineImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Mediator_SpellShot_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) divided by (4); drop the remainder).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 4))
    endif
    set udg_TempReal=Prof_GetSpellPower(GetTriggerUnit(),'R00M',.5) // 'R00M': upgrade "Gun"
    // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
    set udg_SpellTargetUnit=GetSpellTargetUnit()
    if(Trig_Mediator_SpellShot_TargetIsEnemy())then
        call AddSpecialEffectTargetUnitBJ("origin",udg_SpellTargetUnit,"Abilities\\Spells\\Other\\TinkerRocket\\TinkerRocketMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_DispelTarget=GetSpellTargetUnit()
        call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
        set udg_DmgFlagManaDamage=true
        set udg_DmgFlagUnavoidable=-1
        // Udg_TempInteger treated as a decimal-capable number.
        call UnitDamageTargetBJ(GetTriggerUnit(),udg_SpellTargetUnit,I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
        // (udg_TempInteger) times (4).
        set udg_TempInteger=(udg_TempInteger*4)
        set udg_DmgFlagUnavoidable=-1
        // Udg_TempInteger treated as a decimal-capable number.
        call UnitDamageTargetBJ(GetTriggerUnit(),udg_SpellTargetUnit,I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    else
        set udg_TempInteger2=0
        set udg_TempPoint=GetUnitLoc(udg_SpellTargetUnit)
        if(Trig_Mediator_SpellShot_HasHaste())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A18Y',GetLastCreatedUnit()) // 'A18Y': ability "Haste"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasBravery())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A1AO',GetLastCreatedUnit()) // 'A1AO': ability "Bravery"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"innerfire",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasFaith())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A1AP',GetLastCreatedUnit()) // 'A1AP': ability "Faith"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasProtect())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A18W',GetLastCreatedUnit()) // 'A18W': ability "Protect"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasShell())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A18V',GetLastCreatedUnit()) // 'A18V': ability "Shell"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasSharpEye())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A1AS',GetLastCreatedUnit()) // 'A1AS': ability "Sharp Eye"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasMirage())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A1AR',GetLastCreatedUnit()) // 'A1AR': ability "Mirage"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasRunicShield())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A1AQ',GetLastCreatedUnit()) // 'A1AQ': ability "Runic Shield"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"rejuvination",udg_SpellTargetUnit)
        endif
        if(Trig_Mediator_SpellShot_HasRegen())then
            set udg_TempInteger2=(udg_TempInteger2+1)
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ('A190',GetLastCreatedUnit()) // 'A190': ability "Regen"
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"rejuvination",udg_SpellTargetUnit)
            call SaveRealBJ(LoadRealBJ(1,GetHandleIdBJ(GetTriggerUnit()),udg_HealOverTimeHash),1,GetHandleIdBJ(GetSpellTargetUnit()),udg_HealOverTimeHash)
            call GroupAddUnitSimple(udg_SpellTargetUnit,udg_RegenGroup)
        endif
        call RemoveLocation(udg_TempPoint)
        if(Trig_Mediator_SpellShot_MasteryReached())then
            call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[$F]) // $F = 15
            call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
        if(Trig_Mediator_SpellShot_TargetNegatesHeal())then
            call AddSpecialEffectTargetUnitBJ("overhead",udg_SpellTargetUnit,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        else
            call AddSpecialEffectTargetUnitBJ("origin",udg_SpellTargetUnit,"Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectTargetUnitBJ("origin",udg_SpellTargetUnit,"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set udg_IsPureDamage=true
            set udg_DmgFlagManaDamage=true
            set udg_DmgFlagUnavoidable=-1
            // Udg_TempInteger treated as a decimal-capable number.
            call UnitDamageTargetBJ(GetTriggerUnit(),udg_SpellTargetUnit,I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
            // (udg_TempInteger) times (4).
            set udg_TempInteger=(udg_TempInteger*4)
            set udg_IsPureDamage=true
            set udg_DmgFlagUnavoidable=-1
            // Udg_TempInteger treated as a decimal-capable number.
            call UnitDamageTargetBJ(GetTriggerUnit(),udg_SpellTargetUnit,I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
        endif
    endif
endfunction

function Trig_Mediator_Invitation_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A02T') // 'A02T': ability "Invitation"
endfunction

function Trig_Mediator_Invitation_HasInvitedUnit takes nothing returns boolean
    return(udg_SummonUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]!=null)
endfunction

function Trig_Mediator_Invitation_AbilityAtMaxLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())>=$B) // $B = 11
endfunction

function Trig_Mediator_Invitation_TargetHasHandicapHP takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1B4',udg_SpellTargetUnit)>0) // 'A1B4': ability "Handicap Adjusted HP"
endfunction

function Trig_Mediator_Invitation_TargetNotSummoned takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A122',udg_SpellTargetUnit)<=0) // 'A122': ability "Summoned Powerup"
endfunction

function Trig_Mediator_Invitation_Actions takes nothing returns nothing
    if(Trig_Mediator_Invitation_HasInvitedUnit())then
        call UnitApplyTimedLifeBJ(120.,'BTLF',udg_SummonUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]) // 'BTLF': object name not found in map data
    endif
    set udg_SpellTargetUnit=GetSpellTargetUnit()
    set udg_SummonUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=udg_SpellTargetUnit
    call UnitAddTypeBJ(UNIT_TYPE_SUMMONED,udg_SpellTargetUnit)
    call UnitRemoveAbilityBJ('Aspy',udg_SpellTargetUnit) // 'Aspy': object name not found in map data
    call UnitRemoveAbilityBJ('Aspt',udg_SpellTargetUnit) // 'Aspt': object name not found in map data
    call UnitRemoveAbilityBJ('A018',udg_SpellTargetUnit) // 'A018': ability "Spawn Brood Mothers"
    call UnitRemoveAbilityBJ('Aspd',udg_SpellTargetUnit) // 'Aspd': object name not found in map data
    if(Trig_Mediator_Invitation_AbilityAtMaxLevel())then
        call UnitAddAbilityBJ('A04F',udg_SpellTargetUnit) // 'A04F': ability "Join Fast"
    endif
    set udg_DispelTarget=udg_SpellTargetUnit
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    call UnitRemoveBuffBJ('B04N',udg_SpellTargetUnit) // 'B04N': buff "Spirit Strength"
    call UnitRemoveBuffBJ('B04P',udg_SpellTargetUnit) // 'B04P': buff "Spirit Armor"
    call UnitRemoveBuffBJ('B04Q',udg_SpellTargetUnit) // 'B04Q': buff "Spirit Speed"
    if(Trig_Mediator_Invitation_TargetNotSummoned())then
        if(Trig_Mediator_Invitation_TargetHasHandicapHP())then
            // Result 1: (GetPlayerHandicapBJ(Player(11))) minus (100).
            // Result 2: (0.01) times (result 1).
            // Result 3: GetUnitAbilityLevelSwapped('A1B4', udg_SpellTargetUnit) treated as a decimal-capable number.
            // Result 4: (result 3) times (0.1).
            // Result 5: (result 2) times (result 4).
            // Result 6: (1) plus (result 5).
            // Result 7: (maximum health of udg_SpellTargetUnit) divided by (result 6).
            // Result 8: (result 7) times (1).
            // Result 9: (result 8) with its decimal part removed.
            call BlzSetUnitMaxHP(udg_SpellTargetUnit,R2I(((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_SpellTargetUnit)/(1+((.01*(GetPlayerHandicapBJ(Player($B))-100.))*(I2R(GetUnitAbilityLevelSwapped('A1B4',udg_SpellTargetUnit))*.1))))*1.))) // $B = 11; 'A1B4': ability "Handicap Adjusted HP"
            call UnitRemoveAbilityBJ('A1B4',udg_SpellTargetUnit) // 'A1B4': ability "Handicap Adjusted HP"
        else
            // Result 1: (maximum health of udg_SpellTargetUnit) times (1).
            // Result 2: (GetPlayerHandicapBJ(Player(11))) times (0.01).
            // Result 3: (result 1) divided by (result 2).
            // Result 4: (result 3) with its decimal part removed.
            call BlzSetUnitMaxHP(udg_SpellTargetUnit,R2I(((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_SpellTargetUnit)*1.)/(GetPlayerHandicapBJ(Player($B))*.01)))) // $B = 11
        endif
    endif
    call SetUnitOwner(udg_SpellTargetUnit,GetOwningPlayer(GetTriggerUnit()),true)
    set udg_TempUnit2=udg_SpellTargetUnit
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    call SetUnitLifePercentBJ(udg_SpellTargetUnit,'d')
endfunction

function Trig_Mediator_Balance_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A16X') // 'A16X': ability "Balance"
endfunction

function Trig_Mediator_Balance_FilterIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Mediator_Balance_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Mediator_Balance_FilterEnemyTargetable takes nothing returns boolean
    return GetBooleanAnd(Trig_Mediator_Balance_FilterIsEnemy(),Trig_Mediator_Balance_FilterNotInvulnerable())
endfunction

function Trig_Mediator_Balance_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Mediator_Balance_FilterNotMagicImmune takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_MAGIC_IMMUNE)==false)!=null
endfunction

function Trig_Mediator_Balance_FilterAliveNotImmune takes nothing returns boolean
    return GetBooleanAnd(Trig_Mediator_Balance_FilterIsAlive(),Trig_Mediator_Balance_FilterNotMagicImmune())
endfunction

function Trig_Mediator_Balance_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Mediator_Balance_FilterUnitCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Mediator_Balance_FilterAliveNotImmune(),Trig_Mediator_Balance_FilterNotStructure())
endfunction

function Trig_Mediator_Balance_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Mediator_Balance_FilterEnemyTargetable(),Trig_Mediator_Balance_FilterUnitCheck())
endfunction

function Trig_Mediator_Balance_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Mediator_Balance_DamageEnum takes nothing returns nothing
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
endfunction

function Trig_Mediator_Balance_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (facing in degrees of the triggering unit) plus ((loop counter A treated as a decimal-capable number) times
        // (60)).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,250.,(GetUnitFacing(GetTriggerUnit())+(I2R(GetForLoopIndexA())*60.)))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Weapons\\ProcMissile\\ProcMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempGroup=Group_UnitsInRangeOfLoc(480.,udg_TempPoint,Condition(function Trig_Mediator_Balance_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (3).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Mediator_Balance_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (1)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*1))
    endif
    // Result 1: (maximum health of the spell target) minus (current health of the spell target).
    // Result 2: (result 1) with its decimal part removed.
    // Result 3: (result 2) times (1).
    // Result 4: (udg_TempInteger) plus (result 3).
    set udg_TempInteger=(udg_TempInteger+(R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetSpellTargetUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit())))*1))
    set udg_TempReal=Prof_StaffPowerAlt(GetTriggerUnit())
    // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
    call ForGroupBJ(udg_TempGroup,function Trig_Mediator_Balance_DamageEnum)
    call DestroyGroup(udg_TempGroup)
endfunction

function Trig_Mediator_MarkForDeath_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A16W') // 'A16W': ability "!Mark for Death"
endfunction

function Trig_Mediator_MarkForDeath_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('A03C',GetSpellTargetUnit()) // 'A03C': ability "Marked for Death"
    call SetUnitAbilityLevelSwapped('A03C',GetSpellTargetUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A03C': ability "Marked for Death"
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Mediator takes nothing returns nothing
endfunction

function RegisterR11_Mediator_Clone_Reject takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mediator_Clone_Reject=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Mediator_Clone_Reject,EVENT_PLAYER_UNIT_SPELL_CAST)

call TriggerAddCondition(gg_trg_Mediator_Clone_Reject,Condition(function Trig_Mediator_Clone_Reject_Conditions))

call TriggerAddAction(gg_trg_Mediator_Clone_Reject,function Trig_Mediator_Clone_Reject_Actions)

endfunction




function RegisterR11_Mediator_Clone takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mediator_Clone=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Mediator_Clone,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Mediator_Clone,Condition(function Trig_Mediator_Clone_Conditions))

call TriggerAddAction(gg_trg_Mediator_Clone,function Trig_Mediator_Clone_Actions)

endfunction




function RegisterR11_Mediator_SpellShot takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mediator_SpellShot=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Mediator_SpellShot,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Mediator_SpellShot,Condition(function Trig_Mediator_SpellShot_Conditions))

call TriggerAddAction(gg_trg_Mediator_SpellShot,function Trig_Mediator_SpellShot_Actions)

endfunction




function RegisterR11_Mediator_Invitation takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mediator_Invitation=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Mediator_Invitation,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Mediator_Invitation,Condition(function Trig_Mediator_Invitation_Conditions))

call TriggerAddAction(gg_trg_Mediator_Invitation,function Trig_Mediator_Invitation_Actions)

endfunction




function RegisterR11_Mediator_Balance takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mediator_Balance=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Mediator_Balance,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Mediator_Balance,Condition(function Trig_Mediator_Balance_Conditions))

call TriggerAddAction(gg_trg_Mediator_Balance,function Trig_Mediator_Balance_Actions)

endfunction




function RegisterR11_Mediator_MarkForDeath takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mediator_MarkForDeath=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Mediator_MarkForDeath,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Mediator_MarkForDeath,Condition(function Trig_Mediator_MarkForDeath_Conditions))

call TriggerAddAction(gg_trg_Mediator_MarkForDeath,function Trig_Mediator_MarkForDeath_Actions)

endfunction




endlibrary

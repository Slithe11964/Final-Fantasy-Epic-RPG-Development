library TSpellInfernoRipple requires TLoc, TProf
function Trig_Spell_InfernoRipple_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A110') // 'A110': ability "!Inferno Ripple"
endfunction

function Trig_Spell_InfernoRipple_Cond_CasterIsHero_Center takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_InfernoRipple_Cond_CasterIsHero_Left takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_InfernoRipple_Cond_CasterIsHero_Right takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_InfernoRipple_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        // ((loop counter A treated as a decimal-capable number) times (200)) minus (120).
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,((I2R(GetForLoopIndexA())*200.)-120.),GetUnitFacing(GetTriggerUnit()))
        call RemoveLocation(udg_TempPoint2)
        call CreateNUnitsAtLoc(1,'u018',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetUnitFacing(GetTriggerUnit())) // 'u018': unit "Inferno Ripple"
        set udg_TempReal=Prof_RodPower(GetTriggerUnit())
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // ((maximum health of GetLastCreatedUnit()) times (udg_TempReal)) with its decimal part removed.
        call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_TempReal)))
        call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        // ((loop counter A) plus ((13) minus (udg_Difficulty)) treated as a decimal-capable number) times (0.25).
        call UnitApplyTimedLifeBJ((I2R((GetForLoopIndexA()+($D-udg_Difficulty)))*.25),'BTLF',GetLastCreatedUnit()) // $D = 13; 'BTLF': object name not found in map data
        if(Trig_Spell_InfernoRipple_Cond_CasterIsHero_Center())then
            call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
        else
            call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
        endif
        // (facing in degrees of the triggering unit) plus (90).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,(GetUnitFacing(GetTriggerUnit())+90.))
        call CreateNUnitsAtLoc(1,'u018',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetUnitFacing(GetTriggerUnit())) // 'u018': unit "Inferno Ripple"
        call RemoveLocation(udg_TempPoint2)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // ((maximum health of GetLastCreatedUnit()) times (udg_TempReal)) with its decimal part removed.
        call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_TempReal)))
        call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        // ((loop counter A) plus ((13) minus (udg_Difficulty)) treated as a decimal-capable number) times (0.25).
        call UnitApplyTimedLifeBJ((I2R((GetForLoopIndexA()+($D-udg_Difficulty)))*.25),'BTLF',GetLastCreatedUnit()) // $D = 13; 'BTLF': object name not found in map data
        if(Trig_Spell_InfernoRipple_Cond_CasterIsHero_Left())then
            call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
        else
            call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
        endif
        // (facing in degrees of the triggering unit) plus (270).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,(GetUnitFacing(GetTriggerUnit())+270.))
        call CreateNUnitsAtLoc(1,'u018',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetUnitFacing(GetTriggerUnit())) // 'u018': unit "Inferno Ripple"
        call RemoveLocation(udg_TempPoint2)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // ((maximum health of GetLastCreatedUnit()) times (udg_TempReal)) with its decimal part removed.
        call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_TempReal)))
        call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        // ((loop counter A) plus ((13) minus (udg_Difficulty)) treated as a decimal-capable number) times (0.25).
        call UnitApplyTimedLifeBJ((I2R((GetForLoopIndexA()+($D-udg_Difficulty)))*.25),'BTLF',GetLastCreatedUnit()) // $D = 13; 'BTLF': object name not found in map data
        if(Trig_Spell_InfernoRipple_Cond_CasterIsHero_Right())then
            call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
        else
            call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
        endif
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

function InitTrig_Spell_InfernoRipple takes nothing returns nothing
endfunction

endlibrary

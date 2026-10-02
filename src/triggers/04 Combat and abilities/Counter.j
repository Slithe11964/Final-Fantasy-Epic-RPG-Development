library TCounter requires TProf
function Trig_Counter_Attack_Strike_AngleNegative takes nothing returns boolean
    return(udg_TempReal<.0)
endfunction

function Trig_Counter_Attack_Strike_AngleOverHalf takes nothing returns boolean
    return(udg_TempReal>180.)
endfunction

function Trig_Counter_Attack_Strike_ThiefIsPlayerNormal takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_DodgeUnit),udg_PlayingPlayers))
endfunction

function Trig_Counter_Attack_Strike_ThiefIsPlayerMax takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_DodgeUnit),udg_PlayingPlayers))
endfunction

function Trig_Counter_Attack_Strike_HasMaxThievery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0KY',udg_DodgeUnit)>=6) // 'A0KY': ability "Thievery"
endfunction

function Trig_Counter_Attack_Strike_HasThieveryBuff takes nothing returns boolean
    return(UnitHasBuffBJ(udg_DodgeUnit,'B04D')) // 'B04D': buff tooltip "Thievery"
endfunction

function Trig_Counter_Attack_Strike_IsHero takes nothing returns boolean
    return(IsUnitType(udg_DodgeUnit,UNIT_TYPE_HERO))!=null
endfunction

function Trig_Counter_Attack_Strike_FacingTarget takes nothing returns boolean
    return(udg_TempReal<20.)
endfunction

function Trig_Counter_Attack_Strike_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(udg_DodgeUnit)
    set udg_TempPoint2=GetUnitLoc(udg_DodgeAttacker)
    // (AngleBetweenPoints(udg_TempPoint, udg_TempPoint2)) minus (facing in degrees of udg_DodgeUnit).
    set udg_TempReal=(AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)-GetUnitFacing(udg_DodgeUnit))
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing (udg_TempReal) by (360).
    set udg_TempReal=ModuloReal(udg_TempReal,360.)
    if(Trig_Counter_Attack_Strike_AngleNegative())then
        // (-1) times (udg_TempReal).
        set udg_TempReal=(-1.*udg_TempReal)
    endif
    if(Trig_Counter_Attack_Strike_AngleOverHalf())then
        // (360) minus (udg_TempReal).
        set udg_TempReal=(360.-udg_TempReal)
    endif
    if(Trig_Counter_Attack_Strike_FacingTarget())then
        call SetUnitAnimation(udg_DodgeUnit,"attack")
        call QueueUnitAnimationBJ(udg_DodgeUnit,"stand")
        if(Trig_Counter_Attack_Strike_HasThieveryBuff())then
            call AddSpecialEffectTargetUnitBJ("overhead",udg_DodgeAttacker,"UI\\Feedback\\GoldCredit\\GoldCredit.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            if(Trig_Counter_Attack_Strike_HasMaxThievery())then
                if(Trig_Counter_Attack_Strike_ThiefIsPlayerMax())then
                    call AdjustPlayerStateBJ(20,GetOwningPlayer(udg_DodgeUnit),PLAYER_STATE_RESOURCE_GOLD)
                endif
                call AdjustPlayerStateBJ(-20,GetOwningPlayer(udg_DodgeAttacker),PLAYER_STATE_RESOURCE_GOLD)
            else
                if(Trig_Counter_Attack_Strike_ThiefIsPlayerNormal())then
                    // (2) times (GetUnitAbilityLevelSwapped('A0KY', udg_DodgeUnit)).
                    call AdjustPlayerStateBJ((2*GetUnitAbilityLevelSwapped('A0KY',udg_DodgeUnit)),GetOwningPlayer(udg_DodgeUnit),PLAYER_STATE_RESOURCE_GOLD) // 'A0KY': ability "Thievery"
                endif
                // (-2) times (GetUnitAbilityLevelSwapped('A0KY', udg_DodgeUnit)).
                call AdjustPlayerStateBJ((-2*GetUnitAbilityLevelSwapped('A0KY',udg_DodgeUnit)),GetOwningPlayer(udg_DodgeAttacker),PLAYER_STATE_RESOURCE_GOLD) // 'A0KY': ability "Thievery"
            endif
        endif
        if(Trig_Counter_Attack_Strike_IsHero())then
            // Use 3 times the countering hero's Agility for this base amount.
            set udg_TempReal=(I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_DodgeUnit,true))*3.)
        else
            set udg_TempReal=350.
        endif
        // Add 150 to the base, then multiply by 1 + dagger proficiency / 8.
        // Each proficiency level adds 12.5% of that combined base.
        set udg_TempReal=(udg_TempReal+150.)*(.125*(8+Prof_GetLevel(GetTriggerUnit(),'R00B'))) // 'R00B': upgrade "Dagger"
        set udg_IsPhysicalAttack=true
        call UnitDamageTarget(udg_DodgeUnit,udg_DodgeAttacker,udg_TempReal,true,false,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_MEDIUM_CHOP)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Counter takes nothing returns nothing
endfunction

function RegisterR11_Counter_Attack_Strike takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Counter_Attack_Strike=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Counter_Attack_Strike,udg_DodgeFaceTimer[0])

call TriggerAddAction(gg_trg_Counter_Attack_Strike,function Trig_Counter_Attack_Strike_Actions)

endfunction




endlibrary

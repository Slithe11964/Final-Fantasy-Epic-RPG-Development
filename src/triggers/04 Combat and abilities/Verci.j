library TVerci requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Verci_Awaken=null
    trigger gg_trg_Verci_Phases=null
    trigger gg_trg_Verci_Death=null
    // Variables only this module uses.
    integer udg_VerciPhaseTimer=0
    real udg_VerciPhaseLife=0
endglobals

function Trig_Verci_Awaken_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetUnitInvulnerable(udg_Vercingetorix,false)
    call PauseUnitBJ(false,udg_Vercingetorix)
    set udg_VerciPhaseLife=75.
    set udg_VerciPhaseTimer=30
    call SetUnitAnimation(udg_Vercingetorix,"morph alternate")
    call EnableTrigger(gg_trg_Verci_Phases)
endfunction

function Trig_Verci_Phases_Conditions takes nothing returns boolean
    return(IsUnitHiddenBJ(udg_Vercingetorix)==false)
endfunction

function Trig_Verci_Phases_HasAutoBravery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WE',udg_Vercingetorix)>0) // 'A0WE': ability "Auto-Bravery"
endfunction

function Trig_Verci_Phases_HasAutoFaith takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WG',udg_Vercingetorix)>0) // 'A0WG': ability "Auto-Faith"
endfunction

function Trig_Verci_Phases_HasAutoHaste takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0GJ',udg_Vercingetorix)>0) // 'A0GJ': ability "Auto-Haste"
endfunction

function Trig_Verci_Phases_PhaseEnded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_Vercingetorix, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(udg_VerciPhaseTimer<=0)or(GetUnitLifePercent(udg_Vercingetorix)<=udg_VerciPhaseLife)
endfunction

function Trig_Verci_Phases_ShouldEndPhase takes nothing returns boolean
    return(Trig_Verci_Phases_PhaseEnded())
endfunction

function Trig_Verci_Phases_IsHeroUnit takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Verci_Phases_IsPlayerHero takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_ActivePlayers))
endfunction

function Trig_Verci_Phases_IsPlayerHeroUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Verci_Phases_IsHeroUnit(),Trig_Verci_Phases_IsPlayerHero())
endfunction

function Trig_Verci_Phases_NoHeroesNear takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Verci_Phases_IsFullLife takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_Vercingetorix, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_Vercingetorix)>=100.)
endfunction

function Trig_Verci_Phases_IsPhaseTwo takes nothing returns boolean
    return(udg_VerciPhaseLife<=60.)
endfunction

function Trig_Verci_Phases_IsPhaseThree takes nothing returns boolean
    return(udg_VerciPhaseLife<=40.)
endfunction

function Trig_Verci_Phases_IsPhaseFour takes nothing returns boolean
    return(udg_VerciPhaseLife<=20.)
endfunction

function Trig_Verci_Phases_PhaseTimerDone takes nothing returns boolean
    return(udg_VerciPhaseTimer<=0)
endfunction

function Trig_Verci_Phases_IsResting takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',udg_Vercingetorix)>0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Verci_Phases_Actions takes nothing returns nothing
    set udg_VerciPhaseTimer=(udg_VerciPhaseTimer-1)
    if(Trig_Verci_Phases_IsResting())then
        if(Trig_Verci_Phases_PhaseTimerDone())then
            if(Trig_Verci_Phases_IsFullLife())then
                set udg_TempPoint=GetUnitLoc(udg_Vercingetorix)
                set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Verci_Phases_IsPlayerHeroUnit))
                call RemoveLocation(udg_TempPoint)
                if(Trig_Verci_Phases_NoHeroesNear())then
                    call DestroyGroup(udg_TempGroup)
                    call DisableTrigger(GetTriggeringTrigger())
                    call EnableTrigger(gg_trg_Verci_Awaken)
                    call PauseUnitBJ(true,udg_Vercingetorix)
                    call SetUnitAnimation(udg_Vercingetorix,"stand alternate")
                    return
                else
                    call DestroyGroup(udg_TempGroup)
                endif
            endif
            call SetUnitInvulnerable(udg_Vercingetorix,false)
            call SetUnitAnimation(udg_Vercingetorix,"morph alternate")
            // Result 1: current health divided by maximum health for udg_Vercingetorix, times 100 (or 0 if the unit is
            // missing or its maximum is 0).
            // Result 2: (result 1) with its decimal part removed.
            // Result 3: (result 2) divided by (25).
            // Result 4: result 3 treated as a decimal-capable number.
            // Result 5: (result 4) minus (1).
            // Result 6: (result 5) times (25).
            set udg_VerciPhaseLife=((I2R((R2I(GetUnitLifePercent(udg_Vercingetorix))/ 25))-1)*25.)
            set udg_VerciPhaseTimer=25
            if(Trig_Verci_Phases_IsPhaseFour())then
                call UnitAddAbilityBJ('A1E0',udg_Vercingetorix) // 'A1E0': ability "!Wicked Whirl"
                call UnitAddAbilityBJ('A0GJ',udg_Vercingetorix) // 'A0GJ': ability "Auto-Haste"
                call UnitAddAbilityBJ('A0WE',udg_Vercingetorix) // 'A0WE': ability "Auto-Bravery"
                call UnitAddAbilityBJ('A0WG',udg_Vercingetorix) // 'A0WG': ability "Auto-Faith"
            else
                if(Trig_Verci_Phases_IsPhaseThree())then
                    call UnitAddAbilityBJ('A1E0',udg_Vercingetorix) // 'A1E0': ability "!Wicked Whirl"
                    call UnitAddAbilityBJ('A1DV',udg_Vercingetorix) // 'A1DV': ability "Summon Spartacus"
                    call UnitAddAbilityBJ('A0GJ',udg_Vercingetorix) // 'A0GJ': ability "Auto-Haste"
                else
                    if(Trig_Verci_Phases_IsPhaseTwo())then
                        call UnitAddAbilityBJ('A1DV',udg_Vercingetorix) // 'A1DV': ability "Summon Spartacus"
                    endif
                endif
            endif
        endif
    else
        if(Trig_Verci_Phases_ShouldEndPhase())then
            set udg_DispelTarget=udg_Vercingetorix
            call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
            call SetUnitInvulnerable(udg_Vercingetorix,true)
            call UnitRemoveAbilityBJ('A1E0',udg_Vercingetorix) // 'A1E0': ability "!Wicked Whirl"
            call UnitRemoveAbilityBJ('A1DV',udg_Vercingetorix) // 'A1DV': ability "Summon Spartacus"
            call UnitRemoveAbilityBJ('A0GJ',udg_Vercingetorix) // 'A0GJ': ability "Auto-Haste"
            call UnitRemoveAbilityBJ('A0WE',udg_Vercingetorix) // 'A0WE': ability "Auto-Bravery"
            call UnitRemoveAbilityBJ('A0WG',udg_Vercingetorix) // 'A0WG': ability "Auto-Faith"
            call IssueImmediateOrderBJ(udg_Vercingetorix,"channel")
            call SetUnitAnimation(udg_Vercingetorix,"morph")
            call QueueUnitAnimationBJ(udg_Vercingetorix,"stand alternate")
            set udg_VerciPhaseTimer=9
        else
            if(Trig_Verci_Phases_HasAutoHaste())then
                call UnitRemoveBuffBJ('B00F',udg_Vercingetorix) // 'B00F': buff "Haste"
                call UnitRemoveBuffBJ('Bslo',udg_Vercingetorix) // 'Bslo': buff tooltip "Slow"
                if(Trig_Verci_Phases_HasAutoBravery())then
                    call UnitRemoveBuffBJ('B01W',udg_Vercingetorix) // 'B01W': buff "Bravery"
                    call UnitRemoveBuffBJ('B06H',udg_Vercingetorix) // 'B06H': buff "Pain"
                endif
                if(Trig_Verci_Phases_HasAutoFaith())then
                    call UnitRemoveBuffBJ('B05A',udg_Vercingetorix) // 'B05A': buff "Faith"
                    call UnitRemoveBuffBJ('B06I',udg_Vercingetorix) // 'B06I': buff "Fog"
                endif
            endif
        endif
    endif
endfunction

function Trig_Verci_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Verci_Phases)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Verci automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Verci (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Verci takes nothing returns nothing
endfunction

function Register_Verci_Awaken takes nothing returns nothing
    set gg_trg_Verci_Awaken=CreateTrigger()
    call DisableTrigger(gg_trg_Verci_Awaken)
    call TriggerAddAction(gg_trg_Verci_Awaken,function Trig_Verci_Awaken_Actions)
endfunction

function Register_Verci_Phases takes nothing returns nothing
    set gg_trg_Verci_Phases=CreateTrigger()
    call DisableTrigger(gg_trg_Verci_Phases)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Verci_Phases,1.)
    call TriggerAddCondition(gg_trg_Verci_Phases,Condition(function Trig_Verci_Phases_Conditions))
    call TriggerAddAction(gg_trg_Verci_Phases,function Trig_Verci_Phases_Actions)
endfunction

function Register_Verci_Death takes nothing returns nothing
    set gg_trg_Verci_Death=CreateTrigger()
    call TriggerAddAction(gg_trg_Verci_Death,function Trig_Verci_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Verci takes nothing returns nothing
    call Register_Verci_Awaken() // starts off; enabled by Verci, Hunt_Encounters
    call Register_Verci_Phases() // starts off; enabled by Verci; disabled by Verci
    call Register_Verci_Death() // used by Hunt_Encounters
endfunction

endlibrary

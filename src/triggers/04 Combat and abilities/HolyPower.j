library THolyPower requires TSpellShared
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HolyPower_Mastery_Track=null
    trigger gg_trg_HolyPower_Mastery_Start=null
endglobals

function Trig_HolyPower_Mastery_Track_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_EnduranceAwardGroup))
endfunction

function Trig_HolyPower_Mastery_Track_GroupEmptyAfterGoal takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_EnduranceAwardGroup))
endfunction

function Trig_HolyPower_Mastery_Track_MasteryGoalReached takes nothing returns boolean
    return(udg_EnduranceDamageCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=$FA0)and(udg_EnduranceManaCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=$FA0) // $FA0 = 4000
endfunction

function Trig_HolyPower_Mastery_Track_HasHealDone takes nothing returns boolean
    return(udg_SpellManaCost>0)
endfunction

function Trig_HolyPower_Mastery_Track_GroupEmptyAfterLoss takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_EnduranceAwardGroup))
endfunction

function Trig_HolyPower_Mastery_Track_LostEnduranceAura takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B018')==false) // 'B018': buff tooltip "Holy Power"
endfunction

function Trig_HolyPower_Mastery_Track_Actions takes nothing returns nothing
    if(Trig_HolyPower_Mastery_Track_LostEnduranceAura())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_EnduranceAwardGroup)
        if(Trig_HolyPower_Mastery_Track_GroupEmptyAfterLoss())then
            call DisableTrigger(GetTriggeringTrigger())
        endif
    else
        call Spell_StoreManaCost()
        if(Trig_HolyPower_Mastery_Track_HasHealDone())then
            set udg_EnduranceDamageCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EnduranceDamageCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_SpellManaCost)
            if(Trig_HolyPower_Mastery_Track_MasteryGoalReached())then
                call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[9])
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call GroupRemoveUnitSimple(GetTriggerUnit(),udg_EnduranceAwardGroup)
                if(Trig_HolyPower_Mastery_Track_GroupEmptyAfterGoal())then
                    call DisableTrigger(GetTriggeringTrigger())
                endif
            endif
        endif
    endif
endfunction

function Trig_HolyPower_Mastery_Start_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A05W')and(GetUnitAbilityLevelSwapped('A05W',GetTriggerUnit())>=6)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[9])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3) // 'A05W': ability "!Holy Power"; 'A02F': ability "Mastery"
endfunction

function Trig_HolyPower_Mastery_Start_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_EnduranceAwardGroup)
    set udg_EnduranceDamageCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
    set udg_EnduranceManaCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
    call EnableTrigger(gg_trg_HolyPower_Mastery_Track)
endfunction

// World Editor calls InitTrig_HolyPower automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HolyPower (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HolyPower takes nothing returns nothing
endfunction

function Register_HolyPower_Mastery_Track takes nothing returns nothing
    set gg_trg_HolyPower_Mastery_Track=CreateTrigger()
    call DisableTrigger(gg_trg_HolyPower_Mastery_Track)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HolyPower_Mastery_Track,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_HolyPower_Mastery_Track,Condition(function Trig_HolyPower_Mastery_Track_Conditions))
    call TriggerAddAction(gg_trg_HolyPower_Mastery_Track,function Trig_HolyPower_Mastery_Track_Actions)
endfunction

function Register_HolyPower_Mastery_Start takes nothing returns nothing
    set gg_trg_HolyPower_Mastery_Start=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HolyPower_Mastery_Start,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_HolyPower_Mastery_Start,Condition(function Trig_HolyPower_Mastery_Start_Conditions))
    call TriggerAddAction(gg_trg_HolyPower_Mastery_Start,function Trig_HolyPower_Mastery_Start_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HolyPower takes nothing returns nothing
    call Register_HolyPower_Mastery_Track() // starts off; enabled by HolyPower; disabled by Damage
    call Register_HolyPower_Mastery_Start()
endfunction

endlibrary

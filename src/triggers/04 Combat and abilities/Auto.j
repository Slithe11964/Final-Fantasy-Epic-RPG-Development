library TAuto requires TAbil, TProf, TWait
function Trig_Auto_Potion_AI_Conditions takes nothing returns boolean
    // A random whole number from 1 through 5.
    return(GetRandomInt(1,5)==1)
endfunction

function Trig_Auto_Potion_AI_AttackerHurt takes nothing returns boolean
    // Result 1: current health divided by maximum health for GetAttacker(), times 100 (or 0 if the unit is missing
    // or its maximum is 0).
    return((IsPlayerInForce(GetOwningPlayer(GetAttacker()),udg_PlayingPlayers)==false)and(IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(GetUnitLifePercent(GetAttacker())<50.))!=null
endfunction

function Trig_Auto_Potion_AI_VictimHurt takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitLifePercent(GetTriggerUnit())<50.))!=null
endfunction

function Trig_Auto_Potion_AI_CantUsePotion takes nothing returns boolean
    return((IsUnitType(udg_CurrentHero,UNIT_TYPE_UNDEAD))or(UnitHasBuffBJ(udg_CurrentHero,'B05T')))!=null // 'B05T': buff tooltip "Zombie"
endfunction

function Trig_Auto_Potion_AI_Cond_CantUsePotion takes nothing returns boolean
    return(Trig_Auto_Potion_AI_CantUsePotion())
endfunction

function Trig_Auto_Potion_AI_HasPotion takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'phea')) // 'phea': item "Potion"
endfunction

function Trig_Auto_Potion_AI_HasHiPotion takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'pghe')) // 'pghe': item "Hi-Potion"
endfunction

function Trig_Auto_Potion_AI_HasMegaPotion takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I001')) // 'I001': item "Mega Potion"
endfunction

function Trig_Auto_Potion_AI_HasXPotion takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I000')) // 'I000': item "X-Potion"
endfunction

function Trig_Auto_Potion_AI_HasNectar takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I02V')) // 'I02V': item "Nectar"
endfunction

function Trig_Auto_Potion_AI_HasGreaterNectar takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I02X')) // 'I02X': item "Greater Nectar"
endfunction

function Trig_Auto_Potion_AI_HasDebuff takes nothing returns boolean
    return(UnitHasBuffBJ(udg_CurrentHero,'B00P'))or(UnitHasBuffBJ(udg_CurrentHero,'Bslo'))or(UnitHasBuffBJ(udg_CurrentHero,'B02C'))or(UnitHasBuffBJ(udg_CurrentHero,'B00I'))or(UnitHasBuffBJ(udg_CurrentHero,'B05M'))or(UnitHasBuffBJ(udg_CurrentHero,'B05N'))or(UnitHasBuffBJ(udg_CurrentHero,'B003'))or(UnitHasBuffBJ(udg_CurrentHero,'B01U'))or(UnitHasBuffBJ(udg_CurrentHero,'B002'))or(UnitHasBuffBJ(udg_CurrentHero,'B06J'))or(UnitHasBuffBJ(udg_CurrentHero,'B06K'))or(UnitHasBuffBJ(udg_CurrentHero,'B06H'))or(UnitHasBuffBJ(udg_CurrentHero,'B06I')) // 'B00P': buff tooltip "Blind"; 'Bslo': buff tooltip "Slow"; 'B02C': buff tooltip "Silence"; 'B00I': buff tooltip "Hell Ivy"; 'B05M': buff tooltip "Immobilize"; 'B05N': buff tooltip "Immobilize"; 'B003': buff tooltip "Oil"; 'B01U': buff tooltip "Bio"; 'B002': buff tooltip "Burn"; 'B06J': buff tooltip "Deprotect"; 'B06K': buff tooltip "Deshell"; 'B06H': buff "Pain"; 'B06I': buff "Fog"
endfunction

function Trig_Auto_Potion_AI_NeedsRemedy takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0DI'))and(Trig_Auto_Potion_AI_HasDebuff()) // 'I0DI': item "Remedy"
endfunction

function Trig_Auto_Potion_AI_Actions takes nothing returns nothing
    if(Trig_Auto_Potion_AI_VictimHurt())then
        set udg_CurrentHero=GetTriggerUnit()
    else
        if(Trig_Auto_Potion_AI_AttackerHurt())then
            set udg_CurrentHero=GetAttacker()
        else
            return
        endif
    endif
    if(Trig_Auto_Potion_AI_Cond_CantUsePotion())then
        return
    endif
    if(Trig_Auto_Potion_AI_HasPotion())then
        call UnitUseItem(udg_CurrentHero,GetItemOfTypeFromUnitBJ(udg_CurrentHero,'phea')) // 'phea': item "Potion"
        return
    endif
    if(Trig_Auto_Potion_AI_HasHiPotion())then
        call UnitUseItem(udg_CurrentHero,GetItemOfTypeFromUnitBJ(udg_CurrentHero,'pghe')) // 'pghe': item "Hi-Potion"
        return
    endif
    if(Trig_Auto_Potion_AI_HasMegaPotion())then
        call UnitUseItem(udg_CurrentHero,GetItemOfTypeFromUnitBJ(udg_CurrentHero,'I001')) // 'I001': item "Mega Potion"
        return
    endif
    if(Trig_Auto_Potion_AI_HasXPotion())then
        call UnitUseItem(udg_CurrentHero,GetItemOfTypeFromUnitBJ(udg_CurrentHero,'I000')) // 'I000': item "X-Potion"
        return
    endif
    if(Trig_Auto_Potion_AI_HasNectar())then
        call UnitUseItem(udg_CurrentHero,GetItemOfTypeFromUnitBJ(udg_CurrentHero,'I02V')) // 'I02V': item "Nectar"
        return
    endif
    if(Trig_Auto_Potion_AI_HasGreaterNectar())then
        call UnitUseItem(udg_CurrentHero,GetItemOfTypeFromUnitBJ(udg_CurrentHero,'I02X')) // 'I02X': item "Greater Nectar"
        return
    endif
    if(Trig_Auto_Potion_AI_NeedsRemedy())then
        call UnitUseItem(udg_CurrentHero,GetItemOfTypeFromUnitBJ(udg_CurrentHero,'I0DI')) // 'I0DI': item "Remedy"
        return
    endif
endfunction

function Trig_Auto_Crossbow_Volley_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A1A3' // 'A1A3': ability "Multi-Arrowwave"
endfunction

function Trig_Auto_Crossbow_Volley_Actions takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local player owningPlayer=GetOwningPlayer(triggeringUnit)
    local real x=GetUnitX(triggeringUnit)
    local real y=GetUnitY(triggeringUnit)
    local integer l_abilId=GetSpellAbilityId()
    local integer l_power
    local integer l_upgrades
    local real damageAmount
    local unit l_dummy=CreateUnit(owningPlayer,'h01B',x,y,.0) // 'h01B': unit "Proxy Dummy"
    local integer l_dummyId=GetHandleId(l_dummy)
    // (BlzGetAbilityManaCost(l_abilId, Abil_GetLevel(triggeringUnit, l_abilId))) plus ((Agility of triggeringUnit) times (2)).
    set l_power=BlzGetAbilityManaCost(l_abilId,Abil_GetLevel(triggeringUnit,l_abilId))+(GetHeroAgi(triggeringUnit,true)*2)
    // ((10) plus (Prof_GetLevel(triggeringUnit, 'R000'))) plus (Prof_GetLevel(triggeringUnit, 'R002')).
    set l_upgrades=$A+Prof_GetLevel(triggeringUnit,'R000')+Prof_GetLevel(triggeringUnit,'R002') // $A = 10; 'R000': upgrade "Tools"; 'R002': upgrade "Bow"
    // ((l_power) times (l_upgrades)) times (0.1).
    set damageAmount=l_power*l_upgrades*.1
    call SaveUnitHandle(udg_ProxyDamageHash,l_dummyId,0,triggeringUnit)
    call SaveReal(udg_ProxyDamageHash,l_dummyId,1,damageAmount)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,2)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,3,3)
    call ShowUnit(l_dummy,false)
    call UnitAddAbility(l_dummy,'A0QR') // 'A0QR': ability "Arrowwave"
    call UnitApplyTimedLife(l_dummy,'BTLF',3.) // 'BTLF': object name not found in map data
    call IssueImmediateOrderById(l_dummy,$D022E) // $D022E = 852526
    call Wait_Polled(.5)
    set x=GetUnitX(triggeringUnit)
    set y=GetUnitY(triggeringUnit)
    call SetUnitX(l_dummy,x)
    call SetUnitY(l_dummy,y)
    call IssueImmediateOrderById(l_dummy,$D022E) // $D022E = 852526
    call Wait_Polled(.5)
    set x=GetUnitX(triggeringUnit)
    set y=GetUnitY(triggeringUnit)
    call SetUnitX(l_dummy,x)
    call SetUnitY(l_dummy,y)
    call IssueImmediateOrderById(l_dummy,$D022E) // $D022E = 852526
    set triggeringUnit=null
    set l_dummy=null
    set owningPlayer=null
endfunction

// World Editor calls InitTrig_Auto automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Auto_Part1 / RegisterTriggers_Auto_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Auto takes nothing returns nothing
endfunction

function Register_Auto_Potion_AI takes nothing returns nothing
    set gg_trg_Auto_Potion_AI=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Auto_Potion_AI,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Auto_Potion_AI,Condition(function Trig_Auto_Potion_AI_Conditions))
    call TriggerAddAction(gg_trg_Auto_Potion_AI,function Trig_Auto_Potion_AI_Actions)
endfunction

function Register_Auto_Crossbow_Volley takes nothing returns nothing
    set gg_trg_Auto_Crossbow_Volley=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Auto_Crossbow_Volley,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Auto_Crossbow_Volley,Condition(function Trig_Auto_Crossbow_Volley_Conditions))
    call TriggerAddAction(gg_trg_Auto_Crossbow_Volley,function Trig_Auto_Crossbow_Volley_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Auto_Part1 takes nothing returns nothing
    call Register_Auto_Potion_AI()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Auto_Part2 takes nothing returns nothing
    call Register_Auto_Crossbow_Volley()
endfunction

endlibrary

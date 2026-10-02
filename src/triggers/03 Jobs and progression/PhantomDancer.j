library TPhantomDancer requires TLoc, TWait
function Trig_PhantomDancer_Blink_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(GetAttacker())
    // The remainder after dividing ((facing in degrees of GetAttacker()) plus (180)) by (360).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,ModuloReal((GetUnitFacing(GetAttacker())+180.),360.))
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLocFacingLocBJ(GetTriggerUnit(),udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(4.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_PhantomDancer_Berserk_Actions takes nothing returns nothing
    call IssueImmediateOrderBJ(GetTriggerUnit(),"berserk")
endfunction

// World Editor calls InitTrig_PhantomDancer automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PhantomDancer (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PhantomDancer takes nothing returns nothing
endfunction

function Register_PhantomDancer_Blink takes nothing returns nothing
    set gg_trg_PhantomDancer_Blink=CreateTrigger()
    call DisableTrigger(gg_trg_PhantomDancer_Blink)
    call TriggerAddAction(gg_trg_PhantomDancer_Blink,function Trig_PhantomDancer_Blink_Actions)
endfunction

function Register_PhantomDancer_Berserk takes nothing returns nothing
    set gg_trg_PhantomDancer_Berserk=CreateTrigger()
    call DisableTrigger(gg_trg_PhantomDancer_Berserk)
    call TriggerAddAction(gg_trg_PhantomDancer_Berserk,function Trig_PhantomDancer_Berserk_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PhantomDancer takes nothing returns nothing
    call Register_PhantomDancer_Blink()
    call Register_PhantomDancer_Berserk()
endfunction

endlibrary

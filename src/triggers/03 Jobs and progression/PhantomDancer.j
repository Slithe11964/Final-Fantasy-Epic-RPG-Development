library TPhantomDancer requires TLoc, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_PhantomDancer_Blink=null
    trigger gg_trg_PhantomDancer_Berserk=null
endglobals

function Trig_PhantomDancer_Blink_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetUnitLoc(GetAttacker())
    // The remainder after dividing ((facing in degrees of GetAttacker()) plus (180)) by (360).
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,128.,ModuloReal((GetUnitFacing(GetAttacker())+180.),360.))
    call AddSpecialEffectLocBJ(l_tempPoint2,"Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLocFacingLocBJ(GetTriggerUnit(),l_tempPoint2,l_tempPoint)
    call RemoveLocation(l_tempPoint2)
    call RemoveLocation(l_tempPoint)
    call Wait_Polled(4.)
    call EnableTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
    set l_tempPoint2=null
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
    call Register_PhantomDancer_Blink() // starts off; enabled by Hunt_Encounters
    call Register_PhantomDancer_Berserk() // starts off; enabled by Hunt_Encounters
endfunction

endlibrary

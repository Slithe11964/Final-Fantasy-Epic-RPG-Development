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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PhantomDancer takes nothing returns nothing
endfunction
function RegisterR11_PhantomDancer_Blink takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PhantomDancer_Blink=CreateTrigger()
    call DisableTrigger(gg_trg_PhantomDancer_Blink)
    call TriggerAddAction(gg_trg_PhantomDancer_Blink,function Trig_PhantomDancer_Blink_Actions)
endfunction
function RegisterR11_PhantomDancer_Berserk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PhantomDancer_Berserk=CreateTrigger()
    call DisableTrigger(gg_trg_PhantomDancer_Berserk)
    call TriggerAddAction(gg_trg_PhantomDancer_Berserk,function Trig_PhantomDancer_Berserk_Actions)
endfunction




endlibrary

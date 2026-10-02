library TShadow requires TShadowCombat, TShadowHiring, TShadowLifecycle, TShadowLoyalty, TShadowSupport
function InitTrig_Shadow takes nothing returns nothing
endfunction
function RegisterR11_Shadow_FumaShuriken takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_FumaShuriken=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shadow_FumaShuriken,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shadow_FumaShuriken,Condition(function Trig_Shadow_FumaShuriken_Conditions))
    call TriggerAddAction(gg_trg_Shadow_FumaShuriken,function Trig_Shadow_FumaShuriken_Actions)
endfunction
function RegisterR11_Shadow_Hire takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_Hire=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Hire)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shadow_Hire,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Shadow_Hire,Condition(function Trig_Shadow_Hire_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Hire,function Trig_Shadow_Hire_Actions)
endfunction
function RegisterR11_Shadow_Disband takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_Disband=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Disband)
    call TriggerAddCondition(gg_trg_Shadow_Disband,Condition(function Trig_Shadow_Disband_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Disband,function Trig_Shadow_Disband_Actions)
endfunction
function RegisterR11_Shadow_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Shadow_Init,2.)
    call TriggerAddAction(gg_trg_Shadow_Init,function Trig_Shadow_Init_Actions)
endfunction
function RegisterR11_Shadow_FirstAppear takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_FirstAppear=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_FirstAppear)
    call TriggerAddAction(gg_trg_Shadow_FirstAppear,function Trig_Shadow_FirstAppear_Actions)
endfunction
function RegisterR11_Shadow_Intro takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Intro)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(7),true)
    call TriggerAddCondition(gg_trg_Shadow_Intro,Condition(function Trig_Shadow_Intro_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Intro,function Trig_Shadow_Intro_Actions)
endfunction
function RegisterR11_Shadow_Respawn takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_Respawn=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Respawn)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Shadow_Respawn,udg_ShadowTimer)
    call TriggerAddAction(gg_trg_Shadow_Respawn,function Trig_Shadow_Respawn_Actions)
endfunction
function RegisterR11_Shadow_Leave takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_Leave=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Shadow_Leave,udg_ShadowTimer)
    call TriggerAddAction(gg_trg_Shadow_Leave,function Trig_Shadow_Leave_Actions)
endfunction
function RegisterR11_Shadow_NearbyDelay takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_NearbyDelay=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_NearbyDelay)
    call TriggerAddCondition(gg_trg_Shadow_NearbyDelay,Condition(function Trig_Shadow_NearbyDelay_Conditions))
    call TriggerAddAction(gg_trg_Shadow_NearbyDelay,function Trig_Shadow_NearbyDelay_Actions)
endfunction
function RegisterR11_Shadow_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Death)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Shadow_Death,Player($A),EVENT_PLAYER_UNIT_DEATH) // $A = 10
    call TriggerAddCondition(gg_trg_Shadow_Death,Condition(function Trig_Shadow_Death_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Death,function Trig_Shadow_Death_Actions)
endfunction
function RegisterR11_Shadow_LoyaltyTick takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_LoyaltyTick=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_LoyaltyTick)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Shadow_LoyaltyTick,10.)
    call TriggerAddCondition(gg_trg_Shadow_LoyaltyTick,Condition(function Trig_Shadow_LoyaltyTick_Conditions))
    call TriggerAddAction(gg_trg_Shadow_LoyaltyTick,function Trig_Shadow_LoyaltyTick_Actions)
endfunction
function RegisterR11_Shadow_KillCount takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_KillCount=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_KillCount)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Shadow_KillCount,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Shadow_KillCount,Condition(function Trig_Shadow_KillCount_Conditions))
    call TriggerAddAction(gg_trg_Shadow_KillCount,function Trig_Shadow_KillCount_Actions)
endfunction
function RegisterR11_Shadow_AttackedByParty takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_AttackedByParty=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_AttackedByParty)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Shadow_AttackedByParty,Player($A),EVENT_PLAYER_UNIT_ATTACKED) // $A = 10
    call TriggerAddCondition(gg_trg_Shadow_AttackedByParty,Condition(function Trig_Shadow_AttackedByParty_Conditions))
    call TriggerAddAction(gg_trg_Shadow_AttackedByParty,function Trig_Shadow_AttackedByParty_Actions)
endfunction
function RegisterR11_Shadow_HealedBonus takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_HealedBonus=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_HealedBonus)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shadow_HealedBonus,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shadow_HealedBonus,Condition(function Trig_Shadow_HealedBonus_Conditions))
    call TriggerAddAction(gg_trg_Shadow_HealedBonus,function Trig_Shadow_HealedBonus_Actions)
endfunction
function RegisterR11_Shadow_HeroDrink takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shadow_HeroDrink=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_HeroDrink)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shadow_HeroDrink,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shadow_HeroDrink,Condition(function Trig_Shadow_HeroDrink_Conditions))
    call TriggerAddAction(gg_trg_Shadow_HeroDrink,function Trig_Shadow_HeroDrink_Actions)
endfunction





endlibrary

library TQuFrog requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_QuFrog_DrainTick=null
    trigger gg_trg_QuFrog_Death=null
    // Variables only this module uses.
    lightning array udg_QuDrainLightning
    effect array udg_QuDrainEffect
endglobals

function Trig_QuFrog_DrainTick_Cond_Frog1Boost takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)and(udg_QuFrogDrainCount>=$F) // $F = 15
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog1Drain takes nothing returns boolean
    // A random whole number from 1 through 3.
    return(GetRandomInt(1,3)<=1)or(udg_QuFrogDrainCount>=21)or(Trig_QuFrog_DrainTick_Cond_Frog1Boost())
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog1Ready takes nothing returns boolean
    return(Trig_QuFrog_DrainTick_Cond_Frog1Drain())
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog2Boost takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)and(udg_QuFrogDrainCount>=$F) // $F = 15
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog2Drain takes nothing returns boolean
    // A random whole number from 1 through 3.
    return(GetRandomInt(1,3)<=1)or(udg_QuFrogDrainCount>=21)or(Trig_QuFrog_DrainTick_Cond_Frog2Boost())
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog2Ready takes nothing returns boolean
    return(Trig_QuFrog_DrainTick_Cond_Frog2Drain())
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog3Boost takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)and(udg_QuFrogDrainCount>=$F) // $F = 15
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog3Drain takes nothing returns boolean
    // A random whole number from 1 through 3.
    return(GetRandomInt(1,3)<=1)or(udg_QuFrogDrainCount>=21)or(Trig_QuFrog_DrainTick_Cond_Frog3Boost())
endfunction

function Trig_QuFrog_DrainTick_Cond_Frog3Ready takes nothing returns boolean
    return(Trig_QuFrog_DrainTick_Cond_Frog3Drain())
endfunction

function Trig_QuFrog_DrainTick_Cond_AllFrogsDraining takes nothing returns boolean
    return(udg_QuFrogDraining[1])and(udg_QuFrogDraining[2])and(udg_QuFrogDraining[3])
endfunction

function Trig_QuFrog_DrainTick_Cond_FrogLinkActive takes nothing returns boolean
    return(udg_QuFrogDraining[GetForLoopIndexA()])
endfunction

function Trig_QuFrog_DrainTick_Actions takes nothing returns nothing
    set udg_QuFrogDrainCount=(udg_QuFrogDrainCount+1)
    if(Trig_QuFrog_DrainTick_Cond_Frog1Ready())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n039_0083)
        set udg_QuDrainLightning[1]=AddLightningLoc("DRAL",udg_TempPoint,udg_QuFrogLoc)
        call SetLightningColorBJ(GetLastCreatedLightningBJ(),.5,.5,1,1)
        set udg_QuDrainEffect[1]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl")
        set udg_QuDrainEffect[2]=AddSpecialEffectLocBJ(udg_QuFrogLoc,"Abilities\\Spells\\Other\\Drain\\DrainTarget.mdl")
        call RemoveLocation(udg_TempPoint)
        set udg_QuFrogDraining[1]=true
    endif
    if(Trig_QuFrog_DrainTick_Cond_Frog2Ready())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n039_0095)
        set udg_QuDrainLightning[2]=AddLightningLoc("DRAL",udg_TempPoint,udg_QuFrogLoc)
        call SetLightningColorBJ(GetLastCreatedLightningBJ(),.5,.5,1,1)
        set udg_QuDrainEffect[3]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl")
        set udg_QuDrainEffect[4]=AddSpecialEffectLocBJ(udg_QuFrogLoc,"Abilities\\Spells\\Other\\Drain\\DrainTarget.mdl")
        call RemoveLocation(udg_TempPoint)
        set udg_QuFrogDraining[2]=true
    endif
    if(Trig_QuFrog_DrainTick_Cond_Frog3Ready())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n039_0175)
        set udg_QuDrainLightning[3]=AddLightningLoc("DRAL",udg_TempPoint,udg_QuFrogLoc)
        call SetLightningColorBJ(GetLastCreatedLightningBJ(),.5,.5,1,1)
        set udg_QuDrainEffect[5]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl")
        set udg_QuDrainEffect[6]=AddSpecialEffectLocBJ(udg_QuFrogLoc,"Abilities\\Spells\\Other\\Drain\\DrainTarget.mdl")
        call RemoveLocation(udg_TempPoint)
        set udg_QuFrogDraining[3]=true
    endif
    if(Trig_QuFrog_DrainTick_Cond_AllFrogsDraining())then
        call SetUnitInvulnerable(gg_unit_n03A_0136,false)
        set udg_QuFrogDrainCount=0
    endif
    call Wait_Polled(1.)
    call SetUnitInvulnerable(gg_unit_n03A_0136,true)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=3
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_QuFrog_DrainTick_Cond_FrogLinkActive())then
            call DestroyLightningBJ(udg_QuDrainLightning[GetForLoopIndexA()])
            // ((loop counter A) times (2)) minus (1).
            call DestroyEffectBJ(udg_QuDrainEffect[((GetForLoopIndexA()*2)-1)])
            // (loop counter A) times (2).
            call DestroyEffectBJ(udg_QuDrainEffect[(GetForLoopIndexA()*2)])
            set udg_QuFrogDraining[GetForLoopIndexA()]=false
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

function Trig_QuFrog_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_QuFrog_DrainTick)
    call CreateItemLoc('I07I',udg_QuFrogLoc) // 'I07I': item "Qu's Frog Head"
    call RemoveLocation(udg_QuFrogLoc)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call DestroyLightningBJ(udg_QuDrainLightning[1])
    call DestroyLightningBJ(udg_QuDrainLightning[2])
    call DestroyLightningBJ(udg_QuDrainLightning[3])
    set udg_QuFrogDraining[1]=false
    set udg_QuFrogDraining[2]=false
    set udg_QuFrogDraining[3]=false
    set udg_QuFrogDrainCount=0
    call DestroyEffectBJ(udg_QuDrainEffect[1])
    call DestroyEffectBJ(udg_QuDrainEffect[2])
    call DestroyEffectBJ(udg_QuDrainEffect[3])
    call DestroyEffectBJ(udg_QuDrainEffect[4])
    call DestroyEffectBJ(udg_QuDrainEffect[5])
    call DestroyEffectBJ(udg_QuDrainEffect[6])
    call KillUnit(gg_unit_n039_0083)
    call KillUnit(gg_unit_n039_0095)
    call KillUnit(gg_unit_n039_0175)
    call EnableTrigger(gg_trg_FrogHead_TurnIn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_QuFrog automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_QuFrog (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_QuFrog takes nothing returns nothing
endfunction

function Register_QuFrog_DrainTick takes nothing returns nothing
    set gg_trg_QuFrog_DrainTick=CreateTrigger()
    call DisableTrigger(gg_trg_QuFrog_DrainTick)
    call TriggerRegisterTimerEventPeriodic(gg_trg_QuFrog_DrainTick,2.)
    call TriggerAddAction(gg_trg_QuFrog_DrainTick,function Trig_QuFrog_DrainTick_Actions)
endfunction

function Register_QuFrog_Death takes nothing returns nothing
    set gg_trg_QuFrog_Death=CreateTrigger()
    call DisableTrigger(gg_trg_QuFrog_Death)
    call TriggerRegisterUnitEvent(gg_trg_QuFrog_Death,gg_unit_n03A_0136,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_QuFrog_Death,function Trig_QuFrog_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_QuFrog takes nothing returns nothing
    call Register_QuFrog_DrainTick() // starts off; enabled by DeathSeeker; disabled by QuFrog
    call Register_QuFrog_Death() // starts off; enabled by DeathSeeker
endfunction

endlibrary

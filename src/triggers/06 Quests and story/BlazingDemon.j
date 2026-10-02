library TBlazingDemon requires TCam, TCine, TLoc, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_BlazingDemon_Hide=null
    trigger gg_trg_BlazingDemon_Appear=null
    trigger gg_trg_BlazingDemon_FullHeat=null
endglobals

function Trig_BlazingDemon_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00G_0220)
    call SetUnitInvulnerable(gg_unit_U00G_0220,true)
    call PauseUnitBJ(true,gg_unit_U00G_0220)
    set udg_DarkFireStage=0
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_BlazingDemon_Appear_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_BlazingDemon_Appear_Actions takes nothing returns nothing
    set udg_TempPoint2=GetUnitLoc(udg_CinematicActor)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00G_0220,udg_TempPoint,udg_TempPoint2)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    if(Trig_BlazingDemon_Appear_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00G_0220,.0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_U00G_0220)
        call Wait_Polled(2)
        call Text_Say(udg_CinematicActor,"You... have you been watching us take down this fiery demon?",false)
        call Text_Say(gg_unit_U00G_0220,"Hmph. Those were weak flames.",false)
        call Text_Say(gg_unit_U00G_0220,"Yes I've been watching you. I figured now you seem more prepared to light my fires.",false)
        call Text_Say(gg_unit_U00G_0220,"Don't waste your time with small fry like this. You knew we were going to fight sooner or later ever since you held out against me.",false)
        call Text_Say(gg_unit_U00G_0220,"That time is now. And don't hold back or I'll turn you to cinders!",false)
        call Cine_ExitAction()
    else
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_U00G_0220)
        call Wait_Polled(1.)
    endif
    call ConditionalTriggerExecute(gg_trg_Quest_BlazingDemon_Start)
endfunction

function Trig_BlazingDemon_FullHeat_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_BlazingDemon_FullHeat_Cond_LowDifficulty takes nothing returns boolean
    return(udg_Difficulty<=4)
endfunction

function Trig_BlazingDemon_FullHeat_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_U00G_0220,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call UnitAddAbilityBJ('A0Z1',gg_unit_U00G_0220) // 'A0Z1': ability "Full Heat"
    call SetUnitInvulnerable(gg_unit_U00G_0220,true)
    call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',30.,30.,0)
    if(Trig_BlazingDemon_FullHeat_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00G_0220,.0)
        call Text_Say(gg_unit_U00G_0220,"Hahaha! This is great! You really pack a punch!",false)
        call Text_Say(gg_unit_U00G_0220,"Let's turn up the heat even more!",false)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$C // $C = 12
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',20.,20.,0)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$C // $C = 12
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',10.,10.,0)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$C // $C = 12
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',.0,.0,0)
        call Wait_Polled(2)
        call Text_Say(gg_unit_U00G_0220,"I'll turn you all to ash!",false)
        call Cine_ExitAction()
    else
        call PauseUnitBJ(true,gg_unit_U00G_0220)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$C // $C = 12
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        call PauseUnitBJ(false,gg_unit_U00G_0220)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$C // $C = 12
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',.0,.0,0)
    endif
    call SetHeroLevelBJ(gg_unit_U00G_0220,93,false)
    call SetUnitInvulnerable(gg_unit_U00G_0220,false)
    if(Trig_BlazingDemon_FullHeat_Cond_LowDifficulty())then
        call EnableTrigger(gg_trg_Quest_BlazingDemon_End)
        call DestroyTrigger(gg_trg_Quest_BlazingDemon_Escape)
    else
        call EnableTrigger(gg_trg_Quest_BlazingDemon_Escape)
        call DestroyTrigger(gg_trg_Quest_BlazingDemon_End)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_BlazingDemon automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BlazingDemon (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BlazingDemon takes nothing returns nothing
endfunction

function Register_BlazingDemon_Hide takes nothing returns nothing
    set gg_trg_BlazingDemon_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_BlazingDemon_Hide,function Trig_BlazingDemon_Hide_Actions)
endfunction

function Register_BlazingDemon_Appear takes nothing returns nothing
    set gg_trg_BlazingDemon_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_BlazingDemon_Appear)
    call TriggerAddAction(gg_trg_BlazingDemon_Appear,function Trig_BlazingDemon_Appear_Actions)
endfunction

function Register_BlazingDemon_FullHeat takes nothing returns nothing
    set gg_trg_BlazingDemon_FullHeat=CreateTrigger()
    call DisableTrigger(gg_trg_BlazingDemon_FullHeat)
    call TriggerRegisterUnitEvent(gg_trg_BlazingDemon_FullHeat,gg_unit_U00G_0220,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_BlazingDemon_FullHeat,function Trig_BlazingDemon_FullHeat_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BlazingDemon takes nothing returns nothing
    call Register_BlazingDemon_Hide()
    call Register_BlazingDemon_Appear()
    call Register_BlazingDemon_FullHeat()
endfunction

endlibrary

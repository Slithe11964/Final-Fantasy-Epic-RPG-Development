library TBossOzma requires TBattleLog, TCam, TCine, TDifficulty, TLoc, TMusic, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Ozma_Spawn=null
    trigger gg_trg_Boss_Ozma_Barrier=null
    trigger gg_trg_Boss_Ozma_Death=null
    trigger gg_trg_Boss_Ozma_Cleanup=null
    // Variables only this module uses.
    unit udg_OzmaBoss=null
    integer udg_OzmaBarrierTimer=0
endglobals

function Trig_Boss_Ozma_Spawn_IsFirstSummon takes nothing returns boolean
    return(udg_RingHintUsed[8]==false)
endfunction

function Trig_Boss_Ozma_Spawn_Actions takes nothing returns nothing
    local integer l_tempInteger
    set udg_BossCleanupTrigger=gg_trg_Boss_Ozma_Cleanup
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_n03T_0008,0)
    call Wait_Polled(1.)
    if(Trig_Boss_Ozma_Spawn_IsFirstSummon())then
        set udg_RingHintUsed[8]=true
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        // Calculation 1:
        // A random whole number from 0 through 255.
        // Calculation 2:
        // A random whole number from 0 through 255.
        // Calculation 3:
        // A random whole number from 0 through 255.
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),GetRandomInt(0,$FF),GetRandomInt(0,$FF),GetRandomInt(0,$FF)) // $FF = 255
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.8)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        // Calculation 1:
        // A random whole number from 0 through 255.
        // Calculation 2:
        // A random whole number from 0 through 255.
        // Calculation 3:
        // A random whole number from 0 through 255.
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),GetRandomInt(0,$FF),GetRandomInt(0,$FF),GetRandomInt(0,$FF)) // $FF = 255
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.8)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        // Calculation 1:
        // A random whole number from 0 through 255.
        // Calculation 2:
        // A random whole number from 0 through 255.
        // Calculation 3:
        // A random whole number from 0 through 255.
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),GetRandomInt(0,$FF),GetRandomInt(0,$FF),GetRandomInt(0,$FF)) // $FF = 255
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.8)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        // Calculation 1:
        // A random whole number from 0 through 255.
        // Calculation 2:
        // A random whole number from 0 through 255.
        // Calculation 3:
        // A random whole number from 0 through 255.
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),GetRandomInt(0,$FF),GetRandomInt(0,$FF),GetRandomInt(0,$FF)) // $FF = 255
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.4)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.4)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.4)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.4)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.3)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.3)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.3)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.3)
        set udg_TempPoint=GetRectCenter(gg_rct_639)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // Calculation 1:
        // A random decimal number between -256 and 256.
        // Calculation 2:
        // A random decimal number between -256 and 256.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(.2)
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_639)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (30).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,192.,(I2R(GetForLoopIndexA())*30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\Demon\\Infernal\\InfernalBirth.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.8)
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    // (udg_EnemyHandicap) divided by (GetPlayerHandicapBJ(Player(11))).
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_639)
    call CreateNUnitsAtLoc(1,'U01T',Player($B),udg_TempPoint,.0) // 'U01T': unit "Sealed Esper"; $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_OzmaBoss=GetLastCreatedUnit()
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call SetHeroLevelBJ(udg_OzmaBoss,80,false)
    set udg_OzmaBarrierTimer=4
    call EnableTrigger(gg_trg_Boss_Ozma_Barrier)
    call SetUnitAbilityLevelSwapped('A1BF',udg_OzmaBoss,8) // 'A1BF': ability "Adaptive Barrier"
    set udg_AdaptMagicTotal=2000.
    set udg_AdaptPhysTotal=2000.
    set l_tempInteger=0
    loop
        exitwhen l_tempInteger>6
        set udg_AdaptElementTotal[l_tempInteger]=.0
        set l_tempInteger=l_tempInteger+1
    endloop
    set udg_AdaptElementTotal[7]=5000.
    call SetUnitInvulnerable(udg_OzmaBoss,true)
    call PauseUnitBJ(true,udg_OzmaBoss)
    call Wait_Polled(3.)
    call SetUnitInvulnerable(udg_OzmaBoss,false)
    call PauseUnitBJ(false,udg_OzmaBoss)
    call GroupAddUnitSimple(udg_OzmaBoss,udg_BossGroup)
    call Music_SetTrack(54)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Ozma_Death,udg_OzmaBoss,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Boss_Ozma_Death)
    call Cine_Exit()
endfunction

function Trig_Boss_Ozma_Barrier_IsBarrierPhysical takes nothing returns boolean
    return(udg_TempInteger<6)
endfunction

function Trig_Boss_Ozma_Barrier_IsBarrierNeutral takes nothing returns boolean
    return(udg_TempInteger>=6)and(udg_TempInteger<=8)
endfunction

function Trig_Boss_Ozma_Barrier_IsBarrierLocked takes nothing returns boolean
    return(udg_OzmaBarrierTimer>0)
endfunction

function Trig_Boss_Ozma_Barrier_IsBarrierLevelHigh takes nothing returns boolean
    return(udg_TempInteger>=$C) // $C = 12
endfunction

function Trig_Boss_Ozma_Barrier_IsBarrierLevelLow takes nothing returns boolean
    return(udg_TempInteger<=3)
endfunction

function Trig_Boss_Ozma_Barrier_Actions takes nothing returns nothing
    set udg_TempInteger=GetUnitAbilityLevelSwapped('A1BF',udg_OzmaBoss) // 'A1BF': ability "Adaptive Barrier"
    if(Trig_Boss_Ozma_Barrier_IsBarrierLocked())then
        set udg_OzmaBarrierTimer=(udg_OzmaBarrierTimer-1)
    else
        set udg_OzmaBarrierTimer=8
        // (udg_AdaptMagicTotal) times (0.8).
        set udg_AdaptMagicTotal=(udg_AdaptMagicTotal*.8)
        // (udg_AdaptPhysTotal) times (0.8).
        set udg_AdaptPhysTotal=(udg_AdaptPhysTotal*.8)
        set udg_TempPoint=GetUnitLoc(udg_OzmaBoss)
        if(Trig_Boss_Ozma_Barrier_IsBarrierNeutral())then
            call BattleLog_ShowUnit("shifts Adaptive Barrier to Neutral",udg_OzmaBoss)
            call CreateTextTagLocBJ("|cffffcc00ADAPTIVE BARRIER: NEUTRAL",udg_TempPoint,0,13.,'d','d','d',0)
        else
            if(Trig_Boss_Ozma_Barrier_IsBarrierPhysical())then
                call AddSpecialEffectTargetUnitBJ("chest",udg_OzmaBoss,"Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                // (6) minus (udg_TempInteger).
                call BattleLog_ShowUnit("shifts Adaptive Barrier to Physical Level "+I2S(6-udg_TempInteger),udg_OzmaBoss)
                // (6) minus (udg_TempInteger).
                call CreateTextTagLocBJ(("|cffffcc00ADAPTIVE BARRIER: PHYSICAL LV. "+I2S((6-udg_TempInteger))),udg_TempPoint,0,13.,'d','d','d',0)
            else
                call AddSpecialEffectTargetUnitBJ("chest",udg_OzmaBoss,"Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                // (udg_TempInteger) minus (8).
                call BattleLog_ShowUnit("shifts Adaptive Barrier to Magical Level "+I2S(udg_TempInteger-8),udg_OzmaBoss)
                // (udg_TempInteger) minus (8).
                call CreateTextTagLocBJ(("|cffffcc00ADAPTIVE BARRIER: MAGICAL LV. "+I2S((udg_TempInteger-8))),udg_TempPoint,0,13.,'d','d','d',0)
            endif
        endif
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    endif
    if(Trig_Boss_Ozma_Barrier_IsBarrierLevelLow())then
        call SetUnitColor(udg_OzmaBoss,PLAYER_COLOR_YELLOW)
    else
        if(Trig_Boss_Ozma_Barrier_IsBarrierLevelHigh())then
            call SetUnitColor(udg_OzmaBoss,PLAYER_COLOR_GREEN)
        else
            // A random whole number from 2 through 9.
            call SetUnitColor(udg_OzmaBoss,udg_ZoneColor[GetRandomInt(2,9)])
        endif
    endif
endfunction

function Trig_Boss_Ozma_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_OzmaBoss)
endfunction

function Trig_Boss_Ozma_Death_IsKillTrackerOn takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Ozma_Death_IsWaygateUnlocked takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Boss_Ozma_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Ozma_Death_IsKillTrackerOn())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack(54)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call DisableTrigger(gg_trg_Boss_Ozma_Barrier)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0G6',l_tempPoint) // 'I0G6': item "Force of Nature"
    call RemoveLocation(l_tempPoint)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    if(Trig_Boss_Ozma_Death_IsWaygateUnlocked())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call RemoveItem(udg_SummonItem)
    set udg_RingHintsReady=true
    call UnitRemoveAbilityBJ('A1BG',gg_unit_n03T_0008) // 'A1BG': ability "Madain Sari Horn Hint"
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Boss_Ozma_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Boss_Ozma_Barrier)
    call DisableTrigger(gg_trg_Boss_Ozma_Death)
    call GroupRemoveUnitSimple(udg_OzmaBoss,udg_BossGroup)
    call KillUnit(udg_OzmaBoss)
    call RemoveUnit(udg_OzmaBoss)
    call Music_ClearTrack(54)
endfunction

function InitTrig_Boss_Ozma takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part13 (module Boss),
// which keeps the original registration order.

function Register_Boss_Ozma_Spawn takes nothing returns nothing
    set gg_trg_Boss_Ozma_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Spawn)
    call TriggerAddAction(gg_trg_Boss_Ozma_Spawn,function Trig_Boss_Ozma_Spawn_Actions)
endfunction

function Register_Boss_Ozma_Barrier takes nothing returns nothing
    set gg_trg_Boss_Ozma_Barrier=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Barrier)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Boss_Ozma_Barrier,1.)
    call TriggerAddAction(gg_trg_Boss_Ozma_Barrier,function Trig_Boss_Ozma_Barrier_Actions)
endfunction

function Register_Boss_Ozma_Death takes nothing returns nothing
    set gg_trg_Boss_Ozma_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Death)
    call TriggerAddCondition(gg_trg_Boss_Ozma_Death,Condition(function Trig_Boss_Ozma_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Ozma_Death,function Trig_Boss_Ozma_Death_Actions)
endfunction

function Register_Boss_Ozma_Cleanup takes nothing returns nothing
    set gg_trg_Boss_Ozma_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Cleanup)
    call TriggerAddAction(gg_trg_Boss_Ozma_Cleanup,function Trig_Boss_Ozma_Cleanup_Actions)
endfunction

endlibrary

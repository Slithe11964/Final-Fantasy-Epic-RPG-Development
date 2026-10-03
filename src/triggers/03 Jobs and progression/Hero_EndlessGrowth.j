library THeroEndlessGrowth requires TPlayerHero
function Trig_Hero_EndlessGrowth_Has_EndlessAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))>0) // 'A10E': ability "Endless"
endfunction

function Trig_Hero_EndlessGrowth_Endless_NeedsUpdate takes nothing returns boolean
    return(udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]>0)and(udg_SpeedrunMode==false)and(GetHeroLevel(Player_GetHero(udg_TempPlayer))>GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer)))and(IsPlayerInForce(udg_TempPlayer,udg_CheaterForce)==false) // 'A10E': ability "Endless"
endfunction

function Trig_Hero_EndlessGrowth_Title_NeedsStatApply takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[udg_TempInteger]))and(udg_TitleStatsBlocked[udg_TempInteger]==false)and(IsUnitInGroup(Player_GetHero(udg_TempPlayer),udg_BonusGroup[udg_TempInteger])==false)
endfunction

function Trig_Hero_EndlessGrowth_Actions takes nothing returns nothing
    if(Trig_Hero_EndlessGrowth_Endless_NeedsUpdate())then
        if(Trig_Hero_EndlessGrowth_Has_EndlessAbility())then
            call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SUB,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
            call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SUB,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SUB,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
        else
            call UnitAddAbilityBJ('A10E',Player_GetHero(udg_TempPlayer)) // 'A10E': ability "Endless"
            call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,1)
            call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,1)
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,1)
        endif
        call SetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer),GetHeroLevel(Player_GetHero(udg_TempPlayer))) // 'A10E': ability "Endless"
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
        call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
        call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
    endif
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>'d'
        if(Trig_Hero_EndlessGrowth_Title_NeedsStatApply())then
            call ConditionalTriggerExecute(gg_trg_Title_ApplyStats)
            call GroupAddUnitSimple(Player_GetHero(udg_TempPlayer),udg_BonusGroup[udg_TempInteger])
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
endfunction

function InitTrig_Hero_EndlessGrowth takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hero_Part1 (module Hero),
// which keeps the original registration order.

function Register_Hero_EndlessGrowth takes nothing returns nothing
    set gg_trg_Hero_EndlessGrowth=CreateTrigger()
    call DisableTrigger(gg_trg_Hero_EndlessGrowth)
    call TriggerAddAction(gg_trg_Hero_EndlessGrowth,function Trig_Hero_EndlessGrowth_Actions)
endfunction

endlibrary

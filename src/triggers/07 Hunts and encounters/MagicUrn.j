library TMagicUrn requires TForce, TMusic, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MagicUrn_Setup=null
    trigger gg_trg_MagicUrn_Drop=null
    trigger gg_trg_MagicUrn_Open=null
    trigger gg_trg_MagicUrn_Boss_Death=null
endglobals

function Trig_MagicUrn_Setup_Actions takes nothing returns nothing
    set udg_UrnBossDeaths=0
    call ShowUnitHide(gg_unit_U00C_0024)
    call SetUnitInvulnerable(gg_unit_U00C_0024,true)
    call PauseUnitBJ(true,gg_unit_U00C_0024)
    call SetUnitVertexColorBJ(gg_unit_nmgv_0065,.0,.0,.0,0)
    call SetUnitInvulnerable(gg_unit_nmgv_0065,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MagicUrn_Drop_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0A1',l_tempPoint) // 'I0A1': item "Magic Urn"
    call RemoveLocation(l_tempPoint)
    call AddItemToStockBJ('I0A2',gg_unit_n02Y_0052,1,1) // 'I0A2': item "Information: Magic Urn"
    call EnableTrigger(gg_trg_MagicUrn_Open)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_MagicUrn_Open_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0A1') // 'I0A1': item "Magic Urn"
endfunction

function Trig_MagicUrn_Open_Cond_InDarkArea takes nothing returns boolean
    return(RectContainsUnit(gg_rct_454,GetTriggerUnit()))or(RectContainsUnit(gg_rct_455,GetTriggerUnit()))
endfunction

function Trig_MagicUrn_Open_Cond_InDarkAreaWrap takes nothing returns boolean
    return(Trig_MagicUrn_Open_Cond_InDarkArea())
endfunction

function Trig_MagicUrn_Open_Actions takes nothing returns nothing
    local location l_tempPoint
    if(Trig_MagicUrn_Open_Cond_InDarkAreaWrap())then
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"The Magic Urn won't open here!")
        call DestroyForce(udg_TempForce)
        set l_tempPoint=null
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(GetManipulatedItem())
    call RemoveItemFromStockBJ('I0A2',gg_unit_n02Y_0052) // 'I0A2': item "Information: Magic Urn"
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call PlaySoundBJ(gg_snd_SargerasLaugh)
    call Music_SetTrack(36)
    set l_tempPoint=GetUnitLoc(Player_GetHero(GetOwningPlayer(GetTriggerUnit())))
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00C_0024,l_tempPoint,l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call ShowUnitShow(gg_unit_U00C_0024)
    call SetUnitInvulnerable(gg_unit_U00C_0024,false)
    call PauseUnitBJ(false,gg_unit_U00C_0024)
    call EnableTrigger(gg_trg_MagicUrn_Boss_Death)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_MagicUrn_Boss_Death_Cond_TrackBossKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_MagicUrn_Boss_Death_Cond_SecondUrnKill takes nothing returns boolean
    return(udg_UrnBossDeaths>=2)
endfunction

function Trig_MagicUrn_Boss_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_MagicUrn_Boss_Death_Cond_TrackBossKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack(36)
    set udg_UrnBossDeaths=(udg_UrnBossDeaths+1)
    if(Trig_MagicUrn_Boss_Death_Cond_SecondUrnKill())then
        call SaveIntegerBJ(1,2,'e',udg_GameStateHash)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0GE',l_tempPoint) // 'I0GE': item "Curse: Death Skull"
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_MagicUrn automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MagicUrn_Part1 / RegisterTriggers_MagicUrn_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MagicUrn takes nothing returns nothing
endfunction

function Register_MagicUrn_Setup takes nothing returns nothing
    set gg_trg_MagicUrn_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_MagicUrn_Setup,function Trig_MagicUrn_Setup_Actions)
endfunction

function Register_MagicUrn_Drop takes nothing returns nothing
    set gg_trg_MagicUrn_Drop=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MagicUrn_Drop,gg_unit_nmgv_0065,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_MagicUrn_Drop,function Trig_MagicUrn_Drop_Actions)
endfunction

function Register_MagicUrn_Open takes nothing returns nothing
    set gg_trg_MagicUrn_Open=CreateTrigger()
    call DisableTrigger(gg_trg_MagicUrn_Open)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MagicUrn_Open,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_MagicUrn_Open,Condition(function Trig_MagicUrn_Open_Conditions))
    call TriggerAddAction(gg_trg_MagicUrn_Open,function Trig_MagicUrn_Open_Actions)
endfunction

function Register_MagicUrn_Boss_Death takes nothing returns nothing
    set gg_trg_MagicUrn_Boss_Death=CreateTrigger()
    call DisableTrigger(gg_trg_MagicUrn_Boss_Death)
    call TriggerRegisterUnitEvent(gg_trg_MagicUrn_Boss_Death,gg_unit_U00C_0024,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_MagicUrn_Boss_Death,function Trig_MagicUrn_Boss_Death_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_MagicUrn_Part1 takes nothing returns nothing
    call Register_MagicUrn_Setup() // run by MapBootstrap
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_MagicUrn_Part2 takes nothing returns nothing
    call Register_MagicUrn_Drop()
    call Register_MagicUrn_Open() // starts off; enabled by MagicUrn
    call Register_MagicUrn_Boss_Death() // starts off; enabled by MagicUrn
endfunction

endlibrary

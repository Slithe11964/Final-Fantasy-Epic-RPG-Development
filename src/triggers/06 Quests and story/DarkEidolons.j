library TDarkEidolons requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkEidolons_Init=null
    trigger gg_trg_DarkEidolons_SpawnGhosts=null
    trigger gg_trg_DarkEidolons_Unlock=null
endglobals

function Trig_DarkEidolons_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_E00C_0046)
    call PauseUnitBJ(true,gg_unit_E00C_0046)
    call SetUnitInvulnerable(gg_unit_E00C_0046,true)
    call GroupAddUnitSimple(gg_unit_E00C_0046,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01S_0045)
    call PauseUnitBJ(true,gg_unit_H01S_0045)
    call SetUnitInvulnerable(gg_unit_H01S_0045,true)
    call GroupAddUnitSimple(gg_unit_H01S_0045,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01T_0044)
    call PauseUnitBJ(true,gg_unit_H01T_0044)
    call SetUnitInvulnerable(gg_unit_H01T_0044,true)
    call GroupAddUnitSimple(gg_unit_H01T_0044,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_E00D_0043)
    call PauseUnitBJ(true,gg_unit_E00D_0043)
    call SetUnitInvulnerable(gg_unit_E00D_0043,true)
    call GroupAddUnitSimple(gg_unit_E00D_0043,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01V_0041)
    call PauseUnitBJ(true,gg_unit_H01V_0041)
    call SetUnitInvulnerable(gg_unit_H01V_0041,true)
    call GroupAddUnitSimple(gg_unit_H01V_0041,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_U00B_0042)
    call PauseUnitBJ(true,gg_unit_U00B_0042)
    call SetUnitInvulnerable(gg_unit_U00B_0042,true)
    call GroupAddUnitSimple(gg_unit_U00B_0042,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01U_0040)
    call PauseUnitBJ(true,gg_unit_H01U_0040)
    call SetUnitInvulnerable(gg_unit_H01U_0040,true)
    call GroupAddUnitSimple(gg_unit_H01U_0040,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01W_0039)
    call PauseUnitBJ(true,gg_unit_H01W_0039)
    call SetUnitInvulnerable(gg_unit_H01W_0039,true)
    call GroupAddUnitSimple(gg_unit_H01W_0039,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01X_0038)
    call PauseUnitBJ(true,gg_unit_H01X_0038)
    call SetUnitInvulnerable(gg_unit_H01X_0038,true)
    call GroupAddUnitSimple(gg_unit_H01X_0038,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01Y_0037)
    call PauseUnitBJ(true,gg_unit_H01Y_0037)
    call SetUnitInvulnerable(gg_unit_H01Y_0037,true)
    call GroupAddUnitSimple(gg_unit_H01Y_0037,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_n043_0021)
    call ShowUnitHide(gg_unit_H01Z_0036)
    call PauseUnitBJ(true,gg_unit_H01Z_0036)
    call SetUnitInvulnerable(gg_unit_H01Z_0036,true)
    call GroupAddUnitSimple(gg_unit_H01Z_0036,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H01N_0035)
    call PauseUnitBJ(true,gg_unit_H01N_0035)
    call SetUnitInvulnerable(gg_unit_H01N_0035,true)
    call GroupAddUnitSimple(gg_unit_H01N_0035,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_H021_0034)
    call PauseUnitBJ(true,gg_unit_H021_0034)
    call SetUnitInvulnerable(gg_unit_H021_0034,true)
    call GroupAddUnitSimple(gg_unit_H021_0034,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_O00B_0032)
    call PauseUnitBJ(true,gg_unit_O00B_0032)
    call SetUnitInvulnerable(gg_unit_O00B_0032,true)
    call GroupAddUnitSimple(gg_unit_O00B_0032,udg_DarkEidolonGroup)
    call ShowUnitHide(gg_unit_O00A_0033)
    call PauseUnitBJ(true,gg_unit_O00A_0033)
    call SetUnitInvulnerable(gg_unit_O00A_0033,true)
    call GroupAddUnitSimple(gg_unit_O00A_0033,udg_DarkEidolonGroup)
    call SetUnitVertexColorBJ(gg_unit_N02Z_0031,7.,7.,7.,10.)
    call ShowUnitHide(gg_unit_N02Z_0031)
    call PauseUnitBJ(true,gg_unit_N02Z_0031)
    call SetUnitInvulnerable(gg_unit_N02Z_0031,true)
    call GroupAddUnitSimple(gg_unit_N02Z_0031,udg_DarkEidolonGroup)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkEidolons_SpawnGhosts_CreateGhostCopy takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLoc(1,GetUnitTypeId(GetEnumUnit()),Player(8),udg_TempPoint,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_DarkEidolonIllusions)
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetHeroLevelBJ(GetLastCreatedUnit(),GetHeroLevel(GetEnumUnit()),false)
    call UnitAddAbilityBJ('A0VJ',GetLastCreatedUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
    call UnitAddAbilityBJ('Agho',GetLastCreatedUnit()) // 'Agho': object name not found in map data
    call SetUnitPathing(GetLastCreatedUnit(),false)
    call UnitRemoveAbilityBJ('AInv',GetLastCreatedUnit()) // 'AInv': standard ability reference "Inventory"
    call UnitRemoveAbilityBJ('A11N',GetLastCreatedUnit()) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_DarkEidolons_SpawnGhosts_Actions takes nothing returns nothing
    call ForGroupBJ(udg_DarkEidolonGroup,function Trig_DarkEidolons_SpawnGhosts_CreateGhostCopy)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkEidolons_Unlock_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[7]))and(IsQuestCompleted(udg_SideQuest[30]))and(IsQuestCompleted(udg_SideQuest[34]))and(IsQuestCompleted(udg_MainQuest[19]))
endfunction

function Trig_DarkEidolons_Unlock_KillGhost takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_DarkEidolons_Unlock_IsDarkEdenQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[33]))
endfunction

function Trig_DarkEidolons_Unlock_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Wait_Polled(60.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.25,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,0,0,0)
    call ForGroupBJ(udg_DarkEidolonIllusions,function Trig_DarkEidolons_Unlock_KillGhost)
    call DestroyGroup(udg_DarkEidolonIllusions)
    call AddItemToStockBJ('I05B',gg_unit_n02Y_0052,1,1) // 'I05B': item "Information: Dark Eidolons"
    call AddItemToStockBJ('I07S',gg_unit_n02Y_0052,1,1) // 'I07S': item "Information: Dark Ifrit/Shiva"
    call AddItemToStockBJ('I07T',gg_unit_n02Y_0052,1,1) // 'I07T': item "Information: Dark Quezacotl/Phoenix"
    if(Trig_DarkEidolons_Unlock_IsDarkEdenQuestDone())then
        call AddItemToStockBJ('I07U',gg_unit_n02Y_0052,1,1) // 'I07U': item "Information: Dark Eden"
    else
        set udg_QuestFlag[4]=true
    endif
    call EnableTrigger(gg_trg_DarkShiva_Appear)
    call EnableTrigger(gg_trg_DarkIfrit_Appear)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01V_0041)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_H01V_0041)
    call UnitAddAbilityBJ('A0VJ',gg_unit_H01V_0041) // 'A0VJ': ability "Unaffected by Cinematics"
    call EnableTrigger(gg_trg_DarkGolem_Appear)
    call ShowUnitShow(gg_unit_n043_0021)
    call EnableTrigger(gg_trg_DarkBahamut_Riddle)
    call EnableTrigger(gg_trg_DarkLeviathan_Appear)
    call EnableTrigger(gg_trg_DarkQuezacotl_Appear)
    call EnableTrigger(gg_trg_DarkPhoenix_Appear)
    call EnableTrigger(gg_trg_DarkBrothers_Appear)
    call EnableTrigger(gg_trg_DarkEden_Appear)
    call EnableTrigger(gg_trg_Boss_Penance_Summon)
    call EnableTrigger(gg_trg_DarkEidolon_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkEidolons automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkEidolons (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkEidolons takes nothing returns nothing
endfunction

function Register_DarkEidolons_Init takes nothing returns nothing
    set gg_trg_DarkEidolons_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_DarkEidolons_Init,function Trig_DarkEidolons_Init_Actions)
endfunction

function Register_DarkEidolons_SpawnGhosts takes nothing returns nothing
    set gg_trg_DarkEidolons_SpawnGhosts=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_DarkEidolons_SpawnGhosts,20.)
    call TriggerAddAction(gg_trg_DarkEidolons_SpawnGhosts,function Trig_DarkEidolons_SpawnGhosts_Actions)
endfunction

function Register_DarkEidolons_Unlock takes nothing returns nothing
    set gg_trg_DarkEidolons_Unlock=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_DarkEidolons_Unlock,15.)
    call TriggerAddCondition(gg_trg_DarkEidolons_Unlock,Condition(function Trig_DarkEidolons_Unlock_Conditions))
    call TriggerAddAction(gg_trg_DarkEidolons_Unlock,function Trig_DarkEidolons_Unlock_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkEidolons takes nothing returns nothing
    call Register_DarkEidolons_Init() // run by MapBootstrap
    call Register_DarkEidolons_SpawnGhosts()
    call Register_DarkEidolons_Unlock()
endfunction

endlibrary

library TBossDefeat
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Defeat_Announce=null
endglobals

function Trig_Boss_Defeat_Announce_Conditions takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Boss_Defeat_Announce_IsDyingHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Defeat_Announce_Actions takes nothing returns nothing
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Defeat_Announce_IsDyingHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
endfunction

function InitTrig_Boss_Defeat takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part14 (module Boss),
// which keeps the original registration order.

function Register_Boss_Defeat_Announce takes nothing returns nothing
    set gg_trg_Boss_Defeat_Announce=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Hvsh_0145,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H00Y_0022,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Nbbc_0006,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n00F_0139,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Hgam_0060,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n00H_0005,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n014_0174,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n01Z_0127,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Uvng_0076,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_U006_0077,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H00W_0079,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_e009_0118,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01I_0070,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01J_0069,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01K_0068,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01L_0067,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Nman_0151,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_N022_0125,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_U00C_0024,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_O00I_0239,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H02W_0246,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Defeat_Announce,Condition(function Trig_Boss_Defeat_Announce_Conditions))
    call TriggerAddAction(gg_trg_Boss_Defeat_Announce,function Trig_Boss_Defeat_Announce_Actions)
endfunction

endlibrary

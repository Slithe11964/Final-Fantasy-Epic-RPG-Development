library TGodDragon requires TBerserk
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_GodDragon_Transfusion=null
    trigger gg_trg_GodDragon_Death=null
endglobals

function Trig_GodDragon_Transfusion_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call Berserk_Remove(GetTriggerUnit())
    call UnitAddAbilityBJ('A0I3',udg_GodDragonUnit) // 'A0I3': ability "Transfusion Powerup"
    call AddSpecialEffectTargetUnitBJ("origin",udg_GodDragonUnit,"Abilities\\Spells\\Items\\AIsm\\AIsmTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_GodDragonUnit,"Abilities\\Spells\\Items\\AIam\\AIamTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_GodDragonUnit,"Abilities\\Spells\\Items\\AIim\\AIimTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitVertexColorBJ(udg_GodDragonUnit,'d',80.,.0,0)
    call SetUnitLifePercentBJ(udg_GodDragonUnit,'d')
    call SetUnitManaPercentBJ(udg_GodDragonUnit,'d')
    call UnitRemoveAbilityBJ('A0ZR',udg_GodDragonUnit) // 'A0ZR': ability "Immortal"
    call UnitRemoveAbilityBJ('A0LG',udg_GodDragonUnit) // 'A0LG': ability "Water-elemental Attack"
    call UnitRemoveAbilityBJ('A0SW',udg_GodDragonUnit) // 'A0SW': ability "Water Immunity"
    call UnitRemoveAbilityBJ('A0LR',udg_GodDragonUnit) // 'A0LR': ability "Thunder Weakness"
    call UnitAddAbilityBJ('A0MF',udg_GodDragonUnit) // 'A0MF': ability "Omni-elemental Damage"
    call UnitAddAbilityBJ('A0MI',udg_GodDragonUnit) // 'A0MI': ability "Omni Orb Amplification"
    call UnitAddAbilityBJ('A0MG',udg_GodDragonUnit) // 'A0MG': ability "Omni Spell Amplification"
    call UnitAddAbilityBJ('A0ME',udg_GodDragonUnit) // 'A0ME': ability "Omni Ward"
    call BlzSetUnitName(udg_GodDragonUnit,"Neo Shinryu")
    set l_tempPoint=GetUnitLoc(gg_unit_U00H_0211)
    call CreateTextTagLocBJ("|cffffcc00TRANSFUSION",l_tempPoint,0,13.,'d','d','d',0)
    call RemoveLocation(l_tempPoint)
    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_GodDragon_Death_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_GodDragon_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_GodDragon_Death_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I0L5',l_tempPoint) // 'I0L5': item "Dragon Remains"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(l_tempPoint)
    call UnitRemoveAbilityBJ('A0X2',gg_unit_U00H_0211) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_U00H_0211) // 'B064': buff "Perma Cover"
    call UnitAddAbilityBJ('A0YQ',gg_unit_U00H_0211) // 'A0YQ': ability "!Darkja"
    call GroupRemoveUnitSimple(udg_GodDragonUnit,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_U00H_0211,udg_BossUnits)
    call EnableTrigger(gg_trg_Boss_GodDragon_Death)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_GodDragon automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GodDragon (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GodDragon takes nothing returns nothing
endfunction

function Register_GodDragon_Transfusion takes nothing returns nothing
    set gg_trg_GodDragon_Transfusion=CreateTrigger()
    call DisableTrigger(gg_trg_GodDragon_Transfusion)
    call TriggerAddAction(gg_trg_GodDragon_Transfusion,function Trig_GodDragon_Transfusion_Actions)
endfunction

function Register_GodDragon_Death takes nothing returns nothing
    set gg_trg_GodDragon_Death=CreateTrigger()
    call DisableTrigger(gg_trg_GodDragon_Death)
    call TriggerAddAction(gg_trg_GodDragon_Death,function Trig_GodDragon_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GodDragon takes nothing returns nothing
    call Register_GodDragon_Transfusion() // starts off; enabled by Quest_GodDragon
    call Register_GodDragon_Death() // starts off; enabled by Quest_GodDragon
endfunction

endlibrary

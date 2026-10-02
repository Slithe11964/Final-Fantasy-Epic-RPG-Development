library TNightmare requires TPlayerPart01, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Nightmare_Spawn=null
    trigger gg_trg_Nightmare_Despawn=null
    trigger gg_trg_Nightmare_Death_Charge=null
    trigger gg_trg_Nightmare_Roam=null
    trigger gg_trg_Nightmare_Death=null
    // Variables only this module uses.
    integer udg_NightmareZone=0
    boolean udg_DeathbringerDropped=false
endglobals

function Trig_Nightmare_Spawn_Cond_ZoneIndexTaken takes nothing returns boolean
    return(udg_TempInteger>=udg_NightmareZone)
endfunction

function Trig_Nightmare_Spawn_Cond_FirstNightReroll takes nothing returns boolean
    return(udg_GameDay==1)and(udg_NightmareZone==1)
endfunction

function Trig_Nightmare_Spawn_Cond_PlayerTooClose takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<500.)
endfunction

function Trig_Nightmare_Spawn_Enum_AvoidPlayerZone takes nothing returns nothing
    set udg_TempPoint2=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    if(Trig_Nightmare_Spawn_Cond_PlayerTooClose())then
        call RemoveLocation(udg_TempPoint)
        // A random whole number from 1 through LoadIntegerBJ(udg_NightmareZone, 2, udg_SpawnDataHashRef).
        set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_NightmareZone,2,udg_SpawnDataHashRef)),udg_NightmareZone,udg_SpawnRectHashRef))
    endif
    call RemoveLocation(udg_TempPoint2)
endfunction

function Trig_Nightmare_Spawn_Cond_NightmareHardMode takes nothing returns boolean
    return(udg_Difficulty>=6)
endfunction

function Trig_Nightmare_Spawn_Cond_NightmareUntouched takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_SummonedBoss, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_SummonedBoss)>=100.)
endfunction

function Trig_Nightmare_Spawn_Cond_NightmareExists takes nothing returns boolean
    return(udg_SummonedBoss!=null)
endfunction

function Trig_Nightmare_Spawn_Actions takes nothing returns nothing
    // A random whole number from 1 through 8.
    set udg_TempInteger=GetRandomInt(1,8)
    if(Trig_Nightmare_Spawn_Cond_ZoneIndexTaken())then
        // (udg_TempInteger) plus (1).
        set udg_NightmareZone=(udg_TempInteger+1)
    else
        set udg_NightmareZone=udg_TempInteger
    endif
    if(Trig_Nightmare_Spawn_Cond_FirstNightReroll())then
        // A random whole number from 2 through 9.
        set udg_NightmareZone=GetRandomInt(2,9)
    endif
    // A random whole number from 1 through LoadIntegerBJ(udg_NightmareZone, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_NightmareZone,2,udg_SpawnDataHashRef)),udg_NightmareZone,udg_SpawnRectHashRef))
    call ForForce(udg_PlayingPlayers,function Trig_Nightmare_Spawn_Enum_AvoidPlayerZone)
    if(Trig_Nightmare_Spawn_Cond_NightmareExists())then
        if(Trig_Nightmare_Spawn_Cond_NightmareUntouched())then
            set udg_TempPoint2=GetUnitLoc(udg_SummonedBoss)
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            call SetUnitPositionLocFacingBJ(udg_SummonedBoss,udg_TempPoint,GetRandomDirectionDeg())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    else
        if(Trig_Nightmare_Spawn_Cond_NightmareHardMode())then
            call CreateNUnitsAtLoc(1,'U01U',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'U01U': unit "Nightmare"; $B = 11
            call SetHeroLevelBJ(GetLastCreatedUnit(),99,false)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
        else
            call CreateNUnitsAtLoc(1,'U01S',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'U01S': unit "Night's Terror"; $B = 11
            call SetHeroLevelBJ(GetLastCreatedUnit(),66,false)
        endif
        set udg_SummonedBoss=GetLastCreatedUnit()
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call EnableTrigger(gg_trg_Nightmare_Death)
        call EnableTrigger(gg_trg_Nightmare_Roam)
    endif
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Nightmare_Despawn_Conditions takes nothing returns boolean
    return(udg_SummonedBoss!=null)
endfunction

function Trig_Nightmare_Despawn_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Nightmare_Death)
    call DisableTrigger(gg_trg_Nightmare_Roam)
    set udg_TempPoint=GetUnitLoc(udg_SummonedBoss)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call GroupRemoveUnitSimple(udg_SummonedBoss,udg_BossGroup)
    call ShowUnitHide(udg_SummonedBoss)
    call UnitApplyTimedLifeBJ(1.,'BTLF',udg_SummonedBoss) // 'BTLF': object name not found in map data
    set udg_SummonedBoss=null
endfunction

function Trig_Nightmare_Death_Charge_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1AG') // 'A1AG': ability "Death Charge"
endfunction

function Trig_Nightmare_Death_Charge_Cond_IsNightmare takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='U01U') // 'U01U': unit "Nightmare"
endfunction

function Trig_Nightmare_Death_Charge_Actions takes nothing returns nothing
    call UnitRemoveAbilityBJ('A16T',GetTriggerUnit()) // 'A16T': ability "Reaper Slow"
    call UnitRemoveBuffBJ('B083',GetTriggerUnit()) // 'B083': buff tooltip "Lurking Death"
    call Wait_Polled(2)
    call UnitRemoveAbilityBJ('A1AG',GetTriggerUnit()) // 'A1AG': ability "Death Charge"
    if(Trig_Nightmare_Death_Charge_Cond_IsNightmare())then
        call UnitAddAbilityBJ('A1ES',GetTriggerUnit()) // 'A1ES': ability "Ripper Charge"
        call UnitAddAbilityBJ('A1F9',GetTriggerUnit()) // 'A1F9': ability "Ripper Aura"
        call UnitAddAbilityBJ('A1F7',GetTriggerUnit()) // 'A1F7': ability "Ripper Aura"
        call UnitAddAbilityBJ('A1F8',GetTriggerUnit()) // 'A1F8': ability "Ripper Aura"
    else
        call UnitAddAbilityBJ('A0Z0',GetTriggerUnit()) // 'A0Z0': ability "Surge"
    endif
endfunction

function Trig_Nightmare_Roam_Conditions takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_SummonedBoss, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(udg_SummonedBoss!=null)and(GetUnitLifePercent(udg_SummonedBoss)>=100.)
endfunction

function Trig_Nightmare_Roam_Actions takes nothing returns nothing
    // A random whole number from 1 through LoadIntegerBJ(udg_NightmareZone, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_NightmareZone,2,udg_SpawnDataHashRef)),udg_NightmareZone,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(udg_SummonedBoss,"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Nightmare_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_SummonedBoss)
endfunction

function Trig_Nightmare_Death_Cond_FirstNightmareKill takes nothing returns boolean
    return(udg_DeathbringerDropped==false)
endfunction

function Trig_Nightmare_Death_Cond_NightmareDropHard takes nothing returns boolean
    return(udg_Difficulty>=6)
endfunction

function Trig_Nightmare_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Nightmare_Roam)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Nightmare_Death_Cond_NightmareDropHard())then
        call CreateItemLoc('I0BP',udg_TempPoint) // 'I0BP': item "Executioner Sword"
    else
        if(Trig_Nightmare_Death_Cond_FirstNightmareKill())then
            set udg_DeathbringerDropped=true
            call CreateItemLoc('I0EQ',udg_TempPoint) // 'I0EQ': item "Deathbringer"
            call SaveIntegerBJ(1,2,$BB,udg_GameStateHash) // $BB = 187
        endif
    endif
    call CreateItemLoc('I072',udg_TempPoint) // 'I072': item "Book of Death"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_SummonedBoss=null
endfunction

// World Editor calls InitTrig_Nightmare automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Nightmare (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Nightmare takes nothing returns nothing
endfunction

function Register_Nightmare_Spawn takes nothing returns nothing
    set gg_trg_Nightmare_Spawn=CreateTrigger()
    call TriggerRegisterGameStateEventTimeOfDay(gg_trg_Nightmare_Spawn,EQUAL,20.)
    call TriggerRegisterGameStateEventTimeOfDay(gg_trg_Nightmare_Spawn,EQUAL,.0)
    call TriggerAddAction(gg_trg_Nightmare_Spawn,function Trig_Nightmare_Spawn_Actions)
endfunction

function Register_Nightmare_Despawn takes nothing returns nothing
    set gg_trg_Nightmare_Despawn=CreateTrigger()
    call TriggerRegisterGameStateEventTimeOfDay(gg_trg_Nightmare_Despawn,EQUAL,4.)
    call TriggerAddCondition(gg_trg_Nightmare_Despawn,Condition(function Trig_Nightmare_Despawn_Conditions))
    call TriggerAddAction(gg_trg_Nightmare_Despawn,function Trig_Nightmare_Despawn_Actions)
endfunction

function Register_Nightmare_Death_Charge takes nothing returns nothing
    set gg_trg_Nightmare_Death_Charge=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Nightmare_Death_Charge,Player($B),EVENT_PLAYER_UNIT_SPELL_EFFECT) // $B = 11
    call TriggerAddCondition(gg_trg_Nightmare_Death_Charge,Condition(function Trig_Nightmare_Death_Charge_Conditions))
    call TriggerAddAction(gg_trg_Nightmare_Death_Charge,function Trig_Nightmare_Death_Charge_Actions)
endfunction

function Register_Nightmare_Roam takes nothing returns nothing
    set gg_trg_Nightmare_Roam=CreateTrigger()
    call DisableTrigger(gg_trg_Nightmare_Roam)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Nightmare_Roam,10.)
    call TriggerAddCondition(gg_trg_Nightmare_Roam,Condition(function Trig_Nightmare_Roam_Conditions))
    call TriggerAddAction(gg_trg_Nightmare_Roam,function Trig_Nightmare_Roam_Actions)
endfunction

function Register_Nightmare_Death takes nothing returns nothing
    set gg_trg_Nightmare_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Nightmare_Death)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Nightmare_Death,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Nightmare_Death,Condition(function Trig_Nightmare_Death_Conditions))
    call TriggerAddAction(gg_trg_Nightmare_Death,function Trig_Nightmare_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Nightmare takes nothing returns nothing
    call Register_Nightmare_Spawn()
    call Register_Nightmare_Despawn()
    call Register_Nightmare_Death_Charge()
    call Register_Nightmare_Roam()
    call Register_Nightmare_Death()
endfunction

endlibrary

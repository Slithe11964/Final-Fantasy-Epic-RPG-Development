library TValigarmanda requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_Valigarmanda_Confront_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_n0MC_0265)==false)and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Valigarmanda_Confront_PlayConfrontScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Valigarmanda_Confront_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Valigarmanda_Confront_PlayConfrontScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0MC_0265,0)
        call Text_Say(gg_unit_n0MC_0265,"Halt! Who goes there?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Those cages! It can't be.",false)
        call Text_Say(gg_unit_h00R_0256,"You! We're in a bit of a pickle here, mind helpin' us out?",false)
        call Text_Say(gg_unit_n0MC_0265,"Silence, weakling. Who told you you could speak!?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So you're the one who abducted these dwarves.",false)
        call Text_Say(gg_unit_n0MC_0265,"They didn't even put up any resistance. I knew outsiders were weak, but this is even worse than I imagined. Even though they can forge such impressive weapons and armor they can't even fight!",false)
        call Text_Say(gg_unit_n0MC_0265,"Our foolish king and queen forbade us from leaving but now at last they are around no longer to chain us down. We'll have these dwarves forge us some sharp weapons and then invade the outside realm. Nobody gets in our way!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"You damn brute, that's all you want? Let them go and stay in your goddamn ice land... or else.",false)
        call Text_Say(gg_unit_n0MC_0265,"I don't care what a weakling wants from me. In this place, it's only strength that decides right. I fear no weak outsiders. Crushing is all they're good for.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's the only language you speak is it. If it comes down to cold steel, so be it. You'll die by our hand.",false)
        call SetUnitAnimationWithRarity(gg_unit_n0MC_0265,"stand channel",RARITY_FREQUENT)
        call Text_Say(gg_unit_n0MC_0265,"Come my friends! Let us show these outsiders the might of the Icy Realm that we have repressed for far too long already!",false)
        call ResetUnitAnimation(gg_unit_n0MC_0265)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat Valigarmanda and free the dwarves.")
    call QuestSetDescriptionBJ(udg_SideQuest[66],"Defeat Valigarmanda and free the dwarves.")
    call PauseUnitBJ(false,gg_unit_n0MC_0265)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_n0MC_0265) // 'A0VJ': ability "Unaffected by Cinematics"
    call GroupAddUnitSimple(gg_unit_n0MC_0265,udg_BossUnits)
    set udg_ValigarmandaWaveIndex=1
    call StartTimerBJ(udg_ValigarmandaWaveTimer,false,120.)
    call ConditionalTriggerExecute(gg_trg_Valigarmanda_Wave_Spawn)
    call EnableTrigger(gg_trg_Valigarmanda_Wave_Cleared)
    call EnableTrigger(gg_trg_Valigarmanda_Wave_Reset)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Valigarmanda_Wave_Cleared_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_ValigarmandaMinions))
endfunction

function Trig_Valigarmanda_Wave_Cleared_AllWavesDone takes nothing returns boolean
    // (udg_Difficulty) plus (1).
    return(udg_ValigarmandaWaveIndex>=(udg_Difficulty+1))
endfunction

function Trig_Valigarmanda_Wave_Cleared_WaveGroupEmpty takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_ValigarmandaMinions))
endfunction

function Trig_Valigarmanda_Wave_Cleared_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ValigarmandaMinions)
    if(Trig_Valigarmanda_Wave_Cleared_WaveGroupEmpty())then
        if(Trig_Valigarmanda_Wave_Cleared_AllWavesDone())then
            call DisableTrigger(GetTriggeringTrigger())
            call DisableTrigger(gg_trg_Valigarmanda_Wave_Reset)
            call DestroyTrigger(gg_trg_Valigarmanda_Wave_Reset)
            call PauseTimerBJ(true,udg_ValigarmandaWaveTimer)
            call EnableTrigger(gg_trg_Valigarmanda_Death)
            call SetUnitInvulnerable(gg_unit_n0MC_0265,false)
            call UnitRemoveAbilityBJ('Abun',gg_unit_n0MC_0265) // 'Abun': object name not found in map data
            call IssueTargetOrderBJ(gg_unit_n0MC_0265,"bloodlust",gg_unit_n0MC_0265)
            set udg_TempPoint=GetUnitLoc(gg_unit_n0MC_0265)
            set udg_TempPoint2=OffsetLocation(udg_TempPoint,220.,.0)
            call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
            call RemoveLocation(udg_TempPoint2)
            call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
            call SetUnitManaPercentBJ(GetLastCreatedUnit(),'d')
            set udg_TempPoint2=OffsetLocation(udg_TempPoint,-220.,.0)
            call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
            call RemoveLocation(udg_TempPoint2)
            call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
            call SetUnitManaPercentBJ(GetLastCreatedUnit(),'d')
            call RemoveLocation(udg_TempPoint)
            call DestroyTrigger(GetTriggeringTrigger())
        else
            set udg_ValigarmandaWaveIndex=(udg_ValigarmandaWaveIndex+1)
            call StartTimerBJ(udg_ValigarmandaWaveTimer,false,120.)
            call ConditionalTriggerExecute(gg_trg_Valigarmanda_Wave_Spawn)
        endif
    endif
endfunction

function Trig_Valigarmanda_Wave_Spawn_BossFarFromArena takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)>=1200.)
endfunction

function Trig_Valigarmanda_Wave_Spawn_BossOutOfArena takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)>=650.)
endfunction

function Trig_Valigarmanda_Wave_Spawn_WaveIs1 takes nothing returns boolean
    return(udg_ValigarmandaWaveIndex==1)
endfunction

function Trig_Valigarmanda_Wave_Spawn_WaveIs2 takes nothing returns boolean
    return(udg_ValigarmandaWaveIndex==2)
endfunction

function Trig_Valigarmanda_Wave_Spawn_WaveIs3 takes nothing returns boolean
    return(udg_ValigarmandaWaveIndex==3)
endfunction

function Trig_Valigarmanda_Wave_Spawn_WaveIs4 takes nothing returns boolean
    return(udg_ValigarmandaWaveIndex==4)
endfunction

function Trig_Valigarmanda_Wave_Spawn_WaveIs5 takes nothing returns boolean
    return(udg_ValigarmandaWaveIndex==5)
endfunction

function Trig_Valigarmanda_Wave_Spawn_WaveIs6 takes nothing returns boolean
    return(udg_ValigarmandaWaveIndex==6)
endfunction

function Trig_Valigarmanda_Wave_Spawn_WaveIs7OrMore takes nothing returns boolean
    return(udg_ValigarmandaWaveIndex>=7)
endfunction

function Trig_Valigarmanda_Wave_Spawn_BuffSpawnedUnit takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Unit_ScaleToLevel60(GetEnumUnit())
    call SetUnitManaPercentBJ(GetEnumUnit(),'d')
endfunction

function Trig_Valigarmanda_Wave_Spawn_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_697)
    set udg_TempPoint2=GetUnitLoc(gg_unit_n0MC_0265)
    if(Trig_Valigarmanda_Wave_Spawn_BossOutOfArena())then
        if(Trig_Valigarmanda_Wave_Spawn_BossFarFromArena())then
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call SetUnitPositionLocFacingBJ(gg_unit_n0MC_0265,udg_TempPoint,270.)
            call AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0MC_0265,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        else
            call IssuePointOrderLocBJ(gg_unit_n0MC_0265,"move",udg_TempPoint)
        endif
    endif
    call RemoveLocation(udg_TempPoint2)
    if(Trig_Valigarmanda_Wave_Spawn_WaveIs1())then
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,200.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-100.,200.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,200.,.0)
        call CreateNUnitsAtLoc(1,'n026',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n026': unit "Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,.0)
        call CreateNUnitsAtLoc(1,'n026',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n026': unit "Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
    endif
    if(Trig_Valigarmanda_Wave_Spawn_WaveIs2())then
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,200.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-100.,200.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,200.,.0)
        call CreateNUnitsAtLoc(1,'n029',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n029': unit "Ice Troll"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,.0)
        call CreateNUnitsAtLoc(1,'n029',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n029': unit "Ice Troll"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,.0,-200.)
        call CreateNUnitsAtLoc(1,'n028',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n028': unit "Great Polar Bear"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
    endif
    if(Trig_Valigarmanda_Wave_Spawn_WaveIs3())then
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,200.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-100.,200.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,200.,.0)
        call CreateNUnitsAtLoc(1,'n027',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n027': unit "Elder Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,.0)
        call CreateNUnitsAtLoc(1,'n027',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n027': unit "Elder Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,.0,-200.)
        call CreateNUnitsAtLoc(1,'n026',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n026': unit "Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,175.,-200.)
        call CreateNUnitsAtLoc(1,'n026',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n026': unit "Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-175.,-200.)
        call CreateNUnitsAtLoc(1,'n026',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n026': unit "Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
    endif
    if(Trig_Valigarmanda_Wave_Spawn_WaveIs4())then
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,200.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-100.,200.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,200.,.0)
        call CreateNUnitsAtLoc(1,'n02C',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02C': unit "Icy Whelp"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,.0)
        call CreateNUnitsAtLoc(1,'n02C',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02C': unit "Icy Whelp"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,175.,-200.)
        call CreateNUnitsAtLoc(1,'n027',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n027': unit "Elder Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-175.,-200.)
        call CreateNUnitsAtLoc(1,'n027',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n027': unit "Elder Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,.0,-200.)
        call CreateNUnitsAtLoc(1,'n028',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n028': unit "Great Polar Bear"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
    endif
    if(Trig_Valigarmanda_Wave_Spawn_WaveIs5())then
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,200.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-100.,200.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,200.,.0)
        call CreateNUnitsAtLoc(1,'n029',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n029': unit "Ice Troll"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,.0)
        call CreateNUnitsAtLoc(1,'n029',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n029': unit "Ice Troll"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,187.5,-100.)
        call CreateNUnitsAtLoc(1,'n02A',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02A': unit "Ice Tusk Warrior"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-187.5,-100.)
        call CreateNUnitsAtLoc(1,'n02A',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02A': unit "Ice Tusk Warrior"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,175.,-200.)
        call CreateNUnitsAtLoc(1,'n02A',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02A': unit "Ice Tusk Warrior"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-175.,-200.)
        call CreateNUnitsAtLoc(1,'n02A',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02A': unit "Ice Tusk Warrior"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,.0,-200.)
        call CreateNUnitsAtLoc(1,'n02A',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02A': unit "Ice Tusk Warrior"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
    endif
    if(Trig_Valigarmanda_Wave_Spawn_WaveIs6())then
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,200.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-100.,200.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,200.,.0)
        call CreateNUnitsAtLoc(1,'n029',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n029': unit "Ice Troll"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,.0)
        call CreateNUnitsAtLoc(1,'n029',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n029': unit "Ice Troll"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-450.,10.)
        call CreateNUnitsAtLoc(1,'n02C',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02C': unit "Icy Whelp"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,450.,10.)
        call CreateNUnitsAtLoc(1,'n02C',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02C': unit "Icy Whelp"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,130.,-200.)
        call CreateNUnitsAtLoc(1,'n0CG',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CG': unit "Bandersnatch"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-130.,-200.)
        call CreateNUnitsAtLoc(1,'n0CG',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CG': unit "Bandersnatch"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
    endif
    if(Trig_Valigarmanda_Wave_Spawn_WaveIs7OrMore())then
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,200.)
        call CreateNUnitsAtLoc(1,'n027',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n027': unit "Elder Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-100.,200.)
        call CreateNUnitsAtLoc(1,'n027',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n027': unit "Elder Wendigo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,200.,.0)
        call CreateNUnitsAtLoc(1,'n0CG',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CG': unit "Bandersnatch"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,.0)
        call CreateNUnitsAtLoc(1,'n0CG',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CG': unit "Bandersnatch"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-450.,10.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,450.,10.)
        call CreateNUnitsAtLoc(1,'n02D',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02D': unit "Ice Troll Priest"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-360.,10.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,360.,10.)
        call CreateNUnitsAtLoc(1,'n025',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n025': unit "Wendigo Shaman"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,130.,-200.)
        call CreateNUnitsAtLoc(1,'n02C',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02C': unit "Icy Whelp"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-130.,-200.)
        call CreateNUnitsAtLoc(1,'n02C',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n02C': unit "Icy Whelp"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
    endif
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_ValigarmandaMinions,function Trig_Valigarmanda_Wave_Spawn_BuffSpawnedUnit)
endfunction

function Trig_Valigarmanda_Wave_Reset_Actions takes nothing returns nothing
    set udg_ValigarmandaWaveIndex=0
endfunction

function Trig_Valigarmanda_Death_KillLogEnabled takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Valigarmanda_Death_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Valigarmanda_Death_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Valigarmanda_Death_OreQuestDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[67]))
endfunction

function Trig_Valigarmanda_Death_RemoveFreedDwarf takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Valigarmanda_Death_PlayRescueScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Valigarmanda_Death_PriorQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$D])) // $D = 13
endfunction

function Trig_Valigarmanda_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Valigarmanda_Death_KillLogEnabled())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Valigarmanda_Death_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_n0MC_0265,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I00Y',udg_TempPoint) // 'I00Y': item "1000 Gold Coins"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_h00R_0256)
    call ShowUnitShow(gg_unit_Hmbr_0140)
    call ShowUnitShow(gg_unit_H00P_0260)
    call ShowUnitShow(gg_unit_h00Q_0255)
    call ShowUnitShow(gg_unit_h037_0257)
    if(Trig_Valigarmanda_Death_PlayRescueScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0MC_0265,0)
        if(Trig_Valigarmanda_Death_KilledByPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"Finally he's dead. Let's go free the dwarves.",false)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
        call Wait_Polled(1.5)
        set udg_TempPoint=GetRectCenter(gg_rct_705)
        call SetUnitPositionLocFacingBJ(udg_CinematicActor,udg_TempPoint,45.)
        call RemoveLocation(udg_TempPoint)
        call Cam_PanToUnit(udg_CinematicActor,0)
        call KillDestructable(gg_dest_LOcg_0070)
        call KillDestructable(gg_dest_LOcg_0071)
        call KillDestructable(gg_dest_LOcg_0042)
        call KillDestructable(gg_dest_LOcg_0031)
        call KillDestructable(gg_dest_LOcg_0069)
        call KillDestructable(gg_dest_LOcg_0032)
        call KillDestructable(gg_dest_LOcg_0029)
        set udg_TempPoint=GetDestructableLoc(gg_dest_LOcg_0070)
        call CreateNUnitsAtLoc(1,'h00R',Player(8),udg_TempPoint,270.) // 'h00R': unit "Giott"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint=GetDestructableLoc(gg_dest_LOcg_0071)
        call CreateNUnitsAtLoc(1,'Hmbr',Player(8),udg_TempPoint,270.) // 'Hmbr': unit "Smith"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint=GetDestructableLoc(gg_dest_LOcg_0042)
        call CreateNUnitsAtLoc(1,'H00P',Player(8),udg_TempPoint,270.) // 'H00P': unit "Forgefire"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint=GetDestructableLoc(gg_dest_LOcg_0031)
        call CreateNUnitsAtLoc(1,'h037',Player(8),udg_TempPoint,270.) // 'h037': unit "Alberich"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint=GetDestructableLoc(gg_dest_LOcg_0069)
        call CreateNUnitsAtLoc(1,'n02F',Player(8),udg_TempPoint,180.) // 'n02F': unit "Oaka IV"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        set udg_TempPoint=GetRectCenter(gg_rct_704)
        call CreateNUnitsAtLoc(1,'h00Q',Player(8),udg_TempPoint,180.) // 'h00Q': unit "Zone and Watts"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ValigarmandaMinions)
        call Wait_Polled(.5)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
        call Wait_Polled(1.5)
        call Text_Say(gg_unit_h00R_0256,"I can't thank ye enough. Ye saved our hides.",false)
        call Text_Say(udg_CinematicActor,"How did you get captured all the way out here?",false)
        call Text_Say(gg_unit_h037_0257,"Seems these brutes just walked down to our little settlement. This icy realm used to be closed off from the rest of Gaya specifically because they needed to be contained, but now it seems the barriers are all gone again. Along with their king and queen who kept them bound here.",false)
        call Text_Say(udg_CinematicActor,"I see. This place is a dangerous one indeed, home to very strong and aggressive monsters.",false)
        call Text_Say(gg_unit_n02F_0108,"You can say that again!",false)
        call Text_Say(udg_CinematicActor,"Right, you were captured here as well. But you're from around here, are you? Yet you don't seem aggressive like these other monsters.",false)
        call Text_Say(gg_unit_n02F_0108,"I do live here. This brute captured me a while ago already simply because I'm not a fighter! Thanks for taking him down, I never could stand his arrogance.",false)
        call Text_Say(udg_CinematicActor,"Well so long as you're not aggressive towards us you're free to go. Be careful where you stick around.",false)
        call Reward_Give(8000,8000,gg_unit_h00R_0256)
        if(Trig_Valigarmanda_Death_OreQuestDiscovered())then
            call Text_Say(udg_CinematicActor,"Say Loki, what happened to your designated protector? Wasn't he hired specifically to keep you safe from this kind of situation?",false)
            call Text_Say(gg_unit_H00P_0260,"Aye, but he was gone when this happened. He just up and left one day saying he had bigger things to look into and surely we'd be able to take care of ourselves for a minute. Figures guys like him are never around when you need them most.",false)
            call Text_Say(udg_CinematicActor,"Really a reliable fellow isn't he. I wonder where he went.",false)
        endif
        call Text_Say(gg_unit_h00R_0256,"Anyways, we be returnin' to our home for now. Thank ye again for savin' us.",false)
        call ForGroupBJ(udg_ValigarmandaMinions,function Trig_Valigarmanda_Death_RemoveFreedDwarf)
        call Cine_ExitAction()
    else
        call Reward_Give(8000,8000,gg_unit_h00R_0256)
        call KillDestructable(gg_dest_LOcg_0070)
        call KillDestructable(gg_dest_LOcg_0071)
        call KillDestructable(gg_dest_LOcg_0042)
        call KillDestructable(gg_dest_LOcg_0031)
        call KillDestructable(gg_dest_LOcg_0069)
        call KillDestructable(gg_dest_LOcg_0032)
        call KillDestructable(gg_dest_LOcg_0029)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Dwarf Disappearance|r")
    call QuestSetCompletedBJ(udg_SideQuest[66],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0C3',gg_unit_h030_0243,1,1) // 'n0C3': unit "Hunt: Parvati"
    set udg_HuntStock[8]=(udg_HuntStock[8]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call ConditionalTriggerExecute(gg_trg_HauntedTree_Prepare)
    call ShowUnitShow(gg_unit_H036_0254)
    if(Trig_Valigarmanda_Death_PriorQuestDone())then
        call ConditionalTriggerExecute(gg_trg_Ziegfried_Mine_Arrive)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Valigarmanda automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Valigarmanda (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Valigarmanda takes nothing returns nothing
endfunction

function Register_Valigarmanda_Confront takes nothing returns nothing
    set gg_trg_Valigarmanda_Confront=CreateTrigger()
    call DisableTrigger(gg_trg_Valigarmanda_Confront)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Valigarmanda_Confront,250.,gg_unit_n0MC_0265)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Valigarmanda_Confront,450.,gg_unit_n0MC_0265)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Valigarmanda_Confront,700.,gg_unit_n0MC_0265)
    call TriggerAddCondition(gg_trg_Valigarmanda_Confront,Condition(function Trig_Valigarmanda_Confront_Conditions))
    call TriggerAddAction(gg_trg_Valigarmanda_Confront,function Trig_Valigarmanda_Confront_Actions)
endfunction

function Register_Valigarmanda_Wave_Cleared takes nothing returns nothing
    set gg_trg_Valigarmanda_Wave_Cleared=CreateTrigger()
    call DisableTrigger(gg_trg_Valigarmanda_Wave_Cleared)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Valigarmanda_Wave_Cleared,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Valigarmanda_Wave_Cleared,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_Valigarmanda_Wave_Cleared,Condition(function Trig_Valigarmanda_Wave_Cleared_Conditions))
    call TriggerAddAction(gg_trg_Valigarmanda_Wave_Cleared,function Trig_Valigarmanda_Wave_Cleared_Actions)
endfunction

function Register_Valigarmanda_Wave_Spawn takes nothing returns nothing
    set gg_trg_Valigarmanda_Wave_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Valigarmanda_Wave_Spawn)
    call TriggerAddAction(gg_trg_Valigarmanda_Wave_Spawn,function Trig_Valigarmanda_Wave_Spawn_Actions)
endfunction

function Register_Valigarmanda_Wave_Reset takes nothing returns nothing
    set gg_trg_Valigarmanda_Wave_Reset=CreateTrigger()
    call DisableTrigger(gg_trg_Valigarmanda_Wave_Reset)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Valigarmanda_Wave_Reset,udg_ValigarmandaWaveTimer)
    call TriggerAddAction(gg_trg_Valigarmanda_Wave_Reset,function Trig_Valigarmanda_Wave_Reset_Actions)
endfunction

function Register_Valigarmanda_Death takes nothing returns nothing
    set gg_trg_Valigarmanda_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Valigarmanda_Death)
    call TriggerRegisterUnitEvent(gg_trg_Valigarmanda_Death,gg_unit_n0MC_0265,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Valigarmanda_Death,function Trig_Valigarmanda_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Valigarmanda takes nothing returns nothing
    call Register_Valigarmanda_Confront()
    call Register_Valigarmanda_Wave_Cleared()
    call Register_Valigarmanda_Wave_Spawn()
    call Register_Valigarmanda_Wave_Reset()
    call Register_Valigarmanda_Death()
endfunction

endlibrary

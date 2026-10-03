library TWanderer requires TForce, TMusic, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Wanderer_Quest_Init=null
    trigger gg_trg_Wanderer_Spawn=null
    trigger gg_trg_Wanderer_Request=null
    trigger gg_trg_Wanderer_Give_Item=null
    // Variables only this module uses.
    integer array udg_WandererUnitType
    integer array udg_WandererWantedItem
    integer array udg_WandererReward
    integer udg_WandererChainCount=0
endglobals

function Trig_Wanderer_Quest_Init_Actions takes nothing returns nothing
    set udg_WandererUnitType[1]='nftr' // 'nftr': unit "Forest Goblin"
    set udg_WandererUnitType[2]='ncea' // 'ncea': object name not found in map data
    set udg_WandererUnitType[3]='nhyd' // 'nhyd': object name not found in map data
    set udg_WandererUnitType[4]='nogr' // 'nogr': object name not found in map data
    set udg_WandererUnitType[5]='ngst' // 'ngst': object name not found in map data
    set udg_WandererUnitType[6]='nnsw' // 'nnsw': object name not found in map data
    set udg_WandererUnitType[7]='nsty' // 'nsty': editor label "Satyr"
    set udg_WandererUnitType[8]='n026' // 'n026': unit "Wendigo"
    set udg_WandererUnitType[9]='n03B' // 'n03B': unit "Tonberry"
    set udg_WandererUnitType[$B]='n044' // $B = 11; 'n044': unit "PuPu"
    set udg_WandererWantedItem[1]='I06G' // 'I06G': item "Forest Essence"
    set udg_WandererWantedItem[2]='I06K' // 'I06K': item "Barrens' Sand"
    set udg_WandererWantedItem[3]='I06N' // 'I06N': item "Tropical Essence"
    set udg_WandererWantedItem[4]='I074' // 'I074': item "Mine Mineral"
    set udg_WandererWantedItem[5]='I06R' // 'I06R': item "Wild Soul"
    set udg_WandererWantedItem[6]='I06T' // 'I06T': item "Theurgic Water"
    set udg_WandererWantedItem[7]='I068' // 'I068': item "Ancient Spirit"
    set udg_WandererWantedItem[8]='I06X' // 'I06X': item "Unique Ice Shard"
    set udg_WandererWantedItem[9]='I07A' // 'I07A': item "Fairy Voodoo"
    set udg_WandererWantedItem[$A]='I0H1' // $A = 10; 'I0H1': item "Mina"
    set udg_WandererWantedItem[$B]='I0EE' // $B = 11; 'I0EE': item "Fairy Doll"
    set udg_WandererWantedItem[$C]='I0CR' // $C = 12; 'I0CR': item "Crystal Pieces"
    set udg_WandererReward[1]='I01Z' // 'I01Z': item "Crystal Shard"
    set udg_WandererReward[2]='sror' // 'sror': item "Spirit of Lowtown"
    set udg_WandererReward[3]='I085' // 'I085': item "Wild Cry"
    set udg_WandererReward[4]='I07C' // 'I07C': item "Nethril"
    set udg_WandererReward[5]='I08L' // 'I08L': item "Healing Herb"
    set udg_WandererReward[6]='I08B' // 'I08B': item "Serpent Gem"
    set udg_WandererReward[7]='I010' // 'I010': item "Save the Queen"
    set udg_WandererReward[8]='I089' // 'I089': item "Soul Powder"
    set udg_WandererReward[9]='pres' // 'pres': item "Elixir"
    set udg_WandererReward[$B]='I03P' // $B = 11; 'I03P': item "Megalixir"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Wanderer_Spawn_Cond_SpawnPuPu takes nothing returns boolean
    return(udg_ZoneStreakID[GetForLoopIndexA()]==-7)and(udg_ZoneKillStreak[GetForLoopIndexA()]>=20)and(udg_WandererSpawned[$B]==false) // $B = 11
endfunction

function Trig_Wanderer_Spawn_Cond_SpawnWanderer takes nothing returns boolean
    return(udg_WandererSpawned[GetForLoopIndexB()]==false)and(udg_ZoneStreakID[GetForLoopIndexA()]==GetForLoopIndexB())and(udg_ZoneKillStreak[GetForLoopIndexA()]>='d')
endfunction

function Trig_Wanderer_Spawn_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Wanderer_Spawn_Cond_SpawnPuPu())then
            // A random whole number from 1 through 9.
            set udg_TempInteger=GetRandomInt(1,9)
            // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
            set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
            call CreateNUnitsAtLoc(1,'n044',Player(9),udg_TempPoint,GetRandomDirectionDeg()) // 'n044': unit "PuPu"
            call RemoveLocation(udg_TempPoint)
            call SetUnitInvulnerable(GetLastCreatedUnit(),true)
            call UnitAddAbilityBJ('AInv',GetLastCreatedUnit()) // 'AInv': standard ability reference "Inventory"
            call UnitAddAbilityBJ('A0VJ',GetLastCreatedUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
            call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
            call PauseUnitBJ(true,GetLastCreatedUnit())
            set udg_WandererSpawned[$B]=true // $B = 11
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set bj_forLoopBIndex=1
        set bj_forLoopBIndexEnd=9
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            if(Trig_Wanderer_Spawn_Cond_SpawnWanderer())then
                // A random whole number from 1 through LoadIntegerBJ(loop counter B, 2, udg_SpawnDataHashRef).
                set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(GetForLoopIndexB(),2,udg_SpawnDataHashRef)),GetForLoopIndexB(),udg_SpawnRectHashRef))
                call CreateNUnitsAtLoc(1,udg_WandererUnitType[GetForLoopIndexB()],Player(9),udg_TempPoint,GetRandomDirectionDeg())
                call RemoveLocation(udg_TempPoint)
                call SetUnitInvulnerable(GetLastCreatedUnit(),true)
                call UnitAddAbilityBJ('AInv',GetLastCreatedUnit()) // 'AInv': standard ability reference "Inventory"
                call UnitAddAbilityBJ('A0VJ',GetLastCreatedUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
                call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
                call IssueImmediateOrderBJ(GetLastCreatedUnit(),"holdposition")
                call PauseUnitBJ(true,GetLastCreatedUnit())
                set udg_WandererSpawned[GetForLoopIndexB()]=true
            endif
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

function Trig_Wanderer_Request_Conditions takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player(9))and(GetUnitTypeId(GetTriggerUnit())==udg_WandererUnitType[GetUnitPointValue(GetTriggerUnit())])and(Unit_PlayersNearby(450,GetTriggerUnit(),false,false,true))
endfunction

function Trig_Wanderer_Request_Actions takes nothing returns nothing
    local location l_tempPoint
    call Music_SetTrack(38)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc(udg_WandererWantedItem[GetUnitPointValue(GetTriggerUnit())],l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),(GetUnitName(GetTriggerUnit())+(": Give me |cffffcc00"+(GetItemName(GetLastCreatedItem())+"|r, please!"))))
    call RemoveItem(GetLastCreatedItem())
    set l_tempPoint=null
endfunction

function Trig_Wanderer_Give_Item_Conditions takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player(9))and(GetUnitTypeId(GetTriggerUnit())==udg_WandererUnitType[GetUnitPointValue(GetTriggerUnit())])
endfunction

function Trig_Wanderer_Give_Item_Cond_ItemStackMulti takes nothing returns boolean
    return(GetItemCharges(GetManipulatedItem())>=2)
endfunction

function Trig_Wanderer_Give_Item_Cond_NotLastWanderer takes nothing returns boolean
    return(GetUnitPointValue(GetTriggerUnit())!=$B) // $B = 11
endfunction

function Trig_Wanderer_Give_Item_Cond_IsNinthWanderer takes nothing returns boolean
    return(GetUnitPointValue(GetTriggerUnit())==9)
endfunction

function Trig_Wanderer_Give_Item_Cond_IsEarlyWanderer takes nothing returns boolean
    return(GetUnitPointValue(GetTriggerUnit())<=8)
endfunction

function Trig_Wanderer_Give_Item_Cond_IsWantedItem takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())==udg_WandererWantedItem[GetUnitPointValue(GetTriggerUnit())])
endfunction

function Trig_Wanderer_Give_Item_Actions takes nothing returns nothing
    if(Trig_Wanderer_Give_Item_Cond_IsWantedItem())then
        if(Trig_Wanderer_Give_Item_Cond_ItemStackMulti())then
            call SetItemCharges(GetManipulatedItem(),(GetItemCharges(GetManipulatedItem())-1))
            call UnitRemoveItemSwapped(GetManipulatedItem(),GetTriggerUnit())
        else
            call RemoveItem(GetManipulatedItem())
        endif
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call CreateItemLoc(udg_WandererWantedItem[(GetUnitPointValue(GetTriggerUnit())+1)],udg_TempPoint)
        call CreateItemLoc(udg_WandererReward[GetUnitPointValue(GetTriggerUnit())],udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        if(Trig_Wanderer_Give_Item_Cond_NotLastWanderer())then
            set udg_WandererChainCount=(udg_WandererChainCount+1)
        endif
        if(Trig_Wanderer_Give_Item_Cond_IsEarlyWanderer())then
            call SaveIntegerBJ(1,2,($9A+GetUnitPointValue(GetTriggerUnit())),udg_GameStateHash) // $9A = 154
        else
            if(Trig_Wanderer_Give_Item_Cond_IsNinthWanderer())then
                call SaveIntegerBJ(1,2,75,udg_GameStateHash)
            endif
        endif
        call DisplayTextToForce(udg_PlayingPlayers,(GetUnitName(GetTriggerUnit())+": Thanks!"))
        call RemoveUnit(GetTriggerUnit())
        call Music_ClearTrack(38)
    else
        call UnitRemoveItemSwapped(GetManipulatedItem(),GetTriggerUnit())
    endif
endfunction

// World Editor calls InitTrig_Wanderer automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Wanderer (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Wanderer takes nothing returns nothing
endfunction

function Register_Wanderer_Quest_Init takes nothing returns nothing
    set gg_trg_Wanderer_Quest_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Wanderer_Quest_Init,2.)
    call TriggerAddAction(gg_trg_Wanderer_Quest_Init,function Trig_Wanderer_Quest_Init_Actions)
endfunction

function Register_Wanderer_Spawn takes nothing returns nothing
    set gg_trg_Wanderer_Spawn=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Wanderer_Spawn,8.)
    call TriggerAddAction(gg_trg_Wanderer_Spawn,function Trig_Wanderer_Spawn_Actions)
endfunction

function Register_Wanderer_Request takes nothing returns nothing
    set gg_trg_Wanderer_Request=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Wanderer_Request,Player(7),true)
    call TriggerAddCondition(gg_trg_Wanderer_Request,Condition(function Trig_Wanderer_Request_Conditions))
    call TriggerAddAction(gg_trg_Wanderer_Request,function Trig_Wanderer_Request_Actions)
endfunction

function Register_Wanderer_Give_Item takes nothing returns nothing
    set gg_trg_Wanderer_Give_Item=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Wanderer_Give_Item,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Wanderer_Give_Item,Condition(function Trig_Wanderer_Give_Item_Conditions))
    call TriggerAddAction(gg_trg_Wanderer_Give_Item,function Trig_Wanderer_Give_Item_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Wanderer takes nothing returns nothing
    call Register_Wanderer_Quest_Init()
    call Register_Wanderer_Spawn()
    call Register_Wanderer_Request()
    call Register_Wanderer_Give_Item()
endfunction

endlibrary

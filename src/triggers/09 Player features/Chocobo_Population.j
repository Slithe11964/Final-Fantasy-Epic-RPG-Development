library TChocoboPopulation
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chocobo_Init=null
    trigger gg_trg_Chocobo_Spawn_Periodic=null
    trigger gg_trg_Chocobo_Respawn=null
endglobals

function Trig_Chocobo_Init_Actions takes nothing returns nothing
    call SetPlayerTechResearchedSwap('R00J',1,Player($B)) // 'R00J': upgrade "Enemy Chocobo"; $B = 11
    call SetPlayerTechResearchedSwap('R00Q',1,Player($B)) // 'R00Q': upgrade "Enemy Chocobo"; $B = 11
    call SetPlayerTechResearchedSwap('R00R',1,Player($B)) // 'R00R': upgrade "Enemy Chocobo"; $B = 11
    call SetPlayerTechResearchedSwap('R00S',1,Player($B)) // 'R00S': upgrade "Enemy Chocobo"; $B = 11
    call SetPlayerTechResearchedSwap('R00X',1,Player($B)) // 'R00X': upgrade "Enemy Chocobo"; $B = 11
    call SetPlayerTechResearchedSwap('R00W',1,Player($B)) // 'R00W': upgrade "Enemy Chocobo"; $B = 11
    call SetPlayerTechResearchedSwap('R010',1,Player($B)) // 'R010': upgrade "Enemy Chocobo"; $B = 11
    set udg_ChocoboAbility[3]='A0D5' // 'A0D5': ability "Quick Join Fast"
    set udg_ChocoboAbility[4]='A0D8' // 'A0D8': ability "Shadow Mimic"
    set udg_ChocoboAbility[5]='A0D6' // 'A0D6': ability "Trickster's Sprint"
    set udg_ChocoboAbility[6]='A0DH' // 'A0DH': ability "Regeneration"
    set udg_ChocoboAbility[7]='A0C9' // 'A0C9': ability "Teleport"
    set udg_ChocoboAbility[8]='S008' // 'S008': ability "Feather Aura"
    set udg_ChocoboAbility[9]='A0DC' // 'A0DC': ability "Chocry"
    set udg_ChocoboAbility[$A]='A0K9' // $A = 10; 'A0K9': ability "Choco-Armor Aura"
    set udg_ChocoboAbility[$B]='A0DA' // $B = 11; 'A0DA': ability "Chocobo Slow"
    set udg_ChocoboAbility[$C]='A071' // $C = 12; 'A071': ability "Bribe"
    set udg_ChocoboAbility[$D]='A0D9' // $D = 13; 'A0D9': ability "Chocobo Haste"
    set udg_ChocoboAbility[$E]='A0D7' // $E = 14; 'A0D7': ability "Chocommando Aura"
    set udg_ChocoboAbility[$F]='A0DI' // $F = 15; 'A0DI': ability "Attack"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=9
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // A random whole number from 1 through LoadIntegerBJ(loop counter A, 2, udg_SpawnDataHashRef).
        set udg_ChocoboDigSpot[GetForLoopIndexA()]=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(GetForLoopIndexA(),2,udg_SpawnDataHashRef)),GetForLoopIndexA(),udg_SpawnRectHashRef))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=$A // $A = 10
    set bj_forLoopAIndexEnd=20
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // A random whole number from 1 through 9.
        set udg_ChocoboRegionIndex=GetRandomInt(1,9)
        // A random whole number from 1 through LoadIntegerBJ(udg_ChocoboRegionIndex, 2, udg_SpawnDataHashRef).
        set udg_ChocoboDigSpot[GetForLoopIndexA()]=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_ChocoboRegionIndex,2,udg_SpawnDataHashRef)),udg_ChocoboRegionIndex,udg_SpawnRectHashRef))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_ChocoboDigSpot[21]=GetRectCenter(gg_rct_553)
    set udg_ChocoboDigSpot[22]=GetRectCenter(gg_rct_554)
    set udg_ChocoboDigSpot[23]=GetRectCenter(gg_rct_555)
    set udg_ChocoboDigSpot[24]=GetRectCenter(gg_rct_476)
    set udg_ChocoboDigSpot[25]=GetRectCenter(gg_rct_556)
    set udg_ChocoboDigSpot[26]=GetRectCenter(gg_rct_477)
    set udg_ChocoboDigSpot[27]=GetRectCenter(gg_rct_557)
    set udg_ChocoboDigSpot[28]=GetRectCenter(gg_rct_474)
    set udg_ChocoboDigSpot[29]=GetRectCenter(gg_rct_558)
    set udg_ChocoboDigSpot[30]=GetRectCenter(gg_rct_475)
    set udg_ChocoboDigSpot[31]=GetRectCenter(gg_rct_457)
    set udg_ChocoboDigSpot[32]=GetRectCenter(gg_rct_552)
    set udg_ChocoboDigSpot[33]=GetRectCenter(gg_rct_707)
    set udg_ChocoboDigSpot[34]=GetRectCenter(gg_rct_713)
    set udg_ChocoboDigSpot[99]=GetRectCenter(gg_rct_648)
    set udg_ChocoboDigSpotCount=34
    set udg_ChocoboDigItem[1]='I000' // 'I000': item "X-Potion"
    set udg_ChocoboDigItemCharges[1]=3
    set udg_ChocoboDigItem[2]='I002' // 'I002': item "Turbo Ether"
    set udg_ChocoboDigItemCharges[2]=3
    set udg_ChocoboDigItem[3]='pres' // 'pres': item "Elixir"
    set udg_ChocoboDigItemCharges[3]=3
    set udg_ChocoboDigItem[4]='I05I' // 'I05I': item "Spirit Potion"
    set udg_ChocoboDigItemCharges[4]=3
    set udg_ChocoboDigItem[5]='I05H' // 'I05H': item "Blood Ether"
    set udg_ChocoboDigItemCharges[5]=3
    set udg_ChocoboDigItem[6]='I045' // 'I045': item "Pram Nut"
    set udg_ChocoboDigItemCharges[6]=4
    set udg_ChocoboDigItem[7]='sror' // 'sror': item "Spirit of Lowtown"
    set udg_ChocoboDigItemCharges[7]=3
    set udg_ChocoboDigItem[8]='I07G' // 'I07G': item "Carob Nut"
    set udg_ChocoboDigItemCharges[8]=2
    set udg_ChocoboDigItem[9]='I01Z' // 'I01Z': item "Crystal Shard"
    set udg_ChocoboDigItem[$A]='I00Y' // $A = 10; 'I00Y': item "1000 Gold Coins"
    set udg_ChocoboDigItem[$B]='I02V' // $B = 11; 'I02V': item "Nectar"
    set udg_ChocoboDigItemCharges[$B]=4 // $B = 11
    set udg_ChocoboDigItem[$C]='I02X' // $C = 12; 'I02X': item "Greater Nectar"
    set udg_ChocoboDigItemCharges[$C]=3 // $C = 12
    set udg_ChocoboDigItem[$D]='I07F' // $D = 13; 'I07F': item "Luchil Nut"
    set udg_ChocoboDigItemCharges[$D]=5 // $D = 13
    set udg_ChocoboDigItem[$E]='pdiv' // $E = 14; 'pdiv': item "Hero Drink"
    set udg_ChocoboDigItemCharges[$E]=5 // $E = 14
    set udg_ChocoboDigItem[$F]='I021' // $F = 15; 'I021': item "1500 Gold Coins"
    set udg_ChocoboDigItem[16]='I05I' // 'I05I': item "Spirit Potion"
    set udg_ChocoboDigItemCharges[16]=4
    set udg_ChocoboDigItem[17]='I05H' // 'I05H': item "Blood Ether"
    set udg_ChocoboDigItemCharges[17]=4
    set udg_ChocoboDigItem[18]='I0DI' // 'I0DI': item "Remedy"
    set udg_ChocoboDigItemCharges[18]=4
    set udg_ChocoboDigItem[19]='I0CR' // 'I0CR': item "Crystal Pieces"
    set udg_ChocoboDigItem[20]='I0CV' // 'I0CV': item "10000 Gold Coins"
    set udg_ChocoboDigItem[21]='I06G' // 'I06G': item "Forest Essence"
    set udg_ChocoboDigItemCharges[21]=5
    set udg_ChocoboDigItem[22]='I06K' // 'I06K': item "Barrens' Sand"
    set udg_ChocoboDigItemCharges[22]=5
    set udg_ChocoboDigItem[23]='I06N' // 'I06N': item "Tropical Essence"
    set udg_ChocoboDigItemCharges[23]=5
    set udg_ChocoboDigItem[24]='I06R' // 'I06R': item "Wild Soul"
    set udg_ChocoboDigItemCharges[24]=5
    set udg_ChocoboDigItem[25]='I074' // 'I074': item "Mine Mineral"
    set udg_ChocoboDigItemCharges[25]=5
    set udg_ChocoboDigItem[26]='I06T' // 'I06T': item "Theurgic Water"
    set udg_ChocoboDigItemCharges[26]=5
    set udg_ChocoboDigItem[27]='I068' // 'I068': item "Ancient Spirit"
    set udg_ChocoboDigItemCharges[27]=5
    set udg_ChocoboDigItem[28]='I06X' // 'I06X': item "Unique Ice Shard"
    set udg_ChocoboDigItemCharges[28]=5
    set udg_ChocoboDigItem[29]='I0EE' // 'I0EE': item "Fairy Doll"
    set udg_ChocoboDigItem[30]='I027' // 'I027': item "Gysahl Greens"
    set udg_ChocoboDigItem[31]='I0K8' // 'I0K8': item "Buddha Fist"
    set udg_ChocoboDigItem[32]='I0EA' // 'I0EA': item "Black Hole"
    set udg_ChocoboDigItem[33]='I0KE' // 'I0KE': item "Silkis Greens"
    set udg_ChocoboDigItem[34]='I0D1' // 'I0D1': item "Storm Lance"
    set udg_ChocoboDigItem[99]='I0FP' // 'I0FP': item "Wirt's Leg"
    // A random whole number from 1 through LoadIntegerBJ(1, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(1,2,udg_SpawnDataHashRef)),1,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n02J',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02J': unit "Chocobo"
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TownNpcUnits)
    // A random whole number from 1 through LoadIntegerBJ(3, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(3,2,udg_SpawnDataHashRef)),3,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n02S',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02S': unit "Chocobo"
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TownNpcUnits)
    // A random whole number from 1 through LoadIntegerBJ(7, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(7,2,udg_SpawnDataHashRef)),7,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n02T',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02T': unit "Chocobo"
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TownNpcUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Chocobo_Spawn_Periodic_Conditions takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(CountUnitsInGroup(udg_TownNpcUnits)<$F)and(GetRandomInt(1,2)!=1)and(udg_SpawnsPaused==false) // $F = 15
endfunction

function Trig_Chocobo_Spawn_Periodic_RollThirdChocoboType takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Chocobo_Spawn_Periodic_RollSecondChocoboType takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Chocobo_Spawn_Periodic_RollRareChocobo takes nothing returns boolean
    // A random whole number from 1 through 4.
    return(udg_ZodiacQuestStage>=7)and(GetRandomInt(1,4)==1)
endfunction

function Trig_Chocobo_Spawn_Periodic_Actions takes nothing returns nothing
    if(Trig_Chocobo_Spawn_Periodic_RollRareChocobo())then
        // A random whole number from 1 through LoadIntegerBJ(8, 2, udg_SpawnDataHashRef).
        set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(8,2,udg_SpawnDataHashRef)),8,udg_SpawnRectHashRef))
        call CreateNUnitsAtLoc(1,'n02U',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02U': unit "Chocobo"
    else
        if(Trig_Chocobo_Spawn_Periodic_RollSecondChocoboType())then
            // A random whole number from 1 through LoadIntegerBJ(1, 2, udg_SpawnDataHashRef).
            set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(1,2,udg_SpawnDataHashRef)),1,udg_SpawnRectHashRef))
            call CreateNUnitsAtLoc(1,'n02J',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02J': unit "Chocobo"
        else
            if(Trig_Chocobo_Spawn_Periodic_RollThirdChocoboType())then
                // A random whole number from 1 through LoadIntegerBJ(7, 2, udg_SpawnDataHashRef).
                set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(7,2,udg_SpawnDataHashRef)),7,udg_SpawnRectHashRef))
                call CreateNUnitsAtLoc(1,'n02T',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02T': unit "Chocobo"
            else
                // A random whole number from 1 through LoadIntegerBJ(3, 2, udg_SpawnDataHashRef).
                set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(3,2,udg_SpawnDataHashRef)),3,udg_SpawnRectHashRef))
                call CreateNUnitsAtLoc(1,'n02S',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02S': unit "Chocobo"
            endif
        endif
    endif
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TownNpcUnits)
endfunction

function Trig_Chocobo_Respawn_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n038') // 'n038': unit "Chocobo"
endfunction

function Trig_Chocobo_Respawn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetRectCenter(gg_rct_208)
    call CreateNUnitsAtLoc(1,'n04J',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n04J': unit "Chocobo"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call TriggerRegisterUnitEvent(gg_trg_Chocobo_Drop_Nut,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Chocobo_Drop_Nut)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Chocobo_Population takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Chocobo_Part1, RegisterTriggers_Chocobo_Part2 (module Chocobo),
// which keeps the original registration order.

function Register_Chocobo_Init takes nothing returns nothing
    set gg_trg_Chocobo_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Chocobo_Init,20.)
    call TriggerAddAction(gg_trg_Chocobo_Init,function Trig_Chocobo_Init_Actions)
endfunction

function Register_Chocobo_Spawn_Periodic takes nothing returns nothing
    set gg_trg_Chocobo_Spawn_Periodic=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Chocobo_Spawn_Periodic,120.)
    call TriggerAddCondition(gg_trg_Chocobo_Spawn_Periodic,Condition(function Trig_Chocobo_Spawn_Periodic_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Spawn_Periodic,function Trig_Chocobo_Spawn_Periodic_Actions)
endfunction

function Register_Chocobo_Respawn takes nothing returns nothing
    set gg_trg_Chocobo_Respawn=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Respawn,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Chocobo_Respawn,Condition(function Trig_Chocobo_Respawn_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Respawn,function Trig_Chocobo_Respawn_Actions)
endfunction

endlibrary

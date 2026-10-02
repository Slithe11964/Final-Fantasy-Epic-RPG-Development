library TSummonItems requires TPlayerPart01, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Summon_Item_Dropped=null
endglobals

function Trig_Summon_Item_Dropped_IsSummonItem takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I05O')or(GetItemTypeId(GetManipulatedItem())=='I0A3')or(GetItemTypeId(GetManipulatedItem())=='I0D5')or(GetItemTypeId(GetManipulatedItem())=='I0EA')or(GetItemTypeId(GetManipulatedItem())=='I0F0')or(GetItemTypeId(GetManipulatedItem())=='I08S')or(GetItemTypeId(GetManipulatedItem())=='I0L5')or(GetItemTypeId(GetManipulatedItem())=='I0BK') // 'I05O': item "Perfect Mark of Darkness"; 'I0A3': item "Excalipoor"; 'I0D5': item "Judge's Helm"; 'I0EA': item "Black Hole"; 'I0F0': item "Magatama"; 'I08S': item "Spirit Pendant"; 'I0L5': item "Dragon Remains"; 'I0BK': item "Horn of Madain Sari"
endfunction

function Trig_Summon_Item_Dropped_Conditions takes nothing returns boolean
    return(Trig_Summon_Item_Dropped_IsSummonItem())and(udg_InCinematicMode==false)and(udg_RingHintsReady)
endfunction

function Trig_Summon_Item_Dropped_IsSummonBlocked takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Summon_Item_Dropped_ItemOutsideCircle takes nothing returns boolean
    return(RectContainsLoc(gg_rct_472,udg_TempPoint)==false)
endfunction

function Trig_Summon_Item_Dropped_PlayerHeroInArena takes nothing returns boolean
    return(RectContainsUnit(gg_rct_496,Player_GetHero(GetEnumPlayer())))
endfunction

function Trig_Summon_Item_Dropped_CollectArenaPlayer takes nothing returns nothing
    if(Trig_Summon_Item_Dropped_PlayerHeroInArena())then
        call GroupAddUnitSimple(Player_GetHero(GetEnumPlayer()),udg_DuelArenaUnits)
        call ForceAddPlayerSimple(GetEnumPlayer(),udg_DuelArenaPlayers)
    endif
endfunction

function Trig_Summon_Item_Dropped_NoArenaPlayers takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_DuelArenaPlayers)<=0)
endfunction

function Trig_Summon_Item_Dropped_OneArenaPlayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_DuelArenaPlayers)==1)
endfunction

function Trig_Summon_Item_Dropped_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Summon_Item_Dropped_IsHornOfMadainSari takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0BK') // 'I0BK': item "Horn of Madain Sari"
endfunction

function Trig_Summon_Item_Dropped_IsDragonRemains takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0L5') // 'I0L5': item "Dragon Remains"
endfunction

function Trig_Summon_Item_Dropped_IsSpiritPendant takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I08S') // 'I08S': item "Spirit Pendant"
endfunction

function Trig_Summon_Item_Dropped_IsMagatama takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0F0') // 'I0F0': item "Magatama"
endfunction

function Trig_Summon_Item_Dropped_IsBlackHole takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0EA') // 'I0EA': item "Black Hole"
endfunction

function Trig_Summon_Item_Dropped_IsJudgesHelm takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0D5') // 'I0D5': item "Judge's Helm"
endfunction

function Trig_Summon_Item_Dropped_IsExcalipoor takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0A3') // 'I0A3': item "Excalipoor"
endfunction

function Trig_Summon_Item_Dropped_IsPerfectMarkOfDarkness takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I05O') // 'I05O': item "Perfect Mark of Darkness"
endfunction

function Trig_Summon_Item_Dropped_Actions takes nothing returns nothing
    set udg_RingHintsReady=false
    call Wait_Polled(.2)
    if(Trig_Summon_Item_Dropped_IsSummonBlocked())then
        set udg_RingHintsReady=true
        return
    endif
    set udg_TempPoint=GetItemLoc(GetManipulatedItem())
    if(Trig_Summon_Item_Dropped_ItemOutsideCircle())then
        call RemoveLocation(udg_TempPoint)
        set udg_RingHintsReady=true
        return
    endif
    call GroupClear(udg_DuelArenaUnits)
    call ForceClear(udg_DuelArenaPlayers)
    call ForForce(udg_PlayingPlayers,function Trig_Summon_Item_Dropped_CollectArenaPlayer)
    if(Trig_Summon_Item_Dropped_NoArenaPlayers())then
        set udg_RingHintsReady=true
        return
    endif
    if(Trig_Summon_Item_Dropped_OneArenaPlayer())then
        set udg_SummonerPlayer=ForcePickRandomPlayer(udg_DuelArenaPlayers)
    else
        set udg_SummonerPlayer=Player($B) // $B = 11
    endif
    set udg_SummonItem=GetManipulatedItem()
    if(Trig_Summon_Item_Dropped_IsWaygateOpen())then
        call WaygateActivateBJ(false,gg_unit_n0AP_0240)
        call DestroyEffectBJ(udg_SpecialEffect[78])
    endif
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-256.)
    call RemoveLocation(udg_TempPoint)
    call SetItemPositionLoc(udg_SummonItem,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call SetItemVisibleBJ(false,udg_SummonItem)
    call UnitRemoveAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    if(Trig_Summon_Item_Dropped_IsPerfectMarkOfDarkness())then
        call ConditionalTriggerExecute(gg_trg_Boss_Penance_Summon)
    else
        if(Trig_Summon_Item_Dropped_IsExcalipoor())then
            call ConditionalTriggerExecute(gg_trg_Boss_Gilgamesh_Summon)
        else
            if(Trig_Summon_Item_Dropped_IsJudgesHelm())then
                call ConditionalTriggerExecute(gg_trg_Boss_Judges_Summon)
            else
                if(Trig_Summon_Item_Dropped_IsBlackHole())then
                    call ConditionalTriggerExecute(gg_trg_Boss_BlackDevil_Summon)
                else
                    if(Trig_Summon_Item_Dropped_IsMagatama())then
                        call ConditionalTriggerExecute(gg_trg_Boss_DemiFiend_Summon)
                    else
                        if(Trig_Summon_Item_Dropped_IsSpiritPendant())then
                            call ConditionalTriggerExecute(gg_trg_Boss_DarkFact_Summon)
                        else
                            if(Trig_Summon_Item_Dropped_IsDragonRemains())then
                                call ConditionalTriggerExecute(gg_trg_Boss_Shinryu_Warmech_Summon)
                            else
                                if(Trig_Summon_Item_Dropped_IsHornOfMadainSari())then
                                    call ConditionalTriggerExecute(gg_trg_Boss_Ozma_Spawn)
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
endfunction

function InitTrig_Summon_Items takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Summon_Part4 (module Summon),
// which keeps the original registration order.

function Register_Summon_Item_Dropped takes nothing returns nothing
    set gg_trg_Summon_Item_Dropped=CreateTrigger()
    call DisableTrigger(gg_trg_Summon_Item_Dropped)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Item_Dropped,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Summon_Item_Dropped,Condition(function Trig_Summon_Item_Dropped_Conditions))
    call TriggerAddAction(gg_trg_Summon_Item_Dropped,function Trig_Summon_Item_Dropped_Actions)
endfunction

endlibrary

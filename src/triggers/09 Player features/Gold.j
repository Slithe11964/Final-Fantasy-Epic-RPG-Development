library TGold requires TWait
function Trig_Gold_Cap_Actions takes nothing returns nothing
    call SetPlayerStateBJ(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_GOLD,$F423F) // $F423F = 999999
endfunction

function Trig_Gold_Pickup_IsGoldItem takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='gold')or(GetItemTypeId(GetManipulatedItem())=='I004')or(GetItemTypeId(GetManipulatedItem())=='I005')or(GetItemTypeId(GetManipulatedItem())=='I003')or(GetItemTypeId(GetManipulatedItem())=='I006')or(GetItemTypeId(GetManipulatedItem())=='I00X')or(GetItemTypeId(GetManipulatedItem())=='I00Y')or(GetItemTypeId(GetManipulatedItem())=='I0B2')or(GetItemTypeId(GetManipulatedItem())=='I021')or(GetItemTypeId(GetManipulatedItem())=='I0B3')or(GetItemTypeId(GetManipulatedItem())=='I0JQ')or(GetItemTypeId(GetManipulatedItem())=='I0JS')or(GetItemTypeId(GetManipulatedItem())=='I0CV')or(GetItemTypeId(GetManipulatedItem())=='I01Z') // 'gold': item "50 Gold Coins"; 'I004': item "100 Gold Coins"; 'I005': item "150 Gold Coins"; 'I003': item "200 Gold Coins"; 'I006': item "250 Gold Coins"; 'I00X': item "500 Gold Coins"; 'I00Y': item "1000 Gold Coins"; 'I0B2': item "1250 Gold Coins"; 'I021': item "1500 Gold Coins"; 'I0B3': item "2000 Gold Coins"; 'I0JQ': item "2500 Gold Coins"; 'I0JS': item "5000 Gold Coins"; 'I0CV': item "10000 Gold Coins"; 'I01Z': item "Crystal Shard"
endfunction

function Trig_Gold_Pickup_Conditions takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())!=Player($B))and(Trig_Gold_Pickup_IsGoldItem()) // $B = 11
endfunction

function Trig_Gold_Pickup_IsGold50 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='gold') // 'gold': item "50 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold100 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I004') // 'I004': item "100 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold150 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I005') // 'I005': item "150 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold200 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I003') // 'I003': item "200 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold250 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I006') // 'I006': item "250 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold500 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I00X') // 'I00X': item "500 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold1000 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I00Y') // 'I00Y': item "1000 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold1250 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0B2') // 'I0B2': item "1250 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold1500 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I021') // 'I021': item "1500 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold2000 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0B3') // 'I0B3': item "2000 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold2500 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0JQ') // 'I0JQ': item "2500 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold5000 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0JS') // 'I0JS': item "5000 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsGold10000 takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0CV') // 'I0CV': item "10000 Gold Coins"
endfunction

function Trig_Gold_Pickup_IsCrystalShard takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I01Z') // 'I01Z': item "Crystal Shard"
endfunction

function Trig_Gold_Pickup_HeroActive takes nothing returns boolean
    return(IsUnitPausedBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())])==false)
endfunction

function Trig_Gold_Pickup_GiveShare takes nothing returns nothing
    if(Trig_Gold_Pickup_HeroActive())then
        call UnitAddItemByIdSwapped(udg_TempItemId,udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())])
    endif
endfunction

function Trig_Gold_Pickup_Actions takes nothing returns nothing
    set udg_TempItemId='I0IC' // 'I0IC': item "50G"
    if(Trig_Gold_Pickup_IsCrystalShard())then
        set udg_TempItemId='I0IL' // 'I0IL': item "1CS"
    else
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Gold_Pickup_IsGold50())then
            set udg_TempItemId='I0IC' // 'I0IC': item "50G"
        endif
        if(Trig_Gold_Pickup_IsGold100())then
            set udg_TempItemId='I0ID' // 'I0ID': item "100G"
        endif
        if(Trig_Gold_Pickup_IsGold150())then
            set udg_TempItemId='I0IE' // 'I0IE': item "150G"
        endif
        if(Trig_Gold_Pickup_IsGold200())then
            set udg_TempItemId='I0IF' // 'I0IF': item "200G"
        endif
        if(Trig_Gold_Pickup_IsGold250())then
            set udg_TempItemId='I0IG' // 'I0IG': item "250G"
        endif
        if(Trig_Gold_Pickup_IsGold500())then
            set udg_TempItemId='I0IH' // 'I0IH': item "500G"
        endif
        if(Trig_Gold_Pickup_IsGold1000())then
            set udg_TempItemId='I0II' // 'I0II': item "1000G"
        endif
        if(Trig_Gold_Pickup_IsGold1250())then
            set udg_TempItemId='I0B1' // 'I0B1': item "1250G"
        endif
        if(Trig_Gold_Pickup_IsGold1500())then
            set udg_TempItemId='I0IJ' // 'I0IJ': item "1500G"
        endif
        if(Trig_Gold_Pickup_IsGold2000())then
            set udg_TempItemId='I0B4' // 'I0B4': item "2000G"
        endif
        if(Trig_Gold_Pickup_IsGold2500())then
            set udg_TempItemId='I0JR' // 'I0JR': item "2500G"
        endif
        if(Trig_Gold_Pickup_IsGold5000())then
            set udg_TempItemId='I0JT' // 'I0JT': item "5000G"
        endif
        if(Trig_Gold_Pickup_IsGold10000())then
            set udg_TempItemId='I0IK' // 'I0IK': item "10000G"
        endif
    endif
    call ForForce(udg_PlayingPlayers,function Trig_Gold_Pickup_GiveShare)
    call Wait_Polled(1.)
    call RemoveItem(GetManipulatedItem())
endfunction

function Trig_Gold_Share_Pickup_IsShareItem takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0IC')or(GetItemTypeId(GetManipulatedItem())=='I0ID')or(GetItemTypeId(GetManipulatedItem())=='I0IE')or(GetItemTypeId(GetManipulatedItem())=='I0IF')or(GetItemTypeId(GetManipulatedItem())=='I0IG')or(GetItemTypeId(GetManipulatedItem())=='I0IH')or(GetItemTypeId(GetManipulatedItem())=='I0II')or(GetItemTypeId(GetManipulatedItem())=='I0B1')or(GetItemTypeId(GetManipulatedItem())=='I0IJ')or(GetItemTypeId(GetManipulatedItem())=='I0B4')or(GetItemTypeId(GetManipulatedItem())=='I0JR')or(GetItemTypeId(GetManipulatedItem())=='I0JT')or(GetItemTypeId(GetManipulatedItem())=='I0IK')or(GetItemTypeId(GetManipulatedItem())=='I0IL') // 'I0IC': item "50G"; 'I0ID': item "100G"; 'I0IE': item "150G"; 'I0IF': item "200G"; 'I0IG': item "250G"; 'I0IH': item "500G"; 'I0II': item "1000G"; 'I0B1': item "1250G"; 'I0IJ': item "1500G"; 'I0B4': item "2000G"; 'I0JR': item "2500G"; 'I0JT': item "5000G"; 'I0IK': item "10000G"; 'I0IL': item "1CS"
endfunction

function Trig_Gold_Share_Pickup_Conditions takes nothing returns boolean
    return(Trig_Gold_Share_Pickup_IsShareItem())
endfunction

function Trig_Gold_Share_Pickup_Actions takes nothing returns nothing
    call Wait_Polled(1.)
    call RemoveItem(GetManipulatedItem())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Gold takes nothing returns nothing
endfunction

function RegisterR11_Gold_Cap takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gold_Cap=CreateTrigger()

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(0),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(1),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(2),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(3),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(4),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(5),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(6),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerRegisterPlayerStateEvent(gg_trg_Gold_Cap,Player(7),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN,999999.)

call TriggerAddAction(gg_trg_Gold_Cap,function Trig_Gold_Cap_Actions)

endfunction




function RegisterR11_Gold_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gold_Pickup=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gold_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Gold_Pickup,Condition(function Trig_Gold_Pickup_Conditions))

call TriggerAddAction(gg_trg_Gold_Pickup,function Trig_Gold_Pickup_Actions)

endfunction




function RegisterR11_Gold_Share_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gold_Share_Pickup=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gold_Share_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Gold_Share_Pickup,Condition(function Trig_Gold_Share_Pickup_Conditions))

call TriggerAddAction(gg_trg_Gold_Share_Pickup,function Trig_Gold_Share_Pickup_Actions)

endfunction




endlibrary

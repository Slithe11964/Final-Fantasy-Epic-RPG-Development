library TMimic
function Trig_Mimic_Reveal_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_nmgv_0262)
endfunction

function Trig_Mimic_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_MimicUnit=ReplaceUnitBJ(GetTriggerUnit(),'n0NG',bj_UNIT_STATE_METHOD_MAXIMUM) // 'n0NG': unit "Mimic"
    call SetUnitOwner(GetLastReplacedUnitBJ(),Player($B),false) // $B = 11
    call EnableTrigger(gg_trg_Mimic_Death_Loot)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Mimic_Death_Loot_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_MimicUnit)
endfunction

function Trig_Mimic_Death_Loot_RollBookDrop takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Mimic_Death_Loot_RollPotionDrop takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Mimic_Death_Loot_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0BJ',udg_TempPoint) // 'I0BJ': item "Miner's Pickaxe"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I0JS',udg_TempPoint) // 'I0JS': item "5000 Gold Coins"
    if(Trig_Mimic_Death_Loot_RollBookDrop())then
        call CreateItemLoc('rdis',udg_TempPoint) // 'rdis': item "Bravega"
    else
        call CreateItemLoc('rsps',udg_TempPoint) // 'rsps': item "Faithga"
    endif
    if(Trig_Mimic_Death_Loot_RollPotionDrop())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Mimic takes nothing returns nothing
endfunction
function RegisterR11_Mimic_Reveal takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Mimic_Reveal=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Mimic_Reveal,Player(PLAYER_NEUTRAL_PASSIVE),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Mimic_Reveal,Condition(function Trig_Mimic_Reveal_Conditions))
    call TriggerAddAction(gg_trg_Mimic_Reveal,function Trig_Mimic_Reveal_Actions)
endfunction
function RegisterR11_Mimic_Death_Loot takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Mimic_Death_Loot=CreateTrigger()
    call DisableTrigger(gg_trg_Mimic_Death_Loot)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Mimic_Death_Loot,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Mimic_Death_Loot,Condition(function Trig_Mimic_Death_Loot_Conditions))
    call TriggerAddAction(gg_trg_Mimic_Death_Loot,function Trig_Mimic_Death_Loot_Actions)
endfunction




endlibrary

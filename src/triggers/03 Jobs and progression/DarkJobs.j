library TDarkJobs
function Trig_DarkJobs_Unlock_AreDarkShopsVisible takes nothing returns boolean
    return(udg_DarkShopsVisible)
endfunction

function Trig_DarkJobs_Unlock_Actions takes nothing returns nothing
    set udg_DarkJobsUnlocked=true
    call EnableTrigger(gg_trg_DarkJobs_Reveal)
    call AddUnitToStockBJ('H02X',gg_unit_n006_0063,1,1) // 'H02X': unit "Dark Knight"
    call AddUnitToStockBJ('H02Y',gg_unit_n000_0010,1,1) // 'H02Y': unit "Necromancer"
    call AddUnitToStockBJ('n0BO',udg_ShrineMenuUnit[1],1,1) // 'n0BO': unit "Darkness"
    call AddUnitToStockBJ('n0BP',udg_ShrineMenuUnit[2],1,1) // 'n0BP': unit "Minus Strike"
    call AddUnitToStockBJ('n0BQ',udg_ShrineMenuUnit[3],1,1) // 'n0BQ': unit "Drain Attack"
    call AddUnitToStockBJ('n0BR',udg_ShrineMenuUnit[4],1,1) // 'n0BR': unit "HP Regeneration Plus"
    call AddUnitToStockBJ('n0BY',udg_ShrineMenuUnit[5],1,1) // 'n0BY': unit "Raise Dead"
    call AddUnitToStockBJ('n0BX',udg_ShrineMenuUnit[6],1,1) // 'n0BX': unit "Death Screech"
    call AddUnitToStockBJ('n0BZ',udg_ShrineMenuUnit[7],1,1) // 'n0BZ': unit "Drain"
    call AddUnitToStockBJ('n0C0',udg_ShrineMenuUnit[8],1,1) // 'n0C0': unit "Osmose"
    call AddUnitToStockBJ('H02X',gg_unit_n006_0066,1,1) // 'H02X': unit "Dark Knight"
    call AddUnitToStockBJ('H02Y',gg_unit_n000_0261,1,1) // 'H02Y': unit "Necromancer"
    call AddUnitToStockBJ('n0BO',udg_ShrineMenuUnit[$A],1,1) // 'n0BO': unit "Darkness"; $A = 10
    call AddUnitToStockBJ('n0BP',udg_ShrineMenuUnit[$B],1,1) // 'n0BP': unit "Minus Strike"; $B = 11
    call AddUnitToStockBJ('n0BQ',udg_ShrineMenuUnit[$C],1,1) // 'n0BQ': unit "Drain Attack"; $C = 12
    call AddUnitToStockBJ('n0BR',udg_ShrineMenuUnit[$D],1,1) // 'n0BR': unit "HP Regeneration Plus"; $D = 13
    call AddUnitToStockBJ('n0BY',udg_ShrineMenuUnit[$E],1,1) // 'n0BY': unit "Raise Dead"; $E = 14
    call AddUnitToStockBJ('n0BX',udg_ShrineMenuUnit[$F],1,1) // 'n0BX': unit "Death Screech"; $F = 15
    call AddUnitToStockBJ('n0BZ',udg_ShrineMenuUnit[16],1,1) // 'n0BZ': unit "Drain"
    call AddUnitToStockBJ('n0C0',udg_ShrineMenuUnit[17],1,1) // 'n0C0': unit "Osmose"
    call GroupAddUnitSimple(udg_NpcUnit[20],udg_DarkShopGroup)
    call GroupAddUnitSimple(udg_NpcUnit[21],udg_DarkShopGroup)
    if(Trig_DarkJobs_Unlock_AreDarkShopsVisible())then
        call ShowUnitShow(udg_NpcUnit[20])
        call ShowUnitShow(udg_NpcUnit[21])
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkJobs_Reveal_Conditions takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_DarkJobs_Reveal_SetFoodCap22 takes nothing returns nothing
    call SetPlayerStateBJ(GetEnumPlayer(),PLAYER_STATE_RESOURCE_FOOD_CAP,22)
endfunction

function Trig_DarkJobs_Reveal_SetFoodCapFull takes nothing returns nothing
    call SetPlayerStateBJ(GetEnumPlayer(),PLAYER_STATE_RESOURCE_FOOD_CAP,23)
endfunction

function Trig_DarkJobs_Reveal_IsShrineOpen takes nothing returns boolean
    return(udg_ShrineUnlocked)
endfunction

function Trig_DarkJobs_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DarkJobs_Reveal_IsShrineOpen())then
        call ForForce(udg_PlayingPlayers,function Trig_DarkJobs_Reveal_SetFoodCapFull)
    else
        call ForForce(udg_PlayingPlayers,function Trig_DarkJobs_Reveal_SetFoodCap22)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DarkJobs takes nothing returns nothing
endfunction
function RegisterR11_DarkJobs_Unlock takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_DarkJobs_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_DarkJobs_Unlock)
    call TriggerAddAction(gg_trg_DarkJobs_Unlock,function Trig_DarkJobs_Unlock_Actions)
endfunction
function RegisterR11_DarkJobs_Reveal takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_DarkJobs_Reveal=CreateTrigger()
    call DisableTrigger(gg_trg_DarkJobs_Reveal)
    call TriggerRegisterTimerEventPeriodic(gg_trg_DarkJobs_Reveal,12.)
    call TriggerAddCondition(gg_trg_DarkJobs_Reveal,Condition(function Trig_DarkJobs_Reveal_Conditions))
    call TriggerAddAction(gg_trg_DarkJobs_Reveal,function Trig_DarkJobs_Reveal_Actions)
endfunction




endlibrary

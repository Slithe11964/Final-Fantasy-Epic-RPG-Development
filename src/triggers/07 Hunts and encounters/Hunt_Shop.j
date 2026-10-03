library THuntShop
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hunt_Shop_Unlock=null
endglobals

function Trig_Hunt_Shop_Unlock_IsNotSlotTen takes nothing returns boolean
    return(GetForLoopIndexA()!=$A) // $A = 10
endfunction

function Trig_Hunt_Shop_Unlock_HasNewStock takes nothing returns boolean
    return(udg_TempInteger>udg_HuntShopStock)
endfunction

function Trig_Hunt_Shop_Unlock_IsNotSlotTenB takes nothing returns boolean
    return(GetForLoopIndexA()!=$A) // $A = 10
endfunction

function Trig_Hunt_Shop_Unlock_StockNotFull takes nothing returns boolean
    return(udg_HuntShopStock<$B) // $B = 11
endfunction

function Trig_Hunt_Shop_Unlock_AllStockUnlocked takes nothing returns boolean
    return(udg_TempInteger>$B) // $B = 11
endfunction

function Trig_Hunt_Shop_Unlock_Actions takes nothing returns nothing
    // ((((udg_CommonHuntsDone) times (2)) plus (udg_RareHuntsDone)) plus (3)) divided by (4); drop the remainder.
    set udg_TempInteger=((((udg_CommonHuntsDone*2)+udg_RareHuntsDone)+3)/ 4)
    if(Trig_Hunt_Shop_Unlock_AllStockUnlocked())then
        call DisableTrigger(GetTriggeringTrigger())
        if(Trig_Hunt_Shop_Unlock_StockNotFull())then
            set bj_forLoopAIndex=(udg_HuntShopStock+1)
            set bj_forLoopAIndexEnd=$B // $B = 11
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                if(Trig_Hunt_Shop_Unlock_IsNotSlotTenB())then
                    call AddItemToStockBJ(udg_HuntRewardItem[GetForLoopIndexA()],gg_unit_h032_0007,1,1)
                endif
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            set udg_HuntShopStock=$B // $B = 11
        endif
        call DestroyTrigger(GetTriggeringTrigger())
    else
        if(Trig_Hunt_Shop_Unlock_HasNewStock())then
            set bj_forLoopAIndex=(udg_HuntShopStock+1)
            set bj_forLoopAIndexEnd=udg_TempInteger
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                if(Trig_Hunt_Shop_Unlock_IsNotSlotTen())then
                    call AddItemToStockBJ(udg_HuntRewardItem[GetForLoopIndexA()],gg_unit_h032_0007,1,1)
                endif
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            set udg_HuntShopStock=udg_TempInteger
        endif
    endif
endfunction

function InitTrig_Hunt_Shop takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hunt (module Hunt),
// which keeps the original registration order.

function Register_Hunt_Shop_Unlock takes nothing returns nothing
    set gg_trg_Hunt_Shop_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Shop_Unlock)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Hunt_Shop_Unlock,10.)
    call TriggerAddAction(gg_trg_Hunt_Shop_Unlock,function Trig_Hunt_Shop_Unlock_Actions)
endfunction

endlibrary

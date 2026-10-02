library THuntShop
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
            // (udg_HuntShopStock) plus (1).
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
            // (udg_HuntShopStock) plus (1).
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

endlibrary

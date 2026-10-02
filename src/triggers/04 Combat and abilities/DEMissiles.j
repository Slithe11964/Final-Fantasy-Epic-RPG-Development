library TDEMissiles
globals
    // Variables only this module uses.
    item array udg_HiddenItem
    integer udg_HiddenItemCount=0
endglobals

function DEMissiles___HideBothersomeItem takes nothing returns nothing
    if IsItemVisible(GetEnumItem())then
        set udg_HiddenItem[udg_HiddenItemCount]=GetEnumItem()
        call SetItemVisible(udg_HiddenItem[udg_HiddenItemCount],false)
        set udg_HiddenItemCount=udg_HiddenItemCount+1
    endif
endfunction

function InitTrig_DEMissiles takes nothing returns nothing
endfunction

endlibrary

library TStock
function Stock_UpdateBuildings takes itemtype l_itemType,integer l_itemLevel returns nothing
    local group g
    set bj_stockPickedItemType=l_itemType
    set bj_stockPickedItemLevel=l_itemLevel
    set g=CreateGroup()
    call GroupEnumUnitsOfType(g,"marketplace",udg_FilterTrue)
    call ForGroup(g,function UpdateEachStockBuildingEnum)
    call DestroyGroup(g)
    set g=null
endfunction

function Stock_PickRandom takes nothing returns nothing
    local integer pickedItemId
    local itemtype l_pickedType
    local integer l_pickedLevel=0
    local integer l_choices=0
    local integer l_level
    set l_level=1
    loop
        if(bj_stockAllowedPermanent[l_level])then
            set l_choices=l_choices+1
            // A random whole number from 1 through l_choices.
            if(GetRandomInt(1,l_choices)==1)then
                set l_pickedType=ITEM_TYPE_PERMANENT
                set l_pickedLevel=l_level
            endif
        endif
        if(bj_stockAllowedCharged[l_level])then
            set l_choices=l_choices+1
            // A random whole number from 1 through l_choices.
            if(GetRandomInt(1,l_choices)==1)then
                set l_pickedType=ITEM_TYPE_CHARGED
                set l_pickedLevel=l_level
            endif
        endif
        if(bj_stockAllowedArtifact[l_level])then
            set l_choices=l_choices+1
            // A random whole number from 1 through l_choices.
            if(GetRandomInt(1,l_choices)==1)then
                set l_pickedType=ITEM_TYPE_ARTIFACT
                set l_pickedLevel=l_level
            endif
        endif
        set l_level=l_level+1
        exitwhen l_level>bj_MAX_ITEM_LEVEL
    endloop
    if(l_choices==0)then
        set l_pickedType=null
        return
    endif
    call Stock_UpdateBuildings(l_pickedType,l_pickedLevel)
    set l_pickedType=null
endfunction

function Stock_Start takes nothing returns nothing
    call Stock_PickRandom()
    call TimerStart(bj_stockUpdateTimer,bj_STOCK_RESTOCK_INTERVAL,true,function Stock_PickRandom)
endfunction

function InitTrig_Stock takes nothing returns nothing
endfunction

endlibrary

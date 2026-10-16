library TForce
globals
    // Variables only this module uses.
    force udg_EnumForce=null
    hashtable CollectionWatch=InitHashtable()
    integer array CollectionArmoryRevision
    integer array CollectionTitleRevision
    integer array CollectionInventoryRevision
endglobals
function Collection_Watch takes force watched,integer kind returns nothing
    if watched!=null then
        call SaveBoolean(CollectionWatch,GetHandleId(watched),kind,true)
    endif
endfunction

function Collection_Touch takes force watched,player owner returns nothing
    local integer pid=GetPlayerId(owner)
    if LoadBoolean(CollectionWatch,GetHandleId(watched),1) then
        set CollectionArmoryRevision[pid]=CollectionArmoryRevision[pid]+1
    endif
    if LoadBoolean(CollectionWatch,GetHandleId(watched),2) then
        set CollectionTitleRevision[pid]=CollectionTitleRevision[pid]+1
    endif
endfunction

function Collection_ForceAddPlayer takes force target,player owner returns nothing
    if not IsPlayerInForce(owner,target) then
        call ForceAddPlayer(target,owner)
        call Collection_Touch(target,owner)
    endif
endfunction

function Collection_ForceRemovePlayer takes force target,player owner returns nothing
    if IsPlayerInForce(owner,target) then
        call ForceRemovePlayer(target,owner)
        call Collection_Touch(target,owner)
    endif
endfunction

function Collection_ForceAddPlayerSimple takes player owner,force target returns nothing
    call Collection_ForceAddPlayer(target,owner)
endfunction

function Collection_ForceRemovePlayerSimple takes player owner,force target returns nothing
    call Collection_ForceRemovePlayer(target,owner)
endfunction

function Collection_ForceClear takes force target returns nothing
    local integer pid=0
    if LoadBoolean(CollectionWatch,GetHandleId(target),1) or LoadBoolean(CollectionWatch,GetHandleId(target),2) then
        loop
            exitwhen pid>=24
            if IsPlayerInForce(Player(pid),target) then
                call Collection_Touch(target,Player(pid))
            endif
            set pid=pid+1
        endloop
    endif
    call ForceClear(target)
endfunction

function Collection_InventoryChanged takes nothing returns nothing
    local integer pid=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if pid<8 then
        set CollectionInventoryRevision[pid]=CollectionInventoryRevision[pid]+1
    endif
endfunction

function Force_OfPlayer takes player l_owner returns force
    set udg_EnumForce=CreateForce()
    call Collection_ForceAddPlayer(udg_EnumForce,l_owner)
    return udg_EnumForce
endfunction

function Force_Matching takes boolexpr l_filter returns force
    set udg_EnumForce=CreateForce()
    call ForceEnumPlayers(udg_EnumForce,l_filter)
    call DestroyBoolExpr(l_filter)
    return udg_EnumForce
endfunction

function InitTrig_Force takes nothing returns nothing
endfunction

endlibrary

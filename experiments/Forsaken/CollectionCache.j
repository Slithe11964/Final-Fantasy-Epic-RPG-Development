globals
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
    if pid<24 then
        set CollectionInventoryRevision[pid]=CollectionInventoryRevision[pid]+1
    endif
endfunction

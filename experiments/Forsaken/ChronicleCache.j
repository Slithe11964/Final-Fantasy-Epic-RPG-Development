globals
    integer array ChroniclesCachedInventory
    integer array ChroniclesCachedTitles
    integer array ChroniclesCachedSpeed
    unit array ChroniclesCachedHero
    unit array ChroniclesCachedSpirit
    trigger gg_trg_CollectionInventory=null
endglobals

function Chronicles_Tick takes nothing returns nothing
    local integer i=0
    local boolean refresh=false
    local player owner
    local unit hero
    local unit spirit
    loop
        exitwhen i>=8
        set owner=Player(i)
        set hero=Player_GetHero(owner)
        set spirit=udg_SpiritOfGaya[i+1]
        if ChroniclesCachedInventory[i]!=CollectionInventoryRevision[i] or ChroniclesCachedTitles[i]!=CollectionTitleRevision[i] or ChroniclesCachedSpeed[i]!=udg_SpeedrunLevel[i+1] or ChroniclesCachedHero[i]!=hero or ChroniclesCachedSpirit[i]!=spirit then
            call Chronicles_CheckInventory(owner)
            call Chronicles_RestoreSecrets(owner)
            set ChroniclesCachedInventory[i]=CollectionInventoryRevision[i]
            set ChroniclesCachedTitles[i]=CollectionTitleRevision[i]
            set ChroniclesCachedSpeed[i]=udg_SpeedrunLevel[i+1]
            set ChroniclesCachedHero[i]=hero
            set ChroniclesCachedSpirit[i]=spirit
            if GetLocalPlayer()==owner then
                set refresh=true
            endif
        endif
        set i=i+1
    endloop
    if refresh then
        call Chronicles_RefreshTooltips()
    endif
    set owner=null
    set hero=null
    set spirit=null
endfunction

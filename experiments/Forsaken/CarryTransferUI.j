    framehandle CarryUIRoot=null
    framehandle CarryUIButton=null
    framehandle CarryUIClose=null
    framehandle CarryUIHint=null
    framehandle array CarryUIBagButton
    framehandle array CarryUIBagIcon
    framehandle array CarryUIQuickButton
    framehandle array CarryUIQuickIcon
    trigger CarryUIEvents=null
    trigger CarryUISync=null
    boolean CarryUIOpen=false
    integer CarryUISelected=-1
    integer CarryUIRaw=0
    integer CarryUIData=0
    integer CarryUIHeroRaw=0
// FUNCTIONS
function CarryUI_Canonical takes integer raw returns integer
    local integer original=LoadInteger(ForsakenGearTypes,4,raw)
    if original==0 and LoadInteger(ForsakenGearTypes,67,raw)!=0 then
        set original=raw
    endif
    return original
endfunction

function CarryUI_Draw takes unit hero returns nothing
    local integer i=0
    local item carried
    local boolean enabled
    loop
        exitwhen i>=30
        set carried=UnitItemInBagSlot(hero,i)
        set enabled=carried!=null and CarryUI_Canonical(GetItemTypeId(carried))!=0
        if carried!=null then
            call BlzFrameSetTexture(CarryUIBagIcon[i],BlzGetItemIconPath(carried),0,true)
        else
            call BlzFrameSetTexture(CarryUIBagIcon[i],"UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp",0,true)
        endif
        call BlzFrameSetEnable(CarryUIBagButton[i],enabled)
        if enabled then
            call BlzFrameSetAlpha(CarryUIBagIcon[i],255)
        else
            call BlzFrameSetAlpha(CarryUIBagIcon[i],90)
        endif
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=6
        set carried=UnitItemInSlot(hero,i)
        call BlzFrameSetVisible(CarryUIQuickIcon[i],carried!=null)
        if carried!=null then
            call BlzFrameSetTexture(CarryUIQuickIcon[i],BlzGetItemIconPath(carried),0,true)
        endif
        call BlzFrameSetEnable(CarryUIQuickButton[i],carried==null and CarryUISelected>=0)
        set i=i+1
    endloop
    set carried=null
endfunction

function CarryUI_Close takes nothing returns nothing
    set CarryUIOpen=false
    set CarryUISelected=-1
    call BlzFrameSetVisible(CarryUIRoot,false)
endfunction

function CarryUI_ShowAccess takes boolean visible,framehandle anchor returns nothing
    call BlzFrameSetVisible(CarryUIButton,visible)
    if visible and anchor!=null then
        call BlzFrameClearAllPoints(CarryUIButton)
        call BlzFrameSetPoint(CarryUIButton,FRAMEPOINT_BOTTOMRIGHT,anchor,FRAMEPOINT_BOTTOMRIGHT,-.010,.042)
    elseif not visible then
        call CarryUI_Close()
    endif
endfunction

function CarryUI_Field takes string data,integer wanted returns string
    local integer i=0
    local integer start=0
    local integer field=0
    loop
        exitwhen i>=StringLength(data)
        if SubString(data,i,i+1)==":" then
            if field==wanted then
                return SubString(data,start,i)
            endif
            set field=field+1
            set start=i+1
        endif
        set i=i+1
    endloop
    if field==wanted then
        return SubString(data,start,i)
    endif
    return ""
endfunction

// Only this synchronized callback mutates items. All request fields are checked
// against current shared inventory state; local UI drafts are never authority.
function CarryUI_Receive takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local unit hero=Player_GetHero(owner)
    local string data=BlzGetTriggerSyncData()
    local integer heroRaw=S2I(CarryUI_Field(data,0))
    local integer bag=S2I(CarryUI_Field(data,1))
    local integer slot=S2I(CarryUI_Field(data,2))
    local integer raw=S2I(CarryUI_Field(data,3))
    local integer mark=S2I(CarryUI_Field(data,4))
    local item carried
    local item moved
    if GetPlayerId(owner)<0 or GetPlayerId(owner)>=8 or hero==null or GetUnitTypeId(hero)!=heroRaw or StringLength(data)>96 then
        set owner=null
        set hero=null
        return
    endif
    if data!=I2S(heroRaw)+":"+I2S(bag)+":"+I2S(slot)+":"+I2S(raw)+":"+I2S(mark) or bag<0 or bag>=30 or bag>=UnitExtendedInventorySize(hero) or slot<0 or slot>=6 then
        set owner=null
        set hero=null
        return
    endif
    set carried=UnitItemInBagSlot(hero,bag)
    if carried!=null and GetItemTypeId(carried)==raw and GetItemUserData(carried)==mark and CarryUI_Canonical(raw)!=0 and UnitItemInSlot(hero,slot)==null then
        set moved=Integrity_CarryIntoSlot(hero,carried,slot,CarryUI_Canonical(raw))
        if moved!=carried then
            call DisplayTimedTextToPlayer(owner,0,0,3,"Item moved to hero slot "+I2S(slot+1)+". Gear bonuses require equipment slots.")
            call Forsaken_RequestInventoryRefresh(hero)
        else
            call DisplayTimedTextToPlayer(owner,0,0,3,"The item could not move; it has been kept.")
        endif
    else
        call DisplayTimedTextToPlayer(owner,0,0,3,"Inventory changed. Choose the item and an empty hero slot again.")
    endif
    if GetLocalPlayer()==owner and CarryUIOpen then
        set CarryUISelected=-1
        call BlzFrameSetText(CarryUIHint,"Choose gear, then an empty hero slot.")
        call CarryUI_Draw(hero)
    endif
    set owner=null
    set hero=null
    set carried=null
    set moved=null
endfunction

function CarryUI_Click takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local unit hero=Player_GetHero(owner)
    local framehandle control=BlzGetTriggerFrame()
    local item carried
    local integer i=0
    if GetLocalPlayer()==owner and hero!=null then
        if control==CarryUIClose then
            call CarryUI_Close()
        elseif control==CarryUIButton then
            set CarryUIOpen=not CarryUIOpen
            set CarryUISelected=-1
            call BlzFrameSetVisible(CarryUIRoot,CarryUIOpen)
            call BlzFrameSetText(CarryUIHint,"Choose gear, then an empty hero slot.")
            call CarryUI_Draw(hero)
        elseif CarryUIOpen then
            loop
                exitwhen i>=30
                if control==CarryUIBagButton[i] then
                    set carried=UnitItemInBagSlot(hero,i)
                    if carried!=null and CarryUI_Canonical(GetItemTypeId(carried))!=0 then
                        set CarryUISelected=i
                        set CarryUIRaw=GetItemTypeId(carried)
                        set CarryUIData=GetItemUserData(carried)
                        set CarryUIHeroRaw=GetUnitTypeId(hero)
                        call BlzFrameSetText(CarryUIHint,GetItemName(carried)+"|nChoose an empty hero slot below.")
                        call CarryUI_Draw(hero)
                    endif
                    set i=30
                endif
                set i=i+1
            endloop
            set i=0
            loop
                exitwhen i>=6
                if control==CarryUIQuickButton[i] and CarryUISelected>=0 then
                    call BlzSendSyncData("FFCarry",I2S(CarryUIHeroRaw)+":"+I2S(CarryUISelected)+":"+I2S(i)+":"+I2S(CarryUIRaw)+":"+I2S(CarryUIData))
                    set CarryUISelected=-1
                    call BlzFrameSetText(CarryUIHint,"Moving item...")
                    call CarryUI_Draw(hero)
                endif
                set i=i+1
            endloop
        endif
    endif
    set owner=null
    set hero=null
    set control=null
    set carried=null
endfunction

function CarryUI_Init takes nothing returns nothing
    local integer i=0
    local framehandle heading
    if CarryUIRoot!=null then
        return
    endif
    set CarryUIEvents=CreateTrigger()
    call TriggerAddAction(CarryUIEvents,function CarryUI_Click)
    set CarryUISync=CreateTrigger()
    loop
        exitwhen i>=8
        call BlzTriggerRegisterPlayerSyncEvent(CarryUISync,Player(i),"FFCarry",false)
        set i=i+1
    endloop
    call TriggerAddAction(CarryUISync,function CarryUI_Receive)
    set CarryUIButton=BlzCreateFrame("ScriptDialogButton",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetSize(CarryUIButton,.085,.025)
    call BlzFrameSetText(CarryUIButton,"Move to hero")
    call BlzFrameSetVisible(CarryUIButton,false)
    call BlzTriggerRegisterFrameEvent(CarryUIEvents,CarryUIButton,FRAMEEVENT_CONTROL_CLICK)
    set CarryUIRoot=BlzCreateFrame("EscMenuBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetAbsPoint(CarryUIRoot,FRAMEPOINT_TOP,.4,.55)
    call BlzFrameSetSize(CarryUIRoot,.30,.37)
    call BlzFrameSetLevel(CarryUIRoot,80)
    set heading=BlzCreateFrameByType("TEXT","CarryHeading",CarryUIRoot,"",0)
    call BlzFrameSetPoint(heading,FRAMEPOINT_TOP,CarryUIRoot,FRAMEPOINT_TOP,0.,-.018)
    call BlzFrameSetSize(heading,.23,.016)
    call BlzFrameSetFont(heading,"Fonts\\FRIZQT__.TTF",.010,0)
    call BlzFrameSetTextAlignment(heading,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(heading,"Move to hero")
    set CarryUIHint=BlzCreateFrameByType("TEXT","CarryHint",CarryUIRoot,"",0)
    call BlzFrameSetPoint(CarryUIHint,FRAMEPOINT_TOPLEFT,CarryUIRoot,FRAMEPOINT_TOPLEFT,.02,-.041)
    call BlzFrameSetSize(CarryUIHint,.26,.028)
    call BlzFrameSetFont(CarryUIHint,"Fonts\\FRIZQT__.TTF",.007,0)
    set CarryUIClose=BlzCreateFrame("ScriptDialogButton",CarryUIRoot,0,0)
    call BlzFrameSetPoint(CarryUIClose,FRAMEPOINT_TOPRIGHT,CarryUIRoot,FRAMEPOINT_TOPRIGHT,-.012,-.012)
    call BlzFrameSetSize(CarryUIClose,.023,.023)
    call BlzFrameSetText(CarryUIClose,"X")
    call BlzTriggerRegisterFrameEvent(CarryUIEvents,CarryUIClose,FRAMEEVENT_CONTROL_CLICK)
    set i=0
    loop
        exitwhen i>=36
        if i<30 then
            set CarryUIBagButton[i]=BlzCreateFrame("ScriptDialogButton",CarryUIRoot,0,i+1)
            call BlzFrameSetPoint(CarryUIBagButton[i],FRAMEPOINT_TOPLEFT,CarryUIRoot,FRAMEPOINT_TOPLEFT,.025+I2R(ModuloInteger(i,6))*.042,-.076-I2R(i/6)*.042)
            call BlzFrameSetSize(CarryUIBagButton[i],.038,.038)
            set CarryUIBagIcon[i]=BlzCreateFrameByType("BACKDROP","CarryBagIcon",CarryUIBagButton[i],"",i+1)
            call BlzFrameSetAllPoints(CarryUIBagIcon[i],CarryUIBagButton[i])
            call BlzFrameSetEnable(CarryUIBagIcon[i],false)
            call BlzTriggerRegisterFrameEvent(CarryUIEvents,CarryUIBagButton[i],FRAMEEVENT_CONTROL_CLICK)
        else
            set CarryUIQuickButton[i-30]=BlzCreateFrame("ScriptDialogButton",CarryUIRoot,0,i+1)
            call BlzFrameSetPoint(CarryUIQuickButton[i-30],FRAMEPOINT_TOPLEFT,CarryUIRoot,FRAMEPOINT_TOPLEFT,.025+I2R(i-30)*.042,-.306)
            call BlzFrameSetSize(CarryUIQuickButton[i-30],.038,.038)
            call BlzFrameSetText(CarryUIQuickButton[i-30],I2S(i-29))
            set CarryUIQuickIcon[i-30]=BlzCreateFrameByType("BACKDROP","CarryQuickIcon",CarryUIQuickButton[i-30],"",i+1)
            call BlzFrameSetAllPoints(CarryUIQuickIcon[i-30],CarryUIQuickButton[i-30])
            call BlzFrameSetEnable(CarryUIQuickIcon[i-30],false)
            call BlzTriggerRegisterFrameEvent(CarryUIEvents,CarryUIQuickButton[i-30],FRAMEEVENT_CONTROL_CLICK)
        endif
        set i=i+1
    endloop
    set heading=BlzCreateFrameByType("TEXT","CarryDestination",CarryUIRoot,"",0)
    call BlzFrameSetPoint(heading,FRAMEPOINT_TOPLEFT,CarryUIRoot,FRAMEPOINT_TOPLEFT,.025,-.282)
    call BlzFrameSetSize(heading,.25,.016)
    call BlzFrameSetFont(heading,"Fonts\\FRIZQT__.TTF",.008,0)
    call BlzFrameSetText(heading,"Hero slots (1-6)")
    call BlzFrameSetVisible(CarryUIRoot,false)
    set heading=null
endfunction

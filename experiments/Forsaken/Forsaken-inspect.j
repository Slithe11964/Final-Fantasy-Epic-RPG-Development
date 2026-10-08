function Forsaken_CanInspect takes unit hero,player viewer returns boolean
    local player owner
    local boolean allowed=false
    if hero==null or GetUnitTypeId(hero)==0 then
        return false
    endif
    set owner=GetOwningPlayer(hero)
    set allowed=hero!=Player_GetHero(viewer) and IsUnitVisible(hero,viewer) and not IsUnitHidden(hero)
    set owner=null
    return allowed
endfunction

function Forsaken_RenderInspection takes unit hero returns nothing
    local integer slot=0
    local item carried
    local string description
    call BlzFrameSetText(ForsakenInspectTitle,GetPlayerName(GetOwningPlayer(hero))+"|n"+GetUnitName(hero)+" - Level "+I2S(GetUnitLevel(hero)))
    if UnitExtendedInventorySize(hero)==0 then
        call BlzFrameSetText(ForsakenInspectBagLabel,"Inventory - read only (first row)")
    else
        call BlzFrameSetText(ForsakenInspectBagLabel,"Backpack - read only")
    endif
    loop
        exitwhen slot>=39
        if slot<9 then
            set carried=UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot))
            set description=ForsakenInspectSlotName[slot]
        elseif UnitExtendedInventorySize(hero)==0 then
            set carried=null
            set description="No backpack"
            if slot<15 then
                set carried=UnitItemInSlot(hero,slot-9)
                set description="Inventory slot "+I2S(slot-8)
            endif
        else
            set carried=UnitItemInBagSlot(hero,slot-9)
            set description="Bag slot "+I2S(slot-8)
        endif
        if carried!=null then
            call BlzFrameSetTexture(ForsakenInspectIcon[slot],BlzGetItemIconPath(carried),0,true)
            set description=description+"|n|cffffcc00"+GetItemName(carried)+"|r|n"+BlzGetItemExtendedTooltip(carried)
            if GetItemCharges(carried)>0 then
                set description=description+"|nCharges: "+I2S(GetItemCharges(carried))
            endif
            call BlzFrameSetAlpha(ForsakenInspectIcon[slot],255)
        else
            call BlzFrameSetTexture(ForsakenInspectIcon[slot],"UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp",0,true)
            set description=description+"|nEmpty"
            call BlzFrameSetAlpha(ForsakenInspectIcon[slot],110)
        endif
        call BlzFrameSetText(ForsakenInspectItemText[slot],description)
        set slot=slot+1
    endloop
    set carried=null
endfunction

function Forsaken_CreateInspection takes nothing returns nothing
    local integer slot=0
    local integer row
    local integer column
    local framehandle slotButton
    local framehandle label
    local framehandle tip
    local framehandle texture
    set ForsakenInspectSlotName[0]="Head"
    set ForsakenInspectSlotName[1]="Chest"
    set ForsakenInspectSlotName[2]="Gloves"
    set ForsakenInspectSlotName[3]="Boots"
    set ForsakenInspectSlotName[4]="Ring 1"
    set ForsakenInspectSlotName[5]="Ring 2"
    set ForsakenInspectSlotName[6]="Weapon"
    set ForsakenInspectSlotName[7]="Offhand"
    set ForsakenInspectSlotName[8]="Trinket"
    set ForsakenInspectButton=BlzCreateFrame("ScriptDialogButton",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetPoint(ForsakenInspectButton,FRAMEPOINT_BOTTOMRIGHT,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,3),FRAMEPOINT_TOPRIGHT,0,.004)
    call BlzFrameSetSize(ForsakenInspectButton,.032,.032)
    set texture=BlzCreateFrameByType("BACKDROP","ForsakenInspectButtonIcon",ForsakenInspectButton,"",0)
    call BlzFrameSetPoint(texture,FRAMEPOINT_TOPLEFT,ForsakenInspectButton,FRAMEPOINT_TOPLEFT,.003,-.003)
    call BlzFrameSetPoint(texture,FRAMEPOINT_BOTTOMRIGHT,ForsakenInspectButton,FRAMEPOINT_BOTTOMRIGHT,-.003,.003)
    call BlzFrameSetTexture(texture,"ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",0,true)
    call BlzFrameSetEnable(texture,false)
    set tip=BlzCreateFrame("EscMenuBackdrop",ForsakenInspectButton,0,0)
    call BlzFrameSetPoint(tip,FRAMEPOINT_BOTTOMRIGHT,ForsakenInspectButton,FRAMEPOINT_TOPRIGHT,0,.004)
    call BlzFrameSetSize(tip,.17,.055)
    set label=BlzCreateFrameByType("TEXT","ForsakenInspectTip",tip,"",0)
    call BlzFrameSetPoint(label,FRAMEPOINT_TOPLEFT,tip,FRAMEPOINT_TOPLEFT,.018,-.018)
    call BlzFrameSetSize(label,.134,.025)
    call BlzFrameSetFont(label,"Fonts\\FRIZQT__.TTF",.008,0)
    call BlzFrameSetText(label,"Inspect selected unit|nGear, bag, stats and talents")
    call BlzFrameSetTooltip(ForsakenInspectButton,tip)
    call BlzFrameSetVisible(tip,false)
    call BlzFrameSetVisible(ForsakenInspectButton,false)
    call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_PanelAccess,ForsakenInspectButton,FRAMEEVENT_CONTROL_CLICK)
    set ForsakenInspectRoot=BlzCreateFrame("EscMenuBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetAbsPoint(ForsakenInspectRoot,FRAMEPOINT_TOPLEFT,.392,.585)
    call BlzFrameSetSize(ForsakenInspectRoot,.29,.49)
    call BlzFrameSetLevel(ForsakenInspectRoot,30)
    set ForsakenInspectClose=BlzCreateFrame("ScriptDialogButton",ForsakenInspectRoot,0,0)
    call BlzFrameSetPoint(ForsakenInspectClose,FRAMEPOINT_TOPRIGHT,ForsakenInspectRoot,FRAMEPOINT_TOPRIGHT,-.026,-.022)
    call BlzFrameSetSize(ForsakenInspectClose,.016,.016)
    call BlzFrameSetText(ForsakenInspectClose,"X")
    call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_PanelAccess,ForsakenInspectClose,FRAMEEVENT_CONTROL_CLICK)
    set ForsakenInspectTitle=BlzCreateFrameByType("TEXT","ForsakenInspectTitle",ForsakenInspectRoot,"",0)
    call BlzFrameSetPoint(ForsakenInspectTitle,FRAMEPOINT_TOPLEFT,ForsakenInspectRoot,FRAMEPOINT_TOPLEFT,.028,-.028)
    call BlzFrameSetSize(ForsakenInspectTitle,.212,.037)
    call BlzFrameSetFont(ForsakenInspectTitle,"Fonts\\FRIZQT__.TTF",.009,0)
    loop
        exitwhen slot>=39
        set slotButton=BlzCreateFrame("ScriptDialogButton",ForsakenInspectRoot,0,slot+1)
        if slot<9 then
            set row=slot/3
            set column=ModuloInteger(slot,3)
            call BlzFrameSetPoint(slotButton,FRAMEPOINT_TOPLEFT,ForsakenInspectRoot,FRAMEPOINT_TOPLEFT,.058+I2R(column)*.066,-.083-I2R(row)*.052)
            call BlzFrameSetSize(slotButton,.04,.04)
            set label=BlzCreateFrameByType("TEXT","ForsakenInspectSlot",ForsakenInspectRoot,"",slot+1)
            call BlzFrameSetPoint(label,FRAMEPOINT_TOP,slotButton,FRAMEPOINT_BOTTOM,0,-.001)
            call BlzFrameSetSize(label,.062,.01)
            call BlzFrameSetFont(label,"Fonts\\FRIZQT__.TTF",.0065,0)
            call BlzFrameSetTextAlignment(label,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
            call BlzFrameSetText(label,ForsakenInspectSlotName[slot])
            call BlzFrameSetEnable(label,false)
        else
            set row=(slot-9)/6
            set column=ModuloInteger(slot-9,6)
            call BlzFrameSetPoint(slotButton,FRAMEPOINT_TOPLEFT,ForsakenInspectRoot,FRAMEPOINT_TOPLEFT,.035+I2R(column)*.038,-.272-I2R(row)*.035)
            call BlzFrameSetSize(slotButton,.03,.03)
        endif
        set ForsakenInspectIcon[slot]=BlzCreateFrameByType("BACKDROP","ForsakenInspectItemIcon",slotButton,"",slot+1)
        call BlzFrameSetPoint(ForsakenInspectIcon[slot],FRAMEPOINT_TOPLEFT,slotButton,FRAMEPOINT_TOPLEFT,.002,-.002)
        call BlzFrameSetPoint(ForsakenInspectIcon[slot],FRAMEPOINT_BOTTOMRIGHT,slotButton,FRAMEPOINT_BOTTOMRIGHT,-.002,.002)
        call BlzFrameSetEnable(ForsakenInspectIcon[slot],false)
        set tip=BlzCreateFrame("EscMenuBackdrop",slotButton,0,slot+1)
        set ForsakenInspectItemText[slot]=BlzCreateFrameByType("TEXT","ForsakenInspectItemText",tip,"",slot+1)
        call BlzFrameSetAbsPoint(ForsakenInspectItemText[slot],FRAMEPOINT_TOPLEFT,.415,.40)
        call BlzFrameSetSize(ForsakenInspectItemText[slot],.23,0)
        call BlzFrameSetFont(ForsakenInspectItemText[slot],"Fonts\\FRIZQT__.TTF",.007,0)
        call BlzFrameSetPoint(tip,FRAMEPOINT_TOPLEFT,ForsakenInspectItemText[slot],FRAMEPOINT_TOPLEFT,-.018,.018)
        call BlzFrameSetPoint(tip,FRAMEPOINT_BOTTOMRIGHT,ForsakenInspectItemText[slot],FRAMEPOINT_BOTTOMRIGHT,.018,-.018)
        call BlzFrameSetLevel(tip,40)
        call BlzFrameSetTooltip(slotButton,tip)
        call BlzFrameSetVisible(tip,false)
        set slot=slot+1
    endloop
    set label=BlzCreateFrameByType("TEXT","ForsakenInspectBagLabel",ForsakenInspectRoot,"",0)
    call BlzFrameSetPoint(label,FRAMEPOINT_TOP,ForsakenInspectRoot,FRAMEPOINT_TOP,0,-.25)
    call BlzFrameSetSize(label,.22,.015)
    call BlzFrameSetFont(label,"Fonts\\FRIZQT__.TTF",.008,0)
    call BlzFrameSetTextAlignment(label,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
    set ForsakenInspectBagLabel=label
    call BlzFrameSetText(label,"Backpack - read only")
    call BlzFrameSetVisible(ForsakenInspectRoot,false)
    set slotButton=null
    set texture=null
    set label=null
    set tip=null
endfunction

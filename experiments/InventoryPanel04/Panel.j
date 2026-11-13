// Standalone replacement-panel experiment. All item access and mutations are
// synchronized; UI events read strings/IDs from shared snapshots only.
function Bag04_Field takes string data,integer wanted returns string
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

function Bag04_Item takes integer pid,integer slot returns item
    if pid<0 or pid>=8 or InvCheckHero[pid]==null then
        return null
    elseif slot>=0 and slot<9 then
        return BlzUnitItemInEquipmentSlot(InvCheckHero[pid],ConvertLoadoutSlot(slot))
    elseif slot>=9 and slot<39 then
        return BlzUnitItemInBagSlot(InvCheckHero[pid],slot-9)
    elseif slot>=39 and slot<45 then
        return UnitItemInSlot(InvCheckHero[pid],slot-39)
    endif
    return null
endfunction

function Bag04_Draw takes integer pid returns nothing
    local integer i=0
    local integer key
    if GetLocalPlayer()!=Player(pid) then
        return
    endif
    loop
        exitwhen i>=45
        set key=pid*45+i
        call BlzFrameSetTexture(Bag04Icon[i],Bag04IconPath[key],0,true)
        call BlzFrameSetText(Bag04TipText[i],Bag04Tooltip[key])
        call BlzFrameSetText(Bag04Count[i],Bag04Charges[key])
        if Bag04Held==i then
            call BlzFrameSetAlpha(Bag04Icon[i],130)
        else
            call BlzFrameSetAlpha(Bag04Icon[i],255)
        endif
        set i=i+1
    endloop
    call BlzFrameSetText(Bag04Title,GetPlayerName(Player(pid))+"|nLevel 99 Inventory Tester")
endfunction

function Bag04_Capture takes integer pid returns nothing
    local integer i=0
    local integer key
    local integer charges
    local item it
    loop
        exitwhen i>=45
        set key=pid*45+i
        set it=Bag04_Item(pid,i)
        set Bag04ItemId[key]=GetHandleId(it)
        set Bag04Charges[key]=""
        if it==null then
            set Bag04IconPath[key]="UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp"
            set Bag04Tooltip[key]="Empty slot"
        else
            set Bag04IconPath[key]=BlzGetItemIconPath(it)
            set Bag04Tooltip[key]="|cffffcc00"+GetItemName(it)+"|r|n"+BlzGetItemExtendedTooltip(it)
            set charges=GetItemCharges(it)
            if charges>0 then
                set Bag04Charges[key]=I2S(charges)
            endif
        endif
        set i=i+1
    endloop
    if Bag04Ready and GetLocalPlayer()==Player(pid) and Bag04Open then
        call Bag04_Draw(pid)
    endif
    set it=null
endfunction

function Bag04_Show takes boolean value returns nothing
    // This function is called only in the viewer's local input callback.
    set Bag04Open=value
    set Bag04Held=-1
    set Bag04HeldId=0
    call BlzFrameSetVisible(Bag04Root,value)
    if value then
        call Bag04_Draw(GetPlayerId(GetLocalPlayer()))
    else
        set Bag04Hover=-1
    endif
endfunction

function Bag04_Compatible takes item it,integer dest returns boolean
    local equipmentType kind=BlzGetItemEquipmentType(it)
    if dest==0 then
        return kind==EQUIPMENT_TYPE_HEAD
    elseif dest==1 then
        return kind==EQUIPMENT_TYPE_CHEST
    elseif dest==2 then
        return kind==EQUIPMENT_TYPE_GLOVES
    elseif dest==3 then
        return kind==EQUIPMENT_TYPE_BOOTS
    elseif dest==4 or dest==5 then
        return kind==EQUIPMENT_TYPE_RING
    elseif dest==6 then
        return kind==EQUIPMENT_TYPE_PRIMARY
    elseif dest==7 then
        return kind==EQUIPMENT_TYPE_OFFHAND
    elseif dest==8 then
        return kind==EQUIPMENT_TYPE_TRINKET
    endif
    return false
endfunction

function Bag04_Receive takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    local string data=BlzGetTriggerSyncData()
    local integer source=S2I(Bag04_Field(data,0))
    local integer expected=S2I(Bag04_Field(data,1))
    local integer dest=S2I(Bag04_Field(data,2))
    local item it
    local item other
    local unit hero
    local boolean success=false
    local integer nativeSlot
    if InvCheckScene or pid<0 or pid>=8 or source<0 or source>=45 or dest < -1 or dest>=45 then
        return
    endif
    set hero=InvCheckHero[pid]
    set it=Bag04_Item(pid,source)
    if hero==null or GetOwningPlayer(hero)!=GetTriggerPlayer() or it==null or GetHandleId(it)!=expected or GetWidgetLife(hero)<=.405 then
        set hero=null
        set it=null
        return
    endif
    if dest==-1 then
        // Explicit drop button; never remove/delete/recreate an item.
        set success=UnitDropItemPoint(hero,it,GetUnitX(hero)+100.,GetUnitY(hero))
    elseif dest==source then
        set success=true
    elseif dest<9 then
        // Native equip enforces item type/requirements. Do not manually
        // displace occupied gear or simulate any item abilities.
        set other=Bag04_Item(pid,dest)
        if other==null then
            if Bag04_Compatible(it,dest) then
                set success=BlzUnitEquipItem(hero,it)
                set success=success and Bag04_Item(pid,dest)==it
            endif
        endif
    else
        set other=Bag04_Item(pid,dest)
        if source<9 then
            // Preserve a worn item if there is nowhere safe to put it.
            if other==null then
                call BlzUnitUnequipItem(hero,it)
                set success=not BlzUnitHasItemEquipped(hero,it)
            endif
        else
            set success=true
        endif
        if success then
            if dest>=39 then
                set nativeSlot=dest-39
            else
                set nativeSlot=dest-9+6
            endif
            if Bag04_Item(pid,dest)!=it then
                set success=UnitDropItemSlot(hero,it,nativeSlot)
            endif
            // Report actual placement, not merely native return value.
            set success=success and Bag04_Item(pid,dest)==it
        endif
    endif
    call Bag04_Capture(pid)
    if not success then
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,8.,"That slot move was not accepted by the native inventory. The item has not been deleted. This replacement is a test only.")
    endif
    set hero=null
    set it=null
    set other=null
endfunction

function Bag04_Send takes integer destination returns nothing
    if Bag04Held>=0 and Bag04HeldId!=0 then
        call BlzSendSyncData("BagPanel04",I2S(Bag04Held)+":"+I2S(Bag04HeldId)+":"+I2S(destination))
        set Bag04Held=-1
        set Bag04HeldId=0
        call Bag04_Draw(GetPlayerId(GetLocalPlayer()))
    endif
endfunction

function Bag04_Click takes nothing returns nothing
    local framehandle f=BlzGetTriggerFrame()
    local integer i=0
    local integer pid=GetPlayerId(GetTriggerPlayer())
    if GetTriggerPlayer()!=GetLocalPlayer() or InvCheckScene then
        set f=null
        return
    endif
    if f==Bag04Access then
        call Bag04_Show(not Bag04Open)
    elseif f==Bag04Close then
        call Bag04_Show(false)
    elseif f==Bag04Home then
        call InvCheck_Home(GetTriggerPlayer())
    elseif f==Bag04Drop then
        call Bag04_Send(-1)
    elseif f==Bag04Talents then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"This is the independent-backpack test. RPG talents, F/G, spell previews and save loading are intentionally absent.")
    else
        loop
            exitwhen i>=45
            if f==Bag04Button[i] then
                if Bag04Held>=0 then
                    call Bag04_Send(i)
                else
                    call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,5.,"Right-click an item, then left-click its destination. Casting is outside this backpack-isolation test.")
                endif
                exitwhen true
            endif
            set i=i+1
        endloop
    endif
    set f=null
endfunction

function Bag04_Hover takes nothing returns nothing
    local integer i=0
    if GetTriggerPlayer()!=GetLocalPlayer() then
        return
    endif
    if BlzGetTriggerFrameEvent()==FRAMEEVENT_MOUSE_LEAVE then
        set Bag04Hover=-1
        return
    endif
    loop
        exitwhen i>=45
        if BlzGetTriggerFrame()==Bag04Button[i] then
            set Bag04Hover=i
            return
        endif
        set i=i+1
    endloop
endfunction

function Bag04_Mouse takes nothing returns nothing
    local integer key
    if GetTriggerPlayer()!=GetLocalPlayer() or not Bag04Open or InvCheckScene then
        return
    endif
    if BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT and Bag04Hover>=0 then
        if Bag04Held>=0 then
            call Bag04_Send(Bag04Hover)
        else
            set key=GetPlayerId(GetTriggerPlayer())*45+Bag04Hover
            if Bag04ItemId[key]!=0 then
                set Bag04Held=Bag04Hover
                set Bag04HeldId=Bag04ItemId[key]
                call Bag04_Draw(GetPlayerId(GetTriggerPlayer()))
            endif
        endif
    endif
endfunction

function Bag04_Key takes nothing returns nothing
    if GetTriggerPlayer()!=GetLocalPlayer() or InvCheckScene then
        return
    endif
    if BlzGetTriggerPlayerKey()==OSKEY_RETURN then
        set Bag04Chat=not Bag04Chat
    elseif BlzGetTriggerPlayerKey()==OSKEY_ESCAPE then
        if Bag04Chat then
            set Bag04Chat=false
        else
            call Bag04_Show(false)
        endif
    elseif not Bag04Chat then
        call Bag04_Show(not Bag04Open)
    endif
endfunction

function Bag04_Changed takes nothing returns nothing
    local integer pid=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if pid>=0 and pid<8 and GetTriggerUnit()==InvCheckHero[pid] then
        call Bag04_Capture(pid)
    endif
endfunction

function Bag04_Text takes framehandle parent,string name,real x,real y,real width,real height,real size,string value returns framehandle
    local framehandle f=BlzCreateFrameByType("TEXT",name,parent,"",0)
    call BlzFrameSetPoint(f,FRAMEPOINT_TOPLEFT,parent,FRAMEPOINT_TOPLEFT,x,y)
    call BlzFrameSetSize(f,width,height)
    call BlzFrameSetFont(f,"Fonts\\FRIZQT__.TTF",size,0)
    call BlzFrameSetText(f,value)
    call BlzFrameSetEnable(f,false)
    return f
endfunction

function Bag04_Control takes framehandle parent,string caption,real x,real y,real width,real height returns framehandle
    local framehandle f=BlzCreateFrame("ScriptDialogButton",parent,0,0)
    call BlzFrameSetPoint(f,FRAMEPOINT_TOPRIGHT,parent,FRAMEPOINT_TOPRIGHT,x,y)
    call BlzFrameSetSize(f,width,height)
    call BlzFrameSetText(f,caption)
    call BlzTriggerRegisterFrameEvent(Bag04ClickTrigger,f,FRAMEEVENT_CONTROL_CLICK)
    return f
endfunction

function Bag04_Init takes nothing returns nothing
    local integer i=0
    local integer slot
    local integer column
    local integer row
    local real x
    local real y
    local framehandle parent
    local framehandle tip
    local framehandle model
    local trigger hover=CreateTrigger()
    local trigger keys=CreateTrigger()
    local trigger mouse=CreateTrigger()
    local trigger sync=CreateTrigger()
    local trigger changes=CreateTrigger()
    set Bag04ClickTrigger=CreateTrigger()
    call TriggerAddAction(Bag04ClickTrigger,function Bag04_Click)
    call TriggerAddAction(hover,function Bag04_Hover)
    call TriggerAddAction(keys,function Bag04_Key)
    call TriggerAddAction(mouse,function Bag04_Mouse)
    call TriggerAddAction(sync,function Bag04_Receive)
    call TriggerAddAction(changes,function Bag04_Changed)
    // Construct precisely one regular-frame tree on every client at startup.
    set Bag04Root=BlzCreateFrameByType("FRAME","BagPanel04",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetSize(Bag04Root,.2075,.41705)
    call BlzFrameSetPoint(Bag04Root,FRAMEPOINT_BOTTOMRIGHT,BlzGetFrameByName("ConsoleBottomBar",0),FRAMEPOINT_TOPRIGHT,0.,.03)
    call BlzFrameSetLevel(Bag04Root,70)
    set Bag04Bag=BlzCreateFrame("EscMenuBackdrop",Bag04Root,0,0)
    call BlzFrameSetPoint(Bag04Bag,FRAMEPOINT_BOTTOMRIGHT,Bag04Root,FRAMEPOINT_BOTTOMRIGHT,0.,0.)
    call BlzFrameSetSize(Bag04Bag,.2075,.17625)
    set Bag04Gear=BlzCreateFrame("EscMenuBackdrop",Bag04Root,0,0)
    call BlzFrameSetPoint(Bag04Gear,FRAMEPOINT_BOTTOMRIGHT,Bag04Bag,FRAMEPOINT_TOPRIGHT,0.,0.)
    call BlzFrameSetSize(Bag04Gear,.2075,.2408)
    set model=BlzCreateFrameByType("SPRITE","BagPortrait04",Bag04Gear,"",0)
    call BlzFrameSetPoint(model,FRAMEPOINT_TOPLEFT,Bag04Gear,FRAMEPOINT_TOPLEFT,.034,-.008)
    call BlzFrameSetSize(model,.164,.222)
    call BlzFrameSetModel(model,"units\\human\\Footman\\Footman_Portrait.mdx",0)
    call BlzFrameSetEnable(model,false)
    set Bag04Title=Bag04_Text(Bag04Gear,"BagTitle04",.038,-.008,.145,.030,.010,"Inventory Tester")
    set Bag04Close=Bag04_Control(Bag04Gear,"X",-.010,-.008,.026,.025)
    set Bag04Talents=Bag04_Control(Bag04Gear,"Talents",-.010,-.042,.065,.025)
    set Bag04Home=Bag04_Control(Bag04Gear,"Move to hero",-.010,-.175,.096,.025)
    set Bag04Drop=Bag04_Control(Bag04Root,"Drop held item",0.,.024,.090,.022)
    loop
        exitwhen i>=45
        if i<9 then
            set parent=Bag04Gear
            if i<4 then
                set x=.012
                set y=-.016-I2R(i)*.03125
            elseif i==4 then
                set x=.012
                set y=-.19805
            elseif i==5 then
                set x=.16425
                set y=-.19805
            elseif i==6 then
                set x=.0725
                set y=-.19805
            elseif i==7 then
                set x=.10375
                set y=-.19805
            else
                set x=.012
                set y=-.1668
            endif
        elseif i<39 then
            set parent=Bag04Bag
            set slot=i-9
            set column=ModuloInteger(slot,6)
            set row=slot/6
            set x=.010+I2R(column)*.03125
            set y=-.010-I2R(row)*.03125
        else
            // Six-slot test mirror sits next to, never on top of, the bag.
            set parent=Bag04Root
            set slot=i-39
            set x=-.080+I2R(ModuloInteger(slot,2))*.033
            set y=-.2408-I2R(slot/2)*.033
        endif
        set Bag04Button[i]=BlzCreateFrameByType("BUTTON","BagSlot04",parent,"",1000+i)
        call BlzFrameSetPoint(Bag04Button[i],FRAMEPOINT_TOPLEFT,parent,FRAMEPOINT_TOPLEFT,x,y)
        call BlzFrameSetSize(Bag04Button[i],.03125,.03125)
        call BlzFrameSetLevel(Bag04Button[i],75)
        set Bag04Icon[i]=BlzCreateFrameByType("BACKDROP","BagIcon04",Bag04Button[i],"",1100+i)
        call BlzFrameSetAllPoints(Bag04Icon[i],Bag04Button[i])
        call BlzFrameSetEnable(Bag04Icon[i],false)
        set Bag04Count[i]=Bag04_Text(Bag04Button[i],"BagCount04",.012,-.015,.018,.016,.010,"")
        call BlzFrameSetTextAlignment(Bag04Count[i],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
        call BlzTriggerRegisterFrameEvent(Bag04ClickTrigger,Bag04Button[i],FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(hover,Bag04Button[i],FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(hover,Bag04Button[i],FRAMEEVENT_MOUSE_LEAVE)
        set tip=BlzCreateFrame("EscMenuBackdrop",Bag04Button[i],0,0)
        call BlzFrameSetPoint(tip,FRAMEPOINT_BOTTOMRIGHT,Bag04Root,FRAMEPOINT_BOTTOMLEFT,-.012,0.)
        call BlzFrameSetSize(tip,.250,.240)
        call BlzFrameSetEnable(tip,false)
        set Bag04TipText[i]=Bag04_Text(tip,"BagTip04",.014,-.014,.222,.212,.010,"")
        call BlzFrameSetTooltip(Bag04Button[i],tip)
        call BlzFrameSetVisible(tip,false)
        set i=i+1
    endloop
    set Bag04Access=BlzCreateFrameByType("BUTTON","BagAccess04",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetAllPoints(Bag04Access,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,4))
    call BlzFrameSetLevel(Bag04Access,90)
    set parent=BlzCreateFrameByType("BACKDROP","BagAccessIcon04",Bag04Access,"",0)
    call BlzFrameSetAllPoints(parent,Bag04Access)
    call BlzFrameSetTexture(parent,"ReplaceableTextures\\CommandButtons\\BTNBackpack.blp",0,true)
    call BlzFrameSetEnable(parent,false)
    call BlzTriggerRegisterFrameEvent(Bag04ClickTrigger,Bag04Access,FRAMEEVENT_CONTROL_CLICK)
    set i=0
    loop
        exitwhen i>=8
        // Disable the engine's global open/close controller on ALL clients.
        // Capacity/equipment abilities and native item storage remain intact.
        call UnitRemoveAbility(InvCheckHero[i],'ASpc')
        call UnitRemoveAbility(InvCheckCourier[i],'ASpc')
        call BlzTriggerRegisterPlayerSyncEvent(sync,Player(i),"BagPanel04",false)
        call BlzTriggerRegisterPlayerKeyEvent(keys,Player(i),OSKEY_B,0,true)
        call BlzTriggerRegisterPlayerKeyEvent(keys,Player(i),OSKEY_ESCAPE,0,true)
        call BlzTriggerRegisterPlayerKeyEvent(keys,Player(i),OSKEY_RETURN,0,true)
        call TriggerRegisterPlayerEvent(mouse,Player(i),EVENT_PLAYER_MOUSE_DOWN)
        call TriggerRegisterPlayerUnitEvent(changes,Player(i),EVENT_PLAYER_UNIT_PICKUP_ITEM,null)
        call TriggerRegisterPlayerUnitEvent(changes,Player(i),EVENT_PLAYER_UNIT_DROP_ITEM,null)
        call TriggerRegisterPlayerUnitEvent(changes,Player(i),EVENT_PLAYER_UNIT_EQUIP_ITEM,null)
        call TriggerRegisterPlayerUnitEvent(changes,Player(i),EVENT_PLAYER_UNIT_UNEQUIP_ITEM,null)
        call Bag04_Capture(i)
        set i=i+1
    endloop
    set Bag04Ready=true
    call Bag04_Show(false)
    set parent=null
    set tip=null
    set model=null
    set hover=null
    set keys=null
    set mouse=null
    set sync=null
    set changes=null
endfunction

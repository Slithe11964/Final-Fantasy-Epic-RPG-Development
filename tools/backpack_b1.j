    framehandle BagB1Portrait
    string BagB1PortraitPath=""
    string BagB1TitleText=""
    string array BagB1IconPath
    string array BagB1Tip
    string array BagB1Counter
    framehandle array BagB1Cooldown
    string array BagB1CooldownText
// FUNCTIONS
function BagB1_Item takes unit hero,integer slot returns item
    if hero==null then
        return null
    elseif slot>=0 and slot<9 then
        return BlzUnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot))
    elseif slot>=9 and slot<39 then
        return BlzUnitItemInBagSlot(hero,slot-9)
    elseif slot>=39 and slot<45 then
        return UnitItemInSlot(hero,slot-39)
    endif
    return null
endfunction

function BagB1_JobIcon takes integer raw returns string
// JOB_ICONS
    return "ReplaceableTextures\\CommandButtons\\BTNFootman.blp"
endfunction

function BagB1_RefreshVisibility takes nothing returns nothing
    local player viewer=GetLocalPlayer()
    local unit hero=Player_GetHero(viewer)
    if Bag04Ready then
        set Bag04Open=ForsakenBackpackWanted and not InventoryCinematicActive and not udg_InCinematicMode and not TravelVisible[GetPlayerId(viewer)] and Forsaken_InventoryContext(hero,viewer)
        call BlzFrameSetVisible(Bag04Root,Bag04Open)
        if not Bag04Open then
            if Bag04Hover>=0 then
                call BlzFrameSetVisible(Bag08TooltipFrame[Bag04Hover],false)
            endif
            set Bag04Hover=-1
            set Bag04Held=-1
            set Bag04HeldId=0
        endif
    endif
    set viewer=null
    set hero=null
endfunction

function BagB1_Close takes nothing returns nothing
    call BagB1_RefreshVisibility()
endfunction

function BagB1_Draw takes unit hero returns nothing
    local integer i=0
    local integer n
    local integer cast
    local real left
    local real height
    local item it
    local string value=BagB1_JobIcon(GetUnitTypeId(hero))
    local string description
    if value!=BagB1PortraitPath then
        set BagB1PortraitPath=value
        call BlzFrameSetTexture(BagB1Portrait,value,0,true)
    endif
    set value=GetHeroProperName(hero)+"|nLevel "+I2S(GetHeroLevel(hero))+" "+GetUnitName(hero)
    if value!=BagB1TitleText then
        set BagB1TitleText=value
        call BlzFrameSetText(Bag04Title,value)
    endif
    loop
        exitwhen i>=39
        set it=BagB1_Item(hero,i)
        set n=GetHandleId(it)
        if n!=Bag04ItemId[i] then
            set Bag04ItemId[i]=n
            if it==null then
                set value=Bag08_EmptyIcon(i)
            else
                set value=BlzGetItemIconPath(it)
            endif
            if value!=BagB1IconPath[i] then
                set BagB1IconPath[i]=value
                call BlzFrameSetTexture(Bag04Icon[i],value,0,true)
            endif
        endif
        if Bag04Held==i and Bag04HeldId!=n then
            set Bag04Held=-1
            set Bag04HeldId=0
        endif
        if Bag04Held==i then
            call BlzFrameSetAlpha(Bag04Icon[i],130)
        else
            call BlzFrameSetAlpha(Bag04Icon[i],255)
        endif
        set value=""
        if it!=null and GetItemCharges(it)>0 then
            set value=I2S(GetItemCharges(it))
        endif
        if value!=BagB1Counter[i] then
            set BagB1Counter[i]=value
            call BlzFrameSetText(Bag04Count[i],value)
        endif
        set value=""
        if it!=null then
            set cast=LoadInteger(QuickGearData,0,GetItemTypeId(it))
            if cast==0 then
                set cast=LoadInteger(GearInputSpells,0,GetItemTypeId(it))
            endif
            if cast!=0 then
                set left=RMaxBJ(NativeCD_Left(hero,NativeCD_Pool(cast)),BlzGetUnitAbilityCooldownRemaining(hero,cast))
                if left>.01 then
                    set value=I2S(R2I(left+.99))
                endif
            endif
        endif
        if value!=BagB1CooldownText[i] then
            set BagB1CooldownText[i]=value
            call BlzFrameSetText(BagB1Cooldown[i],value)
            call BlzFrameSetVisible(BagB1Cooldown[i],value!="")
        endif
        if Bag04Hover==i then
            set value=""
            if it!=null then
                set description=BlzGetItemExtendedTooltip(it)
                if description==null or description=="" then
                    set description=BlzGetItemDescription(it)
                endif
                set value="|cffffcc00"+GetItemName(it)+"|r"
                if description!=null and description!="" then
                    set value=value+"|n|n"+description
                endif
            endif
            if value!=BagB1Tip[i] then
                set BagB1Tip[i]=value
                set height=RMinBJ(.210,.043+.012*I2R((StringLength(value)+47)/48))
                call BlzFrameSetSize(Bag08TooltipFrame[i],.272,height)
                call BlzFrameSetSize(Bag04TipText[i],.250,height-.020)
                call BlzFrameSetText(Bag04TipText[i],value)
            endif
            call BlzFrameSetVisible(Bag08TooltipFrame[i],it!=null)
        endif
        set i=i+1
    endloop
    call BlzFrameSetVisible(Bag04Drop,Bag04Held>=0)
    set it=null
endfunction

function BagB1_Receive takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local unit hero=Player_GetHero(p)
    local string data=BlzGetTriggerSyncData()
    local integer source=S2I(Bag04_Field(data,0))
    local integer expected=S2I(Bag04_Field(data,1))
    local integer dest=S2I(Bag04_Field(data,2))
    local item it=BagB1_Item(hero,source)
    local item other
    local boolean accepted=false
    local integer nativeSlot
    if InventoryCinematicActive or udg_InCinematicMode or hero==null or GetOwningPlayer(hero)!=p or GetWidgetLife(hero)<=.405 or it==null or GetHandleId(it)!=expected or dest < -1 or dest>=45 then
        set p=null
        set hero=null
        set it=null
        return
    endif
    if dest==source then
        set accepted=true
    elseif dest==-1 then
        set accepted=UnitDropItemPoint(hero,it,GetUnitX(hero)+100.,GetUnitY(hero))
    elseif dest<9 then
        if Bag04_Compatible(it,dest) then
            call BlzUnitEquipItem(hero,it)
            set accepted=BagB1_Item(hero,dest)==it
        endif
    else
        set other=BagB1_Item(hero,dest)
        if source>=9 or other==null then
            if source<9 then
                call BlzUnitUnequipItem(hero,it)
            endif
            if not BlzUnitHasItemEquipped(hero,it) then
                if dest>=39 then
                    set nativeSlot=dest-39
                else
                    set nativeSlot=dest-9+6
                endif
                if BagB1_Item(hero,dest)!=it then
                    call UnitDropItemSlot(hero,it,nativeSlot)
                endif
                set accepted=BagB1_Item(hero,dest)==it
            endif
        endif
    endif
    // Native slot orders do not always emit a pickup/equip event.
    // Reconcile passives from the actual final locations on every client.
    call Forsaken_SyncStoredEffects(hero)
    if not accepted then
        call DisplayTimedTextToPlayer(p,0.,0.,3.,"That item cannot move to this slot.")
    endif
    set p=null
    set hero=null
    set it=null
    set other=null
endfunction

function BagB1_Send takes integer dest returns nothing
    if Bag04Held>=0 and Bag04HeldId!=0 then
        call BlzSendSyncData("FFBagB1",I2S(Bag04Held)+":"+I2S(Bag04HeldId)+":"+I2S(dest))
        set Bag04Held=-1
        set Bag04HeldId=0
    endif
endfunction

function BagB1_Hover takes nothing returns nothing
    local integer i=0
    local framehandle f=BlzGetTriggerFrame()
    if GetLocalPlayer()==GetTriggerPlayer() and Bag04Open and not InventoryCinematicActive then
        loop
            exitwhen i>=39
            if Bag04Button[i]==f then
                if BlzGetTriggerFrameEvent()==FRAMEEVENT_MOUSE_LEAVE then
                    call BlzFrameSetVisible(Bag08TooltipFrame[i],false)
                    if Bag04Hover==i then
                        set Bag04Hover=-1
                    endif
                else
                    if Bag04Hover>=0 and Bag04Hover!=i then
                        call BlzFrameSetVisible(Bag08TooltipFrame[Bag04Hover],false)
                    endif
                    set Bag04Hover=i
                    call BagB1_Draw(Player_GetHero(GetLocalPlayer()))
                endif
                exitwhen true
            endif
            set i=i+1
        endloop
    endif
    set f=null
endfunction

function BagB1_WorldClick takes nothing returns nothing
    if not Bag04Open or Bag04Hover<0 or InventoryCinematicActive or BlzGetTriggerPlayerMouseButton()!=MOUSE_BUTTON_TYPE_RIGHT then
        return
    endif
    if Bag04Held>=0 then
        call BagB1_Send(Bag04Hover)
    elseif Bag04ItemId[Bag04Hover]!=0 then
        set Bag04Held=Bag04Hover
        set Bag04HeldId=Bag04ItemId[Bag04Hover]
    endif
endfunction

function BagB1_Click takes nothing returns nothing
    local framehandle f=BlzGetTriggerFrame()
    local player p=GetTriggerPlayer()
    local integer i=0
    if GetLocalPlayer()==p and Bag04Open and not InventoryCinematicActive then
        if f==Bag04Close then
            call Forsaken_CloseBackpack()
        elseif f==Bag04Talents then
            set ForsakenTalentsWanted=not ForsakenTalentsWanted
            set ForsakenNextPanelDraw=0.
        elseif f==Bag04Home then
            call SelectUnitForPlayerSingle(Player_GetHero(p),p)
        elseif f==Bag04Drop then
            call BagB1_Send(-1)
        else
            loop
                exitwhen i>=39
                if f==Bag04Button[i] then
                    if Bag04Held>=0 then
                        call BagB1_Send(i)
                    elseif Bag04ItemId[i]!=0 then
                        call QuickGear_Request(10+i)
                    endif
                    exitwhen true
                endif
                set i=i+1
            endloop
        endif
    endif
    set p=null
    set f=null
endfunction

function BagB1_Init takes nothing returns nothing
    local integer i=0
    local framehandle console
    local trigger hover=CreateTrigger()
    local trigger sync=CreateTrigger()
    set Bag04ClickTrigger=CreateTrigger()
    call TriggerAddAction(Bag04ClickTrigger,function BagB1_Click)
    call TriggerAddAction(hover,function BagB1_Hover)
    call TriggerAddAction(sync,function BagB1_Receive)
    // CREATE_PANEL
    set i=0
    loop
        exitwhen i>=39
        set Bag04ItemId[i]=-1
        set BagB1Cooldown[i]=Bag04_Text(Bag04Button[i],"BagB1Cooldown",0.,0.,.029,.027,.012,"")
        call BlzFrameSetTextAlignment(BagB1Cooldown[i],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetVisible(BagB1Cooldown[i],false)
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=8
        call BlzTriggerRegisterPlayerSyncEvent(sync,Player(i),"FFBagB1",false)
        set i=i+1
    endloop
    set Bag04Ready=true
    call BlzFrameSetVisible(Bag04Root,false)
    set hover=null
    set sync=null
    set console=null
endfunction

function BagB1_Tick takes unit hero,player viewer returns nothing
    if not Bag04Ready then
        call BagB1_Init()
    endif
    call BagB1_RefreshVisibility()
    if Bag04Open then
        call BagB1_Draw(hero)
    endif
endfunction

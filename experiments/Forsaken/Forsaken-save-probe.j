library TForsakenSaveProbe requires TForsakenSaveLife
// Private engine diagnostic. Inventory capture/codec checks only; never loads or exports a save.
globals
    trigger gg_trg_Forsaken_SaveProbe=null
    hashtable FSX_Map=null
    hashtable FSX_Timers=null
    integer array FSX_Phase
    integer array FSX_Position
    integer array FSX_Count
    boolean array FSX_Compare
    string array FSX_Body
    string array FSX_Last
    string array FSX_Record
    string array FSX_Error
    item array FSX_Handle
    integer array FSX_Raw
    player array FSX_Owner
    boolean array FSX_Visible
    unit array FSX_Hero
    unit array FSX_Gaya
    unit array FSX_House
    timer array FSX_Timer
    timer array FSX_Watchdog
    item array FSX_TestItem
endglobals

function FSX_Message takes integer pid,string message returns nothing
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save test: "+message)
endfunction

function FSX_Stop takes integer pid,string message returns nothing
    local integer slot=0
    call PauseTimer(FSX_Timer[pid])
    call PauseTimer(FSX_Watchdog[pid])
    call RemoveSavedInteger(FSX_Timers,GetHandleId(FSX_Timer[pid]),0)
    call RemoveSavedInteger(FSX_Timers,GetHandleId(FSX_Watchdog[pid]),0)
    call DestroyTimer(FSX_Timer[pid])
    call DestroyTimer(FSX_Watchdog[pid])
    set FSX_Timer[pid]=null
    set FSX_Watchdog[pid]=null
    set FSX_Hero[pid]=null
    set FSX_Gaya[pid]=null
    set FSX_House[pid]=null
    set FSX_Body[pid]=null
    loop
        exitwhen slot>=57
        set FSX_Handle[pid*57+slot]=null
        set FSX_Owner[pid*57+slot]=null
        set FSX_Record[pid*57+slot]=null
        set slot=slot+1
    endloop
    set FSX_Phase[pid]=0
    call FSX_Message(pid,message)
endfunction

function FSX_At takes integer pid,integer position returns item
    if position<6 then
        return UnitItemInSlot(FSX_Hero[pid],position)
    elseif position<36 then
        return UnitItemInBagSlot(FSX_Hero[pid],position-6)
    elseif position<45 then
        return UnitItemInEquipmentSlot(FSX_Hero[pid],ConvertLoadoutSlot(position-36))
    elseif position<51 then
        if FSX_Gaya[pid]!=null then
            return UnitItemInSlot(FSX_Gaya[pid],position-45)
        endif
    elseif FSX_House[pid]!=null then
        return UnitItemInSlot(FSX_House[pid],position-51)
    endif
    return null
endfunction

function FSX_Read takes integer pid,integer position,item carried returns string
    local integer id
    local integer quantity
    local integer flags=0
    local integer holder
    local integer slot
    local string bound="A"
    local string life
    local string flagText
    local string record
    if carried==null then
        return ""
    endif
    set id=LoadInteger(FSX_Map,0,GetItemTypeId(carried))
    if id==0 then
        set FSX_Error[pid]="unknown item at position "+I2S(position)+"; nothing omitted."
        return null
    endif
    set quantity=GetItemCharges(carried)
    if quantity<0 or quantity>127 then
        set FSX_Error[pid]="quantity outside 0..127 at position "+I2S(position)+"."
        return null
    endif
    if GetItemUserData(carried)==pid+1 then
        set bound="B"
    elseif GetItemUserData(carried)!=0 then
        set FSX_Error[pid]="foreign binding at position "+I2S(position)+"."
        return null
    endif
    set life=FSL_CaptureLife(pid,carried)
    if life==null then
        set FSX_Error[pid]="item life could not be captured exactly."
        return null
    endif
    if IsItemInvulnerable(carried) then
        set flags=flags+1
    endif
    if BlzGetItemBooleanField(carried,ITEM_BF_CAN_BE_DROPPED) then
        set flags=flags+2
    endif
    if IsItemPawnable(carried) then
        set flags=flags+4
    endif
    set flagText=FSC_Uint(flags)
    if position<6 then
        set holder=1
        set slot=position
    elseif position<36 then
        set holder=2
        set slot=position-6
    elseif position<45 then
        set holder=3
        set slot=position-36
    elseif position<51 then
        set holder=4
        set slot=position-45
    else
        set holder=5
        set slot=position-51
    endif
    set record=FSC_Uint(position+1)+FSC_Uint(id)+FSC_Uint(holder)+FSC_Uint(slot)+"B"+SubString(FSC_ALPHABET,ModuloInteger(quantity,64),ModuloInteger(quantity,64)+1)+SubString(FSC_ALPHABET,quantity/64,quantity/64+1)+bound+"C"
    set record=record+"BB"+FSC_Uint(StringLength(life))+life+"CB"+FSC_Uint(StringLength(flagText))+flagText
    return FSC_Uint(StringLength(record))+record
endfunction

function FSX_Tick takes nothing returns nothing
    local integer pid=LoadInteger(FSX_Timers,GetHandleId(GetExpiredTimer()),0)-1
    local integer position=FSX_Position[pid]
    local integer index=pid*57+position
    local item carried
    local string record
    local string payload
    local string encoded
    if FSX_Hero[pid]!=udg_PlayerHero[pid+1] or FSX_Gaya[pid]!=udg_SpiritOfGaya[pid+1] or FSX_House[pid]!=udg_PlayerHouse[pid+1] then
        call FSX_Stop(pid,"FAIL: hero/storage reference changed; retry while standing still.")
        return
    endif
    if position<57 then
        set carried=FSX_At(pid,position)
        set record=FSX_Read(pid,position,carried)
        if record==null then
            call FSX_Stop(pid,"FAIL: "+FSX_Error[pid])
            set carried=null
            return
        endif
        if FSX_Phase[pid]==1 then
            set FSX_Handle[index]=carried
            set FSX_Record[index]=record
            if carried!=null then
                set FSX_Raw[index]=GetItemTypeId(carried)
                set FSX_Owner[index]=GetItemPlayer(carried)
                set FSX_Visible[index]=IsItemVisible(carried)
                set FSX_Count[pid]=FSX_Count[pid]+1
            endif
            set FSX_Body[pid]=FSX_Body[pid]+record
        elseif carried!=FSX_Handle[index] or record!=FSX_Record[index] then
            call FSX_Stop(pid,"FAIL: inventory changed during capture; retry while standing still.")
            set carried=null
            return
        elseif carried!=null and (GetItemTypeId(carried)!=FSX_Raw[index] or GetItemPlayer(carried)!=FSX_Owner[index] or IsItemVisible(carried)!=FSX_Visible[index]) then
            call FSX_Stop(pid,"FAIL: item identity/owner/visibility changed during capture.")
            set carried=null
            return
        endif
        set FSX_Position[pid]=position+1
        set carried=null
        return
    endif
    if FSX_Phase[pid]==1 then
        set FSX_Phase[pid]=2
        set FSX_Position[pid]=0
        return
    endif
    set payload=FSC_Uint(FSX_Count[pid])+FSX_Body[pid]
    if FSX_Compare[pid] and payload!=FSX_Last[pid] then
        call FSX_Stop(pid,"CHANGED: inventory differs from the last passing capture.")
        return
    endif
    // Diagnostic account = pid, not a real account binding or a durable save profile.
    if not FSC_Begin(pid,pid) or not FSC_Add(pid,1,1,true,payload) then
        call FSC_Abort(pid)
        call FSX_Stop(pid,"FAIL: inventory writer refused the snapshot.")
        return
    endif
    set encoded=FSC_Finish(pid,false)
    if encoded==null or FSC_Reencode(pid)!=encoded or FSC_Payload[(pid+1)*32]!=payload then
        call FSX_Stop(pid,"FAIL: encode/decode/readback mismatch.")
        return
    endif
    if FSC_Decode(pid,encoded,pid+1,false) or FSC_Decode(pid,encoded+"A",pid,false) or FSC_Code[pid]!=encoded then
        call FSX_Stop(pid,"FAIL: invalid input replaced the accepted test snapshot.")
        return
    endif
    set FSX_Last[pid]=payload
    call FSX_Stop(pid,"PASS: "+I2S(FSX_Count[pid])+" items across 57 slots; "+I2S(StringLength(encoded))+" characters. Exact round trip; wrong account and trailing data rejected. Inventory unchanged. This is not a usable character save.")
endfunction

function FSX_Timeout takes nothing returns nothing
    local integer pid=LoadInteger(FSX_Timers,GetHandleId(GetExpiredTimer()),0)-1
    call PauseTimer(FSX_Timer[pid])
    set FSX_Phase[pid]=-1
    call FSX_Message(pid,"TIMEOUT: engine work did not finish. Restart this test game and report the item count; no character load was attempted.")
endfunction

function FSX_Start takes integer pid,boolean compare returns nothing
    local boolean flagsOk
    if FSX_Phase[pid]!=0 then
        call FSX_Message(pid,"test already running or timed out; restart after a timeout.")
        return
    endif
    if compare and FSX_Last[pid]==null then
        call FSX_Message(pid,"run -savecheck first.")
        return
    endif
    if udg_PlayerHero[pid+1]==null or UnitExtendedInventorySize(udg_PlayerHero[pid+1])!=30 then
        call FSX_Message(pid,"select a hero with the Forsaken backpack first.")
        return
    endif
    if FSX_TestItem[pid]!=null then
        call FSX_Message(pid,"temporary probe cleanup was unverified; restart this test game.")
        return
    endif
    set FSX_TestItem[pid]=CreateItem('fGap',0.,0.)
    if FSX_TestItem[pid]==null then
        call FSX_Message(pid,"FAIL: temporary flag probe could not be created.")
        return
    endif
    call SetItemVisible(FSX_TestItem[pid],false)
    call SetItemDroppable(FSX_TestItem[pid],false)
    set flagsOk=not BlzGetItemBooleanField(FSX_TestItem[pid],ITEM_BF_CAN_BE_DROPPED)
    call SetItemDroppable(FSX_TestItem[pid],true)
    set flagsOk=flagsOk and BlzGetItemBooleanField(FSX_TestItem[pid],ITEM_BF_CAN_BE_DROPPED)
    call RemoveItem(FSX_TestItem[pid])
    if GetItemTypeId(FSX_TestItem[pid])!=0 then
        call FSX_Message(pid,"FAIL: temporary flag probe deletion was not verified; restart.")
        return
    endif
    set FSX_TestItem[pid]=null
    if not flagsOk then
        call FSX_Message(pid,"FAIL: droppability getter did not follow both values.")
        return
    endif
    set FSX_Hero[pid]=udg_PlayerHero[pid+1]
    set FSX_Gaya[pid]=udg_SpiritOfGaya[pid+1]
    set FSX_House[pid]=udg_PlayerHouse[pid+1]
    set FSX_Compare[pid]=compare
    set FSX_Count[pid]=0
    set FSX_Position[pid]=0
    set FSX_Body[pid]=""
    set FSX_Phase[pid]=1
    set FSX_Timer[pid]=CreateTimer()
    set FSX_Watchdog[pid]=CreateTimer()
    call SaveInteger(FSX_Timers,GetHandleId(FSX_Timer[pid]),0,pid+1)
    call SaveInteger(FSX_Timers,GetHandleId(FSX_Watchdog[pid]),0,pid+1)
    call TimerStart(FSX_Watchdog[pid],10.,false,function FSX_Timeout)
    call TimerStart(FSX_Timer[pid],0.02,true,function FSX_Tick)
    call FSX_Message(pid,"checking quick slots, backpack, equipment, Gaya and house; stand still for three seconds.")
endfunction

function FSX_Chat takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    if GetEventPlayerChatString()=="-saveverify" then
        call FSX_Start(pid,true)
    else
        call FSX_Start(pid,false)
    endif
endfunction

function InitTrig_ForsakenSaveProbe takes nothing returns nothing
    local integer pid=0
    set FSX_Map=InitHashtable()
    set FSX_Timers=InitHashtable()
    // FSX_IDENTITY_INITIALIZATION
    set gg_trg_Forsaken_SaveProbe=CreateTrigger()
    loop
        exitwhen pid>=8
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_SaveProbe,Player(pid),"-savecheck",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_SaveProbe,Player(pid),"-saveverify",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_SaveProbe,function FSX_Chat)
endfunction
endlibrary

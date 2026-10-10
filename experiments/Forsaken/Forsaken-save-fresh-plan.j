library TForsakenSaveFreshPlan requires TForsakenSaveCapture
// Detached CU plan. No gameplay writes, object creation, or live-swap dependencies.
globals
    hashtable FFP_Bindings=null
    hashtable FFP_Values=null
    boolean array FFP_Ready
    string array FFP_Error
    string array FFP_Code
    integer array FFP_Account
    integer array FFP_Count
    integer array FFP_Raw
    integer array FFP_Holder
    integer array FFP_Slot
    integer array FFP_Quantity
    boolean array FFP_Bound
    integer array FFP_High
    integer array FFP_Low
    integer array FFP_Flags
    unit array FFP_Starter
    unit array FFP_Gaya
    unit array FFP_House
endglobals

function FFP_Clear takes integer pid returns nothing
    local integer i=0
    if not FSC_PlayerValid(pid) then
        return
    endif
    set FFP_Ready[pid]=false
    set FFP_Code[pid]=null
    set FFP_Starter[pid]=null
    set FFP_Gaya[pid]=null
    set FFP_House[pid]=null
    set FFP_Account[pid]=0
    set FFP_Count[pid]=0
    loop
        exitwhen i>=16
        if FFP_Values!=null then
            call FlushChildHashtable(FFP_Values,pid*16+i)
        endif
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=57
        set FFP_Raw[pid*57+i]=0
        set FFP_Holder[pid*57+i]=0
        set FFP_Slot[pid*57+i]=0
        set FFP_Quantity[pid*57+i]=0
        set FFP_Bound[pid*57+i]=false
        set FFP_High[pid*57+i]=0
        set FFP_Low[pid*57+i]=0
        set FFP_Flags[pid*57+i]=0
        set i=i+1
    endloop
endfunction

function FFP_Eligible takes integer pid,boolean windowOpen returns boolean
    local integer i=0
    local unit hero
    local unit gaya
    local unit house
    if not FSC_PlayerValid(pid) then
        return false
    endif
    set FFP_Error[pid]=null
    if not windowOpen then
        set FFP_Error[pid]="the load window has closed"
        return false
    elseif not udg_HardcoreOff then
        set FFP_Error[pid]="loading is disabled in Hardcore"
        return false
    elseif udg_HasLoadedCode[pid] then
        set FFP_Error[pid]="a character has already loaded this game"
        return false
    elseif not IsPlayerInForce(Player(pid),udg_PlayingPlayers) then
        set FFP_Error[pid]="player is no longer active"
        return false
    elseif FSC_Busy[pid] or FSC_Writing[pid] or FRC_Phase[pid]!=0 then
        set FFP_Error[pid]="save work is still in progress"
        return false
    endif
    set hero=udg_PlayerHero[pid+1]
    set gaya=udg_SpiritOfGaya[pid+1]
    set house=udg_PlayerHouse[pid+1]
    if hero==null or gaya==null or house==null or GetUnitTypeId(hero)==0 or GetUnitTypeId(gaya)==0 or GetUnitTypeId(house)==0 then
        set FFP_Error[pid]="starting character, Gaya or assigned house is missing"
        return false
    elseif GetOwningPlayer(hero)!=Player(pid) or GetOwningPlayer(gaya)!=Player(pid) or GetOwningPlayer(house)!=Player(pid) then
        set FFP_Error[pid]="starting objects are not assigned to this player"
        return false
    elseif GetHeroLevel(hero)!=1 or GetHeroLevel(gaya)!=1 or udg_FreelancerHero[pid+1]!=null or UnitExtendedInventorySize(hero)!=30 then
        set FFP_Error[pid]="CU requires the untouched starting character and Gaya"
        return false
    endif
    loop
        exitwhen i>=57
        if (i<6 and UnitItemInSlot(hero,i)!=null) or (i>=6 and i<36 and UnitItemInBagSlot(hero,i-6)!=null) or (i>=36 and i<45 and UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(i-36))!=null) or (i>=45 and i<51 and UnitItemInSlot(gaya,i-45)!=null) or (i>=51 and UnitItemInSlot(house,i-51)!=null) then
            set FFP_Error[pid]="starting inventory or house is occupied; no items replaced"
            return false
        endif
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=22
        if udg_JobUnitType[i]!=FRC_JobRaw(i) or LoadInteger(udg_JobLevelHash,FRC_JobRaw(i),pid)>1 or (LoadUnitHandle(udg_JobHeroHash,FRC_JobRaw(i),pid)!=null and LoadUnitHandle(udg_JobHeroHash,FRC_JobRaw(i),pid)!=hero) then
            set FFP_Error[pid]="CU requires fresh job progress"
            return false
        endif
        set i=i+1
    endloop
    set hero=null
    set gaya=null
    set house=null
    return true
endfunction

function FFP_ReadSection takes integer pid,integer ctx,integer sid,string payload returns boolean
    local integer count
    local integer i=0
    local integer identity
    local integer value
    local integer tier
    local integer maximum=0
    set FSC_Text[ctx]=payload
    set FSC_Pos[ctx]=0
    set FSC_End[ctx]=StringLength(payload)
    set FSC_Ok[ctx]=true
    set count=FSC_Read(ctx)
    if sid==2 then
        set maximum=22
    elseif sid==4 or sid==6 then
        set maximum=15
    elseif sid==5 then
        set maximum=8
    elseif sid==7 then
        set maximum=100
    elseif sid==8 then
        set maximum=358
    endif
    if count>maximum then
        return false
    endif
    loop
        exitwhen i>=count or not FSC_Ok[ctx]
        set identity=FSC_Read(ctx)
        set value=FSC_Read(ctx)
        if identity<1 or identity>maximum then
            return false
        endif
        if sid==2 then
            set tier=FSC_Read(ctx)
            if value>99 then
                set FFP_Error[pid]="saved job exceeds the current engine cap99"
                return false
            endif
            call SaveInteger(FFP_Values,pid*16+10,identity,tier)
        endif
        call SaveInteger(FFP_Values,pid*16+sid,identity,value)
        set i=i+1
    endloop
    return FSC_Ok[ctx] and FSC_Pos[ctx]==FSC_End[ctx]
endfunction

function FFP_Build takes integer pid,string encoded,boolean windowOpen returns boolean
    // Context25..32 is separate from accepted, decoder and writer contexts.
    local integer ctx=pid+25
    local integer i=0
    local integer sid
    local integer index
    local integer sourceIndex
    local integer targetIndex
    local integer raw
    local integer slotPower
    local boolean valid=true
    if not FSC_PlayerValid(pid) then
        return false
    endif
    call FFP_Clear(pid)
    if not FFP_Eligible(pid,windowOpen) then
        return false
    elseif FFP_Bindings==null or FFP_Values==null then
        set FFP_Error[pid]="fresh-load bindings are not initialized"
        return false
    endif
    if FSC_Seen==null then
        set FSC_Seen=InitHashtable()
    endif
    set FSC_Busy[pid]=true
    call FSC_Clear(ctx)
    call FSC_ClearSeen(ctx)
    set valid=FSC_Parse(ctx,encoded,FRC_Account(pid),true)
    if valid then
        set valid=FSC_Count[ctx]==7
    endif
    loop
        exitwhen i>=FSC_Count[ctx] or not valid
        set index=ctx*32+i
        set sid=FSC_Id[index]
        if sid==3 or sid<1 or sid>8 or not FSC_Required[index] or ((sid==2 or sid==4) and FSC_Version[index]!=2) or (sid!=2 and sid!=4 and FSC_Version[index]!=1) then
            set valid=false
        elseif sid!=1 then
            set valid=FFP_ReadSection(pid,ctx,sid,FSC_Payload[index])
        endif
        set i=i+1
    endloop
    if valid then
        set FFP_Count[pid]=FSC_ItemCount[ctx]
        set i=0
        loop
            exitwhen i>=FFP_Count[pid] or not valid
            set sourceIndex=ctx*57+i
            set targetIndex=pid*57+i
            set raw=LoadInteger(FFP_Bindings,FSC_ItemHolder[sourceIndex],FSC_ItemId[sourceIndex])
            if raw==0 or FSC_ItemQuantity[sourceIndex]<0 or not FSC_ItemComplete[sourceIndex] or FSC_ItemDormant[sourceIndex] then
                set FFP_Error[pid]="unknown item, incomplete metadata or unsupported stored data"
                set valid=false
            elseif FSC_ItemHolder[sourceIndex]==3 then
                set slotPower=1
                set sid=0
                loop
                    exitwhen sid>=FSC_ItemSlot[sourceIndex]
                    set slotPower=slotPower*2
                    set sid=sid+1
                endloop
                if ModuloInteger(LoadInteger(FFP_Bindings,6,FSC_ItemId[sourceIndex])/slotPower,2)!=1 then
                    set FFP_Error[pid]="item cannot occupy the saved equipment slot"
                    set valid=false
                endif
                if FSC_ItemSlot[sourceIndex]==7 then
                    set raw=LoadInteger(FFP_Bindings,7,FSC_ItemId[sourceIndex])
                    if raw==0 then
                        set valid=false
                    endif
                endif
            endif
            if valid then
                set FFP_Raw[targetIndex]=raw
                set FFP_Holder[targetIndex]=FSC_ItemHolder[sourceIndex]
                set FFP_Slot[targetIndex]=FSC_ItemSlot[sourceIndex]
                set FFP_Quantity[targetIndex]=FSC_ItemQuantity[sourceIndex]
                set FFP_Bound[targetIndex]=FSC_ItemBound[sourceIndex]
                set FFP_High[targetIndex]=FSC_ItemHigh[sourceIndex]
                set FFP_Low[targetIndex]=FSC_ItemLow[sourceIndex]
                set FFP_Flags[targetIndex]=FSC_ItemFlags[sourceIndex]
            endif
            set i=i+1
        endloop
    endif
    call FSC_ClearSeen(ctx)
    call FSC_Clear(ctx)
    set FSC_Busy[pid]=false
    if valid then
        if LoadInteger(FFP_Values,pid*16+5,2)<1 then
            set FFP_Error[pid]="saved Gaya level is not supported"
            set valid=false
        elseif LoadInteger(FFP_Values,pid*16+4,4)>99 then
            set FFP_Error[pid]="saved Freelancer exceeds the current engine cap99"
            set valid=false
        elseif LoadInteger(FFP_Values,pid*16+4,1)!=udg_Difficulty then
            set FFP_Error[pid]="CU requires matching saved and game difficulty"
            set valid=false
        elseif (LoadInteger(FFP_Values,pid*16+4,15)==1)!=udg_SpeedrunMode then
            set FFP_Error[pid]="saved Speedrun mode does not match this game"
            set valid=false
        endif
    endif
    if not valid then
        if FFP_Error[pid]==null then
            set FFP_Error[pid]="unsupported or invalid fresh-load profile"
        endif
        call FFP_Clear(pid)
        return false
    endif
    set FFP_Code[pid]=encoded
    set FFP_Account[pid]=FRC_Account(pid)
    set FFP_Starter[pid]=udg_PlayerHero[pid+1]
    set FFP_Gaya[pid]=udg_SpiritOfGaya[pid+1]
    set FFP_House[pid]=udg_PlayerHouse[pid+1]
    set FFP_Ready[pid]=true
    return true
endfunction

function FFP_Recheck takes integer pid,boolean windowOpen returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    elseif not FFP_Ready[pid] then
        set FFP_Error[pid]="no validated fresh-load plan"
        return false
    endif
    if not FFP_Eligible(pid,windowOpen) then
        call FFP_Clear(pid)
        return false
    elseif FFP_Account[pid]!=FRC_Account(pid) or FFP_Starter[pid]!=udg_PlayerHero[pid+1] or FFP_Gaya[pid]!=udg_SpiritOfGaya[pid+1] or FFP_House[pid]!=udg_PlayerHouse[pid+1] or LoadInteger(FFP_Values,pid*16+4,1)!=udg_Difficulty or (LoadInteger(FFP_Values,pid*16+4,15)==1)!=udg_SpeedrunMode then
        set FFP_Error[pid]="player or game context changed before creation"
        call FFP_Clear(pid)
        return false
    endif
    return true
endfunction

function FFP_Init takes nothing returns nothing
    if FFP_Bindings==null then
        set FFP_Bindings=InitHashtable()
        set FFP_Values=InitHashtable()
        // FFP_IDENTITY_INITIALIZATION
    endif
endfunction
endlibrary

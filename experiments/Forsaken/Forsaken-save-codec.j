library TForsakenSaveCodec
// Isolated research codec. No triggers, gameplay writes, file IO or save routes.
globals
    // Bounded scratch item projection; payloads remain authoritative.
    integer array FSC_ItemCount
    integer array FSC_ItemOrdinal
    integer array FSC_ItemId
    integer array FSC_ItemHolder
    integer array FSC_ItemSlot
    integer array FSC_ItemQuantity
    boolean array FSC_ItemBound
    integer array FSC_ItemHigh
    integer array FSC_ItemLow
    integer array FSC_ItemFlags
    boolean array FSC_ItemDormant
    boolean array FSC_ItemComplete
    integer array FSC_MetaHigh
    integer array FSC_MetaLow
    integer array FSC_MetaFlags
    boolean array FSC_MetaDormant
    boolean array FSC_Cheater
    constant string FSC_ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#"
    constant integer FSC_MAX_PAYLOAD=16384
    constant integer FSC_MAX_OPAQUE=4096
    hashtable FSC_Seen=null
    boolean array FSC_ActivationBlocked
    boolean array FSC_PreparedBlocked
    boolean array FSC_OwnershipBlocked
    boolean array FSC_BodyBlocked
    boolean array FSC_ReferenceBlocked
    boolean array FSC_UnitBlocked
    boolean array FSC_SessionBlocked
    boolean array FSC_Busy
    boolean array FSC_Writing
    boolean array FSC_BuildOk
    integer array FSC_BuildSize
    string array FSC_Code
    integer array FSC_Account
    integer array FSC_Count
    integer array FSC_Id
    integer array FSC_Version
    boolean array FSC_Required
    string array FSC_Payload
    string array FSC_Text
    integer array FSC_Pos
    integer array FSC_End
    boolean array FSC_Ok
    integer array FSC_Opaque
    integer array FSC_Dormant
    integer array FSC_Spec
    integer array FSC_Gaya
    boolean array FSC_HasEvidence
    boolean array FSC_MetadataComplete
endglobals

function FSC_PlayerValid takes integer pid returns boolean
    return pid>=0 and pid<8
endfunction

function FSC_Value takes string char returns integer
    local integer i=0
    if StringLength(char)!=1 then
        return -1
    endif
    loop
        exitwhen i>=64
        if SubString(FSC_ALPHABET,i,i+1)==char then
            return i
        endif
        set i=i+1
    endloop
    return -1
endfunction

function FSC_AlphabetValid takes string text returns boolean
    local integer i=0
    local integer size=StringLength(text)
    loop
        exitwhen i>=size
        if FSC_Value(SubString(text,i,i+1))<0 then
            return false
        endif
        set i=i+1
    endloop
    return true
endfunction

function FSC_Uint takes integer value returns string
    local integer part
    local string result=""
    if value<0 then
        return null
    endif
    loop
        set part=ModuloInteger(value,32)
        set value=value/32
        if value>0 then
            set part=part+32
        endif
        set result=result+SubString(FSC_ALPHABET,part,part+1)
        exitwhen value==0
    endloop
    return result
endfunction

function FSC_Read takes integer ctx returns integer
    local integer value=0
    local integer factor=1
    local integer index=0
    local integer digit
    local integer part
    loop
        if not FSC_Ok[ctx] or FSC_Pos[ctx]>=FSC_End[ctx] then
            set FSC_Ok[ctx]=false
            return 0
        endif
        set digit=FSC_Value(SubString(FSC_Text[ctx],FSC_Pos[ctx],FSC_Pos[ctx]+1))
        set FSC_Pos[ctx]=FSC_Pos[ctx]+1
        if digit<0 then
            set FSC_Ok[ctx]=false
            return 0
        endif
        set part=ModuloInteger(digit,32)
        // Check before multiplying/adding. Seventh group has only one data bit.
        if index==6 and part>1 then
            set FSC_Ok[ctx]=false
            return 0
        endif
        set value=value+part*factor
        if digit<32 then
            if index>0 and part==0 then
                set FSC_Ok[ctx]=false
            endif
            return value
        endif
        if index==6 then
            set FSC_Ok[ctx]=false
            return 0
        endif
        set factor=factor*32
        set index=index+1
    endloop
    return 0
endfunction

function FSC_Checksum takes string text returns integer
    local integer a=1
    local integer b=0
    local integer i=0
    local integer size=StringLength(text)
    local integer digit
    loop
        exitwhen i>=size
        set digit=FSC_Value(SubString(text,i,i+1))
        if digit<0 then
            return -1
        endif
        set a=ModuloInteger(a+digit+1,32749)
        set b=ModuloInteger(b+a,32749)
        set i=i+1
    endloop
    return b*32768+a
endfunction

function FSC_Mark takes integer ctx,integer scope,integer identity returns boolean
    local integer parent=ctx*16+scope
    if LoadBoolean(FSC_Seen,parent,identity) then
        set FSC_Ok[ctx]=false
        return false
    endif
    call SaveBoolean(FSC_Seen,parent,identity,true)
    return true
endfunction

function FSC_ClearSeen takes integer ctx returns nothing
    local integer i=0
    loop
        exitwhen i>=9
        call FlushChildHashtable(FSC_Seen,ctx*16+i)
        set i=i+1
    endloop
endfunction

function FSC_Clear takes integer ctx returns nothing
    local integer i=0
    loop
        exitwhen i>=32
        set FSC_Id[ctx*32+i]=0
        set FSC_Version[ctx*32+i]=0
        set FSC_Required[ctx*32+i]=false
        set FSC_Payload[ctx*32+i]=null
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=16
        set FSC_Spec[ctx*16+i]=0
        set FSC_Gaya[ctx*16+i]=0
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=57
        set FSC_ItemOrdinal[ctx*57+i]=0
        set FSC_ItemId[ctx*57+i]=0
        set FSC_ItemHolder[ctx*57+i]=0
        set FSC_ItemSlot[ctx*57+i]=0
        set FSC_ItemQuantity[ctx*57+i]=0
        set FSC_ItemBound[ctx*57+i]=false
        set FSC_ItemHigh[ctx*57+i]=0
        set FSC_ItemLow[ctx*57+i]=0
        set FSC_ItemFlags[ctx*57+i]=0
        set FSC_ItemDormant[ctx*57+i]=false
        set FSC_ItemComplete[ctx*57+i]=false
        set i=i+1
    endloop
    set FSC_ItemCount[ctx]=0
    set FSC_Cheater[ctx]=false
    set FSC_Count[ctx]=0
    set FSC_Account[ctx]=0
    set FSC_Text[ctx]=null
    set FSC_Pos[ctx]=0
    set FSC_End[ctx]=0
    set FSC_Ok[ctx]=true
    set FSC_Opaque[ctx]=0
    set FSC_Dormant[ctx]=0
    set FSC_HasEvidence[ctx]=false
    set FSC_MetadataComplete[ctx]=true
endfunction

function FSC_HolderSize takes integer holder returns integer
    if holder==2 then
        return 30
    elseif holder==3 then
        return 9
    elseif holder==1 or holder==4 or holder==5 then
        return 6
    endif
    return 0
endfunction

function FSC_Life takes integer ctx returns nothing
    local integer high=FSC_Read(ctx)
    local integer low=FSC_Read(ctx)
    set FSC_MetaHigh[ctx]=high
    set FSC_MetaLow[ctx]=low
    // Validate binary32 words without converting/reinterpreting a JASS real.
    // Sign, exponent255, and zero are invalid; positive subnormals are valid.
    if high>65535 or low>65535 or high>=32640 or (high==0 and low==0) then
        set FSC_Ok[ctx]=false
    endif
endfunction

function FSC_Metadata takes integer ctx,integer count returns nothing
    local integer i=0
    local integer sid
    local integer flags
    local integer size
    local integer outerEnd=FSC_End[ctx]
    local integer entryEnd
    local integer value
    local boolean life=false
    local boolean itemFlags=false
    set FSC_MetaHigh[ctx]=0
    set FSC_MetaLow[ctx]=0
    set FSC_MetaFlags[ctx]=-1
    set FSC_MetaDormant[ctx]=false
    call FlushChildHashtable(FSC_Seen,ctx*16+4)
    if count>16 then
        set FSC_Ok[ctx]=false
        return
    endif
    loop
        exitwhen i>=count or not FSC_Ok[ctx]
        set sid=FSC_Read(ctx)
        set flags=FSC_Read(ctx)
        set size=FSC_Read(ctx)
        if not FSC_Ok[ctx] or sid<=0 or flags>1 or size>outerEnd-FSC_Pos[ctx] then
            set FSC_Ok[ctx]=false
            return
        endif
        if not FSC_Mark(ctx,4,sid) then
            return
        endif
        set entryEnd=FSC_Pos[ctx]+size
        set FSC_End[ctx]=entryEnd
        if sid==1 then
            call FSC_Life(ctx)
            set life=true
        elseif sid==2 then
            set value=FSC_Read(ctx)
            set FSC_MetaFlags[ctx]=value
            if value>7 then
                set FSC_Ok[ctx]=false
            endif
            set itemFlags=true
        elseif flags==1 then
            set FSC_Ok[ctx]=false
        else
            set FSC_MetaDormant[ctx]=true
            set FSC_Opaque[ctx]=FSC_Opaque[ctx]+size
            set FSC_Pos[ctx]=entryEnd
        endif
        if FSC_Pos[ctx]!=entryEnd or FSC_Opaque[ctx]>FSC_MAX_OPAQUE then
            set FSC_Ok[ctx]=false
        endif
        set FSC_End[ctx]=outerEnd
        set i=i+1
    endloop
    if not life or not itemFlags then
        set FSC_MetadataComplete[ctx]=false
    endif
endfunction

function FSC_Inventory takes integer ctx returns nothing
    local integer count=FSC_Read(ctx)
    local integer i=0
    local integer size
    local integer ordinal
    local integer identity
    local integer holder
    local integer slot
    local integer flag
    local integer low
    local integer high
    local integer metaCount
    local integer outerEnd=FSC_End[ctx]
    local integer itemEnd
    local integer key
    local integer quantity
    local boolean bound
    call FlushChildHashtable(FSC_Seen,ctx*16+2)
    call FlushChildHashtable(FSC_Seen,ctx*16+3)
    if count>57 then
        set FSC_Ok[ctx]=false
        return
    endif
    loop
        exitwhen i>=count or not FSC_Ok[ctx]
        set size=FSC_Read(ctx)
        if not FSC_Ok[ctx] or size>outerEnd-FSC_Pos[ctx] then
            set FSC_Ok[ctx]=false
            return
        endif
        set itemEnd=FSC_Pos[ctx]+size
        set FSC_End[ctx]=itemEnd
        set ordinal=FSC_Read(ctx)
        set identity=FSC_Read(ctx)
        set holder=FSC_Read(ctx)
        set slot=FSC_Read(ctx)
        if not FSC_Ok[ctx] or ordinal<=0 or identity<=0 or slot>=FSC_HolderSize(holder) then
            set FSC_Ok[ctx]=false
            return
        endif
        if not FSC_Mark(ctx,2,ordinal) or not FSC_Mark(ctx,3,holder*32+slot) then
            return
        endif
        set quantity=-1
        set flag=FSC_Read(ctx)
        if flag==1 then
            if itemEnd-FSC_Pos[ctx]<2 then
                set FSC_Ok[ctx]=false
                return
            endif
            set low=FSC_Value(SubString(FSC_Text[ctx],FSC_Pos[ctx],FSC_Pos[ctx]+1))
            set high=FSC_Value(SubString(FSC_Text[ctx],FSC_Pos[ctx]+1,FSC_Pos[ctx]+2))
            set quantity=low+64*high
            set FSC_Pos[ctx]=FSC_Pos[ctx]+2
            if low<0 or high<0 or high>1 then
                set FSC_Ok[ctx]=false
            endif
        elseif flag!=0 then
            set FSC_Ok[ctx]=false
        endif
        set flag=FSC_Read(ctx)
        set bound=flag==1
        set metaCount=FSC_Read(ctx)
        if flag>1 then
            set FSC_Ok[ctx]=false
        endif
        call FSC_Metadata(ctx,metaCount)
        set key=ctx*57+i
        set FSC_ItemOrdinal[key]=ordinal
        set FSC_ItemId[key]=identity
        set FSC_ItemHolder[key]=holder
        set FSC_ItemSlot[key]=slot
        set FSC_ItemQuantity[key]=quantity
        set FSC_ItemBound[key]=bound
        set FSC_ItemHigh[key]=FSC_MetaHigh[ctx]
        set FSC_ItemLow[key]=FSC_MetaLow[ctx]
        set FSC_ItemFlags[key]=FSC_MetaFlags[ctx]
        set FSC_ItemDormant[key]=FSC_MetaDormant[ctx]
        set FSC_ItemComplete[key]=(FSC_MetaHigh[ctx]!=0 or FSC_MetaLow[ctx]!=0) and FSC_MetaFlags[ctx]>=0
        if FSC_Pos[ctx]!=itemEnd then
            set FSC_Ok[ctx]=false
        endif
        set FSC_End[ctx]=outerEnd
        set i=i+1
    endloop
    if FSC_Ok[ctx] then
        set FSC_ItemCount[ctx]=count
    endif
endfunction

function FSC_CoreMaximum takes integer identity returns integer
    if identity==1 then
        return 6
    elseif identity==2 or identity==3 then
        return 2147483647
    elseif identity==4 then
        return 100
    elseif identity==5 then
        return 10
    elseif identity==6 then
        return 3
    elseif identity==7 then
        return 7
    elseif identity==8 then
        return 15
    elseif identity>=9 and identity<=11 then
        return 1
    endif
    return -1
endfunction

function FSC_GayaMaximum takes integer identity returns integer
    if identity==2 then
        return 100
    elseif identity>=3 and identity<=5 then
        return 3
    elseif identity==1 or (identity>=6 and identity<=8) then
        return 1
    endif
    return -1
endfunction

function FSC_Pairs takes integer ctx,integer sid returns nothing
    local integer count=FSC_Read(ctx)
    local integer i=0
    local integer identity
    local integer value
    call FlushChildHashtable(FSC_Seen,ctx*16+1)
    if count>2048 or (sid==3 and count>256) then
        set FSC_Ok[ctx]=false
        return
    endif
    if sid==3 then
        set FSC_Dormant[ctx]=FSC_Dormant[ctx]+count
    endif
    loop
        exitwhen i>=count or not FSC_Ok[ctx]
        set identity=FSC_Read(ctx)
        set value=FSC_Read(ctx)
        if identity<=0 or not FSC_Ok[ctx] then
            set FSC_Ok[ctx]=false
            return
        endif
        if not FSC_Mark(ctx,1,identity) then
            return
        endif
        if sid==2 then
            if value>100 then
                set FSC_Ok[ctx]=false
            endif
            call SaveBoolean(FSC_Seen,ctx*16+8,identity,true)
        elseif sid==4 then
            if identity==11 then
                set FSC_Cheater[ctx]=value!=0
            endif
            if value>FSC_CoreMaximum(identity) then
                set FSC_Ok[ctx]=false
            endif
            call SaveBoolean(FSC_Seen,ctx*16+5,identity,true)
        elseif sid==5 then
            if value>FSC_GayaMaximum(identity) then
                set FSC_Ok[ctx]=false
            else
                set FSC_Gaya[ctx*16+identity]=value
            endif
            call SaveBoolean(FSC_Seen,ctx*16+6,identity,true)
        elseif sid==6 then
            if identity>15 or value>15 then
                set FSC_Ok[ctx]=false
            endif
            call SaveBoolean(FSC_Seen,ctx*16+7,identity,true)
        elseif (sid==7 or sid==8) and value!=1 then
            set FSC_Ok[ctx]=false
        endif
        set i=i+1
    endloop
endfunction

function FSC_EvidenceCharacter takes integer value returns boolean
    return (value>=65 and value<=90) or (value>=97 and value<=122) or (value>=48 and value<=57) or value==35 or value==36 or value==40 or value==41
endfunction

function FSC_Evidence takes integer ctx returns nothing
    local integer policy=FSC_Read(ctx)
    local integer speedrun=FSC_Read(ctx)
    local integer count=FSC_Read(ctx)
    local integer i=0
    local integer value
    if policy!=1 or speedrun>1 or count<8 or count>4096 then
        set FSC_Ok[ctx]=false
        return
    endif
    loop
        exitwhen i>=count or not FSC_Ok[ctx]
        set value=FSC_Read(ctx)
        if not FSC_EvidenceCharacter(value) or (i==0 and (value<69 or value>72)) then
            set FSC_Ok[ctx]=false
        endif
        set i=i+1
    endloop
endfunction

function FSC_ValidateSection takes integer ctx,integer sid,integer schemaVersion,boolean required,integer size returns nothing
    if schemaVersion!=1 or sid>9 then
        if required then
            set FSC_Ok[ctx]=false
        else
            set FSC_Opaque[ctx]=FSC_Opaque[ctx]+size
            set FSC_Pos[ctx]=FSC_End[ctx]
        endif
    elseif sid==1 then
        call FSC_Inventory(ctx)
    elseif sid==9 then
        call FSC_Evidence(ctx)
    else
        if sid==3 then
            if required then
                set FSC_Ok[ctx]=false
                return
            endif
            set FSC_Opaque[ctx]=FSC_Opaque[ctx]+size
        endif
        call FSC_Pairs(ctx,sid)
    endif
    if FSC_Pos[ctx]!=FSC_End[ctx] or FSC_Opaque[ctx]>FSC_MAX_OPAQUE or FSC_Dormant[ctx]>256 then
        set FSC_Ok[ctx]=false
    endif
endfunction

function FSC_Profile takes integer ctx returns boolean
    local integer i=1
    loop
        exitwhen i>9
        if i!=3 and (i!=9 or FSC_HasEvidence[ctx]) and FSC_Spec[ctx*16+i]!=1 then
            return false
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>11
        if (not FSC_HasEvidence[ctx] or i==1 or i==2 or i==4 or i==6 or i==7 or i==11) and not LoadBoolean(FSC_Seen,ctx*16+5,i) then
            return false
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>22
        if not LoadBoolean(FSC_Seen,ctx*16+8,i) then
            return false
        endif
        if i<=15 and not LoadBoolean(FSC_Seen,ctx*16+7,i) then
            return false
        endif
        if i<=8 and not LoadBoolean(FSC_Seen,ctx*16+6,i) then
            return false
        endif
        set i=i+1
    endloop
    if FSC_Gaya[ctx*16+1]==1 then
        if FSC_Gaya[ctx*16+2]!=99 then
            return false
        endif
        set i=3
        loop
            exitwhen i>8
            if FSC_Gaya[ctx*16+i]!=FSC_GayaMaximum(i) then
                return false
            endif
            set i=i+1
        endloop
    endif
    return FSC_HasEvidence[ctx] or FSC_MetadataComplete[ctx]
endfunction

function FSC_Parse takes integer ctx,string encoded,integer expectedAccount,boolean requireProfile returns boolean
    local integer account
    local integer size
    local integer count
    local integer stored
    local integer headerEnd
    local integer bodyStart
    local integer outerEnd
    local integer sid
    local integer schemaVersion
    local integer flags
    local integer sectionSize
    local integer sectionEnd
    local integer i=0
    local integer index
    if StringLength(encoded)>FSC_MAX_PAYLOAD+64 or not FSC_AlphabetValid(encoded) or SubString(encoded,0,3)!="FSV" then
        return false
    endif
    set FSC_Text[ctx]=encoded
    set FSC_Pos[ctx]=3
    set FSC_End[ctx]=StringLength(encoded)
    if FSC_Read(ctx)!=1 then
        return false
    endif
    set account=FSC_Read(ctx)
    set size=FSC_Read(ctx)
    set count=FSC_Read(ctx)
    set headerEnd=FSC_Pos[ctx]
    set stored=FSC_Read(ctx)
    set bodyStart=FSC_Pos[ctx]
    if not FSC_Ok[ctx] or account>=1048576 or (expectedAccount>=0 and account!=expectedAccount) or size>FSC_MAX_PAYLOAD or count<1 or count>32 or size!=FSC_End[ctx]-bodyStart then
        return false
    endif
    if FSC_Checksum(SubString(encoded,0,headerEnd)+SubString(encoded,bodyStart,StringLength(encoded)))!=stored then
        return false
    endif
    set FSC_Account[ctx]=account
    set FSC_Count[ctx]=count
    set outerEnd=FSC_End[ctx]
    loop
        exitwhen i>=count or not FSC_Ok[ctx]
        set sid=FSC_Read(ctx)
        set schemaVersion=FSC_Read(ctx)
        set flags=FSC_Read(ctx)
        set sectionSize=FSC_Read(ctx)
        if not FSC_Ok[ctx] or sid<=0 or schemaVersion<=0 or flags>1 or sectionSize>outerEnd-FSC_Pos[ctx] then
            return false
        endif
        if not FSC_Mark(ctx,0,sid) then
            return false
        endif
        set sectionEnd=FSC_Pos[ctx]+sectionSize
        set index=ctx*32+i
        set FSC_Id[index]=sid
        set FSC_Version[index]=schemaVersion
        set FSC_Required[index]=flags==1
        set FSC_Payload[index]=SubString(encoded,FSC_Pos[ctx],sectionEnd)
        if sid<=9 and schemaVersion==1 and flags==1 then
            set FSC_Spec[ctx*16+sid]=1
        endif
        if sid==9 then
            set FSC_HasEvidence[ctx]=true
        endif
        set FSC_End[ctx]=sectionEnd
        call FSC_ValidateSection(ctx,sid,schemaVersion,flags==1,sectionSize)
        set FSC_End[ctx]=outerEnd
        set i=i+1
    endloop
    return FSC_Ok[ctx] and FSC_Pos[ctx]==outerEnd and (not requireProfile or FSC_Profile(ctx))
endfunction

function FSC_Decode takes integer pid,string encoded,integer expectedAccount,boolean requireProfile returns boolean
    local integer stage=pid+9
    local integer active=pid+1
    local integer i=0
    local boolean valid
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSC_SessionBlocked[pid] or FSC_UnitBlocked[pid] or FSC_ReferenceBlocked[pid] or FSC_BodyBlocked[pid] or FSC_OwnershipBlocked[pid] or FSC_PreparedBlocked[pid] or FSC_ActivationBlocked[pid] or FSC_Busy[pid] or FSC_Writing[pid] or expectedAccount< -1 or expectedAccount>=1048576 then
        return false
    endif
    set FSC_Busy[pid]=true
    if FSC_Seen==null then
        set FSC_Seen=InitHashtable()
    endif
    call FSC_Clear(stage)
    call FSC_ClearSeen(stage)
    set valid=FSC_Parse(stage,encoded,expectedAccount,requireProfile)
    if valid then
        call FSC_Clear(active)
        set FSC_Account[active]=FSC_Account[stage]
        set FSC_Count[active]=FSC_Count[stage]
        loop
            exitwhen i>=FSC_Count[stage]
            set FSC_Id[active*32+i]=FSC_Id[stage*32+i]
            set FSC_Version[active*32+i]=FSC_Version[stage*32+i]
            set FSC_Required[active*32+i]=FSC_Required[stage*32+i]
            set FSC_Payload[active*32+i]=FSC_Payload[stage*32+i]
            set i=i+1
        endloop
        set FSC_Code[pid]=encoded
    endif
    call FSC_ClearSeen(stage)
    call FSC_Clear(stage)
    set FSC_Busy[pid]=false
    return valid
endfunction

function FSC_EncodeContext takes integer ctx returns string
    local integer i=0
    local integer index
    local string body=""
    local string header
    loop
        exitwhen i>=FSC_Count[ctx]
        set index=ctx*32+i
        set body=body+FSC_Uint(FSC_Id[index])+FSC_Uint(FSC_Version[index])
        if FSC_Required[index] then
            set body=body+"B"
        else
            set body=body+"A"
        endif
        set body=body+FSC_Uint(StringLength(FSC_Payload[index]))+FSC_Payload[index]
        set i=i+1
    endloop
    set header="FSVB"+FSC_Uint(FSC_Account[ctx])+FSC_Uint(StringLength(body))+FSC_Uint(FSC_Count[ctx])
    return header+FSC_Uint(FSC_Checksum(header+body))+body
endfunction

function FSC_Reencode takes integer pid returns string
    if not FSC_PlayerValid(pid) then
        return null
    endif
    if FSC_SessionBlocked[pid] or FSC_UnitBlocked[pid] or FSC_ReferenceBlocked[pid] or FSC_BodyBlocked[pid] or FSC_OwnershipBlocked[pid] or FSC_PreparedBlocked[pid] or FSC_ActivationBlocked[pid] or FSC_Count[pid+1]==0 or FSC_Busy[pid] then
        return null
    endif
    return FSC_EncodeContext(pid+1)
endfunction

function FSC_Begin takes integer pid,integer account returns boolean
    if not FSC_PlayerValid(pid) or account<0 or account>=1048576 then
        return false
    endif
    if FSC_SessionBlocked[pid] or FSC_UnitBlocked[pid] or FSC_ReferenceBlocked[pid] or FSC_BodyBlocked[pid] or FSC_OwnershipBlocked[pid] or FSC_PreparedBlocked[pid] or FSC_ActivationBlocked[pid] or FSC_Busy[pid] or FSC_Writing[pid] then
        return false
    endif
    call FSC_Clear(pid+17)
    set FSC_Account[pid+17]=account
    set FSC_BuildSize[pid]=0
    set FSC_BuildOk[pid]=true
    set FSC_Writing[pid]=true
    return true
endfunction

function FSC_Add takes integer pid,integer sid,integer schemaVersion,boolean required,string payload returns boolean
    local integer ctx=pid+17
    local integer index
    local integer size
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSC_SessionBlocked[pid] or FSC_UnitBlocked[pid] or FSC_ReferenceBlocked[pid] or FSC_BodyBlocked[pid] or FSC_OwnershipBlocked[pid] or FSC_PreparedBlocked[pid] or FSC_ActivationBlocked[pid] or not FSC_Writing[pid] or not FSC_BuildOk[pid] then
        return false
    endif
    if FSC_Count[ctx]>=32 or sid<=0 or schemaVersion<=0 or StringLength(payload)>FSC_MAX_PAYLOAD then
        set FSC_BuildOk[pid]=false
        return false
    endif
    set size=StringLength(FSC_Uint(sid))+StringLength(FSC_Uint(schemaVersion))+1+StringLength(FSC_Uint(StringLength(payload)))+StringLength(payload)
    if size>FSC_MAX_PAYLOAD-FSC_BuildSize[pid] or not FSC_AlphabetValid(payload) then
        set FSC_BuildOk[pid]=false
        return false
    endif
    set index=ctx*32+FSC_Count[ctx]
    set FSC_Id[index]=sid
    set FSC_Version[index]=schemaVersion
    set FSC_Required[index]=required
    set FSC_Payload[index]=payload
    set FSC_Count[ctx]=FSC_Count[ctx]+1
    set FSC_BuildSize[pid]=FSC_BuildSize[pid]+size
    return true
endfunction

function FSC_Abort takes integer pid returns nothing
    if not FSC_PlayerValid(pid) then
        return
    endif
    if not FSC_Busy[pid] then
        call FSC_Clear(pid+17)
        set FSC_Writing[pid]=false
        set FSC_BuildOk[pid]=false
        set FSC_BuildSize[pid]=0
    endif
endfunction

function FSC_Finish takes integer pid,boolean requireProfile returns string
    local integer ctx=pid+17
    local integer account
    local string encoded
    local boolean valid
    if not FSC_PlayerValid(pid) then
        return null
    endif
    if FSC_SessionBlocked[pid] or FSC_UnitBlocked[pid] or FSC_ReferenceBlocked[pid] or FSC_BodyBlocked[pid] or FSC_OwnershipBlocked[pid] or FSC_PreparedBlocked[pid] or FSC_ActivationBlocked[pid] or not FSC_Writing[pid] then
        return null
    endif
    if not FSC_BuildOk[pid] or FSC_Count[ctx]==0 then
        call FSC_Abort(pid)
        return null
    endif
    set account=FSC_Account[ctx]
    set encoded=FSC_EncodeContext(ctx)
    call FSC_Abort(pid)
    set valid=FSC_Decode(pid,encoded,account,requireProfile)
    if not valid then
        return null
    endif
    return encoded
endfunction

function FSC_Reset takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSC_SessionBlocked[pid] or FSC_UnitBlocked[pid] or FSC_ReferenceBlocked[pid] or FSC_BodyBlocked[pid] or FSC_OwnershipBlocked[pid] or FSC_PreparedBlocked[pid] or FSC_ActivationBlocked[pid] or FSC_Busy[pid] then
        return false
    endif
    call FSC_Abort(pid)
    call FSC_Clear(pid+1)
    call FSC_Clear(pid+9)
    set FSC_Code[pid]=null
    return true
endfunction
endlibrary

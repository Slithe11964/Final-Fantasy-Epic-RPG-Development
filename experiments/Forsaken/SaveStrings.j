// Included inside TForsakenSaveCodec by save_strings.lower_module.
// A virtual string stores fixed-size native fragments. No native fragment exceeds
// 960 characters, including intermediate concatenation results.
globals
    constant integer FSS_CHUNK=960
    // Allocate on every client before local file IO; never allocate handles locally.
    hashtable FSS_Store=InitHashtable()
    // Both handles are allocated synchronously; local IO never advances shared IDs.
    hashtable FSS_LocalStore=InitHashtable()
    hashtable FSS_Roots=InitHashtable()
    hashtable FSS_LocalRoots=InitHashtable()
    integer FSS_QueueHead=0
    integer FSS_QueueTail=0
    integer FSS_LocalQueueHead=0
    integer FSS_LocalQueueTail=0
    timer FSS_Collector=null
    integer FSS_Next=0
    integer FSS_LocalNext=0
    string FSS_ScanText=""
    integer FSS_ScanMode=0
    integer FSS_ScanA=1
    integer FSS_ScanB=0
    boolean FSS_ScanValid=false
    boolean FSS_ScanDone=false
endglobals

function FSS_Table takes string text returns hashtable
    if SubString(text,0,4)=="!FL:" then
        return FSS_LocalStore
    endif
    return FSS_Store
endfunction

function FSS_Id takes string text returns integer
    local integer id
    if SubString(text,0,4)!="!FS:" and SubString(text,0,4)!="!FL:" then
        return 0
    endif
    set id=S2I(SubString(text,4,StringLength(text)))
    if id<1 or LoadInteger(FSS_Table(text),id,0)<1 then
        return 0
    endif
    return id
endfunction

function FSS_Length takes string text returns integer
    local integer id=FSS_Id(text)
    if id>0 then
        return LoadInteger(FSS_Table(text),id,0)
    endif
    return StringLength(text)
endfunction

// Objects only contain native fragments, so roots need no recursive graph walk.
// Queue reclamation for a later timer turn; callers may still hold local aliases.
function FSS_Queue takes integer id,boolean privateText returns nothing
    local hashtable data=FSS_Store
    local integer tail=FSS_QueueTail
    if privateText then
        set data=FSS_LocalStore
        set tail=FSS_LocalQueueTail
    endif
    if LoadInteger(data,id,-3)!=0 then
        return
    endif
    call SaveInteger(data,id,-3,1)
    call SaveInteger(data,id,-2,0)
    if tail!=0 then
        call SaveInteger(data,tail,-2,id)
    endif
    if privateText then
        if FSS_LocalQueueHead==0 then
            set FSS_LocalQueueHead=id
        endif
        set FSS_LocalQueueTail=id
    else
        if FSS_QueueHead==0 then
            set FSS_QueueHead=id
        endif
        set FSS_QueueTail=id
    endif
endfunction

// Generated assignments pin persistent save strings. Private IO never touches shared roots.
function FSS_SetRoot takes string value,integer key,integer index,boolean privateText returns string
    local hashtable roots=FSS_Roots
    local hashtable data=FSS_Store
    local integer old
    local integer id=0
    if privateText then
        set roots=FSS_LocalRoots
        set data=FSS_LocalStore
        if SubString(value,0,4)=="!FL:" then
            set id=FSS_Id(value)
        endif
    elseif SubString(value,0,4)=="!FS:" then
        set id=FSS_Id(value)
    endif
    set old=LoadInteger(roots,key,index)
    if old!=id then
        if old>0 then
            call SaveInteger(data,old,-1,LoadInteger(data,old,-1)-1)
            call FSS_Queue(old,privateText)
        endif
        if id>0 then
            call SaveInteger(data,id,-1,LoadInteger(data,id,-1)+1)
        endif
        call SaveInteger(roots,key,index,id)
    endif
    return value
endfunction

function FSS_CollectArena takes boolean privateText returns nothing
    local hashtable data=FSS_Store
    local integer head=FSS_QueueHead
    local integer next
    local integer count=0
    if privateText then
        set data=FSS_LocalStore
        set head=FSS_LocalQueueHead
    endif
    loop
        exitwhen head==0 or count>=128
        set next=LoadInteger(data,head,-2)
        if LoadInteger(data,head,-1)==0 then
            call FlushChildHashtable(data,head)
        else
            call SaveInteger(data,head,-3,0)
            call SaveInteger(data,head,-2,0)
        endif
        set head=next
        set count=count+1
    endloop
    if privateText then
        set FSS_LocalQueueHead=head
        if head==0 then
            set FSS_LocalQueueTail=0
        endif
    else
        set FSS_QueueHead=head
        if head==0 then
            set FSS_QueueTail=0
        endif
    endif
endfunction

function FSS_Collect takes nothing returns nothing
    call FSS_CollectArena(false)
    call FSS_CollectArena(true)
endfunction

function FSS_InitCollector takes nothing returns nothing
    if FSS_Collector==null then
        set FSS_Collector=CreateTimer()
        call TimerStart(FSS_Collector,.25,true,function FSS_Collect)
    endif
endfunction

function FSS_NewLocal takes integer length returns string
    set FSS_LocalNext=FSS_LocalNext+1
    call SaveInteger(FSS_LocalStore,FSS_LocalNext,0,length)
    call FSS_Queue(FSS_LocalNext,true)
    return "!FL:"+I2S(FSS_LocalNext)
endfunction

function FSS_New takes integer length returns string
    set FSS_Next=FSS_Next+1
    call SaveInteger(FSS_Store,FSS_Next,0,length)
    call FSS_Queue(FSS_Next,false)
    return "!FS:"+I2S(FSS_Next)
endfunction

// The caller requests at most one native fragment, possibly across a boundary.
function FSS_Raw takes string text,integer first,integer last returns string
    local integer id=FSS_Id(text)
    local integer part
    local integer take
    local string result=""
    if id==0 then
        return SubString(text,first,last)
    endif
    loop
        exitwhen first>=last
        set part=first/FSS_CHUNK
        set take=(part+1)*FSS_CHUNK
        if take>last then
            set take=last
        endif
        set result=result+SubString(LoadStr(FSS_Table(text),id,part+1),first-part*FSS_CHUNK,take-part*FSS_CHUNK)
        set first=take
    endloop
    return result
endfunction

function FSS_SubString takes string text,integer first,integer last returns string
    local integer id=FSS_Id(text)
    local integer length
    local integer position=0
    local integer take
    local integer part
    local string result
    if first<0 then
        set first=0
    endif
    if id==0 then
        return SubString(text,first,last)
    endif
    set length=LoadInteger(FSS_Table(text),id,0)
    if last>length then
        set last=length
    endif
    if last<=first then
        return ""
    endif
    if last-first<=FSS_CHUNK then
        set part=first/FSS_CHUNK
        if last<=(part+1)*FSS_CHUNK then
            return SubString(LoadStr(FSS_Table(text),id,part+1),first-part*FSS_CHUNK,last-part*FSS_CHUNK)
        endif
        return FSS_Raw(text,first,last)
    endif
    if SubString(text,0,4)=="!FL:" then
        set result=FSS_NewLocal(last-first)
    else
        set result=FSS_New(last-first)
    endif
    set id=FSS_Id(result)
    loop
        exitwhen first>=last
        set take=first+FSS_CHUNK
        if take>last then
            set take=last
        endif
        call SaveStr(FSS_Table(result),id,position+1,FSS_Raw(text,first,take))
        set position=position+1
        set first=take
    endloop
    return result
endfunction

function FSS_ConcatMode takes string left,string right,boolean localText returns string
    local integer split=FSS_Length(left)
    local integer length=split+FSS_Length(right)
    local integer position=0
    local integer last
    local integer id
    local string fragment
    local string result
    if length<=FSS_CHUNK then
        return left+right
    endif
    if localText then
        set result=FSS_NewLocal(length)
    else
        set result=FSS_New(length)
    endif
    set id=FSS_Id(result)
    loop
        exitwhen position>=length
        set last=position+FSS_CHUNK
        if last>length then
            set last=length
        endif
        if last<=split then
            set fragment=FSS_Raw(left,position,last)
        elseif position>=split then
            set fragment=FSS_Raw(right,position-split,last-split)
        else
            set fragment=FSS_Raw(left,position,split)+FSS_Raw(right,0,last-split)
        endif
        call SaveStr(FSS_Table(result),id,position/FSS_CHUNK+1,fragment)
        set position=last
    endloop
    return result
endfunction

function FSS_Concat takes string left,string right returns string
    return FSS_ConcatMode(left,right,false)
endfunction

function FSS_LocalConcat takes string left,string right returns string
    return FSS_ConcatMode(left,right,true)
endfunction

function FSS_Equals takes string left,string right returns boolean
    local integer length
    local integer position=0
    if left==right then
        return true
    elseif FSS_Id(left)==0 and FSS_Id(right)==0 then
        return false
    endif
    set length=FSS_Length(left)
    if length!=FSS_Length(right) then
        return false
    endif
    loop
        exitwhen position>=length
        if FSS_SubString(left,position,position+FSS_CHUNK)!=FSS_SubString(right,position,position+FSS_CHUNK) then
            return false
        endif
        set position=position+FSS_CHUNK
    endloop
    return true
endfunction

// Only the legacy dispatcher needs a native whole code. Old preload files already
// return that whole native string; their checkpoint limitation is unchanged.
function FSS_LegacyText takes string text returns string
    local integer position=0
    local string result=""
    loop
        exitwhen position>=FSS_Length(text)
        set result=result+FSS_SubString(text,position,position+FSS_CHUNK)
        set position=position+FSS_CHUNK
    endloop
    return result
endfunction

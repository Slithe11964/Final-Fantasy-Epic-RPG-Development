// Included inside TForsakenSaveCodec by save_strings.lower_module.
// A virtual string stores fixed-size native fragments. No native fragment exceeds
// 960 characters, including intermediate concatenation results.
globals
    constant integer FSS_CHUNK=960
    // Allocate on every client before local file IO; never allocate handles locally.
    hashtable FSS_Store=InitHashtable()
    integer FSS_Next=0
    string FSS_ScanText=""
    integer FSS_ScanMode=0
    integer FSS_ScanA=1
    integer FSS_ScanB=0
    boolean FSS_ScanValid=false
    boolean FSS_ScanDone=false
endglobals

function FSS_Id takes string text returns integer
    local integer id
    if SubString(text,0,4)!="!FS:" then
        return 0
    endif
    set id=S2I(SubString(text,4,StringLength(text)))
    if id<1 or LoadInteger(FSS_Store,id,0)<1 then
        return 0
    endif
    return id
endfunction

function FSS_Length takes string text returns integer
    local integer id=FSS_Id(text)
    if id>0 then
        return LoadInteger(FSS_Store,id,0)
    endif
    return StringLength(text)
endfunction

function FSS_New takes integer length returns string
    set FSS_Next=FSS_Next+1
    call SaveInteger(FSS_Store,FSS_Next,0,length)
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
        set result=result+SubString(LoadStr(FSS_Store,id,part+1),first-part*FSS_CHUNK,take-part*FSS_CHUNK)
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
    set length=LoadInteger(FSS_Store,id,0)
    if last>length then
        set last=length
    endif
    if last<=first then
        return ""
    endif
    if last-first<=FSS_CHUNK then
        set part=first/FSS_CHUNK
        if last<=(part+1)*FSS_CHUNK then
            return SubString(LoadStr(FSS_Store,id,part+1),first-part*FSS_CHUNK,last-part*FSS_CHUNK)
        endif
        return FSS_Raw(text,first,last)
    endif
    set result=FSS_New(last-first)
    set id=FSS_Next
    loop
        exitwhen first>=last
        set take=first+FSS_CHUNK
        if take>last then
            set take=last
        endif
        call SaveStr(FSS_Store,id,position+1,FSS_Raw(text,first,take))
        set position=position+1
        set first=take
    endloop
    return result
endfunction

function FSS_Concat takes string left,string right returns string
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
    set result=FSS_New(length)
    set id=FSS_Next
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
        call SaveStr(FSS_Store,id,position/FSS_CHUNK+1,fragment)
        set position=last
    endloop
    return result
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

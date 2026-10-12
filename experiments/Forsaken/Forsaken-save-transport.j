library TForsakenSaveTransport requires TForsakenSaveCodec
// File IO remains local; only ordered sync packets reach detached validation.
globals
    constant string FST_PREFIX="FSCU"
    constant string FST_FILE=".\\FFERPG\\Forsaken CU.txt"
    constant integer FST_LIMIT=17000
    boolean array FST_AllowLegacy
    boolean array FST_Legacy
    string array FST_SavedCode
    string array FST_FileStem
    string array FST_FileError
    string array FST_FileBefore
    timer FST_Clock=null
    timer FST_PumpTimer=null
    trigger FST_Sync=null
    integer array FST_RequestId
    integer array FST_Account
    boolean array FST_Pending
    boolean array FST_Receiving
    boolean array FST_Ready
    string array FST_Buffer
    string array FST_Result
    string array FST_Error
    integer array FST_Length
    integer array FST_Check
    integer array FST_Sequence
    real array FST_Start
    integer array FST_SendMillis
    real array FST_ReceiveStart
    real array FST_TransferSeconds
    integer array FST_FileMillis
    // These arrays are read only inside the owning client's local branch.
    string array FST_LocalCode
    integer array FST_LocalPhase
    integer array FST_LocalSequence
    integer array FST_LocalMillis
endglobals

function FST_Digits takes string text returns integer
    local integer position=0
    local integer digit
    local integer value=0
    loop
        exitwhen position>=StringLength(text)
        set digit=0
        loop
            exitwhen digit>=10 or SubString("0123456789",digit,digit+1)==SubString(text,position,position+1)
            set digit=digit+1
        endloop
        if digit>=10 or value>214748364 or (value==214748364 and digit>7) then
            return -1
        endif
        set value=value*10+digit
        set position=position+1
    endloop
    if position==0 then
        return -1
    endif
    return value
endfunction

function FST_Fixed takes integer value,integer width returns string
    local string text=I2S(value)
    if value<0 or StringLength(text)>width then
        return null
    endif
    loop
        exitwhen StringLength(text)>=width
        set text="0"+text
    endloop
    return text
endfunction

function FST_Fail takes integer pid,string reason returns nothing
    set FST_Error[pid]=reason
    set FST_Pending[pid]=false
    set FST_Receiving[pid]=false
    set FST_Legacy[pid]=false
    set FST_Ready[pid]=false
    set FST_Buffer[pid]=null
    set FST_Result[pid]=null
endfunction

function FST_FilePath takes integer page returns string
    if page==0 then
        return FST_FILE
    endif
    return ".\\FFERPG\\Forsaken CU part "+I2S(page)+".txt"
endfunction

function FST_SetFileStem takes integer pid,string stem returns boolean
    local integer i=0
    local integer j
    local string allowed="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 _-"
    local string character
    if StringLength(stem)<1 or StringLength(stem)>64 then
        return false
    endif
    loop
        exitwhen i>=StringLength(stem)
        set character=SubString(stem,i,i+1)
        set j=0
        loop
            exitwhen j>=StringLength(allowed) or SubString(allowed,j,j+1)==character
            set j=j+1
        endloop
        if j>=StringLength(allowed) then
            return false
        endif
        set i=i+1
    endloop
    set FST_FileStem[pid]=stem
    return true
endfunction

function FST_PlayerPath takes integer pid,integer page returns string
    if FST_FileStem[pid]==null or FST_FileStem[pid]=="" then
        return FST_FilePath(page)
    endif
    if page==0 then
        return ".\\FFERPG\\"+FST_FileStem[pid]+".txt"
    endif
    return ".\\FFERPG\\"+FST_FileStem[pid]+" part "+I2S(page)+".txt"
endfunction

function FST_TextChecksum takes string text returns integer
    local integer a=1
    local integer b=0
    local integer i=0
    local integer digit
    loop
        exitwhen i>=StringLength(text)
        if SubString(text,i,i+1)=="(" then
            set digit=64
        elseif SubString(text,i,i+1)==")" then
            set digit=65
        else
            set digit=FSC_Value(SubString(text,i,i+1))
        endif
        if digit<0 then
            return -1
        endif
        set a=ModuloInteger(a+digit+1,32749)
        set b=ModuloInteger(b+a,32749)
        set i=i+1
    endloop
    return b*32768+a
endfunction

function FST_LegacyValid takes string encoded returns boolean
    local integer i=0
    local string ch
    if encoded==null or StringLength(encoded)<11 or StringLength(encoded)>FST_LIMIT or (SubString(encoded,0,1)!="E" and SubString(encoded,0,1)!="F" and SubString(encoded,0,1)!="G" and SubString(encoded,0,1)!="H") then
        return false
    endif
    loop
        exitwhen i>=StringLength(encoded)
        set ch=SubString(encoded,i,i+1)
        if ch!="(" and ch!=")" and not FSC_AlphabetValid(ch) then
            return false
        endif
        set i=i+1
    endloop
    return true
endfunction

function FST_ColorCode takes string text returns string
    local integer i=0
    local integer value
    local string color
    local string previous=""
    local string result=""
    loop
        exitwhen i>=StringLength(text)
        set value=FSC_Value(SubString(text,i,i+1))
        if value<26 then
            set color="|c00C8C8C8"
        elseif value<52 then
            set color="|c00E6E700"
        elseif value<62 then
            set color="|c000068DE"
        else
            set color="|c0016D116"
        endif
        // Change color only when the character category changes; keep native text bounded.
        if color!=previous then
            set result=result+color
            set previous=color
        endif
        set result=result+SubString(text,i,i+1)
        set i=i+1
    endloop
    return result+"|r"
endfunction

function FST_ShowCode takes integer pid,integer page returns boolean
    local string encoded=FST_SavedCode[pid]
    local integer total=(StringLength(encoded)+79)/80
    local integer pages=(total+2)/3
    local integer part=(page-1)*3
    local integer last=part+3
    if encoded==null or page<1 or page>pages then
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save code: use -save first, then -savepage NUMBER for an available page.")
        return false
    endif
    if GetLocalPlayer()==Player(pid) then
        call ClearTextMessages()
    endif
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,120.,"|cFFFFCC00SAVE CODE - PAGE "+I2S(page)+" OF "+I2S(pages)+"|r")
    loop
        exitwhen part>=total or part>=last
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,120.,"-load FSVB:"+I2S(FST_TextChecksum(encoded))+":"+I2S(part+1)+":"+I2S(total)+":"+FST_ColorCode(SubString(encoded,part*80,(part+1)*80)))
        set part=part+1
    endloop
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,120.,"|cFFFFCC00SCREENSHOT PAGE "+I2S(page)+" OF "+I2S(pages)+" - Capture ALL "+I2S(pages)+" pages.|r")
    if page<pages then
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,120.,"Next: -savepage "+I2S(page+1)+". Paste all numbered -load lines in a fresh game.")
    else
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,120.,"FINAL PAGE. Review: -savepage NUMBER. Paste all numbered -load lines in a fresh game.")
    endif
    return true
endfunction

// Local player names are temporary chunk fields; no native reads inside the file.
function FST_ReadFile takes integer pid returns string
    local integer slot=0
    local integer page=0
    local integer pages=1
    local integer size=0
    local integer check=0
    local integer wanted
    local string marker
    local string value
    local string result=""
    local boolean legacy=false
    set FST_FileError[pid]=""
    loop
        exitwhen slot>=24
        set FST_FileBefore[slot]=GetPlayerName(Player(slot))
        set slot=slot+1
    endloop
    loop
        exitwhen page>=pages or FST_FileError[pid]!=""
        set slot=0
        loop
            exitwhen slot>=24
            call SetPlayerName(Player(slot),"FSCU_UNREAD")
            set slot=slot+1
        endloop
        call Preloader(FST_PlayerPath(pid,page))
        set marker=GetPlayerName(Player(23))
        if page==0 and marker=="FSCU_UNREAD" and FST_AllowLegacy[pid] and GetPlayerName(Player(pid))!="FSCU_UNREAD" then
            set result=GetPlayerName(Player(pid))
            set legacy=true
            set size=StringLength(result)
        elseif StringLength(marker)!=21 or SubString(marker,0,4)!="FSC1" then
            set FST_FileError[pid]="page "+I2S(page)+" header was not returned"
        else
            if page==0 then
                set size=FST_Digits(SubString(marker,4,9))
                set check=FST_Digits(SubString(marker,9,19))
                set pages=FST_Digits(SubString(marker,20,21))
            endif
            if size<4 or size>FST_LIMIT or check<0 or pages!=(size+3679)/3680 or FST_Digits(SubString(marker,19,20))!=page or FST_Digits(SubString(marker,4,9))!=size or FST_Digits(SubString(marker,9,19))!=check or FST_Digits(SubString(marker,20,21))!=pages then
                set FST_FileError[pid]="page "+I2S(page)+" header mismatch"
            endif
        endif
        set slot=0
        loop
            exitwhen slot>=23 or FST_FileError[pid]!="" or StringLength(result)>=size
            set value=GetPlayerName(Player(slot))
            set wanted=size-StringLength(result)
            if wanted>160 then
                set wanted=160
            endif
            if StringLength(value)!=wanted or not FSC_AlphabetValid(value) then
                set FST_FileError[pid]="page "+I2S(page)+" chunk "+I2S(slot)+" expected "+I2S(wanted)+" received "+I2S(StringLength(value))
            else
                set result=result+value
            endif
            set slot=slot+1
        endloop
        set page=page+1
    endloop
    set slot=0
    loop
        exitwhen slot>=24
        call SetPlayerName(Player(slot),FST_FileBefore[slot])
        set FST_FileBefore[slot]=null
        set slot=slot+1
    endloop
    if FST_FileError[pid]!="" then
        return null
    endif
    if legacy then
        if not FST_LegacyValid(result) then
            set FST_FileError[pid]="legacy file returned invalid code text"
            return null
        endif
        return result
    endif
    if StringLength(result)!=size or FST_TextChecksum(result)!=check then
        set FST_FileError[pid]="assembled length or checksum mismatch"
        return null
    endif
    return result
endfunction

// Called only from synchronized controller input after checking its load eligibility.
function FST_Request takes integer pid,integer account returns boolean
    local string before
    local string encoded
    local real started
    if not FSC_PlayerValid(pid) or FST_Pending[pid] or FST_Clock==null or FST_RequestId[pid]>=999999 then
        return false
    endif
    set FST_RequestId[pid]=FST_RequestId[pid]+1
    set FST_Account[pid]=account
    set FST_Pending[pid]=true
    set FST_Receiving[pid]=false
    set FST_Ready[pid]=false
    set FST_Error[pid]=""
    set FST_Result[pid]=null
    set FST_Buffer[pid]=""
    set FST_Start[pid]=TimerGetElapsed(FST_Clock)
    if GetLocalPlayer()==Player(pid) then
        set before=GetPlayerName(Player(pid))
        set started=TimerGetElapsed(FST_Clock)
        set encoded=FST_ReadFile(pid)
        call SetPlayerName(Player(pid),before)
        set FST_LocalMillis[pid]=R2I((TimerGetElapsed(FST_Clock)-started)*1000.)
        if encoded==null or StringLength(encoded)<4 or StringLength(encoded)>FST_LIMIT or (not (SubString(encoded,0,4)=="FSVB" and FSC_AlphabetValid(encoded)) and not (FST_AllowLegacy[pid] and FST_LegacyValid(encoded))) then
            set FST_LocalCode[pid]=null
            set FST_LocalPhase[pid]=4
        else
            set FST_LocalCode[pid]=encoded
            set FST_LocalPhase[pid]=1
            set FST_LocalSequence[pid]=0
        endif
    endif
    return true
endfunction

// Accepts only the currently requested sender's complete, ordered envelope.
function FST_Receive takes integer pid,string packet returns nothing
    local string kind
    local integer request
    local integer sequence
    local integer size
    local string chunk
    if not FSC_PlayerValid(pid) or not FST_Pending[pid] or packet==null or StringLength(packet)<7 then
        return
    endif
    set request=FST_Digits(SubString(packet,1,7))
    if request!=FST_RequestId[pid] then
        return
    endif
    set kind=SubString(packet,0,1)
    if kind=="B" or kind=="L" then
        set FST_Legacy[pid]=kind=="L"
        if FST_Legacy[pid] and not FST_AllowLegacy[pid] then
            call FST_Fail(pid,"legacy import was not requested")
            return
        endif
        if FST_Receiving[pid] or StringLength(packet)!=37 then
            call FST_Fail(pid,"duplicate or malformed file header")
            return
        endif
        set size=FST_Digits(SubString(packet,7,12))
        set FST_Check[pid]=FST_Digits(SubString(packet,12,22))
        set FST_FileMillis[pid]=FST_Digits(SubString(packet,22,28))
        set FST_SendMillis[pid]=FST_Digits(SubString(packet,28,37))
        if size<4 or size>FST_LIMIT or FST_Check[pid]<0 or FST_FileMillis[pid]<0 or FST_SendMillis[pid]<0 or FST_SendMillis[pid]>R2I(TimerGetElapsed(FST_Clock)*1000.)+1 then
            call FST_Fail(pid,"invalid file length or checksum header")
            return
        endif
        set FST_Length[pid]=size
        set FST_Sequence[pid]=0
        set FST_Buffer[pid]=""
        set FST_ReceiveStart[pid]=TimerGetElapsed(FST_Clock)
        set FST_Receiving[pid]=true
    elseif kind=="D" then
        set sequence=FST_Digits(SubString(packet,7,10))
        set chunk=SubString(packet,10,StringLength(packet))
        set size=FST_Length[pid]-StringLength(FST_Buffer[pid])
        if size>192 then
            set size=192
        endif
        if not FST_Receiving[pid] or sequence!=FST_Sequence[pid] or size<=0 or StringLength(chunk)!=size or (not FST_Legacy[pid] and not FSC_AlphabetValid(chunk)) then
            call FST_Fail(pid,"missing, repeated or invalid encoded chunk")
            return
        endif
        set FST_Buffer[pid]=FST_Buffer[pid]+chunk
        set FST_Sequence[pid]=sequence+1
    elseif kind=="E" then
        if StringLength(packet)!=7 or not FST_Receiving[pid] or StringLength(FST_Buffer[pid])!=FST_Length[pid] or FST_TextChecksum(FST_Buffer[pid])!=FST_Check[pid] then
            call FST_Fail(pid,"incomplete or corrupted file transfer")
            return
        endif
        if (FST_Legacy[pid] and not FST_LegacyValid(FST_Buffer[pid])) or (not FST_Legacy[pid] and not FSC_Decode(pid,FST_Buffer[pid],FST_Account[pid],true)) then
            call FST_Fail(pid,"file profile failed validation")
            return
        endif
        set FST_Result[pid]=FST_Buffer[pid]
        set FST_Buffer[pid]=null
        set FST_TransferSeconds[pid]=TimerGetElapsed(FST_Clock)-I2R(FST_SendMillis[pid])/1000.
        set FST_Pending[pid]=false
        set FST_Receiving[pid]=false
        set FST_Ready[pid]=true
    elseif kind=="X" then
        call FST_Fail(pid,"file missing, unreadable or invalid; no character changed")
    else
        call FST_Fail(pid,"unknown file transfer packet")
    endif
endfunction

function FST_OnSync takes nothing returns nothing
    call FST_Receive(GetPlayerId(GetTriggerPlayer()),BlzGetTriggerSyncData())
endfunction

function FST_Pump takes nothing returns nothing
    local integer pid=0
    local integer sequence
    local string packet
    local string request
    loop
        exitwhen pid>=8
        if FST_Pending[pid] then
            if TimerGetElapsed(FST_Clock)-FST_Start[pid]>45. then
                call FST_Fail(pid,"file transfer timed out; retry while load window is open")
            elseif GetLocalPlayer()==Player(pid) then
                set request=FST_Fixed(FST_RequestId[pid],6)
                set packet=null
                if FST_LocalPhase[pid]==1 then
                    set packet="B"
                    if SubString(FST_LocalCode[pid],0,4)!="FSVB" then
                        set packet="L"
                    endif
                    set packet=packet+request+FST_Fixed(StringLength(FST_LocalCode[pid]),5)+FST_Fixed(FST_TextChecksum(FST_LocalCode[pid]),10)+FST_Fixed(FST_LocalMillis[pid],6)+FST_Fixed(R2I(TimerGetElapsed(FST_Clock)*1000.),9)
                    set FST_LocalPhase[pid]=2
                elseif FST_LocalPhase[pid]==2 then
                    set sequence=FST_LocalSequence[pid]
                    if sequence*192>=StringLength(FST_LocalCode[pid]) then
                        set packet="E"+request
                        set FST_LocalPhase[pid]=0
                    else
                        set packet="D"+request+FST_Fixed(sequence,3)+SubString(FST_LocalCode[pid],sequence*192,(sequence+1)*192)
                        set FST_LocalSequence[pid]=sequence+1
                    endif
                elseif FST_LocalPhase[pid]==4 then
                    set packet="X"+request
                    set FST_LocalPhase[pid]=0
                endif
                if packet!=null and not BlzSendSyncData(FST_PREFIX,packet) then
                    // Report failure through sync on the next tick, or time out.
                    set FST_LocalPhase[pid]=4
                endif
            endif
        endif
        set pid=pid+1
    endloop
endfunction

function FST_Write takes integer pid,string encoded,integer account returns boolean
    local integer position=0
    local integer page=0
    local integer pages
    local integer slot
    local string marker
    local string before
    local string readback
    if not FSC_PlayerValid(pid) or FST_Pending[pid] or encoded==null or StringLength(encoded)>FST_LIMIT or not FSC_Decode(pid,encoded,account,true) then
        return false
    endif
    if GetLocalPlayer()==Player(pid) then
        set pages=(StringLength(encoded)+3679)/3680
        loop
            exitwhen page>=pages
            call PreloadGenClear()
            call PreloadGenStart()
            set slot=0
            loop
                exitwhen slot>=23 or position>=StringLength(encoded)
                call Preload("\")\r\n\tcall SetPlayerName(Player("+I2S(slot)+"), \""+SubString(encoded,position,position+160)+"\")\r\n\t//")
                set position=position+160
                set slot=slot+1
            endloop
            set marker="FSC1"+FST_Fixed(StringLength(encoded),5)+FST_Fixed(FST_TextChecksum(encoded),10)+FST_Fixed(page,1)+FST_Fixed(pages,1)
            call Preload("\")\r\n\tcall SetPlayerName(Player(23), \""+marker+"\")\r\n\treturn\r\n\t//")
            call PreloadGenEnd(FST_PlayerPath(pid,page))
            set page=page+1
        endloop
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save prototype: file written; checking exact readback.")
        set before=GetPlayerName(Player(pid))
        set readback=FST_ReadFile(pid)
        call SetPlayerName(Player(pid),before)
        if readback==encoded then
            call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save prototype: file written and read back exactly ("+I2S(StringLength(encoded))+" characters). File: "+FST_PlayerPath(pid,0))
        elseif readback==null or readback=="" then
            call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save prototype: file readback failed: "+FST_FileError[pid]+"; expected "+I2S(StringLength(encoded))+" characters. Export unverified.")
        else
            call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save prototype: file readback failed: expected "+I2S(StringLength(encoded))+" characters, received "+I2S(StringLength(readback))+"; prefix ["+SubString(readback,0,4)+"]. Export unverified.")
        endif
    endif
    // Synchronized return means validated export attempted, not local readback success.
    return true
endfunction

function FST_Init takes nothing returns nothing
    local integer pid=0
    if FST_Clock!=null then
        return
    endif
    // Allocate the lookup synchronously before any local file read.
    call FSC_InitCharacters()
    set FST_Clock=CreateTimer()
    call TimerStart(FST_Clock,86400.,false,null)
    set FST_PumpTimer=CreateTimer()
    call TimerStart(FST_PumpTimer,0.05,true,function FST_Pump)
    set FST_Sync=CreateTrigger()
    loop
        exitwhen pid>=8
        call BlzTriggerRegisterPlayerSyncEvent(FST_Sync,Player(pid),FST_PREFIX,false)
        set pid=pid+1
    endloop
    call TriggerAddAction(FST_Sync,function FST_OnSync)
endfunction
endlibrary

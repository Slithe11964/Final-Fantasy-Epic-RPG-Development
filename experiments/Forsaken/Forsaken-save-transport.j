library TForsakenSaveTransport requires TForsakenSaveCodec
// File IO remains local; only ordered sync packets reach detached validation.
globals
    constant string FST_PREFIX="FSCU"
    constant string FST_FILE=".\\FFERPG\\Forsaken CU.txt"
    constant integer FST_LIMIT=17000
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
    set FST_Ready[pid]=false
    set FST_Buffer[pid]=null
    set FST_Result[pid]=null
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
        call SetPlayerName(Player(pid),"")
        call Preloader(FST_FILE)
        set encoded=GetPlayerName(Player(pid))
        call SetPlayerName(Player(pid),before)
        set FST_LocalMillis[pid]=R2I((TimerGetElapsed(FST_Clock)-started)*1000.)
        if encoded==null or StringLength(encoded)<4 or StringLength(encoded)>FST_LIMIT or SubString(encoded,0,4)!="FSVB" or not FSC_AlphabetValid(encoded) then
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
    if kind=="B" then
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
        if not FST_Receiving[pid] or sequence!=FST_Sequence[pid] or size<=0 or StringLength(chunk)!=size or not FSC_AlphabetValid(chunk) then
            call FST_Fail(pid,"missing, repeated or invalid encoded chunk")
            return
        endif
        set FST_Buffer[pid]=FST_Buffer[pid]+chunk
        set FST_Sequence[pid]=sequence+1
    elseif kind=="E" then
        if StringLength(packet)!=7 or not FST_Receiving[pid] or StringLength(FST_Buffer[pid])!=FST_Length[pid] or FSC_Checksum(FST_Buffer[pid])!=FST_Check[pid] then
            call FST_Fail(pid,"incomplete or corrupted file transfer")
            return
        endif
        if not FSC_Decode(pid,FST_Buffer[pid],FST_Account[pid],true) then
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
                    set packet="B"+request+FST_Fixed(StringLength(FST_LocalCode[pid]),5)+FST_Fixed(FSC_Checksum(FST_LocalCode[pid]),10)+FST_Fixed(FST_LocalMillis[pid],6)+FST_Fixed(R2I(TimerGetElapsed(FST_Clock)*1000.),9)
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
    local string before
    local string readback
    if not FSC_PlayerValid(pid) or FST_Pending[pid] or encoded==null or StringLength(encoded)>FST_LIMIT or not FSC_Decode(pid,encoded,account,true) then
        return false
    endif
    if GetLocalPlayer()==Player(pid) then
        call PreloadGenClear()
        call PreloadGenStart()
        loop
            exitwhen position>=StringLength(encoded)
            call Preload("\")\r\n\tcall SetPlayerName(GetLocalPlayer(), GetPlayerName(GetLocalPlayer())+\""+SubString(encoded,position,position+128)+"\")\r\n\t//")
            set position=position+128
        endloop
        call Preload("\")\r\n\treturn\r\n\t//")
        call PreloadGenEnd(FST_FILE)
        set before=GetPlayerName(Player(pid))
        call SetPlayerName(Player(pid),"")
        call Preloader(FST_FILE)
        set readback=GetPlayerName(Player(pid))
        call SetPlayerName(Player(pid),before)
        if readback==encoded then
            call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save prototype: file written and read back exactly ("+I2S(StringLength(encoded))+" characters).")
        else
            call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Save prototype: file readback failed; do not treat this export as verified.")
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

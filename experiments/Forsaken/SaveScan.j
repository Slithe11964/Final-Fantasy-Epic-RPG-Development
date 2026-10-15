// Included after FSC_Value. Each child thread scans at most 128 native characters.
// ExecuteFunc gives the child a fresh execution budget without allocating handles.
function FSS_ScanChunk takes nothing returns nothing
    local integer i=0
    local integer digit
    local string letter
    loop
        exitwhen i>=StringLength(FSS_ScanText)
        set letter=SubString(FSS_ScanText,i,i+1)
        if FSS_ScanMode==2 and letter=="(" then
            set digit=64
        elseif FSS_ScanMode==2 and letter==")" then
            set digit=65
        else
            set digit=FSC_Value(letter)
        endif
        if digit<0 then
            set FSS_ScanValid=false
            set FSS_ScanDone=true
            return
        endif
        if FSS_ScanMode>0 then
            set FSS_ScanA=ModuloInteger(FSS_ScanA+digit+1,32749)
            set FSS_ScanB=ModuloInteger(FSS_ScanB+FSS_ScanA,32749)
        endif
        set i=i+1
    endloop
    set FSS_ScanDone=true
endfunction

// Mode 0 validates the alphabet; 1 is the FSVB checksum; 2 includes legacy brackets.
function FSS_Scan takes string text,integer mode returns integer
    local integer length=FSS_Length(text)
    local integer position=0
    set FSS_ScanMode=mode
    set FSS_ScanA=1
    set FSS_ScanB=0
    set FSS_ScanValid=true
    loop
        exitwhen position>=length
        set FSS_ScanText=FSS_SubString(text,position,position+128)
        set FSS_ScanDone=false
        call ExecuteFunc("FSS_ScanChunk")
        if not FSS_ScanDone or not FSS_ScanValid then
            return -1
        endif
        set position=position+128
    endloop
    set FSS_ScanText=""
    if mode==0 then
        return 1
    endif
    return FSS_ScanB*32768+FSS_ScanA
endfunction

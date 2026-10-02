library TCode requires TCmd, TSave
function Code_Create takes nothing returns boolean
    local integer v=udg_ArgInt
    local player p=udg_ArgPlayer
    local integer sl=Save_AllocBuffer()
    set udg_SavePlayer[sl]=p
    set udg_SaveVersion[sl]=v
    // (13) times (v).
    set udg_CodeKey[sl]=$D*v // $D = 13
    set udg_RetInt=sl
    return true
endfunction

function Code_FreeSlot takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local integer l_slot
    set udg_SaveSlotFreeCount=udg_SaveSlotFreeCount+1
    set l_slot=udg_CodeSlot[l_idx]
    set udg_CodeSlotStack[udg_SaveSlotFreeCount]=l_slot
    return true
endfunction

function Code_WriteInt takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local integer l_val=udg_ArgInt
    local integer l_bits=udg_ArgBits
    // Starting value for l_mixed:
    // (udg_CodeKey at position l_idx) plus (l_val).
    local integer l_mixed=udg_CodeKey[l_idx]+l_val
    local integer l_chunk
    local string l_color
    if l_bits<=9 then
        set udg_CodeFormat[l_idx]=udg_CodeFormat[l_idx]+I2S(l_bits)
    else
        // Calculation 1:
        // (l_bits) minus (10).
        // Calculation 2:
        // (l_bits) minus (9).
        set udg_CodeFormat[l_idx]=udg_CodeFormat[l_idx]+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_bits-$A,l_bits-9) // $A = 10
    endif
    // Increase udg_CodeKey at position l_idx by 211.
    set udg_CodeKey[l_idx]=udg_CodeKey[l_idx]+$D3 // $D3 = 211
    // Result 1: (l_mixed) divided by (udg_Pow2 at position l_bits); drop the remainder.
    // Result 2: (result 1) times (udg_Pow2 at position l_bits).
    // Result 3: (l_mixed) minus (result 2).
    set l_mixed=l_mixed-(l_mixed/ udg_Pow2[l_bits])*udg_Pow2[l_bits]
    // ((udg_CodeBuffer at position l_idx) times (udg_Pow2 at position l_bits)) plus (l_mixed).
    set udg_CodeBuffer[l_idx]=udg_CodeBuffer[l_idx]*udg_Pow2[l_bits]+l_mixed
    // (udg_CodeBits at position l_idx) plus (l_bits).
    set udg_CodeBits[l_idx]=udg_CodeBits[l_idx]+l_bits
    loop
        exitwhen udg_CodeBits[l_idx]<6
        // Decrease udg_CodeBits at position l_idx by 6.
        set udg_CodeBits[l_idx]=udg_CodeBits[l_idx]-6
        // Result 1: (udg_CodeBuffer at position l_idx) divided by (udg_Pow2 at position udg_CodeBits at position
        // l_idx); drop the remainder.
        set l_chunk=udg_CodeBuffer[l_idx]/ udg_Pow2[udg_CodeBits[l_idx]]
        // (udg_CodeBuffer at position l_idx) minus ((l_chunk) times (udg_Pow2 at position udg_CodeBits at position
        // l_idx)).
        set udg_CodeBuffer[l_idx]=udg_CodeBuffer[l_idx]-l_chunk*udg_Pow2[udg_CodeBits[l_idx]]
        if l_chunk<26 then
            set l_color="|c00C8C8C8"
        elseif l_chunk<52 then
            set l_color="|c00E6E700"
        elseif l_chunk<62 then
            set l_color="|c000068DE"
        else
            set l_color="|c0016D116"
        endif
        // Calculation 1:
        // (udg_SaveChunkBase at position l_idx) plus (udg_SaveChunkIndex at position l_idx).
        // Calculation 2:
        // (udg_SaveChunkBase at position l_idx) plus (udg_SaveChunkIndex at position l_idx).
        // Calculation 3:
        // (l_chunk) plus (1).
        set udg_SaveCodeChunk[udg_SaveChunkBase[l_idx]+udg_SaveChunkIndex[l_idx]]=udg_SaveCodeChunk[udg_SaveChunkBase[l_idx]+udg_SaveChunkIndex[l_idx]]+l_color+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_chunk,l_chunk+1)+"|r"
        // (udg_SaveChunkBase at position l_idx) plus (udg_SaveChunkIndex at position l_idx).
        if(StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_idx]+udg_SaveChunkIndex[l_idx]])>=$3E8)then // $3E8 = 1000
            set udg_SaveChunkIndex[l_idx]=udg_SaveChunkIndex[l_idx]+1
            // (udg_SaveChunkBase at position l_idx) plus (udg_SaveChunkIndex at position l_idx).
            set udg_SaveCodeChunk[udg_SaveChunkBase[l_idx]+udg_SaveChunkIndex[l_idx]]=""
        endif
        // (l_chunk) plus (1).
        set udg_SaveCodePlain[l_idx]=udg_SaveCodePlain[l_idx]+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_chunk,l_chunk+1)
    endloop
    return true
endfunction

function Code_ReadInt takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local integer l_bits=udg_ArgInt
    local integer l_val
    local integer i=0
    if l_bits<=9 then
        set udg_CodeFormatRead[l_idx]=udg_CodeFormatRead[l_idx]+I2S(l_bits)
    else
        // Calculation 1:
        // (l_bits) minus (10).
        // Calculation 2:
        // (l_bits) minus (9).
        set udg_CodeFormatRead[l_idx]=udg_CodeFormatRead[l_idx]+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_bits-$A,l_bits-9) // $A = 10
    endif
    loop
        exitwhen udg_CodeBits[l_idx]>=l_bits
        // Result 1: (udg_CodeBuffer at position l_idx) times (64).
        // Result 2: (udg_CodeReadPos at position l_idx) plus (1).
        // Result 3: (result 1) plus (Trig_Cmd_Load_Code_CharToValue(SubString(udg_SaveCodePlain at position l_idx,
        // udg_CodeReadPos at position l_idx, result 2))).
        set udg_CodeBuffer[l_idx]=udg_CodeBuffer[l_idx]*64+Trig_Cmd_Load_Code_CharToValue(SubString(udg_SaveCodePlain[l_idx],udg_CodeReadPos[l_idx],udg_CodeReadPos[l_idx]+1))
        set udg_CodeReadPos[l_idx]=udg_CodeReadPos[l_idx]+1
        // Increase udg_CodeBits at position l_idx by 6.
        set udg_CodeBits[l_idx]=udg_CodeBits[l_idx]+6
    endloop
    // (udg_CodeBits at position l_idx) minus (l_bits).
    set udg_CodeBits[l_idx]=udg_CodeBits[l_idx]-l_bits
    // Result 1: (udg_CodeBuffer at position l_idx) divided by (udg_Pow2 at position udg_CodeBits at position
    // l_idx); drop the remainder.
    set l_val=udg_CodeBuffer[l_idx]/ udg_Pow2[udg_CodeBits[l_idx]]
    // (udg_CodeBuffer at position l_idx) minus ((l_val) times (udg_Pow2 at position udg_CodeBits at position
    // l_idx)).
    set udg_CodeBuffer[l_idx]=udg_CodeBuffer[l_idx]-l_val*udg_Pow2[udg_CodeBits[l_idx]]
    // Result 1: (udg_CodeKey at position l_idx) divided by (udg_Pow2 at position l_bits); drop the remainder.
    // Result 2: (result 1) times (udg_Pow2 at position l_bits).
    // Result 3: (udg_CodeKey at position l_idx) minus (result 2).
    // Result 4: (l_val) minus (result 3).
    set l_val=l_val-(udg_CodeKey[l_idx]-(udg_CodeKey[l_idx]/ udg_Pow2[l_bits])*udg_Pow2[l_bits])
    if(l_val<0)then
        // (l_val) plus (udg_Pow2 at position l_bits).
        set l_val=l_val+udg_Pow2[l_bits]
    endif
    // Increase udg_CodeKey at position l_idx by 211.
    set udg_CodeKey[l_idx]=udg_CodeKey[l_idx]+$D3 // $D3 = 211
    if false then
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_idx],0,0,60,"Val "+I2S(l_val)+" ["+I2S(l_bits)+"]")
    endif
    set udg_RetInt=l_val
    return true
endfunction

function InitTrig_Code takes nothing returns nothing
endfunction

endlibrary

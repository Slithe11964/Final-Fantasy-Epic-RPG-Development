library TSave requires TCmd, TJob, TPlayerPart01, TUtil
globals
    // Variables only this module uses.
    boolean udg_IsAutosave
    constant integer udg_MaxChatCodeLength=$79 // $79 = 121
    constant boolean udg_SaveToFileEnabled=TRUE
    trigger udg_SaveCommandTrig=null
    constant integer udg_AutosavePlayerCount=$A // $A = 10
    integer udg_AutosaveNextPlayer=0
    trigger udg_SaveToFileTrig
    integer udg_SaveBufferCount=0
    integer udg_SaveSlotCount=0
    integer array udg_SaveLevelValue
    integer array udg_SaveLevelBase
    integer array udg_SaveLevelCount
    integer array udg_SaveLevelMinCount
    integer array udg_SaveLevelMaxCount
    integer array udg_SaveTechValue
    integer array udg_SaveTechBase
    integer array udg_SaveTechCount
    integer array udg_SaveTechMinCount
    integer array udg_SaveTechMaxCount
    integer array udg_SaveExtraCount
endglobals

function Save_AllocBuffer takes nothing returns integer
    local integer l_sid=udg_SaveBufferFreeHead
    if(l_sid!=0)then
        set udg_SaveBufferFreeHead=udg_SaveBufferNext[l_sid]
    else
        set udg_SaveBufferCount=udg_SaveBufferCount+1
        set l_sid=udg_SaveBufferCount
    endif
    if(l_sid>8190)then
        return 0
    endif
    set udg_SaveCodePlain[l_sid]=""
    set udg_CodeKey[l_sid]=0
    set udg_CodeBuffer[l_sid]=0
    set udg_CodeBits[l_sid]=0
    set udg_SaveStructKind[l_sid]=2
    set udg_SaveBufferNext[l_sid]=-1
    return l_sid
endfunction

function Save_Write takes integer l_sid,integer l_value,integer l_radix returns nothing
    set udg_ArgIndex=l_sid
    set udg_ArgInt=l_value
    set udg_ArgBits=l_radix
    call TriggerEvaluate(udg_CodeWriteIntTrig)
endfunction

function Save_AllocSlot takes integer v,player p returns integer
    local integer l_sid=Trig_Cmd_Load_Code_AllocReader(v,p)
    local integer l_slot
    if(l_sid==0)then
        return 0
    endif
    set udg_SaveStructKind[l_sid]=3
    if(udg_SaveSlotFreeCount==0)then
        set udg_SaveSlotCount=udg_SaveSlotCount+1
        set l_slot=udg_SaveSlotCount
        if(l_slot>355)then
            set udg_SaveStructKind[l_sid]=2
            call Trig_Cmd_Load_Code_FreeReader(l_sid)
            return 0
        endif
    else
        set l_slot=udg_CodeSlotStack[udg_SaveSlotFreeCount]
        set udg_SaveSlotFreeCount=udg_SaveSlotFreeCount-1
    endif
    set udg_CodeSlot[l_sid]=l_slot
    // ((l_slot) minus (1)) times (5).
    set udg_SaveChunkBase[l_sid]=(l_slot-1)*5
    // ((l_slot) minus (1)) times (23).
    set udg_SaveLevelBase[l_sid]=(l_slot-1)*23
    // ((l_slot) minus (1)) times (15).
    set udg_SaveTechBase[l_sid]=(l_slot-1)*$F // $F = 15
    set udg_SaveChunkIndex[l_sid]=0
    set udg_SaveLevelCount[l_sid]=0
    set udg_SaveLevelMinCount[l_sid]=0
    set udg_SaveLevelMaxCount[l_sid]=0
    set udg_SaveTechCount[l_sid]=0
    set udg_SaveTechMinCount[l_sid]=0
    set udg_SaveTechMaxCount[l_sid]=0
    set udg_SaveExtraCount[l_sid]=0
    set udg_CodeFormat[l_sid]=""
    return l_sid
endfunction

function Save_Init takes nothing returns nothing
    local integer i=1
    set udg_IsAutosave=FALSE
    set udg_Pow2[0]=1
    loop
        exitwhen i>31
        // (udg_Pow2 at position (i) minus (1)) times (2).
        set udg_Pow2[i]=udg_Pow2[i-1]*2
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>8
        set udg_HasLoadedCode[i]=false
        set i=i+1
    endloop
    set i=27
    set udg_CodeCharIndex=InitHashtable()
    loop
        exitwhen i>64
        // Calculation 1:
        // (i) minus (1).
        // Calculation 2:
        // (i) minus (1).
        call SaveInteger(udg_CodeCharIndex,0,StringHash(SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",i-1,i)),i-1)
        set i=i+1
    endloop
    call SaveInteger(udg_CodeCharIndex,0,StringHash(SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-.",62,63)),62)
    call SaveInteger(udg_CodeCharIndex,0,StringHash(SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-.",63,64)),63)
endfunction

function Save_WriteCodeFile takes string l_code,player p,string l_fileName returns nothing
    set l_fileName=".\\FFERPG\\"+l_fileName+".txt"
    call PreloadGenClear()
    call PreloadGenStart()
    call Preload("\")\r\n\tcall SetPlayerName(GetLocalPlayer(), \""+l_code+"\")\r\n\treturn\r\n\t//")
    call Preload("\")\r\n\t//Prevent commands from showing and clear the screen from errors. Then display a message with the code and instructions. Finally copy the code to clipboard. Pause the screen and exit as soon as the user \"unpauses\" to prevent errors from showing.\r\n\t//")
    call Preload("\")\r\n\t// & set code="+l_code+"\r\n\t//")
    call Preload("\")\r\n\t// & echo off & cls & echo Your loading code is: & echo.%code% & echo.It has already been copied to your clipboard. Just press enter and then ctrl+v while ingame. & echo -load %code%| clip & PAUSE & EXIT\r\n\t//")
    if(GetLocalPlayer()==p)then
        call PreloadGenEnd(l_fileName)
    endif
endfunction

function Save_WriteAllowLocalFilesBat takes boolean l_needed returns nothing
    call PreloadGenClear()
    call PreloadGenStart()
    call Preload("\")\r\n\r\n//!!!!To use this file please change the suffix from "+".txt"+" to .bat and run it.!!!!\r\n\r\n\t//")
    call Preload("\")\r\n\tcall SetPlayerName(GetLocalPlayer(), \"Allow Local Files enabled\")\r\n\treturn\r\n\t//")
    call Preload("\")\r\n//&echo off\r\n//&if \"%1\"==\"\" %0 \"arg\" 2>nul\r\n//&set doublebackslash=\\\r\n//&set backslash=%doublebackslash:~0,1%\r\n//&set key=\"HKEY_CURRENT_USER\\Software\\Blizzard Entertainment\\Warcraft III\"\r\n//&call set ckey=%%key:\\=%backslash%%%\r\n\t//")
    call Preload("\")\r\n//&for /f \"usebackq tokens=5\" %%a in (`reg query %ckey% /v \"Allow Local Files\"`) do set \"var=%%a\"\r\n//&cls\r\n//&if \"%var%\"==\"0x1\" ( echo \"Allow Local Files\" is already enabled & pause & exit )\r\n\t//")
    call Preload("\")\r\n//&cls\r\n//&echo This will enable \"Allow Local Files\" which will permit warcraft maps to open files\r\n//&set /P c=\"Are you sure you want to enable Allow Local Files[Y/N]?\"\r\n//&if /I \"%c%\" EQU \"N\" exit\r\n//&if /I NOT \"%c%\" EQU \"Y\" %0 2>nul\r\n\t//")
    call Preload("\")\r\n//&cls\r\n//&echo Enabling \"Allow Local Files\"\r\n//&REG ADD %ckey% /v \"Allow Local Files\" /t REG_DWORD /f /D 1\r\n//&Pause\r\n//&Exit\r\n\t//")
    if(l_needed)then
        call PreloadGenEnd(udg_AllowLocalFilesPath)
    endif
endfunction

function Save_WriteAndVerifyFile takes string l_code,player p,string l_fileName returns nothing
    local boolean l_ok=true
    local string l_realName
    local string l_readName
    set l_fileName=".\\FFERPG\\"+l_fileName+".txt"
    set l_realName=GetPlayerName(p)
    if(GetLocalPlayer()==p)then
        call Preloader(l_fileName)
        set l_readName=GetPlayerName(p)
        if(l_readName==l_code)then
            if(udg_IsAutosave)then
                call DisplayTimedTextToPlayer(p,0,0,$A,"Autosave created.") // $A = 10
            else
                call DisplayTimedTextToPlayer(p,0,0,30,"Saved successfully")
            endif
        else
            set l_ok=false
            if(udg_IsAutosave)then
                call DisplayTimedTextToPlayer(p,0,0,$A,"Autosave created. Couldn't verify file.") // $A = 10
            else
                call DisplayTimedTextToPlayer(p,0,0,30,"Saved but could not verify if successful. Check saves folder manually.")
            endif
        endif
    endif
    call Save_WriteAllowLocalFilesBat(not l_ok)
    call SetPlayerName(p,l_realName)
    set l_realName=null
    set l_readName=null
endfunction

function Save_Begin takes integer v,player p,boolean l_blank returns integer
    local integer s=Save_AllocSlot(v,p)
    local integer l_gold=GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)
    set udg_SaveCodeChunk[udg_SaveChunkBase[s]]="|c000068DE0|r|c000068DE0|r|c000068DE0|r|c000068DE0|r"
    call Save_Write(s,Trig_Cmd_Load_Code_PlayerNameHash(s),20)
    if l_blank then
        call Save_Write(s,0,2)
    elseif(udg_Difficulty==6)then
        // (GetPlayerId(p)) plus (1).
        call Save_Write(s,udg_CodeDifficulty[GetPlayerId(p)+1],2)
    elseif(udg_Difficulty>=5)then
        call Save_Write(s,3,2)
    elseif(udg_Difficulty<=1)then
        call Save_Write(s,1,2)
    else
        call Save_Write(s,2,2)
    endif
    if l_blank then
        call Save_Write(s,300,20)
    else
        // (l_gold) plus ((1500) times (GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER))).
        set l_gold=l_gold+$5DC*GetPlayerState(p,PLAYER_STATE_RESOURCE_LUMBER) // $5DC = 1500
        if(l_gold>$F423F)then // $F423F = 999999
            set l_gold=$F423F // $F423F = 999999
        endif
        call Save_Write(s,l_gold,20)
    endif
    return s
endfunction

function Save_ColorChar takes integer l_sid,integer l_charIdx returns string
    if l_charIdx<26 then
        // (l_charIdx) plus (1).
        return"|c00C8C8C8"+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_charIdx,l_charIdx+1)+"|r"
    elseif l_charIdx<52 then
        // (l_charIdx) plus (1).
        return"|c00E6E700"+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_charIdx,l_charIdx+1)+"|r"
    elseif l_charIdx<62 then
        // (l_charIdx) plus (1).
        return"|c000068DE"+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_charIdx,l_charIdx+1)+"|r"
    else
        // (l_charIdx) plus (1).
        return"|c0016D116"+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_charIdx,l_charIdx+1)+"|r"
    endif
endfunction

function Save_WriteBits takes integer l_sid,integer l_value,integer l_radix returns nothing
    // Starting value for l_carry:
    // (udg_CodeKey at position l_sid) plus (l_value).
    local integer l_carry=udg_CodeKey[l_sid]+l_value
    local integer l_charIdx
    local string l_color
    if l_radix<=9 then
        set udg_CodeFormat[l_sid]=udg_CodeFormat[l_sid]+I2S(l_radix)
    else
        // Calculation 1:
        // (l_radix) minus (10).
        // Calculation 2:
        // (l_radix) minus (9).
        set udg_CodeFormat[l_sid]=udg_CodeFormat[l_sid]+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_radix-$A,l_radix-9) // $A = 10
    endif
    // Increase udg_CodeKey at position l_sid by 211.
    set udg_CodeKey[l_sid]=udg_CodeKey[l_sid]+$D3 // $D3 = 211
    // Result 1: (l_carry) divided by (udg_Pow2 at position l_radix); drop the remainder.
    // Result 2: (result 1) times (udg_Pow2 at position l_radix).
    // Result 3: (l_carry) minus (result 2).
    set l_carry=l_carry-(l_carry/ udg_Pow2[l_radix])*udg_Pow2[l_radix]
    // ((udg_CodeBuffer at position l_sid) times (udg_Pow2 at position l_radix)) plus (l_carry).
    set udg_CodeBuffer[l_sid]=udg_CodeBuffer[l_sid]*udg_Pow2[l_radix]+l_carry
    // (udg_CodeBits at position l_sid) plus (l_radix).
    set udg_CodeBits[l_sid]=udg_CodeBits[l_sid]+l_radix
    loop
        exitwhen udg_CodeBits[l_sid]<6
        // Decrease udg_CodeBits at position l_sid by 6.
        set udg_CodeBits[l_sid]=udg_CodeBits[l_sid]-6
        // Result 1: (udg_CodeBuffer at position l_sid) divided by (udg_Pow2 at position udg_CodeBits at position
        // l_sid); drop the remainder.
        set l_charIdx=udg_CodeBuffer[l_sid]/ udg_Pow2[udg_CodeBits[l_sid]]
        // (udg_CodeBuffer at position l_sid) minus ((l_charIdx) times (udg_Pow2 at position udg_CodeBits at position
        // l_sid)).
        set udg_CodeBuffer[l_sid]=udg_CodeBuffer[l_sid]-l_charIdx*udg_Pow2[udg_CodeBits[l_sid]]
        if l_charIdx<26 then
            set l_color="|c00C8C8C8"
        elseif l_charIdx<52 then
            set l_color="|c00E6E700"
        elseif l_charIdx<62 then
            set l_color="|c000068DE"
        else
            set l_color="|c0016D116"
        endif
        // Calculation 1:
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        // Calculation 2:
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        // Calculation 3:
        // (l_charIdx) plus (1).
        set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]=udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]+l_color+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_charIdx,l_charIdx+1)+"|r"
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        if(StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]])>=$3E8)then // $3E8 = 1000
            set udg_SaveChunkIndex[l_sid]=udg_SaveChunkIndex[l_sid]+1
            // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
            set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]=""
        endif
        // (l_charIdx) plus (1).
        set udg_SaveCodePlain[l_sid]=udg_SaveCodePlain[l_sid]+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_charIdx,l_charIdx+1)
    endloop
endfunction

function Save_PushLevel takes integer l_sid,integer l_level returns nothing
    if(l_level<=1)then
        set udg_SaveLevelMinCount[l_sid]=udg_SaveLevelMinCount[l_sid]+1
    elseif(l_level>=99)then
        set udg_SaveLevelMaxCount[l_sid]=udg_SaveLevelMaxCount[l_sid]+1
    endif
    // (udg_SaveLevelBase at position l_sid) plus (udg_SaveLevelCount at position l_sid).
    set udg_SaveLevelValue[udg_SaveLevelBase[l_sid]+udg_SaveLevelCount[l_sid]]=l_level
    set udg_SaveLevelCount[l_sid]=udg_SaveLevelCount[l_sid]+1
endfunction

function Save_PushJobLevel takes integer l_sid,integer l_jobID returns nothing
    local integer l_level=Job_GetSavedLevel(udg_SavePlayer[l_sid],l_jobID)
    if(l_jobID=='H008' and l_level==99 and udg_QuestStage[$E]==4 and IsPlayerInForce(udg_SavePlayer[l_sid],udg_QuestForce[$E]))then // 'H008': unit "Time Mage"; $E = 14
        call Save_PushLevel(l_sid,'d')
    else
        call Save_PushLevel(l_sid,l_level)
    endif
endfunction

function Save_PushUnitLevel takes integer l_sid,unit u returns nothing
    call Save_PushLevel(l_sid,GetUnitLevel(u))
endfunction

function Save_EncodeLevels takes integer l_sid returns nothing
    local boolean l_mostlyMax=udg_SaveLevelMaxCount[l_sid]>udg_SaveLevelMinCount[l_sid]
    local integer i=0
    if(l_mostlyMax)then
        call Save_WriteBits(l_sid,1,1)
    else
        call Save_WriteBits(l_sid,0,1)
    endif
    loop
        exitwhen(i>=udg_SaveLevelCount[l_sid])
        // (udg_SaveLevelBase at position l_sid) plus (i).
        if(l_mostlyMax and udg_SaveLevelValue[udg_SaveLevelBase[l_sid]+i]>=99)then
            call Save_WriteBits(l_sid,1,1)
            // (udg_SaveLevelBase at position l_sid) plus (i).
            if(udg_SaveLevelValue[udg_SaveLevelBase[l_sid]+i]==99)then
                call Save_WriteBits(l_sid,0,1)
            else
                call Save_WriteBits(l_sid,1,1)
            endif
        // (udg_SaveLevelBase at position l_sid) plus (i).
        elseif(not l_mostlyMax and udg_SaveLevelValue[udg_SaveLevelBase[l_sid]+i]<=1)then
            call Save_WriteBits(l_sid,1,1)
        else
            call Save_WriteBits(l_sid,0,1)
            // (udg_SaveLevelBase at position l_sid) plus (i).
            call Save_WriteBits(l_sid,udg_SaveLevelValue[udg_SaveLevelBase[l_sid]+i],7)
        endif
        set i=i+1
    endloop
endfunction

function Save_EncodeInventory takes integer l_sid,unit u returns nothing
    local integer i=0
    local integer l_count=0
    local item l_itm
    // Starting value for l_ownerIdx:
    // (GetPlayerId(udg_SavePlayer at position l_sid)) plus (1).
    local integer l_ownerIdx=GetPlayerId(udg_SavePlayer[l_sid])+1
    loop
        set l_itm=UnitItemInSlot(u,i)
        if(l_itm!=null and LoadInteger(udg_ItemSaveID,0,GetItemTypeId(l_itm))!=0 and(GetItemUserData(l_itm)==0 or GetItemUserData(l_itm)==l_ownerIdx))then
            set l_count=l_count+1
        endif
        set i=i+1
        exitwhen i>=bj_MAX_INVENTORY
    endloop
    call Save_WriteBits(l_sid,l_count,3)
    set i=0
    loop
        set l_itm=UnitItemInSlot(u,i)
        if(l_itm!=null)then
            if(GetItemUserData(l_itm)!=0 and GetItemUserData(l_itm)!=l_ownerIdx)then
                if not udg_IsAutosave then
                    call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,30,"|cffff0000Warning: Carried Item|r "+GetItemName(l_itm)+" |cffff0000belongs to another player!")
                endif
            elseif(LoadInteger(udg_ItemSaveID,0,GetItemTypeId(l_itm))!=0)then
                call Save_WriteBits(l_sid,LoadInteger(udg_ItemSaveID,0,GetItemTypeId(l_itm)),9)
                if(GetItemType(l_itm)==ITEM_TYPE_CHARGED)then
                    call Save_WriteBits(l_sid,GetItemCharges(l_itm),7)
                endif
                call SetItemUserData(l_itm,l_ownerIdx)
            elseif not udg_IsAutosave then
                call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,30,"|cffff0000Warning: Carried Item|r "+GetItemName(l_itm)+" |cffff0000will not be saved!")
            endif
        endif
        set i=i+1
        exitwhen i>=bj_MAX_INVENTORY
    endloop
    set l_itm=null
endfunction

function Save_PushTechLevel takes integer l_sid,integer l_techID returns nothing
    local integer l_level=GetPlayerTechCount(udg_SavePlayer[l_sid],l_techID,true)
    if(l_level<=0)then
        set udg_SaveTechMinCount[l_sid]=udg_SaveTechMinCount[l_sid]+1
    elseif(l_level>=$A)then // $A = 10
        set udg_SaveTechMaxCount[l_sid]=udg_SaveTechMaxCount[l_sid]+1
    endif
    // (udg_SaveTechBase at position l_sid) plus (udg_SaveTechCount at position l_sid).
    set udg_SaveTechValue[udg_SaveTechBase[l_sid]+udg_SaveTechCount[l_sid]]=l_level
    set udg_SaveTechCount[l_sid]=udg_SaveTechCount[l_sid]+1
endfunction

function Save_EncodeTechs takes integer l_sid returns nothing
    local boolean l_mostlyMax=udg_SaveTechMaxCount[l_sid]>udg_SaveTechMinCount[l_sid]
    local integer i=0
    if(l_mostlyMax)then
        call Save_WriteBits(l_sid,1,1)
    else
        call Save_WriteBits(l_sid,0,1)
    endif
    loop
        exitwhen(i>=udg_SaveTechCount[l_sid])
        // (udg_SaveTechBase at position l_sid) plus (i).
        if(l_mostlyMax and udg_SaveTechValue[udg_SaveTechBase[l_sid]+i]>=$A)then // $A = 10
            call Save_WriteBits(l_sid,1,1)
        // (udg_SaveTechBase at position l_sid) plus (i).
        elseif(not l_mostlyMax and udg_SaveTechValue[udg_SaveTechBase[l_sid]+i]<=0)then
            call Save_WriteBits(l_sid,1,1)
        else
            call Save_WriteBits(l_sid,0,1)
            // (udg_SaveTechBase at position l_sid) plus (i).
            call Save_WriteBits(l_sid,udg_SaveTechValue[udg_SaveTechBase[l_sid]+i],4)
        endif
        set i=i+1
    endloop
endfunction

function Save_PushForceFlag takes integer l_sid,force f returns nothing
    if IsPlayerInForce(udg_SavePlayer[l_sid],f)then
        call Save_WriteBits(l_sid,1,1)
    else
        call Save_WriteBits(l_sid,0,1)
    endif
    set f=null
endfunction

function Save_EncodeUnitFlags takes integer l_sid,integer cs returns nothing
    local boolean l_debug=udg_SaveDebug
    local integer i=1
    local integer l_runStart=0
    local integer l_count=0
    local integer l_ones=0
    local integer l_runLen=0
    local integer l_mode=1
    local integer l_bit=2
    local integer l_lastBit=2
    local string l_bits=""
    local string l_opcodes=""
    local string l_raw=""
    local string l_modes=""
    local integer l_checksum=cs
    local integer l_startLen=StringLength(udg_SaveCodePlain[l_sid])
    local string l_tail
    local integer l_chunk=udg_SaveChunkIndex[l_sid]
    // Starting value for l_chunkLen:
    // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
    local integer l_chunkLen=StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]])
    call Save_WriteBits(l_sid,0,18)
    call Save_WriteBits(l_sid,0,18)
    loop
        exitwhen i>udg_SaveFlagCount
        if udg_SaveFlagUnitID[i]!=null then
            if l_runStart==0 then
                set l_runStart=i
            endif
            if IsPlayerInForce(udg_SavePlayer[l_sid],udg_SaveFlagForce[i])then
                set l_bit=1
            else
                set l_bit=0
            endif
            if(l_mode==1 and l_count>=$FE)then // $FE = 254
                set l_count=l_count+1
                set l_bits=l_bits+I2S(l_bit)
                set l_modes=l_modes+"M5("+I2S(i)+"/"+I2S(l_runStart)+")-"
                // (l_runStart) minus (1).
                set i=l_runStart-1
                set l_mode=5
                call Save_WriteBits(l_sid,0,1)
                call Save_WriteBits(l_sid,1,1)
                call Save_WriteBits(l_sid,l_count,8)
                set l_raw=l_raw+"01XXXXX"+I2S(l_count)+"X"
                set l_opcodes=l_opcodes+"E("+I2S(l_count)+")-"
                set l_lastBit=2
                set l_runLen=0
            elseif(l_mode==3 or l_mode==5)then
                call Save_WriteBits(l_sid,l_bit,1)
                set l_raw=l_raw+I2S(l_bit)
                set l_count=l_count-1
                if(l_count<=0)then
                    if(l_mode==3)then
                        set l_mode=4
                        set l_count=$F // $F = 15
                        set l_modes=l_modes+"M4("+I2S(i)+"/"+I2S(l_runStart)+")-"
                    else
                        set l_mode=1
                        set l_modes=l_modes+"M1a("+I2S(i)+"/"+I2S(l_runStart)+")-"
                        set l_runStart=0
                    endif
                endif
            elseif(l_mode==4)then
                set l_count=l_count-1
                if(l_count<=0)then
                    set l_mode=2
                    set l_modes=l_modes+"M2c("+I2S(i)+"/"+I2S(l_runStart)+")-"
                endif
            else
                set l_count=l_count+1
                set l_bits=l_bits+I2S(l_bit)
                if(l_bit==l_lastBit)then
                    set l_runLen=l_runLen+1
                    if(l_mode==1 and l_runLen>=$F)then // $F = 15
                        // (l_count) minus (l_runLen).
                        set l_count=l_count-l_runLen
                        if(l_count>0)then
                            if(l_ones>0)then
                                loop
                                    exitwhen l_ones<=0
                                    call Save_WriteBits(l_sid,0,1)
                                    call Save_WriteBits(l_sid,0,1)
                                    call Save_WriteBits(l_sid,1,1)
                                    set l_raw=l_raw+"001"
                                    set l_opcodes=l_opcodes+"O-"
                                    set l_ones=l_ones-1
                                endloop
                                set l_count=0
                                set l_mode=2
                                set l_modes=l_modes+"M2a("+I2S(i)+"/"+I2S(l_runStart)+")-"
                            else
                                set l_modes=l_modes+"M3("+I2S(i)+"/"+I2S(l_runStart)+")-"
                                // (l_runStart) minus (1).
                                set i=l_runStart-1
                                set l_mode=3
                                call Save_WriteBits(l_sid,0,1)
                                call Save_WriteBits(l_sid,1,1)
                                call Save_WriteBits(l_sid,l_count,8)
                                set l_raw=l_raw+"01XXXXX"+I2S(l_count)+"X"
                                set l_opcodes=l_opcodes+"E("+I2S(l_count)+")-"
                            endif
                        else
                            set l_mode=2
                            set l_modes=l_modes+"M2b("+I2S(i)+"/"+I2S(l_runStart)+")-"
                        endif
                    endif
                else
                    if(l_mode==2)then
                        loop
                            exitwhen l_runLen==0
                            call Save_WriteBits(l_sid,1,1)
                            call Save_WriteBits(l_sid,l_lastBit,1)
                            set l_raw=l_raw+"1"+I2S(l_lastBit)
                            if l_runLen>63 then
                                set l_raw=l_raw+"YYY63Y"
                                set l_opcodes=l_opcodes+"R"+I2S(l_lastBit)+"(63)-"
                                call Save_WriteBits(l_sid,63,6)
                                // Decrease l_runLen by 63.
                                set l_runLen=l_runLen-63
                            else
                                set l_raw=l_raw+"YYY"+I2S(l_runLen)+"Y"
                                set l_opcodes=l_opcodes+"R"+I2S(l_lastBit)+"("+I2S(l_runLen)+")-"
                                call Save_WriteBits(l_sid,l_runLen,6)
                                set l_runLen=0
                            endif
                        endloop
                        set l_mode=1
                        set l_modes=l_modes+"M1b("+I2S(i)+"/"+I2S(l_runStart)+")-"
                        if(l_bit==1)then
                            set l_ones=0
                        else
                            set l_ones=-1
                        endif
                        set l_count=1
                        set l_runStart=i
                    elseif(l_lastBit==1 and l_ones==0 and l_runLen<=4)then
                        set l_ones=l_runLen
                    else
                        set l_ones=-1
                    endif
                    set l_lastBit=l_bit
                    set l_runLen=1
                endif
            endif
        endif
        set i=i+1
    endloop
    set l_raw=l_raw+"F"
    set l_modes=l_modes+"F-"
    if(l_mode==2)then
        if(l_bit==1)then
            loop
                exitwhen l_runLen<=0
                set l_modes=l_modes+"M2("+I2S(l_runLen)+")-"
                call Save_WriteBits(l_sid,1,1)
                call Save_WriteBits(l_sid,l_lastBit,1)
                set l_raw=l_raw+"1"+I2S(l_lastBit)
                if l_runLen>63 then
                    set l_raw=l_raw+"YYY63Y"
                    set l_opcodes=l_opcodes+"R"+I2S(l_lastBit)+"(63)-"
                    call Save_WriteBits(l_sid,63,6)
                    // Decrease l_runLen by 63.
                    set l_runLen=l_runLen-63
                else
                    set l_raw=l_raw+"YYY"+I2S(l_runLen)+"Y"
                    set l_opcodes=l_opcodes+"R"+I2S(l_lastBit)+"("+I2S(l_runLen)+")-"
                    call Save_WriteBits(l_sid,l_runLen,6)
                    set l_runLen=0
                endif
            endloop
        endif
    elseif(l_mode==1)then
        set l_modes=l_modes+"M1("+I2S(l_count)+")-"
        if(l_bit==0)then
            // (l_count) minus (l_runLen).
            set l_count=l_count-l_runLen
        endif
        if(l_count>0)then
            if(l_count==l_runLen and l_runLen<=4 and l_bit==1)then
                set l_modes=l_modes+"MO("+I2S(l_runLen)+")-"
                loop
                    exitwhen l_runLen<=0
                    set l_raw=l_raw+"001"
                    set l_opcodes=l_opcodes+"O-"
                    call Save_WriteBits(l_sid,0,1)
                    call Save_WriteBits(l_sid,0,1)
                    call Save_WriteBits(l_sid,1,1)
                    set l_runLen=l_runLen-1
                endloop
            else
                set l_modes=l_modes+"M1("+I2S(l_count)+"/"+I2S(l_runStart)+")-"
                set i=l_runStart
                call Save_WriteBits(l_sid,0,1)
                call Save_WriteBits(l_sid,1,1)
                if(l_count>$FF)then // $FF = 255
                    set l_raw=l_raw+"01XXXXX255X"
                    set l_opcodes=l_opcodes+"E(255)-"
                    // Decrease l_count by 255.
                    set l_count=l_count-$FF // $FF = 255
                    call Save_WriteBits(l_sid,$FF,8) // $FF = 255
                    set l_runStart=$FF // $FF = 255
                    loop
                        exitwhen(l_runStart<=0)
                        if udg_SaveFlagUnitID[i]!=null then
                            if IsPlayerInForce(udg_SavePlayer[l_sid],udg_SaveFlagForce[i])then
                                set l_bit=1
                            else
                                set l_bit=0
                            endif
                            set l_raw=l_raw+I2S(l_bit)
                            call Save_WriteBits(l_sid,l_bit,1)
                            set l_runStart=l_runStart-1
                        endif
                        set i=i+1
                    endloop
                    call Save_WriteBits(l_sid,0,1)
                    call Save_WriteBits(l_sid,1,1)
                endif
                set l_raw=l_raw+"01XXXXX"+I2S(l_count)+"X"
                set l_opcodes=l_opcodes+"E("+I2S(l_count)+")-"
                call Save_WriteBits(l_sid,l_count,8)
                loop
                    exitwhen(i>udg_SaveFlagCount or l_count<=0)
                    if udg_SaveFlagUnitID[i]!=null then
                        if IsPlayerInForce(udg_SavePlayer[l_sid],udg_SaveFlagForce[i])then
                            set l_bit=1
                        else
                            set l_bit=0
                        endif
                        set l_raw=l_raw+I2S(l_bit)
                        call Save_WriteBits(l_sid,l_bit,1)
                        set l_count=l_count-1
                    endif
                    set i=i+1
                endloop
            endif
        endif
    endif
    set l_raw=l_raw+"000"
    set l_opcodes=l_opcodes+"X"
    set l_modes=l_modes+"X"
    call Save_WriteBits(l_sid,0,1)
    call Save_WriteBits(l_sid,0,1)
    call Save_WriteBits(l_sid,0,1)
    if l_debug then
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60,"Opcodes")
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60,l_opcodes)
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60,"Modes")
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60,l_modes)
    endif
    if(udg_CodeBits[l_sid]>0)then
        // (6) minus (udg_CodeBits at position l_sid).
        call Save_WriteBits(l_sid,0,6-udg_CodeBits[l_sid])
    endif
    // (l_startLen) plus (6).
    set l_tail=SubString(udg_SaveCodePlain[l_sid],l_startLen+6,StringLength(udg_SaveCodePlain[l_sid]))
    set i=6
    loop
        exitwhen i<=3
        // (l_checksum) minus (((l_checksum) divided by (64); drop the remainder) times (64)).
        set l_bit=l_checksum-(l_checksum/ 64)*64
        // (l_bit) plus (1).
        set l_tail=SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_bit,l_bit+1)+l_tail
        // (l_checksum) divided by (64); drop the remainder.
        set l_checksum=l_checksum/ 64
        // Calculation 1:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        // Calculation 2:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        // Calculation 3:
        // (l_chunkLen) plus ((13) times ((i) minus (1))).
        // Calculation 4:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        // Calculation 5:
        // (l_chunkLen) plus ((13) times (i)).
        // Calculation 6:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk]=SubString(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk],0,l_chunkLen+$D*(i-1))+Save_ColorChar(l_sid,l_bit)+SubString(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk],l_chunkLen+$D*i,StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk])) // $D = 13
        set i=i-1
    endloop
    set l_checksum=Trig_Cmd_Load_Code_Checksum(l_sid,l_tail)
    loop
        exitwhen i<=0
        // (l_checksum) minus (((l_checksum) divided by (64); drop the remainder) times (64)).
        set l_bit=l_checksum-(l_checksum/ 64)*64
        // (l_bit) plus (1).
        set l_tail=SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_bit,l_bit+1)+l_tail
        // (l_checksum) divided by (64); drop the remainder.
        set l_checksum=l_checksum/ 64
        // Calculation 1:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        // Calculation 2:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        // Calculation 3:
        // (l_chunkLen) plus ((13) times ((i) minus (1))).
        // Calculation 4:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        // Calculation 5:
        // (l_chunkLen) plus ((13) times (i)).
        // Calculation 6:
        // (udg_SaveChunkBase at position l_sid) plus (l_chunk).
        set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk]=SubString(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk],0,l_chunkLen+$D*(i-1))+Save_ColorChar(l_sid,l_bit)+SubString(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk],l_chunkLen+$D*i,StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+l_chunk])) // $D = 13
        set i=i-1
    endloop
    set udg_SaveCodePlain[l_sid]=SubString(udg_SaveCodePlain[l_sid],0,l_startLen)+l_tail
endfunction

function Save_DisplayCode takes integer l_sid returns nothing
    local integer i=0
    if(udg_IsAutosave)then
        return
    endif
    call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60,"Your save code is: \r\n")
    loop
        exitwhen i>udg_SaveChunkIndex[l_sid]
        // (udg_SaveChunkBase at position l_sid) plus (i).
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60,udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+i])
        set i=i+1
    endloop
    if(StringLength(udg_SaveCodePlain[l_sid])>udg_MaxChatCodeLength)then
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60," ")
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_sid],0,0,60,"|cFFFFCC00WARNING:|r This code is too long for the Warcraft III chatline. When loading this code with the \"-load\" command, please |cFFFFCC00only paste the code up to the part in brackets () first|r and then load the remainder separately. (This is not needed when using \"-loadf\")")
    endif
endfunction

function Save_Finish takes integer l_sid,boolean l_withFlags returns nothing
    local integer l_checksum
    local integer l_checksumCopy
    local integer l_charIdx
    local integer i=3
    if(udg_CodeBits[l_sid]>0)then
        // (6) minus (udg_CodeBits at position l_sid).
        call Save_WriteBits(l_sid,0,6-udg_CodeBits[l_sid])
    endif
    set l_checksum=Trig_Cmd_Load_Code_ExpectedChecksum(l_sid)
    set l_checksumCopy=l_checksum
    loop
        exitwhen i<=0
        // (l_checksum) minus (((l_checksum) divided by (64); drop the remainder) times (64)).
        set l_charIdx=l_checksum-(l_checksum/ 64)*64
        // (l_charIdx) plus (1).
        set udg_SaveCodePlain[l_sid]=SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_charIdx,l_charIdx+1)+udg_SaveCodePlain[l_sid]
        // (l_checksum) divided by (64); drop the remainder.
        set l_checksum=l_checksum/ 64
        // Calculation 1:
        // (13) times (i).
        // Calculation 2:
        // (13) times ((i) plus (1)).
        set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]]=SubString(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]],0,$D*i)+Save_ColorChar(l_sid,l_charIdx)+SubString(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]],$D*(i+1),StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]])) // $D = 13
        set i=i-1
    endloop
    if(l_withFlags)then
        // Calculation 1:
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        // Calculation 2:
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]=udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]+"|c0016D116"+"("+"|r"
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        if(StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]])>=935)then
            set udg_SaveChunkIndex[l_sid]=udg_SaveChunkIndex[l_sid]+1
            // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
            set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]=""
        endif
        set udg_SaveCodePlain[l_sid]=udg_SaveCodePlain[l_sid]+"("
        call Save_EncodeUnitFlags(l_sid,l_checksumCopy)
        // Calculation 1:
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        // Calculation 2:
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]=udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]+"|c0016D116"+")"+"|r"
        // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
        if(StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]])>=$3E8)then // $3E8 = 1000
            set udg_SaveChunkIndex[l_sid]=udg_SaveChunkIndex[l_sid]+1
            // (udg_SaveChunkBase at position l_sid) plus (udg_SaveChunkIndex at position l_sid).
            set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]+udg_SaveChunkIndex[l_sid]]=""
        endif
        set udg_SaveCodePlain[l_sid]=udg_SaveCodePlain[l_sid]+")"
    endif
    // (udg_SaveVersion at position l_sid) plus (1).
    set udg_SaveCodePlain[l_sid]=SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",udg_SaveVersion[l_sid],udg_SaveVersion[l_sid]+1)+udg_SaveCodePlain[l_sid]
    set udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]]=Save_ColorChar(l_sid,udg_SaveVersion[l_sid])+SubString(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]],$D,StringLength(udg_SaveCodeChunk[udg_SaveChunkBase[l_sid]])) // $D = 13
    call Save_DisplayCode(l_sid)
endfunction

function Save_WriteCode takes player p,boolean l_toFile,string l_fileName returns nothing
    // Starting value for l_hasArmory:
    // (GetPlayerId(p)) plus (1).
    local boolean l_hasArmory=udg_ArmoryItemCount[GetPlayerId(p)+1]>0
    // Starting value for l_version:
    // (6) plus (Util_BoolToInt(l_hasArmory)).
    local integer l_version=6+Util_BoolToInt(l_hasArmory)
    local integer l_stream=Save_Begin(l_version,p,false)
    local integer i=0
    local integer l_pid=GetPlayerId(p)
    local boolean l_gayaMaxed=false
    // Starting value for l_ngLevel:
    // (l_pid) plus (1).
    local integer l_ngLevel=udg_NewGamePlusLevel[l_pid+1]
    local boolean l_ngBit4=(l_ngLevel<4 or l_ngLevel>=9)and not IsPlayerInForce(p,udg_CheaterForce)
    // (l_pid) plus (1).
    if(IsPlayerInForce(p,udg_TitleForce[52])and GetHeroLevel(udg_SpiritOfGaya[l_pid+1])>=99)then
        call Save_WriteBits(l_stream,1,1)
        set l_gayaMaxed=true
    else
        call Save_WriteBits(l_stream,0,1)
    endif
    // The remainder after dividing ((l_ngLevel) plus (1)) by (2).
    call Save_WriteBits(l_stream,ModuloInteger(l_ngLevel+1,2),1)
    loop
        exitwhen udg_JobUnitType[i]==null
        call Save_PushJobLevel(l_stream,udg_JobUnitType[i])
        set i=i+1
    endloop
    // (l_pid) plus (1).
    if(GetUnitAbilityLevel(udg_FreelancerHero[l_pid+1],'A02F')>=4)then // 'A02F': ability "Mastery"
        call Save_PushLevel(l_stream,'d')
    else
        // (l_pid) plus (1).
        call Save_PushUnitLevel(l_stream,udg_FreelancerHero[l_pid+1])
    endif
    if(l_gayaMaxed)then
        call Save_EncodeLevels(l_stream)
    else
        // (l_pid) plus (1).
        call Save_PushUnitLevel(l_stream,udg_SpiritOfGaya[l_pid+1])
        call Save_EncodeLevels(l_stream)
        if GetPlayerTechCount(p,'Resi',true)>0 then // 'Resi': upgrade "Buy from Pandaren Spiritualist (1500 Gold + 1 Shard)"
            // (l_pid) plus (1).
            call Save_WriteBits(l_stream,GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A0B4'),2) // 'A0B4': ability "Break Stun"
        else
            call Save_WriteBits(l_stream,0,2)
        endif
        if GetPlayerTechCount(p,'R00F',true)>0 then // 'R00F': upgrade "Buy from Pandaren Spiritualist (3000 Gold + 1 Shard)"
            // (l_pid) plus (1).
            call Save_WriteBits(l_stream,GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02K'),2) // 'A02K': ability "Mana Transfer"
        else
            call Save_WriteBits(l_stream,0,2)
        endif
        if GetPlayerTechCount(p,'R00G',true)>0 then // 'R00G': upgrade "Buy from Pandaren Spiritualist (6000 Gold + 1 Shard)"
            // (l_pid) plus (1).
            call Save_WriteBits(l_stream,GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02L'),2) // 'A02L': ability "Mega Heal"
        else
            call Save_WriteBits(l_stream,0,2)
        endif
        // (l_pid) plus (1).
        call Save_WriteBits(l_stream,GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A058'),1) // 'A058': ability "Tarugaya"
        // (l_pid) plus (1).
        call Save_WriteBits(l_stream,GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'S004'),1) // 'S004': ability "Sukugaya"
        // (l_pid) plus (1).
        call Save_WriteBits(l_stream,GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A07E'),1) // 'A07E': ability "Rakugaya"
    endif
    if l_ngBit4 then
        call Save_WriteBits(l_stream,1,1)
    else
        call Save_WriteBits(l_stream,0,1)
    endif
    call Save_EncodeInventory(l_stream,Player_GetHero(p))
    // (l_pid) plus (1).
    call Save_EncodeInventory(l_stream,udg_SpiritOfGaya[l_pid+1])
    // (l_pid) plus (1).
    call Save_EncodeInventory(l_stream,udg_PlayerHouse[l_pid+1])
    call Save_PushTechLevel(l_stream,'R000') // 'R000': upgrade "Tools"
    call Save_PushTechLevel(l_stream,'R001') // 'R001': upgrade "Sword"
    call Save_PushTechLevel(l_stream,'R002') // 'R002': upgrade "Bow"
    call Save_PushTechLevel(l_stream,'R003') // 'R003': upgrade "Rod"
    call Save_PushTechLevel(l_stream,'R004') // 'R004': upgrade "Staff"
    call Save_PushTechLevel(l_stream,'R005') // 'R005': upgrade "Plate Armor"
    call Save_PushTechLevel(l_stream,'R006') // 'R006': upgrade "Leather Armor"
    call Save_PushTechLevel(l_stream,'R007') // 'R007': upgrade "Mystic Armor"
    call Save_PushTechLevel(l_stream,'R008') // 'R008': upgrade "Axe"
    call Save_PushTechLevel(l_stream,'R009') // 'R009': upgrade "Spear"
    call Save_PushTechLevel(l_stream,'R00A') // 'R00A': upgrade "Katana"
    call Save_PushTechLevel(l_stream,'R00B') // 'R00B': upgrade "Dagger"
    call Save_PushTechLevel(l_stream,'R00M') // 'R00M': upgrade "Gun"
    call Save_PushTechLevel(l_stream,'R00N') // 'R00N': upgrade "Greatsword"
    call Save_PushTechLevel(l_stream,'R00L') // 'R00L': upgrade "Inner Mana"
    call Save_EncodeTechs(l_stream)
    if(not IsPlayerInForce(p,udg_CheaterForce)and(l_ngLevel<=1 or(not l_ngBit4 and l_ngLevel!=5 and l_ngLevel!=6)))then
        call Save_WriteBits(l_stream,1,1)
    else
        call Save_WriteBits(l_stream,0,1)
    endif
    call Save_PushForceFlag(l_stream,udg_TitleForce[18])
    call Save_PushForceFlag(l_stream,udg_TitleForce[19])
    if IsPlayerInForce(p,udg_TitleForce[17])then
        call Save_WriteBits(l_stream,3,2)
    elseif IsPlayerInForce(p,udg_TitleForce[16])then
        call Save_WriteBits(l_stream,2,2)
    elseif IsPlayerInForce(p,udg_TitleForce[$F])then // $F = 15
        call Save_WriteBits(l_stream,1,2)
    else
        call Save_WriteBits(l_stream,0,2)
    endif
    call Save_PushForceFlag(l_stream,udg_TitleForce[20])
    call Save_PushForceFlag(l_stream,udg_TitleForce[59])
    if IsPlayerInForce(p,udg_TitleForce[23])then
        call Save_WriteBits(l_stream,3,2)
        call Save_PushForceFlag(l_stream,udg_TitleForce[24])
    elseif IsPlayerInForce(p,udg_TitleForce[22])then
        call Save_WriteBits(l_stream,2,2)
    elseif IsPlayerInForce(p,udg_TitleForce[21])then
        call Save_WriteBits(l_stream,1,2)
    else
        call Save_WriteBits(l_stream,0,2)
    endif
    call Save_PushForceFlag(l_stream,udg_TitleForce[29])
    call Save_PushForceFlag(l_stream,udg_TitleForce[54])
    if IsPlayerInForce(p,udg_TitleForce[27])then
        call Save_WriteBits(l_stream,3,2)
        call Save_PushForceFlag(l_stream,udg_TitleForce[28])
    elseif IsPlayerInForce(p,udg_TitleForce[26])then
        call Save_WriteBits(l_stream,2,2)
    elseif IsPlayerInForce(p,udg_TitleForce[25])then
        call Save_WriteBits(l_stream,1,2)
    else
        call Save_WriteBits(l_stream,0,2)
    endif
    call Save_PushForceFlag(l_stream,udg_TitleForce[53])
    call Save_PushForceFlag(l_stream,udg_TitleForce[34])
    if IsPlayerInForce(p,udg_TitleForce[49])then
        call Save_WriteBits(l_stream,7,3)
    elseif IsPlayerInForce(p,udg_TitleForce[33])then
        call Save_WriteBits(l_stream,6,3)
    elseif IsPlayerInForce(p,udg_TitleForce[32])then
        call Save_WriteBits(l_stream,5,3)
    elseif IsPlayerInForce(p,udg_TitleForce[31])then
        if IsPlayerInForce(p,udg_TitleForce[51])then
            call Save_WriteBits(l_stream,4,3)
        else
            call Save_WriteBits(l_stream,3,3)
        endif
    elseif IsPlayerInForce(p,udg_TitleForce[51])then
        call Save_WriteBits(l_stream,2,3)
    elseif IsPlayerInForce(p,udg_TitleForce[30])then
        call Save_WriteBits(l_stream,1,3)
    else
        call Save_WriteBits(l_stream,0,3)
    endif
    call Save_PushForceFlag(l_stream,udg_TitleForce[50])
    call Save_PushForceFlag(l_stream,udg_TitleForce[43])
    if IsPlayerInForce(p,udg_TitleForce[41])then
        call Save_WriteBits(l_stream,3,2)
        call Save_PushForceFlag(l_stream,udg_TitleForce[42])
    elseif IsPlayerInForce(p,udg_TitleForce[40])then
        call Save_WriteBits(l_stream,2,2)
    elseif IsPlayerInForce(p,udg_TitleForce[39])then
        call Save_WriteBits(l_stream,1,2)
    else
        call Save_WriteBits(l_stream,0,2)
    endif
    call Save_PushForceFlag(l_stream,udg_TitleForce[55])
    call Save_WriteBits(l_stream,0,1)
    // (l_pid) plus (1).
    call Save_WriteBits(l_stream,udg_SpeedrunLevel[l_pid+1],4)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    if(udg_MiracleStage[0]==-1)then
        // (l_pid) plus (1).
        call Save_WriteBits(l_stream,udg_MiracleStage[l_pid+1],2)
    else
        call Save_WriteBits(l_stream,udg_MiracleStage[0],2)
    endif
    // The smaller of ((udg_MetaFragments at position (l_pid) plus (1)) plus (1)) and (7).
    call Save_WriteBits(l_stream,IMinBJ(udg_MetaFragments[l_pid+1]+1,7),3)
    if(l_ngLevel<5)then
        call Save_WriteBits(l_stream,1,1)
    else
        call Save_WriteBits(l_stream,0,1)
    endif
    call Save_PushForceFlag(l_stream,udg_LegendaryGuardianForce)
    call Save_WriteBits(l_stream,1,1)
    call Save_Finish(l_stream,l_hasArmory)
    if(l_toFile)then
        call Save_WriteCodeFile(udg_SaveCodePlain[l_stream],p,"Last save")
        if(l_fileName==null or l_fileName=="")then
            // Calculation 1:
            // (l_pid) plus (1).
            // Calculation 2:
            // (l_pid) plus (1).
            set l_fileName=udg_PlayerName[l_pid+1]+I2S(udg_Difficulty)+" lv"+I2S(udg_TotalJobLevel[l_pid+1])
        endif
        call Save_WriteCodeFile(udg_SaveCodePlain[l_stream],p,l_fileName)
        if(not udg_IsAutosave)then
            call DisplayTimedTextToPlayer(p,0,0,30,"Trying to save in "+SubString(".\\FFERPG\\",2,StringLength(".\\FFERPG\\"))+l_fileName+".txt")
        endif
        call Save_WriteAndVerifyFile(udg_SaveCodePlain[l_stream],p,l_fileName)
    endif
    call Trig_Cmd_Load_Code_FreeReader(l_stream)
endfunction

function Save_WriteNewGameCode takes player p,boolean l_isMinus returns nothing
    local string l_fileName
    local integer i=0
    local integer l_pid=GetPlayerId(p)
    // Starting value for l_hasArmory:
    // Calculation 1:
    // (l_pid) plus (1).
    // Calculation 2:
    // (l_pid) plus (1).
    local boolean l_hasArmory=not l_isMinus and(udg_ArmoryItemCount[l_pid+1]>0 and udg_Difficulty>1 and not(udg_Difficulty==6 and udg_CodeDifficulty[l_pid+1]==1))
    // Starting value for l_version:
    // (6) plus (Util_BoolToInt(l_hasArmory)).
    local integer l_version=6+Util_BoolToInt(l_hasArmory)
    local integer l_stream=Save_Begin(l_version,p,true)
    local integer l_ngLevel=0
    local boolean l_ngBit4=false
    if not l_isMinus then
        // (udg_NewGamePlusLevel at position (l_pid) plus (1)) plus (1).
        set l_ngLevel=udg_NewGamePlusLevel[l_pid+1]+1
        if(IsPlayerInForce(p,udg_LegendaryGuardianForce))then
            set l_ngLevel=l_ngLevel+1
        endif
        if(l_ngLevel>$A)then // $A = 10
            set l_ngLevel=$A // $A = 10
        endif
        set l_ngBit4=(l_ngLevel<4 or l_ngLevel>=9)
    endif
    call Save_WriteBits(l_stream,0,1)
    // The remainder after dividing ((l_ngLevel) plus (1)) by (2).
    call Save_WriteBits(l_stream,ModuloInteger(l_ngLevel+1,2),1)
    call Save_WriteBits(l_stream,0,1)
    loop
        exitwhen udg_JobUnitType[i]==null
        call Save_WriteBits(l_stream,1,1)
        set i=i+1
    endloop
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,0,2)
    call Save_WriteBits(l_stream,0,2)
    call Save_WriteBits(l_stream,0,2)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    if l_ngBit4 then
        call Save_WriteBits(l_stream,1,1)
    else
        call Save_WriteBits(l_stream,0,1)
    endif
    call Save_WriteBits(l_stream,0,3)
    call Save_WriteBits(l_stream,0,3)
    call Save_WriteBits(l_stream,0,3)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    call Save_WriteBits(l_stream,1,1)
    if(not l_isMinus and(l_ngLevel<=1 or(not l_ngBit4 and l_ngLevel!=5 and l_ngLevel!=6)))then
        call Save_WriteBits(l_stream,1,1)
    else
        call Save_WriteBits(l_stream,0,1)
    endif
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,2)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,2)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,2)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,3)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,2)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,4)
    call Save_WriteBits(l_stream,0,1)
    call Save_WriteBits(l_stream,0,1)
    if(udg_MiracleStage[0]==-1)then
        // (l_pid) plus (1).
        call Save_WriteBits(l_stream,udg_MiracleStage[l_pid+1],2)
    else
        call Save_WriteBits(l_stream,udg_MiracleStage[0],2)
    endif
    call Save_WriteBits(l_stream,0,3)
    if l_isMinus then
        call Save_WriteBits(l_stream,1,1)
        call Save_WriteBits(l_stream,0,1)
        call Save_WriteBits(l_stream,0,1)
        // (l_pid) plus (1).
        set l_fileName=udg_PlayerName[l_pid+1]+" ngminus"
        call Save_Finish(l_stream,false)
    else
        if(l_ngLevel<5)then
            call Save_WriteBits(l_stream,1,1)
        else
            call Save_WriteBits(l_stream,0,1)
        endif
        call Save_PushForceFlag(l_stream,udg_LegendaryGuardianForce)
        // (l_pid) plus (1).
        set l_fileName=udg_PlayerName[l_pid+1]+" ngplus"+I2S(l_ngLevel)
        // Calculation 1:
        // (l_pid) plus (1).
        // Calculation 2:
        // (l_pid) plus (1).
        if(udg_Difficulty==5 or(udg_Difficulty==6 and(udg_CodeDifficulty[l_pid+1]==0 or udg_CodeDifficulty[l_pid+1]==3)))then
            call Save_WriteBits(l_stream,1,1)
        else
            call Save_WriteBits(l_stream,0,1)
        endif
        call Save_Finish(l_stream,l_hasArmory)
    endif
    call Save_WriteCodeFile(udg_SaveCodePlain[l_stream],p,l_fileName)
    call DisplayTimedTextToPlayer(p,0,0,30,"Trying to save in "+SubString(".\\FFERPG\\",2,StringLength(".\\FFERPG\\"))+l_fileName+".txt")
    call Save_WriteAndVerifyFile(udg_SaveCodePlain[l_stream],p,l_fileName)
    call Trig_Cmd_Load_Code_FreeReader(l_stream)
endfunction

function Save_OnSaveCommand takes nothing returns nothing
    if(not udg_GameRunning)then
        return
    endif
    if(not udg_HardcoreOff)then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Saving is disabled in Hardcore mode!")
        return
    endif
    call Save_WriteCode(GetTriggerPlayer(),false,"")
endfunction

function Save_OnNewGamePlus takes nothing returns nothing
    call Save_WriteNewGameCode(GetTriggerPlayer(),false)
endfunction

function Save_OnNewGameMinus takes nothing returns nothing
    call Save_WriteNewGameCode(GetTriggerPlayer(),true)
endfunction

function Save_CondNewGamePlus takes nothing returns boolean
    // (GetPlayerId(the triggering player)) plus (1).
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TitleForce[$E]))and(udg_NewGamePlusLevel[GetPlayerId(GetTriggerPlayer())+1]<$A)and( not(IsPlayerInForce(GetTriggerPlayer(),udg_CheaterForce))) // $E = 14; $A = 10
endfunction

function Save_CondNewGameMinus takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TitleForce[20]))and( not(IsPlayerInForce(GetTriggerPlayer(),udg_CheaterForce)))
endfunction

function Save_OnSaveToFile takes nothing returns nothing
    local string l_fileName
    if(not udg_GameRunning)then
        return
    endif
    if(not udg_HardcoreOff)then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Saving is disabled in Hardcore mode!")
        return
    endif
    set l_fileName=GetEventPlayerChatString()
    if(SubString(l_fileName,0,6)!="-savef")then
        set l_fileName=null
        return
    endif
    if(StringLength(l_fileName)>6)then
        if(SubString(l_fileName,6,7)!=" ")then
            set l_fileName=null
            return
        endif
        set l_fileName=Trig_Cmd_Load_Code_TrimSpaces(SubString(l_fileName,7,StringLength(l_fileName)))
    else
        set l_fileName=null
    endif
    call Save_WriteCode(GetTriggerPlayer(),true,l_fileName)
endfunction

function Save_Autosave takes nothing returns nothing
    if(IsPlayerInForce(Player(udg_AutosaveNextPlayer),udg_PlayingPlayers)and IsPlayerInForce(Player(udg_AutosaveNextPlayer),udg_AutosaveForce))then
        set udg_IsAutosave=TRUE
        call Save_WriteCode(Player(udg_AutosaveNextPlayer),true,"autosave")
        set udg_IsAutosave=FALSE
    endif
    // (udg_AutosaveNextPlayer) plus (1).
    if(udg_AutosaveNextPlayer+1>=udg_AutosavePlayerCount)then
        set udg_AutosaveNextPlayer=0
    else
        set udg_AutosaveNextPlayer=udg_AutosaveNextPlayer+1
    endif
endfunction

function Save_InitCommands takes nothing returns nothing
    local integer i=0
    set udg_SaveCommandTrig=CreateTrigger()
    loop
        call TriggerRegisterPlayerChatEvent(udg_SaveCommandTrig,Player(i),"-save",true)
        set i=i+1
        exitwhen i>7
    endloop
    call TriggerAddAction(udg_SaveCommandTrig,function Save_OnSaveCommand)
    set i=0
    if(udg_SaveToFileEnabled)then
        set udg_SaveToFileTrig=CreateTrigger()
        loop
            call TriggerRegisterPlayerChatEvent(udg_SaveToFileTrig,Player(i),"-savef",false)
            set i=i+1
            exitwhen i>7
        endloop
        call TriggerAddAction(udg_SaveToFileTrig,function Save_OnSaveToFile)
    endif
    set udg_AutosaveTimerTrig=CreateTrigger()
    call DisableTrigger(udg_AutosaveTimerTrig)
    call TriggerRegisterTimerEvent(udg_AutosaveTimerTrig,60.,true)
    call TriggerAddAction(udg_AutosaveTimerTrig,function Save_Autosave)
    set i=0
    set udg_NewGamePlusTrig=CreateTrigger()
    call DisableTrigger(udg_NewGamePlusTrig)
    loop
        call TriggerRegisterPlayerChatEvent(udg_NewGamePlusTrig,Player(i),"-newgameplus",true)
        set i=i+1
        exitwhen i>7
    endloop
    call TriggerAddCondition(udg_NewGamePlusTrig,Condition(function Save_CondNewGamePlus))
    call TriggerAddAction(udg_NewGamePlusTrig,function Save_OnNewGamePlus)
    set i=0
    set udg_NewGameMinusTrig=CreateTrigger()
    call DisableTrigger(udg_NewGameMinusTrig)
    loop
        call TriggerRegisterPlayerChatEvent(udg_NewGameMinusTrig,Player(i),"-newgameminus",true)
        set i=i+1
        exitwhen i>7
    endloop
    call TriggerAddCondition(udg_NewGameMinusTrig,Condition(function Save_CondNewGameMinus))
    call TriggerAddAction(udg_NewGameMinusTrig,function Save_OnNewGameMinus)
endfunction

function InitTrig_Save takes nothing returns nothing
endfunction

endlibrary

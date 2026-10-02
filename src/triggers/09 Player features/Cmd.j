library TCmd requires TForce, TJob, TMusic, TPlayerPart01
function Trig_Cmd_Load_Code_AllocReader takes integer v,player p returns integer
    set udg_ArgInt=v
    set udg_ArgPlayer=p
    call TriggerEvaluate(udg_CodeCreateTrig)
    return udg_RetInt
endfunction

function Trig_Cmd_Load_Code_FreeReader takes integer l_reader returns nothing
    if l_reader==null then
        return
    elseif(udg_SaveBufferNext[l_reader]!=-1)then
        return
    endif
    set udg_ArgIndex=l_reader
    call TriggerEvaluate(udg_CodeFreeTrig[udg_SaveStructKind[l_reader]])
    set udg_SaveBufferNext[l_reader]=udg_SaveBufferFreeHead
    set udg_SaveBufferFreeHead=l_reader
endfunction

function Trig_Cmd_Load_Code_ReadValue takes integer l_reader,integer l_bits returns integer
    set udg_ArgIndex=l_reader
    set udg_ArgInt=l_bits
    call TriggerEvaluate(udg_CodeReadIntTrig)
    return udg_RetInt
endfunction

function Trig_Cmd_Load_Code_NewReader takes integer v,player p returns integer
    local integer l_reader=Trig_Cmd_Load_Code_AllocReader(v,p)
    local integer l_newReader
    if(l_reader==0)then
        return 0
    endif
    set udg_SaveStructKind[l_reader]=7
    set l_newReader=l_reader
    set udg_CodeReadPos[l_reader]=0
    set udg_CodeArmoryPos[l_reader]=0
    set udg_CodeChecksum[l_reader]=0
    set udg_CodeFormatRead[l_reader]=""
    return l_reader
endfunction

function Trig_Cmd_Load_Code_ApplyJobLevel takes player l_owner,integer l_jobTypeId,integer l_level returns nothing
    local boolean lm
    local integer i
    local unit l_jobHero=LoadUnitHandle(udg_JobHeroHash,l_jobTypeId,GetPlayerId(l_owner))
    local integer l_oldLevel=GetHeroLevel(l_jobHero)
    // (GetPlayerId(l_owner)) plus (1).
    if(l_level>udg_HighestJobLevel[GetPlayerId(l_owner)+1])then
        // (GetPlayerId(l_owner)) plus (1).
        set udg_HighestJobLevel[GetPlayerId(l_owner)+1]=l_level
    endif
    // Calculation 1:
    // (GetPlayerId(l_owner)) plus (1).
    // Calculation 2:
    // ((udg_TotalJobLevel at position (GetPlayerId(l_owner)) plus (1)) plus (l_level)) minus (l_oldLevel).
    set udg_TotalJobLevel[GetPlayerId(l_owner)+1]=udg_TotalJobLevel[GetPlayerId(l_owner)+1]+l_level-l_oldLevel
    if(l_jobTypeId=='H002' and l_level>=50)then // 'H002': unit "Chemist"
        set i=1
        loop
            exitwhen i>$A // $A = 10
            call SetPlayerAbilityAvailable(l_owner,udg_BrewAbility[i],true)
            set i=i+1
        endloop
    endif
    if(l_jobHero!=null)then
        if(l_level>='d')then
            call SetUnitAbilityLevel(l_jobHero,'A02F',4) // 'A02F': ability "Mastery"
            if(l_oldLevel<50)then
                // (Strength of l_jobHero) plus (100).
                call SetHeroStr(l_jobHero,GetHeroStr(l_jobHero,false)+'d',true)
                // (Agility of l_jobHero) plus (100).
                call SetHeroAgi(l_jobHero,GetHeroAgi(l_jobHero,false)+'d',true)
                // (Intelligence of l_jobHero) plus (100).
                call SetHeroInt(l_jobHero,GetHeroInt(l_jobHero,false)+'d',true)
            elseif(l_oldLevel<99)then
                // (Strength of l_jobHero) plus (80).
                call SetHeroStr(l_jobHero,GetHeroStr(l_jobHero,false)+80,true)
                // (Agility of l_jobHero) plus (80).
                call SetHeroAgi(l_jobHero,GetHeroAgi(l_jobHero,false)+80,true)
                // (Intelligence of l_jobHero) plus (80).
                call SetHeroInt(l_jobHero,GetHeroInt(l_jobHero,false)+80,true)
            else
                // (Strength of l_jobHero) plus (50).
                call SetHeroStr(l_jobHero,GetHeroStr(l_jobHero,false)+50,true)
                // (Agility of l_jobHero) plus (50).
                call SetHeroAgi(l_jobHero,GetHeroAgi(l_jobHero,false)+50,true)
                // (Intelligence of l_jobHero) plus (50).
                call SetHeroInt(l_jobHero,GetHeroInt(l_jobHero,false)+50,true)
            endif
            set l_level=99
        elseif(l_level==99)then
            call SetUnitAbilityLevel(l_jobHero,'A02F',3) // 'A02F': ability "Mastery"
            if(l_oldLevel<50)then
                // (Strength of l_jobHero) plus (50).
                call SetHeroStr(l_jobHero,GetHeroStr(l_jobHero,false)+50,true)
                // (Agility of l_jobHero) plus (50).
                call SetHeroAgi(l_jobHero,GetHeroAgi(l_jobHero,false)+50,true)
                // (Intelligence of l_jobHero) plus (50).
                call SetHeroInt(l_jobHero,GetHeroInt(l_jobHero,false)+50,true)
            else
                // (Strength of l_jobHero) plus (30).
                call SetHeroStr(l_jobHero,GetHeroStr(l_jobHero,false)+30,true)
                // (Agility of l_jobHero) plus (30).
                call SetHeroAgi(l_jobHero,GetHeroAgi(l_jobHero,false)+30,true)
                // (Intelligence of l_jobHero) plus (30).
                call SetHeroInt(l_jobHero,GetHeroInt(l_jobHero,false)+30,true)
            endif
        elseif(l_level>=50)then
            call SetUnitAbilityLevel(l_jobHero,'A02F',2) // 'A02F': ability "Mastery"
            // (Strength of l_jobHero) plus (20).
            call SetHeroStr(l_jobHero,GetHeroStr(l_jobHero,false)+20,true)
            // (Agility of l_jobHero) plus (20).
            call SetHeroAgi(l_jobHero,GetHeroAgi(l_jobHero,false)+20,true)
            // (Intelligence of l_jobHero) plus (20).
            call SetHeroInt(l_jobHero,GetHeroInt(l_jobHero,false)+20,true)
        endif
        call SetHeroLevel(l_jobHero,l_level,false)
        call Job_MaxSkills(l_jobHero)
        if(IsPlayerInForce(l_owner,udg_CheaterForce))then
            call SetHeroStr(l_jobHero,5,true)
            call SetHeroAgi(l_jobHero,5,true)
            call SetHeroInt(l_jobHero,5,true)
        endif
        set l_jobHero=null
    else
        call SaveInteger(udg_JobLevelHash,l_jobTypeId,GetPlayerId(l_owner),l_level)
    endif
    if(l_oldLevel<99 and l_level>=99)then
        // (GetPlayerState(l_owner, PLAYER_STATE_RESOURCE_FOOD_USED)) plus (1).
        call SetPlayerState(l_owner,PLAYER_STATE_RESOURCE_FOOD_USED,(GetPlayerState(l_owner,PLAYER_STATE_RESOURCE_FOOD_USED)+1))
    endif
endfunction

function Trig_Cmd_Music_PlayCurrentTrack takes player p returns nothing
    local boolean l_useCustom=udg_MusicUseCustom[GetPlayerId(p)]
    local string l_track
    local integer l_idx
    if udg_MusicSpecialTrack==0 then
        set l_idx=udg_MusicZoneTrack
    else
        set l_idx=udg_MusicSpecialTrack
    endif
    if l_useCustom then
        set l_track=udg_MusicCustomTrack[l_idx]
    else
        set l_track=udg_MusicBlizzTrack[l_idx]
    endif
    call Music_PlayTrack(p,l_track,l_useCustom,false)
endfunction

function Trig_Cmd_Music_NormalizePath takes string in returns string
    local string l_outPath=""
    local integer i=0
    local integer l_len=StringLength(in)
    local string l_ch
    loop
        exitwhen i>=l_len
        // (i) plus (1).
        set l_ch=SubString(in,i,i+1)
        if l_ch=="/" then
            set l_outPath=l_outPath+"\\"
        // Calculation 1:
        // (i) plus (1).
        // Calculation 2:
        // (i) plus (2).
        elseif(l_ch=="\\" and SubString(in,i+1,i+2)!="\\")then
            set l_outPath=l_outPath+"\\"
        else
            set l_outPath=l_outPath+l_ch
        endif
        set i=i+1
    endloop
    set l_len=StringLength(l_outPath)
    if(l_len<2)then
        return""
    // (l_len) minus (2).
    elseif(SubString(l_outPath,l_len-2,l_len)=="\\")then
        return l_outPath
    else
        return l_outPath+"\\"
    endif
endfunction

function Trig_Cmd_Music_SetMusicPath takes player p,string l_path returns nothing
    local integer i=GetPlayerId(p)
    set udg_MusicPathPrefix[i]=Trig_Cmd_Music_NormalizePath(l_path)
    if(udg_MusicPathPrefix[i]=="")then
        set udg_MusicUseCustom[i]=false
        call DisplayTimedTextToPlayer(p,0,0,20,"Invalid path, using native music.")
    else
        set udg_MusicUseCustom[i]=true
        call DisplayTimedTextToPlayer(p,0,0,20,"Path for custom music set to: "+l_path)
    endif
    if udg_MusicEnabled[i]then
        call Trig_Cmd_Music_PlayCurrentTrack(p)
    endif
endfunction

function Trig_Cmd_Music_ResetMusicPath takes player p returns nothing
    local integer i=GetPlayerId(p)
    set udg_MusicUseCustom[i]=false
    set udg_MusicPathPrefix[i]=""
    if udg_MusicEnabled[i]then
        call Trig_Cmd_Music_PlayCurrentTrack(p)
    endif
endfunction

function Trig_Cmd_Load_Code_CharToValue takes string l_ch returns integer
    local integer l_value
    set l_value=LoadInteger(udg_CodeCharIndex,0,StringHash(l_ch))
    if(l_value<52)and(StringCase(l_ch,true)==l_ch)then
        // Decrease l_value by 26.
        set l_value=l_value-26
    endif
    return l_value
endfunction

function Trig_Cmd_Load_Code_TrimSpaces takes string s returns string
    local integer i=0
    local integer l_len=StringLength(s)
    loop
        if(i>=l_len)then
            return""
        endif
        // (i) plus (1).
        exitwhen SubString(s,i,i+1)!=" "
        set i=i+1
    endloop
    set s=SubString(s,i,l_len)
    set i=StringLength(s)
    loop
        // (i) minus (1).
        exitwhen SubString(s,i-1,i)!=" "
        set i=i-1
    endloop
    set s=SubString(s,0,i)
    return s
endfunction

function Trig_Cmd_Load_Code_Checksum takes integer l_reader,string l_text returns integer
    local integer l_sum=$2EA5 // $2EA5 = 11941
    local integer i=0
    local integer l_len=StringLength(l_text)
    loop
        // Calculation 1:
        // (i) plus (1).
        // Calculation 2:
        // (i) plus (1).
        exitwhen(i>=l_len or(SubString(l_text,i,i+1)=="(" or SubString(l_text,i,i+1)==")"))
        // (l_sum) plus (Trig_Cmd_Load_Code_CharToValue(SubString(l_text, i, (i) plus (1)))).
        set l_sum=l_sum+Trig_Cmd_Load_Code_CharToValue(SubString(l_text,i,i+1))
        set i=i+1
    endloop
    if(l_sum>udg_Pow2[18])then
        // (l_sum) minus (((l_sum) divided by (udg_Pow2 at position 18); drop the remainder) times (udg_Pow2 at
        // position 18)).
        set l_sum=l_sum-(l_sum/ udg_Pow2[18])*udg_Pow2[18]
    endif
    return l_sum
endfunction

function Trig_Cmd_Load_Code_ExpectedChecksum takes integer l_reader returns integer
    return Trig_Cmd_Load_Code_Checksum(l_reader,udg_SaveCodePlain[l_reader])
endfunction

function Trig_Cmd_Load_Code_PlayerNameHash takes integer l_reader returns integer
    // Starting value for l_hash:
    // Result 1: (GetPlayerId(udg_SavePlayer at position l_reader)) plus (1).
    // Result 2: the size of (StringHash(udg_PlayerName at position result 1)) without its sign; for example, -5
    // becomes 5.
    local integer l_hash=IAbsBJ(StringHash(udg_PlayerName[GetPlayerId(udg_SavePlayer[l_reader])+1]))
    // Result 1: (l_hash) divided by (udg_Pow2 at position 20); drop the remainder.
    // Result 2: (result 1) times (udg_Pow2 at position 20).
    // Result 3: (l_hash) minus (result 2).
    return(l_hash-(l_hash/ udg_Pow2[20])*udg_Pow2[20])
endfunction

function Trig_Cmd_Load_Code_OpenCode takes player p,string l_code returns integer
    local integer l=Trig_Cmd_Load_Code_NewReader(Trig_Cmd_Load_Code_CharToValue(SubString(l_code,0,1)),p)
    local integer i=1
    set udg_SaveCodePlain[l]=SubString(l_code,4,StringLength(l_code))
    loop
        exitwhen i>3
        // Result 1: (udg_CodeChecksum at position l) times (64).
        // Result 2: (i) plus (1).
        // Result 3: (result 1) plus (Trig_Cmd_Load_Code_CharToValue(SubString(l_code, i, result 2))).
        set udg_CodeChecksum[l]=udg_CodeChecksum[l]*64+Trig_Cmd_Load_Code_CharToValue(SubString(l_code,i,i+1))
        set i=i+1
    endloop
    if(udg_CodeChecksum[l]!=Trig_Cmd_Load_Code_ExpectedChecksum(l))then
        call DisplayTimedTextToPlayer(p,0,0,30,"Code: "+l_code+"\r\n|cFFFF0000Checksum Error!|r Make sure the code is correctly pasted and try again.")
        call Trig_Cmd_Load_Code_FreeReader(l)
        return 0
    endif
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Name")
    endif
    if(Trig_Cmd_Load_Code_ReadValue(l,20)!=Trig_Cmd_Load_Code_PlayerNameHash(l))then
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000This code belongs to a different player!|r")
        call Trig_Cmd_Load_Code_FreeReader(l)
        return 0
    endif
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Difficulty")
    endif
    set i=Trig_Cmd_Load_Code_ReadValue(l,2)
    if udg_Difficulty==6 then
        // (GetPlayerId(p)) plus (1).
        set udg_CodeDifficulty[GetPlayerId(p)+1]=i
    elseif(udg_Difficulty>1 and i>0 and((udg_Difficulty==5 and i<3)or i<2))then
        if udg_Difficulty==5 then
            call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000You cannot load a code from a lower difficulty level in Inferno mode!|r")
        else
            call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000You cannot load a code from Simple mode on higher difficulties!|r")
        endif
        call Trig_Cmd_Load_Code_FreeReader(l)
        return 0
    endif
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gold")
    endif
    call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,Trig_Cmd_Load_Code_ReadValue(l,20))
    return l
endfunction

function Trig_Cmd_Load_Code_GetCodeChecksum takes integer l_reader returns integer
    return udg_CodeChecksum[l_reader]
endfunction

function Trig_Cmd_Load_Code_ArmoryChecksum takes integer l_reader returns integer
    // Calculation 1:
    // (udg_CodeArmoryPos at position l_reader) plus (3).
    // Calculation 2:
    // (StringLength(udg_SaveCodePlain at position l_reader)) minus (1).
    return Trig_Cmd_Load_Code_Checksum(l_reader,SubString(udg_SaveCodePlain[l_reader],udg_CodeArmoryPos[l_reader]+3,StringLength(udg_SaveCodePlain[l_reader])-1))
endfunction

function Trig_Cmd_Load_Code_ArmoryHeader takes integer l_reader returns string
    // (udg_CodeArmoryPos at position l_reader) plus (6).
    return SubString(udg_SaveCodePlain[l_reader],udg_CodeArmoryPos[l_reader],udg_CodeArmoryPos[l_reader]+6)
endfunction

function Trig_Cmd_Load_Code_ReadBits takes integer l_reader,integer l_bits returns integer
    local integer l_value
    local integer i=0
    if l_bits<=9 then
        set udg_CodeFormatRead[l_reader]=udg_CodeFormatRead[l_reader]+I2S(l_bits)
    else
        // Calculation 1:
        // (l_bits) minus (10).
        // Calculation 2:
        // (l_bits) minus (9).
        set udg_CodeFormatRead[l_reader]=udg_CodeFormatRead[l_reader]+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_bits-$A,l_bits-9) // $A = 10
    endif
    loop
        exitwhen udg_CodeBits[l_reader]>=l_bits
        // Result 1: (udg_CodeBuffer at position l_reader) times (64).
        // Result 2: (udg_CodeReadPos at position l_reader) plus (1).
        // Result 3: (result 1) plus (Trig_Cmd_Load_Code_CharToValue(SubString(udg_SaveCodePlain at position l_reader,
        // udg_CodeReadPos at position l_reader, result 2))).
        set udg_CodeBuffer[l_reader]=udg_CodeBuffer[l_reader]*64+Trig_Cmd_Load_Code_CharToValue(SubString(udg_SaveCodePlain[l_reader],udg_CodeReadPos[l_reader],udg_CodeReadPos[l_reader]+1))
        set udg_CodeReadPos[l_reader]=udg_CodeReadPos[l_reader]+1
        // Increase udg_CodeBits at position l_reader by 6.
        set udg_CodeBits[l_reader]=udg_CodeBits[l_reader]+6
    endloop
    // (udg_CodeBits at position l_reader) minus (l_bits).
    set udg_CodeBits[l_reader]=udg_CodeBits[l_reader]-l_bits
    // Result 1: (udg_CodeBuffer at position l_reader) divided by (udg_Pow2 at position udg_CodeBits at position
    // l_reader); drop the remainder.
    set l_value=udg_CodeBuffer[l_reader]/ udg_Pow2[udg_CodeBits[l_reader]]
    // Result 1: (l_value) times (udg_Pow2 at position udg_CodeBits at position l_reader).
    // Result 2: (udg_CodeBuffer at position l_reader) minus (result 1).
    set udg_CodeBuffer[l_reader]=udg_CodeBuffer[l_reader]-l_value*udg_Pow2[udg_CodeBits[l_reader]]
    // Result 1: (udg_CodeKey at position l_reader) divided by (udg_Pow2 at position l_bits); drop the remainder.
    // Result 2: (result 1) times (udg_Pow2 at position l_bits).
    // Result 3: (udg_CodeKey at position l_reader) minus (result 2).
    // Result 4: (l_value) minus (result 3).
    set l_value=l_value-(udg_CodeKey[l_reader]-(udg_CodeKey[l_reader]/ udg_Pow2[l_bits])*udg_Pow2[l_bits])
    if(l_value<0)then
        // (l_value) plus (udg_Pow2 at position l_bits).
        set l_value=l_value+udg_Pow2[l_bits]
    endif
    // Increase udg_CodeKey at position l_reader by 211.
    set udg_CodeKey[l_reader]=udg_CodeKey[l_reader]+$D3 // $D3 = 211
    if false then
        call DisplayTimedTextToPlayer(udg_SavePlayer[l_reader],0,0,60,"Val "+I2S(l_value)+" ["+I2S(l_bits)+"]")
    endif
    return l_value
endfunction

function Trig_Cmd_Load_Code_FlushBits takes integer l_reader returns nothing
    if(udg_CodeBits[l_reader]>0)then
        call Trig_Cmd_Load_Code_ReadBits(l_reader,udg_CodeBits[l_reader])
    endif
endfunction

function Trig_Cmd_Load_Code_SeekArmory takes integer l_reader returns boolean
    local string l_ch
    // (udg_CodeReadPos at position l_reader) plus (1).
    set l_ch=SubString(udg_SaveCodePlain[l_reader],udg_CodeReadPos[l_reader],udg_CodeReadPos[l_reader]+1)
    if l_ch=="(" then
        set udg_CodeReadPos[l_reader]=udg_CodeReadPos[l_reader]+1
        set udg_CodeArmoryPos[l_reader]=udg_CodeReadPos[l_reader]
        return true
    else
        return false
    endif
endfunction

function Trig_Cmd_Load_Armory_AttachArmory takes integer l_reader,string l_code returns boolean
    set udg_SaveCodePlain[l_reader]=SubString(udg_SaveCodePlain[l_reader],0,udg_CodeReadPos[l_reader])+"("+l_code+")"
    return Trig_Cmd_Load_Code_SeekArmory(l_reader)
endfunction

function Trig_Cmd_Load_Code_ReadLevelCapFlag takes integer l_reader returns nothing
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        set udg_CodeCapFlag[l_reader]=TRUE
    else
        set udg_CodeCapFlag[l_reader]=FALSE
    endif
endfunction

function Trig_Cmd_Load_Code_ReadUpgradeCapFlag takes integer l_reader returns nothing
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        set udg_CodeCapFlag[l_reader]=TRUE
    else
        set udg_CodeCapFlag[l_reader]=FALSE
    endif
endfunction

function Trig_Cmd_Load_Code_ReadLevel takes integer l_reader returns integer
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        if(udg_CodeCapFlag[l_reader])then
            if(udg_SaveVersion[l_reader]<=Trig_Cmd_Load_Code_CharToValue("F"))then
                return 99
            else
                // (Trig_Cmd_Load_Code_ReadBits(l_reader, 1)) plus (99).
                return Trig_Cmd_Load_Code_ReadBits(l_reader,1)+99
            endif
        else
            return 0
        endif
    else
        return Trig_Cmd_Load_Code_ReadBits(l_reader,7)
    endif
endfunction

function Trig_Cmd_Load_Code_LoadJobLevel takes integer l_reader,integer l_jobTypeId returns nothing
    call Trig_Cmd_Load_Code_ApplyJobLevel(udg_SavePlayer[l_reader],l_jobTypeId,Trig_Cmd_Load_Code_ReadLevel(l_reader))
endfunction

function Trig_Cmd_Load_Code_LoadHeroLevel takes integer l_reader,unit u returns nothing
    call SetHeroLevel(u,Trig_Cmd_Load_Code_ReadLevel(l_reader),false)
endfunction

function Trig_Cmd_Load_Code_LoadInventory takes integer l_reader,unit u returns nothing
    local integer i=0
    local real x=GetUnitX(u)
    local real y=GetUnitY(u)
    // Starting value for l_pid:
    // (GetPlayerId(udg_SavePlayer at position l_reader)) plus (1).
    local integer l_pid=GetPlayerId(udg_SavePlayer[l_reader])+1
    local integer l_itemCount=Trig_Cmd_Load_Code_ReadBits(l_reader,3)
    local integer l_itemIndex
    local item l_itm
    loop
        call UnitRemoveItemFromSlot(u,i)
        set i=i+1
        exitwhen i>=bj_MAX_INVENTORY
    endloop
    set i=0
    loop
        exitwhen i>=l_itemCount
        set l_itemIndex=Trig_Cmd_Load_Code_ReadBits(l_reader,9)
        if false then
            call DisplayTimedTextToPlayer(udg_SavePlayer[l_reader],0,0,60,"Load: Inventory Item #"+I2S(i)+": "+I2S(l_itemIndex))
        endif
        set l_itm=CreateItem(udg_ItemIdTable[l_itemIndex],x,y)
        if not(IsPlayerInForce(Player(9),udg_SaveFlagForce[l_itemIndex])and(udg_SaveVersion[l_reader]<=Trig_Cmd_Load_Code_CharToValue("F")))then
            if(GetItemType(l_itm)==ITEM_TYPE_CHARGED)then
                call SetItemCharges(l_itm,Trig_Cmd_Load_Code_ReadBits(l_reader,7))
            endif
            call SetItemUserData(l_itm,l_pid)
            if(not UnitAddItem(u,l_itm))and false then
                call DisplayTimedTextToPlayer(udg_SavePlayer[l_reader],0,0,60,"UnitAddItem Fail")
            endif
        else
            if(GetItemType(l_itm)==ITEM_TYPE_CHARGED)then
                call Trig_Cmd_Load_Code_ReadBits(l_reader,7)
            endif
            call RemoveItem(l_itm)
        endif
        set i=i+1
    endloop
endfunction

function Trig_Cmd_Load_Code_LoadUpgrade takes integer l_reader,integer l_techId returns nothing
    call SetPlayerTechResearched(udg_SavePlayer[l_reader],l_techId,Trig_Cmd_Load_Code_ReadBits(l_reader,4))
endfunction

function Trig_Cmd_Load_Code_LoadUpgradeCapped takes integer l_reader,integer l_techId returns nothing
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        if(udg_CodeCapFlag[l_reader])then
            call SetPlayerTechResearched(udg_SavePlayer[l_reader],l_techId,$A) // $A = 10
        endif
    else
        call SetPlayerTechResearched(udg_SavePlayer[l_reader],l_techId,Trig_Cmd_Load_Code_ReadBits(l_reader,4))
    endif
endfunction

function Trig_Cmd_Load_Code_LoadForceFlag takes integer l_reader,force f returns nothing
    if Trig_Cmd_Load_Code_ReadBits(l_reader,1)>0 then
        call ForceAddPlayer(f,udg_SavePlayer[l_reader])
    endif
    set f=null
endfunction

function Trig_Cmd_Load_Code_LoadArmory takes integer l_reader,player p returns nothing
    local integer i=0
    local integer l_runLeft=0
    local integer l_runMode=2
    local string l_bitLog=""
    local string l_rawLog=""
    local string l_runLog=""
    local string l_header=Trig_Cmd_Load_Code_ArmoryHeader(l_reader)
    local integer l_sum=0
    local integer l_owned=0
    loop
        exitwhen i>=3
        // ((l_sum) times (64)) plus (Trig_Cmd_Load_Code_CharToValue(SubString(l_header, i, (i) plus (1)))).
        set l_sum=l_sum*64+Trig_Cmd_Load_Code_CharToValue(SubString(l_header,i,i+1))
        set i=i+1
    endloop
    if(l_sum!=Trig_Cmd_Load_Code_ArmoryChecksum(l_reader))then
        call DisplayTimedTextToPlayer(p,0,0,60,"|cFFFF0000Armory Code Checksum Error!|r Make sure the code is correctly pasted and then use command \"-loada (code)\" with |cFFFFCC00only the part of the code in brackets ()|r to load your armory.")
        return
    endif
    set l_sum=0
    loop
        exitwhen i>=6
        // ((l_sum) times (64)) plus (Trig_Cmd_Load_Code_CharToValue(SubString(l_header, i, (i) plus (1)))).
        set l_sum=l_sum*64+Trig_Cmd_Load_Code_CharToValue(SubString(l_header,i,i+1))
        set i=i+1
    endloop
    if(l_sum!=Trig_Cmd_Load_Code_GetCodeChecksum(l_reader))then
        call DisplayTimedTextToPlayer(p,0,0,60,"Armory subcode does not belong with this code!")
        return
    endif
    set udg_ArmoryCodeSegment[GetPlayerId(p)]=0
    call Trig_Cmd_Load_Code_ReadBits(l_reader,18)
    call Trig_Cmd_Load_Code_ReadBits(l_reader,18)
    set i=1
    loop
        exitwhen i>udg_SaveFlagCount
        if udg_SaveFlagUnitID[i]!=null then
            if(l_runLeft<=0)then
                if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
                    set l_runMode=Trig_Cmd_Load_Code_ReadBits(l_reader,1)
                    set l_runLeft=Trig_Cmd_Load_Code_ReadBits(l_reader,6)
                    set l_rawLog=l_rawLog+"1"+I2S(l_runMode)+"YY"+I2S(l_runLeft)+"Y"
                    set l_runLog=l_runLog+"R"+I2S(l_runMode)+"("+I2S(l_runLeft)+")-"
                else
                    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==0)then
                        if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==0)then
                            set l_rawLog=l_rawLog+"000"
                            set l_runLog=l_runLog+"X"
                            // (GetPlayerId(p)) plus (1).
                            set udg_ArmoryItemCount[GetPlayerId(p)+1]=l_owned
                            call Trig_Cmd_Load_Code_FreeReader(l_reader)
                            call DisplayTimedTextToPlayer(p,0,0,$A,"Armory loaded.") // $A = 10
                            set udg_TempPlayer=p
                            call ConditionalTriggerExecute(gg_trg_Title_ArmsCollection)
                            set p=null
                            return
                        else
                            set l_rawLog=l_rawLog+"001"
                            set l_bitLog=l_bitLog+"1"
                            set l_runLog=l_runLog+"O-"
                            set l_owned=l_owned+1
                            call ForceAddPlayer(udg_SaveFlagForce[i],p)
                        endif
                    else
                        set l_runMode=2
                        set l_runLeft=Trig_Cmd_Load_Code_ReadBits(l_reader,8)
                        set l_rawLog=l_rawLog+"01XXXXX"+I2S(l_runLeft)+"X"
                        set l_runLog=l_runLog+"E("+I2S(l_runLeft)+")-"
                    endif
                endif
            endif
            if(l_runLeft>0)then
                set l_runLeft=l_runLeft-1
                if(l_runMode==2)then
                    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
                        set l_owned=l_owned+1
                        call ForceAddPlayer(udg_SaveFlagForce[i],p)
                        set l_bitLog=l_bitLog+"1"
                    else
                        set l_bitLog=l_bitLog+"0"
                    endif
                elseif(l_runMode==1)then
                    set l_owned=l_owned+1
                    call ForceAddPlayer(udg_SaveFlagForce[i],p)
                    set l_bitLog=l_bitLog+"1"
                else
                    set l_bitLog=l_bitLog+"0"
                endif
            endif
        endif
        set i=i+1
    endloop
    // (GetPlayerId(p)) plus (1).
    set udg_ArmoryItemCount[GetPlayerId(p)+1]=l_owned
    call Trig_Cmd_Load_Code_FreeReader(l_reader)
    call DisplayTimedTextToPlayer(p,0,0,$A,"Armory load successful.") // $A = 10
    set udg_TempPlayer=p
    call ConditionalTriggerExecute(gg_trg_Title_ArmsCollection)
    set p=null
endfunction

function Trig_Cmd_Load_Code_LoadArmoryLegacy takes integer l_reader,player p returns nothing
    local integer i=0
    call Trig_Cmd_Load_Code_LoadArmory(l_reader,p)
    loop
        exitwhen i>udg_SaveFlagCount
        if IsPlayerInForce(Player(9),udg_SaveFlagForce[i])then
            call ForceRemovePlayer(udg_SaveFlagForce[i],p)
        endif
        set i=i+1
    endloop
endfunction

function Trig_Cmd_Load_Code_LoadCodeV3 takes string l_code,player p,boolean l_withArmory returns nothing
    local integer l_reader=Trig_Cmd_Load_Code_OpenCode(p,l_code)
    local integer i=0
    local integer l_pid=GetPlayerId(p)
    local integer l_value
    local boolean l_gayaMastered
    local integer l_ngPlusBits=0
    local boolean l_armoryBlocked=false
    if(l_reader==0)then
        return
    endif
    set l_gayaMastered=(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)
    set l_ngPlusBits=Trig_Cmd_Load_Code_ReadBits(l_reader,1)
    call Trig_Cmd_Load_Code_ReadLevelCapFlag(l_reader)
    loop
        exitwhen i>=udg_JobCount
        call Trig_Cmd_Load_Code_LoadJobLevel(l_reader,udg_JobUnitType[i])
        set i=i+1
    endloop
    set l_value=Trig_Cmd_Load_Code_ReadLevel(l_reader)
    if(l_value>0)then
        // (l_pid) plus (1).
        if(udg_FreelancerHero[l_pid+1]==null)then
            // (l_pid) plus (1).
            set udg_FreelancerHero[l_pid+1]=Job_GetHero(p,'H02L') // 'H02L': unit "Freelancer"
            // (l_pid) plus (1).
            call SetUnitOwner(udg_FreelancerHero[l_pid+1],Player(PLAYER_NEUTRAL_PASSIVE),true)
            // (l_pid) plus (1).
            call SetUnitPosition(udg_FreelancerHero[l_pid+1],GetPlayerStartLocationX(p),GetPlayerStartLocationY(p))
        endif
        // (l_pid) plus (1).
        if(l_value>=99 and GetHeroLevel(udg_FreelancerHero[l_pid+1])<99)then
            // (GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED)) plus (1).
            call SetPlayerState(p,PLAYER_STATE_RESOURCE_FOOD_USED,(GetPlayerState(p,PLAYER_STATE_RESOURCE_FOOD_USED)+1))
        endif
        // (l_pid) plus (1).
        call SetHeroLevel(udg_FreelancerHero[l_pid+1],l_value,false)
        if(l_value>='d')then
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_FreelancerHero[l_pid+1],'A02F',4) // 'A02F': ability "Mastery"
        elseif(l_value>=99)then
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_FreelancerHero[l_pid+1],'A02F',3) // 'A02F': ability "Mastery"
        elseif(l_value>=50)then
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_FreelancerHero[l_pid+1],'A02F',2) // 'A02F': ability "Mastery"
        endif
    endif
    if(l_gayaMastered)then
        if false then
            call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gaya Mastered")
        endif
        // (l_pid) plus (1).
        call SetHeroLevel(udg_SpiritOfGaya[l_pid+1],99,false)
        call SetPlayerTechResearched(p,'Resi',1) // 'Resi': upgrade "Buy from Pandaren Spiritualist (1500 Gold + 1 Shard)"
        call SetPlayerTechResearched(p,'R00F',1) // 'R00F': upgrade "Buy from Pandaren Spiritualist (3000 Gold + 1 Shard)"
        call SetPlayerTechResearched(p,'R00G',1) // 'R00G': upgrade "Buy from Pandaren Spiritualist (6000 Gold + 1 Shard)"
        // (l_pid) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A0B4',3) // 'A0B4': ability "Break Stun"
        // (l_pid) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02K',3) // 'A02K': ability "Mana Transfer"
        // (l_pid) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02L',3) // 'A02L': ability "Mega Heal"
        call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
        // (l_pid) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F',8) // 'A10F': ability "Spiritual Power"
        // (l_pid) plus (1).
        call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'A058') // 'A058': ability "Tarugaya"
        // (l_pid) plus (1).
        call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'S004') // 'S004': ability "Sukugaya"
        // (l_pid) plus (1).
        call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'A07E') // 'A07E': ability "Rakugaya"
    else
        // (l_pid) plus (1).
        call Trig_Cmd_Load_Code_LoadHeroLevel(l_reader,udg_SpiritOfGaya[l_pid+1])
        if false then
            call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gaya Skill Breakstun-Manatransfer-Megaheal")
        endif
        set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
        if(l_value>0)then
            call SetPlayerTechResearched(p,'Resi',1) // 'Resi': upgrade "Buy from Pandaren Spiritualist (1500 Gold + 1 Shard)"
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A0B4',l_value) // 'A0B4': ability "Break Stun"
        endif
        set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
        if(l_value>0)then
            call SetPlayerTechResearched(p,'R00F',1) // 'R00F': upgrade "Buy from Pandaren Spiritualist (3000 Gold + 1 Shard)"
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02K',l_value) // 'A02K': ability "Mana Transfer"
        endif
        set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
        if(l_value>0)then
            call SetPlayerTechResearched(p,'R00G',1) // 'R00G': upgrade "Buy from Pandaren Spiritualist (6000 Gold + 1 Shard)"
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02L',l_value) // 'A02L': ability "Mega Heal"
        endif
        if false then
            call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gaya Skill Taru-Suku-Raku")
        endif
        if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
            // (l_pid) plus (1).
            call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'A058') // 'A058': ability "Tarugaya"
            call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
            // Calculation 1:
            // (l_pid) plus (1).
            // Calculation 2:
            // (GetUnitAbilityLevel(udg_SpiritOfGaya at position (l_pid) plus (1), 'A10F')) plus (1).
            call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F',GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F')+1) // 'A10F': ability "Spiritual Power"
        endif
        if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
            // (l_pid) plus (1).
            call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'S004') // 'S004': ability "Sukugaya"
            call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
            // Calculation 1:
            // (l_pid) plus (1).
            // Calculation 2:
            // (GetUnitAbilityLevel(udg_SpiritOfGaya at position (l_pid) plus (1), 'A10F')) plus (2).
            call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F',GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F')+2) // 'A10F': ability "Spiritual Power"
        endif
        if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
            // (l_pid) plus (1).
            call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'A07E') // 'A07E': ability "Rakugaya"
            call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
            // Calculation 1:
            // (l_pid) plus (1).
            // Calculation 2:
            // (GetUnitAbilityLevel(udg_SpiritOfGaya at position (l_pid) plus (1), 'A10F')) plus (4).
            call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F',GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F')+4) // 'A10F': ability "Spiritual Power"
        endif
    endif
    // (l_ngPlusBits) plus ((Trig_Cmd_Load_Code_ReadBits(l_reader, 1)) times (4)).
    set l_ngPlusBits=l_ngPlusBits+(Trig_Cmd_Load_Code_ReadBits(l_reader,1)*4)
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Hero Inventory")
    endif
    call Trig_Cmd_Load_Code_LoadInventory(l_reader,Player_GetHero(p))
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gaya Inventory")
    endif
    // (l_pid) plus (1).
    call Trig_Cmd_Load_Code_LoadInventory(l_reader,udg_SpiritOfGaya[l_pid+1])
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: House Inventory")
    endif
    // (l_pid) plus (1).
    call Trig_Cmd_Load_Code_LoadInventory(l_reader,udg_PlayerHouse[l_pid+1])
    call Trig_Cmd_Load_Code_ReadUpgradeCapFlag(l_reader)
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Upgrades Tools-Sword-Bow-Rod-Staff")
    endif
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R000') // 'R000': upgrade "Tools"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R001') // 'R001': upgrade "Sword"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R002') // 'R002': upgrade "Bow"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R003') // 'R003': upgrade "Rod"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R004') // 'R004': upgrade "Staff"
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Upgrades Plate-Leather-Mystic-Axe-Spear")
    endif
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R005') // 'R005': upgrade "Plate Armor"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R006') // 'R006': upgrade "Leather Armor"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R007') // 'R007': upgrade "Mystic Armor"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R008') // 'R008': upgrade "Axe"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R009') // 'R009': upgrade "Spear"
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Upgrades Katana-Dagger-Gun-Greatsword-Inner")
    endif
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R00A') // 'R00A': upgrade "Katana"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R00B') // 'R00B': upgrade "Dagger"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R00M') // 'R00M': upgrade "Gun"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R00N') // 'R00N': upgrade "Greatsword"
    call Trig_Cmd_Load_Code_LoadUpgradeCapped(l_reader,'R00L') // 'R00L': upgrade "Inner Mana"
    // (l_ngPlusBits) plus ((Trig_Cmd_Load_Code_ReadBits(l_reader, 1)) times (2)).
    set l_ngPlusBits=l_ngPlusBits+(Trig_Cmd_Load_Code_ReadBits(l_reader,1)*2)
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[18])
    call Trig_Cmd_Load_Code_ReadBits(l_reader,1)
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if(l_value>=1)then
        call ForceAddPlayer(udg_TitleForce[$F],p) // $F = 15
        if(l_value>=2)then
            call ForceAddPlayer(udg_TitleForce[16],p)
            if(l_value>=3)then
                call ForceAddPlayer(udg_TitleForce[17],p)
            endif
        endif
    endif
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[20])
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[59])
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if(l_value>=1)then
        call ForceAddPlayer(udg_TitleForce[21],p)
        if(l_value>=2)then
            call ForceAddPlayer(udg_TitleForce[22],p)
            if(l_value>=3)then
                call ForceAddPlayer(udg_TitleForce[23],p)
                call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[24])
            endif
        endif
    endif
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[29])
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[54])
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if(l_value>=1)then
        call ForceAddPlayer(udg_TitleForce[25],p)
        if(l_value>=2)then
            call ForceAddPlayer(udg_TitleForce[26],p)
            if(l_value>=3)then
                call ForceAddPlayer(udg_TitleForce[27],p)
                call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[28])
            endif
        endif
    endif
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[53])
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[34])
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,3)
    if(l_value>=1)then
        call ForceAddPlayer(udg_TitleForce[30],p)
        if(l_value==2)then
            call ForceAddPlayer(udg_TitleForce[51],p)
        elseif(l_value>=3)then
            call ForceAddPlayer(udg_TitleForce[31],p)
            if(l_value>=4)then
                call ForceAddPlayer(udg_TitleForce[51],p)
                if(l_value>=5)then
                    call ForceAddPlayer(udg_TitleForce[32],p)
                    if(l_value>=6)then
                        call ForceAddPlayer(udg_TitleForce[33],p)
                        if(l_value>=7)then
                            call ForceAddPlayer(udg_TitleForce[49],p)
                        endif
                    endif
                endif
            endif
        endif
    endif
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[50])
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[43])
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if(l_value>=1)then
        call ForceAddPlayer(udg_TitleForce[39],p)
        if(l_value>=2)then
            call ForceAddPlayer(udg_TitleForce[40],p)
            if(l_value>=3)then
                call ForceAddPlayer(udg_TitleForce[41],p)
                call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[42])
            endif
        endif
    endif
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[55])
    call Trig_Cmd_Load_Code_ReadBits(l_reader,1)
    // (l_pid) plus (1).
    set udg_SpeedrunLevel[l_pid+1]=Trig_Cmd_Load_Code_ReadBits(l_reader,4)
    call Trig_Cmd_Load_Code_ReadBits(l_reader,1)
    call Trig_Cmd_Load_Code_ReadBits(l_reader,1)
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Miracle/Replays")
    endif
    // (l_pid) plus (1).
    set udg_MiracleStage[l_pid+1]=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    // (l_pid) plus (1).
    set udg_MetaFragments[l_pid+1]=Trig_Cmd_Load_Code_ReadBits(l_reader,3)
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Construct NGP")
    endif
    // (l_ngPlusBits) plus ((Trig_Cmd_Load_Code_ReadBits(l_reader, 1)) times (8)).
    set l_ngPlusBits=l_ngPlusBits+(Trig_Cmd_Load_Code_ReadBits(l_reader,1)*8)
    call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_LegendaryGuardianForce)
    if(l_ngPlusBits>=$B)then // $B = 11
        // Calculation 1:
        // (l_pid) plus (1).
        // Calculation 2:
        // (15) minus (l_ngPlusBits).
        set udg_NewGamePlusLevel[l_pid+1]=$F-l_ngPlusBits // $F = 15
    elseif(l_ngPlusBits<=5)then
        // Calculation 1:
        // (l_pid) plus (1).
        // Calculation 2:
        // (5) plus (l_ngPlusBits).
        set udg_NewGamePlusLevel[l_pid+1]=5+l_ngPlusBits
    else
        call ForceAddPlayer(udg_CheaterForce,p)
        call SetHeroStr(Player_GetHero(p),5,true)
        call SetHeroAgi(Player_GetHero(p),5,true)
        call SetHeroInt(Player_GetHero(p),5,true)
    endif
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==0 and udg_Difficulty>=5)then
        set l_armoryBlocked=true
    endif
    call Trig_Cmd_Load_Code_FlushBits(l_reader)
    set udg_HasLoadedCode[l_pid]=true
    set udg_SpeedrunFlag[0]=true
    call DisplayTimedTextToPlayer(p,0,0,$A,"Load successful.") // $A = 10
    set udg_TempPlayer=p
    call ConditionalTriggerExecute(gg_trg_Titles_CheckAll)
    if l_withArmory then
        if l_armoryBlocked then
            call DisplayTimedTextToPlayer(p,0,0,$A,"This New Game Plus code's armory |cffffa0a0cannot be loaded into this difficulty|r, you will need to proceed without carrying over your armory.") // $A = 10
            call Trig_Cmd_Load_Code_FreeReader(l_reader)
        else
            set udg_ArmoryCodeSegment[l_pid]=l_reader
            set l_value=StringLength(l_code)
            // (l_value) minus (1).
            if(SubString(l_code,l_value-1,l_value)==")")then
                if Trig_Cmd_Load_Code_SeekArmory(l_reader)then
                    call Trig_Cmd_Load_Code_LoadArmory(l_reader,p)
                else
                    call DisplayTimedTextToPlayer(p,0,0,$A,"Armory code error! Please check the code and then use the extra command \"-loada (code)\" with |cFFFFCC00only the part of your code that's in brackets ()|r to load it.") // $A = 10
                endif
            else
                call DisplayTimedTextToPlayer(p,0,0,$A,"This code has an armory segment that needs to be loaded as well. Please use the extra command \"-loada (code)\" with |cFFFFCC00only the part of your code that's in brackets ()|r to load it.") // $A = 10
            endif
        endif
    else
        call Trig_Cmd_Load_Code_FreeReader(l_reader)
    endif
endfunction

function Trig_Cmd_Load_Code_LoadCodeV2 takes string l_code,player p,boolean l_withArmory returns nothing
    local integer l_reader=Trig_Cmd_Load_Code_OpenCode(p,l_code)
    local integer i=0
    local integer l_pid=GetPlayerId(p)
    local integer l_value
    if(l_reader==0)then
        return
    endif
    call Trig_Cmd_Load_Code_ReadLevelCapFlag(l_reader)
    loop
        exitwhen i>=udg_JobCount
        if(i<5 or i>7)then
            call Trig_Cmd_Load_Code_LoadJobLevel(l_reader,udg_JobUnitType[i])
        elseif(i==5)then
            call Trig_Cmd_Load_Code_LoadJobLevel(l_reader,udg_JobUnitType[7])
        elseif(i==6)then
            call Trig_Cmd_Load_Code_LoadJobLevel(l_reader,udg_JobUnitType[5])
        else
            call Trig_Cmd_Load_Code_LoadJobLevel(l_reader,udg_JobUnitType[6])
        endif
        set i=i+1
    endloop
    set l_value=Trig_Cmd_Load_Code_ReadLevel(l_reader)
    if(l_value>0)then
        // (l_pid) plus (1).
        if(udg_FreelancerHero[l_pid+1]==null)then
            // (l_pid) plus (1).
            set udg_FreelancerHero[l_pid+1]=Job_GetHero(p,'H02L') // 'H02L': unit "Freelancer"
            // (l_pid) plus (1).
            call SetUnitOwner(udg_FreelancerHero[l_pid+1],Player(PLAYER_NEUTRAL_PASSIVE),true)
            // (l_pid) plus (1).
            call SetUnitPosition(udg_FreelancerHero[l_pid+1],GetPlayerStartLocationX(p),GetPlayerStartLocationY(p))
        endif
        // (l_pid) plus (1).
        if(l_value>=99 and GetHeroLevel(udg_FreelancerHero[l_pid+1])<99)then
            // (GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED)) plus (1).
            call SetPlayerState(p,PLAYER_STATE_RESOURCE_FOOD_USED,(GetPlayerState(p,PLAYER_STATE_RESOURCE_FOOD_USED)+1))
        endif
        // (l_pid) plus (1).
        call SetHeroLevel(udg_FreelancerHero[l_pid+1],l_value,false)
        if(l_value>=99)then
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_FreelancerHero[l_pid+1],'A02F',3) // 'A02F': ability "Mastery"
        elseif(l_value>=50)then
            // (l_pid) plus (1).
            call SetUnitAbilityLevel(udg_FreelancerHero[l_pid+1],'A02F',2) // 'A02F': ability "Mastery"
        endif
    endif
    // (l_pid) plus (1).
    call Trig_Cmd_Load_Code_LoadHeroLevel(l_reader,udg_SpiritOfGaya[l_pid+1])
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Hero Inventory")
    endif
    call Trig_Cmd_Load_Code_LoadInventory(l_reader,Player_GetHero(p))
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gaya Inventory")
    endif
    // (l_pid) plus (1).
    call Trig_Cmd_Load_Code_LoadInventory(l_reader,udg_SpiritOfGaya[l_pid+1])
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: House Inventory")
    endif
    // (l_pid) plus (1).
    call Trig_Cmd_Load_Code_LoadInventory(l_reader,udg_PlayerHouse[l_pid+1])
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Upgrades Tools-Sword-Bow-Rod-Staff")
    endif
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R000') // 'R000': upgrade "Tools"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R001') // 'R001': upgrade "Sword"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R002') // 'R002': upgrade "Bow"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R003') // 'R003': upgrade "Rod"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R004') // 'R004': upgrade "Staff"
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Upgrades Plate-Leather-Mystic-Axe-Spear")
    endif
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R005') // 'R005': upgrade "Plate Armor"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R006') // 'R006': upgrade "Leather Armor"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R007') // 'R007': upgrade "Mystic Armor"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R008') // 'R008': upgrade "Axe"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R009') // 'R009': upgrade "Spear"
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Upgrades Katana-Dagger-Gun-Greatsword-Inner")
    endif
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R00A') // 'R00A': upgrade "Katana"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R00B') // 'R00B': upgrade "Dagger"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R00M') // 'R00M': upgrade "Gun"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R00N') // 'R00N': upgrade "Greatsword"
    call Trig_Cmd_Load_Code_LoadUpgrade(l_reader,'R00L') // 'R00L': upgrade "Inner Mana"
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gaya Skill Breakstun-Manatransfer-Megaheal")
    endif
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if(l_value>0)then
        call SetPlayerTechResearched(p,'Resi',1) // 'Resi': upgrade "Buy from Pandaren Spiritualist (1500 Gold + 1 Shard)"
        // (l_pid) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A0B4',l_value) // 'A0B4': ability "Break Stun"
    endif
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if(l_value>0)then
        call SetPlayerTechResearched(p,'R00F',1) // 'R00F': upgrade "Buy from Pandaren Spiritualist (3000 Gold + 1 Shard)"
        // (l_pid) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02K',l_value) // 'A02K': ability "Mana Transfer"
    endif
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if(l_value>0)then
        call SetPlayerTechResearched(p,'R00G',1) // 'R00G': upgrade "Buy from Pandaren Spiritualist (6000 Gold + 1 Shard)"
        // (l_pid) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A02L',l_value) // 'A02L': ability "Mega Heal"
    endif
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Gaya Skill Taru-Suku-Raku")
    endif
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        // (l_pid) plus (1).
        call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'A058') // 'A058': ability "Tarugaya"
        call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
        // Calculation 1:
        // (l_pid) plus (1).
        // Calculation 2:
        // (GetUnitAbilityLevel(udg_SpiritOfGaya at position (l_pid) plus (1), 'A10F')) plus (1).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F',GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F')+1) // 'A10F': ability "Spiritual Power"
    endif
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        // (l_pid) plus (1).
        call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'S004') // 'S004': ability "Sukugaya"
        call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
        // Calculation 1:
        // (l_pid) plus (1).
        // Calculation 2:
        // (GetUnitAbilityLevel(udg_SpiritOfGaya at position (l_pid) plus (1), 'A10F')) plus (2).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F',GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F')+2) // 'A10F': ability "Spiritual Power"
    endif
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        // (l_pid) plus (1).
        call UnitAddAbility(udg_SpiritOfGaya[l_pid+1],'A07E') // 'A07E': ability "Rakugaya"
        call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
        // Calculation 1:
        // (l_pid) plus (1).
        // Calculation 2:
        // (GetUnitAbilityLevel(udg_SpiritOfGaya at position (l_pid) plus (1), 'A10F')) plus (4).
        call SetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F',GetUnitAbilityLevel(udg_SpiritOfGaya[l_pid+1],'A10F')+4) // 'A10F': ability "Spiritual Power"
    endif
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Chronicles 15-34")
    endif
    set i=$F // $F = 15
    loop
        exitwhen i>=35
        if(i==19)then
            call Trig_Cmd_Load_Code_ReadBits(l_reader,1)
        else
            call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[i])
        endif
        set i=i+1
    endloop
    if(IsPlayerInForce(p,udg_TitleForce[32]))then
        call ForceAddPlayer(udg_TitleForce[51],p)
    endif
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Chronicles 39-43")
    endif
    set i=39
    loop
        exitwhen i>=44
        call Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[i])
        set i=i+1
    endloop
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: Miracle-Fragments")
    endif
    // (l_pid) plus (1).
    set udg_MiracleStage[l_pid+1]=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    // (l_pid) plus (1).
    set udg_MetaFragments[l_pid+1]=Trig_Cmd_Load_Code_ReadBits(l_reader,2)
    if false then
        call DisplayTimedTextToPlayer(p,0,0,60,"Load: NGP3-NGM1")
    endif
    set l_value=Trig_Cmd_Load_Code_ReadBits(l_reader,3)
    if(l_value<=5)then
        // (l_pid) plus (1).
        set udg_NewGamePlusLevel[l_pid+1]=l_value
    endif
    if(Trig_Cmd_Load_Code_ReadBits(l_reader,1)==1)then
        call ForceAddPlayer(udg_CheaterForce,p)
        call SetHeroStr(Player_GetHero(p),5,true)
        call SetHeroAgi(Player_GetHero(p),5,true)
        call SetHeroInt(Player_GetHero(p),5,true)
    endif
    call Trig_Cmd_Load_Code_FlushBits(l_reader)
    set udg_HasLoadedCode[l_pid]=true
    set udg_SpeedrunFlag[0]=true
    call DisplayTimedTextToPlayer(p,0,0,$A,"Load successful.") // $A = 10
    set udg_TempPlayer=p
    call ConditionalTriggerExecute(gg_trg_Titles_CheckAll)
    if l_withArmory then
        set udg_ArmoryCodeSegment[l_pid]=l_reader
        set l_value=StringLength(l_code)
        // (l_value) minus (1).
        if(SubString(l_code,l_value-1,l_value)==")")then
            if Trig_Cmd_Load_Code_SeekArmory(l_reader)then
                call Trig_Cmd_Load_Code_LoadArmoryLegacy(l_reader,p)
            else
                call DisplayTimedTextToPlayer(p,0,0,$A,"Armory code error! Please check the code and then use the extra command \"-loada (code)\" with |cFFFFCC00only the part of your code that's in brackets ()|r to load it.") // $A = 10
            endif
        else
            call DisplayTimedTextToPlayer(p,0,0,$A,"This code has an armory segment that needs to be loaded as well. Please use the extra command \"-loada (code)\" with |cFFFFCC00only the part of your code that's in brackets ()|r to load it.") // $A = 10
        endif
    else
        call Trig_Cmd_Load_Code_FreeReader(l_reader)
    endif
endfunction

function Trig_Cmd_Load_Code_LoadCodeG takes string l_code,player p returns nothing
    call Trig_Cmd_Load_Code_LoadCodeV3(l_code,p,false)
endfunction

function Trig_Cmd_Load_Code_LoadCodeH takes string l_code,player p returns nothing
    call Trig_Cmd_Load_Code_LoadCodeV3(l_code,p,true)
endfunction

function Trig_Cmd_Load_Code_LoadCodeE takes string l_code,player p returns nothing
    call Trig_Cmd_Load_Code_LoadCodeV2(l_code,p,false)
endfunction

function Trig_Cmd_Load_Code_LoadCodeF takes string l_code,player p returns nothing
    call Trig_Cmd_Load_Code_LoadCodeV2(l_code,p,true)
endfunction

function Trig_Cmd_Load_Code_LoadCodeDispatch takes string l_code,player p returns nothing
    local string l_version
    if(l_code==null or l_code=="")then
        return
    endif
    if(udg_HasLoadedCode[GetPlayerId(p)])then
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Already Loaded!|r")
        return
    endif
    call DisableTrigger(gg_trg_Item_Stack_Pickup)
    set l_version=SubString(l_code,0,1)
    if(l_version=="A")then
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Codes from versions before 0.9.6 cannot be loaded!|r")
    elseif(l_version=="B")then
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Codes from versions before 0.9.6 cannot be loaded!|r")
    elseif(l_version=="C")then
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Codes from versions before 0.9.6 cannot be loaded!|r")
    elseif(l_version=="D")then
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Codes from versions before 0.9.6 cannot be loaded!|r")
    elseif(l_version=="E")then
        call Trig_Cmd_Load_Code_LoadCodeE(l_code,p)
    elseif(l_version=="F")then
        call Trig_Cmd_Load_Code_LoadCodeF(l_code,p)
    elseif(l_version=="G")then
        call Trig_Cmd_Load_Code_LoadCodeG(l_code,p)
    elseif(l_version=="H")then
        call Trig_Cmd_Load_Code_LoadCodeH(l_code,p)
    else
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Unknown load version!|r")
    endif
    call EnableTrigger(gg_trg_Item_Stack_Pickup)
    set udg_CurrentHero=Player_GetHero(p)
    call ConditionalTriggerExecute(gg_trg_Unit_ApplyUpgradeBonuses)
    call StartTimerBJ(udg_LoadRefreshTimer,false,.0)
    set l_version=null
endfunction

function Trig_Cmd_Music_Conditions takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,7)=="-music ")
endfunction

function Trig_Cmd_Music_IsPrelude takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music prelude")
endfunction

function Trig_Cmd_Music_IsTracknamesToggle takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music tracknames")
endfunction

function Trig_Cmd_Music_IsTracknamesOff takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music tracknames off")
endfunction

function Trig_Cmd_Music_IsTracknamesOn takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music tracknames on")
endfunction

function Trig_Cmd_Music_IsTracknamesCmd takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,17)=="-music tracknames")
endfunction

function Trig_Cmd_Music_IsReset takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music reset")
endfunction

function Trig_Cmd_Music_IsNative takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music native")
endfunction

function Trig_Cmd_Music_IsPlayNative takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,19)=="-music play native ")
endfunction

function Trig_Cmd_Music_IsPlayCustom takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,19)=="-music play custom ")
endfunction

function Trig_Cmd_Music_IsPlayCmd takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,$C)=="-music play ") // $C = 12
endfunction

function Trig_Cmd_Music_IsAutoplayToggle takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music autoplay")
endfunction

function Trig_Cmd_Music_IsAutoplayOff takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music autoplay off")
endfunction

function Trig_Cmd_Music_IsAutoplayOn takes nothing returns boolean
    return(GetEventPlayerChatString()=="-music autoplay on")
endfunction

function Trig_Cmd_Music_IsAutoplayCmd takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,$F)=="-music autoplay") // $F = 15
endfunction

function Trig_Cmd_Music_IsPathCmd takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,$C)=="-music path ") // $C = 12
endfunction

function Trig_Cmd_Music_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    if(Trig_Cmd_Music_IsPathCmd())then
        call Trig_Cmd_Music_SetMusicPath(GetTriggerPlayer(),SubString(GetEventPlayerChatString(),$C,StringLength(GetEventPlayerChatString()))) // $C = 12
    else
        if(Trig_Cmd_Music_IsPrelude())then
            call Music_PlayFile(GetTriggerPlayer(),"war3mapImported\\FF7Prelude.mp3")
        endif
        if(Trig_Cmd_Music_IsAutoplayCmd())then
            if(Trig_Cmd_Music_IsAutoplayOn())then
                set udg_MusicEnabled[GetPlayerId(GetTriggerPlayer())]=true
                call DisplayTimedTextToForce(udg_TempForce,20.,"Music will now be played automatically.")
            else
                if(Trig_Cmd_Music_IsAutoplayOff())then
                    set udg_MusicEnabled[GetPlayerId(GetTriggerPlayer())]=false
                    call DisplayTimedTextToForce(udg_TempForce,20.,"Music will no longer be played automatically.")
                else
                    if(Trig_Cmd_Music_IsAutoplayToggle())then
                        set udg_MusicEnabled[GetPlayerId(GetTriggerPlayer())]=not udg_MusicEnabled[GetPlayerId(GetTriggerPlayer())]
                        call DisplayTimedTextToForce(udg_TempForce,20.,"Toggled music autoplaying.")
                    endif
                endif
            endif
        else
            if(Trig_Cmd_Music_IsTracknamesCmd())then
                if(Trig_Cmd_Music_IsTracknamesOn())then
                    set udg_MusicAnnounce[GetPlayerId(GetTriggerPlayer())]=true
                    call DisplayTimedTextToForce(udg_TempForce,20.,"Filenames of custom music tracks will now be displayed when played.")
                else
                    if(Trig_Cmd_Music_IsTracknamesOff())then
                        set udg_MusicAnnounce[GetPlayerId(GetTriggerPlayer())]=false
                        call DisplayTimedTextToForce(udg_TempForce,20.,"Filenames of custom music tracks will no longer be displayed when played.")
                    else
                        if(Trig_Cmd_Music_IsTracknamesToggle())then
                            set udg_MusicAnnounce[GetPlayerId(GetTriggerPlayer())]=not udg_MusicAnnounce[GetPlayerId(GetTriggerPlayer())]
                            call DisplayTimedTextToForce(udg_TempForce,20.,"Toggled displaying of custom music filenames.")
                        endif
                    endif
                endif
            endif
            if(Trig_Cmd_Music_IsPlayCmd())then
                if(Trig_Cmd_Music_IsPlayCustom())then
                    call Music_PlayTrack(GetTriggerPlayer(),SubString(GetEventPlayerChatString(),19,StringLength(GetEventPlayerChatString())),true,false)
                else
                    if(Trig_Cmd_Music_IsPlayNative())then
                        call Music_PlayTrack(GetTriggerPlayer(),SubString(GetEventPlayerChatString(),19,StringLength(GetEventPlayerChatString())),false,false)
                    else
                        call Music_PlayTrack(GetTriggerPlayer(),SubString(GetEventPlayerChatString(),$C,StringLength(GetEventPlayerChatString())),udg_MusicUseCustom[GetPlayerId(GetTriggerPlayer())],false) // $C = 12
                    endif
                endif
            else
                if(Trig_Cmd_Music_IsNative())then
                    call Trig_Cmd_Music_ResetMusicPath(GetTriggerPlayer())
                    call DisplayTimedTextToForce(udg_TempForce,20.,"Now using native Warcraft III music.")
                else
                    if(Trig_Cmd_Music_IsReset())then
                        call Trig_Cmd_Music_PlayCurrentTrack(GetTriggerPlayer())
                    endif
                endif
            endif
        endif
    endif
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Cmd_Load_Code_Actions takes nothing returns nothing
    local string l_code=GetEventPlayerChatString()
    local string l_prefix=SubString(l_code,0,6)
    if(not udg_HardcoreOff)then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Loading is not allowed in Hardcore mode!")
        return
    endif
    set l_code=SubString(l_code,6,StringLength(l_code))
    set l_code=Trig_Cmd_Load_Code_TrimSpaces(l_code)
    if not(l_prefix=="-load " and StringLength(l_code)>$A)then // $A = 10
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"|cFFFF0000Wrong load command!|r Try '-load' (small 'L').")
        return
    endif
    call Trig_Cmd_Load_Code_LoadCodeDispatch(l_code,GetTriggerPlayer())
    set l_code=null
    set l_prefix=null
endfunction

function Trig_Cmd_Load_Armory_Actions takes nothing returns nothing
    local string l_code=GetEventPlayerChatString()
    local string l_prefix=SubString(l_code,0,7)
    local player p=GetTriggerPlayer()
    local integer l_reader
    if(not udg_HardcoreOff)then
        call DisplayTimedTextToPlayer(p,0,0,30,"Loading is not allowed in Hardcore mode!")
        set p=null
        return
    endif
    if(udg_ArmoryCodeSegment[GetPlayerId(p)]==null)then
        call DisplayTimedTextToPlayer(p,0,0,30,"You can only use this command to supplement a load code with armory if the armory failed to load!")
        set p=null
        return
    endif
    set l_code=SubString(l_code,7,StringLength(l_code))
    set l_code=Trig_Cmd_Load_Code_TrimSpaces(l_code)
    if(SubString(l_code,0,1)=="(")then
        // (StringLength(l_code)) minus (1).
        if(SubString(l_code,StringLength(l_code)-1,StringLength(l_code))==")")then
            // (StringLength(l_code)) minus (1).
            set l_code=SubString(l_code,1,StringLength(l_code)-1)
        else
            call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Invalid armory code!|r (Closing brackets missing?)")
        endif
    endif
    if not(l_prefix=="-loada " and StringLength(l_code)>6)then
        call DisplayTimedTextToPlayer(p,0,0,30,"|cFFFF0000Wrong load command!|r Try '-loada' (small 'L').")
        set p=null
        return
    endif
    set l_reader=udg_ArmoryCodeSegment[GetPlayerId(p)]
    if not Trig_Cmd_Load_Armory_AttachArmory(l_reader,l_code)then
        call DisplayTimedTextToPlayer(p,0,0,30,"Failed to piece things together...")
        set p=null
        return
    endif
    call Trig_Cmd_Load_Code_LoadArmoryLegacy(l_reader,p)
    set l_code=null
    set l_prefix=null
    set p=null
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Cmd takes nothing returns nothing
endfunction
function RegisterR11_Cmd_Music takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Cmd_Music=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(0),"-music",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(1),"-music",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(2),"-music",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(3),"-music",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(4),"-music",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(5),"-music",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(6),"-music",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Music,Player(7),"-music",false)
    call TriggerAddCondition(gg_trg_Cmd_Music,Condition(function Trig_Cmd_Music_Conditions))
    call TriggerAddAction(gg_trg_Cmd_Music,function Trig_Cmd_Music_Actions)
endfunction
function RegisterR11_Cmd_Load_Code takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Cmd_Load_Code=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(0),"-load ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(1),"-load ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(2),"-load ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(3),"-load ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(4),"-load ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(5),"-load ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(6),"-load ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Code,Player(7),"-load ",false)
    call TriggerAddAction(gg_trg_Cmd_Load_Code,function Trig_Cmd_Load_Code_Actions)
endfunction
function RegisterR11_Cmd_Load_Armory takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Cmd_Load_Armory=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(0),"-loada",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(1),"-loada",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(2),"-loada",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(3),"-loada",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(4),"-loada",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(5),"-loada",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(6),"-loada",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cmd_Load_Armory,Player(7),"-loada",false)
    call TriggerAddAction(gg_trg_Cmd_Load_Armory,function Trig_Cmd_Load_Armory_Actions)
endfunction




endlibrary

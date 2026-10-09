library TForsakenSaveProgression requires TForsakenSaveRecovery
// Same-game journal only; not a serializer or a complete character transaction.
// Caller must exclude gameplay mutations and suppress force/research side effects.
globals
    // 0 idle, 1 captured, 2 recovered, 3 blocked.
    integer array FPG_State
    boolean array FPG_Busy
    integer array FPG_Scalar
    integer array FPG_Currency
    integer array FPG_Tech
    force array FPG_Force
    boolean array FPG_Member
    boolean array FPG_JobPresent
    integer array FPG_JobValue
    unit array FPG_JobHero
    integer array FPG_JobXP
    integer array FPG_JobLevel
    integer array FPG_JobMastery
    hashtable array FPG_LevelTable
    hashtable array FPG_HeroTable
    boolean array FPG_Loaded
    integer array FPG_Difficulty
    integer array FPG_WorldMiracle
    boolean array FPG_Speedrun
    boolean array FPG_HardcoreOff
    boolean array FPG_GameRunning
    integer array FPG_SpeedrunBase
    integer array FPG_FlagCount
endglobals
function FPG_JobRaw takes integer slot returns integer
    if slot==0 then
        return 'H000'
    elseif slot==1 then
        return 'H003'
    elseif slot==2 then
        return 'H001'
    elseif slot==3 then
        return 'H00A'
    elseif slot==4 then
        return 'H00B'
    elseif slot==5 then
        return 'H00D'
    elseif slot==6 then
        return 'H00E'
    elseif slot==7 then
        return 'H00C'
    elseif slot==8 then
        return 'H00F'
    elseif slot==9 then
        return 'H00M'
    elseif slot==10 then
        return 'H002'
    elseif slot==11 then
        return 'H004'
    elseif slot==12 then
        return 'H005'
    elseif slot==13 then
        return 'H009'
    elseif slot==14 then
        return 'H008'
    elseif slot==15 then
        return 'H00G'
    elseif slot==16 then
        return 'H00I'
    elseif slot==17 then
        return 'H00H'
    elseif slot==18 then
        return 'H00J'
    elseif slot==19 then
        return 'H00L'
    elseif slot==20 then
        return 'H02X'
    elseif slot==21 then
        return 'H02Y'
    endif
    return 0
endfunction
function FPG_TechRaw takes integer slot returns integer
    if slot==0 then
        return 'R000'
    elseif slot==1 then
        return 'R001'
    elseif slot==2 then
        return 'R002'
    elseif slot==3 then
        return 'R003'
    elseif slot==4 then
        return 'R004'
    elseif slot==5 then
        return 'R005'
    elseif slot==6 then
        return 'R006'
    elseif slot==7 then
        return 'R007'
    elseif slot==8 then
        return 'R008'
    elseif slot==9 then
        return 'R009'
    elseif slot==10 then
        return 'R00A'
    elseif slot==11 then
        return 'R00B'
    elseif slot==12 then
        return 'R00M'
    elseif slot==13 then
        return 'R00N'
    elseif slot==14 then
        return 'R00L'
    elseif slot==15 then
        return 'Resi'
    elseif slot==16 then
        return 'R00F'
    elseif slot==17 then
        return 'R00G'
    endif
    return 0
endfunction
function FPG_LiveForce takes integer slot returns force
    if slot<101 then
        return udg_TitleForce[slot]
    elseif slot<642 then
        return udg_SaveFlagForce[slot-101]
    elseif slot==642 then
        return udg_LegendaryGuardianForce
    endif
    return udg_CheaterForce
endfunction

function FPG_Context takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit hero
    if udg_JobCount!=22 or udg_JobLevelHash!=FPG_LevelTable[pid] or udg_JobHeroHash!=FPG_HeroTable[pid] then
        return false
    endif
    if udg_SpeedrunTitleBase!=FPG_SpeedrunBase[pid] or udg_Difficulty!=FPG_Difficulty[pid] or udg_MiracleStage[0]!=FPG_WorldMiracle[pid] or udg_SaveFlagCount!=FPG_FlagCount[pid] or udg_SpeedrunMode!=FPG_Speedrun[pid] or udg_HardcoreOff!=FPG_HardcoreOff[pid] or udg_GameRunning!=FPG_GameRunning[pid] then
        return false
    endif
    loop
        exitwhen slot>=644
        if FPG_LiveForce(slot)!=FPG_Force[pid*644+slot] then
            return false
        endif
        set slot=slot+1
    endloop
    // Existing hero progression is a read-only boundary for this checkpoint.
    set slot=0
    loop
        exitwhen slot>=22
        set index=pid*22+slot
        set hero=LoadUnitHandle(udg_JobHeroHash,FPG_JobRaw(slot),pid)
        if udg_JobUnitType[slot]!=FPG_JobRaw(slot) or hero!=FPG_JobHero[index] then
            set hero=null
            return false
        endif
        if hero!=null then
            if GetUnitTypeId(hero)!=FPG_JobRaw(slot) or GetOwningPlayer(hero)!=Player(pid) or GetHeroXP(hero)!=FPG_JobXP[index] or GetHeroLevel(hero)!=FPG_JobLevel[index] or GetUnitAbilityLevel(hero,'A02F')!=FPG_JobMastery[index] then
                set hero=null
                return false
            endif
        endif
        set slot=slot+1
    endloop
    set hero=null
    return true
endfunction

function FPG_Matches takes integer pid returns boolean
    local integer slot=0
    local integer index
    local player owner=Player(pid)
    if not FPG_Context(pid) or udg_HasLoadedCode[pid]!=FPG_Loaded[pid] then
        set owner=null
        return false
    endif
    if udg_CodeDifficulty[pid+1]!=FPG_Scalar[pid*9+0] then
        set owner=null
        return false
    endif
    if udg_NewGamePlusLevel[pid+1]!=FPG_Scalar[pid*9+1] then
        set owner=null
        return false
    endif
    if udg_MiracleStage[pid+1]!=FPG_Scalar[pid*9+2] then
        set owner=null
        return false
    endif
    if udg_MetaFragments[pid+1]!=FPG_Scalar[pid*9+3] then
        set owner=null
        return false
    endif
    if udg_SpeedrunLevel[pid+1]!=FPG_Scalar[pid*9+4] then
        set owner=null
        return false
    endif
    if udg_ArmoryItemCount[pid+1]!=FPG_Scalar[pid*9+5] then
        set owner=null
        return false
    endif
    if udg_TotalJobLevel[pid+1]!=FPG_Scalar[pid*9+6] then
        set owner=null
        return false
    endif
    if udg_HighestJobLevel[pid+1]!=FPG_Scalar[pid*9+7] then
        set owner=null
        return false
    endif
    if udg_ArmoryCodeSegment[pid]!=FPG_Scalar[pid*9+8] then
        set owner=null
        return false
    endif
    if GetPlayerState(owner,PLAYER_STATE_RESOURCE_GOLD)!=FPG_Currency[pid*3] or GetPlayerState(owner,PLAYER_STATE_RESOURCE_LUMBER)!=FPG_Currency[pid*3+1] or GetPlayerState(owner,PLAYER_STATE_RESOURCE_FOOD_USED)!=FPG_Currency[pid*3+2] then
        set owner=null
        return false
    endif
    loop
        exitwhen slot>=18
        if GetPlayerTechCount(owner,FPG_TechRaw(slot),true)!=FPG_Tech[pid*18+slot] then
            set owner=null
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=644
        set index=pid*644+slot
        if FPG_Force[index]!=null and IsPlayerInForce(owner,FPG_Force[index])!=FPG_Member[index] then
            set owner=null
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=22
        set index=pid*22+slot
        if HaveSavedInteger(udg_JobLevelHash,FPG_JobRaw(slot),pid)!=FPG_JobPresent[index] or LoadInteger(udg_JobLevelHash,FPG_JobRaw(slot),pid)!=FPG_JobValue[index] then
            set owner=null
            return false
        endif
        set slot=slot+1
    endloop
    set owner=null
    return true
endfunction

function FPG_Clear takes integer pid returns nothing
    local integer slot=0
    loop
        exitwhen slot>=644
        set FPG_Force[pid*644+slot]=null
        set FPG_Member[pid*644+slot]=false
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=22
        set FPG_JobHero[pid*22+slot]=null
        set FPG_JobPresent[pid*22+slot]=false
        set FPG_JobValue[pid*22+slot]=0
        set FPG_JobXP[pid*22+slot]=0
        set FPG_JobLevel[pid*22+slot]=0
        set FPG_JobMastery[pid*22+slot]=0
        set slot=slot+1
    endloop
    set FPG_LevelTable[pid]=null
    set FPG_HeroTable[pid]=null
    set FPG_State[pid]=0
    set FSN_ProgressionBlocked[pid]=false
    set FSJ_ProgressionPending[pid]=false
endfunction

function FPG_Begin takes integer pid returns boolean
    local integer slot=0
    local integer index
    local player owner
    local unit hero
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FPG_Busy[pid] or FSN_Busy[pid] or FPG_State[pid]!=0 or FQR_Busy[pid] or FQR_State[pid]!=1 or not FSJ_Verify(pid) or udg_JobCount!=22 or udg_SaveFlagCount>540 or udg_SaveFlagCount<0 or udg_JobLevelHash==null or udg_JobHeroHash==null then
        return false
    endif
    // Reject an unsupported job roster before reading any journaled state.
    loop
        exitwhen slot>=22
        if udg_JobUnitType[slot]!=FPG_JobRaw(slot) then
            return false
        endif
        set slot=slot+1
    endloop
    set FPG_Busy[pid]=true
    set owner=Player(pid)
    set FPG_LevelTable[pid]=udg_JobLevelHash
    set FPG_HeroTable[pid]=udg_JobHeroHash
    set FPG_Difficulty[pid]=udg_Difficulty
    set FPG_WorldMiracle[pid]=udg_MiracleStage[0]
    set FPG_Speedrun[pid]=udg_SpeedrunMode
    set FPG_HardcoreOff[pid]=udg_HardcoreOff
    set FPG_GameRunning[pid]=udg_GameRunning
    set FPG_SpeedrunBase[pid]=udg_SpeedrunTitleBase
    set FPG_FlagCount[pid]=udg_SaveFlagCount
    set FPG_Loaded[pid]=udg_HasLoadedCode[pid]
    set FPG_Scalar[pid*9+0]=udg_CodeDifficulty[pid+1]
    set FPG_Scalar[pid*9+1]=udg_NewGamePlusLevel[pid+1]
    set FPG_Scalar[pid*9+2]=udg_MiracleStage[pid+1]
    set FPG_Scalar[pid*9+3]=udg_MetaFragments[pid+1]
    set FPG_Scalar[pid*9+4]=udg_SpeedrunLevel[pid+1]
    set FPG_Scalar[pid*9+5]=udg_ArmoryItemCount[pid+1]
    set FPG_Scalar[pid*9+6]=udg_TotalJobLevel[pid+1]
    set FPG_Scalar[pid*9+7]=udg_HighestJobLevel[pid+1]
    set FPG_Scalar[pid*9+8]=udg_ArmoryCodeSegment[pid]
    set FPG_Currency[pid*3]=GetPlayerState(owner,PLAYER_STATE_RESOURCE_GOLD)
    set FPG_Currency[pid*3+1]=GetPlayerState(owner,PLAYER_STATE_RESOURCE_LUMBER)
    set FPG_Currency[pid*3+2]=GetPlayerState(owner,PLAYER_STATE_RESOURCE_FOOD_USED)
    set slot=0
    loop
        exitwhen slot>=18
        set FPG_Tech[pid*18+slot]=GetPlayerTechCount(owner,FPG_TechRaw(slot),true)
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=644
        set index=pid*644+slot
        set FPG_Force[index]=FPG_LiveForce(slot)
        set FPG_Member[index]=false
        if FPG_Force[index]!=null then
            set FPG_Member[index]=IsPlayerInForce(owner,FPG_Force[index])
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=22
        set index=pid*22+slot
        set FPG_JobPresent[index]=HaveSavedInteger(udg_JobLevelHash,FPG_JobRaw(slot),pid)
        set FPG_JobValue[index]=LoadInteger(udg_JobLevelHash,FPG_JobRaw(slot),pid)
        set hero=LoadUnitHandle(udg_JobHeroHash,FPG_JobRaw(slot),pid)
        set FPG_JobHero[index]=hero
        if hero!=null then
            set FPG_JobXP[index]=GetHeroXP(hero)
            set FPG_JobLevel[index]=GetHeroLevel(hero)
            set FPG_JobMastery[index]=GetUnitAbilityLevel(hero,'A02F')
        endif
        set slot=slot+1
    endloop
    set owner=null
    set hero=null
    if not FPG_Matches(pid) or not FSJ_Verify(pid) then
        call FPG_Clear(pid)
        set FPG_Busy[pid]=false
        return false
    endif
    set FPG_State[pid]=1
    set FSJ_ProgressionPending[pid]=true
    set FPG_Busy[pid]=false
    return true
endfunction

function FPG_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FPG_Busy[pid] or FPG_State[pid]==0 then
        return false
    endif
    return FPG_Matches(pid)
endfunction

function FPG_Recover takes integer pid returns boolean
    local integer slot=0
    local integer index
    local player owner
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FPG_Busy[pid] or FPG_State[pid]==0 or FQR_Busy[pid] or FSN_Busy[pid] or FSJ_Busy[pid] then
        return false
    endif
    set FSN_ProgressionBlocked[pid]=true
    set FPG_State[pid]=3
    if not FPG_Context(pid) then
        return false
    endif
    set FPG_Busy[pid]=true
    set FSN_Busy[pid]=true
    set FSJ_Busy[pid]=true
    set owner=Player(pid)
    set udg_CodeDifficulty[pid+1]=FPG_Scalar[pid*9+0]
    set udg_NewGamePlusLevel[pid+1]=FPG_Scalar[pid*9+1]
    set udg_MiracleStage[pid+1]=FPG_Scalar[pid*9+2]
    set udg_MetaFragments[pid+1]=FPG_Scalar[pid*9+3]
    set udg_SpeedrunLevel[pid+1]=FPG_Scalar[pid*9+4]
    set udg_ArmoryItemCount[pid+1]=FPG_Scalar[pid*9+5]
    set udg_TotalJobLevel[pid+1]=FPG_Scalar[pid*9+6]
    set udg_HighestJobLevel[pid+1]=FPG_Scalar[pid*9+7]
    set udg_ArmoryCodeSegment[pid]=FPG_Scalar[pid*9+8]
    set udg_HasLoadedCode[pid]=FPG_Loaded[pid]
    call SetPlayerState(owner,PLAYER_STATE_RESOURCE_GOLD,FPG_Currency[pid*3])
    call SetPlayerState(owner,PLAYER_STATE_RESOURCE_LUMBER,FPG_Currency[pid*3+1])
    call SetPlayerState(owner,PLAYER_STATE_RESOURCE_FOOD_USED,FPG_Currency[pid*3+2])
    loop
        exitwhen slot>=18
        call SetPlayerTechResearched(owner,FPG_TechRaw(slot),FPG_Tech[pid*18+slot])
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=644
        set index=pid*644+slot
        if FPG_Force[index]!=null then
            if FPG_Member[index] then
                call ForceAddPlayer(FPG_Force[index],owner)
            else
                call ForceRemovePlayer(FPG_Force[index],owner)
            endif
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=22
        set index=pid*22+slot
        if FPG_JobPresent[index] then
            call SaveInteger(udg_JobLevelHash,FPG_JobRaw(slot),pid,FPG_JobValue[index])
        else
            call RemoveSavedInteger(udg_JobLevelHash,FPG_JobRaw(slot),pid)
        endif
        set slot=slot+1
    endloop
    set owner=null
    set FSN_Busy[pid]=false
    set FSJ_Busy[pid]=false
    set FPG_Busy[pid]=false
    if not FPG_Matches(pid) then
        return false
    endif
    set FPG_State[pid]=2
    return true
endfunction

function FPG_Release takes integer pid returns boolean
    if not FPG_Verify(pid) then
        return false
    endif
    if FPG_State[pid]!=2 or FQR_Busy[pid] or FSN_Busy[pid] or (FQR_State[pid]!=0 and FQR_State[pid]!=5) or not FSJ_Verify(pid) then
        return false
    endif
    call FPG_Clear(pid)
    return true
endfunction
endlibrary

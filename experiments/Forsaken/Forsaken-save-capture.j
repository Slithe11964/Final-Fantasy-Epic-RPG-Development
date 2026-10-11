library TForsakenSaveCapture requires TForsakenSaveLife
// Read-only live capture. No legacy writer, character mutation or recovery pipeline.
globals
    hashtable FRC_Map=null
    hashtable FRC_Timers=null
    integer array FRC_Phase
    integer array FRC_Position
    integer array FRC_Count
    integer array FRC_AccountHash
    string array FRC_Body
    string array FRC_Result
    string array FRC_Record
    string array FRC_Payload
    string array FRC_Error
    boolean array FRC_WriterOwned
    boolean array FRC_Ready
    item array FRC_Handle
    integer array FRC_Raw
    unit array FRC_Hero
    unit array FRC_Gaya
    unit array FRC_House
    timer array FRC_Timer
    timer array FRC_Watchdog
endglobals

function FRC_Account takes integer pid returns integer
    local integer hashed=StringHash(udg_PlayerName[pid+1])
    local integer value
    if hashed<0 then
        // Avoid negating signed32 minimum while matching the legacy absolute hash.
        set value=ModuloInteger(-(hashed+1),1048576)+1
        return ModuloInteger(value,1048576)
    endif
    return ModuloInteger(hashed,1048576)
endfunction

// Preserve the legacy save tiers rather than the separate difficulty vote indexes.
function FRC_Difficulty takes integer pid returns integer
    if udg_Difficulty==6 then
        return udg_CodeDifficulty[pid+1]
    elseif udg_Difficulty>=5 then
        return 3
    elseif udg_Difficulty<=1 then
        return 1
    endif
    return 2
endfunction

function FRC_Pair takes integer identity,integer value returns string
    if identity<=0 or value<0 then
        return "!"
    endif
    return FSC_Uint(identity)+FSC_Uint(value)
endfunction

function FRC_JobUnit takes integer pid,integer raw returns unit
    if FRC_Hero[pid]!=null and GetUnitTypeId(FRC_Hero[pid])==raw then
        return FRC_Hero[pid]
    endif
    return LoadUnitHandle(udg_JobHeroHash,raw,pid)
endfunction

function FRC_Level takes integer pid,integer raw returns integer
    local unit hero=FRC_JobUnit(pid,raw)
    local integer saved
    if hero!=null then
        set saved=GetHeroLevel(hero)
    else
        set saved=LoadInteger(udg_JobLevelHash,raw,pid)
        if saved==100 then
            set saved=99
        endif
    endif
    set hero=null
    return saved
endfunction

function FRC_Tier takes integer pid,integer raw returns integer
    local unit hero=FRC_JobUnit(pid,raw)
    local integer rank=GetUnitAbilityLevel(hero,'A02F')
    local integer level=FRC_Level(pid,raw)
    if (hero!=null and rank>=4) or (hero==null and LoadInteger(udg_JobLevelHash,raw,pid)==100) then
        set hero=null
        return 3
    endif
    set hero=null
    if level>=99 then
        return 2
    elseif level>=50 then
        return 1
    endif
    return 0
endfunction

function FRC_FreeVariant takes unit hero returns integer
    local integer raw=GetUnitTypeId(hero)
    if hero==null then
        return 0
    elseif raw=='H02L' then
        return 1
    elseif raw=='H02M' then
        return 2
    elseif raw=='H02N' then
        return 3
    endif
    return -1
endfunction

function FRC_JobRaw takes integer slot returns integer
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

function FRC_TechRaw takes integer slot returns integer
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

function FRC_Selected takes integer pid returns integer
    local integer i=0
    loop
        exitwhen i>=22
        if GetUnitTypeId(FRC_Hero[pid])==FRC_JobRaw(i) then
            return i+1
        endif
        set i=i+1
    endloop
    if FRC_Hero[pid]==udg_FreelancerHero[pid+1] and FRC_FreeVariant(FRC_Hero[pid])>0 then
        return 0
    endif
    return -1
endfunction

function FRC_GayaRank takes player owner,unit gaya,integer research,integer abilityId returns integer
    if IsPlayerInForce(owner,udg_TitleForce[52]) and GetHeroLevel(gaya)>=99 then
        return 3
    elseif GetPlayerTechCount(owner,research,true)>0 then
        return GetUnitAbilityLevel(gaya,abilityId)
    endif
    return 0
endfunction

function FRC_Section takes integer pid,integer sid returns string
    local integer i=0
    local integer count=0
    local integer level
    local integer tier
    local integer selected
    local integer variant
    local integer miracle=udg_MiracleStage[pid+1]
    local string body=""
    local player owner=Player(pid)
    local unit free=udg_FreelancerHero[pid+1]
    local unit gaya=FRC_Gaya[pid]
    if sid==2 then
        loop
            exitwhen i>=22
            if udg_JobUnitType[i]!=FRC_JobRaw(i) then
                set FRC_Error[pid]="job registry differs from the frozen bindings"
                return null
            endif
            set level=FRC_Level(pid,FRC_JobRaw(i))
            set tier=FRC_Tier(pid,FRC_JobRaw(i))
            if not FSC_MasteryValid(level,tier) then
                set FRC_Error[pid]="unsupported job level or mastery"
                return null
            endif
            set body=body+FSC_Uint(i+1)+FSC_Uint(level)+FSC_Uint(tier)
            set i=i+1
        endloop
        return FSC_Uint(22)+body
    elseif sid==4 then
        if udg_NewGamePlusLevel[pid+1]<0 or udg_NewGamePlusLevel[pid+1]>10 then
            set FRC_Error[pid]="unsupported New Game mode; no export created"
            return null
        endif
        set level=0
        set tier=0
        set variant=FRC_FreeVariant(free)
        if free!=null then
            set level=GetHeroLevel(free)
            if GetUnitAbilityLevel(free,'A02F')>=4 then
                set tier=3
            elseif level>=99 then
                set tier=2
            elseif level>=50 then
                set tier=1
            endif
        endif
        set selected=FRC_Selected(pid)
        if selected<0 or variant<0 or not FSC_MasteryValid(level,tier) then
            set FRC_Error[pid]="unreviewed active job or Freelancer variant"
            return null
        endif
        if udg_MiracleStage[0]!=-1 then
            set miracle=udg_MiracleStage[0]
        endif
        set body=FRC_Pair(1,FRC_Difficulty(pid))+FRC_Pair(2,GetPlayerState(owner,PLAYER_STATE_RESOURCE_GOLD))+FRC_Pair(3,GetPlayerState(owner,PLAYER_STATE_RESOURCE_LUMBER))+FRC_Pair(4,level)
        set body=body+FRC_Pair(5,udg_NewGamePlusLevel[pid+1])+FRC_Pair(6,miracle)+FRC_Pair(7,udg_MetaFragments[pid+1]+1)+FRC_Pair(8,udg_SpeedrunLevel[pid+1])
        if IsPlayerInForce(owner,udg_LegendaryGuardianForce) then
            set body=body+FRC_Pair(9,1)
        else
            set body=body+FRC_Pair(9,0)
        endif
        set body=body+FRC_Pair(10,1)
        if IsPlayerInForce(owner,udg_CheaterForce) then
            set body=body+FRC_Pair(11,1)
        else
            set body=body+FRC_Pair(11,0)
        endif
        set body=body+FRC_Pair(12,tier)+FRC_Pair(13,selected)+FRC_Pair(14,variant)
        if udg_SpeedrunMode then
            return FSC_Uint(15)+body+FRC_Pair(15,1)
        endif
        return FSC_Uint(15)+body+FRC_Pair(15,0)
    elseif sid==5 then
        set level=GetHeroLevel(gaya)
        if level<1 or level>99 then
            set FRC_Error[pid]="unreviewed Gaya level"
            return null
        endif
        set body=FRC_Pair(1,0)+FRC_Pair(2,level)
        if IsPlayerInForce(owner,udg_TitleForce[52]) and level>=99 then
            set body=FRC_Pair(1,1)+FRC_Pair(2,99)
        endif
        set body=body+FRC_Pair(3,FRC_GayaRank(owner,gaya,'Resi','A0B4'))+FRC_Pair(4,FRC_GayaRank(owner,gaya,'R00F','A02K'))+FRC_Pair(5,FRC_GayaRank(owner,gaya,'R00G','A02L'))
        return FSC_Uint(8)+body+FRC_Pair(6,GetUnitAbilityLevel(gaya,'A058'))+FRC_Pair(7,GetUnitAbilityLevel(gaya,'S004'))+FRC_Pair(8,GetUnitAbilityLevel(gaya,'A07E'))
    elseif sid==6 then
        loop
            exitwhen i>=15
            set body=body+FRC_Pair(i+1,GetPlayerTechCount(owner,FRC_TechRaw(i),true))
            set i=i+1
        endloop
        return FSC_Uint(15)+body
    elseif sid==7 then
        set i=1
        loop
            exitwhen i>100
            if udg_TitleForce[i]!=null and IsPlayerInForce(owner,udg_TitleForce[i]) then
                set body=body+FRC_Pair(i,1)
                set count=count+1
            endif
            set i=i+1
        endloop
        return FSC_Uint(count)+body
    elseif sid==8 then
        if udg_SaveFlagCount!=358 or udg_ArmoryCodeSegment[pid]!=0 then
            set FRC_Error[pid]="unreviewed or unfinished Armory state"
            return null
        endif
        set i=1
        loop
            exitwhen i>358
            if udg_SaveFlagForce[i]!=null and IsPlayerInForce(owner,udg_SaveFlagForce[i]) then
                set body=body+FRC_Pair(i,1)
                set count=count+1
            endif
            set i=i+1
        endloop
        return FSC_Uint(count)+body
    endif
    return null
endfunction

function FRC_At takes integer pid,integer position returns item
    if position<6 then
        return UnitItemInSlot(FRC_Hero[pid],position)
    elseif position<36 then
        return UnitItemInBagSlot(FRC_Hero[pid],position-6)
    elseif position<45 then
        return UnitItemInEquipmentSlot(FRC_Hero[pid],ConvertLoadoutSlot(position-36))
    elseif position<51 then
        if FRC_Gaya[pid]!=null then
            return UnitItemInSlot(FRC_Gaya[pid],position-45)
        endif
    elseif FRC_House[pid]!=null then
        return UnitItemInSlot(FRC_House[pid],position-51)
    endif
    return null
endfunction

function FRC_Read takes integer pid,integer position,item carried returns string
    local integer id
    local integer quantity
    local integer flags=0
    local integer holder
    local integer slot
    local string bound="A"
    local string life
    local string flagText
    local string record
    if carried==null then
        return ""
    endif
    set id=LoadInteger(FRC_Map,0,GetItemTypeId(carried))
    if id==0 then
        set FRC_Error[pid]="unknown item at position "+I2S(position)+"; nothing omitted."
        return null
    endif
    set quantity=GetItemCharges(carried)
    if quantity<0 or quantity>127 then
        set FRC_Error[pid]="quantity outside 0..127 at position "+I2S(position)+"."
        return null
    endif
    if GetItemUserData(carried)==pid+1 then
        set bound="B"
    elseif GetItemUserData(carried)!=0 then
        set FRC_Error[pid]="foreign binding at position "+I2S(position)+"."
        return null
    endif
    set life=FSL_CaptureLife(pid,carried)
    if life==null then
        set FRC_Error[pid]="item life could not be captured exactly."
        return null
    endif
    if IsItemInvulnerable(carried) then
        set flags=flags+1
    endif
    if BlzGetItemBooleanField(carried,ITEM_BF_CAN_BE_DROPPED) then
        set flags=flags+2
    endif
    if IsItemPawnable(carried) then
        set flags=flags+4
    endif
    set flagText=FSC_Uint(flags)
    if position<6 then
        set holder=1
        set slot=position
    elseif position<36 then
        set holder=2
        set slot=position-6
    elseif position<45 then
        set holder=3
        set slot=position-36
    elseif position<51 then
        set holder=4
        set slot=position-45
    else
        set holder=5
        set slot=position-51
    endif
    set record=FSC_Uint(position+1)+FSC_Uint(id)+FSC_Uint(holder)+FSC_Uint(slot)+"B"+SubString(FSC_ALPHABET,ModuloInteger(quantity,64),ModuloInteger(quantity,64)+1)+SubString(FSC_ALPHABET,quantity/64,quantity/64+1)+bound+"C"
    set record=record+"BB"+FSC_Uint(StringLength(life))+life+"CB"+FSC_Uint(StringLength(flagText))+flagText
    return FSC_Uint(StringLength(record))+record
endfunction

function FRC_Stop takes integer pid,string reason returns nothing
    local integer i=0
    call PauseTimer(FRC_Timer[pid])
    call PauseTimer(FRC_Watchdog[pid])
    call RemoveSavedInteger(FRC_Timers,GetHandleId(FRC_Timer[pid]),0)
    call RemoveSavedInteger(FRC_Timers,GetHandleId(FRC_Watchdog[pid]),0)
    call DestroyTimer(FRC_Timer[pid])
    call DestroyTimer(FRC_Watchdog[pid])
    set FRC_Timer[pid]=null
    set FRC_Watchdog[pid]=null
    set FRC_Error[pid]=reason
    set FRC_Phase[pid]=0
    set FRC_Hero[pid]=null
    set FRC_Gaya[pid]=null
    set FRC_House[pid]=null
    set FRC_Body[pid]=null
    loop
        exitwhen i>=57
        set FRC_Handle[pid*57+i]=null
        set FRC_Record[pid*57+i]=null
        set i=i+1
    endloop
endfunction

function FRC_Timeout takes nothing returns nothing
    local integer pid=LoadInteger(FRC_Timers,GetHandleId(GetExpiredTimer()),0)-1
    if FRC_WriterOwned[pid] then
        call FSC_Abort(pid)
        set FRC_WriterOwned[pid]=false
    endif
    call FRC_Stop(pid,"capture timed out; no character changed")
endfunction

function FRC_Tick takes nothing returns nothing
    local integer pid=LoadInteger(FRC_Timers,GetHandleId(GetExpiredTimer()),0)-1
    local integer position=FRC_Position[pid]
    local integer index=pid*57+position
    local integer sid
    local integer schemaVersion
    local item carried
    local string payload
    local string encoded
    if FRC_Hero[pid]!=udg_PlayerHero[pid+1] or FRC_Gaya[pid]!=udg_SpiritOfGaya[pid+1] or FRC_House[pid]!=udg_PlayerHouse[pid+1] or FRC_Account(pid)!=FRC_AccountHash[pid] then
        call FRC_Stop(pid,"character/storage/account changed during capture")
        return
    endif
    if position<57 then
        set carried=FRC_At(pid,position)
        set payload=FRC_Read(pid,position,carried)
        if payload==null then
            call FRC_Stop(pid,FRC_Error[pid])
            return
        endif
        if FRC_Phase[pid]==1 then
            set FRC_Handle[index]=carried
            set FRC_Raw[index]=GetItemTypeId(carried)
            set FRC_Record[index]=payload
            set FRC_Body[pid]=FRC_Body[pid]+payload
            if carried!=null then
                set FRC_Count[pid]=FRC_Count[pid]+1
            endif
        elseif carried!=FRC_Handle[index] or GetItemTypeId(carried)!=FRC_Raw[index] or payload!=FRC_Record[index] then
            call FRC_Stop(pid,"inventory changed during capture")
            return
        endif
    elseif position<65 then
        set sid=position-56
        if sid==3 then
            set FRC_Position[pid]=position+1
            return
        elseif sid==1 then
            set payload=FSC_Uint(FRC_Count[pid])+FRC_Body[pid]
        else
            set payload=FRC_Section(pid,sid)
        endif
        if payload==null then
            call FRC_Stop(pid,FRC_Error[pid])
            return
        endif
        if FRC_Phase[pid]==1 then
            set FRC_Payload[pid*16+sid]=payload
        elseif payload!=FRC_Payload[pid*16+sid] then
            call FRC_Stop(pid,"progression or durable flags changed during capture")
            return
        endif
    elseif FRC_Phase[pid]==1 then
        set FRC_Phase[pid]=2
        set FRC_Position[pid]=0
        return
    else
        if not FSC_Begin(pid,FRC_AccountHash[pid]) then
            call FRC_Stop(pid,"writer busy or refused account")
            return
        endif
        set FRC_WriterOwned[pid]=true
        set sid=1
        loop
            exitwhen sid>8
            if sid!=3 then
                set schemaVersion=1
                if sid==2 or sid==4 then
                    set schemaVersion=2
                endif
                if not FSC_Add(pid,sid,schemaVersion,true,FRC_Payload[pid*16+sid]) then
                    call FSC_Abort(pid)
                    set FRC_WriterOwned[pid]=false
                    call FRC_Stop(pid,"profile writer refused section "+I2S(sid))
                    return
                endif
            endif
            set sid=sid+1
        endloop
        set encoded=FSC_Finish(pid,true)
        set FRC_WriterOwned[pid]=false
        if encoded==null then
            call FRC_Stop(pid,"captured profile did not validate: "+FSC_Error[pid])
            return
        endif
        set FRC_Result[pid]=encoded
        set FRC_Ready[pid]=true
        call FRC_Stop(pid,"")
        return
    endif
    set FRC_Position[pid]=position+1
    set carried=null
endfunction

function FRC_Start takes integer pid returns boolean
    if not FSC_PlayerValid(pid) or FRC_Phase[pid]!=0 or FSC_Writing[pid] or FSC_Busy[pid] or FRC_Map==null or udg_PlayerHero[pid+1]==null or udg_SpiritOfGaya[pid+1]==null or udg_PlayerHouse[pid+1]==null then
        return false
    endif
    if UnitExtendedInventorySize(udg_PlayerHero[pid+1])!=30 then
        return false
    endif
    set FRC_Hero[pid]=udg_PlayerHero[pid+1]
    set FRC_Gaya[pid]=udg_SpiritOfGaya[pid+1]
    set FRC_House[pid]=udg_PlayerHouse[pid+1]
    set FRC_AccountHash[pid]=FRC_Account(pid)
    set FRC_Ready[pid]=false
    set FRC_Result[pid]=null
    set FRC_Error[pid]=""
    set FRC_Position[pid]=0
    set FRC_Count[pid]=0
    set FRC_Body[pid]=""
    set FRC_Phase[pid]=1
    set FRC_Timer[pid]=CreateTimer()
    set FRC_Watchdog[pid]=CreateTimer()
    call SaveInteger(FRC_Timers,GetHandleId(FRC_Timer[pid]),0,pid+1)
    call SaveInteger(FRC_Timers,GetHandleId(FRC_Watchdog[pid]),0,pid+1)
    call TimerStart(FRC_Watchdog[pid],10.,false,function FRC_Timeout)
    call TimerStart(FRC_Timer[pid],0.02,true,function FRC_Tick)
    return true
endfunction

function FRC_Init takes nothing returns nothing
    if FRC_Map!=null then
        return
    endif
    set FRC_Map=InitHashtable()
    set FRC_Timers=InitHashtable()
    // FRC_IDENTITY_INITIALIZATION
endfunction
endlibrary

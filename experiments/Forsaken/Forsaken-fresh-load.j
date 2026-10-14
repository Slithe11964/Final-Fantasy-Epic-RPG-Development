library TForsakenFreshLoad requires TForsakenSaveFreshObjects, TForsakenSaveTransport, TLoad, TShrine, TTitle, TJobLevels, TTitles
globals
    hashtable FFL_Before=null
    integer array FFL_Phase
    string array FFL_Error
    string array FFL_FailureReason
    integer array FFL_CleanupAttempts
    boolean array FFL_RetryCheck
    boolean array FFL_SnapshotTaken
    unit array FFL_OldHero
    unit array FFL_OldGaya
    integer array FFL_ItemKey
    real array FFL_Started
    boolean array FFL_SaveFile
    string array FFL_ChatPart
    integer array FFL_ChatCheck
    integer array FFL_ChatTotal
    integer array FFL_ChatCount
    boolean FFL_CommandsBound=false
    boolean FFL_WindowOpen=true
    timer FFL_Poll=null
    timer FFL_Window=null
    trigger gg_trg_Forsaken_FreshLoad=null
    boolean array FFL_GuardEnabled
endglobals

function FFL_OneGuard takes trigger target,integer index,boolean block returns nothing
    if target==null then
        return
    endif
    if block then
        set FFL_GuardEnabled[index]=IsTriggerEnabled(target)
        call DisableTrigger(target)
    elseif FFL_GuardEnabled[index] then
        call EnableTrigger(target)
    endif
endfunction

function FFL_Guard takes boolean block returns nothing
    // FFL_TRIGGER_GUARD_INITIALIZATION
endfunction

function FFL_Message takes integer pid,string message returns nothing
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,message)
endfunction

function FFL_Val takes integer pid,integer sectionId,integer identity returns integer
    return LoadInteger(FFP_Values,pid*16+sectionId,identity)
endfunction

function FFL_Membership takes player owner,force target,boolean wanted returns nothing
    if wanted then
        call ForceAddPlayer(target,owner)
    else
        call ForceRemovePlayer(target,owner)
    endif
endfunction

function FFL_Snapshot takes integer pid returns nothing
    local integer i=0
    local player owner=Player(pid)
    set FFL_OldHero[pid]=udg_PlayerHero[pid+1]
    set FFL_OldGaya[pid]=udg_SpiritOfGaya[pid+1]
    loop
        exitwhen i>=22
        call SaveInteger(FFL_Before,pid*16+2,i,LoadInteger(udg_JobLevelHash,FRC_JobRaw(i),pid))
        call SaveUnitHandle(FFL_Before,pid*16+3,i,LoadUnitHandle(udg_JobHeroHash,FRC_JobRaw(i),pid))
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=18
        call SaveInteger(FFL_Before,pid*16+6,i,GetPlayerTechCount(owner,FRC_TechRaw(i),true))
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>100
        call SaveBoolean(FFL_Before,pid*16+7,i,IsPlayerInForce(owner,udg_TitleForce[i]))
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>358
        call SaveBoolean(FFL_Before,pid*16+8,i,IsPlayerInForce(owner,udg_SaveFlagForce[i]))
        set i=i+1
    endloop
    call SaveInteger(FFL_Before,pid*16+4,1,udg_CodeDifficulty[pid+1])
    call SaveInteger(FFL_Before,pid*16+4,2,GetPlayerState(owner,PLAYER_STATE_RESOURCE_GOLD))
    call SaveInteger(FFL_Before,pid*16+4,3,GetPlayerState(owner,PLAYER_STATE_RESOURCE_LUMBER))
    call SaveInteger(FFL_Before,pid*16+4,5,udg_NewGamePlusLevel[pid+1])
    call SaveInteger(FFL_Before,pid*16+4,6,udg_MiracleStage[pid+1])
    call SaveInteger(FFL_Before,pid*16+4,7,udg_MetaFragments[pid+1])
    call SaveInteger(FFL_Before,pid*16+4,8,udg_SpeedrunLevel[pid+1])
    call SaveInteger(FFL_Before,pid*16+4,16,udg_ArmoryItemCount[pid+1])
    call SaveBoolean(FFL_Before,pid*16+4,9,IsPlayerInForce(owner,udg_LegendaryGuardianForce))
    call SaveBoolean(FFL_Before,pid*16+4,11,IsPlayerInForce(owner,udg_CheaterForce))
    set FFL_SnapshotTaken[pid]=true
    set owner=null
endfunction

function FFL_PlayerState takes integer pid,boolean restore returns boolean
    local integer i=0
    local integer level
    local integer count=0
    local boolean flag
    local player owner=Player(pid)
    loop
        exitwhen i>=22
        if restore then
            call SaveInteger(udg_JobLevelHash,FRC_JobRaw(i),pid,LoadInteger(FFL_Before,pid*16+2,i))
            call SaveUnitHandle(udg_JobHeroHash,FRC_JobRaw(i),pid,LoadUnitHandle(FFL_Before,pid*16+3,i))
        else
            set level=FFL_Val(pid,2,i+1)
            if FFL_Val(pid,10,i+1)==3 then
                set level=100
            endif
            call SaveInteger(udg_JobLevelHash,FRC_JobRaw(i),pid,level)
            call RemoveSavedHandle(udg_JobHeroHash,FRC_JobRaw(i),pid)
        endif
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=18
        if restore then
            set level=LoadInteger(FFL_Before,pid*16+6,i)
        elseif i<15 then
            set level=FFL_Val(pid,6,i+1)
        else
            // Gaya purchase research is a flag; the saved ability rank is restored separately.
            set level=0
            if FFL_Val(pid,5,i-12)>0 then
                set level=1
            endif
        endif
        call SetPlayerTechResearched(owner,FRC_TechRaw(i),level)
        if GetPlayerTechCount(owner,FRC_TechRaw(i),true)!=level then
            set FFL_Error[pid]="research "+I2S(i)+" wanted="+I2S(level)+" actual="+I2S(GetPlayerTechCount(owner,FRC_TechRaw(i),true))
            return false
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>100
        if restore then
            set flag=LoadBoolean(FFL_Before,pid*16+7,i)
        else
            set flag=FFL_Val(pid,7,i)==1
        endif
        call FFL_Membership(owner,udg_TitleForce[i],flag)
        if IsPlayerInForce(owner,udg_TitleForce[i])!=flag then
            set FFL_Error[pid]="title membership "+I2S(i)
            return false
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>358
        if restore then
            set flag=LoadBoolean(FFL_Before,pid*16+8,i)
        else
            set flag=FFL_Val(pid,8,i)==1
        endif
        call FFL_Membership(owner,udg_SaveFlagForce[i],flag)
        if IsPlayerInForce(owner,udg_SaveFlagForce[i])!=flag then
            set FFL_Error[pid]="Armory membership "+I2S(i)
            return false
        endif
        if flag and ArmoryMissingUnit[i]!=0 then
            set count=count+1
        endif
        set i=i+1
    endloop
    if restore then
        set udg_CodeDifficulty[pid+1]=LoadInteger(FFL_Before,pid*16+4,1)
        set FRC_LoadTier[pid]=0
    else
        set udg_CodeDifficulty[pid+1]=FFL_Val(pid,4,1)
        // Until the load is committed, the check reads back the save's own tier, which may be
        // higher than this game's (an Inferno save loaded in Easy).
        set FRC_LoadTier[pid]=FFL_Val(pid,4,1)
    endif
    if restore then
        set udg_NewGamePlusLevel[pid+1]=LoadInteger(FFL_Before,pid*16+4,5)
    else
        set udg_NewGamePlusLevel[pid+1]=FFL_Val(pid,4,5)
    endif
    if restore then
        set udg_MiracleStage[pid+1]=LoadInteger(FFL_Before,pid*16+4,6)
    else
        set udg_MiracleStage[pid+1]=FFL_Val(pid,4,6)
    endif
    if restore then
        set udg_MetaFragments[pid+1]=LoadInteger(FFL_Before,pid*16+4,7)
    else
        set udg_MetaFragments[pid+1]=FFL_Val(pid,4,7)-1
    endif
    if restore then
        set udg_SpeedrunLevel[pid+1]=LoadInteger(FFL_Before,pid*16+4,8)
    else
        set udg_SpeedrunLevel[pid+1]=FFL_Val(pid,4,8)
    endif
    if restore then
        call SetPlayerState(owner,PLAYER_STATE_RESOURCE_GOLD,LoadInteger(FFL_Before,pid*16+4,2))
        call SetPlayerState(owner,PLAYER_STATE_RESOURCE_LUMBER,LoadInteger(FFL_Before,pid*16+4,3))
        set udg_ArmoryItemCount[pid+1]=LoadInteger(FFL_Before,pid*16+4,16)
        call FFL_Membership(owner,udg_LegendaryGuardianForce,LoadBoolean(FFL_Before,pid*16+4,9))
        call FFL_Membership(owner,udg_CheaterForce,LoadBoolean(FFL_Before,pid*16+4,11))
    else
        call SetPlayerState(owner,PLAYER_STATE_RESOURCE_GOLD,FFL_Val(pid,4,2))
        call SetPlayerState(owner,PLAYER_STATE_RESOURCE_LUMBER,FFL_Val(pid,4,3))
        set udg_ArmoryItemCount[pid+1]=count
        call FFL_Membership(owner,udg_LegendaryGuardianForce,FFL_Val(pid,4,9)==1)
        call FFL_Membership(owner,udg_CheaterForce,FFL_Val(pid,4,11)==1)
    endif
    set owner=null
    return true
endfunction

function FFL_Learn takes unit hero,integer raw,integer wanted returns boolean
    local integer attempts=0
    loop
        exitwhen GetUnitAbilityLevel(hero,raw)>=wanted or attempts>=wanted
        call SelectHeroSkill(hero,raw)
        set attempts=attempts+1
    endloop
    return GetUnitAbilityLevel(hero,raw)==wanted
endfunction

function FFL_PrepareHero takes integer pid,unit hero,integer identity,integer level,integer tier returns boolean
    local integer bonus=0
    local integer i=1
    local integer wanted=11
    local integer str=10
    local integer agi=10
    local integer intel=10
    local integer variant=FFL_Val(pid,4,14)
    local integer jobIndex=identity-1
    // Normal Forsaken setup handlers are guarded during fresh creation.
    call UnitAddAbility(hero,'fBag')
    call UnitMakeAbilityPermanent(hero,true,'fBag')
    call UnitAddAbility(hero,'fGer')
    call UnitMakeAbilityPermanent(hero,true,'fGer')
    call UnitAddAbility(hero,'ASpc')
    call UnitMakeAbilityPermanent(hero,true,'ASpc')
    if UnitInventorySize(hero)!=6 or UnitExtendedInventorySize(hero)!=30 or GetUnitAbilityLevel(hero,'fGer')==0 then
        set FFL_Error[pid]="hero inventory setup quick="+I2S(UnitInventorySize(hero))+" bag="+I2S(UnitExtendedInventorySize(hero))+" equipment="+I2S(GetUnitAbilityLevel(hero,'fGer'))
        return false
    endif
    call SetUnitAbilityLevel(hero,'A02F',tier+1)
    call SetHeroLevel(hero,level,false)
    if tier==1 then
        set bonus=20
    elseif tier==2 then
        set bonus=50
    elseif tier==3 then
        set bonus=100
    endif
    if identity==0 then
        set jobIndex=22
        set str=str+bonus
        set agi=agi+bonus
        set intel=intel+bonus
        set i=0
        loop
            exitwhen i>=22
            if FFL_Val(pid,2,i+1)>=99 then
                if i<10 then
                    if ModuloInteger(i,9)==0 then
                        set str=str+24
                        set agi=agi+24
                    elseif ModuloInteger(i,2)==1 then
                        set str=str+48
                    else
                        set agi=agi+48
                    endif
                elseif i<20 then
                    set intel=intel+24
                elseif i==20 then
                    set str=str+16
                    set agi=agi+16
                else
                    set intel=intel+16
                endif
            endif
            set i=i+1
        endloop
        set str=str+level/2
        set agi=agi+level/2
        set intel=intel+level/2
        if variant==1 then
            set str=str+level+39-level/2
        elseif variant==2 then
            set agi=agi+level+39-level/2
        else
            set intel=intel+level+39-level/2
        endif
        call SetHeroStr(hero,str,true)
        call SetHeroAgi(hero,agi,true)
        call SetHeroInt(hero,intel,true)
    else
        call SetHeroStr(hero,GetHeroStr(hero,false)+bonus,true)
        call SetHeroAgi(hero,GetHeroAgi(hero,false)+bonus,true)
        call SetHeroInt(hero,GetHeroInt(hero,false)+bonus,true)
    endif
    if GetUnitAbilityLevel(hero,'A0SI')>1 then
        call SetUnitAbilityLevel(hero,'A0SI',1)
    endif
    if FFL_Val(pid,4,11)==1 then
        call SetHeroStr(hero,5,true)
        call SetHeroAgi(hero,5,true)
        call SetHeroInt(hero,5,true)
    endif
    set i=1
    loop
        exitwhen i>5 or identity==0
        if level>=50 then
            if i==5 then
                set wanted=6
            endif
            if not FFL_Learn(hero,udg_JobSkill[jobIndex*5+i],wanted) then
                set FFL_Error[pid]="job "+I2S(identity)+" skill "+I2S(i)+" wanted="+I2S(wanted)+" actual="+I2S(GetUnitAbilityLevel(hero,udg_JobSkill[jobIndex*5+i]))
                return false
            endif
        elseif GetUnitAbilityLevel(hero,udg_JobSkill[jobIndex*5+i])!=0 then
            set FFL_Error[pid]="unmastered job skill "+I2S(i)+" expected unlearned"
            return false
        endif
        set i=i+1
    endloop
    if identity==11 and level>=50 then
        call UnitRemoveAbility(hero,'A1AJ')
        call UnitAddAbility(hero,'A1AI')
    endif
    if GetHeroLevel(hero)!=level or GetUnitAbilityLevel(hero,'A02F')!=tier+1 then
        set FFL_Error[pid]="hero level wanted="+I2S(level)+" actual="+I2S(GetHeroLevel(hero))+" mastery wanted="+I2S(tier+1)+" actual="+I2S(GetUnitAbilityLevel(hero,'A02F'))
        return false
    endif
    return true
endfunction

function FFL_PrepareGaya takes integer pid returns boolean
    local unit gaya=FFN_Unit[pid*3+1]
    local integer i=1
    local integer raw
    local integer rank
    local integer bits=0
    call SetHeroLevel(gaya,FFL_Val(pid,5,2),false)
    set rank=1
    if FFL_Val(pid,7,7)==1 then
        set rank=rank+1
    endif
    if FFL_Val(pid,7,40)==1 then
        set rank=rank+2
    endif
    call SetUnitAbilityLevel(gaya,'S009',rank)
    call SetUnitAbilityLevel(gaya,'A10U',1+FFL_Val(pid,7,52))
    loop
        exitwhen i>12
        call SetUnitAbilityLevel(gaya,udg_ChronicleAbility[i],1)
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>60
        if FFL_Val(pid,7,i)==1 and udg_TitleChronicleIndex[i]>0 then
            set raw=udg_ChronicleAbility[udg_TitleChronicleIndex[i]]
            call SetUnitAbilityLevel(gaya,raw,GetUnitAbilityLevel(gaya,raw)+udg_TitleChroniclePoints[i])
        endif
        set i=i+1
    endloop
    call SetUnitAbilityLevel(gaya,udg_ChronicleAbility[11],FFL_Val(pid,4,8)+1)
    set i=3
    loop
        exitwhen i>8
        if i==3 then
            set raw='A0B4'
        elseif i==4 then
            set raw='A02K'
        elseif i==5 then
            set raw='A02L'
        elseif i==6 then
            set raw='A058'
        elseif i==7 then
            set raw='S004'
        else
            set raw='A07E'
        endif
        set rank=FFL_Val(pid,5,i)
        if i<=5 then
            if rank<1 then
                set rank=1
            endif
            call SetUnitAbilityLevel(gaya,raw,rank)
            if GetUnitAbilityLevel(gaya,raw)!=rank then
                set FFL_Error[pid]="Gaya field "+I2S(i)+" wanted="+I2S(rank)+" actual="+I2S(GetUnitAbilityLevel(gaya,raw))
                return false
            endif
        elseif rank>0 then
            call UnitAddAbility(gaya,raw)
            set bits=bits+R2I(Pow(2.,I2R(i-6)))
            if GetUnitAbilityLevel(gaya,raw)!=1 then
                set FFL_Error[pid]="Gaya acquired ability field "+I2S(i)+" missing"
                return false
            endif
        endif
        set i=i+1
    endloop
    if bits>0 then
        call SetUnitAbilityLevel(gaya,'A10F',1+bits)
    endif
    set gaya=null
    return GetHeroLevel(FFN_Unit[pid*3+1])==FFL_Val(pid,5,2)
endfunction

function FFL_At takes unit holder,integer kind,integer slot returns item
    if kind==2 then
        return UnitItemInBagSlot(holder,slot)
    elseif kind==3 then
        return UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot))
    endif
    return UnitItemInSlot(holder,slot)
endfunction

function FFL_NewSpacer takes integer pid,integer raw,unit holder returns item
    local item spacer
    if FFN_SpacerCount[pid]>=36 then
        return null
    endif
    set spacer=CreateItem(raw,GetUnitX(holder),GetUnitY(holder))
    set FFN_Spacer[pid*36+FFN_SpacerCount[pid]]=spacer
    set FFN_SpacerCount[pid]=FFN_SpacerCount[pid]+1
    return spacer
endfunction

function FFL_StripStorage takes item carried returns boolean
    local integer key=GetHandleId(carried)
    local integer i=0
    local integer count=0
    local integer raw
    local ability entry
    loop
        set entry=BlzGetItemAbilityByIndex(carried,i)
        exitwhen entry==null
        if i>=16 then
            return false
        endif
        set raw=BlzGetAbilityId(entry)
        if LoadBoolean(ForsakenBagPassiveTypes,0,raw) then
            set count=count+1
            call SaveInteger(ForsakenBagAbilities,key,count,raw)
        endif
        set i=i+1
    endloop
    if count>0 then
        call SaveInteger(ForsakenBagAbilities,key,0,count)
        call SaveBoolean(ForsakenBagAbilities,key,-1,true)
    endif
    set i=1
    loop
        exitwhen i>count
        set raw=LoadInteger(ForsakenBagAbilities,key,i)
        call BlzItemRemoveAbility(carried,raw)
        if BlzGetItemAbility(carried,raw)!=null then
            return false
        endif
        set i=i+1
    endloop
    set entry=null
    return true
endfunction

function FFL_Holds takes unit holder,item carried returns boolean
    local integer slot=0
    loop
        exitwhen slot>=6
        if UnitItemInSlot(holder,slot)==carried then
            return true
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=UnitExtendedInventorySize(holder)
        if UnitItemInBagSlot(holder,slot)==carried then
            return true
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=9
        if UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot))==carried then
            return true
        endif
        set slot=slot+1
    endloop
    return false
endfunction

// Newly created stored items first become readable in the real holder's active slots.
function FFL_PrepareStored takes integer pid,integer ordinal returns boolean
    local integer index=pid*57+ordinal
    local unit holder=FFN_Unit[pid*3]
    local item carried=FFN_Item[index]
    local integer canonical=LoadInteger(ForsakenGearTypes,4,GetItemTypeId(carried))
    local boolean accepted=false
    local integer equipmentSlot=LoadInteger(ForsakenGearTypes,1,canonical)
    set accepted=UnitAddItem(holder,carried)
    if not FFL_Holds(holder,carried) then
        if accepted then
            set FFL_Error[pid]=FFL_Error[pid]+" pickup accepted but missing from quick/bag/equipment"
        else
            set FFL_Error[pid]=FFL_Error[pid]+" native pickup rejected"
        endif
        return false
    endif
    if canonical!=0 then
        call UnitEquipItem(holder,carried)
        if UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(equipmentSlot))!=carried then
            set FFL_Error[pid]=FFL_Error[pid]+" equipment readback"
            return false
        endif
    endif
    if not FFL_StripStorage(carried) then
        set FFL_Error[pid]=FFL_Error[pid]+" passive stripping"
        return false
    endif
    if canonical!=0 then
        call UnitUnequipItem(holder,carried)
    endif
    call UnitRemoveItem(holder,carried)
    if IsItemOwned(carried) or FFL_Holds(holder,carried) then
        set FFL_Error[pid]=FFL_Error[pid]+" detach readback"
        return false
    endif
    set holder=null
    set carried=null
    if not FFN_MetadataMatches(pid,ordinal) then
        set FFL_Error[pid]=FFL_Error[pid]+" metadata readback"
        return false
    endif
    return true
endfunction

function FFL_Place takes integer pid,integer ordinal returns boolean
    local integer index=pid*57+ordinal
    local integer kind=FFP_Holder[index]
    local integer slot=FFP_Slot[index]
    local integer position=0
    local integer limit=slot
    local unit holder=FFN_Unit[pid*3]
    local item spacer
    local item carried=FFN_Item[index]
    local ability entry
    local integer raw
    if kind==4 then
        set holder=FFN_Unit[pid*3+1]
    elseif kind==5 then
        set holder=udg_PlayerHouse[pid+1]
    endif
    if FFL_At(holder,kind,slot)!=null then
        set FFL_Error[pid]=FFL_Error[pid]+" destination occupied"
        return false
    endif
    if kind==2 then
        set limit=slot+6
    elseif kind==3 then
        set limit=0
        if slot==5 and UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(4))==null then
            set spacer=FFL_NewSpacer(pid,FFP_Raw[index],holder)
            if spacer==null then
                set FFL_Error[pid]=FFL_Error[pid]+" ring spacer allocation"
                return false
            endif
            loop
                set entry=BlzGetItemAbilityByIndex(spacer,0)
                exitwhen entry==null
                set raw=BlzGetAbilityId(entry)
                call BlzItemRemoveAbility(spacer,raw)
                if BlzGetItemAbility(spacer,raw)!=null then
                    set FFL_Error[pid]=FFL_Error[pid]+" ring spacer passive removal"
                    return false
                endif
            endloop
            call UnitAddItem(holder,spacer)
            call UnitEquipItem(holder,spacer)
            if UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(4))!=spacer then
                set FFL_Error[pid]=FFL_Error[pid]+" ring spacer equipment readback"
                return false
            endif
        endif
    endif
    loop
        exitwhen position>=limit
        if (position<6 and UnitItemInSlot(holder,position)==null) or (position>=6 and UnitItemInBagSlot(holder,position-6)==null) then
            set spacer=FFL_NewSpacer(pid,'fGap',holder)
            if spacer==null then
                set FFL_Error[pid]=FFL_Error[pid]+" gap spacer allocation"
                return false
            endif
            call UnitAddItem(holder,spacer)
            if (position<6 and UnitItemInSlot(holder,position)!=spacer) or (position>=6 and UnitItemInBagSlot(holder,position-6)!=spacer) then
                set FFL_Error[pid]=FFL_Error[pid]+" gap spacer pickup readback"
                return false
            endif
        endif
        set position=position+1
    endloop
    call UnitAddItem(holder,carried)
    if kind==3 then
        call UnitEquipItem(holder,carried)
    endif
    if FFL_At(holder,kind,slot)!=carried then
        set FFL_Error[pid]=FFL_Error[pid]+" destination readback"
        return false
    endif
    if not FFN_CleanupSpacers(pid) then
        set FFL_Error[pid]=FFL_Error[pid]+" spacer cleanup"
        return false
    endif
    if not FFN_MetadataMatches(pid,ordinal) then
        set FFL_Error[pid]=FFL_Error[pid]+" metadata readback"
        return false
    endif
    set holder=null
    set carried=null
    set spacer=null
    set entry=null
    return true
endfunction

function FFL_ReleaseSnapshot takes integer pid returns nothing
    local integer section=0
    loop
        exitwhen section>=16
        call FlushChildHashtable(FFL_Before,pid*16+section)
        set section=section+1
    endloop
endfunction

function FFL_Restore takes integer pid returns boolean
    local integer i=0
    local boolean restored=true
    local boolean cleaned=false
    call FFL_Guard(true)
    if FFL_SnapshotTaken[pid] then
        set udg_PlayerHero[pid+1]=FFL_OldHero[pid]
        set udg_SpiritOfGaya[pid+1]=FFL_OldGaya[pid]
        call ShowUnit(FFL_OldHero[pid],true)
        call ShowUnit(FFL_OldGaya[pid],true)
        call SelectUnitForPlayerSingle(FFL_OldHero[pid],Player(pid))
        set udg_FreelancerHero[pid+1]=null
        set restored=FFL_PlayerState(pid,true)
    endif
    if restored then
        set cleaned=FFN_Cleanup(pid)
    endif
    loop
        exitwhen i>=57
        if FFL_ItemKey[pid*57+i]!=0 and FFN_Item[pid*57+i]==null then
            call FlushChildHashtable(ForsakenBagAbilities,FFL_ItemKey[pid*57+i])
            set FFL_ItemKey[pid*57+i]=0
        endif
        set i=i+1
    endloop
    call FFL_Guard(false)
    if restored and cleaned then
        call FFL_ReleaseSnapshot(pid)
        set FFL_Phase[pid]=0
        set FFL_SnapshotTaken[pid]=false
        set FFL_OldHero[pid]=null
        set FFL_OldGaya[pid]=null
        return true
    endif
    set FFP_Locked[pid]=true
    set FFL_Phase[pid]=4
    return false
endfunction

function FFL_Fail takes integer pid,string reason returns nothing
    set FFL_FailureReason[pid]=reason
    if FFL_Restore(pid) then
        call FFL_Message(pid,"Load failed: "+reason+". Nothing was changed; you can load again.")
    else
        // Native removal readbacks may settle after this synchronous operation.
        set FFL_CleanupAttempts[pid]=10
        set FFL_Phase[pid]=5
        call FFL_Message(pid,"Load failed: "+reason+". Cleaning up, please wait.")
    endif
endfunction

function FFL_Apply takes integer pid returns boolean
    local integer selected=FFL_Val(pid,4,13)
    local integer level=FFL_Val(pid,4,4)
    local integer tier=FFL_Val(pid,4,12)
    local integer i=0
    local boolean valid=true
    local integer placementPass=0
    if not FFP_Recheck(pid,FFL_WindowOpen) then
        set FFL_Phase[pid]=0
        call FFL_Message(pid,"Load failed: "+FFP_Error[pid])
        return false
    endif
    call FFL_Snapshot(pid)
    call FFL_Guard(true)
    // The loaded hero takes the starter's place: hide the starter and its Gaya first, so the new
    // units appear exactly where they stood. A failed load shows them again (FFL_Restore).
    call ShowUnit(FFL_OldHero[pid],false)
    call ShowUnit(FFL_OldGaya[pid],false)
    set FFL_Error[pid]="allocation"
    set valid=FFN_Allocate(pid,FFL_WindowOpen)
    if valid then
        if selected>0 then
            set level=FFL_Val(pid,2,selected)
            set tier=FFL_Val(pid,10,selected)
        endif
        set FFL_Error[pid]="hero progression"
        set valid=FFL_PrepareHero(pid,FFN_Unit[pid*3],selected,level,tier)
    endif
    if valid and FFN_Unit[pid*3+2]!=null then
        set FFL_Error[pid]="Freelancer progression"
        set valid=FFL_PrepareHero(pid,FFN_Unit[pid*3+2],0,FFL_Val(pid,4,4),FFL_Val(pid,4,12))
    endif
    if valid then
        set FFL_Error[pid]="player progression"
        set valid=FFL_PlayerState(pid,false)
    endif
    if valid then
        set FFL_Error[pid]="Gaya progression"
        set valid=FFL_PrepareGaya(pid)
    endif
    // Prepare dormant bag effects before any final quick/equipment positions fill.
    loop
        exitwhen i>=FFP_Count[pid] or not valid
        set FFL_ItemKey[pid*57+i]=GetHandleId(FFN_Item[pid*57+i])
        if FFP_Holder[pid*57+i]==2 then
            set FFL_Error[pid]="prepare bag slot "+I2S(FFP_Slot[pid*57+i]+1)+" item="+I2S(FFP_Raw[pid*57+i])
            set valid=FFL_PrepareStored(pid,i)
        endif
        set i=i+1
    endloop
    // Equip first, while quick inventory still has room for the native pickup.
    loop
        exitwhen placementPass>=2 or not valid
        set i=0
        loop
            exitwhen i>=FFP_Count[pid] or not valid
            if (placementPass==0 and FFP_Holder[pid*57+i]==3) or (placementPass==1 and FFP_Holder[pid*57+i]!=3) then
                set FFL_ItemKey[pid*57+i]=GetHandleId(FFN_Item[pid*57+i])
                set FFL_Error[pid]="place holder="+I2S(FFP_Holder[pid*57+i])+" slot="+I2S(FFP_Slot[pid*57+i]+1)+" item="+I2S(FFP_Raw[pid*57+i])
                set valid=FFL_Place(pid,i)
            endif
            set i=i+1
        endloop
        set placementPass=placementPass+1
    endloop
    if valid and FFL_RetryCheck[pid] then
        set valid=false
        set FFL_Error[pid]="retry check intentionally stopped after item placement"
    endif
    set FFL_RetryCheck[pid]=false
    if valid then
        set udg_PlayerHero[pid+1]=FFN_Unit[pid*3]
        set udg_SpiritOfGaya[pid+1]=FFN_Unit[pid*3+1]
        if selected==0 then
            set udg_FreelancerHero[pid+1]=FFN_Unit[pid*3]
        else
            call SaveUnitHandle(udg_JobHeroHash,FRC_JobRaw(selected-1),pid,FFN_Unit[pid*3])
            set udg_FreelancerHero[pid+1]=FFN_Unit[pid*3+2]
        endif
    endif
    call FFL_Guard(false)
    if not valid then
        if FFN_Error[pid]!="" then
            set FFL_Error[pid]=FFL_Error[pid]+"; "+FFN_Error[pid]
        endif
        call FFL_Fail(pid,FFL_Error[pid])
        return false
    endif
    if not FRC_Start(pid) then
        call FFL_Fail(pid,"could not start full readback")
        return false
    endif
    set FFL_Phase[pid]=3
    return true
endfunction

// The legacy loader re-runs each owned title's unlock effects and counts mastered jobs as food.
// Title stats are not reapplied: the saved hero attributes already include them.
// Title flags and Chronicle levels are restored without replaying Title_Grant.
// Restore its display availability separately, after the new character is committed.
function FFL_RestoreChronicles takes integer pid returns nothing
    local player owner=Player(pid)
    local unit gaya=udg_SpiritOfGaya[pid+1]
    local integer category=1
    local integer title=1
    local boolean any=false
    loop
        exitwhen category>12
        if GetUnitAbilityLevel(gaya,udg_ChronicleAbility[category])>1 then
            set any=true
        endif
        call SetPlayerAbilityAvailable(owner,udg_ChronicleAbility[category],GetUnitAbilityLevel(gaya,udg_ChronicleAbility[category])>1)
        set category=category+1
    endloop
    loop
        exitwhen title>59
        if IsPlayerInForce(owner,udg_TitleForce[title]) then
            set any=true
            set category=udg_TitleChronicleIndex[title]
            if category>0 then
                call SetPlayerAbilityAvailable(owner,udg_ChronicleAbility[category],true)
            endif
        endif
        set title=title+1
    endloop
    call SetPlayerAbilityAvailable(owner,'A0AR',any)
    call Chronicles_RestoreSecrets(owner)
    set gaya=null
    set owner=null
endfunction

function FFL_RestoreUnlocks takes integer pid returns nothing
    local player owner=Player(pid)
    local integer i=0
    local integer mastered=0
    loop
        exitwhen i>=udg_JobCount
        if Job_GetSavedLevel(owner,udg_JobUnitType[i])>=99 then
            set mastered=mastered+1
        endif
        set i=i+1
    endloop
    if udg_FreelancerHero[pid+1]!=null and GetHeroLevel(udg_FreelancerHero[pid+1])>=99 then
        set mastered=mastered+1
    endif
    call SetPlayerState(owner,PLAYER_STATE_RESOURCE_FOOD_USED,mastered)
    set i=1
    loop
        exitwhen i>59
        // High Guardian's job-total refresh is done below; the commit restores its eligible
        // New Game Plus command and notice. Do not replay either title's full unlock messages.
        if i!=14 and i!=20 and IsPlayerInForce(owner,udg_TitleForce[i]) then
            set udg_TempPlayer=owner
            set udg_TempInteger=i
            call ConditionalTriggerExecute(gg_trg_Title_UnlockEffects)
        endif
        set i=i+1
    endloop
    // Recount every player's total job level now; the periodic update skips Legendary Guardians.
    call EnableTrigger(gg_trg_JobLevels_Init)
    call StartTimerBJ(udg_JobLevelTimer,false,.01)
    call FFL_RestoreChronicles(pid)
    set owner=null
endfunction

// A loaded profile replaces the whole character, so any other hero the player still
// owns is left over from before the load. Hiding and releasing them keeps the loaded
// hero alone beside Gaya instead of standing next to spare job bodies.
function FFL_RetireSpareHeroes takes integer pid returns nothing
    local group spare=CreateGroup()
    local unit hero=FFN_Unit[pid*3]
    local unit gaya=FFN_Unit[pid*3+1]
    local unit found
    call GroupEnumUnitsOfPlayer(spare,Player(pid),null)
    loop
        set found=FirstOfGroup(spare)
        exitwhen found==null
        call GroupRemoveUnit(spare,found)
        if found!=hero and found!=gaya and IsUnitType(found,UNIT_TYPE_HERO) and not IsUnitHidden(found) then
            call SetUnitOwner(found,Player(PLAYER_NEUTRAL_PASSIVE),true)
            call ShowUnit(found,false)
        endif
    endloop
    call DestroyGroup(spare)
    set spare=null
    set hero=null
    set gaya=null
    set found=null
endfunction

function FFL_NotifyNewGamePlus takes integer pid returns nothing
    local player owner=Player(pid)
    if IsPlayerInForce(owner,udg_TitleForce[14]) and udg_NewGamePlusLevel[pid+1]<10 and not IsPlayerInForce(owner,udg_CheaterForce) then
        call EnableTrigger(udg_NewGamePlusTrig)
        call FFL_Message(pid,"|cffffcc00New Game Plus is available.|r Type -newgameplus to create a fresh-start code with increased job stat growth.")
    endif
    set owner=null
endfunction

// Keep starter agents alive for Warcraft checkpoints. Removing the unit does not
// necessarily release every engine reference held by its old abilities or events.
// A retired starter is neutral, paused and hidden; it cannot act or add a hero icon.
function FFL_RetireStarter takes unit starter returns nothing
    if starter!=null then
        call PauseUnit(starter,true)
        call SetUnitInvulnerable(starter,true)
        call SetUnitOwner(starter,Player(PLAYER_NEUTRAL_PASSIVE),true)
        call ShowUnit(starter,false)
    endif
endfunction

function FFL_Commit takes integer pid returns nothing
    local integer i=0
    local integer selected=FFL_Val(pid,4,13)
    call FFL_Guard(true)
    set udg_HasLoadedCode[pid]=true
    call FFL_RetireStarter(FFL_OldHero[pid])
    call FFL_RetireStarter(FFL_OldGaya[pid])
    call SelectUnitForPlayerSingle(FFN_Unit[pid*3],Player(pid))
    if FFN_Unit[pid*3+2]!=null then
        // Inactive job heroes are neutral so they do not occupy player hero portraits.
        call SetUnitOwner(FFN_Unit[pid*3+2],Player(PLAYER_NEUTRAL_PASSIVE),true)
        call ShowUnit(FFN_Unit[pid*3+2],false)
    endif
    call FFL_RetireSpareHeroes(pid)
    if selected==11 and GetHeroLevel(FFN_Unit[pid*3])>=50 then
        set i=1
        loop
            exitwhen i>10
            call SetPlayerAbilityAvailable(Player(pid),udg_BrewAbility[i],true)
            set i=i+1
        endloop
    endif
    call SetPlayerAbilityAvailable(Player(pid),'A10F',FFL_Val(pid,5,6)+FFL_Val(pid,5,7)+FFL_Val(pid,5,8)>0)
    call SetPlayerAbilityAvailable(Player(pid),'A11U',FFL_Val(pid,7,8)==1)
    call SetPlayerAbilityAvailable(Player(pid),'A0MW',FFL_Val(pid,7,35)==1)
    call SetUnitInvulnerable(FFN_Unit[pid*3],false)
    set i=0
    loop
        exitwhen i>=57
        set FFL_ItemKey[pid*57+i]=0
        set i=i+1
    endloop
    call FFN_ClearRecords(pid)
    set FFN_State[pid]=0
    // From here on this character saves at this game's tier.
    set FRC_LoadTier[pid]=0
    set FFP_Locked[pid]=false
    call FFP_Clear(pid)
    set FFL_Phase[pid]=0
    set FFL_SnapshotTaken[pid]=false
    set FFL_OldHero[pid]=null
    set FFL_OldGaya[pid]=null
    call FFL_ReleaseSnapshot(pid)
    call FFL_Guard(false)
    call FFL_RestoreUnlocks(pid)
    call FFL_Message(pid,"|cff00ff00Load complete.|r")
    call FFL_NotifyNewGamePlus(pid)
endfunction

function FFL_RoutesFile takes string command returns boolean
    local string lower=StringCase(command,false)
    return lower=="-load" or lower=="-loadf" or SubString(lower,0,7)=="-loadf " or SubString(lower,0,11)=="-load fsvb:" or SubString(command,0,10)=="-load FSVB"
endfunction

function FFL_Trim takes string value returns string
    local integer first=0
    local integer last=StringLength(value)
    loop
        exitwhen first>=last or SubString(value,first,first+1)!=" "
        set first=first+1
    endloop
    loop
        exitwhen last<=first or SubString(value,last-1,last)!=" "
        set last=last-1
    endloop
    return SubString(value,first,last)
endfunction

function FFL_LoadChat takes integer pid,string text returns nothing
    local integer i=5
    local integer first=5
    local integer field=0
    local integer check=-1
    local integer part=-1
    local integer total=-1
    local string chunk
    local string encoded=""
    if not FFP_Eligible(pid,FFL_WindowOpen) then
        call FFL_Message(pid,"Load not possible: "+FFP_Error[pid])
        return
    endif
    if SubString(text,0,5)=="FSVB:" then
        loop
            exitwhen i>=StringLength(text) or field>=3
            if SubString(text,i,i+1)==":" then
                if field==0 then
                    set check=FST_Digits(SubString(text,first,i))
                elseif field==1 then
                    set part=FST_Digits(SubString(text,first,i))
                else
                    set total=FST_Digits(SubString(text,first,i))
                endif
                set field=field+1
                set first=i+1
            endif
            set i=i+1
        endloop
        set chunk=SubString(text,first,StringLength(text))
        if field!=3 or check<0 or total<1 or total>213 or part<1 or part>total or StringLength(chunk)<1 or StringLength(chunk)>80 or (part<total and StringLength(chunk)!=80) or not FSC_AlphabetValid(chunk) then
            call FFL_Message(pid,"That load line is incomplete. Paste the whole -load line.")
            return
        endif
        if FFL_ChatCheck[pid]!=check or FFL_ChatTotal[pid]!=total then
            set i=1
            loop
                exitwhen i>213
                set FFL_ChatPart[pid*256+i]=null
                set i=i+1
            endloop
            set FFL_ChatCheck[pid]=check
            set FFL_ChatTotal[pid]=total
            set FFL_ChatCount[pid]=0
        endif
        if FFL_ChatPart[pid*256+part]!=null and FFL_ChatPart[pid*256+part]!=chunk then
            set FFL_ChatPart[pid*256+part]=chunk
        elseif FFL_ChatPart[pid*256+part]==null then
            set FFL_ChatPart[pid*256+part]=chunk
            set FFL_ChatCount[pid]=FFL_ChatCount[pid]+1
        endif
        if FFL_ChatCount[pid]<total then
            call FFL_Message(pid,"Load: part "+I2S(part)+" received ("+I2S(FFL_ChatCount[pid])+" of "+I2S(total)+"). Type -loadstatus to see which parts are missing.")
            return
        endif
        set i=1
        loop
            exitwhen i>total
            set encoded=encoded+FFL_ChatPart[pid*256+i]
            set i=i+1
        endloop
        if StringLength(encoded)>FST_LIMIT or FSC_Checksum(encoded)!=check then
            set FFL_ChatTotal[pid]=0
            call FFL_Message(pid,"Load failed: the parts do not fit together. Paste all of them again.")
            return
        endif
    else
        set encoded=text
    endif
    if FFP_Build(pid,encoded,FFL_WindowOpen) then
        set FST_Result[pid]=encoded
        set FST_FileMillis[pid]=0
        set FST_TransferSeconds[pid]=0.
        set FFL_Started[pid]=TimerGetElapsed(FST_Clock)
        call FFL_Apply(pid)
    else
        set FFL_ChatTotal[pid]=0
        call FFL_Message(pid,"Load failed: "+FFP_Error[pid])
    endif
endfunction

// Lists the parts a chat load is still waiting for, so a stalled paste can be finished
// without sending every line again.
function FFL_LoadStatus takes integer pid returns nothing
    local integer total=FFL_ChatTotal[pid]
    local integer i=1
    local integer listed=0
    local integer missing=0
    local string parts=""
    if total<1 then
        call FFL_Message(pid,"No load in progress. Paste the first -load line.")
        return
    endif
    loop
        exitwhen i>total
        if FFL_ChatPart[pid*256+i]==null then
            set missing=missing+1
            if listed<20 then
                if parts!="" then
                    set parts=parts+", "
                endif
                set parts=parts+I2S(i)
                set listed=listed+1
            endif
        endif
        set i=i+1
    endloop
    if missing==0 then
        call FFL_Message(pid,"Load: all "+I2S(total)+" parts received.")
        return
    endif
    if missing>listed then
        set parts=parts+" and "+I2S(missing-listed)+" more"
    endif
    call FFL_Message(pid,"Load: "+I2S(FFL_ChatCount[pid])+" of "+I2S(total)+" parts received. Still missing part "+parts)
endfunction

function FFL_BeginSave takes integer pid,boolean file,boolean legacy returns boolean
    if FFL_Phase[pid]!=0 or FFP_Locked[pid] then
        return false
    endif
    set FFL_SaveFile[pid]=file
    set FST_LegacySaveMessages[pid]=legacy
    if not udg_HardcoreOff then
        call FFL_Message(pid,"Saving is disabled in Hardcore.")
        return false
    elseif FRC_StartNow(pid) then
        set FFL_Phase[pid]=1
        if legacy then
            call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Trying to save in "+SubString(FST_PlayerPath(pid,0),2,StringLength(FST_PlayerPath(pid,0))))
        else
            call FFL_Message(pid,"Saving...")
        endif
        return true
    endif
    call FFL_Message(pid,"Save failed: the character could not be read. Try again in a moment.")
    return false
endfunction

function FFL_Autosave takes nothing returns nothing
    local integer pid=Save_AutosavePid
    if not FSC_PlayerValid(pid) or FFL_Phase[pid]!=0 or FFP_Locked[pid] or not udg_HardcoreOff then
        return
    endif
    if FST_SetFileStem(pid,"autosave") then
        call FFL_BeginSave(pid,true,true)
    endif
endfunction

function FFL_Chat takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    local string command=GetEventPlayerChatString()
    local string lower=StringCase(command,false)
    local string stem="Forsaken CU"
    local boolean saving=command=="-newsave" or lower=="-save" or lower=="-savef" or SubString(lower,0,7)=="-savef "
    if lower=="-loadstatus" then
        call FFL_LoadStatus(pid)
        return
    endif
    if SubString(lower,0,5)=="-load" and lower!="-load" and SubString(lower,0,6)!="-load " and lower!="-loadf" and SubString(lower,0,7)!="-loadf " then
        return
    endif
    if SubString(lower,0,6)=="-load " and SubString(command,0,10)!="-load FSVB" then
        return
    endif
    if SubString(lower,0,6)=="-loadf" and not FFL_RoutesFile(command) then
        return
    endif
    if SubString(lower,0,6)=="-savef" and not saving then
        call FFL_Message(pid,"use -savef or -savef NAME")
        return
    endif
    if SubString(lower,0,10)=="-savepage " then
        call FST_ShowCode(pid,FST_Digits(FFL_Trim(SubString(command,10,StringLength(command)))))
        return
    endif
    if command=="-newcleanup" then
        if FFL_Phase[pid]==4 then
            call FFL_Fail(pid,"cleanup requested")
        else
            call FFL_Message(pid,"Nothing to clean up.")
        endif
        return
    elseif FFL_Phase[pid]!=0 or FFP_Locked[pid] then
        call FFL_Message(pid,"Another save or load is still running.")
        return
    endif
    if SubString(command,0,10)=="-load FSVB" then
        call FFL_LoadChat(pid,FFL_Trim(SubString(command,6,StringLength(command))))
        return
    endif
    if saving and lower!="-newsave" then
        set stem="Last save"
        if SubString(lower,0,7)=="-savef " then
            set stem=FFL_Trim(SubString(command,7,StringLength(command)))
            if stem=="" then
                set stem="Last save"
            endif
        endif
    elseif lower=="-load" or lower=="-loadf" then
        set stem="Last save"
    elseif FFL_RoutesFile(command) then
        set stem=FFL_Trim(SubString(command,7,StringLength(command)))
    endif
    if not FST_SetFileStem(pid,stem) then
        call FFL_Message(pid,"File names must use letters, numbers, spaces, underscores or hyphens (up to 64 characters)")
        return
    endif
    if saving then
        call FFL_BeginSave(pid,lower!="-save",lower=="-savef" or SubString(lower,0,7)=="-savef ")
    elseif FFP_Eligible(pid,FFL_WindowOpen) then
        set FST_AllowLegacy[pid]=SubString(lower,0,6)=="-loadf" or lower=="-load"
        if FST_Request(pid,FRC_Account(pid)) then
            set FFL_RetryCheck[pid]=command=="-newretrycheck"
            set FFL_Phase[pid]=2
            set FFL_Started[pid]=TimerGetElapsed(FST_Clock)
            call FFL_Message(pid,"Loading...")
        endif
    else
        call FFL_Message(pid,"Load not possible: "+FFP_Error[pid])
    endif
endfunction

function FFL_BindCommands takes nothing returns nothing
    if not FFL_CommandsBound and ForsakenSaveBlocked and udg_SaveCommandTrig!=null and udg_SaveToFileTrig!=null then
        call TriggerClearActions(udg_SaveCommandTrig)
        call TriggerAddAction(udg_SaveCommandTrig,function FFL_Chat)
        call TriggerClearActions(udg_SaveToFileTrig)
        call TriggerAddAction(udg_SaveToFileTrig,function FFL_Chat)
        set FFL_CommandsBound=true
    endif
endfunction

function FFL_Tick takes nothing returns nothing
    local integer pid=0
    call FFL_BindCommands()
    loop
        exitwhen pid>=8
        if FFL_Phase[pid]==1 and FRC_Phase[pid]==0 then
            set FFL_Phase[pid]=0
            if FRC_Ready[pid] then
                if FFL_SaveFile[pid] then
                    if not FST_LegacySaveMessages[pid] then
                        call FFL_Message(pid,"Writing the save file...")
                    endif
                    if not FST_Write(pid,FRC_Result[pid],FRC_Account(pid)) then
                        call FFL_Message(pid,"Save failed: "+FSC_Error[pid])
                    endif
                else
                    set FST_SavedCode[pid]=FRC_Result[pid]
                    call FST_ShowCode(pid,1)
                endif
            else
                call FFL_Message(pid,"Save failed: "+FRC_Error[pid])
            endif
        elseif FFL_Phase[pid]==2 and not FST_Pending[pid] then
            if FST_Ready[pid] then
                if FST_Legacy[pid] then
                    set FFL_Phase[pid]=0
                    call Trig_Cmd_Load_Code_LoadCodeDispatch(FST_Result[pid],Player(pid))
                elseif FFP_Build(pid,FST_Result[pid],FFL_WindowOpen) then
                    call FFL_Apply(pid)
                else
                    set FFL_Phase[pid]=0
                    call FFL_Message(pid,"Load failed: "+FFP_Error[pid])
                endif
            else
                set FFL_Phase[pid]=0
                call FFL_Message(pid,"Load failed: "+FST_Error[pid])
            endif
        elseif FFL_Phase[pid]==5 then
            if FFL_Restore(pid) then
                call FFL_Message(pid,"Load failed: "+FFL_FailureReason[pid]+". Nothing was changed; you can load again.")
            else
                set FFL_CleanupAttempts[pid]=FFL_CleanupAttempts[pid]-1
                if FFL_CleanupAttempts[pid]>0 then
                    set FFL_Phase[pid]=5
                else
                    call FFL_Message(pid,"Load failed: "+FFL_FailureReason[pid]+". Type -newcleanup, then load again.")
                endif
            endif
        elseif FFL_Phase[pid]==3 and FRC_Phase[pid]==0 then
            if FRC_Ready[pid] and FRC_Result[pid]==FFP_Code[pid] then
                call FFL_Commit(pid)
            else
                call FFL_Fail(pid,"full profile readback differs: "+FRC_Error[pid])
            endif
        endif
        set pid=pid+1
    endloop
endfunction

function FFL_CloseWindow takes nothing returns nothing
    set FFL_WindowOpen=false
endfunction

function FFL_LegacyAllowed takes nothing returns boolean
    local integer pid=GetPlayerId(GetTriggerPlayer())
    return not FFP_Locked[pid] and FFL_Phase[pid]==0 and not FFL_RoutesFile(GetEventPlayerChatString())
endfunction

function FFL_LegacyGuard takes nothing returns nothing
    call TriggerAddCondition(gg_trg_Cmd_Load_Code,Condition(function FFL_LegacyAllowed))
    call TriggerAddCondition(gg_trg_Cmd_Load_Armory,Condition(function FFL_LegacyAllowed))
    call TriggerAddCondition(udg_LoadFileTrigger,Condition(function FFL_LegacyAllowed))
    call DestroyTimer(GetExpiredTimer())
endfunction



function InitTrig_ForsakenFreshLoad takes nothing returns nothing
    local integer pid=0
    set Save_UseNewAutosave=true
    call FRC_Init()
    call FFP_Init()
    call FST_Init()
    set FFL_Before=InitHashtable()
    set FFL_Poll=CreateTimer()
    set FFL_Window=CreateTimer()
    call TimerStart(FFL_Poll,0.05,true,function FFL_Tick)
    call TimerStart(FFL_Window,900.,false,function FFL_CloseWindow)
    call TimerStart(CreateTimer(),2.,false,function FFL_LegacyGuard)
    set gg_trg_Forsaken_FreshLoad=CreateTrigger()
    loop
        exitwhen pid>=8
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_FreshLoad,Player(pid),"-load",false)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_FreshLoad,Player(pid),"-savepage ",false)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_FreshLoad,Player(pid),"-newsave",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_FreshLoad,Player(pid),"-newload",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_FreshLoad,Player(pid),"-newcleanup",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_FreshLoad,Player(pid),"-newretrycheck",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_FreshLoad,function FFL_Chat)
endfunction
endlibrary

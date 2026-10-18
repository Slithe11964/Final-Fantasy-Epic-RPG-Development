"""Completed legendary trials and durable multi-element/summon milestones.

Optional profile section 11 v1; older profiles omit it. Transient combo/timed
attempts deliberately restart, while completed tasks and durable steps persist.
"""
import re
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency


def refresh(source):
    fs=functions(source)
    if 'FRC_Section' in fs and 'sid == 11' not in fs['FRC_Section']:
        body=fs['FRC_Section']
        addition='''    elseif (sid == 11) then
        loop
            exitwhen i>=38
            set tier=0
            if i<23 then
                if IsPlayerInForce(owner,udg_JobMasterForce[i]) then
                    set tier=1
                elseif i<22 then
                    if FRC_Tier(pid,FRC_JobRaw(i))==3 then
                        set tier=1
                    endif
                elseif free!=null and GetUnitAbilityLevel(free,'A02F')>=4 then
                    set tier=1
                endif
            elseif i<29 then
                if IsPlayerInForce(owner,udg_WeakElementForce[i-22]) then
                    set tier=1
                endif
            elseif i<35 then
                if IsPlayerInForce(owner,udg_NullElementForce[i-28]) then
                    set tier=1
                endif
            elseif IsPlayerInForce(owner,udg_EidolonAwardForce[i-35]) then
                set tier=1
            endif
            if tier==1 then
                set body=FSS_Concat(body,FRC_Pair(i+1,1))
                set count=count+1
            endif
            set i=i+1
        endloop
        return FSS_Concat(FSC_Uint(count),body)
'''
        body=body.replace('    endif\n    return null',addition+'    endif\n    return null')
        source=put(source,'FRC_Section',body)
        body=fs['FRC_Step']
        body=re.sub(r'position\s*<\s*65', 'position < 66',body)
        body=body.replace('        if (sid == 3) then','        if sid==9 then\n            set sid=11\n        endif\n        if (sid == 3) then') if '(sid == 3)' in body else body.replace('        if sid==3 then','        if sid==9 then\n            set sid=11\n        endif\n        if sid==3 then')
        marker='        set encoded=FSC_Finish(pid,true)'
        body=body.replace(marker,'''        if not FSC_Add(pid,11,1,false,FRC_Payload[pid*16+11]) then
            call FSC_Abort(pid)
            set FRC_WriterOwned[pid]=false
            call FRC_Stop(pid,"legendary progress section refused")
            return
        endif
'''+marker)
        source=put(source,'FRC_Step',body)
    name=next((n for n in fs if n in ['FSC_ValidateSection','FSS_Call_FSC_ValidateSection_Impl'] and re.search(r'sid\s*>\s*9',fs[n])),None)
    if name and 'FSC_LegendProgress' not in fs:
        body=fs[name]
        body=re.sub(r'^    if (.+) then',lambda m:'    if sid==11 and schemaVersion==1 then\n        call FSC_LegendProgress(ctx)\n    elseif '+m[1]+' then',body,count=1,flags=re.M)
        source=put(source,name,body)
        helper='''function FSC_LegendProgress takes integer ctx returns nothing
    local integer count=FSC_Read(ctx)
    local integer i=0
    local integer identity
    local integer value
    call FlushChildHashtable(FSC_Seen,ctx*16+1)
    if count>38 then
        set FSC_Ok[ctx]=false
    endif
    loop
        exitwhen i>=count or not FSC_Ok[ctx]
        set identity=FSC_Read(ctx)
        set value=FSC_Read(ctx)
        if identity<1 or identity>38 or value!=1 then
            set FSC_Ok[ctx]=false
        elseif not FSC_Mark(ctx,1,identity) then
            set FSC_Ok[ctx]=false
        endif
        set i=i+1
    endloop
endfunction

'''
        source=source.replace('function '+name+' takes',helper+'function '+name+' takes',1)
    if 'FFP_ReadSection' in fs and 'sid==11' not in fs['FFP_ReadSection']:
        body=re.sub(r'^    if (.+) then',lambda m:'    if sid==11 then\n        set maximum=38\n    elseif '+m[1]+' then',fs['FFP_ReadSection'],count=1,flags=re.M)
        body=re.sub(r'^        if (.+sid.+==.+2.+) then',lambda m:'        if sid==11 and value!=1 then\n            return false\n        endif\n        if '+m[1]+' then',body,count=1,flags=re.M)
        source=put(source,'FFP_ReadSection',body)
        body=re.sub(r'FSC_Count\[ctx\]\s*==\s*7','(FSC_Count[ctx]==7 or FSC_Count[ctx]==8)',fs['FFP_Build'])
        body=re.sub(r'^        if (.+sid.+3.+sid.+1.+) then',lambda m:'        if sid==11 and FSC_Version[index]==1 and not FSC_Required[index] then\n            set valid=FFP_ReadSection(pid,ctx,sid,FSC_Payload[index])\n        elseif '+m[1]+' then',body,count=1,flags=re.M)
        source=put(source,'FFP_Build',body)
    if 'FFL_Snapshot' in fs and 'FFL_LegendFlags' not in fs:
        helper='''function FFL_LegendFlags takes integer pid,boolean snapshot,boolean restore returns boolean
    local integer i=0
    local integer weak=0
    local integer nulls=0
    local boolean flag
    local player owner=Player(pid)
    local force target
    loop
        exitwhen i>=38
        if i<23 then
            set target=udg_JobMasterForce[i]
        elseif i<29 then
            set target=udg_WeakElementForce[i-22]
        elseif i<35 then
            set target=udg_NullElementForce[i-28]
        else
            set target=udg_EidolonAwardForce[i-35]
        endif
        if snapshot then
            call SaveBoolean(FFL_Before,pid*16+11,i,IsPlayerInForce(owner,target))
        else
            if restore then
                set flag=LoadBoolean(FFL_Before,pid*16+11,i)
            else
                set flag=FFL_Val(pid,11,i+1)==1
            endif
            call FFL_Membership(owner,target,flag)
            if IsPlayerInForce(owner,target)!=flag then
                set target=null
                set owner=null
                return false
            endif
            if i>=23 and i<29 and flag then
                set weak=weak+1
            elseif i>=29 and i<35 and flag then
                set nulls=nulls+1
            endif
        endif
        set i=i+1
    endloop
    if not snapshot then
        set udg_WeakElementCount[pid]=weak
        set udg_NullElementCount[pid]=nulls
    endif
    set owner=null
    set target=null
    return true
endfunction

'''
        source=source.replace('function FFL_Snapshot takes',helper+'function FFL_Snapshot takes',1)
        body=fs['FFL_Snapshot'].replace('    set FFL_SnapshotTaken[pid]=true','    call FFL_LegendFlags(pid,true,false)\n    set FFL_SnapshotTaken[pid]=true')
        source=put(source,'FFL_Snapshot',body)
        body=fs['FFL_PlayerState'];at=body.index('    loop')
        body=body[:at]+'''    if not FFL_LegendFlags(pid,false,restore) then
        return false
    endif
'''+body[at:]
        source=put(source,'FFL_PlayerState',body)
    return source

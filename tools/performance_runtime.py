"""Reviewed runtime maintenance applied to both editor-master output profiles."""
from pathlib import Path
import re
from jtok import functions

ROOT=Path(__file__).resolve().parents[1]

def put(source,name,body):
    pattern=r'^function '+re.escape(name)+r' takes[^\n]*\n.*?^endfunction'
    if not re.search(pattern,source,re.M|re.S):raise ValueError('missing maintained function '+name)
    return re.sub(pattern,lambda _:body.strip(),source,count=1,flags=re.M|re.S)

def replace_once(body,old,new):
    if new in body:return body
    if body.count(old)!=1:raise ValueError('runtime maintenance anchor changed: '+old[:100])
    return body.replace(old,new,1)

def motion(source):
    fs=functions(source)
    for prefix in ('Missile','Knock'):
        name=prefix+'_Allocate'
        if name not in fs:continue
        count='udg_'+prefix+'Count'
        body=fs[name]
        body=replace_once(body,'    else\n        set '+count+'='+count+'+1',
            '    else\n        if '+count+'>=8190 then\n            return 0\n        endif\n        set '+count+'='+count+'+1')
        source=put(source,name,body)
        name=prefix+'_Register';body=functions(source)[name]
        body=replace_once(body,'    if udg_'+prefix+'ActiveCount==0 then',
            '    if l_idx<=0 or udg_'+prefix+'Next[l_idx]!=-1 then\n        return\n    endif\n    if udg_'+prefix+'ActiveCount==0 then')
        source=put(source,name,body)
        name=prefix+'_Free';body=functions(source)[name]
        body=replace_once(body,'    set udg_ArgIndex=l_idx',
            '    set udg_'+prefix+'Next[l_idx]=-2\n    set udg_ArgIndex=l_idx')
        if prefix=='Missile':
            body=replace_once(body,'    call TriggerEvaluate(udg_MissileImpactTrig)',
                '    call TriggerEvaluate(udg_MissileImpactTrig)\n    call DestroyGroup(udg_MissileHitGroup[l_idx])\n    set udg_MissileHitGroup[l_idx]=null\n    set udg_MissileCaster[l_idx]=null\n    set udg_MissileTarget[l_idx]=null\n    set gg_unit_h020_0269[l_idx]=null\n    set udg_MissileModelEffect[l_idx]=null\n    set udg_MissileTrailEffect[l_idx]=null')
        else:
            body=replace_once(body,'    call TriggerEvaluate(udg_KnockRemoveTrig)',
                '    call TriggerEvaluate(udg_KnockRemoveTrig)\n    set udg_KnockUnit[l_idx]=null\n    set udg_KnockSource[l_idx]=null')
        source=put(source,name,body)
        for name,anchor in ((prefix+'_Create','    set udg_'+prefix+('CollisionRange[d]=rd' if prefix=='Missile' else 'Unit[d]=t')),
                            (('Missile_CreateWithEffects' if prefix=='Missile' else 'Knock_Launch'),
                             ('    set udg_MissileCaster[d]=c' if prefix=='Missile' else '    set udg_KnockSpeed[d]=s'))):
            body=functions(source)[name]
            body=replace_once(body,anchor,'    if d==0 then\n        return 0\n    endif\n'+anchor)
            source=put(source,name,body)
        name=prefix+'_Update';body=functions(source)[name]
        if prefix=='Missile':
            body=replace_once(body,'            if udg_MissileAoE[d]>.0 then','            if udg_MissileNext[d]==-1 then\n            if udg_MissileAoE[d]>.0 then')
            body=replace_once(body,'        else\n            call Missile_Free(d)','            endif // Stop travel after an impact removes this projectile.\n        else\n            call Missile_Free(d)')
        source=put(source,name,body)
    if 'Text_IntToString' in functions(source):
        body=functions(source)['Text_IntToString'].replace('if(i<8192)then','if(i>=0 and i<8192)then').replace('if i<8192 then','if i>=0 and i<8192 then')
        source=put(source,'Text_IntToString',body)
    return source

def track_collection_mutations(source):
    # Presentation invalidation only; all membership decisions retain native semantics.
    for name in ('ForceAddPlayerSimple','ForceRemovePlayerSimple','ForceAddPlayer','ForceRemovePlayer','ForceClear'):
        source=re.sub(r'(?<![\w])'+name+r'\(', 'Collection_'+name+'(',source)
    return source

def collections(source):
    fs=functions(source)
    if 'Force_OfPlayer' in fs and 'Collection_Touch' not in fs:
        helper=(ROOT/'experiments/Forsaken/CollectionCache.j').read_text()
        block=re.search(r'^globals\n(.*?)^endglobals\n',helper,re.M|re.S)
        source=source.replace('endglobals',block[1]+'endglobals'+helper[block.end():],1)
    if 'Armory_InitCounter' in fs:
        if 'Armory_PollCounter' not in fs:
            source=source.replace('endglobals','    integer ArmoryCounterRevision=-1\nendglobals',1)
            source=source.replace('function Armory_InitCounter takes',"""function Armory_PollCounter takes nothing returns nothing
    local integer revision=CollectionArmoryRevision[GetPlayerId(GetLocalPlayer())]
    if revision!=ArmoryCounterRevision then
        call Armory_RefreshCounter()
        set ArmoryCounterRevision=revision
    endif
endfunction

function Armory_InitCounter takes""",1)
        body=functions(source)['Armory_InitCounter']
        body=replace_once(body,'    call Armory_RefreshCounter()','    set category=1\n    loop\n        exitwhen category>udg_SaveFlagCount\n        call Collection_Watch(udg_SaveFlagForce[category],1)\n        set category=category+1\n    endloop\n    call Armory_PollCounter()')
        body=body.replace('1.,true,function Armory_RefreshCounter','1.,true,function Armory_PollCounter')
        source=put(source,'Armory_InitCounter',body)
    if 'Chronicles_Init' in fs:
        helper=(ROOT/'experiments/Forsaken/ChronicleCache.j').read_text()
        block=re.search(r'^globals\n(.*?)^endglobals\n',helper,re.M|re.S)
        if 'ChroniclesCachedInventory' not in source:
            source=source.replace('endglobals',block[1]+'endglobals',1)
        source=put(source,'Chronicles_Tick',functions(helper)['Chronicles_Tick'])
        body=functions(source)['Chronicles_Init']
        body=replace_once(body,'    call Chronicles_Tick()',"""    set category=1
    loop
        exitwhen category>65
        call Collection_Watch(udg_TitleForce[category],2)
        set category=category+1
    endloop
    set gg_trg_CollectionInventory=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_CollectionInventory,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_CollectionInventory,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddAction(gg_trg_CollectionInventory,function Collection_InventoryChanged)
    call Chronicles_Tick()
    call Chronicles_RefreshTooltips()""")
        source=put(source,'Chronicles_Init',body)
    if 'TalentFrame_OnSync' in fs:
        body=functions(source)['TalentFrame_OnSync']
        # UI-open state is private; gameplay eligibility is checked by Talent_Choose.
        body=body.replace('    if TalentOpen[GetPlayerId(p)] then\n        call Talent_Choose(p,node/3,ModuloInteger(node,3)+1)\n        call TalentFrame_Show(p)\n    endif',
            '    call Talent_Choose(p,node/3,ModuloInteger(node,3)+1)\n    if TalentOpen[GetPlayerId(p)] then\n        call TalentFrame_Show(p)\n    endif')
        source=put(source,'TalentFrame_OnSync',body)
    # Do not rewrite the observers themselves recursively.
    chunks=[];position=0
    for match in re.finditer(r'^function Collection_\w+ takes.*?^endfunction',source,re.M|re.S):
        chunks.extend((track_collection_mutations(source[position:match.start()]),match[0]));position=match.end()
    chunks.append(track_collection_mutations(source[position:]))
    source=''.join(chunks)
    header=re.search(r'^library (\w+)([^\n]*)',source,re.M)
    if header and header[1]!='TForce' and 'Collection_' in source and not re.search(r'\bTForce\b',header[2]):
        suffix=header[0]+(', TForce' if ' requires ' in header[0] else ' requires TForce')
        source=source[:header.start()]+suffix+source[header.end():]
    return source

def native_panels(source):
    fs=functions(source)
    if 'Forsaken_FindFrame' not in fs:return source
    if 'Forsaken_FindFrameUncached' in fs:return source
    declarations="""    framehandle ForsakenCachedEquipment=null
    framehandle ForsakenCachedBackdrop=null
    boolean ForsakenFrameSearchRequested=true
    real ForsakenNextFrameRetry=0.
    real ForsakenNextPanelDraw=0.
    hashtable ForsakenStatReadCache=InitHashtable()
    boolean ForsakenStatReadActive=false
    unit ForsakenLastInspectTarget=null
    integer ForsakenLastInspectInventory=-1
"""
    source=source.replace('endglobals',declarations+'endglobals',1)
    original=fs['Forsaken_FindFrame'].replace('function Forsaken_FindFrame takes','function Forsaken_FindFrameUncached takes',1)
    cached="""function Forsaken_FindFrame takes string name returns framehandle
    local real now=TimerGetElapsed(ForsakenPanelClock)
    if ForsakenFrameSearchRequested or (ForsakenPanelOpen and now>=ForsakenNextFrameRetry and (ForsakenCachedEquipment==null or ForsakenCachedBackdrop==null)) then
        set ForsakenCachedEquipment=Forsaken_FindFrameUncached("SimpleEquipmentPanel")
        set ForsakenCachedBackdrop=Forsaken_FindFrameUncached("EquipmentPanelBackdrop")
        set ForsakenFrameSearchRequested=false
        set ForsakenNextFrameRetry=now+1.
    endif
    if name=="SimpleEquipmentPanel" then
        return ForsakenCachedEquipment
    endif
    return ForsakenCachedBackdrop
endfunction"""
    source=put(source,'Forsaken_FindFrame',original+'\n\n'+cached)
    # Purely visual redraw: never run magic-defense gameplay calculation locally.
    draw=fs['Forsaken_UpdatePanels'].replace('function Forsaken_UpdatePanels takes','function Forsaken_DrawPanels takes',1)
    first=draw.index('    set udg_CurrentHero=hero')
    last=draw.index('    if rank==2 then',first)
    draw=draw[:first]+draw[last:]
    draw=draw.replace('    if (ForsakenInspectTarget==null and GetLocalPlayer()==owner) or ForsakenInspectTarget==hero then',
        '    if ForsakenPanelOpen and ((ForsakenInspectTarget==null and GetLocalPlayer()==owner) or ForsakenInspectTarget==hero) then')
    source=source.replace('function Forsaken_PollPanels takes',draw+'\n\nfunction Forsaken_PollPanels takes',1)
    update=fs['Forsaken_UpdatePanels']
    first=update.index('    if rank==2 then')
    last=update.index('    set anchor=null',first)
    update=update[:first]+'    call Forsaken_DrawPanels(hero)\n'+update[last:]
    source=put(source,'Forsaken_UpdatePanels',update)
    poll=functions(source)['Forsaken_PollPanels']
    poll=poll.replace('    if ForsakenInspectTarget!=null and ForsakenInspectTarget!=Player_GetHero(GetOwningPlayer(ForsakenInspectTarget)) then\n        call Forsaken_RenderNPC(ForsakenInspectTarget)\n    endif',"""    if ForsakenPanelOpen and TimerGetElapsed(ForsakenPanelClock)>=ForsakenNextPanelDraw then
        if ForsakenInspectTarget!=null and ForsakenInspectTarget!=Player_GetHero(GetOwningPlayer(ForsakenInspectTarget)) then
            call Forsaken_RenderNPC(ForsakenInspectTarget)
        elseif ForsakenInspectTarget!=null then
            call Forsaken_DrawPanels(ForsakenInspectTarget)
        elseif hero!=null then
            call Forsaken_DrawPanels(hero)
        endif
        set ForsakenNextPanelDraw=TimerGetElapsed(ForsakenPanelClock)+.5
    endif""")
    poll=poll.replace('    if ForsakenPanelOpen and TimerGetElapsed', '''    if ForsakenInspectTarget!=null then
        if ForsakenLastInspectTarget!=ForsakenInspectTarget or ForsakenLastInspectInventory!=CollectionInventoryRevision[GetPlayerId(GetOwningPlayer(ForsakenInspectTarget))] then
            call Forsaken_RenderInspection(ForsakenInspectTarget)
            set ForsakenLastInspectTarget=ForsakenInspectTarget
            set ForsakenLastInspectInventory=CollectionInventoryRevision[GetPlayerId(GetOwningPlayer(ForsakenInspectTarget))]
        endif
    else
        set ForsakenLastInspectTarget=null
    endif
    if ForsakenPanelOpen and TimerGetElapsed''',1)
    source=put(source,'Forsaken_PollPanels',poll)
    for name in ('Forsaken_PanelClick','Forsaken_PanelAccess'):
        body=functions(source)[name]
        body=body.replace('    if GetLocalPlayer()==viewer then','    if GetLocalPlayer()==viewer then\n        set ForsakenFrameSearchRequested=true\n        set ForsakenNextPanelDraw=0.',1)
        source=put(source,name,body)
    # Reset handles after Warcraft checkpoint restoration; retry only on interaction/open.
    name='Forsaken_RebuildPanels'
    if name in functions(source):
        body=functions(source)[name].replace('    set ForsakenTalentAnchor=null',
            '    set ForsakenCachedEquipment=null\n    set ForsakenCachedBackdrop=null\n    set ForsakenFrameSearchRequested=true\n    set ForsakenNextPanelDraw=0.\n    set ForsakenTalentAnchor=null',1)
        source=put(source,name,body)
    name='Register_Forsaken_PanelAccess';body=functions(source)[name]
    body=body.replace('        call BlzTriggerRegisterPlayerKeyEvent(gg_trg_Forsaken_PanelAccess,Player(i),OSKEY_ESCAPE,0,true)',
        '        call BlzTriggerRegisterPlayerKeyEvent(gg_trg_Forsaken_PanelAccess,Player(i),OSKEY_ESCAPE,0,true)\n        call BlzTriggerRegisterPlayerKeyEvent(gg_trg_Forsaken_PanelAccess,Player(i),OSKEY_B,0,true)')
    source=put(source,name,body)
    # One display pass can query the same ability dozens of times. Cache per pass.
    if 'Forsaken_StatAbilityLevel' in fs:
        original=fs['Forsaken_StatAbilityLevel'].replace('function Forsaken_StatAbilityLevel takes','function Forsaken_StatAbilityLevelUncached takes',1)
        wrapper="""function Forsaken_StatAbilityLevel takes unit hero,integer raw returns integer
    local integer value
    if ForsakenStatReadActive and HaveSavedInteger(ForsakenStatReadCache,0,raw) then
        return LoadInteger(ForsakenStatReadCache,0,raw)
    endif
    set value=Forsaken_StatAbilityLevelUncached(hero,raw)
    if ForsakenStatReadActive then
        call SaveInteger(ForsakenStatReadCache,0,raw,value)
    endif
    return value
endfunction"""
        source=put(source,'Forsaken_StatAbilityLevel',original+'\n\n'+wrapper)
        original=functions(source)['Forsaken_RenderStats'].replace('function Forsaken_RenderStats takes','function Forsaken_RenderStatsUncached takes',1)
        wrapper="""function Forsaken_RenderStats takes unit hero returns nothing
    call FlushChildHashtable(ForsakenStatReadCache,0)
    set ForsakenStatReadActive=true
    call Forsaken_RenderStatsUncached(hero)
    set ForsakenStatReadActive=false
endfunction"""
        source=put(source,'Forsaken_RenderStats',original+'\n\n'+wrapper)
    return source

def refresh(source):
    return native_panels(collections(motion(source)))

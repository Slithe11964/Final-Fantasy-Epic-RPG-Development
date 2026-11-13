"""Keep Gaya stable during job changes and rebuild native travel UI after load."""
import re
from jtok import functions
from performance_runtime import put
from objdata import read_objects,write_objects
from priest_master import setf


def job_patch(source):
    fs=functions(source)
    if 'Job_GetHero' not in fs:return source
    body=fs['Job_GetHero']
    body=body.replace('    if(l_hero!=null)then','    if l_hero!=null and GetUnitTypeId(l_hero)==l_jobId then',1)
    marker='    call Gaya_RecreateSpirit(l_owner)'
    assert body.count(marker)==1
    source=put(source,'Job_GetHero',body.replace(marker,'    // Job allocation must preserve the live Gaya, including a shrine buyer.',1))
    body=fs['Trig_Job_Change_Actions']
    # Inline this action's zero-argument predicates so their scratch references
    # can be replaced by transaction locals without changing other callers.
    predicates={}
    for name,text in fs.items():
        match=re.search(r'returns boolean\s+return\s*(.*?)\s+endfunction',text,re.S)
        if name.startswith('Trig_Job_Change_') and match:
            predicates[name]=re.sub(r'//[^\n]*','',match[1]).strip()
    for _ in range(12):
        old=body
        for name,expr in predicates.items():body=body.replace(name+'()','('+expr+')')
        if body==old:break
    assert not re.search(r'Trig_Job_Change_\w+\(\)',body),'Unexpanded job predicate'
    local_names={
        'udg_TempPlayer':'jobOwner','udg_TempInteger':'jobScratch','udg_TempForce':'jobForce',
        'udg_NewHero':'jobNext','udg_SelectedJobId':'jobRaw','udg_JobUnlocked':'jobUnlocked',
        'udg_JobRequirementText':'jobRequirement','udg_SavedLifePercent':'jobLife',
        'udg_SavedManaPercent':'jobMana','udg_SavedFacing':'jobFacing','udg_HeroLoc':'jobLoc',
        'bj_forLoopAIndexEnd':'jobEnd','bj_forLoopAIndex':'jobSlot'}
    for before,after in local_names.items():body=re.sub(r'\b'+before+r'\b',after,body)
    body=body.replace('GetForLoopIndexA()','jobSlot')
    body=body.replace('udg_SavedItem[jobSlot]','JobSwitchItems[jobPid*6+jobSlot-1]')
    body=body.replace('GetBuyingUnit()','jobBuyer')
    body=body.replace('Player_GetHero(jobOwner)','jobHero')
    header='''    local player jobOwner=GetOwningPlayer(GetSoldUnit())
    local integer jobPid=GetPlayerId(jobOwner)
    local unit jobHero=Player_GetHero(jobOwner)
    local unit jobBuyer=GetBuyingUnit()
    local unit jobNext=null
    local integer jobRaw=0
    local integer jobScratch=0
    local integer jobSlot=0
    local integer jobEnd=0
    local boolean jobUnlocked=false
    local string jobRequirement=""
    local real jobLife=0.
    local real jobMana=0.
    local real jobFacing=0.
    local location jobLoc=null
    local force jobForce=null
'''
    body=body.replace('    local group l_tempGroup','    local group l_tempGroup\n'+header,1)
    # The event's purchased placeholder is always removed, including a reentrant
    # attempt. Never permit a broken active-hero reference to spawn extra jobs.
    marker='    call RemoveUnit(GetSoldUnit())'
    assert body.count(marker)==1
    body=body.replace(marker,marker+'''
    if JobSwitchBusy[jobPid] or jobHero==null or GetUnitTypeId(jobHero)==0 or GetUnitTypeId(jobHero)=='H01D' then
        return
    endif
    set JobSwitchBusy[jobPid]=true''',1)
    marker='    set jobNext=Job_GetHero(jobOwner,jobRaw)'
    assert body.count(marker)==1
    body=body.replace(marker,marker+'''
    if jobNext==null or GetUnitTypeId(jobNext)!=jobRaw or GetUnitTypeId(jobNext)=='H01D' then
        call DisplayTimedTextToPlayer(jobOwner,0,0,15,"The job could not be created. Your current hero has been kept.")
        return
    endif''',1)
    body=body.replace('call ReviveHeroLoc(jobNext,udg_TempPoint,true)','call ReviveHero(jobNext,GetUnitX(jobHero),GetUnitY(jobHero),true)')
    marker='    set udg_PlayerHero[jobScratch]=jobNext'
    assert body.count(marker)==1
    # Never index the authoritative hero array with a callback-owned scratch.
    body=body.replace(marker,'    set udg_PlayerHero[jobPid+1]=jobNext\n    set jobHero=jobNext',1)
    # Legacy consumers still receive their expected scratch inputs immediately
    # before execution; mutations they make cannot alter this transaction.
    body=re.sub(r'(?m)^(\s*)(call (?:Conditional)?TriggerExecute\([^\n]+)',
        lambda m:m[1]+'set udg_TempPlayer=jobOwner\n'+m[1]+'set udg_TempInteger=jobScratch\n'+m[1]+m[2],body)
    # Release the guard only if this invocation acquired it. The early busy
    # rejection must not release its outer transaction's lock.
    body=body.replace('    set JobSwitchBusy[jobPid]=true','    set JobSwitchBusy[jobPid]=true\n    set jobAcquired=true',1)
    body=body.replace('    local force jobForce=null','    local force jobForce=null\n    local boolean jobAcquired=false',1)
    cleanup='''    if jobAcquired then
        set JobSwitchBusy[jobPid]=false
    endif
    set jobOwner=null
    set jobHero=null
    set jobBuyer=null
    set jobNext=null
    set jobForce=null
    set jobLoc=null
'''
    body=re.sub(r'(?m)^(\s*)return\s*$',lambda m:cleanup+m[1]+'return',body)
    body=body.replace('endfunction',cleanup+'endfunction',1)
    declarations='    boolean array JobSwitchBusy\n    item array JobSwitchItems\n'
    source=source.replace('endglobals',declarations+'endglobals',1)
    source=put(source,'Trig_Job_Change_Actions',body)
    name='Trig_Job_Change_FilterSummoned'
    source=put(source,name,"function "+name+" takes nothing returns boolean\n    return IsUnitType(GetFilterUnit(),UNIT_TYPE_SUMMONED) and GetUnitTypeId(GetFilterUnit())!='H01D'\nendfunction")
    return source


def travel_patch(source):
    fs=functions(source)
    if 'ForsakenUI_Rebuild' in fs:
        name='ForsakenUI_Rebuild';body=fs[name]
        marker='    call ExecuteFunc("BazaarFrame_Rebuild")'
        assert body.count(marker)==1
        source=put(source,name,body.replace(marker,marker+'\n    call ExecuteFunc("TravelPanel_Rebuild")',1))
    if 'TravelPanel_Init' not in fs:return source
    source=source.replace('endglobals','    trigger TravelPanelClicks=null\n    trigger TravelPanelKeys=null\n    trigger TravelPanelSync=null\nendglobals',1)
    body=fs['TravelPanel_Init']
    for name,new in [('clicks','TravelPanelClicks'),('keys','TravelPanelKeys'),('sync','TravelPanelSync')]:
        body=body.replace('    local trigger '+name+'=CreateTrigger()\n','')
        body=re.sub(r'\b'+name+r'\b',new,body)
        body=body.replace('    set '+new+'=null\n','')
    marker='    call DestroyTimer(GetExpiredTimer())'
    assert body.count(marker)==1
    body=body.replace(marker,'''    if TravelPanelClicks!=null then
        call DestroyTrigger(TravelPanelClicks)
        call DestroyTrigger(TravelPanelKeys)
        call DestroyTrigger(TravelPanelSync)
    endif
    set TravelPanelClicks=CreateTrigger()
    set TravelPanelKeys=CreateTrigger()
    set TravelPanelSync=CreateTrigger()''',1)
    marker='    call BlzFrameSetVisible(TravelPanel,false)'
    assert body.count(marker)==1
    # Preserve shared menu/page state; render only the local player's open menu
    # after all replacement controls and listeners exist.
    marker='    call TriggerAddAction(TravelPanelSync,function TravelPanel_Sync)'
    body=body.replace(marker,marker+'''
    set pid=0
    loop
        exitwhen pid>=8
        set TravelEscapeEpoch[pid]=TravelEscapeEpoch[pid]+1
        if TravelVisible[pid] and GetLocalPlayer()==Player(pid) then
            call TravelPanel_Render(Player(pid))
        endif
        set pid=pid+1
    endloop''',1)
    source=put(source,'TravelPanel_Init',body)
    helpers='''function TravelPanel_Start takes nothing returns nothing
    call TravelPanel_Init()
    call DestroyTimer(GetExpiredTimer())
endfunction

function TravelPanel_Rebuild takes nothing returns nothing
    // Warcraft does not serialize UI frames. Do not destroy stale frame handles.
    set TravelPanel=null
    set TravelPanelTitle=null
    call TravelPanel_Init()
endfunction

'''
    source=source.replace('function Register_Travel_Dialog_Click takes',helpers+'function Register_Travel_Dialog_Click takes',1)
    name='Register_Travel_Dialog_Click';body=functions(source)[name]
    body=body.replace('false,function TravelPanel_Init)','false,function TravelPanel_Start)')
    return put(source,name,body)


def objects(data):
    if not data:return data
    table=read_objects(data,'w3a')
    obj=next((o for group in ('original','custom') for o in table[group] if (o['id'] or o['base'])=='ASpc'),None)
    if obj is None:
        obj=dict(base='ASpc',id=None,sets=[dict(flag=0,mods=[])])
        table['original'].append(obj)
    # Inventory UI is an item-class utility command, unaffected by Silence.
    # Keep the native command itself, binding, hotkey, slot and visual behavior.
    setf(obj,'aite',1)
    setf(obj,'aher',0)
    return write_objects(table,table['version'],'w3a')

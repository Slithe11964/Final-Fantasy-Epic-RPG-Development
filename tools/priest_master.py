"""Shared Priest Master talents and data-derived spell/buff presentation."""
import copy,re
from pathlib import Path
from objdata import read_objects,write_objects
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
ROOT=Path(__file__).resolve().parents[1]
HERE=ROOT/'experiments/Forsaken'
POSITIVE=set('B00F B08T B006 B007 BUfa B005 B01W B05A B07F B07G B08R B07H B08S B07I B08P B07J B08Q B06T B06W B00X B00S B06F Broa B01A B00K B07P B06L B082 B052 B04X B06N B076 B051 B07R B07S B018 B04B'.split())
SPECIAL=set('B06L B082 B052 B06N B076 B051 B07R B07S B018 B04B'.split())
ORDERS={'AUfa':'frostarmor','ACf2':'frostarmor','ANdh':'drunkenhaze','Ablo':'bloodlust','ACbb':'bloodlust',
        'Acri':'cripple','Auhf':'unholyfrenzy','ACif':'innerfire','Ainf':'innerfire',
        'Arej':'rejuvination','ACrj':'rejuvination','Aroa':'roar','ANbr':'battleroar','Afzy':'frenzy',
        'Absk':'bloodlust','ACcs':'curse','AIpr':'rejuvination','Aam2':'antimagicshell'}


def fields(o):return {(m['field'],m['level']):m['value'] for st in o['sets'] for m in st['mods']}
def at(f,key,rank,default=0):
    return next((f[key,r] for r in range(rank,0,-1) if (key,r) in f),default)
def setf(o,key,value,rank=0,kind=None,data=0):
    if kind is None:kind=3 if isinstance(value,str) else 2 if isinstance(value,float) else 0
    for st in o['sets']:
        st['mods'][:]=[m for m in st['mods'] if (m['field'],m['level'])!=(key,rank)]
        st['mods'].append(dict(field=key,type=kind,level=rank,data=data,value=value,end=0))


def plan(main,skin):
    table=read_objects(main,'w3a');index={o['id']:copy.deepcopy(o) for o in table['custom']}
    if skin:
        for o in read_objects(skin,'w3a')['custom']:
            if o['id'] in index:
                for st in o['sets']:
                    for m in st['mods']:setf(index[o['id']],m['field'],m['value'],m['level'],m['type'],m['data'])
    swift=copy.deepcopy(index['A00L']);swift['id']='pReg'
    f=fields(swift)
    for rank in range(1,12):
        duration=float(at(f,'adur',rank,12.))/2.
        setf(swift,'adur',duration,rank);setf(swift,'ahdu',duration,rank)
    index['pReg']=swift
    result=[]
    for raw,o in sorted(index.items()):
        # These player spells intentionally install a short placeholder and then
        # cast the real, rank-aware support buff from a proxy. Track that proxy.
        if raw in {'A00G','A0TZ','A01D'}:continue
        if o['base'] not in ORDERS:continue
        f=fields(o);levels=f.get(('alev',0),1)
        if not any(set(str(v).split(','))&POSITIVE for (key,rank),v in f.items() if key=='abuf'):continue
        # Do not turn enemy debuffs that reuse a marker into positive support casts.
        target=str(at(f,'atar',1,''))
        if ('enemy' in target or 'enemies' in target) and not any(x in target for x in ['friend','self']):continue
        clone=copy.deepcopy(o);clone['id']='pReg' if raw=='pReg' else 'pB'+format(len(result),'02X')
        if o['base']=='Absk':clone['base']='Ablo'
        if o['base']=='AIpr':clone['base']='Arej'
        setf(clone,'aher',0);setf(clone,'aite',0);setf(clone,'areq','');setf(clone,'arlv',0)
        setf(clone,'anam','Refresh: '+raw);setf(clone,'alev',levels)
        setf(clone,'acas',0.,1)
        for rank in range(1,levels+1):
            for key,value in [('amcs',0),('acdn',0.),('aran',99999.),('aare',.01),('acas',0.),('amsp',0)]:
                setf(clone,key,value,rank if key!='amsp' else 0)
            setf(clone,'atar','air,ground,friend,self,vulnerable,invulnerable',rank)
            if o['base']=='Absk':
                # Beneficial Berserk markers use zero native incoming-damage factor;
                # combat-script penalties remain attached to their original buff IDs.
                if at(f,'bsk3',rank,0.)!=0.:break
                setf(clone,'Blo1',float(at(f,'bsk2',rank,0.)),rank,data=1)
                setf(clone,'Blo2',float(at(f,'bsk1',rank,0.)),rank,data=2)
                setf(clone,'Blo3',1.,rank,data=3)
            if o['base']=='AIpr':
                setf(clone,'Rej1',float(at(f,'irl1',rank,0.)),rank,data=1)
                setf(clone,'Rej2',float(at(f,'irl2',rank,0.)),rank,data=2)
                setf(clone,'Rej3',3,rank,data=3)
        else:
            result.append(dict(raw=raw,object=o,clone=clone,levels=levels,order=ORDERS[o['base']],area=o['base'] in {'Aroa','ANbr'}))
    expanded=[]
    for e in result:
        f=fields(e['object'])
        buffs=sorted({b for rank in range(1,e['levels']+1) for b in str(at(f,'abuf',rank,'')).split(',') if b in POSITIVE})
        for buff in buffs:
            entry=copy.deepcopy(e);entry['buff']=buff
            clone=entry['clone'];clone['id']='pReg' if e['raw']=='pReg' else 'pB'+format(len(expanded),'02X')
            for rank in range(1,e['levels']+1):
                setf(clone,'abuf',buff if buff in str(at(f,'abuf',rank,'')).split(',') else '',rank)
                if buff in SPECIAL:
                    setf(clone,'adur',99999.,rank);setf(clone,'ahdu',99999.,rank)
                    if clone['base'] in {'AUfa','ACf2'}:setf(clone,'Ufa1',99999.,rank,data=1)
            expanded.append(entry)
    return dict(buff_entries=expanded,abilities=index)


def healing_description(config,raw,rank):
    f=fields(config['abilities'][raw]);mana=int(at(f,'amcs',rank,0))
    if raw=='A00M':return f"|cffffcc00Life Spell|r|nHeals [(5 x {mana} mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply."
    if raw=='A0OM':
        rate=float(at(f,'Etq1',rank,50.))/float(at(f,'Etq2',rank,.1))
        return f"Channels {rate:g} base HP per second to nearby allies for {float(at(f,'adur',rank,15.)):g} seconds. Acid Rain converts half: {rate/2:g} base HP/sec to allies and {rate/2:g} magic damage/sec to enemies in the same radius. Target healing/defense modifiers apply."
    if raw=='A0PC':return "Channels until cancelled. Every second, adds P = floor[(50 + floor(caster Intelligence / 4)) x Staff power] to nearby allies' queued HP recovery. HP ticks roll 93.75%-100%; queued MP recovery rolls 23.4375%-25%. Healing modifiers and other queued recovery apply."
    if raw=='A089':return f"|cffffcc00Life Spell|r|nRestores floor[(3 x {mana} mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply."
    return str(at(f,'aub1',rank,''))


def objects(data,config):
    table=read_objects(data,'w3a');index={o['id']:o for o in table['custom']}
    for e in config['buff_entries']:
        clone=read_objects(write_objects(dict(version=table['version'],original=[],custom=[e['clone']]),table['version'],'w3a'),'w3a')['custom'][0]
        old=index.get(clone['id'])
        if old and old!=clone:raise ValueError('reserved Priest ability differs: '+clone['id'])
        if not old:table['custom'].append(copy.deepcopy(clone))
    for o in table['custom']:
        if o['id'] in {'A00M','A0OM','A0PC','A089'}:
            for rank in range(1,fields(config['abilities'][o['id']]).get(('alev',0),1)+1):
                setf(o,'aub1',healing_description(config,o['id'],rank),rank)
        if o['id']=='A0OM':
            for rank in range(1,7):setf(o,'Etq1',0.,rank,data=1)
        if o['id']!='A00L':continue
        for st in o['sets']:
            for m in st['mods']:
                if m['field']=='aub1':
                    rank=m['level'];duration=at(fields(config['abilities']['A00L']),'adur',rank,12.)
                    m['value']=('|cffffcc00Life Spell|r|nHeals [(25 + caster Intelligence / 3, rounded down) x Staff power + target Strength / 4] HP per second for '+str(int(duration))+' seconds. Each tick varies from 93.75% to 100% of that amount. Swiftmend doubles the rate and halves the duration.')
                elif m['field']=='arut':
                    m['value']='Life spell. Healing each second: (25 + caster Intelligence / 3, rounded down) x Staff power + target Strength / 4; each tick rolls 93.75% to 100%. Rank increases duration from 12 to 60 seconds. Swiftmend keeps total healing and halves duration.'
    return write_objects(table,table['version'],'w3a')


def initializer(config):
    lines=['function Priest_MasterData takes nothing returns nothing']
    for i,buff in enumerate(sorted(POSITIVE)):lines.append("    set PriestBuffIds["+str(i)+"]='"+buff+"'")
    for buff in sorted(SPECIAL):lines.append("    call SaveBoolean(PriestBuffTypes,0,'"+buff+"',true)")
    lines.append('    set PriestBuffCount='+str(len(POSITIVE)))
    regen=fields(config['abilities']['A00L'])
    for rank in range(1,12):lines.append(f"    set PriestRegenDuration[{rank}]={float(at(regen,'adur',rank,12.))}")
    for raw in ['A00G','A0TZ','A00M','A0OM','A0W9','A0PC','A089']:
        f=fields(config['abilities'][raw])
        for rank in range(1,f.get(('alev',0),1)+1):
            text=healing_description(config,raw,rank).replace('\\','\\\\').replace('"','\\"').replace('\n','|n').replace('\r','')
            lines.append("    call SaveStr(PriestAbilityText,'"+raw+"',"+str(rank)+',"'+text+'")')
    for e in config['buff_entries']:
        raw=e['raw'];f=fields(e['object']);clone=e['clone']['id']
        lines+=['    call SaveInteger(PriestBuffTypes,\''+raw+'\',1,\''+clone+'\')',
                "    call SaveInteger(PriestBuffClone,'"+raw+"','"+e['buff']+"','"+clone+"')",
                '    call SaveStr(PriestBuffTypes,\''+raw+'\',2,"'+e['order']+'")',
                '    call SaveBoolean(PriestBuffTypes,\''+raw+'\',3,'+str(e['area']).lower()+')']
        for rank in range(1,e['levels']+1):
            buffs=[b for b in str(at(f,'abuf',rank,'')).split(',') if b in POSITIVE]
            for i,buff in enumerate(buffs):lines.append("    call SaveInteger(PriestBuffTypes,'"+raw+"',"+str(rank*16+i+1)+",'"+buff+"')")
            lines.append("    call SaveInteger(PriestBuffTypes,'"+raw+"',"+str(rank*16)+','+str(len(buffs))+')')
            lines.append("    call SaveReal(PriestBuffTypes,'"+raw+"',"+str(rank*16+9)+','+str(float(at(f,'aare',rank,500. if e['area'] else 0.)))+')')
            duration=float(at(f,'Ufa1',rank,15.)) if e['object']['base'] in {'AUfa','ACf2'} else float(at(f,'adur',rank,12. if raw=='A00L' else 15.))
            lines.append("    call SaveReal(PriestBuffTypes,'"+raw+"',"+str(rank*16+10)+','+str(duration)+')')
    f=fields(config['abilities']['A0OM'])
    for rank in range(1,f.get(('alev',0),6)+1):
        lines+=[f"    set PriestRainHealing[{rank}]={float(at(f,'Etq1',rank,50.))}",
                f"    set PriestRainRadius[{rank}]={float(at(f,'aare',rank,900.))}",
                f"    set PriestRainPeriod[{rank}]={float(at(f,'Etq2',rank,.1))}",
                f"    set PriestRainDuration[{rank}]={float(at(f,'adur',rank,15.))}"]
    body=lines[1:];chunks=[body[i:i+160] for i in range(0,len(body),160)]
    result=[]
    for i,chunk in enumerate(chunks):result.extend(['function Priest_MasterData'+str(i)+' takes nothing returns nothing']+chunk+['endfunction',''])
    result+=['function Priest_MasterData takes nothing returns nothing']
    result+=['    call ExecuteFunc("Priest_MasterData'+str(i)+'")' for i in range(len(chunks))]
    return '\n'.join(result+['endfunction'])


def refresh(source,config,*,native=False):
    fs=functions(source)
    if 'Talents_InitData' in fs:
        # Talents is below the classic backpack in the dependency graph. Keep
        # proficiency/spell runtime in Regen, above both, rather than creating a cycle.
        for dep in ['TProf','TProphet','TRunic','TWait']:
            source=source.replace(', '+dep+'\n','\n',1).replace(', '+dep+',',',',1)
        source=re.sub(r'^function Priest_\w+ takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
        source=re.sub(r'^\s*(?:hashtable|integer|real|unit|group|timer|string) (?:array )?Priest\w+[^\n]*\n','',source,flags=re.M)
        name='Talents_InitData';body=functions(source)[name]
        if '"Acid Rain"' not in body:
            body=body.replace('endfunction','''    set TalentName[Talent_Index(job,2,1)]="Acid Rain"
    set TalentText[Talent_Index(job,2,1)]="Tranquility converts half its healing into damage: heals allies for 50% and damages enemies for 50% of its current-rank base healing in the same radius."
    set TalentName[Talent_Index(job,2,2)]="Refresh"
    set TalentText[Talent_Index(job,2,2)]="Esuna refreshes food and stat buffs already on its target; special hero effects gain 3 seconds instead. Base cooldown becomes 45 seconds."
    set TalentName[Talent_Index(job,2,3)]="Swiftmend"
    set TalentText[Talent_Index(job,2,3)]="Regen delivers the same total healing in half the time: 30 seconds instead of 60 at master rank."
endfunction''')
        source=put(source,name,body)
        # Also update data carried by a previously prepared authoring source.
        body=functions(source)[name]
        body=re.sub(r'(set TalentText\[Talent_Index\(job,2,1\)\]=)"[^"\n]*"',
            r'\1"Tranquility converts half its healing into damage: heals allies for 50% and damages enemies for 50% of its current-rank base healing in the same radius."',body)
        body=re.sub(r'(set TalentText\[Talent_Index\(job,2,2\)\]=)"[^"\n]*"',
            r'\1"Esuna refreshes food and stat buffs already on its target; special hero effects gain 3 seconds instead. Base cooldown becomes 45 seconds."',body)
        source=put(source,name,body)
        name='Talents_Init';body=functions(source)[name]
        body=body.replace('    call Priest_MasterInit()\n','')
        source=put(source,name,body)
    if 'Trig_Esuna_Cast_Actions' in fs:
        source=source.replace('library TEsuna requires TTalents','library TEsuna')
        name='Trig_Esuna_Cast_Actions';body=functions(source)[name]
        body=re.sub(r"    if [^\n]*Talent_Active[^\n]*\n        call Priest_Refresh\(GetSpellTargetUnit\(\)\)\n    endif\n",'',body)
        source=put(source,name,body)
    if 'Trig_Regen_Cast_Actions' in fs:
        for dep in ['TTalents','TProphet','TRunic','TWait','TCooldown']:source=dependency(source,dep)
        declarations=(HERE/'PriestMaster.j').read_text().replace('PTTIPOFFSET','0' if native else '1');global_text,helper=declarations.split('// FUNCTIONS\n',1)
        for declaration in global_text.splitlines():
            match=re.match(r'\s*(\w+)\s+(?:array\s+)?(\w+)',declaration)
            if match and not re.search(r'^\s*'+match[1]+r'\s+(?:array\s+)?'+match[2]+r'\b',source,re.M):source=source.replace('endglobals',declaration+'\nendglobals',1)
        source=re.sub(r'(integer PriestTooltipOffset=)\d+',r'\g<1>'+('0' if native else '1'),source)
        helper=initializer(config)+'\n'+helper
        for name,body in functions(helper).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function Trig_Regen_Cast_IsRegen takes',body+'\n\nfunction Trig_Regen_Cast_IsRegen takes',1)
        name='RegisterTriggers_Regen_Part1';body=functions(source)[name]
        if 'call Priest_MasterInit()' not in body:body=body.replace('endfunction','    call Priest_MasterInit()\nendfunction')
        source=put(source,name,body)
        name='Trig_Regen_Cast_Actions';body=functions(source)[name]
        if 'Priest_Swiftmend' not in body:body=body.replace('endfunction','    call Priest_Swiftmend(GetTriggerUnit(),GetSpellTargetUnit(),GetSpellAbilityId())\nendfunction')
        source=put(source,name,body)
        name='Trig_Regen_Periodic_RegenUnit';body=functions(source)[name]
        if 'udg_HealOverTimeHash,GetHandleId(GetEnumUnit()),10' not in body:
            marker='                if(Trig_Regen_Periodic_IsHostileOwned())then'
            body=body.replace(marker,'                if LoadBoolean(udg_HealOverTimeHash,GetHandleId(GetEnumUnit()),10) then\n                    set udg_TempReal=udg_TempReal*2.\n                endif\n'+marker)
        source=put(source,name,body)
    if 'Trig_Cooldown_Scaling_Actions' in fs:
        source=source.replace(', TTalents','')
        if 'hashtable CooldownTalentBase' not in source:source=source.replace('endglobals','    hashtable CooldownTalentBase=InitHashtable()\nendglobals',1)
        helper='''function Cooldown_Base takes unit caster,integer raw,integer level returns real
    if HaveSavedReal(CooldownTalentBase,GetHandleId(caster),raw) then
        return LoadReal(CooldownTalentBase,GetHandleId(caster),raw)
    endif
    return BlzGetAbilityCooldown(raw,level)
endfunction'''
        if 'Cooldown_Base' in functions(source):source=put(source,'Cooldown_Base',helper)
        else:source=source.replace('function Trig_Cooldown_Scaling_Conditions takes',helper+'\n\nfunction Trig_Cooldown_Scaling_Conditions takes',1)
        name='Trig_Cooldown_Scaling_Actions';body=functions(source)[name]
        body=body.replace('Priest_CooldownBase(','Cooldown_Base(').replace('BlzGetAbilityCooldown(GetSpellAbilityId(),','Cooldown_Base(GetTriggerUnit(),GetSpellAbilityId(),')
        source=put(source,name,body)
    if 'Trig_Runic_Shield_Apply' in fs:
        name='Trig_Runic_Shield_Apply';body=functions(source)[name]
        if 'GetHandleId(t),9' not in body:body=body.replace('    call TimerStart(tm,duration-8,false',
            '    call SaveReal(udg_RunicHash,GetHandleId(t),9,I2R(duration)-8.)\n    call TimerStart(tm,duration-8,false')
        source=put(source,name,body)
    if 'Wait_Polled' in fs:
        if 'SupportBuffStamp' not in source:source=source.replace('endglobals','    hashtable SupportBuffStamp=InitHashtable()\n    timer SupportBuffClock=null\nendglobals',1)
        if 'timer SupportBuffClock' not in source:source=source.replace('endglobals','    timer SupportBuffClock=null\nendglobals',1)
        helper='''function SupportBuff_Now takes nothing returns real
    if SupportBuffClock==null then
        set SupportBuffClock=CreateTimer()
        call TimerStart(SupportBuffClock,1000000.,false,null)
    endif
    return TimerGetElapsed(SupportBuffClock)
endfunction

function SupportBuff_Refresh takes unit target returns nothing
    call SaveReal(SupportBuffStamp,GetHandleId(target),0,SupportBuff_Now())
endfunction

function SupportBuff_Wait takes unit target,real duration returns nothing
    local real started=SupportBuff_Now()
    local real ending=started+duration
    local real refreshed
    loop
        call Wait_Polled(ending-SupportBuff_Now())
        set refreshed=LoadReal(SupportBuffStamp,GetHandleId(target),0)
        if refreshed>=started and refreshed+duration>ending then
            set ending=refreshed+duration
        endif
        exitwhen ending<=SupportBuff_Now()
    endloop
endfunction'''
        for name,body in functions(helper).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function InitTrig_Wait takes',body+'\n\nfunction InitTrig_Wait takes',1)
    if 'Medicine_ApplyTimed' in fs:
        source=source.replace('call Wait_Polled(60.)','call SupportBuff_Wait(t,60.)')
    if native and 'Forsaken_TalentCanPurchase' in fs:
        if 'framehandle array ForsakenTalentDescription' not in source:
            source=source.replace('endglobals','    framehandle array ForsakenTalentDescription\n    framehandle array ForsakenTalentTooltip\nendglobals',1)
        name='Forsaken_TalentCanPurchase';body=functions(source)[name]
        body=body.replace('return node>=0 and node<3 and rank>=1 and TalentPick[Talent_PickIndex(key/100,TALENT_JOB_PRIEST,1)]==0',
            'return node>=0 and node<6 and row<rank and TalentPick[Talent_PickIndex(key/100,TALENT_JOB_PRIEST,row+1)]==0')
        source=put(source,name,body)
        for name in ['Forsaken_DrawPanels','Forsaken_UpdatePanels']:
            if name not in functions(source):continue
            body=functions(source)[name]
            body=body.replace('if node<3 then','if node<6 then').replace('Talent_PickIndex(playerIndex,job,1)','Talent_PickIndex(playerIndex,job,node/3+1)').replace('Talent_Index(job,1,column+1)','Talent_Index(job,node/3+1,column+1)')
            body=body.replace('''            if job==TALENT_JOB_PRIEST then
                if column==0 then''','''            if job==TALENT_JOB_PRIEST then
                if node>=3 and node<6 then
                    if column==0 then
                        set skill='A0OM'
                    elseif column==1 then
                        set skill='A0W9'
                    else
                        set skill='A00L'
                    endif
                elseif column==0 then''')
            if 'ForsakenTalentDescription[node]' not in body:
                body=body.replace('            set node=node+1','''            if job==TALENT_JOB_PRIEST and node<6 then
                call BlzFrameSetText(ForsakenTalentDescription[node],"|cffffcc00"+TalentName[Talent_Index(job,node/3+1,column+1)]+"|r|n|n"+TalentText[Talent_Index(job,node/3+1,column+1)])
            else
                call BlzFrameSetText(ForsakenTalentDescription[node],"No talent available yet.")
            endif
            set node=node+1''',1)
            line='                call BlzFrameSetTexture(ForsakenTalentIcon[node],BlzGetAbilityIcon(skill),0,true)'
            if 'set skill=\'A0OM\'' not in body:
                body=body.replace(line,"                if job==TALENT_JOB_PRIEST and node>=3 and node<6 then\n                    if column==0 then\n                        set skill='A0OM'\n                    elseif column==1 then\n                        set skill='A0W9'\n                    else\n                        set skill='A00L'\n                    endif\n                endif\n"+line,1)
            source=put(source,name,body)
        name='Register_Forsaken_PanelAccess';body=functions(source)[name]
        if 'set ForsakenTalentTooltip[node]=' not in body:
            marker='        call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_TalentClick,ForsakenTalentButton[node],FRAMEEVENT_CONTROL_CLICK)'
            body=body.replace(marker,marker+'''
        set ForsakenTalentTooltip[node]=BlzCreateFrame("EscMenuBackdrop",ForsakenTalentRoot,0,node+1)
        call BlzFrameSetPoint(ForsakenTalentTooltip[node],FRAMEPOINT_TOPLEFT,ForsakenTalentButton[node],FRAMEPOINT_BOTTOMLEFT,0.,-.003)
        call BlzFrameSetSize(ForsakenTalentTooltip[node],.245,.115)
        set ForsakenTalentDescription[node]=BlzCreateFrameByType("TEXT","PriestTalentDescription",ForsakenTalentTooltip[node],"",node+1)
        call BlzFrameSetPoint(ForsakenTalentDescription[node],FRAMEPOINT_TOPLEFT,ForsakenTalentTooltip[node],FRAMEPOINT_TOPLEFT,.012,-.012)
        call BlzFrameSetSize(ForsakenTalentDescription[node],.221,.091)
        call BlzFrameSetFont(ForsakenTalentDescription[node],"Fonts\\\\FRIZQT__.TTF",.008,0)
        call BlzFrameSetTooltip(ForsakenTalentButton[node],ForsakenTalentTooltip[node])
        call BlzFrameSetVisible(ForsakenTalentTooltip[node],false)''',1)
        source=put(source,name,body)
    if native and 'Forsaken_DrawPanels' in functions(source):
        name='Forsaken_DrawPanels';body=functions(source)[name]
        body=body.replace('local string mastery="Normal"','local string mastery="Novice"')
        if ' / 4 earned     Level ' not in body and '/4|nLevel ' not in body:
            start=body.index('            if job==TALENT_JOB_PRIEST then',body.index('GetPlayerName(owner)'))
            end=body.index('        endif',body.index('            endif',start)+len('            endif'))
            body=body[:start]+'            call BlzFrameSetText(ForsakenTalentPoints,"Points: "+I2S(rank)+" / 4 earned     Level "+mastery)\n'+body[end:]
        body=body.replace('I2S(rank)+" / 4 earned     Level "+mastery','I2S(rank)+"/4|nLevel "+mastery')
        body=re.sub(r'call BlzFrameSetText\(ForsakenTalentLabel\[node\],[^\n]*\)', 'call BlzFrameSetText(ForsakenTalentLabel[node],"")',body)
        # Eligibility is checked again by the click action. Enabled icons retain
        # mouseover tooltips even for selected, locked and inspection nodes.
        body=re.sub(r'call BlzFrameSetEnable\(ForsakenTalentButton\[node\],[^\n]*\)', 'call BlzFrameSetEnable(ForsakenTalentButton[node],true)',body)
        source=put(source,name,body)
        name='Register_Forsaken_PanelAccess';body=functions(source)[name]
        body=body.replace('BlzFrameSetSize(ForsakenTalentPoints,.15,.018)','BlzFrameSetSize(ForsakenTalentPoints,.205,.018)')
        body=body.replace('ForsakenTalentButton[node],FRAMEPOINT_BOTTOMLEFT,0.,-.003','ForsakenTalentRoot,FRAMEPOINT_TOPLEFT,.006,-.17')
        body=body.replace('BlzFrameSetSize(ForsakenTalentTooltip[node],.245,.115)','BlzFrameSetSize(ForsakenTalentTooltip[node],.233,.118)')
        body=body.replace('FRAMEPOINT_TOPLEFT,.012,-.012','FRAMEPOINT_TOPLEFT,.018,-.018')
        body=body.replace('BlzFrameSetSize(ForsakenTalentDescription[node],.221,.091)','BlzFrameSetSize(ForsakenTalentDescription[node],.197,.082)')
        source=put(source,name,body)
    return source

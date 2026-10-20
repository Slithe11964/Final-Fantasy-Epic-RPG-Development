"""One local tooltip writer; authored descriptions plus optional calculation sections."""
from pathlib import Path
import re
from damage_tooltips import KINDS,SUMMONS,MARK,FOOT,description,details
from priest_master import fields,at,setf
from objdata import read_objects,write_objects
from jtok import functions
from performance_runtime import put
from player_commands import quote

HEALS={'A00M','A10K','A0OM','A0PC','A089','A06Q','A00L','A04O','A03O','A05A','A0Z3','A0DG','A03L','A0Z4','A07J','A01M','A0O8'}
EFFECTS={'A0IG'}
TALENTS={'A00G':(1,1),'A0TZ':(1,2),'A00M':(1,3),'A0OM':(2,1),'A0W9':(2,2),'A00L':(2,3)}
HMARK='|n|n|cffffcc00Healing calculations|r|n'
EMARK='|n|n|cffffcc00Evasion calculations|r|n'


def catalogue(damage):
    result={}
    for raw in sorted(set(KINDS)|HEALS|EFFECTS|set(TALENTS)):
        if raw not in damage['abilities']:continue
        f=fields(damage['abilities'][raw]);ranks={}
        for rank in range(1,int(f.get(('alev',0),1))+1):
            base=str(at(f,'aub1',rank,'')).replace(FOOT,'').split(MARK)[0].split(HMARK)[0].split(EMARK)[0]
            calc=''
            if raw in KINDS:
                base=description(raw,rank,base,damage);calc=MARK+details(raw,rank,damage)
            mana=int(at(f,'amcs',rank,0))
            if raw=='A0IG':
                calc=EMARK+('Physical evasion +40. After normal low-hit-chance adjustments, incoming physical hit chance is multiplied by 0.8 (20% lower) when it is at least 2%. '
                    f'Lasts {float(at(f,"adur",rank,6.)):g} seconds. Magical hit chance is unchanged; this is not a flat 40% dodge chance.')
            if raw in HEALS:
                if raw in {'A01M','A0O8'}:
                    mult=str(15 if rank>=11 else rank+2) if raw=='A01M' else 'M'
                    calc=f'Base HP restored = floor[(max(3 x target level, target Strength) + 300) x {mult} / 2]. Base MP restored = 25% of that HP amount. Target recovery modifiers apply after this calculation.'
                    if raw=='A0O8':calc+=' M = learned Chakra rank + 2, or 15 at master rank; 8 if the caster has no learned Chakra.'
                elif raw in {'A00M','A10K'}:calc=f'(5 x {mana} mana cost + 5 x caster Intelligence) x Staff power HP on impact. Units along the path receive 25%. Target healing modifiers apply.'
                elif raw=='A0OM':
                    rate=float(at(f,'Etq1',rank,50.))/float(at(f,'Etq2',rank,.1))
                    base=re.sub(r'by [0-9,]+ HP per second',f'by {rate:g} HP per second',base)
                    calc=f'{float(at(f,"Etq1",rank,50.)):g} HP every {float(at(f,"Etq2",rank,.1)):g} seconds = {rate:g} base HP/sec, for {float(at(f,"adur",rank,15.)):g} seconds. Target healing modifiers apply.'
                elif raw=='A0PC':calc='Every second, adds P = floor[(50 + floor(caster Intelligence / 4)) x Staff power] to nearby allies\' queued HP recovery. HP ticks roll 93.75%-100%; queued MP recovery rolls 23.4375%-25%. Other queued recovery and target modifiers apply.'
                elif raw in {'A089','A06Q'}:calc=f'floor[(3 x {mana} mana cost + 3 x caster Intelligence) x Staff power] HP and 25% as MP for allies. Caster receives HP only. Target recovery modifiers apply.'
                elif raw=='A00L':calc=f'[(25 + floor(caster Intelligence / 3)) x Staff power + target Strength / 4] HP per second for {float(at(f,"adur",rank,12.)):g} seconds. Each tick rolls 93.75%-100% before target healing modifiers.'
                elif raw in {'A04O','A03O','A05A'}:calc=f'(10 x {mana} mana cost + 5 x caster Intelligence) x Staff power HP before target healing modifiers.'
                elif raw in {'A0Z3','A0DG','A03L'}:calc=f'floor[({(rank+4)*40} + 2 x caster Intelligence) x Staff power] MP damage. Restores actual MP drained, capped by the target\'s remaining MP; recovery is capped by your maximum MP.'
                else:calc=f'floor[(2 x {mana} mana cost + caster Intelligence) x Staff power] base HP damage per second while channeling. Restores HP equal to actual damage dealt, capped by your maximum HP.'
                calc=HMARK+calc
            ranks[rank]=(base,calc)
        result[raw]=ranks
    return result


def objects(data,config):
    if not data:return data
    table=read_objects(data,'w3a')
    for obj in table['custom']:
        for rank,(base,calc) in config.get(obj['id'],{}).items():setf(obj,'aub1',base+calc,rank)
    return write_objects(table,table['version'],'w3a')


def runtime(source,config):
    fs=functions(source)
    if 'Priest_RegenTooltip' not in fs:return source
    for decl in ['hashtable SpellCalcData=InitHashtable()','hashtable SpellCalcLast=InitHashtable()','hashtable SpellCalcCasting=InitHashtable()','integer array SpellCalcRaw','integer SpellCalcCount=0','boolean array SpellCalcHidden']:
        name=decl.split('=')[0].split()[-1]
        if not re.search(r'^\s*\w+\s+(?:array )?'+name+r'\b',source,re.M):source=source.replace('endglobals','    '+decl+'\nendglobals',1)
    lines=[]
    for i,(raw,ranks) in enumerate(sorted(config.items())):
        lines.append(f"    set SpellCalcRaw[{i}]='{raw}'")
        for rank,(base,calc) in ranks.items():
            lines += [f"    call SaveStr(SpellCalcData,'{raw}',{rank},{quote(base)})",f"    call SaveStr(SpellCalcData,'{raw}',{100+rank},{quote(calc)})"]
        row,choice=TALENTS.get(raw,(0,0))
        lines += [f"    call SaveInteger(SpellCalcData,'{raw}',-1,{row})",f"    call SaveInteger(SpellCalcData,'{raw}',-2,{choice})"]
        if raw in SUMMONS:lines.append(f"    call SaveInteger(SpellCalcData,'{raw}',-3,1)")
    lines.append('    set SpellCalcCount='+str(len(config)))
    chunks=[lines[i:i+100] for i in range(0,len(lines),100)]
    helpers='\n\n'.join('function SpellCalc_Data'+str(i)+' takes nothing returns nothing\n'+'\n'.join(chunk)+'\nendfunction' for i,chunk in enumerate(chunks))
    helpers+='\n\nfunction SpellCalc_InitData takes nothing returns nothing\n'+'\n'.join('    call ExecuteFunc("SpellCalc_Data'+str(i)+'")' for i in range(len(chunks)))+'\nendfunction\n\n'
    helpers+=(Path(__file__).resolve().parents[1]/'experiments/Forsaken/SpellCalculations.j').read_text()
    for name,body in functions(helpers).items():
        if name in functions(source):source=put(source,name,body)
        else:source=source.replace('function Priest_AbilityTalentTip takes',body+'\n\nfunction Priest_AbilityTalentTip takes',1)
    callbacks=[]
    for name in ['SpellCalc_CastBegin','SpellCalc_CastEnd']:
        callbacks.append(functions(source)[name].strip())
        source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
    source=re.sub(r'\n+function SpellCalc_Register takes',lambda m:'\n\n'+'\n\n'.join(callbacks)+'\n\nfunction SpellCalc_Register takes',source,count=1)
    source=put(source,'Priest_AbilityTalentTip','''function Priest_AbilityTalentTip takes unit hero,integer raw,integer row,integer choice returns nothing
    local integer rank=GetUnitAbilityLevel(hero,raw)
    if rank>0 then
        call BlzSetAbilityExtendedTooltip(raw,SpellCalc_Tooltip(hero,raw,rank),rank-1+PriestTooltipOffset)
    endif
endfunction''')
    source=put(source,'Priest_RegenTooltip','''function Priest_RegenTooltip takes nothing returns nothing
    call SpellCalc_Update()
endfunction''')
    body=functions(source)['Priest_MasterInit']
    if 'SpellCalc_InitData()' not in body:body=body.replace('    call Priest_MasterData()','    call Priest_MasterData()\n    call SpellCalc_InitData()\n    call SpellCalc_Register()')
    return put(source,'Priest_MasterInit',body)

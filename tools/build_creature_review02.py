"""Normal-baseline review, live stats and source-derived spell calculations."""
from pathlib import Path
import sys,re,json,copy,csv
sys.path.insert(0,str(Path(__file__).resolve().parent))
import build_creature_review as build
from mpq import MPQ
from objdata import read_objects,write_objects
from priest_master import fields,setf,at
from jtok import functions
from performance_runtime import put
from asset_gallery_catalogue import slk
import damage_tooltips as dt

ROOT=build.ROOT
ORIGINAL_CATALOGUE=build.catalogue
ROWS=[];ABILITIES={};SPELLS={};MECHANICS={};LEVELS={};UNIT_OBJECTS={}
GEAR={};RANKS={}
CURRENT_SOURCES=None
STOCK={r['alias']:r for r in slk((ROOT/'tools/build-inputs/abilitydata-review.slk').read_bytes()) if 'alias' in r}
META=slk((ROOT/'tools/build-inputs/abilitymetadata-review.slk').read_bytes())
LABELS={m[1]:m[2] for m in re.finditer(r'^(\w+)\s*=\s*"?(.*?)"?\s*$',(ROOT/'tools/build-inputs/worldeditstrings-review.txt').read_text(encoding='utf-8-sig'),re.M)}
STOCK_TEXT=json.loads((ROOT/'tools/build-inputs/stock-ability-text-review.json').read_text())

def chunks(text,limit=720):
    text=re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',str(text)).replace('|n','\n')
    result=[]
    for line in text.splitlines():
        while len(line.encode())>limit:
            cut=min(limit,len(line));result.append(line[:cut]);line=line[cut:]
        if result and len((result[-1]+'\n'+line).encode())<=limit:result[-1]+='\n'+line
        else:result.append(line)
    return [x for x in result if x.strip()]

def clean(s):
    s=re.sub(r'\$([A-Fa-f0-9]+)',lambda m:str(int(m[1],16)),s)
    for a,b in [('GetSpellAbilityUnit()','caster'),('GetTriggerUnit()','caster'),('GetEnumUnit()','target'),('GetSpellTargetUnit()','target'),('GetUnitLevel(caster)','caster level'),('udg_TempInteger','amount'),('udg_TempReal','power'),('GetHeroInt(caster, true)','caster INT'),('GetHeroStr(caster, true)','caster STR'),('GetHeroAgi(caster, true)','caster AGI')]:s=s.replace(a,b)
    return s.replace('udg_','').replace('I2R(','real(').replace('R2I(','truncate(').replace('*',' x ')

def trace(fs,roots):
    seen=set();todo=[(r,0) for r in roots];out=[]
    while todo:
        n,depth=todo.pop(0)
        if n in seen or n not in fs or depth>4:continue
        seen.add(n);b=fs[n]
        if len(seen)>250:break
        calls=re.findall(r'\b(?:call\s+|function\s+)(\w+)',b)+re.findall(r'\b(Trig_\w+)\(',b)
        for c in calls:
            if c in fs and c not in seen and not c.startswith(('Register','Cine_','Text_','Quest','Trig_Damage_Engine_','Forsaken_')):todo.append((c,depth+1))
        lines=[]
        for line in b.splitlines():
            line=line.split('//')[0].strip()
            if re.search(r'(UnitDamageTarget|UnitDamagePoint|SetUnitLife|SetWidgetLife|SetUnitMana|SetUnitState.*UNIT_STATE_(LIFE|MANA)|Unit_Heal|Heal_|HealUnit|BlzUnitHeal|UnitAddAbility|UnitRemoveAbility|SetUnitAbilityLevel|IssueTargetOrder|IssuePointOrder|CreateNUnits|SetUnitMoveSpeed)',line):lines.append(clean(line.removeprefix('call ')))
        if lines:
            calculations=[]
            for l in b.splitlines():
                l=l.strip().split('//')[0]
                if l.startswith(('if ','if(','elseif ','elseif(','else','endif','loop','exitwhen')):
                    calculations.append(clean(l).replace('elseif','Otherwise if').replace('endif','End condition').replace('exitwhen','Until').replace('loop','Repeat'))
                elif re.match(r'(?:set|local (?:real|integer)) ',l) and not re.search(r'=\s*(?:Create|GetUnitLoc|GetRect|GetLastCreated|GetEnumUnit|GetTriggerUnit|GetSpellAbilityUnit)',l) and not re.search(r'(TempPoint|TempGroup|LoopIndex|=null)',l):calculations.append(clean(l.removeprefix('set ')))
            title=n.removeprefix('Trig_').replace('_Actions','').replace('_',' ')
            out.append(title+':\n'+'\n'.join(calculations+lines))
    return '\n\n'.join(out)

def native_details(raw,rank):
    o=ABILITIES.get(raw);f=fields(o) if o else {};base=o['base'] if o else raw
    stock=STOCK.get(base,STOCK.get(raw,{}));code=stock.get('code',base)
    values=[]
    for m in META:
        uses=m.get('useSpecific','').split(',')
        if m.get('field')!='Data' or not ({base,code,raw}&set(uses)):continue
        label=LABELS.get(m.get('displayName',''),m['ID'])
        data=int(m.get('data','0') or 0)
        if data<1 or data>26:continue
        val=at(f,m['ID'],rank,None)
        if val is None:val=stock.get('Data'+chr(64+data)+str(min(rank,int(stock.get('levels','1') or 1))))
        if val in [None,'-','_','']:continue
        if isinstance(val,float):val=f'{val:g}'
        values.append(f'{label}: {val}')
    return '\n'.join(dict.fromkeys(values)) or 'No direct damage/heal amount: passive, status, summon or scripted proxy. See scripted calculation below where applicable.'

def catalogue(base,script):
    global ROWS,ABILITIES,UNIT_OBJECTS
    rows,audit,fs=ORIGINAL_CATALOGUE(base,script)
    strings=build.wts_read(base.read('war3map.wts'))
    for ext,dest in [('w3a',ABILITIES),('w3u',UNIT_OBJECTS)]:
        t=read_objects(base.read('war3map.'+ext),ext)
        for o in t['original']+t['custom']:dest[o['id'] or o['base']]=copy.deepcopy(o)
    # Resolve inherited stock abilities, not just explicit map overrides.
    stock_units={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes()) if 'unitAbilID' in r}
    for row in rows:
        raw=row['raw'];o=UNIT_OBJECTS.get(raw,{});f=fields(o) if o else {}
        stock_row=stock_units.get(o.get('base',raw),{})
        inherited=[]
        if ('uabi',None) not in f:inherited.extend(stock_row.get('abilList','').split(','))
        if ('uhab',None) not in f:inherited.extend(stock_row.get('heroAbilList','').split(','))
        present={a['raw'] for a in row['abilities']}
        row['abilities'].extend(dict(raw=a,name=a) for a in inherited if len(a)==4 and a not in present)
        for a in row['abilities']:
            if a['raw'] not in ABILITIES and a['raw'] in STOCK:
                o=dict(base=a['raw'],id=None,sets=[dict(flag=0,mods=[])])
                setf(o,'alev',int(STOCK[a['raw']].get('levels','1') or 1),0)
                ABILITIES[a['raw']]=o
            if a['raw'] in ABILITIES:
                v=fields(ABILITIES[a['raw']]);a['name']=str(v.get(('anam',0),a['name']))
                if a['name'].startswith('TRIGSTR_'):a['name']=strings.get(int(a['name'][8:]),a['name'])
                if a['name']==a['raw']:a['name']=STOCK_TEXT.get(a['raw'],{}).get('Name',a['name']).strip('"')
        LEVELS[raw]=1
    # Reproduce authored hero levels from fixed placements and unambiguous spawn routines.
    for m in re.finditer(r"SetHeroLevel(?:BJ)?\(\s*(gg_unit_(.{4})_\d+),\s*(\d+)",script):LEVELS[m[2]]=int(m[3])
    for b in fs.values():
        raws=set(re.findall(r"CreateNUnitsAtLoc(?:FacingLocBJ)?\([^,]+,\s*'(.{4})'",b))
        levels=re.findall(r'SetHeroLevel(?:BJ)?\([^,]+,\s*(\d+)',b)
        if len(raws)==1 and levels:LEVELS[next(iter(raws))]=int(levels[0])
    # Track concrete spawn variables through each authored setup function.
    for b in fs.values():
        variables={};current=None
        for line in b.splitlines():
            m=re.search(r"UnitAddItemToSlotById\(\s*gg_unit_(.{4})_\d+,\s*'(.{4})'",line)
            if m:GEAR.setdefault(m[1],[]).append(m[2])
            m=re.search(r"SelectHeroSkill\(\s*gg_unit_(.{4})_\d+,\s*'(.{4})'",line)
            if m:
                ranks=RANKS.setdefault(m[1],{});ranks[m[2]]=ranks.get(m[2],0)+1
            m=re.search(r"CreateNUnitsAtLoc(?:FacingLocBJ)?\([^,]+,\s*'(.{4})'",line)
            if m:current=m[1]
            m=re.search(r'set\s+(\w+)=GetLastCreatedUnit\(\)',line)
            if m and current:variables[m[1]]=current
            m=re.search(r'SetHeroLevel(?:BJ)?\(\s*([^,]+),\s*(\d+)',line)
            if m:
                target=m[1].strip();raw=variables.get(target)
                if target.startswith('gg_unit_'):raw=target[8:12]
                if raw:LEVELS[raw]=int(m[2])
            m=re.search(r"UnitAddItemById(?:Swapped)?\(\s*'(.{4})',\s*([^,)]+)\)",line)
            if m:
                target=m[2].strip();raw=variables.get(target)
                if target.startswith('gg_unit_'):raw=target[8:12]
                if raw in UNIT_OBJECTS:GEAR.setdefault(raw,[]).append(m[1])
            m=re.search(r"SetUnitAbilityLevelSwapped\(\s*'(.{4})',\s*([^,]+),\s*(\d+)\)",line)
            if m:
                target=m[2].strip();raw=variables.get(target)
                if target.startswith('gg_unit_'):raw=target[8:12]
                if raw:RANKS.setdefault(raw,{})[m[1]]=int(m[3])
    for raw,items in GEAR.items():GEAR[raw]=list(dict.fromkeys(items))[:6]
    all_sources=CURRENT_SOURCES if CURRENT_SOURCES is not None else {p:p.read_text(encoding='utf-8-sig') for p in (ROOT/'src/triggers').rglob('*.j') if 'Startup coordinator' not in str(p)}
    aod_files={p for p,t in all_sources.items() if 'udg_DuelArenaPlayers' in t}
    aod=set();story=set()
    for p,t in all_sources.items():
        refs=(set(re.findall(r"'(.{4})'",t))|set(re.findall(r'gg_unit_(.{4})_\d+',t)))&set(UNIT_OBJECTS)
        if p in aod_files:aod.update(refs)
        if '06 Quests and story' in str(p) or p.name in ['Boss_Gafgarion.j','Boss_Zalera.j','Boss_Chaos.j','Boss_OrcChieftain.j']:story.update(refs)
    battle=set(re.findall(r"set udg_ArenaMonsterType\[[^\]]+\]\s*=\s*'(.{4})'",script))
    # Keep world spawn pools beside their later variants; duplicate encounter
    # versions in their encounter sections so cross-category units remain findable.
    grouped=[r for r in rows if r['area']<10]
    unique={r['raw']:r for r in rows}
    aliases={'N0LU':'Gilgamesh II','U01T':'Ozma','U01N':'Shinryu Altana','N03K':'Penance'}
    for raw,name in aliases.items():
        if raw in unique:unique[raw]['name']=name+' ('+unique[raw]['name']+')'
    for section,raws in [(10,aod),(11,story-aod),(12,battle)]:
        for raw in sorted(raws&set(unique),key=lambda r:(not r[0].isupper(),unique[r]['name'])):
            r=copy.deepcopy(unique[raw]);r.update(area=section,area_name=build.AREAS[section],section=build.AREAS[section],origin=build.AREAS[section]);grouped.append(r)
    covered={r['raw'] for r in grouped}
    for raw in sorted(set(unique)-covered):
        r=copy.deepcopy(unique[raw]);r.update(area=11,area_name=build.AREAS[11],section='Other world/story encounter or helper');grouped.append(r)
    # Index actual on-card spells against their conditions/actions and helpers.
    config=dt.catalogue(base.read('war3map.w3a'),base.read('war3mapSkin.w3a'),base.read('war3map.w3t'),base.read('war3mapSkin.w3t'))
    reverse={}
    for n,b in fs.items():
        for c in set(re.findall(r'\b(?:function\s+|call\s+)(\w+)',b)+re.findall(r'\b(Trig_\w+)\(',b)):
            if c!=n:reverse.setdefault(c,set()).add(n)
    native_actions=set()
    for raw in {a['raw'] for r in grouped for a in r['abilities']}:
        roots=[]
        for n,b in fs.items():
            if "'"+raw+"'" in b and ('GetSpellAbilityId' in b or ('GetUnitAbilityLevel' in b and not n.startswith(('Forsaken','Trig_Damage')))):
                roots.append(n)
                if n.endswith('_Conditions'):roots.append(n[:-11]+'_Actions')
        # Follow condition wrappers to their event registration and its action.
        frontier=roots[:];visited=set()
        for _ in range(4):
            newer=[]
            for n in frontier:
                for parent in reverse.get(n,[]):
                    if parent in visited:continue
                    visited.add(parent)
                    if parent.startswith(('Register','InitTrig')):
                        actions=re.findall(r'TriggerAddAction\([^,]+,\s*function (\w+)',fs[parent]);roots.extend(actions)
                        if 'EVENT_PLAYER_UNIT_SPELL_' in fs[parent]:native_actions.update(actions)
                    else:newer.append(parent)
            frontier=newer
        native_actions.update(n for n in roots if 'GetSpellAbilityId' in fs.get(n,''))
        traced=trace(fs,roots)
        o=ABILITIES.get(raw);levelcount=fields(o).get(('alev',0),1) if o else 1
        entries=[]
        for rank in range(1,min(100,int(levelcount))+1):
            if raw in dt.KINDS:
                desc='Hero-caster formula (where applicable): '+dt.details(raw,rank,config)
            else:desc=native_details(raw,rank)
            if traced:desc+='\nScript calculation (conditions and per-hit/pulse assignments are retained):\n'+traced
            entries.append(desc)
        SPELLS[raw]=entries
    # Unit-specific scripted mechanics, excluding native command-card abilities.
    for raw,r in unique.items():
        texts=[]
        for p,t in all_sources.items():
            if p.name.startswith('Arena_'):continue
            if ("'"+raw+"'" in t or 'gg_unit_'+raw+'_' in t) and (p.name.startswith('Boss_') or '04 Combat and abilities' in str(p)):
                localfs=functions(t)
                root=[n for n,b in localfs.items() if n not in native_actions and not n.startswith(('Register','InitTrig')) and re.search(r'UnitDamage|SetUnitLife|SetWidgetLife|SetUnitState.*UNIT_STATE_(LIFE|MANA)|BlzUnitHeal|Unit_Heal|UnitAddAbility|UnitRemoveAbility|SetUnitAbilityLevel|IssueTargetOrder|IssuePointOrder|CreateNUnits|SetUnitMoveSpeed',b)]
                desc=trace(fs,root)
                if desc:texts.append(p.stem.replace('_',' ')+':\n'+desc)
        MECHANICS[raw]='\n\n'.join(dict.fromkeys(texts)) or 'No additional unit-specific scripted damage/healing mechanic found in the encounter sources. Standard abilities are listed by -abilities and on their command card.'
    ROWS=grouped
    audit['normal_baseline']='Normal / one player, 100% HP handicap, difficulty scale 1. Authored hero spawn levels; no forced level 10.'
    return grouped,audit,fs

EXTRA=r'''
function Review02_Stats takes unit u returns nothing
    local integer element=1
    local string names=""
    local string origin=LoadStr(ReviewHash,GetHandleId(u),0)
    local string sources=LoadStr(Review02Data,GetUnitTypeId(u),-3)
    call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,GetUnitName(u)+" | Normal, one-player baseline | Level "+I2S(GetUnitLevel(u)))
    if origin!=null and origin!="" then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,origin)
    endif
    if sources!=null and sources!="" then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,sources)
    endif
    call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"HP "+R2SW(GetWidgetLife(u),1,0)+" / "+I2S(BlzGetUnitMaxHP(u))+"; MP "+R2SW(GetUnitState(u,UNIT_STATE_MANA),1,0)+" / "+I2S(BlzGetUnitMaxMana(u)))
    call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"Accuracy "+R2SW(Trig_Damage_Engine_GetAccuracy(u),1,2)+"; Evasion "+R2SW(Trig_Damage_Engine_GetEvasion(u),1,2)+"; Armor "+R2SW(BlzGetUnitArmor(u),1,2))
    call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"NPC magic defense (native armor) "+R2SW(BlzGetUnitArmor(u),1,2)+"; Attack "+I2S(BlzGetUnitBaseDamage(u,0))+" + "+I2S(BlzGetUnitWeaponIntegerField(u,UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE,0))+"d"+I2S(BlzGetUnitWeaponIntegerField(u,UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE,0))+"; Attack interval "+R2SW(BlzGetUnitAttackCooldown(u,0),1,2)+"s; Move speed "+R2SW(GetUnitMoveSpeed(u),1,0))
    call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"Base HP regen "+R2SW(BlzGetUnitRealField(u,UNIT_RF_HIT_POINTS_REGENERATION_RATE),1,2)+"/s; MP regen "+R2SW(BlzGetUnitRealField(u,UNIT_RF_MANA_REGENERATION),1,2)+"/s. Auras and scripted effects are additional.")
    if IsUnitType(u,UNIT_TYPE_HERO) then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"STR "+I2S(GetHeroStr(u,true))+"; AGI "+I2S(GetHeroAgi(u,true))+"; INT "+I2S(GetHeroInt(u,true)))
    endif
    loop
        exitwhen element>7
        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,LoadStr(Review02Data,0,element)+": "+Review02_Resist(Trig_Damage_Engine_GetElementResist(u,element)))
        set element=element+1
    endloop
endfunction

function Review02_Pages takes unit u,integer page,integer kind returns nothing
    local integer raw=GetUnitTypeId(u)
    local integer count=LoadInteger(Review02Data,raw,kind)
    local integer i=IMaxBJ(0,page-1)*5
    local integer last=IMinBJ(count,i+5)
    if count<=0 then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"No catalogue entry for this practice target. Select a gallery creature.")
        return
    endif
    if i>=count then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"No further pages. Use -spells or -abilities, optionally followed by a page number.")
    endif
    loop
        exitwhen i>=last
        call DisplayTimedTextToPlayer(Player(0),0.,0.,60.,LoadStr(Review02Data,raw,kind+1+i))
        set i=i+1
    endloop
    call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,"Page "+I2S(IMaxBJ(1,page))+" / "+I2S((count+4)/5)+". Calculations are before target mitigation; conditional branches/per-hit effects are separate. Encounter AI is not automatically running in this review.")
endfunction
'''

def script_hook(script,rows):
    fs=functions(script);lines=['    set Review02Data=InitHashtable()','    set udg_Difficulty=3','    set udg_DifficultyScale=1.','    set udg_EnemyHpPerPlayer=100.','    set udg_EnemyHandicap=100.','    set udg_ExpRate=1.','    call SetPlayerHandicap(Player(0),1.)','    call SetPlayerHandicap(Player(11),1.)','    call Review02_EnemyTech()','    call SetPlayerTechResearched(Player(0),\'R01R\',3)','    call SetPlayerTechResearched(Player(11),\'R01R\',3)']
    for i,name in enumerate(['Fire','Ice','Thunder','Water','Earth','Wind','Omni'],1):lines.append(f'    call SaveStr(Review02Data,0,{i},"{name}")')
    for raw in sorted({r['raw'] for r in rows}):
        lines.append(f"    call SaveInteger(Review02Data,'{raw}',-1,{LEVELS.get(raw,1)})")
        name=next(r['name'] for r in rows if r['raw']==raw)
        lines.append(f"    call SaveStr(Review02Data,'{raw}',-2,{build.q(name)})")
        origins='Sources: '+', '.join(sorted({r['area_name'] for r in rows if r['raw']==raw}))
        lines.append(f"    call SaveStr(Review02Data,'{raw}',-3,{build.q(origins)})")
        gear=GEAR.get(raw,[]);lines.append(f"    call SaveInteger(Review02Data,'{raw}',3000,{len(gear)})")
        for i,item in enumerate(gear):lines.append(f"    call SaveInteger(Review02Data,'{raw}',{3001+i},'{item}')")
        skills=RANKS.get(raw,{})
        lines.append(f"    call SaveInteger(Review02Data,'{raw}',3500,{len(skills)})")
        for i,(a,rank) in enumerate(skills.items()):lines.extend([f"    call SaveInteger(Review02Data,'{raw}',{3501+i*2},'{a}')",f"    call SaveInteger(Review02Data,'{raw}',{3502+i*2},{rank})"])
        for kind,text in [(1000,MECHANICS[raw]),(2000,'\n\n'.join(a['name']+' ['+a['raw']+']\n'+SPELLS.get(a['raw'],['No active calculation.'])[0] for a in next(r for r in rows if r['raw']==raw)['abilities']))]:
            parts=chunks(text)
            lines.append(f"    call SaveInteger(Review02Data,'{raw}',{kind},{len(parts)})")
            for i,p in enumerate(parts):lines.append(f"    call SaveStr(Review02Data,'{raw}',{kind+1+i},{build.q(p)})")
    groups=[lines[i:i+45] for i in range(0,len(lines),45)]
    data='\n\n'.join(f'function Review02_Data{i} takes nothing returns nothing\n'+'\n'.join(g)+'\nendfunction' for i,g in enumerate(groups))
    loader='function Review02_Load takes nothing returns nothing\n'+'\n'.join(f'    call ExecuteFunc("Review02_Data{i}")' for i in range(len(groups)))+'\nendfunction'
    enemy=fs['InitUpgrades_Player11'].replace('InitUpgrades_Player11','Review02_EnemyTech').replace('Player(11)','Player(0)')
    extra_tech='\n'.join(l.replace('Player($B)','Player(0)').replace('Player(11)','Player(0)') for l in fs['Trig_Init_EnemyUpgrades_Actions'].splitlines() if ('Player($B)' in l or 'Player(11)' in l) and 'TechResearched' in l)
    enemy=enemy.replace('endfunction',extra_tech+'\nendfunction')
    setup='''function Review02_Setup takes unit u returns nothing
    local integer raw=GetUnitTypeId(u)
    local integer i=0
    local integer a
    local item gear
    if u==null or GetUnitTypeId(u)==0 then
        return
    endif
    call BlzSetUnitName(u,LoadStr(Review02Data,raw,-2))
    loop
        exitwhen i>=LoadInteger(Review02Data,raw,3000)
        set gear=UnitAddItemById(u,LoadInteger(Review02Data,raw,3001+i))
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=LoadInteger(Review02Data,raw,3500)
        set a=LoadInteger(Review02Data,raw,3501+i*2)
        if GetUnitAbilityLevel(u,a)==0 then
            call UnitAddAbility(u,a)
        endif
        call SetUnitAbilityLevel(u,a,LoadInteger(Review02Data,raw,3502+i*2))
        set i=i+1
    endloop
    call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_MAX_LIFE))
    call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MAX_MANA))
    set gear=null
endfunction
'''
    resist='''function Review02_Resist takes integer tier returns string
    if tier==7 then
        return "Absorb (heals instead of damage)"
    elseif tier==6 then
        return "Immune"
    elseif tier==5 then
        return "Resistant (50% damage)"
    elseif tier==1 then
        return "Weak (200% damage)"
    elseif tier==2 then
        return "Weakened (160% damage)"
    elseif tier==4 then
        return "Protected (80% damage)"
    endif
    return "Normal (100% damage)"
endfunction
'''
    script=script.replace('endglobals','    hashtable Review02Data=null\nendglobals',1)
    # Functions are inserted before review helpers, after their RPG dependencies.
    script=script.replace('function Review_Label takes',enemy+'\n'+resist+'\n'+EXTRA+'\n'+setup+'\n'+data+'\n'+loader+'\nfunction Review_Label takes',1)
    fs=functions(script)
    for n in ['Review_Add','Review_Chat']:
        b=fs[n].replace('call SetUnitInvulnerable(u,true)','call SetUnitInvulnerable(u,false)\n        call UnitRemoveAbility(u,\'Avul\')').replace('call SetUnitInvulnerable(ReviewFighter,true)','call SetUnitInvulnerable(ReviewFighter,false)\n        call UnitRemoveAbility(ReviewFighter,\'Avul\')')
        b=b.replace('SetHeroLevel(u,10,false)',"SetHeroLevel(u,IMaxBJ(1,LoadInteger(Review02Data,GetUnitTypeId(u),-1)),false)")
        b=b.replace('SetHeroLevel(ReviewFighter,10,false)',"SetHeroLevel(ReviewFighter,IMaxBJ(1,LoadInteger(Review02Data,GetUnitTypeId(ReviewFighter),-1)),false)")
        if n=='Review_Chat':
            b=b.replace('        call Review_Targets()','        call Review02_Setup(ReviewFighter)\n        call Review_Targets()',1)
            b=b.replace('area<=12','area<=13')
            b=b.replace('    elseif s=="-info" and u!=null then\n        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,GetUnitName(u)+"|n"+LoadStr(ReviewHash,GetHandleId(u),0))','''    elseif s=="-info" and u!=null then
        call Review02_Stats(u)
    elseif SubString(s,0,7)=="-spells" and u!=null then
        call Review02_Pages(u,IMaxBJ(1,S2I(SubString(s,8,StringLength(s)))),1000)
    elseif SubString(s,0,10)=="-abilities" and u!=null then
        call Review02_Pages(u,IMaxBJ(1,S2I(SubString(s,11,StringLength(s)))),2000)''')
        else:b=b.replace('    set u=null','    call Review02_Setup(u)\n    set u=null',1)
        script=put(script,n,b)
    script=put(script,'Review_Select','''function Review_Select takes nothing returns nothing
    set ReviewSelected=GetTriggerUnit()
endfunction''')
    b=functions(script)['Review_Start'].replace('    set ReviewHash=InitHashtable()','    set ReviewHash=InitHashtable()\n    call ExecuteFunc("Review02_Load")',1)
    b=b.replace('Creature Review 01 ready.','Creature Review 02 ready.').replace('Select one to see its original abilities.','Selection is silent. -info shows live stats; -abilities shows spell calculations; -spells shows scripted mechanics.').replace('-area 1 through -area 12','-area 1 through -area 13')
    return put(script,'Review_Start',b).replace('Catalogues are safe, player-controlled copies.','Exhibits are damageable, player-controlled copies.')

def files_hook(files,base):
    # Add formula sections in the review's ability tooltips, leaving gameplay
    # data unchanged. Original maps receive only the separate house aura patch.
    strings=build.wts_read(base.read('war3map.wts'))
    for filename in ['war3map.w3a','war3mapSkin.w3a']:
        try:table=read_objects(base.read(filename),'w3a')
        except (KeyError,FileNotFoundError):continue
        if filename=='war3map.w3a':
            present={o['id'] or o['base'] for o in table['original']+table['custom']}
            for raw in sorted(set(SPELLS)-present):
                if raw in STOCK:table['original'].append(dict(base=raw,id=None,sets=[dict(flag=0,mods=[])]))
        for o in table['original']+table['custom']:
            raw=o['id'] or o['base']
            if raw not in SPELLS:continue
            f=fields(o)
            for rank,detail in enumerate(SPELLS[raw],1):
                authored=str(at(f,'aub1',rank,''))
                if authored.startswith('TRIGSTR_'):authored=strings.get(int(authored[8:]),authored)
                if not authored:
                    value=STOCK_TEXT.get(raw,STOCK_TEXT.get(o['base'],{})).get('Ubertip','')
                    choices=next(csv.reader([value])) if value else []
                    authored=choices[min(rank-1,len(choices)-1)] if choices else ''
                button_detail=detail
                if len(button_detail.encode())>1600:button_detail=detail.split('\nScript calculation',1)[0]+'\nFull conditional damage/healing calculation: type -abilities while selecting this creature.'
                text=authored+'|n|n|cffffcc00Calculation / effect values|r|n'+button_detail.replace('\n','|n')
                setf(o,'aub1',text,rank)
        files[filename]=write_objects(table,table['version'],'w3a')
    dest=build.OUT.parent
    (dest/'Spell-Calculations.json').write_text(json.dumps(dict(spells=SPELLS,scripted=MECHANICS,hero_levels=LEVELS,starting_items=GEAR,ability_ranks=RANKS),indent=2),encoding='utf-8')
    docs=['# Creature Review 02 spell calculations','', 'Native fields retain their editor labels. Scripted calculations retain conditions and intermediate assignments; they are not unconditional totals. All displayed formulas precede target defenses and damage modifiers.','']
    for r in {r['raw']:r for r in ROWS}.values():
        docs+=['## '+r['name']+' ('+r['raw']+')',r['area_name'],MECHANICS[r['raw']],'']
        for a in r['abilities']:docs+=['### '+a['name']+' ('+a['raw']+')','\n\n'.join('Rank '+str(i)+': '+s for i,s in enumerate(SPELLS.get(a['raw'],[]),1)),'']
    (dest/'Spell-Calculations.md').write_text('\n'.join(docs),encoding='utf-8')
    index=['# Creature Review 02','',build.DIRECTORY,'','Units are damageable. Hero levels, starting equipment and ability ranks come from authored spawn setups where identified. Native Normal enemy research and 100% one-player handicap are used. The full RPG damage pipeline and automatic encounter AI do not run in this isolated review.','', 'Calculation details: [Spell-Calculations.md](Spell-Calculations.md). Conditional assignments/per-hit effects remain separate; direct life setters are state changes, not mitigated attack damage.','']
    for area,name in build.AREAS.items():
        if area==13:continue
        index+=['## '+name,'']+[f"- {r['name']} ({r['raw']}) — {r['section']}" for r in ROWS if r['area']==area]+['']
    (dest/'Creature-Catalogue.md').write_text('\n'.join(index),encoding='utf-8')
    return files

def main():
    build.OUT=ROOT/'release/development/CreatureReview02/FFERPG-Creature-Review-02.w3x'
    build.NAME='FFERPG - Creature Review 02'
    build.DISPLAY_AREAS=12;build.PRACTICE_AREA=13
    build.AREAS.update({10:'Arena of Darkness',11:'Story / world encounters',12:'Battle Arena',13:'Practice arena'})
    build.center=lambda i: (17800.,-21100.) if i==13 else (-2800.+((i-1)%3)*10300.,2900.-((i-1)//3)*6000.)
    build.catalogue=catalogue;build.SCRIPT_HOOK=script_hook;build.FILES_HOOK=files_hook;build.CHANGED_OBJECTS={'war3map.w3a'}
    build.DIRECTORY='Select a unit silently. -info: origin and live stats. -abilities [page]: native/button calculations. -spells [page]: scripted attacks/heals. -test: practice clone. -refresh: restore HP/MP/cooldowns. -mana: test mana. -reset: practice targets. -hurt: wound friendly target. -safe / -vulnerable: optional selected-unit protection.\n\n'+ '\n'.join(f'-area {i}: {name}' for i,name in build.AREAS.items())+'\n\nNormal one-player baseline. Units are damageable. Boss encounter AI is described, not automatically started. No save/load.'
    build.build()
    p=build.OUT.parent/'README.md';p.write_text(build.DIRECTORY+'\n\nFull rank calculations: Spell-Calculations.md. Native spell values and script expressions are exported separately; conditional/per-hit formulas are not final damage totals. This isolated review does not start the complete RPG damage pipeline or boss encounters. No balance changes are made to reviewed spells.\n',encoding='utf-8')

if __name__=='__main__':main()

"""Build an isolated creature catalogue; never starts the RPG world or UI."""
from pathlib import Path
import sys,re,json,struct,hashlib,copy
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ,write_files,compact
from objdata import read_objects
from priest_master import fields
from jtok import functions
from expand_map import read_w3e
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from wtg import write_wtg,ITEM_TYPES
from wct import write_wct,raw_of

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f.w3x'
OUT=ROOT/'release/development/CreatureReview01/FFERPG-Creature-Review-01.w3x'
NAME='FFERPG - Creature Review 01'
DISPLAY_AREAS=11
PRACTICE_AREA=12
SCRIPT_HOOK=None
FILES_HOOK=None
CHANGED_OBJECTS=set()
DIRECTORY=None
LAYOUT_GROUPS=None
SOURCE_TEXTS=None
EXTRA_UNITS=set()
AREAS={1:'Guardia Forest',2:'Barrens',3:'Central Islands',4:'Northern Mountain',5:'Western spawn area (Zone 5)',6:'Naga Islands',7:'Lothlorien',8:'Icy Realm',9:'Dark Dragon Marsh',10:'Story, arena and other encounters',11:'Additional encounter forms and summons',12:'Practice arena'}

def q(s):return '"'+s.replace('\\','\\\\').replace('"','\\"').replace('\n','|n')+'"'
def num(s):return float(s) if '$' not in s else (-1 if s.startswith('-') else 1)*int(s.lstrip('-$'),16)
def center(i):return (-2800.+((i-1)%3)*10300.,2900.-((i-1)//3)*7800.)

def catalogue(base,script):
    fs=functions(script);strings=wts_read(base.read('war3map.wts'))
    objs={};ability_objs={}
    for ext,dest in [('w3u',objs),('w3a',ability_objs)]:
        for filename in ['war3map.'+ext,'war3mapSkin.'+ext]:
            try:table=read_objects(base.read(filename),ext)
            except (KeyError,FileNotFoundError):continue
            for o in table['original']+table['custom']:
                raw=o['id'] or o['base'];dest.setdefault(raw,{}).update({k[0]:v for k,v in fields(o).items()});dest[raw]['base']=o['base']
    comment_names={m[1]:m[2] for m in re.finditer(r"//\s*'(.{4})':\s*(?:unit|editor label)\s+\"([^\"]+)\"",script)}
    def name(raw,table=objs):
        v=table.get(raw,{}).get('unam' if table is objs else 'anam',raw)
        if v==raw and table is objs:v=comment_names.get(raw,raw)
        if v.startswith('TRIGSTR_'):v=strings.get(int(v[8:]),v)
        return re.sub(r'\|c[0-9A-Fa-f]{8}|\|r','',v)
    compact_script=re.sub(r'[ \t]','',script)
    pools={i:set() for i in range(1,11)};daynight={};current=[]
    for line in re.sub(r'[ \t]','',fs['Trig_Spawn_Pools_Init_Actions']).splitlines():
        if 'setl_pool=CreateUnitPool()' in line:current=[]
        m=re.search(r"UnitPoolAddUnitType\(l_pool,'(.{4})'",line)
        if m:current.append(m[1])
        m=re.search(r'SaveUnitPoolHandle\(udg_SpawnDataHash,([34]),(\d+|\$[A-F0-9]+),l_pool\)',line)
        if m:
            area=int(num(m[2]));pools[area].update(current)
            for raw in current:daynight.setdefault((area,raw),set()).add('day' if m[1]=='3' else 'night')
    late={i:set() for i in range(1,10)};area=0
    for line in re.sub(r'[ \t]','',fs['Trig_Zeromus_Death_UpgradeSpawnPools']).splitlines():
        m=re.search(r'LoadUnitPoolHandle\(udg_SpawnDataHash,[34],(\d+)\)',line)
        if m:area=int(m[1])
        m=re.search(r"UnitPoolAddUnitType\(l_pool,'(.{4})'",line)
        if m:late[area].add(m[1])
    monster=set(re.findall(r"set udg_MonsterTypeID\s*=\s*'(.{4})'",script))
    # Include every hostile preplacement in addition to the loot taxonomy.
    placed=[]
    for n,b in fs.items():
        if n=='CreateUnitsForPlayer11':
            placed+=re.findall(r"(?:BlzCreateUnitWithSkin|CreateUnit)\(\s*p,\s*'(.{4})',\s*(-?(?:\$[0-9A-Fa-f]+|[\d.]+)),\s*(-?(?:\$[0-9A-Fa-f]+|[\d.]+)),",re.sub(r'[ \t]','',b))
    monster.update(r[0] for r in placed)
    monster.update(EXTRA_UNITS)
    # Explicit hostile dynamic creations, including forms absent from loot tables.
    dynamic=set(re.findall(r"(?:BlzCreateUnitWithSkin|CreateUnit)\(\s*Player\((?:11|\$B)\),\s*'(.{4})'",compact_script))
    dynamic.update(re.findall(r"CreateNUnitsAtLoc(?:FacingLocBJ)?\([^,]+,'(.{4})',Player\((?:11|\$B)\)",compact_script))
    dynamic.update(re.findall(r"setudg_ArenaMonsterType\[[^\]]+\]='(.{4})'",compact_script))
    excluded={r for r in dynamic if any(x in name(r).lower() for x in ['dummy','missile','projectile','effect caster']) or 'Aloc' in objs.get(r,{}).get('uabi','')}
    dynamic-=excluded;monster.update(dynamic)
    rects={m[1]:tuple(map(float,m.groups()[1:])) for m in re.finditer(r'set(gg_rct_\w+)=Rect\(([-\d.]+),([-\d.]+),([-\d.]+),([-\d.]+)\)',re.sub(r'[ \t]','',fs['CreateRegions']))}
    area_rects={i:[] for i in range(1,10)}
    for m in re.finditer(r'SaveRectHandle\(udg_SpawnRectHash,\s*(\d+),[^,]+,\s*(gg_rct_\w+)\)',script):
        if int(m[1]) in area_rects and m[2] in rects:area_rects[int(m[1])].append(rects[m[2]])
    belongs={}
    for raw,x,y in placed:
        for i,rs in area_rects.items():
            if any(a<=num(x)<=c and b<=num(y)<=d for a,b,c,d in rs):belongs.setdefault(raw,set()).add(i)
    rows=[];covered=set()
    source_texts=SOURCE_TEXTS if SOURCE_TEXTS is not None else {p:p.read_text(encoding='utf-8-sig') for p in (ROOT/'src/triggers').rglob('*.j') if any(t in p.name for t in ['Boss','Enemy','Arena'])}
    def add(raw,area,section,origin):
        data=objs.get(raw,{})
        abilities=[r for r in (data.get('uabi','')+','+data.get('uhab','')).split(',') if r and r!='_']
        sources=[];mechanics=[]
        for path,text in source_texts.items():
            if not any(t in path.name for t in ['Boss','Enemy','Arena']):continue
            if "'"+raw+"'" in text:
                sources.append(str(path.relative_to(ROOT)).replace('\\','/'))
                mechanics.extend(re.findall(r'^function (\w+) takes',text,re.M))
        rows.append(dict(raw=raw,name=name(raw),area=area,area_name=AREAS[area],section=section,origin=origin,
            abilities=[dict(raw=a,name=name(a,ability_objs)) for a in abilities],script_sources=sources,
            script_functions=mechanics,valid_object=raw in objs))
        covered.add(raw)
    for i in range(1,10):
        for raw in sorted(pools[i],key=name):add(raw,i,'Regular spawns',' / '.join(sorted(daynight[(i,raw)])))
        for raw in sorted(late[i],key=name):add(raw,i,'After Dimensional Boundary','Zeromus / boundary spawn-pool additions')
        if i==8:
            for raw in sorted(pools[10],key=name):add(raw,i,'Later Hell invasion','Scorching Travel event (not Dimensional Boundary)')
        for raw in sorted(set(belongs)-covered,key=name):
            if i in belongs[raw]:add(raw,i,'Local encounters','Hostile placement inside this area spawn rectangle')
    for raw in sorted(monster-covered,key=name):add(raw,10,'Other encounters','Monster taxonomy / hostile placed or scripted unit')
    # Boss scripts can refer to non-hostile-created forms via variables; add named unit literals.
    extras=set()
    for path,text in source_texts.items():
        if path.name.startswith('Boss'):extras.update(r for r in re.findall(r"'(.{4})'",text) if r in objs)
    extras-=covered
    extras={r for r in extras if not any(x in name(r).lower() for x in ['dummy','missile','projectile']) and 'Aloc' not in objs.get(r,{}).get('uabi','')}
    for raw in sorted(extras,key=name):add(raw,11,'Additional forms / summons','Unit references in boss scripts; may include encounter helpers')
    return rows,dict(monster_taxonomy_count=len(set(re.findall(r"set udg_MonsterTypeID\s*=\s*'(.{4})'",script))),excluded_dynamic_helpers=sorted(excluded),unresolved=sorted({r['raw'] for r in rows if not r['valid_object']}),covered_unique=len(covered)),fs

RUNTIME=r'''
function Review_Label takes string text, real x, real y returns nothing
    local texttag t=CreateTextTag()
    call SetTextTagText(t,text,.028)
    call SetTextTagPos(t,x,y,70.)
    call SetTextTagColor(t,255,215,80,255)
    set t=null
endfunction

function Review_Add takes integer raw, real x, real y, string info returns nothing
    local unit u=CreateUnit(Player(0),raw,x,y,270.)
    local integer h=GetHandleId(u)
    if u!=null then
        call SaveStr(ReviewHash,h,0,info)
        call SaveBoolean(ReviewHash,h,1,true)
        call SetUnitAcquireRange(u,0.)
        call SetUnitInvulnerable(u,true)
        call SetUnitPathing(u,false)
        if IsUnitType(u,UNIT_TYPE_HERO) then
            call SetHeroLevel(u,10,false)
            call SuspendHeroXP(u,true)
        endif
    endif
    set u=null
endfunction

function Review_Select takes nothing returns nothing
    local unit u=GetTriggerUnit()
    local string info=LoadStr(ReviewHash,GetHandleId(u),0)
    set ReviewSelected=u
    if info!=null and info!="" then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,GetUnitName(u)+"|n"+info)
    endif
    set u=null
endfunction

function Review_Targets takes nothing returns nothing
    local integer i=0
    local unit u
    loop
        exitwhen i>=8
        if ReviewTargets[i]!=null then
            call RemoveUnit(ReviewTargets[i])
        endif
        set u=CreateUnit(Player(11),'hfoo',19100.+I2R(ModuloInteger(i,4))*450.,-22000.-I2R(i/4)*550.,180.)
        call BlzSetUnitMaxHP(u,1000000)
        call SetUnitState(u,UNIT_STATE_LIFE,1000000.)
        call SetUnitAcquireRange(u,0.)
        call SetUnitMoveSpeed(u,0.)
        call BlzSetUnitName(u,"Enemy practice target")
        set ReviewTargets[i]=u
        set i=i+1
    endloop
    if ReviewFriend!=null then
        call RemoveUnit(ReviewFriend)
    endif
    set ReviewFriend=CreateUnit(Player(0),'hfoo',18400.,-22500.,0.)
    call BlzSetUnitMaxHP(ReviewFriend,100000)
    call SetUnitState(ReviewFriend,UNIT_STATE_LIFE,25000.)
    call SetUnitAcquireRange(ReviewFriend,0.)
    call BlzSetUnitName(ReviewFriend,"Wounded friendly practice target")
    set u=null
endfunction

function Review_Chat takes nothing returns nothing
    local string s=GetEventPlayerChatString()
    local integer area
    local unit u=ReviewSelected
    if SubString(s,0,6)=="-area " then
        set area=S2I(SubString(s,6,StringLength(s)))
        if area>=1 and area<=12 then
            call PanCameraToTimedForPlayer(Player(0),ReviewX[area]+3500.,ReviewY[area]-1600.,.4)
        endif
    elseif s=="-test" and u!=null then
        if ReviewFighter!=null then
            call RemoveUnit(ReviewFighter)
        endif
        set ReviewFighter=CreateUnit(Player(0),GetUnitTypeId(u),17800.,-22000.,0.)
        call SetUnitAcquireRange(ReviewFighter,0.)
        call SetUnitInvulnerable(ReviewFighter,true)
        if IsUnitType(ReviewFighter,UNIT_TYPE_HERO) then
            call SetHeroLevel(ReviewFighter,10,false)
            call SuspendHeroXP(ReviewFighter,true)
        endif
        call SaveStr(ReviewHash,GetHandleId(ReviewFighter),0,LoadStr(ReviewHash,GetHandleId(u),0))
        call Review_Targets()
        call SelectUnitForPlayerSingle(ReviewFighter,Player(0))
        call PanCameraToTimedForPlayer(Player(0),18500.,-22000.,.4)
    elseif s=="-refresh" and u!=null then
        call UnitResetCooldown(u)
        call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_MAX_LIFE))
        call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MAX_MANA))
    elseif s=="-mana" and u!=null then
        call BlzSetUnitMaxMana(u,10000)
        call SetUnitState(u,UNIT_STATE_MANA,10000.)
    elseif s=="-vulnerable" and u!=null then
        call SetUnitInvulnerable(u,false)
    elseif s=="-safe" and u!=null then
        call SetUnitInvulnerable(u,true)
    elseif s=="-reset" then
        call Review_Targets()
    elseif s=="-hurt" then
        call SetUnitState(ReviewFriend,UNIT_STATE_LIFE,25000.)
    elseif s=="-info" and u!=null then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,30.,GetUnitName(u)+"|n"+LoadStr(ReviewHash,GetHandleId(u),0))
    else
        call DisplayTimedTextToPlayer(Player(0),0.,0.,45.,"Creature Review: select a creature, then -test to copy it into practice. -refresh restores HP/mana/cooldowns; -mana grants test mana; -reset restores targets; -hurt wounds ally; -vulnerable / -safe toggles selected invulnerability; -info repeats details. -area 1..12 travels between sections. F9 lists areas. Catalogues are safe, player-controlled copies. Boss encounter scripts are documented separately; automatic encounter phases are disabled.")
    endif
    set u=null
endfunction

function Review_Start takes nothing returns nothing
    local trigger t=CreateTrigger()
    local quest questInfo=CreateQuest()
    call QuestSetTitle(questInfo,"Creature Review controls and area directory")
    call QuestSetDescription(questInfo,REVIEW_DIRECTORY)
    call QuestSetRequired(questInfo,false)
    call QuestSetDiscovered(questInfo,true)
    set ReviewHash=InitHashtable()
    call SetPlayerState(Player(0),PLAYER_STATE_RESOURCE_GOLD,1000000)
    call SetPlayerState(Player(0),PLAYER_STATE_RESOURCE_LUMBER,1000000)
    call SetPlayerAlliance(Player(0),Player(11),ALLIANCE_PASSIVE,false)
    call SetPlayerAlliance(Player(11),Player(0),ALLIANCE_PASSIVE,false)
    call FogEnable(false)
    call FogMaskEnable(false)
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY,12.)
    call SetTimeOfDayScale(0.)
    call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,2400.,0.)
    call TriggerRegisterPlayerSelectionEventBJ(t,Player(0),true)
    call TriggerAddAction(t,function Review_Select)
    set t=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(t,Player(0),"-",false)
    call TriggerAddAction(t,function Review_Chat)
    // GENERATED CALLS
    call Review_Targets()
    call PanCameraToTimedForPlayer(Player(0),700.,1300.,0.)
    call DisplayTimedTextToPlayer(Player(0),0.,0.,60.,"Creature Review 01 ready. All exhibits belong to Red. Select one to see its original abilities. Type -test to copy it into the practice arena, -help for controls, or -area 1 through -area 12 to browse. F9 contains the directory.")
    set t=null
    set questInfo=null
endfunction
'''

def build():
    assert not OUT.exists(),'Do not overwrite a reviewed map'
    base=MPQ(str(BASE));script=base.read('war3map.j').decode().replace('\r\n','\n')
    rows,audit,fs=catalogue(base,script)
    # A source typo references m02A, absent from both custom and stock unit data.
    # Keep it in the audit rather than creating an invalid native unit handle.
    valid=[r for r in rows if r['valid_object']]
    placements=[];counts={};labels=[]
    for i in range(1,DISPLAY_AREAS+1):
        x,y=center(i);labels.append(f'    set ReviewX[{i}]={x}');labels.append(f'    set ReviewY[{i}]={y}')
        labels.append(f'    call Review_Label({q(str(i)+". "+AREAS[i])},{x},{y})')
        regular=[r for r in valid if r['area']==i and r['section'] not in ['After Dimensional Boundary','Later Hell invasion']]
        later=[r for r in valid if r['area']==i and r not in regular]
        groups=LAYOUT_GROUPS(valid,i,x,y) if LAYOUT_GROUPS else [("Regular / encounters" if side==0 else "After Boundary / later event",group,x+side*5200.,y-500.,y-1100.,(24,350.,440.) if i>=10 else (10,470.,510.)) for side,group in enumerate([regular,later])]
        for side,(title,group,gx,label_y,start_y,grid) in enumerate(groups):
            if title and (LAYOUT_GROUPS or i<10 or side==0):labels.append(f'    call Review_Label({q(title)},{gx},{label_y})')
            for n,r in enumerate(group):
                cols,dx,dy=grid
                r['x']=gx+(n%cols)*dx;r['y']=start_y-(n//cols)*dy
                info=f"{r['area_name']} | {r['section']} | {r['raw']} | {r['origin']}\nAbilities: "+(', '.join(a['name']+' ['+a['raw']+']' for a in r['abilities']) or 'Stock inherited abilities; inspect command card.')
                if r['script_sources']:info+='\nEncounter-only mechanics: see Creature-Catalogue.md. Full encounter AI/phases are not running.'
                if len(info.encode())>950:info=info[:800]+' (see catalogue)'
                placements.append(f"    call Review_Add('{r['raw']}',{r['x']},{r['y']},{q(info)})")
        counts[i]=len(regular)+len(later)
        assert len(regular)<=(336 if i>=10 else 110),(i,len(regular))
    x,y=center(PRACTICE_AREA);labels.extend([f'    set ReviewX[{PRACTICE_AREA}]={x}',f'    set ReviewY[{PRACTICE_AREA}]={y}',f'    call Review_Label("{PRACTICE_AREA}. Practice arena - select an exhibit and type -test",{x},{y})'])
    all_lines=labels+placements
    chunks=[all_lines[i:i+30] for i in range(0,len(all_lines),30)]
    generated='\n\n'.join(f'function Review_Data{i} takes nothing returns nothing\n'+ '\n'.join(c)+'\nendfunction' for i,c in enumerate(chunks))
    directory='Select an exhibit, then -test. -refresh restores cooldowns/HP/mana. -mana grants test mana. -reset restores targets. -hurt wounds friendly target. -safe / -vulnerable toggles invulnerability. -info repeats details.\n\n'+'\n'.join(f'-area {i}: {n}' for i,n in AREAS.items())+'\n\nDay/night pools are combined. Boundary additions appear beside their original areas, including intentional duplicates. Icy Realm Hell invasion is a separate later event. Story/arena bosses without verified area rectangles are in section 10. Normal object abilities retain original data. Boss AI, quest phases, loot and automatic encounters are disabled; see the companion catalogue for scripted mechanics. Testing map only; no save/load.'
    directory=directory.replace('Story/arena bosses without verified area rectangles are in section 10.','Other encounters: section 10.')
    if DIRECTORY:directory=DIRECTORY
    assert len(q(directory).encode())<1000
    runtime=RUNTIME.replace('REVIEW_DIRECTORY',q(directory)).replace('    // GENERATED CALLS','\n'.join(f'    call ExecuteFunc("Review_Data{i}")' for i in range(len(chunks))))
    globals_='''
    hashtable ReviewHash=null
    unit ReviewSelected=null
    unit ReviewFighter=null
    unit ReviewFriend=null
    unit array ReviewTargets
    real array ReviewX
    real array ReviewY
'''
    script=script.replace('endglobals',globals_+'endglobals',1)
    # Retain definitions for spell dependencies, but do not register any RPG UI,
    # quests, deaths, damage loop, spawn loop, or encounter lifecycle.
    original_main=fs['main']
    combat_sources='\n'.join(p.read_text(encoding='utf-8-sig') for p in (ROOT/'src/triggers/04 Combat and abilities').glob('*.j'))
    registrations=[]
    for n,b in fs.items():
        if n.startswith(('Register_','RegisterLegacy_')) and re.search(r'function '+re.escape(n)+r'\b',combat_sources) and 'EVENT_PLAYER_UNIT_SPELL_' in b:
            # Register only pure spell events. Mixed encounter/death/init events stay dormant.
            events=re.findall(r'EVENT_[A-Z_]+',b)
            if events and all(e.startswith('EVENT_PLAYER_UNIT_SPELL_') for e in events):registrations.append(n)
    setup=['InitBlizzard','InitGlobals','Startup_InitGameplayState','Element_InitTables','Missile_Init','Register_Spell_Tables_Init','NativeCD_Init']
    # Remove the selected registrations from the unused RPG startup paths so
    # each retained spell hook has one authored call site in this test map.
    for n in registrations+['Register_Spell_Tables_Init']:
        script=re.sub(r'^[ \t]*call\s+(?:ExecuteFunc\(\s*"'+re.escape(n)+r'"\s*\)|'+re.escape(n)+r'\(\s*\))[^\n]*', '    // Registered by the isolated review entry point.',script,flags=re.M)
    init='function main takes nothing returns nothing\n    call Startup_MapEnvironment()\n    call CreateRegions()\n'+ '\n'.join(f'    call {n}()' for n in setup)+ '\n'+ '\n'.join(f'    call ExecuteFunc("{n}")' for n in registrations)+'\n    call Review_Start()\nendfunction'
    script=script.replace(original_main,runtime+'\n'+generated+'\n'+init)
    if SCRIPT_HOOK:script=SCRIPT_HOOK(script,rows)
    # World Editor regenerates these native map functions on save. Give the
    # retained dependency implementations private names to prevent collisions.
    native_names={'InitGlobals','InitCustomTriggers','CreateRegions','CreateCameras','CreateAllUnits','CreateAllDestructables','CreateAllItems','InitUpgrades','InitTechTree','Trig_MainDeprotected_Actions'}
    native_names.update(n for n in fs if n.startswith(('CreateUnitsFor','CreateBuildingsFor','CreateNeutral','InitUpgradesFor','InitTechTreeFor')))
    for n in sorted(native_names,key=len,reverse=True):script=re.sub(r'\b'+re.escape(n)+r'\b','ReviewOriginal_'+n,script)
    # Reuse the exact same review entry implementation in the editor source.
    init=functions(script)['main']
    # A self-contained editable trigger pairs with the native runtime.
    editor_body=script
    efs=functions(script)
    for n in ['main','config','InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities']:editor_body=editor_body.replace(efs[n],'')
    # Editor's generated main runs the custom initializer, which invokes the review main.
    editor_body+='\nfunction Review_EditorMain takes nothing returns nothing\n'+ '\n'.join(init.splitlines()[1:-1])+'\nendfunction\nfunction InitTrig_CreatureReview takes nothing returns nothing\n    call Review_EditorMain()\nendfunction\n'
    gm=re.search(r'^globals\n.*?^endglobals\n',editor_body,re.M|re.S);header=gm[0];editor_body=editor_body.replace(header,'',1)
    tree=dict(format='reforged',counts={k:0 for k in ITEM_TYPES},deleted={k:[] for k in ITEM_TYPES},game_version=2,variables=[],tail=b'',items=[dict(kind=1,id=0,name=NAME,is_comment=0,expanded=1,parent=-1),dict(kind=4,id=1,name='Creature Review',is_comment=0,expanded=1,parent=0),dict(kind=8,id=2,name='CreatureReview',desc='Isolated creature inspection and practice.',is_comment=0,enabled=1,custom=1,initially_off=0,run_on_init=1,parent=1,functions=[])])
    tree['counts'].update({1:1,4:1,8:1})
    terrain=bytearray(base.read('war3map.w3e'));head,w,h,ox,oy=read_w3e(terrain)
    for i in range(w*h):terrain[head+8*i:head+8*i+8]=struct.pack('<HHHBB',8192,8192,3,0,0xF2)
    strings=wts_read(base.read('war3map.wts'));strings[38788]=NAME;strings[38790]='Player-controlled creature and boss review. Play as Red. -help and F9 for controls. Separate test map; no save/load.'
    files={'war3map.j':script.replace('\n','\r\n').encode(),'war3map.wts':wts_write(strings),'war3map.w3e':bytes(terrain),'war3map.wpm':base.read('war3map.wpm')[:16]+bytes(len(base.read('war3map.wpm'))-16),'war3map.shd':bytes(len(base.read('war3map.shd'))),'war3map.doo':base.read('war3map.doo')[:12]+struct.pack('<iii',0,0,0),'war3mapUnits.doo':base.read('war3mapUnits.doo')[:12]+struct.pack('<i',0),'war3map.wtg':write_wtg(tree),'war3map.wct':write_wct(dict(format='reforged',comment=b'Creature Review',header=raw_of(header),entries=[raw_of(editor_body)]))}
    OUT.parent.mkdir(parents=True,exist_ok=True)
    (OUT.parent/'Creature-Catalogue.json').write_text(json.dumps(dict(areas=AREAS,coverage=audit,creatures=rows),indent=2))
    docs=['# FFERPG Creature Review 01','',directory.replace('|n','\n'),'','Every entry retains the original unit and ability object data. Safe exhibits cannot be harmed. The practice clone is also safe initially; use -vulnerable to test defense. Hero exhibits start at level 10, with original hero abilities available to learn. No new monster roles are implemented.','', '## Coverage',json.dumps(audit,indent=2),'']
    for i in range(1,DISPLAY_AREAS+1):
        docs+=['## '+str(i)+'. '+AREAS[i],'']
        for r in rows:
            if r['area']!=i:continue
            docs+=['### '+r['name']+' (`'+r['raw']+'`) — '+r['section'],r['origin'],'', 'Abilities: '+(', '.join(a['name']+' (`'+a['raw']+'`)' for a in r['abilities']) or 'Inherited stock command card; inspect in game.'),'']
            if r['script_sources']:docs+=['Scripted encounter references: '+', '.join(r['script_sources']),'Functions for review: '+', '.join(r['script_functions']),'']
    (OUT.parent/'Creature-Catalogue.md').write_text('\n'.join(docs),encoding='utf-8')
    OUT.with_suffix('.j').write_text(script)
    if FILES_HOOK:files=FILES_HOOK(files,base)
    tmp=OUT.parent/'unpacked.w3x';write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));tmp.unlink()
    _,flags,players=read_header(str(BASE));raw=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
    checked=MPQ(str(OUT))
    for n,v in files.items():assert checked.read(n)==v,n
    for n in ['war3map.w3i','war3map.w3u','war3map.w3a','war3map.imp']:
        if n not in CHANGED_OBJECTS:assert checked.read(n)==base.read(n),n
    report=dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),exhibits=len(valid),unique=len({r['raw'] for r in valid}),area_counts=counts,coverage=audit,spell_registrations=registrations,live_test='pending')
    (OUT.parent/'checks.json').write_text(json.dumps(report,indent=2));print(json.dumps({k:v for k,v in report.items() if k!='spell_registrations'},indent=2))

if __name__=='__main__':build()

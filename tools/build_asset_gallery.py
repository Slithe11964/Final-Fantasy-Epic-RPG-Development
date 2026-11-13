"""Standalone paged HD asset museum using a proven native Warcraft map container."""
from pathlib import Path
import copy,csv,hashlib,json,math,re,struct,sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ,write_files,compact
from objdata import read_objects,write_objects
from priest_master import setf,fields
from build_thief_daggers import ability
from expand_map import read_w3e
from jtok import functions,tokens
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from wtg import write_wtg,ITEM_TYPES
from wct import write_wct,raw_of

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'experiments/AssetGallery'
BASE=ROOT/'release/development/QuickUI11/FFERPG-QuickUI11-Forsaken.w3x'
OUT=ROOT/'release/development/AssetGallery01/FFERPG-Asset-Gallery-01.w3x'
NAME='FFERPG - Reforged Asset Gallery 01'

def quote(s):return '"'+s.replace('\\','\\\\').replace('"','\\"')+'"'
def code36(n):
    alphabet='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';result=''
    for _ in range(3):result=alphabet[n%36]+result;n//=36
    assert n==0
    return 'z'+result

def city_plans(available):
    cities=[]
    def exact(path):
        path=path.lower().replace('/','\\');assert path in available,path;return path
    def choose(part):
        hits=sorted(p for p in available if part in p and not any(t in p for t in ['portrait','birth','death','decay']))
        assert hits,part
        return hits[0]
    human_houses=[exact(f'doodads/cityscape/structures/citybuildingrow_{i}/citybuildingrow_{i}.mdx') for i in range(3)]
    fountain=exact('doodads/cityscape/props/city_fountain/city_fountain.mdx')
    lamp=exact('doodads/cityscape/props/lanternpost/lanternpost0.mdx')
    bench=exact('doodads/cityscape/props/citystonebench/citystonebench.mdx')
    wall=exact('doodads/cityscape/structures/city_lowwall/city_lowwall.mdx')
    bushes=choose('doodads\\cityscape\\plants\\citybush')
    def add(rows,path,x,y,scale=1.,angle=270.):rows.append(dict(path=path,x=x,y=y,scale=scale,angle=angle))
    def border(rows,path,scale=.8):
        for x in range(-2400,2401,600):
            add(rows,path,x,2600,scale,0.)
            if abs(x)>600:add(rows,path,x,-2500,scale,0.)
        for y in range(-1900,2401,600):
            add(rows,path,-2700,y,scale,90.);add(rows,path,2700,y,scale,90.)
    # Market town: main avenue, fountain plaza, residential rows and stalls.
    rows=[]
    add(rows,exact('buildings/human/townhall/townhall.mdx'),0,1900,.9)
    add(rows,exact('buildings/human/arcanesanctum/arcanesanctum.mdx'),1700,1900,.7)
    add(rows,exact('buildings/human/blacksmith/blacksmith.mdx'),-1700,1900,.7)
    add(rows,fountain,0,0,.9)
    for side in [-1,1]:
        for i,y in enumerate([1100,250,-650,-1550]):add(rows,human_houses[i%3],side*1750,y,.85,90. if side<0 else 270.)
        for y in [-1500,-700,700,1500]:add(rows,lamp,side*400,y,1.)
        for y in [-350,350]:add(rows,bench,side*680,y,.9,90. if side<0 else 270.)
        for i,y in enumerate([-1300,-650,650]):
            add(rows,choose('marketstalllarge'),side*950,y,.8,90. if side<0 else 270.)
            add(rows,choose(['marketitemproduce','marketitemtextiles','marketitembaubles'][i]),side*950,y-100,.8)
        for y in [-2100,2100]:add(rows,bushes,side*2200,y,1.3)
    add(rows,choose('citymaingate'),0,-2450,.85)
    border(rows,wall,.9)
    cities.append(('Human market town',rows))
    # Elven district: Silvermoon silhouette, radial homes, gardens and magical lamps.
    rows=[]
    add(rows,choose('largesilvermoontower'),0,1800,.75)
    add(rows,exact('buildings/human/arcanesanctum/arcanesanctum.mdx'),-1700,1450,.8)
    add(rows,exact('buildings/other/dalaranguardtower/dalaranguardtower.mdx'),1700,1450,1.)
    add(rows,fountain,0,0,.9)
    elfhouses=[exact(f'buildings/other/elvenfishvillagebuilding{i}/elvenfishvillagebuilding{i}.mdx') for i in range(4)]
    crystal=exact('doodads/cityscape/props/crystallamp/crystallamp.mdx')
    tulip=choose('silvermoon_tulips_00')
    banner=choose('highelfcreststandingbanners')
    for side in [-1,1]:
        for i,y in enumerate([600,-350,-1300]):add(rows,elfhouses[i],side*1750,y,.9,90. if side<0 else 270.)
        for y in [-1800,-900,900,1800]:add(rows,crystal,side*450,y,.9)
        for y in [-1500,-700,700,1500]:add(rows,tulip,side*1150,y,1.)
        add(rows,banner,side*350,-2300,1.)
        for y in [-400,400]:add(rows,bench,side*700,y,.8,90. if side<0 else 270.)
        for y in [-2100,-1000,1000,2100]:add(rows,bushes,side*2400,y,1.3)
    border(rows,wall,.9)
    cities.append(('Elven arcane district',rows))
    # Orc settlement: fortified gate, great hall and functional military quarters.
    rows=[]
    add(rows,exact('buildings/orc/greathall/greathall.mdx'),0,1800,.9)
    for path,x,y in [('orcbarracks',-1750,1400),('beastiary',1750,1400),('warmill',-1750,150),('spiritlodge',1750,150),('voodoolounge',-1750,-1300),('taurentotem',1750,-1300)]:
        add(rows,exact(f'buildings/orc/{path}/{path}.mdx'),x,y,.8)
    for side in [-1,1]:
        for y in [-1800,-800,800]:add(rows,exact('buildings/orc/trollburrow/trollburrow.mdx'),side*850,y,.75)
        for y in [-2100,-450,450,2100]:add(rows,choose('torchhuman0'),side*360,y,1.1)
        add(rows,exact('buildings/orc/watchtower/watchtower.mdx'),side*2100,-2100,.9)
    add(rows,choose('orgrimmargate_completed'),0,-2500,.7)
    border(rows,choose('orgrimmarwallsegment_completed'),.7)
    add(rows,choose('marketitemproduce'),550,-400,.8)
    cities.append(('Orc frontier settlement',rows))
    # Necropolis: processional avenue, crypts, graveyard, ruined walls and dead trees.
    rows=[]
    add(rows,exact('buildings/undead/necropolis/necropolis.mdx'),0,1900,.8)
    for path,x,y in [('templeofthedamned',-1750,1450),('boneyard',1750,1450),('crypt',-1750,100),('slaughterhouse',1750,100),('graveyard',-1700,-1300),('tombofrelics',1700,-1300)]:
        add(rows,exact(f'buildings/undead/{path}/{path}.mdx'),x,y,.8)
    add(rows,exact('buildings/undead/ziggurat/ziggurat.mdx'),-900,600,.8)
    add(rows,exact('buildings/undead/ziggurat/ziggurat.mdx'),900,600,.8)
    add(rows,choose('fountainruined'),0,-100,.9)
    for side in [-1,1]:
        for y in [-2000,-1000,900,2100]:add(rows,choose('icetorch'),side*400,y,.9)
        for y in [-2100,-900,200,1800]:add(rows,choose('citygrave0'),side*1100,y,.9)
        for y in [-2000,-700,700,2000]:add(rows,exact('doodads/ashenvale/plants/ashencanopytree/ruinscanopytree0.mdx'),side*2450,y,.8)
    border(rows,choose('ruinedwall'),.9)
    cities.append(('Undead fortress and graveyard',rows))
    return cities

def unit_obj(raw,model,name,base='hfoo',scale=1.):
    o=dict(base=base,id=raw,sets=[dict(flag=0,mods=[])])
    values={'unam':name,'utip':name,'utub':model,'umdl':model,'usca':scale,'ussc':1.25,'uabi':'Avul','uhab':'',
        'uver':0,'uvar':1,'uaen':0,'uacq':0.,'ucol':0.,'umvs':0,'umvt':'none','uhpm':1000,'uhpr':0.,'umpm':0,
        'usnd':'','upgr':'','uspa':'','ubui':'','usei':'','utra':'','ufma':0,'ufoo':0,'usid':0,'usin':0}
    for key,value in values.items():setf(o,key,value,rank=None)
    return o

def terrain(data):
    head,w,h,ox,oy=read_w3e(data);result=bytearray(data)
    palette=['Ldrt','Ldro','Lrok','Lgrs','Lgrd','Ygsb','Yhdg','Yrtl','Adrd','Cdrt']
    count=struct.unpack_from('<I',data,13)[0];assert count==len(palette)
    for i,value in enumerate(palette):result[17+4*i:21+4*i]=value.encode()
    for y in range(h):
        for x in range(w):
            if abs(ox+x*128)<=3584 and abs(oy+y*128)<=3584:
                offset=head+8*(y*w+x);result[offset:offset+8]=struct.pack('<HHHBB',8192,8192,3,0,0xF2)
    return bytes(result)

def editor_files(source):
    fs=functions(source);body=source.replace(fs['main'],'').replace(fs['config'],'')
    for name in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities']:body=body.replace(fs[name],'')
    gm=re.search(r'^globals\n.*?^endglobals\n',body,re.M|re.S);globals_=gm[0];body=body.replace(globals_,'',1)
    tree=dict(format='reforged',counts={k:0 for k in ITEM_TYPES},deleted={k:[] for k in ITEM_TYPES},game_version=2,variables=[],tail=b'',items=[
        dict(kind=1,id=0,name=NAME,is_comment=0,expanded=1,parent=-1),dict(kind=4,id=1,name='Asset Gallery',is_comment=0,expanded=1,parent=0),
        dict(kind=8,id=2,name='AssetShowcase',desc='Standalone HD catalogue and city examples.',is_comment=0,enabled=1,custom=1,initially_off=0,run_on_init=1,parent=1,functions=[])])
    tree['counts'].update({1:1,4:1,8:1})
    return {'war3map.wtg':write_wtg(tree),'war3map.wct':write_wct(dict(format='reforged',comment=b'Asset Gallery',header=raw_of(globals_),entries=[raw_of(body)]))}

def build():
    assert not OUT.exists(),'Never overwrite a reviewed showcase map.'
    catalogue=json.loads((SOURCE/'catalogue.json').read_text());models=catalogue['models'];icons=catalogue['icon_catalogue']
    base=MPQ(str(BASE));stock=read_objects(base.read('war3map.w3u'),'w3u');usedids={o['id'] or o['base'] for o in stock['custom']+stock['original']}
    available={m['path'] for m in catalogue['all_world_models']};cities=city_plans(available)
    bank=copy.deepcopy(models);by_path={m['path']:m['id'] for m in bank}
    for _,rows in cities:
        for row in rows:
            if row['path'] not in by_path:
                by_path[row['path']]=len(bank)+1;bank.append(dict(id=len(bank)+1,path=row['path'],name=row['path'].split('\\')[-1][:-4].replace('_',' ').title(),group=0,used=True))
    assert len(bank)<8191 and len(icons)<8191
    nextid=0;newunits=[];data=[]
    for m in bank:
        while code36(nextid) in usedids:nextid+=1
        m['raw']=code36(nextid);usedids.add(m['raw']);nextid+=1
        group=m['group'];m['scale']=.7 if group==2 else .65 if group in [3,5,6,7] else .9
        newunits.append(unit_obj(m['raw'],m['path'],'#'+str(m['id'])+' '+m['name'],scale=m['scale']))
        i=m['id'];data.extend([f"    set GalRaw[{i}]='{m['raw']}'",f'    set GalPath[{i}]={quote(m["path"])}',f'    set GalName[{i}]={quote(m["name"])}',f'    set GalScale[{i}]={m["scale"]}',f'    set GalGroup[{i}]={group}'])
    groups=catalogue['groups'];data.extend([f'    set GalModelCount={len(models)}',f'    set GalBankCount={len(bank)}',f'    set GalIconCount={len(icons)}',f'    set GalFirst[0]=1',f'    set GalLast[0]={len(models)}','    set GalGroupName[0]="All unused world models"'])
    for group,info in groups.items():
        ids=[m['id'] for m in models if m['group']==int(group)];assert ids
        data.extend([f'    set GalFirst[{group}]={min(ids)}',f'    set GalLast[{group}]={max(ids)}',f'    set GalGroupName[{group}]={quote(info["name"])}'])
    for icon in icons:
        i=icon['id'];data.extend([f'    set GalIconPath[{i}]={quote(icon["path"])}',f'    set GalIconName[{i}]={quote(icon["name"])}'])
    nav=[];nav_names=['Previous page','Next page','Next category / Return','Icon library','City examples','Gallery help'];keys=['Q','W','E','R','T','Y']
    orders=['roar','howlofterror','frenzy','windwalk','stomp','thunderclap','fanofknives','berserk','immolation','channel','soulburn','acidbomb','volcano','blizzard','tranquility']
    nav_slots=[(0,2),(1,2),(2,2),(3,2),(1,1),(2,1)]
    for i,name in enumerate(nav_names):
        icon='ReplaceableTextures\\CommandButtons\\'+['BTNCancel.blp','BTNSelectHeroOn.blp','BTNChestOfGold.blp','BTNHumanArmorUpOne.blp','BTNTownHall.blp','BTNSelectHeroOn.blp'][i]
        x,y=nav_slots[i]
        nav.append(ability('vN0'+str(i),name,keys[i],x,y,orders[i],0,icon,'Asset showcase control: '+name+'. F1 returns to the Curator. -help lists chat controls.'))
    browser_nav=[ability('vB0'+str(i),nav_names[i],keys[i],i,0,orders[i],0,'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp','Icon library: '+nav_names[i]) for i in range(3)]
    iconabilities=[]
    slots=[(3,0)]+[(x,y) for y in [1,2] for x in range(4)]
    for i,(x,y) in enumerate(slots):
        raw='vI0'+str(i);data.append(f"    set GalIconRaw[{i}]='{raw}'")
        iconabilities.append(ability(raw,'Icon sample '+str(i+1),'',x,y,orders[6+i],0,icons[i]['path'],'Click to print the icon asset path.'))
    assert not ({o['id'] for o in nav+browser_nav+iconabilities}&{o['id'] or o['base'] for o in read_objects(base.read('war3map.w3a'),'w3a')['custom']})
    explorer=unit_obj('YEXP','units\\human\\HeroPaladin\\HeroPaladin.mdl','Asset Curator','Hpal',.85)
    for k,v in {'uabi':'Avul,'+','.join(o['id'] for o in nav),'umvs':500,'umvt':'fly','umvh':30.,'upro':'Curator','upco':1,'uhpm':100000,'usid':1800,'usin':1800}.items():setf(explorer,k,v,rank=None)
    terminal=unit_obj('yICO','buildings\\human\\ArcaneVault\\ArcaneVault.mdl','Icon Library','hhou',.65)
    setf(terminal,'uabi','Avul,vB00,vB01,vB02,'+','.join(o['id'] for o in iconabilities),rank=None)
    newunits.extend([explorer,terminal]);assert not {'YEXP','yICO'}&usedids
    stock['custom'].extend(newunits);abilities=read_objects(base.read('war3map.w3a'),'w3a');abilities['custom'].extend(nav+browser_nav+iconabilities)
    row_id=0;placements=[]
    for city,(name,rows) in enumerate(cities,1):
        data.extend([f'    set GalCityName[{city}]={quote(name)}',f'    set GalCityFirst[{city}]={row_id+1}'])
        for row in rows:
            row_id+=1;mid=by_path[row['path']]
            data.extend([f'    set GalCityRaw[{row_id}]={mid}']+[f'    set GalCity{key}[{row_id}]={float(row[col])}' for key,col in [('X','x'),('Y','y'),('Angle','angle'),('Scale','scale')]])
            placements.append(dict(city=city,city_name=name,model_id=mid,**row))
        data.append(f'    set GalCityLast[{city}]={row_id}')
        assert len(rows)<200
    chunks=[data[i:i+100] for i in range(0,len(data),100)]
    generated='\n\n'.join('function Gal_Data'+str(i)+' takes nothing returns nothing\n'+'\n'.join(lines)+'\nendfunction' for i,lines in enumerate(chunks))
    generated+='\n\nfunction Gal_LoadData takes nothing returns nothing\n'+'\n'.join(f'    call ExecuteFunc("Gal_Data{i}")' for i in range(len(chunks)))+'\nendfunction\n'
    source=(SOURCE/'AssetGallery.j').read_text().replace('// Generated catalogue data functions are inserted here by the builder.',generated)
    fs=functions(base.read('war3map.j').decode())
    source+='\n\n'+'\n\n'.join(fs[n] for n in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities','config'])
    strings=wts_read(base.read('war3map.wts'));strings[38788]=NAME;strings[38790]='A standalone Reforged asset museum: unused models, icon library, and four city examples. Use HD graphics. F1 / Q W E R T / -help.';strings[38789]='1 designer'
    files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.wts':wts_write(strings),'war3map.w3u':write_objects(stock,stock['version'],'w3u'),'war3map.w3a':write_objects(abilities,abilities['version'],'w3a'),
        'war3map.w3e':terrain(base.read('war3map.w3e')),'war3map.wpm':base.read('war3map.wpm')[:16]+bytes(len(base.read('war3map.wpm'))-16),
        'war3map.shd':bytes(len(base.read('war3map.shd'))),'war3map.doo':base.read('war3map.doo')[:12]+struct.pack('<iii',0,0,0),'war3mapUnits.doo':base.read('war3mapUnits.doo')[:12]+struct.pack('<i',0)}
    files.update(editor_files(source))
    OUT.parent.mkdir(parents=True,exist_ok=True);tmp=OUT.parent/'unpacked.w3x'
    write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));tmp.unlink()
    _,flags,players=read_header(str(BASE));raw=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
    checked=MPQ(str(OUT))
    for name,value in files.items():assert checked.read(name)==value,name
    for name in ['war3map.w3i','war3mapMap.blp','war3mapPreview.tga','war3map.imp']:assert checked.read(name)==base.read(name),name
    for name in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities','config']:assert tokens(functions(source)[name])==tokens(fs[name]),name
    assert 'Forsaken_PollPanels' not in source and 'NativeCD_' not in source
    with (SOURCE/'city-placements.csv').open('w',newline='',encoding='utf-8-sig') as f:
        w=csv.DictWriter(f,fieldnames=list(placements[0]));w.writeheader();w.writerows(placements)
    (SOURCE/'generated-runtime.j').write_text(source)
    report={'output':str(OUT),'sha256':hashlib.sha256(OUT.read_bytes()).hexdigest(),'bytes':OUT.stat().st_size,
        'unused_models':len(models),'icons':len(icons),'groups':groups,'model_page_size':24,'icon_page_size':9,
        'cities':{name:len(rows) for name,rows in cities},'max_live_displays':max(24,max(len(rows) for _,rows in cities)),
        'browser_metadata':'W3I, native player config, preview, minimap and import table byte/token-identical to known-working QuickUI11. No handcrafted map info.',
        'runtime':'Standalone; no RPG gameplay/UI code. Native command-card icon browser, paged model displays, bounded asynchronous search. Model/unit/effect handles are created synchronously; only selection/camera are local.',
        'asset_coverage':catalogue['method'],'live_test':'pending','installed':False}
    (OUT.parent/'checks.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

if __name__=='__main__':build()

"""Build a separate, minimal Thief/scarecrow arena; never modify RPG releases."""
from pathlib import Path
import copy,hashlib,json,math,re,struct,sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ,write_files,compact
from objdata import write_objects,read_objects,R
from damage_tooltips import merged
from priest_master import fields,setf
from wtg import write_wtg,ITEM_TYPES
from wct import write_wct,raw_of
from add_header import build_header
from jtok import functions

ROOT=Path(__file__).resolve().parents[1]
HERE=ROOT/'experiments/ThiefDaggers'
BASE=ROOT/'release/development/QuickUI11/FFERPG-QuickUI11-Forsaken.w3x'
OUT=ROOT/'release/development/ThiefDaggers01/FFERPG-Thief-Daggers-01.w3x'
NAME='Thief - Dagger Rip Prototype 01'

def z(s):return s.encode('utf-8')+b'\0'
def ints(*v):return struct.pack('<'+'i'*len(v),*v)
def floats(*v):return struct.pack('<'+'f'*len(v),*v)

def map_info():
    # Classic v25 map info is accepted by current Warcraft; one fixed human slot.
    b=ints(25,1,6061)+z(NAME)+z('Slithe')+z('Thief and scarecrow only. R plants/rips daggers. Q/W/E compare visuals. T resets.')+z('1 tester')
    b+=floats(-3584.,-3584.,3584.,3584.,-3584.,3584.,3584.,-3584.)
    b+=ints(4,4,4,4,56,56,32)+b'L'+ints(-1)
    b+=z('')+z('R: plant daggers, R again: rip them out. Q/W/E: visual styles. T: reset.')+z(NAME)+z('Standalone ability test')
    b+=ints(0)+z('')+z('')+z('')+z('')
    b+=ints(0)+floats(3000.,5000.,0.)+bytes([0,0,0,255])+ints(0)+z('Default')+b'L'+bytes([255,255,255,255])
    b+=ints(1) # player count
    b+=ints(0,1,1,1)+z('Tester')+floats(-96.,0.)+ints(0,0)
    b+=ints(1,0,1)+z('Tester') # force count, flags, player mask, name
    b+=ints(0,0,0,0) # upgrades, tech, random units, random items
    return b

def terrain():
    n=65
    b=b'W3E!'+ints(11)+b'L'+ints(1,3)+b'LdrtLgrsLrok'+ints(2)+b'CLdiCLgr'+ints(n,n)+floats(-4096.,-4096.)
    for row in range(n):
        for col in range(n):
            radius=math.hypot(col-32,row-32)
            texture=0 if radius<6 else 2 if 6<=radius<7 else 1
            b+=struct.pack('<HHBBB',8192,8192,texture,0,0xF2)
    return b

def unit_field(o,key,value):setf(o,key,value,rank=None)

def ability(raw,name,key,x,y,order,target,icon,tooltip):
    o=dict(base='ANcl',id=raw,sets=[dict(flag=0,mods=[])])
    for field,value in {'alev':1,'aher':0,'arlv':1,'alsk':0,'anam':name,'ansf':'[Dagger prototype]',
                        'ahky':key,'abpx':x,'abpy':y,'aart':icon,'arac':'human','atat':'','acat':'','aeat':'',
                        'aani':'attack' if raw=='pDgA' else 'spell'}.items():setf(o,field,value)
    for field,value,data in [('Ncl1',0.,1),('Ncl2',target,2),('Ncl3',1,3),('Ncl4',0.,4),('Ncl5',0,5),('Ncl6',order,6)]:
        setf(o,field,value,rank=1,data=data)
    for field,value in {'acdn':0.,'amcs':0,'acas':0.,'adur':0.,'ahdu':0.,'aran':600.,'aare':0.,
                        'atar':'air,ground,enemy','atp1':name+' (|cffffcc00'+key+'|r)','aub1':tooltip}.items():
        setf(o,field,value,rank=1)
    return o

def object_data(base):
    units=merged(base.read('war3map.w3u'),base.read('war3mapSkin.w3u'),'w3u')
    thief=copy.deepcopy(units['H00B']);dummy=copy.deepcopy(units['u01M'])
    for field,value in {'uabi':'pDgA,pDgR,pDs1,pDs2,pDs3,pDRs','uhab':'','upgr':'','uhpm':2000,'umpm':1000,
                        'uacq':0.,'ustr':100,'uagi':100,'uint':100,'ua1b':1,'ua1d':1,'ua1s':1,'umvs':350,
                        'unam':'Thief - Dagger Prototype','upro':'Thief','utip':'Thief - Dagger Prototype'}.items():unit_field(thief,field,value)
    for field,value in {'uabi':'','upgr':'','uhpm':100000,'uhpr':0.,'udef':0.,'udty':'normal','uaen':0,'uacq':0.,
                        'umvt':'foot','umvh':0.,'umvs':0,'utar':'ground','unam':'Scarecrow','utip':'Scarecrow'}.items():unit_field(dummy,field,value)
    imported='ReplaceableTextures\\CommandButtons\\'
    abilities=[
        ability('pDgA','Arm / Rip Daggers','R',3,2,'channel',0,imported+'BTNSpecialDagger1.blp',
                'Activate to arm daggers. Each landed basic attack adds a dagger to the scarecrow. Stacks have no cap; each dagger expires separately after 30 seconds.|nPress R again to rip them out and deal damage.|nRip damage: dagger count x (50 + 2 x AGI).'),
        ability('pDgR','Rip Daggers','R',3,2,'berserk',0,imported+'BTNINV_ThrowingKnife_04.blp',
                'Rip every planted dagger out, clearing the blades and dealing dagger count x (50 + 2 x AGI) damage.|nThis prototype has a 2-second cooldown after ripping.'),
        ability('pDs1','Visual 1: Embedded Blades','Q',0,2,'roar',0,imported+'BTNSpecialDagger5.blp',
                'Compare steel blades embedded around the scarecrow. Works while daggers are planted.'),
        ability('pDs2','Visual 2: Spectral Orbit','W',1,2,'howlofterror',0,imported+'BTNShadowStrike.blp',
                'Compare blue spectral blades orbiting the scarecrow. Works while daggers are planted.'),
        ability('pDs3','Visual 3: Bloodied Blade Fan','E',2,2,'frenzy',0,imported+'BTNFanOfKnives.blp',
                'Compare a red blade fan with blood impacts. Works while daggers are planted.'),
        ability('pDRs','Reset Test','T',1,1,'windwalk',0,imported+'BTNReturnGoods.blp',
                'Remove daggers, heal or replace the scarecrow, and clear the ultimate cooldown.')]
    return {'war3map.w3u':write_objects(dict(original=[],custom=[thief,dummy]),2,'w3u'),
            'war3map.w3a':write_objects(dict(original=[],custom=abilities),2,'w3a')},thief,abilities

def editor_files(script):
    fs=functions(script)
    # WE generates main/config itself. The editor trigger only calls main_old.
    source=script.replace(fs['main'],'').replace(fs['config'],'')
    for name in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities']:
        if name in fs:source=source.replace(fs[name],'')
    globals_block=re.search(r'^globals\n.*?^endglobals\n',source,re.M|re.S)[0]
    source=source.replace(globals_block,'',1)
    tree=dict(format='reforged',counts={k:0 for k in ITEM_TYPES},deleted={k:[] for k in ITEM_TYPES},
              game_version=2,variables=[],tail=b'',items=[
        dict(kind=1,id=0,name=NAME,is_comment=0,expanded=1,parent=-1),
        dict(kind=4,id=1,name='Dagger prototype',is_comment=0,expanded=1,parent=0),
        dict(kind=8,id=2,name='DaggerPrototype',desc='Standalone ability and visual test.',is_comment=0,
             enabled=1,custom=1,initially_off=0,run_on_init=1,parent=1,functions=[])])
    tree['counts'].update({1:1,4:1,8:1})
    wct=dict(format='reforged',comment=b'Standalone Thief dagger prototype',header=raw_of(globals_block),entries=[raw_of(source)])
    return {'war3map.wtg':write_wtg(tree),'war3map.wct':write_wct(wct)}

def build():
    raise RuntimeError('Prototype 01 is quarantined after map-browser crashes. Use build_thief_daggers_template.py; do not reinstall 01.')
    assert not OUT.exists(),'Use a new prototype filename; never overwrite a tested map.'
    base=MPQ(str(BASE));script=(HERE/'ThiefDaggers.j').read_text()
    originals={n:base.read(n) for n in (base.read('(listfile)') or b'').decode().splitlines()}
    files={name:None for name in originals if name not in ['(listfile)','(attributes)','(signature)']}
    payload=dict()
    payload.update({'war3map.j':script.replace('\n','\r\n').encode(),'war3map.w3i':map_info(),
                    'war3map.wts':b'',
                    'war3map.w3e':terrain(),'war3map.wpm':b'MP3W'+ints(0,256,256)+bytes(256*256),
                    'war3map.shd':bytes(256*256),'war3map.doo':b'W3do'+ints(8,11,0,0,0),
                    'war3mapUnits.doo':b'W3do'+ints(8,11,0),
                    'war3map.w3r':ints(5,0),'war3map.w3c':ints(0,0),'war3map.mmp':ints(0,0)})
    objects,thief,abilities=object_data(base);payload.update(objects);payload.update(editor_files(script))
    imported={fields(thief)['uico',None],fields(thief)['ussi',None]}
    imported.update(fields(a)['aart',0] for a in abilities)
    for name in imported:
        if base.read(name):payload[name]=base.read(name)
    custom=[name for name in imported if name in payload]
    payload['war3map.imp']=ints(1,len(custom))+b''.join(bytes([13])+z(name) for name in sorted(custom))
    # Delete first, so the original archive's hash table has ample free slots.
    files.update(payload)
    OUT.parent.mkdir(parents=True,exist_ok=True);tmp=OUT.with_suffix('.unpacked.w3x')
    write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));tmp.unlink()
    data=OUT.read_bytes();OUT.write_bytes(build_header(NAME,0,1)+data[data.index(b'MPQ\x1a'):])
    check=MPQ(str(OUT))
    for name,data in payload.items():assert check.read(name)==data,name
    assert len(read_objects(check.read('war3map.w3u'),'w3u')['custom'])==2
    assert len(read_objects(check.read('war3map.w3a'),'w3a')['custom'])==6
    assert set(re.findall(r"CreateUnit\([^\n]*?'(....)'",script))=={'H00B','u01M'}
    assert 'QuickGear_' not in script and 'PauseUnit' not in script
    report=dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),bytes=OUT.stat().st_size,
                actors=['Thief','Scarecrow'],styles=3,daggers=dict(interval=.3,maximum=20,range=300),
                damage='count x (50 + 2 x AGI)',cooldown=2,main_map='untouched',live_test='pending')
    (OUT.parent/'checks.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__=='__main__':build()

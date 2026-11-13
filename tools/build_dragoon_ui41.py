"""Build UI41 from the confirmed UI40, integrating the approved Dragoon kit."""
from pathlib import Path
import hashlib,json,re,struct,subprocess,sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from editor_pair import View,runtime_for
from dragoon_rpg import ROOT,refresh,patch_objects,SKILLS,mana_cost,EYE_ICON
from order_libraries import order
from mpq import MPQ,write_files,compact
from wct import write_wct,raw_of,text_of
from downgrade import wts_write
from add_header import read_header,build_header
from jtok import functions,tokens

STAGE='QuickUI41'
BASE=ROOT/'release/development/QuickUI40/FFERPG-QuickUI40-Forsaken.w3x'
OUT=ROOT/'release/development/QuickUI41/FFERPG-QuickUI41-Forsaken.w3x'
EXTRA_FILES={}

def build():
    assert not OUT.exists(),'Preserve all previous builds.'
    view=View(BASE)
    modules={lib:refresh(source) for lib,source in view.modules.items()}
    changed={lib for lib in modules if modules[lib]!=view.modules[lib]}
    runtime=runtime_for(view,view,view,modules)
    runtime,_=order(runtime)
    wct=view.wct
    for i,raw in enumerate(wct['entries']):
        match=re.match(r'\s*library (\w+)\b',text_of(raw))
        if match and match[1] in changed:wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
    files=patch_objects(view.archive)
    files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)})
    strings={i:re.sub(r'\bLancer(s)?\b',lambda m:'Dragoon'+(m[1] or ''),s) for i,s in view.strings.items()}
    strings={i:s.replace('Thievery','1000 Cuts') if 'Thievery' in s and ('Abilities' in s or 'Thief' in s) else s for i,s in strings.items()}
    strings[38788]='FFERPG '+STAGE+' (Dragoon)'
    files['war3map.wts']=wts_write(strings)
    arena=MPQ(str(ROOT/'release/development/Dragoon10/FFERPG-Dragoon-10.w3x'))
    imp=view.archive.read('war3map.imp');version,count=struct.unpack_from('<II',imp);extra=[]
    for name in ['DragoonRune.tga','DragoonCharge.ogg','DragoonStab.ogg']:
        assert name.encode()+b'\0' not in imp
        files[name]=arena.read(name);assert files[name]
        extra.append(bytes([13])+name.encode()+b'\0')
    for name,data in EXTRA_FILES.items():
        assert name.encode()+b'\0' not in imp
        files[name]=data
        extra.append(bytes([13])+name.encode()+b'\0')
    files['war3map.imp']=struct.pack('<II',version,count+len(extra))+imp[8:]+b''.join(extra)
    OUT.parent.mkdir(parents=True,exist_ok=True)
    # Keep the exact compiled candidate and updated modules available for inspection.
    script=OUT.parent/'runtime.j';script.write_text(runtime)
    for lib in changed:(OUT.parent/(lib+'.j')).write_text(modules[lib])
    result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(script)],capture_output=True,text=True)
    print(result.stdout[-5000:],result.stderr);assert result.returncode==0
    tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));tmp.unlink()
    _,flags,players=read_header(str(BASE));data=OUT.read_bytes();OUT.write_bytes(build_header('FFERPG '+STAGE+' (Dragoon)',flags,players)+data[data.index(b'MPQ\x1a'):])
    packed=MPQ(str(OUT))
    for name,data in files.items():assert packed.read(name)==data,name
    for name in view.archive.read('(listfile)').decode().splitlines():
        if name not in files and name.lower() not in ['(listfile)','(attributes)','(signature)']:assert packed.read(name)==view.archive.read(name),name
    before,after=functions(view.runtime),functions(runtime)
    modified=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n]))
    report={'base':str(BASE),'output':str(OUT),'sha256':hashlib.sha256(OUT.read_bytes()).hexdigest(),'changed_modules':sorted(changed),'changed_existing_functions':modified,'new_functions':sorted(after.keys()-before.keys()),'compile':'PASS','archive_readback':'PASS','unrelated_resources':'byte-identical','save_identity':'H00C / job7 and skill slots36..40 retained; all serializers unchanged','summon':'original Dragon Ally ranks, units, scaling and mastery preserved; hotkey D','balance':'ranked MP/damage curves: Knight Armor Breaker, Knight Shock, Flare and original Jump; Spear proficiency; original summon attacks retained','gameplay':'pending native/multiplayer/load/job-switch acceptance'}
    report.update({'drakesbane':{'reach':400,'angle':180},'eye_icon':EYE_ICON,'jump_target':'enemy unit, follows target while airborne','cooldowns':'all five abilities use existing CDR path; four motion/gated spells call scaling once explicitly','layout':'Q Sonic0,2; W Drakesbane1,2; E Dragon Ally2,2; R Jump3,2; T Rise3,1','mana':{raw:[mana_cost(raw,i) for i in range(1,7 if raw=='A14D' else 12)] for raw in SKILLS}})
    OUT.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(json.dumps({k:v for k,v in report.items() if k not in ['new_functions','changed_existing_functions']},indent=2))

if __name__=='__main__':build()

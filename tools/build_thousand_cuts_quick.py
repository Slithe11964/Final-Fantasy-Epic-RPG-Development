"""Build QuickUI30 from the user-selected UI28 release, changing only Thievery."""
from pathlib import Path
import sys,json,hashlib,struct
sys.path.insert(0,str(Path(__file__).resolve().parent))
from editor_pair import View,runtime_for
from thousand_cuts import refresh,objects,TOTALS,MANA,COOLDOWNS,ROOT
from wct import read_wct,write_wct,text_of,raw_of
from mpq import MPQ,write_files,compact
from order_libraries import order
from native_api import migrate
from add_header import read_header,build_header
from jtok import functions,tokens

BASE=ROOT/'release/0.9.7.5d/FFERPG-0.9.7.5d-Forsaken.w3x'
OUT=ROOT/'release/development/QuickUI30/FFERPG-QuickUI30-Forsaken.w3x'

def build():
    assert not OUT.exists(),'Never overwrite a user-tested quick build.'
    view=View(BASE);modules={lib:refresh(source) for lib,source in view.modules.items()}
    changed={lib for lib in modules if modules[lib]!=view.modules[lib]}
    assert changed=={'TDamage','TCooldown'},changed
    runtime=runtime_for(view,view,view,modules);runtime,_=migrate(runtime);runtime,_=order(runtime)
    before,after=functions(view.runtime),functions(runtime)
    allowed={'Trig_Damage_Engine_Actions','RegisterTriggers_Damage','Trig_Cooldown_Scaling_Conditions'}
    altered={n for n in before if n in after and tokens(before[n])!=tokens(after[n])}
    assert altered==allowed,altered
    assert set(after)-set(before)==set(functions((ROOT/'experiments/Forsaken/ThousandCuts.j').read_text()))
    # Backpack, quick-gear shortcuts, all other spells and save/load stay exact.
    wct=read_wct(view.archive.read('war3map.wct'))
    import re
    for i,entry in enumerate(wct['entries']):
        match=re.match(r'\s*library (\w+)\b',text_of(entry))
        if match and match[1] in changed:wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
    main,skin=objects(view.archive.read('war3map.w3a'),view.archive.read('war3mapSkin.w3a'))
    asset='ThiefDaggers\\BloodiedBlade-StillSilent.mdx'
    imp=view.archive.read('war3map.imp');version,count=struct.unpack_from('<II',imp)
    assert asset.encode() not in imp
    imp=struct.pack('<II',version,count+1)+imp[8:]+bytes([13])+asset.encode()+b'\0'
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.w3a':main,
        'war3mapSkin.w3a':skin,'war3map.imp':imp,asset:(ROOT/'experiments/ThiefDaggers/assets/BloodiedBlade-StillSilent.mdx').read_bytes()}
    OUT.parent.mkdir(parents=True,exist_ok=True);tmp=OUT.parent/'unpacked.w3x'
    write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));tmp.unlink()
    _,flags,players=read_header(str(BASE));data=OUT.read_bytes()
    OUT.write_bytes(build_header('FFERPG-QuickUI30 (1000 Cuts test)',flags,players)+data[data.index(b'MPQ\x1a'):])
    packed=MPQ(str(OUT))
    for name,value in files.items():assert packed.read(name)==value,name
    for name in view.archive.read('(listfile)').decode().splitlines():
        if name not in files and name.lower() not in ['(listfile)','(attributes)','(signature)']:assert packed.read(name)==view.archive.read(name),name
    report={'base':str(BASE),'output':str(OUT),'sha256':hashlib.sha256(OUT.read_bytes()).hexdigest(),'bytes':OUT.stat().st_size,
        'changed_modules':sorted(changed),'changed_existing_functions':sorted(altered),
        'skill':'A0KY: Thievery -> 1000 Cuts; existing six learned ranks and T ultimate slot retained; Fan of Knives unchanged',
        'balance':{'reference_daggers':40,'forty_dagger_base_damage':TOTALS,'forty_dagger_agility_coefficient':16,
            'proficiency_multiplier':'1 + 0.1 x effective Dagger proficiency','mana_on_activation':MANA,'mana_per_second':20,'mana_on_rip':300,'cooldown_after_rip':COOLDOWNS,
            'comparison':'Iainuki: 3000/3500/4000/4500/5000/6000 + 8 STR + 8 AGI, times Katana proficiency. Equal at equal STR/AGI and proficiency; 1000 Cuts needs 40 landed attacks.'},
        'mechanics':'Single target locked by first successful basic hit; uncapped stacks; independent 30-second expirations; stationary silent bloodied blades; one cutting sound on rip; ordinary physical combat pipeline; CDR applied before rip cooldown; per-player synchronized state; idle timer paused',
        'unchanged':'All other functions/resources, including QuickGear/backpack/savecode, verified against selected UI28-based release',
        'tests':'focused mechanic/object tests passed; compile and startup checks pending','live_test':'pending','installed':False}
    (OUT.parent/'checks.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

if __name__=='__main__':build()

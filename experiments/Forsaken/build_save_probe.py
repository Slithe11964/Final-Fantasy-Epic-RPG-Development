"""Build a private BT-based live inventory/codec diagnostic using mandatory map gates."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from mpq import MPQ
from wct import read_wct, text_of
import save_registry


def identity(path):
    return dict(path=str(path.resolve()),sha256=hashlib.sha256(path.read_bytes()).hexdigest())


def validate_gear_fixture(archive,objects):
    from objdata import read_objects,fields
    shoes=objects.get('f003',{})
    if shoes.get('iabi')!='A0MU,fGmk' or shoes.get('iequ')!='Boots' or shoes.get('icla')!='Equipment' or shoes.get('ihtp')!=1:
        raise ValueError('unreviewed real boots fixture')
    table=read_objects(archive.read('war3map.w3a'),'w3a')
    abilities={o['id'] or o['base']:o for group in ('original','custom') for o in table[group]}
    for raw,base,expected in [('A0MU','AIms',{('Imvb',1):80}),('fGmk','AIi1',{('Iagi',1):0,('Iint',1):0,('Istr',1):0}),('fBag','AInx',{('inv6',1):30}),('fGer','AEqu',{('equ1',1):0})]:
        obj=abilities.get(raw,{})
        data=fields(obj) if obj else {}
        if obj.get('base')!=base or any(data.get(k)!=v for k,v in expected.items()):
            raise ValueError('unreviewed gear ability fixture: '+raw)


def probe_source(aliases):
    text=(HERE/'Forsaken-save-probe.j').read_text()
    lines=["    call SaveInteger(FSX_Map,0,'%s',%d)"%(raw,id) for raw,id in sorted(aliases.items())]
    return text.replace('    // FSX_IDENTITY_INITIALIZATION','\n'.join(lines))


def modules(house=False,gear=False):
    house=house or gear
    result=[('ForsakenSaveCodec','Forsaken-save-codec.j'),('ForsakenSaveLife','Forsaken-save-life.j')]
    if house:
        result += [('ForsakenSaveNative','Forsaken-save-native.j'),('ForsakenSaveJournal','Forsaken-save-journal.j'),
                   ('ForsakenSaveEffects','Forsaken-save-effects.j'),('ForsakenSavePosition','Forsaken-save-position.j')]
    result.append(('ForsakenSaveProbe','Forsaken-save-probe.j'))
    if house:result.append(('ForsakenHouseProbe','Forsaken-house-probe.j'))
    if gear:result += [('ForsakenSaveEquipment','Forsaken-save-equipment.j'),('ForsakenGearProbe','Forsaken-gear-probe.j')]
    return result


def house_probe_source(runtime):
    triggers=sorted(set(re.findall(r'^\s*trigger\s+([A-Za-z_]\w*)\s*=',runtime,re.M)))
    if not triggers or len(triggers)>4096:raise ValueError('unexpected trigger guard count')
    arrays=set(re.findall(r'^\s*trigger\s+array\s+(\w+)',runtime,re.M))
    dynamic='QuestStepPickupTrigger' in arrays
    if dynamic and ('QuestStepTrigger' not in arrays or not re.search(r'constant integer QUEST_MAX_STEPS=16\b',runtime)):
        raise ValueError('unreviewed dynamic quest trigger layout')
    for first in re.findall(r'TriggerRegister\w+\(([^,]+),[^\n]*EVENT_(?:PLAYER_)?UNIT_(?:PICKUP_ITEM|DROP_ITEM|USE_ITEM)',runtime):
        if first.strip() not in triggers and not (dynamic and re.fullmatch(r'QuestStepPickupTrigger\[\w+\]',first.strip())):
            raise ValueError('unguarded inventory event registration: '+first)
    text=(HERE/'Forsaken-house-probe.j').read_text(encoding='utf-8')
    lines=['    call FHT_OneGuard(%s,%d,block)'%(name,i) for i,name in enumerate(triggers)]
    text=text.replace('    // FHT_TRIGGER_GUARD_INITIALIZATION','\n'.join(lines))
    if dynamic:
        capacity='    return QuestCount>=0 and QuestCount<=(8192-%d)/32-1'%len(triggers)
        text=text.replace('    // FHT_TRIGGER_GUARD_CAPACITY\n    return true',capacity)
        guard='    if block then\n        set FHT_Span=(QuestCount+1)*QUEST_MAX_STEPS\n    endif\n    loop\n        exitwhen slot>=FHT_Span\n        call FHT_OneGuard(QuestStepTrigger[slot],BASE+slot,block)\n        call FHT_OneGuard(QuestStepPickupTrigger[slot],BASE+FHT_Span+slot,block)\n        set slot=slot+1\n    endloop\n    if not block then\n        set FHT_Span=0\n    endif'.replace('BASE',str(len(triggers)))
        text=text.replace('    // FHT_DYNAMIC_TRIGGER_GUARD_INITIALIZATION',guard)
    return text


def module_source(module,file,aliases,runtime):
    if module=='ForsakenSaveProbe':return probe_source(aliases)
    if module=='ForsakenHouseProbe':return house_probe_source(runtime)
    if module=='ForsakenGearProbe':return (HERE/file).read_text(encoding='utf-8')
    return (HERE/file).read_text(encoding='utf-8').replace('endlibrary',
        'function InitTrig_'+module+' takes nothing returns nothing\nendfunction\nendlibrary')


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--stage',default='BU')
    p.add_argument('--house-probe',action='store_true',help='include reversible temporary native house storage tests')
    p.add_argument('--gear-probe',action='store_true',help='include real boots equipment and extended bag tests on a contained hero')
    p.add_argument('--base',type=Path,default=ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x')
    p.add_argument('--mapping',type=Path,default=ROOT/'release/Forsaken/gear-slots-BS.json')
    p.add_argument('--resume-checked-build',type=Path,help='reuse a completed mandatory stage build after a publication/audit interruption')
    args=p.parse_args()
    args.house_probe=args.house_probe or args.gear_probe
    if not re.fullmatch('[A-Z][A-Z0-9]*',args.stage): p.error('invalid stage')
    dest=ROOT/'release/Forsaken'
    names=['FFERPG_0.9.7.3-r16-Forsaken'+args.stage+'.w3x','checks-r16-stage'+args.stage+'.txt',
           'build-r16-stage'+args.stage+'.json','save-probe-'+args.stage+'.json']
    if any((dest/name).exists() for name in names): p.error('choose an unused stage; outputs are never overwritten')
    base=args.base.resolve()
    if base.read_bytes()[:4]!=b'HM3W': raise ValueError('base must have a playable HM3W header')
    registry,aliases=save_registry.check(json.loads(args.mapping.read_text()))
    runtime=MPQ(str(base)).read('war3map.j').decode()
    if args.house_probe:
        from objdata import read_objects,fields
        objects={}
        archive=MPQ(str(base))
        for member in ('war3map.w3t','war3mapSkin.w3t'):
            data=archive.read(member)
            if data:
                table=read_objects(data,'w3t')
                for group in ('original','custom'):
                    for obj in table[group]:objects.setdefault(obj['id'] or obj['base'],{}).update(fields(obj))
        gap=objects.get('fGap',{})
        if gap.get('iabi')!='' or gap.get('ipow')!=0 or gap.get('iuse')!=0:
            raise ValueError('fGap is not the reviewed zero-ability temporary spacer')
        if args.gear_probe:
            validate_gear_fixture(archive,objects)
        house_probe_source(runtime)
    allow_new='^gg_trg_Forsaken_(Save|House|Gear)Probe$' if args.gear_probe else '^gg_trg_Forsaken_(Save|House)Probe$' if args.house_probe else '^gg_trg_Forsaken_SaveProbe$'
    alias_roots=dict(re.findall(r"SaveInteger\(ForsakenGearTypes,4,'(....)','(....)'\)",runtime))
    offhands=dict(re.findall(r"SaveInteger\(ForsakenGearTypes,6,'(....)','(....)'\)",runtime))
    canonical={r['rawcode']:r['id'] for r in registry['items']}
    for raw,id in aliases.items():
        if raw in canonical: continue
        original=alias_roots.get(offhands.get(raw,raw))
        if canonical.get(original)!=id: raise ValueError('mapping does not match actual base runtime: '+raw)
    if args.resume_checked_build:
        work=args.resume_checked_build.resolve()
        if not work.is_relative_to((ROOT/'build').resolve()): raise ValueError('resume workspace must be under this repository build directory')
        checked=json.loads((work/'release'/names[2]).read_text())
        built=work/'release'/names[0]
        if hashlib.sha256(built.read_bytes()).hexdigest()!=checked['output']['sha256']:
            raise ValueError('checked output hash changed')
        if hashlib.sha256((work/'release'/names[1]).read_bytes()).hexdigest()!=checked['checks_sha256']:
            raise ValueError('checked build log changed')
        for module,file in modules(args.house_probe,args.gear_probe):
            expected=module_source(module,file,aliases,runtime)
            if (work/'src/triggers/11 Save diagnostics'/(module+'.j')).read_text()!=expected:
                raise ValueError('resume source differs: '+module)
        for tool,values in [('check_map.py',[built,'--baseline',base,'--allow-new',allow_new]),('check_sources.py',[built])]:
            subprocess.run([sys.executable,str(work/'tools'/tool),*map(str,values)],cwd=work,check=True)
        publish(base,built,args.mapping,aliases,work,names,dest,args.stage,args.house_probe,args.gear_probe)
        return
    scratch=Path(tempfile.mkdtemp(prefix='SaveProbe'+args.stage+'-',dir=ROOT/'build'))
    work=scratch/'FFERPG'
    for folder in ('src','tools','baseline'):
        shutil.copytree(ROOT/folder,work/folder,ignore=shutil.ignore_patterns('__pycache__'))
    shutil.copy2(ROOT/'build.ps1',work/'build.ps1')
    config_path=work/'tools/build-config.json'
    config=json.loads(config_path.read_text())
    config.update(prefix='FFERPG_0.9.7.3-r16-Forsaken',title='FF Epic RPG - SAVE DIAGNOSTIC (character saving disabled)')
    config_path.write_text(json.dumps(config,indent=2)+'\n')
    logs=[]
    def run(tool,*values):
        result=subprocess.run([sys.executable,str(tool),*map(str,values)],cwd=work,capture_output=True,text=True,errors='replace')
        logs.append(result.stdout+result.stderr)
        (scratch/'probe-build.log').write_text('\n'.join(logs))
        print(result.stdout+result.stderr,flush=True)
        if result.returncode: raise ValueError('failed '+str(tool)+'; scratch retained at '+str(scratch))
    run(work/'tools/export_sources.py',base,work/'src')
    previous=base
    for module,file in modules(args.house_probe,args.gear_probe):
        source=module_source(module,file,aliases,runtime)
        path=work/'src/triggers/11 Save diagnostics'/ (module+'.j')
        path.parent.mkdir(parents=True,exist_ok=True)
        path.write_bytes(source.replace('\n','\r\n').encode())
        current=scratch/(module+'.w3x')
        run(work/'tools/add_module.py',previous,current,'11 Save diagnostics',module)
        previous=current
    run(work/'tools/check_map.py',previous,'--baseline',base,'--allow-new',allow_new)
    # Use the established stage builder for all compilation/source/compatibility/content gates.
    run(work/'tools/build_stage.py',args.stage,'--base',previous)
    built=work/'release'/names[0]
    run(work/'tools/check_map.py',built,'--baseline',base,'--allow-new',allow_new)
    publish(base,built,args.mapping,aliases,work,names,dest,args.stage,args.house_probe,args.gear_probe)


def publish(base,built,mapping,aliases,work,names,dest,stage,house=False,gear=False):
    original,out=MPQ(str(base)),MPQ(str(built))
    # MPQ member CRC metadata changes when scripts change; it is not gameplay content.
    changed={'war3map.j','war3map.wtg','war3map.wct','(attributes)'}
    entries=set(original.read('(listfile)').decode().replace('\r','').splitlines())
    preserved={name:hashlib.sha256(original.read(name)).hexdigest() for name in sorted(entries-changed)
               if original.read(name) is not None}
    if any(out.read(name)!=original.read(name) for name in preserved): raise ValueError('original archive member changed unexpectedly')
    before=read_wct(original.read('war3map.wct'))
    after=read_wct(out.read('war3map.wct'))
    if before['header']!=after['header'] or not all(raw in after['entries'] for raw in before['entries']):
        raise ValueError('original editor source changed')
    report=dict(stage=stage,scope='Private inventory/codec engine diagnostic; no character load, durable save export, files or multiplayer transport.',
                base=identity(base),output=identity(built),mapping=identity(mapping),
                sources={name:identity(HERE/name) for name in [file for _,file in modules(house,gear)]+['build_save_probe.py']},
                preserved_members=preserved,original_editor_source_preserved=True,aliases=len(aliases),
                scratch=str(work),commands=['-savecheck','-saveverify']+(['-savehousecheck','-savehousecleanup'] if house else []),save_export_disabled=True,
                house_probe=house,gear_probe=gear)
    if gear:
        report['commands'].append('-savegearcheck')
        report['gear_fixture']={'raw':'f003','passive':'A0MU','marker':'fGmk','move_bonus':80,'life':1,'equipment_slot':3,'bag_slot':29}
    if house:
        generated=house_probe_source(original.read('war3map.j').decode('utf-8'))
        report['house_guard_sha256']=hashlib.sha256(generated.encode('utf-8')).hexdigest()
        report['guarded_triggers']=len(re.findall(r'call FHT_OneGuard\([^,]+,\d+,block\)',generated))
        report['dynamic_trigger_arrays']=['QuestStepTrigger','QuestStepPickupTrigger'] if 'QuestStepPickupTrigger[slot]' in generated else []
        report['trigger_guard_capacity']=8192
        report['scope']='Private inventory/codec and synthetic temporary native house diagnostic; no character load, durable export, files or multiplayer transport.'
    if any((dest/name).exists() for name in names): raise ValueError('output appeared while building; refusing overwrite')
    dest.mkdir(exist_ok=True)
    for name in names[:3]:
        with (dest/name).open('xb') as stream: stream.write((work/'release'/name).read_bytes())
    with (dest/names[3]).open('x',encoding='utf-8') as stream: json.dump(report,stream,indent=2); stream.write('\n')
    print('PRIVATE TEST MAP:',dest/names[0])
    print('Original BT and shared sources unchanged. Scratch:',work)


if __name__=='__main__': main()

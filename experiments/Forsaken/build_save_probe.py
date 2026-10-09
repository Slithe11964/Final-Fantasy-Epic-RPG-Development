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


def probe_source(aliases):
    text=(HERE/'Forsaken-save-probe.j').read_text()
    lines=["    call SaveInteger(FSX_Map,0,'%s',%d)"%(raw,id) for raw,id in sorted(aliases.items())]
    return text.replace('    // FSX_IDENTITY_INITIALIZATION','\n'.join(lines))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--stage',default='BU')
    p.add_argument('--base',type=Path,default=ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x')
    p.add_argument('--mapping',type=Path,default=ROOT/'release/Forsaken/gear-slots-BS.json')
    p.add_argument('--resume-checked-build',type=Path,help='reuse a completed mandatory stage build after a publication/audit interruption')
    args=p.parse_args()
    if not re.fullmatch('[A-Z][A-Z0-9]*',args.stage): p.error('invalid stage')
    dest=ROOT/'release/Forsaken'
    names=['FFERPG_0.9.7.3-r16-Forsaken'+args.stage+'.w3x','checks-r16-stage'+args.stage+'.txt',
           'build-r16-stage'+args.stage+'.json','save-probe-'+args.stage+'.json']
    if any((dest/name).exists() for name in names): p.error('choose an unused stage; outputs are never overwritten')
    base=args.base.resolve()
    if base.read_bytes()[:4]!=b'HM3W': raise ValueError('base must have a playable HM3W header')
    registry,aliases=save_registry.check(json.loads(args.mapping.read_text()))
    runtime=MPQ(str(base)).read('war3map.j').decode()
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
        for module,file in [('ForsakenSaveCodec','Forsaken-save-codec.j'),('ForsakenSaveLife','Forsaken-save-life.j'),('ForsakenSaveProbe','Forsaken-save-probe.j')]:
            expected=probe_source(aliases) if module=='ForsakenSaveProbe' else (HERE/file).read_text().replace('endlibrary','function InitTrig_'+module+' takes nothing returns nothing\nendfunction\nendlibrary')
            if (work/'src/triggers/11 Save diagnostics'/(module+'.j')).read_text()!=expected:
                raise ValueError('resume source differs: '+module)
        for tool,values in [('check_map.py',[built,'--baseline',base,'--allow-new','^gg_trg_Forsaken_SaveProbe$']),('check_sources.py',[built])]:
            subprocess.run([sys.executable,str(work/'tools'/tool),*map(str,values)],cwd=work,check=True)
        publish(base,built,args.mapping,aliases,work,names,dest,args.stage)
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
    for module,file in [('ForsakenSaveCodec','Forsaken-save-codec.j'),('ForsakenSaveLife','Forsaken-save-life.j'),('ForsakenSaveProbe','Forsaken-save-probe.j')]:
        source=probe_source(aliases) if module=='ForsakenSaveProbe' else (HERE/file).read_text().replace('endlibrary',
                'function InitTrig_'+module+' takes nothing returns nothing\nendfunction\nendlibrary')
        path=work/'src/triggers/11 Save diagnostics'/ (module+'.j')
        path.parent.mkdir(parents=True,exist_ok=True)
        path.write_bytes(source.replace('\n','\r\n').encode())
        current=scratch/(module+'.w3x')
        run(work/'tools/add_module.py',previous,current,'11 Save diagnostics',module)
        previous=current
    run(work/'tools/check_map.py',previous,'--baseline',base,'--allow-new','^gg_trg_Forsaken_SaveProbe$')
    # Use the established stage builder for all compilation/source/compatibility/content gates.
    run(work/'tools/build_stage.py',args.stage,'--base',previous)
    built=work/'release'/names[0]
    run(work/'tools/check_map.py',built,'--baseline',base,'--allow-new','^gg_trg_Forsaken_SaveProbe$')
    publish(base,built,args.mapping,aliases,work,names,dest,args.stage)


def publish(base,built,mapping,aliases,work,names,dest,stage):
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
                sources={name:identity(HERE/name) for name in ('Forsaken-save-codec.j','Forsaken-save-life.j','Forsaken-save-probe.j','build_save_probe.py')},
                preserved_members=preserved,original_editor_source_preserved=True,aliases=len(aliases),
                scratch=str(work),commands=['-savecheck','-saveverify'],save_export_disabled=True)
    if any((dest/name).exists() for name in names): raise ValueError('output appeared while building; refusing overwrite')
    dest.mkdir(exist_ok=True)
    for name in names[:3]:
        with (dest/name).open('xb') as stream: stream.write((work/'release'/name).read_bytes())
    with (dest/names[3]).open('x',encoding='utf-8') as stream: json.dump(report,stream,indent=2); stream.write('\n')
    print('PRIVATE TEST MAP:',dest/names[0])
    print('Original BT and shared sources unchanged. Scratch:',work)


if __name__=='__main__': main()

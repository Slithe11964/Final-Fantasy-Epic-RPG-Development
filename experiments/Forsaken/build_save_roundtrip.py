"""Build the complete private fresh-character file round trip on gameplay BT."""
import argparse, hashlib, json, re, shutil, subprocess, sys, tempfile
from pathlib import Path
from build_save_probe import HERE, ROOT, capture_source, fresh_plan_source, identity
sys.path.insert(0,str(ROOT/'tools'))
from mpq import MPQ
from wct import read_wct
import save_registry
from map_presentation import prepare_map, sync_intro, expected_source, settings

BT_TEST_REVISION='0ef79c5'
BT_TEST_FILES=('test_armory_catalog.py','test_bazaar_frames.py','test_chronicles_secrets.py','test_quest_events.py')

def align_bt_tests(work):
    # Gameplay sources are exported from BT, so use its checked regression expectations.
    names=subprocess.run(['git','ls-tree','--name-only',BT_TEST_REVISION+':tools/tests'],cwd=ROOT,capture_output=True,text=True,check=True).stdout.splitlines()
    for path in (work/'tools/tests').glob('test_*.py'):
        if path.name not in names:
            path.unlink()  # This private BT workspace cannot test newer gameplay modules.
    for name in BT_TEST_FILES:
        result=subprocess.run(['git','show',BT_TEST_REVISION+':tools/tests/'+name],cwd=ROOT,capture_output=True,check=True)
        (work/'tools/tests'/name).write_bytes(result.stdout)

MODULES=[('ForsakenSaveCodec','Forsaken-save-codec.j'),('ForsakenSaveLife','Forsaken-save-life.j'),('ForsakenSaveCapture','Forsaken-save-capture.j'),('ForsakenSaveTransport','Forsaken-save-transport.j'),('ForsakenSaveFreshPlan','Forsaken-save-fresh-plan.j'),('ForsakenSaveFreshObjects','Forsaken-save-fresh-objects.j'),('ForsakenFreshLoad','Forsaken-fresh-load.j')]

def load_source(runtime):
    triggers=sorted(set(re.findall(r'^\s*trigger\s+(\w+)\s*=',runtime,re.M)))
    dynamic='trigger array QuestStepPickupTrigger' in runtime
    lines=['    local integer slot=0']
    lines+=['    call FFL_OneGuard(%s,%d,block)'%(n,i) for i,n in enumerate(triggers)]
    if dynamic:
        if 'constant integer QUEST_MAX_STEPS=16' not in runtime: raise ValueError('quest layout changed')
        # Fixed ranges avoid collisions and cover every currently allocated quest step.
        span=(8192-len(triggers))//2
        lines+=['    loop','        exitwhen slot>=(QuestCount+1)*QUEST_MAX_STEPS or slot>='+str(span),'        call FFL_OneGuard(QuestStepTrigger[slot],%d+slot,block)'%len(triggers),'        call FFL_OneGuard(QuestStepPickupTrigger[slot],%d+slot,block)'%(len(triggers)+span),'        set slot=slot+1','    endloop']
        quest_max=max(map(int,re.findall(r'QuestCount=(\d+)',runtime)) or [93])
        if (quest_max+1)*16>span: raise ValueError('guard capacity insufficient')
    return (HERE/'Forsaken-fresh-load.j').read_text().replace('    // FFL_TRIGGER_GUARD_INITIALIZATION','\n'.join(lines))

def main():
    p=argparse.ArgumentParser();p.add_argument('--stage',default='CU');p.add_argument('--resume-work',type=Path)
    p.add_argument('--small-file-pages',action='store_true',help='test build: 920-character file pages so ordinary saves span several files')
    args=p.parse_args()
    if not re.fullmatch('[A-Z][A-Z0-9]*',args.stage):p.error('invalid stage')
    base=ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x'
    mapping=ROOT/'release/Forsaken/gear-slots-BS.json';catalog=json.loads(mapping.read_text())
    registry,aliases=save_registry.check(catalog);runtime=MPQ(str(base)).read('war3map.j').decode()
    dest=ROOT/'release/Forsaken'
    names=['FFERPG_0.9.7.3-r16-Forsaken'+args.stage+'.w3x','checks-r16-stage'+args.stage+'.txt','build-r16-stage'+args.stage+'.json','save-roundtrip-'+args.stage+'.json']
    if any((dest/n).exists() for n in names):p.error('outputs already exist')
    if args.resume_work:
        work=args.resume_work.resolve();scratch=work.parent
        if not work.is_relative_to((ROOT/'build').resolve()):raise ValueError('resume must be an existing build workspace')
    else:
        scratch=Path(tempfile.mkdtemp(prefix='SaveRoundtrip'+args.stage+'-',dir=ROOT/'build'));work=scratch/'FFERPG'
        for folder in ('src','tools','baseline'):shutil.copytree(ROOT/folder,work/folder,ignore=shutil.ignore_patterns('__pycache__'))
        shutil.copy2(ROOT/'build.ps1',work/'build.ps1')
    base=prepare_map(base,scratch/'presentation-base.w3x',args.stage) if not args.resume_work else scratch/'presentation-base.w3x'
    align_bt_tests(work)
    config=work/'tools/build-config.json';data=json.loads(config.read_text());data.update(prefix='FFERPG_0.9.7.3-r16-Forsaken',title=settings()['name']+' Forsaken '+args.stage+' private save/restart/load test');config.write_text(json.dumps(data,indent=2)+'\n')
    logs=[]
    def run(tool,*values):
        result=subprocess.run([sys.executable,str(work/'tools'/tool),*map(str,values)],cwd=work,capture_output=True,text=True,errors='replace')
        logs.append(result.stdout+result.stderr);(scratch/'roundtrip-build.log').write_text('\n'.join(logs));print(result.stdout+result.stderr,flush=True)
        if result.returncode:raise ValueError('failed '+tool+'; retained '+str(scratch))
    if not args.resume_work:
        seed=subprocess.run(['git','show',BT_TEST_REVISION+':src/trigger-list.json'],cwd=ROOT,capture_output=True,check=True)
        (work/'src/trigger-list.json').write_bytes(seed.stdout)
        run('export_sources.py',base,work/'src')
        entries=json.loads((work/'src/trigger-list.json').read_text())
        kept={work/'src/triggers'/entry['folder']/(entry['name']+'.j') for entry in entries if entry.get('library')}
        for path in (work/'src/triggers').rglob('*.j'):
            if path not in kept:
                path.unlink()  # Export does not delete modules absent from the selected base.
    sync_intro(work)
    job_path=work/'src/triggers/03 Jobs and progression/Job.j'
    job_source=job_path.read_text()
    first,rest=job_source.split('\n',1)
    if not re.search(r'\bTUnit\b',first):
        first+=', TUnit'
        job_path.write_bytes((first+'\n'+rest).replace('\n','\r\n').encode())
    previous=base
    for module,file in MODULES:
        if module=='ForsakenSaveCapture':source=capture_source(aliases)
        elif module=='ForsakenSaveFreshPlan':source=fresh_plan_source(registry,catalog)
        elif module=='ForsakenFreshLoad':source=load_source(runtime)
        else:source=(HERE/file).read_text()
        if module=='ForsakenSaveTransport' and args.small_file_pages:
            source=source.replace('constant integer FST_CHUNK=160','constant integer FST_CHUNK=40')
            if 'FST_CHUNK=40' not in source:raise ValueError('transport chunk constant not found')
        if module!='ForsakenFreshLoad':source=source.replace('endlibrary','function InitTrig_'+module+' takes nothing returns nothing\nendfunction\nendlibrary')
        path=work/'src/triggers/11 Save prototype'/(module+'.j')
        if args.resume_work:
            if path.read_text()!=source:raise ValueError('resume source changed: '+module)
        else:
            path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(source.replace('\n','\r\n').encode())
        current=scratch/(module+'.w3x')
        if not args.resume_work:run('add_module.py',previous,current,'11 Save prototype',module)
        previous=current
    presented_script=scratch/'presentation-ready.w3x'
    if not presented_script.exists():
        run('sync_module.py',previous,scratch/'intro-ready.w3x','Intro')
        run('sync_module.py',scratch/'intro-ready.w3x',scratch/'job-ready.w3x','Job')
        run('sync_module.py',scratch/'job-ready.w3x',presented_script,'Shrine')
    previous=presented_script
    allow='^gg_trg_Forsaken_FreshLoad$'
    built=work/'release'/names[0]
    if not built.exists():  # a resumed build skips stages that already finished
        run('check_map.py',previous,'--baseline',base,'--allow-new',allow)
        run('build_stage.py',args.stage,'--base',previous)
    run('check_map.py',built,'--baseline',base,'--allow-new',allow)
    original,out=MPQ(str(base)),MPQ(str(built));changed={'war3map.j','war3map.wtg','war3map.wct','(attributes)'}
    members=set(original.read('(listfile)').decode().replace('\r','').splitlines())-changed
    if any(out.read(n)!=original.read(n) for n in members):raise ValueError('gameplay archive content changed')
    before,after=read_wct(original.read('war3map.wct')),read_wct(out.read('war3map.wct'))
    expected=[]
    for entry in before['entries']:
        if entry.startswith(b'library TJob '):
            first,rest=entry.split(b'\n',1)
            if not re.search(rb'\bTUnit\b',first):
                entry=first.rstrip(b'\r')+b', TUnit\r\n'+rest
        expected.append(expected_source(entry,work))
    if before['header']!=after['header'] or not all(e in after['entries'] for e in expected):raise ValueError('original source changed beyond the Job dependency repair')
    report=dict(stage=args.stage,scope='Real file save/restart/fresh load prototype; no quests or live swap.',base=identity(base),output=identity(built),sources={module:identity(work/'src/triggers/11 Save prototype'/(module+'.j')) for module,_ in MODULES},commands=['-save','-savepage NUMBER','-savef NAME','-load FSVB:CHECK:PART:TOTAL:CHUNK','-loadf NAME','-newsave','-newload','-newcleanup','-newretrycheck'],scratch=str(work),engine_measurements_pending=True,bt_regression_revision=BT_TEST_REVISION,bt_regression_files=list(BT_TEST_FILES))
    for n in names[:3]:
        with (dest/n).open('xb') as stream:stream.write((work/'release'/n).read_bytes())
    with (dest/names[3]).open('x') as stream:json.dump(report,stream,indent=2)
    print('PRIVATE ROUNDTRIP MAP:',dest/names[0])
if __name__=='__main__':main()

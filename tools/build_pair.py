"""Build both playable profiles from one saved Reforged editor master.

Nothing edits src/, the input map or a reference map. Both checked maps publish
together; a merge conflict or classic incompatibility leaves only private scratch.
"""
import argparse
from contextlib import contextmanager
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys
import tempfile

from editor_pair import prepare, View, Conflict, classic_fallback
from mpq import MPQ
from editor_layout import trigger_items
from export_sources import export
from downgrade import wts_read

ROOT=Path(__file__).resolve().parents[1]


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def scenario_name(path):
    archive=MPQ(str(path));info=archive.read('war3map.w3i')
    version=struct.unpack_from('<i',info)[0];start=28 if version>=28 else 12
    name=info[start:info.index(b'\0',start)].decode('utf-8')
    ref=re.fullmatch(r'TRIGSTR_(\d+)',name)
    if ref:
        strings=wts_read(archive.read('war3map.wts'))
        if int(ref[1]) not in strings:raise Conflict('scenario name has an unresolved string-table reference')
        name=strings[int(ref[1])]
    return name


@contextmanager
def stage_lock(stage):
    folder=ROOT/'build';folder.mkdir(exist_ok=True)
    lock=folder/('editor-pair-'+stage+'.lock')
    with lock.open('x',encoding='ascii') as stream:stream.write(stage+'\n')
    try:yield
    finally:
        if lock.resolve().parent!=folder.resolve():raise Conflict('stage lock escaped the workspace')
        lock.unlink()


def export_tree(path,work):
    export(str(path),str(work/'src'))
    source=work/'src';entries=json.loads((source/'trigger-list.json').read_text(encoding='utf-8'))
    view=View(path)
    folders={item['id']:item['name'] for item in view.tree['items'] if item['kind']==4}
    for entry,item in zip(entries,trigger_items(view.tree)):
        if not entry.get('library'):
            entry['name']=item['name']
            continue
        old=source/'triggers'/entry['folder']/(entry['name']+'.j')
        new_folder=folders.get(item['parent'],'_new')
        target=source/'triggers'/new_folder/(item['name']+'.j')
        if old!=target:
            target.parent.mkdir(parents=True,exist_ok=True);old.rename(target)
        entry.update(name=item['name'],folder=new_folder)
    (source/'trigger-list.json').write_text(json.dumps(entries,indent=1)+'\n',encoding='utf-8')
    kept={source/'triggers'/entry['folder']/(entry['name']+'.j') for entry in entries if entry.get('library')}
    for file in (source/'triggers').rglob('*.j'):
        if file not in kept:file.unlink()


def native_tests(work):
    sys.path.insert(0,str(ROOT/'experiments/Forsaken'))
    from build_save_roundtrip import align_bt_tests
    align_bt_tests(work)
    for name in ('test_talents.py','test_armory_catalog.py','test_bazaar_browser.py','test_bazaar_frames.py','test_bazaar_reopen.py','test_quest_unlocks.py'):
        shutil.copy2(ROOT/'tools/tests'/name,work/'tools/tests'/name)
    fixture=work/'tools/tests/test_chronicles_secrets.py'
    old="        self.assertNotIn('Chronicles unlocked:', next(v[2] for v in e['writes'] if v[:2] == ('body', 'cSec')))"
    new="        self.assertIn(('body', 'cSec', 'Secrets description|n|n|cffffcc00Chronicles unlocked:|r 1 / 1', 0), e['writes'])"
    text=fixture.read_text(encoding='utf-8')
    if text.count(old)!=1:raise Conflict('pinned native Chronicle regression changed')
    fixture.write_text(text.replace(old,new,1),encoding='utf-8')


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map',type=Path,required=True)
    parser.add_argument('--stage',required=True)
    parser.add_argument('--config',type=Path,default=ROOT/'editor/pair-config.json')
    args=parser.parse_args()
    if not re.fullmatch('[A-Z][A-Z0-9]*',args.stage):parser.error('stage must be uppercase letters/digits')
    source=args.map.resolve()
    config=json.loads(args.config.read_text(encoding='utf-8'))
    if config.get('schema')!=1:raise Conflict('unsupported editor pair configuration version')
    editor=ROOT/config['editor_reference']['path'];native=ROOT/config['native_reference']['path']
    for label,path in [('editor_reference',editor),('native_reference',native)]:
        if sha(path)!=config[label]['sha256']:raise Conflict(label+' changed; rebase the editor master explicitly')
    if source in (editor.resolve(),native.resolve()):raise Conflict('Save As a separate editor master; do not edit the release references')
    final=ROOT/'release/pairs'/args.stage
    if final.exists():raise FileExistsError('stage output already exists: '+str(final))
    with stage_lock(args.stage):
        scratch=Path(tempfile.mkdtemp(prefix='EditorPair'+args.stage+'-',dir=ROOT/'build'))
        snapshot=scratch/'edited-master.w3x';shutil.copy2(source,snapshot)
        report=dict(stage=args.stage,editor_input=str(source),editor_input_sha256=sha(snapshot),references=config,
                    scenario_name=scenario_name(snapshot),outputs={},profiles={},
                    tool_sha256={name:sha(ROOT/'tools'/name) for name in ('editor_pair.py','build_pair.py','performance_runtime.py','save_strings.py')})
        aliases={raw:[v for v in (entry.get('variant'),entry.get('offhand')) if v]
                 for raw,entry in json.loads((ROOT/'release/Forsaken/gear-slots-BS.json').read_text(encoding='utf-8')).items()}
        print('Working copy:',scratch,flush=True)
        try:
            # Prepare both first: conflicts cannot publish one half of a pair.
            for profile,reference in [('Forsaken',native),('Classic',editor)]:
                target=scratch/(profile+'.w3x')
                report['profiles'][profile]=prepare(editor,snapshot,reference,target,native=profile=='Forsaken',aliases=aliases)
                print(profile+': edits prepared',flush=True)
            ready=scratch/'paired-output';ready.mkdir()
            for profile in ('Forsaken','Classic'):
                work=scratch/profile/'FFERPG';work.mkdir(parents=True)
                for folder in ('src','tools','baseline','experiments'):
                    shutil.copytree(ROOT/folder,work/folder,ignore=shutil.ignore_patterns('__pycache__'))
                for name in ('build.ps1','make_129.ps1'):shutil.copy2(ROOT/name,work/name)
                target=scratch/(profile+'.w3x')
                export_tree(target,work)
                (work/'release').mkdir()
                # Catalogue regressions inspect an existing source map in the private workspace.
                shutil.copy2(editor,work/'release'/editor.name)
                cfg_path=work/'tools/build-config.json'
                cfg=json.loads(cfg_path.read_text(encoding='utf-8'))
                if profile=='Forsaken':
                    cfg.update(prefix='FFERPG_0.9.7.3-r16-Forsaken')
                    native_tests(work)
                # The scenario name/description inside the input map remain authoritative.
                cfg['title']=report['scenario_name']+' - '+profile
                cfg['classic_title']=report['scenario_name']+' - 1.29.2 '+args.stage
                cfg['preserve_scenario_name']=True
                cfg['editor_scenario']=True
                if profile=='Classic':
                    fallback=scratch/'classic-fill.w3x'
                    template=work/'baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x'
                    report['classic_reset_fields']=classic_fallback(editor,snapshot,template,fallback)
                    cfg['classic_fill_from']=str(fallback)
                cfg_path.write_text(json.dumps(cfg,indent=2)+'\n',encoding='utf-8')
                env_args=[sys.executable,str(work/'tools/order_libraries.py'),str(target),str(scratch/(profile+'-ordered.w3x'))]
                subprocess.run(env_args,cwd=work,check=True)
                command=[sys.executable,str(work/'tools/build_stage.py'),args.stage,'--base',str(scratch/(profile+'-ordered.w3x'))]
                if profile=='Classic':command.append('--with-classic')
                log=scratch/(profile+'-build.txt')
                print(profile+': compiling and checking',flush=True)
                with log.open('wb') as stream:
                    result=subprocess.run(command,cwd=work,stdout=stream,stderr=subprocess.STDOUT)
                if result.returncode:
                    raise Conflict(profile+' build failed; details: '+str(log))
                filename=cfg['prefix']+args.stage+'.w3x'
                built=work/'release'/filename
                if profile=='Classic':built=built.parent/'1.29.2'/filename
                output='FFERPG-'+args.stage+'-'+('Forsaken' if profile=='Forsaken' else '1.29.2')+'.w3x'
                shutil.copy2(built,ready/output)
                shutil.copy2(work/'release'/('checks-r16-stage'+args.stage+'.txt'),ready/(profile+'-checks.txt'))
                shutil.copy2(work/'release'/('build-r16-stage'+args.stage+'.json'),ready/(profile+'-build.json'))
                report['outputs'][profile]=dict(file=output,sha256=sha(built))
                print(profile+': passed',flush=True)
            (ready/'pair-report.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
            final.parent.mkdir(exist_ok=True,parents=True)
            if final.exists():raise FileExistsError('stage output appeared while building: '+str(final))
            ready.rename(final)
            print('Both playable maps are ready:',final,flush=True)
        except Exception as error:
            (scratch/'failure.txt').write_text(str(error)+'\n',encoding='utf-8')
            raise


if __name__=='__main__':
    try:main()
    except (ValueError,OSError,subprocess.SubprocessError) as error:
        print('PAIR BUILD STOPPED: '+str(error),file=sys.stderr)
        raise SystemExit(1)

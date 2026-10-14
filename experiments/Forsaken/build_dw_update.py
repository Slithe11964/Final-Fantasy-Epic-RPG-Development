"""Update the DW private test with Chronicle visibility, Priest talents and faster house portals."""
import argparse
import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from mpq import MPQ, replace_files
from objdata import read_objects, write_objects
from wtg import read_wtg
from wct import read_wct
from editor_layout import trigger_items
from jtok import functions
import talents_catalog
from build_save_roundtrip import align_bt_tests, load_source
from map_presentation import prepare_map, settings


def priest_source():
    source=(ROOT/'src/triggers/03 Jobs and progression/Talents.j').read_text()
    source=source.replace('constant boolean TalentUseFrames=true','constant boolean TalentUseFrames=false')
    source=re.sub(r'^function Talents_GiveButton takes\b.*?^endfunction',
                  'function Talents_GiveButton takes nothing returns nothing\n    // Forsaken opens its own talent tree from the equipment panel.\nendfunction',source,count=1,flags=re.M|re.S)
    return source


def patch_job(source):
    old="and(GetUnitTypeId(GetSoldUnit())!='n0KL')"
    if source.count(old)!=1:raise ValueError('job purchase guard changed')
    return source.replace(old,old+"and(GetUnitTypeId(GetSoldUnit())!='nTRt')",1)


def patch_equip(source):
    first,rest=source.split('\n',1)
    source=first+', TTalents\n'+rest
    helper="""function Forsaken_PriestPoints takes integer pid,integer rank returns integer
    local integer row=1
    local integer points=rank
    loop
        exitwhen row>rank
        if TalentPick[Talent_PickIndex(pid,TALENT_JOB_PRIEST,row)]!=0 then
            set points=points-1
        endif
        set row=row+1
    endloop
    return points
endfunction

"""
    source=source.replace('function Forsaken_TalentCanPurchase',helper+'function Forsaken_TalentCanPurchase',1)
    start=source.index('function Forsaken_TalentCanPurchase')
    end=source.index('endfunction',start)
    source=source[:start]+source[start:end].replace('    if node<0', """    if ModuloInteger(key,100)==TALENT_JOB_PRIEST then
        return node>=0 and node<3 and rank>=1 and TalentPick[Talent_PickIndex(key/100,TALENT_JOB_PRIEST,1)]==0
    endif
    if node<0""")+source[end:]
    source=source.replace('        call SaveBoolean(ForsakenTalentState,key,node,true)', """        if job==TALENT_JOB_PRIEST and not Talent_Choose(owner,node/3+1,ModuloInteger(node,3)+1) then
            set hero=null
            set owner=null
            return
        endif
        call SaveBoolean(ForsakenTalentState,key,node,true)""",1)
    old='            call BlzFrameSetText(ForsakenTalentPoints,"Choices: "+I2S(rank-LoadInteger(ForsakenTalentState,key,20))+" / "+mastery+"|nPreview: no bonuses")'
    new="""            if job==TALENT_JOB_PRIEST then
                call BlzFrameSetText(ForsakenTalentPoints,"Points: "+I2S(Forsaken_PriestPoints(playerIndex,rank))+" / "+I2S(rank)+" earned|nLevels 1, 50, 99, 100")
            else
"""+old+'\n            endif'
    if old not in source:raise ValueError('talent heading changed')
    source=source.replace(old,new,1)
    old='            if LoadBoolean(ForsakenTalentState,key,node) then'
    new="""            if job==TALENT_JOB_PRIEST then
                if column==0 then
                    set skill='A00G'
                elseif column==1 then
                    set skill='A0TZ'
                else
                    set skill='A00M'
                endif
                call BlzFrameSetTexture(ForsakenTalentIcon[node],BlzGetAbilityIcon(skill),0,true)
                if node<3 then
                    if TalentPick[Talent_PickIndex(playerIndex,job,1)]==column+1 then
                        call BlzFrameSetText(ForsakenTalentLabel[node],"|cff00ff00"+TalentName[Talent_Index(job,1,column+1)]+"|r")
                    else
                        call BlzFrameSetText(ForsakenTalentLabel[node],TalentName[Talent_Index(job,1,column+1)])
                    endif
                    call BlzFrameSetAlpha(ForsakenTalentIcon[node],255)
                    call BlzFrameSetEnable(ForsakenTalentButton[node],ForsakenInspectTarget==null and Forsaken_TalentCanPurchase(key,node,rank))
                else
                    call BlzFrameSetText(ForsakenTalentLabel[node],"Not yet available")
                    call BlzFrameSetAlpha(ForsakenTalentIcon[node],90)
                    call BlzFrameSetEnable(ForsakenTalentButton[node],false)
                endif
            elseif LoadBoolean(ForsakenTalentState,key,node) then"""
    if old not in source:raise ValueError('talent node display changed')
    return source.replace(old,new,1)


def prepare_objects(base,out):
    archive=MPQ(str(base))
    a=read_objects(archive.read('war3map.w3a'),'w3a')
    sa=read_objects(archive.read('war3mapSkin.w3a'),'w3a')
    u=read_objects(archive.read('war3map.w3u'),'w3u')
    su=read_objects(archive.read('war3mapSkin.w3u'),'w3u')
    talents_catalog.rebase_cure(a,sa)
    talents_catalog.prepare(a)
    talents_catalog.prepare_units(u,su)
    for table in (u,su):
        for obj in table['custom']:
            if obj['id'] in ('nTRt','n0KL'):
                talents_catalog.setf(obj,'ubpx',0,0 if obj['id']=='nTRt' else 3)
                talents_catalog.setf(obj,'ubpy',0,2)
    for table in (a,sa):
        objects={o['id']:o for o in table['custom']}
        for raw in ('A0P3','A04J'):
            if raw not in objects:continue
            obj=objects[raw]
            if table is a:
                talents_catalog.setf(obj,'Hmt2' if raw=='A0P3' else 'acas',2,3.,1,2 if raw=='A0P3' else 0)
            else:
                text=('Teleports the Hero and any of your nearby units to a target House. Requires 3 seconds to cast.'
                      if raw=='A0P3' else 'Teleports the Spirit of Gaya and any of your nearby troops to a target house.|nTakes 3 seconds to cast and has 90 seconds cooldown.')
                talents_catalog.setf(obj,'aub1',3,text,1)
    files={name:write_objects(table,table['version'],ext) for name,table,ext in
           [('war3map.w3a',a,'w3a'),('war3mapSkin.w3a',sa,'w3a'),('war3map.w3u',u,'w3u'),('war3mapSkin.w3u',su,'w3u')]}
    replace_files(str(base),str(out),files)
    return out


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--stage',default='DZ')
    ap.add_argument('--resume-work',type=Path)
    args=ap.parse_args()
    if not re.fullmatch('[A-Z][A-Z0-9]*',args.stage):ap.error('invalid stage')
    name='FFERPG_0.9.7.3-r16-Forsaken'+args.stage+'.w3x'
    dest=ROOT/'release/Forsaken'
    names=[name,'checks-r16-stage'+args.stage+'.txt','build-r16-stage'+args.stage+'.json']
    if any((dest/n).exists() for n in names):ap.error('outputs already exist')
    base=dest/'FFERPG_0.9.7.3-r16-ForsakenDW.w3x'
    if args.resume_work:
        work=args.resume_work.resolve()
        if not work.is_relative_to((ROOT/'build').resolve()):raise ValueError('resume workspace must be inside build')
        scratch=work.parent
    else:
        scratch=Path(tempfile.mkdtemp(prefix='ForsakenUpdate'+args.stage+'-',dir=ROOT/'build'))
        work=scratch/'FFERPG'
        for folder in ('src','tools','baseline'):
            shutil.copytree(ROOT/folder,work/folder,ignore=shutil.ignore_patterns('__pycache__'))
    for wrapper in ('build.ps1','make_129.ps1'):
        shutil.copy2(ROOT/wrapper,work/wrapper)
    logs=[]
    def run(tool,*values):
        result=subprocess.run([sys.executable,str(work/'tools'/tool),*map(str,values)],cwd=work,capture_output=True,text=True,errors='replace')
        logs.append(result.stdout+result.stderr);(scratch/'update-build.log').write_text('\n'.join(logs))
        print(result.stdout+result.stderr,flush=True)
        if result.returncode:raise ValueError('failed '+tool+'; retained '+str(scratch))
    if not args.resume_work:
        presented=prepare_map(base,scratch/'presentation.w3x',args.stage)
        prepared=prepare_objects(presented,scratch/'objects.w3x')
        run('export_sources.py',prepared,work/'src')
        entries=json.loads((work/'src/trigger-list.json').read_text())
        tree=read_wtg(MPQ(str(prepared)).read('war3map.wtg'))
        folders={i['id']:i['name'] for i in tree['items'] if i['kind']==4}
        for entry,item in zip(entries,trigger_items(tree)):
            if entry['name']!=item['name'] and entry.get('library'):raise ValueError('exported trigger order changed')
            if not entry.get('library'):entry['name']=item['name']
            folder=folders.get(item['parent'],entry['folder'])
            old=work/'src/triggers'/entry['folder']/(entry['name']+'.j')
            new=work/'src/triggers'/folder/(entry['name']+'.j')
            if old.exists() and old!=new:new.parent.mkdir(parents=True,exist_ok=True);old.rename(new)
            entry['folder']=folder
        (work/'src/trigger-list.json').write_text(json.dumps(entries,indent=1)+'\n')
        kept={work/'src/triggers'/e['folder']/(e['name']+'.j') for e in entries if e.get('library')}
        for path in (work/'src/triggers').rglob('*.j'):
            if path not in kept:path.unlink()
        align_bt_tests(work)
        shutil.copy2(ROOT/'tools/tests/test_talents.py',work/'tools/tests/test_talents.py')
        config=work/'tools/build-config.json';data=json.loads(config.read_text())
        data.update(prefix='FFERPG_0.9.7.3-r16-Forsaken',title=settings()['name']+' Forsaken '+args.stage+' private Chronicle/Priest test')
        config.write_text(json.dumps(data,indent=2)+'\n')
        def path(module):return next(work/'src/triggers'/e['folder']/(module+'.j') for e in entries if e['name']==module)
        def write(p,source):p.write_bytes(source.replace('\n','\r\n').encode())
        talent=work/'src/triggers/03 Jobs and progression/Talents.j'
        talent.parent.mkdir(parents=True,exist_ok=True);write(talent,priest_source())
        added=scratch/'talents.w3x'
        run('add_module.py',prepared,added,'03 Jobs and progression','Talents')
        for module,folder in [('Missile','01 Shared helpers'),('Spell_Cure','04 Combat and abilities')]:
            write(path(module),(ROOT/'src/triggers'/folder/(module+'.j')).read_text())
        write(path('Equip'),patch_equip(path('Equip').read_text()))
        write(path('Job'),patch_job(path('Job').read_text()))
        boot=path('MapBootstrap').read_text()
        first,rest=boot.split('\n',1);boot=first+', optional TTalents\n'+rest
        start=boot.index('function Startup_RegisterTriggers');end=boot.index('endfunction',start)
        boot=boot[:end]+'    call ExecuteFunc("RegisterTriggers_Talents")\n'+boot[end:]
        write(path('MapBootstrap'),boot)
        runtime=MPQ(str(added)).read('war3map.j').decode()
        write(path('ForsakenFreshLoad'),load_source(runtime))
        synced=scratch/'sources.w3x'
        run('sync_module.py',added,synced,'Missile','Spell_Cure','Equip','Job','MapBootstrap','ForsakenFreshLoad')
        run('order_libraries.py',synced,scratch/'ordered.w3x')
    allow='^gg_trg_Talents_(Open|Guard|Reset|Dialog|FrameClick|FrameSync)$'
    built=work/'release'/name
    if not built.exists():run('build_stage.py',args.stage,'--base',scratch/'ordered.w3x','--allow-new',allow)
    run('check_map.py',built,'--baseline',base,'--allow-new',allow)
    original,out=MPQ(str(base)),MPQ(str(built))
    allowed={'war3map.w3i','war3map.j','war3map.wtg','war3map.wct','war3map.w3a','war3mapSkin.w3a','war3map.w3u','war3mapSkin.w3u','(attributes)'}
    for member in original.read('(listfile)').decode().replace('\r','').splitlines():
        if member not in allowed and original.read(member)!=out.read(member):raise ValueError('unrelated archive member changed: '+member)
    # Keep DW's codec and normal file paging byte-for-byte, apart from the loader fix.
    before=read_wct(original.read('war3map.wct'))['entries']
    after=read_wct(out.read('war3map.wct'))['entries']
    for entry in before:
        if any(entry.startswith(('library T'+lib+' ').encode()) for lib in
               ('ForsakenSaveCodec','ForsakenSaveLife','ForsakenSaveCapture','ForsakenSaveTransport','ForsakenSaveFreshPlan','ForsakenSaveFreshObjects')):
            if entry not in after:raise ValueError('DW save module changed unexpectedly')
    transport=next(e.decode() for e in after if e.startswith(b'library TForsakenSaveTransport '))
    if 'constant integer FST_CHUNK=160' not in transport:raise ValueError('DW normal file paging changed')
    for n in names:
        with (dest/n).open('xb') as stream:stream.write((work/'release'/n).read_bytes())
    print('FORSAKEN TEST MAP:',dest/name)

if __name__=='__main__':main()

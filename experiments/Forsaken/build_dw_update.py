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
import armory_menu_catalog
import ui_recovery
from build_save_roundtrip import align_bt_tests, load_source
from build_save_probe import capture_source, fresh_plan_source
import save_registry
from save_strings import lower_module
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
        if 'cSec' not in objects:
            raise ValueError('Secrets object missing from DW')
        talents_catalog.setf(objects['cSec'],'atp1',3,'Secrets',1)
        talents_catalog.setf(objects['cSec'],'aub1',3,ui_recovery.SECRETS,1)
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
    menu=out.with_name('menu-'+out.name)
    armory_menu_catalog.prepare(out,menu)
    return menu


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--stage',default='EA')
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
        for fixture in ('test_armory_catalog.py','test_bazaar_browser.py','test_bazaar_frames.py','test_bazaar_reopen.py','test_quest_unlocks.py'):
            shutil.copy2(ROOT/'tools/tests'/fixture,work/'tools/tests'/fixture)
        config=work/'tools/build-config.json';data=json.loads(config.read_text())
        data.update(prefix='FFERPG_0.9.7.3-r16-Forsaken',title=settings()['name']+' Forsaken '+args.stage+' private Chronicle/Priest test')
        config.write_text(json.dumps(data,indent=2)+'\n')
        def path(module):return next(work/'src/triggers'/e['folder']/(module+'.j') for e in entries if e['name']==module)
        def write(p,source):p.write_bytes(source.replace('\n','\r\n').encode())
        talent=work/'src/triggers/03 Jobs and progression/Talents.j'
        talent.parent.mkdir(parents=True,exist_ok=True);write(talent,priest_source())
        added=scratch/'talents.w3x'
        run('add_module.py',prepared,added,'03 Jobs and progression','Talents')
        cache=work/'src/triggers/11 Save prototype/ForsakenSaveCache.j'
        write(cache,(HERE/'Forsaken-save-cache.j').read_text().replace('endlibrary','function InitTrig_ForsakenSaveCache takes nothing returns nothing\nendfunction\nendlibrary'))
        cached=scratch/'cache.w3x'
        run('add_module.py',added,cached,'11 Save prototype','ForsakenSaveCache')
        recovery=work/'src/triggers/05 Items crafting and shops/ForsakenUIRecovery.j'
        write(recovery,(HERE/'Forsaken-ui-recovery.j').read_text())
        recovered=scratch/'recovery.w3x'
        run('add_module.py',cached,recovered,'05 Items crafting and shops','ForsakenUIRecovery')
        cached=recovered
        catalog=json.loads((ROOT/'release/Forsaken/gear-slots-BS.json').read_text())
        registry,aliases=save_registry.check(catalog)
        for module,source in [('ForsakenSaveCapture',capture_source(aliases)),
                              ('ForsakenSaveFreshPlan',fresh_plan_source(registry,catalog)),
                              ('ForsakenSaveTransport',(HERE/'Forsaken-save-transport.j').read_text())]:
            write(path(module),source.replace('endlibrary','function InitTrig_'+module+' takes nothing returns nothing\nendfunction\nendlibrary'))
        cmd=path('Cmd').read_text()
        current=(ROOT/'src/triggers/09 Player features/Cmd.j').read_text()
        pattern=r'^function Trig_Cmd_Load_Code_OpenCode takes\b.*?^endfunction'
        replacement=re.search(pattern,current,re.M|re.S).group()
        cmd,count=re.subn(pattern,lambda _:replacement,cmd,count=1,flags=re.M|re.S)
        if count!=1:raise ValueError('legacy load difficulty function changed')
        write(path('Cmd'),cmd)
        saved=path('Save').read_text()
        saved=saved.replace('globals\n','globals\n    boolean Save_UseNewAutosave=false\n    integer Save_AutosavePid=0\n',1)
        current=(ROOT/'src/triggers/09 Player features/Save.j').read_text()
        pattern=r'^function Save_Autosave takes\b.*?^endfunction'
        replacement=re.search(pattern,current,re.M|re.S).group()
        saved,count=re.subn(pattern,lambda _:replacement,saved,count=1,flags=re.M|re.S)
        if count!=1:raise ValueError('autosave function changed')
        write(path('Save'),saved)
        for module,folder in [('Missile','01 Shared helpers'),('Spell_Cure','04 Combat and abilities')]:
            write(path(module),(ROOT/'src/triggers'/folder/(module+'.j')).read_text())
        for module in ('Armory','Bazaar'):
            write(path(module),(ROOT/'src/triggers/05 Items crafting and shops'/(module+'.j')).read_text())
        write(path('Equip'),ui_recovery.panel_source(patch_equip(path('Equip').read_text())))
        write(path('Titles'),ui_recovery.secrets_source(path('Titles').read_text()))
        write(path('Vote'),ui_recovery.simple_notice_source(path('Vote').read_text()))
        write(path('Curse'),(HERE/'Forsaken-curse.j').read_text())
        for module in ('Quest_AoMadoushi','Quest_Phoenix'):
            write(path(module),(ROOT/'src/triggers/06 Quests and story'/(module+'.j')).read_text())
        write(path('Job'),patch_job(path('Job').read_text()))
        boot=path('MapBootstrap').read_text()
        first,rest=boot.split('\n',1);boot=first+', optional TTalents\n'+rest
        start=boot.index('function Startup_RegisterTriggers');end=boot.index('endfunction',start)
        boot=boot[:end]+'    call ExecuteFunc("RegisterTriggers_Talents")\n'+boot[end:]
        write(path('MapBootstrap'),boot)
        runtime=MPQ(str(cached)).read('war3map.j').decode()
        write(path('ForsakenFreshLoad'),load_source(runtime))
        # Generate bounded runtime storage from the same logical codec and permanent IDs.
        # This changes only internal representation; file chunks and screenshot parts stay exact.
        for module, file in [('ForsakenSaveCodec','Forsaken-save-codec.j'),
                             ('ForsakenSaveLife','Forsaken-save-life.j'),
                             ('ForsakenSaveFreshObjects','Forsaken-save-fresh-objects.j')]:
            source=(HERE/file).read_text().replace('endlibrary','function InitTrig_'+module+' takes nothing returns nothing\nendfunction\nendlibrary')
            write(path(module),source)
        save_modules=('ForsakenSaveCodec','ForsakenSaveLife','ForsakenSaveCapture','ForsakenSaveCache',
                      'ForsakenSaveTransport','ForsakenSaveFreshPlan','ForsakenSaveFreshObjects','ForsakenFreshLoad')
        for module in save_modules:
            target=cache if module=='ForsakenSaveCache' else path(module)
            write(target,lower_module(target.read_text()))
        synced=scratch/'sources.w3x'
        run('sync_module.py',cached,synced,'Missile','Spell_Cure','Equip','Job','Cmd','Save','Armory','Bazaar','Titles','Vote','Curse','Quest_AoMadoushi','Quest_Phoenix','MapBootstrap','ForsakenFreshLoad',
            *save_modules[:-1])
        run('order_libraries.py',synced,scratch/'ordered.w3x')
    # The pinned DW test predates the requested Secrets collection footer.
    fixture=work/'tools/tests/test_chronicles_secrets.py'
    text=fixture.read_text()
    old="        self.assertNotIn('Chronicles unlocked:', next(v[2] for v in e['writes'] if v[:2] == ('body', 'cSec')))"
    new="        self.assertIn(('body', 'cSec', 'Secrets description|n|n|cffffcc00Chronicles unlocked:|r 1 / 1', 0), e['writes'])"
    if old in text:
        fixture.write_text(text.replace(old,new,1))
    elif new not in text:
        raise ValueError('Chronicle fixture footer expectation changed')
    allow='^gg_trg_(Talents_(Open|Guard|Reset|Dialog|FrameClick|FrameSync)|Forsaken_UIRecovery)$'
    built=work/'release'/name
    if not built.exists():run('build_stage.py',args.stage,'--base',scratch/'ordered.w3x','--allow-new',allow)
    auditbase=scratch/'approved-ui-startup.j'
    auditbase.write_text(ui_recovery.startup_baseline(
        MPQ(str(base)).read('war3map.j').decode().replace('\r\n','\n'),
        MPQ(str(built)).read('war3map.j').decode().replace('\r\n','\n')))
    run('check_map.py',built,'--baseline',auditbase,'--allow-new',allow)
    original,out=MPQ(str(base)),MPQ(str(built))
    allowed={'war3map.w3i','war3map.j','war3map.wtg','war3map.wct','war3map.w3a','war3mapSkin.w3a','war3map.w3u','war3mapSkin.w3u','(attributes)'}
    for member in original.read('(listfile)').decode().replace('\r','').splitlines():
        if member not in allowed and original.read(member)!=out.read(member):raise ValueError('unrelated archive member changed: '+member)
    # Check the exact lowering of the canonical modules; file paging remains DW's.
    before=read_wct(original.read('war3map.wct'))['entries']
    after=read_wct(out.read('war3map.wct'))['entries']
    for module, file in [('ForsakenSaveCodec','Forsaken-save-codec.j'),
                         ('ForsakenSaveLife','Forsaken-save-life.j'),
                         ('ForsakenSaveFreshObjects','Forsaken-save-fresh-objects.j')]:
        source=(HERE/file).read_text().replace('endlibrary','function InitTrig_'+module+' takes nothing returns nothing\nendfunction\nendlibrary')
        expected=lower_module(source).strip()
        actual=next(e.decode().replace('\r\n','\n').rstrip('\x00').strip() for e in after
                    if e.startswith(('library T'+module).encode()))
        if actual!=expected:raise ValueError('unexpected bounded save module: '+module)
    transport=next(e.decode() for e in after if e.startswith(b'library TForsakenSaveTransport '))
    if 'constant integer FST_CHUNK=160' not in transport:raise ValueError('DW normal file paging changed')
    editor=b'\n'.join(after)
    if b'library TBackpack ' in editor or b'library TSaveSlots ' in editor:
        raise ValueError('classic backpack modules must never enter the Reforged Forsaken build')
    runtime=out.read('war3map.j').decode()
    if 'UnitItemInEquipmentSlot(' not in runtime or 'UnitItemInBagSlot(' not in runtime:
        raise ValueError('native Forsaken inventory missing')
    for n in names:
        with (dest/n).open('xb') as stream:stream.write((work/'release'/n).read_bytes())
    print('FORSAKEN TEST MAP:',dest/name)

if __name__=='__main__':main()

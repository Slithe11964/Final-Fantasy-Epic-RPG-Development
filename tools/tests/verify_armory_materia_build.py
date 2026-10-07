"""Stage AM preservation audit against AL, including the append-only armory bitmap extension."""
import hashlib
import copy
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT, fingerprint
from mpq import MPQ
from objdata import read_objects,fields
from editor_layout import paired_text
from wct import read_wct,text_of
from wtg import read_wtg
from jtok import functions,tokens
from check_armory import check
from check_save_compat import MATERIA_EXTENSION


def main():
    paths=[ROOT/'release/FFERPG_0.9.7.3-r16-stageAL.w3x',
           ROOT/'release/FFERPG_0.9.7.3-r16-stageAM.w3x',
           ROOT/'release/1.29.2/FFERPG_0.9.7.3-r16-stageAM.w3x']
    old,new,classic=[MPQ(str(p)) for p in paths]
    names=set(old.read('(listfile)').decode().splitlines())|set(new.read('(listfile)').decode().splitlines())
    changed=sorted(n for n in names if old.read(n)!=new.read(n))
    assert set(changed)<={'war3map.j','war3map.wct','war3map.w3u'},changed
    before=read_objects(old.read('war3map.w3u'),'w3u')
    after=read_objects(new.read('war3map.w3u'),'w3u')
    assert before['original']==after['original']
    def ordered(obj):
        obj=copy.deepcopy(obj)
        for group in obj['sets']:
            group['mods'].sort(key=lambda m:json.dumps(m,sort_keys=True))
        return obj
    assert [ordered(o) for o in before['custom']]==[ordered(o) for o in after['custom'][:len(before['custom'])]]
    added=after['custom'][len(before['custom']):]
    assert {o['id'] for o in added}=={'mCat','m071','m100','m103','m150','z071','z100','z103','z150'}
    assert not check(paths[1]) and not check(paths[2])
    category=fields(next(o for o in added if o['id']=='mCat'))
    assert (category['umpm'],category['ubpx'],category['ubpy'],category['ulev'])==(8,1,2,2)
    def modules(archive):
        return {name:text_of(value) for name,value in paired_text(read_wtg(archive.read('war3map.wtg')),read_wct(archive.read('war3map.wct'))).items()}
    prior,current=modules(old),modules(new)
    allowed={
        'Armory':{'Armory_InitHints','Armory_InCategory','Trig_Armory_Init_Actions','Trig_Armory_Store_Item_Conditions'},
        'Cmd':{'Trig_Cmd_Load_Code_LoadArmory'},'Save':{'Save_EncodeUnitFlags'}}
    additions={'Armory':{'Armory_IsStorableMateria'},'Cmd':{'Trig_Cmd_Load_Code_ArmoryFlagIndex'},'Save':set()}
    assert prior.keys()==current.keys()
    for name in prior:
        if name not in allowed:
            assert prior[name]==current[name],name
            continue
        a,b=functions(prior[name]),functions(current[name])
        assert set(b)-set(a)==additions[name]
        assert set(a)<=set(b)
        different={f for f in a if tokens(a[f])!=tokens(b[f])}
        assert different==allowed[name],(name,different)
    approval=json.loads(MATERIA_EXTENSION.read_text())
    contract=json.loads((ROOT/'tools/contracts/save-compatibility.json').read_text())
    for module,name in [('Cmd','Trig_Cmd_Load_Code_LoadArmory'),('Save','Save_EncodeUnitFlags')]:
        body=functions(current[module])[name]
        restored=body.replace('i>udg_SaveFlagCount+4','i>udg_SaveFlagCount').replace('[Trig_Cmd_Load_Code_ArmoryFlagIndex(i)]','[i]')
        assert fingerprint(restored)==contract['serializers'][name]
        assert fingerprint(body)==approval['serializers'][name]['extended']
    old_runtime,new_runtime,legacy=[functions(a.read('war3map.j').decode()) for a in [old,new,classic]]
    allowed_runtime=set().union(*(set(functions(current[m])) for m in allowed))
    changed_functions=[f for f in old_runtime if tokens(old_runtime[f])!=tokens(new_runtime[f])]
    assert set(changed_functions)<=allowed_runtime
    assert set(old_runtime)<=set(new_runtime)
    for module in allowed:
        for name,body in functions(current[module]).items():
            if name.startswith('InitTrig_'):
                continue
            assert tokens(new_runtime[name])==tokens(legacy[name]),name
    report={'changed_assets':changed,'added_units':[o['id'] for o in added],
            'changed_runtime_functions':changed_functions,
            'existing_objects_items_rewards_and_other_modules_unchanged':True,
            'legacy_bitmap_order_preserved_with_four_materia_appended':True,
            'hashes':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    (ROOT/'release/preservation-r16-stageAM.json').write_text(json.dumps(report,indent=2)+'\n')
    print('PASS AM preservation: nine new stock units only; original objects/items/rewards and other modules unchanged; legacy bitmap order preserved.')


if __name__=='__main__':
    main()

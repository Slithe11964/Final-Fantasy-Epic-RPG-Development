"""Audit Stage AN: append-only food indexes and mode predicates, no object/gameplay edits."""
import hashlib
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT, fingerprint
from mpq import MPQ
from editor_layout import paired_text
from wct import read_wct,text_of
from wtg import read_wtg
from jtok import functions,tokens
from check_save_compat import FOOD_EXTENSION, CONTRACT


def main():
    paths=[ROOT/'release/FFERPG_0.9.7.3-r16-stageAM.w3x',ROOT/'release/FFERPG_0.9.7.3-r16-stageAN.w3x',ROOT/'release/1.29.2/FFERPG_0.9.7.3-r16-stageAN.w3x']
    old,new,classic=[MPQ(str(p)) for p in paths]
    names=set(old.read('(listfile)').decode().splitlines())|set(new.read('(listfile)').decode().splitlines())
    changed=sorted(n for n in names if old.read(n)!=new.read(n))
    assert set(changed)<={'war3map.j','war3map.wct'},changed
    def modules(a):
        return {k:text_of(v) for k,v in paired_text(read_wtg(a.read('war3map.wtg')),read_wct(a.read('war3map.wct'))).items()}
    a,b=modules(old),modules(new)
    assert a.keys()==b.keys()
    expected={'Armory':{'Trig_Armory_Item_List_Actions'},'Save':{'Save_EncodeInventory'},'Cmd':{'Trig_Cmd_Load_Code_LoadInventory'}}
    extra={'Cmd':{'Trig_Cmd_Load_Code_IsChocoboFood','Trig_Cmd_Load_Code_ItemAllowed'}}
    for module in a:
        if module not in expected:
            assert a[module]==b[module],module
            continue
        x,y=functions(a[module]),functions(b[module])
        assert set(y)-set(x)==extra.get(module,set())
        assert set(x)<=set(y)
        assert {f for f in x if tokens(x[f])!=tokens(y[f])}==expected[module]
    approval=json.loads(FOOD_EXTENSION.read_text())
    original=json.loads(CONTRACT.read_text())
    old_armory=functions(a['Armory'])['Trig_Armory_Item_List_Actions']
    restored=functions(b['Armory'])['Trig_Armory_Item_List_Actions'].replace('set udg_SaveFlagCount=358','set udg_SaveFlagCount=351')
    for index,raw in approval['items'].items():
        import re
        restored=re.sub(r"^    set udg_ItemIdTable\["+index+r"\]='"+raw+r"'.*\n",'',restored,flags=re.M)
    assert tokens(old_armory)==tokens(restored)
    for module,name in [('Save','Save_EncodeInventory'),('Cmd','Trig_Cmd_Load_Code_LoadInventory')]:
        body=functions(b[module])[name]
        restored=body.replace(' and Trig_Cmd_Load_Code_ItemAllowed(GetItemTypeId(l_itm))','').replace(' and Trig_Cmd_Load_Code_ItemAllowed(udg_ItemIdTable[l_itemIndex]) then','then')
        assert fingerprint(restored)==original['serializers'][name]
        assert fingerprint(body)==approval['serializers'][name]['extended']
    prior,current,legacy=[functions(x.read('war3map.j').decode()) for x in [old,new,classic]]
    allowed=set().union(*(set(functions(b[m])) for m in expected))
    different=[f for f in prior if tokens(prior[f])!=tokens(current[f])]
    assert set(different)<=allowed
    assert set(prior)<=set(current)
    for module in expected:
        for name in functions(b[module]):
            assert tokens(current[name])==tokens(legacy[name]),name
    report={'changed_assets':changed,'changed_runtime_functions':different,'seven_food_indexes_appended':approval['items'],
            'all_objects_rewards_other_modules_unchanged':True,'existing_inventory_and_armory_mapping_preserved':True,
            'hashes':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    (ROOT/'release/preservation-r16-stageAN.json').write_text(json.dumps(report,indent=2)+'\n')
    print('PASS AN preservation: script/editor changes only; seven appended food IDs and Speedrun predicates; objects/rewards/other modules unchanged.')


if __name__=='__main__':
    main()

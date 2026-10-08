"""Audit every experimental armory variant against its unchanged AS definition."""
import argparse
import json
from pathlib import Path
import re

import build_forsaken as build
from mpq import MPQ
from objdata import fields, read_objects


def objects(archive, extension):
    table=read_objects(archive.read('war3map.'+extension),extension)
    return {o['id'] or o['base']:fields(o) for group in ('original','custom') for o in table[group]}


def audit(base, modern, mapping, output):
    before,after=MPQ(base),MPQ(modern)
    originals,items=objects(before,'w3t'),objects(after,'w3t')
    old_abilities,new_abilities=objects(before,'w3a'),objects(after,'w3a')
    passive=build.bag_passive_types(base)
    residual={raw:int(value) for raw,value in re.findall(r"41,'(.{4})',(\d+)\)",'\n'.join(build.item_accuracy_initialization(base,mapping)))}
    report=['# Forsaken BR gear audit','',
        '276 equipment entries checked against Stage AS; four Materia remain outside the native equipment conversion.',
        'Every original equipment ability definition and its numeric fields match AS. Every native variant retains the original abilities, cooldown group, charges and level/mastery requirements, adding only native slot/class metadata and the zero-stat storage marker. Original items remain available for Gaya.',
        '',
        'Automated storage-cycle tests cover all 276 entries: passive bonuses detach in storage, active abilities survive, and the original passives restore when equipped. These are source/object and mocked lifecycle checks, not 276 in-game damage or equip trials. Native acceptance is still required.',
        '',
        'Accuracy residual means a tooltip bonus missing from the original combat formula. Existing lance/Glasses/Strange Vision accuracy markers are not added again. Gun Critical Chance shows the weapon\'s base proc chance; the original elapsed-time/proficiency crit buildup still applies in combat. Ammunition flat damage includes current proficiency. Rock/Piercing Shot adds armor-piercing damage, not an armor-rating debuff. Bag of Tricks adds 20 percentage points to the ordinary item-drop roll. Magic Gloves activates at full HP; Leather/Steel Gorget and Armguard activate at or below 30% HP.',
        '',
        '| Item | Slot | Requirement | Accuracy residual | Stored passive IDs | Active / other IDs |',
        '|---|---|---|---|---|---|']
    count=0
    for raw,entry in mapping.items():
        if 'variant' not in entry:continue
        original=originals[raw]
        for ability in original.get('iabi','').split(','):
            if ability in old_abilities:
                assert new_abilities[ability]==old_abilities[ability],(entry['name'],ability)
        for variant in [entry['variant']]+([entry['offhand']] if 'offhand' in entry else []):
            expected=dict(original)
            expected.update(utub=build.slot_tooltip(original.get('utub',''),entry['slot']),
                iequ='Offhand' if variant==entry.get('offhand') else entry['slot'],icla='Equipment',
                iabi=original.get('iabi','')+',fGmk')
            assert items[variant]==expected,(entry['name'],variant)
        abilities=set(original.get('iabi','').split(','))
        requirement=original.get('ihtp','Inherited')
        if requirement==145:requirement='Legendary mastery'
        report.append('| '+ ' | '.join([entry['name'],entry['slot'],str(requirement),str(residual.get(raw,0)),
            ', '.join(sorted(abilities & passive)) or '—',', '.join(sorted(abilities-passive)) or '—'])+' |')
        count+=1
    assert count==276,count
    marker=new_abilities['fGmk']
    assert all(marker[(field,1)]==0 for field in ('Iagi','Iint','Istr'))
    output.write_text('\n'.join(report)+'\n',encoding='utf-8')
    print('PASS all 276 gear variants and original ability values; wrote',output)


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map',type=Path,required=True)
    parser.add_argument('--mapping',type=Path,required=True)
    parser.add_argument('--output',type=Path,default=build.ROOT/'docs/FORSAKEN_GEAR_AUDIT.md')
    args=parser.parse_args()
    audit(build.ROOT/'release/FFERPG_0.9.7.3-r16-stageAS.w3x',args.map,
          json.loads(args.mapping.read_text()),args.output)

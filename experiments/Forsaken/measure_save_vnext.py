"""Reproducible synthetic codec sizes. Not measured Warcraft transport capacity."""
import json
from pathlib import Path
import migrate_save as migration
import save_progression as progression
import save_vnext as codec


def profiles():
    records=[]
    for holder,count in codec.HOLDERS.items():
        for slot in range(count):
            records.append((len(records)+1,1000+len(records),holder,slot,120,True,
                            ((1,True,codec.life_words(145.25)),(2,False,codec.uint(5)))))
    inventory=codec.Section(1,1,True,codec.inventory(records))
    jobs=codec.Section(2,1,True,codec.pairs([(i,100) for i in range(1,43)]))
    extension=codec.Section(3,1,False,codec.pairs([(10000+i,1) for i in range(50)]))
    examples=[('full-57-inventory', (inventory,)),
              ('full-57-plus-42-jobs-and-50-dormant-records', (inventory,jobs,extension))]
    remaining=codec.MAX_OPAQUE-len(extension.payload)
    examples.append(('same-plus-full-opaque-budget',
                     (inventory,jobs,extension,codec.Section(99,1,False,'A'*remaining))))
    report=[]
    for name,sections in examples:
        envelope=codec.Envelope(1048575,sections)
        text=codec.encode(envelope)
        assert codec.decode(text,1048575)==envelope
        report.append(dict(name=name,encoded_characters=len(text),
            section_payload_characters=sum(len(s.payload) for s in sections),
            inventory_records=57,section_count=len(sections)))
    here = Path(__file__).resolve().parent
    titles = sorted((set(range(15, 35)) - {19}) | set(range(39, 44)) | {49, 50, 51, 53, 54, 55, 59})
    armory = json.loads((here/'legacy-layouts.json').read_text())['armory_order']
    core = {name: maximum for name, maximum in progression.CORE.values()}
    core.update(difficulty=3, gold=999999, shards=500, cheater_flag=0)
    gaya = {name: maximum for name, maximum in progression.GAYA.values()}
    gaya['level'] = 99
    logical = (inventory, jobs, extension,
               codec.Section(4, 1, True, progression.scalars(core, progression.CORE)),
               codec.Section(5, 1, True, progression.scalars(gaya, progression.GAYA)),
               codec.Section(6, 1, True, codec.pairs([(i, 10) for i in range(1, 16)])),
               codec.Section(7, 1, True, codec.pairs([(i, 1) for i in titles])),
               codec.Section(8, 1, True, codec.pairs([(i, 1) for i in sorted(armory)])))
    logical_report = []
    for name, sections in [('full-logical-profile', logical),
                           ('full-logical-plus-full-opaque-budget', logical + (examples[-1][1][-1],))]:
        envelope = codec.Envelope(1048575, sections)
        decoded = codec.decode(codec.encode(envelope))
        state = progression.snapshot(decoded)
        assert decoded == envelope
        logical_report.append(dict(name=name, encoded_characters=len(codec.encode(envelope)),
            inventory_records=len(state['inventory']), job_records=len(state['jobs']),
            title_records=len(state['titles']), armory_records=len(state['armory']),
            dormant_records=50, section_count=len(sections)))
    migration_report = []
    for case in json.loads((here/'legacy-fixtures.json').read_text())['cases']:
        envelope = migration.translate(case['code'])
        comparison = migration.comparison(envelope)
        assert comparison['equal']
        migration_report.append(dict(name=case['name'], legacy_characters=len(case['code']),
            encoded_characters=comparison['encoded_characters'],
            compared_fields=len(comparison['checks'])))
    return dict(provenance='Synthetic reference codec sizes. Original profiles exclude full progression; '
                          'logical profiles include core/Gaya/upgrades/titles/Armory. All exclude '
                          'transport framing and native overhead. No Warcraft capacity claim.',
                profiles=report, logical_profiles=logical_report, migration_profiles=migration_report)


if __name__=='__main__':
    print(json.dumps(profiles(),indent=2))

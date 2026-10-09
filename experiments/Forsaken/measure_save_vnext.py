"""Reproducible synthetic codec sizes. Not measured Warcraft transport capacity."""
import json
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
    return dict(provenance='Synthetic reference codec sizes; excludes full progression, Armory, '
                          'transport framing and native overhead. No Warcraft capacity claim.',
                profiles=report)


if __name__=='__main__':
    print(json.dumps(profiles(),indent=2))

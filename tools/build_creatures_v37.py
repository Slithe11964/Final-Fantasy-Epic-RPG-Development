"""Build the V37 creature balance map from the validated V36 development map."""
from build_f1030_inventory_rollback import *
from creature_runtime37 import refresh
from creature_objects37 import objects
from test_map_identity import info_labels

BASE = ROOT/'release/build-inputs/FFERPG-V36.w3x'
OUT = ROOT/'release/development/V37/FFERPG-V37.w3x'

def build():
    assert not OUT.exists()
    v = view(str(BASE))
    label = 'FFERPG V37'
    def labels(text):
        return text.replace('FFERPG V36', label).replace('V36 F/G:', 'V37 F/G:')
    changed = {}
    for lib, text in v.modules.items():
        result = refresh(text)
        if result != text:
            changed[lib] = result
    rt = labels(refresh(v.runtime))
    units, abilities = objects(v)
    files = {}
    for ext, replacements in [('w3u', units), ('w3a', abilities)]:
        added = set(replacements)
        for prefix in ['war3map', 'war3mapSkin']:
            name = prefix+'.'+ext
            raw = v.archive.read(name)
            if not raw:
                continue
            table = read_objects(raw, ext)
            for key in ['original','custom']:
                if prefix=='war3map':
                    rows = []
                    for obj in table[key]:
                        code = obj['id'] or obj['base']
                        rows.append(replacements.get(code,obj))
                        added.discard(code)
                    table[key] = rows
                else:
                    table[key] = [obj for obj in table[key] if (obj['id'] or obj['base']) not in replacements]
            if prefix=='war3map':
                table['custom'].extend(replacements[code] for code in sorted(added))
            packed = write_objects(table,table['version'],ext)
            if packed!=raw:
                files[name]=packed
    for index, raw in enumerate(v.wct['entries']):
        old=text_of(raw).replace('\r\n','\n')
        match=re.match(r'\s*library (\w+)\b',old)
        new=labels(changed.get(match[1],old) if match else old)
        if new!=old:
            v.wct['entries'][index]=raw_of(new.replace('\n','\r\n'))
    if v.wct.get('header'):
        old=text_of(v.wct['header']).replace('\r\n','\n')
        new=labels(old)
        if new!=old:
            v.wct['header']=raw_of(new.replace('\n','\r\n'))
    strings={key:labels(value) for key,value in v.strings.items()}
    strings[38788]=strings[4]=label
    files.update({'war3map.j':rt.replace('\n','\r\n').encode(), 'war3map.wct':write_wct(v.wct),
                  'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(v.archive.read('war3map.w3i'),label)})
    OUT.parent.mkdir(parents=True,exist_ok=True)
    tmp=OUT.with_suffix('.unpacked.w3x')
    write_files(str(BASE),str(tmp),files)
    compact(str(tmp),str(OUT))
    _,flags,players=read_header(str(BASE))
    data=OUT.read_bytes()
    OUT.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    final=MPQ(str(OUT))
    for name in v.archive.read('(listfile)').decode().splitlines():
        if name.lower() not in ['(listfile)','(attributes)','(signature)']:
            assert final.read(name)==files.get(name,v.archive.read(name)),name
    OUT.with_suffix('.j').write_text(rt)
    OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),
        sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(), changed_libraries=sorted(changed),
        changed_units=sorted(units),changed_abilities=sorted(abilities)),indent=2))
    print(OUT,flush=True)

if __name__=='__main__':
    build()

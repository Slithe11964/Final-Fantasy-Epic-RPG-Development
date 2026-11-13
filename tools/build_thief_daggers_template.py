"""Prepare prototype 02 outside Maps using the confirmed-working native container."""
from pathlib import Path
import copy,hashlib,json,re,struct,sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from build_thief_daggers import BASE,HERE,ROOT,object_data,editor_files
from mpq import MPQ,write_files,compact
from objdata import read_objects,write_objects
from downgrade import wts_read,wts_write
from expand_map import read_w3e
from jtok import functions,tokens
from add_header import read_header,build_header

OUT=ROOT/'release/development/ThiefDaggers05/FFERPG-Thief-Daggers-05.w3x'
NAME='Thief - Dagger Rip Prototype 05'

def patch_objects(base,name,extension,objects):
    table=read_objects(base.read(name),extension)
    replacements={o['id']:o for o in objects}
    table['custom']=[copy.deepcopy(replacements.pop(o['id'])) if o['id'] in replacements else o for o in table['custom']]
    table['custom'].extend(copy.deepcopy(list(replacements.values())))
    return write_objects(table,table['version'],extension)

def arena_terrain(data):
    head,width,height,ox,oy=read_w3e(data)
    # Keep native v12 dimensions/tileset/world origin. Flatten only the test arena.
    count=struct.unpack_from('<I',data,13)[0]
    palette=[data[17+i*4:21+i*4] for i in range(count)]
    tile=next((palette.index(name) for name in [b'Lgrs',b'Vgrs',b'Adrd'] if name in palette),0)
    result=bytearray(data)
    point=struct.pack('<HHHBB',8192,8192,tile,0,0xF2)
    for row in range(height):
        for col in range(width):
            if abs(ox+128*col)<=1536 and abs(oy+128*row)<=1536:
                offset=head+8*(row*width+col);result[offset:offset+8]=point
    assert result[:head]==data[:head]
    return bytes(result)

def build():
    assert not OUT.exists(),'Never overwrite a candidate already reviewed.'
    base=MPQ(str(BASE));baseline_hash=hashlib.sha256(BASE.read_bytes()).hexdigest()
    source=(HERE/'ThiefDaggers.j').read_text();old_functions=functions(base.read('war3map.j').decode())
    source=source.replace(functions(source)['config'],old_functions['config'])
    for name in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities']:
        source=source.replace('function config takes',old_functions[name]+'\n\nfunction config takes',1)
    source=source.replace('DAGGER RIP PROTOTYPE','DAGGER RIP PROTOTYPE 05')
    files={'war3map.j':source.replace('\n','\r\n').encode()}
    # Native map-info file, slot definitions, preview and archive resources stay intact.
    # Change only existing WTS display strings used by the working metadata/config.
    strings=wts_read(base.read('war3map.wts'))
    strings[38788]=NAME
    strings[38790]='Standalone Thief/scarecrow test. R arms/rips attack-stacked daggers; Q/W/E change visuals; T resets.'
    strings[38789]='1 tester'
    files['war3map.wts']=wts_write(strings)
    data,thief,abilities=object_data(base)
    units=read_objects(data['war3map.w3u'],'w3u')['custom']
    files['war3map.w3u']=patch_objects(base,'war3map.w3u','w3u',units)
    files['war3map.w3a']=patch_objects(base,'war3map.w3a','w3a',abilities)
    skin=read_objects(base.read('war3mapSkin.w3u'),'w3u')
    skin['custom']=[o for o in skin['custom'] if o['id'] not in {'H00B','u01M'}]
    files['war3mapSkin.w3u']=write_objects(skin,skin['version'],'w3u')
    files['war3map.w3e']=arena_terrain(base.read('war3map.w3e'))
    pathing=base.read('war3map.wpm');files['war3map.wpm']=pathing[:16]+bytes(len(pathing)-16)
    files['war3map.shd']=bytes(len(base.read('war3map.shd')))
    files['war3map.doo']=base.read('war3map.doo')[:12]+struct.pack('<iii',0,0,0)
    files['war3mapUnits.doo']=base.read('war3mapUnits.doo')[:12]+struct.pack('<i',0)
    files['ThiefDaggers\\BloodiedBlade-StillSilent.mdx']=(HERE/'assets/BloodiedBlade-StillSilent.mdx').read_bytes()
    files.update(editor_files(source))
    OUT.parent.mkdir(parents=True,exist_ok=True);tmp=OUT.with_suffix('.unpacked.w3x')
    write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));tmp.unlink()
    _,flags,players=read_header(str(BASE));raw=OUT.read_bytes()
    OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
    check=MPQ(str(OUT))
    for name,value in files.items():assert check.read(name)==value,name
    for name in ['war3map.w3i','war3mapMap.blp','war3mapPreview.tga','war3map.imp']:
        assert check.read(name)==base.read(name),name
    compiled=functions(check.read('war3map.j').decode())
    for name in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities','config']:
        assert tokens(compiled[name])==tokens(old_functions[name]),name
    assert hashlib.sha256(BASE.read_bytes()).hexdigest()==baseline_hash
    report=dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),bytes=OUT.stat().st_size,
        native_metadata='W3I, minimap, preview, import table and player configuration identical to working QuickUI11',
        actors=['Thief','Scarecrow'],installed=False,live_test='pending; keep outside Maps until controlled browser test',
        changes='native container retained; flat test patch; empty placements; prototype script and abilities')
    (OUT.parent/'checks.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__=='__main__':build()

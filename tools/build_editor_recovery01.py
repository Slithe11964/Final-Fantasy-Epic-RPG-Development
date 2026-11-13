"""Separate editor-loader diagnostic: older trigger containers, identical code/content."""
from pathlib import Path
import hashlib,json
from mpq import MPQ,write_files,compact
from downgrade import triggers_classic
from wtg import read_wtg
from wct import read_wct
from editor_layout import layout_errors
from add_header import read_header,build_header

ROOT=Path(__file__).resolve().parents[1]


def build():
    source=ROOT/'editor/FFERPG-Editor-Master.w3x'
    output=ROOT/'editor/FFERPG-Editor-Recovery01.w3x'
    assert not output.exists(),'Never overwrite an authoring or recovery map.'
    before=hashlib.sha256(source.read_bytes()).hexdigest()
    archive=MPQ(str(source))
    wtg,wct=triggers_classic(archive.read('war3map.wtg'),archive.read('war3map.wct'))
    oldtree=read_wtg(archive.read('war3map.wtg'));newtree=read_wtg(wtg)
    oldtext=read_wct(archive.read('war3map.wct'));newtext=read_wct(wct)
    assert oldtext['entries']==newtext['entries'] and oldtext['header']==newtext['header']
    assert not layout_errors(newtree,newtext)
    for key in ('name','type','unk','is_array','size','is_init','init'):
        assert [v[key] for v in oldtree['variables']]==[v[key] for v in newtree['variables']]
    oldtr=[t for t in oldtree['items'] if t['kind'] in (8,16,32)]
    newtr=[t for t in newtree['items'] if t['kind'] in (8,16,32)]
    for key in ('name','desc','enabled','custom','initially_off','run_on_init','functions'):
        assert [v[key] for v in oldtr]==[v[key] for v in newtr],key
    private=ROOT/'build/editor-recovery01.unpacked.w3x'
    assert not private.exists()
    files={'war3map.wtg':wtg,'war3map.wct':wct}
    write_files(str(source),str(private),files)
    compact(str(private),str(output))
    # Retain the private candidate too; do not remove or replace the master.
    _,flags,players=read_header(str(ROOT/'release/0.9.7.5e/FFERPG-0.9.7.5e-Forsaken.w3x'))
    data=output.read_bytes()
    output.write_bytes(build_header('FFERPG Editor Recovery01',flags,players)+data[data.index(b'MPQ\x1a'):])
    checked=MPQ(str(output))
    for name in archive.read('(listfile)').decode('utf-8').splitlines():
        if name.lower() in ('(listfile)','(attributes)','(signature)'):continue
        assert checked.read(name)==files.get(name,archive.read(name)),name
    assert hashlib.sha256(source.read_bytes()).hexdigest()==before
    report=dict(source=str(source),source_sha256=before,output=str(output),
        output_sha256=hashlib.sha256(output.read_bytes()).hexdigest(),
        trigger_count=len(oldtr),variable_count=len(oldtree['variables']),
        changed=['WTG version7 / WCT version1 containers','map-list header'],
        preserved='All trigger code, states and variables; runtime, objects, terrain, units, doodads, scenario, imports and other named resources byte-identical.',
        acceptance='Opening in World Editor is unverified. Diagnostic recovery copy; master unchanged.')
    output.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(json.dumps(report,indent=2))


if __name__=='__main__':build()

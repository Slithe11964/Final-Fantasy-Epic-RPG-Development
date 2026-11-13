"""Label the eight current tests, preserving exact pre-label copies."""
from pathlib import Path
import hashlib,json,re,shutil
from mpq import MPQ,write_files,compact
from downgrade import wts_read,wts_write
from wct import read_wct,text_of,raw_of,write_wct
from add_header import read_header,build_header
from test_map_identity import script_labels,without_literals,info_labels

ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST')
OUT=ROOT/'release/development/TestMapLabels20261110'
# File identity, release directory, visible identity, diagnostic identity, purpose.
SPECS=[
 ('FFERPG-0.9.7.5g-Recovery14.w3x','GRecovery14','FFERPG 0.9.7.5g Recovery14','Recovery14','Regular gear controls; hotkeys work, buttons reported invisible.'),
 ('FFERPG-0.9.7.5g-Recovery15.w3x','GRecovery15','FFERPG 0.9.7.5g Recovery15','Recovery15','Gear-button display-parent test.'),
 ('FFERPG-0.9.7.5g-NoFG-Test.w3x','GRecovery14','FFERPG 0.9.7.5g No F-G Test','NoFG Test','Diagnostic: gear hotkey buttons and activation disabled.'),
 ('FFERPG-V25.w3x','V25','FFERPG V25 - Gear Frontend','V25','Full development: regular gear controls.'),
 ('FFERPG-V26.w3x','V26','FFERPG V26 - Gear Display','V26','Full development: gear-button display-parent test.'),
 ('FFERPG-Inventory-Multiplayer-Check-03.w3x','InventoryMultiplayerCheck03','FFERPG Native Inventory Check03','Native Check03','Standalone native backpack test; shared vision off by default. No save codes.'),
 ('FFERPG-Independent-Backpack-04.w3x','InventoryPanel04','FFERPG Independent Backpack04','Backpack04','Standalone replacement-panel prototype. No RPG talents, item casting or save codes.'),
 ('FFERPG-Creature-Review-03s.w3x','CreatureReview03s','FFERPG Creature Review03s','Creature Review03s','Creature and boss review; select a unit and type -info or -spells.'),
]

def build_one(spec):
    name,folder,label,short,purpose=spec
    found=list(TEST.rglob(name));assert len(found)==1,(name,found)
    installed=found[0];release=ROOT/'release/development'/folder/name
    assert installed.read_bytes()==release.read_bytes(),('Installed map differs; preserve user edits',installed)
    out=OUT/name;assert not out.exists()
    m=MPQ(str(installed));original=m.read('war3map.j').decode().replace('\r\n','\n')
    runtime=script_labels(original,label,short)
    assert without_literals(original)==without_literals(runtime),'Non-display script changed'
    wct=read_wct(m.read('war3map.wct'))
    for part in ['header']:
        if wct.get(part):
            old=text_of(wct[part]);new=script_labels(old,label,short)
            assert without_literals(old)==without_literals(new)
            if new!=old:wct[part]=raw_of(new)
    for i,raw in enumerate(wct['entries']):
        old=text_of(raw);new=script_labels(old,label,short)
        assert without_literals(old)==without_literals(new)
        if new!=old:wct['entries'][i]=raw_of(new)
    strings=wts_read(m.read('war3map.wts'));strings[38788]=label
    # Keep the author's description and Discord link exactly as supplied.
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),
           'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(m.read('war3map.w3i'),label,purpose)}
    tmp=out.with_suffix('.unpacked.w3x');write_files(str(installed),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(installed));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for n in m.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:
            assert checked.read(n)==files.get(n,m.read(n)),n
    assert wts_read(checked.read('war3map.wts'))[38788]==label
    assert read_header(str(out))[0]==label
    assert not re.search(r'Welcome to Final Fantasy Epic RPG 0\.9|udg_BoardTitlePrefix\s*=\s*"Final Fantasy Epic RPG 0\.9|UI\d+ F/G:',runtime)
    out.with_suffix('.j').write_text(runtime)
    return dict(name=name,label=label,purpose=purpose,source=str(installed),release=str(release),output=str(out),before_sha256=hashlib.sha256(installed.read_bytes()).hexdigest(),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),scope='Display strings/map metadata only; all non-string script tokens and all unrelated archive payloads exact')

def build():
    assert not OUT.exists();OUT.mkdir(parents=True)
    records=[]
    for spec in SPECS:
        record=build_one(spec);records.append(record)
        (OUT/'manifest.json').write_text(json.dumps(records,indent=2));print(record['name'],record['label'],flush=True)

if __name__=='__main__':build()

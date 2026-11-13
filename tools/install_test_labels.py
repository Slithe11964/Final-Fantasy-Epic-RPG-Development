"""Back up and replace display-only labels in current installed/release copies."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'release/development/TestMapLabels20261110'
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
records=json.loads((OUT/'manifest.json').read_text())
assert len(records)==8
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for rec in records:
    for field in ['source','release']:
        p=Path(rec[field]);assert digest(p) in [rec['before_sha256'],rec['sha256']],p
    assert Path(rec['source']).resolve().is_relative_to(TEST)
    assert Path(rec['release']).resolve().is_relative_to(ROOT)
    assert digest(Path(rec['output']))==rec['sha256']
history=OUT/'before-labels';history.mkdir(exist_ok=True)
for rec in records:
    installed=Path(rec['source']);release=Path(rec['release']);new=Path(rec['output'])
    for kind,p in [('installed',installed),('release',release)]:
        dest=history/kind/p.name;dest.parent.mkdir(exist_ok=True)
        if dest.exists():assert digest(dest)==rec['before_sha256'],dest
        else:
            assert digest(p)==rec['before_sha256'],p
            shutil.copy2(p,dest)
    # Preserve sidecars too; their original hashes remain useful audit evidence.
    for suffix in ['.j','.json']:
        p=release.with_suffix(suffix)
        backup=history/'release'/p.name
        if p.exists() and not backup.exists():shutil.copy2(p,backup)
    try:
        if digest(installed)!=rec['sha256']:shutil.copy2(new,installed)
    except PermissionError:
        # Do not stop Warcraft or overwrite a map held by an active session.
        alternate=installed.with_name(installed.stem+'-Labeled'+installed.suffix)
        assert not alternate.exists() or digest(alternate)==rec['sha256'],alternate
        if not alternate.exists():shutil.copy2(new,alternate)
        rec['locked_original']=str(installed)
        rec['installed_actual']=str(alternate)
        installed=alternate
    shutil.copy2(new,release)
    shutil.copy2(new.with_suffix('.j'),release.with_suffix('.j'))
    meta=release.with_suffix('.json')
    if meta.exists():
        data=json.loads(meta.read_text());data['sha256']=rec['sha256'];data['display_identity']=rec['label'];data['label_update']='2026-11-10; display strings only; TestMapLabels20261110/manifest.json';meta.write_text(json.dumps(data,indent=2))
    assert digest(installed)==digest(release)==rec['sha256']
    print(str(installed),flush=True)
(OUT/'installed.json').write_text(json.dumps(records,indent=2))

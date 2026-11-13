"""Install only the requested text correction, retaining exact backups."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'release/development/DescriptionRestore20261110'
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
records=json.loads((OUT/'manifest.json').read_text());assert len(records)==14
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
history=OUT/'before-restoration';history.mkdir(exist_ok=True)
pending=[]
for rec in records:
    base=Path(rec['base']);new=Path(rec['output']);assert digest(base) in [rec['before_sha256'],rec['sha256']],base
    locations=list(TEST.rglob(base.name))+list(TEST.rglob(base.stem+'-Labeled.w3x'))
    rec['installed']=[]
    for target in locations+[base]:
        assert target.resolve().is_relative_to(TEST if target in locations else ROOT)
        assert digest(target) in [rec['before_sha256'],rec['sha256']],target
        relative=target.resolve().relative_to(TEST if target in locations else ROOT)
        backup=history/('installed' if target in locations else 'workspace')/relative
        backup.parent.mkdir(parents=True,exist_ok=True)
        if not backup.exists():shutil.copy2(target,backup)
        try:
            if digest(target)!=rec['sha256']:shutil.copy2(new,target)
        except PermissionError:
            pending.append(str(target));continue
        assert digest(target)==rec['sha256']
        if target in locations:rec['installed'].append(str(target));print(target,flush=True)
    # Sidecars reflect the corrected canonical archive, with originals retained.
    if digest(base)==rec['sha256']:
        for suffix in ['.j','.json']:
            target=base.with_suffix(suffix);backup=history/'workspace'/target.relative_to(ROOT)
            if target.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(target,backup)
            if suffix=='.j':shutil.copy2(new.with_suffix('.j'),target)
            elif target.exists():
                data=json.loads(target.read_text());data.update(sha256=rec['sha256'],display_identity=rec['label'],description_restored='Exact dated-f author description and loading text; 2026-11-10');target.write_text(json.dumps(data,indent=2))
(OUT/'installed.json').write_text(json.dumps(dict(maps=records,pending_locked=pending),indent=2))
print('Locked pending:',pending)

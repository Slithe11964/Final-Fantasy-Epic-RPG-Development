"""Publish the requested h pair and V28, preserving prior canonical maps."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
STAGE=ROOT/'release/development/VersionHRightDock20261110'
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
records=json.loads((STAGE/'manifest.json').read_text());assert len(records)==3
history=STAGE/'before-promotion';assert not history.exists()
for rec in records:
    source=Path(rec['output']);dest=TEST/source.name
    assert source.is_file() and dest.resolve().is_relative_to(TEST) and not dest.exists(),dest
history.mkdir()
for rec in records:
    source=Path(rec['output']);name=source.name
    folder=ROOT/'release/development/V28' if name=='FFERPG-V28.w3x' else ROOT/'release/0.9.7.5h'
    target=folder/name;assert target.resolve().is_relative_to(ROOT)
    for suffix in ['.w3x','.j','.json','.unpacked.w3x']:
        old=target.with_suffix(suffix)
        if old.exists():
            backup=history/('V28' if name=='FFERPG-V28.w3x' else 'production')/old.name
            backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(old,backup)
        fresh=source.with_suffix(suffix)
        if fresh.exists():shutil.copy2(fresh,old)
    installed=TEST/name;shutil.copy2(source,installed)
    digest=hashlib.sha256(source.read_bytes()).hexdigest()
    assert digest==hashlib.sha256(target.read_bytes()).hexdigest()==hashlib.sha256(installed.read_bytes()).hexdigest()
    rec.update(canonical=str(target),installed=str(installed),bytes=installed.stat().st_size)
    print(installed,flush=True)
(STAGE/'installed.json').write_text(json.dumps(records,indent=2))
(ROOT/'release/development/V28/installed.json').write_text(json.dumps(records,indent=2))

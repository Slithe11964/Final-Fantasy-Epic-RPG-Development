from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
sources=[ROOT/'release/development/H20261110UI01/FFERPG-0.9.7.5h-UI01.w3x',ROOT/'release/development/V29/FFERPG-V29.w3x']
for p in sources:assert p.is_file() and not (TEST/p.name).exists()
records=[]
for p in sources:
 dest=TEST/p.name;assert dest.resolve().is_relative_to(TEST);shutil.copy2(p,dest)
 digest=hashlib.sha256(p.read_bytes()).hexdigest();assert digest==hashlib.sha256(dest.read_bytes()).hexdigest()
 records.append(dict(source=str(p),installed=str(dest),sha256=digest,status='Diagnostic only; invisible controls unresolved'))
(ROOT/'release/development/V29/installed.json').write_text(json.dumps(records,indent=2))
for r in records:print(r['installed'])

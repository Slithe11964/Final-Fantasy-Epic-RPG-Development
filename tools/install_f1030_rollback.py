"""Install distinct rollback candidates and record reference identity."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST')
files=[
 ROOT/'release/development/GRecovery05/FFERPG-0.9.7.5g-Recovery05.w3x',
 ROOT/'release/development/GRecovery05/FFERPG-0.9.7.5g-1.29.2-Recovery05.w3x',
 ROOT/'release/development/V16/FFERPG-V16.w3x',
 ROOT/'release/development/CreatureReview03o/FFERPG-Creature-Review-03o.w3x']
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=TEST/'FFERPG-0.9.7.5f.w3x'
assert digest(ref)=='da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93'
for src in files:
 assert src.is_file()
 assert not (TEST/src.name).exists(),TEST/src.name
records=[]
for src in files:
 dst=TEST/src.name;shutil.copy2(src,dst);assert digest(src)==digest(dst)
 records.append(dict(source=str(src),installed=str(dst),bytes=dst.stat().st_size,sha256=digest(dst)))
assert digest(ref)=='da2a65c51889ac4a2efe19d17de0de98e2a19351b6c7b09d9d07fbf6eeac3d93'
(ROOT/'release/development/GRecovery05/installed.json').write_text(json.dumps(records,indent=2))
for record in records:print(record['installed'],record['sha256'])

"""Install only the new development candidates; preserve any previous TEST copy."""
from pathlib import Path
import json,hashlib,shutil
ROOT=Path(__file__).resolve().parents[1]
TEST=Path(r'C:\Users\jaked\Documents\Warcraft III\Maps\Download\TEST')
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
rows=[]
for rel in ['release/development/QuickUI99/FFERPG-QuickUI99.w3x','release/development/CreatureReview03g/FFERPG-Creature-Review-03g.w3x']:
 src=ROOT/rel;dst=TEST/src.name
 if dst.exists() and digest(dst)!=digest(src):
  backup=ROOT/'build/candidates/ancient99-test-backups'/digest(dst)/dst.name
  backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(dst,backup)
 TEST.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst);assert digest(src)==digest(dst)
 rows.append(dict(path=str(dst),bytes=dst.stat().st_size,sha256=digest(dst)))
(ROOT/'release/development/QuickUI99/TEST-installed.json').write_text(json.dumps(rows,indent=2))
print(json.dumps(rows,indent=2))

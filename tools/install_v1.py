from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
src=ROOT/'release/development/V1/FFERPG-V1.w3x'
dst=Path.home()/'Documents/Warcraft III/Maps/Download/TEST'/src.name
if dst.exists() and digest(src)!=digest(dst):
 backup=ROOT/'build/candidates/v1-test-backups'/digest(dst)/dst.name
 backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(dst,backup)
dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst);assert digest(src)==digest(dst)
record=dict(path=str(dst),bytes=dst.stat().st_size,sha256=digest(dst))
(src.parent/'TEST-installed.json').write_text(json.dumps(record,indent=2));print(json.dumps(record,indent=2))

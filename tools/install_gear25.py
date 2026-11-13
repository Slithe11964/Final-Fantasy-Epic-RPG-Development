"""Install rendering comparisons without replacing prior builds."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
files=[ROOT/'release/development/V25/FFERPG-V25.w3x',ROOT/'release/development/GRecovery14/FFERPG-0.9.7.5g-Recovery14.w3x',ROOT/'release/development/GRecovery14/FFERPG-0.9.7.5g-NoFG-Test.w3x']
records=[]
for source in files:
 dest=TEST/source.name
 assert source.is_file() and dest.resolve().is_relative_to(TEST) and not dest.exists()
for source in files:
 dest=TEST/source.name;shutil.copy2(source,dest);digest=hashlib.sha256(source.read_bytes()).hexdigest();assert digest==hashlib.sha256(dest.read_bytes()).hexdigest()
 records.append(dict(source=str(source),installed=str(dest),sha256=digest,bytes=dest.stat().st_size,status='native/multiplayer test pending'))
(ROOT/'release/development/V25/installed.json').write_text(json.dumps(records,indent=2))
for r in records:print(r['installed'],r['sha256'])

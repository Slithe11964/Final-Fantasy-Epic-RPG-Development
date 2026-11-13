"""Install distinct display-parent candidates; preserve Recovery14 and V25."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
sources=[ROOT/'release/development/GRecovery15/FFERPG-0.9.7.5g-Recovery15.w3x',ROOT/'release/development/V26/FFERPG-V26.w3x']
for source in sources:
    dest=TEST/source.name
    assert source.is_file() and dest.resolve().is_relative_to(TEST) and not dest.exists(),dest
records=[]
for source in sources:
    dest=TEST/source.name;shutil.copy2(source,dest)
    digest=hashlib.sha256(source.read_bytes()).hexdigest()
    assert digest==hashlib.sha256(dest.read_bytes()).hexdigest()
    records.append(dict(source=str(source),installed=str(dest),bytes=dest.stat().st_size,sha256=digest,status='Visibility/cooldown/native/multiplayer testing pending'))
(ROOT/'release/development/V26/installed.json').write_text(json.dumps(records,indent=2))
for r in records:print(r['installed'])

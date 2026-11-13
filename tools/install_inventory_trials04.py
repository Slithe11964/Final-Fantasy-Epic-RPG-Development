"""Install separate diagnostic/prototype maps; never replace existing maps."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
SOURCES=[ROOT/'release/development/InventoryMultiplayerCheck03/FFERPG-Inventory-Multiplayer-Check-03.w3x',ROOT/'release/development/InventoryPanel04/FFERPG-Independent-Backpack-04.w3x']
for source in SOURCES:
    dest=TEST/source.name
    assert source.is_file() and dest.resolve().is_relative_to(TEST) and not dest.exists(),dest
records=[]
for source in SOURCES:
    dest=TEST/source.name;shutil.copy2(source,dest)
    digest=hashlib.sha256(source.read_bytes()).hexdigest()
    assert digest==hashlib.sha256(dest.read_bytes()).hexdigest()
    records.append(dict(source=str(source),installed=str(dest),bytes=dest.stat().st_size,sha256=digest,status='Standalone test only; native appearance/input/multiplayer unverified'))
(ROOT/'release/development/InventoryPanel04/installed.json').write_text(json.dumps(records,indent=2))
for r in records:print(r['installed'])

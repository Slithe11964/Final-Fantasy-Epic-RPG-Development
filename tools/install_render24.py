"""Install diagnostic comparisons, never overwrite a prior map."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST').resolve()
files=[ROOT/'release/development/V24/FFERPG-V24.w3x',ROOT/'release/development/GRecovery13/FFERPG-0.9.7.5g-Recovery13.w3x',ROOT/'release/development/InventoryMultiplayerCheck02/FFERPG-Inventory-Multiplayer-Check-02.w3x']
records=[]
for source in files:
 dest=TEST/source.name
 assert source.is_file() and dest.resolve().is_relative_to(TEST) and not dest.exists()
for source in files:
 dest=TEST/source.name;shutil.copy2(source,dest)
 digest=hashlib.sha256(source.read_bytes()).hexdigest();assert digest==hashlib.sha256(dest.read_bytes()).hexdigest()
 records.append(dict(source=str(source),installed=str(dest),sha256=digest,bytes=dest.stat().st_size,status='diagnostic only; not a confirmed fix'))
(ROOT/'release/development/RenderInvestigation20261109/installed.json').write_text(json.dumps(records,indent=2))
for r in records:print(r['installed'],r['sha256'])

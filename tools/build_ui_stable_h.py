"""Production h item-event UI visibility correction."""
from pathlib import Path
import json
import build_preview68 as package
from ui_stable_h import refresh
ROOT=Path(__file__).resolve().parents[1]
BACKUP=ROOT/'release/0.9.7.5h/history/2026-11-06-before-ui-stability'
BASE=(BACKUP if BACKUP.exists() else ROOT/'release/0.9.7.5h')/'FFERPG-0.9.7.5h.w3x'
OUT=ROOT/'release/development/VersionHHotfix01/FFERPG-0.9.7.5h-Hotfix01.w3x'
if __name__=='__main__':
 package.refresh=refresh
 package.build(BASE,OUT,'FFERPG 0.9.7.5h',allowed_modules={'TEquip'})
 p=OUT.with_suffix('.json');r=json.loads(p.read_text());r.update(version='0.9.7.5h',change='Item changes clear stale targeting without hiding talents, X, inspection, carry access or F/G. Native inventory visibility requires explicit opening intent; closed frames remain hidden through the existing settle window.',acceptance='Native pickup/drop/open/closed UI and multiplayer confirmation pending.',new_polling_timers=0,gameplay='Unchanged; cinematic full clear and .2-second item-read guard retained.')
 assert set(r['changed_functions'])=={'Inventory94_ClearLocal','Inventory94_Changed','Forsaken_BackpackVisible','UI72_Tick'}
 assert r['new_functions']==['Inventory94_ClearAim']
 p.write_text(json.dumps(r,indent=2))

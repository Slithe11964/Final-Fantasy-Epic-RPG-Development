"""Package native item-preview correction without altering idle76 isolation."""
import json
from pathlib import Path
import build_preview68 as package
from preview77 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
    package.refresh=refresh;package.build(base,out,label)
    p=out.with_suffix('.json');r=json.loads(p.read_text())
    assert set(r['changed_functions'])=={'Preview75_QuickSlot','BagScreen_Click66','Wave65_Draw','QuickGear_Diagnostic'}
    r['acceptance']='Native six-slot horizontal hit-region shift based on adjacent-column report; fresh click replacement without stale move delay; Gaya runes anchored at loaded hero while actual caster selection/cast-end tracking is preserved. No new callbacks/timers/hooks or gameplay changes. Client alignment and multiplayer acceptance pending.'
    p.write_text(json.dumps(r,indent=2))

if __name__=='__main__':
    build(ROOT/'release/development/VersionFHotfix07/FFERPG-0.9.7.5f-Hotfix07.w3x',ROOT/'release/development/VersionFHotfix08/FFERPG-0.9.7.5f-Hotfix08.w3x','FFERPG 0.9.7.5f Hotfix08')
    build(ROOT/'release/development/QuickUI76/FFERPG-QuickUI76.w3x',ROOT/'release/development/QuickUI77/FFERPG-QuickUI77.w3x','FFERPG QuickUI77 (Dragoon)')

"""Separate idle isolation and quick-slot detector patches, combined for testing."""
import json
from pathlib import Path
import build_preview68 as package
from idle76 import refresh as idle
from slots76 import refresh as slots
ROOT=Path(__file__).resolve().parents[1]

def refresh(source):return slots(idle(source))

def build(base,out,label):
    package.refresh=refresh;package.build(base,out,label)
    meta=out.with_suffix('.json');r=json.loads(meta.read_text())
    r['acceptance']='Isolation candidate: shared equipped-item reference cache replaces F/G local live-slot reads; idle mouse click polling stops. Quick-slot visibility/scale comes from console, not legacy origin inventory button. No new timers or gameplay/cast receiver changes. Neither multiplayer stability nor native quick-slot click acceptance is established.'
    meta.write_text(json.dumps(r,indent=2))

if __name__=='__main__':
    build(ROOT/'release/development/VersionFHotfix06/FFERPG-0.9.7.5f-Hotfix06.w3x',ROOT/'release/development/VersionFHotfix07/FFERPG-0.9.7.5f-Hotfix07.w3x','FFERPG 0.9.7.5f Hotfix07')
    build(ROOT/'release/development/QuickUI75/FFERPG-QuickUI75.w3x',ROOT/'release/development/QuickUI76/FFERPG-QuickUI76.w3x','FFERPG QuickUI76 (Dragoon)')

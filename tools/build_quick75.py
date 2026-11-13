"""Native quick-slot previews for hero and Spirit of Gaya."""
import json
from pathlib import Path
import build_preview68 as package
from quick75 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
    package.refresh=refresh;package.build(base,out,label)
    meta=out.with_suffix('.json');r=json.loads(meta.read_text())
    r['acceptance']='Read-only six-slot click observation and caster-aware hero/Gaya wave previews. No input interception, new timers or gameplay changes. Native HUD geometry and multiplayer acceptance pending.'
    meta.write_text(json.dumps(r,indent=2))

if __name__=='__main__':
    build(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f.w3x',ROOT/'release/development/VersionFHotfix06/FFERPG-0.9.7.5f-Hotfix06.w3x','FFERPG 0.9.7.5f Hotfix06')
    build(ROOT/'release/development/QuickUI74/FFERPG-QuickUI74.w3x',ROOT/'release/development/QuickUI75/FFERPG-QuickUI75.w3x','FFERPG QuickUI75 (Dragoon)')

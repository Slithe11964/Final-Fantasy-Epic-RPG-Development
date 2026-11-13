"""Package capped, consolidated UI updates on both current branches."""
import json
from pathlib import Path
import build_preview68 as package
from ui72 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label,dragoon=False):
    package.refresh=lambda s:refresh(s,dragoon)
    package.build(base,out,label,{'TEquip','TDamage'} if dragoon else {'TEquip'})
    meta=out.with_suffix('.json');r=json.loads(meta.read_text())
    r['acceptance']='One 10Hz background UI heartbeat; change-driven icons, active-only 10Hz wave rendering and shared panel updates. Existing combat timing preserved. Native input and multiplayer acceptance pending.'
    meta.write_text(json.dumps(r,indent=2))

if __name__=='__main__':
    build(ROOT/'release/development/VersionFHotfix02/FFERPG-0.9.7.5f-Hotfix02.w3x',
        ROOT/'release/development/VersionFHotfix03/FFERPG-0.9.7.5f-Hotfix03.w3x','FFERPG 0.9.7.5f Hotfix03')
    build(ROOT/'release/development/QuickUI71/FFERPG-QuickUI71.w3x',
        ROOT/'release/development/QuickUI72/FFERPG-QuickUI72.w3x','FFERPG QuickUI72 (Dragoon)',True)

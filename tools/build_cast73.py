"""Cast-boundary isolation candidate; not a confirmed desync resolution."""
import json
from pathlib import Path
import build_preview68 as package
from cast73 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
    package.refresh=refresh;package.build(base,out,label)
    meta=out.with_suffix('.json');r=json.loads(meta.read_text())
    assert set(r['changed_functions'])=={'QuickGear_RecordSpell','UI72_Tick','QuickGear_Request','GearWave_Arm'}
    r['acceptance']='Defer local cleanup from shared spell event to existing UI heartbeat. No new timers, no gameplay/wave/cooldown changes. Multiplayer reproduction required; desync cause unproven.'
    meta.write_text(json.dumps(r,indent=2))

if __name__=='__main__':
    build(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f.w3x',
        ROOT/'release/development/VersionFHotfix04/FFERPG-0.9.7.5f-Hotfix04.w3x','FFERPG 0.9.7.5f Hotfix04')
    build(ROOT/'release/development/QuickUI72/FFERPG-QuickUI72.w3x',
        ROOT/'release/development/QuickUI73/FFERPG-QuickUI73.w3x','FFERPG QuickUI73 (Dragoon)')

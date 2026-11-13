"""Build a secondary player-leave crash guard; not an initial desync fix."""
import json
from pathlib import Path
import build_preview68 as package
from leave_guard70 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
    # Same one-module archive/editor pairing process as the preceding preview.
    package.refresh=refresh
    package.build(base,out,label)
    meta=out.with_suffix('.json');report=json.loads(meta.read_text())
    assert set(report['changed_functions'])=={
        'Forsaken_EnableHero','Forsaken_PrepareInventories','Forsaken_RebindBag'}
    report['acceptance']='Removed-hero inventory maintenance guard. Initial network desync remains unexplained; multiplayer runtime confirmation pending.'
    meta.write_text(json.dumps(report,indent=2))

if __name__=='__main__':
    build(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-Forsaken.w3x',
        ROOT/'release/development/VersionFHotfix01/FFERPG-0.9.7.5f-Hotfix01.w3x','FFERPG 0.9.7.5f Hotfix01')
    build(ROOT/'release/development/QuickUI69/FFERPG-QuickUI69-Forsaken.w3x',
        ROOT/'release/development/QuickUI70/FFERPG-QuickUI70.w3x','FFERPG QuickUI70 (Dragoon)')

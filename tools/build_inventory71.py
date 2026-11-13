"""First desync isolation candidate: stop repeated unchanged gear mutations."""
import json
from pathlib import Path
import build_preview68 as package
from inventory71 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
    package.refresh=refresh;package.build(base,out,label)
    meta=out.with_suffix('.json');r=json.loads(meta.read_text())
    assert set(r['changed_functions'])=={'Forsaken_EnableHero','Forsaken_PrepareInventories'}
    assert set(r['new_functions'])=={'Inventory71_Scan','Inventory71_Clear','Inventory71_Reconcile'}
    r['acceptance']='Desync isolation candidate: exact synchronized gear snapshot gates inventory reconciliation; unchanged gear does not mutate every second. Rune preview/input/icon code unchanged. Multiplayer acceptance required, cause not proven.'
    meta.write_text(json.dumps(r,indent=2))

if __name__=='__main__':
    build(ROOT/'release/development/VersionFHotfix01/FFERPG-0.9.7.5f-Hotfix01.w3x',
        ROOT/'release/development/VersionFHotfix02/FFERPG-0.9.7.5f-Hotfix02.w3x','FFERPG 0.9.7.5f Hotfix02')
    build(ROOT/'release/development/QuickUI70/FFERPG-QuickUI70.w3x',
        ROOT/'release/development/QuickUI71/FFERPG-QuickUI71.w3x','FFERPG QuickUI71 (Dragoon)')

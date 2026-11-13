"""Apply the minimal UI flash fix to production g and the Central Islands test."""
from pathlib import Path
import json
import build_preview68 as package
from ui_flash96 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
 package.refresh=refresh
 package.build(base,out,label,allowed_modules={'TEquip'})
 report=json.loads(out.with_suffix('.json').read_text())
 report.update(acceptance='Move/attack orders no longer clear/suspend gear UI. True gear changes and cinematic suspension retained. Carry access button has an explicit foreground level and cleared panel state is consistent. Native recording reproduction pending.',gameplay='No item/spell/stat/quest/monster/save-format changes; no new timer.',version='0.9.7.5g' if 'Hotfix' in out.name else 'QuickUI96')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2))

if __name__=='__main__':
 build(ROOT/'release/0.9.7.5g/history/2026-11-04-before-ui96/FFERPG-0.9.7.5g.w3x',ROOT/'release/development/VersionGHotfix01/FFERPG-0.9.7.5g-Hotfix01.w3x','FFERPG 0.9.7.5g')
 build(ROOT/'release/development/QuickUI95/FFERPG-QuickUI95.w3x',ROOT/'release/development/QuickUI96/FFERPG-QuickUI96.w3x','FFERPG QuickUI96 (Central Islands / UI Fix)')

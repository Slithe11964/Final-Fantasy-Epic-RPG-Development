"""Label-only production promotion of Hotfix10 to 0.9.7.5g."""
import hashlib,json
from pathlib import Path
import build_preview68 as package
from editor_pair import View
from downgrade import wts_write,wts_read
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/VersionFHotfix10/FFERPG-0.9.7.5f-Hotfix10.w3x'
OUT=ROOT/'release/0.9.7.5g/FFERPG-0.9.7.5g.w3x'

def main():
 package.refresh=lambda s:s.replace('0.9.7.5f','0.9.7.5g')
 package.wts_write=lambda entries:wts_write({k:v.replace('0.9.7.5f','0.9.7.5g') for k,v in entries.items()})
 package.build(BASE,OUT,'FFERPG 0.9.7.5g',allowed_modules={'TEquip','TIntro','TMultiboard'})
 old,new=View(BASE),View(OUT)
 assert new.runtime==old.runtime.replace('0.9.7.5f','0.9.7.5g')
 for lib,s in old.modules.items():assert new.modules[lib]==s.replace('0.9.7.5f','0.9.7.5g'),lib
 assert not any('0.9.7.5f' in v for v in wts_read(new.archive.read('war3map.wts')).values())
 report=json.loads(OUT.with_suffix('.json').read_text())
 report.update(version='0.9.7.5g',date='2026-11-04',promotion='Hotfix10, version labels only: map title, welcome, scoreboard and gear diagnostics.',gameplay='unchanged from Hotfix10',save_format='unchanged',classic_1292='Not rebuilt in this request.',acceptance='Retains Hotfix10 crash hardening; native crash reproduction and multiplayer acceptance remain pending.')
 OUT.with_suffix('.json').write_text(json.dumps(report,indent=2))
 print(json.dumps(report,indent=2))

if __name__=='__main__':main()

"""V1: QuickUI99 content plus the production autosave repair. Future tests use V2,V3..."""
import build_preview68 as package
from autosave100 import refresh
ROOT=package.ROOT
BASE=ROOT/'release/development/QuickUI99/FFERPG-QuickUI99.w3x'
OUT=ROOT/'release/development/V1/FFERPG-V1.w3x'
def main():
 package.refresh=refresh
 package.build(BASE,OUT,'FFERPG V1',allowed_modules={'TEquip','TForsakenFreshLoad'})
 p=OUT.with_suffix('.json');r=package.json.loads(p.read_text());r.update(version='V1',previous='QuickUI99',next_development_version='V2',autosave='Production autosave repair: 10minute cycle after initial15minute load window; defer busy profiles/cutscenes; existing writer and format.',acceptance='Compile/archive checks PASS. Native gameplay and real autosave timestamp acceptance pending.');p.write_text(package.json.dumps(r,indent=2))
if __name__=='__main__':main()

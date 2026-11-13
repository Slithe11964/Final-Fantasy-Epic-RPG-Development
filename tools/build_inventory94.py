"""Apply the same narrow crash candidate to the exact reported release and UI93."""
import json,hashlib,re
from pathlib import Path
import build_preview68 as package
from inventory_crash94 import catalog,presentations,refresh
from editor_pair import View
from jtok import functions
from downgrade import wts_write
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
 view=View(base);items=catalog(view);icons,tips=presentations(view)
 package.refresh=lambda source:refresh(source,items,icons,tips)
 modules={lib:package.refresh(s) for lib,s in view.modules.items()}
 changed={lib for lib in modules if modules[lib]!=view.modules[lib]}
 expected={'TUnit','TEquip','TCine','TItemCooldown','TForsakenFreshLoad','TTitles','TPassive','TStatus','TTalents','TTitle'}
 if 'BlzGetItemEquipmentType(' in view.modules.get('TProf',''):expected.add('TProf')
 assert changed==expected,changed
 package.wts_write=lambda entries:wts_write({k:v.replace('|n- Unlocked New Game Minus.','') for k,v in entries.items()})
 package.build(base,out,label,allowed_modules=changed)
 report=json.loads(out.with_suffix('.json').read_text());report.update(item_definitions=len(items),base_sha1=hashlib.sha1(base.read_bytes()).hexdigest(),acceptance='Native crash hardening candidate: no item-ability index enumeration, guarded native item equipment type, pre-bind passive preparation, and quiescent cinematic/gear-transition UI. Both recorded traces are native and have no script symbol attribution. Retest required; no crash-free or desync-free guarantee.')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2))
 (out.parent/'Item-Ability-Catalogue.json').write_text(json.dumps(items,indent=2))
 for lib in changed:
  text=modules[lib]
  assert 'BlzGetItemAbilityByIndex' not in text,lib
  if lib!='TUnit':assert 'BlzGetItemEquipmentType(' not in text,lib

if __name__=='__main__':
 build(ROOT/'release/0.9.7.5f/history/2026-11-04-before-inventory94/FFERPG-0.9.7.5f.w3x',ROOT/'release/development/VersionFHotfix10/FFERPG-0.9.7.5f-Hotfix10.w3x','FFERPG 0.9.7.5f (Inventory Crash Fix)')
 build(ROOT/'release/development/QuickUI93/FFERPG-QuickUI93.w3x',ROOT/'release/development/QuickUI94/FFERPG-QuickUI94.w3x','FFERPG QuickUI94 (Inventory Crash Fix)')

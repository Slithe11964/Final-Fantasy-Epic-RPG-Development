"""Publish the checked modern f crash fix, preserving the reported release."""
import hashlib,json,shutil
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
RELEASE=ROOT/'release/0.9.7.5f'
BACKUP=RELEASE/'history/2026-11-04-before-inventory94'
PROD=ROOT/'release/development/VersionFHotfix10/FFERPG-0.9.7.5f-Hotfix10.w3x'
UI=ROOT/'release/development/QuickUI94/FFERPG-QuickUI94.w3x'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
 for log in ['inventory94-prod-check.log','inventory94-ui-check.log']:
  text=(ROOT/'build'/log).read_text();assert 'FAIL' not in text and 'PASS 5 native save/load text safety' in text,log
 for log in ['inventory94-save-prod.log','inventory94-save-ui.log','inventory94-content-prod.log','inventory94-content-ui.log']:
  text=(ROOT/'build'/log).read_text();assert 'FAIL' not in text and 'PASS' in text,log
 assert '\nOK\n' in (ROOT/'build/inventory94-tests.log').read_text()
 for p in [PROD,UI]:assert sha(p)==json.loads(p.with_suffix('.json').read_text())['sha256']
 assert not BACKUP.exists(),'Do not replace the preserved pre-fix release.'
 BACKUP.mkdir(parents=True)
 old=RELEASE/'FFERPG-0.9.7.5f.w3x'
 assert hashlib.sha1(old.read_bytes()).hexdigest()=='e24c6402dbd37b022f29baac2de2372073f87057'
 for p in RELEASE.iterdir():
  if p.is_file():shutil.copy2(p,BACKUP/p.name)
 dated=RELEASE/'2026-11-04';dated.mkdir(exist_ok=False)
 for suffix in ['.w3x','.j','.json','.unpacked.w3x']:
  src=PROD.with_suffix(suffix);target=dated/('FFERPG-0.9.7.5f'+suffix)
  shutil.copy2(src,target);shutil.copy2(src,RELEASE/target.name)
 report=json.loads(PROD.with_suffix('.json').read_text())
 report.update(output=str(RELEASE/'FFERPG-0.9.7.5f.w3x'),date='2026-11-04',version='0.9.7.5f',previous_snapshot=str(BACKUP),classic_1292='unchanged',newgameplus='Original eligibility and fresh-start code reset writer retained; action no longer replaced by save-unavailable.',newgameminus='Still blocked; Lucifer General unlock announcement and Chronicle claims removed.',runtime_acceptance='Demi Fiend with castable gear and Nirvana pickup/Sprint Boots hover require in-game retesting. Native report has no script attribution.')
 (RELEASE/'FFERPG-0.9.7.5f.json').write_text(json.dumps(report,indent=2))
 previous=json.loads((BACKUP/'release-report.json').read_text())
 previous['inventory94_update']=report
 (RELEASE/'release-report.json').write_text(json.dumps(previous,indent=2))
 notes='''2026-11-04 inventory crash update (modern build)

Before cinematics: cancel targeting and hide custom gear/backpack/talent UI;
suspend UI polling, inventory maintenance, passive stat refresh, Chronicle checks,
shield readouts, and load application. Resume after the native interface and hero
selection return, refreshing inventory/stats. Cinematic dialogue and fight intact.
Replace live item-ability index scans and icon/tooltip queries with bounded static
object-data lookups; guard null/retired item and unit access. Prepare stored-copy
passives before binding those copies and detach bag items before stripping them.
Restore -newgameplus's original fresh-start-code reset action; minus stays blocked.
Remove New Game Minus claims from Demi Fiend/Lucifer's General announcements and
Chronicle descriptions. The title's stat reward remains.

This production branch retains Lancer and the older Thief. QuickUI94 has the same
fixes on QuickUI93 content. Classic 1.29.2 and editor master were not replaced.
Both scripts/editor sources compile; focused tests, save and content checks pass.
Native crash reproduction and multiplayer acceptance remain pending. Retest both
reported scenarios before distribution. Previous production files preserved under
history/2026-11-04-before-inventory94.

Previous release notes:

'''
 (RELEASE/'RELEASE_NOTES.md').write_text(notes+(BACKUP/'RELEASE_NOTES.md').read_text())
 test=Path.home()/'Documents/Warcraft III/Maps/Download/TEST'
 installed=[]
 for src in [PROD,UI]:
  target=test/src.name;assert not target.exists(),'Preserve earlier TEST maps: '+str(target)
  shutil.copy2(src,target);assert sha(src)==sha(target)
  installed.append(dict(path=str(target),sha256=sha(target),bytes=target.stat().st_size))
 (ROOT/'build/inventory94-installed.json').write_text(json.dumps(installed,indent=2))
 print(json.dumps(installed,indent=2))

if __name__=='__main__':main()

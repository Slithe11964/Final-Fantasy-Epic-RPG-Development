"""Publish the requested replacement g pair and install QuickUI96, with backups."""
from pathlib import Path
import json,hashlib,shutil
ROOT=Path(__file__).resolve().parents[1]
REL=ROOT/'release/0.9.7.5g'
BACKUP=REL/'history/2026-11-04-before-ui96'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
 for name in ['ui96-prod-check.log','ui96-map-check.log','ui96-classic-check.log','ui96-prod-save.log','ui96-save.log','ui96-classic-save.log','ui96-prod-content.log','ui96-content.log']:
  s=(ROOT/'build'/name).read_text();assert 'PASS' in s and 'FAIL' not in s,name
 assert '\nOK\n' in (ROOT/'build/ui96-tests.log').read_text()
 assert not BACKUP.exists();BACKUP.mkdir(parents=True)
 for p in REL.iterdir():
  if p.is_file():shutil.copy2(p,BACKUP/p.name)
 test=Path.home()/'Documents/Warcraft III/Maps/Download/TEST'
 for name in ['FFERPG-0.9.7.5g.w3x','FFERPG-0.9.7.5g-1.29.2.w3x']:
  p=test/name
  if p.exists():
   assert p.read_bytes()==(REL/name).read_bytes(),'TEST differs from the current release; preserve separately before replacing.'
   shutil.copy2(p,BACKUP/('TEST-before-ui96-'+name))
 folder=REL/'2026-11-04-ui96';folder.mkdir(exist_ok=False)
 native=ROOT/'release/development/VersionGHotfix01/FFERPG-0.9.7.5g-Hotfix01.w3x'
 classic=native.parent/'FFERPG-0.9.7.5g-1.29.2.w3x'
 outputs=[]
 for src,name in [(native,'FFERPG-0.9.7.5g'),(classic,'FFERPG-0.9.7.5g-1.29.2')]:
  for suffix in ['.w3x','.j','.unpacked.w3x']:
   shutil.copy2(src.with_suffix(suffix),folder/(name+suffix));shutil.copy2(src.with_suffix(suffix),REL/(name+suffix))
  r=json.loads(src.with_suffix('.json').read_text());r.update(date='2026-11-04',output=str(REL/(name+'.w3x')),previous_snapshot=str(BACKUP),version='0.9.7.5g',move_to_hero='Original backpack coordinates/anchor/size unchanged; foreground layer and hidden/open state fixed.')
  (REL/(name+'.json')).write_text(json.dumps(r,indent=2));(folder/(name+'.json')).write_text(json.dumps(r,indent=2))
  target=test/(name+'.w3x');shutil.copy2(src,target);assert digest(target)==digest(src)
  outputs.append(dict(path=str(target),sha256=digest(target),bytes=target.stat().st_size))
 ui=ROOT/'release/development/QuickUI96/FFERPG-QuickUI96.w3x';target=test/ui.name;assert not target.exists();shutil.copy2(ui,target);assert digest(ui)==digest(target)
 outputs.append(dict(path=str(target),sha256=digest(target),bytes=target.stat().st_size))
 (ROOT/'build/ui96-installed.json').write_text(json.dumps(outputs,indent=2))
 notes='''UI display fix — 2026-11-04

Modern g: movement/attack/smart/stop orders no longer trigger the gear UI shutdown.
True inventory changes and cutscenes retain the existing crash precautions.
Move to hero stays at its original backpack position; its rendering layer and
panel open/hidden state are fixed. No item/stat/spell/save changes or new timers.
Same fix is in QuickUI96, retaining all Central Islands content from QuickUI95.
Classic 1.29.2 g is included unchanged: its interface has none of these controls.
Both g builds retain 7% house health/mana recovery.

Playable/editor, startup/source/global, save/content and five focused checks pass.
Native visual reproduction and multiplayer acceptance remain pending.
Prior g pair and TEST copies preserved under history/2026-11-04-before-ui96.
See docs/UI_FLASH96.md.

'''
 (REL/'RELEASE_NOTES.md').write_text(notes+(BACKUP/'RELEASE_NOTES.md').read_text())
 (folder/'RELEASE_NOTES.md').write_text(notes)
 print(json.dumps(outputs,indent=2))

if __name__=='__main__':main()

"""Promote the checked production autosave pair, retaining earlier releases and TEST copies."""
from pathlib import Path
import json,hashlib,shutil
from mpq import MPQ
ROOT=Path(__file__).resolve().parents[1]
REL=ROOT/'release/0.9.7.5g';BACKUP=REL/'history/2026-11-05-before-autosave'
SOURCE=ROOT/'release/development/VersionGHotfix02'
TEST=Path.home()/'Documents/Warcraft III/Maps/Download/TEST'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 assert not BACKUP.exists();BACKUP.mkdir(parents=True)
 for p in REL.iterdir():
  if p.is_file():shutil.copy2(p,BACKUP/p.name)
 dated=REL/'2026-11-05-autosave';dated.mkdir(exist_ok=False);rows=[]
 for name in ['FFERPG-0.9.7.5g','FFERPG-0.9.7.5g-1.29.2']:
  src=SOURCE/(name+'-Hotfix02.w3x');report=json.loads(src.with_suffix('.json').read_text());assert report['sha256']==digest(src)
  old=MPQ(str(REL/(name+'.w3x')));new=MPQ(str(src))
  for file in old.read('(listfile)').decode().splitlines():
   if file.lower() not in ['war3map.j','war3map.wct','(listfile)','(attributes)','(signature)']:assert old.read(file)==new.read(file),file
  target=TEST/(name+'.w3x')
  if target.exists():shutil.copy2(target,BACKUP/('TEST-before-autosave-'+target.name))
  for suffix in ['.w3x','.j','.unpacked.w3x']:
   shutil.copy2(src.with_suffix(suffix),REL/(name+suffix));shutil.copy2(src.with_suffix(suffix),dated/(name+suffix))
  report.update(base=str(BACKUP/(name+'.w3x')),output=str(REL/(name+'.w3x')),version='0.9.7.5g',date='2026-11-05',validation='Both native/editor/startup/source/globals/text safety/content/save checks and11focused tests PASS; live interval/file confirmation pending.')
  (REL/(name+'.json')).write_text(json.dumps(report,indent=2));(dated/(name+'.json')).write_text(json.dumps(report,indent=2))
  TEST.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target);assert digest(target)==digest(src)
  rows.append(dict(path=str(target),bytes=target.stat().st_size,sha256=digest(target)))
 notes="Autosave repair — 2026-11-05\n\nModern g inventory setup no longer clears the autosave trigger's action.\nOriginal cadence retained: one slot each60seconds over10slots, so each player\ngets an autosave every10minutes after the initial15minute loading window.\nBoth versions explicitly enable the scheduler at the end of that window.\nBusy loads/saves/cutscenes defer instead of dropping the scheduled save.\nModern inventory/cutscene suspension also defers capture. Retry timer runs\nonly while deferred work exists; at most one capture per retry second.\nExisting FFERPG/autosave.txt, full-profile serializer, account checks, local\nfile writing and readback verification unchanged. -autosave off/Hardcore\ncontinue to suppress autosaving. Previous pair preserved in history.\n11focused tests and both map/editor/save/content validations PASS.\nLive gameplay interval and physical file timestamp still need confirmation.\nNo Dragoon/Thief/monster/master changes; development QuickUI99 unchanged.\n\n"
 (REL/'RELEASE_NOTES.md').write_text(notes+(BACKUP/'RELEASE_NOTES.md').read_text());(dated/'RELEASE_NOTES.md').write_text(notes)
 (SOURCE/'TEST-installed.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
if __name__=='__main__':main()

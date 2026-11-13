"""Preserve rejected intermediate editor payloads, normalize final source."""
import shutil
from build_gear_visibility27 import ROOT,build
for folder,name,base,label,short in [
 ('GRecovery16','FFERPG-0.9.7.5g-Recovery16','GRecovery15/FFERPG-0.9.7.5g-Recovery15','FFERPG 0.9.7.5g Recovery16','Recovery16'),
 ('V27','FFERPG-V27','V26/FFERPG-V26','FFERPG V27 - Gear Visibility','V27')]:
    path=ROOT/'release/development'/folder/(name+'.w3x')
    history=path.parent/'history-before-editor-newlines';assert not history.exists();history.mkdir()
    for suffix in ['.w3x','.j','.json','.unpacked.w3x']:
        p=path.with_suffix(suffix)
        if p.exists():shutil.move(str(p),str(history/p.name))
    build(ROOT/'release/development'/(base+'.w3x'),path,label,short)

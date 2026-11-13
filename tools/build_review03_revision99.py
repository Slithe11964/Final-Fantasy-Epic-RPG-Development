"""Creature Review 03g: Ancient Forest roles, summons and Mother Spider split."""
import re
import build_review03_revision95 as review
from build_review03_revision97 import patch as hydra_patch
from build_ancient99 import SUMMONS,all_objects
from jtok import functions
from performance_runtime import put
from editor_pair import View

def patch(script,rows):
 script=hydra_patch(script,rows);fs=functions(script);b=fs['Review_Chat']
 needle='    elseif s=="-split" then'
 start=b.index(needle);end=b.index('    elseif s=="-info"',start)
 b=b[:start]+'''    elseif s=="-split" then
        if u!=null and GetWidgetLife(u)>.405 and (GetUnitTypeId(u)=='nahy' or GetUnitTypeId(u)=='nhyd' or GetUnitTypeId(u)=='n010') then
            call KillUnit(u)
            call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Selected creature divided. Mother Spider releases three Brood Mothers; Hydras release two offspring.")
        else
            call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Select a living Ancient Hydra, Hydra, or Mother Spider, then type -split. Cast Brood Shell to test shell hatching after ten seconds or when killed.")
        endif
'''+b[end:]
 script=put(script,'Review_Chat',b)
 return script
if __name__=='__main__':
 review.SOURCE_MAP=review.ROOT/'release/development/QuickUI99/FFERPG-QuickUI99.w3x'
 review.SOURCE=review.ROOT/'build/review03-source99.w3x'
 review.REVISION='03g'
 review.REVIEW_OUT=review.ROOT/'release/development/CreatureReview03g/FFERPG-Creature-Review-03g.w3x'
 review.EXTRA_SPELLS=[r for r in all_objects(View(review.SOURCE_MAP),'w3a') if r.startswith(('z','n')) and r[-1] in '89']
 origins={'qL99':'Corrupted Tree of Life: spawned every5seconds while rooted; seeks enemy heroes and explodes.','qD99':'Corrupted Tree of Life: two summoned Dryads.','qS99':'Corrupted Tree of Life: summoned Sylph.','qE99':'Mother Spider: Brood Shell hatches after10seconds or when killed.','qI99':'Satyr Hellcaller: summoned Infernal.','qT99':'Corrupted Treant: three summoned Ents.','qA99':'Corrupted Ancient of War: produced every5seconds while rooted.'}
 review.EXTRA_EXHIBITS=[(r,info[1],7,'Lothlorien / Ancient Forest',origins[r]) for r,info in SUMMONS.items()]+[('nsbm','Brood Mother (Mother Spider offspring)',7,'Lothlorien / Ancient Forest','Mother Spider or Brood Shell: three Brood Mothers; original offspring stats retained.')]
 review.POST_HOOK=patch
 review.main()

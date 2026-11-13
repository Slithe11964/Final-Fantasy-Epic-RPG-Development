"""Creature Review 03p: V18 creature polish without stack-counter UI."""
import build_review03_revision95 as review
from build_review03_revision97 import patch as hydra_patch
from build_ancient99 import SUMMONS,all_objects
from jtok import functions
from performance_runtime import put
from editor_pair import View

def patch(script,rows):
 script=hydra_patch(script,rows);b=functions(script)['Review_Chat'];start=b.index('    elseif s=="-split" then');end=b.index('    elseif s=="-info"',start)
 b=b[:start]+'''    elseif s=="-split" then
        if u!=null and GetWidgetLife(u)>.405 and (GetUnitTypeId(u)=='nahy' or GetUnitTypeId(u)=='nhyd' or GetUnitTypeId(u)=='n010' or GetUnitTypeId(u)=='nsbm') then
            call KillUnit(u)
            call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Selected creature divided. Mother Spider releases three permanent Broodlings. A Broodling releases two permanent Spiderlings. Hydras release two offspring.")
        else
            call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Select a living Ancient Hydra, Hydra, Mother Spider or Broodling, then type -split. Brood Shell carries eggs that hatch after ten seconds; killing Mother Spider early cancels that extra egg wave.")
        endif
'''+b[end:]
 script=put(script,'Review_Chat',b)
 start=functions(script)['Review_Start']
 start=start.replace('    call ExecuteFunc("Review02_Load")','    set D7ReviewNoCollision=true\n    call ExecuteFunc("Review02_Load")',1)
 script=put(script,'Review_Start',start)
 script=put(script,'Review_Add',functions(script)['Review_Add'].replace('call SetUnitPathing(u,false)','call SetUnitPathing(u,true)'))
 script=put(script,'Review_Start',functions(script)['Review_Start'].replace('set D7ReviewNoCollision=true','set D7ReviewNoCollision=false'))
 script=put(script,'Review03_Combat',functions(script)['Review03_Combat'].replace(' call Inventory94_Init()\n',''))
 assert 'call SetUnitPathing(u,true)' in functions(script)['Review_Add']
 return script

if __name__=='__main__':
 review.SOURCE_MAP=review.ROOT/'release/development/V18/FFERPG-V18.w3x'
 review.SOURCE=review.ROOT/'build/review03-source-v18.w3x'
 review.REVISION='03p'
 review.REVIEW_OUT=review.ROOT/'release/development/CreatureReview03p/FFERPG-Creature-Review-03p.w3x'
 review.EXTRA_SPELLS=[r for r in all_objects(View(review.SOURCE_MAP),'w3a') if (r.startswith(('z','n')) and r[-1] in '89') or r.startswith(('d','j','k')) and r[-1]=='2']
 origins={'qL99':'Corrupted Tree of Life: spawned every five seconds while rooted; seeks heroes and explodes. No building command.','qD99':'Corrupted Tree of Life: summoned Dryads.','qS99':'Corrupted Tree of Life: summoned Sylph.','qI99':'Satyr Hellcaller: Infernal appears when its meteor lands.','qT99':'Corrupted Treant: summoned Ents.','qA99':'Corrupted Ancient of War: produced every five seconds while rooted; protected only while Cover Archers is active.'}
 review.EXTRA_EXHIBITS=[(r,info[1],7,'Lothlorien / Ancient Forest',origins[r]) for r,info in SUMMONS.items() if r!='qE99']+[
 ('nsbm','Broodling',7,'Lothlorien / Ancient Forest','Mother Spider eggs or death: three permanent Broodlings; each splits into two Spiderlings on death. -split supported.'),
 ('nspr','Spiderling',7,'Lothlorien / Ancient Forest','Broodling death: two permanent Spiderlings. Death roar permanently grants allied Mother Spiders and Broodlings within 1000 +5% attack speed, stacking.')]
 original_catalogue=review.review3.catalogue
 def catalogue_without_forest_spider(base,script):
  rows,audit,fs=original_catalogue(base,script)
  rows=[r for r in rows if not (r['raw']=='nspb' and r['area']!=12) and not (r['area']==1 and r['raw']=='rSP3')]
  review.review3.review.ROWS=rows
  return rows,audit,fs
 review.review3.catalogue=catalogue_without_forest_spider
 review.POST_HOOK=patch
 review.main()

"""Rebuild Creature Review from the V37 combat and object data."""
from pathlib import Path
import build_review03_revision95 as review
from build_review03_revision_v20 import patch
from build_ancient99 import SUMMONS, all_objects
from editor_pair import View

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT/'release/development/V37/FFERPG-V37.w3x'
OUT = ROOT/'release/development/CreatureReview03t/FFERPG-Creature-Review-03t.w3x'

def build():
    review.SOURCE_MAP = BASE
    review.SOURCE = BASE
    review.REVISION = '03t'
    review.REVIEW_OUT = OUT
    review.previous.source = lambda: None
    review.previous.POISON = 'bP88'
    abilities = all_objects(View(BASE),'w3a')
    review.EXTRA_SPELLS = [raw for raw in abilities if raw.endswith(('37','88','89','90','95','98','99')) or
                           raw.startswith(('z','n')) and raw[-1] in '89' or
                           raw.startswith(('d','j','k')) and raw[-1]=='2']
    review.EXTRA_SPELLS.extend(['fT86','fN86','bG88','bB88','bK88','bS88','cP25','cP33','hHB0','mSL9','mBI9','mFB9','mTV9'])
    origins = {
        'qL99':'Corrupted Tree of Life spawns a wisp every five seconds while rooted.',
        'qD99':'Summoned by the Corrupted Tree of Life.',
        'qS99':'Summoned by the Corrupted Tree of Life for 120 seconds.',
        'qI99':'Appears when the Satyr Hellcaller meteor lands.',
        'qT99':'Summoned by the Corrupted Treant.',
        'qA99':'Produced by the rooted Corrupted Ancient of War.',
    }
    review.EXTRA_EXHIBITS = [(raw,info[1],7,'Lothlorien / Ancient Forest',origins[raw])
                            for raw,info in SUMMONS.items() if raw in origins]
    review.EXTRA_EXHIBITS += [
        ('nsbm','Broodling',7,'Lothlorien / Ancient Forest','Mother Spider eggs and death release permanent Broodlings.'),
        ('nspr','Spiderling',7,'Lothlorien / Ancient Forest','Broodlings release Spiderlings when killed.')]
    original_catalogue = review.review3.catalogue
    def catalogue(base, script):
        rows, audit, funcs = original_catalogue(base,script)
        rows = [row for row in rows if not (row['raw']=='nspb' and row['area']==1)
                and not (row['area']==1 and row['raw']=='rSP3')]
        review.review3.review.ROWS = rows
        return rows, audit, funcs
    review.review3.catalogue = catalogue
    review.POST_HOOK = patch
    review.main()
    readme=OUT.parent/'README.md'
    readme.write_text('# Creature Review 03t\n\nBased on V37. Play as Red. -help lists controls. -info shows creature stats, -abilities lists spell calculations, -test creates a controlled practice copy and -enemy creates a hostile copy.\n',encoding='utf-8')

if __name__=='__main__':
    build()


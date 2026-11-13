"""Creature Review 03f: Naga Islands and level20 hatchlings."""
import build_review03_revision95 as review
from build_review03_revision97 import patch
from build_naga98 import objects98
from editor_pair import View
if __name__=='__main__':
 review.SOURCE_MAP=review.ROOT/'release/development/QuickUI98/FFERPG-QuickUI98.w3x'
 review.SOURCE=review.ROOT/'build/review03-source98.w3x'
 review.REVISION='03f'
 review.REVIEW_OUT=review.ROOT/'release/development/CreatureReview03f/FFERPG-Creature-Review-03f.w3x'
 review.EXTRA_SPELLS=[r for r in __import__('build_forest86').all_objects(View(review.SOURCE_MAP),'w3a') if len(r)==4 and r[0]=='n' and r[-1] in '89']
 review.POST_HOOK=patch
 review.main()

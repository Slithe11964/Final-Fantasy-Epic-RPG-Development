"""Rebuild the readable creature review from QuickUI93's current world pools."""
from pathlib import Path
import build_review03_revision92 as review
ROOT=Path(__file__).resolve().parents[1]
if __name__=='__main__':
 review.OUT=ROOT/'release/development/QuickUI93/FFERPG-QuickUI93.w3x'
 review.SOURCE=ROOT/'build/review03-source93.w3x'
 review.REVISION='03c'
 review.REVIEW_OUT=ROOT/'release/development/CreatureReview03c/FFERPG-Creature-Review-03c.w3x'
 review.main()

"""Creature Review 03e: functional -split for Ancient Hydra and Hydra."""
import re
import build_review03_revision95 as review
from jtok import functions
from performance_runtime import put

def patch(script,rows):
 fs=functions(script);b=fs['Review_Chat']
 pattern=r'    elseif s=="-split" and u!=null then\n.*?(?=    elseif s=="-info")'
 replacement='''    elseif s=="-split" then
        if u!=null and GetWidgetLife(u)>.405 and (GetUnitTypeId(u)=='nahy' or GetUnitTypeId(u)=='nhyd') then
            call KillUnit(u)
            call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Hydra divided: two offspring appear where it died. Select a new Hydra and use -split again to see its hatchlings.")
        else
            call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Select a living Ancient Hydra (nahy) or Hydra (nhyd), then type -split. Hatchlings do not divide.")
        endif
'''
 b,count=re.subn(pattern,lambda m:replacement,b,flags=re.S);assert count==1
 b=b.replace('local string s=GetEventPlayerChatString()','local string s=StringCase(GetEventPlayerChatString(),false)',1)
 b=b.replace('    if SubString(s,0,6)', '''    loop
        exitwhen StringLength(s)==0 or SubString(s,StringLength(s)-1,StringLength(s))!=" "
        set s=SubString(s,0,StringLength(s)-1)
    endloop
    if SubString(s,0,6)''',1)
 script=put(script,'Review_Chat',b)
 fs=functions(script);b=fs['Review_Start'].replace('-wound: selected half HP.','-wound: selected half HP. -split: living Ancient Hydra/Hydra divides on death.')
 script=put(script,'Review_Start',b)
 return script

if __name__=='__main__':
 review.SOURCE_MAP=review.ROOT/'release/development/QuickUI97/FFERPG-QuickUI97.w3x'
 review.SOURCE=review.ROOT/'build/review03-source97.w3x'
 review.REVISION='03e'
 review.REVIEW_OUT=review.ROOT/'release/development/CreatureReview03e/FFERPG-Creature-Review-03e.w3x'
 review.POST_HOOK=patch
 review.main()
 p=review.REVIEW_OUT.parent/'README.md';s=p.read_text();s=s.replace('native two-hydra death split','two-stage scripted death split');p.write_text(s+'\n-split works for both living Ancient Hydras and Hydras. Hydra Hatchlings do not divide. Offspring Hydras: level25,3000HP,41armor,135–140attack; poison20%,50+5*attackerLevel per second for10s.\n')

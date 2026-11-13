"""Keep the full teleporter page and its Cancel button above Warcraft's HUD."""
from jtok import functions
from performance_runtime import put
def refresh(s):
 fs=functions(s)
 if 'TravelPanel_Render' not in fs:return s
 b=fs['TravelPanel_Render'];anchor='    local string label';assert anchor in b
 b=b.replace(anchor,anchor+'\n    local integer buttons=0\n    local real stride=.04',1)
 anchor='    loop\n        exitwhen i>15';assert anchor in b
 layout='''    set i=1
    loop
        exitwhen i>udg_TravelCount
        if udg_WarpUnlocked[TravelOrder[i]] then
            set total=total+1
        endif
        set i=i+1
    endloop
    set buttons=IMinBJ(10,IMaxBJ(0,total-TravelPage[pid]*10))+1
    if (TravelPage[pid]+1)*10<total then
        set buttons=buttons+1
    endif
    if TravelPage[pid]>0 then
        set buttons=buttons+1
    endif
    set stride=RMinBJ(.04,(.40-.072)/I2R(buttons))
    call BlzFrameClearAllPoints(TravelPanel)
    call BlzFrameSetAbsPoint(TravelPanel,FRAMEPOINT_TOP,.4,.585)
    set total=0
    set i=0
'''
 b=b.replace(anchor,layout+anchor,1)
 b=b.replace('I2R(row)*.04','I2R(row)*stride').replace('I2R(row+1)*.04','I2R(row+1)*stride')
 for index in ['raw','14','15','0']:
  needle=f'    call BlzFrameSetVisible(TravelPanelButton[{index}],true)'
  assert needle in b
  b=b.replace(needle,f'    call BlzFrameSetSize(TravelPanelButton[{index}],.228,stride-.005)\n'+needle,1)
 s=put(s,'TravelPanel_Render',b)
 b=fs['TravelPanel_Init'];b=b.replace('call BlzFrameSetLevel(TravelPanel,12)','call BlzFrameSetLevel(TravelPanel,80)',1)
 b=b.replace('    call BlzFrameSetText(TravelPanelTitle,"Choose destination")','    call BlzFrameSetText(TravelPanelTitle,"Choose destination")\n    call BlzFrameSetEnable(TravelPanelTitle,false)',1)
 return put(s,'TravelPanel_Init',b)

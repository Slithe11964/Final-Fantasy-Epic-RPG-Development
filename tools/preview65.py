"""Non-intercepting screen observation and damage-footprint previews."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]

def refresh(source):
    fs=functions(source)
    if 'GearInput_Cursor' not in fs:return source
    wave=(ROOT/'experiments/Forsaken/Wave65.j').read_text()
    bag=(ROOT/'experiments/Forsaken/BagScreen65.j').read_text()
    for fragment in (wave,bag):
        source=source.replace('endglobals',re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]+'endglobals',1)
    wf=functions(wave)
    source=source.replace('function GearWave_Clear takes',
        '\n\n'.join(body for name,body in wf.items() if name!='Wave65_Draw')+'\n\nfunction GearWave_Clear takes',1)
    source=source.replace('function GearWave_Draw takes',wf['Wave65_Draw']+'\n\nfunction GearWave_Draw takes',1)
    source=put(source,'GearWave_Draw','function GearWave_Draw takes nothing returns nothing\n    call Wave65_Draw()\nendfunction')
    source=put(source,'GearWave_Clear',fs['GearWave_Clear'].replace('    local integer i=1','    local integer i=1\n    call Wave65_Clear()',1))
    body=fs['GearWave_Init'].replace('"GearWaveRune.tga",24.,24.','"GearWaveRune.tga",48.,48.')
    body=body.replace('    set GearWaveKeys=CreateTrigger()','    call Wave65_Init()\n    set GearWaveKeys=CreateTrigger()',1)
    source=put(source,'GearWave_Init',body)
    source=put(source,'GearWave_Reset',fs['GearWave_Reset'].replace('    call GearWave_Clear()',
        '    call GearWave_Clear()\n    call Wave65_Reset()',1))
    source=source.replace('function BagHover_Poll64 takes','\n\n'.join(functions(bag).values())+'\n\nfunction BagHover_Poll64 takes',1)
    for name in ('BagHover_Poll64','BagHover_World64'):
        source=put(source,name,'function '+name+' takes nothing returns nothing\nendfunction')
    source=put(source,'BagCast_Init63','''function BagCast_Init63 takes nothing returns nothing
    // Static native console exists on every client; never discover bag children.
    set BagConsole65=BlzGetFrameByName("ConsoleBottomBar",0)
endfunction''')
    source=put(source,'GearInput_Poll',fs['GearInput_Poll'].replace('call BagHover_Poll64()','call BagScreen_Poll65()'))
    for name in ('GearInput_Init','GearCursor_Error60'):
        body=fs[name].replace('Width()/2),.14','Width()/2),.155')
        body=body.replace('GearError62.toc','GearError65.toc').replace('GearGroundError62','GearGroundError65')
        source=put(source,name,body)
    body=fs['QuickGear_Diagnostic'].replace('UI64 F/G:','UI65 F/G:').replace('Hotfix12 F/G:','Hotfix13 F/G:')
    body=body.replace('"Passive bag slot="','"Screen bag slot="')
    body=body.replace('" raw key requests="+I2S(GearRawRequests64)',
        '" raw key requests="+I2S(GearRawRequests64)+" previews="+I2S(BagScreenArms65)+" bounds="+R2S(BagLeftEdge65)+","+R2S(BagTopEdge65)+" cell="+R2S(BagCellX65)+","+R2S(BagCellY65)')
    return put(source,'QuickGear_Diagnostic',body)

"""Restore UI55 dispatch; passive inventory hover observers arm the shared runes."""
import re
from pathlib import Path
from editor_pair import View
from jtok import functions
from performance_runtime import put
from damage_tooltips import merged
from priest_master import fields
ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'Wave_Init' in fs:source=put(source,'Wave_Init','function Wave_Init takes nothing returns nothing\nendfunction')
    if 'QuickGear_Request' not in fs:return source
    baseline=functions(View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x').modules['TEquip'])
    wave=(ROOT/'experiments/Forsaken/GearWave57.j').read_text()
    # Item command events do not reliably observe native inventory selection.
    # Ordinary Calculator selection still uses its existing E/button event.
    wave=re.sub(r'^    call TriggerRegisterCommandEvent\(GearWave(?:Commands|IceCommands),.*\n','',wave,flags=re.M)
    wave=re.sub(r'^    call BlzTriggerRegisterFrameEvent\(GearWaveCalculator,.*\n','',wave,flags=re.M)
    wave=wave.replace('    call TriggerAddAction(GearWaveCalculator,function GearWave_CalculatorArm)',
        '    call TriggerAddAction(GearWaveCalculator,function GearWave_CalculatorArm)\n    call TriggerRegisterCommandEvent(GearWaveCalculator,\'A17S\',"shockwave")')
    input=(ROOT/'experiments/Forsaken/GearInput58.j').read_text()
    view=View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x')
    items=merged(view.object_bytes('war3map.w3t'),view.object_bytes('war3mapSkin.w3t'),'w3t')
    wave_ids={'A08X','A0Q0','A0Q1','A0Q2','A0SM','A0TP','A0SA','A150','A0UY','A0TM','A17S'}
    rows=[]
    for raw,obj in sorted(items.items()):
        for cast in str(fields(obj).get(('iabi',None),'')).split(','):
            if cast in wave_ids:
                rows.append(f"    call SaveInteger(GearInputSpells,0,'{raw}','{cast}')")
                break
    assert rows
    input+='\nfunction GearInput_InitSpells takes nothing returns nothing\n'+'\n'.join(rows)+'\nendfunction\n'
    input=input.replace('    call GearWave_Init()','    call ExecuteFunc("GearInput_InitSpells")\n    call GearWave_Init()',1)
    for fragment in (wave,input):
        source=source.replace('endglobals',re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]+'endglobals',1)
    for name in ('QuickGear_Request','QuickGear_Mouse','QuickGear_Receive','QuickGear_InitPreviews','QuickGear_ClearPreview','QuickGear_MovePreview','QuickGear_Reset'):
        source=put(source,name,baseline[name])
    source=source.replace(fs['QuickGear_BindWeaponCast'],'')
    for name in ('QuickGearTargetImage','QuickGearTargetPreview'):
        source=re.sub(r'^\s*\w+ '+name+r'=[^\n]*\n','',source,flags=re.M)
    source=source.replace('function QuickGear_RecordSpell takes','\n\n'.join(functions(wave).values())+'\n\nfunction QuickGear_RecordSpell takes',1)
    source=source.replace('function QuickGear_Request takes','\n\n'.join(functions(input).values())+'\n\nfunction QuickGear_Request takes',1)
    body=functions(source)['QuickGear_ClearPreview']
    body=body.replace('    set QuickGearPreview=0','    set GearInputTarget=false\n    if GearInputCursor!=null then\n        call BlzFrameSetVisible(GearInputCursor,false)\n        call BlzEnableCursor(true)\n    endif\n    call GearWave_Clear()\n    set QuickGearPreview=0')
    source=put(source,'QuickGear_ClearPreview',body)
    body=functions(source)['QuickGear_Request']
    body=body.replace('            if LoadInteger(QuickGearData,1,raw)>=2 then','''            set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
            set GearInputTarget=LoadInteger(QuickGearData,1,raw)==1
            call GearInput_Cursor()
            call GearWave_Arm(cast)
            if GearWaveMode==0 and LoadInteger(QuickGearData,1,raw)>=2 then''',1)
    source=put(source,'QuickGear_Request',body)
    body=functions(source)['QuickGear_Mouse']
    body=body.replace('        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()',
        '        if BlzGetTriggerPlayerMouseX()==0. and BlzGetTriggerPlayerMouseY()==0. then\n            return\n        endif\n        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()',1)
    body=body.replace('        call QuickGear_MovePreview()','        call QuickGear_MovePreview()\n        call GearInput_Cursor()\n        call GearWave_Draw()',1)
    marker='    if GetLocalPlayer()==GetTriggerPlayer() and QuickGearPending>=0 then'
    body=body.replace(marker,'''    if GetLocalPlayer()==GetTriggerPlayer() and QuickGearPending<0 then
        if BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT or ((BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0.) and TimerGetElapsed(NativeCDClock)-GearInputArmedAt>.08) then
            call GearWave_Clear()
        endif
    endif
'''+marker,1)
    body=body.replace('        elseif BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_LEFT then',
        '        elseif BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_LEFT and (BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0.) then',1)
    source=put(source,'QuickGear_Mouse',body)
    body=functions(source)['QuickGear_Reset'].replace('    call QuickGear_ClearPreview()',
        '    call GearInput_Reset()\n    call QuickGear_ClearPreview()',1)
    source=put(source,'QuickGear_Reset',body)
    body=functions(source)['QuickGear_Init'].replace('    set origin=null\nendfunction',
        '    call ExecuteFunc("GearInput_Init")\n    set origin=null\nendfunction',1)
    source=put(source,'QuickGear_Init',body)
    body=functions(source)['QuickGear_WheelTick'].replace('    // Once -gearhotkey',
        '    call GearInput_Poll()\n    // Once -gearhotkey',1)
    body=body.replace('    if not QuickGear_FocusReset() then\n        return',
        '    if not QuickGear_FocusReset() then\n        call QuickGear_ClearPreview()\n        set GearInputHoverSlot=0\n        return',1)
    source=put(source,'QuickGear_WheelTick',body)
    body=functions(source)['QuickGear_RecordSpell']
    body=body.replace('        set QuickGearActualSpell[pid]=GetSpellAbilityId()',
        '        set QuickGearActualSpell[pid]=GetSpellAbilityId()\n        if GetLocalPlayer()==GetOwningPlayer(hero) then\n            call ExecuteFunc("QuickGear_ClearPreview")\n        endif',1)
    source=put(source,'QuickGear_RecordSpell',body)
    body=functions(source)['QuickGear_Receive'].replace('        if mode==0 then',
        '        set QuickGearExpectedSpell[GetPlayerId(owner)]=cast\n        if mode==0 then',1)
    source=put(source,'QuickGear_Receive',body)
    body=functions(source)['QuickGear_Diagnostic'].replace('UI56 F/G:','UI58 F/G:').replace('Hotfix04 F/G:','Hotfix06 F/G:')
    body=body.replace('    if GetLocalPlayer()==owner then','    if GetLocalPlayer()==owner then\n        call DisplayTimedTextToPlayer(owner,0,0,60,"Bag previews="+I2S(GearInputBagClicks)+" hover="+I2S(GearInputHoverSlot))',1)
    return put(source,'QuickGear_Diagnostic',body)

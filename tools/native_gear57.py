"""Use the real native equipment controls while preserving the confirmed F/G art."""
from pathlib import Path
import re
from editor_pair import View
from jtok import functions
from performance_runtime import put

ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'Wave_Init' in fs:
        # Calculator/gear previews now share the standalone renderer, including
        # release maps that have no Dragoon module or DG_Rune image bank.
        source=put(source,'Wave_Init','function Wave_Init takes nothing returns nothing\nendfunction')
    if 'QuickGear_Request' not in fs:return source
    baseline=functions(View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x').modules['TEquip'])
    wave=(ROOT/'experiments/Forsaken/GearWave57.j').read_text()
    native=(ROOT/'experiments/Forsaken/NativeGear57.j').read_text()
    for fragment in (wave,native):
        declarations=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
        source=source.replace('endglobals',declarations+'endglobals',1)
    # Remove UI56's substitute unit ring and active-ability mutation. The engine
    # now supplies its own cursor and acts on its real equipped-item control.
    for name in ('QuickGear_InitPreviews','QuickGear_ClearPreview','QuickGear_MovePreview','QuickGear_Receive'):
        source=put(source,name,baseline[name])
    if 'QuickGear_BindWeaponCast' in fs:source=source.replace(fs['QuickGear_BindWeaponCast'],'')
    for name in ('QuickGearTargetImage','QuickGearTargetPreview'):
        source=re.sub(r'^\s*\w+ '+name+r'=[^\n]*\n','',source,flags=re.M)
    source=source.replace('function QuickGear_RecordSpell takes','\n\n'.join(functions(wave).values())+'\n\nfunction QuickGear_RecordSpell takes',1)
    source=source.replace('function QuickGear_Request takes','\n\n'.join(functions(native).values())+'\n\nfunction QuickGear_Request takes',1)
    source=put(source,'QuickGear_Request','''function QuickGear_Request takes integer slot returns nothing
    call NativeGear_Request(slot)
endfunction''')
    source=put(source,'QuickGear_Mouse','''function QuickGear_Mouse takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        if GetTriggerEventId()==EVENT_PLAYER_MOUSE_MOVE then
            if BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0. then
                set QuickGearMouseX=BlzGetTriggerPlayerMouseX()
                set QuickGearMouseY=BlzGetTriggerPlayerMouseY()
                set QuickGearMouseKnown=true
                call QuickGear_MovePreview()
            endif
        elseif BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT then
            call NativeGear_Cancel()
        elseif TimerGetElapsed(NativeCDClock)-RMaxBJ(NativeGearStarted,GearWaveStarted)>.08 and (BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0.) then
            // Native item targeting handles the click. Never send a second
            // manual item-use order from this presentation callback.
            call NativeGear_Cancel()
        endif
    endif
endfunction''')
    body=baseline['QuickGear_Reset']
    body=body.replace('    call QuickGear_ClearPreview()','    call NativeGear_Reset()\n    call QuickGear_ClearPreview()',1)
    source=put(source,'QuickGear_Reset',body)
    body=functions(source)['QuickGear_Init']
    marker='    set origin=null\nendfunction'
    assert body.count(marker)==1
    body=body.replace(marker,'    call ExecuteFunc("NativeGear_Init")\n'+marker,1)
    source=put(source,'QuickGear_Init',body)
    body=functions(source)['QuickGear_WheelTick'];marker='    // Once -gearhotkey'
    assert marker in body
    body=body.replace(marker,'    call NativeGear_Tick()\n'+marker,1)
    # Cancel the guarded native request even while the game has no focus.
    body=body.replace('    if not QuickGear_FocusReset() then\n        return','    if not QuickGear_FocusReset() then\n        call NativeGear_Cancel()\n        return',1)
    source=put(source,'QuickGear_WheelTick',body)
    body=functions(source)['QuickGear_RecordSpell']
    marker='        set QuickGearActualSpell[pid]=GetSpellAbilityId()'
    assert marker in body
    body=body.replace(marker,marker+'\n        if GetLocalPlayer()==GetOwningPlayer(hero) then\n            set NativeGearArmed=false\n            call GearWave_Clear()\n            call ExecuteFunc("QuickGear_ClearPreview")\n        endif',1)
    source=put(source,'QuickGear_RecordSpell',body)
    body=functions(source)['QuickGear_Diagnostic'].replace('UI56 F/G:','UI57 F/G:').replace('Hotfix04 F/G:','Hotfix05 F/G:')
    body=body.replace('    if GetLocalPlayer()==owner then','    if GetLocalPlayer()==owner then\n        call DisplayTimedTextToPlayer(owner,0,0,60,"Native item clicks="+I2S(NativeGearClickCount)+" waiting="+I2S(NativeGearWaiting)+" bound="+QuickGear_Bool(ForsakenInventoryHero==hero))',1)
    source=put(source,'QuickGear_Diagnostic',body)
    assert 'QuickGearTargetPreview' not in source and 'QuickGearTargetImage' not in source
    return source

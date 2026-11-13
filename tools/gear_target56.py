"""Visible unit targeting, focus recovery and selected primary active binding."""
from pathlib import Path
import re
from jtok import functions
from performance_runtime import put

ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'QuickGear_Request' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/GearTarget56.j').read_text()
    declarations=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
    source=source.replace('endglobals',declarations+'endglobals',1)
    helpers=functions(fragment)
    source=source.replace('function QuickGear_Receive takes',helpers['QuickGear_RecordSpell']+'\n\n'+helpers['QuickGear_BindWeaponCast']+'\n\nfunction QuickGear_Receive takes',1)
    source=source.replace('function QuickGear_WheelTick takes',helpers['QuickGear_FocusReset']+'\n\nfunction QuickGear_WheelTick takes',1)
    body=fs['QuickGear_InitPreviews']
    marker='    local integer index=1'
    body=body.replace(marker,marker+'''
    set QuickGearTargetImage=CreateImage("ReplaceableTextures\\\\Selection\\\\SpellAreaOfEffect.blp",128.,128.,0.,0.,0.,0.,0.,0.,0.,1)
    if QuickGearTargetImage!=null and GetHandleId(QuickGearTargetImage)!=-1 then
        call SetImageRenderAlways(QuickGearTargetImage,false)
        call ShowImage(QuickGearTargetImage,false)
        call SetImageAboveWater(QuickGearTargetImage,true,true)
    endif''',1)
    source=put(source,'QuickGear_InitPreviews',body)
    body=fs['QuickGear_ClearPreview'].replace('    set QuickGearPreview=0','''    set QuickGearTargetPreview=false
    if QuickGearTargetImage!=null and GetHandleId(QuickGearTargetImage)!=-1 then
        call SetImageRenderAlways(QuickGearTargetImage,false)
        call ShowImage(QuickGearTargetImage,false)
    endif
    set QuickGearPreview=0''',1)
    source=put(source,'QuickGear_ClearPreview',body)
    body=fs['QuickGear_MovePreview'].replace(' returns nothing\n',' returns nothing\n    local unit focus=null\n    local real x=QuickGearMouseX\n    local real y=QuickGearMouseY\n',1)
    body=body.replace('endfunction','''    if QuickGearTargetPreview and QuickGearMouseKnown and not InventoryCinematicActive then
        set focus=BlzGetMouseFocusUnit()
        if focus!=null then
            set x=GetUnitX(focus)
            set y=GetUnitY(focus)
        endif
        if QuickGearTargetImage!=null and GetHandleId(QuickGearTargetImage)!=-1 then
            call SetImagePosition(QuickGearTargetImage,x-64.,y-64.,0.)
            call SetImageRenderAlways(QuickGearTargetImage,true)
            call ShowImage(QuickGearTargetImage,true)
        endif
    endif
    set focus=null
endfunction''',1)
    source=put(source,'QuickGear_MovePreview',body)
    body=fs['QuickGear_Request']
    marker='            if LoadInteger(QuickGearData,1,raw)>=2 then'
    assert body.count(marker)==1
    body=body.replace(marker,'''            if LoadInteger(QuickGearData,1,raw)==1 then
                set QuickGearTargetPreview=true
                call QuickGear_MovePreview()
            elseif LoadInteger(QuickGearData,1,raw)>=2 then''',1)
    source=put(source,'QuickGear_Request',body)
    body=fs['QuickGear_Reset'];marker='    call QuickGear_ClearPreview()'
    body=body.replace(marker,marker+'''
    if QuickGearTargetImage!=null and GetHandleId(QuickGearTargetImage)!=-1 then
        call DestroyImage(QuickGearTargetImage)
    endif
    set QuickGearTargetImage=null''',1)
    source=put(source,'QuickGear_Reset',body)
    body=fs['QuickGear_WheelTick'];marker='    // Once -gearhotkey'
    assert marker in body
    body=body.replace(marker,'''    if not QuickGear_FocusReset() then
        return
    endif
'''+marker,1)
    source=put(source,'QuickGear_WheelTick',body)
    body=fs['QuickGear_Receive'];marker='        if mode==0 then'
    assert body.count(marker)==1
    body=body.replace(marker,'''        set QuickGearExpectedSpell[GetPlayerId(owner)]=cast
        if slot==0 and mode==1 and not QuickGear_BindWeaponCast(carried,cast) then
            set carried=null
            set hero=null
            set owner=null
            set target=null
            set candidate=null
            return
        endif
'''+marker,1)
    source=put(source,'QuickGear_Receive',body)
    body=fs['QuickGear_InitDiagnostics'];marker='    set QuickGearDiagnostics=CreateTrigger()'
    body=body.replace(marker,marker+'''
    if QuickGearSpellObserver==null then
        set QuickGearSpellObserver=CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(QuickGearSpellObserver,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddAction(QuickGearSpellObserver,function QuickGear_RecordSpell)
    endif''',1)
    source=put(source,'QuickGear_InitDiagnostics',body)
    body=fs['QuickGear_Diagnostic'];marker='        set slot=slot+1'
    body=body.replace('UI55 F/G:','UI56 F/G:').replace('Hotfix04 F/G:','Hotfix04 F/G:')
    # A single line distinguishes expected lookup from the engine's actual spell.
    line='        call DisplayTimedTextToPlayer(owner,0,0,60,"Spell expected="+I2S(QuickGearExpectedSpell[pid])+" actual="+I2S(QuickGearActualSpell[pid]))\n'
    body=body.replace('    if GetLocalPlayer()==owner then','    if GetLocalPlayer()==owner then\n'+line,1)
    return put(source,'QuickGear_Diagnostic',body)

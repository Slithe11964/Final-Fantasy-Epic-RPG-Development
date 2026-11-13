"""End native aiming on its spell event, not incidental clicks or other effects."""
from jtok import functions
from performance_runtime import put

LOG='''function Preview_LogClear68 takes string reason returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    if GearWaveMode>0 then
        if QuickGearChatOpen then
            set reason=reason+" chat"
        endif
        if InventoryCinematicActive then
            set reason=reason+" cinematic"
        endif
        if not BlzIsLocalClientActive() then
            set reason=reason+" unfocused"
        endif
        if hero==null then
            set reason=reason+" no-hero"
        elseif not IsUnitSelected(hero,GetLocalPlayer()) then
            set reason=reason+" deselected"
        endif
        set PreviewLastClear68=reason
        set PreviewLastSpell68=GearWaveCast67
    endif
    set hero=null
endfunction'''

def refresh(source):
    fs=functions(source)
    if 'GearInput_Cursor' not in fs:return source
    source=source.replace('endglobals','    string PreviewLastClear68="none"\n    integer PreviewLastSpell68=0\nendglobals',1)
    source=source.replace('function GearWave_Clear takes',LOG+'\n\nfunction GearWave_Clear takes',1)
    body=fs['QuickGear_Mouse']
    old='BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT or ((BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0.) and TimerGetElapsed(NativeCDClock)-GearInputArmedAt>.08)'
    assert old in body
    body=body.replace(old,'BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT')
    source=put(source,'QuickGear_Mouse',body)
    body=fs['BagScreen_Click66'].replace('    local integer cast=0',
        '    local integer cast=0\n    local boolean wasAiming=GearWaveMode>0 or QuickGearPending>=0',1)
    body=body.replace('        if BagHoverSlot64>=0 and not BagMoving64 then',
        '''        if wasAiming then
            // Right click cancels native targeting before it can pick up items.
            set BagMoving64=false
            set BagCarried66=null
            set BagSourceSlot66=-1
            set BagMovedAt66=-100.
        elseif BagHoverSlot64>=0 and not BagMoving64 then''',1)
    source=put(source,'BagScreen_Click66',body)
    source=put(source,'QuickGear_RecordSpell','''function QuickGear_RecordSpell takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    if pid>=0 and pid<8 and hero==Player_GetHero(GetOwningPlayer(hero)) then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_EFFECT then
            set QuickGearActualSpell[pid]=GetSpellAbilityId()
        endif
        if GetLocalPlayer()==GetOwningPlayer(hero) then
            // Native aim ends only when this spell starts. Unrelated triggered
            // effects on the hero cannot dismiss an armed wave preview.
            if GearWaveMode==0 or GetSpellAbilityId()==GearWaveCast67 then
                call Preview_LogClear68("spell-start/effect")
                call ExecuteFunc("QuickGear_ClearPreview")
            endif
        endif
    endif
    set hero=null
endfunction''')
    body=fs['QuickGear_InitDiagnostics'].replace(
        '        call TriggerRegisterAnyUnitEventBJ(QuickGearSpellObserver,EVENT_PLAYER_UNIT_SPELL_EFFECT)',
        '        call TriggerRegisterAnyUnitEventBJ(QuickGearSpellObserver,EVENT_PLAYER_UNIT_SPELL_CHANNEL)\n        call TriggerRegisterAnyUnitEventBJ(QuickGearSpellObserver,EVENT_PLAYER_UNIT_SPELL_EFFECT)')
    source=put(source,'QuickGear_InitDiagnostics',body)
    current=functions(source)
    for name in ['QuickGear_Mouse','QuickGear_Poll','QuickGear_FocusReset','GearInput_Poll','Wave65_Draw','GearWave_CancelKey','BagScreen_Click66']:
        body=current[name]
        for call in ['call GearWave_Clear()','call QuickGear_ClearPreview()']:
            body=body.replace(call,'call Preview_LogClear68("'+name+'")\n        '+call)
        source=put(source,name,body)
    body=fs['QuickGear_Diagnostic'].replace('UI67 F/G:','UI68 F/G:').replace('Hotfix15 F/G:','Hotfix16 F/G:')
    body=body.replace('    if GetLocalPlayer()==owner then',
        '    if GetLocalPlayer()==owner then\n        call DisplayTimedTextToPlayer(owner,0,0,60,"Last wave clear="+PreviewLastClear68+" spell="+I2S(PreviewLastSpell68))',1)
    return put(source,'QuickGear_Diagnostic',body)

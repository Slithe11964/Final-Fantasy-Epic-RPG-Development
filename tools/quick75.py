"""Native six-slot hero/Gaya clicks can arm existing water/ice previews."""
from jtok import functions
from performance_runtime import put

GLOBALS='''    unit Preview75Caster=null
    framehandle Preview75Button=null
'''
HELPERS='''function Preview75_Selected takes nothing returns unit
    local player viewer=GetLocalPlayer()
    local unit hero=Player_GetHero(viewer)
    local unit gaya=udg_SpiritOfGaya[GetPlayerId(viewer)+1]
    if ForsakenSelectedTarget!=null and (ForsakenSelectedTarget==hero or ForsakenSelectedTarget==gaya) and IsUnitSelected(ForsakenSelectedTarget,viewer) then
        set hero=ForsakenSelectedTarget
    elseif hero!=null and IsUnitSelected(hero,viewer) then
        // Normal hero selection.
    elseif gaya!=null and IsUnitSelected(gaya,viewer) then
        set hero=gaya
    else
        set hero=null
    endif
    set gaya=null
    set viewer=null
    return hero
endfunction

function Preview75_Source takes integer slot returns unit
    if slot>=200 and slot<206 then
        return Preview75_Selected()
    endif
    return Player_GetHero(GetLocalPlayer())
endfunction

function Preview75_QuickVisible takes nothing returns boolean
    local unit caster=Preview75_Selected()
    local boolean show=caster!=null and GetUnitTypeId(caster)!=0 and UnitInventorySize(caster)>=6 and not QuickGearChatOpen and not InventoryCinematicActive and BlzIsLocalClientActive()
    if show then
        set show=Preview75Button!=null and BlzFrameIsVisible(Preview75Button)
    endif
    set caster=null
    return show
endfunction

function Preview75_QuickSlot takes real x,real y returns integer
    local real scale=BlzFrameGetWidth(Preview75Button)/.03125
    local real left=(BlzPixelToFrameX(0)+BlzPixelToFrameX(BlzGetLocalClientWidth())-BlzFrameGetWidth(BagConsole65))/2.
    local real bottom=BlzPixelToFrameY(BlzGetLocalClientHeight())
    local real top=0.
    local real slotLeft=0.
    local integer slot=0
    if scale<=0. then
        return -1
    endif
    // Native two-column inventory: .03125 buttons, .04/.03815 spacing.
    set left=left+.4907*scale
    set top=bottom+.1179*scale
    loop
        exitwhen slot>=6
        set slotLeft=left+.04*I2R(ModuloInteger(slot,2))*scale
        set bottom=top-.03815*I2R(slot/2)*scale
        if x>=slotLeft and x<slotLeft+.03125*scale and y<=bottom and y>bottom-.03125*scale then
            return 200+slot
        endif
        set slot=slot+1
    endloop
    return -1
endfunction
'''

def refresh(source):
    fs=functions(source)
    if 'BagScreen_Update66' not in fs:return source
    assert 'Preview75_Selected' not in fs
    source=source.replace('endglobals',GLOBALS+'endglobals',1)
    source=source.replace('function GearWave_Clear takes',HELPERS+'\nfunction GearWave_Clear takes',1)
    name='Wave65_Draw';body=fs[name]
    body=body.replace('local unit hero=Player_GetHero(GetLocalPlayer())','local unit hero=Preview75Caster',1)
    body=body.replace('if hero==null or not IsUnitSelected','if hero==null or GetUnitTypeId(hero)==0 or not IsUnitSelected',1)
    source=put(source,name,body)
    name='BagCast_Init63';body=fs[name]
    body=body.replace('    set BagConsole65=',
        '    set Preview75Button=BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON,0)\n    set BagConsole65=',1)
    source=put(source,name,body)
    name='BagScreen_Item67';body=fs[name]
    body=body.replace('    elseif slot>=0 and slot<30 then',
        '    elseif slot>=200 and slot<206 then\n        return UnitItemInSlot(hero,slot-200)\n    elseif slot>=0 and slot<30 then',1)
    source=put(source,name,body)
    name='BagScreen_Update66';body=fs[name]
    marker='    if BagMoving64 and BagSourceSlot66>=0 and hero!=null then'
    assert marker in body
    body=body.replace(marker,'''    if BagHoverSlot64<0 and BagConsole65!=null and Preview75_QuickVisible() then
        set BagHoverSlot64=Preview75_QuickSlot(mouseX,mouseY)
    endif
'''+marker,1)
    body=body.replace('BagScreen_Item67(hero,BagSourceSlot66)','BagScreen_Item67(Preview75_Source(BagSourceSlot66),BagSourceSlot66)')
    source=put(source,name,body)
    name='BagScreen_Click66';body=fs[name]
    body=body.replace('local unit hero=Player_GetHero(GetLocalPlayer())','local unit hero=Preview75_Source(BagHoverSlot64)',1)
    body=body.replace('            call GearWave_Arm(cast)',
        '            call GearWave_Arm(cast)\n            set Preview75Caster=hero',1)
    source=put(source,name,body)
    name='GearInput_Poll';body=fs[name]
    body=body.replace('if BagMoving64 or (ForsakenLinkedBag!=null',
        'if Preview75_QuickVisible() or BagMoving64 or (ForsakenLinkedBag!=null',1)
    source=put(source,name,body)
    name='GearWave_Arm';body=fs[name]
    body=body.replace('    set UI72WaveNext=0.',
        '    set Preview75Caster=Preview75_Selected()\n    set UI72WaveNext=0.',1)
    source=put(source,name,body)
    name='GearWave_Clear';body=fs[name]
    body=body.replace('    set GearWaveMode=0','    set GearWaveMode=0\n    set Preview75Caster=null',1)
    source=put(source,name,body)
    name='QuickGear_Request';body=fs[name]
    body=body.replace('            call GearWave_Arm(cast)',
        '            call GearWave_Arm(cast)\n            set Preview75Caster=hero',1)
    source=put(source,name,body)
    name='GearWave_CalculatorArm';body=fs[name]
    body=body.replace("        call GearWave_Arm('A17S')","        call GearWave_Arm('A17S')\n        set Preview75Caster=hero",1)
    source=put(source,name,body)
    name='QuickGear_Poll';body=fs[name]
    old='InventoryCinematicActive or not IsUnitSelected(hero,viewer) or'
    new='InventoryCinematicActive or (not IsUnitSelected(hero,viewer) and (GearWaveMode==0 or Preview75Caster==null or not IsUnitSelected(Preview75Caster,viewer))) or'
    assert old in body;source=put(source,name,body.replace(old,new,1))
    source=put(source,'QuickGear_RecordSpell', '''function QuickGear_RecordSpell takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    local player owner=GetOwningPlayer(hero)
    local integer pid=GetPlayerId(owner)
    if pid>=0 and pid<8 then
        if hero==Player_GetHero(owner) and GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_EFFECT then
            set QuickGearActualSpell[pid]=GetSpellAbilityId()
        endif
        if GetLocalPlayer()==owner and (hero==Player_GetHero(owner) or hero==udg_SpiritOfGaya[pid+1]) then
            if (Preview75Caster==hero or (Preview75Caster==null and hero==Player_GetHero(owner))) and (GearWaveMode==0 or GetSpellAbilityId()==GearWaveCast67) then
                set UI73ClearRequested=true
                set UI73ClearRevision=UI73AimRevision
            endif
        endif
    endif
    set owner=null
    set hero=null
endfunction''')
    return source

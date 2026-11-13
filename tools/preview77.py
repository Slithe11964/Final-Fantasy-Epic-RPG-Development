"""Native inventory slot alignment, fresh click state, hero-origin runes."""
from jtok import functions
from performance_runtime import put

GLOBALS='''    integer Preview77Slot=-1
    integer Preview77Raw=0
    integer Preview77Spell=0
'''

def refresh(source):
    fs=functions(source)
    if 'Preview75_QuickSlot' not in fs:return source
    assert 'Preview77Slot' not in source
    source=source.replace('endglobals',GLOBALS+'endglobals',1)
    n='Preview75_QuickSlot';b=fs[n]
    assert 'set left=left+.4907*scale' in b
    # Inventory-bar parent placement is not the decorative inventory cover.
    # Center the columns at .5318 / .5718 in the native console coordinates.
    b=b.replace('set left=left+.4907*scale','set left=left+.516175*scale',1)
    source=put(source,n,b)
    n='BagScreen_Click66';b=fs[n]
    b=b.replace('    local integer cast=0','    local integer cast=0\n    local integer raw=0',1)
    old='''    elseif TimerGetElapsed(NativeCDClock)-BagMovedAt66<.12 then
        set cast=0
    elseif BagMoving64 then'''
    assert old in b
    b=b.replace(old,'    elseif BagMoving64 then',1)
    old='''        set cast=BagCast_Spell63(GetItemTypeId(BagScreen_Item67(hero,BagHoverSlot64)))
        if cast!=0 then
            set QuickGearPending=-1
            call Preview_LogClear68("BagScreen_Click66")
        call QuickGear_ClearPreview()
            call GearWave_Arm(cast)'''
    new='''        set raw=GetItemTypeId(BagScreen_Item67(hero,BagHoverSlot64))
        set cast=BagCast_Spell63(raw)
        set Preview77Slot=BagHoverSlot64
        set Preview77Raw=raw
        set Preview77Spell=cast
        // Every new inventory activation replaces the previous item's visual.
        // A missing/unsupported slot must not leave an older water path armed.
        set QuickGearPending=-1
        call Preview_LogClear68("new inventory click")
        call QuickGear_ClearPreview()
        if cast!=0 then
            call GearWave_Arm(cast)'''
    assert old in b
    source=put(source,n,b.replace(old,new,1))
    # Keep Preview75Caster as the actual native item holder for selection and
    # cast-end notices, while all wave geometry uses the player's loaded hero.
    n='Wave65_Draw';b=fs[n]
    assert 'local unit hero=Preview75Caster' in b
    b=b.replace('local unit hero=Preview75Caster','local unit hero=Player_GetHero(GetLocalPlayer())',1)
    b=b.replace('or not IsUnitSelected(hero,GetLocalPlayer())','or Preview75Caster==null or GetUnitTypeId(Preview75Caster)==0 or not IsUnitSelected(Preview75Caster,GetLocalPlayer())',1)
    source=put(source,n,b)
    n='QuickGear_Diagnostic';b=fs[n]
    b=b.replace('    if GetLocalPlayer()==owner then','''    if GetLocalPlayer()==owner then
        call DisplayTimedTextToPlayer(owner,0,0,60,"Last native item click: slot="+I2S(Preview77Slot)+" raw="+I2S(Preview77Raw)+" spell="+I2S(Preview77Spell)+" active="+I2S(GearWaveCast67)+" mode="+I2S(GearWaveMode))''',1)
    source=put(source,n,b)
    return source

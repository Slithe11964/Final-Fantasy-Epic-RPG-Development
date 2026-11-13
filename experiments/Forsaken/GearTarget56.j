globals
    image QuickGearTargetImage=null
    boolean QuickGearTargetPreview=false
    boolean QuickGearClientActive=true
    trigger QuickGearSpellObserver=null
    integer array QuickGearExpectedSpell
    integer array QuickGearActualSpell
endglobals

function QuickGear_FocusReset takes nothing returns boolean
    local boolean active=BlzIsLocalClientActive()
    if active!=QuickGearClientActive then
        set QuickGearClientActive=active
        set QuickGearChatOpen=false
        set QuickGearPending=-1
        set QuickGearHeld[0]=false
        set QuickGearHeld[1]=false
        set QuickGearLastPress[0]=-1.
        set QuickGearLastPress[1]=-1.
        call QuickGear_ClearPreview()
    endif
    return active
endfunction

function QuickGear_RecordSpell takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    if pid<8 and hero==Player_GetHero(GetOwningPlayer(hero)) then
        set QuickGearActualSpell[pid]=GetSpellAbilityId()
    endif
    set hero=null
endfunction

function QuickGear_BindWeaponCast takes item carried,integer cast returns boolean
    // Rebind the selected primary item's active ability only. No item leaves
    // its slot and no passive ability, charge, ownership or userdata is edited.
    if BlzGetItemAbility(carried,cast)==null then
        return false
    endif
    if not BlzItemRemoveAbility(carried,cast) then
        return false
    endif
    return BlzItemAddAbility(carried,cast)
endfunction

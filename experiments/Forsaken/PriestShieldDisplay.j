// Created/updated from shared gameplay events, with visibility private to owners.
function Talent_ShieldDisplayClear takes unit target returns nothing
    local integer key=GetHandleId(target)
    local texttag label=LoadTextTagHandle(TalentShieldState,key,2)
    local effect barrier=LoadEffectHandle(TalentShieldState,key,4)
    if label!=null then
        call DestroyTextTag(label)
        call RemoveSavedHandle(TalentShieldState,key,2)
    endif
    if barrier!=null then
        call DestroyEffect(barrier)
        call RemoveSavedHandle(TalentShieldState,key,4)
    endif
    set barrier=null
    call GroupRemoveUnit(TalentShieldDisplayGroup,target)
    set label=null
endfunction

function Talent_ShieldDisplayUnit takes nothing returns nothing
    local unit target=GetEnumUnit()
    local real amount=LoadReal(TalentShieldState,GetHandleId(target),0)
    local texttag label=LoadTextTagHandle(TalentShieldState,GetHandleId(target),2)
    if amount<=0. or GetWidgetLife(target)<=.405 or GetUnitTypeId(target)==0 then
        call Talent_ShieldDisplayClear(target)
    elseif label!=null then
        call SetTextTagText(label,"Shield: "+I2S(R2I(amount+.5)),.020)
        call SetTextTagPos(label,GetUnitX(target)-180.,GetUnitY(target)+80.,GetUnitFlyHeight(target)+155.)
        call SetTextTagVisibility(label,GetLocalPlayer()==GetOwningPlayer(target) and IsUnitVisible(target,GetLocalPlayer()) and not IsUnitHidden(target))
    endif
    set target=null
    set label=null
endfunction

function Talent_ShieldDisplayTick takes nothing returns nothing
    call ForGroup(TalentShieldDisplayGroup,function Talent_ShieldDisplayUnit)
    if FirstOfGroup(TalentShieldDisplayGroup)==null then
        call PauseTimer(TalentShieldDisplayTimer)
    endif
endfunction

function Talent_ShieldDisplayUpdate takes unit target returns nothing
    local integer key=GetHandleId(target)
    local texttag label=LoadTextTagHandle(TalentShieldState,key,2)
    local effect barrier=LoadEffectHandle(TalentShieldState,key,4)
    if LoadReal(TalentShieldState,key,0)<=0. then
        call Talent_ShieldDisplayClear(target)
    else
        if barrier==null then
            set barrier=AddSpecialEffectTarget("Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl",target,"origin")
            call SaveEffectHandle(TalentShieldState,key,4,barrier)
        endif
        if label==null then
            set label=CreateTextTag()
            call SaveTextTagHandle(TalentShieldState,key,2,label)
            call SetTextTagPermanent(label,true)
            call SetTextTagColor(label,255,215,0,255)
            call SetTextTagText(label,"Shield: "+I2S(R2I(LoadReal(TalentShieldState,key,0)+.5)),.020)
            call SetTextTagPos(label,GetUnitX(target)-180.,GetUnitY(target)+80.,GetUnitFlyHeight(target)+155.)
            call SetTextTagVisibility(label,GetLocalPlayer()==GetOwningPlayer(target) and IsUnitVisible(target,GetLocalPlayer()) and not IsUnitHidden(target))
        endif
        if FirstOfGroup(TalentShieldDisplayGroup)==null then
            call TimerStart(TalentShieldDisplayTimer,.1,true,function Talent_ShieldDisplayTick)
        endif
        call GroupAddUnit(TalentShieldDisplayGroup,target)
    endif
    set barrier=null
    set label=null
endfunction

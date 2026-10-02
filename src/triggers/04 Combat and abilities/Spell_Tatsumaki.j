library TSpellTatsumaki requires TAbil, TCombatFormulas, TFilter, TProf
globals
    // Variables only this module uses.
    constant real udg_TatsumakiDuration=25
    timer udg_TatsumakiTimer=CreateTimer()
    integer udg_TatsumakiRecycle=0
    integer udg_TatsumakiCount=0
    integer array udg_TatsumakiNext
    integer array udg_TatsumakiTicks
endglobals

function Trig_Spell_Tatsumaki_FireTickEvent takes integer l_idx returns nothing
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_TatsumakiPullTrig)
endfunction

function Trig_Spell_Tatsumaki_FireEndEvent takes integer l_idx returns nothing
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_TatsumakiStompTrig)
endfunction

function Trig_Spell_Tatsumaki_Alloc takes nothing returns integer
    local integer l_idx=udg_TatsumakiRecycle
    if(l_idx!=0)then
        set udg_TatsumakiRecycle=udg_TatsumakiNext[l_idx]
    else
        set udg_TatsumakiCount=udg_TatsumakiCount+1
        set l_idx=udg_TatsumakiCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_TatsumakiTicks[l_idx]=0
    set udg_TatsumakiHitTick[l_idx]=false
    set udg_TatsumakiNext[l_idx]=-1
    return l_idx
endfunction

function Trig_Spell_Tatsumaki_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_TatsumakiNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_TatsumakiRemoveTrig)
    set udg_TatsumakiNext[l_idx]=udg_TatsumakiRecycle
    set udg_TatsumakiRecycle=l_idx
endfunction

function Trig_Spell_Tatsumaki_Loop takes nothing returns nothing
    local integer d
    local integer i=0
    loop
        exitwhen i>=udg_TatsumakiActiveCount
        set d=udg_TatsumakiList[i]
        set udg_TatsumakiTicks[d]=udg_TatsumakiTicks[d]+1
        set udg_TatsumakiHitTick[d]=not udg_TatsumakiHitTick[d]
        if udg_TatsumakiTicks[d]>=udg_TatsumakiDuration then
            call Trig_Spell_Tatsumaki_FireEndEvent(d)
            call Trig_Spell_Tatsumaki_Free(d)
        else
            call Trig_Spell_Tatsumaki_FireTickEvent(d)
        endif
        set i=i+1
    endloop
    if udg_TatsumakiActiveCount==0 then
        call PauseTimer(udg_TatsumakiTimer)
    endif
endfunction

function Trig_Spell_Tatsumaki_Start takes unit c returns integer
    local integer d=Trig_Spell_Tatsumaki_Alloc()
    set udg_TatsumakiCaster[d]=c
    set udg_TatsumakiOwner[d]=GetOwningPlayer(udg_TatsumakiCaster[d])
    if udg_TatsumakiActiveCount==0 then
        call TimerStart(udg_TatsumakiTimer,.03,true,function Trig_Spell_Tatsumaki_Loop)
    endif
    set udg_TatsumakiList[udg_TatsumakiActiveCount]=d
    set udg_TatsumakiIndex[d]=udg_TatsumakiActiveCount
    set udg_TatsumakiActiveCount=udg_TatsumakiActiveCount+1
    return d
endfunction

function Trig_Spell_Tatsumaki_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A18H' or GetSpellAbilityId()=='A1AT') // 'A18H': ability "Tatsumaki"; 'A1AT': ability "Tatsumaki"
endfunction

function Trig_Spell_Tatsumaki_Actions takes nothing returns nothing
    local integer d=Trig_Spell_Tatsumaki_Start(GetTriggerUnit())
    local real damageAmount=Trig_Spell_Tatsumaki_DamageFormula(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(udg_TatsumakiCaster[d],GetSpellAbilityId())),GetHeroStr(udg_TatsumakiCaster[d],true),GetHeroAgi(udg_TatsumakiCaster[d],true),Prof_GetLevel(udg_TatsumakiCaster[d],'R00A')) // 'R00A': upgrade "Katana"
    // (damage) times (0.1).
    set udg_TatsumakiTickDamage[d]=damageAmount*.1
    set udg_TatsumakiStompDamage[d]=damageAmount
endfunction

// Owns event registration, filters, and preloads for Spell_Tatsumaki.
// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).
function RegisterLegacy_Spell_Tatsumaki takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Spell_Tatsumaki_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Spell_Tatsumaki_Actions)
    set udg_TatsumakiFilter=Condition(function Filter_ValidUnit)
    call Preload("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
endfunction

function InitTrig_Spell_Tatsumaki takes nothing returns nothing
endfunction

endlibrary

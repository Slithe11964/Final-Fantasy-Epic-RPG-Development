library TSpellLiquidSteel requires TAbil, TCombatFormulas, TFilter, TProf
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    timer udg_LiquidSteelTimer=CreateTimer()
    boolexpr udg_LiquidSteelFilter
    integer udg_LiquidSteelRecycle=0
    integer udg_LiquidSteelCount=0
    integer array udg_LiquidSteelNext
    unit array udg_LiquidSteelCaster
    unit array udg_LiquidSteelTarget
    unit array udg_LiquidSteelPrevTarget
    real array udg_LiquidSteelDmg
    real array udg_LiquidSteelX
    real array udg_LiquidSteelY
    integer array udg_LiquidSteelBounces
    integer array udg_LiquidSteelDelay
    player array udg_LiquidSteelOwner
    group udg_LiquidSteelGroup=CreateGroup()
endglobals

// ---- Spell ----
function Trig_Spell_LiquidSteel_Alloc takes nothing returns integer
    local integer l_idx=udg_LiquidSteelRecycle
    if(l_idx!=0)then
        set udg_LiquidSteelRecycle=udg_LiquidSteelNext[l_idx]
    else
        set udg_LiquidSteelCount=udg_LiquidSteelCount+1
        set l_idx=udg_LiquidSteelCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_LiquidSteelDelay[l_idx]=0
    set udg_LiquidSteelNext[l_idx]=-1
    return l_idx
endfunction

function Trig_Spell_LiquidSteel_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_LiquidSteelNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_LiquidSteelRemoveTrig)
    set udg_LiquidSteelNext[l_idx]=udg_LiquidSteelRecycle
    set udg_LiquidSteelRecycle=l_idx
endfunction

function Trig_Spell_LiquidSteel_Loop takes nothing returns nothing
    local integer d
    local integer i=0
    local real l_ang
    local real dx
    local real dy
    local real l_distSq
    loop
        exitwhen i>=udg_LiquidSteelActiveCount
        set d=udg_LiquidSteelList[i]
        if udg_LiquidSteelBounces[d]<=0 then
            call Trig_Spell_LiquidSteel_Free(d)
        elseif(udg_LiquidSteelTarget[d]!=udg_LiquidSteelPrevTarget[d])then
            // (x position of udg_LiquidSteelTarget at position d) minus (udg_LiquidSteelX at position d).
            set dx=GetUnitX(udg_LiquidSteelTarget[d])-udg_LiquidSteelX[d]
            // (y position of udg_LiquidSteelTarget at position d) minus (udg_LiquidSteelY at position d).
            set dy=GetUnitY(udg_LiquidSteelTarget[d])-udg_LiquidSteelY[d]
            // The angle in radians from the y gap (dy) and x gap (dx).
            set l_ang=Atan2(dy,dx)
            // (udg_LiquidSteelX at position d) plus ((50) times (the horizontal direction share for angle (l_ang) in
            // radians)).
            set udg_LiquidSteelX[d]=udg_LiquidSteelX[d]+50.*Cos(l_ang)
            // (udg_LiquidSteelY at position d) plus ((50) times (the vertical direction share for angle (l_ang) in
            // radians)).
            set udg_LiquidSteelY[d]=udg_LiquidSteelY[d]+50.*Sin(l_ang)
            // (the square of (dx)) plus (the square of (dy)).
            set l_distSq=(dx*dx)+(dy*dy)
            if(l_distSq<10000.)then
                set udg_LiquidSteelPrevTarget[d]=udg_LiquidSteelTarget[d]
                set i=i-1
            endif
            call SetUnitX(gg_unit_h020_0272[d],udg_LiquidSteelX[d])
            call SetUnitY(gg_unit_h020_0272[d],udg_LiquidSteelY[d])
        elseif(udg_LiquidSteelDelay[d]<=0)then
            set udg_LiquidSteelBounces[d]=udg_LiquidSteelBounces[d]-1
            call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",udg_LiquidSteelX[d],udg_LiquidSteelY[d]))
            set udg_IsPhysicalAttack=true
            set udg_DamageElement=4
            call UnitDamageTarget(udg_LiquidSteelCaster[d],udg_LiquidSteelTarget[d],udg_LiquidSteelDmg[d],true,true,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,null)
            set udg_FilterOwner=udg_LiquidSteelOwner[d]
            call GroupEnumUnitsInRange(udg_LiquidSteelGroup,udg_LiquidSteelX[d],udg_LiquidSteelY[d],600.,udg_LiquidSteelFilter)
            call GroupRemoveUnit(udg_LiquidSteelGroup,udg_LiquidSteelPrevTarget[d])
            set udg_LiquidSteelTarget[d]=GroupPickRandomUnit(udg_LiquidSteelGroup)
            if(udg_LiquidSteelTarget[d]==null)then
                set udg_LiquidSteelTarget[d]=udg_LiquidSteelPrevTarget[d]
                set udg_LiquidSteelX[d]=GetUnitX(udg_LiquidSteelTarget[d])
                set udg_LiquidSteelY[d]=GetUnitY(udg_LiquidSteelTarget[d])
                set udg_LiquidSteelDelay[d]=20
            else
                set udg_LiquidSteelDelay[d]=3
                // (x position of udg_LiquidSteelTarget at position d) minus (udg_LiquidSteelX at position d).
                set dx=GetUnitX(udg_LiquidSteelTarget[d])-udg_LiquidSteelX[d]
                // (y position of udg_LiquidSteelTarget at position d) minus (udg_LiquidSteelY at position d).
                set dy=GetUnitY(udg_LiquidSteelTarget[d])-udg_LiquidSteelY[d]
                // The angle in radians from the y gap (dy) and x gap (dx).
                set l_ang=Atan2(dy,dx)
                // (udg_LiquidSteelX at position d) plus ((50) times (the horizontal direction share for angle (l_ang) in
                // radians)).
                set udg_LiquidSteelX[d]=udg_LiquidSteelX[d]+50.*Cos(l_ang)
                // (udg_LiquidSteelY at position d) plus ((50) times (the vertical direction share for angle (l_ang) in
                // radians)).
                set udg_LiquidSteelY[d]=udg_LiquidSteelY[d]+50.*Sin(l_ang)
                call SetUnitFacing(gg_unit_h020_0272[d],l_ang)
            endif
            call SetUnitX(gg_unit_h020_0272[d],udg_LiquidSteelX[d])
            call SetUnitY(gg_unit_h020_0272[d],udg_LiquidSteelY[d])
        else
            set udg_LiquidSteelDelay[d]=udg_LiquidSteelDelay[d]-1
            // (20) divided by (2); drop the remainder.
            if(udg_LiquidSteelDelay[d]==20/ 2)then
                // Decrease udg_LiquidSteelBounces at position d by 3.
                set udg_LiquidSteelBounces[d]=udg_LiquidSteelBounces[d]-3
                set udg_IsPhysicalAttack=true
                set udg_DamageElement=4
                call UnitDamageTarget(udg_LiquidSteelCaster[d],udg_LiquidSteelTarget[d],udg_LiquidSteelDmg[d],true,true,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,null)
                call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",udg_LiquidSteelX[d],udg_LiquidSteelY[d]))
            endif
            set udg_LiquidSteelX[d]=GetUnitX(udg_LiquidSteelTarget[d])
            set udg_LiquidSteelY[d]=GetUnitY(udg_LiquidSteelTarget[d])
            call SetUnitX(gg_unit_h020_0272[d],udg_LiquidSteelX[d])
            call SetUnitY(gg_unit_h020_0272[d],udg_LiquidSteelY[d])
        endif
        set i=i+1
    endloop
    if udg_LiquidSteelActiveCount==0 then
        call PauseTimer(udg_LiquidSteelTimer)
    endif
endfunction

function Trig_Spell_LiquidSteel_Start takes unit c,unit t returns integer
    local integer d=Trig_Spell_LiquidSteel_Alloc()
    set udg_LiquidSteelCaster[d]=c
    set udg_LiquidSteelTarget[d]=t
    set udg_LiquidSteelPrevTarget[d]=c
    set udg_LiquidSteelOwner[d]=GetOwningPlayer(udg_LiquidSteelCaster[d])
    if udg_LiquidSteelActiveCount==0 then
        call TimerStart(udg_LiquidSteelTimer,.03,true,function Trig_Spell_LiquidSteel_Loop)
    endif
    set udg_LiquidSteelList[udg_LiquidSteelActiveCount]=d
    set udg_LiquidSteelIndex[d]=udg_LiquidSteelActiveCount
    set udg_LiquidSteelActiveCount=udg_LiquidSteelActiveCount+1
    return d
endfunction

function Trig_Spell_LiquidSteel_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QH' or GetSpellAbilityId()=='A01Q') // 'A0QH': ability "Liquid Steel"; 'A01Q': ability "Liquid Steel"
endfunction

function Trig_Spell_LiquidSteel_Actions takes nothing returns nothing
    local integer d=Trig_Spell_LiquidSteel_Start(GetTriggerUnit(),GetSpellTargetUnit())
    local integer abilityLevel=GetUnitAbilityLevel(udg_LiquidSteelCaster[d],'A0QH') // 'A0QH': ability "Liquid Steel"
    // Starting value for l_facing:
    // Result 1: (y position of udg_LiquidSteelTarget at position d) minus (y position of udg_LiquidSteelCaster at
    // position d).
    // Result 2: (x position of udg_LiquidSteelTarget at position d) minus (x position of udg_LiquidSteelCaster at
    // position d).
    // Result 3: the angle in radians from the y gap (result 1) and x gap (result 2).
    local real l_facing=Atan2(GetUnitY(udg_LiquidSteelTarget[d])-GetUnitY(udg_LiquidSteelCaster[d]),GetUnitX(udg_LiquidSteelTarget[d])-GetUnitX(udg_LiquidSteelCaster[d]))
    if(GetSpellAbilityId()=='A01Q')then // 'A01Q': ability "Liquid Steel"
        set udg_LiquidSteelBounces[d]=$A // $A = 10
    elseif(abilityLevel>=$B)then // $B = 11
        set udg_LiquidSteelBounces[d]=$F // $F = 15
    else
        // (abilityLevel) plus (2).
        set udg_LiquidSteelBounces[d]=abilityLevel+2
    endif
    set udg_LiquidSteelDmg[d]=Trig_Spell_LiquidSteel_DamageFormula(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(udg_LiquidSteelCaster[d],GetSpellAbilityId())),GetHeroStr(udg_LiquidSteelCaster[d],true),GetHeroInt(udg_LiquidSteelCaster[d],true),Prof_GetHybridLevel(udg_LiquidSteelCaster[d]))
    // Result 1: the horizontal direction share for angle (l_facing) in radians.
    // Result 2: (50) times (result 1).
    // Result 3: (x position of udg_LiquidSteelCaster at position d) plus (result 2).
    set udg_LiquidSteelX[d]=GetUnitX(udg_LiquidSteelCaster[d])+50.*Cos(l_facing)
    // Result 1: the vertical direction share for angle (l_facing) in radians.
    // Result 2: (50) times (result 1).
    // Result 3: (y position of udg_LiquidSteelCaster at position d) plus (result 2).
    set udg_LiquidSteelY[d]=GetUnitY(udg_LiquidSteelCaster[d])+50.*Sin(l_facing)
    set gg_unit_h020_0272[d]=CreateUnit(udg_LiquidSteelOwner[d],'h020',udg_LiquidSteelX[d],udg_LiquidSteelY[d],l_facing) // 'h020': unit "Dummy Missile"
    set udg_LiquidSteelEffect[d]=AddSpecialEffectTarget("Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl",gg_unit_h020_0272[d],"chest")
endfunction

// Owns event registration, filters, and preloads for Spell_LiquidSteel.
// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).
function RegisterLegacy_Spell_LiquidSteel takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Spell_LiquidSteel_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Spell_LiquidSteel_Actions)
    set udg_LiquidSteelFilter=Condition(function Filter_EnemyOfOwner)
    call Preload("Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call Preload("Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl")
endfunction

function InitTrig_Spell_LiquidSteel takes nothing returns nothing
endfunction

endlibrary

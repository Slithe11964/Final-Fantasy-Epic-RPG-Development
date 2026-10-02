library TBossVerc requires TFilter
function Trig_Boss_Verc_WickedWhirl_DamageGroup takes integer l_idx returns nothing
    local unit u
    loop
        set u=FirstOfGroup(udg_WickedWhirlGroup)
        exitwhen u==null
        call GroupRemoveUnit(udg_WickedWhirlGroup,u)
        set udg_DamageElement=1
        call UnitDamageTarget(udg_WickedWhirlCaster[l_idx],u,7500.,true,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,null)
    endloop
endfunction

function Trig_Boss_Verc_WickedWhirl_Alloc takes nothing returns integer
    local integer l_idx=udg_WickedWhirlRecycle
    if(l_idx!=0)then
        set udg_WickedWhirlRecycle=udg_WickedWhirlNext[l_idx]
    else
        set udg_WickedWhirlCount=udg_WickedWhirlCount+1
        set l_idx=udg_WickedWhirlCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_WickedWhirlTicks[l_idx]=0
    set udg_WickedWhirlNext[l_idx]=-1
    return l_idx
endfunction

function Trig_Boss_Verc_WickedWhirl_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_WickedWhirlNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_WickedWhirlRemoveTrig)
    set udg_WickedWhirlNext[l_idx]=udg_WickedWhirlRecycle
    set udg_WickedWhirlRecycle=l_idx
endfunction

function Trig_Boss_Verc_WickedWhirl_Loop takes nothing returns nothing
    local integer d
    local integer i=0
    local real x
    local real y
    loop
        exitwhen i>=udg_WickedWhirlActiveCount
        set d=udg_WickedWhirlList[i]
        // (udg_WickedWhirlAngle at position d) plus ((12) times (bj_DEGTORAD)).
        set udg_WickedWhirlAngle[d]=udg_WickedWhirlAngle[d]+(12.*bj_DEGTORAD)
        if(udg_WickedWhirlTicks[d]>=udg_WickedWhirlDuration or GetUnitAbilityLevel(udg_WickedWhirlTarget[d],'Avul')>0)then // 'Avul': standard ability reference "Invulnerable"
            call Trig_Boss_Verc_WickedWhirl_Free(d)
        else
            set x=GetUnitX(udg_WickedWhirlTarget[d])
            set y=GetUnitY(udg_WickedWhirlTarget[d])
            // (x) plus ((300) times (the horizontal direction share for angle (udg_WickedWhirlAngle at position d) in
            // radians)).
            call SetUnitX(gg_unit_h020_0273[d],x+300.*Cos(udg_WickedWhirlAngle[d]))
            // (y) plus ((300) times (the vertical direction share for angle (udg_WickedWhirlAngle at position d) in
            // radians)).
            call SetUnitY(gg_unit_h020_0273[d],y+300.*Sin(udg_WickedWhirlAngle[d]))
            // Calculation 1:
            // The remainder after dividing (udg_WickedWhirlTicks at position d) by (10).
            // Calculation 2:
            // The remainder after dividing (udg_WickedWhirlTicks at position d) by (2).
            if(ModuloInteger(udg_WickedWhirlTicks[d],$A)==0 or(udg_WickedWhirlTicks[d]>'x' and ModuloInteger(udg_WickedWhirlTicks[d],2)==0))then // $A = 10
                // The remainder after dividing (udg_WickedWhirlTicks at position d) by (4).
                if(ModuloInteger(udg_WickedWhirlTicks[d],4)==0)then
                    // (x) plus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x+$96,y) // $96 = 150
                    // (x) minus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x-$96,y) // $96 = 150
                    // (y) plus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x,y+$96) // $96 = 150
                    // (y) minus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x,y-$96) // $96 = 150
                else
                    // Calculation 1:
                    // (x) plus (150).
                    // Calculation 2:
                    // (y) plus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x+$96,y+$96) // $96 = 150
                    // Calculation 1:
                    // (x) minus (150).
                    // Calculation 2:
                    // (y) plus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x-$96,y+$96) // $96 = 150
                    // Calculation 1:
                    // (x) plus (150).
                    // Calculation 2:
                    // (y) minus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x+$96,y-$96) // $96 = 150
                    // Calculation 1:
                    // (x) minus (150).
                    // Calculation 2:
                    // (y) minus (150).
                    call AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",x-$96,y-$96) // $96 = 150
                endif
                call GroupEnumUnitsInRange(udg_WickedWhirlGroup,x,y,300.,udg_WickedWhirlFilter)
                call Trig_Boss_Verc_WickedWhirl_DamageGroup(d)
            endif
            set udg_WickedWhirlTicks[d]=udg_WickedWhirlTicks[d]+1
        endif
        set i=i+1
    endloop
    if udg_WickedWhirlActiveCount==0 then
        call PauseTimer(udg_WickedWhirlTimer)
    endif
endfunction

function Trig_Boss_Verc_WickedWhirl_Start takes unit c,unit t returns integer
    local integer d=Trig_Boss_Verc_WickedWhirl_Alloc()
    set udg_WickedWhirlCaster[d]=c
    set udg_WickedWhirlTarget[d]=t
    if udg_WickedWhirlActiveCount==0 then
        call TimerStart(udg_WickedWhirlTimer,.03,true,function Trig_Boss_Verc_WickedWhirl_Loop)
    endif
    set udg_WickedWhirlList[udg_WickedWhirlActiveCount]=d
    set udg_WickedWhirlIndex[d]=udg_WickedWhirlActiveCount
    set udg_WickedWhirlActiveCount=udg_WickedWhirlActiveCount+1
    return d
endfunction

function Trig_Boss_Verc_WickedWhirl_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1E0' and GetUnitAbilityLevel(GetTriggerUnit(),'Avul')<=0) // 'A1E0': ability "!Wicked Whirl"; 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_Verc_WickedWhirl_Actions takes nothing returns nothing
    local integer d=Trig_Boss_Verc_WickedWhirl_Start(GetTriggerUnit(),GetSpellTargetUnit())
    local real l_facing=GetUnitFacing(udg_WickedWhirlCaster[d])
    local real x
    local real y
    // ((l_facing) plus (180)) times (bj_DEGTORAD).
    set udg_WickedWhirlAngle[d]=(l_facing+$B4)*bj_DEGTORAD // $B4 = 180
    // Result 1: the horizontal direction share for angle (udg_WickedWhirlAngle at position d) in radians.
    // Result 2: (300) times (result 1).
    // Result 3: (x position of udg_WickedWhirlTarget at position d) plus (result 2).
    set x=GetUnitX(udg_WickedWhirlTarget[d])+300.*Cos(udg_WickedWhirlAngle[d])
    // Result 1: the vertical direction share for angle (udg_WickedWhirlAngle at position d) in radians.
    // Result 2: (300) times (result 1).
    // Result 3: (y position of udg_WickedWhirlTarget at position d) plus (result 2).
    set y=GetUnitY(udg_WickedWhirlTarget[d])+300.*Sin(udg_WickedWhirlAngle[d])
    set gg_unit_h020_0273[d]=CreateUnit(Player($B),'h020',x,y,l_facing) // $B = 11; 'h020': unit "Dummy Missile"
    set udg_WickedWhirlEffect[d]=AddSpecialEffectTarget("units\\undead\\Gargoyle\\Gargoyle.mdl",gg_unit_h020_0273[d],"chest")
    call BlzSetSpecialEffectColor(udg_WickedWhirlEffect[d],$7F,0,0) // $7F = 127
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl",udg_WickedWhirlTarget[d],"origin"))
    call ShowUnit(udg_WickedWhirlCaster[d],false)
    call SetUnitInvulnerable(udg_WickedWhirlCaster[d],true)
endfunction

// Owns event registration, filters, and preloads for Boss_Verc_WickedWhirl.
function RegisterLegacy_Boss_Verc_WickedWhirl takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    call TriggerRegisterPlayerUnitEvent(eventTrigger,Player($B),EVENT_PLAYER_UNIT_SPELL_EFFECT,null) // $B = 11
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Boss_Verc_WickedWhirl_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Boss_Verc_WickedWhirl_Actions)
    set udg_WickedWhirlFilter=Condition(function Filter_EnemyOfHostile)
    call Preload("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call Preload("units\\undead\\Gargoyle\\Gargoyle.mdl")
    call Preload("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl")
endfunction

function InitTrig_Boss_Verc takes nothing returns nothing
endfunction

endlibrary

library TSpellBlizzaga requires TAbil, TCombatFormulas, TFilter, TMissile, TPath, TProf
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    timer udg_BlizzagaTimer=CreateTimer()
    boolexpr udg_BlizzagaFilter
    integer udg_BlizzagaRecycle=0
    integer udg_BlizzagaCount=0
    integer array udg_BlizzagaNext
    boolean array udg_BlizzagaSplits
    real array udg_BlizzagaAngle
    real array udg_BlizzagaDist
    real array udg_BlizzagaX
    real array udg_BlizzagaY
    real array udg_BlizzagaDmg
    real array udg_BlizzagaShardDmg
    unit gg_unit_h01B_0270
endglobals

function Trig_Spell_Blizzaga_DamageGroup takes integer l_idx,real damageAmount returns nothing
    local unit u
    loop
        set u=FirstOfGroup(udg_BlizzagaGroup)
        exitwhen u==null
        call GroupRemoveUnit(udg_BlizzagaGroup,u)
        if IsUnitEnemy(u,udg_BlizzagaOwner[l_idx])then
            set udg_DamageElement=2
            call UnitDamageTarget(udg_BlizzagaCaster[l_idx],u,damageAmount,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
        endif
    endloop
endfunction

function Trig_Spell_Blizzaga_Alloc takes nothing returns integer
    local integer l_idx=udg_BlizzagaRecycle
    if(l_idx!=0)then
        set udg_BlizzagaRecycle=udg_BlizzagaNext[l_idx]
    else
        set udg_BlizzagaCount=udg_BlizzagaCount+1
        set l_idx=udg_BlizzagaCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_BlizzagaSplits[l_idx]=false
    set udg_BlizzagaDist[l_idx]=.0
    set udg_BlizzagaShardDmg[l_idx]=.0
    set udg_BlizzagaNext[l_idx]=-1
    return l_idx
endfunction

function Trig_Spell_Blizzaga_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_BlizzagaNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_BlizzagaRemoveTrig)
    set udg_BlizzagaNext[l_idx]=udg_BlizzagaRecycle
    set udg_BlizzagaRecycle=l_idx
endfunction

function Trig_Spell_Blizzaga_Loop takes nothing returns nothing
    local integer d
    local integer i=0
    local real x
    local real y
    local integer l_j=0
    loop
        exitwhen i>=udg_BlizzagaActiveCount
        set d=udg_BlizzagaList[i]
        // Increase udg_BlizzagaDist at position d by 200.
        set udg_BlizzagaDist[d]=udg_BlizzagaDist[d]+200.
        // Result 1: the horizontal direction share for angle (udg_BlizzagaAngle at position d) in radians.
        // Result 2: (udg_BlizzagaDist at position d) times (result 1).
        // Result 3: (udg_BlizzagaX at position d) plus (result 2).
        set x=udg_BlizzagaX[d]+udg_BlizzagaDist[d]*Cos(udg_BlizzagaAngle[d])
        // Result 1: the vertical direction share for angle (udg_BlizzagaAngle at position d) in radians.
        // Result 2: (udg_BlizzagaDist at position d) times (result 1).
        // Result 3: (udg_BlizzagaY at position d) plus (result 2).
        set y=udg_BlizzagaY[d]+udg_BlizzagaDist[d]*Sin(udg_BlizzagaAngle[d])
        if Path_IsWalkable(x,y,10.)and udg_BlizzagaDist[d]<1200. then
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl",x,y))
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl",x,y))
            call GroupEnumUnitsInRange(udg_BlizzagaGroup,x,y,200.,udg_BlizzagaFilter)
            call Trig_Spell_Blizzaga_DamageGroup(d,udg_BlizzagaDmg[d])
            if udg_BlizzagaSplits[d]then
                loop
                    exitwhen l_j>=4
                    set gg_unit_h01B_0270=CreateUnit(udg_BlizzagaOwner[d],'h01B',x,y,.0) // 'h01B': unit "Proxy Dummy"
                    set udg_TempHandleId=GetHandleIdBJ(gg_unit_h01B_0270)
                    call SaveUnitHandleBJ(udg_BlizzagaCaster[d],0,udg_TempHandleId,udg_ProxyDamageHash)
                    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
                    call ShowUnitHide(gg_unit_h01B_0270)
                    call UnitApplyTimedLife(gg_unit_h01B_0270,'BTLF',6.) // 'BTLF': object name not found in map data
                    call UnitAddAbilityBJ('A0M2',gg_unit_h01B_0270) // 'A0M2': ability "Ice-elemental Damage"
                    // A random decimal number between 0 and 360.
                    call Missile_Launch(gg_unit_h01B_0270,"Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl","Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl",null,GetRandomReal(.0,360.),80.,25.,600.,.0,.0,200.,udg_BlizzagaShardDmg[d],2,ATTACK_TYPE_NORMAL,true)
                    set l_j=l_j+1
                endloop
            endif
        else
            call Trig_Spell_Blizzaga_Free(d)
        endif
        set i=i+1
    endloop
    if udg_BlizzagaActiveCount==0 then
        call PauseTimer(udg_BlizzagaTimer)
    endif
endfunction

function Trig_Spell_Blizzaga_Start takes unit c returns integer
    local integer d=Trig_Spell_Blizzaga_Alloc()
    set udg_BlizzagaCaster[d]=c
    set udg_BlizzagaOwner[d]=GetOwningPlayer(c)
    set udg_BlizzagaX[d]=GetUnitX(udg_BlizzagaCaster[d])
    set udg_BlizzagaY[d]=GetUnitY(udg_BlizzagaCaster[d])
    if udg_BlizzagaActiveCount==0 then
        call TimerStart(udg_BlizzagaTimer,.1,true,function Trig_Spell_Blizzaga_Loop)
    endif
    set udg_BlizzagaList[udg_BlizzagaActiveCount]=d
    set udg_BlizzagaIndex[d]=udg_BlizzagaActiveCount
    set udg_BlizzagaActiveCount=udg_BlizzagaActiveCount+1
    return d
endfunction

function Trig_Spell_Blizzaga_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A17S' or GetSpellAbilityId()=='A0TM' or GetSpellAbilityId()=='A0UY' or GetSpellAbilityId()=='A0RM' or GetSpellAbilityId()=='A0TX') // 'A17S': ability "Blizzaga"; 'A0TM': ability "Blizzaga"; 'A0UY': ability "Blizzaga"; 'A0RM': ability "!Diamond Dust"; 'A0TX': ability "!Diamond Dust"
endfunction

function Trig_Spell_Blizzaga_Actions takes nothing returns nothing
    local integer i=1
    local integer d
    local real a
    local unit triggeringUnit=GetTriggerUnit()
    local integer l_waves=3
    // Starting value for r:
    // (67.5) divided by (l_waves).
    local real r=67.5/ l_waves
    local integer manaCost=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(triggeringUnit,GetSpellAbilityId()))
    local real heroIntelligence=GetHeroInt(triggeringUnit,true)
    loop
        exitwhen i>l_waves
        set d=Trig_Spell_Blizzaga_Start(triggeringUnit)
        // Result 1: (67.5) divided by (2).
        // Result 2: (AngleBetweenPoints(Location(udg_BlizzagaX at position d, udg_BlizzagaY at position d),
        // GetSpellTargetLoc())) minus (result 1).
        set a=AngleBetweenPoints(Location(udg_BlizzagaX[d],udg_BlizzagaY[d]),GetSpellTargetLoc())-(67.5/ 2.)
        // ((a) plus ((r) times (i))) times (bj_DEGTORAD).
        set udg_BlizzagaAngle[d]=(a+r*i)*bj_DEGTORAD
        set udg_BlizzagaDmg[d]=Trig_Spell_Blizzaga_WaveDamageFormula(manaCost,heroIntelligence,Prof_RodPower(triggeringUnit))
        if(i!=1 and i!=l_waves)then
            set udg_BlizzagaSplits[d]=true
            set udg_BlizzagaShardDmg[d]=Trig_Spell_Blizzaga_ShardDamageFormula(manaCost,heroIntelligence,Prof_RodPower(triggeringUnit))
        endif
        set i=i+1
    endloop
    set triggeringUnit=null
endfunction

// Owns event registration, filters, and preloads for Spell_Blizzaga.
// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).
function RegisterLegacy_Spell_Blizzaga takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Spell_Blizzaga_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Spell_Blizzaga_Actions)
    set udg_BlizzagaFilter=Condition(function Filter_AliveNotInvul)
    call Preload("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl")
    call Preload("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl")
    call Preload("Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl")
endfunction

function InitTrig_Spell_Blizzaga takes nothing returns nothing
endfunction

endlibrary

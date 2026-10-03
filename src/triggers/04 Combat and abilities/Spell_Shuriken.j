library TSpellShuriken requires TAbil, TCombatFormulas, TFilter, TProf
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    timer udg_ShurikenTimer=CreateTimer()
    boolexpr udg_ShurikenFilter
    integer udg_ShurikenRecycle=0
    integer udg_ShurikenCount=0
    integer array udg_ShurikenNext
    boolean array udg_ShurikenReturning
    integer array udg_ShurikenSide
    real array udg_ShurikenRadius
endglobals

function Trig_Spell_Shuriken_FireHitEvent takes integer l_idx returns nothing
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_ShurikenDamageTrig)
endfunction

function Trig_Spell_Shuriken_Alloc takes nothing returns integer
    local integer l_idx=udg_ShurikenRecycle
    if(l_idx!=0)then
        set udg_ShurikenRecycle=udg_ShurikenNext[l_idx]
    else
        set udg_ShurikenCount=udg_ShurikenCount+1
        set l_idx=udg_ShurikenCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_ShurikenReturning[l_idx]=false
    set udg_ShurikenHitGroupA[l_idx]=CreateGroup()
    set udg_ShurikenHitGroupB[l_idx]=CreateGroup()
    set udg_ShurikenNext[l_idx]=-1
    return l_idx
endfunction

function Trig_Spell_Shuriken_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_ShurikenNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_ShurikenRemoveTrig)
    set udg_ShurikenNext[l_idx]=udg_ShurikenRecycle
    set udg_ShurikenRecycle=l_idx
endfunction

function Trig_Spell_Shuriken_Loop takes nothing returns nothing
    local integer d
    local integer i=0
    local real l_cosAng
    loop
        exitwhen i>=udg_ShurikenActiveCount
        set d=udg_ShurikenList[i]
        set udg_ShurikenAngle[d]=udg_ShurikenAngle[d]+(12.*bj_DEGTORAD)
        if udg_ShurikenRadius[d]<=80. then
            call Trig_Spell_Shuriken_Free(d)
        else
            if udg_ShurikenReturning[d]then
                set udg_ShurikenRadius[d]=udg_ShurikenRadius[d]-10.
            else
                set udg_ShurikenRadius[d]=udg_ShurikenRadius[d]+10.
                if(udg_ShurikenRadius[d]>=540.)then
                    set udg_ShurikenReturning[d]=true
                endif
            endif
            // The horizontal direction share for angle (udg_ShurikenAngle at position d) in radians.
            set l_cosAng=Cos(udg_ShurikenAngle[d])
            if(udg_ShurikenSide[d]==1 and l_cosAng<0)then
                call GroupClear(udg_ShurikenHitGroupA[d])
                set udg_ShurikenSide[d]=2
            elseif(udg_ShurikenSide[d]==2 and l_cosAng>0)then
                call GroupClear(udg_ShurikenHitGroupB[d])
                set udg_ShurikenSide[d]=1
            endif
            set udg_ShurikenX[d]=GetUnitX(udg_ShurikenCaster[d])+udg_ShurikenRadius[d]*l_cosAng
            set udg_ShurikenY[d]=GetUnitY(udg_ShurikenCaster[d])+udg_ShurikenRadius[d]*Sin(udg_ShurikenAngle[d])
            call SetUnitX(gg_unit_h020_0271[d],udg_ShurikenX[d])
            call SetUnitY(gg_unit_h020_0271[d],udg_ShurikenY[d])
            call GroupEnumUnitsInRange(udg_ShurikenEnumGroup,udg_ShurikenX[d],udg_ShurikenY[d],150.,udg_ShurikenFilter)
            call Trig_Spell_Shuriken_FireHitEvent(d)
        endif
        set i=i+1
    endloop
    if udg_ShurikenActiveCount==0 then
        call PauseTimer(udg_ShurikenTimer)
    endif
endfunction

function Trig_Spell_Shuriken_Start takes unit c returns integer
    local integer d=Trig_Spell_Shuriken_Alloc()
    set udg_ShurikenCaster[d]=c
    set udg_ShurikenOwner[d]=GetOwningPlayer(udg_ShurikenCaster[d])
    if udg_ShurikenActiveCount==0 then
        call TimerStart(udg_ShurikenTimer,.03,true,function Trig_Spell_Shuriken_Loop)
    endif
    set udg_ShurikenList[udg_ShurikenActiveCount]=d
    set udg_ShurikenIndex[d]=udg_ShurikenActiveCount
    set udg_ShurikenActiveCount=udg_ShurikenActiveCount+1
    return d
endfunction

function Trig_Spell_Shuriken_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A0AD' // 'A0AD': ability "Yuffie's Shuriken"
endfunction

function Trig_Spell_Shuriken_Actions takes nothing returns nothing
    local integer d=Trig_Spell_Shuriken_Start(GetTriggerUnit())
    local integer abilityLevel=GetUnitAbilityLevel(udg_ShurikenCaster[d],'A0AD') // 'A0AD': ability "Yuffie's Shuriken"
    local real l_facing=GetUnitFacing(udg_ShurikenCaster[d])
    set udg_ShurikenDamage[d]=Trig_Spell_Shuriken_DamageFormula(BlzGetAbilityManaCost('A0AD',Abil_GetLevel(udg_ShurikenCaster[d],'A0AD')),GetHeroAgi(udg_ShurikenCaster[d],true),Prof_GetLevel(udg_ShurikenCaster[d],'R00B')) // 'A0AD': ability "Yuffie's Shuriken"; 'R00B': upgrade "Dagger"
    set udg_ShurikenAngle[d]=(l_facing+270.)*bj_DEGTORAD
    // The horizontal direction share for angle (udg_ShurikenAngle at position d) in radians.
    if Cos(udg_ShurikenAngle[d])>0 then
        set udg_ShurikenSide[d]=1
    else
        set udg_ShurikenSide[d]=2
    endif
    set udg_ShurikenRadius[d]=90.
    set udg_ShurikenX[d]=GetUnitX(udg_ShurikenCaster[d])+udg_ShurikenRadius[d]*Cos(udg_ShurikenAngle[d])
    set udg_ShurikenY[d]=GetUnitY(udg_ShurikenCaster[d])+udg_ShurikenRadius[d]*Sin(udg_ShurikenAngle[d])
    set gg_unit_h020_0271[d]=CreateUnit(udg_ShurikenOwner[d],'h020',udg_ShurikenX[d],udg_ShurikenY[d],l_facing) // 'h020': unit "Dummy Missile"
    set udg_ShurikenEffect[d]=AddSpecialEffectTarget("Abilities\\Weapons\\ShadowHunterMissile\\ShadowHunterMissile.mdl",gg_unit_h020_0271[d],"chest")
endfunction

// Owns event registration, filters, and preloads for Spell_Shuriken.
// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).
function RegisterLegacy_Spell_Shuriken takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Spell_Shuriken_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Spell_Shuriken_Actions)
    set udg_ShurikenFilter=Condition(function Filter_AliveNonStructure)
    call Preload("Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl")
    call Preload("Abilities\\Weapons\\ShadowHunterMissile\\ShadowHunterMissile.mdl")
endfunction

function InitTrig_Spell_Shuriken takes nothing returns nothing
endfunction

endlibrary

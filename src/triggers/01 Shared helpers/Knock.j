library TKnock requires TPath
globals
    // Variables only this module uses.
    timer udg_KnockTimer=CreateTimer()
    integer udg_KnockActiveCount=0
    integer array udg_KnockList
    rect udg_KnockTreeRect=Rect(.0,.0,.0,.0)
    integer udg_KnockFreeHead=0
    integer udg_KnockCount=0
    integer array udg_KnockNext
    unit array udg_KnockUnit
    real array udg_KnockTreeRadius
    string array udg_KnockEffect
    integer array udg_KnockIndex
endglobals

function Knock_Allocate takes nothing returns integer
    local integer l_idx=udg_KnockFreeHead
    if(l_idx!=0)then
        set udg_KnockFreeHead=udg_KnockNext[l_idx]
    else
        set udg_KnockCount=udg_KnockCount+1
        set l_idx=udg_KnockCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_KnockNext[l_idx]=-1
    return l_idx
endfunction

function Knock_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_KnockNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_KnockRemoveTrig)
    set udg_KnockNext[l_idx]=udg_KnockFreeHead
    set udg_KnockFreeHead=l_idx
endfunction

function Knock_Update takes nothing returns nothing
    local integer d
    local integer i=0
    local real x
    local real y
    local real l_distSq
    local unit l_dummy
    loop
        exitwhen i>=udg_KnockActiveCount
        set d=udg_KnockList[i]
        // Move horizontally by this update's travel distance times the direction's horizontal share.
        set udg_KnockX[d]=udg_KnockX[d]+udg_KnockSpeed[d]*udg_KnockCosA[d]
        // Move vertically by the same travel distance times the direction's vertical share.
        set udg_KnockY[d]=udg_KnockY[d]+udg_KnockSpeed[d]*udg_KnockSinA[d]
        set x=GetUnitX(udg_KnockUnit[d])-udg_KnockX[d]
        set y=GetUnitY(udg_KnockUnit[d])-udg_KnockY[d]
        // Square the horizontal and vertical gaps and add them. This is distance squared, so no square root is needed here.
        set l_distSq=(x*x)+(y*y)
        set udg_KnockSpeed[d]=udg_KnockSpeed[d]-udg_KnockDecay[d]
        if l_distSq<10000. and Path_IsWalkable(udg_KnockX[d],udg_KnockY[d],10.)then
            call SetUnitX(udg_KnockUnit[d],udg_KnockX[d])
            call SetUnitY(udg_KnockUnit[d],udg_KnockY[d])
            call DestroyEffect(AddSpecialEffect(udg_KnockEffect[d],udg_KnockX[d],udg_KnockY[d]))
            call SetRect(udg_KnockTreeRect,udg_KnockX[d]-udg_KnockTreeRadius[d],udg_KnockY[d]-udg_KnockTreeRadius[d],udg_KnockX[d]+udg_KnockTreeRadius[d],udg_KnockY[d]+udg_KnockTreeRadius[d])
            call EnumDestructablesInRect(udg_KnockTreeRect,udg_KillTreeFilter,null)
        else
            if(udg_KnockDamage[d]>.0 and udg_KnockSource[d]!=null)then
                set l_dummy=CreateUnit(GetOwningPlayer(udg_KnockSource[d]),'h02S',GetUnitX(udg_KnockUnit[d]),GetUnitY(udg_KnockUnit[d]),.0) // 'h02S': unit "Simple Casting Dummy"
                call ShowUnit(l_dummy,false)
                call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
                if(IsUnitInGroup(udg_KnockUnit[d],udg_BossGroup))then
                    call UnitAddAbility(l_dummy,'A1BW') // 'A1BW': ability "Daze"
                    call IssueTargetOrderById(l_dummy,$D00DD,udg_KnockUnit[d]) // $D00DD = 852189
                else
                    call UnitAddAbility(l_dummy,'A18J') // 'A18J': ability "Knockdown Stun"
                    call IssueTargetOrderById(l_dummy,$D011C,udg_KnockUnit[d]) // $D011C = 852252
                endif
                set l_dummy=null
                set udg_IsPhysicalAttack=true
                call UnitDamageTarget(udg_KnockSource[d],udg_KnockUnit[d],udg_KnockDamage[d],true,true,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,null)
            endif
            call Knock_Free(d)
        endif
        if udg_KnockSpeed[d]<=.0 then
            call Knock_Free(d)
        endif
        set i=i+1
    endloop
    if udg_KnockActiveCount==0 then
        call PauseTimer(udg_KnockTimer)
    endif
endfunction

function Knock_Register takes integer l_idx returns nothing
    if udg_KnockActiveCount==0 then
        call TimerStart(udg_KnockTimer,.03,true,function Knock_Update)
    endif
    set udg_KnockList[udg_KnockActiveCount]=l_idx
    set udg_KnockIndex[l_idx]=udg_KnockActiveCount
    set udg_KnockActiveCount=udg_KnockActiveCount+1
endfunction

function Knock_Create takes unit t,string fx returns integer
    local integer d=Knock_Allocate()
    set udg_KnockUnit[d]=t
    set udg_KnockX[d]=GetUnitX(udg_KnockUnit[d])
    set udg_KnockY[d]=GetUnitY(udg_KnockUnit[d])
    set udg_KnockEffect[d]=fx
    set udg_KnockDamage[d]=.0
    return d
endfunction

function Knock_Launch takes unit c,unit t,real s,string fx,boolean sf,real damageAmount returns integer
    local integer d=Knock_Create(t,fx)
    local real a=Atan2(udg_KnockY[d]-GetUnitY(c),udg_KnockX[d]-GetUnitX(c))
    set udg_KnockSpeed[d]=s
    if sf then
        // Scale the starting knockback speed by default movement speed minus 0.4 per Agility.
        // This line does not clamp that factor, so its sign depends on the supplied stats.
        set udg_KnockSpeed[d]=udg_KnockSpeed[d]*(GetUnitDefaultMoveSpeed(t)-GetHeroAgi(t,true)*.4)
        if(GetUnitAbilityLevel(t,'A0KV')>0)then // 'A0KV': ability "Ailment Defense"
            // Ailment Defense keeps only 20% of this knockback speed: a reduction of 80%.
            set udg_KnockSpeed[d]=udg_KnockSpeed[d]*.2
        endif
    endif
    // Store 3% of the starting speed as the slowdown amount.
    set udg_KnockDecay[d]=udg_KnockSpeed[d]*.03
    // The horizontal direction share for angle (a) in radians.
    set udg_KnockCosA[d]=Cos(a)
    // The vertical direction share for angle (a) in radians.
    set udg_KnockSinA[d]=Sin(a)
    if(damageAmount>.0)then
        set udg_KnockDamage[d]=damageAmount
        set udg_KnockSource[d]=c
    endif
    call Knock_Register(d)
    return d
endfunction

function Knock_Apply takes unit c,unit t,real s,string fx,boolean sf,real damageAmount returns nothing
    call Knock_Launch(c,t,s,fx,sf,damageAmount)
endfunction

function Knock_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_KnockActiveCount=udg_KnockActiveCount-1
    set udg_KnockList[udg_KnockIndex[l_idx]]=udg_KnockList[udg_KnockActiveCount]
    set udg_KnockIndex[udg_KnockList[udg_KnockIndex[l_idx]]]=udg_KnockIndex[l_idx]
    return true
endfunction

function InitTrig_Knock takes nothing returns nothing
endfunction

endlibrary

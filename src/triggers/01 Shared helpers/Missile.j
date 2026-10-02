library TMissile requires TFilter, TKnock, TPath
function Missile_RunOnLoop takes integer l_idx returns nothing
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_MissileCollisionTrig)
endfunction

function Missile_RunOnHit takes integer l_idx,unit t,real damageAmount,real rd returns nothing
    set udg_ArgIndex=l_idx
    set udg_ArgUnit=t
    set udg_ArgReal=damageAmount
    set udg_ArgRadius=rd
    call TriggerEvaluate(udg_MissileDamageTrig)
endfunction

function Missile_Allocate takes nothing returns integer
    local integer l_idx=udg_MissileFreeHead
    if(l_idx!=0)then
        set udg_MissileFreeHead=udg_MissileNext[l_idx]
    else
        set udg_MissileCount=udg_MissileCount+1
        set l_idx=udg_MissileCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_MissileTarget[l_idx]=null
    set udg_MissileCollisionRange[l_idx]=.0
    set udg_MissileSplashRadius[l_idx]=.0
    set udg_MissileImpactDamage[l_idx]=.0
    set udg_MissileAoE[l_idx]=.0
    set udg_MissileTravelDamage[l_idx]=.0
    set udg_MissileFalloff[l_idx]=true
    set udg_MissileKnockback[l_idx]=false
    set udg_MissileElement[l_idx]=0
    set udg_MissileAttackType[l_idx]=ATTACK_TYPE_NORMAL
    set udg_MissileIsMagic[l_idx]=true
    set udg_MissileIsPure[l_idx]=false
    set udg_MissileTrueDamage[l_idx]=false
    set udg_MissileHealCredit[l_idx]=0
    set udg_MissileHoming[l_idx]=false
    set udg_MissileModelEffect[l_idx]=null
    set udg_MissileTrailEffect[l_idx]=null
    set udg_MissileImpactEffect[l_idx]=null
    set udg_MissileImpactEffect2[l_idx]=null
    set udg_MissileHitEffect[l_idx]=null
    set udg_MissileHitOnce[l_idx]=false
    set udg_MissileHitGroup[l_idx]=CreateGroup()
    set udg_MissileNext[l_idx]=-1
    return l_idx
endfunction

function Missile_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_MissileNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_MissileImpactTrig)
    set udg_MissileNext[l_idx]=udg_MissileFreeHead
    set udg_MissileFreeHead=l_idx
endfunction

function Missile_Update takes nothing returns nothing
    local integer d
    local integer i=0
    local unit u
    local real a
    loop
        exitwhen i>=udg_MissileActiveCount
        set d=udg_MissileList[i]
        // (udg_MissileRange at position d) minus (udg_MissileSpeed at position d).
        set udg_MissileRange[d]=udg_MissileRange[d]-udg_MissileSpeed[d]
        if udg_MissileHoming[d]then
            // Result 1: (y position of udg_MissileTarget at position d) minus (udg_MissileY at position d).
            // Result 2: (x position of udg_MissileTarget at position d) minus (udg_MissileX at position d).
            // Result 3: the angle in radians from the y gap (result 1) and x gap (result 2).
            set a=Atan2(GetUnitY(udg_MissileTarget[d])-udg_MissileY[d],GetUnitX(udg_MissileTarget[d])-udg_MissileX[d])
            // The horizontal direction share for angle (a) in radians.
            set udg_MissileCosA[d]=Cos(a)
            // The vertical direction share for angle (a) in radians.
            set udg_MissileSinA[d]=Sin(a)
            // (a) times (bj_RADTODEG).
            call SetUnitFacing(gg_unit_h020_0269[d],a*bj_RADTODEG)
        endif
        // Move the projectile horizontally using travel distance times the horizontal direction share.
        set udg_MissileX[d]=udg_MissileX[d]+udg_MissileSpeed[d]*udg_MissileCosA[d]
        // Move the projectile vertically using travel distance times the vertical direction share.
        set udg_MissileY[d]=udg_MissileY[d]+udg_MissileSpeed[d]*udg_MissileSinA[d]
        if Path_IsWalkable(udg_MissileX[d],udg_MissileY[d],10.)and udg_MissileRange[d]>.0 then
            call SetUnitX(gg_unit_h020_0269[d],udg_MissileX[d])
            call SetUnitY(gg_unit_h020_0269[d],udg_MissileY[d])
            if udg_MissileCollisionRange[d]>.0 then
                call Missile_RunOnLoop(d)
            endif
            if udg_MissileAoE[d]>.0 then
                call GroupEnumUnitsInRange(udg_MissileEnumGroup,udg_MissileX[d],udg_MissileY[d],udg_MissileAoE[d],udg_MissileFilter)
                loop
                    set u=FirstOfGroup(udg_MissileEnumGroup)
                    exitwhen u==null
                    call GroupRemoveUnit(udg_MissileEnumGroup,u)
                    call Missile_RunOnHit(d,u,udg_MissileTravelDamage[d],udg_MissileAoE[d])
                    if udg_MissileKnockback[d]and IsUnitEnemy(u,GetOwningPlayer(udg_MissileCaster[d]))then
                        call Knock_Apply(udg_MissileCaster[d],u,udg_MissileSpeed[d],udg_MissileHitEffect[d],true,.0)
                    endif
                endloop
            endif
            if udg_MissileHoming[d]then
                // (x position of udg_MissileTarget at position d) minus (udg_MissileX at position d).
                set udg_MissileDX=GetUnitX(udg_MissileTarget[d])-udg_MissileX[d]
                // (y position of udg_MissileTarget at position d) minus (udg_MissileY at position d).
                set udg_MissileDY=GetUnitY(udg_MissileTarget[d])-udg_MissileY[d]
                // Find straight-line distance: square both coordinate gaps, add them, then take the square root.
                set udg_MissileDistance=SquareRoot(udg_MissileDX*udg_MissileDX+udg_MissileDY*udg_MissileDY)
                if udg_MissileDistance<60. then
                    call Missile_Free(d)
                endif
            endif
        else
            call Missile_Free(d)
        endif
        set i=i+1
    endloop
    if udg_MissileActiveCount==0 then
        call PauseTimer(udg_MissileTimer)
    endif
endfunction

function Missile_Register takes integer l_idx returns nothing
    if udg_MissileActiveCount==0 then
        call TimerStart(udg_MissileTimer,.03,true,function Missile_Update)
    endif
    set udg_MissileList[udg_MissileActiveCount]=l_idx
    set udg_MissileIndex[l_idx]=udg_MissileActiveCount
    set udg_MissileActiveCount=udg_MissileActiveCount+1
endfunction

function Missile_Create takes real rd returns integer
    local integer d=Missile_Allocate()
    set udg_MissileCollisionRange[d]=rd
    return d
endfunction

function Missile_CreateWithEffects takes unit c,string l_modelPath,string l_extraModelPath,real a,real rd returns integer
    local integer d=Missile_Create(rd)
    set udg_MissileCaster[d]=c
    set udg_MissileX[d]=GetUnitX(c)
    set udg_MissileY[d]=GetUnitY(c)
    set gg_unit_h020_0269[d]=CreateUnit(GetOwningPlayer(udg_MissileCaster[d]),'h020',udg_MissileX[d],udg_MissileY[d],a) // 'h020': unit "Dummy Missile"
    set udg_MissileModelEffect[d]=AddSpecialEffectTarget(l_modelPath,gg_unit_h020_0269[d],"chest")
    set udg_MissileTrailEffect[d]=AddSpecialEffectTarget(l_extraModelPath,gg_unit_h020_0269[d],"chest")
    // The horizontal direction share for angle ((a) times (bj_DEGTORAD)) in radians.
    set udg_MissileCosA[d]=Cos(a*bj_DEGTORAD)
    // The vertical direction share for angle ((a) times (bj_DEGTORAD)) in radians.
    set udg_MissileSinA[d]=Sin(a*bj_DEGTORAD)
    call Missile_Register(d)
    return d
endfunction

function Missile_DamageUnit takes integer l_idx,unit t,real damageAmount,real rd returns nothing
    local damagetype l_dmgType
    local boolean l_noTarget=udg_MissileTarget[l_idx]==null
    if udg_MissileIsPure[l_idx]then
        set l_dmgType=DAMAGE_TYPE_UNIVERSAL
    elseif udg_MissileIsMagic[l_idx]then
        set l_dmgType=DAMAGE_TYPE_MAGIC
    else
        set l_dmgType=DAMAGE_TYPE_NORMAL
    endif
    // (x position of t) minus (udg_MissileX at position l_idx).
    set udg_MissileDX=GetUnitX(t)-udg_MissileX[l_idx]
    // (y position of t) minus (udg_MissileY at position l_idx).
    set udg_MissileDY=GetUnitY(t)-udg_MissileY[l_idx]
    set udg_MissileDamageDealt=damageAmount
    if udg_MissileFalloff[l_idx]then
        // Damage fades with distance from the center: base damage x (1 - distance / radius).
        // At the center keep all damage; halfway to the radius keep half; at the radius keep none.
        set udg_MissileDamageDealt=damageAmount-(damageAmount*(SquareRoot(udg_MissileDX*udg_MissileDX+udg_MissileDY*udg_MissileDY)/ rd))
    endif
    if udg_MissileHitOnce[l_idx]then
        if not IsUnitInGroup(t,udg_MissileHitGroup[l_idx])then
            call GroupAddUnit(udg_MissileHitGroup[l_idx],t)
            if(l_noTarget and IsUnitEnemy(t,GetOwningPlayer(udg_MissileCaster[l_idx])))or(not l_noTarget and IsUnitAlly(t,GetOwningPlayer(udg_MissileTarget[l_idx])))then
                set udg_DamageElement=udg_MissileElement[l_idx]
                if not udg_MissileIsMagic[l_idx]then
                    set udg_IsPhysicalAttack=true
                endif
                if udg_MissileIsPure[l_idx]then
                    set udg_IsPureDamage=true
                    set udg_HealCreditPlayer=udg_MissileHealCredit[l_idx]
                endif
                if udg_MissileTrueDamage[l_idx]then
                    set udg_IgnoresReduction=true
                endif
                call UnitDamageTarget(udg_MissileCaster[l_idx],t,udg_MissileDamageDealt,true,false,udg_MissileAttackType[l_idx],l_dmgType,null)
            endif
        endif
    else
        if(l_noTarget and IsUnitEnemy(t,GetOwningPlayer(udg_MissileCaster[l_idx])))or(not l_noTarget and IsUnitAlly(t,GetOwningPlayer(udg_MissileTarget[l_idx])))then
            set udg_DamageElement=udg_MissileElement[l_idx]
            if not udg_MissileIsMagic[l_idx]then
                set udg_IsPhysicalAttack=true
            endif
            if udg_MissileIsPure[l_idx]then
                set udg_IsPureDamage=true
                set udg_IgnoresReduction=true
            endif
            call UnitDamageTarget(udg_MissileCaster[l_idx],t,udg_MissileDamageDealt,true,false,udg_MissileAttackType[l_idx],l_dmgType,null)
        endif
    endif
endfunction

function Missile_Launch takes unit c,string l_modelPath,string l_hitFx,string l_endFx,real a,real rd,real s,real md,real l_aoe,real l_dps,real l_hitRadius,real l_hitDamage,integer l_element,attacktype l_atkType,boolean l_pierce returns nothing
    local integer d=Missile_CreateWithEffects(c,l_modelPath,"",a,rd)
    set udg_MissileSpeed[d]=s
    set udg_MissileRange[d]=md
    set udg_MissileAoE[d]=l_aoe
    // (l_dps) times (0.03).
    set udg_MissileTravelDamage[d]=l_dps*.03
    set udg_MissileSplashRadius[d]=l_hitRadius
    set udg_MissileImpactDamage[d]=l_hitDamage
    set udg_MissileImpactEffect[d]=l_hitFx
    set udg_MissileImpactEffect2[d]=l_endFx
    set udg_MissileHitOnce[d]=false
    set udg_MissileFalloff[d]=false
    set udg_MissileElement[d]=l_element
    set udg_MissileAttackType[d]=l_atkType
    set udg_MissileIsMagic[d]=l_atkType==ATTACK_TYPE_NORMAL
    set udg_MissileTrueDamage[d]=l_pierce
endfunction

function Missile_Init takes nothing returns nothing
    set udg_DummyItem=CreateItem('ciri',-$7D0,-4500) // 'ciri': item "Meta Fragment"; $7D0 = 2000
    call SetItemVisible(udg_DummyItem,false)
    set gg_rct_002=Rect(.0,.0,128.,128.)
    set udg_MissileFilter=Condition(function Filter_MissileTarget)
    set udg_KillDestFilter=Condition(function Filter_KillDestructable)
endfunction

function Missile_CheckCollision takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local unit u
    local real l_tmp1
    local real l_tmp2
    call GroupEnumUnitsInRange(udg_MissileEnumGroup,udg_MissileX[l_idx],udg_MissileY[l_idx],udg_MissileCollisionRange[l_idx],udg_MissileFilter)
    set u=FirstOfGroup(udg_MissileEnumGroup)
    if u!=null and u!=udg_MissileCaster[l_idx]and GetUnitTypeId(u)!='h020' then // 'h020': unit "Dummy Missile"
        call Missile_Free(l_idx)
    endif
    call GroupClear(udg_MissileEnumGroup)
    return true
endfunction

function Missile_DamageWrap takes nothing returns boolean
    call Missile_DamageUnit(udg_ArgIndex,udg_ArgUnit,udg_ArgReal,udg_ArgRadius)
    return true
endfunction

function Missile_Impact takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local unit u
    local damagetype l_dmgType
    if udg_MissileIsPure[l_idx]then
        set l_dmgType=DAMAGE_TYPE_UNIVERSAL
    elseif udg_MissileIsMagic[l_idx]then
        set l_dmgType=DAMAGE_TYPE_MAGIC
    else
        set l_dmgType=DAMAGE_TYPE_NORMAL
    endif
    set udg_MissileActiveCount=udg_MissileActiveCount-1
    set udg_MissileList[udg_MissileIndex[l_idx]]=udg_MissileList[udg_MissileActiveCount]
    set udg_MissileIndex[udg_MissileList[udg_MissileIndex[l_idx]]]=udg_MissileIndex[l_idx]
    if udg_MissileSplashRadius[l_idx]>.0 then
        call GroupEnumUnitsInRange(udg_MissileEnumGroup,udg_MissileX[l_idx],udg_MissileY[l_idx],udg_MissileSplashRadius[l_idx],udg_MissileFilter)
        loop
            set u=FirstOfGroup(udg_MissileEnumGroup)
            exitwhen u==null
            call GroupRemoveUnit(udg_MissileEnumGroup,u)
            call Missile_DamageUnit(l_idx,u,udg_MissileImpactDamage[l_idx],udg_MissileSplashRadius[l_idx])
            if udg_MissileKnockback[l_idx]then
                call Knock_Apply(udg_MissileCaster[l_idx],u,udg_MissileSpeed[l_idx],udg_MissileHitEffect[l_idx],true,.0)
            endif
        endloop
    elseif udg_MissileHoming[l_idx]and udg_MissileImpactDamage[l_idx]>.0 then
        call DestroyEffect(AddSpecialEffectTarget(udg_MissileHitEffect[l_idx],udg_MissileTarget[l_idx],"chest"))
        if not udg_MissileIsMagic[l_idx]then
            set udg_IsPhysicalAttack=true
        endif
        if udg_MissileIsPure[l_idx]then
            set udg_IsPureDamage=true
            set udg_HealCreditPlayer=udg_MissileHealCredit[l_idx]
        endif
        if udg_MissileTrueDamage[l_idx]then
            set udg_IgnoresReduction=true
        endif
        call UnitDamageTarget(udg_MissileCaster[l_idx],udg_MissileTarget[l_idx],udg_MissileImpactDamage[l_idx],true,false,udg_MissileAttackType[l_idx],l_dmgType,null)
    endif
    call DestroyEffect(AddSpecialEffect(udg_MissileImpactEffect[l_idx],udg_MissileX[l_idx],udg_MissileY[l_idx]))
    call DestroyEffect(AddSpecialEffect(udg_MissileImpactEffect2[l_idx],udg_MissileX[l_idx],udg_MissileY[l_idx]))
    call RemoveUnit(gg_unit_h020_0269[l_idx])
    call DestroyEffect(udg_MissileModelEffect[l_idx])
    call DestroyEffect(udg_MissileTrailEffect[l_idx])
    return true
endfunction

function InitTrig_Missile takes nothing returns nothing
endfunction

endlibrary

library TDamage requires TBattleLog, TBerserk, TElement, TGroup, TPlayerHero, TProf, TText, TUnit, TWait
globals
    // Per-hit context for Trig_Damage_Engine_CalcDamage (one slot per nested call, see DmgCtx_Depth).
    integer DmgCtx_Depth=0
    real array DmgCtx_Amount
    unit array DmgCtx_Source
    unit array DmgCtx_Target
    boolean array DmgCtx_Unavoidable
    integer array DmgCtx_Kind
    boolean array DmgCtx_NoCrit
    integer array DmgCtx_Element
    boolean array DmgCtx_ManaDamage
    boolean array DmgCtx_Holy
    boolean array DmgCtx_Heal
    boolean array DmgCtx_NoRedirect
    boolean array DmgCtx_HealUndead
    boolean array DmgCtx_Pure
    boolean array DmgCtx_Melee
    boolean array DmgCtx_Ranged
    boolean array DmgCtx_Physical
    boolean array DmgCtx_Magical
    boolean array DmgCtx_Akashic
    boolean array DmgCtx_IgnoreDefense
    integer array DmgCtx_FxCode
    integer array DmgCtx_BlockCode
    real array DmgCtx_SourceX
    real array DmgCtx_SourceY
    real array DmgCtx_TargetX
    real array DmgCtx_TargetY
    integer array DmgCtx_SourceHandle
    integer array DmgCtx_TargetHandle
    player array DmgCtx_SourcePlayer
    player array DmgCtx_TargetPlayer
    real array DmgCtx_ArmorMult
    real array DmgCtx_DefenseScale
    integer array DmgCtx_Tmp
    real array DmgCtx_Val
    real array DmgCtx_Val2
    unit array DmgCtx_Dummy
    texttag array DmgCtx_Tag
    integer array DmgCtx_Resist
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Damage_Init=null
    trigger gg_trg_Damage_RegisterEnter=null
    trigger gg_trg_Damage_RegisterAttacked=null
    trigger gg_trg_Damage_Engine=null
    trigger gg_trg_Damage_ProxyCleanup=null
    trigger gg_trg_Damage_Splash=null
    // Variables only this module uses.
    unit udg_ProxyDamageTarget=null
    unit udg_SplashSource=null
    real udg_SplashDamage=0
    boolean udg_DmgArmorProbe=false
    real udg_DmgArmorProbeResult=0
    item udg_TwoHandedItem=null
    boolean udg_DmgFlagMelee=false
    boolean udg_DmgFlagRedirected=false
endglobals

function Trig_Damage_Engine_FindTwoHandedItem takes unit u returns nothing
    local integer i=0
    local item l_it
    set udg_TwoHandedItem=null
    loop
        set l_it=UnitItemInSlot(u,i)
        if(l_it!=null and(GetItemType(l_it)==ITEM_TYPE_PERMANENT or GetItemType(l_it)==ITEM_TYPE_POWERUP))then
            if(udg_TwoHandedItem!=null or GetItemType(l_it)==ITEM_TYPE_POWERUP)then
                set udg_TwoHandedItem=null
                set l_it=null
                return
            elseif(GetItemType(l_it)==ITEM_TYPE_PERMANENT)then
                set udg_TwoHandedItem=l_it
            endif
        endif
        set i=i+1
        exitwhen i>=bj_MAX_INVENTORY
    endloop
    set l_it=null
endfunction

function Trig_Damage_Engine_ProficiencyMult takes unit u returns real
    local integer l_weapon
    local integer l_prof
    local integer l_varied
    local integer i
    local item l_it
    local real l_rate=.04
    local player owningPlayer=GetOwningPlayer(u)
    if(owningPlayer!=Player($B)and u!=Player_GetHero(owningPlayer))then // $B = 11
        set owningPlayer=null
        return 1.5
    endif
    set l_weapon=Prof_GetWeaponUpgrade(u)
    if(l_weapon==0)then
        set l_prof=0
    elseif(l_weapon=='R00N')then // 'R00N': upgrade "Greatsword"
        set l_prof=Prof_GetHybridLevel(u)
    else
        set l_prof=Prof_GetLevel(u,l_weapon)
    endif
    if(GetUnitAbilityLevel(u,'A16Y')>0)then // 'A16Y': ability "Varied Proficiency"
        set l_varied=0
        if(GetUnitAbilityLevel(u,'A135')>0)then // 'A135': ability "Joker Proficiency"
            // Increase l_varied by 12.
            set l_varied=l_varied+$C // $C = 12
        else
            // Increase l_varied by 5.
            set l_varied=l_varied+5
        endif
        set i=0
        loop
            set l_it=UnitItemInSlot(u,i)
            if(l_it!=null and GetItemType(l_it)==ITEM_TYPE_PERMANENT)then
                // ((l_varied) plus (((GetItemLifeBJ(l_it)) with its decimal part removed) divided by (10))) plus (1).
                set l_varied=l_varied+(R2I(GetItemLifeBJ(l_it))/ $A)+1 // $A = 10
            endif
            set i=i+1
            exitwhen i>=bj_MAX_INVENTORY
        endloop
        set l_it=null
        if(l_varied>l_prof)then
            set l_prof=l_varied
        endif
    endif
    if(GetUnitAbilityLevel(u,'A15J')>0)then // 'A15J': ability "Striker"
        if Unit_HasNoEquipment(u)then
            set l_prof=60
            if(GetUnitAbilityLevel(u,'A136')>0)then // 'A136': ability "High Proficiency"
                set l_prof=90
            endif
        elseif(l_prof<$A)then // $A = 10
            set l_prof=$A // $A = 10
            if(GetUnitAbilityLevel(u,'A136')>0)then // 'A136': ability "High Proficiency"
                set l_prof=$F // $F = 15
            endif
        endif
    endif
    set owningPlayer=null
    if(l_prof>0)then
        if(l_weapon=='R00I')then // 'R00I': upgrade "Heavens Forged Axe"
            set l_rate=.02
        endif
        // ((l_prof treated as a decimal-capable number) times (l_rate)) plus (1).
        return I2R(l_prof)*l_rate+1
    else
        return 1.
    endif
endfunction

function Trig_Damage_Engine_IsNight takes nothing returns boolean
    local real l_tod=GetTimeOfDay()
    return l_tod<6. or l_tod>=18.
endfunction

function Trig_Damage_Engine_GetElementResist takes unit u,integer l_element returns integer
    local integer l_tier=3
    local integer i=1
    if(l_element<=0)then
        return 3
    endif
    if(GetUnitAbilityLevel(u,'A11N')>0)then // 'A11N': ability "Shifting Elements"
        if(l_element==7 or l_element==udg_ElementOpposite[GetUnitAbilityLevel(u,'A11N')])then // 'A11N': ability "Shifting Elements"
            return 1
        else
            return 6
        endif
    endif
    // A random whole number from 1 through 100.
    if(GetUnitAbilityLevel(u,'A0PM')>0 and GetRandomInt(1,'d')<=$F)then // 'A0PM': ability "Random Omni Absorb"; $F = 15
        return 7
    endif
    if(GetUnitAbilityLevel(u,udg_ElementAbsorbAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementAbsorbAbil[7])>0)then
        set l_tier=7
    elseif(l_tier<6 and(GetUnitAbilityLevel(u,udg_ElementImmunityAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementImmunityAbil[7])>0))then
        set l_tier=6
    elseif(l_tier<5 and(GetUnitAbilityLevel(u,udg_ElementResistAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementResistAbil[7])>0))then
        set l_tier=5
    elseif(l_tier==3 and(GetUnitAbilityLevel(u,udg_ElementWeaknessAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementWeaknessAbil[7])>0))then
        set l_tier=1
    endif
    if(l_element==7 and l_tier==3)then
        loop
            exitwhen i>=7
            if(GetUnitAbilityLevel(u,udg_ElementWeaknessAbil[i])>0)then
                set l_tier=1
                set i=7
            endif
            set i=i+1
        endloop
    endif
    return l_tier
endfunction

function Trig_Damage_Engine_GetElementBonus takes unit u,integer l_element,boolean l_physical returns real
    local real l_bonus=.0
    if(GetUnitAbilityLevel(u,'A0PN')>0 or GetUnitAbilityLevel(u,'B08Z')>0)then // 'A0PN': ability "Gaya Strength"; 'B08Z': buff tooltip "Gaya Strength"
        // Increase l_bonus by 0.33333.
        set l_bonus=l_bonus+.33333
    endif
    if(l_physical and GetUnitAbilityLevel(u,udg_ElementAttackAbil[l_element])>0)then
        // Increase l_bonus by 0.1.
        set l_bonus=l_bonus+.1
    endif
    if(GetUnitAbilityLevel(u,udg_ElementKnowledgeAbil[l_element])>0)then
        // Increase l_bonus by 0.5.
        set l_bonus=l_bonus+.5
    endif
    if(GetUnitAbilityLevel(u,udg_ElementBoostAbil[l_element])>0)then
        // Increase l_bonus by 0.3.
        set l_bonus=l_bonus+.3
    endif
    if(not l_physical and GetUnitAbilityLevel(u,udg_ElementSpellAmpAbil[l_element])>0)then
        // Increase l_bonus by 0.8.
        set l_bonus=l_bonus+.8
    endif
    if(GetUnitAbilityLevel(u,udg_ElementOrbAmpAbil[l_element])>0)then
        // Increase l_bonus by 0.6.
        set l_bonus=l_bonus+.6
    endif
    if(l_element==6 and GetUnitAbilityLevel(u,'A1FF')>0)then // 'A1FF': ability "Yatagarasu Power"
        // Increase l_bonus by 1.2.
        set l_bonus=l_bonus+1.2
    endif
    if(l_element==1 and GetUnitAbilityLevel(u,'A0YW')>0)then // 'A0YW': ability "Gathering Heat"
        if(GetUnitAbilityLevel(u,'A0Z1')>0)then // 'A0Z1': ability "Full Heat"
            // Increase l_bonus by 2.
            set l_bonus=l_bonus+2.
        else
            // (l_bonus) plus ((2) times ((1) minus ((current health of u) divided by (maximum health of u)))).
            set l_bonus=l_bonus+(2.*(1.-(GetUnitState(u,UNIT_STATE_LIFE)/ GetUnitState(u,UNIT_STATE_MAX_LIFE))))
        endif
    endif
    if(l_element==7)then
        // (l_bonus) times (0.5).
        set l_bonus=l_bonus*.5
    endif
    if(GetUnitAbilityLevel(u,udg_ElementEnchantBuff[l_element])>0)then
        // (((l_bonus) plus (1)) times (1.2)) minus (1).
        set l_bonus=((l_bonus+1.)*1.2)-1.
    endif
    return l_bonus
endfunction

function Trig_Damage_Engine_NotifyDamageSource takes nothing returns nothing
    call Element_SetFromUnit(GetEventDamageSource(),udg_IsPhysicalAttack)
endfunction

function Trig_Damage_Engine_ReapplyStunEnum takes nothing returns nothing
    local unit enumeratedUnit=GetEnumUnit()
    local unit l_dummy
    local integer l_stunLevel=0
    // (l_stunLevel) plus (GetUnitAbilityLevel(enumeratedUnit, 'BPSE')).
    set l_stunLevel=l_stunLevel+GetUnitAbilityLevel(enumeratedUnit,'BPSE') // 'BPSE': buff tooltip "Stunned"
    // (l_stunLevel) plus ((GetUnitAbilityLevel(enumeratedUnit, 'B08I')) times (2)).
    set l_stunLevel=l_stunLevel+GetUnitAbilityLevel(enumeratedUnit,'B08I')*2 // 'B08I': buff tooltip "Stunned"
    if(l_stunLevel>0)then
        call UnitRemoveAbility(enumeratedUnit,'BPSE') // 'BPSE': buff tooltip "Stunned"
        call UnitRemoveAbility(enumeratedUnit,'B08I') // 'B08I': buff tooltip "Stunned"
        set l_dummy=CreateUnit(GetOwningPlayer(enumeratedUnit),'h02S',GetUnitX(enumeratedUnit),GetUnitY(enumeratedUnit),.0) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnit(l_dummy,false)
        call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
        if(l_stunLevel==1)then
            call UnitAddAbility(l_dummy,'A1BV') // 'A1BV': ability "Daze"
        else
            call UnitAddAbility(l_dummy,'A1BW') // 'A1BW': ability "Daze"
        endif
        call IssueTargetOrder(l_dummy,"cripple",enumeratedUnit)
    endif
    if(GetUnitAbilityLevel(enumeratedUnit,'B00L')>0)then // 'B00L': buff tooltip "Freeze"
        call UnitRemoveAbility(enumeratedUnit,'B00L') // 'B00L': buff tooltip "Freeze"
        if(GetOwningPlayer(enumeratedUnit)==Player($B))then // $B = 11
            set l_dummy=CreateUnit(Player(9),'h02S',GetUnitX(enumeratedUnit),GetUnitY(enumeratedUnit),.0) // 'h02S': unit "Simple Casting Dummy"
        else
            set l_dummy=CreateUnit(Player($B),'h02S',GetUnitX(enumeratedUnit),GetUnitY(enumeratedUnit),.0) // $B = 11; 'h02S': unit "Simple Casting Dummy"
        endif
        call ShowUnit(l_dummy,false)
        call UnitApplyTimedLife(l_dummy,'BTLF',1.2) // 'BTLF': object name not found in map data
        call UnitAddAbility(l_dummy,'A0OP') // 'A0OP': ability "Frost Attack"
        call IssueTargetOrder(l_dummy,"frostnova",enumeratedUnit)
    endif
    set enumeratedUnit=null
    set l_dummy=null
endfunction

function Trig_Damage_Engine_ReapplyStuns takes nothing returns nothing
    call ForGroup(udg_BossGroup,function Trig_Damage_Engine_ReapplyStunEnum)
endfunction

function Trig_Damage_Engine_GetComboHits takes unit u returns integer
    local real l_hits
    local real successChance=0
    if(GetUnitAbilityLevel(u,'A139')>0 or GetUnitAbilityLevel(u,'A13H')>0)then // 'A139': ability "Combo Potential"; 'A13H': ability "Mid Combo Potential"
        set successChance=successChance+1
    endif
    if(GetUnitAbilityLevel(u,'A021')>0 or GetUnitAbilityLevel(u,'B08M')>0)then // 'A021': ability "Rendan"; 'B08M': buff tooltip "Rendan"
        set successChance=successChance+1
    endif
    if(GetUnitAbilityLevel(u,'A0TW')>0)then // 'A0TW': ability "Cursed Combo Potential"
        // Increase chance by 2.
        set successChance=successChance+2
    endif
    if(GetUnitAbilityLevel(u,'A182')>0)then // 'A182': ability "Kazuma Effect"
        // Increase chance by 2.
        set successChance=successChance+2
    endif
    if(GetUnitAbilityLevel(u,'A0HS')>0)then // 'A0HS': ability "Wyrmhero Effect"
        // Increase chance by 6.
        set successChance=successChance+6
    endif
    if(GetUnitAbilityLevel(u,'A0OQ')>0)then // 'A0OQ': ability "Combo Triple Chance"
        // (chance) times (3).
        set successChance=successChance*3
    endif
    // A random whole number from 1 through 20.
    if(IsUnitType(u,UNIT_TYPE_MELEE_ATTACKER)and(GetUnitAbilityLevel(u,'B00O')>0 or GetUnitAbilityLevel(u,'B07L')>0 or(successChance>0 and GetRandomInt(1,20)<=successChance)))then // 'B00O': buff tooltip "Rendan"; 'B07L': buff tooltip "Renzokuken"
        // A random decimal number between 3 and 5.6.
        set l_hits=GetRandomReal(3.,5.6)
        if(GetUnitAbilityLevel(u,'B07L')>0)then // 'B07L': buff tooltip "Renzokuken"
            // (l_hits) plus (GetUnitAbilityLevel(u, 'A0IY') treated as a decimal-capable number).
            set l_hits=l_hits+I2R(GetUnitAbilityLevel(u,'A0IY')) // 'A0IY': ability "Renzokuken"
        else
            call UnitRemoveAbility(u,'B00O') // 'B00O': buff tooltip "Rendan"
        endif
        if(GetUnitAbilityLevel(u,'A0HS')>0)then // 'A0HS': ability "Wyrmhero Effect"
            // Increase l_hits by 11.
            set l_hits=l_hits+11.
        endif
        if(GetUnitAbilityLevel(u,'A13G')>0)then // 'A13G': ability "Combo Extend"
            // Increase l_hits by 8.
            set l_hits=l_hits+8.
        endif
        if(GetUnitAbilityLevel(u,'A1DG')>0)then // 'A1DG': ability "Combo Dragon"
            // Increase l_hits by 7.
            set l_hits=l_hits+7.
        endif
        if(GetUnitAbilityLevel(u,'A182')>0)then // 'A182': ability "Kazuma Effect"
            // (l_hits) plus (a random decimal number between -1.1 and 1.5).
            set l_hits=l_hits+GetRandomReal(-1.1,1.5)
        endif
        if(GetUnitAbilityLevel(u,'A13F')>0)then // 'A13F': ability "Combo Extend"
            // Increase l_hits by 6.
            set l_hits=l_hits+6.
        endif
        if(GetUnitAbilityLevel(u,'A13E')>0)then // 'A13E': ability "Combo Extend"
            // Increase l_hits by 5.
            set l_hits=l_hits+5.
        endif
        if(GetUnitAbilityLevel(u,'A13D')>0)then // 'A13D': ability "Combo Extend"
            // Increase l_hits by 4.
            set l_hits=l_hits+4.
        endif
        if(GetUnitAbilityLevel(u,'A13C')>0)then // 'A13C': ability "Combo Extend"
            // Increase l_hits by 3.
            set l_hits=l_hits+3.
        endif
        if(GetUnitAbilityLevel(u,'A13H')>0)then // 'A13H': ability "Mid Combo Potential"
            // Increase l_hits by 3.
            set l_hits=l_hits+3.
        endif
        if(GetUnitAbilityLevel(u,'A13B')>0)then // 'A13B': ability "Combo Extend"
            // Increase l_hits by 2.
            set l_hits=l_hits+2.
        endif
        if(GetUnitAbilityLevel(u,'A13A')>0)then // 'A13A': ability "Combo Extend"
            set l_hits=l_hits+1.
        endif
        set u=null
        // (l_hits) with its decimal part removed.
        return R2I(l_hits)
    else
        set u=null
        return 0
    endif
endfunction

function Trig_Damage_Engine_ComboEnd takes unit u returns nothing
    local timer tm=LoadTimerHandle(udg_ComboHash,GetHandleId(u),3)
    if tm==null then
        return
    endif
    call UnitRemoveAbility(u,'A137') // 'A137': ability "Combo Strike"
    call UnitRemoveAbility(u,'B07L') // 'B07L': buff tooltip "Renzokuken"
    call FlushChildHashtable(udg_ComboHash,GetHandleId(tm))
    call FlushChildHashtable(udg_ComboHash,GetHandleId(u))
    call DestroyTimer(tm)
    set tm=null
endfunction

function Trig_Damage_Engine_ComboExpire takes nothing returns nothing
    local unit u=LoadUnitHandle(udg_ComboHash,GetHandleId(GetExpiredTimer()),4)
    call Trig_Damage_Engine_ComboEnd(u)
    set u=null
endfunction

function Trig_Damage_Engine_ComboStart takes unit u,unit t returns nothing
    local timer tm
    local integer l_hits=Trig_Damage_Engine_GetComboHits(u)
    local texttag l_tag
    if(l_hits<2)then
        return
    endif
    set tm=CreateTimer()
    call SaveBoolean(udg_ComboHash,GetHandleId(u),0,true)
    call SaveUnitHandle(udg_ComboHash,GetHandleId(u),1,t)
    call SaveInteger(udg_ComboHash,GetHandleId(u),2,l_hits)
    call SaveTimerHandle(udg_ComboHash,GetHandleId(u),3,tm)
    call SaveUnitHandle(udg_ComboHash,GetHandleId(tm),4,u)
    call SaveInteger(udg_ComboHash,GetHandleId(u),5,2)
    set l_tag=CreateTextTag()
    call SaveTextTagHandle(udg_ComboHash,GetHandleId(u),6,l_tag)
    // (y position of u) plus (32).
    call SetTextTagPos(l_tag,GetUnitX(u),GetUnitY(u)+32.,0)
    call SetTextTagVelocity(l_tag,0,.036)
    call SetTextTagPermanent(l_tag,false)
    call SetTextTagLifespan(l_tag,1.)
    call UnitAddAbility(u,'A137') // 'A137': ability "Combo Strike"
    call TimerStart(tm,.5,false,function Trig_Damage_Engine_ComboExpire)
    set tm=null
    set u=null
    set t=null
endfunction

function Trig_Damage_Engine_RollBlock takes unit u,boolean l_physical,boolean l_magical returns boolean
    // A random whole number from 1 through 10.
    if(GetUnitAbilityLevel(u,'A0RT')>0 and GetRandomInt(1,$A)<=3)then // 'A0RT': ability "Interceptor Protection"; $A = 10
        return true
    endif
    if l_physical then
        // Calculation 1:
        // A random whole number from 1 through 100.
        // Calculation 2:
        // (2) times (LoadInteger(udg_RunicHash, GetHandleId(u), 6)).
        if(GetUnitAbilityLevel(u,'B07R')>0 and GetRandomInt(1,'d')<=(2*LoadInteger(udg_RunicHash,GetHandleId(u),6)))then // 'B07R': buff "Runic Shield"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0PP')>0 and GetRandomInt(1,'d')<=30)then // 'A0PP': ability "Defend"
            // A random whole number from 1 through 3.
            if(IsUnitInGroup(u,udg_DefendingUnits)or GetRandomInt(1,3)>1)then
                return true
            endif
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S0')>0 and GetRandomInt(1,'d')<=5)then // 'A0S0': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0P2')>0 and GetRandomInt(1,'d')<=$A)then // 'A0P2': ability "Block Phys"; $A = 10
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0PT')>0 and GetRandomInt(1,'d')<=$A)then // 'A0PT': ability "Block Phys"; $A = 10
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0AM')>0 and GetRandomInt(1,'d')<=18)then // 'A0AM': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A05B')>0 and GetRandomInt(1,'d')<=20)then // 'A05B': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S6')>0 and GetRandomInt(1,'d')<=20)then // 'A0S6': ability "Block Both"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0US')>0 and GetRandomInt(1,'d')<=20)then // 'A0US': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A07A')>0 and GetRandomInt(1,'d')<=25)then // 'A07A': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A05C')>0 and GetRandomInt(1,'d')<=25)then // 'A05C': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A05D')>0 and GetRandomInt(1,'d')<=30)then // 'A05D': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A05E')>0 and GetRandomInt(1,'d')<=35)then // 'A05E': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A05F')>0 and GetRandomInt(1,'d')<=40)then // 'A05F': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0QV')>0 and GetRandomInt(1,'d')<=40)then // 'A0QV': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0FK')>0 and GetRandomInt(1,'d')<=45)then // 'A0FK': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0CJ')>0 and GetRandomInt(1,'d')<=50)then // 'A0CJ': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A1CF')>0 and GetRandomInt(1,'d')<=55)then // 'A1CF': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0HG')>0 and GetRandomInt(1,'d')<=60)then // 'A0HG': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0JR')>0 and GetRandomInt(1,'d')<=85)then // 'A0JR': ability "Block Phys"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0D2')>0 and GetRandomInt(1,'d')<=90)then // 'A0D2': ability "Block Phys"
            return true
        endif
    elseif l_magical then
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'B07R')>0 and GetRandomInt(1,'d')<=LoadInteger(udg_RunicHash,GetHandleId(u),6))then // 'B07R': buff "Runic Shield"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S1')>0 and GetRandomInt(1,'d')<=$A)then // 'A0S1': ability "Block Mag"; $A = 10
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S2')>0 and GetRandomInt(1,'d')<=$F)then // 'A0S2': ability "Block Mag"; $F = 15
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S3')>0 and GetRandomInt(1,'d')<=20)then // 'A0S3': ability "Block Mag"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S6')>0 and GetRandomInt(1,'d')<=20)then // 'A0S6': ability "Block Both"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S4')>0 and GetRandomInt(1,'d')<=25)then // 'A0S4': ability "Block Mag"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A12W')>0 and GetRandomInt(1,'d')<=30)then // 'A12W': ability "Block Mag"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0WF')>0 and GetRandomInt(1,'d')<=35)then // 'A0WF': ability "Block Mag"
            return true
        endif
        // A random whole number from 1 through 100.
        if(GetUnitAbilityLevel(u,'A0S5')>0 and GetRandomInt(1,'d')<=40)then // 'A0S5': ability "Block Mag"
            return true
        endif
    endif
    return false
endfunction

function Trig_Damage_Engine_CheckBlock takes unit u,unit t,boolean l_physical,boolean l_magical returns boolean
    local integer l_prof
    if(l_physical and GetUnitAbilityLevel(u,'A0PQ')>0)or(l_magical and GetUnitAbilityLevel(u,'A0PR')>0)then // 'A0PQ': ability "Anti-Block Phys"; 'A0PR': ability "Anti-Block Mag"
        // A random whole number from 1 through 3.
        if(GetRandomInt(1,3)>1)then
            return false
        endif
    endif
    set l_prof=Prof_GetLevel(u,'R00B') // 'R00B': upgrade "Dagger"
    // A random whole number from 1 through (20) plus (l_prof).
    if(l_physical and l_prof>0 and GetRandomInt(1,20+l_prof)<=l_prof)then
        return false
    endif
    if Trig_Damage_Engine_RollBlock(t,l_physical,l_magical)then
        return true
    elseif l_magical then
        set l_prof=Prof_GetLevel(t,'R001') // 'R001': upgrade "Sword"
        // A random whole number from 1 through 50.
        if(l_prof>0 and GetRandomInt(1,50)<=l_prof and Trig_Damage_Engine_RollBlock(t,true,false))then
            return true
        endif
    endif
    return false
endfunction

function Trig_Damage_Engine_GetCritMult takes unit u returns real
    local real mp
    local integer l_bonus=GetUnitAbilityLevel(u,'A0TK') // 'A0TK': ability "MP Attack"
    if(GetUnitAbilityLevel(u,'B05K')>0 and l_bonus>0)then // 'B05K': buff tooltip "MP Attack"
        set mp=GetUnitState(u,UNIT_STATE_MANA)
        if(l_bonus>=6)then
            if(mp>150.)then
                // (mp) minus (150).
                call SetUnitState(u,UNIT_STATE_MANA,mp-150.)
                return 2.5
            endif
        // (20) plus ((20) times (l_bonus treated as a decimal-capable number)).
        elseif(mp>(20.+(20.*I2R(l_bonus))))then
            // (mp) minus ((30) plus ((10) times (l_bonus treated as a decimal-capable number))).
            call SetUnitState(u,UNIT_STATE_MANA,mp-(30.+(10.*I2R(l_bonus))))
            // (1.2) plus ((0.2) times (l_bonus treated as a decimal-capable number)).
            return 1.2+(.2*I2R(l_bonus))
        endif
    endif
    set l_bonus=Prof_GetLevel(u,'R00M') // 'R00M': upgrade "Gun"
    if(l_bonus>0 and Player_GetHero(GetOwningPlayer(u))==u)then
        set mp=TimerGetElapsed(udg_LastCritTimer[GetPlayerId(GetOwningPlayer(u))])
        // (((l_bonus) times (mp)) times (0.3)) with its decimal part removed.
        set l_bonus=R2I(l_bonus*mp*.3)
    else
        set l_bonus=0
    endif
    if(GetUnitAbilityLevel(u,'A0EC')>0)then // 'A0EC': editor label "Critical Strike"
        return .2
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0H6')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'A0H6': editor label "Critical Strike"
        return 4.3
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0NK')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'A0NK': editor label "Critical Strike"
        return 4.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (35) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0AJ')>0 and GetRandomInt(1,'d')<=35+l_bonus)then // 'A0AJ': editor label "Critical Strike"
        return 4.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (9) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0CL')>0 and GetRandomInt(1,'d')<=9+l_bonus)then // 'A0CL': editor label "Critical Strike"
        return 4.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (15) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0KU')>0 and GetRandomInt(1,'d')<=$F+l_bonus)then // 'A0KU': editor label "Critical Strike"; $F = 15
        return 4.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (10) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0H4')>0 and GetRandomInt(1,'d')<=$A+l_bonus)then // 'A0H4': editor label "Critical Strike"; $A = 10
        return 3.8
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (35) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0VA')>0 and GetRandomInt(1,'d')<=35+l_bonus)then // 'A0VA': editor label "Critical Strike"
        return 3.5
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (35) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0E2')>0 and GetRandomInt(1,'d')<=35+l_bonus)then // 'A0E2': editor label "Critical Strike"
        return 3.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (10) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0HQ')>0 and GetRandomInt(1,'d')<=$A+l_bonus)then // 'A0HQ': editor label "Critical Strike"; $A = 10
        return 3.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0I6')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'A0I6': editor label "Critical Strike"
        return 3.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (25) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A07G')>0 and GetRandomInt(1,'d')<=25+l_bonus)then // 'A07G': editor label "Critical Strike"
        return 3.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (25) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0BF')>0 and GetRandomInt(1,'d')<=25+l_bonus)then // 'A0BF': editor label "Critical Strike"
        return 3.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (15) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0H5')>0 and GetRandomInt(1,'d')<=$F+l_bonus)then // 'A0H5': editor label "Critical Strike"; $F = 15
        return 2.8
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (35) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0V9')>0 and GetRandomInt(1,'d')<=35+l_bonus)then // 'A0V9': editor label "Critical Strike"
        return 2.5
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (15) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A119')>0 and GetRandomInt(1,'d')<=$F+l_bonus)then // 'A119': editor label "Critical Strike"; $F = 15
        return 2.4
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0R6')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'A0R6': ability "Dexterity"
        return udg_DexterityCritMult
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if((GetUnitAbilityLevel(u,'AIcs')>0 or GetUnitAbilityLevel(u,'ACct')>0)and GetRandomInt(1,'d')<=20+l_bonus)then // 'AIcs': editor label "Critical Strike"; 'ACct': editor label "Critical Strike"
        return 2.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0BD')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'A0BD': editor label "Critical Strike"
        return 2.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (25) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0AF')>0 and GetRandomInt(1,'d')<=25+l_bonus)then // 'A0AF': editor label "Critical Strike"
        return 2.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (35) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A08N')>0 and GetRandomInt(1,'d')<=35+l_bonus)then // 'A08N': editor label "Critical Strike"
        return 2.
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0NP')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'A0NP': editor label "Critical Strike"
        return 1.8
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (15) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A118')>0 and GetRandomInt(1,'d')<=$F+l_bonus)then // 'A118': editor label "Critical Strike"; $F = 15
        return 1.8
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (15) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A116')>0 and GetRandomInt(1,'d')<=$F+l_bonus)then // 'A116': editor label "Critical Strike"; $F = 15
        return 1.6
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (30) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0BE')>0 and GetRandomInt(1,'d')<=30+l_bonus)then // 'A0BE': editor label "Critical Strike"
        return 1.5
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A0NN')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'A0NN': editor label "Critical Strike"
        return 1.5
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (20) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'B058')>0 and GetRandomInt(1,'d')<=20+l_bonus)then // 'B058': buff tooltip "Sharpshooter"
        return 1.5
    endif
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (15) plus (l_bonus).
    if(GetUnitAbilityLevel(u,'A115')>0 and GetRandomInt(1,'d')<=$F+l_bonus)then // 'A115': editor label "Critical Strike"; $F = 15
        return 1.4
    endif
    return 1.
endfunction

function Trig_Damage_Engine_GetSpeedBonus takes unit u returns real
    local real l_bonus=.0
    if udg_EternityMode and not IsUnitType(u,UNIT_TYPE_HERO)and GetOwningPlayer(u)==Player($B)then // $B = 11
        // Increase l_bonus by 20.
        set l_bonus=l_bonus+20.
    endif
    if(GetUnitAbilityLevel(u,'A0R6')>0)then // 'A0R6': ability "Dexterity"
        // (l_bonus) plus (udg_DexterityBonus).
        set l_bonus=l_bonus+udg_DexterityBonus
    endif
    if(GetUnitAbilityLevel(u,'A0HX')>0)then // 'A0HX': ability "Swiftness"
        // Increase l_bonus by 150.
        set l_bonus=l_bonus+150.
    endif
    if(GetUnitAbilityLevel(u,'A0AU')>0)then // 'A0AU': ability "Swiftness"
        // Increase l_bonus by 120.
        set l_bonus=l_bonus+120.
    endif
    if(GetUnitAbilityLevel(u,'A0DB')>0)then // 'A0DB': ability "Chocobo Swiftness"
        // Increase l_bonus by 100.
        set l_bonus=l_bonus+100.
    endif
    if(GetUnitAbilityLevel(u,'A0GY')>0)then // 'A0GY': ability "Swiftness"
        // Increase l_bonus by 80.
        set l_bonus=l_bonus+80.
    endif
    if(GetUnitAbilityLevel(u,'A0JL')>0)then // 'A0JL': ability "Swiftness"
        // Increase l_bonus by 50.
        set l_bonus=l_bonus+50.
    endif
    if(GetUnitAbilityLevel(u,'ACev')>0)then // 'ACev': ability "Swiftness"
        // Increase l_bonus by 30.
        set l_bonus=l_bonus+30.
    endif
    return l_bonus
endfunction

function Trig_Damage_Engine_GetAccuracy takes unit u returns real
    // Starting value for l_acc:
    // (Trig_Damage_Engine_GetSpeedBonus(u)) times (0.8).
    local real l_acc=Trig_Damage_Engine_GetSpeedBonus(u)*.8
    // Starting value for ms:
    // (GetUnitDefaultMoveSpeed(u)) minus ((Agility of u) times (0.4)).
    local real ms=GetUnitDefaultMoveSpeed(u)-(GetHeroAgi(u,true)*.4)
    if(ms<=80)then
        // Increase l_acc by 150.
        set l_acc=l_acc+$96 // $96 = 150
    else
        // (l_acc) plus (((ms) minus (80)) times (0.75)).
        set l_acc=l_acc+(ms-80)*.75
    endif
    if IsUnitType(u,UNIT_TYPE_HERO)then
        // (l_acc) plus ((Agility of u treated as a decimal-capable number) times (0.1)).
        set l_acc=l_acc+(I2R(GetHeroAgi(u,true))*.1)
    else
        // (l_acc) plus ((unit level of u treated as a decimal-capable number) times (0.4)).
        set l_acc=l_acc+(I2R(GetUnitLevel(u))*.4)
    endif
    if(GetUnitAbilityLevel(u,'A1DI')>0 or GetUnitAbilityLevel(u,'A1DJ')>0)then // 'A1DI': ability "Sukugaya Unit Attack Speed +20%"; 'A1DJ': ability "Sukugaya Hero Bonus"
        // Increase l_acc by 30.
        set l_acc=l_acc+30.
    endif
    if(GetUnitAbilityLevel(u,'A16L')>0)then // 'A16L': ability "Accuracy"
        // Increase l_acc by 70.
        set l_acc=l_acc+70.
    endif
    if(GetUnitAbilityLevel(u,'A16R')>0)then // 'A16R': ability "Accuracy"
        // Increase l_acc by 200.
        set l_acc=l_acc+200.
    endif
    if(GetUnitAbilityLevel(u,'A19E')>0)then // 'A19E': ability "Spear Accuracy"
        // Increase l_acc by 9.
        set l_acc=l_acc+9.
    endif
    if(GetUnitAbilityLevel(u,'A19G')>0)then // 'A19G': ability "Spear Accuracy"
        // Increase l_acc by 20.
        set l_acc=l_acc+20.
    endif
    if(GetUnitAbilityLevel(u,'A19F')>0)then // 'A19F': ability "Spear Accuracy"
        // Increase l_acc by 30.
        set l_acc=l_acc+30.
    endif
    if(GetUnitAbilityLevel(u,'A19H')>0)then // 'A19H': ability "Spear Accuracy"
        // Increase l_acc by 35.
        set l_acc=l_acc+35.
    endif
    if(GetUnitAbilityLevel(u,'A1A1')>0)then // 'A1A1': ability "Spear Hybrid"
        // Increase l_acc by 35.
        set l_acc=l_acc+35.
    endif
    if(GetUnitAbilityLevel(u,'A19J')>0)then // 'A19J': ability "Spear Accuracy"
        // Increase l_acc by 40.
        set l_acc=l_acc+40.
    endif
    if(GetUnitAbilityLevel(u,'A19I')>0)then // 'A19I': ability "Spear Accuracy"
        // Increase l_acc by 50.
        set l_acc=l_acc+50.
    endif
    if(GetUnitAbilityLevel(u,'A19D')>0)then // 'A19D': ability "Spear Accuracy"
        // Increase l_acc by 60.
        set l_acc=l_acc+60.
    endif
    if(GetUnitAbilityLevel(u,'A19K')>0)then // 'A19K': ability "Spear Accuracy"
        // Increase l_acc by 75.
        set l_acc=l_acc+75.
    endif
    if(GetUnitAbilityLevel(u,'A18O')>0)then // 'A18O': ability "Strange Vision Accuracy"
        // Increase l_acc by 255.
        set l_acc=l_acc+255.
    endif
    if(GetUnitAbilityLevel(u,'A068')>0)then // 'A068': ability "Glasses Accuracy"
        // Increase l_acc by 40.
        set l_acc=l_acc+40.
    endif
    if(GetUnitAbilityLevel(u,'A02D')>0)then // 'A02D': ability "Rabite's Foot"
        // Increase l_acc by 120.
        set l_acc=l_acc+120.
    endif
    return l_acc
endfunction

function Trig_Damage_Engine_GetEvasion takes unit u returns real
    local real l_eva=Trig_Damage_Engine_GetSpeedBonus(u)
    // Starting value for ms:
    // (GetUnitDefaultMoveSpeed(u)) minus ((Agility of u) times (0.4)).
    local real ms=GetUnitDefaultMoveSpeed(u)-(GetHeroAgi(u,true)*.4)
    if(GetUnitAbilityLevel(u,'A0EI')>0)then // 'A0EI': ability "Adamant Armor"
        return .0
    endif
    if(ms>80)then
        // (l_eva) plus (((ms) minus (80)) times (0.25)).
        set l_eva=l_eva+(ms-80)*.25
    endif
    if(IsUnitType(u,UNIT_TYPE_HERO)and GetUnitAbilityLevel(u,'A02M')<=0)then // 'A02M': ability "No Evasion From Agility"
        // Result 1: Agility of u treated as a decimal-capable number.
        // Result 2: (result 1) times (0.005).
        // Result 3: (Prof_GetLevel(u, 'R006')) plus (20).
        // Result 4: result 3 treated as a decimal-capable number.
        // Result 5: (result 2) times (result 4).
        // Result 6: (l_eva) plus (result 5).
        set l_eva=l_eva+(I2R(GetHeroAgi(u,true))*.005*I2R(Prof_GetLevel(u,'R006')+20)) // 'R006': upgrade "Leather Armor"
    else
        // (l_eva) plus ((unit level of u treated as a decimal-capable number) times (0.5)).
        set l_eva=l_eva+(I2R(GetUnitLevel(u))*.5)
    endif
    if(GetUnitAbilityLevel(u,'A1DI')>0 or GetUnitAbilityLevel(u,'A1DJ')>0)then // 'A1DI': ability "Sukugaya Unit Attack Speed +20%"; 'A1DJ': ability "Sukugaya Hero Bonus"
        // Increase l_eva by 15.
        set l_eva=l_eva+15.
    endif
    if(GetUnitAbilityLevel(u,'A1DB')>0)then // 'A1DB': ability "Evasion"
        // Decrease l_eva by 80.
        set l_eva=l_eva-80.
    endif
    if(GetUnitAbilityLevel(u,'A16S')>0)then // 'A16S': ability "Evasion"
        // Increase l_eva by 60.
        set l_eva=l_eva+60.
    endif
    if(GetUnitAbilityLevel(u,'A182')>0)then // 'A182': ability "Kazuma Effect"
        // Increase l_eva by 30.
        set l_eva=l_eva+30.
    endif
    if(GetUnitAbilityLevel(u,'AIev')>0)then // 'AIev': ability "Jade Collar Evasion"
        // Increase l_eva by 30.
        set l_eva=l_eva+30.
    endif
    if(GetUnitAbilityLevel(u,'A0QB')>0)then // 'A0QB': ability "Main Gauche Evasion"
        // Increase l_eva by 50.
        set l_eva=l_eva+50.
    endif
    if(GetUnitAbilityLevel(u,'A1B6')>0)then // 'A1B6': ability "Slither Shield Evasion"
        // Increase l_eva by 50.
        set l_eva=l_eva+50.
    endif
    if(GetUnitAbilityLevel(u,'A02D')>0)then // 'A02D': ability "Rabite's Foot"
        // Increase l_eva by 80.
        set l_eva=l_eva+80.
    endif
    if(l_eva<0)then
        set l_eva=.0
    endif
    return l_eva
endfunction

function Trig_Damage_Engine_RollMiss takes unit l_attacker,unit targetUnit,boolean l_magical returns boolean
    local real successChance
    // Starting value for l_pid:
    // (GetPlayerId(GetOwningPlayer(targetUnit))) plus (1).
    local integer l_pid=GetPlayerId(GetOwningPlayer(targetUnit))+1
    if(GetUnitAbilityLevel(targetUnit,'B05M')>0 or GetUnitAbilityLevel(targetUnit,'B05N')>0)then // 'B05M': buff tooltip "Immobilize"; 'B05N': buff tooltip "Immobilize"
        return false
    endif
    if(GetUnitAbilityLevel(targetUnit,'A0EI')>0)then // 'A0EI': ability "Adamant Armor"
        return false
    endif
    if(GetUnitAbilityLevel(l_attacker,'B02V')>0)then // 'B02V': buff tooltip "Total Blind"
        return true
    endif
    set successChance=Trig_Damage_Engine_GetEvasion(targetUnit)
    if(successChance<=0)then
        return false
    endif
    // (Trig_Damage_Engine_GetAccuracy(l_attacker)) minus (chance).
    set successChance=Trig_Damage_Engine_GetAccuracy(l_attacker)-successChance
    if(GetUnitAbilityLevel(l_attacker,'B00X')>0)then // 'B00X': buff tooltip "Blessing of Might"
        // Increase chance by 25.
        set successChance=successChance+25.
    endif
    if(GetUnitAbilityLevel(targetUnit,'B00X')>0)then // 'B00X': buff tooltip "Blessing of Might"
        // Decrease chance by 25.
        set successChance=successChance-25.
    endif
    if(GetUnitAbilityLevel(l_attacker,'B003')>0)then // 'B003': buff tooltip "Oil"
        // Decrease chance by 40.
        set successChance=successChance-40.
    endif
    if(not l_magical and GetUnitAbilityLevel(targetUnit,'B06W')>0)then // 'B06W': buff tooltip "Mirage"
        // Decrease chance by 40.
        set successChance=successChance-40.
    endif
    if(GetUnitAbilityLevel(targetUnit,'A1B8')>0)then // 'A1B8': ability "Mirage Vest Evasion"
        // (chance) minus ((100) times ((1) minus ((current health of targetUnit) divided by (maximum health of
        // targetUnit)))).
        set successChance=successChance-('d'*(1.-(GetUnitState(targetUnit,UNIT_STATE_LIFE)/ GetUnitState(targetUnit,UNIT_STATE_MAX_LIFE))))
    endif
    if(GetUnitAbilityLevel(l_attacker,'B01F')>0)then // 'B01F': buff tooltip "Aim"
        // Increase chance by 40.
        set successChance=successChance+40.
    endif
    if l_magical then
        // Increase chance by 30.
        set successChance=successChance+30.
    endif
    if(successChance<75)then
        // ((chance) plus (75)) times (0.5).
        set successChance=(successChance+75)*.5
    endif
    if(successChance<50)then
        // ((chance) plus (50)) times (0.5).
        set successChance=(successChance+50)*.5
    endif
    if(successChance>=2)then
        if(GetUnitAbilityLevel(l_attacker,'B00P')>0)then // 'B00P': buff tooltip "Blind"
            // (chance) times (0.5).
            set successChance=successChance*.5
        endif
        if(not l_magical and GetUnitAbilityLevel(targetUnit,'B06W')>0)then // 'B06W': buff tooltip "Mirage"
            // (chance) times (0.8).
            set successChance=successChance*.8
        endif
    endif
    if(successChance>=$96)then // $96 = 150
        return false
    endif
    if(GetUnitAbilityLevel(targetUnit,'B050')>0)then // 'B050': buff tooltip "Evade and Counter"
        return true
    endif
    // (0.5) plus ((chance) times (0.01)).
    if(not l_magical and IsPlayerInForce(GetOwningPlayer(targetUnit),udg_ActivePlayers)and targetUnit==Player_GetHero(GetOwningPlayer(targetUnit))and TimerGetRemaining(udg_DodgeSaveTimer[l_pid])>(.5+(successChance*.01)))then
        call TimerStart(udg_DodgeSaveTimer[l_pid],.01,false,null)
        return true
    endif
    if(successChance<25 and IsPlayerInForce(GetOwningPlayer(targetUnit),udg_ActivePlayers))then
        // ((chance) plus (25)) times (0.5).
        set successChance=(successChance+25)*.5
    endif
    if(successChance<2)then
        set successChance=2.
    elseif(successChance>98)then
        set successChance=98.
    endif
    // A random decimal number between 0 and 100.
    return(GetRandomReal(0,'d')>=successChance)
endfunction

function Trig_Damage_Engine_RengekiEnd takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local unit u=LoadUnitHandle(udg_RunicHash,GetHandleId(expiredTimer),2)
    call GroupRemoveUnit(udg_RengekiGroup,u)
    call SaveInteger(udg_RunicHash,GetHandleId(u),3,0)
    call FlushChildHashtable(udg_RunicHash,GetHandleId(expiredTimer))
    call UnitRemoveAbility(u,'A13T') // 'A13T': ability "Rengeki Bonus"
    call UnitRemoveAbility(u,'A14C') // 'A14C': ability "Rengeki Bonus"
    call UnitRemoveAbility(u,'B074') // 'B074': buff "Rengeki"
    call DestroyTimer(expiredTimer)
    set u=null
    set expiredTimer=null
endfunction

function Trig_Damage_Engine_RengekiStack takes unit u returns nothing
    local timer t
    local integer l_stacks
    if(IsUnitInGroup(u,udg_RengekiGroup))then
        // (LoadInteger(udg_RunicHash, GetHandleId(u), 3)) plus (1).
        set l_stacks=LoadInteger(udg_RunicHash,GetHandleId(u),3)+1
        if(l_stacks<=30)then
            call SaveInteger(udg_RunicHash,GetHandleId(u),3,l_stacks)
            // The remainder after dividing (l_stacks) by (10).
            if(ModuloInteger(l_stacks,$A)==0)then // $A = 10
                call UnitRemoveAbility(u,'A14C') // 'A14C': ability "Rengeki Bonus"
                call UnitRemoveAbility(u,'B074') // 'B074': buff "Rengeki"
                call UnitAddAbility(u,'A14C') // 'A14C': ability "Rengeki Bonus"
                // (l_stacks) divided by (10); drop the remainder.
                call SetUnitAbilityLevel(u,'A14C',l_stacks/ $A) // 'A14C': ability "Rengeki Bonus"; $A = 10
            endif
            if(l_stacks==$A)then // $A = 10
                set t=LoadTimerHandle(udg_RunicHash,GetHandleId(u),4)
                call TimerStart(t,15.,false,function Trig_Damage_Engine_RengekiEnd)
            elseif(l_stacks<$A)then // $A = 10
                set t=LoadTimerHandle(udg_RunicHash,GetHandleId(u),4)
                call TimerStart(t,3.,false,function Trig_Damage_Engine_RengekiEnd)
            endif
        endif
    else
        call GroupAddUnit(udg_RengekiGroup,u)
        set t=CreateTimer()
        call SaveUnitHandle(udg_RunicHash,GetHandleId(t),2,u)
        call SaveInteger(udg_RunicHash,GetHandleId(u),3,1)
        call SaveTimerHandle(udg_RunicHash,GetHandleId(u),4,t)
        call TimerStart(t,3.,false,function Trig_Damage_Engine_RengekiEnd)
    endif
endfunction

function Trig_Damage_Engine_IsBehind takes real ux,real uy,real tx,real ty,real l_facing returns boolean
    // Starting value for dx:
    // (tx) minus (ux).
    local real dx=tx-ux
    // Starting value for dy:
    // (ty) minus (uy).
    local real dy=ty-uy
    // Starting value for l_distSq:
    // (the square of (dx)) plus (the square of (dy)).
    local real l_distSq=dx*dx+dy*dy
    // Starting value for angle:
    // (the angle in radians from the y gap (dy) and x gap (dx)) times (bj_RADTODEG).
    local real angle=Atan2(dy,dx)*bj_RADTODEG
    // Starting value for l_diff:
    // The remainder after dividing ((l_facing) minus (angle)) by (360).
    local real l_diff=ModuloReal(l_facing-angle,360.)
    if(l_distSq>65336.)then
        return false
    endif
    if(l_diff>$B4)then // $B4 = 180
        // (360) minus (l_diff).
        set l_diff=360-l_diff
    endif
    return(l_diff<20)
endfunction

function Trig_Damage_Engine_FilterAlive takes nothing returns boolean
    return(GetWidgetLife(GetFilterUnit())>.405 and GetUnitAbilityLevel(GetFilterUnit(),'Avul')<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Damage_Engine_BlockEffectPath takes boolean l_physical returns string
    if l_physical then
        return "Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl"
    else
        return "Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl"
    endif
endfunction

function Trig_Damage_Engine_AwardGeomancer takes nothing returns nothing
    local unit u=udg_SplashSource
    local player up=GetOwningPlayer(u)
    if(udg_SplashTally>=200000. and GetUnitAbilityLevel(u,'B05J')>0 and GetUnitTypeId(u)=='H00D' and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(up,udg_JobMasterForce[5]))then // 'B05J': buff "Blitz"; 'H00D': unit "Geomancer"; 'A02F': ability "Mastery"
        call ForceAddPlayer(udg_JobMasterForce[5],up)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
    endif
    set udg_SplashTally=-1.
    set u=null
    set up=null
endfunction

function Trig_Damage_Engine_AwardSorcerer takes nothing returns nothing
    local timer tm=GetExpiredTimer()
    local integer i=0
    local player p
    local unit u
    loop
        exitwhen(tm==udg_SleepWakeTimer[i]or i>7)
        set i=i+1
    endloop
    set tm=null
    if i>7 then
        return
    endif
    set p=Player(i)
    set u=Player_GetHero(p)
    // (i) plus (1).
    if(GetWidgetLife(udg_SleepTarget[i+1])<=.405 and GetUnitTypeId(u)=='H00L' and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(p,udg_JobMasterForce[19]))then // 'H00L': unit "Sorcerer"; 'A02F': ability "Mastery"
        call ForceAddPlayer(udg_JobMasterForce[19],p)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
    endif
    set u=null
    set p=null
endfunction

function Trig_Damage_Engine_ToAttackType takes integer l_kind returns attacktype
    if l_kind==1 then
        return ATTACK_TYPE_NORMAL
    elseif l_kind==2 then
        return ATTACK_TYPE_MELEE
    elseif l_kind==3 then
        return ATTACK_TYPE_PIERCE
    elseif l_kind==4 then
        return ATTACK_TYPE_SIEGE
    elseif l_kind==5 then
        return ATTACK_TYPE_MAGIC
    elseif l_kind==6 then
        return ATTACK_TYPE_CHAOS
    elseif l_kind==7 then
        return ATTACK_TYPE_HERO
    endif
    return null
endfunction

function Trig_Damage_Engine_UnshareVisionEnum takes nothing returns nothing
    call UnitShareVision(Player_GetHero(GetEnumPlayer()),Player($B),false) // $B = 11
endfunction

function Trig_Damage_Engine_UnshareVision takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Damage_Engine_UnshareVisionEnum)
endfunction

function Trig_Damage_Engine_ProxyDamageApply takes integer dh,unit t,real l_amount returns nothing
    local unit u=LoadUnitHandle(udg_ProxyDamageHash,dh,0)
    local group l_hitGroup=LoadGroupHandle(udg_ProxyDamageHash,dh,6)
    local real l_stored
    local boolean l_ranged=true
    local attacktype l_atype
    local damagetype l_dtype
    local integer l_dmgKind=LoadInteger(udg_ProxyDamageHash,dh,2)
    if(u!=null and not IsUnitInGroup(t,l_hitGroup))then
        if l_hitGroup!=null then
            call GroupAddUnit(l_hitGroup,t)
        endif
        set l_stored=LoadReal(udg_ProxyDamageHash,dh,1)
        if(l_stored>.0)then
            if(LoadBoolean(udg_ProxyDamageHash,dh,8))then
                call DisplayTimedTextToForce(GetPlayersAll(),10.,"DEBUG: "+GetUnitName(u)+" deals "+R2S(l_stored)+" damage.")
            else
                set l_amount=l_stored
                if LoadBoolean(udg_ProxyDamageHash,dh,4)then
                    // (amount) times (0.8).
                    call SaveReal(udg_ProxyDamageHash,dh,1,l_amount*.8)
                endif
            endif
        endif
    else
        set l_amount=.0
    endif
    if(l_amount>.0)then
        if(u==Player_GetHero(GetOwningPlayer(u)))then
            call UnitShareVision(u,Player($B),true) // $B = 11
            call TimerStart(udg_VisionShareTimer,3.,false,function Trig_Damage_Engine_UnshareVision)
        endif
        set udg_IsPhysicalAttack=false
        if(l_dmgKind==4)then
            set l_atype=ATTACK_TYPE_CHAOS
            set l_dtype=DAMAGE_TYPE_UNIVERSAL
            set udg_DmgFlagPure=true
        else
            set udg_DmgFlagPure=false
            if(l_dmgKind==3)then
                set l_atype=ATTACK_TYPE_NORMAL
                set l_dtype=DAMAGE_TYPE_MAGIC
            else
                set l_atype=Trig_Damage_Engine_ToAttackType(LoadInteger(udg_ProxyDamageHash,dh,3))
                set l_dtype=DAMAGE_TYPE_NORMAL
                set udg_IsPhysicalAttack=true
                set l_ranged=(l_dmgKind==2)
            endif
        endif
        if LoadBoolean(udg_ProxyDamageHash,dh,7)then
            set udg_DmgFlagUnavoidable=-1
        endif
        if LoadBoolean(udg_ProxyDamageHash,dh,5)then
            set udg_DmgFlagNoCrit=-1.
        endif
        call UnitDamageTarget(u,t,l_amount,true,l_ranged,l_atype,l_dtype,null)
    endif
    set u=null
    set t=null
    set l_hitGroup=null
endfunction

function Trig_Damage_Engine_PostDamageEffects takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local real tx=GetUnitX(triggeringUnit)
    local real ty=GetUnitY(triggeringUnit)
    local player tp=GetOwningPlayer(triggeringUnit)
    // Starting value for l_pid:
    // (GetPlayerId(tp)) plus (1).
    local integer l_pid=GetPlayerId(tp)+1
    local real l_amount=GetEventDamage()
    local texttag tt
    set udg_DmgFlagUnavoidable=0
    set udg_DamageElement=0
    set udg_DmgFlagMelee=false
    set udg_IsPhysicalAttack=false
    set udg_DmgFlagPure=false
    set udg_IgnoresReduction=false
    set udg_DmgFlagRedirected=false
    set udg_IsPureDamage=false
    set udg_DmgFlagManaDamage=false
    set udg_DmgFlagHealUndead=false
    set udg_DmgFlagNoCrit=1.
    if(l_amount>.0)then
        call UnitRemoveAbility(triggeringUnit,'B03W') // 'B03W': buff tooltip "Cat's Ring"
        call UnitRemoveAbility(triggeringUnit,'B041') // 'B041': buff tooltip "Cat's Ring"
        call UnitRemoveAbility(triggeringUnit,'B040') // 'B040': buff tooltip "Mana Ring"
        call UnitRemoveAbility(triggeringUnit,'B042') // 'B042': buff tooltip "Mana Ring"
    endif
    if(not udg_InCinematicMode and triggeringUnit==Player_GetHero(tp)and udg_GatherState[l_pid]==1)then
        set udg_GatherState[l_pid]=0
        call RemoveItem(udg_GatherItem[l_pid])
        call UnitRemoveAbility(triggeringUnit,'A0VJ') // 'A0VJ': ability "Unaffected by Cinematics"
        call PauseUnit(triggeringUnit,false)
    endif
    call TimerStart(udg_StunReapplyTimer,.0,false,function Trig_Damage_Engine_ReapplyStuns)
    if(GetUnitAbilityLevel(triggeringUnit,'A0GJ')>0)then // 'A0GJ': ability "Auto-Haste"
        call UnitRemoveAbility(triggeringUnit,'B00F') // 'B00F': buff "Haste"
        call UnitRemoveAbility(triggeringUnit,'Bslo') // 'Bslo': buff tooltip "Slow"
    endif
    if(GetUnitAbilityLevel(triggeringUnit,'A0WE')>0)then // 'A0WE': ability "Auto-Bravery"
        call UnitRemoveAbility(triggeringUnit,'B01W') // 'B01W': buff "Bravery"
        call UnitRemoveAbility(triggeringUnit,'B06H') // 'B06H': buff "Pain"
    endif
    if(GetUnitAbilityLevel(triggeringUnit,'A0WG')>0)then // 'A0WG': ability "Auto-Faith"
        call UnitRemoveAbility(triggeringUnit,'B05A') // 'B05A': buff "Faith"
        call UnitRemoveAbility(triggeringUnit,'B06I') // 'B06I': buff "Fog"
    endif
    if(GetUnitAbilityLevel(triggeringUnit,'A15P')>0 or GetUnitAbilityLevel(triggeringUnit,'A15Q')>0)then // 'A15P': ability "Auto-Protect"; 'A15Q': ability "Auto-Deprotect"
        call UnitRemoveAbility(triggeringUnit,'B007') // 'B007': buff "Protect"
        call UnitRemoveAbility(triggeringUnit,'B06J') // 'B06J': buff tooltip "Deprotect"
    endif
    if(GetUnitAbilityLevel(triggeringUnit,'A15R')>0 or GetUnitAbilityLevel(triggeringUnit,'A15S')>0)then // 'A15R': ability "Auto-Shell"; 'A15S': ability "Auto-Deshell"
        call UnitRemoveAbility(triggeringUnit,'B005') // 'B005': buff "Shell"
        call UnitRemoveAbility(triggeringUnit,'B06K') // 'B06K': buff tooltip "Deshell"
    endif
    if(IsUnitInGroup(triggeringUnit,udg_BerserkGroup)or IsUnitInGroup(triggeringUnit,udg_VirusImmuneGroup))then
        call TimerStart(udg_MaxHpDrainTimer,.0,false,null)
    endif
    // (amount) plus (1).
    if(l_amount+1>=GetWidgetLife(triggeringUnit))then
        if(GetUnitAbilityLevel(triggeringUnit,'A0ZR')>0 or GetUnitAbilityLevel(triggeringUnit,'B06L')>0 or GetUnitAbilityLevel(triggeringUnit,'A0X2')>0)then // 'A0ZR': ability "Immortal"; 'B06L': buff tooltip "Trance"; 'A0X2': ability "Perma Cover"
            set udg_ImmortalLife=GetWidgetLife(triggeringUnit)
            set udg_ImmortalDamage=l_amount
            set udg_ImmortalUnit=triggeringUnit
            set udg_ImmortalSource=GetEventDamageSource()
            call BlzSetEventDamage(.0)
            call SetUnitState(triggeringUnit,UNIT_STATE_LIFE,1.)
            if(GetUnitAbilityLevel(triggeringUnit,'A0Y2')>0 or GetUnitAbilityLevel(triggeringUnit,'A0RO')>0 or GetUnitAbilityLevel(triggeringUnit,'A0XS')>0)then // 'A0Y2': ability "Arcanium Immortality"; 'A0RO': ability "Arm Destruction"; 'A0XS': ability "Arm Destruction"
                call BattleLog_ShowUnit("collapses.",triggeringUnit)
                call Berserk_Remove(triggeringUnit)
                call PauseUnit(triggeringUnit,true)
                call SetUnitInvulnerable(triggeringUnit,true)
                call IssueImmediateOrderById(triggeringUnit,$D0019) // $D0019 = 851993
                if(GetUnitAbilityLevel(triggeringUnit,'A0RO')>0 or GetUnitAbilityLevel(triggeringUnit,'A0XS')>0)then // 'A0RO': ability "Arm Destruction"; 'A0XS': ability "Arm Destruction"
                    set udg_PenanceArmsActive=false
                    call UnitRemoveAbility(triggeringUnit,'A0RP') // 'A0RP': ability "Shielding Arm"
                    call UnitRemoveAbility(triggeringUnit,'A0XP') // 'A0XP': ability "Shielding Arm"
                endif
                call UnitAddAbility(triggeringUnit,'A0T5') // 'A0T5': ability "Fast Regeneration"
                call UnitAddType(triggeringUnit,UNIT_TYPE_PEON)
                call SetUnitAnimation(triggeringUnit,"death")
                call QueueUnitAnimation(triggeringUnit,"sleep")
                call Wait_Polled(.5)
                call UnitRemoveAbility(triggeringUnit,'BPSE') // 'BPSE': buff tooltip "Stunned"
                call UnitRemoveAbility(triggeringUnit,'B00I') // 'B00I': buff tooltip "Hell Ivy"
                call UnitRemoveAbility(triggeringUnit,'B00L') // 'B00L': buff tooltip "Freeze"
                call UnitRemoveAbility(triggeringUnit,'B00E') // 'B00E': buff tooltip "Stop"
                call UnitRemoveAbility(triggeringUnit,'B00V') // 'B00V': buff tooltip "Blizzaga"
                call UnitRemoveAbility(triggeringUnit,'B01Y') // 'B01Y': buff tooltip "Holy Blast"
                call UnitRemoveAbility(triggeringUnit,'B05M') // 'B05M': buff tooltip "Immobilize"
                call UnitRemoveAbility(triggeringUnit,'B05N') // 'B05N': buff tooltip "Immobilize"
                call Wait_Polled(33.5)
                if(GetWidgetLife(triggeringUnit)>.405)then
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl",triggeringUnit,"origin"))
                    call SetUnitAnimation(triggeringUnit,"birth")
                    call QueueUnitAnimation(triggeringUnit,"stand")
                    call Wait_Polled(1.)
                    if(GetWidgetLife(triggeringUnit)>.405)then
                        call SetUnitState(triggeringUnit,UNIT_STATE_LIFE,GetUnitState(triggeringUnit,UNIT_STATE_MAX_LIFE))
                        call SetUnitInvulnerable(triggeringUnit,false)
                        call UnitRemoveType(triggeringUnit,UNIT_TYPE_PEON)
                        call IssueImmediateOrderById(triggeringUnit,$D0004) // $D0004 = 851972
                        if(GetUnitAbilityLevel(triggeringUnit,'A0RO')>0)then // 'A0RO': ability "Arm Destruction"
                            call UnitAddAbility(triggeringUnit,'A0RP') // 'A0RP': ability "Shielding Arm"
                        elseif(GetUnitAbilityLevel(triggeringUnit,'A0XS')>0)then // 'A0XS': ability "Arm Destruction"
                            call UnitAddAbility(triggeringUnit,'A0XP') // 'A0XP': ability "Shielding Arm"
                        endif
                        call UnitRemoveAbility(triggeringUnit,'A0T5') // 'A0T5': ability "Fast Regeneration"
                        call PauseUnit(triggeringUnit,false)
                    endif
                endif
            elseif(GetUnitAbilityLevel(triggeringUnit,'A11V')>0)then // 'A11V': ability "Penance Morph"
                call BattleLog_ShowUnit("transforms!",triggeringUnit)
                call UnitAddAbility(triggeringUnit,'Arav') // 'Arav': object name not found in map data
                call UnitRemoveAbility(triggeringUnit,'Arav') // 'Arav': object name not found in map data
                call UnitRemoveAbility(triggeringUnit,'A11V') // 'A11V': ability "Penance Morph"
                call PauseUnit(triggeringUnit,true)
                call SetUnitAnimation(triggeringUnit,"morph")
                call UnitRemoveAbility(triggeringUnit,'A0ZM') // 'A0ZM': ability "Earth Smash"
                call UnitRemoveAbility(triggeringUnit,'A0WN') // 'A0WN': ability "Physical Hardness"
                call UnitRemoveAbility(triggeringUnit,'A0WP') // 'A0WP': ability "Magical Hardness"
                call UnitRemoveAbility(triggeringUnit,'A0ME') // 'A0ME': ability "Omni Ward"
                call SetUnitFlyHeight(triggeringUnit,500.,200.)
                call Wait_Polled(2.)
                call AddUnitAnimationProperties(triggeringUnit,"alternate",true)
                call SetUnitState(triggeringUnit,UNIT_STATE_LIFE,GetUnitState(triggeringUnit,UNIT_STATE_MAX_LIFE))
                call UnitRemoveAbility(triggeringUnit,'A0ZR') // 'A0ZR': ability "Immortal"
                call GroupAddUnit(udg_PenanceUnits,triggeringUnit)
                call EnableTrigger(gg_trg_Boss_Penance_Judgment_Loop)
                call EnableTrigger(gg_trg_Boss_Penance_Arm_Death)
                call PauseUnit(triggeringUnit,false)
            endif
        else
            if(GetUnitAbilityLevel(triggeringUnit,'B02X')>0)then // 'B02X': buff tooltip "Auto-Life"
                call BattleLog_ShowUnit("revives through |cffffcc00Auto-Life|r.",triggeringUnit)
                call BlzSetEventDamage(.0)
                call Berserk_Remove(triggeringUnit)
                // (maximum health of triggeringUnit) times (0.5).
                call SetUnitState(triggeringUnit,UNIT_STATE_LIFE,GetUnitState(triggeringUnit,UNIT_STATE_MAX_LIFE)*.5)
                call UnitRemoveAbility(triggeringUnit,'B02X') // 'B02X': buff tooltip "Auto-Life"
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",triggeringUnit,"origin"))
                set tt=CreateTextTag()
                call SetTextTagText(tt,"|cffffcc00AUTO-LIFE",.028)
                // (ty) plus (64).
                call SetTextTagPos(tt,tx,ty+64,.0)
                call SetTextTagColor(tt,$FF,$FF,$FF,$FF) // $FF = 255
                call SetTextTagVelocity(tt,.0,.044375)
                call SetTextTagPermanent(tt,false)
                call SetTextTagLifespan(tt,1.3)
                call SetTextTagFadepoint(tt,.8)
                if(not IsPlayerInForce(GetLocalPlayer(),udg_AbilityTextForce))then
                    call SetTextTagVisibility(tt,false)
                endif
                set tt=null
            elseif(GetUnitAbilityLevel(triggeringUnit,'A14S')>0 and not IsUnitInGroup(triggeringUnit,udg_UndyingGroup))then // 'A14S': ability "Endure"
                call BattleLog_ShowUnit("endures death through |cffffcc00Undying|r.",triggeringUnit)
                call BlzSetEventDamage(.0)
                call Berserk_Remove(triggeringUnit)
                // (maximum health of triggeringUnit) times (0.25).
                call SetUnitState(triggeringUnit,UNIT_STATE_LIFE,GetUnitState(triggeringUnit,UNIT_STATE_MAX_LIFE)*.25)
                call BlzUnitDisableAbility(triggeringUnit,'A14T',true,false) // 'A14T': ability "Undying"
                call GroupAddUnit(udg_UndyingGroup,triggeringUnit)
                call DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl",triggeringUnit,"origin"))
                set tt=CreateTextTag()
                call SetTextTagText(tt,"|cffffcc00UNDYING",.028)
                // (ty) plus (64).
                call SetTextTagPos(tt,tx,ty+64,.0)
                call SetTextTagColor(tt,$FF,$FF,$FF,$FF) // $FF = 255
                call SetTextTagVelocity(tt,.0,.044375)
                call SetTextTagPermanent(tt,false)
                call SetTextTagLifespan(tt,1.3)
                call SetTextTagFadepoint(tt,.8)
                if(not IsPlayerInForce(GetLocalPlayer(),udg_AbilityTextForce))then
                    call SetTextTagVisibility(tt,false)
                endif
                set tt=null
                call Wait_Polled(30.)
                call BlzUnitDisableAbility(triggeringUnit,'A14T',false,false) // 'A14T': ability "Undying"
                call GroupRemoveUnit(udg_UndyingGroup,triggeringUnit)
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl",triggeringUnit,"origin"))
            endif
        endif
    endif
    set triggeringUnit=null
    set tp=null
endfunction

// Releases the context slot of a finished CalcDamage call.
function Trig_Damage_Engine_FreeContext takes integer c returns nothing
    set DmgCtx_Source[c]=null
    set DmgCtx_Target[c]=null
    set DmgCtx_SourcePlayer[c]=null
    set DmgCtx_TargetPlayer[c]=null
    set DmgCtx_Dummy[c]=null
    set DmgCtx_Tag[c]=null
    set DmgCtx_Depth=c-1
endfunction

// Step 1 - Setup: negative amounts become 0; the target's armor becomes a multiplier
// (1 + 0.02 per armor point) that later steps use to apply or undo armor.
function Trig_Damage_Engine_Step01_Setup takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local boolean l_unavoidable=DmgCtx_Unavoidable[c]
    local integer l_blockCode=DmgCtx_BlockCode[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    if(l_amount<1.)then
        set l_amount=.0
    endif
    if(l_armorMult>.0)then
        // ((l_armorMult) times (0.02)) plus (1).
        set l_armorMult=(l_armorMult*.02)+1.
    else
        set l_armorMult=1.
    endif
    // Unavoidable damage can never be evaded or blocked.
    if l_unavoidable then
        set l_blockCode=-1
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_BlockCode[c]=l_blockCode
    set DmgCtx_ArmorMult[c]=l_armorMult
endfunction

// Step 2 - Healing an undead or Zombie target hurts it instead (x1.5, counts as holy).
function Trig_Damage_Engine_Step02_HealingUndead takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_holy=DmgCtx_Holy[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_healUndead=DmgCtx_HealUndead[c]
    local boolean l_pure=DmgCtx_Pure[c]
    if(l_heal and not l_healUndead and(IsUnitType(t,UNIT_TYPE_UNDEAD)or GetUnitAbilityLevel(t,'B05T')>0))then // 'B05T': buff tooltip "Zombie"
        set l_heal=false
        if(not l_pure)then
            // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
            set l_amount=l_amount*1.5
            set l_holy=true
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Holy[c]=l_holy
    set DmgCtx_Heal[c]=l_heal
    set t=null
endfunction

// Step 3 - Complete protection: Infinity (absorbs the hit and counts toward a job mastery),
// Majin Barrier, Block All / Shield, protected quest and town NPCs (Player(8)),
// Cup Arena outsiders, Null Sleep.
function Trig_Damage_Engine_Step03_FullProtection takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local integer l_blockCode=DmgCtx_BlockCode[c]
    local player up=DmgCtx_SourcePlayer[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    local integer l_tmp=DmgCtx_Tmp[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    if(l_heal)then
        set l_blockCode=-1
    elseif(l_amount>.0)then
        if(GetUnitAbilityLevel(t,'B052')>0 or GetUnitAbilityLevel(t,'A0PD')>0)then // 'B052': buff "Infinity"; 'A0PD': ability "Invulnerability"
            set l_tmp=GetUnitAbilityLevel(t,'A0KF') // 'A0KF': ability "Infinity"
            if(l_tmp>0)then
                // (l_tmp) minus (1).
                set l_dummy=Player_GetHero(Player(l_tmp-1))
                // (l_tmp) minus (1).
                if(IsPlayerInForce(Player(l_tmp-1),udg_JobMasterForce[18])or GetUnitAbilityLevel(l_dummy,'A02F')!=3)then // 'A02F': ability "Mastery"
                    call UnitRemoveAbility(t,'A0KF') // 'A0KF': ability "Infinity"
                else
                    if l_physical then
                        // (udg_InfinityAbsorbed at position l_tmp) plus ((amount) times (l_armorMult)).
                        set udg_InfinityAbsorbed[l_tmp]=udg_InfinityAbsorbed[l_tmp]+(l_amount*l_armorMult)
                    else
                        // (udg_InfinityAbsorbed at position l_tmp) plus (amount).
                        set udg_InfinityAbsorbed[l_tmp]=udg_InfinityAbsorbed[l_tmp]+l_amount
                    endif
                    if(udg_InfinityAbsorbed[l_tmp]>=500000.)then
                        // (l_tmp) minus (1).
                        call ForceAddPlayer(udg_JobMasterForce[18],Player(l_tmp-1))
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",l_dummy,"origin"))
                    endif
                endif
            endif
            set l_blockCode=3
            set l_amount=.0
        elseif(GetUnitAbilityLevel(t,'A0Y0')>0 and GetUnitAbilityLevel(t,'B08V')<=0)then // 'A0Y0': ability "Majin Barrier"; 'B08V': buff tooltip "Chaos"
            set l_blockCode=3
            set l_amount=.0
        elseif(GetUnitAbilityLevel(t,'A0T8')>0 or GetUnitAbilityLevel(t,'B059')>0)then // 'A0T8': ability "Block All"; 'B059': buff tooltip "Shield"
            set l_blockCode=2
            set l_amount=.0
        elseif(GetOwningPlayer(t)==Player(8))then
            if(IsUnitInGroup(t,udg_QuestNpcUnits))then
                set l_blockCode=2
                set l_amount=.0
            elseif(IsUnitInGroup(t,udg_TownNpcUnits))then
                set l_blockCode=1
                set l_amount=.0
            endif
        elseif(IsUnitInGroup(t,udg_CupArenaUnits)and not IsPlayerInForce(up,udg_CupArenaPlayers))then
            set l_blockCode=3
            set l_amount=.0
        elseif(GetUnitAbilityLevel(t,'B03A')>0 and GetUnitAbilityLevel(t,'A1EX')>0)then // 'B03A': buff tooltip "Sleep"; 'A1EX': ability "Null Sleep"
            set l_blockCode=1
            set l_amount=.0
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_BlockCode[c]=l_blockCode
    set DmgCtx_Tmp[c]=l_tmp
    set DmgCtx_Dummy[c]=l_dummy
    set t=null
    set l_dummy=null
endfunction

// Step 4 - Cover: the hit is redirected to the unit covering the target if it is alive and in range.
// Returns true when the hit was redirected: CalcDamage then stops and returns 0.
function Trig_Damage_Engine_Step04_Cover takes integer c returns boolean
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_noRedirect=DmgCtx_NoRedirect[c]
    local boolean l_pure=DmgCtx_Pure[c]
    local boolean l_melee=DmgCtx_Melee[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local real tx=DmgCtx_TargetX[c]
    local real ty=DmgCtx_TargetY[c]
    local integer th=DmgCtx_TargetHandle[c]
    local player tp=DmgCtx_TargetPlayer[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    local real l_val=DmgCtx_Val[c]
    local real l_val2=DmgCtx_Val2[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    if(l_amount>.0 and not l_heal and not l_noRedirect and(GetUnitAbilityLevel(t,'B063')>0 or GetUnitAbilityLevel(t,'A0X2')>0))then // 'B063': buff "Cover"; 'A0X2': ability "Perma Cover"
        set l_dummy=LoadUnitHandle(udg_LinkedCasterHash,th,1)
        if(l_dummy==null or GetWidgetLife(l_dummy)<=.405 or IsUnitInGroup(l_dummy,udg_InactiveUnits)or GetUnitAbilityLevel(l_dummy,'Avul')>0)then // 'Avul': standard ability reference "Invulnerable"
            call UnitRemoveAbility(t,'B063') // 'B063': buff "Cover"
            set l_dummy=null
        else
            // (tx) minus (x position of l_dummy).
            set l_val=tx-GetUnitX(l_dummy)
            // (ty) minus (y position of l_dummy).
            set l_val2=ty-GetUnitY(l_dummy)
            // The square root of ((the square of (l_val)) plus (the square of (l_val2))).
            set l_val=SquareRoot(l_val*l_val+l_val2*l_val2)
            set l_val2=LoadReal(udg_LinkedCasterHash,th,2)
            if(l_val2>.0 and l_val>l_val2)then
                call UnitRemoveAbility(t,'B063') // 'B063': buff "Cover"
                set l_dummy=null
            else
                call DestroyEffect(AddSpecialEffectTarget(Trig_Damage_Engine_BlockEffectPath(l_physical),t,"origin"))
                set udg_DmgFlagRedirected=true
                if l_pure then
                    call UnitDamageTarget(u,l_dummy,l_amount,false,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
                elseif l_physical then
                    set udg_IsPhysicalAttack=true
                    set udg_DmgFlagMelee=l_melee
                    // (amount) times (l_armorMult).
                    call UnitDamageTarget(u,l_dummy,(l_amount*l_armorMult),true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL,null)
                elseif(not IsPlayerInForce(tp,udg_PlayingPlayers)or t!=Player_GetHero(tp))then
                    set udg_DmgArmorProbe=true
                    call UnitDamageTarget(u,t,100.,false,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,null)
                    // (amount) times ((100) divided by (udg_DmgArmorProbeResult)).
                    call UnitDamageTarget(u,l_dummy,(l_amount*(100./ udg_DmgArmorProbeResult)),false,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,null)
                else
                    call UnitDamageTarget(u,l_dummy,l_amount,false,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,null)
                endif
                set l_dummy=null
                set u=null
                set t=null
                return true
            endif
        endif
    endif
    set DmgCtx_Source[c]=u
    set DmgCtx_Target[c]=t
    set DmgCtx_Val[c]=l_val
    set DmgCtx_Val2[c]=l_val2
    set DmgCtx_Dummy[c]=l_dummy
    set u=null
    set t=null
    set l_dummy=null
    return false
endfunction

// Step 5 - Immunities: Physical Immunity; Inner Fire against magic.
function Trig_Damage_Engine_Step05_Immunities takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_magical=DmgCtx_Magical[c]
    local boolean l_akashic=DmgCtx_Akashic[c]
    local integer l_blockCode=DmgCtx_BlockCode[c]
    if((l_physical or l_akashic)and not l_heal and l_amount>.0 and GetUnitAbilityLevel(t,'A0PS')>0)then // 'A0PS': ability "Physical Immunity"
        set l_blockCode=3
        set l_amount=.0
    endif
    if(l_magical and not l_akashic and not l_heal and l_amount>.0 and GetUnitAbilityLevel(t,'B076')>0)then // 'B076': buff "Inner Fire"
        set l_blockCode=3
        set l_amount=.0
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_BlockCode[c]=l_blockCode
    set t=null
endfunction

// Step 6 - Defense: heals, Akashic, holy and Pierce/Frog hits handle armor here. Magic that
// hits a player's hero is scaled by 50 / (50 + that player's magic defense).
function Trig_Damage_Engine_Step06_Defense takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_holy=DmgCtx_Holy[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_pure=DmgCtx_Pure[c]
    local boolean l_ranged=DmgCtx_Ranged[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_magical=DmgCtx_Magical[c]
    local boolean l_akashic=DmgCtx_Akashic[c]
    local boolean l_ignoreDef=DmgCtx_IgnoreDefense[c]
    local player up=DmgCtx_SourcePlayer[c]
    local player tp=DmgCtx_TargetPlayer[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    local real l_defScale=DmgCtx_DefenseScale[c]
    if(l_amount>.0 and not l_pure and(l_heal or l_akashic or l_holy or GetUnitAbilityLevel(u,'B05Q')>0 or GetUnitAbilityLevel(t,'B015')>0 or GetUnitAbilityLevel(t,'B05R')>0))then // 'B05Q': buff tooltip "Pierce"; 'B015': buff tooltip "Frog"; 'B05R': buff tooltip "Vitality Zero"
        if(l_physical or not IsPlayerInForce(tp,udg_PlayingPlayers)or t!=Player_GetHero(tp))then
            if l_physical then
                // (amount) times (l_armorMult).
                set l_amount=l_amount*l_armorMult
            else
                set udg_DmgArmorProbe=true
                call UnitDamageTarget(u,t,100.,false,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,null)
                // (amount) times ((100) divided by (udg_DmgArmorProbeResult)).
                set l_amount=l_amount*(100./ udg_DmgArmorProbeResult)
            endif
        endif
        if(l_akashic)then
            set l_magical=false
            set l_physical=true
            set l_ranged=true
            if not(l_holy or GetUnitAbilityLevel(u,'B05Q')>0 or GetUnitAbilityLevel(t,'B015')>0 or GetUnitAbilityLevel(t,'B05R')>0)then // 'B05Q': buff tooltip "Pierce"; 'B015': buff tooltip "Frog"; 'B05R': buff tooltip "Vitality Zero"
                // (amount) divided by (l_armorMult).
                set l_amount=l_amount/ l_armorMult
            else
                set l_armorMult=1.
            endif
        else
            set l_armorMult=1.
        endif
        if l_heal then
            set l_ignoreDef=true
        endif
    elseif(l_magical and IsPlayerInForce(tp,udg_PlayingPlayers)and t==Player_GetHero(tp))then
        // Result 1: (GetPlayerId(tp)) plus (1).
        // Result 2: (udg_MagicDefense at position result 1) plus (50).
        // Result 3: result 2 treated as a decimal-capable number.
        // Result 4: (50) divided by (result 3).
        set l_defScale=50./ I2R(udg_MagicDefense[GetPlayerId(tp)+1]+50)
        // (amount) times (l_defScale).
        set l_amount=l_amount*l_defScale
    endif
    // A player hero's ranged shot restarts RangedShotTimer.
    if(l_ranged and IsPlayerInForce(up,udg_PlayingPlayers)and u==Player_GetHero(up))then
        // (GetPlayerId(up)) plus (1).
        call TimerStart(udg_RangedShotTimer[GetPlayerId(up)+1],.01,false,null)
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Ranged[c]=l_ranged
    set DmgCtx_Physical[c]=l_physical
    set DmgCtx_Magical[c]=l_magical
    set DmgCtx_IgnoreDefense[c]=l_ignoreDef
    set DmgCtx_ArmorMult[c]=l_armorMult
    set DmgCtx_DefenseScale[c]=l_defScale
    set u=null
    set t=null
endfunction

// Step 7 - Melee attacker bonuses: weapon proficiency, axe charge, Rengeki, mana on hit,
// Combo Strike, Two-Handed, Dragon Eye, splash, Momentum and other melee skills.
function Trig_Damage_Engine_Step07_MeleeBonuses takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_melee=DmgCtx_Melee[c]
    local real ux=DmgCtx_SourceX[c]
    local real uy=DmgCtx_SourceY[c]
    local real tx=DmgCtx_TargetX[c]
    local real ty=DmgCtx_TargetY[c]
    local integer uh=DmgCtx_SourceHandle[c]
    local player up=DmgCtx_SourcePlayer[c]
    local player tp=DmgCtx_TargetPlayer[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    local integer l_tmp=DmgCtx_Tmp[c]
    local real l_val=DmgCtx_Val[c]
    local real l_val2=DmgCtx_Val2[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    local texttag l_tag=DmgCtx_Tag[c]
    if l_melee and l_amount>.0 then
        set l_val=Trig_Damage_Engine_ProficiencyMult(u)
        if l_val>1. then
            // (amount) times (l_val).
            set l_amount=l_amount*l_val
        endif
        if(IsPlayerInForce(up,udg_PlayingPlayers)and u==Player_GetHero(up))then
            set l_tmp=Prof_GetLevel(u,'R00I') // 'R00I': upgrade "Heavens Forged Axe"
            if(l_tmp>0)then
                // Result 1: (1) minus (remaining seconds of udg_AxeChargeTimer at position GetPlayerId(up)).
                // Result 2: (l_tmp) times (0.08).
                // Result 3: (result 1) times (result 2).
                // Result 4: (1) plus (result 3).
                // Result 5: (amount) times (result 4).
                set l_amount=l_amount*(1+((1.-TimerGetRemaining(udg_AxeChargeTimer[GetPlayerId(up)]))*(l_tmp*.08)))
            endif
            call TimerStart(udg_AxeChargeTimer[GetPlayerId(up)],1.2,false,null)
        endif
        if(GetUnitAbilityLevel(u,'A13S')>0)then // 'A13S': ability "Rengeki"
            call Trig_Damage_Engine_RengekiStack(t)
        endif
        if(GetUnitAbilityLevel(t,'A17C')==1 and IsUnitType(u,UNIT_TYPE_MELEE_ATTACKER))then // 'A17C': ability "Blind Spotted"
            call SetUnitAbilityLevel(t,'A17C',2) // 'A17C': ability "Blind Spotted"
        endif
        if(GetUnitAbilityLevel(u,'A0AP')>0 and Unit_HasNoEquipment(u)and(GetUnitAbilityLevel(t,'BPSE')>0 or GetUnitAbilityLevel(t,'B03R')>0 or GetUnitAbilityLevel(t,'B08I')>0 or GetUnitAbilityLevel(t,'B08E')>0))then // 'A0AP': ability "Barehanded"; 'BPSE': buff tooltip "Stunned"; 'B03R': buff tooltip "Stunned"; 'B08I': buff tooltip "Stunned"; 'B08E': buff tooltip "Daze"
            // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
            set l_amount=l_amount*1.5
        endif
        if(GetUnitState(u,UNIT_STATE_MANA)<GetUnitState(u,UNIT_STATE_MAX_MANA)and not IsUnitType(t,UNIT_TYPE_STRUCTURE)and IsUnitEnemy(t,up))then
            // (Prof_GetLevel(u, 'R007')) times (2).
            set l_tmp=Prof_GetLevel(u,'R007')*2 // 'R007': upgrade "Mystic Armor"
            if(GetUnitAbilityLevel(u,'B018')>0 or GetUnitAbilityLevel(u,'B082')>0)then // 'B018': buff tooltip "Holy Power"; 'B082': buff tooltip "Dark Power"
                if(GetUnitAbilityLevel(u,'A05W')>=6 or GetUnitAbilityLevel(u,'A1AA')>=6)then // 'A05W': ability "!Holy Power"; 'A1AA': ability "!Dark Power"
                    // Increase l_tmp by 100.
                    set l_tmp=l_tmp+'d'
                    if(IsUnitInGroup(u,udg_EnduranceAwardGroup))then
                        // Calculation 1:
                        // (GetPlayerId(up)) plus (1).
                        // Calculation 2:
                        // (GetPlayerId(up)) plus (1).
                        if(udg_EnduranceManaCount[GetPlayerId(up)+1]>=$F3C and udg_EnduranceDamageCount[GetPlayerId(up)+1]>=$FA0)then // $F3C = 3900; $FA0 = 4000
                            call ForceAddPlayer(udg_JobMasterForce[9],up)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
                            call GroupRemoveUnit(udg_EnduranceAwardGroup,u)
                            if(FirstOfGroup(udg_EnduranceAwardGroup)==null)then
                                call DisableTrigger(gg_trg_HolyPower_Mastery_Track)
                            endif
                        else
                            // Increase udg_EnduranceManaCount at position (GetPlayerId(up)) plus (1) by 100.
                            set udg_EnduranceManaCount[GetPlayerId(up)+1]=udg_EnduranceManaCount[GetPlayerId(up)+1]+'d'
                        endif
                    endif
                else
                    // (l_tmp) plus ((((GetUnitAbilityLevel(u, 'A05W')) plus (GetUnitAbilityLevel(u, 'A1AA'))) plus (3)) times
                    // (10)).
                    set l_tmp=l_tmp+((GetUnitAbilityLevel(u,'A05W')+GetUnitAbilityLevel(u,'A1AA')+3)*$A) // 'A05W': ability "!Holy Power"; 'A1AA': ability "!Dark Power"; $A = 10
                endif
            endif
            if(l_tmp>0)then
                // (current mana of u) plus (l_tmp).
                call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)+l_tmp)
            endif
        endif
        if(GetUnitAbilityLevel(u,'A137')>0)then // 'A137': ability "Combo Strike"
            if(t!=LoadUnitHandle(udg_ComboHash,uh,1))then
                call Trig_Damage_Engine_ComboEnd(u)
            else
                set l_tag=LoadTextTagHandle(udg_ComboHash,uh,6)
                call SetTextTagAge(l_tag,.0)
                // (uy) plus (32).
                call SetTextTagPos(l_tag,ux,uy+32.,0)
                set l_tmp=LoadInteger(udg_ComboHash,uh,5)
                // Result 1: Prof_GetLevel(u, 'R00A') treated as a decimal-capable number.
                // Result 2: (result 1) times (0.002).
                // Result 3: (result 2) times (l_tmp).
                // Result 4: (1) plus (result 3).
                // Result 5: (amount) times (result 4).
                set l_amount=l_amount*(1.+((I2R(Prof_GetLevel(u,'R00A'))*.002)*l_tmp)) // 'R00A': upgrade "Katana"
                call SetTextTagText(l_tag,Text_IntToString(l_tmp)+" Hits!",.03)
                set l_tmp=LoadInteger(udg_ComboHash,uh,2)
                if(l_tmp<=1)then
                    call Trig_Damage_Engine_ComboEnd(u)
                else
                    // (LoadInteger(udg_ComboHash, uh, 5)) plus (1).
                    call SaveInteger(udg_ComboHash,uh,5,LoadInteger(udg_ComboHash,uh,5)+1)
                    // (l_tmp) minus (1).
                    call SaveInteger(udg_ComboHash,uh,2,l_tmp-1)
                    call TimerStart(LoadTimerHandle(udg_ComboHash,GetHandleId(u),3),.5,false,function Trig_Damage_Engine_ComboExpire)
                endif
            endif
        else
            call Trig_Damage_Engine_ComboStart(u,t)
        endif
        if(GetUnitAbilityLevel(u,'A0GP')>0 and IsUnitType(u,UNIT_TYPE_MELEE_ATTACKER)and IsUnitType(u,UNIT_TYPE_HERO))then // 'A0GP': ability "Two-Handed"
            call Trig_Damage_Engine_FindTwoHandedItem(u)
            if udg_TwoHandedItem!=null then
                // (amount) plus (((current health of udg_TwoHandedItem) times (5)) divided by (l_armorMult)).
                set l_amount=l_amount+((GetWidgetLife(udg_TwoHandedItem)*5.)/ l_armorMult)
                call UnitRemoveAbility(u,'B05W') // 'B05W': buff tooltip "Two-Handed Swing"
            endif
        endif
        if(GetUnitAbilityLevel(u,'A11T')>0)then // 'A11T': ability "Dragon Eye"
            // (tx) minus (ux).
            set l_val=tx-ux
            // (ty) minus (uy).
            set l_val2=ty-uy
            // The square root of ((the square of (l_val)) plus (the square of (l_val2))).
            set l_val=SquareRoot(l_val*l_val+l_val2*l_val2)
            if(l_val>800.)then
                set l_val=800.
            endif
            // (0.2) plus ((l_val) divided by (500)).
            set l_val=.2+(l_val/ 500.)
            // (amount) times (l_val).
            set l_amount=l_amount*l_val
        endif
        if(GetUnitAbilityLevel(u,'A0Y4')>0)then // 'A0Y4': ability "Explosive Strike"
            // Increase amount by 500.
            set l_amount=l_amount+500.
        endif
        if(GetUnitAbilityLevel(u,'A0YX')>0)then // 'A0YX': ability "Minor Demistrike"
            // (amount) plus ((current health of t) divided by (8)).
            set l_amount=l_amount+(GetUnitState(t,UNIT_STATE_LIFE)/ 8.)
        endif
        set l_tmp=Prof_GetLevel(u,'R00M') // 'R00M': upgrade "Gun"
        if(l_tmp>0)then
            // Increase l_tmp by 10.
            set l_tmp=l_tmp+$A // $A = 10
            if(GetUnitAbilityLevel(u,'A0YA')>0)then // 'A0YA': ability "Onion Shot"
                // (amount) plus (((l_tmp treated as a decimal-capable number) times (35)) divided by (l_armorMult)).
                set l_amount=l_amount+((I2R(l_tmp)*35.)/ l_armorMult)
            endif
            if(GetUnitAbilityLevel(u,'A1AL')>0)then // 'A1AL': ability "Medium Shot"
                // (amount) plus (((l_tmp treated as a decimal-capable number) times (25)) divided by (l_armorMult)).
                set l_amount=l_amount+((I2R(l_tmp)*25.)/ l_armorMult)
            endif
            if(GetUnitAbilityLevel(u,'A1FE')>0)then // 'A1FE': ability "Small Shot"
                // (amount) plus (((l_tmp treated as a decimal-capable number) times (10)) divided by (l_armorMult)).
                set l_amount=l_amount+((I2R(l_tmp)*10.)/ l_armorMult)
            endif
            if(GetUnitAbilityLevel(u,'A0YB')>0)then // 'A0YB': ability "Piercing Shot"
                // (amount) plus ((l_tmp treated as a decimal-capable number) times (15)).
                set l_amount=l_amount+(I2R(l_tmp)*15.)
            endif
            if(GetUnitAbilityLevel(u,'A1AM')>0)then // 'A1AM': ability "Pulsar Shot"
                // (amount) plus ((l_tmp treated as a decimal-capable number) times (30)).
                set l_amount=l_amount+(I2R(l_tmp)*30.)
            endif
            if(GetUnitAbilityLevel(u,'A144')>0)then // 'A144': ability "Molotov Shot"
                if(udg_MolotovCooldown[GetPlayerId(up)]<=0)then
                    set udg_MolotovCooldown[GetPlayerId(up)]=$A // $A = 10
                    set l_dummy=CreateUnit(up,'h02S',tx,ty,.0) // 'h02S': unit "Simple Casting Dummy"
                    call ShowUnit(l_dummy,false)
                    call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
                    call UnitAddAbility(l_dummy,'A143') // 'A143': ability "Molotov Shot"
                    call IssueTargetOrder(l_dummy,"drunkenhaze",t)
                    // ((60) plus (Intelligence of u)) times (Prof_GetSpellPower(u, 'R00M', 0.5)).
                    set l_val=(60+GetHeroInt(u,true))*Prof_GetSpellPower(u,'R00M',.5) // 'R00M': upgrade "Gun"
                    call SaveUnitHandle(udg_MolotovHash,GetHandleId(t),0,u)
                    call SaveReal(udg_MolotovHash,GetHandleId(t),1,l_val)
                else
                    set udg_MolotovCooldown[GetPlayerId(up)]=udg_MolotovCooldown[GetPlayerId(up)]-1
                endif
            endif
            if(GetUnitAbilityLevel(u,'A145')>0 and GetUnitAbilityLevel(t,'A0RA')<=0 and GetUnitAbilityLevel(t,'B00P')<=0)then // 'A145': ability "Bubble Shot"; 'A0RA': ability "Blindproof"; 'B00P': buff tooltip "Blind"
                set l_dummy=CreateUnit(up,'h02S',tx,ty,.0) // 'h02S': unit "Simple Casting Dummy"
                call ShowUnit(l_dummy,false)
                call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
                call UnitAddAbility(l_dummy,'A09C') // 'A09C': ability "Blind"
                call IssueTargetOrder(l_dummy,"curse",t)
            endif
        endif
        if((GetUnitAbilityLevel(u,'A0T6')>0 or GetUnitAbilityLevel(u,'B05J')>0 or(GetUnitAbilityLevel(u,'A0YC')>0 and l_tmp>0))and not IsUnitInGroup(t,udg_SplashGroup))then // 'A0T6': ability "Splash Attack"; 'B05J': buff "Blitz"; 'A0YC': ability "Scattershot"
            set l_tmp=325
            if(IsUnitType(u,UNIT_TYPE_MELEE_ATTACKER))then
                // The angle in radians from the y gap ((ty) minus (uy)) and x gap ((tx) minus (ux)).
                set l_val2=Atan2(ty-uy,tx-ux)
                // (tx) plus ((the horizontal direction share for angle (l_val2) in radians) times (250)).
                set l_val=tx+Cos(l_val2)*250.
                // (ty) plus ((the vertical direction share for angle (l_val2) in radians) times (250)).
                set l_val2=ty+Sin(l_val2)*250.
            else
                set l_val=tx
                set l_val2=ty
            endif
            set udg_SplashGroup=CreateGroup()
            // L_tmp treated as a decimal-capable number.
            call GroupEnumUnitsInRange(udg_SplashGroup,l_val,l_val2,I2R(l_tmp),Condition(function Trig_Damage_Engine_FilterAlive))
            call GroupRemoveUnit(udg_SplashGroup,t)
            set udg_SplashSource=u
            // ((amount) times (l_armorMult)) times (0.5).
            set udg_SplashDamage=l_amount*l_armorMult*.5
            call TimerStart(udg_SplashTimer,.0,false,null)
            if(GetUnitAbilityLevel(u,'B05J')>0 and GetUnitTypeId(u)=='H00D' and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(up,udg_JobMasterForce[5]))then // 'B05J': buff "Blitz"; 'H00D': unit "Geomancer"; 'A02F': ability "Mastery"
                set udg_SplashTally=.0
                call TimerStart(udg_GeomancerAwardTimer,.01,false,function Trig_Damage_Engine_AwardGeomancer)
            endif
        endif
        if(GetUnitAbilityLevel(u,'A0KY')>0 and GetUnitAbilityLevel(u,'B04D')>0 and not IsUnitType(t,UNIT_TYPE_STRUCTURE)and IsUnitEnemy(t,up)and GetUnitTypeId(t)!='u01M')then // 'A0KY': ability "Thievery"; 'B04D': buff tooltip "Thievery"; 'u01M': unit "Scarecrow"
            // Result 1: (unit level of t) plus (2).
            // Result 2: (result 1) times (3).
            // Result 3: result 2 treated as a decimal-capable number.
            // Result 4: the square root of (result 3).
            // Result 5: (result 4) plus (0.5).
            // Result 6: (result 5) with its decimal part removed.
            set l_tmp=R2I(SquareRoot(I2R((GetUnitLevel(t)+2)*3))+.5)
            // (GetUnitAbilityLevel(u, 'A0KY')) times (2).
            if(GetUnitAbilityLevel(u,'A0KY')<=5 and l_tmp>(GetUnitAbilityLevel(u,'A0KY')*2))then // 'A0KY': ability "Thievery"
                // (GetUnitAbilityLevel(u, 'A0KY')) times (2).
                set l_tmp=GetUnitAbilityLevel(u,'A0KY')*2 // 'A0KY': ability "Thievery"
            endif
            call DestroyEffect(AddSpecialEffectTarget("UI\\Feedback\\GoldCredit\\GoldCredit.mdl",t,"overhead"))
            if(up!=Player($B))then // $B = 11
                call AdjustPlayerStateBJ(l_tmp,up,PLAYER_STATE_RESOURCE_GOLD)
            endif
            // (l_tmp) times (-1).
            call AdjustPlayerStateBJ((l_tmp*-1),tp,PLAYER_STATE_RESOURCE_GOLD)
        endif
        // (GetPlayerId(up)) plus (1).
        if(GetUnitAbilityLevel(u,'B07V')>0 and udg_MomentumCharges[GetPlayerId(up)+1]>0 and tp==Player($B)and IsUnitType(t,UNIT_TYPE_ATTACKS_GROUND))then // 'B07V': buff tooltip "Momentum"; $B = 11
            set udg_MomentumCharges[GetPlayerId(up)+1]=udg_MomentumCharges[GetPlayerId(up)+1]-1
            // (GetPlayerId(up)) plus (1).
            if(udg_MomentumCharges[GetPlayerId(up)+1]==0)then
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl",u,"overhead"))
            endif
        endif
    endif
    // Command AI: melee AI units sometimes cast a spell at their target; each bit of the
    // ability level enables one spell.
    set l_tmp=GetUnitAbilityLevel(u,'A0SF') // 'A0SF': ability "Command AI"
    if(l_tmp>1 and l_melee)then
        set l_tmp=l_tmp-1
        // (tx) minus (ux).
        set l_val=tx-ux
        // (ty) minus (uy).
        set l_val2=ty-uy
        // The square root of ((the square of (l_val)) plus (the square of (l_val2))).
        set l_val=SquareRoot(l_val*l_val+l_val2*l_val2)
        if(l_val<=1200.)then
            // Calculation 1:
            // The remainder after dividing (l_tmp) by (2).
            // Calculation 2:
            // A random whole number from 1 through 5.
            if(ModuloInteger(l_tmp,2)==1 and GetRandomInt(1,5)==1)then
                call IssueTargetOrder(u,"thunderbolt",t)
            // Calculation 1:
            // The remainder after dividing ((l_tmp) divided by (2); drop the remainder) by (2).
            // Calculation 2:
            // A random whole number from 1 through 5.
            elseif(ModuloInteger(l_tmp/ 2,2)==1 and GetRandomInt(1,5)==1)then
                call IssuePointOrder(u,"flamestrike",tx,ty)
            // Calculation 1:
            // The remainder after dividing ((l_tmp) divided by (4); drop the remainder) by (2).
            // Calculation 2:
            // A random whole number from 1 through 5.
            elseif(ModuloInteger(l_tmp/ 4,2)==1 and GetRandomInt(1,5)==1)then
                call IssueTargetOrder(u,"frostnova",t)
            // Calculation 1:
            // The remainder after dividing ((l_tmp) divided by (8); drop the remainder) by (2).
            // Calculation 2:
            // A random whole number from 1 through 5.
            elseif(ModuloInteger(l_tmp/ 8,2)==1 and GetRandomInt(1,5)==1)then
                call IssuePointOrder(u,"shockwave",tx,ty)
            // Calculation 1:
            // The remainder after dividing ((l_tmp) divided by (16); drop the remainder) by (2).
            // Calculation 2:
            // A random whole number from 1 through 5.
            elseif(ModuloInteger(l_tmp/ 16,2)==1 and GetRandomInt(1,5)<=2)then
                // A random whole number from 1 through 2.
                if GetRandomInt(1,2)==1 then
                    call IssueImmediateOrder(u,"stomp")
                else
                    call IssueImmediateOrder(u,"thunderclap")
                endif
            endif
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Tmp[c]=l_tmp
    set DmgCtx_Val[c]=l_val
    set DmgCtx_Val2[c]=l_val2
    set DmgCtx_Dummy[c]=l_dummy
    set DmgCtx_Tag[c]=l_tag
    set u=null
    set t=null
    set l_dummy=null
    set l_tag=null
endfunction

// Step 8 - Elements: use the attacker's element when none was given, then apply the
// target's weakness / resistance / immunity / absorption.
function Trig_Damage_Engine_Step08_Elements takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local integer l_element=DmgCtx_Element[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_pure=DmgCtx_Pure[c]
    local boolean l_ranged=DmgCtx_Ranged[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_ignoreDef=DmgCtx_IgnoreDefense[c]
    local integer l_fxCode=DmgCtx_FxCode[c]
    local integer l_blockCode=DmgCtx_BlockCode[c]
    local player up=DmgCtx_SourcePlayer[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    local integer l_resist=DmgCtx_Resist[c]
    if(l_element<=0 and not l_pure)then
        set l_element=Element_GetOfUnit(u,l_physical)
    endif
    if(l_amount>.0 and l_element>0 and GetUnitAbilityLevel(u,'A1A4')<=0)then // 'A1A4': ability "Non-elemental Damage"
        set l_resist=Trig_Damage_Engine_GetElementResist(t,l_element)
        if(GetUnitAbilityLevel(u,'A1F3')>0 or GetUnitAbilityLevel(t,'B057')>0)then // 'A1F3': ability "Imperiled Strike"; 'B057': buff tooltip "Imperil"
            set l_resist=l_resist-1
        endif
        if(l_resist==0)then
            if(not IsUnitType(t,UNIT_TYPE_HERO)and not IsUnitType(t,UNIT_TYPE_RESISTANT))then
                set l_amount=6666666.
                set l_ignoreDef=true
                set l_blockCode=-1
                if(GetUnitTypeId(u)=='H00H' and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(up,udg_NullElementForce[l_element]))then // 'H00H': unit "Calculator"; 'A02F': ability "Mastery"
                    call ForceAddPlayer(udg_NullElementForce[l_element],up)
                    set udg_NullElementCount[GetPlayerId(up)]=udg_NullElementCount[GetPlayerId(up)]+1
                    if(udg_NullElementCount[GetPlayerId(up)]>=6)then
                        call ForceAddPlayer(udg_JobMasterForce[17],up)
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
                    endif
                endif
            else
                // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
                set l_amount=l_amount*2.
                if(GetUnitAbilityLevel(u,'A1CB')>0)then // 'A1CB': ability "Ancient Elements"
                    // Multiply the current amount by 1.3: 100 becomes 130, before any later adjustments.
                    set l_amount=l_amount*1.3
                endif
            endif
            set l_fxCode=1
        elseif(l_resist==1)then
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
            if(GetUnitAbilityLevel(u,'A1CB')>0)then // 'A1CB': ability "Ancient Elements"
                // Multiply the current amount by 1.3: 100 becomes 130, before any later adjustments.
                set l_amount=l_amount*1.3
            endif
            set l_fxCode=1
        elseif(l_resist==2)then
            // Multiply the current amount by 1.6: 100 becomes 160, before any later adjustments.
            set l_amount=l_amount*1.6
            if(GetUnitAbilityLevel(u,'A1CB')>0)then // 'A1CB': ability "Ancient Elements"
                // Multiply the current amount by 1.3: 100 becomes 130, before any later adjustments.
                set l_amount=l_amount*1.3
            endif
            set l_fxCode=1
        elseif(l_resist==4)then
            // Keep 80% of the current amount, reducing it by 20%.
            set l_amount=l_amount*.8
        elseif(l_resist==5)then
            // Keep 50% of the current amount, reducing it by 50%.
            set l_amount=l_amount*.5
            set l_fxCode=3
        elseif(l_resist==6)then
            set l_amount=.0
            set l_blockCode=3
        elseif(l_resist==7)then
            set l_heal=true
            set l_blockCode=-1
        endif
    endif
    // Rengeki Bonus on the target against ranged hits.
    if(l_ranged and l_amount>.0 and GetUnitAbilityLevel(t,'A14C')>0)then // 'A14C': ability "Rengeki Bonus"
        // (amount) times (((LoadInteger(udg_RunicHash, GetHandleId(t), 3)) times (0.05)) plus (1)).
        set l_amount=l_amount*((LoadInteger(udg_RunicHash,GetHandleId(t),3)*.05)+1)
    endif
    // Special unit n08D_0001: its hit equals its own armor, then it expires.
    if(u==gg_unit_n08D_0001 and u!=null)then
        if l_amount>.0 then
            // (BlzGetUnitArmor(u)) divided by (l_armorMult).
            set l_amount=BlzGetUnitArmor(u)/ l_armorMult
        endif
        call UnitApplyTimedLife(gg_unit_n08D_0001,'BTLF',.5) // 'BTLF': object name not found in map data
        call UnitAddAbility(gg_unit_n08D_0001,'Abun') // 'Abun': object name not found in map data
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Element[c]=l_element
    set DmgCtx_Heal[c]=l_heal
    set DmgCtx_IgnoreDefense[c]=l_ignoreDef
    set DmgCtx_FxCode[c]=l_fxCode
    set DmgCtx_BlockCode[c]=l_blockCode
    set DmgCtx_Resist[c]=l_resist
    set u=null
    set t=null
endfunction

// Step 9 - Accuracy: effects that make the hit impossible to evade (Sharp Eye, Null Evasion,
// Gun Accuracy ...).
function Trig_Damage_Engine_Step09_Accuracy takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_magical=DmgCtx_Magical[c]
    local integer l_blockCode=DmgCtx_BlockCode[c]
    if(l_blockCode==0)then
        if(l_amount<=0)then
            set l_blockCode=-1
        elseif(GetUnitAbilityLevel(u,'B06T')>0 or GetUnitAbilityLevel(u,'A127')>0 or GetUnitAbilityLevel(t,'A127')>0)then // 'B06T': buff tooltip "Sharp Eye"; 'A127': ability "Null Evasion"
            set l_blockCode=-1
        elseif(l_physical and GetUnitAbilityLevel(u,'A0Y7')>0 and Prof_GetLevel(u,'R00M')>0)then // 'A0Y7': ability "Gun Accuracy"; 'R00M': upgrade "Gun"
            set l_blockCode=-1
        elseif(l_magical and GetUnitAbilityLevel(u,'A0MY')>0)then // 'A0MY': ability "Truecast"
            set l_blockCode=-1
        endif
    endif
    if(GetUnitAbilityLevel(u,'A0RA')>0)then // 'A0RA': ability "Blindproof"
        call UnitRemoveAbility(u,'B00P') // 'B00P': buff tooltip "Blind"
        call UnitRemoveAbility(u,'B02V') // 'B02V': buff tooltip "Total Blind"
    endif
    set DmgCtx_BlockCode[c]=l_blockCode
    set u=null
    set t=null
endfunction

// Step 10 - Evasion and blocking: miss roll (Trig_Damage_Engine_RollMiss), Evade and Counter,
// block abilities.
function Trig_Damage_Engine_Step10_EvasionAndBlocking takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_noRedirect=DmgCtx_NoRedirect[c]
    local boolean l_pure=DmgCtx_Pure[c]
    local boolean l_melee=DmgCtx_Melee[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_magical=DmgCtx_Magical[c]
    local integer l_blockCode=DmgCtx_BlockCode[c]
    local real ux=DmgCtx_SourceX[c]
    local real uy=DmgCtx_SourceY[c]
    local real tx=DmgCtx_TargetX[c]
    local real ty=DmgCtx_TargetY[c]
    local player tp=DmgCtx_TargetPlayer[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    local real l_defScale=DmgCtx_DefenseScale[c]
    local integer l_tmp=DmgCtx_Tmp[c]
    local real l_val=DmgCtx_Val[c]
    local real l_val2=DmgCtx_Val2[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    if(l_blockCode==0)then
        if(GetUnitAbilityLevel(t,'B050')<=0)then // 'B050': buff tooltip "Evade and Counter"
            set udg_DodgeStreak[GetPlayerId(tp)]=0
        endif
        if(not l_noRedirect and not l_pure and Trig_Damage_Engine_RollMiss(u,t,l_magical))then
            set l_blockCode=1
        else
            set udg_DodgeStreak[GetPlayerId(tp)]=0
            if(Trig_Damage_Engine_CheckBlock(u,t,l_physical,l_magical))then
                set l_blockCode=2
            endif
        endif
        if(l_blockCode>0)then
            if(l_blockCode==1)then
                if(GetUnitAbilityLevel(t,'B050')>0)then // 'B050': buff tooltip "Evade and Counter"
                    // (tx) minus (ux).
                    set l_val=tx-ux
                    // (ty) minus (uy).
                    set l_val2=ty-uy
                    // The square root of ((the square of (l_val)) plus (the square of (l_val2))).
                    set l_val=SquareRoot(l_val*l_val+l_val2*l_val2)
                    if(l_val<256.)then
                        call SetUnitFacingToFaceUnitTimed(t,u,0)
                        set udg_DodgeUnit=t
                        set udg_DodgeAttacker=u
                        call TimerStart(udg_DodgeFaceTimer[0],.01,false,null)
                    endif
                    if(GetUnitAbilityLevel(t,'A02F')==3 and not IsPlayerInForce(tp,udg_JobMasterForce[4]))then // 'A02F': ability "Mastery"
                        set udg_DodgeStreak[GetPlayerId(tp)]=udg_DodgeStreak[GetPlayerId(tp)]+1
                        if(udg_DodgeStreak[GetPlayerId(tp)]>=20)then
                            call ForceAddPlayer(udg_JobMasterForce[4],tp)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",t,"origin"))
                        endif
                    endif
                endif
            elseif(l_blockCode==2)then
                if(GetUnitAbilityLevel(t,'A0RT')>0 and gg_unit_n08D_0001==null and GetWidgetLife(u)>.405 and IsUnitEnemy(u,tp)and GetUnitAbilityLevel(u,'Avul')<=0)then // 'A0RT': ability "Interceptor Protection"; 'Avul': standard ability reference "Invulnerable"
                    // (bj_RADTODEG) times (the angle in radians from the y gap ((uy) minus (ty)) and x gap ((ux) minus (tx))).
                    set gg_unit_n08D_0001=CreateUnit(tp,'n08D',tx,ty,bj_RADTODEG*Atan2(uy-ty,ux-tx)) // 'n08D': unit "Interceptor"
                    call SetUnitPathing(gg_unit_n08D_0001,false)
                    call UnitApplyTimedLife(gg_unit_n08D_0001,'BTLF',3.) // 'BTLF': object name not found in map data
                    call UnitAddType(gg_unit_n08D_0001,UNIT_TYPE_PEON)
                    // ((amount) times (l_armorMult)) plus ((Strength of t) plus (Agility of t) treated as a decimal-capable
                    // number).
                    call BlzSetUnitArmor(gg_unit_n08D_0001,((l_amount*l_armorMult)+(I2R(GetHeroStr(t,true)+GetHeroAgi(t,true)))))
                    call IssueTargetOrder(gg_unit_n08D_0001,"attackonce",u)
                endif
                if(GetUnitAbilityLevel(t,'B07R')>0 and GetUnitAbilityLevel(t,'B07S')>0 and l_amount>=10.)then // 'B07R': buff "Runic Shield"; 'B07S': buff "Runic Revenge"
                    set l_val=LoadReal(udg_RunicHash,GetHandleId(t),5)
                    if(l_val<9999.)then
                        // (l_val) plus ((amount) times (0.2)).
                        set l_val=l_val+(l_amount*.2)
                        if(l_val>9999.)then
                            set l_val=9999.
                        endif
                        call SaveReal(udg_RunicHash,GetHandleId(t),5,l_val)
                        // (l_val) with its decimal part removed.
                        set l_tmp=R2I(l_val)
                        // (l_tmp) plus (1).
                        call SetUnitAbilityLevel(t,'A1AV',l_tmp+1) // 'A1AV': ability "Runic Damage Bonus"
                        // (the remainder after dividing ((l_tmp) divided by (10); drop the remainder) by (10)) plus (1).
                        call SetUnitAbilityLevel(t,'A1AW',ModuloInteger(l_tmp/ $A,$A)+1) // 'A1AW': ability "Runic Damage Bonus"; $A = 10
                        // (the remainder after dividing ((l_tmp) divided by (100); drop the remainder) by (10)) plus (1).
                        call SetUnitAbilityLevel(t,'A1AX',ModuloInteger(l_tmp/ 'd',$A)+1) // 'A1AX': ability "Runic Damage Bonus"; $A = 10
                        // (the remainder after dividing ((l_tmp) divided by (1000); drop the remainder) by (10)) plus (1).
                        call SetUnitAbilityLevel(t,'A1AY',ModuloInteger(l_tmp/ $3E8,$A)+1) // 'A1AY': ability "Runic Damage Bonus"; $3E8 = 1000; $A = 10
                    endif
                endif
                if(GetUnitAbilityLevel(t,'A1A0')>0 and l_melee and IsUnitType(u,UNIT_TYPE_MELEE_ATTACKER))then // 'A1A0': ability "Parry"
                    set l_dummy=CreateUnit(tp,'h02S',ux,uy,.0) // 'h02S': unit "Simple Casting Dummy"
                    call ShowUnit(l_dummy,false)
                    call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
                    call UnitAddAbility(l_dummy,'A17A') // 'A17A': ability "Parry"
                    call IssueTargetOrder(l_dummy,"cripple",u)
                endif
                if(GetUnitAbilityLevel(t,'A1B2')>0 and l_magical)then // 'A1B2': ability "Reflect"
                    set l_dummy=CreateUnit(tp,'h01B',tx,ty,.0) // 'h01B': unit "Proxy Dummy"
                    set l_tmp=GetHandleId(l_dummy)
                    call SaveUnitHandle(udg_ProxyDamageHash,l_tmp,0,t)
                    // ((amount) divided by (l_defScale)) plus (10).
                    call SaveReal(udg_ProxyDamageHash,l_tmp,1,(l_amount/ l_defScale)+10.)
                    call SaveInteger(udg_ProxyDamageHash,l_tmp,2,3)
                    call ShowUnit(l_dummy,false)
                    call UnitApplyTimedLife(l_dummy,'BTLF',2.) // 'BTLF': object name not found in map data
                    call UnitAddAbility(l_dummy,'A1D6') // 'A1D6': ability "Reflect"
                    call IssueTargetOrder(l_dummy,"thunderbolt",u)
                endif
            endif
            set l_amount=.0
        endif
        call UnitRemoveAbility(t,'B050') // 'B050': buff tooltip "Evade and Counter"
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_BlockCode[c]=l_blockCode
    set DmgCtx_Tmp[c]=l_tmp
    set DmgCtx_Val[c]=l_val
    set DmgCtx_Val2[c]=l_val2
    set DmgCtx_Dummy[c]=l_dummy
    set u=null
    set t=null
    set l_dummy=null
endfunction

// Step 11 - Remember the attacker's last element and apply its element damage bonus.
function Trig_Damage_Engine_Step11_ElementBonus takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local integer l_element=DmgCtx_Element[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local integer l_fxCode=DmgCtx_FxCode[c]
    local integer l_blockCode=DmgCtx_BlockCode[c]
    local player up=DmgCtx_SourcePlayer[c]
    local real l_val=DmgCtx_Val[c]
    if(l_amount>.0 and l_element>0)then
        if(GetUnitAbilityLevel(u,'A0PO')<=0)then // 'A0PO': ability "Latest Used Element"
            call UnitAddAbility(u,'A0PO') // 'A0PO': ability "Latest Used Element"
        endif
        // (l_element) plus (1).
        call SetUnitAbilityLevel(u,'A0PO',l_element+1) // 'A0PO': ability "Latest Used Element"
        // Result 1: (1) plus (Trig_Damage_Engine_GetElementBonus(u, l_element, l_physical)).
        // Result 2: (result 1) plus (Trig_Damage_Engine_GetElementBonus(u, 7, l_physical)).
        set l_val=1.+Trig_Damage_Engine_GetElementBonus(u,l_element,l_physical)+Trig_Damage_Engine_GetElementBonus(u,7,l_physical)
        if(GetUnitAbilityLevel(u,'A1A4')>0)then // 'A1A4': ability "Non-elemental Damage"
            set l_element=0
        elseif(GetUnitAbilityLevel(t,udg_ElementAilmentBuff[l_element])>0 or GetUnitAbilityLevel(t,udg_ElementAilmentBuff2[l_element])>0)then
            // Increase l_val by 1.2.
            set l_val=l_val+1.2
            if(l_fxCode==1)then
                set l_fxCode=4
            else
                set l_fxCode=1
            endif
            if(GetUnitTypeId(u)=='H004' and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(up,udg_WeakElementForce[l_element]))then // 'H004': unit "Wizard"; 'A02F': ability "Mastery"
                call ForceAddPlayer(udg_WeakElementForce[l_element],up)
                set udg_WeakElementCount[GetPlayerId(up)]=udg_WeakElementCount[GetPlayerId(up)]+1
                if(udg_WeakElementCount[GetPlayerId(up)]>=6)then
                    call ForceAddPlayer(udg_JobMasterForce[$B],up) // $B = 11
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
                endif
            endif
        endif
        if(l_val>1.)then
            // (amount) times (l_val).
            set l_amount=l_amount*l_val
        endif
        if(IsPlayerInForce(up,udg_PlayingPlayers))then
            set udg_ElementRecordUnit=u
            set udg_ElementRecord[0]=l_element
            call TimerStart(udg_ElementRecordTimer,.01,false,null)
        endif
    elseif(l_amount>.0)then
        if(GetUnitAbilityLevel(t,'A11P')>0)then // 'A11P': ability "Non-Elemental Immunity"
            set l_amount=.0
            set l_blockCode=3
        elseif(GetUnitAbilityLevel(t,'A11O')>0)then // 'A11O': ability "Non-Elemental Resistance"
            // Keep 12.5% of the current amount, reducing it by 87.5%.
            set l_amount=l_amount*.125
            set l_fxCode=3
        endif
    endif
    // Show the evade / block effect and floating text when the hit was stopped.
    if(l_blockCode>0)then
        if(l_blockCode==1)then
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl",t,"origin"))
        elseif(l_blockCode==2)then
            call DestroyEffect(AddSpecialEffectTarget(Trig_Damage_Engine_BlockEffectPath(l_physical),t,"origin"))
        endif
        call Text_FloatingDamage(t,false,l_blockCode,.0,false,0)
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Element[c]=l_element
    set DmgCtx_FxCode[c]=l_fxCode
    set DmgCtx_BlockCode[c]=l_blockCode
    set DmgCtx_Val[c]=l_val
    set u=null
    set t=null
endfunction

// Step 12 - Physical attacker skills: Aim, Killer / Artemis Arrows and other shot bonuses.
function Trig_Damage_Engine_Step12_PhysicalSkills takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local real tx=DmgCtx_TargetX[c]
    local real ty=DmgCtx_TargetY[c]
    local player up=DmgCtx_SourcePlayer[c]
    local real l_armorMult=DmgCtx_ArmorMult[c]
    local integer l_tmp=DmgCtx_Tmp[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    if(l_physical and l_amount>.0)then
        if(GetUnitAbilityLevel(u,'B01F')>0 and GetUnitAbilityLevel(u,'A0RH')>0)then // 'B01F': buff tooltip "Aim"; 'A0RH': ability "Aim"
            // Result 1: (amount) times (1.2).
            // Result 2: (GetUnitAbilityLevel(u, 'A0RH')) times (50).
            // Result 3: result 2 treated as a decimal-capable number.
            // Result 4: (result 3) divided by (l_armorMult).
            // Result 5: (result 1) plus (result 4).
            set l_amount=(l_amount*1.2)+(I2R(GetUnitAbilityLevel(u,'A0RH')*50)/ l_armorMult) // 'A0RH': ability "Aim"
        endif
        set l_tmp=Prof_GetLevel(u,'R002') // 'R002': upgrade "Bow"
        if(l_tmp>0)then
            // Increase l_tmp by 10.
            set l_tmp=l_tmp+$A // $A = 10
            if(GetUnitAbilityLevel(u,'A04H')>0)then // 'A04H': ability "Little Arrows"
                // ((amount) times (1.15)) plus (((l_tmp treated as a decimal-capable number) times (10)) divided by
                // (l_armorMult)).
                set l_amount=(l_amount*1.15)+((I2R(l_tmp)*10.)/ l_armorMult)
            endif
            if(GetUnitAbilityLevel(u,'A0Y8')>0)then // 'A0Y8': ability "Onion Arrows"
                // ((amount) times (1.2)) plus (((l_tmp treated as a decimal-capable number) times (20)) divided by
                // (l_armorMult)).
                set l_amount=(l_amount*1.2)+((I2R(l_tmp)*20.)/ l_armorMult)
            endif
            if(GetUnitAbilityLevel(u,'A0Y9')>0)then // 'A0Y9': ability "Killer Arrows"
                // ((amount) times (1.25)) plus (((l_tmp treated as a decimal-capable number) times (50)) divided by
                // (l_armorMult)).
                set l_amount=(l_amount*1.25)+((I2R(l_tmp)*50.)/ l_armorMult)
            endif
            if(GetUnitAbilityLevel(u,'A174')>0)then // 'A174': ability "Artemis Arrows"
                // ((amount) times (1.3)) plus (((l_tmp treated as a decimal-capable number) times (80)) divided by
                // (l_armorMult)).
                set l_amount=(l_amount*1.3)+((I2R(l_tmp)*80.)/ l_armorMult)
            endif
            if(GetUnitAbilityLevel(u,'A0Y6')>0 and IsUnitType(u,UNIT_TYPE_HERO))then // 'A0Y6': ability "Tempest Arrows"
                // Result 1: (Agility of u) times (l_tmp).
                // Result 2: result 1 treated as a decimal-capable number.
                // Result 3: (result 2) times (0.04).
                // Result 4: (result 3) divided by (l_armorMult).
                // Result 5: (amount) plus (result 4).
                set l_amount=l_amount+((I2R(GetHeroAgi(u,true)*l_tmp)*.04)/ l_armorMult)
            endif
        endif
        if(GetUnitAbilityLevel(u,'A16E')>0)then // 'A16E': ability "Blind Spot"
            if(GetUnitAbilityLevel(t,'A17C')<=0)then // 'A17C': ability "Blind Spotted"
                call UnitAddAbility(t,'A17C') // 'A17C': ability "Blind Spotted"
            elseif(GetUnitAbilityLevel(t,'A17C')==2)then // 'A17C': ability "Blind Spotted"
                call SetUnitAbilityLevel(t,'A17C',1) // 'A17C': ability "Blind Spotted"
                // Multiply the current amount by 1.25: 100 becomes 125, before any later adjustments.
                set l_amount=l_amount*1.25
                if(GetUnitAbilityLevel(u,'B01F')>0 and GetUnitAbilityLevel(u,'A14B')>=$B and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(up,udg_JobMasterForce[2]))then // 'B01F': buff tooltip "Aim"; 'A14B': ability "Aim"; $B = 11; 'A02F': ability "Mastery"
                    set udg_BlindSpotCount[GetPlayerId(up)+1]=udg_BlindSpotCount[GetPlayerId(up)+1]+1
                    // (GetPlayerId(up)) plus (1).
                    if(udg_BlindSpotCount[GetPlayerId(up)+1]>=60)then
                        call ForceAddPlayer(udg_JobMasterForce[2],up)
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
                    endif
                endif
            endif
        endif
        if(GetUnitAbilityLevel(u,'A0PF')>0 or(GetUnitAbilityLevel(u,'A13Q')>0 and l_tmp>0))then // 'A0PF': ability "Frost Attack"; 'A13Q': ability "Icecloud Arrows"
            set l_dummy=CreateUnit(up,'h02S',tx,ty,.0) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnit(l_dummy,false)
            call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
            call UnitAddAbility(l_dummy,'A0PE') // 'A0PE': ability "Frost Attack"
            call IssueTargetOrder(l_dummy,"frostnova",t)
        endif
        // A random whole number from 1 through 10.
        if((GetUnitAbilityLevel(u,'A1EV')>0 or(GetUnitAbilityLevel(u,'A13W')>0 and l_tmp>0))and GetRandomInt(1,$A)==1)then // 'A1EV': ability "Shock Attack"; 'A13W': ability "Shock Arrows"; $A = 10
            call UnitRemoveAbility(t,'B013') // 'B013': buff tooltip "Shock"
            set l_dummy=CreateUnit(up,'h02S',tx,ty,.0) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnit(l_dummy,false)
            call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
            call UnitAddAbility(l_dummy,'A13V') // 'A13V': ability "Shock Arrows"
            call IssueTargetOrder(l_dummy,"acidbomb",t)
        endif
        if(GetUnitAbilityLevel(t,'B04T')<=0 and(GetUnitAbilityLevel(u,'A0PH')>0 or GetUnitAbilityLevel(u,'A0PI')>0 or GetUnitAbilityLevel(u,'A0PJ')>0 or GetUnitAbilityLevel(u,'A0PK')>0))then // 'B04T': buff tooltip "Poison"; 'A0PH': ability "Poison Attack"; 'A0PI': ability "Deadly Poison"; 'A0PJ': ability "Poison Acid"; 'A0PK': ability "Poison Acid"
            set l_dummy=CreateUnit(up,'h01B',tx,ty,.0) // 'h01B': unit "Proxy Dummy"
            set l_tmp=GetHandleId(l_dummy)
            call SaveUnitHandle(udg_ProxyDamageHash,l_tmp,0,u)
            call SaveReal(udg_ProxyDamageHash,l_tmp,1,.0)
            call SaveInteger(udg_ProxyDamageHash,l_tmp,2,3)
            call ShowUnit(l_dummy,false)
            call UnitApplyTimedLife(l_dummy,'BTLF',11.) // 'BTLF': object name not found in map data
            if(GetUnitAbilityLevel(u,'A0PI')>0)then // 'A0PI': ability "Deadly Poison"
                call UnitAddAbility(l_dummy,'A12P') // 'A12P': ability "Deadly Poison"
            elseif(GetUnitAbilityLevel(u,'A0PJ')>0)then // 'A0PJ': ability "Poison Acid"
                call UnitAddAbility(l_dummy,'A12Q') // 'A12Q': ability "Poison Acid"
            elseif(GetUnitAbilityLevel(u,'A0PK')>0)then // 'A0PK': ability "Poison Acid"
                call UnitAddAbility(l_dummy,'A12R') // 'A12R': ability "Poison Acid"
            else
                call UnitAddAbility(l_dummy,'A0PG') // 'A0PG': ability "Poison Attack"
                // ((unit level of u) times (3)) plus (5).
                call SaveReal(udg_ProxyDamageHash,l_tmp,1,(GetUnitLevel(u)*3)+5.)
            endif
            call IssueTargetOrder(l_dummy,"acidbomb",t)
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Tmp[c]=l_tmp
    set DmgCtx_Dummy[c]=l_dummy
    set u=null
    set t=null
    set l_dummy=null
endfunction

// Step 13 - Marked for Death and Undead Touch.
function Trig_Damage_Engine_Step13_MarkedForDeath takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_heal=DmgCtx_Heal[c]
    if(l_amount>.0 and not l_heal and GetUnitAbilityLevel(t,'B07M')>0)then // 'B07M': buff tooltip "Marked for Death"
        // ((amount) plus (80)) plus ((GetUnitAbilityLevel(t, 'A03C')) times (20)).
        set l_amount=l_amount+80+(GetUnitAbilityLevel(t,'A03C')*20) // 'A03C': ability "Marked for Death"
        if not IsUnitType(u,UNIT_TYPE_HERO)then
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
        endif
    endif
    if(l_amount>.0 and not l_heal and GetUnitAbilityLevel(u,'A1FC')>0)then // 'A1FC': ability "Undead Touch"
        // Increase amount by 30.
        set l_amount=l_amount+30
    endif
    set DmgCtx_Amount[c]=l_amount
    set u=null
    set t=null
endfunction

// Step 14 - Difficulty: hits from the enemy player (Player(11)) on active players are divided by
// DifficultyScale; hits on the enemy player are multiplied by it.
function Trig_Damage_Engine_Step14_Difficulty takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_pure=DmgCtx_Pure[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_magical=DmgCtx_Magical[c]
    local player up=DmgCtx_SourcePlayer[c]
    local player tp=DmgCtx_TargetPlayer[c]
    local real l_defScale=DmgCtx_DefenseScale[c]
    if(not l_pure and udg_Difficulty!=3)then
        if(up==Player($B)and IsPlayerInForce(tp,udg_ActivePlayers))then // $B = 11
            // (amount) divided by (udg_DifficultyScale).
            set l_amount=l_amount/ udg_DifficultyScale
        elseif(tp==Player($B))then // $B = 11
            // (amount) times (udg_DifficultyScale).
            set l_amount=l_amount*udg_DifficultyScale
        endif
    endif
    // Eternity Mode bonuses.
    if(l_amount>.0 and udg_EternityMode)then
        if(not l_pure and GetUnitAbilityLevel(u,'B07T')>0)then // 'B07T': buff "Eternity Mode"
            if l_physical then
                // Multiply the current amount by 1.2: 100 becomes 120, before any later adjustments.
                set l_amount=l_amount*1.2
            else
                // ((amount) times (1.3)) plus ((l_defScale) times (400)).
                set l_amount=(l_amount*1.3)+(l_defScale*400)
            endif
        elseif(l_magical and not l_heal and GetUnitAbilityLevel(t,'B07T')>0)then // 'B07T': buff "Eternity Mode"
            // Keep 62.5% of the current amount, reducing it by 37.5%.
            set l_amount=l_amount*.625
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set u=null
    set t=null
endfunction

// Step 15 - Random spread: normally x(15..16)/16; Gambler Spirit x(0.2..2).
function Trig_Damage_Engine_Step15_RandomSpread takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_pure=DmgCtx_Pure[c]
    local boolean l_ignoreDef=DmgCtx_IgnoreDefense[c]
    if(not l_pure and l_amount>.0)then
        if(GetUnitAbilityLevel(u,'A05L')>0)then // 'A05L': ability "Gambler Spirit"
            // (amount) times (a random decimal number between 0.2 and 2).
            set l_amount=l_amount*GetRandomReal(.2,2.)
        else
            // (amount) times ((a random decimal number between 15 and 16) divided by (16)).
            set l_amount=l_amount*(GetRandomReal(15.,16.)/ 16.)
        endif
        if(GetUnitAbilityLevel(u,'B07V')>0)then // 'B07V': buff tooltip "Momentum"
            // (amount) times ((1) plus ((0.25) times ((GetUnitAbilityLevel(u, 'A197')) minus (1)))).
            set l_amount=l_amount*(1.+(.25*(GetUnitAbilityLevel(u,'A197')-1))) // 'A197': ability "Momentum"
        elseif(GetUnitAbilityLevel(u,'A197')>1)then // 'A197': ability "Momentum"
            call SetUnitAbilityLevel(u,'A197',1) // 'A197': ability "Momentum"
        endif
        if not l_heal then
            if(GetUnitAbilityLevel(t,'A0ZU')>0)then // 'A0ZU': ability "Double Vulnerable"
                // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
                set l_amount=l_amount*2.
            endif
            // (current health of t) divided by (maximum health of t).
            if(GetUnitAbilityLevel(t,'A0T9')>0 and not l_ignoreDef and(GetUnitState(t,UNIT_STATE_LIFE)/ GetUnitState(t,UNIT_STATE_MAX_LIFE))<=.3)then // 'A0T9': ability "Last Stand"
                // Keep 50% of the current amount, reducing it by 50%.
                set l_amount=l_amount*.5
            endif
            if(GetUnitAbilityLevel(t,'B01F')>0)then // 'B01F': buff tooltip "Aim"
                if(GetUnitAbilityLevel(t,'A0RH')>=$B)then // 'A0RH': ability "Aim"; $B = 11
                    // Multiply the current amount by 1.2: 100 becomes 120, before any later adjustments.
                    set l_amount=l_amount*1.2
                else
                    // Multiply the current amount by 1.3: 100 becomes 130, before any later adjustments.
                    set l_amount=l_amount*1.3
                endif
            endif
            if(GetUnitAbilityLevel(u,'B00K')>0 or GetUnitAbilityLevel(u,'B07P')>0)then // 'B00K': buff tooltip "Rage"; 'B07P': buff "Enraged"
                // Multiply the current amount by 1.1: 100 becomes 110, before any later adjustments.
                set l_amount=l_amount*1.1
            endif
            if(GetUnitAbilityLevel(t,'B00K')>0 or GetUnitAbilityLevel(t,'B07P')>0)then // 'B00K': buff tooltip "Rage"; 'B07P': buff "Enraged"
                // Multiply the current amount by 1.6: 100 becomes 160, before any later adjustments.
                set l_amount=l_amount*1.6
            endif
            if(GetUnitAbilityLevel(t,'B06R')>0)then // 'B06R': buff tooltip "Spiritual Guard"
                // Keep 20% of the current amount, reducing it by 80%.
                set l_amount=l_amount*.2
            endif
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set u=null
    set t=null
endfunction

// Step 16 - Physical hit: critical hits, Devaluing Attack, Bravery / Pain buffs, Focus,
// Adrenaline, Physical Hardness, Deathblow, Ultima Blade.
function Trig_Damage_Engine_Step16_PhysicalHit takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_noCrit=DmgCtx_NoCrit[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_melee=DmgCtx_Melee[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_ignoreDef=DmgCtx_IgnoreDefense[c]
    local integer l_fxCode=DmgCtx_FxCode[c]
    local real ux=DmgCtx_SourceX[c]
    local real uy=DmgCtx_SourceY[c]
    local real tx=DmgCtx_TargetX[c]
    local real ty=DmgCtx_TargetY[c]
    local player up=DmgCtx_SourcePlayer[c]
    local integer l_tmp=DmgCtx_Tmp[c]
    local real l_val=DmgCtx_Val[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    if(l_physical and l_amount>.0)then
        if(not l_noCrit and not IsUnitType(t,UNIT_TYPE_STRUCTURE))then
            set l_val=1.
            // A random whole number from 1 through 20.
            if((((GetUnitAbilityLevel(u,'A15K')>0 and GetUnitLevel(t)<GetUnitLevel(u)and(not udg_EternityMode or GetUnitLevel(u)>60))or(GetUnitAbilityLevel(u,'A10X')>0 and GetUnitLevel(t)<40 and not udg_EternityMode))and(not IsUnitType(t,UNIT_TYPE_HERO)and not IsUnitType(t,UNIT_TYPE_RESISTANT))and(u==udg_StoryBoss or u==udg_SummonedBoss or GetRandomInt(1,20)==1)))then // 'A15K': ability "Mortal Shock"; 'A10X': ability "Mortal Shock"
                set l_fxCode=2
                set l_amount=6666666.
                set l_ignoreDef=true
            elseif(l_melee and GetUnitAbilityLevel(u,'B089')>0)then // 'B089': buff tooltip "Stealth"
                set l_val=4.
            elseif(l_melee and((GetUnitAbilityLevel(u,'A0WH')>0 or GetUnitAbilityLevel(u,'A0WL')>0 or GetUnitAbilityLevel(u,'A1B9')>0 or GetUnitAbilityLevel(u,'B04D')>0)and(not IsUnitType(t,UNIT_TYPE_STRUCTURE)and Trig_Damage_Engine_IsBehind(ux,uy,tx,ty,GetUnitFacing(t)))))then // 'A0WH': ability "Backstab Crit"; 'A0WL': ability "Backstab Deathblow"; 'A1B9': ability "Backstab"; 'B04D': buff tooltip "Thievery"
                if(GetUnitAbilityLevel(u,'A0WL')>0 and(not IsUnitType(t,UNIT_TYPE_HERO)and not IsUnitType(t,UNIT_TYPE_RESISTANT)and GetUnitLevel(t)<GetUnitLevel(u)and(not udg_EternityMode or GetUnitLevel(u)>60)))then // 'A0WL': ability "Backstab Deathblow"
                    set l_fxCode=2
                    set l_amount=6666666.
                    set l_ignoreDef=true
                elseif(GetUnitAbilityLevel(u,'A0WH')>0)then // 'A0WH': ability "Backstab Crit"
                    set l_val=2.
                elseif(GetUnitAbilityLevel(u,'A0WL')>0 or GetUnitAbilityLevel(u,'A1B9')>0)then // 'A0WL': ability "Backstab Deathblow"; 'A1B9': ability "Backstab"
                    set l_val=1.5
                endif
                if(GetUnitAbilityLevel(u,'B04D')>0)then // 'B04D': buff tooltip "Thievery"
                    // (l_val) times ((1.2) plus ((0.1) times (GetUnitAbilityLevel(u, 'A0KY')))).
                    set l_val=l_val*(1.2+(.1*GetUnitAbilityLevel(u,'A0KY'))) // 'A0KY': ability "Thievery"
                endif
            else
                set l_val=Trig_Damage_Engine_GetCritMult(u)
            endif
            if(l_val!=1.)then
                set l_fxCode=2
                if(GetUnitAbilityLevel(u,'A18L')>0)then // 'A18L': ability "High Critical Shot"
                    set l_val=l_val+1.
                endif
                // (amount) times (l_val).
                set l_amount=l_amount*l_val
                call TimerStart(udg_LastCritTimer[GetPlayerId(up)],5.,false,null)
            endif
        endif
        if(GetUnitAbilityLevel(u,'A0QX')>0 and(GetUnitUserData(t)>=1 and GetUnitUserData(t)<=9))then // 'A0QX': ability "Devaluing Attack"
            call UnitAddAbility(t,'A0QY') // 'A0QY': ability "Devalued"
            call UnitRemoveAbility(t,'Aspy') // 'Aspy': object name not found in map data
            call UnitRemoveAbility(t,'Aspt') // 'Aspt': object name not found in map data
            call UnitRemoveAbility(t,'A018') // 'A018': ability "Spawn Brood Mothers"
            call UnitRemoveAbility(t,'Aspd') // 'Aspd': object name not found in map data
            // (amount) plus (current health of t).
            set l_amount=l_amount+GetUnitState(t,UNIT_STATE_LIFE)
        endif
        if(GetUnitAbilityLevel(u,'B061')>0)then // 'B061': buff tooltip "Imperial Rage"
            // Multiply the current amount by 3: 100 becomes 300, before any later adjustments.
            set l_amount=l_amount*3.
        endif
        if(GetUnitAbilityLevel(u,'B08P')>0)then // 'B08P': buff "Bravera"
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
        elseif(GetUnitAbilityLevel(u,'B01W')>0 or GetUnitAbilityLevel(u,'B07I')>0 or GetUnitAbilityLevel(u,'A0WE')>0)then // 'B01W': buff "Bravery"; 'B07I': buff "Bravery"; 'A0WE': ability "Auto-Bravery"
            // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
            set l_amount=l_amount*1.5
        elseif(GetUnitAbilityLevel(u,'B08W')>0)then // 'B08W': buff "Painra"
            // Keep 50% of the current amount, reducing it by 50%.
            set l_amount=l_amount*.5
        elseif(GetUnitAbilityLevel(u,'B06H')>0)then // 'B06H': buff "Pain"
            // Keep 66.666% of the current amount, reducing it by 33.334%.
            set l_amount=l_amount*.66666
        endif
        if(GetUnitAbilityLevel(t,'A0F3')>0)then // 'A0F3': ability "Invert Defense Buffs"
            if(not l_ignoreDef and(GetUnitAbilityLevel(t,'B06J')>0 or GetUnitAbilityLevel(t,'A15Q')>0))then // 'B06J': buff tooltip "Deprotect"; 'A15Q': ability "Auto-Deprotect"
                // Keep 66.666% of the current amount, reducing it by 33.334%.
                set l_amount=l_amount*.66666
            elseif(not l_heal and(GetUnitAbilityLevel(t,'B007')>0 or GetUnitAbilityLevel(t,'B07G')>0 or GetUnitAbilityLevel(t,'B08R')>0 or GetUnitAbilityLevel(t,'A15P')>0))then // 'B007': buff "Protect"; 'B07G': buff "Protect"; 'B08R': buff "Protectra"; 'A15P': ability "Auto-Protect"
                // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
                set l_amount=l_amount*1.5
            endif
        else
            if(not l_ignoreDef and GetUnitAbilityLevel(t,'B08R')>0)then // 'B08R': buff "Protectra"
                // Keep 50% of the current amount, reducing it by 50%.
                set l_amount=l_amount*.5
            elseif(not l_ignoreDef and(GetUnitAbilityLevel(t,'B007')>0 or GetUnitAbilityLevel(t,'B07G')>0 or GetUnitAbilityLevel(t,'A15P')>0))then // 'B007': buff "Protect"; 'B07G': buff "Protect"; 'A15P': ability "Auto-Protect"
                // Keep 66.666% of the current amount, reducing it by 33.334%.
                set l_amount=l_amount*.66666
            elseif(not l_heal and(GetUnitAbilityLevel(t,'B06J')>0 or GetUnitAbilityLevel(t,'A15Q')>0))then // 'B06J': buff tooltip "Deprotect"; 'A15Q': ability "Auto-Deprotect"
                // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
                set l_amount=l_amount*1.5
            endif
        endif
        // (current health of u) divided by (maximum health of u).
        if(GetUnitAbilityLevel(u,'A0P9')>0 and(GetUnitState(u,UNIT_STATE_LIFE)/ GetUnitState(u,UNIT_STATE_MAX_LIFE))>=.99)then // 'A0P9': ability "Focus"
            // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
            set l_amount=l_amount*1.5
            if(GetUnitAbilityLevel(u,'B063')>0 and GetUnitAbilityLevel(u,'A0O4')>0)then // 'B063': buff "Cover"; 'A0O4': ability "Cover"
                set l_tmp=GetUnitAbilityLevel(u,'A0O4') // 'A0O4': ability "Cover"
                // (l_tmp) minus (1).
                set l_dummy=Player_GetHero(Player(l_tmp-1))
                // (l_tmp) minus (1).
                if(IsPlayerInForce(Player(l_tmp-1),udg_JobMasterForce[0])or GetUnitAbilityLevel(l_dummy,'A02F')!=3 or GetUnitTypeId(l_dummy)!='H000')then // 'A02F': ability "Mastery"; 'H000': unit "Squire"
                    call UnitRemoveAbility(u,'A0O4') // 'A0O4': ability "Cover"
                else
                    set udg_CoverAwardCount[l_tmp]=udg_CoverAwardCount[l_tmp]+1
                    if(udg_CoverAwardCount[l_tmp]>=30)then
                        // (l_tmp) minus (1).
                        call ForceAddPlayer(udg_JobMasterForce[0],Player(l_tmp-1))
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",l_dummy,"origin"))
                    endif
                endif
            endif
        // (current health of u) divided by (maximum health of u).
        elseif(GetUnitAbilityLevel(u,'A0PA')>0 and(GetUnitState(u,UNIT_STATE_LIFE)/ GetUnitState(u,UNIT_STATE_MAX_LIFE))<=.3)then // 'A0PA': ability "Adrenaline"
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
        endif
        if(not l_ignoreDef and GetUnitAbilityLevel(t,'A0WN')>0)then // 'A0WN': ability "Physical Hardness"
            // Keep 70% of the current amount, reducing it by 30%.
            set l_amount=l_amount*.7
        endif
        if(GetUnitAbilityLevel(u,'A07L')>0)then // 'A07L': ability "Deathblow"
            // (amount) times ((1.5) minus ((current health of t) divided by (maximum health of t))).
            set l_amount=l_amount*(1.5-(GetUnitState(t,UNIT_STATE_LIFE)/ GetUnitState(t,UNIT_STATE_MAX_LIFE)))
        endif
        if(GetUnitAbilityLevel(u,'A11F')>0)then // 'A11F': ability "Ultima Blade"
            // (amount) times ((1.5) times ((current health of u) divided by (maximum health of u))).
            set l_amount=l_amount*(1.5*(GetUnitState(u,UNIT_STATE_LIFE)/ GetUnitState(u,UNIT_STATE_MAX_LIFE)))
        endif
    endif
    // Backstab and Stealth end once the attacker hits.
    call UnitRemoveAbility(u,'B03N') // 'B03N': buff tooltip "Backstab"
    call UnitRemoveAbility(u,'B089') // 'B089': buff tooltip "Stealth"
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_IgnoreDefense[c]=l_ignoreDef
    set DmgCtx_FxCode[c]=l_fxCode
    set DmgCtx_Tmp[c]=l_tmp
    set DmgCtx_Val[c]=l_val
    set DmgCtx_Dummy[c]=l_dummy
    set u=null
    set t=null
    set l_dummy=null
endfunction

// Step 17 - Magic: Faith / Faithra and other spell-power modifiers.
function Trig_Damage_Engine_Step17_Magic takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_magical=DmgCtx_Magical[c]
    local boolean l_ignoreDef=DmgCtx_IgnoreDefense[c]
    local integer l_tmp=DmgCtx_Tmp[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    if(l_magical and l_amount>.0)then
        if(GetUnitAbilityLevel(u,'B08Q')>0)then // 'B08Q': buff "Faithra"
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
        elseif(GetUnitAbilityLevel(u,'B05A')>0 or GetUnitAbilityLevel(u,'B07J')>0 or GetUnitAbilityLevel(u,'A0WG')>0)then // 'B05A': buff "Faith"; 'B07J': buff "Faith"; 'A0WG': ability "Auto-Faith"
            // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
            set l_amount=l_amount*1.5
        elseif(GetUnitAbilityLevel(u,'B08X')>0)then // 'B08X': buff "Fogra"
            // Keep 50% of the current amount, reducing it by 50%.
            set l_amount=l_amount*.5
        elseif(GetUnitAbilityLevel(u,'B06I')>0)then // 'B06I': buff "Fog"
            // Keep 66.666% of the current amount, reducing it by 33.334%.
            set l_amount=l_amount*.66666
        endif
        if(GetUnitAbilityLevel(t,'A0F3')>0)then // 'A0F3': ability "Invert Defense Buffs"
            if(not l_ignoreDef and(GetUnitAbilityLevel(t,'B06K')>0 or GetUnitAbilityLevel(t,'A15S')>0))then // 'B06K': buff tooltip "Deshell"; 'A15S': ability "Auto-Deshell"
                // Keep 66.666% of the current amount, reducing it by 33.334%.
                set l_amount=l_amount*.66666
            elseif(not l_heal and(GetUnitAbilityLevel(t,'B005')>0 or GetUnitAbilityLevel(t,'B07H')>0 or GetUnitAbilityLevel(t,'B08S')>0 or GetUnitAbilityLevel(t,'A15R')>0))then // 'B005': buff "Shell"; 'B07H': buff "Shell"; 'B08S': buff "Shellra"; 'A15R': ability "Auto-Shell"
                // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
                set l_amount=l_amount*1.5
            endif
        else
            if(not l_ignoreDef and GetUnitAbilityLevel(t,'B08S')>0)then // 'B08S': buff "Shellra"
                // Keep 50% of the current amount, reducing it by 50%.
                set l_amount=l_amount*.5
            elseif(not l_ignoreDef and(GetUnitAbilityLevel(t,'B005')>0 or GetUnitAbilityLevel(t,'B07H')>0 or GetUnitAbilityLevel(t,'A15R')>0))then // 'B005': buff "Shell"; 'B07H': buff "Shell"; 'A15R': ability "Auto-Shell"
                // Keep 66.666% of the current amount, reducing it by 33.334%.
                set l_amount=l_amount*.66666
            elseif(not l_heal and(GetUnitAbilityLevel(t,'B06K')>0 or GetUnitAbilityLevel(t,'A15S')>0))then // 'B06K': buff tooltip "Deshell"; 'A15S': ability "Auto-Deshell"
                // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
                set l_amount=l_amount*1.5
            endif
        endif
        // (current health of u) divided by (maximum health of u).
        if(GetUnitAbilityLevel(u,'A0RF')>0 and(GetUnitState(u,UNIT_STATE_LIFE)/ GetUnitState(u,UNIT_STATE_MAX_LIFE))>=.99)then // 'A0RF': ability "Serenity"
            // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
            set l_amount=l_amount*1.5
            if(GetUnitAbilityLevel(u,'B063')>0 and GetUnitAbilityLevel(u,'A0O4')>0)then // 'B063': buff "Cover"; 'A0O4': ability "Cover"
                set l_tmp=GetUnitAbilityLevel(u,'A0O4') // 'A0O4': ability "Cover"
                // (l_tmp) minus (1).
                set l_dummy=Player_GetHero(Player(l_tmp-1))
                // (l_tmp) minus (1).
                if(IsPlayerInForce(Player(l_tmp-1),udg_JobMasterForce[0])or GetUnitAbilityLevel(l_dummy,'A02F')!=3 or GetUnitTypeId(l_dummy)!='H000')then // 'A02F': ability "Mastery"; 'H000': unit "Squire"
                    call UnitRemoveAbility(u,'A0O4') // 'A0O4': ability "Cover"
                else
                    set udg_CoverAwardCount[l_tmp]=udg_CoverAwardCount[l_tmp]+1
                    if(udg_CoverAwardCount[l_tmp]>=30)then
                        // (l_tmp) minus (1).
                        call ForceAddPlayer(udg_JobMasterForce[0],Player(l_tmp-1))
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",l_dummy,"origin"))
                    endif
                endif
            endif
        // (current health of u) divided by (maximum health of u).
        elseif(GetUnitAbilityLevel(u,'A0RG')>0 and(GetUnitState(u,UNIT_STATE_LIFE)/ GetUnitState(u,UNIT_STATE_MAX_LIFE))<=.3)then // 'A0RG': ability "Spellbreaker"
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
        endif
        if(not l_ignoreDef and GetUnitAbilityLevel(t,'A0WP')>0)then // 'A0WP': ability "Magical Hardness"
            // Keep 70% of the current amount, reducing it by 30%.
            set l_amount=l_amount*.7
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Tmp[c]=l_tmp
    set DmgCtx_Dummy[c]=l_dummy
    set u=null
    set t=null
    set l_dummy=null
endfunction

// Step 18 - Final modifiers from both sides: Night Might, Great Wall, Inner Fire, Death Screech,
// Sleep, Oversoul, Adaptive Barrier, Sentinel, Divine Shield, Drain Attack ...
function Trig_Damage_Engine_Step18_FinalModifiers takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local integer l_element=DmgCtx_Element[c]
    local boolean l_manaDamage=DmgCtx_ManaDamage[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_pure=DmgCtx_Pure[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local boolean l_magical=DmgCtx_Magical[c]
    local integer th=DmgCtx_TargetHandle[c]
    local player up=DmgCtx_SourcePlayer[c]
    local integer l_tmp=DmgCtx_Tmp[c]
    local real l_val=DmgCtx_Val[c]
    local real l_val2=DmgCtx_Val2[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    if l_amount>.0 then
        if(GetUnitAbilityLevel(u,'A03N')>0 and not l_pure and Trig_Damage_Engine_IsNight())then // 'A03N': ability "Night Might"
            // Multiply the current amount by 1.6: 100 becomes 160, before any later adjustments.
            set l_amount=l_amount*1.6
        endif
        if(GetUnitAbilityLevel(t,'A03N')>0 and not l_heal and Trig_Damage_Engine_IsNight())then // 'A03N': ability "Night Might"
            // Keep 62.5% of the current amount, reducing it by 37.5%.
            set l_amount=l_amount*.625
        endif
        if(not l_heal and(GetUnitAbilityLevel(t,'B06B')>0 or GetUnitAbilityLevel(t,'B06C')>0))then // 'B06B': buff tooltip "Left Arm"; 'B06C': buff tooltip "Right Arm"
            // Keep 25% of the current amount, reducing it by 75%.
            set l_amount=l_amount*.25
        endif
        if(not l_heal and l_amount>1.)then
            if(GetUnitAbilityLevel(t,'A0RV')>0 or GetUnitAbilityLevel(t,'A0EI')>0)then // 'A0RV': ability "Improved Hardened Skin"; 'A0EI': ability "Adamant Armor"
                if l_amount<=26. then
                    set l_amount=1.
                else
                    // Decrease amount by 25.
                    set l_amount=l_amount-25.
                endif
            elseif(GetUnitAbilityLevel(t,'A0RU')>0)then // 'A0RU': ability "Hardened Skin"
                if l_amount<=11. then
                    set l_amount=1.
                else
                    // Decrease amount by 10.
                    set l_amount=l_amount-10.
                endif
            endif
        endif
        if(GetUnitAbilityLevel(t,'B08U')>0 and not l_heal and l_amount>1.)then // 'B08U': buff tooltip "Girimehkala Skin"
            // Keep 66.666% of the current amount, reducing it by 33.334%.
            set l_amount=l_amount*.66666
            if l_amount<='e' then
                set l_amount=1.
            else
                // Decrease amount by 100.
                set l_amount=l_amount-'d'
            endif
        endif
        if(GetUnitAbilityLevel(t,'A1FA')>0 and not l_heal)then // 'A1FA': ability "Great Wall"
            // Keep 50% of the current amount, reducing it by 50%.
            set l_amount=l_amount*.5
        endif
        if(GetUnitAbilityLevel(u,'B076')>0 and(not l_pure or l_heal))then // 'B076': buff "Inner Fire"
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
        endif
        if(GetUnitAbilityLevel(t,'B070')>0 and(not l_pure or l_heal))then // 'B070': buff tooltip "Death Screech"
            if l_heal then
                // Keep 70% of the current amount, reducing it by 30%.
                set l_amount=l_amount*.7
            else
                // Multiply the current amount by 1.3: 100 becomes 130, before any later adjustments.
                set l_amount=l_amount*1.3
            endif
        endif
        if(((l_manaDamage and GetUnitAbilityLevel(u,'B07E')>0)or(not l_manaDamage and GetUnitAbilityLevel(u,'B07D')>0))and l_heal)then // 'B07E': buff tooltip "MP Plus"; 'B07D': buff tooltip "HP Plus"
            // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
            set l_amount=l_amount*2.
        endif
        if(GetUnitAbilityLevel(t,'B03A')>0)then // 'B03A': buff tooltip "Sleep"
            if(not l_heal and not l_pure and GetUnitAbilityLevel(t,'A0U6')<=0)then // 'A0U6': ability "Sleepproof"
                // Multiply the current amount by 2: 100 becomes 200, before any later adjustments.
                set l_amount=l_amount*2.
            endif
            call UnitRemoveAbility(t,'B03A') // 'B03A': buff tooltip "Sleep"
            call UnitRemoveAbility(t,'B03B') // 'B03B': buff "Sleep (Pause)"
            call UnitRemoveAbility(t,'B03C') // 'B03C': buff "Sleep (Stunned)"
            // (GetPlayerId(up)) plus (1).
            if(t==udg_SleepTarget[GetPlayerId(up)+1])then
                call TimerStart(udg_SleepWakeTimer[GetPlayerId(up)],.5,false,function Trig_Damage_Engine_AwardSorcerer)
            endif
        endif
        if(GetUnitAbilityLevel(t,'A13R')>0 and l_heal)then // 'A13R': ability "Rejuvenation"
            // Multiply the current amount by 1.5: 100 becomes 150, before any later adjustments.
            set l_amount=l_amount*1.5
        endif
        if(GetUnitAbilityLevel(u,'A134')>0 and not l_pure)then // 'A134': ability "Oversoul"
            // Multiply the current amount by 1.65: 100 becomes 165, before any later adjustments.
            set l_amount=l_amount*1.65
        endif
        if(not l_heal and(GetUnitAbilityLevel(t,'A0RE')>0 or GetUnitAbilityLevel(t,'B082')>0))then // 'A0RE': ability "Elunes Grace"; 'B082': buff tooltip "Dark Power"
            // Scale damage with the target's remaining health: keep 10% plus 90% times its health fraction.
            // At half health, the factor is 0.1 + 0.9 x 0.5 = 0.55, so keep 55% of the hit.
            set l_amount=l_amount*(.1+((GetUnitState(t,UNIT_STATE_LIFE)/ GetUnitState(t,UNIT_STATE_MAX_LIFE))*.9))
            if(GetUnitAbilityLevel(t,'A0RE')>0 and l_amount>100.)then // 'A0RE': ability "Elunes Grace"
                // Soften hits above 100: divide damage by 100, take the square root, then multiply by 100.
                // Examples: 400 becomes 200; 900 becomes 300. Big hits still hurt more, but grow more slowly.
                set l_amount=SquareRoot(l_amount*.01)*100.
            endif
        endif
        if(GetUnitAbilityLevel(u,'A0R9')>0)then // 'A0R9': ability "Demistrike"
            // (amount) plus ((current health of t) times (0.25)).
            set l_amount=l_amount+(GetUnitState(t,UNIT_STATE_LIFE)*.25)
        endif
        if(not l_heal and GetUnitAbilityLevel(t,'A1BF')>0)then // 'A1BF': ability "Adaptive Barrier"
            if l_physical then
                // Adaptive Barrier keeps a fraction of physical damage equal to ability level / 15.
                set l_amount=(l_amount*GetUnitAbilityLevel(t,'A1BF'))/ $F // 'A1BF': ability "Adaptive Barrier"; $F = 15
                // (udg_AdaptPhysTotal) plus (amount).
                set udg_AdaptPhysTotal=udg_AdaptPhysTotal+l_amount
            elseif l_magical then
                // Magic uses the opposite fraction: (16 - ability level) / 15.
                set l_amount=(l_amount*(16-GetUnitAbilityLevel(t,'A1BF')))/ $F // 'A1BF': ability "Adaptive Barrier"; $F = 15
                // (udg_AdaptMagicTotal) plus (amount).
                set udg_AdaptMagicTotal=udg_AdaptMagicTotal+l_amount
            else
                // Keep 50% of the current amount, reducing it by 50%.
                set l_amount=l_amount*.5
            endif
            // (udg_AdaptElementTotal at position l_element) plus (amount).
            set udg_AdaptElementTotal[l_element]=udg_AdaptElementTotal[l_element]+l_amount
            // (udg_AdaptElementTotal at position 7) plus (amount).
            set udg_AdaptElementTotal[7]=udg_AdaptElementTotal[7]+l_amount
            if(l_element<7)then
                // Count damage from other elements, divide by all tracked elemental damage plus 1, then add 0.2.
                // Repeating the same element lowers this multiplier; the +1 prevents division by zero.
                set l_val=((udg_AdaptElementTotal[7]-udg_AdaptElementTotal[l_element])/(udg_AdaptElementTotal[7]+1.))+.2
                // (amount) times (l_val).
                set l_amount=l_amount*l_val
            endif
            // Choose the next barrier level from the share of tracked damage that was magical.
            // Add 1 to each damage total to avoid an empty fraction, multiply the magic share by 15, drop decimals, then add 1.
            set l_tmp=R2I($F*((udg_AdaptMagicTotal+1.)/(udg_AdaptPhysTotal+udg_AdaptMagicTotal+2.)))+1 // $F = 15
            call SetUnitAbilityLevel(t,'A1BF',l_tmp) // 'A1BF': ability "Adaptive Barrier"
            if(l_tmp<=3)then
                call UnitAddAbility(t,'A15P') // 'A15P': ability "Auto-Protect"
                call UnitRemoveAbility(t,'A15R') // 'A15R': ability "Auto-Shell"
                call UnitRemoveAbility(t,'B06J') // 'B06J': buff tooltip "Deprotect"
            elseif(l_tmp>=$C)then // $C = 12
                call UnitAddAbility(t,'A15R') // 'A15R': ability "Auto-Shell"
                call UnitRemoveAbility(t,'A15P') // 'A15P': ability "Auto-Protect"
                call UnitRemoveAbility(t,'B06K') // 'B06K': buff tooltip "Deshell"
            else
                call UnitRemoveAbility(t,'A15P') // 'A15P': ability "Auto-Protect"
                call UnitRemoveAbility(t,'A15R') // 'A15R': ability "Auto-Shell"
                call UnitRemoveAbility(t,'B079') // 'B079': buff "Auto-Protect"
                call UnitRemoveAbility(t,'B07B') // 'B07B': buff "Auto-Shell"
            endif
        endif
        // (Prof_GetLevel(t, 'R005')) plus (1).
        set l_tmp=Prof_GetLevel(t,'R005')+1 // 'R005': upgrade "Plate Armor"
        if(l_amount>1. and not l_heal and not l_pure and l_tmp>1)then
            if l_amount<=l_tmp then
                set l_amount=1.
            else
                // (amount) minus (l_tmp).
                set l_amount=l_amount-l_tmp
            endif
        endif
        if(GetUnitAbilityLevel(t,'A1DL')>0 and not l_pure and not l_heal and(l_amount>GetUnitState(t,UNIT_STATE_LIFE)))then // 'A1DL': ability "Rakugaya Bonus"
            // Keep 50% of the current amount, reducing it by 50%.
            set l_amount=l_amount*.5
        endif
        if(GetUnitAbilityLevel(t,'B04M')>0 and not l_heal)then // 'B04M': buff tooltip "Sentinel"
            // Keep 33.333% of the current amount, reducing it by 66.667%.
            set l_amount=l_amount*.33333
            if(l_amount>GetUnitState(t,UNIT_STATE_LIFE)and GetUnitAbilityLevel(t,'B02X')<=0)then // 'B02X': buff tooltip "Auto-Life"
                call UnitRemoveAbility(t,'B04M') // 'B04M': buff tooltip "Sentinel"
                set l_amount=.0
                call Text_FloatingDamage(t,false,2,.0,false,2)
            endif
        endif
        if(l_amount>.0 and GetUnitAbilityLevel(t,'B051')>0 and not l_heal and LoadBoolean(udg_DivineShieldHash,th,3))then // 'B051': buff "Divine Shield"
            set l_dummy=LoadUnitHandle(udg_DivineShieldHash,th,4)
            if(GetUnitAbilityLevel(l_dummy,'Avul')>0)then // 'Avul': standard ability reference "Invulnerable"
                call UnitRemoveAbility(t,'B051') // 'B051': buff "Divine Shield"
            else
                // (amount) divided by ((LoadReal(udg_DivineShieldHash, th, 5)) times (2)).
                set l_val=(l_amount/(LoadReal(udg_DivineShieldHash,th,5)*2.))
                set l_val2=GetUnitState(l_dummy,UNIT_STATE_MANA)
                if(l_val>l_val2)then
                    set l_val=l_val2
                    call UnitRemoveAbility(t,'B051') // 'B051': buff "Divine Shield"
                endif
                if(l_val>=1)then
                    // (amount) minus ((l_val) times (LoadReal(udg_DivineShieldHash, th, 5))).
                    set l_amount=l_amount-(l_val*LoadReal(udg_DivineShieldHash,th,5))
                    // (l_val2) minus (l_val).
                    call SetUnitState(l_dummy,UNIT_STATE_MANA,l_val2-l_val)
                    call Text_FloatingDamage(l_dummy,false,0,l_val,true,0)
                endif
            endif
        endif
        if(GetUnitAbilityLevel(u,'B04B')<=0 and(GetUnitAbilityLevel(u,'A0V3')>0 or(GetUnitAbilityLevel(u,'BUav')>0 and l_physical))and not l_heal and l_amount>=2.)then // 'B04B': buff tooltip "Drain Attack"; 'A0V3': ability "Vampiric Power"; 'BUav': buff tooltip "Vampiric Strike"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl",u,"origin"))
            if(up==Player($B))then // $B = 11
                // (amount) times (0.5).
                set l_val=l_amount*.5
            else
                // (amount) times (0.2).
                set l_val=l_amount*.2
            endif
            // (current health of u) plus (l_val).
            call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_LIFE)+l_val)
            call Text_FloatingDamage(u,true,0,l_val,false,0)
        elseif(l_physical and GetUnitAbilityLevel(u,'B04B')>0 and GetUnitAbilityLevel(u,'A0R2')>0 and not l_heal and l_amount>=2.)then // 'B04B': buff tooltip "Drain Attack"; 'A0R2': ability "Drain Attack"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl",u,"origin"))
            if(GetUnitAbilityLevel(u,'A0R2')>=$B)then // 'A0R2': ability "Drain Attack"; $B = 11
                // Keep 75% of the current amount, reducing it by 25%.
                set l_amount=l_amount*.75
            else
                // (amount) times ((0.58) plus ((GetUnitAbilityLevel(u, 'A0R2') treated as a decimal-capable number) times
                // (0.02))).
                set l_amount=l_amount*(.58+(I2R(GetUnitAbilityLevel(u,'A0R2'))*.02)) // 'A0R2': ability "Drain Attack"
            endif
            // (amount) times (0.5).
            set l_val=l_amount*.5
            if(l_val>GetUnitState(t,UNIT_STATE_LIFE))then
                set l_val=GetUnitState(t,UNIT_STATE_LIFE)
            endif
            // (current health of u) plus (l_val).
            call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_LIFE)+l_val)
            call Text_FloatingDamage(u,true,0,l_val,false,0)
            if(l_val>=30000. and GetUnitAbilityLevel(u,'A0R2')>=$B and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(up,udg_JobMasterForce[20]))then // 'A0R2': ability "Drain Attack"; $B = 11; 'A02F': ability "Mastery"
                call ForceAddPlayer(udg_JobMasterForce[20],up)
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
            endif
        endif
    endif
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Tmp[c]=l_tmp
    set DmgCtx_Val[c]=l_val
    set DmgCtx_Val2[c]=l_val2
    set DmgCtx_Dummy[c]=l_dummy
    set u=null
    set t=null
    set l_dummy=null
endfunction

// Step 19 - Apply: heals and mana changes are applied here (with floating text) and return 0;
// normal damage is returned to the caller, which deals it.
function Trig_Damage_Engine_Step19_Apply takes integer c returns nothing
    local real l_amount=DmgCtx_Amount[c]
    local unit u=DmgCtx_Source[c]
    local unit t=DmgCtx_Target[c]
    local boolean l_manaDamage=DmgCtx_ManaDamage[c]
    local boolean l_heal=DmgCtx_Heal[c]
    local boolean l_melee=DmgCtx_Melee[c]
    local boolean l_physical=DmgCtx_Physical[c]
    local integer l_fxCode=DmgCtx_FxCode[c]
    local integer th=DmgCtx_TargetHandle[c]
    local player up=DmgCtx_SourcePlayer[c]
    local player tp=DmgCtx_TargetPlayer[c]
    local unit l_dummy=DmgCtx_Dummy[c]
    set udg_LastDamageDealt=l_amount
    if(l_amount>.0)then
        if l_manaDamage then
            if l_heal then
                // (current mana of t) plus (amount).
                call SetUnitState(t,UNIT_STATE_MANA,GetUnitState(t,UNIT_STATE_MANA)+l_amount)
            else
                // (current mana of t) minus (amount).
                call SetUnitState(t,UNIT_STATE_MANA,GetUnitState(t,UNIT_STATE_MANA)-l_amount)
            endif
            if l_amount<500000. then
                call Text_FloatingDamage(t,l_heal,0,l_amount,true,0)
            endif
            set l_amount=.0
        elseif l_heal then
            if l_amount<500000. then
                call Text_FloatingDamage(t,true,0,l_amount,false,0)
            else
                call Text_FloatingDamage(t,true,4,.0,false,0)
            endif
            // (current health of t) plus (amount).
            call SetUnitState(t,UNIT_STATE_LIFE,GetUnitState(t,UNIT_STATE_LIFE)+l_amount)
            if(udg_HealCreditPlayer>0)then
                // (GetPlayerId(up)) plus (1).
                if(udg_HealCreditPlayer==GetPlayerId(up)+1)then
                    // (udg_HealingTotal at position GetPlayerId(up)) plus (amount).
                    set udg_HealingTotal[GetPlayerId(up)]=udg_HealingTotal[GetPlayerId(up)]+l_amount
                    if(udg_HealingTotal[GetPlayerId(up)]>=50000. and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(up,udg_JobMasterForce[$C]))then // 'A02F': ability "Mastery"; $C = 12
                        call ForceAddPlayer(udg_JobMasterForce[$C],up) // $C = 12
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
                    endif
                endif
                set udg_HealCreditPlayer=0
            endif
            set l_amount=.0
        endif
    endif
    // Cleave / critical-hit effect on the target.
    if(l_amount>.0 and l_fxCode>0)then
        if(l_fxCode==1)then
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Cleave\\CleaveDamageTarget.mdl",t,"origin"))
        elseif(l_fxCode==2)then
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",t,"origin"))
        endif
    endif
    // Absorb shields store the damage instead of taking it.
    if(l_amount>.0 and IsUnitInGroup(t,udg_AbsorbShieldGroup))then
        // (LoadReal(udg_AbsorbShieldHash, th, 0)) plus (amount).
        call SaveReal(udg_AbsorbShieldHash,th,0,LoadReal(udg_AbsorbShieldHash,th,0)+l_amount)
        set l_amount=.0
        call DestroyEffect(AddSpecialEffectTarget(Trig_Damage_Engine_BlockEffectPath(l_physical),t,"origin"))
        call Text_FloatingDamage(t,false,5,.0,false,0)
    endif
    // DPS meter for players.
    if(IsPlayerInForce(up,udg_PlayingPlayers)and l_amount>.0 and l_amount<1000000.)then
        call ConditionalTriggerExecute(gg_trg_Dps_Start)
        // Calculation 1:
        // (GetPlayerId(up)) plus (1).
        // Calculation 2:
        // (LoadReal(udg_DpsHash, (GetPlayerId(up)) plus (1), LoadInteger(udg_DpsHash, 0, 0))) plus (amount).
        call SaveReal(udg_DpsHash,GetPlayerId(up)+1,LoadInteger(udg_DpsHash,0,0),LoadReal(udg_DpsHash,GetPlayerId(up)+1,LoadInteger(udg_DpsHash,0,0))+l_amount)
        if(udg_SplashTally>=.0)then
            // (udg_SplashTally) plus (amount).
            set udg_SplashTally=udg_SplashTally+l_amount
        endif
        if(udg_DamageTally[GetPlayerId(up)]>=1. and u==Player_GetHero(up))then
            // (udg_DamageTally at position GetPlayerId(up)) plus (amount).
            set udg_DamageTally[GetPlayerId(up)]=udg_DamageTally[GetPlayerId(up)]+l_amount
        endif
        if(l_melee and l_amount>=10000. and GetUnitAbilityLevel(u,'A087')>0 and GetUnitTypeId(Player_GetHero(up))=='H009' and GetUnitAbilityLevel(Player_GetHero(up),'A02F')==3 and not IsPlayerInForce(up,udg_JobMasterForce[$D]))then // 'A087': ability "Solid Skin"; 'H009': unit "Summoner"; 'A02F': ability "Mastery"; $D = 13
            if(u==udg_Eidolon1)then
                call ForceAddPlayer(udg_EidolonAwardForce[0],up)
            elseif(u==udg_Eidolon2)then
                call ForceAddPlayer(udg_EidolonAwardForce[1],up)
            elseif(u==udg_Eidolon3)then
                call ForceAddPlayer(udg_EidolonAwardForce[2],up)
            endif
            if(IsPlayerInForce(up,udg_EidolonAwardForce[0])and IsPlayerInForce(up,udg_EidolonAwardForce[1])and IsPlayerInForce(up,udg_EidolonAwardForce[2]))then
                call ForceAddPlayer(udg_JobMasterForce[$D],up) // $D = 13
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",Player_GetHero(up),"origin"))
            endif
        endif
    endif
    // Floating damage text.
    if(l_amount>=1.)then
        if(l_amount>=1000000.)then
            call Text_FloatingDamage(t,false,6,.0,false,l_fxCode)
        else
            call Text_FloatingDamage(t,false,0,l_amount,false,l_fxCode)
        endif
    endif
    // Illusions deal no damage.
    if IsUnitIllusion(u)then
        set l_amount=.0
    endif
    set u=null
    set t=null
    set l_dummy=null
    set up=null
    set tp=null
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Source[c]=u
    set DmgCtx_Target[c]=t
    set DmgCtx_SourcePlayer[c]=up
    set DmgCtx_TargetPlayer[c]=tp
    set DmgCtx_Dummy[c]=l_dummy
    set u=null
    set t=null
    set l_dummy=null
endfunction

// ==========================================================================================
// Trig_Damage_Engine_CalcDamage - the combat formula used by the damage engine for attacks,
// spells and heals. It runs the steps below in order; each step is a function above
// (Trig_Damage_Engine_StepNN_*) that changes the hit's values (amount, block code, ...).
//   l_amount     base damage or healing           u / t : source / target unit
//   l_dmgKind    1 melee, 2 ranged, 4 pure (skips most modifiers), anything else = magic
//   l_element    element id (0 = use the attacker's element)
//   DmgCtx_BlockCode  -1 cannot miss or be blocked, 0 normal, 1 evaded, 2 blocked, 3 nullified
//   DmgCtx_FxCode     1 cleave effect, 2 critical-hit effect
// A hit can cause another hit while it is being calculated, so every call gets its own slot
// c in the DmgCtx_* arrays. To add a modifier, put it in the step where it belongs, or add a
// new step function and call it here.
// ==========================================================================================
function Trig_Damage_Engine_CalcDamage takes real l_amount,unit u,unit t,boolean l_unavoidable,integer l_dmgKind,boolean l_noCrit,integer l_element,boolean l_manaDamage,boolean l_holy,boolean l_heal,boolean l_noRedirect,boolean l_healUndead returns real
    local integer c
    local real result
    if DmgCtx_Depth>=8000 then
        // safety: a crashed call never released its slot; start over instead of running past the arrays
        set DmgCtx_Depth=0
    endif
    set DmgCtx_Depth=DmgCtx_Depth+1
    set c=DmgCtx_Depth
    set DmgCtx_Amount[c]=l_amount
    set DmgCtx_Source[c]=u
    set DmgCtx_Target[c]=t
    set DmgCtx_Unavoidable[c]=l_unavoidable
    set DmgCtx_Kind[c]=l_dmgKind
    set DmgCtx_NoCrit[c]=l_noCrit
    set DmgCtx_Element[c]=l_element
    set DmgCtx_ManaDamage[c]=l_manaDamage
    set DmgCtx_Holy[c]=l_holy
    set DmgCtx_Heal[c]=l_heal
    set DmgCtx_NoRedirect[c]=l_noRedirect
    set DmgCtx_HealUndead[c]=l_healUndead
    set DmgCtx_Pure[c]=(DmgCtx_Kind[c]==4)
    set DmgCtx_Melee[c]=(DmgCtx_Kind[c]==1)
    set DmgCtx_Ranged[c]=(DmgCtx_Kind[c]==2)
    set DmgCtx_Physical[c]=DmgCtx_Melee[c] or DmgCtx_Ranged[c]
    set DmgCtx_Magical[c]=(not DmgCtx_Physical[c])and(not DmgCtx_Pure[c])
    set DmgCtx_Akashic[c]=(DmgCtx_Magical[c] and not DmgCtx_Heal[c] and GetUnitAbilityLevel(DmgCtx_Source[c],'A041')>0) // 'A041': ability "Akashic"
    set DmgCtx_IgnoreDefense[c]=false
    set DmgCtx_FxCode[c]=0
    set DmgCtx_BlockCode[c]=0
    set DmgCtx_SourceX[c]=GetUnitX(DmgCtx_Source[c])
    set DmgCtx_SourceY[c]=GetUnitY(DmgCtx_Source[c])
    set DmgCtx_TargetX[c]=GetUnitX(DmgCtx_Target[c])
    set DmgCtx_TargetY[c]=GetUnitY(DmgCtx_Target[c])
    set DmgCtx_SourceHandle[c]=GetHandleId(DmgCtx_Source[c])
    set DmgCtx_TargetHandle[c]=GetHandleId(DmgCtx_Target[c])
    set DmgCtx_SourcePlayer[c]=GetOwningPlayer(DmgCtx_Source[c])
    set DmgCtx_TargetPlayer[c]=GetOwningPlayer(DmgCtx_Target[c])
    set DmgCtx_ArmorMult[c]=BlzGetUnitArmor(DmgCtx_Target[c])
    set DmgCtx_DefenseScale[c]=1.
    set DmgCtx_Resist[c]=3
    call Trig_Damage_Engine_Step01_Setup(c)
    call Trig_Damage_Engine_Step02_HealingUndead(c)
    call Trig_Damage_Engine_Step03_FullProtection(c)
    if Trig_Damage_Engine_Step04_Cover(c) then
        call Trig_Damage_Engine_FreeContext(c)
        return .0
    endif
    call Trig_Damage_Engine_Step05_Immunities(c)
    call Trig_Damage_Engine_Step06_Defense(c)
    call Trig_Damage_Engine_Step07_MeleeBonuses(c)
    call Trig_Damage_Engine_Step08_Elements(c)
    call Trig_Damage_Engine_Step09_Accuracy(c)
    call Trig_Damage_Engine_Step10_EvasionAndBlocking(c)
    call Trig_Damage_Engine_Step11_ElementBonus(c)
    call Trig_Damage_Engine_Step12_PhysicalSkills(c)
    call Trig_Damage_Engine_Step13_MarkedForDeath(c)
    call Trig_Damage_Engine_Step14_Difficulty(c)
    call Trig_Damage_Engine_Step15_RandomSpread(c)
    call Trig_Damage_Engine_Step16_PhysicalHit(c)
    call Trig_Damage_Engine_Step17_Magic(c)
    call Trig_Damage_Engine_Step18_FinalModifiers(c)
    call Trig_Damage_Engine_Step19_Apply(c)
    set result=DmgCtx_Amount[c]
    call Trig_Damage_Engine_FreeContext(c)
    return result
endfunction

function Trig_Damage_Init_RegisterDamageUnit takes nothing returns nothing
    call TriggerRegisterUnitEvent(gg_trg_Damage_Engine,GetEnumUnit(),EVENT_UNIT_DAMAGED)
    call UnitAddAbilityBJ('A0PB',GetEnumUnit()) // 'A0PB': ability "Physical Damage Detection"
endfunction

function Trig_Damage_Init_Actions takes nothing returns nothing
    call InitHashtableBJ()
    set udg_ComboHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_ProxyDamageHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_DpsHash=GetLastCreatedHashtableBJ()
    call SaveIntegerBJ(1,2,0,udg_DpsHash)
    call SaveIntegerBJ($F,3,0,udg_DpsHash) // $F = 15
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=28
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempGroup=Group_AllUnitsOfPlayer(ConvertedPlayer(GetForLoopIndexA()))
        call ForGroupBJ(udg_TempGroup,function Trig_Damage_Init_RegisterDamageUnit)
        call DestroyGroup(udg_TempGroup)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call EnableTrigger(gg_trg_Damage_RegisterEnter)
    call EnableTrigger(gg_trg_Damage_RegisterAttacked)
    call EnableTrigger(gg_trg_Damage_Engine)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Damage_RegisterEnter_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0PB',GetTriggerUnit())<=0) // 'A0PB': ability "Physical Damage Detection"
endfunction

function Trig_Damage_RegisterEnter_Actions takes nothing returns nothing
    call TriggerRegisterUnitEvent(gg_trg_Damage_Engine,GetTriggerUnit(),EVENT_UNIT_DAMAGED)
    call UnitAddAbilityBJ('A0PB',GetTriggerUnit()) // 'A0PB': ability "Physical Damage Detection"
endfunction

function Trig_Damage_RegisterAttacked_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0PB',GetTriggerUnit())<=0) // 'A0PB': ability "Physical Damage Detection"
endfunction

function Trig_Damage_RegisterAttacked_Actions takes nothing returns nothing
    call TriggerRegisterUnitEvent(gg_trg_Damage_Engine,GetTriggerUnit(),EVENT_UNIT_DAMAGED)
    call UnitAddAbilityBJ('A0PB',GetTriggerUnit()) // 'A0PB': ability "Physical Damage Detection"
endfunction

function Trig_Damage_Engine_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit())!='o007' // 'o007': unit "Regenerator"
endfunction

function Trig_Damage_Engine_Actions takes nothing returns nothing
    local unit u=GetEventDamageSource()
    local unit triggeringUnit=GetTriggerUnit()
    local real l_amount=GetEventDamage()
    local integer l_dmgKind=0
    if(GetUnitAbilityLevel(triggeringUnit,'B04S')>0)or(GetUnitAbilityLevel(triggeringUnit,'B04R')>0)then // 'B04S': buff tooltip "Physical Damage"; 'B04R': buff tooltip "Physical Damage"
        set l_dmgKind=1
        call UnitRemoveAbility(triggeringUnit,'B04S') // 'B04S': buff tooltip "Physical Damage"
        call UnitRemoveAbility(triggeringUnit,'B04R') // 'B04R': buff tooltip "Physical Damage"
    endif
    if(GetUnitTypeId(u)=='h01B')then // 'h01B': unit "Proxy Dummy"
        if(l_amount>.0)then
            call Trig_Damage_Engine_NotifyDamageSource()
            call BlzSetEventDamage(.0)
            set udg_ProxyDamageTarget=triggeringUnit
            call Trig_Damage_Engine_ProxyDamageApply(GetHandleId(u),triggeringUnit,l_amount)
        endif
    elseif udg_DmgArmorProbe then
        set udg_DmgArmorProbe=false
        set udg_DmgArmorProbeResult=l_amount
        call BlzSetEventDamage(.0)
    else
        if(l_dmgKind==0)then
            if udg_DmgFlagPure then
                set l_dmgKind=4
            elseif udg_IsPhysicalAttack then
                if udg_DmgFlagMelee then
                    set l_dmgKind=1
                else
                    set l_dmgKind=2
                endif
            else
                set l_dmgKind=3
            endif
        endif
        set l_amount=Trig_Damage_Engine_CalcDamage(l_amount,u,triggeringUnit,(udg_DmgFlagUnavoidable<0),l_dmgKind,(udg_DmgFlagNoCrit<.0),udg_DamageElement,udg_DmgFlagManaDamage,udg_IgnoresReduction,udg_IsPureDamage,udg_DmgFlagRedirected,udg_DmgFlagHealUndead)
        call BlzSetEventDamage(l_amount)
        call UnitRemoveAbility(u,'B04O') // 'B04O': buff tooltip "Recovering"
        call UnitRemoveAbility(triggeringUnit,'B04O') // 'B04O': buff tooltip "Recovering"
        call Trig_Damage_Engine_PostDamageEffects()
    endif
    set u=null
    set triggeringUnit=null
endfunction

function Trig_Damage_ProxyCleanup_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='h01B') // 'h01B': unit "Proxy Dummy"
endfunction

function Trig_Damage_ProxyCleanup_Actions takes nothing returns nothing
    call FlushChildHashtableBJ(GetHandleIdBJ(GetTriggerUnit()),udg_ProxyDamageHash)
endfunction

function Trig_Damage_Splash_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetEnumUnit(),GetOwningPlayer(udg_SplashSource)))and(GetUnitTypeId(GetEnumUnit())!='u014') // 'u014': unit "Galbalan Orb"
endfunction

function Trig_Damage_Splash_SplashEnum takes nothing returns nothing
    if(Trig_Damage_Splash_FilterEnemy())then
        set udg_IsPhysicalAttack=true
        set udg_DmgFlagMelee=true
        set udg_DmgFlagNoCrit=-1.
        call UnitDamageTarget(udg_SplashSource,GetEnumUnit(),udg_SplashDamage,true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL,null)
    endif
endfunction

function Trig_Damage_Splash_Actions takes nothing returns nothing
    call ForGroupBJ(udg_SplashGroup,function Trig_Damage_Splash_SplashEnum)
    call DestroyGroup(udg_SplashGroup)
endfunction

// World Editor calls InitTrig_Damage automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Damage (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Damage takes nothing returns nothing
endfunction

function Register_Damage_Init takes nothing returns nothing
    set gg_trg_Damage_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Damage_Init,8.18)
    call TriggerAddAction(gg_trg_Damage_Init,function Trig_Damage_Init_Actions)
endfunction

function Register_Damage_RegisterEnter takes nothing returns nothing
    set gg_trg_Damage_RegisterEnter=CreateTrigger()
    call DisableTrigger(gg_trg_Damage_RegisterEnter)
    call TriggerRegisterEnterRectSimple(gg_trg_Damage_RegisterEnter,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_Damage_RegisterEnter,Condition(function Trig_Damage_RegisterEnter_Conditions))
    call TriggerAddAction(gg_trg_Damage_RegisterEnter,function Trig_Damage_RegisterEnter_Actions)
endfunction

function Register_Damage_RegisterAttacked takes nothing returns nothing
    set gg_trg_Damage_RegisterAttacked=CreateTrigger()
    call DisableTrigger(gg_trg_Damage_RegisterAttacked)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Damage_RegisterAttacked,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Damage_RegisterAttacked,Condition(function Trig_Damage_RegisterAttacked_Conditions))
    call TriggerAddAction(gg_trg_Damage_RegisterAttacked,function Trig_Damage_RegisterAttacked_Actions)
endfunction

function Register_Damage_Engine takes nothing returns nothing
    set gg_trg_Damage_Engine=CreateTrigger()
    call DisableTrigger(gg_trg_Damage_Engine)
    call TriggerAddCondition(gg_trg_Damage_Engine,Condition(function Trig_Damage_Engine_Conditions))
    call TriggerAddAction(gg_trg_Damage_Engine,function Trig_Damage_Engine_Actions)
endfunction

function Register_Damage_ProxyCleanup takes nothing returns nothing
    set gg_trg_Damage_ProxyCleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Damage_ProxyCleanup,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Damage_ProxyCleanup,Condition(function Trig_Damage_ProxyCleanup_Conditions))
    call TriggerAddAction(gg_trg_Damage_ProxyCleanup,function Trig_Damage_ProxyCleanup_Actions)
endfunction

function Register_Damage_Splash takes nothing returns nothing
    set gg_trg_Damage_Splash=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Damage_Splash,udg_SplashTimer)
    call TriggerAddAction(gg_trg_Damage_Splash,function Trig_Damage_Splash_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Damage takes nothing returns nothing
    call Register_Damage_Init()
    call Register_Damage_RegisterEnter() // starts off; enabled by Damage
    call Register_Damage_RegisterAttacked() // starts off; enabled by Damage
    call Register_Damage_Engine() // starts off; enabled by Damage
    call Register_Damage_ProxyCleanup()
    call Register_Damage_Splash()
endfunction

endlibrary

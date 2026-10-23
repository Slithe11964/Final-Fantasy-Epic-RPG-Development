globals
    hashtable CutsData=InitHashtable()
    timer CutsTimer=null
    real CutsNow=0.
    boolean CutsTimerRunning=false
    unit array CutsCaster
    unit array CutsTarget
    boolean array CutsActive
    boolean array CutsRipping
    boolean array CutsRestore
    integer array CutsFirst
    integer array CutsLast
    integer array CutsCount
    integer array CutsRank
    real array CutsRipUntil
    real array CutsRipDamage
    texttag array CutsCounter
endglobals

function Cuts_BaseTotal takes integer rank returns real
    if rank>=6 then
        return 6000.
    endif
    return 2500.+500.*I2R(IMaxBJ(1,rank))
endfunction

function Cuts_Damage takes unit caster,integer count returns real
    return I2R(count)/40.*(Cuts_BaseTotal(GetUnitAbilityLevel(caster,'A0KY'))+16.*I2R(GetHeroAgi(caster,true)))*(1.+.1*I2R(Prof_GetLevel(caster,'R00B')))
endfunction

function Cuts_Label takes integer pid returns nothing
    if CutsCounter[pid]!=null then
        call SetTextTagText(CutsCounter[pid],"Daggers: "+I2S(CutsCount[pid]),.019)
        call SetTextTagPosUnit(CutsCounter[pid],CutsTarget[pid],145.+12.*I2R(pid))
    endif
endfunction

function Cuts_Clear takes integer pid returns nothing
    local integer i=CutsFirst[pid]
    local effect blade
    loop
        exitwhen i>CutsLast[pid]
        set blade=LoadEffectHandle(CutsData,16+pid,i)
        if blade!=null then
            call DestroyEffect(blade)
        endif
        set i=i+1
    endloop
    call FlushChildHashtable(CutsData,pid)
    call FlushChildHashtable(CutsData,16+pid)
    if CutsCounter[pid]!=null then
        call DestroyTextTag(CutsCounter[pid])
        set CutsCounter[pid]=null
    endif
    set CutsTarget[pid]=null
    set CutsFirst[pid]=1
    set CutsLast[pid]=0
    set CutsCount[pid]=0
    set CutsRipping[pid]=false
    set blade=null
endfunction

function Cuts_Position takes integer pid returns nothing
    local integer i=CutsFirst[pid]
    local real angle
    local real x
    local real y
    local real z
    local real fraction=0.
    local effect blade
    if CutsTarget[pid]==null then
        return
    endif
    if CutsRipping[pid] then
        set fraction=RMinBJ(1.,1.-(CutsRipUntil[pid]-CutsNow)/.25)
    endif
    loop
        exitwhen i>CutsLast[pid]
        set blade=LoadEffectHandle(CutsData,16+pid,i)
        set angle=2.35+I2R(ModuloInteger(i-1,40))*.17
        set x=GetUnitX(CutsTarget[pid])+58.*Cos(angle)
        set y=GetUnitY(CutsTarget[pid])+58.*Sin(angle)
        set z=GetUnitFlyHeight(CutsTarget[pid])+40.+I2R(ModuloInteger(i,6))*18.
        call BlzSetSpecialEffectPosition(blade,x+(GetUnitX(CutsCaster[pid])-x)*fraction,y+(GetUnitY(CutsCaster[pid])-y)*fraction,z+(75.-z)*fraction)
        call BlzSetSpecialEffectYaw(blade,angle+bj_PI)
        set i=i+1
    endloop
    call Cuts_Label(pid)
    set blade=null
endfunction

function Cuts_Expire takes integer pid returns nothing
    local integer i=CutsFirst[pid]
    local boolean changed=false
    loop
        exitwhen i>CutsLast[pid]
        exitwhen LoadReal(CutsData,pid,i)>CutsNow
        call DestroyEffect(LoadEffectHandle(CutsData,16+pid,i))
        call RemoveSavedHandle(CutsData,16+pid,i)
        call RemoveSavedReal(CutsData,pid,i)
        set CutsCount[pid]=CutsCount[pid]-1
        set changed=true
        set i=i+1
    endloop
    set CutsFirst[pid]=i
    if changed then
        call Cuts_Label(pid)
    endif
endfunction

// Called by the existing damage engine only after a successful basic attack.
function Cuts_OnHit takes unit caster,unit target returns nothing
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local integer serial
    local effect blade
    if pid>=8 or not CutsActive[pid] or CutsCaster[pid]!=caster or caster!=Player_GetHero(GetOwningPlayer(caster)) or IsUnitIllusion(caster) or not IsUnitEnemy(target,GetOwningPlayer(caster)) or IsUnitType(target,UNIT_TYPE_STRUCTURE) or GetWidgetLife(target)<=.405 then
        return
    endif
    if CutsTarget[pid]!=null and CutsTarget[pid]!=target then
        return
    endif
    set CutsNow=TimerGetElapsed(NativeCDClock)
    call Cuts_Expire(pid)
    if CutsTarget[pid]==null then
        set CutsTarget[pid]=target
        set CutsCounter[pid]=CreateTextTag()
        call SetTextTagPermanent(CutsCounter[pid],true)
        call SetTextTagColor(CutsCounter[pid],255,160,140,255)
    endif
    set CutsLast[pid]=CutsLast[pid]+1
    set serial=CutsLast[pid]
    set CutsCount[pid]=CutsCount[pid]+1
    call SaveReal(CutsData,pid,serial,CutsNow+30.)
    set blade=AddSpecialEffect("ThiefDaggers\\BloodiedBlade-StillSilent.mdx",GetUnitX(target),GetUnitY(target))
    call BlzSetSpecialEffectColor(blade,235,85,85)
    call BlzSetSpecialEffectScale(blade,.42)
    call BlzSetSpecialEffectTime(blade,0.)
    call BlzSetSpecialEffectTimeScale(blade,0.)
    call SaveEffectHandle(CutsData,16+pid,serial,blade)
    call Cuts_Position(pid)
    set blade=null
endfunction

function Cuts_FinishRip takes integer pid returns nothing
    local unit caster=CutsCaster[pid]
    local unit target=CutsTarget[pid]
    local real damage=CutsRipDamage[pid]
    local sound rip
    // Clear first: rip damage must never add another dagger or hit twice.
    call Cuts_Clear(pid)
    if GetWidgetLife(caster)>.405 and GetWidgetLife(target)>.405 and IsUnitEnemy(target,GetOwningPlayer(caster)) and not BlzIsUnitInvulnerable(target) then
        set rip=CreateSoundFromLabel("MetalHeavySliceFlesh",false,true,true,10,10)
        call SetSoundVolume(rip,127)
        call SetSoundPosition(rip,GetUnitX(target),GetUnitY(target),75.)
        call StartSound(rip)
        call KillSoundWhenDone(rip)
        call DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl",target,"chest"))
        set udg_IsPhysicalAttack=true
        set udg_DmgFlagMelee=false
        set udg_DamageElement=0
        call UnitDamageTarget(caster,target,damage,true,true,ATTACK_TYPE_PIERCE,DAMAGE_TYPE_NORMAL,null)
    endif
    set CutsCaster[pid]=null
    set caster=null
    set target=null
    set rip=null
endfunction

function Cuts_Tick takes nothing returns nothing
    local integer pid=0
    local unit caster
    local ability entry
    local integer rank
    local boolean running=false
    set CutsNow=TimerGetElapsed(NativeCDClock)
    loop
        exitwhen pid>=8
        set caster=CutsCaster[pid]
        if caster!=null then
            if GetUnitTypeId(caster)==0 or caster!=Player_GetHero(GetOwningPlayer(caster)) or GetUnitAbilityLevel(caster,'A0KY')==0 then
                call Cuts_Clear(pid)
                set CutsActive[pid]=false
                set CutsRestore[pid]=false
                set CutsCaster[pid]=null
            else
                set rank=GetUnitAbilityLevel(caster,'A0KY')-1
                if CutsRestore[pid] or CutsRank[pid]!=rank then
                    set entry=BlzGetUnitAbility(caster,'A0KY')
                    if CutsActive[pid] then
                        call BlzSetAbilityIntegerLevelField(entry,ABILITY_ILF_MANA_COST,rank,0)
                    else
                        call BlzSetAbilityIntegerLevelField(entry,ABILITY_ILF_MANA_COST,rank,BlzGetAbilityManaCost('A0KY',rank))
                    endif
                    set CutsRestore[pid]=false
                    set CutsRank[pid]=rank
                endif
                if GetWidgetLife(caster)<=.405 or (CutsTarget[pid]!=null and GetWidgetLife(CutsTarget[pid])<=.405) then
                    if CutsActive[pid] then
                        call NativeCD_Queue(caster,'A0KY',SharedItemCD_Duration(caster,'A0KY'),false)
                    endif
                    call Cuts_Clear(pid)
                    set CutsActive[pid]=false
                    set CutsRestore[pid]=false
                    set entry=BlzGetUnitAbility(caster,'A0KY')
                    call BlzSetAbilityIntegerLevelField(entry,ABILITY_ILF_MANA_COST,rank,BlzGetAbilityManaCost('A0KY',rank))
                    set CutsCaster[pid]=null
                elseif CutsRipping[pid] then
                    call Cuts_Position(pid)
                    if CutsNow+.00001>=CutsRipUntil[pid] then
                        call Cuts_FinishRip(pid)
                    endif
                elseif CutsActive[pid] then
                    call Cuts_Expire(pid)
                    call Cuts_Position(pid)
                endif
                if not CutsActive[pid] and not CutsRipping[pid] and not CutsRestore[pid] then
                    set CutsCaster[pid]=null
                else
                    set running=true
                endif
            endif
        endif
        set pid=pid+1
    endloop
    if not running then
        call PauseTimer(CutsTimer)
        set CutsTimerRunning=false
    endif
    set caster=null
    set entry=null
endfunction

function Cuts_Cast takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local integer rank=GetUnitAbilityLevel(caster,'A0KY')-1
    local ability entry
    local real cooldown=0.
    if GetSpellAbilityId()!='A0KY' or pid>=8 or rank<0 or caster!=Player_GetHero(GetOwningPlayer(caster)) then
        set caster=null
        return
    endif
    set entry=BlzGetUnitAbility(caster,'A0KY')
    set CutsNow=TimerGetElapsed(NativeCDClock)
    if GetTriggerEventId()!=EVENT_PLAYER_UNIT_SPELL_EFFECT then
        if CutsActive[pid] and CutsCaster[pid]==caster then
            set cooldown=SharedItemCD_Duration(caster,'A0KY')
            call BlzSetAbilityIntegerLevelField(entry,ABILITY_ILF_MANA_COST,rank,0)
        else
            call BlzSetAbilityIntegerLevelField(entry,ABILITY_ILF_MANA_COST,rank,BlzGetAbilityManaCost('A0KY',rank))
        endif
        call BlzSetAbilityRealLevelField(entry,ABILITY_RLF_COOLDOWN,rank,cooldown)
        call BlzSetUnitAbilityCooldown(caster,'A0KY',rank,cooldown)
    else
        if CutsActive[pid] and CutsCaster[pid]==caster then
            call Cuts_Expire(pid)
            set CutsActive[pid]=false
            set cooldown=SharedItemCD_Duration(caster,'A0KY')
            call NativeCD_Queue(caster,'A0KY',cooldown,false)
            if CutsCount[pid]>0 then
                set CutsRipping[pid]=true
                set CutsRipUntil[pid]=CutsNow+.25
                set CutsRipDamage[pid]=Cuts_Damage(caster,CutsCount[pid])
            else
                call Cuts_Clear(pid)
            endif
        elseif not CutsRipping[pid] then
            call Cuts_Clear(pid)
            set CutsCaster[pid]=caster
            set CutsActive[pid]=true
            call UnitRemoveAbility(caster,'B04D')
            call UnitRemoveAbility(caster,'BEia')
            call NativeCD_Queue(caster,'A0KY',0.,false)
        endif
        set CutsRestore[pid]=true
        if not CutsTimerRunning then
            set CutsTimerRunning=true
            call TimerStart(CutsTimer,.05,true,function Cuts_Tick)
        endif
    endif
    set caster=null
    set entry=null
endfunction

function Cuts_Init takes nothing returns nothing
    local trigger cast=CreateTrigger()
    set CutsTimer=CreateTimer()
    call TriggerRegisterAnyUnitEventBJ(cast,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerRegisterAnyUnitEventBJ(cast,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerRegisterAnyUnitEventBJ(cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(cast,function Cuts_Cast)
    set cast=null
endfunction

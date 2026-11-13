globals
    unit DagThief=null
    unit DagScarecrow=null
    timer DagTimer=null
    trigger DagSpells=null
    trigger DagAttacks=null
    texttag DagCounter=null
    effect array DagBlade
    real array DagX
    real array DagY
    integer array DagExpires
    real array DagZ
    integer DagStacks=0
    integer DagStyle=3
    integer DagTicks=0
    integer DagRipTicks=0
    real DagRipDamage=0.
    boolean DagActive=false
    boolean DagRipping=false
endglobals

function Dag_StyleName takes nothing returns string
    if DagStyle==2 then
        return "Spectral orbit"
    elseif DagStyle==3 then
        return "Bloodied blade fan"
    endif
    return "Embedded blades"
endfunction

function Dag_Damage takes integer stacks returns real
    return I2R(stacks)*(50.+2.*I2R(GetHeroAgi(DagThief,true)))
endfunction

function Dag_UpdateCounter takes nothing returns nothing
    call SetTextTagText(DagCounter,"Daggers: "+I2S(DagStacks)+" | Rip: "+I2S(R2I(Dag_Damage(DagStacks))),.019)
    call SetTextTagPosUnit(DagCounter,DagScarecrow,160.)
endfunction

function Dag_ClearBlades takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>DagStacks
        if DagBlade[i]!=null then
            call DestroyEffect(DagBlade[i])
            set DagBlade[i]=null
        endif
        set i=i+1
    endloop
endfunction

function Dag_SpawnBlade takes integer i returns nothing
    local string model="Abilities\\Weapons\\WardenMissile\\WardenMissile.mdl"
    if DagStyle==3 then
        set model="ThiefDaggers\\BloodiedBlade-StillSilent.mdx"
    endif
    set DagBlade[i]=AddSpecialEffect(model,GetUnitX(DagScarecrow),GetUnitY(DagScarecrow))
    call BlzSetSpecialEffectScale(DagBlade[i],.65)
    if DagStyle==2 then
        call BlzSetSpecialEffectColor(DagBlade[i],90,185,255)
        call BlzSetSpecialEffectAlpha(DagBlade[i],210)
    elseif DagStyle==3 then
        call BlzSetSpecialEffectColor(DagBlade[i],235,85,85)
        call BlzSetSpecialEffectScale(DagBlade[i],.42)
        call BlzSetSpecialEffectTime(DagBlade[i],0.)
        call BlzSetSpecialEffectTimeScale(DagBlade[i],0.)
    endif
endfunction

function Dag_PositionBlades takes nothing returns nothing
    local integer i=1
    local real angle
    local real radius
    local real z
    local real cx=GetUnitX(DagScarecrow)
    local real cy=GetUnitY(DagScarecrow)
    loop
        exitwhen i>DagStacks
        set angle=I2R(i-1)*2.399963
        set radius=46.+I2R(ModuloInteger(i,3))*7.
        set z=55.+I2R(ModuloInteger(i,5))*16.
        if DagStyle==2 then
            set angle=angle+I2R(DagTicks)*.045
            set radius=95.+I2R(ModuloInteger(i,2))*22.
            set z=65.+I2R(ModuloInteger(i,4))*18.
        elseif DagStyle==3 then
            set angle=2.35+I2R(i-1)*.17
            set radius=58.
            set z=40.+I2R(ModuloInteger(i,6))*18.
        endif
        set DagX[i]=cx+radius*Cos(angle)
        set DagY[i]=cy+radius*Sin(angle)
        set DagZ[i]=z
        call BlzSetSpecialEffectX(DagBlade[i],DagX[i])
        call BlzSetSpecialEffectY(DagBlade[i],DagY[i])
        call BlzSetSpecialEffectZ(DagBlade[i],DagZ[i])
        call BlzSetSpecialEffectYaw(DagBlade[i],angle+bj_PI)
        set i=i+1
    endloop
endfunction

function Dag_ShowStart takes nothing returns nothing
    call BlzUnitHideAbility(DagThief,'pDgR',true)
    call BlzUnitHideAbility(DagThief,'pDgA',false)
endfunction

function Dag_Abort takes nothing returns nothing
    set DagActive=false
    set DagRipping=false
    call Dag_ClearBlades()
    set DagStacks=0
    set DagRipTicks=0
    call Dag_ShowStart()
    call Dag_UpdateCounter()
endfunction

function Dag_FloatDamage takes real amount returns nothing
    local texttag tag=CreateTextTag()
    call SetTextTagText(tag,"Rip: "+I2S(R2I(amount)),.027)
    call SetTextTagColor(tag,255,210,110,255)
    call SetTextTagPosUnit(tag,DagScarecrow,115.)
    call SetTextTagVelocity(tag,0.,.045)
    call SetTextTagPermanent(tag,false)
    call SetTextTagLifespan(tag,2.)
    call SetTextTagFadepoint(tag,1.2)
    set tag=null
endfunction

function Dag_PlayRipSound takes nothing returns nothing
    local sound rip=CreateSoundFromLabel("MetalHeavySliceFlesh",false,true,true,10,10)
    call SetSoundVolume(rip,127)
    call SetSoundPosition(rip,GetUnitX(DagScarecrow),GetUnitY(DagScarecrow),75.)
    call StartSound(rip)
    call KillSoundWhenDone(rip)
    set rip=null
endfunction

function Dag_FinishRip takes nothing returns nothing
    local real damage=DagRipDamage
    local real before=GetWidgetLife(DagScarecrow)
    call Dag_ClearBlades()
    set DagStacks=0
    set DagRipping=false
    if GetWidgetLife(DagScarecrow)>.405 and GetWidgetLife(DagThief)>.405 then
        call DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl",DagScarecrow,"chest"))
        call Dag_PlayRipSound()
        call UnitDamageTarget(DagThief,DagScarecrow,damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
        call Dag_FloatDamage(before-GetWidgetLife(DagScarecrow))
    endif
    call Dag_UpdateCounter()
endfunction

function Dag_Plant takes nothing returns nothing
    set DagStacks=DagStacks+1
    set DagExpires[DagStacks]=DagTicks+1000
    call Dag_SpawnBlade(DagStacks)
    call Dag_PositionBlades()
    call Dag_UpdateCounter()
endfunction

function Dag_Expire takes nothing returns nothing
    local integer expired=0
    local integer i=1
    loop
        exitwhen i>DagStacks
        exitwhen DagExpires[i]>DagTicks
        call DestroyEffect(DagBlade[i])
        set DagBlade[i]=null
        set expired=expired+1
        set i=i+1
    endloop
    if expired==0 then
        return
    endif
    loop
        exitwhen i>DagStacks
        set DagBlade[i-expired]=DagBlade[i]
        set DagExpires[i-expired]=DagExpires[i]
        set DagBlade[i]=null
        set i=i+1
    endloop
    set DagStacks=DagStacks-expired
    call Dag_UpdateCounter()
endfunction

function Dag_OnAttackDamage takes nothing returns nothing
    if DagActive and not DagRipping and GetEventDamageSource()==DagThief and GetTriggerUnit()==DagScarecrow and BlzGetEventIsAttack() and GetEventDamage()>0. then
        call Dag_Plant()
    endif
endfunction

function Dag_Tick takes nothing returns nothing
    local integer i=1
    local real fraction
    local real x
    local real y
    if DagActive then
        if GetWidgetLife(DagThief)<=.405 or GetWidgetLife(DagScarecrow)<=.405 then
            call Dag_Abort()
            return
        endif
        set DagTicks=DagTicks+1
        call Dag_Expire()
        call Dag_PositionBlades()
    elseif DagRipping then
        set DagRipTicks=DagRipTicks+1
        set fraction=I2R(DagRipTicks)/8.
        set x=GetUnitX(DagThief)
        set y=GetUnitY(DagThief)
        loop
            exitwhen i>DagStacks
            call BlzSetSpecialEffectX(DagBlade[i],DagX[i]+(x-DagX[i])*fraction)
            call BlzSetSpecialEffectY(DagBlade[i],DagY[i]+(y-DagY[i])*fraction)
            call BlzSetSpecialEffectZ(DagBlade[i],DagZ[i]+(75.-DagZ[i])*fraction)
            set i=i+1
        endloop
        if DagRipTicks>=8 then
            call Dag_FinishRip()
        endif
    endif
endfunction

function Dag_Begin takes unit target returns nothing
    if DagActive or DagRipping or target!=DagScarecrow or GetWidgetLife(target)<=.405 then
        return
    endif
    set DagActive=true
    set DagTicks=0
    set DagStacks=0
    call Dag_UpdateCounter()
endfunction

function Dag_Rip takes nothing returns nothing
    if not DagActive or DagStacks<=0 then
        return
    endif
    set DagActive=false
    set DagRipping=true
    set DagRipTicks=0
    set DagRipDamage=Dag_Damage(DagStacks)
    call SetUnitAnimation(DagThief,"spell")
    call Dag_ShowStart()
    call BlzStartUnitAbilityCooldown(DagThief,'pDgA',2.)
endfunction

function Dag_ChangeStyle takes integer style returns nothing
    local integer i=1
    if DagRipping then
        return
    endif
    set DagStyle=style
    call Dag_ClearBlades()
    loop
        exitwhen i>DagStacks
        call Dag_SpawnBlade(i)
        set i=i+1
    endloop
    call Dag_PositionBlades()
    call DisplayTimedTextToPlayer(Player(0),0.,0.,5.,"Visual style: "+Dag_StyleName())
endfunction

function Dag_CreateScarecrow takes nothing returns nothing
    set DagScarecrow=CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE),'u01M',96.,0.,180.)
    call SetUnitAcquireRange(DagScarecrow,0.)
    call TriggerRegisterUnitEvent(DagAttacks,DagScarecrow,EVENT_UNIT_DAMAGED)
    call SetUnitState(DagScarecrow,UNIT_STATE_LIFE,100000.)
endfunction

function Dag_Reset takes nothing returns nothing
    call Dag_Abort()
    if GetWidgetLife(DagScarecrow)<=.405 then
        call RemoveUnit(DagScarecrow)
        call Dag_CreateScarecrow()
    else
        call SetUnitState(DagScarecrow,UNIT_STATE_LIFE,100000.)
    endif
    call BlzEndUnitAbilityCooldown(DagThief,'pDgA')
    call SetUnitState(DagThief,UNIT_STATE_MANA,GetUnitState(DagThief,UNIT_STATE_MAX_MANA))
    call SetUnitAnimation(DagThief,"stand")
    call Dag_UpdateCounter()
endfunction

function Dag_OnSpell takes nothing returns nothing
    local integer raw=GetSpellAbilityId()
    if GetTriggerUnit()!=DagThief then
        return
    endif
    if raw=='pDgA' then
        if DagActive then
            call Dag_Rip()
        elseif not DagRipping then
            call Dag_Begin(DagScarecrow)
        endif
    elseif raw=='pDgR' then
        call Dag_Rip()
    elseif raw=='pDs1' then
        call Dag_ChangeStyle(1)
    elseif raw=='pDs2' then
        call Dag_ChangeStyle(2)
    elseif raw=='pDs3' then
        call Dag_ChangeStyle(3)
    elseif raw=='pDRs' then
        call Dag_Reset()
    endif
endfunction

function Dag_Help takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call DisplayTimedTextToPlayer(Player(0),0.,0.,45.,"DAGGER RIP PROTOTYPE|nR: arm daggers, then attack the scarecrow. Each landed basic attack adds a dagger. No stack cap; each dagger expires after 30 seconds.|nR again: rip all daggers out for damage. Bloodied blades are the default.")
    call DisplayTimedTextToPlayer(Player(0),0.,0.,45.,"Q / W / E: embedded / spectral / bloodied visuals. Switch while daggers are planted to compare.|nT: reset scarecrow and cooldown. Rip damage = daggers x (50 + 2 x AGI). Test cooldown: 2 seconds.")
endfunction

function main_old takes nothing returns nothing
    call SetCameraBounds(-2304.,-2304.,2304.,2304.,-2304.,2304.,2304.,-2304.)
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl","Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY,12.)
    call SuspendTimeOfDay(true)
    call InitBlizzard()
    call FogEnable(false)
    call FogMaskEnable(false)
    set DagThief=CreateUnit(Player(0),'H00B',-96.,0.,0.)
    call SetHeroAgi(DagThief,100,true)
    call SetUnitAcquireRange(DagThief,0.)
    set DagAttacks=CreateTrigger()
    call TriggerAddAction(DagAttacks,function Dag_OnAttackDamage)
    call Dag_CreateScarecrow()
    call Dag_ShowStart()
    set DagCounter=CreateTextTag()
    call SetTextTagPermanent(DagCounter,true)
    call SetTextTagColor(DagCounter,255,230,130,255)
    call Dag_UpdateCounter()
    set DagSpells=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(DagSpells,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(DagSpells,function Dag_OnSpell)
    set DagTimer=CreateTimer()
    call TimerStart(DagTimer,.03,true,function Dag_Tick)
    if GetLocalPlayer()==Player(0) then
        call ClearSelection()
        call SelectUnit(DagThief,true)
        call SetCameraPosition(0.,0.)
        call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,1450.,0.)
    endif
    call TimerStart(CreateTimer(),.5,false,function Dag_Help)
endfunction

function InitTrig_DaggerPrototype takes nothing returns nothing
    call main_old()
endfunction

function main takes nothing returns nothing
    call main_old()
endfunction

function config takes nothing returns nothing
    call SetMapName("Thief - Dagger Rip Prototype 01")
    call SetMapDescription("One Thief, one scarecrow, three dagger visual styles.")
    call SetPlayers(1)
    call SetTeams(1)
    call SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
    call DefineStartLocation(0,-96.,0.)
    call SetPlayerStartLocation(Player(0),0)
    call ForcePlayerStartLocation(Player(0),0)
    call SetPlayerColor(Player(0),ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0),RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(0),false)
    call SetPlayerController(Player(0),MAP_CONTROL_USER)
endfunction

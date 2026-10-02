library TBossShinra requires TMissile
globals
    // Variables only this module uses.
    constant integer udg_ClioneDuration=$A // $A = 10
    timer udg_ClioneTimer=CreateTimer()
    integer udg_ClioneRecycle=0
    integer udg_ClioneCount=0
    integer array udg_ClioneNext
    unit array udg_ClioneCaster
    real array udg_ClioneDmg
    integer array udg_ClioneTicks
endglobals

function Trig_Boss_Shinra_Clione_Alloc takes nothing returns integer
    local integer l_idx=udg_ClioneRecycle
    if(l_idx!=0)then
        set udg_ClioneRecycle=udg_ClioneNext[l_idx]
    else
        set udg_ClioneCount=udg_ClioneCount+1
        set l_idx=udg_ClioneCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_ClioneTicks[l_idx]=0
    set udg_ClioneNext[l_idx]=-1
    return l_idx
endfunction

function Trig_Boss_Shinra_Clione_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_ClioneNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_ClioneRemoveTrig)
    set udg_ClioneNext[l_idx]=udg_ClioneRecycle
    set udg_ClioneRecycle=l_idx
endfunction

function Trig_Boss_Shinra_Clione_DamageFormula takes unit tu returns real
    // (10) times (((Strength of tu) plus (Agility of tu)) plus (Intelligence of tu)).
    return(10.*(GetHeroStr(tu,true)+GetHeroAgi(tu,true)+GetHeroInt(tu,true)))
endfunction

function Trig_Boss_Shinra_Clione_Loop takes nothing returns nothing
    local integer d
    local integer i=0
    local real a
    loop
        exitwhen i>=udg_ClioneActiveCount
        set d=udg_ClioneList[i]
        set udg_ClioneTicks[d]=udg_ClioneTicks[d]+1
        if(GetWidgetLife(udg_ClioneCaster[d])>.405 and udg_ClioneTicks[d]<=udg_ClioneDuration)then
            // The remainder after dividing (udg_ClioneTicks at position d) by (2).
            if ModuloInteger(udg_ClioneTicks[d],2)==0 then
                set a=1.
            else
                set a=-1.
            endif
            // (facing in degrees of udg_ClioneCaster at position d) plus ((a) times (a random decimal number between 0 and
            // 9)).
            set a=GetUnitFacing(udg_ClioneCaster[d])+a*GetRandomReal(0,9.)
            // Calculation 1:
            // (650) plus (a random decimal number between -150 and 150).
            // Calculation 2:
            // ((udg_ClioneDmg at position d) times (a random decimal number between 15 and 16)) divided by (16).
            call Missile_Launch(udg_ClioneCaster[d],"Abilities\\Weapons\\FaerieDragonMissile\\FaerieDragonMissile.mdl","Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",null,a,100.,40.,650.+GetRandomReal(-$96,$96),.0,.0,350.,udg_ClioneDmg[d]*GetRandomReal(15.,16.)/ 16.,0,ATTACK_TYPE_CHAOS,false) // $96 = 150
        else
            call Trig_Boss_Shinra_Clione_Free(d)
        endif
        set i=i+1
    endloop
    if udg_ClioneActiveCount==0 then
        call PauseTimer(udg_ClioneTimer)
    endif
endfunction

function Trig_Boss_Shinra_Clione_Start takes unit c returns integer
    local integer d=Trig_Boss_Shinra_Clione_Alloc()
    set udg_ClioneCaster[d]=c
    if udg_ClioneActiveCount==0 then
        call TimerStart(udg_ClioneTimer,.25,true,function Trig_Boss_Shinra_Clione_Loop)
    endif
    set udg_ClioneList[udg_ClioneActiveCount]=d
    set udg_ClioneIndex[d]=udg_ClioneActiveCount
    set udg_ClioneActiveCount=udg_ClioneActiveCount+1
    return d
endfunction

function Trig_Boss_Shinra_Clione_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A0W2' // 'A0W2': ability "!Clione"
endfunction

function Trig_Boss_Shinra_Clione_Actions takes nothing returns nothing
    local integer d=Trig_Boss_Shinra_Clione_Start(GetTriggerUnit())
    set udg_ClioneDmg[d]=Trig_Boss_Shinra_Clione_DamageFormula(udg_ClioneCaster[d])
endfunction

// Owns event registration, filters, and preloads for Boss_Shinra_Clione.
// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).
function RegisterLegacy_Boss_Shinra_Clione takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Boss_Shinra_Clione_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Boss_Shinra_Clione_Actions)
    call Preload("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
    call Preload("Abilities\\Weapons\\FaerieDragonMissile\\FaerieDragonMissile.mdl")
endfunction

function InitTrig_Boss_Shinra takes nothing returns nothing
endfunction

endlibrary

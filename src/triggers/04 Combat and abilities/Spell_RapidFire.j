library TSpellRapidFire requires TAbil, TMissile, TProf
globals
    // Variables only this module uses.
    timer udg_RapidFireTimer=CreateTimer()
    group udg_RapidFireGroup=CreateGroup()
    integer udg_RapidFireRecycle=0
    integer udg_RapidFireCount=0
    integer array udg_RapidFireNext
    real array udg_RapidFireDmg
    integer array udg_RapidFireElement
    string array udg_RapidFireMissileFx
    string array udg_RapidFireImpactFx
    integer array udg_RapidFireShots
endglobals

function Trig_Spell_RapidFire_Alloc takes nothing returns integer
    local integer l_idx=udg_RapidFireRecycle
    if(l_idx!=0)then
        set udg_RapidFireRecycle=udg_RapidFireNext[l_idx]
    else
        set udg_RapidFireCount=udg_RapidFireCount+1
        set l_idx=udg_RapidFireCount
    endif
    if(l_idx>8190)then
        return 0
    endif
    set udg_RapidFireShots[l_idx]=0
    set udg_RapidFireNext[l_idx]=-1
    return l_idx
endfunction

function Trig_Spell_RapidFire_Free takes integer l_idx returns nothing
    if l_idx==null then
        return
    elseif(udg_RapidFireNext[l_idx]!=-1)then
        return
    endif
    set udg_ArgIndex=l_idx
    call TriggerEvaluate(udg_RapidFireRemoveTrig)
    set udg_RapidFireNext[l_idx]=udg_RapidFireRecycle
    set udg_RapidFireRecycle=l_idx
endfunction

function Trig_Spell_RapidFire_DamageFormula takes unit tu returns real
    local integer manaCost=BlzGetAbilityManaCost('A0AE',Abil_GetLevel(tu,'A0AE')) // 'A0AE': ability "Rapid Fire"
    // Starting value for l_agiBonus:
    // (Agility of tu) times (2).
    local real l_agiBonus=GetHeroAgi(tu,true)*2
    // Starting value for l_mult:
    // (0.1) times ((10) plus (Prof_GetLevel(tu, 'R002'))).
    local real l_mult=.1*($A+Prof_GetLevel(tu,'R002')) // $A = 10; 'R002': upgrade "Bow"
    // ((mana cost) plus (l_agiBonus)) times (l_mult).
    return(manaCost+l_agiBonus)*l_mult
endfunction

function Trig_Spell_RapidFire_Loop takes nothing returns nothing
    local integer d
    local integer i=0
    local real a
    loop
        exitwhen i>=udg_RapidFireActiveCount
        set d=udg_RapidFireList[i]
        set udg_RapidFireShots[d]=udg_RapidFireShots[d]+1
        if udg_RapidFireShots[d]>16 then
            call GroupRemoveUnit(udg_RapidFireGroup,udg_RapidFireShooter[d])
        endif
        if IsUnitInGroup(udg_RapidFireShooter[d],udg_RapidFireGroup)then
            call SetUnitAnimation(udg_RapidFireShooter[d],"Attack - 1")
            // The remainder after dividing (udg_RapidFireShots at position d) by (2).
            if ModuloInteger(udg_RapidFireShots[d],2)==0 then
                set a=1.
            else
                set a=-1.
            endif
            // Result 1: a random decimal number between 0 and 18.
            // Result 2: (a) times (result 1).
            // Result 3: (facing in degrees of udg_RapidFireShooter at position d) plus (result 2).
            set a=GetUnitFacing(udg_RapidFireShooter[d])+a*GetRandomReal(0,18.)
            // Calculation 1:
            // (900) plus (a random decimal number between -200 and 200).
            // Calculation 2:
            // ((udg_RapidFireDmg at position d) times (a random decimal number between 15 and 16)) divided by (16).
            call Missile_Launch(udg_RapidFireShooter[d],udg_RapidFireMissileFx[d],udg_RapidFireImpactFx[d],null,a,80.,30.,900.+GetRandomReal(-$C8,$C8),.0,.0,200.,udg_RapidFireDmg[d]*GetRandomReal(15.,16.)/ 16.,udg_RapidFireElement[d],ATTACK_TYPE_PIERCE,false) // $C8 = 200
        else
            call Trig_Spell_RapidFire_Free(d)
        endif
        set i=i+1
    endloop
    if udg_RapidFireActiveCount==0 then
        call PauseTimer(udg_RapidFireTimer)
    endif
endfunction

function Trig_Spell_RapidFire_Start takes unit c returns integer
    local integer d=Trig_Spell_RapidFire_Alloc()
    set udg_RapidFireShooter[d]=c
    if udg_RapidFireActiveCount==0 then
        call TimerStart(udg_RapidFireTimer,.1,true,function Trig_Spell_RapidFire_Loop)
    endif
    set udg_RapidFireList[udg_RapidFireActiveCount]=d
    set udg_RapidFireIndex[d]=udg_RapidFireActiveCount
    set udg_RapidFireActiveCount=udg_RapidFireActiveCount+1
    return d
endfunction

function Trig_Spell_RapidFire_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0AE' or GetSpellAbilityId()=='A01P') // 'A0AE': ability "Rapid Fire"; 'A01P': ability "Rapid Fire"
endfunction

function Trig_Spell_RapidFire_Actions takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local integer d=Trig_Spell_RapidFire_Start(triggeringUnit)
    call GroupAddUnit(udg_RapidFireGroup,triggeringUnit)
    if(GetSpellAbilityId()=='A0AE')then // 'A0AE': ability "Rapid Fire"
        set udg_RapidFireDmg[d]=Trig_Spell_RapidFire_DamageFormula(triggeringUnit)
    else
        set udg_RapidFireDmg[d]=4500
    endif
    if GetUnitAbilityLevel(triggeringUnit,'A0YI')>0 then // 'A0YI': ability "Bow: Ice-elemental Attack"
        set udg_RapidFireElement[d]=2
        set udg_RapidFireMissileFx[d]="Abilities\\Spells\\Other\\FrostArrows\\NagaColdArrowMissile.mdl"
        set udg_RapidFireImpactFx[d]="Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl"
    elseif GetUnitAbilityLevel(triggeringUnit,'A0YG')>0 then // 'A0YG': ability "Bow: Thunder-elemental Attack"
        set udg_RapidFireElement[d]=3
        set udg_RapidFireMissileFx[d]="Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl"
        set udg_RapidFireImpactFx[d]="Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
    elseif GetUnitAbilityLevel(triggeringUnit,'A0YH')>0 then // 'A0YH': ability "Bow: Wind-elemental Attack"
        set udg_RapidFireElement[d]=6
        set udg_RapidFireMissileFx[d]="Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl"
        set udg_RapidFireImpactFx[d]="Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl"
    else
        set udg_RapidFireElement[d]=1
        set udg_RapidFireMissileFx[d]="Abilities\\Weapons\\SearingArrow\\SearingArrowMissile.mdl"
        set udg_RapidFireImpactFx[d]="Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
    endif
    set triggeringUnit=null
endfunction

function Trig_Spell_RapidFire_End_Actions takes nothing returns nothing
    call GroupRemoveUnit(udg_RapidFireGroup,GetTriggerUnit())
endfunction

// Owns event registration, filters, and preloads for Spell_RapidFire.
function RegisterLegacy_Spell_RapidFire takes nothing returns nothing
    local integer setupIndex
    local trigger firstSpellTrigger
    local trigger secondSpellTrigger
    set firstSpellTrigger=CreateTrigger()
    set secondSpellTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(firstSpellTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        call TriggerRegisterPlayerUnitEvent(secondSpellTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_ENDCAST,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(firstSpellTrigger,Condition(function Trig_Spell_RapidFire_Conditions))
    call TriggerAddCondition(secondSpellTrigger,Condition(function Trig_Spell_RapidFire_Conditions))
    call TriggerAddAction(firstSpellTrigger,function Trig_Spell_RapidFire_Actions)
    call TriggerAddAction(secondSpellTrigger,function Trig_Spell_RapidFire_End_Actions)
    call Preload("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl")
    call Preload("Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl")
    call Preload("Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
    call Preload("Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl")
    call Preload("Abilities\\Weapons\\SearingArrow\\SearingArrowMissile.mdl")
    call Preload("Abilities\\Spells\\Other\\FrostArrows\\NagaColdArrowMissile.mdl")
    call Preload("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl")
    call Preload("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl")
endfunction

function InitTrig_Spell_RapidFire takes nothing returns nothing
endfunction

endlibrary

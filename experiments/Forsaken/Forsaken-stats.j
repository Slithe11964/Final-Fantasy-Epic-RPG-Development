function Forsaken_StatPercent takes real value returns string
    return R2SW(value,1,2)+"%"
endfunction

function Forsaken_StatCooldown takes unit hero returns real
    local real scale=1.
    if hero==Player_GetHero(GetOwningPlayer(hero)) and IsPlayerInForce(GetOwningPlayer(hero),udg_PlayingPlayers) then
        set scale=1000./(1000.+I2R(GetHeroAgi(hero,true)))
    endif
    if Forsaken_StatAbilityLevel(hero,'A1C3')>0 then
        set scale=scale*.7
    endif
    if Forsaken_StatAbilityLevel(hero,'A18K')>0 then
        set scale=scale*.8
    endif
    if Forsaken_StatAbilityLevel(hero,'B08T')>0 then
        set scale=scale*.67
    elseif Forsaken_StatAbilityLevel(hero,'B00F')>0 or Forsaken_StatAbilityLevel(hero,'B07F')>0 or Forsaken_StatAbilityLevel(hero,'A0GJ')>0 then
        set scale=scale*.75
    elseif Forsaken_StatAbilityLevel(hero,'B08Y')>0 then
        set scale=scale*1.5
    elseif Forsaken_StatAbilityLevel(hero,'Bslo')>0 then
        set scale=scale*1.3
    endif
    return 100.*(1.-scale)
endfunction

function Forsaken_StatArmorDefense takes real armor returns real
    local real factor=LoadReal(ForsakenGearTypes,40,2)
    if armor>=0. then
        return 100.*armor*factor/(1.+armor*factor)
    endif
    // Negative armor uses Warcraft's exponential vulnerability curve.
    return 100.*(Pow(1.-factor,-armor)-1.)
endfunction

function Forsaken_StatBlock takes unit hero,boolean physical returns real
    local real chance=Forsaken_StatBlockRoll(hero,physical)
    if not physical then
        set chance=chance+(1.-chance)*RMinBJ(1.,I2R(Prof_GetLevel(hero,'R001'))/50.)*Forsaken_StatBlockRoll(hero,true)
    endif
    return chance*100.
endfunction

function Forsaken_StatResistance takes unit hero,integer element returns string
    local integer tier=Forsaken_Stat_GetElementResist(hero,element)
    if Forsaken_StatAbilityLevel(hero,'B057')>0 then
        set tier=tier-1
    endif
    if tier==7 then
        return "Absorb"
    elseif tier==6 then
        return "Immune"
    elseif tier==5 then
        return "50%"
    elseif tier==4 then
        return "20%"
    elseif tier==2 then
        return "-60%"
    elseif tier==1 then
        return "-100%"
    elseif tier==0 then
        return "Lethal"
    endif
    return "0%"
endfunction

function Forsaken_StatOutgoing takes unit hero,boolean physical returns real
    local real mult=1.
    local real hp=GetUnitState(hero,UNIT_STATE_LIFE)/GetUnitState(hero,UNIT_STATE_MAX_LIFE)
    if physical then
        if Forsaken_StatAbilityLevel(hero,'B061')>0 then
            set mult=mult*3.
        endif
        if Forsaken_StatAbilityLevel(hero,'B08P')>0 then
            set mult=mult*2.
        elseif Forsaken_StatAbilityLevel(hero,'B01W')>0 or Forsaken_StatAbilityLevel(hero,'B07I')>0 or Forsaken_StatAbilityLevel(hero,'A0WE')>0 then
            set mult=mult*1.5
        elseif Forsaken_StatAbilityLevel(hero,'B08W')>0 then
            set mult=mult*.5
        elseif Forsaken_StatAbilityLevel(hero,'B06H')>0 then
            set mult=mult*.66666
        endif
        if Forsaken_StatAbilityLevel(hero,'A0P9')>0 and hp>=.99 then
            set mult=mult*1.5
        elseif Forsaken_StatAbilityLevel(hero,'A0PA')>0 and hp<=.3 then
            set mult=mult*2.
        endif
        if Forsaken_StatAbilityLevel(hero,'A11F')>0 then
            set mult=mult*1.5*hp
        endif
    else
        if Forsaken_StatAbilityLevel(hero,'B08Q')>0 then
            set mult=mult*2.
        elseif Forsaken_StatAbilityLevel(hero,'B05A')>0 or Forsaken_StatAbilityLevel(hero,'B07J')>0 or Forsaken_StatAbilityLevel(hero,'A0WG')>0 then
            set mult=mult*1.5
        elseif Forsaken_StatAbilityLevel(hero,'B08X')>0 then
            set mult=mult*.5
        elseif Forsaken_StatAbilityLevel(hero,'B06I')>0 then
            set mult=mult*.66666
        endif
        if Forsaken_StatAbilityLevel(hero,'A0RF')>0 and hp>=.99 then
            set mult=mult*1.5
        elseif Forsaken_StatAbilityLevel(hero,'A0RG')>0 and hp<=.3 then
            set mult=mult*2.
        endif
    endif
    if Forsaken_StatAbilityLevel(hero,'A03N')>0 and (GetFloatGameState(GAME_STATE_TIME_OF_DAY)<6. or GetFloatGameState(GAME_STATE_TIME_OF_DAY)>=18.) then
        set mult=mult*1.6
    endif
    if Forsaken_StatAbilityLevel(hero,'B076')>0 then
        set mult=mult*2.
    endif
    if Forsaken_StatAbilityLevel(hero,'A134')>0 then
        set mult=mult*1.65
    endif
    return (mult-1.)*100.
endfunction

function Forsaken_StatHealing takes unit hero,boolean mana returns real
    local real mult=1.
    if Forsaken_StatAbilityLevel(hero,'B076')>0 then
        set mult=mult*2.
    endif
    if (mana and Forsaken_StatAbilityLevel(hero,'B07E')>0) or (not mana and Forsaken_StatAbilityLevel(hero,'B07D')>0) then
        set mult=mult*2.
    endif
    return (mult-1.)*100.
endfunction

function Forsaken_StatHealingReceived takes unit hero returns real
    local real mult=1.
    if Forsaken_StatAbilityLevel(hero,'B070')>0 then
        set mult=mult*.7
    endif
    if Forsaken_StatAbilityLevel(hero,'A13R')>0 then
        set mult=mult*1.5
    endif
    return (mult-1.)*100.
endfunction

function Forsaken_StatRow takes integer row,string label,string value returns nothing
    call BlzFrameSetText(ForsakenStatLabel[row],label)
    call BlzFrameSetText(ForsakenStatValue[row],value)
endfunction

function Forsaken_RenderStats takes unit hero returns nothing
    local integer i=0
    local integer element
    local integer playerIndex=GetPlayerId(GetOwningPlayer(hero))+1
    local string name
    local string title="Combat"
    local real value
    loop
        exitwhen i>=12
        call Forsaken_StatRow(i,"","")
        set i=i+1
    endloop
    if ForsakenStatsPage==0 then
        if hero==Player_GetHero(GetOwningPlayer(hero)) then
            call Forsaken_StatRow(0,"Health regen",R2SW(ForsakenHeroHPRegen[playerIndex],1,2))
            call Forsaken_StatRow(1,"Mana regen",R2SW(ForsakenHeroMPRegen[playerIndex],1,2))
            call Forsaken_StatRow(2,"Magic Defense",I2S(udg_MagicDefense[playerIndex]))
            call Forsaken_StatRow(3,"Magic Defense %",Forsaken_StatPercent(Forsaken_DefensePercent(udg_MagicDefense[playerIndex])))
        else
            call Forsaken_StatRow(0,"Base health regen",R2SW(BlzGetUnitRealField(hero,UNIT_RF_HIT_POINTS_REGENERATION_RATE),1,2))
            call Forsaken_StatRow(1,"Base mana regen",R2SW(BlzGetUnitRealField(hero,UNIT_RF_MANA_REGENERATION),1,2))
            call Forsaken_StatRow(2,"Magic defense basis","Native armor")
            call Forsaken_StatRow(3,"Armor reduction %",Forsaken_StatPercent(Forsaken_StatArmorDefense(BlzGetUnitArmor(hero))))
        endif
        call Forsaken_StatRow(4,"Armor",R2SW(BlzGetUnitArmor(hero),1,2))
        call Forsaken_StatRow(5,"Armor defense %",Forsaken_StatPercent(Forsaken_StatArmorDefense(BlzGetUnitArmor(hero))))
        call Forsaken_StatRow(6,"Evasion rating",R2SW(Forsaken_Stat_GetEvasion(hero),1,2))
        call Forsaken_StatRow(7,"Accuracy rating",R2SW(Forsaken_Stat_GetAccuracy(hero),1,2))
        call Forsaken_StatRow(8,"Physical block",Forsaken_StatPercent(Forsaken_StatBlock(hero,true)))
        call Forsaken_StatRow(9,"Magical block",Forsaken_StatPercent(Forsaken_StatBlock(hero,false)))
        call Forsaken_StatRow(10,"Cooldown reduction",Forsaken_StatPercent(Forsaken_StatCooldown(hero)))
    elseif ForsakenStatsPage==1 then
        set title="Resistances"
        set i=0
        loop
            exitwhen i>=6
            set name=ForsakenStatName[i]
            call Forsaken_StatRow(i,name+" resistance",Forsaken_StatResistance(hero,i+1))
            set i=i+1
        endloop
        set value=0.
        if Forsaken_StatAbilityLevel(hero,'A11P')>0 then
            call Forsaken_StatRow(6,"Non-elemental","Immune")
        else
            if Forsaken_StatAbilityLevel(hero,'A11O')>0 then
                set value=87.5
            endif
            call Forsaken_StatRow(6,"Non-elemental",Forsaken_StatPercent(value))
        endif
        set value=0.
        if Forsaken_StatAbilityLevel(hero,'A0PM')>0 then
            set value=15.
        endif
        call Forsaken_StatRow(7,"Random absorption",Forsaken_StatPercent(value))
    elseif ForsakenStatsPage==2 then
        set title="Element bonuses"
        set i=0
        loop
            exitwhen i>=12
            set element=i/2+1
            set name=ForsakenStatName[element-1]
            if ModuloInteger(i,2)==0 then
                set name=name+" attack bonus"
                set value=Forsaken_Stat_GetElementBonus(hero,element,true)+Forsaken_Stat_GetElementBonus(hero,7,true)
            else
                set name=name+" spell bonus"
                set value=Forsaken_Stat_GetElementBonus(hero,element,false)+Forsaken_Stat_GetElementBonus(hero,7,false)
            endif
            call Forsaken_StatRow(i,name,Forsaken_StatPercent(value*100.))
            set i=i+1
        endloop
    else
        set title="Other bonuses"
        call Forsaken_StatRow(0,"Physical buffs",Forsaken_StatPercent(Forsaken_StatOutgoing(hero,true)))
        call Forsaken_StatRow(1,"Magic buffs",Forsaken_StatPercent(Forsaken_StatOutgoing(hero,false)))
        call Forsaken_StatRow(2,"HP healing buffs",Forsaken_StatPercent(Forsaken_StatHealing(hero,false)))
        call Forsaken_StatRow(3,"MP healing buffs",Forsaken_StatPercent(Forsaken_StatHealing(hero,true)))
        call Forsaken_StatRow(4,"Healing received",Forsaken_StatPercent(Forsaken_StatHealingReceived(hero)))
        call Forsaken_StatRow(5,"Staff / healing power",Forsaken_StatPercent((Forsaken_StatSpellPower(hero,'R004',.5)-1.)*100.))
        call Forsaken_StatRow(6,"Rod spell power",Forsaken_StatPercent((Forsaken_StatSpellPower(hero,'R003',.5)-1.)*100.))
        call Forsaken_StatRow(7,"Inner Mana power",Forsaken_StatPercent((Forsaken_StatSpellPower(hero,'R00L',1.)-1.)*100.))
        set value=0.
        if Forsaken_StatAbilityLevel(hero,'A0RV')>0 or Forsaken_StatAbilityLevel(hero,'A0EI')>0 then
            set value=25.
        elseif Forsaken_StatAbilityLevel(hero,'A0RU')>0 then
            set value=10.
        endif
        call Forsaken_StatRow(8,"Flat damage guard",R2SW(value,1,0))
        call Forsaken_StatRow(9,"Move speed",R2SW(GetUnitMoveSpeed(hero),1,0))
    endif
    call BlzFrameSetText(ForsakenStatsHeading,title+" ("+I2S(ForsakenStatsPage+1)+"/4)")
endfunction

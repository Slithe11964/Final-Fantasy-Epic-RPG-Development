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

function Forsaken_StatPenalty takes string value,boolean reduced returns string
    if reduced then
        return "|cffff4040"+value+"|r"
    endif
    return value
endfunction

function Forsaken_StatItemAccuracy takes unit hero returns real
    local integer slot=0
    local item gear
    local real total=0.
    loop
        exitwhen slot>=15
        set gear=Forsaken_ActiveGear(hero,slot)
        if gear!=null then
            set total=total+I2R(LoadInteger(ForsakenGearTypes,41,GetItemTypeId(gear)))
        endif
        set slot=slot+1
    endloop
    set gear=null
    return total
endfunction

function Forsaken_StatAccuracy takes unit hero returns real
    local real value=Forsaken_Stat_GetAccuracy(hero)+Forsaken_StatItemAccuracy(hero)
    if Forsaken_StatAbilityLevel(hero,'B00X')>0 then
        set value=value+25.
    endif
    if Forsaken_StatAbilityLevel(hero,'B01F')>0 then
        set value=value+40.
    endif
    if Forsaken_StatAbilityLevel(hero,'B003')>0 then
        set value=value-40.
    endif
    // Blind halves the hit margin after target evasion; this rating is its target-independent display.
    if Forsaken_StatAbilityLevel(hero,'B02V')>0 then
        return 0.
    elseif Forsaken_StatAbilityLevel(hero,'B00P')>0 then
        set value=value*.5
    endif
    return RMaxBJ(0.,value)
endfunction

function Forsaken_StatDefenseMultiplier takes unit hero,boolean physical returns real
    local boolean inverted=Forsaken_StatAbilityLevel(hero,'A0F3')>0
    local boolean penalty
    local boolean protect
    local boolean stronger
    if physical then
        set penalty=Forsaken_StatAbilityLevel(hero,'B06J')>0 or Forsaken_StatAbilityLevel(hero,'A15Q')>0
        set stronger=Forsaken_StatAbilityLevel(hero,'B08R')>0
        set protect=stronger or Forsaken_StatAbilityLevel(hero,'B007')>0 or Forsaken_StatAbilityLevel(hero,'B07G')>0 or Forsaken_StatAbilityLevel(hero,'A15P')>0
    else
        set penalty=Forsaken_StatAbilityLevel(hero,'B06K')>0 or Forsaken_StatAbilityLevel(hero,'A15S')>0
        set stronger=Forsaken_StatAbilityLevel(hero,'B08S')>0
        set protect=stronger or Forsaken_StatAbilityLevel(hero,'B005')>0 or Forsaken_StatAbilityLevel(hero,'B07H')>0 or Forsaken_StatAbilityLevel(hero,'A15R')>0
    endif
    if inverted then
        if penalty then
            return .66666
        elseif protect then
            return 1.5
        endif
    elseif stronger then
        return .5
    elseif protect then
        return .66666
    elseif penalty then
        return 1.5
    endif
    return 1.
endfunction

function Forsaken_StatEffectiveDefense takes real base,real multiplier returns real
    // Defense statuses multiply the damage remaining after armor; they do not change the raw rating.
    return 100.*(1.-(1.-base*.01)*multiplier)
endfunction

function Forsaken_StatElementText takes unit hero,integer element returns string
    local real physical=100.*(Forsaken_StatElementDamageBonus(hero,element,true))
    local real magical=100.*(Forsaken_StatElementDamageBonus(hero,element,false))
    if RAbsBJ(physical-magical)<.001 then
        return Forsaken_StatPercent(physical)
    endif
    if RAbsBJ(physical-I2R(R2I(physical)))<.001 then
        return I2S(R2I(physical))+"% | "+Forsaken_StatPercent(magical)
    endif
    return Forsaken_StatPercent(physical)+" | "+Forsaken_StatPercent(magical)
endfunction

function Forsaken_StatRow takes integer row,string label,string value returns nothing
    call BlzFrameSetText(ForsakenStatLabel[row],label)
    call BlzFrameSetText(ForsakenStatValue[row],value)
endfunction

function Forsaken_RenderStats takes unit hero returns nothing
    local integer i=0
    local integer element=Element_GetOfUnit(hero,true)
    local integer playerIndex=GetPlayerId(GetOwningPlayer(hero))+1
    local string name
    local string title="Defenses"
    local real value
    local item twoHandedWeapon=Forsaken_TwoHandedWeapon(hero)
    local real physicalDefense=Forsaken_StatDefenseMultiplier(hero,true)
    local real magicalDefense=Forsaken_StatDefenseMultiplier(hero,false)
    local boolean blind=Forsaken_StatAbilityLevel(hero,'B00P')>0 or Forsaken_StatAbilityLevel(hero,'B02V')>0 or Forsaken_StatAbilityLevel(hero,'B003')>0
    loop
        exitwhen i>=12
        call Forsaken_StatRow(i,"","")
        set i=i+1
    endloop
    if ForsakenStatsPage==1 then
        if hero==Player_GetHero(GetOwningPlayer(hero)) then
            call Forsaken_StatRow(0,"Magic Defense",I2S(udg_MagicDefense[playerIndex]))
            call Forsaken_StatRow(1,"Magic Defense %",Forsaken_StatPenalty(Forsaken_StatPercent(Forsaken_StatEffectiveDefense(Forsaken_DefensePercent(udg_MagicDefense[playerIndex]),magicalDefense)),magicalDefense>1.))
        else
            call Forsaken_StatRow(0,"Magic defense basis","Native armor")
            call Forsaken_StatRow(1,"Armor reduction %",Forsaken_StatPercent(Forsaken_StatArmorDefense(BlzGetUnitArmor(hero))))
        endif
        call Forsaken_StatRow(2,"Armor",R2SW(BlzGetUnitArmor(hero),1,2))
        call Forsaken_StatRow(3,"Armor defense %",Forsaken_StatPenalty(Forsaken_StatPercent(Forsaken_StatEffectiveDefense(Forsaken_StatArmorDefense(BlzGetUnitArmor(hero)),physicalDefense)),physicalDefense>1.))
        call Forsaken_StatRow(4,"Evasion rating",Forsaken_StatPenalty(R2SW(Forsaken_Stat_GetEvasion(hero),1,2),Forsaken_StatAbilityLevel(hero,'A1DB')>0))
        call Forsaken_StatRow(6,"Physical block",Forsaken_StatPercent(Forsaken_StatBlock(hero,true)))
        call Forsaken_StatRow(7,"Magical block",Forsaken_StatPercent(Forsaken_StatBlock(hero,false)))
        set value=0.
        if Forsaken_StatAbilityLevel(hero,'A0RV')>0 or Forsaken_StatAbilityLevel(hero,'A0EI')>0 then
            set value=25.
        elseif Forsaken_StatAbilityLevel(hero,'A0RU')>0 then
            set value=10.
        endif
        call Forsaken_StatRow(8,"Flat damage guard",R2SW(value,1,0))
    elseif ForsakenStatsPage==2 then
        set title="Resistances"
        if ForsakenConditionPage then
            set title="Condition resistances"
            call Forsaken_RenderConditions(hero,0)
        else
        set i=0
        loop
            exitwhen i>=6
            set name=ForsakenStatName[i]
            call Forsaken_StatRow(i,name+" resistance",Forsaken_StatPenalty(Forsaken_StatResistance(hero,i+1),Forsaken_StatAbilityLevel(hero,'B057')>0))
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
        call Forsaken_RenderConditions(hero,8)
        endif
    elseif ForsakenStatsPage==0 then
        set title="Damage bonuses"
        set i=0
        loop
            exitwhen i>=6
            set name=ForsakenStatName[i]+" damage"
            if element==i+1 then
                set name="|cff00ff00"+name+"|r"
            endif
            call Forsaken_StatRow(i,name,Forsaken_StatElementText(hero,i+1))
            set i=i+1
        endloop
        call Forsaken_StatRow(6,"Physical damage",Forsaken_StatPenalty(Forsaken_StatPercent(Forsaken_StatOutgoing(hero,true)),Forsaken_StatAbilityLevel(hero,'B08W')>0 or Forsaken_StatAbilityLevel(hero,'B06H')>0))
        call Forsaken_StatRow(7,"Magical damage",Forsaken_StatPenalty(Forsaken_StatPercent(Forsaken_StatOutgoing(hero,false)),Forsaken_StatAbilityLevel(hero,'B08X')>0 or Forsaken_StatAbilityLevel(hero,'B06I')>0))
        call Forsaken_StatRow(8,"Attack speed",Forsaken_StatPenalty(R2SW(Forsaken_StatAttackSpeed(hero),1,0)+"%",Forsaken_StatAbilityLevel(hero,'Bslo')>0 or Forsaken_StatAbilityLevel(hero,'B08Y')>0))
        call Forsaken_StatRow(9,"Accuracy rating",Forsaken_StatPenalty(R2SW(Forsaken_StatAccuracy(hero),1,2),blind))
        if Forsaken_StatAbilityLevel(hero,'A0AP')>0 or Forsaken_StatAbilityLevel(hero,'A15J')>0 then
            call Forsaken_StatRow(10,"Attack multiplier",R2SW(Forsaken_StatAttackMultiplier(hero),1,2)+"x")
            if Unit_HasNoEquipment(hero) then
                call Forsaken_StatRow(11,"Brawler","|cff00ff00Active|r")
            else
                call Forsaken_StatRow(11,"Brawler","Inactive")
            endif
        elseif Forsaken_StatAbilityLevel(hero,'A0GP')>0 then
            if twoHandedWeapon!=null then
                call Forsaken_StatRow(10,"Two-Handed damage","+"+R2SW(GetWidgetLife(twoHandedWeapon)*5.,1,0))
                call Forsaken_StatRow(11,"Two-Handed speed","+240%")
            else
                call Forsaken_StatRow(10,"Two-Handed damage","+0")
                call Forsaken_StatRow(11,"Two-Handed speed","+0%")
            endif
        endif
        if element==7 and Forsaken_StatAbilityLevel(hero,'A0AP')==0 and Forsaken_StatAbilityLevel(hero,'A15J')==0 and Forsaken_StatAbilityLevel(hero,'A0GP')==0 then
            call Forsaken_StatRow(11,"|cff00ff00Basic attack element|r","Omni")
        endif
    else
        set title="Other bonuses"
        if hero==Player_GetHero(GetOwningPlayer(hero)) then
            call Forsaken_StatRow(0,"Health regen",R2SW(ForsakenHeroHPRegen[playerIndex],1,2))
            call Forsaken_StatRow(5,"Mana regen",R2SW(ForsakenHeroMPRegen[playerIndex],1,2))

        else
            call Forsaken_StatRow(0,"Base health regen",R2SW(BlzGetUnitRealField(hero,UNIT_RF_HIT_POINTS_REGENERATION_RATE),1,2))
            call Forsaken_StatRow(5,"Base mana regen",R2SW(BlzGetUnitRealField(hero,UNIT_RF_MANA_REGENERATION),1,2))

        endif
        call Forsaken_StatRow(1,"HP healing buffs",Forsaken_StatPercent(Forsaken_StatHealing(hero,false)))
        call Forsaken_StatRow(2,"MP healing buffs",Forsaken_StatPercent(Forsaken_StatHealing(hero,true)))
        call Forsaken_StatRow(3,"Healing received",Forsaken_StatPenalty(Forsaken_StatPercent(Forsaken_StatHealingReceived(hero)),Forsaken_StatAbilityLevel(hero,'B070')>0))
        call Forsaken_StatRow(6,"Cooldown reduction",Forsaken_StatPenalty(Forsaken_StatPercent(Forsaken_StatCooldown(hero)),(Forsaken_StatAbilityLevel(hero,'B08Y')>0 or Forsaken_StatAbilityLevel(hero,'Bslo')>0) and Forsaken_StatAbilityLevel(hero,'B08T')==0 and Forsaken_StatAbilityLevel(hero,'B00F')==0 and Forsaken_StatAbilityLevel(hero,'B07F')==0 and Forsaken_StatAbilityLevel(hero,'A0GJ')==0))
        call Forsaken_StatRow(4,"Move speed",Forsaken_StatPenalty(R2SW(GetUnitMoveSpeed(hero),1,0),Forsaken_StatAbilityLevel(hero,'B08Y')>0 or Forsaken_StatAbilityLevel(hero,'Bslo')>0 or Forsaken_StatAbilityLevel(hero,'B05M')>0 or Forsaken_StatAbilityLevel(hero,'B05N')>0))
    endif
    set twoHandedWeapon=null
    call BlzFrameSetText(ForsakenStatsHeading,title+" ("+I2S(ForsakenStatsPage+1)+"/4)")
endfunction

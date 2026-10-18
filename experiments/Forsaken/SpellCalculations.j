function SpellCalc_Tooltip takes unit hero,integer raw,integer rank returns string
    local string tip=LoadStr(SpellCalcData,raw,rank)
    local real amount
    local integer mana=BlzGetAbilityManaCost(raw,rank-1)
    local integer row=LoadInteger(SpellCalcData,raw,-1)
    local integer choice=LoadInteger(SpellCalcData,raw,-2)
    local real rate
    if not SpellCalcHidden[GetPlayerId(GetLocalPlayer())] then
        set tip=tip+LoadStr(SpellCalcData,raw,100+rank)
        if raw=='A00M' or raw=='A10K' then
            set amount=(I2R(mana)*5.+I2R(GetHeroInt(hero,true))*5.)*Prof_StaffPower(hero)
            set tip=tip+"|nCurrent caster: "+R2SW(amount,1,0)+" HP on impact; "+R2SW(amount*.25,1,0)+" HP along the path."
        elseif raw=='A04O' or raw=='A03O' or raw=='A05A' then
            set amount=(I2R(mana)*10.+I2R(GetHeroInt(hero,true))*5.)*Prof_StaffPower(hero)
            set tip=tip+"|nCurrent caster: "+R2SW(amount,1,0)+" base HP."
        elseif raw=='A0PC' then
            set amount=I2R(R2I(I2R(50+GetHeroInt(hero,true)/4)*Prof_StaffPower(hero)))
            set tip=tip+"|nCurrent caster: "+R2SW(amount,1,0)+" queued HP per second; up to "+R2SW(amount*.25,1,0)+" MP per second."
        elseif raw=='A089' or raw=='A06Q' then
            set amount=I2R(R2I((I2R(mana)*3.+I2R(GetHeroInt(hero,true))*3.)*Prof_StaffPower(hero)))
            set tip=tip+"|nCurrent caster: "+R2SW(amount,1,0)+" HP and "+R2SW(amount*.25,1,0)+" MP. Caster receives HP only."
        elseif raw=='A00L' then
            set rate=I2R(25+GetHeroInt(hero,true)/3)*Prof_StaffPower(hero)
            if Talent_Active(hero,12,2,3,raw) then
                set tip=tip+"|nSwiftmend: ("+R2SW(rate*2.,1,0)+" + 50% of target Strength) HP/sec for "+R2SW(PriestRegenDuration[rank]*.5,1,0)+" seconds, before recovery rolls."
            else
                set tip=tip+"|nCurrent caster: "+R2SW(rate,1,0)+" + 25% of target Strength HP/sec, before recovery rolls."
            endif
        elseif raw=='A0Z3' or raw=='A0DG' or raw=='A03L' then
            set amount=I2R(R2I(I2R((rank+4)*40+GetHeroInt(hero,true)*2)*Prof_StaffPower(hero)))
            set tip=tip+"|nCurrent caster: "+R2SW(amount,1,0)+" base MP drained."
        elseif raw=='A0Z4' or raw=='A07J' then
            set amount=I2R(R2I(I2R(mana*2+GetHeroInt(hero,true))*Prof_StaffPower(hero)))
            set tip=tip+"|nCurrent caster: "+R2SW(amount,1,0)+" base damage/sec; heals actual damage dealt."
        endif
    endif
    if row>0 and Talent_Active(hero,12,row,choice,raw) then
        set tip=tip+"|n|n|cffffcc00Talent: "+TalentName[Talent_Index(12,row,choice)]+"|r|n"+TalentText[Talent_Index(12,row,choice)]
        if raw=='A0OM' and not SpellCalcHidden[GetPlayerId(GetLocalPlayer())] then
            set amount=I2R(R2I(PriestRainHealing[rank]/PriestRainPeriod[rank]*.5+.5))
            set tip=tip+"|nEach "+R2SW(PriestRainPeriod[rank],1,1)+" seconds: "+R2SW(PriestRainHealing[rank]*.5,1,0)+" base HP and "+R2SW(PriestRainHealing[rank]*.5,1,0)+" base magic damage."
            set tip=tip+"|nCurrent split: "+R2SW(amount,1,0)+" base HP/sec and "+R2SW(amount,1,0)+" magic damage/sec, before target modifiers."
        endif
    endif
    return tip
endfunction

function SpellCalc_Update takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local integer i=0
    local integer raw
    local integer rank
    local string tip
    if hero!=null then
        loop
            exitwhen i>=SpellCalcCount
            set raw=SpellCalcRaw[i]
            set rank=GetUnitAbilityLevel(hero,raw)
            if rank>0 then
                set tip=SpellCalc_Tooltip(hero,raw,rank)
                if not HaveSavedInteger(SpellCalcLast,raw,rank) or LoadInteger(SpellCalcLast,raw,rank)!=StringHash(tip) or LoadInteger(SpellCalcLast,raw,rank+100)!=StringLength(tip) then
                    call BlzSetAbilityExtendedTooltip(raw,tip,rank-1+PriestTooltipOffset)
                    call SaveInteger(SpellCalcLast,raw,rank,StringHash(tip))
                    call SaveInteger(SpellCalcLast,raw,rank+100,StringLength(tip))
                endif
            endif
            set i=i+1
        endloop
    endif
    set hero=null
endfunction

function SpellCalc_Command takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local string command=StringCase(GetEventPlayerChatString(),false)
    if command=="-spellcalculations off" then
        set SpellCalcHidden[GetPlayerId(viewer)]=true
        call DisplayTimedTextToPlayer(viewer,0,0,10,"Spell calculations hidden.")
    elseif command=="-spellcalculations on" then
        set SpellCalcHidden[GetPlayerId(viewer)]=false
        call DisplayTimedTextToPlayer(viewer,0,0,10,"Spell calculations shown.")
    else
        call DisplayTimedTextToPlayer(viewer,0,0,10,"Use -spellcalculations on or -spellcalculations off.")
    endif
    if GetLocalPlayer()==viewer then
        call SpellCalc_Update()
    endif
    set viewer=null
endfunction

function SpellCalc_Register takes nothing returns nothing
    local trigger command=CreateTrigger()
    local integer i=0
    loop
        exitwhen i>=8
        call TriggerRegisterPlayerChatEvent(command,Player(i),"-spellcalculations",false)
        set i=i+1
    endloop
    call TriggerAddAction(command,function SpellCalc_Command)
    set command=null
endfunction

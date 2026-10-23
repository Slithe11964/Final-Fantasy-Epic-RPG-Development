function SharedItemCD_IsItem takes integer raw returns boolean
    return LoadBoolean(SharedItemCDTypes,0,raw)
endfunction

function SharedItemCD_Duration takes unit caster,integer raw returns real
    local real scale=1000.
    local integer level=Abil_GetLevel(caster,raw)
    if GetUnitAbilityLevel(caster,'Avul')>0 then
        return RMaxBJ(0.,BlzGetAbilityCooldown(raw,level))
    endif
    if GetUnitAbilityLevel(caster,'A1C3')>0 then
        set scale=scale*.7
    endif
    if GetUnitAbilityLevel(caster,'A18K')>0 then
        set scale=scale*.8
    endif
    if GetUnitAbilityLevel(caster,'B08T')>0 then
        set scale=scale*.67
    elseif GetUnitAbilityLevel(caster,'B00F')>0 or GetUnitAbilityLevel(caster,'B07F')>0 or GetUnitAbilityLevel(caster,'A0GJ')>0 then
        set scale=scale*.75
    elseif GetUnitAbilityLevel(caster,'B08Y')>0 then
        set scale=scale*1.5
    elseif GetUnitAbilityLevel(caster,'Bslo')>0 then
        set scale=scale*1.3
    endif
    if caster==Player_GetHero(GetOwningPlayer(caster)) and IsPlayerInForce(GetOwningPlayer(caster),udg_PlayingPlayers) then
        set scale=scale/(I2R(GetHeroAgi(caster,true))+1000.)
    else
        set scale=scale/1000.
    endif
    // Read the immutable object cooldown, never a transferred item's remaining
    // cooldown or its already-scaled ability instance (which would compound).
    return RMaxBJ(0.,BlzGetAbilityCooldown(raw,level)*scale)
endfunction

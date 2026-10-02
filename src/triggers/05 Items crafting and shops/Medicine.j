library TMedicine requires TPlayerHero, TWait
function Medicine_ApplyTimed takes unit t,boolean ph returns nothing
    local integer l_amount=2
    local integer l_level=GetUnitAbilityLevel(t,'A0FM') // 'A0FM': ability "Hero Drink Powerup"
    local integer l_bigLevel
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",t,"origin"))
    if ph then
        set l_amount=3
        set udg_DispelTarget=t
        call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    endif
    if(l_level<=0)then
        call UnitAddAbility(t,'A0FM') // 'A0FM': ability "Hero Drink Powerup"
        set l_level=1
    endif
    // (l_level) plus (amount).
    set l_level=l_level+l_amount
    if(l_level>$C)then // $C = 12
        // Decrease l_level by 12.
        set l_level=l_level-$C // $C = 12
        set l_bigLevel=GetUnitAbilityLevel(t,'A17Q') // 'A17Q': ability "Hero Drink Powerup"
        if(l_bigLevel>0)then
            // (l_bigLevel) plus (1).
            call SetUnitAbilityLevel(t,'A17Q',l_bigLevel+1) // 'A17Q': ability "Hero Drink Powerup"
        else
            call UnitAddAbility(t,'A17Q') // 'A17Q': ability "Hero Drink Powerup"
        endif
    endif
    call SetUnitAbilityLevel(t,'A0FM',l_level) // 'A0FM': ability "Hero Drink Powerup"
    call Wait_Polled(60.)
    set l_level=GetUnitAbilityLevel(t,'A0FM') // 'A0FM': ability "Hero Drink Powerup"
    set l_bigLevel=GetUnitAbilityLevel(t,'A17Q') // 'A17Q': ability "Hero Drink Powerup"
    // (l_level) minus (amount).
    set l_level=l_level-l_amount
    if(l_level>1)then
        call SetUnitAbilityLevel(t,'A0FM',l_level) // 'A0FM': ability "Hero Drink Powerup"
    elseif(l_level<1)then
        if(l_bigLevel>0)then
            // Increase l_level by 12.
            set l_level=l_level+$C // $C = 12
            call SetUnitAbilityLevel(t,'A0FM',l_level) // 'A0FM': ability "Hero Drink Powerup"
            if(l_bigLevel>1)then
                // (l_bigLevel) minus (1).
                call SetUnitAbilityLevel(t,'A17Q',l_bigLevel-1) // 'A17Q': ability "Hero Drink Powerup"
            else
                call UnitRemoveAbility(t,'A17Q') // 'A17Q': ability "Hero Drink Powerup"
            endif
        else
            call UnitRemoveAbility(t,'A0FM') // 'A0FM': ability "Hero Drink Powerup"
        endif
    elseif(l_bigLevel<=0)then
        call UnitRemoveAbility(t,'A0FM') // 'A0FM': ability "Hero Drink Powerup"
    else
        call SetUnitAbilityLevel(t,'A0FM',l_level) // 'A0FM': ability "Hero Drink Powerup"
    endif
    call TimerStart(udg_StatsRefreshTimer,.01,false,null)
endfunction

function InitTrig_Medicine takes nothing returns nothing
endfunction

endlibrary

library TMemento requires TForce
function Trig_Memento_Ring_Compass_Cond_IsMementoSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A1D7')or(GetSpellAbilityId()=='A1D8') // 'A1D7': ability "Memento"; 'A1D8': ability "Memento"
endfunction

function Trig_Memento_Ring_Compass_Conditions takes nothing returns boolean
    return(Trig_Memento_Ring_Compass_Cond_IsMementoSpell())
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleSouthEast takes nothing returns boolean
    return(udg_TempReal<=337.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleSouth takes nothing returns boolean
    return(udg_TempReal<=292.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleSouthWest takes nothing returns boolean
    return(udg_TempReal<=247.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleWest takes nothing returns boolean
    return(udg_TempReal<=202.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleNorthWest takes nothing returns boolean
    return(udg_TempReal<=157.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleNorth takes nothing returns boolean
    return(udg_TempReal<=112.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleNorthEast takes nothing returns boolean
    return(udg_TempReal<=67.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_AngleEast takes nothing returns boolean
    return(udg_TempReal<=22.5)
endfunction

function Trig_Memento_Ring_Compass_Cond_IsGlowingRing takes nothing returns boolean
    return(GetSpellAbilityId()=='A1D7') // 'A1D7': ability "Memento"
endfunction

function Trig_Memento_Ring_Compass_Cond_RingLinkLost takes nothing returns boolean
    return(udg_ShadowLoyalty<=0)
endfunction

function Trig_Memento_Ring_Compass_Cond_NoShadowUnit takes nothing returns boolean
    return(udg_ShadowUnit==null)
endfunction

function Trig_Memento_Ring_Compass_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Memento_Ring_Compass_Cond_NoShadowUnit())then
        if(Trig_Memento_Ring_Compass_Cond_RingLinkLost())then
            call DisplayTimedTextToForce(udg_TempForce,10.,"You can't make out any information from the ring anymore...")
        else
            call DisplayTimedTextToForce(udg_TempForce,10.,"The ring doesn't appear to pull you in any particular direction.")
        endif
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint2=GetUnitLoc(udg_ShadowUnit)
        // The remainder after dividing (AngleBetweenPoints(udg_TempPoint, udg_TempPoint2)) by (360).
        set udg_TempReal=ModuloReal(AngleBetweenPoints(udg_TempPoint,udg_TempPoint2),360.)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Memento_Ring_Compass_Cond_AngleEast())then
            set udg_TempString="east"
        else
            if(Trig_Memento_Ring_Compass_Cond_AngleNorthEast())then
                set udg_TempString="north-east"
            else
                if(Trig_Memento_Ring_Compass_Cond_AngleNorth())then
                    set udg_TempString="north"
                else
                    if(Trig_Memento_Ring_Compass_Cond_AngleNorthWest())then
                        set udg_TempString="north-west"
                    else
                        if(Trig_Memento_Ring_Compass_Cond_AngleWest())then
                            set udg_TempString="west"
                        else
                            if(Trig_Memento_Ring_Compass_Cond_AngleSouthWest())then
                                set udg_TempString="south-west"
                            else
                                if(Trig_Memento_Ring_Compass_Cond_AngleSouth())then
                                    set udg_TempString="south"
                                else
                                    if(Trig_Memento_Ring_Compass_Cond_AngleSouthEast())then
                                        set udg_TempString="south-east"
                                    else
                                        set udg_TempString="east"
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
        if(Trig_Memento_Ring_Compass_Cond_IsGlowingRing())then
            call DisplayTimedTextToForce(udg_TempForce,10.,("The ring's glow points you towards the |cffffcc00"+(udg_TempString+"|r.")))
        else
            call DisplayTimedTextToForce(udg_TempForce,10.,("A memory of the ring's faint glow makes you look towards the |cffffcc00"+(udg_TempString+"|r.")))
        endif
    endif
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Memento takes nothing returns nothing
endfunction
function RegisterR11_Memento_Ring_Compass takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Memento_Ring_Compass=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Memento_Ring_Compass,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Memento_Ring_Compass,Condition(function Trig_Memento_Ring_Compass_Conditions))
    call TriggerAddAction(gg_trg_Memento_Ring_Compass,function Trig_Memento_Ring_Compass_Actions)
endfunction




endlibrary

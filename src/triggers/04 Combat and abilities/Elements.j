library TElements
function Trig_Elements_Init_Actions takes nothing returns nothing
    set udg_ElementSpellPrimary[1]='A0SG' // 'A0SG': ability "Firaga"
    set udg_ElementSpellSecondary[1]='A0SH' // 'A0SH': ability "Fire"
    set udg_EnchantAbility[1]='A1DS' // 'A1DS': ability "Enfire"
    set udg_ElementSpellPrimary[2]='A0TM' // 'A0TM': ability "Blizzaga"
    set udg_ElementSpellSecondary[2]='A0IO' // 'A0IO': ability "Ice"
    set udg_EnchantAbility[2]='A0S9' // 'A0S9': ability "Enfrost"
    set udg_ElementSpellPrimary[3]='A0TN' // 'A0TN': ability "Thundaga"
    set udg_ElementSpellSecondary[3]='A0TO' // 'A0TO': ability "Bolt"
    set udg_EnchantAbility[3]='A0SB' // 'A0SB': ability "Enthunder"
    set udg_ElementSpellPrimary[4]='A0SN' // 'A0SN': ability "Aqualung"
    set udg_ElementSpellSecondary[4]='A0SA' // 'A0SA': ability "Water"
    set udg_EnchantAbility[4]='A0SC' // 'A0SC': ability "Enwater"
    set udg_ElementSpellPrimary[5]='A103' // 'A103': ability "Quake"
    set udg_ElementSpellSecondary[5]='A0T7' // 'A0T7': ability "Tremor"
    set udg_EnchantAbility[5]='A0SD' // 'A0SD': ability "Enstone"
    set udg_ElementSpellPrimary[6]='A0SS' // 'A0SS': ability "Aero"
    set udg_ElementSpellSecondary[6]='A044' // 'A044': ability "Gust"
    set udg_EnchantAbility[6]='A0SE' // 'A0SE': ability "Enaero"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Elements takes nothing returns nothing
endfunction
function RegisterR11_Elements_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Elements_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Elements_Init,25.)
    call TriggerAddAction(gg_trg_Elements_Init,function Trig_Elements_Init_Actions)
endfunction




endlibrary

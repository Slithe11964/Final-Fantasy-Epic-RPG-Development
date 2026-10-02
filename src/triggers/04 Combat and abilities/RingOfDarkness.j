library TRingOfDarkness
function Trig_RingOfDarkness_Init_Actions takes nothing returns nothing
    set udg_RingHintsReady=true
    call UnitAddAbilityBJ('A1BG',gg_unit_n03T_0008) // 'A1BG': ability "Madain Sari Horn Hint"
    call UnitAddAbilityBJ('A0JH',gg_unit_n03T_0008) // 'A0JH': ability "Black Hole Hint"
    call UnitAddAbilityBJ('A10W',gg_unit_n03T_0008) // 'A10W': ability "Spirit Pendant Hint"
    call UnitAddAbilityBJ('A0HJ',gg_unit_n03T_0008) // 'A0HJ': ability "Excalipoor Hint"
    call UnitAddAbilityBJ('A0HK',gg_unit_n03T_0008) // 'A0HK': ability "Judge's Helm Hint"
    call UnitAddAbilityBJ('A0HI',gg_unit_n03T_0008) // 'A0HI': ability "Perfect MoD Hint"
    call UnitAddAbilityBJ('A0U9',gg_unit_n03T_0008) // 'A0U9': ability "Magatama Hint"
    call UnitAddAbilityBJ('A01G',gg_unit_n03T_0008) // 'A01G': ability "Dragon Soul Hint"
    set udg_GlyphActivated[1]=false
    set udg_GlyphActivated[2]=false
    set udg_GlyphActivated[3]=false
    set udg_GlyphActivated[4]=false
    set udg_GlyphDemonType[1]='n0A5' // 'n0A5': unit "Cu Chulainn"
    set udg_GlyphDemonType[2]='n0A4' // 'n0A4': unit "Girimehkala"
    set udg_GlyphDemonType[3]='n0A6' // 'n0A6': unit "Pixie"
    set udg_GlyphDemonType[4]='n0A9' // 'n0A9': unit "Arahabaki"
    set udg_GlyphDemonType[5]='n0A7' // 'n0A7': unit "Titania"
    set udg_GlyphDemonType[6]='n0A8' // 'n0A8': unit "Parvati"
    set udg_RingHintUsed[1]=false
    set udg_RingHintUsed[2]=false
    set udg_RingHintUsed[3]=false
    set udg_RingHintUsed[4]=false
    set udg_RingHintUsed[5]=false
    set udg_RingHintUsed[6]=false
    set udg_RingHintUsed[7]=false
    set udg_RingHintUsed[8]=false
    set udg_GlyphRect[0]=gg_rct_689
    set udg_GlyphRect[1]=gg_rct_687
    set udg_GlyphRect[2]=gg_rct_688
    set udg_GlyphRect[3]=gg_rct_690
    call EnableTrigger(gg_trg_Glyph_Area_Enter)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_RingOfDarkness automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_RingOfDarkness (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_RingOfDarkness takes nothing returns nothing
endfunction

function Register_RingOfDarkness_Init takes nothing returns nothing
    set gg_trg_RingOfDarkness_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_RingOfDarkness_Init,90.)
    call TriggerAddAction(gg_trg_RingOfDarkness_Init,function Trig_RingOfDarkness_Init_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_RingOfDarkness takes nothing returns nothing
    call Register_RingOfDarkness_Init()
endfunction

endlibrary

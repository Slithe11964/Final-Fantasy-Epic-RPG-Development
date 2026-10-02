library TBlackPearl
function Trig_BlackPearl_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$B9 // $B9 = 185
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_BlackPearl takes nothing returns nothing
endfunction

function RegisterR11_BlackPearl_Death takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_BlackPearl_Death=CreateTrigger()

call TriggerAddAction(gg_trg_BlackPearl_Death,function Trig_BlackPearl_Death_Actions)

endfunction




endlibrary

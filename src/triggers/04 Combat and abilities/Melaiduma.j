library TMelaiduma requires TMusic
function Trig_Melaiduma_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call Music_ClearTrack(37)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$B1 // $B1 = 177
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Melaiduma takes nothing returns nothing
endfunction
function RegisterR11_Melaiduma_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Melaiduma_Death=CreateTrigger()
    call TriggerAddAction(gg_trg_Melaiduma_Death,function Trig_Melaiduma_Death_Actions)
endfunction




endlibrary

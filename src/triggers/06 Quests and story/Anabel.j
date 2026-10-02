library TAnabel
function Trig_Anabel_Appear_Actions takes nothing returns nothing
    set udg_SeaKingQuestStarted=true
    call RemoveItemFromStockBJ('I0HB',gg_unit_n02Y_0052) // 'I0HB': item "Information: Fishing"
    call SetUnitFacingTimed(gg_unit_n0AV_0247,270.,.2)
    set udg_SpecialEffect[68]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0AV_0247,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_NebraAngler_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Anabel takes nothing returns nothing
endfunction
function RegisterR11_Anabel_Appear takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Anabel_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_Anabel_Appear)
    call TriggerAddAction(gg_trg_Anabel_Appear,function Trig_Anabel_Appear_Actions)
endfunction




endlibrary

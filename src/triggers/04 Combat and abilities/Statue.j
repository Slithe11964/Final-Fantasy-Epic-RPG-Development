library TStatue
function Trig_Statue_Keeper_Anim_Actions takes nothing returns nothing
    call SetDoodadAnimationRectBJ("stand alternate",'AOks',gg_rct_448) // 'AOks': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Statue_Guardian_Anim_Actions takes nothing returns nothing
    call SetDoodadAnimationRectBJ("stand alternate",'AOgs',gg_rct_449) // 'AOgs': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Statue takes nothing returns nothing
endfunction
function RegisterR11_Statue_Keeper_Anim takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Statue_Keeper_Anim=CreateTrigger()
    call TriggerAddAction(gg_trg_Statue_Keeper_Anim,function Trig_Statue_Keeper_Anim_Actions)
endfunction
function RegisterR11_Statue_Guardian_Anim takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Statue_Guardian_Anim=CreateTrigger()
    call TriggerAddAction(gg_trg_Statue_Guardian_Anim,function Trig_Statue_Guardian_Anim_Actions)
endfunction




endlibrary

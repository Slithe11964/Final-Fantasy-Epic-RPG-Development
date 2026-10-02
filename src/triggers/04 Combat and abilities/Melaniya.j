library TMelaniya requires TGroup
function Trig_Melaniya_Setup_Enum_HideGuard takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),true)
endfunction

function Trig_Melaniya_Setup_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("chest",gg_unit_n01S_0082,"Abilities\\Spells\\Undead\\AntiMagicShell\\AntiMagicShell.mdl")
    set udg_SpecialEffect[45]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01S_0082,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_HideoutGuards=Group_UnitsInRectOfPlayer(gg_rct_404,Player($B)) // $B = 11
    call ForGroupBJ(udg_HideoutGuards,function Trig_Melaniya_Setup_Enum_HideGuard)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Melaniya takes nothing returns nothing
endfunction

function RegisterR11_Melaniya_Setup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Melaniya_Setup=CreateTrigger()

call TriggerAddAction(gg_trg_Melaniya_Setup,function Trig_Melaniya_Setup_Actions)

endfunction




endlibrary

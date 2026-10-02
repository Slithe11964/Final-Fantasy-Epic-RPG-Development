library TBarrens
function Trig_Barrens_Forge_Setup_Actions takes nothing returns nothing
    set udg_SpecialEffect[87]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00R_0256,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_KalmTechLevel=0
    call SetDestructableInvulnerableBJ(gg_dest_ITx3_0033,true)
    call SetDestructableInvulnerableBJ(gg_dest_ITx1_0022,true)
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0070,true)
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0071,true)
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0042,true)
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0031,true)
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0069,true)
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0032,true)
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0029,true)
    call ShowDestructableBJ(false,gg_dest_LOcg_0070)
    call ShowDestructableBJ(false,gg_dest_LOcg_0071)
    call ShowDestructableBJ(false,gg_dest_LOcg_0042)
    call ShowDestructableBJ(false,gg_dest_LOcg_0031)
    call ShowDestructableBJ(false,gg_dest_LOcg_0032)
    call ShowDestructableBJ(false,gg_dest_LOcg_0029)
    call ShowUnitHide(gg_unit_n0MC_0265)
    call SetUnitInvulnerable(gg_unit_n0MC_0265,true)
    call PauseUnitBJ(true,gg_unit_n0MC_0265)
    call UnitAddAbilityBJ('Abun',gg_unit_n0MC_0265) // 'Abun': object name not found in map data
    call UnitAddAbilityBJ('A0VJ',gg_unit_n0MC_0265) // 'A0VJ': ability "Unaffected by Cinematics"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Barrens takes nothing returns nothing
endfunction

function RegisterR11_Barrens_Forge_Setup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Barrens_Forge_Setup=CreateTrigger()

call TriggerAddAction(gg_trg_Barrens_Forge_Setup,function Trig_Barrens_Forge_Setup_Actions)

endfunction




endlibrary

library TPromotion requires TJob, TPlayerPart01
function Trig_Promotion_Award_Random_Conditions takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)==1)
endfunction

function Trig_Promotion_Award_Random_Cond_NeedsPromotion takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))==3)and(IsPlayerInForce(udg_TempPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Promotion_Award_Random_Actions takes nothing returns nothing
    set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
    set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_TempPlayer))
    if(Trig_Promotion_Award_Random_Cond_NeedsPromotion())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_QuestForce[udg_TempInteger])
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_TempPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Promotion takes nothing returns nothing
endfunction
function RegisterR11_Promotion_Award_Random takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Promotion_Award_Random=CreateTrigger()
    call DisableTrigger(gg_trg_Promotion_Award_Random)
    call TriggerAddCondition(gg_trg_Promotion_Award_Random,Condition(function Trig_Promotion_Award_Random_Conditions))
    call TriggerAddAction(gg_trg_Promotion_Award_Random,function Trig_Promotion_Award_Random_Actions)
endfunction




endlibrary

library TPassive requires TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Passive_Bonus_Sync=null
endglobals

function Trig_Passive_Bonus_Sync_EarnsStrengthFeat takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1C8',Player_GetHero(GetEnumPlayer()))>=$B)and(GetHeroStatBJ(bj_HEROSTAT_STR,Player_GetHero(GetEnumPlayer()),true)>=$3E8)and(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(GetEnumPlayer()))==3)and(IsPlayerInForce(GetEnumPlayer(),udg_JobMasterForce[3])==false) // 'A1C8': ability "Strength Burst"; $B = 11; $3E8 = 1000; 'A02F': ability "Mastery"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyStr takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasStrBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A16N',Player_GetHero(GetEnumPlayer()))>0) // 'A16N': ability "Strength Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsStrBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1C8',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1C8') // 'A1C8': ability "Strength Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyAgi takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasAgiBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A16O',Player_GetHero(GetEnumPlayer()))>0) // 'A16O': ability "Agility Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsAgiBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1C9',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1C9') // 'A1C9': ability "Agility Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyInt takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasIntBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A16P',Player_GetHero(GetEnumPlayer()))>0) // 'A16P': ability "Intelligence Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsIntBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1CA',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1CA') // 'A1CA': ability "Intelligence Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyMove takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasMoveBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A006',Player_GetHero(GetEnumPlayer()))>0) // 'A006': ability "Move Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsMoveBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1E7',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1E7') // 'A1E7': ability "Move Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyAttackSpeed takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasAttackSpeedPassive takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A00V',Player_GetHero(GetEnumPlayer()))>0) // 'A00V': ability "Attack Speed Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsAttackSpeedBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1E6',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1E6') // 'A1E6': ability "Attack Speed Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyDamage takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasDamageBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QW',Player_GetHero(GetEnumPlayer()))>0) // 'A0QW': ability "Damage Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsDamageBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1E4',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1E4') // 'A1E4': ability "Damage Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyDefense takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasDefenseBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0EM',Player_GetHero(GetEnumPlayer()))>0) // 'A0EM': ability "Defense Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsDefenseBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1E5',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1E5') // 'A1E5': ability "Defense Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyHpRegen takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasHpRegenBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0TU',Player_GetHero(GetEnumPlayer()))>0) // 'A0TU': ability "HP Regeneration Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsHpRegenBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1E8',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1E8') // 'A1E8': ability "HP Regeneration Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasFrenzyMpRegen takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B08F')) // 'B08F': buff tooltip "Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasMpRegenBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A033',Player_GetHero(GetEnumPlayer()))>0) // 'A033': ability "MP Regeneration Bonus"
endfunction

function Trig_Passive_Bonus_Sync_NeedsMpRegenBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1E9',Player_GetHero(GetEnumPlayer()))>0)and(udg_JobSkill[udg_SubSkillSlot[GetConvertedPlayerId(GetEnumPlayer())]]!='A1E9') // 'A1E9': ability "MP Regeneration Burst"
endfunction

function Trig_Passive_Bonus_Sync_HasCompetitiveAura takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('S00L',Player_GetHero(GetEnumPlayer()))>0) // 'S00L': ability "Competitive Spirit"
endfunction

function Trig_Passive_Bonus_Sync_HasCompetitiveSpirit takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1EZ',Player_GetHero(GetEnumPlayer()))>0) // 'A1EZ': ability "Competitive Spirit"
endfunction

function Trig_Passive_Bonus_Sync_SyncPlayerPassives takes nothing returns nothing
    call GroupAddUnitSimple(Player_GetHero(GetEnumPlayer()),udg_ActiveHeroGroup)
    if(Trig_Passive_Bonus_Sync_NeedsStrBonus())then
        call UnitAddAbilityBJ('A16N',Player_GetHero(GetEnumPlayer())) // 'A16N': ability "Strength Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyStr())then
            call SetUnitAbilityLevelSwapped('A16N',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1C8',Player_GetHero(GetEnumPlayer()))*2)) // 'A16N': ability "Strength Bonus"; 'A1C8': ability "Strength Burst"
            if(Trig_Passive_Bonus_Sync_EarnsStrengthFeat())then
                call ForceAddPlayerSimple(GetEnumPlayer(),udg_JobMasterForce[3])
                call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
            endif
        else
            call SetUnitAbilityLevelSwapped('A16N',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1C8',Player_GetHero(GetEnumPlayer()))*1)) // 'A16N': ability "Strength Bonus"; 'A1C8': ability "Strength Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasStrBonus())then
            call UnitRemoveAbilityBJ('A16N',Player_GetHero(GetEnumPlayer())) // 'A16N': ability "Strength Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsAgiBonus())then
        call UnitAddAbilityBJ('A16O',Player_GetHero(GetEnumPlayer())) // 'A16O': ability "Agility Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyAgi())then
            call SetUnitAbilityLevelSwapped('A16O',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1C9',Player_GetHero(GetEnumPlayer()))*2)) // 'A16O': ability "Agility Bonus"; 'A1C9': ability "Agility Burst"
        else
            call SetUnitAbilityLevelSwapped('A16O',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1C9',Player_GetHero(GetEnumPlayer()))*1)) // 'A16O': ability "Agility Bonus"; 'A1C9': ability "Agility Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasAgiBonus())then
            call UnitRemoveAbilityBJ('A16O',Player_GetHero(GetEnumPlayer())) // 'A16O': ability "Agility Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsIntBonus())then
        call UnitAddAbilityBJ('A16P',Player_GetHero(GetEnumPlayer())) // 'A16P': ability "Intelligence Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyInt())then
            call SetUnitAbilityLevelSwapped('A16P',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1CA',Player_GetHero(GetEnumPlayer()))*2)) // 'A16P': ability "Intelligence Bonus"; 'A1CA': ability "Intelligence Burst"
        else
            call SetUnitAbilityLevelSwapped('A16P',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1CA',Player_GetHero(GetEnumPlayer()))*1)) // 'A16P': ability "Intelligence Bonus"; 'A1CA': ability "Intelligence Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasIntBonus())then
            call UnitRemoveAbilityBJ('A16P',Player_GetHero(GetEnumPlayer())) // 'A16P': ability "Intelligence Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsMoveBonus())then
        call UnitAddAbilityBJ('A006',Player_GetHero(GetEnumPlayer())) // 'A006': ability "Move Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyMove())then
            call SetUnitAbilityLevelSwapped('A006',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E7',Player_GetHero(GetEnumPlayer()))*2)) // 'A006': ability "Move Bonus"; 'A1E7': ability "Move Burst"
        else
            call SetUnitAbilityLevelSwapped('A006',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E7',Player_GetHero(GetEnumPlayer()))*1)) // 'A006': ability "Move Bonus"; 'A1E7': ability "Move Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasMoveBonus())then
            call UnitRemoveAbilityBJ('A006',Player_GetHero(GetEnumPlayer())) // 'A006': ability "Move Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsAttackSpeedBonus())then
        call UnitAddAbilityBJ('A00V',Player_GetHero(GetEnumPlayer())) // 'A00V': ability "Attack Speed Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyAttackSpeed())then
            call SetUnitAbilityLevelSwapped('A00V',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E6',Player_GetHero(GetEnumPlayer()))*2)) // 'A00V': ability "Attack Speed Bonus"; 'A1E6': ability "Attack Speed Burst"
        else
            call SetUnitAbilityLevelSwapped('A00V',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E6',Player_GetHero(GetEnumPlayer()))*1)) // 'A00V': ability "Attack Speed Bonus"; 'A1E6': ability "Attack Speed Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasAttackSpeedPassive())then
            call UnitRemoveAbilityBJ('A00V',Player_GetHero(GetEnumPlayer())) // 'A00V': ability "Attack Speed Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsDamageBonus())then
        call UnitAddAbilityBJ('A0QW',Player_GetHero(GetEnumPlayer())) // 'A0QW': ability "Damage Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyDamage())then
            call SetUnitAbilityLevelSwapped('A0QW',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E4',Player_GetHero(GetEnumPlayer()))*2)) // 'A0QW': ability "Damage Bonus"; 'A1E4': ability "Damage Burst"
        else
            call SetUnitAbilityLevelSwapped('A0QW',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E4',Player_GetHero(GetEnumPlayer()))*1)) // 'A0QW': ability "Damage Bonus"; 'A1E4': ability "Damage Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasDamageBonus())then
            call UnitRemoveAbilityBJ('A0QW',Player_GetHero(GetEnumPlayer())) // 'A0QW': ability "Damage Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsDefenseBonus())then
        call UnitAddAbilityBJ('A0EM',Player_GetHero(GetEnumPlayer())) // 'A0EM': ability "Defense Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyDefense())then
            call SetUnitAbilityLevelSwapped('A0EM',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E5',Player_GetHero(GetEnumPlayer()))*2)) // 'A0EM': ability "Defense Bonus"; 'A1E5': ability "Defense Burst"
        else
            call SetUnitAbilityLevelSwapped('A0EM',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E5',Player_GetHero(GetEnumPlayer()))*1)) // 'A0EM': ability "Defense Bonus"; 'A1E5': ability "Defense Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasDefenseBonus())then
            call UnitRemoveAbilityBJ('A0EM',Player_GetHero(GetEnumPlayer())) // 'A0EM': ability "Defense Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsHpRegenBonus())then
        call UnitAddAbilityBJ('A0TU',Player_GetHero(GetEnumPlayer())) // 'A0TU': ability "HP Regeneration Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyHpRegen())then
            call SetUnitAbilityLevelSwapped('A0TU',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E8',Player_GetHero(GetEnumPlayer()))*2)) // 'A0TU': ability "HP Regeneration Bonus"; 'A1E8': ability "HP Regeneration Burst"
        else
            call SetUnitAbilityLevelSwapped('A0TU',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E8',Player_GetHero(GetEnumPlayer()))*1)) // 'A0TU': ability "HP Regeneration Bonus"; 'A1E8': ability "HP Regeneration Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasHpRegenBonus())then
            call UnitRemoveAbilityBJ('A0TU',Player_GetHero(GetEnumPlayer())) // 'A0TU': ability "HP Regeneration Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_NeedsMpRegenBonus())then
        call UnitAddAbilityBJ('A033',Player_GetHero(GetEnumPlayer())) // 'A033': ability "MP Regeneration Bonus"
        if(Trig_Passive_Bonus_Sync_HasFrenzyMpRegen())then
            call SetUnitAbilityLevelSwapped('A033',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E9',Player_GetHero(GetEnumPlayer()))*2)) // 'A033': ability "MP Regeneration Bonus"; 'A1E9': ability "MP Regeneration Burst"
        else
            call SetUnitAbilityLevelSwapped('A033',Player_GetHero(GetEnumPlayer()),(GetUnitAbilityLevelSwapped('A1E9',Player_GetHero(GetEnumPlayer()))*1)) // 'A033': ability "MP Regeneration Bonus"; 'A1E9': ability "MP Regeneration Burst"
        endif
    else
        if(Trig_Passive_Bonus_Sync_HasMpRegenBonus())then
            call UnitRemoveAbilityBJ('A033',Player_GetHero(GetEnumPlayer())) // 'A033': ability "MP Regeneration Bonus"
        endif
    endif
    if(Trig_Passive_Bonus_Sync_HasCompetitiveSpirit())then
        call UnitAddAbilityBJ('S00L',Player_GetHero(GetEnumPlayer())) // 'S00L': ability "Competitive Spirit"
    else
        if(Trig_Passive_Bonus_Sync_HasCompetitiveAura())then
            call UnitRemoveAbilityBJ('S00L',Player_GetHero(GetEnumPlayer())) // 'S00L': ability "Competitive Spirit"
        endif
    endif
    set udg_CurrentHero=Player_GetHero(GetEnumPlayer())
    call ConditionalTriggerExecute(gg_trg_AttackSpeed_Update)
    call ConditionalTriggerExecute(gg_trg_MagicDefense_Calc)
endfunction

function Trig_Passive_Bonus_Sync_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Passive_Bonus_Sync_SyncPlayerPassives)
    call StartTimerBJ(udg_StatsRefreshTimer,false,2.)
    call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
endfunction

// World Editor calls InitTrig_Passive automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Passive (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Passive takes nothing returns nothing
endfunction

function Register_Passive_Bonus_Sync takes nothing returns nothing
    set gg_trg_Passive_Bonus_Sync=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Passive_Bonus_Sync,udg_StatsRefreshTimer)
    call TriggerAddAction(gg_trg_Passive_Bonus_Sync,function Trig_Passive_Bonus_Sync_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Passive takes nothing returns nothing
    call Register_Passive_Bonus_Sync()
endfunction

endlibrary

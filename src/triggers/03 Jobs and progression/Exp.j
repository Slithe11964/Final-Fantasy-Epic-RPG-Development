library TExp requires TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Exp_Distribution=null
    // Variables only this module uses.
    real udg_ExpAmount=0
    location udg_TempPoint4=null
    real udg_ExpBase=0
    integer udg_PlayerIndex=0
endglobals

function Trig_Exp_Distribution_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_STRUCTURE)==false)and(IsUnitIllusionBJ(GetTriggerUnit())==false)and(GetUnitAbilityLevelSwapped('A0QY',GetTriggerUnit())<=0)and(GetKillingUnitBJ()!=null)and(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers)))!=null // 'A0QY': ability "Devalued"
endfunction

function Trig_Exp_Distribution_UseScaledBaseExp takes nothing returns boolean
    return(udg_EternityMode)and(GetUnitLevel(GetTriggerUnit())<60)
endfunction

function Trig_Exp_Distribution_IsEliteTarget takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))or(IsUnitType(GetTriggerUnit(),UNIT_TYPE_RESISTANT))or(IsUnitInGroup(GetTriggerUnit(),udg_CupArenaUnits)))!=null
endfunction

function Trig_Exp_Distribution_IsElite takes nothing returns boolean
    return(Trig_Exp_Distribution_IsEliteTarget())
endfunction

function Trig_Exp_Distribution_HasExpAura takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('S00L',GetKillingUnitBJ())>0)or(UnitHasBuffBJ(GetKillingUnitBJ(),'B071')) // 'S00L': ability "Competitive Spirit"; 'B071': buff tooltip "Competition"
endfunction

function Trig_Exp_Distribution_HasExpBonusAura takes nothing returns boolean
    return(Trig_Exp_Distribution_HasExpAura())
endfunction

function Trig_Exp_Distribution_NearTempUnit takes nothing returns boolean
    // The straight-line distance between udg_TempPoint3 and udg_TempPoint4.
    return(DistanceBetweenPoints(udg_TempPoint3,udg_TempPoint4)<=udg_ExpShareRange)
endfunction

function Trig_Exp_Distribution_TempUnitIsNeutral takes nothing returns boolean
    return(GetOwningPlayer(udg_ShadowUnit)==Player($A)) // $A = 10
endfunction

function Trig_Exp_Distribution_HasComboBonus takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_TitleForce[2]))
endfunction

function Trig_Exp_Distribution_ComboAwardReady takes nothing returns boolean
    return(udg_ComboCount>=20)and(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_JobMasterForce[6])==false)and(GetUnitAbilityLevelSwapped('A02F',GetKillingUnitBJ())==3) // 'A02F': ability "Mastery"
endfunction

function Trig_Exp_Distribution_IsComboKill takes nothing returns boolean
    return(GetKillingUnitBJ()==udg_ComboUnit)and(TimerGetRemaining(udg_ComboTimer)>.0)
endfunction

function Trig_Exp_Distribution_IsTechFinishKill takes nothing returns boolean
    return(GetKillingUnitBJ()==Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())))and(TimerGetRemaining(udg_RangedShotTimer[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])>.0)
endfunction

function Trig_Exp_Distribution_IsLowExpTarget takes nothing returns boolean
    return((GetUnitAbilityLevelSwapped('A0ZU',GetTriggerUnit())>0)or(IsUnitType(GetTriggerUnit(),UNIT_TYPE_SUMMONED)))!=null // 'A0ZU': ability "Double Vulnerable"
endfunction

function Trig_Exp_Distribution_UseScaledLowExp takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Exp_Distribution_UseScaledNormalExp takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Exp_Distribution_GivesLowExp takes nothing returns boolean
    return(Trig_Exp_Distribution_IsLowExpTarget())
endfunction

function Trig_Exp_Distribution_HasIntExpBonus takes nothing returns boolean
    return(IsPlayerInForce(ConvertedPlayer(udg_PlayerIndex),udg_TitleForce[5]))
endfunction

function Trig_Exp_Distribution_IsKillerPlayer takes nothing returns boolean
    return(GetOwningPlayer(GetKillingUnitBJ())==ConvertedPlayer(udg_PlayerIndex))
endfunction

function Trig_Exp_Distribution_IsKillerHero takes nothing returns boolean
    return(GetKillingUnitBJ()==Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))
endfunction

function Trig_Exp_Distribution_HeroHasRoar takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(ConvertedPlayer(udg_PlayerIndex)),'B071')) // 'B071': buff tooltip "Competition"
endfunction

function Trig_Exp_Distribution_HasGrowthAura takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0O7',Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))>0)or(UnitHasBuffBJ(Player_GetHero(ConvertedPlayer(udg_PlayerIndex)),'B04X')) // 'A0O7': ability "Auto-Growth"; 'B04X': buff "Growth"
endfunction

function Trig_Exp_Distribution_HasGrowth takes nothing returns boolean
    return(Trig_Exp_Distribution_HasGrowthAura())
endfunction

function Trig_Exp_Distribution_HeroAtMaxLevel takes nothing returns boolean
    return(GetHeroLevel(udg_SpiritOfGaya[udg_PlayerIndex])>=99)
endfunction

function Trig_Exp_Distribution_HeroAtMaxLevelBank takes nothing returns boolean
    return(GetHeroLevel(udg_SpiritOfGaya[udg_PlayerIndex])>=99)
endfunction

function Trig_Exp_Distribution_ExpBankFull takes nothing returns boolean
    return(udg_BankedXP[udg_PlayerIndex]>500000.)
endfunction

function Trig_Exp_Distribution_CanGainExp takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A14Q',Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))<=0) // 'A14Q': ability "Pointless"
endfunction

function Trig_Exp_Distribution_HeroInExpRange takes nothing returns boolean
    // The straight-line distance between udg_TempPoint3 and udg_TempPoint4.
    return(DistanceBetweenPoints(udg_TempPoint3,udg_TempPoint4)<=udg_ExpShareRange)
endfunction

function Trig_Exp_Distribution_IsActivePlayer takes nothing returns boolean
    return(IsPlayerInForce(ConvertedPlayer(udg_PlayerIndex),udg_PlayingPlayers))
endfunction

function Trig_Exp_Distribution_Actions takes nothing returns nothing
    call ConditionalTriggerExecute(gg_trg_Job_XP_Handicap)
    if(Trig_Exp_Distribution_UseScaledBaseExp())then
        // Eternity mode below level 60: base XP = 5 x (enemy level + 40) + 15.
        set udg_ExpBase=(((I2R((GetUnitLevel(GetTriggerUnit())+40))*25.)/ 5.)+15.)
    else
        // Normal base XP = enemy level x 25 / 3 + 15. This division keeps decimals.
        set udg_ExpBase=(((I2R(GetUnitLevel(GetTriggerUnit()))*25.)/ 3.)+15.)
    endif
    if(Trig_Exp_Distribution_IsElite())then
        // Elite enemies give 2.5 times the base XP: 100 becomes 250.
        set udg_ExpBase=(udg_ExpBase*2.5)
    endif
    if(Trig_Exp_Distribution_HasExpBonusAura())then
        // The XP aura adds 50% of the current base. Multipliers apply one after another, not by adding percentages.
        set udg_ExpBase=(udg_ExpBase*1.5)
    endif
    set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
    if(Trig_Exp_Distribution_TempUnitIsNeutral())then
        set udg_TempPoint4=GetUnitLoc(udg_ShadowUnit)
        if(Trig_Exp_Distribution_NearTempUnit())then
            // (udg_ExpBase) times (0.5).
            set udg_ExpBase=(udg_ExpBase*.5)
        endif
        call RemoveLocation(udg_TempPoint4)
    endif
    if(Trig_Exp_Distribution_IsTechFinishKill())then
        if(Trig_Exp_Distribution_HasComboBonus())then
            // (udg_ExpBase) times (2).
            set udg_ExpBase=(udg_ExpBase*2.)
        else
            // (udg_ExpBase) times (1.4).
            set udg_ExpBase=(udg_ExpBase*1.4)
        endif
        call CreateTextTagLocBJ("Tech Finish!",udg_TempPoint3,0,12.,.0,'d',100.,.0)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),128.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.1)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),.1)
        if(Trig_Exp_Distribution_IsComboKill())then
            set udg_ComboAwarded=true
            if(Trig_Exp_Distribution_ComboAwardReady())then
                call ForceAddPlayerSimple(GetOwningPlayer(GetKillingUnitBJ()),udg_JobMasterForce[6])
                call AddSpecialEffectTargetUnitBJ("origin",GetKillingUnitBJ(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
            endif
        endif
    endif
    set udg_PlayerIndex=1
    loop
        exitwhen udg_PlayerIndex>8
        if(Trig_Exp_Distribution_IsActivePlayer())then
            set udg_TempPoint4=GetUnitLoc(Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))
            if(Trig_Exp_Distribution_HeroInExpRange())then
                if(Trig_Exp_Distribution_GivesLowExp())then
                    if(Trig_Exp_Distribution_UseScaledLowExp())then
                        // Low-XP target in Eternity mode: multiply base XP by [0.3 x (enemy level + 60) + 20] / (hero level + 40).
                        // A larger hero level in the bottom of the fraction reduces the reward for the same enemy.
                        set udg_ExpAmount=(udg_ExpBase*(((I2R((GetUnitLevel(GetTriggerUnit())+60))*.3)+20.)/ I2R((GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))+40))))
                    else
                        // Low-XP target: multiply base XP by (0.5 x enemy level + 20) / (hero level + 40).
                        set udg_ExpAmount=(udg_ExpBase*(((I2R(GetUnitLevel(GetTriggerUnit()))*.5)+20.)/ I2R((GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))+40))))
                    endif
                else
                    if(Trig_Exp_Distribution_UseScaledNormalExp())then
                        // Normal target in Eternity mode: multiply base XP by [0.81 x (enemy level + 60) + 25] / (hero level + 25).
                        set udg_ExpAmount=(udg_ExpBase*(((I2R((GetUnitLevel(GetTriggerUnit())+60))*.81)+25.)/ I2R((GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))+25))))
                    else
                        // Normal target: multiply base XP by (1.3 x enemy level + 25) / (hero level + 25).
                        set udg_ExpAmount=(udg_ExpBase*(((I2R(GetUnitLevel(GetTriggerUnit()))*1.3)+25.)/ I2R((GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_PlayerIndex)))+25))))
                    endif
                endif
                if(Trig_Exp_Distribution_HasIntExpBonus())then
                    // With the Intelligence-XP title, every 5 Intelligence adds 1% to the current reward.
                    // For example, 100 Intelligence multiplies XP by 1.2, giving 20% more.
                    set udg_ExpAmount=(udg_ExpAmount*(1+(I2R(GetHeroStatBJ(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_PlayerIndex)),true))/ 500.)))
                else
                    // Without that title, every 10 Intelligence adds 1% to the current reward.
                    set udg_ExpAmount=(udg_ExpAmount*(1+(I2R(GetHeroStatBJ(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_PlayerIndex)),true))/ 1000.)))
                endif
                if(Trig_Exp_Distribution_IsKillerHero())then
                    // (udg_ExpAmount) times (1.5).
                    set udg_ExpAmount=(udg_ExpAmount*1.5)
                else
                    if(Trig_Exp_Distribution_IsKillerPlayer())then
                        // (udg_ExpAmount) times (1.35).
                        set udg_ExpAmount=(udg_ExpAmount*1.35)
                    endif
                endif
                if(Trig_Exp_Distribution_HeroHasRoar())then
                    // (udg_ExpAmount) times (1.3).
                    set udg_ExpAmount=(udg_ExpAmount*1.3)
                endif
                if(Trig_Exp_Distribution_HasGrowth())then
                    // (udg_ExpAmount) times (1.5).
                    set udg_ExpAmount=(udg_ExpAmount*1.5)
                endif
                // Convert the player XP percentage to a multiplier: 100% becomes 1; 50% becomes 0.5.
                set udg_ExpAmount=(udg_ExpAmount*(GetPlayerHandicapXPBJ(ConvertedPlayer(udg_PlayerIndex))*.01))
                if(Trig_Exp_Distribution_CanGainExp())then
                    if(Trig_Exp_Distribution_HeroAtMaxLevel())then
                        // When the secondary hero is level 99 or higher, give the main hero 20% extra XP.
                        // R2I drops the decimal part rather than rounding to the nearest whole number.
                        call AddHeroXPSwapped(R2I((udg_ExpAmount*1.2)),Player_GetHero(ConvertedPlayer(udg_PlayerIndex)),true)
                    else
                        // ((udg_ExpAmount) times (udg_SecondaryXPRate)) with its decimal part removed.
                        call AddHeroXPSwapped(R2I((udg_ExpAmount*udg_SecondaryXPRate)),udg_SpiritOfGaya[udg_PlayerIndex],true)
                        // (udg_ExpAmount) with its decimal part removed.
                        call AddHeroXPSwapped(R2I(udg_ExpAmount),Player_GetHero(ConvertedPlayer(udg_PlayerIndex)),true)
                    endif
                else
                    if(Trig_Exp_Distribution_HeroAtMaxLevelBank())then
                        // (udg_BankedXP at position udg_PlayerIndex) plus ((udg_ExpAmount) times (1.2)).
                        set udg_BankedXP[udg_PlayerIndex]=(udg_BankedXP[udg_PlayerIndex]+(udg_ExpAmount*1.2))
                    else
                        // (udg_BankedXP at position udg_PlayerIndex) plus (udg_ExpAmount).
                        set udg_BankedXP[udg_PlayerIndex]=(udg_BankedXP[udg_PlayerIndex]+udg_ExpAmount)
                    endif
                    if(Trig_Exp_Distribution_ExpBankFull())then
                        // Cap stored XP at 500,000; any amount above that limit is discarded.
                        set udg_BankedXP[udg_PlayerIndex]=500000.
                    else
                        call StartTimerBJ(udg_ExpBankTimer[udg_PlayerIndex],false,.01)
                    endif
                endif
            endif
            call RemoveLocation(udg_TempPoint4)
        endif
        set udg_PlayerIndex=udg_PlayerIndex+1
    endloop
    call RemoveLocation(udg_TempPoint3)
endfunction

// World Editor calls InitTrig_Exp automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Exp (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Exp takes nothing returns nothing
endfunction

function Register_Exp_Distribution takes nothing returns nothing
    set gg_trg_Exp_Distribution=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Exp_Distribution,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Exp_Distribution,Condition(function Trig_Exp_Distribution_Conditions))
    call TriggerAddAction(gg_trg_Exp_Distribution,function Trig_Exp_Distribution_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Exp takes nothing returns nothing
    call Register_Exp_Distribution()
endfunction

endlibrary

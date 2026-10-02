library TBossJudges requires TCam, TCine, TDifficulty, TJob, TLoc, TMusic, TPlayerPart01, TText, TWait
function Trig_Boss_Judges_Summon_FirstEncounter takes nothing returns boolean
    return(udg_RingHintUsed[3]==false)
endfunction

function Trig_Boss_Judges_Summon_ActivateJudge takes nothing returns nothing
    call SetUnitLifePercentBJ(GetEnumUnit(),'d')
    call SetUnitManaPercentBJ(GetEnumUnit(),'d')
    call UnitAddItemByIdSwapped('I03P',GetEnumUnit()) // 'I03P': item "Megalixir"
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call PauseUnitBJ(false,GetEnumUnit())
    call GroupAddUnitSimple(GetEnumUnit(),udg_BossGroup)
    call TriggerRegisterUnitLifeEvent(gg_trg_Boss_Judges_UseMegalixir,GetEnumUnit(),LESS_THAN,10000.)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Judges_Death,GetEnumUnit(),EVENT_UNIT_DEATH)
endfunction

function Trig_Boss_Judges_Summon_Actions takes nothing returns nothing
    set udg_BossCleanupTrigger=gg_trg_Boss_Judges_Cleanup
    call Cine_Enter()
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    // (udg_EnemyHandicap) divided by (GetPlayerHandicapBJ(Player(11))).
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_639)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'N03R',Player($B),udg_TempPoint,180.) // 'N03R': unit "Judge Magister"; $B = 11
    set udg_JudgeGabranth=GetLastCreatedUnit()
    call Cam_PanToUnit(GetLastCreatedUnit(),0)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_JudgeGroup)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetHeroLevelBJ(GetLastCreatedUnit(),90,false)
    call UnitAddItemByIdSwapped('I0D6',GetLastCreatedUnit()) // 'I0D6': item "Innocence"
    call UnitAddItemByIdSwapped('I0D7',GetLastCreatedUnit()) // 'I0D7': item "Guilt"
    call UnitAddItemByIdSwapped('I0D4',GetLastCreatedUnit()) // 'I0D4': item "Helm of Divine Judgement"
    call UnitAddItemByIdSwapped('I0BX',GetLastCreatedUnit()) // 'I0BX': item "Grand Armor"
    call UnitAddItemByIdSwapped('I08R',GetLastCreatedUnit()) // 'I08R': item "Pocket of Chemist's Elixirs"
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,100.)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'N03P',Player($B),udg_TempPoint2,180.) // 'N03P': unit "Judge Magister"; $B = 11
    set udg_JudgeBergan=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_JudgeGroup)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetHeroLevelBJ(GetLastCreatedUnit(),87,false)
    call UnitAddItemByIdSwapped('I0D8',GetLastCreatedUnit()) // 'I0D8': item "Nethicite Blade"
    call UnitAddItemByIdSwapped('I0D9',GetLastCreatedUnit()) // 'I0D9': item "Kiltias Slayer"
    call UnitAddItemByIdSwapped('I0D4',GetLastCreatedUnit()) // 'I0D4': item "Helm of Divine Judgement"
    call UnitAddItemByIdSwapped('I0BX',GetLastCreatedUnit()) // 'I0BX': item "Grand Armor"
    call UnitAddItemByIdSwapped('I0DR',GetLastCreatedUnit()) // 'I0DR': item "Cameo Belt"
    set udg_TempPoint=OffsetLocation(udg_TempPoint2,100.,100.)
    call RemoveLocation(udg_TempPoint2)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'N03Q',Player($B),udg_TempPoint,180.) // 'N03Q': unit "Judge Magister"; $B = 11
    set udg_JudgeZargabaath=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_JudgeGroup)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetHeroLevelBJ(GetLastCreatedUnit(),88,false)
    call UnitAddItemByIdSwapped('I0DD',GetLastCreatedUnit()) // 'I0DD': item "Archadian Axe"
    call UnitAddItemByIdSwapped('I0DC',GetLastCreatedUnit()) // 'I0DC': item "Halberd of Truth"
    call UnitAddItemByIdSwapped('I0D4',GetLastCreatedUnit()) // 'I0D4': item "Helm of Divine Judgement"
    call UnitAddItemByIdSwapped('I0BX',GetLastCreatedUnit()) // 'I0BX': item "Grand Armor"
    call UnitAddItemByIdSwapped('I08R',GetLastCreatedUnit()) // 'I08R': item "Pocket of Chemist's Elixirs"
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_639)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,100.,-100.)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'N03N',Player($B),udg_TempPoint2,180.) // 'N03N': unit "Judge Magister"; $B = 11
    set udg_JudgeGhis=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_JudgeGroup)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetHeroLevelBJ(GetLastCreatedUnit(),86,false)
    call UnitAddItemByIdSwapped('I0DA',GetLastCreatedUnit()) // 'I0DA': item "Treacherous Sword"
    call UnitAddItemByIdSwapped('I0DB',GetLastCreatedUnit()) // 'I0DB': item "Razor Fan"
    call UnitAddItemByIdSwapped('I0D4',GetLastCreatedUnit()) // 'I0D4': item "Helm of Divine Judgement"
    call UnitAddItemByIdSwapped('I0BX',GetLastCreatedUnit()) // 'I0BX': item "Grand Armor"
    call UnitAddItemByIdSwapped('I0EP',GetLastCreatedUnit()) // 'I0EP': item "Pocket of Elixirs"
    set udg_TempPoint=OffsetLocation(udg_TempPoint2,100.,-100.)
    call RemoveLocation(udg_TempPoint2)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'N03O',Player($B),udg_TempPoint,180.) // 'N03O': unit "Judge Magister"; $B = 11
    set udg_JudgeDrace=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_JudgeGroup)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call SetHeroLevelBJ(GetLastCreatedUnit(),89,false)
    call UnitAddItemByIdSwapped('I0DE',GetLastCreatedUnit()) // 'I0DE': item "Staff of Justice"
    call UnitAddItemByIdSwapped('I0DF',GetLastCreatedUnit()) // 'I0DF': item "Final Sentence"
    call UnitAddItemByIdSwapped('I0D4',GetLastCreatedUnit()) // 'I0D4': item "Helm of Divine Judgement"
    call UnitAddItemByIdSwapped('I0BX',GetLastCreatedUnit()) // 'I0BX': item "Grand Armor"
    call UnitAddItemByIdSwapped('I08R',GetLastCreatedUnit()) // 'I08R': item "Pocket of Chemist's Elixirs"
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2.)
    if(Trig_Boss_Judges_Summon_FirstEncounter())then
        set udg_RingHintUsed[3]=true
        call Text_Transmission(udg_JudgeGabranth,"|cffff0000Judge Magisters|r","That helm is one of ours.","(null)",null,0,true)
        call Text_Transmission(udg_JudgeGabranth,"|cffff0000Judge Magisters|r","We can grant you the real deal, but are you worthy?","(null)",null,0,true)
        call Text_Transmission(udg_JudgeGabranth,"|cffff0000Judge Magisters|r","Then you must be able to defeat us in battle!","(null)",null,0,true)
        call Text_Transmission(udg_JudgeGabranth,"|cffff0000Judge Magisters|r","Let us begin!","(null)",null,0,true)
    endif
    call ForGroupBJ(udg_JudgeGroup,function Trig_Boss_Judges_Summon_ActivateJudge)
    call EnableTrigger(gg_trg_Boss_Judges_Gabranth_AI)
    call EnableTrigger(gg_trg_Boss_Judges_Ghis_AI)
    call EnableTrigger(gg_trg_Boss_Judges_Zargabaath_AI)
    call EnableTrigger(gg_trg_Boss_Judges_Drace_AI)
    call EnableTrigger(gg_trg_Boss_Judges_Death)
    call EnableTrigger(gg_trg_Boss_Judges_UseMegalixir)
    call Music_SetTrack(26)
    call StartTimerBJ(udg_JudgeTimer[1],false,5.)
    call StartTimerBJ(udg_JudgeTimer[2],false,7.5)
    call StartTimerBJ(udg_JudgeTimer[3],false,10.)
    call StartTimerBJ(udg_JudgeTimer[4],false,12.5)
    call ConditionalTriggerExecute(gg_trg_Boss_Judges_Ultimates)
    call Cine_Exit()
endfunction

function Trig_Boss_Judges_Ultimates_GhisAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeGhis,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Ultimates_DraceAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeDrace,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Ultimates_BerganAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeBergan,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Ultimates_ZargabaathAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeZargabaath,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Ultimates_GabranthAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeGabranth,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Ultimates_Actions takes nothing returns nothing
    call Wait_Polled(15.)
    if(Trig_Boss_Judges_Ultimates_GhisAlive())then
        call UnitAddAbilityBJ('A0WZ',udg_JudgeGhis) // 'A0WZ': ability "!Chain Magick"
        // (6) minus (CountUnitsInGroup(udg_JudgeGroup)).
        call SetUnitAbilityLevelSwapped('A0WZ',udg_JudgeGhis,(6-CountUnitsInGroup(udg_JudgeGroup))) // 'A0WZ': ability "!Chain Magick"
        call Wait_Polled(30.)
    endif
    if(Trig_Boss_Judges_Ultimates_DraceAlive())then
        call UnitAddAbilityBJ('A0X0',udg_JudgeDrace) // 'A0X0': ability "!Salvation"
        // (6) minus (CountUnitsInGroup(udg_JudgeGroup)).
        call SetUnitAbilityLevelSwapped('A0X0',udg_JudgeDrace,(6-CountUnitsInGroup(udg_JudgeGroup))) // 'A0X0': ability "!Salvation"
        call Wait_Polled(30.)
    endif
    if(Trig_Boss_Judges_Ultimates_BerganAlive())then
        call UnitAddAbilityBJ('A0WW',udg_JudgeBergan) // 'A0WW': ability "!Imperial Rage"
        // (6) minus (CountUnitsInGroup(udg_JudgeGroup)).
        call SetUnitAbilityLevelSwapped('A0WW',udg_JudgeBergan,(6-CountUnitsInGroup(udg_JudgeGroup))) // 'A0WW': ability "!Imperial Rage"
        call Wait_Polled(30.)
    endif
    if(Trig_Boss_Judges_Ultimates_ZargabaathAlive())then
        call UnitAddAbilityBJ('A0X1',udg_JudgeZargabaath) // 'A0X1': ability "!Intimidation"
        // (6) minus (CountUnitsInGroup(udg_JudgeGroup)).
        call SetUnitAbilityLevelSwapped('A0X1',udg_JudgeZargabaath,(6-CountUnitsInGroup(udg_JudgeGroup))) // 'A0X1': ability "!Intimidation"
        call Wait_Polled(30.)
    endif
    if(Trig_Boss_Judges_Ultimates_GabranthAlive())then
        call UnitAddAbilityBJ('A0WX',udg_JudgeGabranth) // 'A0WX': ability "!Sentence"
        // (6) minus (CountUnitsInGroup(udg_JudgeGroup)).
        call SetUnitAbilityLevelSwapped('A0WX',udg_JudgeGabranth,(6-CountUnitsInGroup(udg_JudgeGroup))) // 'A0WX': ability "!Sentence"
    endif
endfunction

function Trig_Boss_Judges_Ghis_AI_Conditions takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeGhis,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Ghis_AI_WasLowLastTick takes nothing returns boolean
    return(udg_GlyphActivated[1])
endfunction

function Trig_Boss_Judges_Ghis_AI_GhisWounded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_JudgeGhis, times 100 (or 0 if the unit is missing
    // or its maximum is 0).
    return(GetUnitLifePercent(udg_JudgeGhis)<50.)
endfunction

function Trig_Boss_Judges_Ghis_AI_Actions takes nothing returns nothing
    call StartTimerBJ(udg_JudgeTimer[1],false,5.)
    if(Trig_Boss_Judges_Ghis_AI_GhisWounded())then
        if(Trig_Boss_Judges_Ghis_AI_WasLowLastTick())then
            call UnitUseItemTarget(udg_JudgeGhis,GetItemOfTypeFromUnitBJ(udg_JudgeGhis,'I0EP'),udg_JudgeGhis) // 'I0EP': item "Pocket of Elixirs"
            set udg_GlyphActivated[1]=false
        else
            set udg_GlyphActivated[1]=true
        endif
    else
        set udg_GlyphActivated[1]=false
    endif
endfunction

function Trig_Boss_Judges_Gabranth_AI_Conditions takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeGabranth,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Gabranth_AI_ZargWasLowLastTick takes nothing returns boolean
    return(udg_GlyphActivated[2])
endfunction

function Trig_Boss_Judges_Gabranth_AI_ZargabaathWounded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_JudgeZargabaath, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(IsUnitInGroup(udg_JudgeZargabaath,udg_JudgeGroup))and(GetUnitLifePercent(udg_JudgeZargabaath)<50.)
endfunction

function Trig_Boss_Judges_Gabranth_AI_DraceWasLowLastTick takes nothing returns boolean
    return(udg_GlyphActivated[2])
endfunction

function Trig_Boss_Judges_Gabranth_AI_DraceWounded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_JudgeDrace, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(IsUnitInGroup(udg_JudgeDrace,udg_JudgeGroup))and(GetUnitLifePercent(udg_JudgeDrace)<50.)
endfunction

function Trig_Boss_Judges_Gabranth_AI_Actions takes nothing returns nothing
    call StartTimerBJ(udg_JudgeTimer[2],false,7.5)
    if(Trig_Boss_Judges_Gabranth_AI_DraceWounded())then
        if(Trig_Boss_Judges_Gabranth_AI_DraceWasLowLastTick())then
            call UnitUseItemTarget(udg_JudgeGabranth,GetItemOfTypeFromUnitBJ(udg_JudgeGabranth,'I08R'),udg_JudgeDrace) // 'I08R': item "Pocket of Chemist's Elixirs"
            set udg_GlyphActivated[2]=false
        else
            set udg_GlyphActivated[2]=true
        endif
    else
        if(Trig_Boss_Judges_Gabranth_AI_ZargabaathWounded())then
            if(Trig_Boss_Judges_Gabranth_AI_ZargWasLowLastTick())then
                call UnitUseItemTarget(udg_JudgeGabranth,GetItemOfTypeFromUnitBJ(udg_JudgeGabranth,'I08R'),udg_JudgeZargabaath) // 'I08R': item "Pocket of Chemist's Elixirs"
                set udg_GlyphActivated[2]=false
            else
                set udg_GlyphActivated[2]=true
            endif
        else
            set udg_GlyphActivated[2]=false
            call IssueImmediateOrderBJ(udg_JudgeGabranth,"stomp")
        endif
    endif
endfunction

function Trig_Boss_Judges_Zargabaath_AI_Conditions takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeZargabaath,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Zargabaath_AI_GabranthWasLowLastTick takes nothing returns boolean
    return(udg_GlyphActivated[3])
endfunction

function Trig_Boss_Judges_Zargabaath_AI_GabranthWounded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_JudgeGabranth, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(IsUnitInGroup(udg_JudgeGabranth,udg_JudgeGroup))and(GetUnitLifePercent(udg_JudgeGabranth)<50.)
endfunction

function Trig_Boss_Judges_Zargabaath_AI_DraceWasLowLastTick takes nothing returns boolean
    return(udg_GlyphActivated[3])
endfunction

function Trig_Boss_Judges_Zargabaath_AI_DraceWounded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_JudgeDrace, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(IsUnitInGroup(udg_JudgeDrace,udg_JudgeGroup))and(GetUnitLifePercent(udg_JudgeDrace)<50.)
endfunction

function Trig_Boss_Judges_Zargabaath_AI_Actions takes nothing returns nothing
    call StartTimerBJ(udg_JudgeTimer[3],false,7.5)
    if(Trig_Boss_Judges_Zargabaath_AI_DraceWounded())then
        if(Trig_Boss_Judges_Zargabaath_AI_DraceWasLowLastTick())then
            call UnitUseItemTarget(udg_JudgeZargabaath,GetItemOfTypeFromUnitBJ(udg_JudgeZargabaath,'I08R'),udg_JudgeDrace) // 'I08R': item "Pocket of Chemist's Elixirs"
            set udg_GlyphActivated[3]=false
        else
            set udg_GlyphActivated[3]=true
        endif
        return
    else
        if(Trig_Boss_Judges_Zargabaath_AI_GabranthWounded())then
            if(Trig_Boss_Judges_Zargabaath_AI_GabranthWasLowLastTick())then
                call UnitUseItemTarget(udg_JudgeZargabaath,GetItemOfTypeFromUnitBJ(udg_JudgeZargabaath,'I08R'),udg_JudgeGabranth) // 'I08R': item "Pocket of Chemist's Elixirs"
                set udg_GlyphActivated[3]=false
            else
                set udg_GlyphActivated[3]=true
            endif
        else
            set udg_GlyphActivated[3]=false
            call IssueImmediateOrderBJ(udg_JudgeZargabaath,"stomp")
        endif
    endif
endfunction

function Trig_Boss_Judges_Drace_AI_Conditions takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeDrace,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Drace_AI_HasBerserk takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B05V')) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_Boss_Judges_Drace_AI_DispelBerserk takes nothing returns nothing
    if(Trig_Boss_Judges_Drace_AI_HasBerserk())then
        call IssueTargetOrderBJ(udg_JudgeDrace,"innerfire",GetEnumUnit())
        return
    endif
endfunction

function Trig_Boss_Judges_Drace_AI_ZargWasLowLastTick takes nothing returns boolean
    return(udg_GlyphActivated[4])
endfunction

function Trig_Boss_Judges_Drace_AI_ZargabaathWounded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_JudgeZargabaath, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(IsUnitInGroup(udg_JudgeZargabaath,udg_JudgeGroup))and(GetUnitLifePercent(udg_JudgeZargabaath)<50.)
endfunction

function Trig_Boss_Judges_Drace_AI_GabranthWasLowLastTick takes nothing returns boolean
    return(udg_GlyphActivated[4])
endfunction

function Trig_Boss_Judges_Drace_AI_GabranthWounded takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_JudgeGabranth, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(IsUnitInGroup(udg_JudgeGabranth,udg_JudgeGroup))and(GetUnitLifePercent(udg_JudgeGabranth)<50.)
endfunction

function Trig_Boss_Judges_Drace_AI_Actions takes nothing returns nothing
    call StartTimerBJ(udg_JudgeTimer[4],false,7.5)
    if(Trig_Boss_Judges_Drace_AI_GabranthWounded())then
        if(Trig_Boss_Judges_Drace_AI_GabranthWasLowLastTick())then
            call UnitUseItemTarget(udg_JudgeDrace,GetItemOfTypeFromUnitBJ(udg_JudgeDrace,'I08R'),udg_JudgeGabranth) // 'I08R': item "Pocket of Chemist's Elixirs"
            set udg_GlyphActivated[4]=false
        else
            set udg_GlyphActivated[4]=true
        endif
    else
        if(Trig_Boss_Judges_Drace_AI_ZargabaathWounded())then
            if(Trig_Boss_Judges_Drace_AI_ZargWasLowLastTick())then
                call UnitUseItemTarget(udg_JudgeDrace,GetItemOfTypeFromUnitBJ(udg_JudgeDrace,'I08R'),udg_JudgeZargabaath) // 'I08R': item "Pocket of Chemist's Elixirs"
                set udg_GlyphActivated[4]=false
            else
                set udg_GlyphActivated[4]=true
            endif
        else
            set udg_GlyphActivated[4]=false
            call ForGroupBJ(udg_JudgeGroup,function Trig_Boss_Judges_Drace_AI_DispelBerserk)
            call IssueImmediateOrderBJ(udg_JudgeDrace,"tranquility")
        endif
    endif
endfunction

function Trig_Boss_Judges_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Death_ShouldRecordKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Judges_Death_CanMasterJob takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_SummonerPlayer))==3)and(IsPlayerInForce(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Boss_Judges_Death_SummonerIsPlayer takes nothing returns boolean
    return(udg_SummonerPlayer!=Player($B)) // $B = 11
endfunction

function Trig_Boss_Judges_Death_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Boss_Judges_Death_BerganAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeBergan,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Death_DraceAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeDrace,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Death_GabranthAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeGabranth,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Death_GhisAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeGhis,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Death_ZargabaathAlive takes nothing returns boolean
    return(IsUnitInGroup(udg_JudgeZargabaath,udg_JudgeGroup))
endfunction

function Trig_Boss_Judges_Death_JudgesRemain takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_JudgeGroup)==false)
endfunction

function Trig_Boss_Judges_Death_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I03P',udg_TempPoint) // 'I03P': item "Megalixir"
    call RemoveLocation(udg_TempPoint)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_JudgeGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    if(Trig_Boss_Judges_Death_JudgesRemain())then
        call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
        if(Trig_Boss_Judges_Death_BerganAlive())then
            call IncUnitAbilityLevelSwapped('A0WW',udg_JudgeBergan) // 'A0WW': ability "!Imperial Rage"
        endif
        if(Trig_Boss_Judges_Death_DraceAlive())then
            call IncUnitAbilityLevelSwapped('A0X0',udg_JudgeDrace) // 'A0X0': ability "!Salvation"
        endif
        if(Trig_Boss_Judges_Death_GabranthAlive())then
            call IncUnitAbilityLevelSwapped('A0WX',udg_JudgeGabranth) // 'A0WX': ability "!Sentence"
        endif
        if(Trig_Boss_Judges_Death_GhisAlive())then
            call IncUnitAbilityLevelSwapped('A0WZ',udg_JudgeGhis) // 'A0WZ': ability "!Chain Magick"
        endif
        if(Trig_Boss_Judges_Death_ZargabaathAlive())then
            call IncUnitAbilityLevelSwapped('A0X1',udg_JudgeZargabaath) // 'A0X1': ability "!Intimidation"
        endif
    else
        call DisableTrigger(GetTriggeringTrigger())
        if(Trig_Boss_Judges_Death_ShouldRecordKill())then
            set udg_BossUnit=null
            set udg_TempString="|cffff4040Judge Magisters|r defeated in "
            call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
        endif
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=5
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (72) times (loop counter A treated as a decimal-capable number).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(72.*I2R(GetForLoopIndexA())))
            call CreateItemLoc('I0D4',udg_TempPoint2) // 'I0D4': item "Helm of Divine Judgement"
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call Music_ClearTrack(26)
        call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
        if(Trig_Boss_Judges_Death_SummonerIsPlayer())then
            set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_SummonerPlayer))
            if(Trig_Boss_Judges_Death_CanMasterJob())then
                call ForceAddPlayerSimple(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])
                call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_SummonerPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
            endif
        endif
        if(Trig_Boss_Judges_Death_IsWaygateOpen())then
            call WaygateActivateBJ(true,gg_unit_n0AP_0240)
            set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
        endif
        call RemoveItem(udg_SummonItem)
        set udg_RingHintsReady=true
        call UnitRemoveAbilityBJ('A0HK',gg_unit_n03T_0008) // 'A0HK': ability "Judge's Helm Hint"
        call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Boss_Judges_UseMegalixir_Conditions takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I03P'))and(IsUnitInGroup(GetTriggerUnit(),udg_JudgeGroup)) // 'I03P': item "Megalixir"
endfunction

function Trig_Boss_Judges_UseMegalixir_Actions takes nothing returns nothing
    call UnitUseItem(GetTriggerUnit(),GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03P')) // 'I03P': item "Megalixir"
endfunction

function Trig_Boss_Judge_ImperialRage_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0WW') // 'A0WW': ability "!Imperial Rage"
endfunction

function Trig_Boss_Judge_ImperialRage_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("overhead",GetTriggerUnit(),"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitVertexColorBJ(GetTriggerUnit(),'d',.0,.0,0)
    call Wait_Polled(20.)
    call SetUnitVertexColorBJ(GetTriggerUnit(),40.,40.,40.,0)
endfunction

function Trig_Boss_Judge_Sentence_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0WX') // 'A0WX': ability "!Sentence"
endfunction

function Trig_Boss_Judge_Sentence_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(40000.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,5,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0WY',GetLastCreatedUnit()) // 'A0WY': ability "Sentence"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
endfunction

function Trig_Boss_Judge_ChainMagick_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0WZ') // 'A0WZ': ability "!Chain Magick"
endfunction

function Trig_Boss_Judge_ChainMagick_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0G0') // 'A0G0': ability "Virus"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0VL') // 'A0VL': ability "Scourge"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0TF') // 'A0TF': ability "Flare"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A1EU') // 'A1EU': ability "Mass Dispel"
    set udg_IsPureDamage=true
    set udg_DmgFlagPure=true
    set udg_DmgFlagManaDamage=true
    // (maximum mana of the triggering unit) divided by (10).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetTriggerUnit())/ 10.),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    call Wait_Polled(5.)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0G0') // 'A0G0': ability "Virus"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0VL') // 'A0VL': ability "Scourge"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0TF') // 'A0TF': ability "Flare"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A1EU') // 'A1EU': ability "Mass Dispel"
    set udg_IsPureDamage=true
    set udg_DmgFlagPure=true
    set udg_DmgFlagManaDamage=true
    // (maximum mana of the triggering unit) divided by (10).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetTriggerUnit())/ 10.),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    call Wait_Polled(5.)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0G0') // 'A0G0': ability "Virus"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0VL') // 'A0VL': ability "Scourge"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0TF') // 'A0TF': ability "Flare"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A1EU') // 'A1EU': ability "Mass Dispel"
    set udg_IsPureDamage=true
    set udg_DmgFlagPure=true
    set udg_DmgFlagManaDamage=true
    // (maximum mana of the triggering unit) divided by (10).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetTriggerUnit())/ 10.),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    call Wait_Polled(5.)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0G0') // 'A0G0': ability "Virus"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0VL') // 'A0VL': ability "Scourge"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0TF') // 'A0TF': ability "Flare"
    call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A1EU') // 'A1EU': ability "Mass Dispel"
    set udg_IsPureDamage=true
    set udg_DmgFlagPure=true
    set udg_DmgFlagManaDamage=true
    // (maximum mana of the triggering unit) divided by (10).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetTriggerUnit())/ 10.),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
endfunction

function Trig_Boss_Judges_Cleanup_RemoveJudge takes nothing returns nothing
    call GroupRemoveUnitSimple(GetEnumUnit(),udg_BossGroup)
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Boss_Judges_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Boss_Judges_Death)
    call ForGroupBJ(udg_JudgeGroup,function Trig_Boss_Judges_Cleanup_RemoveJudge)
    call GroupClear(udg_JudgeGroup)
    call Music_ClearTrack(26)
endfunction

function InitTrig_Boss_Judges takes nothing returns nothing
endfunction

endlibrary

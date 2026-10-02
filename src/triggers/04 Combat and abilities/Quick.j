library TQuick
function Trig_Quick_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0HO') // 'A0HO': ability "!Quick"
endfunction

function Trig_Quick_Cast_NotLastJobSlot takes nothing returns boolean
    return(GetForLoopIndexA()!=$E) // $E = 14
endfunction

function Trig_Quick_Cast_TargetIsPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetSpellTargetUnit()),udg_PlayingPlayers))
endfunction

function Trig_Quick_Cast_IsHeroTarget takes nothing returns boolean
    return(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Quick_Cast_Actions takes nothing returns nothing
    if(Trig_Quick_Cast_IsHeroTarget())then
        set bj_forLoopAIndex=0
        set bj_forLoopAIndexEnd=udg_JobCount
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),udg_JobExtraAbility[GetForLoopIndexA()])
            set bj_forLoopBIndex=1
            set bj_forLoopBIndexEnd=4
            loop
                exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
                // ((loop counter A) times (5)) plus (loop counter B).
                call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),udg_JobSkill[((GetForLoopIndexA()*5)+GetForLoopIndexB())])
                set bj_forLoopBIndex=bj_forLoopBIndex+1
            endloop
            if(Trig_Quick_Cast_NotLastJobSlot())then
                // ((loop counter A) times (5)) plus (5).
                call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),udg_JobSkill[((GetForLoopIndexA()*5)+5)])
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),'A0WS') // 'A0WS': ability "Fuma Shuriken"
        call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),'A1AJ') // 'A1AJ': ability "Alchemy"
        call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),'A1AI') // 'A1AI': ability "Alchemy"
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=6
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),udg_EnchantAbility[GetForLoopIndexA()])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$D // $D = 13
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call BlzEndUnitAbilityCooldown(GetSpellTargetUnit(),udg_BrewAbility[GetForLoopIndexA()])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        if(Trig_Quick_Cast_TargetIsPlayerUnit())then
            call BlzEndUnitAbilityCooldown(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],'A0B4') // 'A0B4': ability "Break Stun"
            call BlzEndUnitAbilityCooldown(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],'A02K') // 'A02K': ability "Mana Transfer"
            call BlzEndUnitAbilityCooldown(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],'A02L') // 'A02L': ability "Mega Heal"
            call BlzEndUnitAbilityCooldown(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],'A0P3') // 'A0P3': ability "House Portal"
            call BlzEndUnitAbilityCooldown(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],'A11U') // 'A11U': ability "Scan"
        endif
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

// World Editor calls InitTrig_Quick automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Quick (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Quick takes nothing returns nothing
endfunction

function Register_Quick_Cast takes nothing returns nothing
    set gg_trg_Quick_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quick_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Quick_Cast,Condition(function Trig_Quick_Cast_Conditions))
    call TriggerAddAction(gg_trg_Quick_Cast,function Trig_Quick_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Quick takes nothing returns nothing
    call Register_Quick_Cast()
endfunction

endlibrary

library TZiegfried requires TQuestEngine, TCam, TCine, TGroup, TLoc, TPlayerHero, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ziegfried_Mine_Arrive=null
    trigger gg_trg_Ziegfried_Advance_Order=null
    trigger gg_trg_Ziegfried_Attack_Fafnir=null
    trigger gg_trg_Ziegfried_Meltdown=null
    trigger gg_trg_Ziegfried_Confront=null
    trigger gg_trg_Ziegfried_Arena_Leash=null
endglobals

function Trig_Ziegfried_Mine_Arrive_NewsWindowOpen takes nothing returns boolean
    return(udg_GameDay<=20)
endfunction

function Trig_Ziegfried_Mine_Arrive_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItemFromStockBJ('I04U',gg_unit_n02Y_0052) // 'I04U': item "Information: Arcanium"
    call SetHeroLevelBJ(gg_unit_H036_0254,65,false)
    set l_tempPoint=GetRectCenter(gg_rct_684)
    call SetUnitPositionLocFacingBJ(gg_unit_H036_0254,l_tempPoint,110.)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_685)
    call CreateNUnitsAtLoc(1,'e01K',Player(8),l_tempPoint,140.) // 'e01K': unit "Viking Boat"
    call RemoveLocation(l_tempPoint)
    set udg_VikingBoat=GetLastCreatedUnit()
    call ExecuteFunc("QuestImperviousBeast_Available") // the "!" over Ziegfried; the Impervious Beast quest can start
    call PauseUnitBJ(false,gg_unit_H036_0254)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_H036_0254) // 'A0VJ': ability "Unaffected by Cinematics"
    if(Trig_Ziegfried_Mine_Arrive_NewsWindowOpen())then
        set udg_NewsText[3]=udg_NewsText[2]
        set udg_NewsText[2]=udg_NewsText[1]
        set udg_NewsText[6]=udg_NewsText[5]
        set udg_NewsText[5]=udg_NewsText[4]
        set udg_NewsText[1]="|cffffcc00Exclusive Interview with Bali Forgefire|r"
        set udg_NewsText[4]="Bali Forgefire, professional smith, has agreed to do an interview with Kalm News. When asked how he had managed to recreate the legendary Masamune blade, he answered: \"It's not too bad. You just need some Scarletite, Nethril and Dark Gems.\""
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Ziegfried_Advance_Order_Actions takes nothing returns nothing
    call IssuePointOrderLocBJ(gg_unit_H036_0254,"attack",udg_FafnirPatrolPoint[1])
endfunction

function Trig_Ziegfried_Attack_Fafnir_Actions takes nothing returns nothing
    call IssueTargetOrderBJ(gg_unit_H036_0254,"attack",udg_Fafnir)
endfunction

function Trig_Ziegfried_Meltdown_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A00T') // 'A00T': ability "!Meltdown"
endfunction

function Trig_Ziegfried_Meltdown_Wave1_RingIsCreep takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Ziegfried_Meltdown_Wave1_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Ziegfried_Meltdown_Wave1_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Ziegfried_Meltdown_Wave1_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave1_FilterAlive(),Trig_Ziegfried_Meltdown_Wave1_FilterEnemy())
endfunction

function Trig_Ziegfried_Meltdown_Wave1_FilterNotInvul takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Ziegfried_Meltdown_Wave1_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave1_FilterAliveEnemy(),Trig_Ziegfried_Meltdown_Wave1_FilterNotInvul())
endfunction

function Trig_Ziegfried_Meltdown_Wave1Alt_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Ziegfried_Meltdown_Wave1Alt_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Ziegfried_Meltdown_Wave1Alt_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave1Alt_FilterAlive(),Trig_Ziegfried_Meltdown_Wave1Alt_FilterEnemy())
endfunction

function Trig_Ziegfried_Meltdown_Wave1Alt_FilterNotInvul takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Ziegfried_Meltdown_Wave1Alt_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave1Alt_FilterAliveEnemy(),Trig_Ziegfried_Meltdown_Wave1Alt_FilterNotInvul())
endfunction

function Trig_Ziegfried_Meltdown_Wave1_PickIsCreep takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Ziegfried_Meltdown_EnumUnitAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetEnumUnit()))
endfunction

function Trig_Ziegfried_Meltdown_Wave1_DamageUnit takes nothing returns nothing
    set udg_DmgFlagUnavoidable=-1
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),20000.,true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL,null)
    if(Trig_Ziegfried_Meltdown_EnumUnitAlive())then
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A00U',GetLastCreatedUnit()) // 'A00U': ability "Vitality Zero"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"faeriefire",GetEnumUnit())
    endif
endfunction

function Trig_Ziegfried_Meltdown_Wave2_RingIsCreep takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Ziegfried_Meltdown_Wave2_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Ziegfried_Meltdown_Wave2_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Ziegfried_Meltdown_Wave2_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave2_FilterAlive(),Trig_Ziegfried_Meltdown_Wave2_FilterEnemy())
endfunction

function Trig_Ziegfried_Meltdown_Wave2_FilterNotInvul takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Ziegfried_Meltdown_Wave2_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave2_FilterAliveEnemy(),Trig_Ziegfried_Meltdown_Wave2_FilterNotInvul())
endfunction

function Trig_Ziegfried_Meltdown_Wave2Alt_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Ziegfried_Meltdown_Wave2Alt_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Ziegfried_Meltdown_Wave2Alt_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave2Alt_FilterAlive(),Trig_Ziegfried_Meltdown_Wave2Alt_FilterEnemy())
endfunction

function Trig_Ziegfried_Meltdown_Wave2Alt_FilterNotInvul takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Ziegfried_Meltdown_Wave2Alt_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Ziegfried_Meltdown_Wave2Alt_FilterAliveEnemy(),Trig_Ziegfried_Meltdown_Wave2Alt_FilterNotInvul())
endfunction

function Trig_Ziegfried_Meltdown_Wave2_PickIsCreep takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Ziegfried_Meltdown_Wave2_DamageUnit takes nothing returns nothing
    set udg_DmgFlagUnavoidable=-1
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),20000.,true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL,null)
endfunction

function Trig_Ziegfried_Meltdown_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,300.,(I2R(GetForLoopIndexA())*30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\Disenchant\\DisenchantSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,600.,((I2R(GetForLoopIndexA())*30.)-15.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\Disenchant\\DisenchantSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Ziegfried_Meltdown_Wave1_RingIsCreep())then
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,900.,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\Disenchant\\DisenchantSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Ziegfried_Meltdown_Wave1_PickIsCreep())then
        set udg_TempGroup=Group_UnitsInRangeOfLoc(1024.,udg_TempPoint,Condition(function Trig_Ziegfried_Meltdown_Wave1_FilterTarget))
    else
        set udg_TempGroup=Group_UnitsInRangeOfLoc(728.,udg_TempPoint,Condition(function Trig_Ziegfried_Meltdown_Wave1Alt_FilterTarget))
    endif
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Ziegfried_Meltdown_Wave1_DamageUnit)
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,300.,(I2R(GetForLoopIndexA())*30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\NightElf\\Wisp\\WispExplode.mdl")
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),$FF,0,0) // $FF = 255
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,600.,((I2R(GetForLoopIndexA())*30.)-15.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\NightElf\\Wisp\\WispExplode.mdl")
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),$FF,0,0) // $FF = 255
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Ziegfried_Meltdown_Wave2_RingIsCreep())then
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,900.,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Units\\NightElf\\Wisp\\WispExplode.mdl")
            call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),$FF,0,0) // $FF = 255
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Ziegfried_Meltdown_Wave2_PickIsCreep())then
        set udg_TempGroup=Group_UnitsInRangeOfLoc(1024.,udg_TempPoint,Condition(function Trig_Ziegfried_Meltdown_Wave2_FilterTarget))
    else
        set udg_TempGroup=Group_UnitsInRangeOfLoc(728.,udg_TempPoint,Condition(function Trig_Ziegfried_Meltdown_Wave2Alt_FilterTarget))
    endif
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Ziegfried_Meltdown_Wave2_DamageUnit)
    call DestroyGroup(udg_TempGroup)
endfunction

function Trig_Ziegfried_Confront_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsUnitHiddenBJ(gg_unit_H036_0254)==false)and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Ziegfried_Confront_PlayConfrontDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// A hero comes near Ziegfried (quest "Divine Order", step 2): he refuses to help the dwarves and fights.
function Trig_Ziegfried_Confront_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[90])
    call ShowUnitHide(gg_unit_N0N0_0267)
    if(Trig_Ziegfried_Confront_PlayConfrontDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H036_0254,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Ziegfried. We meet again.",false)
        call Text_Say(gg_unit_H036_0254,"Ah, it's you again. Do you need something?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Bad news, Ziegfried. It seems killing this beast here made some god very mad at you. Now a knight of his is holding the dwarves in the Barrens all hostage. Come help me take him down!",false)
        call Text_Say(gg_unit_H036_0254,"Haha, so he has noticed my power already. No matter, I shall wait here until he dares confront me himself. You may leave. Some puny knight isn't worth my time.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"What? You're just going to ignore him? What about Bali and Loki? And the others?",false)
        call Text_Say(gg_unit_H036_0254,"What about them? Why are they my problem?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"They hired you to protect them, they forged your gear for you, and you weren't even there to protect them when they got kidnapped! Now's the time to make up for that!",false)
        call Text_Say(gg_unit_H036_0254,"Make up? Please. I protected those dwarves while I was there with them in exchange for the gear they crafted me. It's not like I had any obligation to be there every hour of every day. They said it was perfectly fine if I had to take some time off. And so I did, I got my gear, and then I moved on. What happens to them now is none of my concern.",false)
        call Text_Say(gg_unit_H036_0254,"It's not on me to keep protecting them. I have much greater ambitions. I'm looking to challenge the gods themselves! What about that is so hard to understand?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So that's how it is. Thank you, Ziegfried. We fought side by side, but now I feel no regret over what I am about to do.",false)
        call Text_Say(gg_unit_H036_0254,"Drawing your weapon are you? So that's how the Northern God is playing this. Well if you think you can penetrate my armor you are welcome to try. This'll make for a fine warmup exercise.",false)
        call Cine_ExitAction()
    endif
    call Quest_StepDone(QUEST_DIVINE_ORDER,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call SetUnitOwner(gg_unit_H036_0254,Player($B),true) // $B = 11
    call PauseUnitBJ(false,gg_unit_H036_0254)
    call SetUnitInvulnerable(gg_unit_H036_0254,false)
    call UnitRemoveAbilityBJ('A0Y2',gg_unit_H036_0254) // 'A0Y2': ability "Arcanium Immortality"
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_H036_0254) // 'A0ZR': ability "Immortal"
    call EnableTrigger(gg_trg_Ziegfried_Arena_Leash)
    call EnableTrigger(gg_trg_Quest_DivineOrder_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Ziegfried_Arena_Leash_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H036_0254)
endfunction

function Trig_Ziegfried_Arena_Leash_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_677)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),l_tempPoint,270.)
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Ziegfried automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ziegfried_Part1 / RegisterTriggers_Ziegfried_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ziegfried takes nothing returns nothing
endfunction

function Register_Ziegfried_Mine_Arrive takes nothing returns nothing
    set gg_trg_Ziegfried_Mine_Arrive=CreateTrigger()
    call DisableTrigger(gg_trg_Ziegfried_Mine_Arrive)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Ziegfried_Mine_Arrive,udg_SharedDelayTimer5)
    call TriggerAddAction(gg_trg_Ziegfried_Mine_Arrive,function Trig_Ziegfried_Mine_Arrive_Actions)
endfunction

function Register_Ziegfried_Advance_Order takes nothing returns nothing
    set gg_trg_Ziegfried_Advance_Order=CreateTrigger()
    call DisableTrigger(gg_trg_Ziegfried_Advance_Order)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Ziegfried_Advance_Order,4.)
    call TriggerAddAction(gg_trg_Ziegfried_Advance_Order,function Trig_Ziegfried_Advance_Order_Actions)
endfunction

function Register_Ziegfried_Attack_Fafnir takes nothing returns nothing
    set gg_trg_Ziegfried_Attack_Fafnir=CreateTrigger()
    call DisableTrigger(gg_trg_Ziegfried_Attack_Fafnir)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Ziegfried_Attack_Fafnir,10.)
    call TriggerAddAction(gg_trg_Ziegfried_Attack_Fafnir,function Trig_Ziegfried_Attack_Fafnir_Actions)
endfunction

function Register_Ziegfried_Meltdown takes nothing returns nothing
    set gg_trg_Ziegfried_Meltdown=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ziegfried_Meltdown,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ziegfried_Meltdown,Condition(function Trig_Ziegfried_Meltdown_Conditions))
    call TriggerAddAction(gg_trg_Ziegfried_Meltdown,function Trig_Ziegfried_Meltdown_Actions)
endfunction

function Register_Ziegfried_Confront takes nothing returns nothing
    set gg_trg_Ziegfried_Confront=CreateTrigger()
    call DisableTrigger(gg_trg_Ziegfried_Confront)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Ziegfried_Confront,800.,gg_unit_H036_0254)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Ziegfried_Confront,250.,gg_unit_H036_0254)
    call TriggerAddCondition(gg_trg_Ziegfried_Confront,Condition(function Trig_Ziegfried_Confront_Conditions))
    call TriggerAddAction(gg_trg_Ziegfried_Confront,function Trig_Ziegfried_Confront_Actions)
endfunction

function Register_Ziegfried_Arena_Leash takes nothing returns nothing
    set gg_trg_Ziegfried_Arena_Leash=CreateTrigger()
    call DisableTrigger(gg_trg_Ziegfried_Arena_Leash)
    call TriggerRegisterEnterRectSimple(gg_trg_Ziegfried_Arena_Leash,gg_rct_710)
    call TriggerAddCondition(gg_trg_Ziegfried_Arena_Leash,Condition(function Trig_Ziegfried_Arena_Leash_Conditions))
    call TriggerAddAction(gg_trg_Ziegfried_Arena_Leash,function Trig_Ziegfried_Arena_Leash_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Ziegfried_Part1 takes nothing returns nothing
    call Register_Ziegfried_Mine_Arrive() // starts off; enabled by Quest_Arcanium; run by Valigarmanda
    call Register_Ziegfried_Advance_Order() // starts off; enabled by Quest_ImperviousBeast; disabled by Fafnir
    call Register_Ziegfried_Attack_Fafnir() // starts off; enabled by Fafnir; disabled by Quest_ImperviousBeast
    call Register_Ziegfried_Meltdown()
    call Register_Ziegfried_Confront() // starts off; enabled by Quest_DivineOrder
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Ziegfried_Part2 takes nothing returns nothing
    call Register_Ziegfried_Arena_Leash() // starts off; enabled by Ziegfried; disabled by Quest_DivineOrder; destroyed by Quest_DivineOrder
endfunction

endlibrary

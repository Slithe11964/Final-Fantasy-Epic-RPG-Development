library TZodiark requires TCam, TCine, TGroup, TLink, TLoc, TMusic, TPlayerPart01, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Zodiark_Prepare=null
    trigger gg_trg_Zodiark_Encounter=null
    trigger gg_trg_Zodiark_BanishRay=null
    trigger gg_trg_Zodiark_Darkja=null
endglobals

function Trig_Zodiark_Prepare_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00H_0211)
    call PauseUnitBJ(true,gg_unit_U00H_0211)
    call SetUnitInvulnerable(gg_unit_U00H_0211,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Zodiark_Encounter_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Zodiark_Encounter_HasFoughtBefore takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[40]))
endfunction

function Trig_Zodiark_Encounter_Quest20Done_Greeting takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[20]))
endfunction

function Trig_Zodiark_Encounter_Quest19Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[19]))
endfunction

function Trig_Zodiark_Encounter_Quest20Done_Meta takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[20]))
endfunction

function Trig_Zodiark_Encounter_MetaDialogueOn takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Zodiark_Encounter_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Zodiark_Encounter_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Zodiark_Encounter_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_GodDragonUnit,.0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"This must be it... the legendary God Dragon.",false)
        call SetUnitFacingToFaceUnitTimed(udg_GodDragonUnit,GetTriggerUnit(),.0)
        call Text_Say(udg_GodDragonUnit,"...",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It really looks terrifying. This is a dragon befitting of its title.",false)
        if(Trig_Zodiark_Encounter_Quest20Done_Greeting())then
            call Text_Say(null,"Now this is an interesting development...",false)
        else
            if(Trig_Zodiark_Encounter_HasFoughtBefore())then
                call Text_Say(null,"Come back for more, have you?",false)
            else
                call Text_Say(null,"Ah, so the heroes have arrived.",false)
            endif
        endif
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It speaks!",false)
        call Text_Transmission(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"It speaks! ...","It speaks!",null,0,false)
        call Text_Transmission(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"It speaks! ... no wait.","It speaks! ...",null,0,false)
        call Text_Transmission(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"It speaks! ... no wait. Who said that?","It speaks! ... no wait.",null,0,false)
        call Text_Say(null,"The legend of the God Dragon is it?",false)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
        call ShowUnitShow(gg_unit_U00H_0211)
        set udg_TempPoint=GetUnitLoc(gg_unit_U00H_0211)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$C // $C = 12
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,90.,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2)
        call Text_Transmission(gg_unit_U00H_0211,"Mysterious Dragon","It is fascinating how legends spread, is it not.","(null)",null,0,false)
        if(Trig_Zodiark_Encounter_MetaDialogueOn())then
            if(Trig_Zodiark_Encounter_Quest20Done_Meta())then
                call Text_Say(gg_unit_U00H_0211,"But enough of this charade. You need no introduction to me, nor I to you.",false)
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"You're... an irregular existence, aren't you?",false)
                call Text_Say(gg_unit_U00H_0211,"Not nearly as much as you. I never imagined you'd bring the tale to this point.",false)
                call Text_Say(gg_unit_U00H_0211,"There are many who have played with this world, but only the fewest made it here. Perhaps you can even go beyond...",false)
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Beyond? Beyond what?",false)
                call Text_Say(gg_unit_U00H_0211,"Oh I fear it is not yet time for that. But perhaps you will be one of the players to meet her eventually.",false)
                call Text_Say(gg_unit_U00H_0211,"The witch hidden beneath the waves of the endlessly recurring world...",false)
                call Text_Say(gg_unit_U00H_0211,"Well it matters not. For now, I will perform my last role in this world as your opponent in battle.",false)
                call Text_Say(gg_unit_U00H_0211,"Prepare yourself, witch!",false)
            else
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Wait where'd you come from? Who are you?",false)
                call Text_Transmission(gg_unit_U00H_0211,"Mysterious Dragon","Ah, names. What transient labels they are. I've been called by many names in different worlds. Some know me as Mercurius, or simply the Serpent. In this world some call me the God Dragon. As for you, however...","(null)",null,0,false)
                call Text_Say(gg_unit_U00H_0211,"The most meaningful title of mine for you would be Zodiark, the Zodiac Brave of Darkness. The thirteenth of the twelve.",false)
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So you're another Zodiac Brave! You guys really are everywhere aren't you?",false)
                call Text_Say(gg_unit_U00H_0211,"Certainly. The Zodiac Braves are but a group that keeps this world in order. Ah but even among them I am but an outsider. An honorary member at best. For I do not come from this world myself, you see.",false)
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"What do you mean?",false)
                call Text_Say(gg_unit_U00H_0211,"If the Holy one is the executioner to deal with threats within this world, then I am the executioner to deal with threats from outside this world. Gravity may guard the border, but external enemies to this very world's existence are my domain.",false)
                call Text_Say(gg_unit_U00H_0211,"As an outsider yourself I suppose I cannot very well let you walk freely. How tragic.",false)
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"What is it with you. We've been in this world for a while now and now WE are the ones who sought YOU out. You haven't done anything!",false)
                call Text_Say(gg_unit_U00H_0211,"I could hardly help myself. Your tale was a beautiful one to watch unfold. Such pure heroic deeds, how could one not be moved? That's why it is tragic. I am no longer allowed to be just a spectator. I must now act my part myself.",false)
                call Text_Say(gg_unit_U00H_0211,"Every heroic tale needs its villains. We are the ones in yours. It is such a curious thing how the dice roll at times.",false)
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I don't understand a damn thing of what you're talking about, but you're starting to get on my nerves with your drivel. Let's just fight already.",false)
                call Text_Say(gg_unit_U00H_0211,"But of course. The prelude is at its end. Now for the main course. Fight for your lives, heroes, and don't you dare disappoint the spectators!",false)
            endif
        else
            call Text_Say(gg_unit_U00H_0211,"But this is truly a unique world. Cut off from the time reversals that save your life time and time again. Did you come here intentionally?",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I have no idea what you're talking about.",false)
            call Text_Say(gg_unit_U00H_0211,"It matters not. My words will reach the one they are meant to.",false)
            call Text_Say(gg_unit_U00H_0211,"There is something I wish to show you. Something that is beyond your reach to see for yourself in any normal world.",false)
            call Text_Say(gg_unit_U00H_0211,"It comes at the cost of your own life, however. You must lose the battle against the Ice Demon Echele. Only then can you see the truth with your own eyes. If you do not trust me, that is fine as well. The play is splendid as it is.",false)
            if(Trig_Zodiark_Encounter_Quest19Completed())then
                call Text_Say(gg_unit_U00H_0211,"Of course this would require starting all over again for you, since you already defeated him in this world. Regardless, my offer stands. Do think about it.",false)
            endif
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Are you done with your monologue yet?",false)
            call Text_Say(gg_unit_U00H_0211,"Ah of course. Allow me to perform the role I am meant for. The boss fight against the 13th Zodiac Brave, Zodiark of Darkness!",false)
        endif
        call Cine_ExitAction()
    else
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
        call ShowUnitShow(gg_unit_U00H_0211)
        set udg_TempPoint=GetUnitLoc(gg_unit_U00H_0211)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$C // $C = 12
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,90.,(I2R(GetForLoopIndexA())*30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
    endif
    call UnitRemoveAbilityBJ('A0VJ',udg_GodDragonUnit) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(false,udg_GodDragonUnit)
    call SetUnitInvulnerable(udg_GodDragonUnit,false)
    call PauseUnitBJ(false,gg_unit_U00H_0211)
    call SetUnitInvulnerable(gg_unit_U00H_0211,false)
    call Link_SaveCaster(udg_GodDragonUnit,gg_unit_U00H_0211,.0)
    call UnitAddAbilityBJ('A0X2',gg_unit_U00H_0211) // 'A0X2': ability "Perma Cover"
    call Music_SetTrack($D) // $D = 13
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat Zodiark, the Zodiac Brave of Darkness.")
    call QuestSetDescriptionBJ(udg_MainQuest[17],"Defeat Zodiark, the Zodiac Brave of Darkness.")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Zodiark_BanishRay_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A120') // 'A120': ability "Banish Ray"
endfunction

function Trig_Zodiark_BanishRay_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (30).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,90.,(I2R(GetForLoopIndexA())*30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    // ((maximum health of the spell target) times (a random decimal number between 0.05 and 0.15)) plus (15000).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetSpellTargetUnit())*GetRandomReal(.05,.15))+15000.),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
endfunction

function Trig_Zodiark_Darkja_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0YQ') // 'A0YQ': ability "!Darkja"
endfunction

function Trig_Zodiark_Darkja_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Zodiark_Darkja_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Zodiark_Darkja_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Zodiark_Darkja_FilterAlive(),Trig_Zodiark_Darkja_FilterEnemy())
endfunction

function Trig_Zodiark_Darkja_FilterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Zodiark_Darkja_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Zodiark_Darkja_FilterAliveEnemy(),Trig_Zodiark_Darkja_FilterVulnerable())
endfunction

function Trig_Zodiark_Darkja_TargetCursable takes nothing returns boolean
    return(IsUnitAliveBJ(GetEnumUnit()))and(UnitHasBuffBJ(GetEnumUnit(),'B00P')==false) // 'B00P': buff tooltip "Blind"
endfunction

function Trig_Zodiark_Darkja_DamageTarget takes nothing returns nothing
    // (maximum health of the unit being visited) times (a random decimal number between 0.5 and 0.6).
    set udg_TempReal=(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEnumUnit())*GetRandomReal(.5,.6))
    set udg_DmgFlagPure=true
    set udg_IgnoresReduction=true
    set udg_DmgFlagUnavoidable=-1
    // (udg_TempReal) plus (1000).
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),udg_TempReal+1000.,true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
    if(Trig_Zodiark_Darkja_TargetCursable())then
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A09G',GetLastCreatedUnit()) // 'A09G': ability "Blind"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",GetEnumUnit())
    endif
endfunction

function Trig_Zodiark_Darkja_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (30).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,300.,(I2R(GetForLoopIndexA())*30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // ((loop counter A treated as a decimal-capable number) times (30)) minus (15).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,600.,((I2R(GetForLoopIndexA())*30.)-15.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempGroup=Group_UnitsInRangeOfLoc(728.,udg_TempPoint,Condition(function Trig_Zodiark_Darkja_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Zodiark_Darkja_DamageTarget)
    call DestroyGroup(udg_TempGroup)
endfunction

// World Editor calls InitTrig_Zodiark automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Zodiark_Part1 / RegisterTriggers_Zodiark_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Zodiark takes nothing returns nothing
endfunction

function Register_Zodiark_Prepare takes nothing returns nothing
    set gg_trg_Zodiark_Prepare=CreateTrigger()
    call TriggerAddAction(gg_trg_Zodiark_Prepare,function Trig_Zodiark_Prepare_Actions)
endfunction

function Register_Zodiark_Encounter takes nothing returns nothing
    set gg_trg_Zodiark_Encounter=CreateTrigger()
    call DisableTrigger(gg_trg_Zodiark_Encounter)
    call TriggerAddCondition(gg_trg_Zodiark_Encounter,Condition(function Trig_Zodiark_Encounter_Conditions))
    call TriggerAddAction(gg_trg_Zodiark_Encounter,function Trig_Zodiark_Encounter_Actions)
endfunction

function Register_Zodiark_BanishRay takes nothing returns nothing
    set gg_trg_Zodiark_BanishRay=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Zodiark_BanishRay,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Zodiark_BanishRay,Condition(function Trig_Zodiark_BanishRay_Conditions))
    call TriggerAddAction(gg_trg_Zodiark_BanishRay,function Trig_Zodiark_BanishRay_Actions)
endfunction

function Register_Zodiark_Darkja takes nothing returns nothing
    set gg_trg_Zodiark_Darkja=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Zodiark_Darkja,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Zodiark_Darkja,Condition(function Trig_Zodiark_Darkja_Conditions))
    call TriggerAddAction(gg_trg_Zodiark_Darkja,function Trig_Zodiark_Darkja_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Zodiark_Part1 takes nothing returns nothing
    call Register_Zodiark_Prepare() // run by MapBootstrap
    call Register_Zodiark_Encounter() // starts off; enabled by Quest_GodDragon
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Zodiark_Part2 takes nothing returns nothing
    call Register_Zodiark_BanishRay()
    call Register_Zodiark_Darkja()
endfunction

endlibrary

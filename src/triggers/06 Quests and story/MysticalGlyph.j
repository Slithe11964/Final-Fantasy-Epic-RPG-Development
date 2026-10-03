library TMysticalGlyph requires TCam, TCine, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MysticalGlyph_Prepare=null
    trigger gg_trg_MysticalGlyph_Drop=null
    trigger gg_trg_MysticalGlyph_Pickup=null
    trigger gg_trg_MysticalGlyph_Ping=null
    trigger gg_trg_MysticalGlyph_Deliver=null
    trigger gg_trg_MysticalGlyph_Result=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    integer udg_GlyphDropCounter=0
    sound gg_snd_StormPandarenBrewmasterYesAttack=null
endglobals

function Trig_MysticalGlyph_Prepare_Actions takes nothing returns nothing
    set udg_GlyphDropCounter=$DAC // $DAC = 3500
    call EnableTrigger(gg_trg_MysticalGlyph_Drop)
    set udg_SpecialEffect[18]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n007_0105,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Storm_Greet)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysticalGlyph_Drop_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(GetUnitUserData(GetTriggerUnit())>=1)and(GetUnitUserData(GetTriggerUnit())<=9)
endfunction

function Trig_MysticalGlyph_Drop_Cond_CounterRemaining takes nothing returns boolean
    return(udg_GlyphDropCounter>0)
endfunction

function Trig_MysticalGlyph_Drop_Cond_KillerNotHero takes nothing returns boolean
    return(GetKillingUnitBJ()!=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())))
endfunction

function Trig_MysticalGlyph_Drop_Cond_InfoStocked takes nothing returns boolean
    return(udg_QuestFlag[3])
endfunction

function Trig_MysticalGlyph_Drop_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_GlyphDropCounter=(udg_GlyphDropCounter-R2I(SquareRoot(I2R(GetUnitLevel(GetTriggerUnit())))))
    set udg_GlyphDropCounter=(udg_GlyphDropCounter-GetUnitUserData(GetTriggerUnit()))
    if(Trig_MysticalGlyph_Drop_Cond_CounterRemaining())then
        set l_tempPoint=null
        return
    endif
    if(Trig_MysticalGlyph_Drop_Cond_KillerNotHero())then
        set udg_GlyphDropCounter=0
        set l_tempPoint=null
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[30]=CreateItemLoc('gopr',l_tempPoint) // 'gopr': item "Mystical Glyph"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(l_tempPoint)
    call EnableTrigger(gg_trg_MysticalGlyph_Pickup)
    call EnableTrigger(gg_trg_MysticalGlyph_Ping)
    if(Trig_MysticalGlyph_Drop_Cond_InfoStocked())then
        call RemoveItemFromStockBJ('I05F',gg_unit_n02Y_0052) // 'I05F': item "Information: Mystical Glyph"
    else
        call DestroyEffectBJ(udg_SpecialEffect[18])
        call DisableTrigger(gg_trg_Storm_Greet)
        set udg_QuestFlag[3]=true
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_MysticalGlyph_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='gopr') // 'gopr': item "Mystical Glyph"
endfunction

function Trig_MysticalGlyph_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call AddSpecialEffectTargetUnitBJ("origin",udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetManipulatingUnit()))],"Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Mystical Glyph|r")
    set udg_SideQuest[20]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffMystical Glyph","You found some strange glyph. Your Spirit of Gaya reacted strangely when you picked it up.  Perhaps you should bring this glyph to someone skilled in spiritual lore.","ReplaceableTextures\\CommandButtons\\BTNGlyph.blp")
    call EnableTrigger(gg_trg_MysticalGlyph_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysticalGlyph_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[30]!=null)and(IsItemOwned(udg_QuestItem[30])==false)
endfunction

function Trig_MysticalGlyph_Ping_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetItemLoc(udg_QuestItem[30])
    call PingMinimapLocForForce(GetPlayersAll(),l_tempPoint,2.)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_MysticalGlyph_Deliver_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'gopr'))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null // 'gopr': item "Mystical Glyph"
endfunction

function Trig_MysticalGlyph_Deliver_Cond_ShowHandoverTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysticalGlyph_Deliver_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_MysticalGlyph_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'gopr')) // 'gopr': item "Mystical Glyph"
    if(Trig_MysticalGlyph_Deliver_Cond_ShowHandoverTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n007_0105,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hello Storm. Listen, I found this strange glyph some time ago and I think it is somehow connected to my Spirit of Gaya.",false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","Maybe you are right. Or maybe you are not. If you give this glyph to me I will study it thoroughly and only after I carefully research it will you hear my answer. Is that ok with you?","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Sure, this glyph doesn't seem to have be of any use to me.",false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","It will probably take a long time to study this glyph. Come back some other time.","(null)",null,0,false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Wait while Storm researches Mystical Glyph.")
    call QuestSetDescriptionBJ(udg_SideQuest[20],"Wait while Storm researches Mystical Glyph.")
    call Wait_Polled(480.)
    set udg_SpecialEffect[18]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n007_0105,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffStorm has something to tell you !!!|r")
    call QuestSetDescriptionBJ(udg_SideQuest[20],"Talk to Storm.")
    call PlaySoundBJ(gg_snd_StormPandarenBrewmasterYesAttack)
    call GroupAddUnitSimple(gg_unit_n007_0105,udg_BossUnits)
    call EnableTrigger(gg_trg_MysticalGlyph_Result)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysticalGlyph_Result_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n007_0105,true,true,true))
endfunction

function Trig_MysticalGlyph_Result_Cond_ShowResultTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysticalGlyph_Result_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[18])
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_MysticalGlyph_Result_Cond_ShowResultTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n007_0105,0)
        call Text_Transmission(gg_unit_n007_0105,"Storm","I studied the Glyph you found and came to a conclusion that it may be used to extend power of your Spirit of Gaya.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","I don't know who made this glyph or how they developed these methods, but as far as I can tell this is the real thing.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","In short, thanks to the Glyph, I can perform new rituals of empowerment. Isn't that great?","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It certainly is.",false)
        call Reward_Give(0,$7D0,gg_unit_n007_0105) // $7D0 = 2000
        call Cine_ExitAction()
    else
        call Reward_Give(0,$7D0,gg_unit_n007_0105) // $7D0 = 2000
    endif
    call ReplaceUnitBJ(gg_unit_n007_0105,'n017',bj_UNIT_STATE_METHOD_MAXIMUM) // 'n017': unit "Storm the Pandaren Spiritualist"
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Mystical Glyph|r")
    call QuestSetCompletedBJ(udg_SideQuest[20],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Storm Deciphers Mystical Glyph|r"
    set udg_NewsText[4]="Some time ago the adventurers have brought a mystical glyph to Storm. Now, after studying it for a while, Storm has finally found out what it means. Thank you, adventurers!"
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_MysticalGlyph automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MysticalGlyph_Part1 / RegisterTriggers_MysticalGlyph_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MysticalGlyph takes nothing returns nothing
endfunction

function Register_MysticalGlyph_Prepare takes nothing returns nothing
    set gg_trg_MysticalGlyph_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_MysticalGlyph_Prepare)
    call TriggerAddAction(gg_trg_MysticalGlyph_Prepare,function Trig_MysticalGlyph_Prepare_Actions)
endfunction

function Register_MysticalGlyph_Drop takes nothing returns nothing
    set gg_trg_MysticalGlyph_Drop=CreateTrigger()
    call DisableTrigger(gg_trg_MysticalGlyph_Drop)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_MysticalGlyph_Drop,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_MysticalGlyph_Drop,Condition(function Trig_MysticalGlyph_Drop_Conditions))
    call TriggerAddAction(gg_trg_MysticalGlyph_Drop,function Trig_MysticalGlyph_Drop_Actions)
endfunction

function Register_MysticalGlyph_Pickup takes nothing returns nothing
    set gg_trg_MysticalGlyph_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_MysticalGlyph_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MysticalGlyph_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_MysticalGlyph_Pickup,Condition(function Trig_MysticalGlyph_Pickup_Conditions))
    call TriggerAddAction(gg_trg_MysticalGlyph_Pickup,function Trig_MysticalGlyph_Pickup_Actions)
endfunction

function Register_MysticalGlyph_Ping takes nothing returns nothing
    set gg_trg_MysticalGlyph_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_MysticalGlyph_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_MysticalGlyph_Ping,15.)
    call TriggerAddCondition(gg_trg_MysticalGlyph_Ping,Condition(function Trig_MysticalGlyph_Ping_Conditions))
    call TriggerAddAction(gg_trg_MysticalGlyph_Ping,function Trig_MysticalGlyph_Ping_Actions)
endfunction

function Register_MysticalGlyph_Deliver takes nothing returns nothing
    set gg_trg_MysticalGlyph_Deliver=CreateTrigger()
    call DisableTrigger(gg_trg_MysticalGlyph_Deliver)
    call TriggerRegisterUnitInRangeSimple(gg_trg_MysticalGlyph_Deliver,450.,gg_unit_n007_0105)
    call TriggerAddCondition(gg_trg_MysticalGlyph_Deliver,Condition(function Trig_MysticalGlyph_Deliver_Conditions))
    call TriggerAddAction(gg_trg_MysticalGlyph_Deliver,function Trig_MysticalGlyph_Deliver_Actions)
endfunction

function Register_MysticalGlyph_Result takes nothing returns nothing
    set gg_trg_MysticalGlyph_Result=CreateTrigger()
    call DisableTrigger(gg_trg_MysticalGlyph_Result)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysticalGlyph_Result,Player(7),true)
    call TriggerAddCondition(gg_trg_MysticalGlyph_Result,Condition(function Trig_MysticalGlyph_Result_Conditions))
    call TriggerAddAction(gg_trg_MysticalGlyph_Result,function Trig_MysticalGlyph_Result_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_MysticalGlyph_Part1 takes nothing returns nothing
    call Register_MysticalGlyph_Prepare() // starts off; run by Cid, Mid
    call Register_MysticalGlyph_Drop() // starts off; enabled by MysticalGlyph
    call Register_MysticalGlyph_Pickup() // starts off; enabled by MysticalGlyph
    call Register_MysticalGlyph_Ping() // starts off; enabled by MysticalGlyph; disabled by MysticalGlyph
    call Register_MysticalGlyph_Deliver() // starts off; enabled by MysticalGlyph
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_MysticalGlyph_Part2 takes nothing returns nothing
    call Register_MysticalGlyph_Result() // starts off; enabled by MysticalGlyph
endfunction

endlibrary

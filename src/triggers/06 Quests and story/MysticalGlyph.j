library TMysticalGlyph requires TQuestEngine, TPlayerHero
// Side quest "Mystical Glyph", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// After enough kills a Mystical Glyph drops; picking it up starts the quest. Storm studies the glyph for
// 8 minutes and then can empower the Spirit of Gaya. Prepared by Cid and Mid (gg_trg_MysticalGlyph_Prepare).
// The module shows its own "!" over Storm (also used by his greeting before the quest) and no "?".
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MysticalGlyph_Prepare=null
    trigger gg_trg_MysticalGlyph_Drop=null
    trigger gg_trg_MysticalGlyph_Pickup=null
    trigger gg_trg_MysticalGlyph_Ping=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_MYSTICAL_GLYPH=0
    player MysticalGlyph_Player=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    integer udg_GlyphDropCounter=0
    sound gg_snd_StormPandarenBrewmasterYesAttack=null
endglobals

// 8 minutes after the glyph was handed in: Storm has finished his research and calls the party.
function MysticalGlyph_ResearchDone takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    set udg_SpecialEffect[18]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n007_0105,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffStorm has something to tell you !!!|r")
    call Quest_SetLog(QUEST_MYSTICAL_GLYPH,"Talk to Storm.",false)
    call PlaySoundBJ(gg_snd_StormPandarenBrewmasterYesAttack)
    call Quest_StepDone(QUEST_MYSTICAL_GLYPH,MysticalGlyph_Player,Player_GetHero(MysticalGlyph_Player))
endfunction

// Step 2 done (Storm got the glyph): he researches it for 8 minutes.
function MysticalGlyph_Delivered takes nothing returns nothing
    call DisableTrigger(gg_trg_MysticalGlyph_Ping)
    call DestroyTrigger(gg_trg_MysticalGlyph_Ping)
    set MysticalGlyph_Player=QuestDonePlayer
    call TimerStart(CreateTimer(),480.,false,function MysticalGlyph_ResearchDone)
endfunction

// Quest done: Storm becomes the Pandaren Spiritualist, and the news reports it.
function MysticalGlyph_Done takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[18])
    call ReplaceUnitBJ(gg_unit_n007_0105,'n017',bj_UNIT_STATE_METHOD_MAXIMUM) // 'n017': unit "Storm the Pandaren Spiritualist"
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Storm Deciphers Mystical Glyph|r"
    set udg_NewsText[4]="Some time ago the adventurers have brought a mystical glyph to Storm. Now, after studying it for a while, Storm has finally found out what it means. Thank you, adventurers!"
endfunction

function MysticalGlyph_Define takes nothing returns nothing
    local integer q=Quest_Define("Mystical Glyph",QUEST_SIDE,20,"ReplaceableTextures\\CommandButtons\\BTNGlyph.blp")
    set QUEST_MYSTICAL_GLYPH=q
    call Quest_NoMarker(q)
    // 1. Pick up the glyph (gg_trg_MysticalGlyph_Pickup)
    call Quest_Custom(q,"You found some strange glyph. Your Spirit of Gaya reacted strangely when you picked it up.  Perhaps you should bring this glyph to someone skilled in spiritual lore.")
    // 2. Bring the glyph to Storm
    call Quest_Deliver(q,gg_unit_n007_0105,'gopr',1,"","Wait while Storm researches Mystical Glyph.") // 'gopr': item "Mystical Glyph"
    call Quest_Say(q,null,"Hello Storm. Listen, I found this strange glyph some time ago and I think it is somehow connected to my Spirit of Gaya.")
    call Quest_SayAs(q,gg_unit_n007_0105,"Storm",null,"Maybe you are right. Or maybe you are not. If you give this glyph to me I will study it thoroughly and only after I carefully research it will you hear my answer. Is that ok with you?")
    call Quest_Say(q,null,"Sure, this glyph doesn't seem to have be of any use to me.")
    call Quest_SayAs(q,gg_unit_n007_0105,"Storm",null,"It will probably take a long time to study this glyph. Come back some other time.")
    call Quest_OnDone(q,"MysticalGlyph_Delivered")
    // 3. Storm researches the glyph for 8 minutes (MysticalGlyph_ResearchDone)
    call Quest_Custom(q,"")
    // 4. Talk to Storm
    call Quest_Talk(q,gg_unit_n007_0105,"")
    call Quest_PingUnit(q)
    call Quest_SayAs(q,gg_unit_n007_0105,"Storm",null,"I studied the Glyph you found and came to a conclusion that it may be used to extend power of your Spirit of Gaya.")
    call Quest_SayAs(q,gg_unit_n007_0105,"Storm",null,"I don't know who made this glyph or how they developed these methods, but as far as I can tell this is the real thing.")
    call Quest_SayAs(q,gg_unit_n007_0105,"Storm",null,"In short, thanks to the Glyph, I can perform new rituals of empowerment. Isn't that great?")
    call Quest_Say(q,null,"It certainly is.")
    call Quest_Reward(q,0,2000)
    call Quest_OnDone(q,"MysticalGlyph_Done")
endfunction

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

// Step 1: a hero picked up the glyph; the quest starts.
function Trig_MysticalGlyph_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call AddSpecialEffectTargetUnitBJ("origin",udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetManipulatingUnit()))],"Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if QUEST_MYSTICAL_GLYPH==0 then
        call MysticalGlyph_Define()
    endif
    call Quest_Start(QUEST_MYSTICAL_GLYPH,GetOwningPlayer(GetManipulatingUnit()),GetManipulatingUnit())
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysticalGlyph_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[30]!=null)and(IsItemOwned(udg_QuestItem[30])==false)and(GetItemTypeId(udg_QuestItem[30])=='gopr') // 'gopr': item "Mystical Glyph" (not yet handed in)
endfunction

function Trig_MysticalGlyph_Ping_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetItemLoc(udg_QuestItem[30])
    call PingMinimapLocForForce(GetPlayersAll(),l_tempPoint,2.)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
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

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_MysticalGlyph_Part1 takes nothing returns nothing
    call Register_MysticalGlyph_Prepare() // starts off; run by Cid, Mid
    call Register_MysticalGlyph_Drop() // starts off; enabled by MysticalGlyph
    call Register_MysticalGlyph_Pickup() // starts off; enabled by MysticalGlyph
    call Register_MysticalGlyph_Ping() // starts off; enabled by MysticalGlyph; disabled by MysticalGlyph
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_MysticalGlyph_Part2 takes nothing returns nothing
    // nothing left: Storm's answer is now a step of the quest
endfunction

endlibrary

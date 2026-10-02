library TFrakir requires TCam, TCine, TText, TUnit
function Trig_Frakir_ShowMarker_Actions takes nothing returns nothing
    set udg_FrakirLoreHeard=false
    set udg_SpecialEffect[9]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nsw2_0056,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Frakir_Lore_Talk)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Frakir_Lore_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_nsw2_0056,true,true,true))
endfunction

function Trig_Frakir_Lore_Talk_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Frakir_Lore_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[9])
    set udg_FrakirLoreHeard=true
    if(Trig_Frakir_Lore_Talk_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_nsw2_0056,"Hello, my name is Frakir. I am a planeswalker.",false)
        call Text_Say(gg_unit_nsw2_0056,"Allow me to welcome you. I have been observing this world, Gaya for over a hundred years. Things have changed a lot.",false)
        call Text_Say(gg_unit_nsw2_0056,"Over a hundred years ago, the world was ruled by demons. It was a harsh time, but eventually all the tribes of elves of this world banded together to banish and seal them away.",false)
        call Text_Say(gg_unit_nsw2_0056,"In the aftermath of that revolution, this very town was built. It is called Kalm and is the fruit of many elves and humans working together to create a place just beyond the Great Wall where they could live new, normal lives.",false)
        call Text_Say(gg_unit_nsw2_0056,"Elves used to all just live in the forest, and of course not all of them were comfortable leaving. There is still a settlement in the forests down south where the elves that did not migrate to Kalm live. They mostly keep to themselves.",false)
        call Text_Say(gg_unit_nsw2_0056,"Kalm is now ruled by Cid. He is an engineer whose research into weaponry and sorcery alike has brought tremendous advancement in the security of Kalm. Those towers you see at the gates are his very own handiwork.",false)
        call Text_Say(gg_unit_nsw2_0056,"The defenses of the city are managed by Izlude, captain of Kalm's forces, and his sister Meliadoul, first ranger. They keep our guards well-trained and equipped in case monsters become a serious threat to the town once more.",false)
        call Text_Say(gg_unit_nsw2_0056,"Alma and Zalmo are the local clerics. They take care of the sick and many people owe the lives of their loved ones to their magic. You should consider seeing them when you're hurt from your travels as well, they can mend your wounds.",false)
        call Text_Say(gg_unit_nsw2_0056,"Over the last decades a Hunt Club has also established themselves in Kalm. They dutifully keep the monsters in areas all over the world in check and have been the first to respond to monster attacks several times.",false)
        call Text_Say(gg_unit_nsw2_0056,"There is also a Farm further to the south of Kalm, which has its own tightly knit community. They provide Kalm with food but in return seem to mostly just want to be left alone.",false)
        call Text_Say(gg_unit_nsw2_0056,"A relic of old is also Kalm's Battle Arena. It is off to the far southwest of the world and the roads there no longer exist. However, thanks to the magic powers of two jesters, an alternative route there was created and allows it to be used to this day.",false)
        call Text_Say(gg_unit_nsw2_0056,"Some legends speak of a parallel underworld to Gaya - Terra. The legends changed over the years but by now it is mostly simply considered the world where the souls of people who have died return to. In any case, nobody has ever seen Terra for themselves, so it may very well be just this world's name for \"heaven\".",false)
        call Text_Say(gg_unit_nsw2_0056,"Sadly I do not know much about it myself. There are a lot of strange phenomena in Gaya and many truths and myths have become intertwined so by now it has become difficult to distinguish between true dangers and embellished stories.",false)
        call Text_Say(gg_unit_nsw2_0056,"There used to be a group of wizards called the Seekers who strived to unravel this world's secrets. I believe Mae'chen, who resides in this very town, had close ties to them himself.",false)
        call Text_Say(gg_unit_nsw2_0056,"Unfortunately, they all lost their minds someday, without warning, and now are just as mindless and dangerous as the common fiends. Nobody knows what happened to them. But who knows, you may yet be able to locate some scriptures that give an insight into the wisdom they gained, and what led to their fall.",false)
        call Text_Say(gg_unit_nsw2_0056,"At any rate it remains a dangerous world largely populated by monsters with a lot of unsolved phenomena. Take care of yourselves out there and make good use of the benevolent Spirit following you to survive when you're out in the wild.",false)
        call Text_Say(gg_unit_nsw2_0056,"That's all I can tell you, fare thee well.",false)
        call Cine_ExitAction()
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Frakir_NextMarker_Cond_FrakirLoreHeard takes nothing returns boolean
    return(udg_FrakirLoreHeard)
endfunction

function Trig_Frakir_NextMarker_Actions takes nothing returns nothing
    if(Trig_Frakir_NextMarker_Cond_FrakirLoreHeard())then
        set udg_SpecialEffect[9]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nsw2_0056,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    else
        call DisableTrigger(gg_trg_Frakir_Lore_Talk)
        call DestroyTrigger(gg_trg_Frakir_Lore_Talk)
    endif
    call EnableTrigger(gg_trg_Quest_SpiritHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Frakir takes nothing returns nothing
endfunction

function RegisterR11_Frakir_ShowMarker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Frakir_ShowMarker=CreateTrigger()

call DisableTrigger(gg_trg_Frakir_ShowMarker)

call TriggerAddAction(gg_trg_Frakir_ShowMarker,function Trig_Frakir_ShowMarker_Actions)

endfunction




function RegisterR11_Frakir_Lore_Talk takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Frakir_Lore_Talk=CreateTrigger()

call DisableTrigger(gg_trg_Frakir_Lore_Talk)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Frakir_Lore_Talk,Player(7),true)

call TriggerAddCondition(gg_trg_Frakir_Lore_Talk,Condition(function Trig_Frakir_Lore_Talk_Conditions))

call TriggerAddAction(gg_trg_Frakir_Lore_Talk,function Trig_Frakir_Lore_Talk_Actions)

endfunction




function RegisterR11_Frakir_NextMarker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Frakir_NextMarker=CreateTrigger()

call DisableTrigger(gg_trg_Frakir_NextMarker)

call TriggerAddAction(gg_trg_Frakir_NextMarker,function Trig_Frakir_NextMarker_Actions)

endfunction




endlibrary

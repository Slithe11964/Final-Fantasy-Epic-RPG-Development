library TNews requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_News_Morning=null
    trigger gg_trg_News_Evening=null
    trigger gg_trg_News_SetTitle=null
    trigger gg_trg_News_SetEntry=null
    trigger gg_trg_News_SubmitEntry=null
    // Variables only this module uses.
    boolean udg_NewsTextAllSpaces=false
endglobals

function Trig_News_Morning_IsDayPast9 takes nothing returns boolean
    return(udg_GameDay>=$A) // $A = 10
endfunction

function Trig_News_Morning_IsMainQuest4Done takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[4]))
endfunction

function Trig_News_Morning_IsMainQuest2Done takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[2]))
endfunction

function Trig_News_Morning_IsMainQuest1Done takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[1]))
endfunction

function Trig_News_Morning_IsMainQuest1Found takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[1]))
endfunction

function Trig_News_Morning_IsMorningDay2 takes nothing returns boolean
    return(udg_GameDay==2)
endfunction

function Trig_News_Morning_IsMorningDay3 takes nothing returns boolean
    return(udg_GameDay==3)
endfunction

function Trig_News_Morning_HasStoryProgress12 takes nothing returns boolean
    return(udg_StoryProgress>=$C) // $C = 12
endfunction

function Trig_News_Morning_IsMorningDay4 takes nothing returns boolean
    return(udg_GameDay==4)
endfunction

function Trig_News_Morning_IsMorningDay5 takes nothing returns boolean
    return(udg_GameDay==5)
endfunction

function Trig_News_Morning_IsMorningDay6 takes nothing returns boolean
    return(udg_GameDay==6)
endfunction

function Trig_News_Morning_IsMorningDay7 takes nothing returns boolean
    return(udg_GameDay==7)
endfunction

function Trig_News_Morning_IsMorningDay8 takes nothing returns boolean
    return(udg_GameDay==8)
endfunction

function Trig_News_Morning_IsMorningDay9 takes nothing returns boolean
    return(udg_GameDay==9)
endfunction

function Trig_News_Morning_Actions takes nothing returns nothing
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,60.,0,50.)
    set udg_GameDay=(udg_GameDay+1)
    if(Trig_News_Morning_IsDayPast9())then
        return
    endif
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[2]=(udg_NewsText[2]+" |cffffcc00(Yesterday)|r")
    set udg_NewsText[3]=(udg_NewsText[3]+" |cffffcc00(Yesterday)|r")
    if(Trig_News_Morning_IsMorningDay2())then
        if(Trig_News_Morning_IsMainQuest1Found())then
            if(Trig_News_Morning_IsMainQuest1Done())then
                if(Trig_News_Morning_IsMainQuest2Done())then
                    if(Trig_News_Morning_IsMainQuest4Done())then
                        set udg_NewsText[1]="|cffffcc00Cid Thanks The Adventurers|r"
                        set udg_NewsText[4]="\"I want to say great thanks to the adventurers, who have done many deeds for us in the past time. Keep up the good work!\""
                    else
                        set udg_NewsText[1]="|cffffcc00Cid's Thanks|r"
                        set udg_NewsText[4]="\"Thanks to the adventurers who have brought the Zodiac Stone to me!\""
                    endif
                else
                    set udg_NewsText[1]="|cffffcc00Cid Thinks The Adventurers Are Brave People|r"
                    set udg_NewsText[4]="\"Thank you so much, adventurers, for finding my nephew. And don't give up on finding that artifact!\""
                endif
            else
                set udg_NewsText[1]="|cffffcc00Cid's Scouts Had Success|r"
                set udg_NewsText[4]="\"To the adventurers: You're trying to find my nephew, thanks a lot! Our scouts have noticed a cage near five runes. He could be located there.\""
            endif
        else
            set udg_NewsText[1]="|cffffcc00Cid Wants His Nephew Back|r"
            set udg_NewsText[4]="\"To all the people in Kalm: Please find my nephew Mid. I've been depressed ever since he went missing.\""
        endif
        return
    endif
    if(Trig_News_Morning_IsMorningDay3())then
        set udg_NewsText[1]="|cffffcc00Weapon Advertisement|r"
        set udg_NewsText[4]="25% off the Mithril Sword, only today!! Get it now, or pay 600 gold more!"
        set udg_KalmNpc[4]=ReplaceUnitBJ(udg_KalmNpc[4],'n02L',bj_UNIT_STATE_METHOD_RELATIVE) // 'n02L': unit "Weapon Vendor"
        return
    endif
    if(Trig_News_Morning_IsMorningDay4())then
        set udg_KalmNpc[4]=ReplaceUnitBJ(udg_KalmNpc[4],'n00X',bj_UNIT_STATE_METHOD_RELATIVE) // 'n00X': unit "Weapon Vendor"
        if(Trig_News_Morning_HasStoryProgress12())then
            set udg_NewsText[1]="|cffffcc00Most Popular People: Adventurers!|r"
            set udg_NewsText[4]="Almost every person in Kalm can say something good about the adventurers, which came here a few days ago. They have been voted the most popular people in Kalm! Good job!"
        else
            set udg_NewsText[1]="|cffffcc00Most Popular Person: Alma!|r"
            set udg_NewsText[4]="Alma, the Cleric, is the most popular person in Kalm! She has healed a total of 86 ill or wounded people and has helped Zalmo a lot. Congratulations!!"
        endif
        return
    endif
    if(Trig_News_Morning_IsMorningDay5())then
        set udg_NewsText[1]="|cffffcc00Weapon Advertisement|r"
        set udg_NewsText[4]="It's local Mithril day!! 25% off all Mithril items, only today!! Get them now, or pay a lot more!"
        set udg_KalmNpc[2]=ReplaceUnitBJ(udg_KalmNpc[2],'n02O',bj_UNIT_STATE_METHOD_RELATIVE) // 'n02O': unit "Armor Vendor"
        set udg_KalmNpc[3]=ReplaceUnitBJ(udg_KalmNpc[3],'n02N',bj_UNIT_STATE_METHOD_RELATIVE) // 'n02N': unit "Shield and Helmet Vendor"
        set udg_KalmNpc[4]=ReplaceUnitBJ(udg_KalmNpc[4],'n02M',bj_UNIT_STATE_METHOD_RELATIVE) // 'n02M': unit "Weapon Vendor"
        return
    endif
    if(Trig_News_Morning_IsMorningDay6())then
        set udg_KalmNpc[2]=ReplaceUnitBJ(udg_KalmNpc[2],'n00Y',bj_UNIT_STATE_METHOD_RELATIVE) // 'n00Y': unit "Armor Vendor"
        set udg_KalmNpc[3]=ReplaceUnitBJ(udg_KalmNpc[3],'n0MK',bj_UNIT_STATE_METHOD_RELATIVE) // 'n0MK': unit "Shield and Helmet Vendor"
        set udg_KalmNpc[4]=ReplaceUnitBJ(udg_KalmNpc[4],'n00X',bj_UNIT_STATE_METHOD_RELATIVE) // 'n00X': unit "Weapon Vendor"
        set udg_NewsText[1]="|cffffcc00New Helmet for sale!|r"
        set udg_NewsText[4]=StringIdentity("The local Shield and Helmet vendor wishes to announce that he received delivery of a new helmet! Do check out his shop if you're interested.")
        return
    endif
    if(Trig_News_Morning_IsMorningDay7())then
        set udg_NewsText[1]="|cffffcc00Warning from the Hunt Club|r"
        set udg_NewsText[4]="The hunt club issues a warning: if out in the wild you happen to find an Elemental, do not provoke it, do not cast magic it doesn't like, just stay calm and try to get away. They are incredibly dangerous beings!"
        call RemoveItemFromStockBJ('I03Z',gg_unit_n001_0012) // 'I03Z': item "Nectar (50% off!)"
        call AddItemToStockBJ('I02V',gg_unit_n001_0012,3,3) // 'I02V': item "Nectar"
        return
    endif
    if(Trig_News_Morning_IsMorningDay8())then
        set udg_NewsText[1]="|cffffcc00New Robe for sale!|r"
        set udg_NewsText[4]=StringIdentity("The armor vendor in our town has received a special delivery and is now selling a very powerful robe. Any interested adventurers are welcome to seek him out in the eastern part of town!")
        set udg_KalmNpc[2]=ReplaceUnitBJ(udg_KalmNpc[2],'n02R',bj_UNIT_STATE_METHOD_RELATIVE) // 'n02R': unit "Armor Vendor"
        return
    endif
    if(Trig_News_Morning_IsMorningDay9())then
        set udg_NewsText[1]="|cffffcc00Knights Suggests Chocobos In Kalm|r"
        set udg_NewsText[4]="A knight in our town is tired of riding horses, and deposited a wish to ride chocobos instead. Cid responds saying they do not have the nuts necessary to tame enough for a cavalry, as Luchil, Carob and Zeio Nuts are not found near Kalm. Too bad!"
        return
    endif
endfunction

function Trig_News_Evening_IsSideQuest1Done takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[1]))
endfunction

function Trig_News_Evening_IsSideQuest1Found takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[1]))
endfunction

function Trig_News_Evening_IsEveningDay1 takes nothing returns boolean
    return(udg_GameDay==1)
endfunction

function Trig_News_Evening_IsSideQuest5Done takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[5]))
endfunction

function Trig_News_Evening_IsSideQuest5Failed takes nothing returns boolean
    return(IsQuestFailed(udg_SideQuest[5]))
endfunction

function Trig_News_Evening_IsCaravanEscorted takes nothing returns boolean
    return(udg_StoryFlag[1])
endfunction

function Trig_News_Evening_IsSideQuest5Found takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[5]))
endfunction

function Trig_News_Evening_IsEveningDay2 takes nothing returns boolean
    return(udg_GameDay==2)
endfunction

function Trig_News_Evening_IsElixirOnSale takes nothing returns boolean
    return(udg_StoryFlag[2])
endfunction

function Trig_News_Evening_IsEveningDay3 takes nothing returns boolean
    return(udg_GameDay==3)
endfunction

function Trig_News_Evening_IsSideQuest15Done takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$F])) // $F = 15
endfunction

function Trig_News_Evening_IsEveningDay4 takes nothing returns boolean
    return(udg_GameDay==4)
endfunction

function Trig_News_Evening_IsEveningDay5 takes nothing returns boolean
    return(udg_GameDay==5)
endfunction

function Trig_News_Evening_IsEveningDay6 takes nothing returns boolean
    return(udg_GameDay==6)
endfunction

function Trig_News_Evening_IsEveningDay7 takes nothing returns boolean
    return(udg_GameDay==7)
endfunction

function Trig_News_Evening_IsEveningDay8 takes nothing returns boolean
    return(udg_GameDay==8)
endfunction

function Trig_News_Evening_IsEveningDay9 takes nothing returns boolean
    return(udg_GameDay==9)
endfunction

function Trig_News_Evening_Actions takes nothing returns nothing
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,25.,100.,50.)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    if(Trig_News_Evening_IsEveningDay1())then
        set udg_NewsText[1]="|cffffcc00Entry By Elena|r"
        if(Trig_News_Evening_IsSideQuest1Found())then
            if(Trig_News_Evening_IsSideQuest1Done())then
                set udg_NewsText[4]="\"I'd like to thank the adventurers, who recently helped me find Shimmerweed. Thank you!\""
            else
                set udg_NewsText[4]="\"I'd like to thank the adventurers, that are trying to find Shimmerweed for me. Thank you and don't give up!\""
            endif
        else
            set udg_NewsText[4]="\"A message to the adventurers, who recently arrived in Kalm: Please help me, I desperately need 'Shimmerweed', but it's too dangerous for me in Guardia Forest!\""
        endif
    endif
    if(Trig_News_Evening_IsEveningDay2())then
        if(Trig_News_Evening_IsSideQuest5Found())then
            if(Trig_News_Evening_IsCaravanEscorted())then
                if(Trig_News_Evening_IsSideQuest5Done())then
                    set udg_NewsText[1]="|cffffcc00Sam's Thanks|r"
                    set udg_NewsText[4]="\"Thanks to the adventurers, who arrived in Kalm yesterday, the caravan from Dio was able to come here safely and the Delivery Confirmation has been brought back. THANKS!!!\""
                endif
            else
                if(Trig_News_Evening_IsSideQuest5Failed())then
                    set udg_NewsText[1]="|cffffcc00Sam Is Disappointed|r"
                    set udg_NewsText[4]="\"A person from the farm arrived at my place, telling me that Dio's caravan has died during delivery. He also told me that the caravan was supposed to be protected. Shame on you, adventurers, I'm disappointed!\""
                else
                    set udg_NewsText[1]="|cffffcc00Sam's Thanks|r"
                    set udg_NewsText[4]="\"Thanks to the adventurers, which arrived yesterday, the caravan from Dio was successfully protected from dangers during delivery. Thanks, now just bring back that confirmation!\""
                endif
            endif
        else
            set udg_NewsText[1]="|cffffcc00No Caravan From Farm|r"
            set udg_NewsText[4]="Sam is impatiently awaiting a caravan from Dio, from the farm. But it hasn't arrived yet. It should've arrived three days ago. Has something happened?"
        endif
    endif
    if(Trig_News_Evening_IsEveningDay3())then
        set udg_NewsText[1]="|cffffcc00Kesha's Special Brew Voted Best Drink|r"
        if(Trig_News_Evening_IsElixirOnSale())then
            set udg_NewsText[4]="A global survey showed that Kesha's Special Brew is the most popular drink in the whole town. Second is the Elixir by the Pandaren Fire."
        else
            set udg_NewsText[4]="A global survey showed that Kesha's Special Brew is the most popular drink in the whole town. Second is the Nectar by the Pandaren Fire."
        endif
    endif
    if(Trig_News_Evening_IsEveningDay4())then
        if(Trig_News_Evening_IsSideQuest15Done())then
            set udg_NewsText[1]="|cffffcc00Small Boy Finally Healed!|r"
            set udg_NewsText[4]="Thanks to the adventurers, which have brought healing waters of Fountain of Restoration, a small boy at the age of 7 was saved from a bad illness. Special Thanks come from Zalmo, Alma and Cid!"
        else
            set udg_NewsText[1]="|cffffcc00Small Boy Caught Deadly Illness|r"
            set udg_NewsText[4]="A few days ago, a poor small boy fell ill. It is a deadly illness never seen before in Kalm. Neither Zalmo nor Alma can heal the poor boy - who can?"
        endif
    endif
    if(Trig_News_Evening_IsEveningDay5())then
        set udg_NewsText[1]="|cffffcc00Exotic Stones Stolen!!|r"
        set udg_NewsText[4]="Some idiot has stolen Kesha's exotic stones, which he desperately needs for his special brew while Kesha was painting his roof. Now, they are scattered across Kalm. Who can find them?"
        call ConditionalTriggerExecute(gg_trg_Kesha_Stones_Spawn)
    endif
    if(Trig_News_Evening_IsEveningDay6())then
        set udg_NewsText[1]="|cffffcc00Fire Congratulates Cid Using An Offer!|r"
        set udg_NewsText[4]="Fire celebrates Cid's anniversary a lot different than we do. He offers FIFTY PERCENT off Nectar till 6:00 next morning, so come now or pay the double price!"
        call RemoveItemFromStockBJ('I02V',gg_unit_n001_0012) // 'I02V': item "Nectar"
        call AddItemToStockBJ('I03Z',gg_unit_n001_0012,3,3) // 'I03Z': item "Nectar (50% off!)"
    endif
    if(Trig_News_Evening_IsEveningDay7())then
        set udg_NewsText[1]="|cffffcc00Xu: Fell Ill And Got Healed|r"
        set udg_NewsText[4]="Alma and Zalmo have healed yet another person. Xu, high elf woman, fell ill and got healed a few hours later. \"Thank you so much!\", she said."
    endif
    if(Trig_News_Evening_IsEveningDay8())then
        set udg_NewsText[1]="|cffffcc00Advertisement|r"
        set udg_NewsText[4]="Had a hard day? Got hurt? Are you exhausted? Well, come to Kesha's Place and drink Kesha's Special Brew! This drink is only surpassed by the Megalixir."
    endif
    if(Trig_News_Evening_IsEveningDay9())then
        set udg_NewsText[1]="|cffffcc00Retirement|r"
        set udg_NewsText[4]="I, Wedge, have decided to retire from writing the morning and evening news. Other articles may still be posted by other people. Thank you to all loyal readers!"
        call AddItemToStockBJ('I043',gg_unit_h00K_0137,1,1) // 'I043': item "Make Own Entry"
        call EnableTrigger(gg_trg_News_SetTitle)
        call EnableTrigger(gg_trg_News_SetEntry)
        call EnableTrigger(gg_trg_News_SubmitEntry)
    endif
endfunction

function Trig_News_SetTitle_Conditions takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,$C)=="-news title ") // $C = 12
endfunction

function Trig_News_SetTitle_IsTitleTooShort takes nothing returns boolean
    return(StringLength(GetEventPlayerChatString())<=$F) // $F = 15
endfunction

function Trig_News_SetTitle_IsTitleCharNotSpace takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),GetForLoopIndexA(),GetForLoopIndexA())!=" ")
endfunction

function Trig_News_SetTitle_IsTitleAllSpaces takes nothing returns boolean
    return(udg_NewsTextAllSpaces)
endfunction

function Trig_News_SetTitle_Actions takes nothing returns nothing
    if(Trig_News_SetTitle_IsTitleTooShort())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"The string must be at least 3 spaces long!")
        return
    endif
    set udg_NewsTextAllSpaces=true
    set bj_forLoopAIndex=$D // $D = 13
    set bj_forLoopAIndexEnd=StringLength(GetEventPlayerChatString())
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_News_SetTitle_IsTitleCharNotSpace())then
            set udg_NewsTextAllSpaces=false
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_News_SetTitle_IsTitleAllSpaces())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"You cannot set the news to nothing but spaces!")
        return
    endif
    set udg_NewsTitle[GetConvertedPlayerId(GetTriggerPlayer())]=SubStringBJ(GetEventPlayerChatString(),$D,StringLength(GetEventPlayerChatString())) // $D = 13
    call DisplayTimedTextToForce(GetPlayersAll(),10.,"Success!")
endfunction

function Trig_News_SetEntry_Conditions takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,$C)=="-news entry ") // $C = 12
endfunction

function Trig_News_SetEntry_IsEntryTooShort takes nothing returns boolean
    return(StringLength(GetEventPlayerChatString())<=$F) // $F = 15
endfunction

function Trig_News_SetEntry_IsEntryCharNotSpace takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),GetForLoopIndexA(),GetForLoopIndexA())!=" ")
endfunction

function Trig_News_SetEntry_IsEntryAllSpaces takes nothing returns boolean
    return(udg_NewsTextAllSpaces)
endfunction

function Trig_News_SetEntry_Actions takes nothing returns nothing
    if(Trig_News_SetEntry_IsEntryTooShort())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"The string must be at least 3 spaces long!")
        return
    endif
    set udg_NewsTextAllSpaces=true
    set bj_forLoopAIndex=$D // $D = 13
    set bj_forLoopAIndexEnd=StringLength(GetEventPlayerChatString())
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_News_SetEntry_IsEntryCharNotSpace())then
            set udg_NewsTextAllSpaces=false
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_News_SetEntry_IsEntryAllSpaces())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"You cannot set the news to nothing but spaces!")
        return
    endif
    set udg_NewsEntry[GetConvertedPlayerId(GetTriggerPlayer())]=SubStringBJ(GetEventPlayerChatString(),$D,StringLength(GetEventPlayerChatString())) // $D = 13
    call DisplayTimedTextToForce(GetPlayersAll(),10.,"Success!")
endfunction

function Trig_News_SubmitEntry_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I043') // 'I043': item "Make Own Entry"
endfunction

function Trig_News_SubmitEntry_IsOnCooldown takes nothing returns boolean
    return(udg_NewsEntryCooldown[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_News_SubmitEntry_IsEntryUnset takes nothing returns boolean
    return(udg_NewsEntry[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=="no")
endfunction

function Trig_News_SubmitEntry_IsTitleUnset takes nothing returns boolean
    return(udg_NewsTitle[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=="no")
endfunction

function Trig_News_SubmitEntry_IsTitleAndEntryUnset takes nothing returns boolean
    return(udg_NewsTitle[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=="no")and(udg_NewsEntry[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=="no")
endfunction

function Trig_News_SubmitEntry_Actions takes nothing returns nothing
    if(Trig_News_SubmitEntry_IsOnCooldown())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"You must wait at least 3 minutes after submitting an entry before being able to submit another one!")
        call AdjustPlayerStateBJ(25,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
        return
    endif
    if(Trig_News_SubmitEntry_IsTitleAndEntryUnset())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"You didn't set either Title or Entry!")
        call AdjustPlayerStateBJ(25,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
        return
    else
        if(Trig_News_SubmitEntry_IsTitleUnset())then
            call DisplayTimedTextToForce(GetPlayersAll(),10.,"You didn't set the Title!")
            call AdjustPlayerStateBJ(25,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
            return
        else
            if(Trig_News_SubmitEntry_IsEntryUnset())then
                call DisplayTimedTextToForce(GetPlayersAll(),10.,"You didn't set the Entry!")
                call AdjustPlayerStateBJ(25,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
                return
            endif
        endif
    endif
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]=udg_NewsTitle[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]
    set udg_NewsText[4]=udg_NewsEntry[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]
    set udg_NewsTitle[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]="no"
    set udg_NewsEntry[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]="no"
    set udg_NewsEntryCooldown[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
    call Wait_Polled(180.)
    set udg_NewsEntryCooldown[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
endfunction

// World Editor calls InitTrig_News automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_News_Part1 / RegisterTriggers_News_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_News takes nothing returns nothing
endfunction

function Register_News_Morning takes nothing returns nothing
    set gg_trg_News_Morning=CreateTrigger()
    call DisableTrigger(gg_trg_News_Morning)
    call TriggerRegisterGameStateEventTimeOfDay(gg_trg_News_Morning,EQUAL,6.)
    call TriggerAddAction(gg_trg_News_Morning,function Trig_News_Morning_Actions)
endfunction

function Register_News_Evening takes nothing returns nothing
    set gg_trg_News_Evening=CreateTrigger()
    call TriggerRegisterGameStateEventTimeOfDay(gg_trg_News_Evening,EQUAL,18.)
    call TriggerAddAction(gg_trg_News_Evening,function Trig_News_Evening_Actions)
endfunction

function Register_News_SetTitle takes nothing returns nothing
    set gg_trg_News_SetTitle=CreateTrigger()
    call DisableTrigger(gg_trg_News_SetTitle)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(0),"-news title ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(1),"-news title ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(2),"-news title ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(3),"-news title ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(4),"-news title ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(5),"-news title ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(6),"-news title ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetTitle,Player(7),"-news title ",false)
    call TriggerAddCondition(gg_trg_News_SetTitle,Condition(function Trig_News_SetTitle_Conditions))
    call TriggerAddAction(gg_trg_News_SetTitle,function Trig_News_SetTitle_Actions)
endfunction

function Register_News_SetEntry takes nothing returns nothing
    set gg_trg_News_SetEntry=CreateTrigger()
    call DisableTrigger(gg_trg_News_SetEntry)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(0),"-news entry ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(1),"-news entry ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(2),"-news entry ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(3),"-news entry ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(4),"-news entry ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(5),"-news entry ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(6),"-news entry ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_News_SetEntry,Player(7),"-news entry ",false)
    call TriggerAddCondition(gg_trg_News_SetEntry,Condition(function Trig_News_SetEntry_Conditions))
    call TriggerAddAction(gg_trg_News_SetEntry,function Trig_News_SetEntry_Actions)
endfunction

function Register_News_SubmitEntry takes nothing returns nothing
    set gg_trg_News_SubmitEntry=CreateTrigger()
    call DisableTrigger(gg_trg_News_SubmitEntry)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_News_SubmitEntry,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_News_SubmitEntry,Condition(function Trig_News_SubmitEntry_Conditions))
    call TriggerAddAction(gg_trg_News_SubmitEntry,function Trig_News_SubmitEntry_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_News_Part1 takes nothing returns nothing
    call Register_News_Morning()
    call Register_News_Evening()
    call Register_News_SetTitle()
    call Register_News_SetEntry()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_News_Part2 takes nothing returns nothing
    call Register_News_SubmitEntry()
endfunction

endlibrary

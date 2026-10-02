library TNameDiary requires TCam, TCine, TForce, TPlayerPart01, TReward, TText, TUnit
function Trig_NameDiary_Prepare_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_SpecialEffect[80]=AddSpecialEffectTargetUnitBJ("overhead",udg_TimmyUnit,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_NameDiary_Start)
    set udg_DiaryNameCount=0
    set udg_DiaryEntry[1]="A"
    set udg_DiaryEntry[2]="B"
    set udg_DiaryEntry[3]="C"
    set udg_DiaryEntry[4]="D"
    set udg_DiaryEntry[5]="E"
    set udg_DiaryEntry[6]="F"
    set udg_DiaryEntry[7]="G"
    set udg_DiaryEntry[8]="H"
    set udg_DiaryEntry[9]="I"
    set udg_DiaryEntry[$A]="J" // $A = 10
    set udg_DiaryEntry[$B]="K" // $B = 11
    set udg_DiaryEntry[$C]="L" // $C = 12
    set udg_DiaryEntry[$D]="M" // $D = 13
    set udg_DiaryEntry[$E]="N" // $E = 14
    set udg_DiaryEntry[$F]="O" // $F = 15
    set udg_DiaryEntry[16]="P"
    set udg_DiaryEntry[17]="Q"
    set udg_DiaryEntry[18]="R"
    set udg_DiaryEntry[19]="S"
    set udg_DiaryEntry[20]="T"
    set udg_DiaryEntry[21]="U"
    set udg_DiaryEntry[22]="V"
    set udg_DiaryEntry[23]="W"
    set udg_DiaryEntry[24]="X"
    set udg_DiaryEntry[25]="Y"
    set udg_DiaryEntry[26]="Z"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_NameDiary_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_TimmyUnit,true,true,true))
endfunction

function Trig_NameDiary_Start_MatchesLetterSlot takes nothing returns boolean
    return(SubStringBJ(udg_TempString,1,1)==SubStringBJ(udg_DiaryEntry[GetForLoopIndexA()],1,1))
endfunction

function Trig_NameDiary_Start_HasLetterSlot takes nothing returns boolean
    return(udg_TempInteger!=0)
endfunction

function Trig_NameDiary_Start_IsNameUsable takes nothing returns boolean
    return(StringLength(udg_TempString)>1)and(StringCase(SubStringBJ(udg_TempString,1,1),false)!=StringCase(SubStringBJ(udg_TempString,1,1),true))
endfunction

function Trig_NameDiary_Start_HasAnyEntry takes nothing returns boolean
    return(udg_DiaryNameCount>=1)
endfunction

function Trig_NameDiary_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_NameDiary_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[80])
    set udg_TempString=udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]
    if(Trig_NameDiary_Start_IsNameUsable())then
        set udg_TempString=(StringCase(SubStringBJ(udg_TempString,1,1),true)+SubStringBJ(udg_TempString,2,StringLength(udg_TempString)))
        set udg_TempInteger=0
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=26
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_NameDiary_Start_MatchesLetterSlot())then
                set udg_TempInteger=GetForLoopIndexA()
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        if(Trig_NameDiary_Start_HasLetterSlot())then
            set udg_DiaryEntry[udg_TempInteger]=udg_TempString
            set udg_DiaryNameCount=(udg_DiaryNameCount+1)
        endif
    endif
    if(Trig_NameDiary_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(udg_TimmyUnit,"Hey you're the ones who saved me right?",false)
        call Text_Say(udg_TimmyUnit,"I heard you guys are big adventurers, traveling all over the world!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That we are. We travel all over Gaya.",false)
        call Text_Say(udg_TimmyUnit,"Wooow! I've never been anywhere besides here, except when I got captured.",false)
        call Text_Say(gg_unit_n00I_0011,"Timmy says he wants to explore the whole world someday.",false)
        call Text_Say(gg_unit_n00I_0011,"Of course with what happened here recently I'm not about to let him leave just yet. It's far too dangerous. But he did have something to ask of you, something that only adventurers can do for him.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Something only we can do? We aren't kindergarteners you know.",false)
        call Text_Say(gg_unit_n00I_0011,"I know, but please hear him out.",false)
        call Text_Say(udg_TimmyUnit,"Umm... well look at this.\r\n\r\n|cffffcc00Timmy pushes a small book into your hands.|r",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What's this? A... B... C...?",false)
        call Text_Say(udg_TimmyUnit,"It was me and my dad's diary. Just before he set out, we had made a promise; that whenever he'd meet someone from somewhere other than here, he'd put their names in this list. So he could show me and tell me about what kinds of people there are in this world.",false)
        call Text_Say(gg_unit_n00I_0011,"It was supposed to be one name for every letter of the alphabet. But... well you know what happened...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. And now you want us to be the ones to fill this diary with names from all over the world in his stead.",false)
        call Text_Say(udg_TimmyUnit,"Would you do it?",false)
        call Text_Say(gg_unit_n00I_0011,"Please. I'll reward you if you do this for him. You don't need to give a history lesson after. Just fill out the list, it'll give him something to wonder about at night.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, we'll do it. We'll fill out the whole list!",false)
        if(Trig_NameDiary_Start_HasAnyEntry())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I suppose I'll start by putting my own name in here... and now to find 25 others.",false)
        endif
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Name Diary|r")
    set udg_TempString="Timmy wants you to chronicle names from people all over the world in his diary. Get at least one for each letter of the alphabet!|n"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=26
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempString=(udg_TempString+("|n"+udg_DiaryEntry[GetForLoopIndexA()]))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_SideQuest[60]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Name Diary"),udg_TempString,"ReplaceableTextures\\CommandButtons\\BTNBansheeMaster.blp")
    set udg_QuestReq[5]=CreateQuestItemBJ(udg_SideQuest[60],("Names chronicled: "+(I2S(udg_DiaryNameCount)+"/26")))
    call AddSpecialEffectTargetUnitBJ("overhead",udg_TimmyUnit,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_QuestItem[$D]=UnitAddItemByIdSwapped('I0IA',Player_GetHero(GetTriggerPlayer())) // $D = 13; 'I0IA': item "Name Diary"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_SpecialEffect[80]=GetLastCreatedEffectBJ()
    call EnableTrigger(gg_trg_NameDiary_Chronicle)
    call EnableTrigger(gg_trg_NameDiary_Ping)
    call TriggerRegisterUnitInRangeSimple(gg_trg_NameDiary_Reward,450.,udg_TimmyUnit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_NameDiary_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[$D]!=null) // $D = 13
endfunction

function Trig_NameDiary_Ping_IsDiaryFull takes nothing returns boolean
    return(udg_DiaryNameCount>=26)
endfunction

function Trig_NameDiary_Ping_IsDiaryDropped takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[$D])==false) // $D = 13
endfunction

function Trig_NameDiary_Ping_Actions takes nothing returns nothing
    if(Trig_NameDiary_Ping_IsDiaryDropped())then
        set udg_TempPoint=GetItemLoc(udg_QuestItem[$D]) // $D = 13
        call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
        call RemoveLocation(udg_TempPoint)
    else
        if(Trig_NameDiary_Ping_IsDiaryFull())then
            set udg_TempPoint=GetUnitLoc(udg_TimmyUnit)
            call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
            call RemoveLocation(udg_TempPoint)
        endif
    endif
endfunction

function Trig_NameDiary_Chronicle_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZP') // 'A0ZP': ability "Name Chronicle"
endfunction

function Trig_NameDiary_Chronicle_IsDiaryFull takes nothing returns boolean
    return(udg_DiaryNameCount>=26)
endfunction

function Trig_NameDiary_Chronicle_IsTargetHero takes nothing returns boolean
    return(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_NameDiary_Chronicle_IsKatyaOrTimmy takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n00I')or(GetUnitTypeId(GetSpellTargetUnit())=='n00J') // 'n00I': unit "Katya"; 'n00J': unit "Timmy"
endfunction

function Trig_NameDiary_Chronicle_IsBannedTarget takes nothing returns boolean
    return(Trig_NameDiary_Chronicle_IsKatyaOrTimmy())
endfunction

function Trig_NameDiary_Chronicle_IsGenericUnitType takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='hfoo')or(GetUnitTypeId(GetSpellTargetUnit())=='hkni')or(GetUnitTypeId(GetSpellTargetUnit())=='hhes')or(GetUnitTypeId(GetSpellTargetUnit())=='hcth')or(GetUnitTypeId(GetSpellTargetUnit())=='nhef')or(GetUnitTypeId(GetSpellTargetUnit())=='nhem')or(GetUnitTypeId(GetSpellTargetUnit())=='nhea')or(GetUnitTypeId(GetSpellTargetUnit())=='nvlk')or(GetUnitTypeId(GetSpellTargetUnit())=='nvk2')or(GetUnitTypeId(GetSpellTargetUnit())=='nvlw')or(GetUnitTypeId(GetSpellTargetUnit())=='nvil')or(GetUnitTypeId(GetSpellTargetUnit())=='nvl2')or(GetUnitTypeId(GetSpellTargetUnit())=='hrdh')or(GetUnitTypeId(GetSpellTargetUnit())=='hbew')or(GetUnitTypeId(GetSpellTargetUnit())=='ewsp')or(GetUnitTypeId(GetSpellTargetUnit())=='earc')or(GetUnitTypeId(GetSpellTargetUnit())=='esen')or(GetUnitTypeId(GetSpellTargetUnit())=='edot')or(GetUnitTypeId(GetSpellTargetUnit())=='edoc')or(GetUnitTypeId(GetSpellTargetUnit())=='nwat')or(GetUnitTypeId(GetSpellTargetUnit())=='nssn')or(GetUnitTypeId(GetSpellTargetUnit())=='etrs')or(GetUnitTypeId(GetSpellTargetUnit())=='edes')or(GetUnitTypeId(GetSpellTargetUnit())=='ebsh')or(GetUnitTypeId(GetSpellTargetUnit())=='e00E')or(GetUnitTypeId(GetSpellTargetUnit())=='e011')or(GetUnitTypeId(GetSpellTargetUnit())=='e010')or(GetUnitTypeId(GetSpellTargetUnit())=='n0BM')or(GetUnitTypeId(GetSpellTargetUnit())=='e00Y')or(GetUnitTypeId(GetSpellTargetUnit())=='n02X')or(GetUnitTypeId(GetSpellTargetUnit())=='n015')or(GetUnitTypeId(GetSpellTargetUnit())=='n03A')or(GetUnitTypeId(GetSpellTargetUnit())=='n039')or(GetUnitTypeId(GetSpellTargetUnit())=='n0M3')or(GetUnitTypeId(GetSpellTargetUnit())=='n0M2') // 'hfoo': object name not found in map data; 'hkni': unit "Mounted Knight"; 'hhes': unit "Knight"; 'hcth': object name not found in map data; 'nhef': unit "High Elf Female"; 'nhem': unit "High Elf Male"; 'nhea': object name not found in map data; 'nvlk': unit "Human Child"; 'nvk2': unit "Human Child"; 'nvlw': unit "Human Female"; 'nvil': unit "Human Male"; 'nvl2': unit "Human Male"; 'hrdh': object name not found in map data; 'hbew': object name not found in map data; 'ewsp': object name not found in map data; 'earc': object name not found in map data; 'esen': editor label "Huntress"; 'edot': unit "Wizard"; 'edoc': unit "Monk"; 'nwat': object name not found in map data; 'nssn': object name not found in map data; 'etrs': unit "Night Elf Fishing Ship"; 'edes': object name not found in map data; 'ebsh': object name not found in map data; 'e00E': unit "Night Elf Supply Ship"; 'e011': unit "Phantom Archer"; 'e010': unit "Phantom Wizard"; 'n0BM': unit "Phantom Warden"; 'e00Y': unit "Mysterious Blue Girl"; 'n02X': unit "Jack's Little Hydra"; 'n015': unit "Mithril Golem"; 'n03A': unit "Qu's Frog"; 'n039': unit "Magic Frog"; 'n0M3': unit "Kobold Merchant"; 'n0M2': unit "Spiritual Trader"
endfunction

function Trig_NameDiary_Chronicle_IsUnnamedTarget takes nothing returns boolean
    return(Trig_NameDiary_Chronicle_IsGenericUnitType())
endfunction

function Trig_NameDiary_Chronicle_IsInvalidTargetType takes nothing returns boolean
    return((GetOwningPlayer(GetSpellTargetUnit())==Player($B))or(GetOwningPlayer(GetSpellTargetUnit())==Player(PLAYER_NEUTRAL_PASSIVE))or(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_STRUCTURE))or(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_SUMMONED))or(IsUnitInGroup(GetSpellTargetUnit(),udg_QuestNpcUnits))or(GetUnitName(GetSpellTargetUnit())=="Chocobo"))!=null // $B = 11
endfunction

function Trig_NameDiary_Chronicle_IsInvalidTarget takes nothing returns boolean
    return(Trig_NameDiary_Chronicle_IsInvalidTargetType())
endfunction

function Trig_NameDiary_Chronicle_IsTargetPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetSpellTargetUnit()),udg_PlayingPlayers))
endfunction

function Trig_NameDiary_Chronicle_IsNameTooShort takes nothing returns boolean
    return(StringLength(udg_TempString)<=1)
endfunction

function Trig_NameDiary_Chronicle_IsClydeUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_ShadowUnit)and(GetOwningPlayer(udg_ShadowUnit)==Player(9))
endfunction

function Trig_NameDiary_Chronicle_HasShadowEntry takes nothing returns boolean
    return(udg_DiaryEntry[3]=="C")and(udg_DiaryEntry[19]=="Shadow")
endfunction

function Trig_NameDiary_Chronicle_IsNameClyde takes nothing returns boolean
    return(udg_TempString=="Clyde")
endfunction

function Trig_NameDiary_Chronicle_IsGeneralLeo takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='h02I') // 'h02I': unit "General Leo"
endfunction

function Trig_NameDiary_Chronicle_MatchesLetterSlot takes nothing returns boolean
    return(SubStringBJ(udg_TempString,1,1)==SubStringBJ(udg_DiaryEntry[GetForLoopIndexA()],1,1))
endfunction

function Trig_NameDiary_Chronicle_HasNoLetterSlot takes nothing returns boolean
    return(udg_TempInteger==0)
endfunction

function Trig_NameDiary_Chronicle_IsLetterTaken takes nothing returns boolean
    return(StringLength(udg_DiaryEntry[udg_TempInteger])>1)
endfunction

function Trig_NameDiary_Chronicle_IsDiaryComplete takes nothing returns boolean
    return(udg_DiaryNameCount>=26)
endfunction

function Trig_NameDiary_Chronicle_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_NameDiary_Chronicle_IsDiaryFull())then
        call DisplayTimedTextToForce(udg_TempForce,10.,"The Name Diary is already full!")
        call DestroyForce(udg_TempForce)
        return
    endif
    if(Trig_NameDiary_Chronicle_IsTargetPlayerUnit())then
        set udg_TempString=udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]
    else
        if(Trig_NameDiary_Chronicle_IsInvalidTarget())then
            call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000This unit is not a valid target!|r")
            call DestroyForce(udg_TempForce)
            return
        else
            if(Trig_NameDiary_Chronicle_IsUnnamedTarget())then
                call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000This unit's name cannot be chronicled!|r")
                call DestroyForce(udg_TempForce)
                return
            else
                if(Trig_NameDiary_Chronicle_IsBannedTarget())then
                    call DisplayTimedTextToForce(udg_TempForce,10.,"Katya and Timmy's names cannot be put in the diary!")
                    call DestroyForce(udg_TempForce)
                    return
                else
                    if(Trig_NameDiary_Chronicle_IsTargetHero())then
                        set udg_TempString=GetHeroProperName(GetSpellTargetUnit())
                    else
                        set udg_TempString=GetUnitName(GetSpellTargetUnit())
                    endif
                endif
            endif
        endif
    endif
    if(Trig_NameDiary_Chronicle_IsNameTooShort())then
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000This unit's name cannot be chronicled!|r")
        call DestroyForce(udg_TempForce)
        return
    endif
    if(Trig_NameDiary_Chronicle_IsGeneralLeo())then
        set udg_TempString="Leo"
    else
        if(Trig_NameDiary_Chronicle_IsClydeUnit())then
            set udg_TempString="Clyde"
        else
            set udg_TempString=(StringCase(SubStringBJ(udg_TempString,1,1),true)+SubStringBJ(udg_TempString,2,StringLength(udg_TempString)))
        endif
        if(Trig_NameDiary_Chronicle_IsNameClyde())then
            if(Trig_NameDiary_Chronicle_HasShadowEntry())then
                call DisplayTimedTextToForce(udg_TempForce,10.,"Struck the name 'Shadow' from the diary.")
                set udg_DiaryEntry[19]="S"
                set udg_DiaryNameCount=(udg_DiaryNameCount-1)
            endif
        endif
    endif
    set udg_TempInteger=0
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=26
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_NameDiary_Chronicle_MatchesLetterSlot())then
            set udg_TempInteger=GetForLoopIndexA()
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_NameDiary_Chronicle_HasNoLetterSlot())then
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000This unit's name cannot be chronicled!|r")
        call DestroyForce(udg_TempForce)
        return
    endif
    if(Trig_NameDiary_Chronicle_IsLetterTaken())then
        call DisplayTimedTextToForce(udg_TempForce,10.,("The Name Diary already has an entry for the letter '"+(SubStringBJ(udg_TempString,1,1)+"'!")))
        call DestroyForce(udg_TempForce)
        return
    endif
    set udg_DiaryEntry[udg_TempInteger]=udg_TempString
    set udg_DiaryNameCount=(udg_DiaryNameCount+1)
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,("Wrote the name '"+(udg_TempString+"' into the diary!")))
    call DestroyForce(udg_TempForce)
    call QuestItemSetDescriptionBJ(udg_QuestReq[5],("Names chronicled: "+(I2S(udg_DiaryNameCount)+"/26")))
    set udg_TempString="Timmy wants you to chronicle names from people all over the world in his diary. Get at least one for each letter of the alphabet!|n"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=26
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempString=(udg_TempString+("|n"+udg_DiaryEntry[GetForLoopIndexA()]))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call QuestSetDescriptionBJ(udg_SideQuest[60],udg_TempString)
    if(Trig_NameDiary_Chronicle_IsDiaryComplete())then
        call QuestItemSetCompletedBJ(udg_QuestReq[5],true)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Return the Name Diary to Timmy.")
        call EnableTrigger(gg_trg_NameDiary_Reward)
    endif
endfunction

function Trig_NameDiary_Reward_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0IA'))and(udg_InCinematicMode==false) // 'I0IA': item "Name Diary"
endfunction

function Trig_NameDiary_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_NameDiary_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_NameDiary_Chronicle)
    call DestroyTrigger(gg_trg_NameDiary_Chronicle)
    call DisableTrigger(gg_trg_NameDiary_Ping)
    call DestroyTrigger(gg_trg_NameDiary_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0IA')) // 'I0IA': item "Name Diary"
    call DestroyEffectBJ(udg_SpecialEffect[80])
    if(Trig_NameDiary_Reward_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go. We filled out the entire list!",false)
        call Text_Say(udg_TimmyUnit,"Wow! This is amazing!",false)
        call Text_Say(gg_unit_n00I_0011,"Thank you for your efforts. Here's your reward, as promised.",false)
        call Reward_Give(6500,7500,gg_unit_n00I_0011)
        call Cine_ExitAction()
    else
        call Reward_Give(6500,7500,gg_unit_n00I_0011)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Name Diary|r")
    call QuestSetCompletedBJ(udg_SideQuest[60],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_NameDiary takes nothing returns nothing
endfunction

function RegisterR11_NameDiary_Prepare takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_NameDiary_Prepare=CreateTrigger()

call DisableTrigger(gg_trg_NameDiary_Prepare)

call TriggerRegisterTimerExpireEventBJ(gg_trg_NameDiary_Prepare,udg_TimmyQuestTimer)

call TriggerAddAction(gg_trg_NameDiary_Prepare,function Trig_NameDiary_Prepare_Actions)

endfunction




function RegisterR11_NameDiary_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_NameDiary_Start=CreateTrigger()

call DisableTrigger(gg_trg_NameDiary_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NameDiary_Start,Player(7),true)

call TriggerAddCondition(gg_trg_NameDiary_Start,Condition(function Trig_NameDiary_Start_Conditions))

call TriggerAddAction(gg_trg_NameDiary_Start,function Trig_NameDiary_Start_Actions)

endfunction




function RegisterR11_NameDiary_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_NameDiary_Ping=CreateTrigger()

call DisableTrigger(gg_trg_NameDiary_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_NameDiary_Ping,15.)

call TriggerAddCondition(gg_trg_NameDiary_Ping,Condition(function Trig_NameDiary_Ping_Conditions))

call TriggerAddAction(gg_trg_NameDiary_Ping,function Trig_NameDiary_Ping_Actions)

endfunction




function RegisterR11_NameDiary_Chronicle takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_NameDiary_Chronicle=CreateTrigger()

call DisableTrigger(gg_trg_NameDiary_Chronicle)

call TriggerRegisterAnyUnitEventBJ(gg_trg_NameDiary_Chronicle,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_NameDiary_Chronicle,Condition(function Trig_NameDiary_Chronicle_Conditions))

call TriggerAddAction(gg_trg_NameDiary_Chronicle,function Trig_NameDiary_Chronicle_Actions)

endfunction




function RegisterR11_NameDiary_Reward takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_NameDiary_Reward=CreateTrigger()

call DisableTrigger(gg_trg_NameDiary_Reward)

call TriggerAddCondition(gg_trg_NameDiary_Reward,Condition(function Trig_NameDiary_Reward_Conditions))

call TriggerAddAction(gg_trg_NameDiary_Reward,function Trig_NameDiary_Reward_Actions)

endfunction




endlibrary

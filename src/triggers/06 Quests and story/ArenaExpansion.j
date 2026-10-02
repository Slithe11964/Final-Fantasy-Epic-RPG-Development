library TArenaExpansion requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_ArenaExpansion_Prepare_Cond_PrereqQuestPending takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[40])==false)
endfunction

function Trig_ArenaExpansion_Prepare_Actions takes nothing returns nothing
    if(Trig_ArenaExpansion_Prepare_Cond_PrereqQuestPending())then
        call StartTimerBJ(udg_SharedDelayTimer2,false,100.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffLimma has something to tell you !!|r")
    set udg_SpecialEffect[60]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e008_0132,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_ArenaExpansion_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ArenaExpansion_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e008_0132,true,true,true))
endfunction

function Trig_ArenaExpansion_Start_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ArenaExpansion_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[60])
    if(Trig_ArenaExpansion_Start_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e008_0132,"Hello again. It seems that I am once again in need of your aid.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Why did you call us, Limma?",false)
        call Text_Say(gg_unit_e008_0132,"In order to properly simulate battles in the arena, we will need to construct a Reality Marble.",false)
        call Text_Say(gg_unit_e008_0132,"Unfortunately, accomplishing such a feat requires two very rare artifacts; a Shadow Stone and Dimensional Dust.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That sounds troublesome, but we can handle gathering rare artifacts. Where can we get them?",false)
        call Text_Say(gg_unit_e008_0132,"Well that's the problem already. We're not really sure ourselves where to get either of them.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's a problem. Are we to just look aimlessly?",false)
        call Text_Say(gg_unit_e008_0132,"Not quite, no. While the specifics have been lost to history, we did create Shadow Stones in the past. Their power of drawing from the shadow cast by a fiend and trapping them inside of it has been the basis of creating Zodiac Stones which we used to imprison demons long ago.",false)
        call Text_Say(gg_unit_e008_0132,"A hundred years ago, we used two of them to seal away Hashmalum, the Brave of Earth, and Ultima, the Brave of Holy. We also wanted to capture Belias, the Brave of Fire, but unfortunately he disappeared and we never managed to do it.",false)
        call Text_Say(gg_unit_e008_0132,"The Shadow Stone we made for Belias should still be around. We didn't keep it in Lothlorien due to its danger, but you may find it hidden away.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Interesting. Where did you hide it?",false)
        call Text_Say(gg_unit_e008_0132,"It must be somewhere in the Barrens, the hottest place in Gaya. That's where the trap was to be laid. In order to camouflage it my sisters must have placed it somewhere in the shade. It's a very dark artifact so in the shade it's hard to see until you get very close to it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright. So what about the Dimension Dust then?",false)
        call Text_Say(gg_unit_e008_0132,"As the name suggests it can be found on the border between dimensions. But I'm afraid you won't be able to simply find it and pick it up. You need a special device for it as I recall.",false)
        call Text_Say(gg_unit_e008_0132,"I'd ask you to focus on the Shadow Stone for now. I'll see if I can find out more about how to gather Dimension Dust in the meantime.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright then. One more thing though, how much gold are we looking at for this job?",false)
        call Text_Say(gg_unit_e008_0132,"Right, well I'm willing to offer you 6000 Gold for both artifacts. I'll have to ask you to bring both of them though, just one won't help us get anywhere. Also you'll be able to participate in our simulated battles at your leisure. Sound alright?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's fine.",false)
        call Text_Say(gg_unit_e008_0132,"Good. Best of luck in your search!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"(Hmm, she said the Shadow Stones are 'created'. Maybe the people at the Bazaar in Kalm could create one if I bring them the right materials?)",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"(Well it's either that or finding this elusive hidden Shadow Stone. Either will do.)",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Arena Expansion|r")
    set udg_SideQuest[38]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Arena Expansion"),"Limma has asked you to bring her Shadow Stone. The Night Elves hid one away in the shade in the Barrens, but it blends in unless you get really close to it. Alternatively, the Bazaar in Kalm may be able to create one with the right materials.","ReplaceableTextures\\CommandButtons\\BTNCOP.blp")
    call EnableTrigger(gg_trg_ArenaExpansion_ShadowStoneTurnIn)
    call EnableTrigger(gg_trg_ArenaExpansion_ShadowStoneSpawn)
    set udg_SpecialEffect[60]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e008_0132,"Objects\\RandomObject\\RandomObject.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ArenaExpansion_ShadowStoneSpawn_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null
endfunction

function Trig_ArenaExpansion_ShadowStoneSpawn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetRectCenter(gg_rct_565)
    call CreateItemLoc('I05Q',udg_TempPoint) // 'I05Q': item "Shadow Stone"
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ArenaExpansion_ShadowStoneTurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I05Q'))and(IsUnitHiddenBJ(gg_unit_e008_0132)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I05Q': item "Shadow Stone"
endfunction

function Trig_ArenaExpansion_ShadowStoneTurnIn_Cond_ItemHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05Q'))>=2) // 'I05Q': item "Shadow Stone"
endfunction

function Trig_ArenaExpansion_ShadowStoneTurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ArenaExpansion_ShadowStoneTurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_ArenaExpansion_ShadowStoneTurnIn_Cond_ItemHasCharges())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I05Q')) minus (1).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05Q'))-1)) // 'I05Q': item "Shadow Stone"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05Q')) // 'I05Q': item "Shadow Stone"
    endif
    if(Trig_ArenaExpansion_ShadowStoneTurnIn_Cond_ShowDialogue())then
        call DestroyEffectBJ(udg_SpecialEffect[60])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e008_0132,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go, we got a Shadow Stone.",false)
        call Text_Say(gg_unit_e008_0132,"Oh, thank you so much! In the meantime I've found more about the Dimension Dust.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Great, how can we get it then?",false)
        call Text_Say(gg_unit_e008_0132,"As I mentioned before, Dimension Dust gathers on the boundary of the world. However it is normally so small as to be impossible to see or touch.",false)
        call Text_Say(gg_unit_e008_0132,"But properly compressed and clumped it can be seen and even picked up. And as luck would have it, we have a device that allows doing just that.",false)
        call Text_Say(gg_unit_e008_0132,"We call it a Boundary Vaccuum. It'll help you compress the Dimension Dust easily!\r\n\r\n|cffffcc00Limma gives you a Boundary Vaccuum.|r",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well that doesn't sound too complicated then.",false)
        call Text_Say(gg_unit_e008_0132,"Oh I do need to warn you about one thing; the boundary of the world is guarded by another demon.",false)
        call Text_Say(gg_unit_e008_0132,"Fortunately he lives isolated from the rest so we just ignored him, but he remains a powerful foe and you'll have to take him down if you wish to gather the dust.",false)
        call Text_Say(gg_unit_e008_0132,"Good luck, and thanks for your efforts!",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[60]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e008_0132,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Get Dimension Dust from the border between dimensions.")
    call QuestSetDescriptionBJ(udg_SideQuest[38],"Limma has asked you to get some Dimension Dust from the border between dimensions using the Boundary Vaccuum. The border is apparently guarded by a demon which will need to be defeated to be able to gather the dust.")
    call EnableTrigger(gg_trg_ArenaExpansion_GatherDust)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ArenaExpansion_GatherDust_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsQuestCompleted(udg_SideQuest[40])))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_ArenaExpansion_GatherDust_Cond_AnySlotEmpty takes nothing returns boolean
    return(UnitItemInSlotBJ(GetTriggerUnit(),1)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),2)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),3)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),4)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),5)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),6)==null)
endfunction

function Trig_ArenaExpansion_GatherDust_Cond_InventoryHasRoom takes nothing returns boolean
    return(Trig_ArenaExpansion_GatherDust_Cond_AnySlotEmpty())
endfunction

function Trig_ArenaExpansion_GatherDust_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_ArenaExpansion_GatherDust_Cond_InventoryHasRoom())then
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call UnitAddItemByIdSwapped('I05R',GetTriggerUnit()) // 'I05R': item "Dimension Dust"
    else
        call AddSpecialEffectTargetUnitBJ("origin",udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call UnitAddItemByIdSwapped('I05R',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]) // 'I05R': item "Dimension Dust"
    endif
    set udg_QuestItem[24]=GetLastCreatedItem()
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_ArenaExpansion_PingDust)
    call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" used the Boundary Vaccuum to gather Dimension Dust."))
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Bring the Dimension Dust back to Limma.")
    call QuestSetDescriptionBJ(udg_SideQuest[38],"Bring Dimension Dust to Limma.")
    call EnableTrigger(gg_trg_ArenaExpansion_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ArenaExpansion_PingDust_Conditions takes nothing returns boolean
    return(udg_QuestItem[24]!=null)
endfunction

function Trig_ArenaExpansion_PingDust_Cond_DustCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[24]))
endfunction

function Trig_ArenaExpansion_PingDust_Actions takes nothing returns nothing
    if(Trig_ArenaExpansion_PingDust_Cond_DustCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_e008_0132)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[24])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_ArenaExpansion_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I05R'))and(IsUnitHiddenBJ(gg_unit_e008_0132)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I05R': item "Dimension Dust"
endfunction

function Trig_ArenaExpansion_Complete_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ArenaExpansion_Complete_Cond_ExtraCupsUnlocked takes nothing returns boolean
    return(udg_ArenaRank>=2)
endfunction

function Trig_ArenaExpansion_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_ArenaExpansion_PingDust)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05R')) // 'I05R': item "Dimension Dust"
    call DestroyEffectBJ(udg_SpecialEffect[60])
    if(Trig_ArenaExpansion_Complete_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e008_0132,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We managed to gather the Dimension Dust as instructed.",false)
        call Text_Say(gg_unit_e008_0132,"Oh wow, you did it! You're really strong aren't you.",false)
        call Text_Say(gg_unit_e008_0132,"I'll use these two artifacts to create the Reality Marble right away.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_e008_0132)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2)
        set udg_TempPoint=GetUnitLoc(gg_unit_e008_0132)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_e008_0132)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.25)
        set udg_TempPoint=GetUnitLoc(gg_unit_e008_0132)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        call Text_Say(gg_unit_e008_0132,"There we go. With the power of shadows and illusions we can now simulate combat situations that would normally be impossible.",false)
        call Text_Say(gg_unit_e008_0132,"We'll take some time figuring out the finesse of it, but for the time being, we'll add monsters we captured from our own forests to the pool.",false)
        call Text_Say(gg_unit_e008_0132,"Of course you're welcome to try your hand against whatever scenarios we create at any time!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Sounds great! Looking forward to it.",false)
        call Reward_Give(6000,6000,gg_unit_e008_0132)
        call Text_Say(gg_unit_e008_0132,"|n|cffffcc00The Battle Arena has now expanded.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give(6000,6000,gg_unit_e008_0132)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00The Battle Arena has now expanded.|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Arena Expansion|r")
    call QuestSetCompletedBJ(udg_SideQuest[38],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_ArenaOrganizerLast=5
    call UnitAddAbilityBJ('Ane2',gg_unit_e008_0132) // 'Ane2': object name not found in map data
    call ShowUnitShow(gg_unit_e01C_0027)
    call ShowUnitShow(gg_unit_e01D_0026)
    call AddUnitToStockBJ('n0JZ',gg_unit_h02I_0167,1,1) // 'n0JZ': unit "Arena BP to Gold"
    call AddUnitToStockBJ('n0K0',gg_unit_h02I_0167,1,1) // 'n0K0': unit "Arena BP to EXP"
    call AddUnitToStockBJ('n0K1',gg_unit_h02I_0167,1,1) // 'n0K1': unit "Arena BP to Shards"
    call AddUnitToStockBJ('n09H',udg_ArenaOrganizer[0],1,1) // 'n09H': unit "Arena: Lothlorien Cup"
    call AddItemToStockBJ('I0J9',gg_unit_e01C_0027,1,1) // 'I0J9': item "Elixir (BP)"
    call AddItemToStockBJ('I0JA',gg_unit_e01C_0027,1,1) // 'I0JA': item "Hero Drink (BP)"
    call AddItemToStockBJ('I0JB',gg_unit_e01C_0027,1,1) // 'I0JB': item "Greater Nectar (BP)"
    if(Trig_ArenaExpansion_Complete_Cond_ExtraCupsUnlocked())then
        call AddUnitToStockBJ('n09N',udg_ArenaOrganizer[0],1,1) // 'n09N': unit "Arena: Ningen Cup"
        call AddItemToStockBJ('I0JC',gg_unit_e01C_0027,1,1) // 'I0JC': item "Gladiator's Blade (BP)"
        call AddItemToStockBJ('I0JD',gg_unit_e01C_0027,1,1) // 'I0JD': item "Muramasa (BP)"
        call AddItemToStockBJ('I0JE',gg_unit_e01C_0027,1,1) // 'I0JE': item "Heady Pipe (BP)"
        call AddUnitToStockBJ('n090',udg_ArenaOrganizer[0],1,1) // 'n090': unit "Arena: Demon Cup"
        call AddItemToStockBJ('I0JF',gg_unit_e01C_0027,1,1) // 'I0JF': item "Assassin's Dagger (BP)"
        call AddItemToStockBJ('I0JG',gg_unit_e01C_0027,1,1) // 'I0JG': item "Helm of the Necromancer (BP)"
        call AddItemToStockBJ('I0JH',gg_unit_e01C_0027,1,1) // 'I0JH': item "Zodiac Helmet (BP)"
        call AddUnitToStockBJ('n094',udg_ArenaOrganizer[0],1,1) // 'n094': unit "Arena: Dimension Cup"
        call AddItemToStockBJ('I0JI',gg_unit_e01D_0026,1,1) // 'I0JI': item "Zodiac Escutcheon (BP)"
        call AddItemToStockBJ('I0JJ',gg_unit_e01D_0026,1,1) // 'I0JJ': item "Robe of Lords (BP)"
        call AddItemToStockBJ('I0JK',gg_unit_e01D_0026,1,1) // 'I0JK': item "Circlet (BP)"
        call AddItemToStockBJ('I0K5',gg_unit_e01D_0026,1,1) // 'I0K5': item "Golden Skull (BP)"
        call AddItemToStockBJ('I0K6',gg_unit_e01D_0026,1,1) // 'I0K6': item "Crystal Skull (BP)"
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_ArenaExpansion takes nothing returns nothing
endfunction

function RegisterR11_ArenaExpansion_Prepare takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaExpansion_Prepare=CreateTrigger()

call DisableTrigger(gg_trg_ArenaExpansion_Prepare)

call TriggerRegisterTimerExpireEventBJ(gg_trg_ArenaExpansion_Prepare,udg_SharedDelayTimer2)

call TriggerAddAction(gg_trg_ArenaExpansion_Prepare,function Trig_ArenaExpansion_Prepare_Actions)

endfunction




function RegisterR11_ArenaExpansion_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaExpansion_Start=CreateTrigger()

call DisableTrigger(gg_trg_ArenaExpansion_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaExpansion_Start,Player(7),true)

call TriggerAddCondition(gg_trg_ArenaExpansion_Start,Condition(function Trig_ArenaExpansion_Start_Conditions))

call TriggerAddAction(gg_trg_ArenaExpansion_Start,function Trig_ArenaExpansion_Start_Actions)

endfunction




function RegisterR11_ArenaExpansion_ShadowStoneSpawn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaExpansion_ShadowStoneSpawn=CreateTrigger()

call DisableTrigger(gg_trg_ArenaExpansion_ShadowStoneSpawn)

call TriggerRegisterEnterRectSimple(gg_trg_ArenaExpansion_ShadowStoneSpawn,gg_rct_565)

call TriggerAddCondition(gg_trg_ArenaExpansion_ShadowStoneSpawn,Condition(function Trig_ArenaExpansion_ShadowStoneSpawn_Conditions))

call TriggerAddAction(gg_trg_ArenaExpansion_ShadowStoneSpawn,function Trig_ArenaExpansion_ShadowStoneSpawn_Actions)

endfunction




function RegisterR11_ArenaExpansion_ShadowStoneTurnIn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaExpansion_ShadowStoneTurnIn=CreateTrigger()

call DisableTrigger(gg_trg_ArenaExpansion_ShadowStoneTurnIn)

call TriggerRegisterUnitInRangeSimple(gg_trg_ArenaExpansion_ShadowStoneTurnIn,450.,gg_unit_e008_0132)

call TriggerAddCondition(gg_trg_ArenaExpansion_ShadowStoneTurnIn,Condition(function Trig_ArenaExpansion_ShadowStoneTurnIn_Conditions))

call TriggerAddAction(gg_trg_ArenaExpansion_ShadowStoneTurnIn,function Trig_ArenaExpansion_ShadowStoneTurnIn_Actions)

endfunction




function RegisterR11_ArenaExpansion_GatherDust takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaExpansion_GatherDust=CreateTrigger()

call DisableTrigger(gg_trg_ArenaExpansion_GatherDust)

call TriggerRegisterEnterRectSimple(gg_trg_ArenaExpansion_GatherDust,gg_rct_372)

call TriggerAddCondition(gg_trg_ArenaExpansion_GatherDust,Condition(function Trig_ArenaExpansion_GatherDust_Conditions))

call TriggerAddAction(gg_trg_ArenaExpansion_GatherDust,function Trig_ArenaExpansion_GatherDust_Actions)

endfunction




function RegisterR11_ArenaExpansion_PingDust takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaExpansion_PingDust=CreateTrigger()

call DisableTrigger(gg_trg_ArenaExpansion_PingDust)

call TriggerRegisterTimerEventPeriodic(gg_trg_ArenaExpansion_PingDust,15.)

call TriggerAddCondition(gg_trg_ArenaExpansion_PingDust,Condition(function Trig_ArenaExpansion_PingDust_Conditions))

call TriggerAddAction(gg_trg_ArenaExpansion_PingDust,function Trig_ArenaExpansion_PingDust_Actions)

endfunction




function RegisterR11_ArenaExpansion_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaExpansion_Complete=CreateTrigger()

call DisableTrigger(gg_trg_ArenaExpansion_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_ArenaExpansion_Complete,450.,gg_unit_e008_0132)

call TriggerAddCondition(gg_trg_ArenaExpansion_Complete,Condition(function Trig_ArenaExpansion_Complete_Conditions))

call TriggerAddAction(gg_trg_ArenaExpansion_Complete,function Trig_ArenaExpansion_Complete_Actions)

endfunction




endlibrary

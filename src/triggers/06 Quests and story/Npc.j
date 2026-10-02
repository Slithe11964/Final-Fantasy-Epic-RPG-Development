library TNpc requires TWait
function Trig_Npc_Hints_Create_Actions takes nothing returns nothing
    set udg_QuestMarkerEffect[1]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nvlw_0048,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[4]=AddSpecialEffectTargetUnitBJ("head",gg_unit_hfoo_0090,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[5]=AddSpecialEffectTargetUnitBJ("head",gg_unit_hhes_0088,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[6]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nvlk_0004,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[7]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nhea_0084,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[8]=AddSpecialEffectTargetUnitBJ("head",gg_unit_hkni_0092,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[9]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nvlk_0146,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[$C]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nwat_0157,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl") // $C = 12
    set udg_QuestMarkerEffect[$D]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Nsjs_0194,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl") // $D = 13
    set udg_QuestMarkerEffect[$E]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nvil_0003,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl") // $E = 14
    set udg_QuestMarkerEffect[16]=AddSpecialEffectTargetUnitBJ("head",gg_unit_hhes_0086,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[20]=AddSpecialEffectTargetUnitBJ("head",gg_unit_hhes_0099,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[22]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nhea_0096,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    set udg_QuestMarkerEffect[23]=AddSpecialEffectTargetUnitBJ("head",gg_unit_n0AW_0223,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Woman_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Woman_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call PlaySoundOnUnitBJ(gg_snd_VillagerWomanWhat,'d',gg_unit_nvlw_0048)
    call DestroyEffectBJ(udg_QuestMarkerEffect[1])
    set udg_FloatingText[1]=CreateTextTagUnitBJ("|cffffcc00Woman|r: Hello !",gg_unit_nvlw_0048,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[1])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Reno_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Reno_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[2])
    set udg_FloatingText[2]=CreateTextTagUnitBJ("|cffffcc00Reno|r: I saw those dwarves in the Barrens being taken by some icy guys. Course I ran away like hell immediately!",gg_unit_n012_0163,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[2])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Rude_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Rude_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[3])
    set udg_FloatingText[3]=CreateTextTagUnitBJ("|cffffcc00Rude|r: Odin's magical horse is called Sleipnir.",gg_unit_n013_0164,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[3])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Footman_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Footman_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[4])
    set udg_FloatingText[4]=CreateTextTagUnitBJ("|cffffcc00Footman|r: There are many shops in our town - check them out !",gg_unit_hfoo_0090,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[4])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Swordsman_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Swordsman_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[5])
    set udg_FloatingText[5]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: We, High Elves, live much longer than humans. Yet we are also mortal.",gg_unit_hhes_0088,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[5])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Child_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Child_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call PlaySoundOnUnitBJ(gg_snd_VillagerKidWhat,'d',gg_unit_nvlk_0004)
    call DestroyEffectBJ(udg_QuestMarkerEffect[6])
    set udg_FloatingText[6]=CreateTextTagUnitBJ("|cffffcc00Child|r: Hello !",gg_unit_nvlk_0004,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[6])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Archer_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Archer_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[7])
    set udg_FloatingText[7]=CreateTextTagUnitBJ("|cffffcc00Archer|r: Evanescence . . . What a sad word . . .",gg_unit_nhea_0084,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[7])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Knight_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Knight_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[8])
    set udg_FloatingText[8]=CreateTextTagUnitBJ("|cffffcc00Knight|r: I wish I had a chocobo to ride.",gg_unit_hkni_0092,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[8])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_ChildChocobo_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_ChildChocobo_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[9])
    set udg_FloatingText[9]=CreateTextTagUnitBJ("|cffffcc00Child|r: Chocobos are fond of Greens.",gg_unit_nvlk_0146,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[9])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Kenarius_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Kenarius_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[$A]) // $A = 10
    set udg_FloatingText[$A]=CreateTextTagUnitBJ("|cffffcc00Kenarius|r: My daughters disappointed me greatly but I still love them.",gg_unit_Ecen_0180,0,12.,'d','d','d',0) // $A = 10
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[$A]) // $A = 10
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Nimphrodel_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Nimphrodel_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[$B]) // $B = 11
    set udg_FloatingText[$B]=CreateTextTagUnitBJ("|cffffcc00Nimphrodel|r: Me and Batu are going to have many children.",gg_unit_E003_0182,0,12.,'d','d','d',0) // $B = 11
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[$B]) // $B = 11
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Sentry_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Sentry_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[$C]) // $C = 12
    set udg_FloatingText[$C]=CreateTextTagUnitBJ("|cffffcc00Sentry|r: Lady Galadriel and Lord Celeborn are the Lords of the Night Elves of Lothlorien.",gg_unit_nwat_0157,0,12.,'d','d','d',0) // $C = 12
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[$C]) // $C = 12
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Kesha_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Kesha_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[$D]) // $D = 13
    call PlaySoundOnUnitBJ(gg_snd_PandarenBrewmasterReady,'d',gg_unit_Nsjs_0194)
    set udg_FloatingText[$D]=CreateTextTagUnitBJ("|cffffcc00Kesha|r: Fresh, cool ale here.",gg_unit_Nsjs_0194,0,12.,'d','d','d',0) // $D = 13
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[$D]) // $D = 13
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Peasant_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Peasant_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[$E]) // $E = 14
    set udg_VillagerEffectActive=true
    set udg_FloatingText[$E]=CreateTextTagUnitBJ("|cffffcc00Peasant|r: Please just leave us alone . . .",gg_unit_nvil_0003,0,12.,'d','d','d',0) // $E = 14
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[$E]) // $E = 14
endfunction

function Trig_Npc_Talk_PeasantHarvest_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_PeasantHarvest_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[$F]) // $F = 15
    set udg_FloatingText[$F]=CreateTextTagUnitBJ("|cffffcc00Peasant|r: We must work hard. Everyone is depending on our harvest.",gg_unit_nvil_0003,0,12.,'d','d','d',0) // $F = 15
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[$F]) // $F = 15
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_MineStory_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_MineStory_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[16])
    set udg_FloatingText[16]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: I once heard that long time ago there was a mine west from Kalm near the mountains.",gg_unit_hhes_0086,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[16])
    set udg_FloatingText[16]=CreateTextTagUnitBJ("|cffffcc00Elf Woman|r: Yes and they say that one lucky enough could even find Arcanium there.",gg_unit_nhef_0085,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[16])
    set udg_FloatingText[16]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: True. Too bad there was an earthquake and the mine crumbled, now there's no way to get inside.",gg_unit_hhes_0086,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[16])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Fire_WantMore_Actions takes nothing returns nothing
    call DestroyTextTagBJ(udg_FloatingText[17])
    call DestroyTextTagBJ(udg_FloatingText[18])
    set udg_FloatingText[17]=CreateTextTagUnitBJ("|cffffcc00Fire|r: Wow, that's a potion I don't have! Bring me more, please.",gg_unit_n001_0012,0,12.,'d','d','d',0)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
endfunction

function Trig_Npc_Fire_Thanks_Actions takes nothing returns nothing
    call DestroyTextTagBJ(udg_FloatingText[17])
    call DestroyTextTagBJ(udg_FloatingText[18])
    set udg_FloatingText[18]=CreateTextTagUnitBJ("|cffffcc00Fire|r: Thanks! I will study this type of potion.",gg_unit_n001_0012,0,12.,'d','d','d',0)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
endfunction

function Trig_Npc_Priscilla_SummonEden_Conditions takes nothing returns boolean
    return(IsTriggerEnabled(GetTriggeringTrigger()))
endfunction

function Trig_Npc_Priscilla_SummonEden_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_FloatingText[19]=CreateTextTagUnitBJ("|cffffcc00Priscilla|r: Okay, I will summon Eden now.",gg_unit_u007_0128,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[19])
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_LinkGuard_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsUnitHiddenBJ(gg_unit_hhes_0099)==false))!=null
endfunction

function Trig_Npc_Talk_LinkGuard_Cond_HuntressHidden takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_u002_0196))
endfunction

function Trig_Npc_Talk_LinkGuard_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[20])
    set udg_FloatingText[20]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: Hmm. We're missing a guard named Link.",gg_unit_hhes_0099,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[20])
    if(Trig_Npc_Talk_LinkGuard_Cond_HuntressHidden())then
        set udg_FloatingText[20]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: A night elf from the south recently visited Kalm, but she went back again.",gg_unit_hhes_0099,0,12.,'d','d','d',0)
        call Wait_Polled(10.)
        call DestroyTextTagBJ(udg_FloatingText[20])
        set udg_FloatingText[20]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: I wonder if she knows anything about him...",gg_unit_hhes_0099,0,12.,'d','d','d',0)
        call Wait_Polled(10.)
        call DestroyTextTagBJ(udg_FloatingText[20])
    else
        set udg_FloatingText[20]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: What do you say? Link is cursed and now resides in the Northern Mountains?",gg_unit_hhes_0099,0,12.,'d','d','d',0)
        call Wait_Polled(10.)
        call DestroyTextTagBJ(udg_FloatingText[20])
        set udg_FloatingText[20]=CreateTextTagUnitBJ("|cffffcc00Swordsman|r: If that is true, please ask the huntress from the Night Elven Settlement about him. She recently came here.",gg_unit_hhes_0099,0,12.,'d','d','d',0)
        call Wait_Polled(10.)
        call DestroyTextTagBJ(udg_FloatingText[20])
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Jack_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Jack_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[21])
    set udg_FloatingText[21]=CreateTextTagUnitBJ("|cffffcc00Jack|r: Look, the hydra has already hatched! Isn't it cute?",gg_unit_Hapm_0179,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[21])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_ArcherWall_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_ArcherWall_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[22])
    set udg_FloatingText[22]=CreateTextTagUnitBJ("|cffffcc00Archer|r: You can see beyond the Great Wall from here.",gg_unit_nhea_0096,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[22])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Ruksel_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Ruksel_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_RukselHintShown=true
    call DestroyEffectBJ(udg_QuestMarkerEffect[23])
    set udg_FloatingText[23]=CreateTextTagUnitBJ("|cffffcc00Ruksel|r: Hmm... where could I have dropped it...",gg_unit_n0AW_0223,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[23])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Thorn_BattleWait_Actions takes nothing returns nothing
    call DestroyTextTagBJ(udg_FloatingText[24])
    set udg_FloatingText[24]=CreateTextTagUnitBJ("|cffffcc00Thorn|r: No disturbing a battle in progress! You wait!",gg_unit_h02T_0064,0,12.,'d','d','d',0)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5.)
endfunction

function Trig_Npc_Talk_Sigroon_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitVisible(gg_unit_e019_0228,GetOwningPlayer(GetTriggerUnit())))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Sigroon_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[25])
    set udg_FloatingText[25]=CreateTextTagUnitBJ("|cffffcc00Sigroon|r: The marshes ahead are extremely dangerous. Beware!",gg_unit_e019_0228,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[25])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Quincy_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Quincy_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[26])
    set udg_FloatingText[26]=CreateTextTagUnitBJ("|cffffcc00Quincy|r: The seekers really possessed a fascinating wealth of knowledge about our world. How could they turn evil?",gg_unit_h031_0114,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[26])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Npc_Talk_Gravedigger_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Npc_Talk_Gravedigger_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[27])
    set udg_FloatingText[27]=CreateTextTagUnitBJ("|cffffcc00Peasant|r: We've finally given them the proper burial they deserve.",gg_unit_nvl2_0266,0,12.,'d','d','d',0)
    call Wait_Polled(10.)
    call DestroyTextTagBJ(udg_FloatingText[27])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Npc takes nothing returns nothing
endfunction
function RegisterR11_Npc_Hints_Create takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Hints_Create=CreateTrigger()
    call TriggerAddAction(gg_trg_Npc_Hints_Create,function Trig_Npc_Hints_Create_Actions)
endfunction
function RegisterR11_Npc_Talk_Woman takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Woman=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Woman,150.,gg_unit_nvlw_0048)
    call TriggerAddCondition(gg_trg_Npc_Talk_Woman,Condition(function Trig_Npc_Talk_Woman_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Woman,function Trig_Npc_Talk_Woman_Actions)
endfunction
function RegisterR11_Npc_Talk_Reno takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Reno=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Reno)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Reno,150.,gg_unit_n012_0163)
    call TriggerAddCondition(gg_trg_Npc_Talk_Reno,Condition(function Trig_Npc_Talk_Reno_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Reno,function Trig_Npc_Talk_Reno_Actions)
endfunction
function RegisterR11_Npc_Talk_Rude takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Rude=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Rude)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Rude,150.,gg_unit_n013_0164)
    call TriggerAddCondition(gg_trg_Npc_Talk_Rude,Condition(function Trig_Npc_Talk_Rude_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Rude,function Trig_Npc_Talk_Rude_Actions)
endfunction
function RegisterR11_Npc_Talk_Footman takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Footman=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Footman,150.,gg_unit_hfoo_0090)
    call TriggerAddCondition(gg_trg_Npc_Talk_Footman,Condition(function Trig_Npc_Talk_Footman_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Footman,function Trig_Npc_Talk_Footman_Actions)
endfunction
function RegisterR11_Npc_Talk_Swordsman takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Swordsman=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Swordsman,150.,gg_unit_hhes_0088)
    call TriggerAddCondition(gg_trg_Npc_Talk_Swordsman,Condition(function Trig_Npc_Talk_Swordsman_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Swordsman,function Trig_Npc_Talk_Swordsman_Actions)
endfunction
function RegisterR11_Npc_Talk_Child takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Child=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Child,150.,gg_unit_nvlk_0004)
    call TriggerAddCondition(gg_trg_Npc_Talk_Child,Condition(function Trig_Npc_Talk_Child_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Child,function Trig_Npc_Talk_Child_Actions)
endfunction
function RegisterR11_Npc_Talk_Archer takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Archer=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Archer,150.,gg_unit_nhea_0084)
    call TriggerAddCondition(gg_trg_Npc_Talk_Archer,Condition(function Trig_Npc_Talk_Archer_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Archer,function Trig_Npc_Talk_Archer_Actions)
endfunction
function RegisterR11_Npc_Talk_Knight takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Knight=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Knight,150.,gg_unit_hkni_0092)
    call TriggerAddCondition(gg_trg_Npc_Talk_Knight,Condition(function Trig_Npc_Talk_Knight_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Knight,function Trig_Npc_Talk_Knight_Actions)
endfunction
function RegisterR11_Npc_Talk_ChildChocobo takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_ChildChocobo=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_ChildChocobo,150.,gg_unit_nvlk_0146)
    call TriggerAddCondition(gg_trg_Npc_Talk_ChildChocobo,Condition(function Trig_Npc_Talk_ChildChocobo_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_ChildChocobo,function Trig_Npc_Talk_ChildChocobo_Actions)
endfunction
function RegisterR11_Npc_Talk_Kenarius takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Kenarius=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Kenarius)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Kenarius,150.,gg_unit_Ecen_0180)
    call TriggerAddCondition(gg_trg_Npc_Talk_Kenarius,Condition(function Trig_Npc_Talk_Kenarius_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Kenarius,function Trig_Npc_Talk_Kenarius_Actions)
endfunction
function RegisterR11_Npc_Talk_Nimphrodel takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Nimphrodel=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Nimphrodel)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Nimphrodel,150.,gg_unit_E003_0182)
    call TriggerAddCondition(gg_trg_Npc_Talk_Nimphrodel,Condition(function Trig_Npc_Talk_Nimphrodel_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Nimphrodel,function Trig_Npc_Talk_Nimphrodel_Actions)
endfunction
function RegisterR11_Npc_Talk_Sentry takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Sentry=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Sentry,150.,gg_unit_nwat_0157)
    call TriggerAddCondition(gg_trg_Npc_Talk_Sentry,Condition(function Trig_Npc_Talk_Sentry_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Sentry,function Trig_Npc_Talk_Sentry_Actions)
endfunction
function RegisterR11_Npc_Talk_Kesha takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Kesha=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Kesha,150.,gg_unit_Nsjs_0194)
    call TriggerAddCondition(gg_trg_Npc_Talk_Kesha,Condition(function Trig_Npc_Talk_Kesha_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Kesha,function Trig_Npc_Talk_Kesha_Actions)
endfunction
function RegisterR11_Npc_Talk_Peasant takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Peasant=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Peasant,150.,gg_unit_nvil_0003)
    call TriggerAddCondition(gg_trg_Npc_Talk_Peasant,Condition(function Trig_Npc_Talk_Peasant_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Peasant,function Trig_Npc_Talk_Peasant_Actions)
endfunction
function RegisterR11_Npc_Talk_PeasantHarvest takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_PeasantHarvest=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_PeasantHarvest)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_PeasantHarvest,150.,gg_unit_nvil_0003)
    call TriggerAddCondition(gg_trg_Npc_Talk_PeasantHarvest,Condition(function Trig_Npc_Talk_PeasantHarvest_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_PeasantHarvest,function Trig_Npc_Talk_PeasantHarvest_Actions)
endfunction
function RegisterR11_Npc_Talk_MineStory takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_MineStory=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_MineStory,150.,gg_unit_hhes_0086)
    call TriggerAddCondition(gg_trg_Npc_Talk_MineStory,Condition(function Trig_Npc_Talk_MineStory_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_MineStory,function Trig_Npc_Talk_MineStory_Actions)
endfunction
function RegisterR11_Npc_Fire_WantMore takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Fire_WantMore=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Fire_WantMore)
    call TriggerAddAction(gg_trg_Npc_Fire_WantMore,function Trig_Npc_Fire_WantMore_Actions)
endfunction
function RegisterR11_Npc_Fire_Thanks takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Fire_Thanks=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Fire_Thanks)
    call TriggerAddAction(gg_trg_Npc_Fire_Thanks,function Trig_Npc_Fire_Thanks_Actions)
endfunction
function RegisterR11_Npc_Priscilla_SummonEden takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Priscilla_SummonEden=CreateTrigger()
    call TriggerAddCondition(gg_trg_Npc_Priscilla_SummonEden,Condition(function Trig_Npc_Priscilla_SummonEden_Conditions))
    call TriggerAddAction(gg_trg_Npc_Priscilla_SummonEden,function Trig_Npc_Priscilla_SummonEden_Actions)
endfunction
function RegisterR11_Npc_Talk_LinkGuard takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_LinkGuard=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_LinkGuard,150.,gg_unit_hhes_0099)
    call TriggerAddCondition(gg_trg_Npc_Talk_LinkGuard,Condition(function Trig_Npc_Talk_LinkGuard_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_LinkGuard,function Trig_Npc_Talk_LinkGuard_Actions)
endfunction
function RegisterR11_Npc_Talk_Jack takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Jack=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Jack)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Jack,150.,gg_unit_Hapm_0179)
    call TriggerAddCondition(gg_trg_Npc_Talk_Jack,Condition(function Trig_Npc_Talk_Jack_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Jack,function Trig_Npc_Talk_Jack_Actions)
endfunction
function RegisterR11_Npc_Talk_ArcherWall takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_ArcherWall=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_ArcherWall,150.,gg_unit_nhea_0096)
    call TriggerAddCondition(gg_trg_Npc_Talk_ArcherWall,Condition(function Trig_Npc_Talk_ArcherWall_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_ArcherWall,function Trig_Npc_Talk_ArcherWall_Actions)
endfunction
function RegisterR11_Npc_Talk_Ruksel takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Ruksel=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Ruksel,150.,gg_unit_n0AW_0223)
    call TriggerAddCondition(gg_trg_Npc_Talk_Ruksel,Condition(function Trig_Npc_Talk_Ruksel_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Ruksel,function Trig_Npc_Talk_Ruksel_Actions)
endfunction
function RegisterR11_Npc_Thorn_BattleWait takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Thorn_BattleWait=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Thorn_BattleWait)
    call TriggerAddAction(gg_trg_Npc_Thorn_BattleWait,function Trig_Npc_Thorn_BattleWait_Actions)
endfunction
function RegisterR11_Npc_Talk_Sigroon takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Sigroon=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Sigroon)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Sigroon,150.,gg_unit_e019_0228)
    call TriggerAddCondition(gg_trg_Npc_Talk_Sigroon,Condition(function Trig_Npc_Talk_Sigroon_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Sigroon,function Trig_Npc_Talk_Sigroon_Actions)
endfunction
function RegisterR11_Npc_Talk_Quincy takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Quincy=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Quincy)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Quincy,150.,gg_unit_h031_0114)
    call TriggerAddCondition(gg_trg_Npc_Talk_Quincy,Condition(function Trig_Npc_Talk_Quincy_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Quincy,function Trig_Npc_Talk_Quincy_Actions)
endfunction
function RegisterR11_Npc_Talk_Gravedigger takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Npc_Talk_Gravedigger=CreateTrigger()
    call DisableTrigger(gg_trg_Npc_Talk_Gravedigger)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Npc_Talk_Gravedigger,150.,gg_unit_nvl2_0266)
    call TriggerAddCondition(gg_trg_Npc_Talk_Gravedigger,Condition(function Trig_Npc_Talk_Gravedigger_Conditions))
    call TriggerAddAction(gg_trg_Npc_Talk_Gravedigger,function Trig_Npc_Talk_Gravedigger_Actions)
endfunction




endlibrary

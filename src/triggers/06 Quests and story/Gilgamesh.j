library TGilgamesh requires TCam, TCine, TLoc, TMusic, TPlayerPart01, TText, TWait
function Trig_Gilgamesh_Gift_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0FG') // 'I0FG': item "Gilgamesh"
endfunction

function Trig_Gilgamesh_Gift_HasRyuujin takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I0C7'))or(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[udg_TempInteger],'I0C7')) // 'I0C7': item "Ryuujin no Ken"
endfunction

function Trig_Gilgamesh_Gift_OwnsRyuujin takes nothing returns boolean
    return(Trig_Gilgamesh_Gift_HasRyuujin())
endfunction

function Trig_Gilgamesh_Gift_IsGiftStage1 takes nothing returns boolean
    return(udg_GenjiGiftStage==1)
endfunction

function Trig_Gilgamesh_Gift_HasGenjiShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I0BU'))or(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[udg_TempInteger],'I0BU')) // 'I0BU': item "Genji Shield"
endfunction

function Trig_Gilgamesh_Gift_OwnsGenjiShield takes nothing returns boolean
    return(Trig_Gilgamesh_Gift_HasGenjiShield())
endfunction

function Trig_Gilgamesh_Gift_IsGiftStage2 takes nothing returns boolean
    return(udg_GenjiGiftStage==2)
endfunction

function Trig_Gilgamesh_Gift_HasGenjiMask takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I0AA'))or(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[udg_TempInteger],'I0AA')) // 'I0AA': item "Genji Mask"
endfunction

function Trig_Gilgamesh_Gift_OwnsGenjiMask takes nothing returns boolean
    return(Trig_Gilgamesh_Gift_HasGenjiMask())
endfunction

function Trig_Gilgamesh_Gift_IsGiftStage3 takes nothing returns boolean
    return(udg_GenjiGiftStage==3)
endfunction

function Trig_Gilgamesh_Gift_NeedsGenjiGloves takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I0BU'))and(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I0AA'))and(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I01Y'))and(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I0B0')==false) // 'I0BU': item "Genji Shield"; 'I0AA': item "Genji Mask"; 'I01Y': item "Genji Armor"; 'I0B0': item "Genji Gloves"
endfunction

function Trig_Gilgamesh_Gift_HasGenjiArmor takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'I01Y'))or(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[udg_TempInteger],'I01Y')) // 'I01Y': item "Genji Armor"
endfunction

function Trig_Gilgamesh_Gift_OwnsGenjiArmor takes nothing returns boolean
    return(Trig_Gilgamesh_Gift_HasGenjiArmor())
endfunction

function Trig_Gilgamesh_Gift_IsGiftStage4 takes nothing returns boolean
    return(udg_GenjiGiftStage==4)
endfunction

function Trig_Gilgamesh_Gift_LuShangOwed takes nothing returns boolean
    return(IsPlayerInForce(ConvertedPlayer(udg_TempInteger),udg_LuShangPending))
endfunction

function Trig_Gilgamesh_Gift_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    // (facing in degrees of the triggering unit) plus (180).
    set udg_TempReal=(GetUnitFacing(GetTriggerUnit())+180.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,udg_TempReal)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'N03D',Player(8),udg_TempPoint2,udg_TempReal) // 'N03D': unit "Mighty Swordsman"
    call RemoveLocation(udg_TempPoint2)
    set udg_FishedGilgamesh=GetLastCreatedUnit()
    call SetHeroLevelBJ(GetLastCreatedUnit(),91,false)
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call UnitRemoveAbilityBJ('AInv',GetLastCreatedUnit()) // 'AInv': standard ability reference "Inventory"
    if(Trig_Gilgamesh_Gift_LuShangOwed())then
        call ForceRemovePlayerSimple(ConvertedPlayer(udg_TempInteger),udg_LuShangPending)
        set udg_GilgameshGift='I0GC' // 'I0GC': item "Lu Shang"
    else
        // (the remainder after dividing (udg_GenjiGiftStage) by (4)) plus (1).
        set udg_GenjiGiftStage=(ModuloInteger(udg_GenjiGiftStage,4)+1)
        if(Trig_Gilgamesh_Gift_IsGiftStage1())then
            if(Trig_Gilgamesh_Gift_OwnsRyuujin())then
                set udg_GilgameshGift='I0H2' // 'I0H2': item "Curse: Ryuujin no Ken"
            else
                set udg_GilgameshGift='I07B' // 'I07B': item "Samurai's Amulet"
            endif
        endif
        if(Trig_Gilgamesh_Gift_IsGiftStage2())then
            if(Trig_Gilgamesh_Gift_OwnsGenjiShield())then
                set udg_GenjiGiftStage=(udg_GenjiGiftStage+1)
            else
                set udg_GilgameshGift='I0BU' // 'I0BU': item "Genji Shield"
            endif
        endif
        if(Trig_Gilgamesh_Gift_IsGiftStage3())then
            if(Trig_Gilgamesh_Gift_OwnsGenjiMask())then
                set udg_GenjiGiftStage=(udg_GenjiGiftStage+1)
            else
                set udg_GilgameshGift='I0AA' // 'I0AA': item "Genji Mask"
            endif
        endif
        if(Trig_Gilgamesh_Gift_IsGiftStage4())then
            if(Trig_Gilgamesh_Gift_OwnsGenjiArmor())then
                if(Trig_Gilgamesh_Gift_NeedsGenjiGloves())then
                    set udg_GilgameshGift='I0B0' // 'I0B0': item "Genji Gloves"
                else
                    set udg_GilgameshGift='I07B' // 'I07B': item "Samurai's Amulet"
                endif
            else
                set udg_GilgameshGift='I01Y' // 'I01Y': item "Genji Armor"
            endif
        endif
    endif
    call Wait_Polled(2.)
    call CreateTextTagUnitBJ("|cffffcc00Gilgamesh|r: Muahaha! Thank you for fishing me up from there!",udg_FishedGilgamesh,0,12.,'d','d','d',0)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
    call Wait_Polled(5.)
    call CreateTextTagUnitBJ("|cffffcc00Gilgamesh|r: Here's a little thing I got from down there. I don't need it, so it's all yours! See ya!",udg_FishedGilgamesh,0,12.,'d','d','d',0)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
    call Wait_Polled(5.)
    set udg_TempPoint=GetUnitLoc(udg_FishedGilgamesh)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateItemLoc(udg_GilgameshGift,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(udg_FishedGilgamesh)
    set udg_FishedGilgamesh=null
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_Gilgamesh_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_N03D_0165)
    call SetUnitInvulnerable(gg_unit_N03D_0165,true)
    call PauseUnitBJ(true,gg_unit_N03D_0165)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Gilgamesh_Appear_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Gilgamesh_Appear_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Gilgamesh_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call SetUnitPositionLocFacingLocBJ(gg_unit_N03D_0165,udg_TempPoint,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    if(Trig_Gilgamesh_Appear_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_N03D_0165,0)
        set udg_TempPoint=GetUnitLoc(gg_unit_N03D_0165)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_N03D_0165)
        call Text_Say(gg_unit_N03D_0165,"Your weapons are forfeit to me!",false)
        call Text_Say(gg_unit_N03D_0165,"Have at you!",false)
        call Cine_ExitAction()
    else
        call ShowUnitShow(gg_unit_N03D_0165)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_N03D_0165,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call SetUnitInvulnerable(gg_unit_N03D_0165,false)
    call PauseUnitBJ(false,gg_unit_N03D_0165)
    call IssueImmediateOrderBJ(gg_unit_N03D_0165,"spiritwolf")
    call GroupAddUnitSimple(gg_unit_N03D_0165,udg_BossUnits)
    call EnableTrigger(gg_trg_Gilgamesh_Phase2)
    call Music_SetTrack(30)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Gilgamesh_Phase2_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Gilgamesh_Phase2_Actions takes nothing returns nothing
    set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_N03D_0165,udg_TempPoint3,false)
    call RemoveLocation(udg_TempPoint3)
    call SetUnitInvulnerable(gg_unit_N03D_0165,true)
    if(Trig_Gilgamesh_Phase2_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_N03D_0165,0)
        call Wait_Polled(1.)
        call Text_Say(gg_unit_N03D_0165,"Enough expository banter!",false)
        call Text_Transmission(gg_unit_N03D_0165,"Gilgamesh","Enough expository banter! Now we fight like men!","Enough expository banter!",null,0,false)
        call Text_Transmission(gg_unit_N03D_0165,"Gilgamesh","Enough expository banter! Now we fight like men! And ladies!","Enough expository banter! Now we fight like men!",null,0,false)
        call Text_Transmission(gg_unit_N03D_0165,"Gilgamesh","Enough expository banter! Now we fight like men! And ladies! And ladies who dress like men!","Enough expository banter! Now we fight like men! And ladies!",null,0,false)
        call Text_Transmission(gg_unit_N03D_0165,"Gilgamesh","Enough expository banter! Now we fight like men! And ladies! And ladies who dress like men!\r\nFor Gilgamesh...","Enough expository banter! Now we fight like men! And ladies! And ladies who dress like men!",null,0,false)
        call Text_Transmission(gg_unit_N03D_0165,"Gilgamesh","Enough expository banter! Now we fight like men! And ladies! And ladies who dress like men!\r\nFor Gilgamesh... it is morphing time!","Enough expository banter! Now we fight like men! And ladies! And ladies who dress like men!\r\nFor Gilgamesh...",null,0,false)
        call Cine_ExitAction()
    else
        call PauseUnitBJ(true,gg_unit_N03D_0165)
        call Wait_Polled(1.)
        call PauseUnitBJ(false,gg_unit_N03D_0165)
    endif
    call RemoveItem(GetItemOfTypeFromUnitBJ(gg_unit_N03D_0165,'I0A3')) // 'I0A3': item "Excalipoor"
    call UnitAddItemByIdSwapped('I011',gg_unit_N03D_0165) // 'I011': item "Excalibur"
    call SetHeroLevelBJ(gg_unit_N03D_0165,60,false)
    call SetUnitInvulnerable(gg_unit_N03D_0165,false)
    set udg_TempPoint=GetUnitLoc(gg_unit_N03D_0165)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",gg_unit_N03D_0165)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",gg_unit_N03D_0165)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"antimagicshell",gg_unit_N03D_0165)
    call RemoveLocation(udg_TempPoint)
    call PlaySoundBJ(gg_snd_002)
    call DisplayTimedTextToForce(udg_PlayingPlayers,30,"|cff0000a0Gilgamesh|r is now Master |cff0000ffMighty Swordsman|r")
    call SetUnitLifePercentBJ(gg_unit_N03D_0165,100.)
    call EnableTrigger(gg_trg_Gilgamesh_Defeat)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Gilgamesh_Defeat_Cond_TrackKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Gilgamesh_Defeat_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Gilgamesh_Defeat_Cond_GenjiPickA takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Gilgamesh_Defeat_Cond_TwoGenjiRoll takes nothing returns boolean
    // A random whole number from 1 through 3.
    return(GetRandomInt(1,3)<=1)
endfunction

function Trig_Gilgamesh_Defeat_Cond_GenjiPickB takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Gilgamesh_Defeat_Cond_SingleGenjiRoll takes nothing returns boolean
    // A random whole number from 1 through 3.
    return(GetRandomInt(1,3)<=1)
endfunction

function Trig_Gilgamesh_Defeat_Cond_LargeParty takes nothing returns boolean
    return(udg_Difficulty>=4)
endfunction

function Trig_Gilgamesh_Defeat_Cond_GenjiGlovesRoll takes nothing returns boolean
    // A random whole number from 1 through 4.
    return(GetRandomInt(1,4)<=1)
endfunction

function Trig_Gilgamesh_Defeat_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Gilgamesh_Defeat_Cond_TrackKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(gg_unit_N03D_0165)
    call ReviveHeroLoc(gg_unit_N03D_0165,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(gg_unit_N03D_0165,true)
    if(Trig_Gilgamesh_Defeat_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_N03D_0165,0)
        call Text_Say(gg_unit_N03D_0165,"...",false)
        call Text_Say(gg_unit_N03D_0165,"... I just remembered I have something important to do!",false)
        call Text_Say(gg_unit_N03D_0165,"Later!",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_N03D_0165)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call Cine_ExitAction()
        set udg_TempPoint=GetUnitLoc(gg_unit_N03D_0165)
    else
        set udg_TempPoint=GetUnitLoc(gg_unit_N03D_0165)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call CreateItemLoc('I0A3',udg_TempPoint) // 'I0A3': item "Excalipoor"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I07B',udg_TempPoint) // 'I07B': item "Samurai's Amulet"
    if(Trig_Gilgamesh_Defeat_Cond_LargeParty())then
        if(Trig_Gilgamesh_Defeat_Cond_TwoGenjiRoll())then
            call CreateItemLoc('I0BU',udg_TempPoint) // 'I0BU': item "Genji Shield"
            call CreateItemLoc('I0AA',udg_TempPoint) // 'I0AA': item "Genji Mask"
        else
            if(Trig_Gilgamesh_Defeat_Cond_GenjiPickA())then
                call CreateItemLoc('I0AA',udg_TempPoint) // 'I0AA': item "Genji Mask"
                call CreateItemLoc('I01Y',udg_TempPoint) // 'I01Y': item "Genji Armor"
            else
                call CreateItemLoc('I0BU',udg_TempPoint) // 'I0BU': item "Genji Shield"
                call CreateItemLoc('I01Y',udg_TempPoint) // 'I01Y': item "Genji Armor"
            endif
        endif
    else
        if(Trig_Gilgamesh_Defeat_Cond_SingleGenjiRoll())then
            call CreateItemLoc('I0BU',udg_TempPoint) // 'I0BU': item "Genji Shield"
        else
            if(Trig_Gilgamesh_Defeat_Cond_GenjiPickB())then
                call CreateItemLoc('I0AA',udg_TempPoint) // 'I0AA': item "Genji Mask"
            else
                call CreateItemLoc('I01Y',udg_TempPoint) // 'I01Y': item "Genji Armor"
            endif
        endif
    endif
    if(Trig_Gilgamesh_Defeat_Cond_GenjiGlovesRoll())then
        call CreateItemLoc('I0B0',udg_TempPoint) // 'I0B0': item "Genji Gloves"
    endif
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(gg_unit_N03D_0165)
    call PauseUnitBJ(true,gg_unit_N03D_0165)
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Return to Mae'chen.")
    call QuestSetDescriptionBJ(udg_SideQuest[41],"You have found and defeated Gilgamesh, but he escaped. Return to Mae'chen.")
    call Music_ClearTrack(30)
    call EnableTrigger(gg_trg_BridgeBattle_Complete)
    set udg_GilgameshDefeated=true
    call SaveIntegerBJ(1,2,'l',udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Gilgamesh takes nothing returns nothing
endfunction

function RegisterR11_Gilgamesh_Gift takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gilgamesh_Gift=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gilgamesh_Gift,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Gilgamesh_Gift,Condition(function Trig_Gilgamesh_Gift_Conditions))

call TriggerAddAction(gg_trg_Gilgamesh_Gift,function Trig_Gilgamesh_Gift_Actions)

endfunction




function RegisterR11_Gilgamesh_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gilgamesh_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Gilgamesh_Init,function Trig_Gilgamesh_Init_Actions)

endfunction




function RegisterR11_Gilgamesh_Appear takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gilgamesh_Appear=CreateTrigger()

call DisableTrigger(gg_trg_Gilgamesh_Appear)

call TriggerRegisterUnitInRangeSimple(gg_trg_Gilgamesh_Appear,128.,gg_unit_N03D_0165)

call TriggerRegisterEnterRectSimple(gg_trg_Gilgamesh_Appear,gg_rct_478)

call TriggerRegisterEnterRectSimple(gg_trg_Gilgamesh_Appear,gg_rct_479)

call TriggerAddCondition(gg_trg_Gilgamesh_Appear,Condition(function Trig_Gilgamesh_Appear_Conditions))

call TriggerAddAction(gg_trg_Gilgamesh_Appear,function Trig_Gilgamesh_Appear_Actions)

endfunction




function RegisterR11_Gilgamesh_Phase2 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gilgamesh_Phase2=CreateTrigger()

call DisableTrigger(gg_trg_Gilgamesh_Phase2)

call TriggerRegisterUnitEvent(gg_trg_Gilgamesh_Phase2,gg_unit_N03D_0165,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Gilgamesh_Phase2,function Trig_Gilgamesh_Phase2_Actions)

endfunction




function RegisterR11_Gilgamesh_Defeat takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gilgamesh_Defeat=CreateTrigger()

call DisableTrigger(gg_trg_Gilgamesh_Defeat)

call TriggerRegisterUnitEvent(gg_trg_Gilgamesh_Defeat,gg_unit_N03D_0165,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Gilgamesh_Defeat,function Trig_Gilgamesh_Defeat_Actions)

endfunction




endlibrary

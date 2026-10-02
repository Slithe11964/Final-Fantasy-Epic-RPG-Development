library TBossEchele requires TBattleLog, TCam, TCine, TLoc, TMusic, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Echele_Start=null
    trigger gg_trg_Boss_Echele_SpawnForm=null
    trigger gg_trg_Boss_Echele_FormChange=null
    trigger gg_trg_Boss_Echele_KillMinions=null
    trigger gg_trg_Boss_Echele_Leash=null
endglobals

function Trig_Boss_Echele_Start_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Boss_Echele_Start_Enum_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),6.)
endfunction

function Trig_Boss_Echele_Start_Enum_ClearCameraNoise takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_Boss_Echele_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Echele_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_EchelePhase=0
    set udg_EcheleFormsKilled=0
    if(Trig_Boss_Echele_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Wait_Polled(2)
        set udg_TempPoint=GetRectCenter(gg_rct_657)
        set udg_TempReal=90.
        call ConditionalTriggerExecute(gg_trg_Boss_Echele_SpawnForm)
        call PauseUnitBJ(true,udg_EcheleBoss)
        call SetUnitInvulnerable(udg_EcheleBoss,true)
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Cam_PanToUnit(udg_EcheleBoss,.2)
        call Wait_Polled(2)
        call Text_Say(GetTriggerUnit(),"This is it! Let's hit him with everything we have!",false)
        call SetUnitAnimation(udg_EcheleBoss,"stand channel")
        call ForForce(udg_PlayingPlayers,function Trig_Boss_Echele_Start_Enum_ShakeCamera)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
        call Wait_Polled(1.)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
        call Wait_Polled(1.5)
        call Text_Say(null,"|cffffcc00Echele channels the power of the Zodiac Braves!|r",false)
        call Text_Say(udg_StoryBoss,"We must be quick. The temperature is dropping by the second. Draw your blades!",false)
        call Text_Say(null,"|cffffcc00Echele's spell will turn the world to ice in|r 10 minutes|cffffcc00!|r",true)
        call ForForce(udg_PlayingPlayers,function Trig_Boss_Echele_Start_Enum_ClearCameraNoise)
        call Cine_ExitAction()
        call PauseUnitBJ(false,udg_EcheleBoss)
        call SetUnitInvulnerable(udg_EcheleBoss,false)
    else
        set udg_TempPoint=GetRectCenter(gg_rct_657)
        set udg_TempReal=90.
        call ConditionalTriggerExecute(gg_trg_Boss_Echele_SpawnForm)
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call StartTimerBJ(udg_WorldFreezeTimer,false,600.)
    set udg_WorldFreezeDialog=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"World Freeze")
    call TimerDialogSetTitleColorBJ(GetLastCreatedTimerDialogBJ(),40.,40.,100.,0)
    call TimerDialogSetTimeColorBJ(GetLastCreatedTimerDialogBJ(),40.,40.,100.,0)
    call EnableTrigger(gg_trg_Boss_Echele_Leash)
    call EnableTrigger(gg_trg_IceAge_FreezeTimeout)
    call Music_SetTrack(17)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated1 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form1 takes nothing returns boolean
    return(udg_EchelePhase==1)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated2 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form2 takes nothing returns boolean
    return(udg_EchelePhase==2)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated3 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form3 takes nothing returns boolean
    return(udg_EchelePhase==3)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated4 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form4 takes nothing returns boolean
    return(udg_EchelePhase==4)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated5 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form5 takes nothing returns boolean
    return(udg_EchelePhase==5)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated6 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form6 takes nothing returns boolean
    return(udg_EchelePhase==6)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated7 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form7 takes nothing returns boolean
    return(udg_EchelePhase==7)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated8 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form8 takes nothing returns boolean
    return(udg_EchelePhase==8)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated9 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form9 takes nothing returns boolean
    return(udg_EchelePhase==9)
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated10 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form10 takes nothing returns boolean
    return(udg_EchelePhase==$A) // $A = 10
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated11 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form11 takes nothing returns boolean
    return(udg_EchelePhase==$B) // $B = 11
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated12 takes nothing returns boolean
    return(udg_BossDefeated[udg_EchelePhase])
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_Form12 takes nothing returns boolean
    return(udg_EchelePhase==$C) // $C = 12
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_HardModeMidForm takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))and(udg_EchelePhase<$D) // $D = 13
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_HardMode_Items takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_SpawnTrueForm takes nothing returns boolean
    return(udg_EchelePhase>=$D) // $D = 13
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_FinalFormSpawn takes nothing returns boolean
    return(udg_EcheleFormsKilled==$C) // $C = 12
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_HardMode_TrueForm takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_HardMode_Minor takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_Boss_Echele_SpawnForm_Cond_IsTrueForm takes nothing returns boolean
    return(udg_EchelePhase>=$D) // $D = 13
endfunction

function Trig_Boss_Echele_SpawnForm_Actions takes nothing returns nothing
    set udg_EchelePhase=(udg_EchelePhase+1)
    if(Trig_Boss_Echele_SpawnForm_Cond_Form1())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated1())then
            call CreateNUnitsAtLoc(1,'U01H',Player($B),udg_TempPoint,udg_TempReal) // 'U01H': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I02S',GetLastCreatedUnit()) // 'I02S': item "Cursed Wand"
            call UnitAddItemByIdSwapped('I02T',GetLastCreatedUnit()) // 'I02T': item "Unholy Shield"
            call UnitAddItemByIdSwapped('I0FC',GetLastCreatedUnit()) // 'I0FC': item "Enchanted Helmet"
            call UnitAddItemByIdSwapped('I01V',GetLastCreatedUnit()) // 'I01V': item "Magician's Robe"
            call UnitAddItemByIdSwapped('I00F',GetLastCreatedUnit()) // 'I00F': item "Jade Collar"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form2())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated2())then
            call CreateNUnitsAtLoc(1,'U01E',Player($B),udg_TempPoint,udg_TempReal) // 'U01E': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I033',GetLastCreatedUnit()) // 'I033': item "Trident"
            call UnitAddItemByIdSwapped('I016',GetLastCreatedUnit()) // 'I016': item "Platinum Shield"
            call UnitAddItemByIdSwapped('I0FB',GetLastCreatedUnit()) // 'I0FB': item "Serpent Helmet"
            call UnitAddItemByIdSwapped('I01S',GetLastCreatedUnit()) // 'I01S': item "Shimmering Mail"
            call UnitAddItemByIdSwapped('I00P',GetLastCreatedUnit()) // 'I00P': item "Greater Totem of Power"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form3())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated3())then
            call CreateNUnitsAtLoc(1,'U01D',Player($B),udg_TempPoint,udg_TempReal) // 'U01D': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I02S',GetLastCreatedUnit()) // 'I02S': item "Cursed Wand"
            call UnitAddItemByIdSwapped('I016',GetLastCreatedUnit()) // 'I016': item "Platinum Shield"
            call UnitAddItemByIdSwapped('I02Z',GetLastCreatedUnit()) // 'I02Z': item "Barbarian's Helmet"
            call UnitAddItemByIdSwapped('I01S',GetLastCreatedUnit()) // 'I01S': item "Shimmering Mail"
            call UnitAddItemByIdSwapped('I02W',GetLastCreatedUnit()) // 'I02W': item "Necklace of the Sorcerer"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form4())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated4())then
            call CreateNUnitsAtLoc(1,'U01A',Player($B),udg_TempPoint,udg_TempReal) // 'U01A': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I0F3',GetLastCreatedUnit()) // 'I0F3': item "Mjolnir"
            call UnitAddItemByIdSwapped('I02T',GetLastCreatedUnit()) // 'I02T': item "Unholy Shield"
            call UnitAddItemByIdSwapped('I01J',GetLastCreatedUnit()) // 'I01J': item "Diamond Helmet"
            call UnitAddItemByIdSwapped('I01P',GetLastCreatedUnit()) // 'I01P': item "Grandmasterwork Leather"
            call UnitAddItemByIdSwapped('I0GJ',GetLastCreatedUnit()) // 'I0GJ': item "Stopwatch"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form5())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated5())then
            call CreateNUnitsAtLoc(1,'U01F',Player($B),udg_TempPoint,udg_TempReal) // 'U01F': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I0F2',GetLastCreatedUnit()) // 'I0F2': item "Icebrand"
            call UnitAddItemByIdSwapped('I03A',GetLastCreatedUnit()) // 'I03A': item "Frost Shield"
            call UnitAddItemByIdSwapped('I0FC',GetLastCreatedUnit()) // 'I0FC': item "Enchanted Helmet"
            call UnitAddItemByIdSwapped('I01S',GetLastCreatedUnit()) // 'I01S': item "Shimmering Mail"
            call UnitAddItemByIdSwapped('I0FX',GetLastCreatedUnit()) // 'I0FX': item "Orb of Frost"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form6())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated6())then
            call CreateNUnitsAtLoc(1,'U01I',Player($B),udg_TempPoint,udg_TempReal) // 'U01I': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I0F6',GetLastCreatedUnit()) // 'I0F6': item "Wildfire Spear"
            call UnitAddItemByIdSwapped('I0FA',GetLastCreatedUnit()) // 'I0FA': item "Flame Shield"
            call UnitAddItemByIdSwapped('I0FC',GetLastCreatedUnit()) // 'I0FC': item "Enchanted Helmet"
            call UnitAddItemByIdSwapped('I01V',GetLastCreatedUnit()) // 'I01V': item "Magician's Robe"
            call UnitAddItemByIdSwapped('I04D',GetLastCreatedUnit()) // 'I04D': item "Leather Gorget"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form7())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated7())then
            call CreateNUnitsAtLoc(1,'E01F',Player($B),udg_TempPoint,udg_TempReal) // 'E01F': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I00O',GetLastCreatedUnit()) // 'I00O': item "Fel Axe"
            call UnitAddItemByIdSwapped('I02T',GetLastCreatedUnit()) // 'I02T': item "Unholy Shield"
            call UnitAddItemByIdSwapped('I02Z',GetLastCreatedUnit()) // 'I02Z': item "Barbarian's Helmet"
            call UnitAddItemByIdSwapped('I05G',GetLastCreatedUnit()) // 'I05G': item "Gaia Gear"
            call UnitAddItemByIdSwapped('I00I',GetLastCreatedUnit()) // 'I00I': item "Germinas Boots"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form8())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated8())then
            call CreateNUnitsAtLoc(1,'U01C',Player($B),udg_TempPoint,udg_TempReal) // 'U01C': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I04E',GetLastCreatedUnit()) // 'I04E': item "Doom Mace"
            call UnitAddItemByIdSwapped('I02T',GetLastCreatedUnit()) // 'I02T': item "Unholy Shield"
            call UnitAddItemByIdSwapped('I02Z',GetLastCreatedUnit()) // 'I02Z': item "Barbarian's Helmet"
            call UnitAddItemByIdSwapped('I030',GetLastCreatedUnit()) // 'I030': item "Fur Armor"
            call UnitAddItemByIdSwapped('I04M',GetLastCreatedUnit()) // 'I04M': item "Stalwart Belt"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form9())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated9())then
            call CreateNUnitsAtLoc(1,'U01G',Player($B),udg_TempPoint,udg_TempReal) // 'U01G': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I0H5',GetLastCreatedUnit()) // 'I0H5': item "Dark Energy"
            call UnitAddItemByIdSwapped('I02S',GetLastCreatedUnit()) // 'I02S': item "Cursed Wand"
            call UnitAddItemByIdSwapped('I02Z',GetLastCreatedUnit()) // 'I02Z': item "Barbarian's Helmet"
            call UnitAddItemByIdSwapped('I01P',GetLastCreatedUnit()) // 'I01P': item "Grandmasterwork Leather"
            call UnitAddItemByIdSwapped('I063',GetLastCreatedUnit()) // 'I063': item "Charming Banner"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form10())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated10())then
            call CreateNUnitsAtLoc(1,'U01J',Player($B),udg_TempPoint,udg_TempReal) // 'U01J': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I04E',GetLastCreatedUnit()) // 'I04E': item "Doom Mace"
            call UnitAddItemByIdSwapped('I014',GetLastCreatedUnit()) // 'I014': item "Mithril Shield"
            call UnitAddItemByIdSwapped('I0FC',GetLastCreatedUnit()) // 'I0FC': item "Enchanted Helmet"
            call UnitAddItemByIdSwapped('I01S',GetLastCreatedUnit()) // 'I01S': item "Shimmering Mail"
            call UnitAddItemByIdSwapped('I031',GetLastCreatedUnit()) // 'I031': item "Crusher's Belt"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form11())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated11())then
            call CreateNUnitsAtLoc(1,'U01B',Player($B),udg_TempPoint,udg_TempReal) // 'U01B': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I0F8',GetLastCreatedUnit()) // 'I0F8': item "Ame-no-Murakumo"
            call UnitAddItemByIdSwapped('I0F8',GetLastCreatedUnit()) // 'I0F8': item "Ame-no-Murakumo"
            call UnitAddItemByIdSwapped('I0FC',GetLastCreatedUnit()) // 'I0FC': item "Enchanted Helmet"
            call UnitAddItemByIdSwapped('I0F9',GetLastCreatedUnit()) // 'I0F9': item "Windbreaker"
            call UnitAddItemByIdSwapped('I063',GetLastCreatedUnit()) // 'I063': item "Charming Banner"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_Form12())then
        if(Trig_Boss_Echele_SpawnForm_Cond_BraveDefeated12())then
            call CreateNUnitsAtLoc(1,'U01K',Player($B),udg_TempPoint,udg_TempReal) // 'U01K': unit "Ice Demon"; $B = 11
            set udg_EcheleBoss=GetLastCreatedUnit()
            call UnitAddItemByIdSwapped('I0IN',GetLastCreatedUnit()) // 'I0IN': item "Holy Energy"
            call UnitAddItemByIdSwapped('I0I5',GetLastCreatedUnit()) // 'I0I5': item "Tome of Crippling"
            call UnitAddItemByIdSwapped('I02U',GetLastCreatedUnit()) // 'I02U': item "Helm of the Necromancer"
            call UnitAddItemByIdSwapped('I01Y',GetLastCreatedUnit()) // 'I01Y': item "Genji Armor"
            call UnitAddItemByIdSwapped('I00H',GetLastCreatedUnit()) // 'I00H': item "Griever"
        else
            set udg_EchelePhase=(udg_EchelePhase+1)
        endif
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_HardModeMidForm())then
        call UnitAddAbilityBJ('A0MI',udg_EcheleBoss) // 'A0MI': ability "Omni Orb Amplification"
        call UnitAddAbilityBJ('A0MG',udg_EcheleBoss) // 'A0MG': ability "Omni Spell Amplification"
        call UnitAddAbilityBJ('A0WN',udg_EcheleBoss) // 'A0WN': ability "Physical Hardness"
        call UnitAddAbilityBJ('A0WP',udg_EcheleBoss) // 'A0WP': ability "Magical Hardness"
        call ModifyHeroStat(bj_HEROSTAT_STR,udg_EcheleBoss,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
        call ModifyHeroStat(bj_HEROSTAT_AGI,udg_EcheleBoss,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
        call ModifyHeroStat(bj_HEROSTAT_INT,udg_EcheleBoss,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
        // (udg_TempReal) plus (40).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(udg_TempReal+40.))
        call ConditionalTriggerExecute(gg_trg_TrueIceAge_SpawnBrave)
        // (udg_TempReal) plus (320).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(udg_TempReal+320.))
        call ConditionalTriggerExecute(gg_trg_TrueIceAge_SpawnBrave)
    endif
    if(Trig_Boss_Echele_SpawnForm_Cond_SpawnTrueForm())then
        call CreateNUnitsAtLoc(1,'N024',Player($B),udg_TempPoint,udg_TempReal) // 'N024': unit "Ice Demon"; $B = 11
        set udg_EcheleBoss=GetLastCreatedUnit()
        call UnitAddItemByIdSwapped('I0LP',GetLastCreatedUnit()) // 'I0LP': item "True Ice Axe"
        call UnitAddItemByIdSwapped('I03A',GetLastCreatedUnit()) // 'I03A': item "Frost Shield"
        if(Trig_Boss_Echele_SpawnForm_Cond_HardMode_Items())then
            call UnitAddItemByIdSwapped('I0D4',GetLastCreatedUnit()) // 'I0D4': item "Helm of Divine Judgement"
            call UnitAddItemByIdSwapped('I0E5',GetLastCreatedUnit()) // 'I0E5': item "Maximillian"
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (1500).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+$5DC),0) // $5DC = 1500
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (1500).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+$5DC),1) // $5DC = 1500
            // (BlzGetUnitArmor(GetLastCreatedUnit())) plus (60).
            call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+60.))
            // (maximum health of GetLastCreatedUnit()) plus (20000).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+$4E20)) // $4E20 = 20000
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
            call UnitAddAbilityBJ('A12D',udg_EcheleBoss) // 'A12D': ability "Dewall"
            call UnitAddAbilityBJ('A12U',udg_EcheleBoss) // 'A12U': ability "Attack Speed +80%"
            call UnitAddAbilityBJ('ACev',udg_EcheleBoss) // 'ACev': ability "Swiftness"
            call UnitAddAbilityBJ('A1F3',udg_EcheleBoss) // 'A1F3': ability "Imperiled Strike"
            call UnitAddAbilityBJ('A15A',udg_EcheleBoss) // 'A15A': ability "Shock"
            call UnitAddAbilityBJ('A0UG',udg_EcheleBoss) // 'A0UG': ability "!Ultima"
        else
            call UnitAddItemByIdSwapped('I02Z',GetLastCreatedUnit()) // 'I02Z': item "Barbarian's Helmet"
            call UnitAddItemByIdSwapped('I01P',GetLastCreatedUnit()) // 'I01P': item "Grandmasterwork Leather"
        endif
        call UnitAddItemByIdSwapped('I00J',GetLastCreatedUnit()) // 'I00J': item "Chimes of Piercing"
        call UnitAddItemByIdSwapped('I02X',GetLastCreatedUnit()) // 'I02X': item "Greater Nectar"
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Echele_SpawnForm_Cond_IsTrueForm())then
        if(Trig_Boss_Echele_SpawnForm_Cond_HardMode_TrueForm())then
            call SetHeroLevelBJ(udg_EcheleBoss,99,false)
            call ModifyHeroStat(bj_HEROSTAT_STR,udg_EcheleBoss,bj_MODIFYMETHOD_ADD,9)
            call ModifyHeroStat(bj_HEROSTAT_AGI,udg_EcheleBoss,bj_MODIFYMETHOD_ADD,9)
            call ModifyHeroStat(bj_HEROSTAT_INT,udg_EcheleBoss,bj_MODIFYMETHOD_ADD,9)
            call TriggerRegisterUnitEvent(gg_trg_TrueIceAge_Victory,udg_EcheleBoss,EVENT_UNIT_DEATH)
            call EnableTrigger(gg_trg_TrueIceAge_Victory)
        else
            if(Trig_Boss_Echele_SpawnForm_Cond_FinalFormSpawn())then
                set udg_SpeedrunBoss[5]=udg_EcheleBoss
            endif
            // (98) minus ((udg_EcheleFormsKilled) times (4)).
            call SetHeroLevelBJ(udg_EcheleBoss,(98-(udg_EcheleFormsKilled*4)),false)
            call ModifyHeroStat(bj_HEROSTAT_STR,udg_EcheleBoss,bj_MODIFYMETHOD_SUB,$96) // $96 = 150
            call ModifyHeroStat(bj_HEROSTAT_AGI,udg_EcheleBoss,bj_MODIFYMETHOD_SUB,$96) // $96 = 150
            call ModifyHeroStat(bj_HEROSTAT_INT,udg_EcheleBoss,bj_MODIFYMETHOD_SUB,$96) // $96 = 150
            call TriggerRegisterUnitEvent(gg_trg_IceAge_Victory,udg_EcheleBoss,EVENT_UNIT_DEATH)
            call EnableTrigger(gg_trg_IceAge_Victory)
        endif
    else
        if(Trig_Boss_Echele_SpawnForm_Cond_HardMode_Minor())then
            call SetHeroLevelBJ(udg_EcheleBoss,80,false)
        else
            call SetHeroLevelBJ(udg_EcheleBoss,50,false)
        endif
        call TriggerRegisterUnitEvent(gg_trg_Boss_Echele_FormChange,udg_EcheleBoss,EVENT_UNIT_DEATH)
        call EnableTrigger(gg_trg_Boss_Echele_FormChange)
    endif
endfunction

function Trig_Boss_Echele_FormChange_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Boss_Echele_FormChange_Cond_HasMinions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_BossSummons)==false)
endfunction

function Trig_Boss_Echele_FormChange_Cond_TrueFormNext takes nothing returns boolean
    return(udg_EchelePhase>=$D) // $D = 13
endfunction

function Trig_Boss_Echele_FormChange_Enum_UnpauseUnit takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Boss_Echele_FormChange_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Echele_FormChange_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_EcheleFormsKilled=(udg_EcheleFormsKilled+1)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_QuestUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    if(Trig_Boss_Echele_FormChange_Cond_HasMinions())then
        call GroupAddGroup(udg_BossSummons,udg_EcheleMinionsToKill)
        call GroupClear(udg_BossSummons)
        call StartTimerBJ(udg_EcheleMinionKillTimer,false,.01)
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempReal=GetUnitFacing(GetTriggerUnit())
    call RemoveUnit(GetTriggerUnit())
    call ConditionalTriggerExecute(gg_trg_Boss_Echele_SpawnForm)
    if(Trig_Boss_Echele_FormChange_Cond_CinematicsEnabled())then
        call PauseTimerBJ(true,udg_WorldFreezeTimer)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call SetUnitInvulnerable(udg_EcheleBoss,true)
        call Wait_Polled(2)
        call EnableTrigger(GetTriggeringTrigger())
        if(Trig_Boss_Echele_FormChange_Cond_TrueFormNext())then
            call Text_Say(null,"|cffffcc00Echele switches to his true form!|r",false)
        else
            call Text_Say(null,"|cffffcc00Echele switches mode of attack!|r",false)
        endif
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(1.)
        call SetUnitInvulnerable(udg_EcheleBoss,false)
        call Cine_ExitAction()
        call PauseTimerBJ(false,udg_WorldFreezeTimer)
        call ForGroupBJ(udg_BossSummons,function Trig_Boss_Echele_FormChange_Enum_UnpauseUnit)
    else
        call BattleLog_ShowUnit("switches mode of attack!",GetTriggerUnit())
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateTextTagLocBJ("|cffffcc00MODE CHANGE",udg_TempPoint,0,13.,'d','d','d',0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call GroupAddUnitSimple(udg_EcheleBoss,udg_QuestUnits)
    call GroupAddUnitSimple(udg_EcheleBoss,udg_BossGroup)
endfunction

function Trig_Boss_Echele_KillMinions_Enum_KillUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Boss_Echele_KillMinions_Actions takes nothing returns nothing
    call ForGroupBJ(udg_EcheleMinionsToKill,function Trig_Boss_Echele_KillMinions_Enum_KillUnit)
    call GroupClear(udg_EcheleMinionsToKill)
endfunction

function Trig_Boss_Echele_Leash_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Boss_Echele_Leash_Enum_MoveMinion takes nothing returns nothing
    call SetUnitPositionLocFacingBJ(GetEnumUnit(),udg_TempPoint,90.)
endfunction

function Trig_Boss_Echele_Leash_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_645)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,90.)
    call ForGroupBJ(udg_BossSummons,function Trig_Boss_Echele_Leash_Enum_MoveMinion)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

function InitTrig_Boss_Echele takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part7 (module Boss),
// which keeps the original registration order.

function Register_Boss_Echele_Start takes nothing returns nothing
    set gg_trg_Boss_Echele_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_Start)
    call TriggerRegisterEnterRectSimple(gg_trg_Boss_Echele_Start,gg_rct_657)
    call TriggerAddCondition(gg_trg_Boss_Echele_Start,Condition(function Trig_Boss_Echele_Start_Conditions))
    call TriggerAddAction(gg_trg_Boss_Echele_Start,function Trig_Boss_Echele_Start_Actions)
endfunction

function Register_Boss_Echele_SpawnForm takes nothing returns nothing
    set gg_trg_Boss_Echele_SpawnForm=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_SpawnForm)
    call TriggerAddAction(gg_trg_Boss_Echele_SpawnForm,function Trig_Boss_Echele_SpawnForm_Actions)
endfunction

function Register_Boss_Echele_FormChange takes nothing returns nothing
    set gg_trg_Boss_Echele_FormChange=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_FormChange)
    call TriggerAddCondition(gg_trg_Boss_Echele_FormChange,Condition(function Trig_Boss_Echele_FormChange_Conditions))
    call TriggerAddAction(gg_trg_Boss_Echele_FormChange,function Trig_Boss_Echele_FormChange_Actions)
endfunction

function Register_Boss_Echele_KillMinions takes nothing returns nothing
    set gg_trg_Boss_Echele_KillMinions=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_Echele_KillMinions,udg_EcheleMinionKillTimer)
    call TriggerAddAction(gg_trg_Boss_Echele_KillMinions,function Trig_Boss_Echele_KillMinions_Actions)
endfunction

function Register_Boss_Echele_Leash takes nothing returns nothing
    set gg_trg_Boss_Echele_Leash=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_Leash)
    call TriggerRegisterEnterRectSimple(gg_trg_Boss_Echele_Leash,gg_rct_660)
    call TriggerAddCondition(gg_trg_Boss_Echele_Leash,Condition(function Trig_Boss_Echele_Leash_Conditions))
    call TriggerAddAction(gg_trg_Boss_Echele_Leash,function Trig_Boss_Echele_Leash_Actions)
endfunction

endlibrary

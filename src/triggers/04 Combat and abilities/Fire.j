library TFire requires TAbil, TCam, TCine, TProf, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Fire_Cast=null
    trigger gg_trg_Fire_Pawn_Nectar=null
    trigger gg_trg_Fire_Pawn_SpiritPotion=null
    trigger gg_trg_Fire_Pawn_BloodEther=null
    trigger gg_trg_Fire_Pawn_HeroDrink=null
    trigger gg_trg_Fire_Reward_Megalixir=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    boolean udg_FireCastToggle=false
    sound gg_snd_PandarenBrewmasterYes=null
endglobals

function Trig_Fire_Cast_IsFire takes nothing returns boolean
    return(GetSpellAbilityId()=='A0PU')or(GetSpellAbilityId()=='A0QA')or(GetSpellAbilityId()=='A19P')or(GetSpellAbilityId()=='A0JD')or(GetSpellAbilityId()=='A0U8')or(GetSpellAbilityId()=='A142')or(GetSpellAbilityId()=='A0SH') // 'A0PU': ability "Fire"; 'A0QA': ability "Fire"; 'A19P': ability "Fire"; 'A0JD': ability "Elementa"; 'A0U8': ability "Elementa"; 'A142': ability "Elementa"; 'A0SH': ability "Fire"
endfunction

function Trig_Fire_Cast_Conditions takes nothing returns boolean
    return(Trig_Fire_Cast_IsFire())
endfunction

function Trig_Fire_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Fire_Cast_IsElementa takes nothing returns boolean
    return(GetSpellAbilityId()=='A0JD')or(GetSpellAbilityId()=='A0U8') // 'A0JD': ability "Elementa"; 'A0U8': ability "Elementa"
endfunction

function Trig_Fire_Cast_IsElementaCast takes nothing returns boolean
    return(Trig_Fire_Cast_IsElementa())
endfunction

function Trig_Fire_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Fire_Cast_UseAltDummy takes nothing returns boolean
    return(udg_FireCastToggle)
endfunction

function Trig_Fire_Cast_Actions takes nothing returns nothing
    if(Trig_Fire_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Start with one quarter of the spell's mana cost, dropping any fraction.
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 4)
    if(Trig_Fire_Cast_IsElementaCast())then
        // This branch halves that base again, dropping any fraction before later bonuses.
        set udg_TempInteger=(udg_TempInteger/ 2)
    endif
    if(Trig_Fire_Cast_IsHero())then
        // A hero adds half of Intelligence, with the fraction dropped.
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 2))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    if(Trig_Fire_Cast_UseAltDummy())then
        call UnitAddAbilityBJ('A0DQ',GetLastCreatedUnit()) // 'A0DQ': ability "Fire"
        set udg_FireCastToggle=false
    else
        call UnitAddAbilityBJ('A07Z',GetLastCreatedUnit()) // 'A07Z': ability "Fire"
        set udg_FireCastToggle=true
    endif
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Fire_Pawn_Nectar_Cond_NectarSoldToFire takes nothing returns boolean
    return(GetBuyingUnit()==gg_unit_n001_0012)or(GetBuyingUnit()==gg_unit_n02K_0073)
endfunction

function Trig_Fire_Pawn_Nectar_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())=='I02X')and(Trig_Fire_Pawn_Nectar_Cond_NectarSoldToFire()) // 'I02X': item "Greater Nectar"
endfunction

function Trig_Fire_Pawn_Nectar_Cond_NectarAllPotions takes nothing returns boolean
    return(udg_FirePotionCount[0]>=4)
endfunction

function Trig_Fire_Pawn_Nectar_Cond_NectarQuotaMet takes nothing returns boolean
    return(udg_FirePotionCount[1]>=16)
endfunction

function Trig_Fire_Pawn_Nectar_Cond_NectarQuotaLow takes nothing returns boolean
    return(udg_FirePotionCount[1]<16)
endfunction

function Trig_Fire_Pawn_Nectar_Actions takes nothing returns nothing
    // (udg_FirePotionCount at position 1) plus (item charges of GetSoldItem()).
    set udg_FirePotionCount[1]=(udg_FirePotionCount[1]+GetItemCharges(GetSoldItem()))
    if(Trig_Fire_Pawn_Nectar_Cond_NectarQuotaLow())then
        call ConditionalTriggerExecute(gg_trg_Npc_Fire_WantMore)
    else
        if(Trig_Fire_Pawn_Nectar_Cond_NectarQuotaMet())then
            call DisableTrigger(GetTriggeringTrigger())
            call ConditionalTriggerExecute(gg_trg_Npc_Fire_Thanks)
            call Wait_Polled(180.)
            call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire's stock contains a new item for sale !!!|r")
            call AddItemToStockBJ('I02X',gg_unit_n02K_0073,0,99) // 'I02X': item "Greater Nectar"
            set udg_FirePotionCount[0]=(udg_FirePotionCount[0]+1)
            if(Trig_Fire_Pawn_Nectar_Cond_NectarAllPotions())then
                call Wait_Polled(180.)
                set udg_SpecialEffect[17]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n001_0012,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                call EnableTrigger(gg_trg_Fire_Reward_Megalixir)
                call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire has something to tell you !!!|r")
                call PlaySoundBJ(gg_snd_PandarenBrewmasterYes)
            endif
            call DestroyTrigger(GetTriggeringTrigger())
        endif
    endif
endfunction

function Trig_Fire_Pawn_SpiritPotion_Cond_PotionSoldToFire takes nothing returns boolean
    return(GetBuyingUnit()==gg_unit_n001_0012)or(GetBuyingUnit()==gg_unit_n02K_0073)
endfunction

function Trig_Fire_Pawn_SpiritPotion_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())=='I05I')and(Trig_Fire_Pawn_SpiritPotion_Cond_PotionSoldToFire()) // 'I05I': item "Spirit Potion"
endfunction

function Trig_Fire_Pawn_SpiritPotion_Cond_PotionAllPotions takes nothing returns boolean
    return(udg_FirePotionCount[0]>=4)
endfunction

function Trig_Fire_Pawn_SpiritPotion_Cond_PotionQuotaMet takes nothing returns boolean
    return(udg_FirePotionCount[2]>=$A) // $A = 10
endfunction

function Trig_Fire_Pawn_SpiritPotion_Cond_PotionQuotaLow takes nothing returns boolean
    return(udg_FirePotionCount[2]<$A) // $A = 10
endfunction

function Trig_Fire_Pawn_SpiritPotion_Actions takes nothing returns nothing
    // (udg_FirePotionCount at position 2) plus (item charges of GetSoldItem()).
    set udg_FirePotionCount[2]=(udg_FirePotionCount[2]+GetItemCharges(GetSoldItem()))
    if(Trig_Fire_Pawn_SpiritPotion_Cond_PotionQuotaLow())then
        call ConditionalTriggerExecute(gg_trg_Npc_Fire_WantMore)
    else
        if(Trig_Fire_Pawn_SpiritPotion_Cond_PotionQuotaMet())then
            call DisableTrigger(GetTriggeringTrigger())
            call ConditionalTriggerExecute(gg_trg_Npc_Fire_Thanks)
            call Wait_Polled(180.)
            call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire's stock contains a new item for sale !!!|r")
            call AddItemToStockBJ('I05I',gg_unit_n02K_0073,0,99) // 'I05I': item "Spirit Potion"
            set udg_FirePotionCount[0]=(udg_FirePotionCount[0]+1)
            if(Trig_Fire_Pawn_SpiritPotion_Cond_PotionAllPotions())then
                call Wait_Polled(180.)
                set udg_SpecialEffect[17]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n001_0012,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                call EnableTrigger(gg_trg_Fire_Reward_Megalixir)
                call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire has something to tell you !!!|r")
                call PlaySoundBJ(gg_snd_PandarenBrewmasterYes)
            endif
            call DestroyTrigger(GetTriggeringTrigger())
        endif
    endif
endfunction

function Trig_Fire_Pawn_BloodEther_Cond_EtherSoldToFire takes nothing returns boolean
    return(GetBuyingUnit()==gg_unit_n001_0012)or(GetBuyingUnit()==gg_unit_n02K_0073)
endfunction

function Trig_Fire_Pawn_BloodEther_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())=='I05H')and(Trig_Fire_Pawn_BloodEther_Cond_EtherSoldToFire()) // 'I05H': item "Blood Ether"
endfunction

function Trig_Fire_Pawn_BloodEther_Cond_EtherAllPotions takes nothing returns boolean
    return(udg_FirePotionCount[0]>=4)
endfunction

function Trig_Fire_Pawn_BloodEther_Cond_EtherQuotaMet takes nothing returns boolean
    return(udg_FirePotionCount[3]>=$A) // $A = 10
endfunction

function Trig_Fire_Pawn_BloodEther_Cond_EtherQuotaLow takes nothing returns boolean
    return(udg_FirePotionCount[3]<$A) // $A = 10
endfunction

function Trig_Fire_Pawn_BloodEther_Actions takes nothing returns nothing
    // (udg_FirePotionCount at position 3) plus (item charges of GetSoldItem()).
    set udg_FirePotionCount[3]=(udg_FirePotionCount[3]+GetItemCharges(GetSoldItem()))
    if(Trig_Fire_Pawn_BloodEther_Cond_EtherQuotaLow())then
        call ConditionalTriggerExecute(gg_trg_Npc_Fire_WantMore)
    else
        if(Trig_Fire_Pawn_BloodEther_Cond_EtherQuotaMet())then
            call DisableTrigger(GetTriggeringTrigger())
            call ConditionalTriggerExecute(gg_trg_Npc_Fire_Thanks)
            call Wait_Polled(180.)
            call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire's stock contains a new item for sale !!!|r")
            call AddItemToStockBJ('I05H',gg_unit_n02K_0073,0,99) // 'I05H': item "Blood Ether"
            set udg_FirePotionCount[0]=(udg_FirePotionCount[0]+1)
            if(Trig_Fire_Pawn_BloodEther_Cond_EtherAllPotions())then
                call Wait_Polled(180.)
                set udg_SpecialEffect[17]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n001_0012,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                call EnableTrigger(gg_trg_Fire_Reward_Megalixir)
                call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire has something to tell you !!!|r")
                call PlaySoundBJ(gg_snd_PandarenBrewmasterYes)
            endif
            call DestroyTrigger(GetTriggeringTrigger())
        endif
    endif
endfunction

function Trig_Fire_Pawn_HeroDrink_Cond_DrinkSoldToFire takes nothing returns boolean
    return(GetBuyingUnit()==gg_unit_n001_0012)or(GetBuyingUnit()==gg_unit_n02K_0073)
endfunction

function Trig_Fire_Pawn_HeroDrink_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())=='pdiv')and(Trig_Fire_Pawn_HeroDrink_Cond_DrinkSoldToFire()) // 'pdiv': item "Hero Drink"
endfunction

function Trig_Fire_Pawn_HeroDrink_Cond_DrinkAllPotions takes nothing returns boolean
    return(udg_FirePotionCount[0]>=4)
endfunction

function Trig_Fire_Pawn_HeroDrink_Cond_DrinkQuotaMet takes nothing returns boolean
    return(udg_FirePotionCount[4]>=7)
endfunction

function Trig_Fire_Pawn_HeroDrink_Cond_DrinkQuotaLow takes nothing returns boolean
    return(udg_FirePotionCount[4]<7)
endfunction

function Trig_Fire_Pawn_HeroDrink_Actions takes nothing returns nothing
    // (udg_FirePotionCount at position 4) plus (item charges of GetSoldItem()).
    set udg_FirePotionCount[4]=(udg_FirePotionCount[4]+GetItemCharges(GetSoldItem()))
    if(Trig_Fire_Pawn_HeroDrink_Cond_DrinkQuotaLow())then
        call ConditionalTriggerExecute(gg_trg_Npc_Fire_WantMore)
    else
        if(Trig_Fire_Pawn_HeroDrink_Cond_DrinkQuotaMet())then
            call DisableTrigger(GetTriggeringTrigger())
            call ConditionalTriggerExecute(gg_trg_Npc_Fire_Thanks)
            call Wait_Polled(180.)
            call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire's stock contains a new item for sale !!!|r")
            call AddItemToStockBJ('pdiv',gg_unit_n02K_0073,0,99) // 'pdiv': item "Hero Drink"
            set udg_FirePotionCount[0]=(udg_FirePotionCount[0]+1)
            if(Trig_Fire_Pawn_HeroDrink_Cond_DrinkAllPotions())then
                call Wait_Polled(180.)
                set udg_SpecialEffect[17]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n001_0012,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                call EnableTrigger(gg_trg_Fire_Reward_Megalixir)
                call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire has something to tell you !!!|r")
                call PlaySoundBJ(gg_snd_PandarenBrewmasterYes)
            endif
            call DestroyTrigger(GetTriggeringTrigger())
        endif
    endif
endfunction

function Trig_Fire_Reward_Megalixir_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n001_0012,true,true,true))
endfunction

function Trig_Fire_Reward_Megalixir_Cond_FireCineOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Fire_Reward_Megalixir_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[17])
    if(Trig_Fire_Reward_Megalixir_Cond_FireCineOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n001_0012,0)
        call Text_Transmission(gg_unit_n001_0012,"Fire","I have to thank you. Thanks to you I can now create and sell nearly every potion in existence.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n001_0012,"Fire","I have even managed to create a Megalixir. It was extremely difficult however and I don't think I will ever create one again.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n001_0012,"Fire","If you are interested in purchasing it, I welcome you to. Use it wisely though! It is my masterpiece.","(null)",null,0,false)
        call Cine_ExitAction()
    endif
    call AddItemToStockBJ('I03P',gg_unit_n02K_0073,1,1) // 'I03P': item "Megalixir"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Fire automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Fire_Part1 / RegisterTriggers_Fire_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Fire takes nothing returns nothing
endfunction

function Register_Fire_Cast takes nothing returns nothing
    set gg_trg_Fire_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fire_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Fire_Cast,Condition(function Trig_Fire_Cast_Conditions))
    call TriggerAddAction(gg_trg_Fire_Cast,function Trig_Fire_Cast_Actions)
endfunction

function Register_Fire_Pawn_Nectar takes nothing returns nothing
    set gg_trg_Fire_Pawn_Nectar=CreateTrigger()
    call DisableTrigger(gg_trg_Fire_Pawn_Nectar)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fire_Pawn_Nectar,EVENT_PLAYER_UNIT_PAWN_ITEM)
    call TriggerAddCondition(gg_trg_Fire_Pawn_Nectar,Condition(function Trig_Fire_Pawn_Nectar_Conditions))
    call TriggerAddAction(gg_trg_Fire_Pawn_Nectar,function Trig_Fire_Pawn_Nectar_Actions)
endfunction

function Register_Fire_Pawn_SpiritPotion takes nothing returns nothing
    set gg_trg_Fire_Pawn_SpiritPotion=CreateTrigger()
    call DisableTrigger(gg_trg_Fire_Pawn_SpiritPotion)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fire_Pawn_SpiritPotion,EVENT_PLAYER_UNIT_PAWN_ITEM)
    call TriggerAddCondition(gg_trg_Fire_Pawn_SpiritPotion,Condition(function Trig_Fire_Pawn_SpiritPotion_Conditions))
    call TriggerAddAction(gg_trg_Fire_Pawn_SpiritPotion,function Trig_Fire_Pawn_SpiritPotion_Actions)
endfunction

function Register_Fire_Pawn_BloodEther takes nothing returns nothing
    set gg_trg_Fire_Pawn_BloodEther=CreateTrigger()
    call DisableTrigger(gg_trg_Fire_Pawn_BloodEther)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fire_Pawn_BloodEther,EVENT_PLAYER_UNIT_PAWN_ITEM)
    call TriggerAddCondition(gg_trg_Fire_Pawn_BloodEther,Condition(function Trig_Fire_Pawn_BloodEther_Conditions))
    call TriggerAddAction(gg_trg_Fire_Pawn_BloodEther,function Trig_Fire_Pawn_BloodEther_Actions)
endfunction

function Register_Fire_Pawn_HeroDrink takes nothing returns nothing
    set gg_trg_Fire_Pawn_HeroDrink=CreateTrigger()
    call DisableTrigger(gg_trg_Fire_Pawn_HeroDrink)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fire_Pawn_HeroDrink,EVENT_PLAYER_UNIT_PAWN_ITEM)
    call TriggerAddCondition(gg_trg_Fire_Pawn_HeroDrink,Condition(function Trig_Fire_Pawn_HeroDrink_Conditions))
    call TriggerAddAction(gg_trg_Fire_Pawn_HeroDrink,function Trig_Fire_Pawn_HeroDrink_Actions)
endfunction

function Register_Fire_Reward_Megalixir takes nothing returns nothing
    set gg_trg_Fire_Reward_Megalixir=CreateTrigger()
    call DisableTrigger(gg_trg_Fire_Reward_Megalixir)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Fire_Reward_Megalixir,Player(7),true)
    call TriggerAddCondition(gg_trg_Fire_Reward_Megalixir,Condition(function Trig_Fire_Reward_Megalixir_Conditions))
    call TriggerAddAction(gg_trg_Fire_Reward_Megalixir,function Trig_Fire_Reward_Megalixir_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Fire_Part1 takes nothing returns nothing
    call Register_Fire_Cast()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Fire_Part2 takes nothing returns nothing
    call Register_Fire_Pawn_Nectar() // starts off; enabled by Elixir
    call Register_Fire_Pawn_SpiritPotion() // starts off; enabled by Elixir
    call Register_Fire_Pawn_BloodEther() // starts off; enabled by Elixir
    call Register_Fire_Pawn_HeroDrink() // starts off; enabled by Elixir
    call Register_Fire_Reward_Megalixir() // starts off; enabled by Fire
endfunction

endlibrary

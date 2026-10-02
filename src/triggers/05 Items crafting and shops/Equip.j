library TEquip requires TForce, TJob
function Trig_Equip_Restrictions_Conditions takes nothing returns boolean
    return((GetManipulatedItem()!=null)and(GetItemType(GetManipulatedItem())!=ITEM_TYPE_CHARGED)and(GetItemType(GetManipulatedItem())!=ITEM_TYPE_CAMPAIGN)and(GetUnitTypeId(GetManipulatingUnit())!='H01D')and(IsUnitType(GetManipulatingUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers)))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Equip_Restrictions_BothOffhand takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_POWERUP)and(GetItemType(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==ITEM_TYPE_POWERUP)
endfunction

function Trig_Equip_Restrictions_HandsFull takes nothing returns boolean
    return(udg_TempBoolean)or(Trig_Equip_Restrictions_BothOffhand())
endfunction

function Trig_Equip_Restrictions_Cond_HandsFull takes nothing returns boolean
    return(Trig_Equip_Restrictions_HandsFull())
endfunction

function Trig_Equip_Restrictions_SlotIsHandGear takes nothing returns boolean
    return(GetItemType(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==ITEM_TYPE_PERMANENT)or(GetItemType(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==ITEM_TYPE_POWERUP)
endfunction

function Trig_Equip_Restrictions_OtherHandGear takes nothing returns boolean
    return(UnitItemInSlotBJ(GetManipulatingUnit(),udg_SlotIndex)!=null)and(UnitItemInSlotBJ(GetManipulatingUnit(),udg_SlotIndex)!=GetManipulatedItem())and(Trig_Equip_Restrictions_SlotIsHandGear())
endfunction

function Trig_Equip_Restrictions_IsArmor takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_PURCHASABLE)
endfunction

function Trig_Equip_Restrictions_IsHelmet takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_ARTIFACT)
endfunction

function Trig_Equip_Restrictions_IsOffhand takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_POWERUP)
endfunction

function Trig_Equip_Restrictions_IsWeapon takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_PERMANENT)
endfunction

function Trig_Equip_Restrictions_SameSlotType takes nothing returns boolean
    return(UnitItemInSlotBJ(GetManipulatingUnit(),udg_SlotIndex)!=null)and(UnitItemInSlotBJ(GetManipulatingUnit(),udg_SlotIndex)!=GetManipulatedItem())and(GetItemType(UnitItemInSlotBJ(GetManipulatingUnit(),udg_SlotIndex))==GetItemType(GetManipulatedItem()))
endfunction

function Trig_Equip_Restrictions_IsHandGear takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_PERMANENT)or(GetItemType(GetManipulatedItem())==ITEM_TYPE_POWERUP)
endfunction

function Trig_Equip_Restrictions_CanDualWield takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HP',GetTriggerUnit())>=1)and(Trig_Equip_Restrictions_IsHandGear()) // 'A0HP': ability "Dual Wield"
endfunction

function Trig_Equip_Restrictions_NeedMediator takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==$B)and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00G')<'d') // $B = 11; 'H00G': unit "Mediator"
endfunction

function Trig_Equip_Restrictions_HasDarkKnight takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_Equip_Restrictions_NeedHolyOrDark takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00M')<'d')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H02X')<'d') // 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Equip_Restrictions_ItemLevel8 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==8)
endfunction

function Trig_Equip_Restrictions_NeedSamurai takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00E')<'d') // 'H00E': unit "Samurai"
endfunction

function Trig_Equip_Restrictions_ItemLevel7 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==7)
endfunction

function Trig_Equip_Restrictions_NeedGeomancer takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00D')<'d') // 'H00D': unit "Geomancer"
endfunction

function Trig_Equip_Restrictions_ItemLevel6 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==6)
endfunction

function Trig_Equip_Restrictions_NeedLancer takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00C')<'d') // 'H00C': unit "Lancer"
endfunction

function Trig_Equip_Restrictions_ItemLevel5 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==5)
endfunction

function Trig_Equip_Restrictions_NeedThiefNinja takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==4)and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00B')<'d')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00F')<'d') // 'H00B': unit "Thief"; 'H00F': unit "Ninja"
endfunction

function Trig_Equip_Restrictions_NeedMonk takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00A')<'d') // 'H00A': unit "Monk"
endfunction

function Trig_Equip_Restrictions_ItemLevel0 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==0)
endfunction

function Trig_Equip_Restrictions_NeedArcher takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H001')<'d') // 'H001': unit "Archer"
endfunction

function Trig_Equip_Restrictions_ItemLevel3 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==3)
endfunction

function Trig_Equip_Restrictions_NeedKnight takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H003')<'d') // 'H003': unit "Knight"
endfunction

function Trig_Equip_Restrictions_ItemLevel2 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==2)
endfunction

function Trig_Equip_Restrictions_NeedSquireChemist takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H000')<'d')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H002')<'d') // 'H000': unit "Squire"; 'H002': unit "Chemist"
endfunction

function Trig_Equip_Restrictions_ItemLevel1 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())==1)
endfunction

function Trig_Equip_Restrictions_ItemLevelUnder5 takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())<5)
endfunction

function Trig_Equip_Restrictions_MasterMissing takes nothing returns boolean
    return(udg_TempString!=" ")
endfunction

function Trig_Equip_Restrictions_JobGatedItem takes nothing returns boolean
    return(GetItemLifeBJ(GetManipulatedItem())==145.)
endfunction

function Trig_Equip_Restrictions_GaiaLevelTooLow takes nothing returns boolean
    // Result 1: hero level of udg_SpiritOfGaya at position GetConvertedPlayerId(GetOwningPlayer(the triggering
    // unit)) treated as a decimal-capable number.
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetItemLifeBJ(GetManipulatedItem())>I2R(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
endfunction

function Trig_Equip_Restrictions_Actions takes nothing returns nothing
    set udg_SpeedrunFlag[4]=true
    if(Trig_Equip_Restrictions_CanDualWield())then
        set udg_TempBoolean=false
        set udg_SlotIndex=1
        loop
            exitwhen udg_SlotIndex>6
            if(Trig_Equip_Restrictions_OtherHandGear())then
                if(Trig_Equip_Restrictions_Cond_HandsFull())then
                    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                    call DisplayTextToForce(udg_TempForce,"You are already using gear for |cffff0000both of your hands|r.")
                    call DestroyForce(udg_TempForce)
                    call UnitRemoveItemSwapped(GetManipulatedItem(),GetManipulatingUnit())
                    return
                else
                    set udg_TempBoolean=true
                endif
            endif
            set udg_SlotIndex=udg_SlotIndex+1
        endloop
    else
        set udg_SlotIndex=1
        loop
            exitwhen udg_SlotIndex>6
            if(Trig_Equip_Restrictions_SameSlotType())then
                set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                if(Trig_Equip_Restrictions_IsWeapon())then
                    call DisplayTextToForce(udg_TempForce,"You are already using a different |cffff0000Weapon|r.")
                else
                    if(Trig_Equip_Restrictions_IsOffhand())then
                        call DisplayTextToForce(udg_TempForce,"You are already using different |cffff8040Offhand gear|r.")
                    else
                        if(Trig_Equip_Restrictions_IsHelmet())then
                            call DisplayTextToForce(udg_TempForce,"You are already using a different |cffffff00Helmet|r.")
                        else
                            if(Trig_Equip_Restrictions_IsArmor())then
                                call DisplayTextToForce(udg_TempForce,"You are already using different |cffff00ffArmor|r.")
                            else
                                call DisplayTextToForce(udg_TempForce,"You are already using a different |cff00ffffAccessory|r.")
                            endif
                        endif
                    endif
                endif
                call DestroyForce(udg_TempForce)
                call UnitRemoveItemSwapped(GetManipulatedItem(),GetManipulatingUnit())
                return
            endif
            set udg_SlotIndex=udg_SlotIndex+1
        endloop
    endif
    if(Trig_Equip_Restrictions_GaiaLevelTooLow())then
        if(Trig_Equip_Restrictions_JobGatedItem())then
            set udg_TempString=" "
            if(Trig_Equip_Restrictions_ItemLevelUnder5())then
                if(Trig_Equip_Restrictions_ItemLevel1())then
                    if(Trig_Equip_Restrictions_NeedSquireChemist())then
                        set udg_TempString="Squire or Chemist"
                    endif
                else
                    if(Trig_Equip_Restrictions_ItemLevel2())then
                        if(Trig_Equip_Restrictions_NeedKnight())then
                            set udg_TempString="Knight"
                        endif
                    else
                        if(Trig_Equip_Restrictions_ItemLevel3())then
                            if(Trig_Equip_Restrictions_NeedArcher())then
                                set udg_TempString="Archer"
                            endif
                        else
                            if(Trig_Equip_Restrictions_ItemLevel0())then
                                if(Trig_Equip_Restrictions_NeedMonk())then
                                    set udg_TempString="Monk"
                                endif
                            else
                                if(Trig_Equip_Restrictions_NeedThiefNinja())then
                                    set udg_TempString="Thief or Ninja"
                                endif
                            endif
                        endif
                    endif
                endif
            else
                if(Trig_Equip_Restrictions_ItemLevel5())then
                    if(Trig_Equip_Restrictions_NeedLancer())then
                        set udg_TempString="Lancer"
                    endif
                else
                    if(Trig_Equip_Restrictions_ItemLevel6())then
                        if(Trig_Equip_Restrictions_NeedGeomancer())then
                            set udg_TempString="Geomancer"
                        endif
                    else
                        if(Trig_Equip_Restrictions_ItemLevel7())then
                            if(Trig_Equip_Restrictions_NeedSamurai())then
                                set udg_TempString="Samurai"
                            endif
                        else
                            if(Trig_Equip_Restrictions_ItemLevel8())then
                                if(Trig_Equip_Restrictions_NeedHolyOrDark())then
                                    if(Trig_Equip_Restrictions_HasDarkKnight())then
                                        set udg_TempString="Holy Swordsman or Dark Knight"
                                    else
                                        set udg_TempString="Holy Swordsman"
                                    endif
                                endif
                            else
                                if(Trig_Equip_Restrictions_NeedMediator())then
                                    set udg_TempString="Mediator"
                                endif
                            endif
                        endif
                    endif
                endif
            endif
            if(Trig_Equip_Restrictions_MasterMissing())then
                set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                call DisplayTextToForce(udg_TempForce,(("In order to equip "+(GetItemName(GetManipulatedItem())+((" "+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+" you must have a Legendary Master ")))+udg_TempString))
                call DestroyForce(udg_TempForce)
                call UnitRemoveItemSwapped(GetManipulatedItem(),GetManipulatingUnit())
                return
            endif
        else
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
            // (GetItemLifeBJ(the item being used or moved)) with its decimal part removed.
            call DisplayTextToForce(udg_TempForce,(("In order to equip "+(GetItemName(GetManipulatedItem())+((" "+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+" your Spirit of Gaya must be at least Level ")))+I2S(R2I(GetItemLifeBJ(GetManipulatedItem())))))
            call DestroyForce(udg_TempForce)
            call UnitRemoveItemSwapped(GetManipulatedItem(),GetManipulatingUnit())
            return
        endif
    endif
endfunction

// World Editor calls InitTrig_Equip automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Equip (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Equip takes nothing returns nothing
endfunction

function Register_Equip_Restrictions takes nothing returns nothing
    set gg_trg_Equip_Restrictions=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Equip_Restrictions,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Equip_Restrictions,Condition(function Trig_Equip_Restrictions_Conditions))
    call TriggerAddAction(gg_trg_Equip_Restrictions,function Trig_Equip_Restrictions_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Equip takes nothing returns nothing
    call Register_Equip_Restrictions()
endfunction

endlibrary

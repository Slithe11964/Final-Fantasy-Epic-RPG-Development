library TForge requires TCam, TCine, TPlayerHero, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Forge_Bali_Init=null
    trigger gg_trg_Forge_Bali_ItemGiven=null
    trigger gg_trg_Forge_Bali_ItemTaken=null
    trigger gg_trg_Forge_Bali_Refresh=null
    trigger gg_trg_Forge_Bali_ClearText=null
    trigger gg_trg_Forge_Bali_Craft=null
    trigger gg_trg_Forge_Bali_PsypherTalk=null
    // Variables only this module uses.
    integer array udg_ForgeRecipeResult
    integer array udg_ForgeRecipeBase
    integer array udg_ForgeRecipeMaterial
    integer array udg_CelestialWeapon
    integer udg_ForgeRecipeCount=0
endglobals

function Trig_Forge_Bali_Init_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_SpecialEffect[32]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hmbr_0140,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Arcanium_Start)
    set l_tempPoint=GetUnitLoc(gg_unit_Hmbr_0140)
    set udg_ForgeDropPoint=OffsetLocation(l_tempPoint,-10.,-75.)
    call RemoveLocation(l_tempPoint)
    set udg_ForgeRecipeCount=33
    set udg_ForgeRecipeBase[1]='I0L7' // 'I0L7': item "Shimmering Sword"
    set udg_ForgeRecipeMaterial[1]='I0FR' // 'I0FR': item "Ice Gem"
    set udg_ForgeRecipeResult[1]='I0F2' // 'I0F2': item "Icebrand"
    set udg_ForgeRecipeBase[2]='I0L6' // 'I0L6': item "Shimmering Spear"
    set udg_ForgeRecipeMaterial[2]='I0FT' // 'I0FT': item "Water Gem"
    set udg_ForgeRecipeResult[2]='I033' // 'I033': item "Trident"
    set udg_ForgeRecipeBase[3]='I0L6' // 'I0L6': item "Shimmering Spear"
    set udg_ForgeRecipeMaterial[3]='I0FQ' // 'I0FQ': item "Fire Gem"
    set udg_ForgeRecipeResult[3]='I0F6' // 'I0F6': item "Wildfire Spear"
    set udg_ForgeRecipeBase[4]='I0L6' // 'I0L6': item "Shimmering Spear"
    set udg_ForgeRecipeMaterial[4]='I0G2' // 'I0G2': item "Holy Gem"
    set udg_ForgeRecipeResult[4]='I05S' // 'I05S': item "Holy Lance"
    set udg_ForgeRecipeBase[5]='I0L8' // 'I0L8': item "Shimmering Axe"
    set udg_ForgeRecipeMaterial[5]='I0FS' // 'I0FS': item "Lightning Gem"
    set udg_ForgeRecipeResult[5]='I0F3' // 'I0F3': item "Mjolnir"
    set udg_ForgeRecipeBase[6]='I0L8' // 'I0L8': item "Shimmering Axe"
    set udg_ForgeRecipeMaterial[6]='I0FU' // 'I0FU': item "Earth Gem"
    set udg_ForgeRecipeResult[6]='I00O' // 'I00O': item "Fel Axe"
    set udg_ForgeRecipeBase[7]='I0L9' // 'I0L9': item "Shimmering Katana"
    set udg_ForgeRecipeMaterial[7]='I0FV' // 'I0FV': item "Wind Gem"
    set udg_ForgeRecipeResult[7]='I0F8' // 'I0F8': item "Ame-no-Murakumo"
    set udg_ForgeRecipeBase[8]='I0L9' // 'I0L9': item "Shimmering Katana"
    set udg_ForgeRecipeMaterial[8]='I0G8' // 'I0G8': item "Dark Gem"
    set udg_ForgeRecipeResult[8]='I0LQ' // 'I0LQ': item "Chunchunmaru"
    set udg_ForgeRecipeBase[9]='I0L8' // 'I0L8': item "Shimmering Axe"
    set udg_ForgeRecipeMaterial[9]='I0G7' // 'I0G7': item "Omni Gem"
    set udg_ForgeRecipeResult[9]='I04H' // 'I04H': item "Ancient Axe"
    set udg_ForgeRecipeBase[$A]='I0LN' // $A = 10; 'I0LN': item "Shimmering Shield"
    set udg_ForgeRecipeMaterial[$A]='I0FQ' // $A = 10; 'I0FQ': item "Fire Gem"
    set udg_ForgeRecipeResult[$A]='I0FA' // $A = 10; 'I0FA': item "Flame Shield"
    set udg_ForgeRecipeBase[$B]='I0LN' // $B = 11; 'I0LN': item "Shimmering Shield"
    set udg_ForgeRecipeMaterial[$B]='I0FR' // $B = 11; 'I0FR': item "Ice Gem"
    set udg_ForgeRecipeResult[$B]='I03A' // $B = 11; 'I03A': item "Frost Shield"
    set udg_ForgeRecipeBase[$C]='I0LO' // $C = 12; 'I0LO': item "Shimmering Helmet"
    set udg_ForgeRecipeMaterial[$C]='I0FS' // $C = 12; 'I0FS': item "Lightning Gem"
    set udg_ForgeRecipeResult[$C]='I01J' // $C = 12; 'I01J': item "Diamond Helmet"
    set udg_ForgeRecipeBase[$D]='I0LO' // $D = 13; 'I0LO': item "Shimmering Helmet"
    set udg_ForgeRecipeMaterial[$D]='I0FT' // $D = 13; 'I0FT': item "Water Gem"
    set udg_ForgeRecipeResult[$D]='I0FB' // $D = 13; 'I0FB': item "Serpent Helmet"
    set udg_ForgeRecipeBase[$E]='I0LM' // $E = 14; 'I0LM': item "Shimmering Cloth"
    set udg_ForgeRecipeMaterial[$E]='I0FU' // $E = 14; 'I0FU': item "Earth Gem"
    set udg_ForgeRecipeResult[$E]='I05G' // $E = 14; 'I05G': item "Gaia Gear"
    set udg_ForgeRecipeBase[$F]='I0LM' // $F = 15; 'I0LM': item "Shimmering Cloth"
    set udg_ForgeRecipeMaterial[$F]='I0G7' // $F = 15; 'I0G7': item "Omni Gem"
    set udg_ForgeRecipeResult[$F]='I0K9' // $F = 15; 'I0K9': item "Vishnu Vest"
    set udg_ForgeRecipeBase[16]='I01S' // 'I01S': item "Shimmering Mail"
    set udg_ForgeRecipeMaterial[16]='I0FV' // 'I0FV': item "Wind Gem"
    set udg_ForgeRecipeResult[16]='I0F9' // 'I0F9': item "Windbreaker"
    set udg_ForgeRecipeBase[17]='I01S' // 'I01S': item "Shimmering Mail"
    set udg_ForgeRecipeMaterial[17]='I084' // 'I084': item "Adamantite"
    set udg_ForgeRecipeResult[17]='I0A6' // 'I0A6': item "Adamant Armor"
    set udg_ForgeRecipeBase[18]='I0L4' // 'I0L4': item "Glimmering Hat"
    set udg_ForgeRecipeMaterial[18]='I0FR' // 'I0FR': item "Ice Gem"
    set udg_ForgeRecipeResult[18]='I0L1' // 'I0L1': item "Ice Hat"
    set udg_ForgeRecipeBase[19]='I0L4' // 'I0L4': item "Glimmering Hat"
    set udg_ForgeRecipeMaterial[19]='I0FU' // 'I0FU': item "Earth Gem"
    set udg_ForgeRecipeResult[19]='I0L3' // 'I0L3': item "Earth Hat"
    set udg_ForgeRecipeBase[20]='I0L4' // 'I0L4': item "Glimmering Hat"
    set udg_ForgeRecipeMaterial[20]='I0FV' // 'I0FV': item "Wind Gem"
    set udg_ForgeRecipeResult[20]='I0L2' // 'I0L2': item "Green Hat"
    set udg_ForgeRecipeBase[21]='I0KQ' // 'I0KQ': item "Glimmering Robe"
    set udg_ForgeRecipeMaterial[21]='I0FQ' // 'I0FQ': item "Fire Gem"
    set udg_ForgeRecipeResult[21]='I0KR' // 'I0KR': item "Red Robe"
    set udg_ForgeRecipeBase[22]='I0KQ' // 'I0KQ': item "Glimmering Robe"
    set udg_ForgeRecipeMaterial[22]='I0FS' // 'I0FS': item "Lightning Gem"
    set udg_ForgeRecipeResult[22]='I0KS' // 'I0KS': item "Light Robe"
    set udg_ForgeRecipeBase[23]='I0KQ' // 'I0KQ': item "Glimmering Robe"
    set udg_ForgeRecipeMaterial[23]='I0FT' // 'I0FT': item "Water Gem"
    set udg_ForgeRecipeResult[23]='I0KT' // 'I0KT': item "Azure Robe"
    set udg_ForgeRecipeBase[24]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ForgeRecipeMaterial[24]='I0FQ' // 'I0FQ': item "Fire Gem"
    set udg_ForgeRecipeResult[24]='I0FW' // 'I0FW': item "Orb of Fire"
    set udg_ForgeRecipeBase[25]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ForgeRecipeMaterial[25]='I0FR' // 'I0FR': item "Ice Gem"
    set udg_ForgeRecipeResult[25]='I0FX' // 'I0FX': item "Orb of Frost"
    set udg_ForgeRecipeBase[26]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ForgeRecipeMaterial[26]='I0FS' // 'I0FS': item "Lightning Gem"
    set udg_ForgeRecipeResult[26]='I0FY' // 'I0FY': item "Orb of Lightning"
    set udg_ForgeRecipeBase[27]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ForgeRecipeMaterial[27]='I0FT' // 'I0FT': item "Water Gem"
    set udg_ForgeRecipeResult[27]='I0FZ' // 'I0FZ': item "Orb of Water"
    set udg_ForgeRecipeBase[28]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ForgeRecipeMaterial[28]='I0FU' // 'I0FU': item "Earth Gem"
    set udg_ForgeRecipeResult[28]='I0G0' // 'I0G0': item "Orb of Earth"
    set udg_ForgeRecipeBase[29]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ForgeRecipeMaterial[29]='I0FV' // 'I0FV': item "Wind Gem"
    set udg_ForgeRecipeResult[29]='I0G1' // 'I0G1': item "Orb of Wind"
    set udg_ForgeRecipeBase[30]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ForgeRecipeMaterial[30]='I0G7' // 'I0G7': item "Omni Gem"
    set udg_ForgeRecipeResult[30]='I0C8' // 'I0C8': item "Orb of Cetra"
    set udg_ForgeRecipeBase[31]='I0L7' // 'I0L7': item "Shimmering Sword"
    set udg_ForgeRecipeMaterial[31]='I0G2' // 'I0G2': item "Holy Gem"
    set udg_ForgeRecipeResult[31]='I011' // 'I011': item "Excalibur"
    set udg_ForgeRecipeBase[32]='I0KQ' // 'I0KQ': item "Glimmering Robe"
    set udg_ForgeRecipeMaterial[32]='I0G2' // 'I0G2': item "Holy Gem"
    set udg_ForgeRecipeResult[32]='I0D2' // 'I0D2': item "White Robe"
    set udg_ForgeRecipeBase[33]='I0LN' // 'I0LN': item "Shimmering Shield"
    set udg_ForgeRecipeMaterial[33]='I0G8' // 'I0G8': item "Dark Gem"
    set udg_ForgeRecipeResult[33]='I0FK' // 'I0FK': item "Invert Shield"
    set udg_CelestialWeapon[0]='I0LC' // 'I0LC': item "Ehrgeiz"
    set udg_CelestialWeapon[1]='I0LJ' // 'I0LJ': item "Chainsaw"
    set udg_CelestialWeapon[2]='I0LE' // 'I0LE': item "Durandal"
    set udg_CelestialWeapon[3]='I0LA' // 'I0LA': item "Sagittarius"
    set udg_CelestialWeapon[4]='I0LG' // 'I0LG': item "Zwill Crossblade"
    set udg_CelestialWeapon[5]='I0LB' // 'I0LB': item "Longinus"
    set udg_CelestialWeapon[6]='I0LD' // 'I0LD': item "Scorpio"
    set udg_CelestialWeapon[7]='I0LI' // 'I0LI': item "Zanmatou"
    set udg_CelestialWeapon[8]='I0LF' // 'I0LF': item "Ragnarok"
    set udg_CelestialWeapon[$B]='I0LH' // $B = 11; 'I0LH': item "Exeter"
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Forge_Bali_ItemGiven_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_Hmbr_0140)
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_IsForgeBase takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())==udg_ForgeRecipeBase[GetForLoopIndexA()])
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_HasGear takes nothing returns boolean
    return(udg_ForgeGearSlot!=null)
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_GearMatched takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_PhysicalWeaponLevel takes nothing returns boolean
    return(GetItemLevel(GetManipulatedItem())<=8)or(GetItemLevel(GetManipulatedItem())==$B) // $B = 11
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_IsLevel99Weapon takes nothing returns boolean
    return(GetItemLifeBJ(GetManipulatedItem())==99.)and(GetItemType(GetManipulatedItem())==ITEM_TYPE_PERMANENT)and(Trig_Forge_Bali_ItemGiven_Cond_PhysicalWeaponLevel())
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_MaterialIsPsypher takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeMaterialSlot)=='I0A8') // 'I0A8': item "Celestial Psypher"
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_IsCampaignItem takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_CAMPAIGN)
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_IsForgeMaterial takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())==udg_ForgeRecipeMaterial[GetForLoopIndexA()])
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_IsPsypher takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0A8') // 'I0A8': item "Celestial Psypher"
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_HasMaterial takes nothing returns boolean
    return(udg_ForgeMaterialSlot!=null)
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_PsypherWithGear takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeMaterialSlot)=='I0A8')and(udg_ForgeGearSlot!=null) // 'I0A8': item "Celestial Psypher"
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_MaterialMatched takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Forge_Bali_ItemGiven_Cond_IsChargedItem takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_CHARGED)
endfunction

function Trig_Forge_Bali_ItemGiven_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Forge_Bali_ItemTaken)
    if(Trig_Forge_Bali_ItemGiven_Cond_IsChargedItem())then
        if(Trig_Forge_Bali_ItemGiven_Cond_IsPsypher())then
            set udg_TempBoolean=true
        else
            set udg_TempBoolean=false
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=udg_ForgeRecipeCount
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                if(Trig_Forge_Bali_ItemGiven_Cond_IsForgeMaterial())then
                    set udg_TempBoolean=true
                endif
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
        endif
        if(Trig_Forge_Bali_ItemGiven_Cond_MaterialMatched())then
            if(Trig_Forge_Bali_ItemGiven_Cond_HasMaterial())then
                call UnitRemoveItemSwapped(udg_ForgeMaterialSlot,gg_unit_Hmbr_0140)
                call SetItemPositionLoc(udg_ForgeMaterialSlot,udg_ForgeDropPoint)
            endif
            set udg_ForgeMaterialSlot=GetManipulatedItem()
            if(Trig_Forge_Bali_ItemGiven_Cond_PsypherWithGear())then
                call UnitRemoveItemSwapped(udg_ForgeGearSlot,gg_unit_Hmbr_0140)
                call SetItemPositionLoc(udg_ForgeGearSlot,udg_ForgeDropPoint)
                set udg_ForgeGearSlot=null
            endif
            call ConditionalTriggerExecute(gg_trg_Forge_Bali_Refresh)
        else
            call UnitRemoveItemSwapped(GetManipulatedItem(),gg_unit_Hmbr_0140)
            call SetItemPositionLoc(GetManipulatedItem(),udg_ForgeDropPoint)
            call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: Unfortunately I can't use this material with my forge.",12.)
            call StartTimerBJ(udg_ForgeTextTimer,false,5.)
        endif
    else
        if(Trig_Forge_Bali_ItemGiven_Cond_IsCampaignItem())then
            call UnitRemoveItemSwapped(GetManipulatedItem(),gg_unit_Hmbr_0140)
            call SetItemPositionLoc(GetManipulatedItem(),udg_ForgeDropPoint)
            call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: Unfortunately I can't use this item with my forge.",12.)
            call StartTimerBJ(udg_ForgeTextTimer,false,5.)
        else
            if(Trig_Forge_Bali_ItemGiven_Cond_MaterialIsPsypher())then
                if(Trig_Forge_Bali_ItemGiven_Cond_IsLevel99Weapon())then
                    set udg_ForgeGearSlot=GetManipulatedItem()
                    call ConditionalTriggerExecute(gg_trg_Forge_Bali_Refresh)
                else
                    call UnitRemoveItemSwapped(GetManipulatedItem(),gg_unit_Hmbr_0140)
                    call SetItemPositionLoc(GetManipulatedItem(),udg_ForgeDropPoint)
                    call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: I can only forge a Celestial Psypher into a Level 99 Physical Weapon.",12.)
                    call StartTimerBJ(udg_ForgeTextTimer,false,5.)
                endif
            else
                set udg_TempBoolean=false
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=udg_ForgeRecipeCount
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    if(Trig_Forge_Bali_ItemGiven_Cond_IsForgeBase())then
                        set udg_TempBoolean=true
                    endif
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                if(Trig_Forge_Bali_ItemGiven_Cond_GearMatched())then
                    if(Trig_Forge_Bali_ItemGiven_Cond_HasGear())then
                        call UnitRemoveItemSwapped(udg_ForgeGearSlot,gg_unit_Hmbr_0140)
                        call SetItemPositionLoc(udg_ForgeGearSlot,udg_ForgeDropPoint)
                    endif
                    set udg_ForgeGearSlot=GetManipulatedItem()
                    call ConditionalTriggerExecute(gg_trg_Forge_Bali_Refresh)
                else
                    call UnitRemoveItemSwapped(GetManipulatedItem(),gg_unit_Hmbr_0140)
                    call SetItemPositionLoc(GetManipulatedItem(),udg_ForgeDropPoint)
                    call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: I can only forge materials into Loki's reforged gear.",12.)
                    call StartTimerBJ(udg_ForgeTextTimer,false,5.)
                endif
            endif
        endif
    endif
    call EnableTrigger(gg_trg_Forge_Bali_ItemTaken)
endfunction

function Trig_Forge_Bali_ItemTaken_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_Hmbr_0140)
endfunction

function Trig_Forge_Bali_ItemTaken_Cond_DroppedGear takes nothing returns boolean
    return(GetManipulatedItem()==udg_ForgeGearSlot)
endfunction

function Trig_Forge_Bali_ItemTaken_Cond_DroppedMaterial takes nothing returns boolean
    return(GetManipulatedItem()==udg_ForgeMaterialSlot)
endfunction

function Trig_Forge_Bali_ItemTaken_Actions takes nothing returns nothing
    if(Trig_Forge_Bali_ItemTaken_Cond_DroppedGear())then
        set udg_ForgeGearSlot=null
    endif
    if(Trig_Forge_Bali_ItemTaken_Cond_DroppedMaterial())then
        set udg_ForgeMaterialSlot=null
    endif
    call ConditionalTriggerExecute(gg_trg_Forge_Bali_Refresh)
endfunction

function Trig_Forge_Bali_Refresh_Cond_GearIsBase takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeGearSlot)==udg_ForgeRecipeBase[GetForLoopIndexA()])
endfunction

function Trig_Forge_Bali_Refresh_Cond_RecipeMatches takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeGearSlot)==udg_ForgeRecipeBase[GetForLoopIndexA()])and(GetItemTypeId(udg_ForgeMaterialSlot)==udg_ForgeRecipeMaterial[GetForLoopIndexA()])
endfunction

function Trig_Forge_Bali_Refresh_Cond_MaterialIsPsypher_Pair takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeMaterialSlot)=='I0A8') // 'I0A8': item "Celestial Psypher"
endfunction

function Trig_Forge_Bali_Refresh_Cond_SameOwnerCheck takes nothing returns boolean
    return(GetItemUserData(udg_ForgeGearSlot)==0)or(GetItemUserData(udg_ForgeMaterialSlot)==0)or(GetItemUserData(udg_ForgeGearSlot)==GetItemUserData(udg_ForgeMaterialSlot))
endfunction

function Trig_Forge_Bali_Refresh_Cond_SameOwner takes nothing returns boolean
    return(Trig_Forge_Bali_Refresh_Cond_SameOwnerCheck())
endfunction

function Trig_Forge_Bali_Refresh_Cond_MaterialInRecipe takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeMaterialSlot)==udg_ForgeRecipeMaterial[GetForLoopIndexA()])
endfunction

function Trig_Forge_Bali_Refresh_Cond_MaterialIsPsypher_Alone takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeMaterialSlot)=='I0A8') // 'I0A8': item "Celestial Psypher"
endfunction

function Trig_Forge_Bali_Refresh_Cond_OnlyMaterial takes nothing returns boolean
    return(udg_ForgeGearSlot==null)and(udg_ForgeMaterialSlot!=null)
endfunction

function Trig_Forge_Bali_Refresh_Cond_OnlyGear takes nothing returns boolean
    return(udg_ForgeGearSlot!=null)and(udg_ForgeMaterialSlot==null)
endfunction

function Trig_Forge_Bali_Refresh_Cond_SlotsEmpty takes nothing returns boolean
    return(udg_ForgeGearSlot==null)and(udg_ForgeMaterialSlot==null)
endfunction

function Trig_Forge_Bali_Refresh_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_ForgeRecipeCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call RemoveItemFromStockBJ(udg_ForgeRecipeBase[GetForLoopIndexA()],gg_unit_Hmbr_0140)
        call RemoveItemFromStockBJ(udg_ForgeRecipeMaterial[GetForLoopIndexA()],gg_unit_Hmbr_0140)
        call RemoveItemFromStockBJ(udg_ForgeRecipeResult[GetForLoopIndexA()],gg_unit_Hmbr_0140)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveItemFromStockBJ('I0BB',gg_unit_Hmbr_0140) // 'I0BB': item "Result Unknown"
    call UnitRemoveAbilityBJ('A1AN',gg_unit_Hmbr_0140) // 'A1AN': ability "Forge"
    call PauseTimerBJ(true,udg_ForgeTextTimer)
    if(Trig_Forge_Bali_Refresh_Cond_SlotsEmpty())then
        call SetTextTagTextBJ(udg_ForgeText," ",12.)
    else
        if(Trig_Forge_Bali_Refresh_Cond_OnlyGear())then
            call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: To forge this piece of gear further I will need any of these materials.",12.)
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=udg_ForgeRecipeCount
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                if(Trig_Forge_Bali_Refresh_Cond_GearIsBase())then
                    call AddItemToStockBJ(udg_ForgeRecipeMaterial[GetForLoopIndexA()],gg_unit_Hmbr_0140,0,0)
                endif
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
        else
            if(Trig_Forge_Bali_Refresh_Cond_OnlyMaterial())then
                if(Trig_Forge_Bali_Refresh_Cond_MaterialIsPsypher_Alone())then
                    call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: I will need a Level 99 Physical Weapon to make a Celestial Weapon out of...",12.)
                else
                    call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: This material I can forge into any of these pieces of gear.",12.)
                    set bj_forLoopAIndex=1
                    set bj_forLoopAIndexEnd=udg_ForgeRecipeCount
                    loop
                        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                        if(Trig_Forge_Bali_Refresh_Cond_MaterialInRecipe())then
                            call AddItemToStockBJ(udg_ForgeRecipeBase[GetForLoopIndexA()],gg_unit_Hmbr_0140,0,0)
                        endif
                        set bj_forLoopAIndex=bj_forLoopAIndex+1
                    endloop
                endif
            else
                if(Trig_Forge_Bali_Refresh_Cond_SameOwner())then
                    call UnitAddAbilityBJ('A1AN',gg_unit_Hmbr_0140) // 'A1AN': ability "Forge"
                    if(Trig_Forge_Bali_Refresh_Cond_MaterialIsPsypher_Pair())then
                        call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: I will make a Celestial Weapon. Is that okay?",12.)
                        call AddItemToStockBJ('I0BB',gg_unit_Hmbr_0140,0,0) // 'I0BB': item "Result Unknown"
                    else
                        call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: This will be the result of this forging. Sounds good?",12.)
                        set bj_forLoopAIndex=1
                        set bj_forLoopAIndexEnd=udg_ForgeRecipeCount
                        loop
                            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                            if(Trig_Forge_Bali_Refresh_Cond_RecipeMatches())then
                                call AddItemToStockBJ(udg_ForgeRecipeResult[GetForLoopIndexA()],gg_unit_Hmbr_0140,0,0)
                            endif
                            set bj_forLoopAIndex=bj_forLoopAIndex+1
                        endloop
                    endif
                else
                    call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: Unfortunately these items don't belong to the same person. I can't combine them.",12.)
                    call StartTimerBJ(udg_ForgeTextTimer,false,5.)
                endif
            endif
        endif
    endif
endfunction

function Trig_Forge_Bali_ClearText_Actions takes nothing returns nothing
    call SetTextTagTextBJ(udg_ForgeText," ",12.)
endfunction

function Trig_Forge_Bali_Craft_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1AN') // 'A1AN': ability "Forge"
endfunction

function Trig_Forge_Bali_Craft_Cond_GearUnbound_Celestial takes nothing returns boolean
    return(GetItemUserData(udg_ForgeGearSlot)==0)
endfunction

function Trig_Forge_Bali_Craft_Cond_MaterialHasCharges_Celestial takes nothing returns boolean
    return(GetItemCharges(udg_ForgeMaterialSlot)>=2)
endfunction

function Trig_Forge_Bali_Craft_Cond_PhysicalWeaponLevel takes nothing returns boolean
    return(udg_TempInteger<=8)or(udg_TempInteger==$B) // $B = 11
endfunction

function Trig_Forge_Bali_Craft_Cond_IsLevel99Weapon takes nothing returns boolean
    return(GetItemLifeBJ(udg_ForgeGearSlot)==99.)and(GetItemType(udg_ForgeGearSlot)==ITEM_TYPE_PERMANENT)and(Trig_Forge_Bali_Craft_Cond_PhysicalWeaponLevel())
endfunction

function Trig_Forge_Bali_Craft_Cond_RecipeMatches takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeGearSlot)==udg_ForgeRecipeBase[GetForLoopIndexA()])and(GetItemTypeId(udg_ForgeMaterialSlot)==udg_ForgeRecipeMaterial[GetForLoopIndexA()])
endfunction

function Trig_Forge_Bali_Craft_Cond_GearUnbound_Normal takes nothing returns boolean
    return(GetItemUserData(udg_ForgeGearSlot)==0)
endfunction

function Trig_Forge_Bali_Craft_Cond_MaterialHasCharges_Normal takes nothing returns boolean
    return(GetItemCharges(udg_ForgeMaterialSlot)>=2)
endfunction

function Trig_Forge_Bali_Craft_Cond_RecipeFound takes nothing returns boolean
    return(udg_TempInteger>0)
endfunction

function Trig_Forge_Bali_Craft_Cond_MaterialIsPsypher takes nothing returns boolean
    return(GetItemTypeId(udg_ForgeMaterialSlot)=='I0A8') // 'I0A8': item "Celestial Psypher"
endfunction

function Trig_Forge_Bali_Craft_Cond_BothSlotsFilled takes nothing returns boolean
    return(udg_ForgeGearSlot!=null)and(udg_ForgeMaterialSlot!=null)
endfunction

function Trig_Forge_Bali_Craft_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Forge_Bali_ItemTaken)
    if(Trig_Forge_Bali_Craft_Cond_BothSlotsFilled())then
        if(Trig_Forge_Bali_Craft_Cond_MaterialIsPsypher())then
            set udg_TempInteger=GetItemLevel(udg_ForgeGearSlot)
            if(Trig_Forge_Bali_Craft_Cond_IsLevel99Weapon())then
                call RemoveItemFromStockBJ('I0BB',gg_unit_Hmbr_0140) // 'I0BB': item "Result Unknown"
                call CreateItemLoc(udg_CelestialWeapon[udg_TempInteger],udg_ForgeDropPoint)
                if(Trig_Forge_Bali_Craft_Cond_GearUnbound_Celestial())then
                    call SetItemUserData(GetLastCreatedItem(),GetItemUserData(udg_ForgeMaterialSlot))
                else
                    call SetItemUserData(GetLastCreatedItem(),GetItemUserData(udg_ForgeGearSlot))
                endif
                call RemoveItem(udg_ForgeGearSlot)
                set udg_ForgeGearSlot=null
                if(Trig_Forge_Bali_Craft_Cond_MaterialHasCharges_Celestial())then
                    call SetItemCharges(udg_ForgeMaterialSlot,(GetItemCharges(udg_ForgeMaterialSlot)-1))
                    call UnitRemoveItemSwapped(udg_ForgeMaterialSlot,gg_unit_Hmbr_0140)
                    call SetItemPositionLoc(udg_ForgeMaterialSlot,udg_ForgeDropPoint)
                    set udg_ForgeMaterialSlot=null
                else
                    call RemoveItem(udg_ForgeMaterialSlot)
                    set udg_ForgeMaterialSlot=null
                endif
                call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: There you go. Use it wisely.",12.)
            else
                call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: This item is not suited for making a Celestial...",12.)
            endif
        else
            set udg_TempInteger=0
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=udg_ForgeRecipeCount
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                if(Trig_Forge_Bali_Craft_Cond_RecipeMatches())then
                    set udg_TempInteger=GetForLoopIndexA()
                endif
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            if(Trig_Forge_Bali_Craft_Cond_RecipeFound())then
                call RemoveItemFromStockBJ(udg_ForgeRecipeResult[udg_TempInteger],gg_unit_Hmbr_0140)
                call CreateItemLoc(udg_ForgeRecipeResult[udg_TempInteger],udg_ForgeDropPoint)
                if(Trig_Forge_Bali_Craft_Cond_GearUnbound_Normal())then
                    call SetItemUserData(GetLastCreatedItem(),GetItemUserData(udg_ForgeMaterialSlot))
                else
                    call SetItemUserData(GetLastCreatedItem(),GetItemUserData(udg_ForgeGearSlot))
                endif
                call RemoveItem(udg_ForgeGearSlot)
                set udg_ForgeGearSlot=null
                if(Trig_Forge_Bali_Craft_Cond_MaterialHasCharges_Normal())then
                    call SetItemCharges(udg_ForgeMaterialSlot,(GetItemCharges(udg_ForgeMaterialSlot)-1))
                    call UnitRemoveItemSwapped(udg_ForgeMaterialSlot,gg_unit_Hmbr_0140)
                    call SetItemPositionLoc(udg_ForgeMaterialSlot,udg_ForgeDropPoint)
                    set udg_ForgeMaterialSlot=null
                else
                    call RemoveItem(udg_ForgeMaterialSlot)
                    set udg_ForgeMaterialSlot=null
                endif
                call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: There, all done!",12.)
            else
                call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: Something is wrong... I can't forge these items together.",12.)
            endif
        endif
    else
        call SetTextTagTextBJ(udg_ForgeText,"|cffffcc00Bali|r: Something is wrong... I can't forge these items together.",12.)
    endif
    call StartTimerBJ(udg_ForgeTextTimer,false,5.)
    call UnitRemoveAbilityBJ('A1AN',gg_unit_Hmbr_0140) // 'A1AN': ability "Forge"
    call EnableTrigger(gg_trg_Forge_Bali_ItemTaken)
endfunction

function Trig_Forge_Bali_PsypherTalk_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0A8'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_Hmbr_0140)==false)and(udg_InCinematicMode==false))!=null // 'I0A8': item "Celestial Psypher"
endfunction

function Trig_Forge_Bali_PsypherTalk_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Forge_Bali_PsypherTalk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Forge_Bali_PsypherTalk_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Hmbr_0140,0)
        call Text_Say(gg_unit_Hmbr_0140,"Loki... take a look at what this adventurer's holding.",false)
        call Text_Say(gg_unit_H00P_0260,"That... can't really be a Celestial Psypher, can it?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Indeed it is, and it was not easy to acquire. Can you make something from this?",false)
        call Text_Say(gg_unit_Hmbr_0140,"I've managed to craft gear from Arcanium, I'll certainly manage a Psypher. But are you even aware of what it is you're holding?",false)
        call Text_Say(gg_unit_Hmbr_0140,"Celestial Psyphers can be used to craft the Celestial Weapons. These are weapons that far surpass the power of regular weapons, but require absolute mastery to wield.",false)
        call Text_Say(gg_unit_Hmbr_0140,"I can forge a Psypher into a weapon of yours to create one, but make sure you are |cffffcc00Legendary Master|r of the weapon's wielder, otherwise you won't be able to use it. In addition, to create a Celestial Weapon I will need no less than a |cffffcc00Level 99 Weapon|r of the type you want to create.",false)
        call Text_Say(gg_unit_Hmbr_0140,"Last thing I need to mention: there are no Celestial Rods, Staffs or Inner Mana Weapons. The Psypher does not call forth magic, it merely hones the weapon and its blade to its utmost limit.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Damn that's a lot. These weapons better be worth the effort.",false)
        call Text_Say(gg_unit_H00P_0260,"You can be sure of that.",false)
        call Cine_ExitAction()
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Forge automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Forge (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Forge takes nothing returns nothing
endfunction

function Register_Forge_Bali_Init takes nothing returns nothing
    set gg_trg_Forge_Bali_Init=CreateTrigger()
    call DisableTrigger(gg_trg_Forge_Bali_Init)
    call TriggerAddAction(gg_trg_Forge_Bali_Init,function Trig_Forge_Bali_Init_Actions)
endfunction

function Register_Forge_Bali_ItemGiven takes nothing returns nothing
    set gg_trg_Forge_Bali_ItemGiven=CreateTrigger()
    call DisableTrigger(gg_trg_Forge_Bali_ItemGiven)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Forge_Bali_ItemGiven,Player(9),EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Forge_Bali_ItemGiven,Condition(function Trig_Forge_Bali_ItemGiven_Conditions))
    call TriggerAddAction(gg_trg_Forge_Bali_ItemGiven,function Trig_Forge_Bali_ItemGiven_Actions)
endfunction

function Register_Forge_Bali_ItemTaken takes nothing returns nothing
    set gg_trg_Forge_Bali_ItemTaken=CreateTrigger()
    call DisableTrigger(gg_trg_Forge_Bali_ItemTaken)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Forge_Bali_ItemTaken,Player(9),EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Forge_Bali_ItemTaken,Condition(function Trig_Forge_Bali_ItemTaken_Conditions))
    call TriggerAddAction(gg_trg_Forge_Bali_ItemTaken,function Trig_Forge_Bali_ItemTaken_Actions)
endfunction

function Register_Forge_Bali_Refresh takes nothing returns nothing
    set gg_trg_Forge_Bali_Refresh=CreateTrigger()
    call DisableTrigger(gg_trg_Forge_Bali_Refresh)
    call TriggerAddAction(gg_trg_Forge_Bali_Refresh,function Trig_Forge_Bali_Refresh_Actions)
endfunction

function Register_Forge_Bali_ClearText takes nothing returns nothing
    set gg_trg_Forge_Bali_ClearText=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Forge_Bali_ClearText,udg_ForgeTextTimer)
    call TriggerAddAction(gg_trg_Forge_Bali_ClearText,function Trig_Forge_Bali_ClearText_Actions)
endfunction

function Register_Forge_Bali_Craft takes nothing returns nothing
    set gg_trg_Forge_Bali_Craft=CreateTrigger()
    call DisableTrigger(gg_trg_Forge_Bali_Craft)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Forge_Bali_Craft,Player(9),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Forge_Bali_Craft,Condition(function Trig_Forge_Bali_Craft_Conditions))
    call TriggerAddAction(gg_trg_Forge_Bali_Craft,function Trig_Forge_Bali_Craft_Actions)
endfunction

function Register_Forge_Bali_PsypherTalk takes nothing returns nothing
    set gg_trg_Forge_Bali_PsypherTalk=CreateTrigger()
    call DisableTrigger(gg_trg_Forge_Bali_PsypherTalk)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Forge_Bali_PsypherTalk,450.,gg_unit_Hmbr_0140)
    call TriggerAddCondition(gg_trg_Forge_Bali_PsypherTalk,Condition(function Trig_Forge_Bali_PsypherTalk_Conditions))
    call TriggerAddAction(gg_trg_Forge_Bali_PsypherTalk,function Trig_Forge_Bali_PsypherTalk_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Forge takes nothing returns nothing
    call Register_Forge_Bali_Init() // starts off; run by Giott
    call Register_Forge_Bali_ItemGiven() // starts off; enabled by Quest_Arcanium
    call Register_Forge_Bali_ItemTaken() // starts off; enabled by Forge; disabled by Forge
    call Register_Forge_Bali_Refresh() // starts off; run by Forge
    call Register_Forge_Bali_ClearText()
    call Register_Forge_Bali_Craft() // starts off; enabled by Quest_Arcanium
    call Register_Forge_Bali_PsypherTalk() // starts off; enabled by Quest_Arcanium
endfunction

endlibrary

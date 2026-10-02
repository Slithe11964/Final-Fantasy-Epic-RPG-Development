library TPotion requires TText
function Trig_Potion_Use_IsPotionItem takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='phea')or(GetItemTypeId(GetManipulatedItem())=='pman')or(GetItemTypeId(GetManipulatedItem())=='pghe')or(GetItemTypeId(GetManipulatedItem())=='pgma')or(GetItemTypeId(GetManipulatedItem())=='I001')or(GetItemTypeId(GetManipulatedItem())=='sman')or(GetItemTypeId(GetManipulatedItem())=='I000')or(GetItemTypeId(GetManipulatedItem())=='I002')or(GetItemTypeId(GetManipulatedItem())=='I02V')or(GetItemTypeId(GetManipulatedItem())=='I02X')or(GetItemTypeId(GetManipulatedItem())=='I05I')or(GetItemTypeId(GetManipulatedItem())=='I05H')or(GetItemTypeId(GetManipulatedItem())=='pres') // 'phea': item "Potion"; 'pman': item "Ether"; 'pghe': item "Hi-Potion"; 'pgma': item "Hi-Ether"; 'I001': item "Mega Potion"; 'sman': item "Mega Ether"; 'I000': item "X-Potion"; 'I002': item "Turbo Ether"; 'I02V': item "Nectar"; 'I02X': item "Greater Nectar"; 'I05I': item "Spirit Potion"; 'I05H': item "Blood Ether"; 'pres': item "Elixir"
endfunction

function Trig_Potion_Use_Conditions takes nothing returns boolean
    return(Trig_Potion_Use_IsPotionItem())
endfunction

function Trig_Potion_Use_PharmaCleanse takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HL',GetTriggerUnit())>=1)and(GetItemTypeId(GetManipulatedItem())!='I05I')and(GetItemTypeId(GetManipulatedItem())!='I05H') // 'A0HL': ability "Pharmacology"; 'I05I': item "Spirit Potion"; 'I05H': item "Blood Ether"
endfunction

function Trig_Potion_Use_IsTier4Potion takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I000')or(GetItemTypeId(GetManipulatedItem())=='I002')or(GetItemTypeId(GetManipulatedItem())=='I02X') // 'I000': item "X-Potion"; 'I002': item "Turbo Ether"; 'I02X': item "Greater Nectar"
endfunction

function Trig_Potion_Use_Cond_Tier4Potion takes nothing returns boolean
    return(Trig_Potion_Use_IsTier4Potion())
endfunction

function Trig_Potion_Use_IsTier3Potion takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I001')or(GetItemTypeId(GetManipulatedItem())=='sman')or(GetItemTypeId(GetManipulatedItem())=='I02V') // 'I001': item "Mega Potion"; 'sman': item "Mega Ether"; 'I02V': item "Nectar"
endfunction

function Trig_Potion_Use_Cond_Tier3Potion takes nothing returns boolean
    return(Trig_Potion_Use_IsTier3Potion())
endfunction

function Trig_Potion_Use_IsTier2Potion takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='pghe')or(GetItemTypeId(GetManipulatedItem())=='pgma') // 'pghe': item "Hi-Potion"; 'pgma': item "Hi-Ether"
endfunction

function Trig_Potion_Use_Cond_Tier2Potion takes nothing returns boolean
    return(Trig_Potion_Use_IsTier2Potion())
endfunction

function Trig_Potion_Use_IsTier1Potion takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='phea')or(GetItemTypeId(GetManipulatedItem())=='pman') // 'phea': item "Potion"; 'pman': item "Ether"
endfunction

function Trig_Potion_Use_Cond_Tier1Potion takes nothing returns boolean
    return(Trig_Potion_Use_IsTier1Potion())
endfunction

function Trig_Potion_Use_HasPharmacology takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HL',GetTriggerUnit())>=1) // 'A0HL': ability "Pharmacology"
endfunction

function Trig_Potion_Use_IsManaPotion takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='pman')or(GetItemTypeId(GetManipulatedItem())=='pgma')or(GetItemTypeId(GetManipulatedItem())=='sman')or(GetItemTypeId(GetManipulatedItem())=='I002')or(GetItemTypeId(GetManipulatedItem())=='I02V')or(GetItemTypeId(GetManipulatedItem())=='I02X') // 'pman': item "Ether"; 'pgma': item "Hi-Ether"; 'sman': item "Mega Ether"; 'I002': item "Turbo Ether"; 'I02V': item "Nectar"; 'I02X': item "Greater Nectar"
endfunction

function Trig_Potion_Use_Cond_ManaPotion takes nothing returns boolean
    return(Trig_Potion_Use_IsManaPotion())
endfunction

function Trig_Potion_Use_IsLifePotion takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='phea')or(GetItemTypeId(GetManipulatedItem())=='pghe')or(GetItemTypeId(GetManipulatedItem())=='I001')or(GetItemTypeId(GetManipulatedItem())=='I000')or(GetItemTypeId(GetManipulatedItem())=='I02V')or(GetItemTypeId(GetManipulatedItem())=='I02X') // 'phea': item "Potion"; 'pghe': item "Hi-Potion"; 'I001': item "Mega Potion"; 'I000': item "X-Potion"; 'I02V': item "Nectar"; 'I02X': item "Greater Nectar"
endfunction

function Trig_Potion_Use_Cond_LifePotion takes nothing returns boolean
    return(Trig_Potion_Use_IsLifePotion())
endfunction

function Trig_Potion_Use_IsBloodEther takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I05H') // 'I05H': item "Blood Ether"
endfunction

function Trig_Potion_Use_IsSpiritPotion takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I05I') // 'I05I': item "Spirit Potion"
endfunction

function Trig_Potion_Use_IsElixir takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='pres') // 'pres': item "Elixir"
endfunction

function Trig_Potion_Use_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B03D',GetTriggerUnit()) // 'B03D': buff tooltip "Spawn Protection"
    if(Trig_Potion_Use_PharmaCleanse())then
        set udg_DispelTarget=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    endif
    if(Trig_Potion_Use_IsElixir())then
        set udg_DmgFlagPure=true
        set udg_DmgFlagUnavoidable=-1
        set udg_IsPureDamage=true
        set udg_DmgFlagManaDamage=true
        call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),6666666.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
        set udg_DmgFlagPure=true
        set udg_DmgFlagUnavoidable=-1
        set udg_IsPureDamage=true
        call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),6666666.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    else
        if(Trig_Potion_Use_IsSpiritPotion())then
            call Text_FloatingDamage(GetTriggerUnit(),false,0,600.,true,0)
            set udg_DmgFlagPure=true
            set udg_DmgFlagUnavoidable=-1
            set udg_IsPureDamage=true
            call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),3000.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
        else
            if(Trig_Potion_Use_IsBloodEther())then
                set udg_DmgFlagPure=true
                set udg_DmgFlagUnavoidable=-1
                set udg_IsPureDamage=true
                set udg_DmgFlagManaDamage=true
                call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),2000.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                set udg_DmgFlagPure=true
                set udg_DmgFlagUnavoidable=-1
                call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),1000.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            else
                set udg_TempInteger=0
                if(Trig_Potion_Use_Cond_Tier1Potion())then
                    set udg_TempInteger=400
                else
                    if(Trig_Potion_Use_Cond_Tier2Potion())then
                        set udg_TempInteger=$3E8 // $3E8 = 1000
                    else
                        if(Trig_Potion_Use_Cond_Tier3Potion())then
                            set udg_TempInteger=$9C4 // $9C4 = 2500
                        else
                            if(Trig_Potion_Use_Cond_Tier4Potion())then
                                set udg_TempInteger=6000
                            endif
                        endif
                    endif
                endif
                if(Trig_Potion_Use_HasPharmacology())then
                    // Multiply the potion amount by 1.5, then drop any fraction: 101 becomes 151.
                    set udg_TempInteger=((udg_TempInteger*3)/ 2)
                endif
                if(Trig_Potion_Use_Cond_ManaPotion())then
                    set udg_DmgFlagPure=true
                    set udg_DmgFlagUnavoidable=-1
                    set udg_IsPureDamage=true
                    set udg_DmgFlagManaDamage=true
                    // (udg_TempInteger) divided by (2); drop the remainder treated as a decimal-capable number.
                    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),I2R((udg_TempInteger/ 2)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                endif
                if(Trig_Potion_Use_Cond_LifePotion())then
                    set udg_DmgFlagPure=true
                    set udg_DmgFlagUnavoidable=-1
                    set udg_IsPureDamage=true
                    // Udg_TempInteger treated as a decimal-capable number.
                    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),I2R(udg_TempInteger),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                endif
            endif
        endif
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Potion takes nothing returns nothing
endfunction

function RegisterR11_Potion_Use takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Potion_Use=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Potion_Use,EVENT_PLAYER_UNIT_USE_ITEM)

call TriggerAddCondition(gg_trg_Potion_Use,Condition(function Trig_Potion_Use_Conditions))

call TriggerAddAction(gg_trg_Potion_Use,function Trig_Potion_Use_Actions)

endfunction




endlibrary

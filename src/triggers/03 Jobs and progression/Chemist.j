library TChemist requires TAbil, TFix, TForce, TMedicine, TProf, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chemist_TakeItem=null
    trigger gg_trg_Chemist_Pharmacology=null
    trigger gg_trg_Chemist_LearnAlchemy=null
    trigger gg_trg_Chemist_Brew=null
    trigger gg_trg_Chemist_NoxiousMixture=null
    trigger gg_trg_Chemist_Molotov=null
    // Variables only this module uses.
    item udg_ChemistItem=null
endglobals

function Trig_Chemist_TakeItem_Cond_LastCharge takes nothing returns boolean
    return(GetItemCharges(udg_ChemistItem)==1)
endfunction

function Trig_Chemist_TakeItem_Cond_HasSpareCharges takes nothing returns boolean
    return(GetItemCharges(udg_ChemistItem)>1)
endfunction

function Trig_Chemist_TakeItem_Cond_IsChemistItem takes nothing returns boolean
    return(SubStringBJ(GetItemName(udg_ChemistItem),1,$A)=="Chemist's ")and(GetItemCharges(udg_ChemistItem)>0) // $A = 10
endfunction

function Trig_Chemist_TakeItem_Actions takes nothing returns nothing
    set udg_TempItemId='tkno' // 'tkno': object name not found in map data
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>6
        set udg_ChemistItem=UnitItemInSlotBJ(udg_CurrentHero,udg_TempInteger)
        if(Trig_Chemist_TakeItem_Cond_IsChemistItem())then
            set udg_TempItemId=GetItemTypeId(udg_ChemistItem)
            if(Trig_Chemist_TakeItem_Cond_HasSpareCharges())then
                // (item charges of udg_ChemistItem) minus (1).
                call SetItemCharges(udg_ChemistItem,(GetItemCharges(udg_ChemistItem)-1))
            else
                if(Trig_Chemist_TakeItem_Cond_LastCharge())then
                    call Fix_ChemistItem_RemoveLater(udg_ChemistItem)
                endif
            endif
            return
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
endfunction

function Trig_Chemist_Pharmacology_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A19C') // 'A19C': ability "Pharmacology"
endfunction

function Trig_Chemist_Pharmacology_Cond_NoSpellTarget takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Chemist_Pharmacology_Cond_NoChemistItem takes nothing returns boolean
    return(udg_TempItemId=='tkno') // 'tkno': object name not found in map data
endfunction

function Trig_Chemist_Pharmacology_Cond_IsTierFourItem takes nothing returns boolean
    return(udg_TempItemId=='I02O')or(udg_TempItemId=='I02N')or(udg_TempItemId=='I0EU') // 'I02O': item "Chemist's X-Potion"; 'I02N': item "Chemist's Turbo Ether"; 'I0EU': item "Chemist's Greater Nectar"
endfunction

function Trig_Chemist_Pharmacology_Cond_TierFour takes nothing returns boolean
    return(Trig_Chemist_Pharmacology_Cond_IsTierFourItem())
endfunction

function Trig_Chemist_Pharmacology_Cond_IsTierThreeItem takes nothing returns boolean
    return(udg_TempItemId=='I02M')or(udg_TempItemId=='I02K')or(udg_TempItemId=='I0ET') // 'I02M': item "Chemist's Mega Potion"; 'I02K': item "Chemist's Mega Ether"; 'I0ET': item "Chemist's Nectar"
endfunction

function Trig_Chemist_Pharmacology_Cond_TierThree takes nothing returns boolean
    return(Trig_Chemist_Pharmacology_Cond_IsTierThreeItem())
endfunction

function Trig_Chemist_Pharmacology_Cond_IsTierTwoItem takes nothing returns boolean
    return(udg_TempItemId=='I02J')or(udg_TempItemId=='I02I') // 'I02J': item "Chemist's Hi-Potion"; 'I02I': item "Chemist's Hi-Ether"
endfunction

function Trig_Chemist_Pharmacology_Cond_TierTwo takes nothing returns boolean
    return(Trig_Chemist_Pharmacology_Cond_IsTierTwoItem())
endfunction

function Trig_Chemist_Pharmacology_Cond_IsTierOneItem takes nothing returns boolean
    return(udg_TempItemId=='I02L')or(udg_TempItemId=='I02E') // 'I02L': item "Chemist's Potion"; 'I02E': item "Chemist's Ether"
endfunction

function Trig_Chemist_Pharmacology_Cond_TierOne takes nothing returns boolean
    return(Trig_Chemist_Pharmacology_Cond_IsTierOneItem())
endfunction

function Trig_Chemist_Pharmacology_Cond_IsManaItem takes nothing returns boolean
    return(udg_TempItemId=='I02E')or(udg_TempItemId=='I02I')or(udg_TempItemId=='I02K')or(udg_TempItemId=='I02N')or(udg_TempItemId=='I0ET')or(udg_TempItemId=='I0EU') // 'I02E': item "Chemist's Ether"; 'I02I': item "Chemist's Hi-Ether"; 'I02K': item "Chemist's Mega Ether"; 'I02N': item "Chemist's Turbo Ether"; 'I0ET': item "Chemist's Nectar"; 'I0EU': item "Chemist's Greater Nectar"
endfunction

function Trig_Chemist_Pharmacology_Cond_RestoresMana takes nothing returns boolean
    return(Trig_Chemist_Pharmacology_Cond_IsManaItem())
endfunction

function Trig_Chemist_Pharmacology_Cond_IsHealItem takes nothing returns boolean
    return(udg_TempItemId=='I02L')or(udg_TempItemId=='I02J')or(udg_TempItemId=='I02M')or(udg_TempItemId=='I02O')or(udg_TempItemId=='I0ET')or(udg_TempItemId=='I0EU') // 'I02L': item "Chemist's Potion"; 'I02J': item "Chemist's Hi-Potion"; 'I02M': item "Chemist's Mega Potion"; 'I02O': item "Chemist's X-Potion"; 'I0ET': item "Chemist's Nectar"; 'I0EU': item "Chemist's Greater Nectar"
endfunction

function Trig_Chemist_Pharmacology_Cond_RestoresLife takes nothing returns boolean
    return(Trig_Chemist_Pharmacology_Cond_IsHealItem())
endfunction

function Trig_Chemist_Pharmacology_Cond_IsElixir takes nothing returns boolean
    return(udg_TempItemId=='I02D') // 'I02D': item "Chemist's Elixir"
endfunction

function Trig_Chemist_Pharmacology_Cond_HealsNegated takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',udg_TempUnit2)>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Chemist_Pharmacology_Cond_IsHeroDrink takes nothing returns boolean
    return(udg_TempItemId=='I02H') // 'I02H': item "Chemist's Hero Drink"
endfunction

function Trig_Chemist_Pharmacology_Actions takes nothing returns nothing
    if(Trig_Chemist_Pharmacology_Cond_NoSpellTarget())then
        set udg_TempUnit2=GetTriggerUnit()
    else
        set udg_TempUnit2=GetSpellTargetUnit()
    endif
    set udg_CurrentHero=GetTriggerUnit()
    set udg_TempItemId='tkno' // 'tkno': object name not found in map data
    call ConditionalTriggerExecute(gg_trg_Chemist_TakeItem)
    if(Trig_Chemist_Pharmacology_Cond_NoChemistItem())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000You have no Chemist's item to toss!|r")
        call DestroyForce(udg_TempForce)
        return
    endif
    set udg_SpeedrunFlag[5]=true
    set udg_DispelTarget=udg_TempUnit2
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    if(Trig_Chemist_Pharmacology_Cond_IsHeroDrink())then
        call Medicine_ApplyTimed(GetSpellTargetUnit(),true)
    else
        if(Trig_Chemist_Pharmacology_Cond_HealsNegated())then
            call AddSpecialEffectTargetUnitBJ("overhead",udg_TempUnit2,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        else
            if(Trig_Chemist_Pharmacology_Cond_IsElixir())then
                call AddSpecialEffectTargetUnitBJ("origin",udg_TempUnit2,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                set udg_DmgFlagPure=true
                set udg_DmgFlagUnavoidable=-1
                set udg_IgnoresReduction=true
                set udg_IsPureDamage=true
                set udg_DmgFlagManaDamage=true
                call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,6666666.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                set udg_DmgFlagPure=true
                set udg_DmgFlagUnavoidable=-1
                set udg_IgnoresReduction=true
                set udg_IsPureDamage=true
                call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,6666666.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            else
                set udg_TempInteger=0
                if(Trig_Chemist_Pharmacology_Cond_TierOne())then
                    set udg_TempInteger=400
                else
                    if(Trig_Chemist_Pharmacology_Cond_TierTwo())then
                        set udg_TempInteger=$3E8 // $3E8 = 1000
                    else
                        if(Trig_Chemist_Pharmacology_Cond_TierThree())then
                            set udg_TempInteger=$9C4 // $9C4 = 2500
                        else
                            if(Trig_Chemist_Pharmacology_Cond_TierFour())then
                                set udg_TempInteger=6000
                            endif
                        endif
                    endif
                endif
                // ((udg_TempInteger) times (3)) divided by (2); drop the remainder.
                set udg_TempInteger=((udg_TempInteger*3)/ 2)
                if(Trig_Chemist_Pharmacology_Cond_RestoresMana())then
                    call AddSpecialEffectTargetUnitBJ("origin",udg_TempUnit2,"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    set udg_DmgFlagPure=true
                    set udg_DmgFlagUnavoidable=-1
                    set udg_IgnoresReduction=true
                    set udg_IsPureDamage=true
                    set udg_DmgFlagManaDamage=true
                    // (udg_TempInteger) divided by (2); drop the remainder treated as a decimal-capable number.
                    call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,I2R((udg_TempInteger/ 2)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                endif
                if(Trig_Chemist_Pharmacology_Cond_RestoresLife())then
                    call AddSpecialEffectTargetUnitBJ("origin",udg_TempUnit2,"Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    set udg_DmgFlagPure=true
                    set udg_DmgFlagUnavoidable=-1
                    set udg_IgnoresReduction=true
                    set udg_IsPureDamage=true
                    // Udg_TempInteger treated as a decimal-capable number.
                    call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,I2R(udg_TempInteger),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                endif
            endif
        endif
    endif
endfunction

function Trig_Chemist_LearnAlchemy_Conditions takes nothing returns boolean
    return(GetLearnedSkillBJ()=='A1AK') // 'A1AK': ability "Alchemy"
endfunction

function Trig_Chemist_LearnAlchemy_Cond_AlchemyMastered takes nothing returns boolean
    return(udg_TempInteger>$A) // $A = 10
endfunction

function Trig_Chemist_LearnAlchemy_Actions takes nothing returns nothing
    set udg_TempInteger=GetUnitAbilityLevelSwapped('A1AK',GetTriggerUnit()) // 'A1AK': ability "Alchemy"
    call SetPlayerAbilityAvailableBJ(true,udg_BrewAbility[udg_TempInteger],GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Chemist_LearnAlchemy_Cond_AlchemyMastered())then
        call UnitRemoveAbilityBJ('A1AJ',GetTriggerUnit()) // 'A1AJ': ability "Alchemy"
        call UnitAddAbilityBJ('A1AI',GetTriggerUnit()) // 'A1AI': ability "Alchemy"
    else
        call UnitAddAbilityBJ('A1AJ',GetTriggerUnit()) // 'A1AJ': ability "Alchemy"
    endif
endfunction

function Trig_Chemist_Brew_Conditions takes nothing returns boolean
    return(SubStringBJ(GetAbilityName(GetSpellAbilityId()),1,5)=="Brew ")
endfunction

function Trig_Chemist_Brew_Cond_BrewPotion takes nothing returns boolean
    return(GetSpellAbilityId()=='A18U') // 'A18U': ability "Brew Potion"
endfunction

function Trig_Chemist_Brew_Cond_BrewEther takes nothing returns boolean
    return(GetSpellAbilityId()=='A18X') // 'A18X': ability "Brew Ether"
endfunction

function Trig_Chemist_Brew_Cond_BrewHiPotion takes nothing returns boolean
    return(GetSpellAbilityId()=='A18Z') // 'A18Z': ability "Brew Hi-Potion"
endfunction

function Trig_Chemist_Brew_Cond_BrewHiEther takes nothing returns boolean
    return(GetSpellAbilityId()=='A191') // 'A191': ability "Brew Hi-Ether"
endfunction

function Trig_Chemist_Brew_Cond_IsBrewHeroDrink takes nothing returns boolean
    return(GetSpellAbilityId()=='A195')or(GetSpellAbilityId()=='A196') // 'A195': ability "Brew Hero Drink"; 'A196': ability "Brew Hero Drink"
endfunction

function Trig_Chemist_Brew_Cond_BrewHeroDrink takes nothing returns boolean
    return(Trig_Chemist_Brew_Cond_IsBrewHeroDrink())
endfunction

function Trig_Chemist_Brew_Cond_BrewMegaPotion takes nothing returns boolean
    return(GetSpellAbilityId()=='A193') // 'A193': ability "Brew Mega Potion"
endfunction

function Trig_Chemist_Brew_Cond_BrewMegaEther takes nothing returns boolean
    return(GetSpellAbilityId()=='A194') // 'A194': ability "Brew Mega Ether"
endfunction

function Trig_Chemist_Brew_Cond_IsBrewNectar takes nothing returns boolean
    return(GetSpellAbilityId()=='A18Q')or(GetSpellAbilityId()=='A192') // 'A18Q': ability "Brew Nectar"; 'A192': ability "Brew Nectar"
endfunction

function Trig_Chemist_Brew_Cond_NectarUpgradeRoll takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetSpellAbilityId()=='A192')or(GetRandomInt(1,2)==1) // 'A192': ability "Brew Nectar"
endfunction

function Trig_Chemist_Brew_Cond_BrewGreaterNectar takes nothing returns boolean
    // A random whole number from 1 through 600.
    return(Trig_Chemist_Brew_Cond_NectarUpgradeRoll())and(GetRandomInt(1,600)<=GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))
endfunction

function Trig_Chemist_Brew_Cond_BrewNectar takes nothing returns boolean
    return(Trig_Chemist_Brew_Cond_IsBrewNectar())
endfunction

function Trig_Chemist_Brew_Cond_BrewXPotion takes nothing returns boolean
    return(GetSpellAbilityId()=='A18R') // 'A18R': ability "Brew X-Potion"
endfunction

function Trig_Chemist_Brew_Cond_BrewTurboEther takes nothing returns boolean
    return(GetSpellAbilityId()=='A18S') // 'A18S': ability "Brew Turbo Ether"
endfunction

function Trig_Chemist_Brew_Cond_BrewElixir takes nothing returns boolean
    return(GetSpellAbilityId()=='A18T') // 'A18T': ability "Brew Elixir"
endfunction

function Trig_Chemist_Brew_Actions takes nothing returns nothing
    if(Trig_Chemist_Brew_Cond_BrewPotion())then
        call UnitAddItemByIdSwapped('I02L',GetTriggerUnit()) // 'I02L': item "Chemist's Potion"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewEther())then
        call UnitAddItemByIdSwapped('I02E',GetSpellAbilityUnit()) // 'I02E': item "Chemist's Ether"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewHiPotion())then
        call UnitAddItemByIdSwapped('I02J',GetSpellAbilityUnit()) // 'I02J': item "Chemist's Hi-Potion"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewHiEther())then
        call UnitAddItemByIdSwapped('I02I',GetSpellAbilityUnit()) // 'I02I': item "Chemist's Hi-Ether"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewHeroDrink())then
        call UnitAddItemByIdSwapped('I02H',GetSpellAbilityUnit()) // 'I02H': item "Chemist's Hero Drink"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewMegaPotion())then
        call UnitAddItemByIdSwapped('I02M',GetSpellAbilityUnit()) // 'I02M': item "Chemist's Mega Potion"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewMegaEther())then
        call UnitAddItemByIdSwapped('I02K',GetSpellAbilityUnit()) // 'I02K': item "Chemist's Mega Ether"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewNectar())then
        if(Trig_Chemist_Brew_Cond_BrewGreaterNectar())then
            call UnitAddItemByIdSwapped('I0EU',GetSpellAbilityUnit()) // 'I0EU': item "Chemist's Greater Nectar"
        else
            call UnitAddItemByIdSwapped('I0ET',GetSpellAbilityUnit()) // 'I0ET': item "Chemist's Nectar"
        endif
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewXPotion())then
        call UnitAddItemByIdSwapped('I02O',GetSpellAbilityUnit()) // 'I02O': item "Chemist's X-Potion"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewTurboEther())then
        call UnitAddItemByIdSwapped('I02N',GetSpellAbilityUnit()) // 'I02N': item "Chemist's Turbo Ether"
        return
    endif
    if(Trig_Chemist_Brew_Cond_BrewElixir())then
        call UnitAddItemByIdSwapped('I02D',GetSpellAbilityUnit()) // 'I02D': item "Chemist's Elixir"
        return
    endif
endfunction

function Trig_Chemist_NoxiousMixture_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GZ') // 'A0GZ': ability "Noxious Mixture"
endfunction

function Trig_Chemist_NoxiousMixture_Actions takes nothing returns nothing
    local integer l_abilId=GetSpellAbilityId()
    local unit triggeringUnit=GetTriggerUnit()
    local player owningPlayer=GetOwningPlayer(triggeringUnit)
    local real x=GetSpellTargetX()
    local real y=GetSpellTargetY()
    local integer l_dummyId
    // Starting value for manaCost:
    // (BlzGetAbilityManaCost(l_abilId, Abil_GetLevel(triggeringUnit, l_abilId))) divided by (10).
    local integer manaCost=BlzGetAbilityManaCost(l_abilId,Abil_GetLevel(triggeringUnit,l_abilId))/ $A // $A = 10
    // Starting value for l_intBonus:
    // (Intelligence of triggeringUnit) times (6).
    local integer l_intBonus=GetHeroInt(triggeringUnit,true)*6
    local integer l_potency=1
    local integer l_cloudKind=3
    local real l_power
    local unit l_dummy
    local effect l_fx
    set udg_CurrentHero=triggeringUnit
    set udg_TempItemId='tkno' // 'tkno': object name not found in map data
    call ConditionalTriggerExecute(gg_trg_Chemist_TakeItem)
    if(udg_TempItemId=='tkno')then // 'tkno': object name not found in map data
        call DisplayTimedTextToPlayer(owningPlayer,0,0,10.,"|cffff0000You have no Chemist's item to toss!|r")
        set triggeringUnit=null
        set owningPlayer=null
        return
    endif
    if(udg_TempItemId=='I02L' or udg_TempItemId=='I02J' or udg_TempItemId=='I02M' or udg_TempItemId=='I02O')then // 'I02L': item "Chemist's Potion"; 'I02J': item "Chemist's Hi-Potion"; 'I02M': item "Chemist's Mega Potion"; 'I02O': item "Chemist's X-Potion"
        set l_cloudKind=2
    elseif(udg_TempItemId=='I02E' or udg_TempItemId=='I02I' or udg_TempItemId=='I02K' or udg_TempItemId=='I02N' or udg_TempItemId=='I02D')then // 'I02E': item "Chemist's Ether"; 'I02I': item "Chemist's Hi-Ether"; 'I02K': item "Chemist's Mega Ether"; 'I02N': item "Chemist's Turbo Ether"; 'I02D': item "Chemist's Elixir"
        set l_cloudKind=3
    elseif(udg_TempItemId=='I0ET' or udg_TempItemId=='I0EU' or udg_TempItemId=='I02H')then // 'I0ET': item "Chemist's Nectar"; 'I0EU': item "Chemist's Greater Nectar"; 'I02H': item "Chemist's Hero Drink"
        set l_cloudKind=4
    endif
    if(udg_TempItemId=='I02L' or udg_TempItemId=='I02E' or udg_TempItemId=='I0ET')then // 'I02L': item "Chemist's Potion"; 'I02E': item "Chemist's Ether"; 'I0ET': item "Chemist's Nectar"
        set l_potency=80
    elseif(udg_TempItemId=='I02J' or udg_TempItemId=='I02I' or udg_TempItemId=='I0EU')then // 'I02J': item "Chemist's Hi-Potion"; 'I02I': item "Chemist's Hi-Ether"; 'I0EU': item "Chemist's Greater Nectar"
        set l_potency='}'
    elseif(udg_TempItemId=='I02M' or udg_TempItemId=='I02K' or udg_TempItemId=='I02H')then // 'I02M': item "Chemist's Mega Potion"; 'I02K': item "Chemist's Mega Ether"; 'I02H': item "Chemist's Hero Drink"
        set l_potency=$C8 // $C8 = 200
    elseif(udg_TempItemId=='I02O' or udg_TempItemId=='I02N')then // 'I02O': item "Chemist's X-Potion"; 'I02N': item "Chemist's Turbo Ether"
        set l_potency=300
    elseif(udg_TempItemId=='I02D')then // 'I02D': item "Chemist's Elixir"
        set l_potency=500
    endif
    if(l_cloudKind==3)then
        // ((l_potency) times (5)) divided by (4); drop the remainder.
        set l_potency=(l_potency*5)/ 4
    elseif(l_cloudKind==4)then
        // (l_intBonus) divided by (2); drop the remainder.
        set l_intBonus=l_intBonus/ 2
    endif
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\AcidBomb\\BottleMissile.mdl",x,y))
    set l_dummy=CreateUnit(owningPlayer,'h01B',x,y,.0) // 'h01B': unit "Proxy Dummy"
    set l_dummyId=GetHandleId(l_dummy)
    call SaveUnitHandle(udg_ProxyDamageHash,l_dummyId,0,triggeringUnit)
    // ((((mana cost) times (l_potency)) plus (l_intBonus)) times (Prof_GetSpellPower(triggeringUnit, 'R000', 0.5))) times
    // (0.1).
    set l_power=(((manaCost*l_potency)+l_intBonus)*Prof_GetSpellPower(triggeringUnit,'R000',.5))*.1 // 'R000': upgrade "Tools"
    if(l_cloudKind==3)then
        call SaveReal(udg_ProxyDamageHash,l_dummyId,1,l_power)
        call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,3)
        set l_fx=AddSpecialEffect("Abilities\\Spells\\Human\\CloudOfFog\\CloudOfFog.mdl",x,y)
        call BlzSetSpecialEffectScale(l_fx,1.2)
    elseif(l_cloudKind==2)then
        call SaveReal(udg_ProxyDamageHash,l_dummyId,1,l_power)
        call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,3)
        set l_fx=AddSpecialEffect("Units\\Undead\\PlagueCloud\\PlagueCloud.mdl",x,y)
        call BlzSetSpecialEffectScale(l_fx,3.)
    elseif(l_cloudKind==4)then
        // (l_power) times (udg_DifficultyScale).
        call SaveReal(udg_ProxyDamageHash,l_dummyId,1,l_power*udg_DifficultyScale)
        call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,4)
        set l_fx=AddSpecialEffect("Abilities\\Spells\\NightElf\\TargetArtLumber\\TargetArtLumber.mdl",x,y)
        call BlzSetSpecialEffectScale(l_fx,2.5)
    endif
    call UnitApplyTimedLife(l_dummy,'BTLF',5.7) // 'BTLF': object name not found in map data
    call UnitAddAbility(l_dummy,'A1A9') // 'A1A9': ability "Noxious Mixture Damage"
    call Wait_Polled(6.)
    call DestroyEffect(l_fx)
    set triggeringUnit=null
    set l_dummy=null
    set owningPlayer=null
    set l_fx=null
endfunction

function Trig_Chemist_Molotov_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZZ') // 'A0ZZ': ability "Molotov Cocktail"
endfunction

function Trig_Chemist_Molotov_Cond_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Chemist_Molotov_Actions takes nothing returns nothing
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (5).
    // Result 2: (result 1) plus (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 5)+2
    if(Trig_Chemist_Molotov_Cond_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (1)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*1))
    endif
    set udg_TempReal=Prof_GetSpellPower(GetTriggerUnit(),'R000',.5) // 'R000': upgrade "Tools"
    call SaveUnitHandleBJ(GetTriggerUnit(),0,GetHandleIdBJ(GetSpellTargetUnit()),udg_MolotovHash)
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,GetHandleIdBJ(GetSpellTargetUnit()),udg_MolotovHash)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0ZY',GetLastCreatedUnit()) // 'A0ZY': ability "Molotov Cocktail"
    call SetUnitAbilityLevelSwapped('A0ZY',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0ZY': ability "Molotov Cocktail"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_Chemist automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Chemist (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Chemist takes nothing returns nothing
endfunction

function Register_Chemist_TakeItem takes nothing returns nothing
    set gg_trg_Chemist_TakeItem=CreateTrigger()
    call DisableTrigger(gg_trg_Chemist_TakeItem)
    call TriggerAddAction(gg_trg_Chemist_TakeItem,function Trig_Chemist_TakeItem_Actions)
endfunction

function Register_Chemist_Pharmacology takes nothing returns nothing
    set gg_trg_Chemist_Pharmacology=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chemist_Pharmacology,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chemist_Pharmacology,Condition(function Trig_Chemist_Pharmacology_Conditions))
    call TriggerAddAction(gg_trg_Chemist_Pharmacology,function Trig_Chemist_Pharmacology_Actions)
endfunction

function Register_Chemist_LearnAlchemy takes nothing returns nothing
    set gg_trg_Chemist_LearnAlchemy=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chemist_LearnAlchemy,EVENT_PLAYER_HERO_SKILL)
    call TriggerAddCondition(gg_trg_Chemist_LearnAlchemy,Condition(function Trig_Chemist_LearnAlchemy_Conditions))
    call TriggerAddAction(gg_trg_Chemist_LearnAlchemy,function Trig_Chemist_LearnAlchemy_Actions)
endfunction

function Register_Chemist_Brew takes nothing returns nothing
    set gg_trg_Chemist_Brew=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chemist_Brew,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chemist_Brew,Condition(function Trig_Chemist_Brew_Conditions))
    call TriggerAddAction(gg_trg_Chemist_Brew,function Trig_Chemist_Brew_Actions)
endfunction

function Register_Chemist_NoxiousMixture takes nothing returns nothing
    set gg_trg_Chemist_NoxiousMixture=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chemist_NoxiousMixture,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chemist_NoxiousMixture,Condition(function Trig_Chemist_NoxiousMixture_Conditions))
    call TriggerAddAction(gg_trg_Chemist_NoxiousMixture,function Trig_Chemist_NoxiousMixture_Actions)
endfunction

function Register_Chemist_Molotov takes nothing returns nothing
    set gg_trg_Chemist_Molotov=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chemist_Molotov,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chemist_Molotov,Condition(function Trig_Chemist_Molotov_Conditions))
    call TriggerAddAction(gg_trg_Chemist_Molotov,function Trig_Chemist_Molotov_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Chemist takes nothing returns nothing
    call Register_Chemist_TakeItem() // starts off; run by Chemist
    call Register_Chemist_Pharmacology()
    call Register_Chemist_LearnAlchemy()
    call Register_Chemist_Brew()
    call Register_Chemist_NoxiousMixture()
    call Register_Chemist_Molotov()
endfunction

endlibrary

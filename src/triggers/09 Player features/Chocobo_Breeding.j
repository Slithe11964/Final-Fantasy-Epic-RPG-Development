library TChocoboBreeding
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chocobo_Breed_Score=null
endglobals

function Trig_Chocobo_Breed_Score_TargetIsTier3Type takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedTargetChocobo)=='n02T')or(GetUnitTypeId(udg_BreedTargetChocobo)=='n035')or(GetUnitTypeId(udg_BreedTargetChocobo)=='n036') // 'n02T': unit "Chocobo"; 'n035': unit "Chocobo"; 'n036': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_TargetIsTier6 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedTargetChocobo)=='n038') // 'n038': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_TargetIsTier5 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedTargetChocobo)=='n037') // 'n037': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_TargetIsTier4 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedTargetChocobo)=='n02U') // 'n02U': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_TargetIsTier3 takes nothing returns boolean
    return(Trig_Chocobo_Breed_Score_TargetIsTier3Type())
endfunction

function Trig_Chocobo_Breed_Score_TargetIsTier2 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedTargetChocobo)=='n02S') // 'n02S': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_TargetIsTier1 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedTargetChocobo)=='n02J') // 'n02J': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_PartnerIsTier3Type takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedPartnerChocobo)=='n02T')or(GetUnitTypeId(udg_BreedPartnerChocobo)=='n035')or(GetUnitTypeId(udg_BreedPartnerChocobo)=='n036') // 'n02T': unit "Chocobo"; 'n035': unit "Chocobo"; 'n036': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_PartnerIsTier6 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedPartnerChocobo)=='n038') // 'n038': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_PartnerIsTier5 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedPartnerChocobo)=='n037') // 'n037': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_PartnerIsTier4 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedPartnerChocobo)=='n02U') // 'n02U': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_PartnerIsTier3 takes nothing returns boolean
    return(Trig_Chocobo_Breed_Score_PartnerIsTier3Type())
endfunction

function Trig_Chocobo_Breed_Score_PartnerIsTier2 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedPartnerChocobo)=='n02S') // 'n02S': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_PartnerIsTier1 takes nothing returns boolean
    return(GetUnitTypeId(udg_BreedPartnerChocobo)=='n02J') // 'n02J': unit "Chocobo"
endfunction

function Trig_Chocobo_Breed_Score_Actions takes nothing returns nothing
    if(Trig_Chocobo_Breed_Score_TargetIsTier1())then
        set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+1)
    else
        if(Trig_Chocobo_Breed_Score_TargetIsTier2())then
            set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+2)
        else
            if(Trig_Chocobo_Breed_Score_TargetIsTier3())then
                set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+3)
            else
                if(Trig_Chocobo_Breed_Score_TargetIsTier4())then
                    set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+4)
                else
                    if(Trig_Chocobo_Breed_Score_TargetIsTier5())then
                        set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+5)
                    else
                        if(Trig_Chocobo_Breed_Score_TargetIsTier6())then
                            set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+6)
                        endif
                    endif
                endif
            endif
        endif
    endif
    if(Trig_Chocobo_Breed_Score_PartnerIsTier1())then
        set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+1)
    else
        if(Trig_Chocobo_Breed_Score_PartnerIsTier2())then
            set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+2)
        else
            if(Trig_Chocobo_Breed_Score_PartnerIsTier3())then
                set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+3)
            else
                if(Trig_Chocobo_Breed_Score_PartnerIsTier4())then
                    set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+4)
                else
                    if(Trig_Chocobo_Breed_Score_PartnerIsTier5())then
                        set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+5)
                    else
                        if(Trig_Chocobo_Breed_Score_PartnerIsTier6())then
                            set udg_ChocoboAbilityIndex=(udg_ChocoboAbilityIndex+6)
                        endif
                    endif
                endif
            endif
        endif
    endif
endfunction

function InitTrig_Chocobo_Breeding takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Chocobo_Part1 (module Chocobo),
// which keeps the original registration order.

function Register_Chocobo_Breed_Score takes nothing returns nothing
    set gg_trg_Chocobo_Breed_Score=CreateTrigger()
    call DisableTrigger(gg_trg_Chocobo_Breed_Score)
    call TriggerAddAction(gg_trg_Chocobo_Breed_Score,function Trig_Chocobo_Breed_Score_Actions)
endfunction

endlibrary

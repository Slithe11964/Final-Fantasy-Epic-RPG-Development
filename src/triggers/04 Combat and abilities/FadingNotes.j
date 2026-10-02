library TFadingNotes requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_FadingNotes_Init=null
    trigger gg_trg_FadingNotes_DropCultist=null
    trigger gg_trg_FadingNotes_DropWizard=null
    // Variables only this module uses.
    item udg_NoteFromCultist=null
    item udg_NoteFromWizard=null
    integer udg_FadingNoteIndex=0
endglobals

function Trig_FadingNotes_Init_Actions takes nothing returns nothing
    set udg_FadingNoteIndex=0
    set udg_RewardItem[1]='I0AB' // 'I0AB': item "Fading Note"
    set udg_RewardItem[2]='I0AC' // 'I0AC': item "Fading Note"
    set udg_RewardItem[3]='I0AD' // 'I0AD': item "Fading Note"
    set udg_RewardItem[4]='I0AE' // 'I0AE': item "Fading Note"
    set udg_RewardItem[5]='I0AF' // 'I0AF': item "Fading Note"
    set udg_RewardItem[6]='I0AG' // 'I0AG': item "Fading Note"
    set udg_RewardItem[7]='I0AV' // 'I0AV': item "Fading Note"
    set udg_RewardItem[8]='I0AH' // 'I0AH': item "Fading Note"
    set udg_RewardItem[9]='I0AI' // 'I0AI': item "Fading Note"
    set udg_RewardItem[$A]='I0AJ' // $A = 10; 'I0AJ': item "Fading Note"
    set udg_RewardItem[$B]='I0AK' // $B = 11; 'I0AK': item "Fading Note"
    set udg_RewardItem[$C]='I0AL' // $C = 12; 'I0AL': item "Fading Note"
    set udg_RewardItem[$D]='I0AM' // $D = 13; 'I0AM': item "Fading Note"
    set udg_RewardItem[$E]='I0AN' // $E = 14; 'I0AN': item "Fading Note"
    set udg_RewardItem[$F]='I0AO' // $F = 15; 'I0AO': item "Fading Note"
    set udg_RewardItem[16]='I0AP' // 'I0AP': item "Fading Note"
    set udg_RewardItem[17]='I0AQ' // 'I0AQ': item "Fading Note"
    set udg_RewardItem[18]='I0AR' // 'I0AR': item "Fading Note"
    set udg_RewardItem[19]='I0AS' // 'I0AS': item "Fading Note"
    set udg_RewardItem[20]='I0AT' // 'I0AT': item "Fading Note"
    set udg_RewardItem[21]='I0AU' // 'I0AU': item "Fading Note"
    set udg_RewardItem[22]='I0AW' // 'I0AW': item "Fading Note"
    set udg_RewardItem[23]='I0AX' // 'I0AX': item "Fading Note"
    set udg_RewardItem[24]='I0AY' // 'I0AY': item "Fading Note"
    set udg_RewardItem[25]='I0AZ' // 'I0AZ': item "Fading Note"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_FadingNotes_DropCultist_IsCultist takes nothing returns boolean
    return(GetUnitTypeId(GetDyingUnit())=='nwiz')or(GetUnitTypeId(GetDyingUnit())=='nhfp')or(GetUnitTypeId(GetDyingUnit())=='nhdc')or(GetUnitTypeId(GetDyingUnit())=='nhhr') // 'nwiz': unit "Apprentice Dark Wizard"; 'nhfp': unit "Kultist"; 'nhdc': object name not found in map data; 'nhhr': object name not found in map data
endfunction

function Trig_FadingNotes_DropCultist_Conditions takes nothing returns boolean
    // A random whole number from 1 through 10.
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_FadingNotes_DropCultist_IsCultist())and(GetRandomInt(1,$A)<=1) // $A = 10
endfunction

function Trig_FadingNotes_DropCultist_IsLastNote takes nothing returns boolean
    return(udg_FadingNoteIndex>=25)
endfunction

function Trig_FadingNotes_DropCultist_DiffersFromWizardNote takes nothing returns boolean
    return(GetItemTypeId(GetLastCreatedItem())!=GetItemTypeId(udg_NoteFromWizard))
endfunction

function Trig_FadingNotes_DropCultist_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_FadingNotes_DropCultist_IsLastNote())then
        set udg_FadingNoteIndex=1
    else
        set udg_FadingNoteIndex=(udg_FadingNoteIndex+1)
    endif
    set udg_NoteFromCultist=CreateItemLoc(udg_RewardItem[udg_FadingNoteIndex],udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    if(Trig_FadingNotes_DropCultist_DiffersFromWizardNote())then
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        call Wait_Polled(45.)
    endif
    call RemoveItem(udg_NoteFromCultist)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_FadingNotes_DropWizard_IsWizard takes nothing returns boolean
    return(GetUnitTypeId(GetDyingUnit())=='nwzr')or(GetUnitTypeId(GetDyingUnit())=='nwzg')or(GetUnitTypeId(GetDyingUnit())=='nwzd') // 'nwzr': object name not found in map data; 'nwzg': object name not found in map data; 'nwzd': object name not found in map data
endfunction

function Trig_FadingNotes_DropWizard_Conditions takes nothing returns boolean
    // A random whole number from 1 through 10.
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_FadingNotes_DropWizard_IsWizard())and(GetRandomInt(1,$A)<=1) // $A = 10
endfunction

function Trig_FadingNotes_DropWizard_IsLastNoteIndex takes nothing returns boolean
    return(udg_FadingNoteIndex>=25)
endfunction

function Trig_FadingNotes_DropWizard_DiffersFromCultistNote takes nothing returns boolean
    return(GetItemTypeId(GetLastCreatedItem())!=GetItemTypeId(udg_NoteFromCultist))
endfunction

function Trig_FadingNotes_DropWizard_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_FadingNotes_DropWizard_IsLastNoteIndex())then
        set udg_FadingNoteIndex=1
    else
        set udg_FadingNoteIndex=(udg_FadingNoteIndex+1)
    endif
    set udg_NoteFromWizard=CreateItemLoc(udg_RewardItem[udg_FadingNoteIndex],udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    if(Trig_FadingNotes_DropWizard_DiffersFromCultistNote())then
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        call Wait_Polled(45.)
    endif
    call RemoveItem(udg_NoteFromWizard)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_FadingNotes automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_FadingNotes (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_FadingNotes takes nothing returns nothing
endfunction

function Register_FadingNotes_Init takes nothing returns nothing
    set gg_trg_FadingNotes_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_FadingNotes_Init,3.)
    call TriggerAddAction(gg_trg_FadingNotes_Init,function Trig_FadingNotes_Init_Actions)
endfunction

function Register_FadingNotes_DropCultist takes nothing returns nothing
    set gg_trg_FadingNotes_DropCultist=CreateTrigger()
    call DisableTrigger(gg_trg_FadingNotes_DropCultist)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_FadingNotes_DropCultist,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_FadingNotes_DropCultist,Condition(function Trig_FadingNotes_DropCultist_Conditions))
    call TriggerAddAction(gg_trg_FadingNotes_DropCultist,function Trig_FadingNotes_DropCultist_Actions)
endfunction

function Register_FadingNotes_DropWizard takes nothing returns nothing
    set gg_trg_FadingNotes_DropWizard=CreateTrigger()
    call DisableTrigger(gg_trg_FadingNotes_DropWizard)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_FadingNotes_DropWizard,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_FadingNotes_DropWizard,Condition(function Trig_FadingNotes_DropWizard_Conditions))
    call TriggerAddAction(gg_trg_FadingNotes_DropWizard,function Trig_FadingNotes_DropWizard_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_FadingNotes takes nothing returns nothing
    call Register_FadingNotes_Init()
    call Register_FadingNotes_DropCultist() // starts off; enabled by Quest_SeekDestroy
    call Register_FadingNotes_DropWizard() // starts off; enabled by Quest_SeekDestroy
endfunction

endlibrary

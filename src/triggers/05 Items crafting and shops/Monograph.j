library TMonograph
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Monograph_Drop=null
    // Variables only this module uses.
    integer udg_MonographCount=0
endglobals

function Trig_Monograph_Drop_IsKnightChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0057)
endfunction

function Trig_Monograph_Drop_IsElderChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0056)
endfunction

function Trig_Monograph_Drop_IsDragoonChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0055)
endfunction

function Trig_Monograph_Drop_IsBerserkerChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0054)
endfunction

function Trig_Monograph_Drop_IsWarmageChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0053)
endfunction

function Trig_Monograph_Drop_IsTravellerChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0051)
endfunction

function Trig_Monograph_Drop_IsHunterChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0050)
endfunction

function Trig_Monograph_Drop_IsSageChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0049)
endfunction

function Trig_Monograph_Drop_IsSentinelChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0048)
endfunction

function Trig_Monograph_Drop_IsScholarChest takes nothing returns boolean
    return(GetDyingDestructable()==gg_dest_B001_0047)
endfunction

function Trig_Monograph_Drop_AllChestsDone takes nothing returns boolean
    return(udg_MonographCount>=$A) // $A = 10
endfunction

function Trig_Monograph_Drop_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_MonographCount=(udg_MonographCount+1)
    set l_tempPoint=GetDestructableLoc(GetDyingDestructable())
    if(Trig_Monograph_Drop_IsScholarChest())then
        call CreateItemLoc('I0EK',l_tempPoint) // 'I0EK': item "Scholar's Monograph"
    else
        if(Trig_Monograph_Drop_IsSentinelChest())then
            call CreateItemLoc('I0EJ',l_tempPoint) // 'I0EJ': item "Sentinel's Monograph"
        else
            if(Trig_Monograph_Drop_IsSageChest())then
                call CreateItemLoc('I0EL',l_tempPoint) // 'I0EL': item "Sage's Monograph"
            else
                if(Trig_Monograph_Drop_IsHunterChest())then
                    call CreateItemLoc('I0EF',l_tempPoint) // 'I0EF': item "Hunter's Monograph"
                else
                    if(Trig_Monograph_Drop_IsTravellerChest())then
                        call CreateItemLoc('I0EG',l_tempPoint) // 'I0EG': item "Traveller's Monograph"
                    else
                        if(Trig_Monograph_Drop_IsWarmageChest())then
                            call CreateItemLoc('I0EH',l_tempPoint) // 'I0EH': item "Warmage's Monograph"
                        else
                            if(Trig_Monograph_Drop_IsBerserkerChest())then
                                call CreateItemLoc('I0EM',l_tempPoint) // 'I0EM': item "Berserker's Monograph"
                            else
                                if(Trig_Monograph_Drop_IsDragoonChest())then
                                    call CreateItemLoc('I0EN',l_tempPoint) // 'I0EN': item "Dragoon's Monograph"
                                else
                                    if(Trig_Monograph_Drop_IsElderChest())then
                                        call CreateItemLoc('I0EO',l_tempPoint) // 'I0EO': item "Elder's Monograph"
                                    else
                                        if(Trig_Monograph_Drop_IsKnightChest())then
                                            call CreateItemLoc('I0EI',l_tempPoint) // 'I0EI': item "Knight's Monograph"
                                        endif
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set udg_MonographDropped=true
    if(Trig_Monograph_Drop_AllChestsDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call DestroyTrigger(GetTriggeringTrigger())
    endif
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Monograph automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Monograph (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Monograph takes nothing returns nothing
endfunction

function Register_Monograph_Drop takes nothing returns nothing
    set gg_trg_Monograph_Drop=CreateTrigger()
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0047)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0048)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0049)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0050)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0051)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0053)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0054)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0055)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0056)
    call TriggerRegisterDeathEvent(gg_trg_Monograph_Drop,gg_dest_B001_0057)
    call TriggerAddAction(gg_trg_Monograph_Drop,function Trig_Monograph_Drop_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Monograph takes nothing returns nothing
    call Register_Monograph_Drop()
endfunction

endlibrary

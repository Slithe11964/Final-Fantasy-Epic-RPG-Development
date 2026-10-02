library TAbilityTags requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_AbilityTags_Show=null
endglobals

function Trig_AbilityTags_Show_UseBaseCost_Tier6 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_AbilityTags_Show_IsTier6 takes nothing returns boolean
    return(udg_GatherState[GetForLoopIndexA()]==6)
endfunction

function Trig_AbilityTags_Show_UseBaseCost_Tier5 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_AbilityTags_Show_IsTier5 takes nothing returns boolean
    return(udg_GatherState[GetForLoopIndexA()]==5)
endfunction

function Trig_AbilityTags_Show_UseBaseCost_Tier4 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_AbilityTags_Show_IsTier4 takes nothing returns boolean
    return(udg_GatherState[GetForLoopIndexA()]==4)
endfunction

function Trig_AbilityTags_Show_PlayerHasAbilities takes nothing returns boolean
    return(IsPlayerInForce(ConvertedPlayer(GetForLoopIndexA()),udg_PlayingPlayers))and(udg_GatherState[GetForLoopIndexA()]>=4)
endfunction

function Trig_AbilityTags_Show_Actions takes nothing returns nothing
    call StartTimerBJ(udg_FishingTimer[0],false,.4)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_AbilityTags_Show_PlayerHasAbilities())then
            if(Trig_AbilityTags_Show_IsTier4())then
                call CreateTextTagLocBJ(GetAbilityName(udg_FishPullAbil[GetForLoopIndexA()]),udg_FishingBobberLoc[GetForLoopIndexA()],0,10.,'d','d','d',0)
                if(Trig_AbilityTags_Show_UseBaseCost_Tier4())then
                    // Result 1: (1) minus (1).
                    // Result 2: BlzGetAbilityManaCost(udg_FishPullAbil at position loop counter A, result 1) treated as a
                    // decimal-capable number.
                    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),128.,I2R(BlzGetAbilityManaCost(udg_FishPullAbil[GetForLoopIndexA()],(1-1))))
                else
                    // BlzGetAbilityManaCost(udg_FishPullAbil at position loop counter A, 1) treated as a decimal-capable number.
                    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),128.,I2R(BlzGetAbilityManaCost(udg_FishPullAbil[GetForLoopIndexA()],1)))
                endif
            else
                if(Trig_AbilityTags_Show_IsTier5())then
                    call CreateTextTagLocBJ(GetAbilityName(udg_FishLeftAbil[GetForLoopIndexA()]),udg_FishingBobberLoc[GetForLoopIndexA()],0,12.,'d','d','d',0)
                    if(Trig_AbilityTags_Show_UseBaseCost_Tier5())then
                        // Result 1: (1) minus (1).
                        // Result 2: BlzGetAbilityManaCost(udg_FishLeftAbil at position loop counter A, result 1) treated as a
                        // decimal-capable number.
                        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),150.,I2R(BlzGetAbilityManaCost(udg_FishLeftAbil[GetForLoopIndexA()],(1-1))))
                    else
                        // BlzGetAbilityManaCost(udg_FishLeftAbil at position loop counter A, 1) treated as a decimal-capable number.
                        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),150.,I2R(BlzGetAbilityManaCost(udg_FishLeftAbil[GetForLoopIndexA()],1)))
                    endif
                else
                    if(Trig_AbilityTags_Show_IsTier6())then
                        call CreateTextTagLocBJ(GetAbilityName(udg_FishRightAbil[GetForLoopIndexA()]),udg_FishingBobberLoc[GetForLoopIndexA()],0,12.,'d','d','d',0)
                        if(Trig_AbilityTags_Show_UseBaseCost_Tier6())then
                            // Result 1: (1) minus (1).
                            // Result 2: BlzGetAbilityManaCost(udg_FishRightAbil at position loop counter A, result 1) treated as a
                            // decimal-capable number.
                            call SetTextTagVelocityBJ(GetLastCreatedTextTag(),150.,I2R(BlzGetAbilityManaCost(udg_FishRightAbil[GetForLoopIndexA()],(1-1))))
                        else
                            // BlzGetAbilityManaCost(udg_FishRightAbil at position loop counter A, 1) treated as a decimal-capable number.
                            call SetTextTagVelocityBJ(GetLastCreatedTextTag(),150.,I2R(BlzGetAbilityManaCost(udg_FishRightAbil[GetForLoopIndexA()],1)))
                        endif
                    endif
                endif
            endif
            call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
            set udg_TempForce=Force_OfPlayer(ConvertedPlayer(GetForLoopIndexA()))
            call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
            call DestroyForce(udg_TempForce)
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            call SetTextTagFadepointBJ(GetLastCreatedTextTag(),.1)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

// World Editor calls InitTrig_AbilityTags automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_AbilityTags (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_AbilityTags takes nothing returns nothing
endfunction

function Register_AbilityTags_Show takes nothing returns nothing
    set gg_trg_AbilityTags_Show=CreateTrigger()
    call DisableTrigger(gg_trg_AbilityTags_Show)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_AbilityTags_Show,udg_FishingTimer[0])
    call TriggerAddAction(gg_trg_AbilityTags_Show,function Trig_AbilityTags_Show_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_AbilityTags takes nothing returns nothing
    call Register_AbilityTags_Show() // starts off; enabled by Fishing_ReelingAndCatch; disabled by Fishing_ReelingAndCatch
endfunction

endlibrary

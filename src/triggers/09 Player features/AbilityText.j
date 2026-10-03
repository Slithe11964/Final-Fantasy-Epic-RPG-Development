library TAbilityText requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_AbilityText_Command=null
    // Variables only this module uses.
    trigger udg_AbilityTextTrigger=null
endglobals

function AbilityText_Cond takes nothing returns boolean
    return(((not IsUnitType(GetTriggerUnit(),UNIT_TYPE_STRUCTURE))and udg_AbilityTextEnabled)and(not IsUnitHidden(GetTriggerUnit())))!=null
endfunction

function AbilityText_Show takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local player tp=GetOwningPlayer(triggeringUnit)
    local real x=GetUnitX(triggeringUnit)
    local real y=GetUnitY(triggeringUnit)
    local integer l_alpha=0
    local boolean l_marked=false
    local string l_spellName=GetObjectName(GetSpellAbilityId())
    local texttag tt=null
    if(SubString(l_spellName,0,1)==udg_AbilityNameMarker)then
        set l_marked=true
        set l_alpha=$FF // $FF = 255
        set l_spellName=udg_ColorGold+StringCase(SubString(l_spellName,1,StringLength(l_spellName)),true)
    else
        if(GetPlayerId(tp)>7)then
            set l_spellName=null
            set tp=null
            set triggeringUnit=null
            return
        endif
        set l_spellName=udg_PlayerColorCode[GetPlayerId(tp)+1]+l_spellName
    endif
    set tt=CreateTextTag()
    if(l_marked)then
        call SetTextTagText(tt,l_spellName,.028)
    else
        call SetTextTagText(tt,l_spellName,.023)
    endif
    call SetTextTagPos(tt,x,y+64,.0)
    call SetTextTagColor(tt,$FF,$FF,$FF,l_alpha) // $FF = 255
    call SetTextTagVelocity(tt,.0,.044375)
    call SetTextTagPermanent(tt,false)
    call SetTextTagLifespan(tt,1.3)
    call SetTextTagFadepoint(tt,.8)
    if(not IsPlayerInForce(GetLocalPlayer(),udg_AbilityTextForce))then
        call SetTextTagVisibility(tt,false)
    endif
    set l_spellName=null
    set tt=null
    set tp=null
    set triggeringUnit=null
endfunction

function AbilityText_Init takes nothing returns nothing
    local integer i=0
    set udg_AbilityTextTrigger=CreateTrigger()
    loop
        call TriggerRegisterPlayerUnitEvent(udg_AbilityTextTrigger,Player(i),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set i=i+1
        exitwhen i>=$C // $C = 12
    endloop
    call TriggerAddCondition(udg_AbilityTextTrigger,Condition(function AbilityText_Cond))
    call TriggerAddAction(udg_AbilityTextTrigger,function AbilityText_Show)
endfunction

// ---- AbilityText ----
function Trig_AbilityText_Command_Cond_InAbilityTextForce takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_AbilityTextForce))
endfunction

function Trig_AbilityText_Command_Cond_AbilityTextToggle takes nothing returns boolean
    return(GetEventPlayerChatString()=="-abilitytext")
endfunction

function Trig_AbilityText_Command_Cond_AbilityTextOffArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-abilitytext off")
endfunction

function Trig_AbilityText_Command_Cond_AbilityTextOnArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-abilitytext on")
endfunction

function Trig_AbilityText_Command_Cond_AbilityTextNowOn takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_AbilityTextForce))
endfunction

function Trig_AbilityText_Command_Actions takes nothing returns nothing
    local force l_tempForce
    if(Trig_AbilityText_Command_Cond_AbilityTextOnArg())then
        call ForceAddPlayerSimple(GetTriggerPlayer(),udg_AbilityTextForce)
    else
        if(Trig_AbilityText_Command_Cond_AbilityTextOffArg())then
            call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_AbilityTextForce)
        else
            if(Trig_AbilityText_Command_Cond_AbilityTextToggle())then
                if(Trig_AbilityText_Command_Cond_InAbilityTextForce())then
                    call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_AbilityTextForce)
                else
                    call ForceAddPlayerSimple(GetTriggerPlayer(),udg_AbilityTextForce)
                endif
            else
                set l_tempForce=null
                return
            endif
        endif
    endif
    set l_tempForce=Force_OfPlayer(GetTriggerPlayer())
    if(Trig_AbilityText_Command_Cond_AbilityTextNowOn())then
        call DisplayTimedTextToForce(l_tempForce,10.,"Ability Floating Text is now turned on.")
    else
        call DisplayTimedTextToForce(l_tempForce,10.,"Ability Floating Text is now turned off.")
    endif
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_AbilityText automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_AbilityText (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_AbilityText takes nothing returns nothing
endfunction

function Register_AbilityText_Command takes nothing returns nothing
    set gg_trg_AbilityText_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(0),"-abilitytext",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(1),"-abilitytext",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(2),"-abilitytext",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(3),"-abilitytext",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(4),"-abilitytext",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(5),"-abilitytext",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(6),"-abilitytext",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_AbilityText_Command,Player(7),"-abilitytext",false)
    call TriggerAddAction(gg_trg_AbilityText_Command,function Trig_AbilityText_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_AbilityText takes nothing returns nothing
    call Register_AbilityText_Command()
endfunction

endlibrary

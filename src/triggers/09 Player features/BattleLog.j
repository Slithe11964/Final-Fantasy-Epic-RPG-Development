library TBattleLog requires TForce, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Battlelog_Command=null
    // Variables only this module uses.
    string udg_ColorEnd="|r"
    string udg_TextUses="uses "
    trigger udg_BattleLogTrigger=null
endglobals

function BattleLog_Show takes string l_msg,unit t returns nothing
    local real tx=GetUnitX(t)
    local real ty=GetUnitY(t)
    local player tp=GetOwningPlayer(t)
    local unit h
    local real hx
    local real hy
    local player hp
    local integer i=0
    loop
        exitwhen i>=8
        set hp=Player(i)
        if IsPlayerInForce(hp,udg_BattleLogForce)then
            if(tp==hp)then
                call DisplayTimedTextToPlayer(hp,0,0,5,l_msg)
            elseif(IsUnitVisible(t,tp))then
                set h=Player_GetHero(hp)
                // (x position of h) minus (tx).
                set hx=GetUnitX(h)-tx
                // (y position of h) minus (ty).
                set hy=GetUnitY(h)-ty
                // The square of (hx).
                set hx=hx*hx
                // The square of (hy).
                set hy=hy*hy
                // (hx) plus (hy).
                if(hx+hy<$1E8480)then // $1E8480 = 2000000
                    call DisplayTimedTextToPlayer(hp,0,0,5,l_msg)
                endif
            endif
        endif
        set i=i+1
    endloop
    set h=null
    set tp=null
    set hp=null
endfunction

function BattleLog_ShowUnit takes string l_msg,unit t returns nothing
    local string l_name
    if IsUnitType(t,UNIT_TYPE_HERO)then
        set l_name=GetHeroProperName(t)
    else
        set l_name=GetUnitName(t)
    endif
    // (GetPlayerId(GetOwningPlayer(t))) plus (1).
    call BattleLog_Show(udg_PlayerColorCode[GetPlayerId(GetOwningPlayer(t))+1]+l_name+"|r "+l_msg,t)
endfunction

function BattleLog_Cond takes nothing returns boolean
    return(not IsUnitType(GetTriggerUnit(),UNIT_TYPE_STRUCTURE)and GetUnitAbilityLevel(GetTriggerUnit(),'Avul')<=0 and not IsUnitHidden(GetTriggerUnit())and GetSpellAbilityId()!='A0R3')!=null // 'Avul': standard ability reference "Invulnerable"; 'A0R3': ability "Evade & Counter"
endfunction

function BattleLog_ShowCast takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local string l_spellName=GetObjectName(GetSpellAbilityId())
    if(SubString(l_spellName,0,1)==udg_AbilityNameMarker)then
        set l_spellName=udg_ColorGold+SubString(l_spellName,1,StringLength(l_spellName))+udg_ColorEnd+udg_AbilityNameMarker
    endif
    call BattleLog_ShowUnit(udg_TextUses+l_spellName,triggeringUnit)
    set triggeringUnit=null
endfunction

function BattleLog_Init takes nothing returns nothing
    local integer i=0
    set udg_BattleLogTrigger=CreateTrigger()
    call DisableTrigger(udg_BattleLogTrigger)
    loop
        call TriggerRegisterPlayerUnitEvent(udg_BattleLogTrigger,Player(i),EVENT_PLAYER_UNIT_SPELL_CHANNEL,null)
        set i=i+1
        exitwhen i>=$C // $C = 12
    endloop
    call TriggerAddCondition(udg_BattleLogTrigger,Condition(function BattleLog_Cond))
    call TriggerAddAction(udg_BattleLogTrigger,function BattleLog_ShowCast)
endfunction

// ---- Battlelog ----
function Trig_Battlelog_Command_Cond_InBattlelogForce takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_BattleLogForce))
endfunction

function Trig_Battlelog_Command_Cond_BattlelogToggle takes nothing returns boolean
    return(GetEventPlayerChatString()=="-battlelog")
endfunction

function Trig_Battlelog_Command_Cond_BattlelogOffArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-battlelog off")
endfunction

function Trig_Battlelog_Command_Cond_BattlelogOnArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-battlelog on")
endfunction

function Trig_Battlelog_Command_Cond_BattlelogForceEmpty takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_BattleLogForce)<=0)
endfunction

function Trig_Battlelog_Command_Cond_BattlelogNowOn takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_BattleLogForce))
endfunction

function Trig_Battlelog_Command_Actions takes nothing returns nothing
    if(Trig_Battlelog_Command_Cond_BattlelogOnArg())then
        call ForceAddPlayerSimple(GetTriggerPlayer(),udg_BattleLogForce)
    else
        if(Trig_Battlelog_Command_Cond_BattlelogOffArg())then
            call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_BattleLogForce)
        else
            if(Trig_Battlelog_Command_Cond_BattlelogToggle())then
                if(Trig_Battlelog_Command_Cond_InBattlelogForce())then
                    call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_BattleLogForce)
                else
                    call ForceAddPlayerSimple(GetTriggerPlayer(),udg_BattleLogForce)
                endif
            else
                return
            endif
        endif
    endif
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    if(Trig_Battlelog_Command_Cond_BattlelogNowOn())then
        call DisplayTimedTextToForce(udg_TempForce,10.,"You will now get a detailed battle log.")
        call EnableTrigger(udg_BattleLogTrigger)
    else
        call DisplayTimedTextToForce(udg_TempForce,10.,"You will no longer get a detailed battle log.")
        if(Trig_Battlelog_Command_Cond_BattlelogForceEmpty())then
            call DisableTrigger(udg_BattleLogTrigger)
        endif
    endif
    call DestroyForce(udg_TempForce)
endfunction

// World Editor calls InitTrig_BattleLog automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BattleLog (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BattleLog takes nothing returns nothing
endfunction

function Register_Battlelog_Command takes nothing returns nothing
    set gg_trg_Battlelog_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(0),"-battlelog",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(1),"-battlelog",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(2),"-battlelog",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(3),"-battlelog",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(4),"-battlelog",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(5),"-battlelog",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(6),"-battlelog",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Battlelog_Command,Player(7),"-battlelog",false)
    call TriggerAddAction(gg_trg_Battlelog_Command,function Trig_Battlelog_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BattleLog takes nothing returns nothing
    call Register_Battlelog_Command()
endfunction

endlibrary

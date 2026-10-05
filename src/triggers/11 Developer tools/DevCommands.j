library TDevCommands requires TPlayerHero, optional TTitle, TQuestEngine
// ==========================================================================================
// Developer test commands, so testing late-game content takes minutes instead of hours.
//
// ON only when BOTH are true:
//   * DEV_COMMANDS_ON below is true, and
//   * the game has exactly one human player (single player). Multiplayer games ignore them.
// For a public release, untick this trigger in the Trigger Editor (it is optional: nothing else
// needs it) or set DEV_COMMANDS_ON to false.
//
// Type -dev in game for the list. Codes saved after using them carry what the commands gave you.
// docs/DEBUG_COMMANDS.md describes every command.
// ==========================================================================================
globals
    constant boolean DEV_COMMANDS_ON=true
    trigger gg_trg_DevCommands_Chat=null
    trigger gg_trg_DevCommands_Announce=null
    boolean udg_DevGodMode=false
    fogmodifier udg_DevRevealFog=null
    // Characters in the order of their codes, so a typed rawcode like I01Z becomes an id.
    constant string DEV_CHARS=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
endglobals

function DevCommands_Active takes nothing returns boolean
    return DEV_COMMANDS_ON and CountPlayersInForceBJ(udg_PlayingPlayers)==1
endfunction

function DevCommands_Say takes player p,string s returns nothing
    call DisplayTimedTextToPlayer(p,0,0,15,"|cff66ccff[dev]|r "+s)
endfunction

// The text after the command word, e.g. "-gold 5000" -> "5000".
function DevCommands_Arg takes string msg,integer n returns string
    local integer i=0
    local integer len=StringLength(msg)
    local integer word=0
    local integer start=-1
    loop
        exitwhen i>len
        if i==len or SubString(msg,i,i+1)==" " then
            if start>=0 then
                if word==n then
                    return SubString(msg,start,i)
                endif
                set word=word+1
                set start=-1
            endif
        elseif start<0 then
            set start=i
        endif
        set i=i+1
    endloop
    return ""
endfunction

// "I01Z" -> 'I01Z'
function DevCommands_RawCode takes string s returns integer
    local integer i=0
    local integer id=0
    local integer k
    if StringLength(s)!=4 then
        return 0
    endif
    loop
        exitwhen i>=4
        set k=0
        loop
            exitwhen k>=StringLength(DEV_CHARS) or SubString(DEV_CHARS,k,k+1)==SubString(s,i,i+1)
            set k=k+1
        endloop
        set id=id*256+k+32
        set i=i+1
    endloop
    return id
endfunction

// 'I01Z' -> "I01Z"
function DevCommands_RawToString takes integer id returns string
    local string s=""
    local integer i=0
    local integer c
    loop
        exitwhen i>=4
        set c=id-(id/256)*256
        set s=SubString(DEV_CHARS,c-32,c-31)+s
        set id=id/256
        set i=i+1
    endloop
    return s
endfunction

// Writes Documents/Warcraft III/CustomMapData/FFERPG/itemtable.txt: every saveable item with its save
// index, rawcode, whether it is charged (charged items store their charges in save codes) and name.
// tools/savecode.py reads this file to decode save codes exactly.
function DevCommands_DumpItems takes player p returns nothing
    local integer i=1
    local item it
    local integer charged
    local integer n=0
    call PreloadGenClear()
    call PreloadGenStart()
    loop
        exitwhen i>udg_SaveFlagCount
        if udg_ItemIdTable[i]!=0 then
            set it=CreateItem(udg_ItemIdTable[i],0,0)
            set charged=0
            if GetItemType(it)==ITEM_TYPE_CHARGED then
                set charged=1
            endif
            call Preload("ITEM "+I2S(i)+" "+DevCommands_RawToString(udg_ItemIdTable[i])+" "+I2S(charged)+" "+GetItemName(it))
            call RemoveItem(it)
            set n=n+1
        endif
        set i=i+1
    endloop
    if GetLocalPlayer()==p then
        call PreloadGenEnd(".\\FFERPG\\itemtable.txt")
    endif
    set it=null
    call DevCommands_Say(p,I2S(n)+" items written to CustomMapData\\FFERPG\\itemtable.txt")
endfunction

function DevCommands_QuestState takes player p,integer l_number returns nothing
    local integer q=1
    local string l_state
    local string l_slot
    local string l_flags
    local quest l_entry
    static if LIBRARY_TQuestEngine then
        loop
            exitwhen q>QuestCount
            if (l_number==0 and (QuestState[q]==QUEST_STATE_AVAILABLE or QuestState[q]==QUEST_STATE_ACTIVE)) or q==l_number then
                set l_state="hidden"
                if QuestState[q]==QUEST_STATE_AVAILABLE then
                    set l_state="available"
                elseif QuestState[q]==QUEST_STATE_ACTIVE then
                    set l_state="active"
                elseif QuestState[q]==QUEST_STATE_DONE then
                    set l_state="done"
                elseif QuestState[q]==QUEST_STATE_FAILED then
                    set l_state="failed"
                endif
                set l_slot="SideQuest"
                if QuestLogKind[q]==QUEST_MAIN then
                    set l_slot="MainQuest"
                endif
                set l_flags=""
                set l_entry=Quest_LogEntry(q)
                if l_entry!=null then
                    if IsQuestCompleted(l_entry) then
                        set l_flags=l_flags+" log completed"
                    endif
                    if IsQuestFailed(l_entry) then
                        set l_flags=l_flags+" log failed"
                    endif
                endif
                call DevCommands_Say(p,"#"+I2S(q)+" "+QuestName[q]+": "+l_state+", step "+I2S(QuestCurrent[q])+"/"+I2S(QuestSteps[q])+", "+l_slot+"["+I2S(QuestLogIndex[q])+"]"+l_flags)
            endif
            set q=q+1
        endloop
        if l_number<0 or l_number>QuestCount then
            call DevCommands_Say(p,"usage: -queststate [engine quest number 1.."+I2S(QuestCount)+"]")
        endif
    else
        call DevCommands_Say(p,"the QuestEngine module is switched off")
    endif
    set l_entry=null
endfunction

function DevCommands_Help takes player p returns nothing
    call DevCommands_Say(p,"Developer commands (single player only):")
    call DevCommands_Say(p,"-gold N, -shards N, -bp N (Battle Points), -lvl N (hero level)")
    call DevCommands_Say(p,"-heal, -god (toggle invulnerable), -cd (reset cooldowns)")
    call DevCommands_Say(p,"-item XXXX (create item by rawcode), -unit XXXX [N] (enemy units)")
    call DevCommands_Say(p,"-kill (selected units), -tp X Y (or -tp: camera), -pos")
    call DevCommands_Say(p,"-time H (0-24), -reveal (toggle), -spawns on/off, -title N")
    call DevCommands_Say(p,"-dumpitems (item table file for tools/savecode.py)")
    call DevCommands_Say(p,"-queststate [N] (active/available quests, or one engine quest number)")
endfunction

function DevCommands_KillEnum takes nothing returns nothing
    if not IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO) or GetOwningPlayer(GetEnumUnit())!=GetTriggerPlayer() then
        call KillUnit(GetEnumUnit())
    endif
endfunction

function Trig_DevCommands_Chat_Conditions takes nothing returns boolean
    return DevCommands_Active()
endfunction

function Trig_DevCommands_Chat_Actions takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local string msg=GetEventPlayerChatString()
    local string cmd=StringCase(DevCommands_Arg(msg,0),false)
    local string a1=DevCommands_Arg(msg,1)
    local string a2=DevCommands_Arg(msg,2)
    local unit h=Player_GetHero(p)
    local integer n=S2I(a1)
    local integer i
    local group g
    if cmd=="-dev" then
        call DevCommands_Help(p)
    elseif cmd=="-gold" then
        call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+n)
        call DevCommands_Say(p,"+"+I2S(n)+" gold")
    elseif cmd=="-shards" then
        call SetPlayerState(p,PLAYER_STATE_RESOURCE_LUMBER,GetPlayerState(p,PLAYER_STATE_RESOURCE_LUMBER)+n)
        call DevCommands_Say(p,"+"+I2S(n)+" Crystal Shards")
    elseif cmd=="-bp" then
        set udg_BattlePoints[GetConvertedPlayerId(p)]=IMinBJ(udg_BattlePoints[GetConvertedPlayerId(p)]+n,999999)
        call DevCommands_Say(p,"Battle Points: "+I2S(udg_BattlePoints[GetConvertedPlayerId(p)]))
    elseif cmd=="-dumpitems" then
        call DevCommands_DumpItems(p)
    elseif cmd=="-queststate" then
        call DevCommands_QuestState(p,n)
    elseif h==null then
        call DevCommands_Say(p,"pick a hero first")
    elseif cmd=="-lvl" then
        if n>GetHeroLevel(h) then
            call SetHeroLevel(h,n,true)
        endif
        call DevCommands_Say(p,"hero level "+I2S(GetHeroLevel(h)))
    elseif cmd=="-heal" then
        call SetUnitState(h,UNIT_STATE_LIFE,GetUnitState(h,UNIT_STATE_MAX_LIFE))
        call SetUnitState(h,UNIT_STATE_MANA,GetUnitState(h,UNIT_STATE_MAX_MANA))
    elseif cmd=="-god" then
        set udg_DevGodMode=not udg_DevGodMode
        call SetUnitInvulnerable(h,udg_DevGodMode)
        if udg_DevGodMode then
            call DevCommands_Say(p,"god mode ON (hero invulnerable)")
        else
            call DevCommands_Say(p,"god mode OFF")
        endif
    elseif cmd=="-cd" then
        call UnitResetCooldown(h)
        call DevCommands_Say(p,"cooldowns reset")
    elseif cmd=="-item" then
        set i=DevCommands_RawCode(a1)
        if i==0 then
            call DevCommands_Say(p,"usage: -item I01Z")
        else
            call CreateItem(i,GetUnitX(h),GetUnitY(h))
        endif
    elseif cmd=="-unit" then
        set i=DevCommands_RawCode(a1)
        set n=IMaxBJ(1,IMinBJ(S2I(a2),20))
        if i==0 then
            call DevCommands_Say(p,"usage: -unit n00A 3")
        else
            loop
                exitwhen n<=0
                call CreateUnit(Player(11),i,GetUnitX(h)+GetRandomReal(-300,300),GetUnitY(h)+GetRandomReal(-300,300),270.)
                set n=n-1
            endloop
        endif
    elseif cmd=="-kill" then
        set g=CreateGroup()
        call SyncSelections()
        call GroupEnumUnitsSelected(g,p,null)
        call ForGroup(g,function DevCommands_KillEnum)
        call DestroyGroup(g)
        set g=null
    elseif cmd=="-tp" then
        if a1=="" then
            // single player only, so reading the local camera is safe
            call SetUnitPosition(h,GetCameraTargetPositionX(),GetCameraTargetPositionY())
        else
            call SetUnitPosition(h,S2R(a1),S2R(a2))
        endif
        call PanCameraToTimedForPlayer(p,GetUnitX(h),GetUnitY(h),0)
    elseif cmd=="-pos" then
        call DevCommands_Say(p,"hero at "+I2S(R2I(GetUnitX(h)))+" "+I2S(R2I(GetUnitY(h))))
    elseif cmd=="-time" then
        call SetFloatGameState(GAME_STATE_TIME_OF_DAY,S2R(a1))
    elseif cmd=="-reveal" then
        if udg_DevRevealFog==null then
            set udg_DevRevealFog=CreateFogModifierRect(p,FOG_OF_WAR_VISIBLE,GetPlayableMapRect(),true,false)
            call FogModifierStart(udg_DevRevealFog)
            call DevCommands_Say(p,"map revealed")
        else
            call DestroyFogModifier(udg_DevRevealFog)
            set udg_DevRevealFog=null
            call DevCommands_Say(p,"map hidden again")
        endif
    elseif cmd=="-spawns" then
        set udg_SpawnsPaused=(StringCase(a1,false)=="off")
        if udg_SpawnsPaused then
            call DevCommands_Say(p,"monster spawns paused")
        else
            call DevCommands_Say(p,"monster spawns on")
        endif
    elseif cmd=="-title" then
        static if LIBRARY_TTitle then
            set udg_TempPlayer=p
            set udg_TempInteger=n
            call TriggerExecute(gg_trg_Title_Grant)
        else
            call DevCommands_Say(p,"the Title module is switched off")
        endif
    endif
    set h=null
    set p=null
endfunction

function Trig_DevCommands_Announce_Actions takes nothing returns nothing
    if DevCommands_Active() then
        call DevCommands_Say(GetLocalPlayer(),"Developer test commands are ON. Type -dev for the list.")
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DevCommands automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DevCommands (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DevCommands takes nothing returns nothing
endfunction

function Register_DevCommands_Chat takes nothing returns nothing
    local integer i=0
    set gg_trg_DevCommands_Chat=CreateTrigger()
    loop
        exitwhen i>7
        call TriggerRegisterPlayerChatEvent(gg_trg_DevCommands_Chat,Player(i),"-",false)
        set i=i+1
    endloop
    call TriggerAddCondition(gg_trg_DevCommands_Chat,Condition(function Trig_DevCommands_Chat_Conditions))
    call TriggerAddAction(gg_trg_DevCommands_Chat,function Trig_DevCommands_Chat_Actions)
endfunction

function Register_DevCommands_Announce takes nothing returns nothing
    set gg_trg_DevCommands_Announce=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_DevCommands_Announce,5.)
    call TriggerAddAction(gg_trg_DevCommands_Announce,function Trig_DevCommands_Announce_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DevCommands takes nothing returns nothing
    call Register_DevCommands_Chat()
    call Register_DevCommands_Announce()
endfunction

endlibrary

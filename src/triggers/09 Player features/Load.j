library TLoad requires TCmd, TPlayerHero, TSave
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Load_Warn_5Min=null
    trigger gg_trg_Load_Disable=null
    // Variables only this module uses.
    unit udg_CodeInputUnit
    trigger udg_LoadCodeOwnerTrig
    trigger udg_LoadCodeSpellTrig
    string udg_LoadCodeBuffer
    integer udg_LoadCharValue
    boolean udg_LoadBracketOpened
    boolean udg_LoadHasHighBits
    trigger udg_LoadFileTrigger=null
endglobals

function Load_TypeCodeWithUIKeys takes string l_code,player p returns nothing
    local integer i=0
    local integer l_len
    local integer l_hi
    local integer l_lo
    local integer l_charIdx
    local string l_ch
    if(GetOwningPlayer(udg_CodeInputUnit)!=Player(PLAYER_NEUTRAL_PASSIVE))then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,GetPlayerName(GetOwningPlayer(udg_CodeInputUnit))+" is loading. Please try again later.")
        return
    endif
    call SetUnitOwner(udg_CodeInputUnit,p,false)
    if(GetLocalPlayer()==p)then
        call ClearSelection()
        call SelectUnit(udg_CodeInputUnit,true)
    endif
    call TriggerSleepAction(.0)
    if(GetLocalPlayer()==p)then
        if(l_code!=null)then
            set bj_forLoopAIndex=1
            set l_len=StringLength(l_code)
            loop
                exitwhen i>=l_len
                set l_ch=SubString(l_code,i,i+1)
                if(l_ch=="(" or l_ch==")")then
                    call ForceUIKey("J")
                else
                    set l_charIdx=Trig_Cmd_Load_Code_CharToValue(l_ch)
                    set l_hi=l_charIdx/ 8
                    // (l_charIdx) minus (((l_charIdx) divided by (8); drop the remainder) times (8)).
                    set l_lo=l_charIdx-(l_charIdx/ 8)*8
                    call ForceUIKey(SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_hi,l_hi+1))
                    call ForceUIKey(SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",l_lo,l_lo+1))
                endif
                set i=i+1
            endloop
        endif
        call ForceUIKey("I")
    endif
endfunction

function Load_OnCodeAbility takes nothing returns nothing
    if(GetSpellAbilityId()=='A0K7')then // 'A0K7': ability "Send: End Transmission"
        call TriggerSleepAction(.0)
        call SetUnitOwner(udg_CodeInputUnit,Player(PLAYER_NEUTRAL_PASSIVE),false)
    elseif(GetSpellAbilityId()=='A0N5')then // 'A0N5': ability "Send: Armory Brackets"
        if(not udg_LoadBracketOpened)then
            set udg_LoadCodeBuffer=udg_LoadCodeBuffer+"("
            set udg_LoadBracketOpened=true
        else
            set udg_LoadCodeBuffer=udg_LoadCodeBuffer+")"
            set udg_LoadBracketOpened=true
        endif
    else
        if(udg_LoadHasHighBits==false)then
            set udg_LoadCharValue=S2I(SubString(GetObjectName(GetSpellAbilityId()),6,7))
            set udg_LoadHasHighBits=true
        else
            set udg_LoadCharValue=(udg_LoadCharValue*8)+S2I(SubString(GetObjectName(GetSpellAbilityId()),6,7))
            set udg_LoadCodeBuffer=udg_LoadCodeBuffer+SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#",udg_LoadCharValue,udg_LoadCharValue+1)
            set udg_LoadHasHighBits=false
        endif
    endif
endfunction

function Load_OnCodeUnitOwnerChange takes nothing returns nothing
    if(GetOwningPlayer(GetChangingUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))then
        set udg_LoadCodeBuffer=""
        set udg_LoadHasHighBits=false
        set udg_LoadBracketOpened=false
    else
        call Trig_Cmd_Load_Code_LoadCodeDispatch(udg_LoadCodeBuffer,GetChangingUnitPrevOwner())
        if(GetLocalPlayer()==GetChangingUnitPrevOwner())then
            call ClearSelection()
            call SelectUnit(Player_GetHero(GetChangingUnitPrevOwner()),true)
        endif
    endif
endfunction

function Load_InitCodeUnit takes nothing returns nothing
    set udg_CodeInputUnit=gg_unit_n087_0053
    set udg_LoadCodeOwnerTrig=CreateTrigger()
    call TriggerRegisterUnitEvent(udg_LoadCodeOwnerTrig,udg_CodeInputUnit,EVENT_UNIT_CHANGE_OWNER)
    call TriggerAddAction(udg_LoadCodeOwnerTrig,function Load_OnCodeUnitOwnerChange)
    set udg_LoadCodeSpellTrig=CreateTrigger()
    call TriggerRegisterUnitEvent(udg_LoadCodeSpellTrig,udg_CodeInputUnit,EVENT_UNIT_SPELL_EFFECT)
    call TriggerAddAction(udg_LoadCodeSpellTrig,function Load_OnCodeAbility)
endfunction

function Load_OnLoadFile takes nothing returns nothing
    local boolean l_isLoadX=false
    local string l_oldName
    local string l_code
    local string l_fileName
    local integer l_playerCount=CountPlayersInForceBJ(udg_PlayingPlayers)
    if(not udg_HardcoreOff)then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Loading is not allowed in Hardcore mode!")
        return
    endif
    if(2==1 and l_playerCount>1)then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Cannot load from file in multiplayer.")
        return
    endif
    set l_fileName=GetEventPlayerChatString()
    if(StringLength(l_fileName)>6)then
        if(SubString(l_fileName,0,7)=="-loadx ")then
            set l_isLoadX=true
        elseif(SubString(l_fileName,0,7)!="-loadf ")then
            set l_fileName=null
            return
        endif
        set l_fileName=Trig_Cmd_Load_Code_TrimSpaces(SubString(l_fileName,7,StringLength(l_fileName)))
    else
        set l_fileName=null
    endif
    if(udg_HasLoadedCode[GetPlayerId(GetTriggerPlayer())])then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"|cFFFF0000Already Loaded!|r")
        set l_fileName=null
        return
    endif
    if(l_fileName==null or l_fileName=="")then
        set l_fileName="Last save"
    endif
    set l_fileName=l_fileName+".txt"
    set l_oldName=GetPlayerName(GetTriggerPlayer())
    if(GetLocalPlayer()==GetTriggerPlayer())then
        call Preloader(".\\FFERPG\\"+l_fileName)
    endif
    set l_code=GetPlayerName(GetTriggerPlayer())
    if(l_code==l_oldName)then
        call Save_WriteAllowLocalFilesBat(GetLocalPlayer()==GetTriggerPlayer())
        if(GetLocalPlayer()==GetTriggerPlayer())then
            call Preloader(udg_AllowLocalFilesPath)
        endif
        if(GetPlayerName(GetTriggerPlayer())=="Allow Local Files enabled")then
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Invalid filename. Cannot find \""+l_fileName+"\".")
        else
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"You have to enable \"Allow Local files\" if you want to use -loadf. Run \""+udg_AllowLocalFilesPath+"\" in Warcraft Folder\\FFERPG\\.")
        endif
        set l_code=null
    endif
    call SetPlayerName(GetTriggerPlayer(),l_oldName)
    if(l_playerCount==1 and not l_isLoadX)then
        call Trig_Cmd_Load_Code_LoadCodeDispatch(l_code,GetTriggerPlayer())
    else
        call Load_TypeCodeWithUIKeys(l_code,GetTriggerPlayer())
    endif
    set l_oldName=null
    set l_code=null
    set l_fileName=null
endfunction

function Load_InitFileCommands takes nothing returns nothing
    local integer i=0
    if(2==0)then
        return
    endif
    set udg_LoadFileTrigger=CreateTrigger()
    loop
        call TriggerRegisterPlayerChatEvent(udg_LoadFileTrigger,Player(i),"-loadf",false)
        call TriggerRegisterPlayerChatEvent(udg_LoadFileTrigger,Player(i),"-loadx",false)
        set i=i+1
        exitwhen i>7
    endloop
    call TriggerAddAction(udg_LoadFileTrigger,function Load_OnLoadFile)
endfunction

function Trig_Load_Warn_5Min_IsLoadEnabled takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Load_Warn_5Min_Actions takes nothing returns nothing
    if(Trig_Load_Warn_5Min_IsLoadEnabled())then
        call DisplayTextToForce(GetPlayersAll(),"|cffff0000The loading function will be disabled in 5 minutes.|r")
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Load_Disable_IsLoadActive takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Load_Disable_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Cmd_Load_Code)
    call DisableTrigger(udg_LoadFileTrigger)
    call DisableTrigger(gg_trg_Cmd_Load_Armory)
    if(Trig_Load_Disable_IsLoadActive())then
        call DisplayTextToForce(GetPlayersAll(),"The loading function is disabled now.")
        call ConditionalTriggerExecute(gg_trg_Bernkastel_Try_Spawn)
        call EnableTrigger(udg_AutosaveTimerTrig)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Load automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Load (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Load takes nothing returns nothing
endfunction

function Register_Load_Warn_5Min takes nothing returns nothing
    set gg_trg_Load_Warn_5Min=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Load_Warn_5Min,600.)
    call TriggerAddAction(gg_trg_Load_Warn_5Min,function Trig_Load_Warn_5Min_Actions)
endfunction

function Register_Load_Disable takes nothing returns nothing
    set gg_trg_Load_Disable=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Load_Disable,900.)
    call TriggerAddAction(gg_trg_Load_Disable,function Trig_Load_Disable_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Load takes nothing returns nothing
    call Register_Load_Warn_5Min()
    call Register_Load_Disable()
endfunction

endlibrary

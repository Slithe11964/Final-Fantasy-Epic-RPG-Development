globals
    image array GearWaveRune
    integer GearWaveMode=0
    real GearWaveStarted=-1.
    trigger GearWaveKeys=null
    trigger GearWaveCommands=null
    trigger GearWaveIceCommands=null
    trigger GearWaveCalculator=null
endglobals

function GearWave_Clear takes nothing returns nothing
    local integer i=1
    set GearWaveMode=0
    loop
        exitwhen i>64
        if GearWaveRune[i]!=null then
            call ShowImage(GearWaveRune[i],false)
        endif
        set i=i+1
    endloop
endfunction

function GearWave_ModeFor takes integer cast returns integer
    if cast=='A17S' or cast=='A0TM' or cast=='A0UY' then
        return 2
    elseif cast=='A08X' or cast=='A0Q0' or cast=='A0Q1' or cast=='A0Q2' or cast=='A0SM' or cast=='A0TP' or cast=='A0SA' or cast=='A150' then
        return 1
    endif
    return 0
endfunction

function GearWave_Arm takes integer cast returns nothing
    call GearWave_Clear()
    set GearWaveMode=GearWave_ModeFor(cast)
    set GearWaveStarted=TimerGetElapsed(NativeCDClock)
endfunction

function GearWave_Draw takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local unit focus=null
    local integer i=1
    local real x=QuickGearMouseX
    local real y=QuickGearMouseY
    local real angle
    local real direction
    local real distance
    if GearWaveMode==0 then
        set hero=null
        return
    endif
    if hero==null or not IsUnitSelected(hero,GetLocalPlayer()) or InventoryCinematicActive or QuickGearChatOpen or not BlzIsLocalClientActive() then
        call GearWave_Clear()
        set hero=null
        return
    endif
    set focus=BlzGetMouseFocusUnit()
    if focus!=null then
        set x=GetUnitX(focus)
        set y=GetUnitY(focus)
    endif
    set angle=Atan2(y-GetUnitY(hero),x-GetUnitX(hero))
    loop
        exitwhen i>64
        if GearWaveMode==1 then
            set distance=800.*I2R(i-1)/31.
            set direction=angle
        else
            set distance=1000.*I2R(ModuloInteger(i-1,21))/20.
            set direction=angle+(-11.25+22.5*I2R((i-1)/21))*bj_DEGTORAD
        endif
        if (GearWaveMode==1 and i<=32) or (GearWaveMode==2 and i<=63) then
            call SetImagePosition(GearWaveRune[i],GetUnitX(hero)+distance*Cos(direction)-12.,GetUnitY(hero)+distance*Sin(direction)-12.,0.)
            call ShowImage(GearWaveRune[i],true)
        else
            call ShowImage(GearWaveRune[i],false)
        endif
        set i=i+1
    endloop
    set focus=null
    set hero=null
endfunction

function GearWave_Command takes nothing returns nothing
    if GetTriggerPlayer()==GetLocalPlayer() then
        call GearWave_Arm(GetSpellAbilityId())
    endif
endfunction

function GearWave_WaterCommand takes nothing returns nothing
    if GetTriggerPlayer()==GetLocalPlayer() then
        call GearWave_Arm('A08X')
    endif
endfunction

function GearWave_IceCommand takes nothing returns nothing
    if GetTriggerPlayer()==GetLocalPlayer() then
        call GearWave_Arm('A0UY')
    endif
endfunction

function GearWave_CalculatorArm takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    if GetTriggerPlayer()==GetLocalPlayer() and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) and GetUnitAbilityLevel(hero,'A17S')>0 and not QuickGearChatOpen and not TravelVisible[GetPlayerId(GetLocalPlayer())] then
        call GearWave_Arm('A17S')
    endif
    set hero=null
endfunction

function GearWave_CancelKey takes nothing returns nothing
    if GetTriggerPlayer()==GetLocalPlayer() then
        call GearWave_Clear()
    endif
endfunction

function GearWave_Reset takes nothing returns nothing
    local integer i=1
    call GearWave_Clear()
    loop
        exitwhen i>64
        if GearWaveRune[i]!=null and GetHandleId(GearWaveRune[i])!=-1 then
            call DestroyImage(GearWaveRune[i])
        endif
        set GearWaveRune[i]=null
        set i=i+1
    endloop
    if GearWaveKeys!=null then
        call DestroyTrigger(GearWaveKeys)
        call DestroyTrigger(GearWaveCommands)
        call DestroyTrigger(GearWaveIceCommands)
        call DestroyTrigger(GearWaveCalculator)
    endif
    set GearWaveKeys=null
    set GearWaveCommands=null
    set GearWaveIceCommands=null
    set GearWaveCalculator=null
endfunction

function GearWave_Init takes nothing returns nothing
    local integer i=1
    local integer pid=0
    loop
        exitwhen i>64
        set GearWaveRune[i]=CreateImage("GearWaveRune.tga",24.,24.,0.,0.,0.,0.,0.,0.,0.,2)
        call SetImageRenderAlways(GearWaveRune[i],true)
        call SetImageAboveWater(GearWaveRune[i],true,true)
        call ShowImage(GearWaveRune[i],false)
        set i=i+1
    endloop
    set GearWaveKeys=CreateTrigger()
    set GearWaveCommands=CreateTrigger()
    set GearWaveIceCommands=CreateTrigger()
    set GearWaveCalculator=CreateTrigger()
    call TriggerAddAction(GearWaveKeys,function GearWave_CancelKey)
    call TriggerAddAction(GearWaveCommands,function GearWave_WaterCommand)
    call TriggerAddAction(GearWaveIceCommands,function GearWave_IceCommand)
    call TriggerAddAction(GearWaveCalculator,function GearWave_CalculatorArm)
    loop
        exitwhen pid>=8
        call BlzTriggerRegisterPlayerKeyEvent(GearWaveKeys,Player(pid),OSKEY_ESCAPE,0,true)
        call BlzTriggerRegisterPlayerKeyEvent(GearWaveCalculator,Player(pid),OSKEY_E,0,true)
        set pid=pid+1
    endloop
    call BlzTriggerRegisterFrameEvent(GearWaveCalculator,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,BlzGetAbilityPosY('A17S')*4+BlzGetAbilityPosX('A17S')),FRAMEEVENT_CONTROL_CLICK)
    call TriggerRegisterCommandEvent(GearWaveCommands,'A08X',"carrionswarm")
    call TriggerRegisterCommandEvent(GearWaveCommands,'A0Q0',"carrionswarm")
    call TriggerRegisterCommandEvent(GearWaveCommands,'A0Q1',"carrionswarm")
    call TriggerRegisterCommandEvent(GearWaveCommands,'A0Q2',"carrionswarm")
    call TriggerRegisterCommandEvent(GearWaveIceCommands,'A0UY',"shockwave")
    call TriggerRegisterCommandEvent(GearWaveIceCommands,'A0TM',"shockwave")
    call TriggerRegisterCommandEvent(GearWaveIceCommands,'A17S',"shockwave")
endfunction

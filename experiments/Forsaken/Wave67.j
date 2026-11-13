globals
    image array IceAreaRune65
    image array WaterMiddle67
    image array IceEdge67
    real array IceEdgeX67
    real array IceEdgeY67
    integer GearWaveCast67=0
endglobals

function Wave65_WaterWidth takes real distance returns real
    return 100.+200.*distance/800.
endfunction

function Wave67_BuildEdge takes nothing returns nothing
    local integer i=1
    local integer lane=0
    local integer step=1
    local real a=0.
    local real d=0.
    local real direction=0.
    local real projection=0.
    local real discriminant=0.
    local real reach=0.
    loop
        exitwhen i>64
        set a=(-101.25+225.*I2R(i-1)/63.)*bj_DEGTORAD
        set reach=0.
        set lane=0
        loop
            exitwhen lane>=3
            set direction=(-11.25+22.5*I2R(lane))*bj_DEGTORAD
            set step=1
            loop
                exitwhen step>5
                set d=200.*I2R(step)
                set projection=d*Cos(direction-a)
                set discriminant=40000.-d*d+projection*projection
                if discriminant>=0. then
                    set reach=RMaxBJ(reach,projection+SquareRoot(discriminant))
                endif
                set step=step+1
            endloop
            set lane=lane+1
        endloop
        set IceEdgeX67[i]=reach*Cos(a)
        set IceEdgeY67[i]=reach*Sin(a)
        set i=i+1
    endloop
endfunction

function Wave67_Init takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>63
        // Twice the 48-unit water glyph, instead of overlapping 400-unit circles.
        set IceAreaRune65[i]=CreateImage("GearWaveRune.tga",96.,96.,0.,0.,0.,0.,0.,0.,0.,2)
        call SetImageRenderAlways(IceAreaRune65[i],true)
        call SetImageAboveWater(IceAreaRune65[i],true,true)
        call ShowImage(IceAreaRune65[i],false)
        set i=i+1
    endloop
    call Wave67_BuildEdge()
    set i=1
    loop
        exitwhen i>64
        set IceEdge67[i]=CreateImage("GearWaveRune.tga",48.,48.,0.,0.,0.,0.,0.,0.,0.,2)
        call SetImageRenderAlways(IceEdge67[i],true)
        call SetImageAboveWater(IceEdge67[i],true,true)
        call SetImageColor(IceEdge67[i],255,255,255,170)
        call ShowImage(IceEdge67[i],false)
        if i<=17 then
            set WaterMiddle67[i]=CreateImage("GearWaveRune.tga",96.,96.,0.,0.,0.,0.,0.,0.,0.,2)
            call SetImageRenderAlways(WaterMiddle67[i],true)
            call SetImageAboveWater(WaterMiddle67[i],true,true)
            call ShowImage(WaterMiddle67[i],false)
        endif
        set i=i+1
    endloop
endfunction

function Wave67_Clear takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>63
        if IceAreaRune65[i]!=null then
            call ShowImage(IceAreaRune65[i],false)
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>64
        if IceEdge67[i]!=null then
            call ShowImage(IceEdge67[i],false)
        endif
        if i<=17 and WaterMiddle67[i]!=null then
            call ShowImage(WaterMiddle67[i],false)
        endif
        set i=i+1
    endloop
endfunction

function Wave67_Reset takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>63
        if IceAreaRune65[i]!=null then
            call DestroyImage(IceAreaRune65[i])
            set IceAreaRune65[i]=null
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>64
        if IceEdge67[i]!=null then
            call DestroyImage(IceEdge67[i])
            set IceEdge67[i]=null
        endif
        if i<=17 and WaterMiddle67[i]!=null then
            call DestroyImage(WaterMiddle67[i])
            set WaterMiddle67[i]=null
        endif
        set i=i+1
    endloop
endfunction

function Wave67_Draw takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local unit focus=null
    local integer i=1
    local real x=QuickGearMouseX
    local real y=QuickGearMouseY
    local real angle=0.
    local real direction=0.
    local real distance=0.
    local real across=0.
    local real width=0.
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
        if GearWaveMode==1 and i<=63 then
            if i<=17 then
                // Center path.
                set distance=800.*I2R(i-1)/16.
                set across=0.
            elseif i<=51 then
                // Both widening edges, inset by the glyph's visible radius.
                set distance=800.*I2R(ModuloInteger(i-18,17))/16.
                set width=Wave65_WaterWidth(distance)-22.
                if i<=34 then
                    set across=width
                else
                    set across=-width
                endif
            elseif i<=58 then
                set distance=778.
                set across=-278.+556.*I2R(i-52)/6.
            else
                set distance=22.
                set across=-78.+156.*I2R(i-59)/4.
            endif
            if i<=17 and (GearWaveCast67=='A08X' or GearWaveCast67=='A0Q2') then
                call SetImagePosition(WaterMiddle67[i],GetUnitX(hero)+distance*Cos(angle)-48.,GetUnitY(hero)+distance*Sin(angle)-48.,0.)
                call ShowImage(WaterMiddle67[i],true)
                call ShowImage(GearWaveRune[i],false)
            else
                call SetImagePosition(GearWaveRune[i],GetUnitX(hero)+distance*Cos(angle)-across*Sin(angle)-24.,GetUnitY(hero)+distance*Sin(angle)+across*Cos(angle)-24.,0.)
                call ShowImage(GearWaveRune[i],true)
            endif
        else
            call ShowImage(GearWaveRune[i],false)
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>64
        if GearWaveMode==2 then
            call SetImagePosition(IceEdge67[i],GetUnitX(hero)+IceEdgeX67[i]*Cos(angle)-IceEdgeY67[i]*Sin(angle)-24.,GetUnitY(hero)+IceEdgeX67[i]*Sin(angle)+IceEdgeY67[i]*Cos(angle)-24.,0.)
            call ShowImage(IceEdge67[i],IceEdgeX67[i]*IceEdgeX67[i]+IceEdgeY67[i]*IceEdgeY67[i]>1.)
        else
            call ShowImage(IceEdge67[i],false)
        endif
        if i<=17 and (GearWaveMode!=1 or (GearWaveCast67!='A08X' and GearWaveCast67!='A0Q2')) then
            call ShowImage(WaterMiddle67[i],false)
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>63
        if GearWaveMode==2 then
            // Three readable paths. 1200 includes the last pulse's 200 radius.
            set distance=1200.*I2R(ModuloInteger(i-1,21))/20.
            set direction=angle+(-11.25+22.5*I2R((i-1)/21))*bj_DEGTORAD
            call SetImagePosition(IceAreaRune65[i],GetUnitX(hero)+distance*Cos(direction)-48.,GetUnitY(hero)+distance*Sin(direction)-48.,0.)
            call ShowImage(IceAreaRune65[i],true)
        else
            call ShowImage(IceAreaRune65[i],false)
        endif
        set i=i+1
    endloop
    set focus=null
    set hero=null
endfunction

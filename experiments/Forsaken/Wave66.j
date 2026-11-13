globals
    image array IceAreaRune65
endglobals

function Wave65_WaterWidth takes real distance returns real
    return 100.+200.*distance/800.
endfunction

function Wave66_Init takes nothing returns nothing
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
endfunction

function Wave66_Clear takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>63
        if IceAreaRune65[i]!=null then
            call ShowImage(IceAreaRune65[i],false)
        endif
        set i=i+1
    endloop
endfunction

function Wave66_Reset takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>63
        if IceAreaRune65[i]!=null then
            call DestroyImage(IceAreaRune65[i])
            set IceAreaRune65[i]=null
        endif
        set i=i+1
    endloop
endfunction

function Wave66_Draw takes nothing returns nothing
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
            call SetImagePosition(GearWaveRune[i],GetUnitX(hero)+distance*Cos(angle)-across*Sin(angle)-24.,GetUnitY(hero)+distance*Sin(angle)+across*Cos(angle)-24.,0.)
            call ShowImage(GearWaveRune[i],true)
        else
            call ShowImage(GearWaveRune[i],false)
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

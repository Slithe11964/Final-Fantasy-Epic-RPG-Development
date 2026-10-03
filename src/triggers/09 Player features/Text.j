library TText
globals
    // Variables only this module uses.
    constant real udg_TextSpeedFast=300
    string array udg_IntStringCache
endglobals

function Text_Transmission takes unit l_speaker,string l_name,string l_msg,string l_skipText,sound l_snd,real l_dur,boolean l_forced returns nothing
    local real l_chars
    local integer i
    local real l_rest
    if(not l_forced and(udg_TextSpeed==0 or udg_CinematicSkipped))then
        return
    endif
    if(l_skipText==null or l_skipText=="(null)")then
        set l_chars=StringLength(l_msg)*.2
    else
        set l_chars=(StringLength(l_msg)-StringLength(l_skipText))*.2
    endif
    if(l_dur>0)then
        set bj_lastTransmissionDuration=l_dur
    elseif(l_forced)then
        // (1) plus (((l_chars) divided by (udg_TextSpeedFast)) times (60)).
        set bj_lastTransmissionDuration=1+(l_chars/ udg_TextSpeedFast*60.)
    else
        // (1) plus (((l_chars) divided by (udg_TextSpeed)) times (60)).
        set bj_lastTransmissionDuration=1+(l_chars/ udg_TextSpeed*60.)
    endif
    if(l_name==null)then
        if(l_speaker==null)then
        elseif(GetPlayerController(GetOwningPlayer(l_speaker))==MAP_CONTROL_USER)then
            set l_name=udg_PlayerName[GetPlayerId(GetOwningPlayer(l_speaker))+1]
        elseif(IsUnitType(l_speaker,UNIT_TYPE_HERO))then
            set l_name=GetHeroProperName(l_speaker)
        else
            set l_name=GetUnitName(l_speaker)
        endif
    endif
    if(l_snd!=null)then
        call StartSound(l_snd)
        set bj_lastTransmissionDuration=RMaxBJ(bj_lastTransmissionDuration,I2R(GetSoundDuration(l_snd))*.001)
    endif
    if(l_speaker==null)then
        call SetCinematicScene(0,PLAYER_COLOR_RED,l_name,l_msg,bj_lastTransmissionDuration+bj_TRANSMISSION_PORT_HANGTIME,bj_lastTransmissionDuration)
    else
        call SetCinematicScene(GetUnitTypeId(l_speaker),GetPlayerColor(GetOwningPlayer(l_speaker)),l_name,l_msg,bj_lastTransmissionDuration+bj_TRANSMISSION_PORT_HANGTIME,bj_lastTransmissionDuration)
        call PingMinimap(GetUnitX(l_speaker),GetUnitY(l_speaker),bj_TRANSMISSION_PING_TIME)
        if(not IsUnitHidden(l_speaker))then
            call UnitAddIndicator(l_speaker,bj_TRANSMISSION_IND_RED,bj_TRANSMISSION_IND_BLUE,bj_TRANSMISSION_IND_GREEN,bj_TRANSMISSION_IND_ALPHA)
        endif
    endif
    if(l_forced or l_dur>0 or bj_lastTransmissionDuration<=2.5)then
        call TriggerSleepAction(bj_lastTransmissionDuration)
    else
        set l_rest=bj_lastTransmissionDuration-2.
        call TriggerSleepAction(2.)
        if(not udg_CinematicSkipped)then
            call TriggerSleepAction(l_rest)
        endif
    endif
endfunction

function Text_Say takes unit l_speaker,string l_msg,boolean l_forced returns nothing
    call Text_Transmission(l_speaker,null,l_msg,null,null,0,l_forced)
endfunction

function Text_IntToString takes integer i returns string
    if(i<8192)then
        if(udg_IntStringCache[i]==null)then
            set udg_IntStringCache[i]=I2S(i)
        endif
        return udg_IntStringCache[i]
    else
        return I2S(i)
    endif
endfunction

function Text_FloatingDamage takes unit u,boolean l_isHeal,integer l_msgType,real l_amount,boolean mp,integer l_colorIdx returns nothing
    local texttag l_tag
    local real l_size=.02
    local real x=GetUnitX(u)
    local real y=GetUnitY(u)
    if(udg_InCinematicMode or not udg_ShowDamageText or IsUnitHidden(u))then
        set u=null
        return
    endif
    set l_tag=CreateTextTag()
    if l_isHeal then
        set l_size=.028
        call SetTextTagColor(l_tag,0,$FF,0,$FF) // $FF = 255
    elseif(l_colorIdx>0)then
        if(l_colorIdx==1)then
            call SetTextTagColor(l_tag,$FF,$DC,25,$FF) // $FF = 255; $DC = 220
        elseif(l_colorIdx==2)then
            call SetTextTagColor(l_tag,$FF,0,0,$FF) // $FF = 255
        elseif(l_colorIdx==3)then
            call SetTextTagColor(l_tag,$7F,$CD,$FF,$FF) // $7F = 127; $CD = 205; $FF = 255
        elseif(l_colorIdx==4)then
            call SetTextTagColor(l_tag,$FF,'x',0,$FF) // $FF = 255
        endif
    endif
    if(l_msgType==0)then
        if mp then
            call SetTextTagText(l_tag,Text_IntToString(R2I(l_amount+.5))+" MP",l_size)
        else
            call SetTextTagText(l_tag,Text_IntToString(R2I(l_amount+.5)),l_size)
        endif
    elseif(l_msgType==1)then
        call SetTextTagText(l_tag,"Miss",l_size)
    elseif(l_msgType==2)then
        call SetTextTagText(l_tag,"Block",l_size)
    elseif(l_msgType==3)then
        call SetTextTagText(l_tag,"Immune",l_size)
    elseif(l_msgType==4)then
        call SetTextTagText(l_tag,"Recovery",l_size)
    elseif(l_msgType==5)then
        call SetTextTagText(l_tag,"Absorb",l_size)
    elseif(l_msgType==6)then
        call SetTextTagText(l_tag,"DEATH",l_size)
    endif
    if mp then
        call SetTextTagPos(l_tag,x,y-64.,0)
    else
        call SetTextTagPos(l_tag,x,y,0)
    endif
    call SetTextTagVelocity(l_tag,0,.036)
    call SetTextTagPermanent(l_tag,false)
    call SetTextTagLifespan(l_tag,1.)
    call SetTextTagFadepoint(l_tag,.1)
    if(not IsPlayerInForce(GetLocalPlayer(),udg_TrackedPlayers)or not IsUnitVisible(u,GetLocalPlayer())or IsUnitFogged(u,GetLocalPlayer()))then
        call SetTextTagVisibility(l_tag,false)
    endif
    set u=null
    set l_tag=null
endfunction

function InitTrig_Text takes nothing returns nothing
endfunction

endlibrary

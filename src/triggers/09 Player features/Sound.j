library TSound
globals
    // Variables only this module uses.
    sound gg_snd_001
endglobals

function Sound_PlayError takes player l_p,string l_msg returns nothing
    if(GetLocalPlayer()==l_p)then
        call StartSound(gg_snd_001)
    endif
endfunction

function Sound_InitError takes nothing returns nothing
    set gg_snd_001=CreateSoundFromLabel("InterfaceError",false,false,false,$A,$A) // $A = 10
endfunction

function InitTrig_Sound takes nothing returns nothing
endfunction

endlibrary

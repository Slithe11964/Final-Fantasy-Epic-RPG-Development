library TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Music_Prelude=null
    // Variables only this module uses.
    string udg_PreludeMusic="war3mapImported\\FF7Prelude.mp3"
    string array udg_MusicPlayingFile
endglobals

function Music_InitTracks takes nothing returns nothing
    local integer i=0
    loop
        exitwhen i>=8
        set udg_MusicEnabled[i]=true
        set udg_MusicUseCustom[i]=false
        set udg_MusicAnnounce[i]=false
        set udg_MusicPathPrefix[i]=""
        set udg_MusicPlayingFile[i]="war3mapImported\\FF7Prelude.mp3"
        set i=i+1
    endloop
    set udg_MusicBlizzTrack[1]="Human1"
    set udg_MusicBlizzTrack[2]="BloodElfTheme"
    set udg_MusicBlizzTrack[3]="PursuitTheme"
    set udg_MusicBlizzTrack[4]="Human2"
    set udg_MusicBlizzTrack[5]="HumanX1"
    set udg_MusicBlizzTrack[6]="Orc2"
    set udg_MusicBlizzTrack[7]="NightElf1"
    set udg_MusicBlizzTrack[8]="NightElf1"
    set udg_MusicBlizzTrack[9]="NightElf2"
    set udg_MusicBlizzTrack[$A]="NightElfX1" // $A = 10
    set udg_MusicBlizzTrack[$B]="NightElf3" // $B = 11
    set udg_MusicBlizzTrack[$C]="NightElf3" // $C = 12
    set udg_MusicBlizzTrack[$D]="UndeadX1" // $D = 13
    set udg_MusicBlizzTrack[$E]="NightElfX1" // $E = 14
    set udg_MusicBlizzTrack[$F]="UndeadX1" // $F = 15
    set udg_MusicBlizzTrack[16]="UndeadX1"
    set udg_MusicBlizzTrack[17]="UndeadX1"
    set udg_MusicBlizzTrack[18]="UndeadX1"
    set udg_MusicBlizzTrack[49]="War3XMainScreen"
    set udg_MusicBlizzTrack[50]="Mainscreen"
    set udg_MusicCustomTrack[1]="ffeMQ1"
    set udg_MusicCustomTrack[2]="ffeMQ2"
    set udg_MusicCustomTrack[3]="ffeBtl"
    set udg_MusicCustomTrack[4]="ffeMQ2"
    set udg_MusicCustomTrack[5]="ffeMQ4"
    set udg_MusicCustomTrack[6]="ffeMQ5"
    set udg_MusicCustomTrack[7]="ffeMQ6"
    set udg_MusicCustomTrack[8]="ffeMQ6p"
    set udg_MusicCustomTrack[9]="ffeMQ7"
    set udg_MusicCustomTrack[$A]="ffeMQ8" // $A = 10
    set udg_MusicCustomTrack[$B]="ffeMQ9" // $B = 11
    set udg_MusicCustomTrack[$C]="ffeMQ4" // $C = 12
    set udg_MusicCustomTrack[$D]="ffeZB1" // $D = 13
    set udg_MusicCustomTrack[$E]="ffeFast1" // $E = 14
    set udg_MusicCustomTrack[$F]="ffeHash" // $F = 15
    set udg_MusicCustomTrack[16]="ffeFast2"
    set udg_MusicCustomTrack[17]="ffeEch"
    set udg_MusicCustomTrack[18]="ffeFast3"
    set udg_MusicCustomTrack[19]="ffeAnx"
    set udg_MusicCustomTrack[20]="ffeT1"
    set udg_MusicCustomTrack[21]="ffeT2"
    set udg_MusicCustomTrack[22]="ffeT3"
    set udg_MusicCustomTrack[23]="ffeWp1"
    set udg_MusicCustomTrack[24]="ffeRodP"
    set udg_MusicCustomTrack[25]="ffeGil2"
    set udg_MusicCustomTrack[26]="ffeRodJM"
    set udg_MusicCustomTrack[27]="ffeRodD"
    set udg_MusicCustomTrack[28]="ffeRodDF1"
    set udg_MusicCustomTrack[29]="ffeRodDF2"
    set udg_MusicCustomTrack[30]="ffeGil1"
    set udg_MusicCustomTrack[31]="ffeShem"
    set udg_MusicCustomTrack[32]="ffeShd"
    set udg_MusicCustomTrack[33]="ffeMB1"
    set udg_MusicCustomTrack[34]="ffeSE"
    set udg_MusicCustomTrack[35]="ffeMB2"
    set udg_MusicCustomTrack[36]="ffeHF"
    set udg_MusicCustomTrack[37]="ffeMld"
    set udg_MusicCustomTrack[38]="ffeFM"
    set udg_MusicCustomTrack[39]="ffeKS1"
    set udg_MusicCustomTrack[40]="ffeKS2"
    set udg_MusicCustomTrack[41]="ffeBtl"
    set udg_MusicCustomTrack[42]="ffeKS2"
    set udg_MusicCustomTrack[43]="ffeArn"
    set udg_MusicCustomTrack[44]="ffeWp1"
    set udg_MusicCustomTrack[45]="ffeAS"
    set udg_MusicCustomTrack[46]="ffeChc"
    set udg_MusicCustomTrack[47]="ffeWp2"
    set udg_MusicCustomTrack[48]="ffeZB2"
    set udg_MusicCustomTrack[49]="ffeA1"
    set udg_MusicCustomTrack[50]="ffeA2"
    set udg_MusicCustomTrack[51]="ffeA3"
    set udg_MusicCustomTrack[52]="ffeA4"
    set udg_MusicCustomTrack[53]="ffeUmi1"
    set udg_MusicCustomTrack[54]="ffeRodO"
    set udg_MusicCustomTrack[55]="ffeRodSO"
    set udg_MusicCustomTrack[56]="ffeOd"
endfunction

function Music_PlayFile takes player p,string l_filePath returns nothing
    local integer i=GetPlayerId(p)
    if(l_filePath!=udg_MusicPlayingFile[i])then
        set udg_MusicPlayingFile[i]=l_filePath
        if(GetLocalPlayer()==p and GetSoundFileDuration(l_filePath)>0)then
            call PlayMusic(l_filePath)
        endif
    endif
endfunction

function Music_PlayTrack takes player p,string l_trackName,boolean l_useCustom,boolean l_respectSetting returns nothing
    local integer i=GetPlayerId(p)
    local string l_blizzPath="Sound\\Music\\mp3Music\\"+l_trackName+".mp3"
    local string l_filePath
    if(IsPlayerInForce(p,udg_PlayingPlayers)and(not l_respectSetting or udg_MusicEnabled[i]))then
        if l_useCustom then
            set l_filePath=udg_MusicPathPrefix[i]+l_trackName+".mp3"
            if udg_MusicAnnounce[i]then
                call DisplayTimedTextToPlayer(p,0,0,$F,"|cff00ffffNow playing track:|r "+l_trackName+".mp3") // $F = 15
            endif
        else
            set l_filePath=l_blizzPath
        endif
        call Music_PlayFile(p,l_filePath)
    endif
endfunction

function Music_PlayIndexAll takes integer l_trackIdx returns nothing
    local integer i=0
    local boolean l_useCustom
    local string l_trackName
    loop
        exitwhen i>=8
        set l_useCustom=udg_MusicUseCustom[i]
        if l_useCustom then
            set l_trackName=udg_MusicCustomTrack[l_trackIdx]
        else
            set l_trackName=udg_MusicBlizzTrack[l_trackIdx]
        endif
        call Music_PlayTrack(Player(i),l_trackName,l_useCustom,true)
        set i=i+1
    endloop
endfunction

function Music_SetTrack takes integer l_trackIdx returns nothing
    if udg_MusicSpecialTrack!=l_trackIdx then
        set udg_MusicSpecialTrack=l_trackIdx
        call Music_PlayIndexAll(l_trackIdx)
    endif
endfunction

function Music_SetZoneTrack takes integer l_trackIdx returns nothing
    set udg_MusicZoneTrack=l_trackIdx
    call Music_PlayIndexAll(l_trackIdx)
endfunction

function Music_ClearTrack takes integer l_trackIdx returns nothing
    if udg_MusicSpecialTrack==l_trackIdx then
        set udg_MusicSpecialTrack=0
        call Music_PlayIndexAll(udg_MusicZoneTrack)
    endif
endfunction

function Trig_Music_Prelude_Actions takes nothing returns nothing
    call PlayMusicBJ(udg_PreludeMusic)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Music automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Music (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Music takes nothing returns nothing
endfunction

function Register_Music_Prelude takes nothing returns nothing
    set gg_trg_Music_Prelude=CreateTrigger()
    call TriggerAddAction(gg_trg_Music_Prelude,function Trig_Music_Prelude_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Music takes nothing returns nothing
    call Register_Music_Prelude() // run by MapBootstrap
endfunction

endlibrary

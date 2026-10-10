library TTitles requires TJob, TPlayerHero, TTitle
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Titles_Init=null
    trigger gg_trg_Titles_CheckAll=null
    trigger gg_trg_Titles_CheckBasic=null
    trigger gg_trg_Titles_MonographPickup=null
    boolean array ChroniclesMonographSeen
    integer array ChroniclesMonographCount
    integer array ChroniclesLevels
    string array ChroniclesTooltipBase
    string array ChroniclesTooltipShown
    string array ChroniclesNameBase
    string ChroniclesRootBase=""
    string ChroniclesRootShown=""
    string ChroniclesSecretsBase=""
    integer ChroniclesTooltipOffset=0
    string ChroniclesSecretsShown=""
endglobals

function Chronicles_MonographIndex takes integer raw returns integer
    if raw=='I0EI' then
        return 0
    elseif raw=='I0EF' then
        return 1
    elseif raw=='I0EG' then
        return 2
    elseif raw=='I0EJ' then
        return 3
    elseif raw=='I0EH' then
        return 4
    elseif raw=='I0EM' then
        return 5
    elseif raw=='I0EK' then
        return 6
    elseif raw=='I0EL' then
        return 7
    elseif raw=='I0EO' then
        return 8
    elseif raw=='I0EN' then
        return 9
    endif
    return -1
endfunction

function Chronicles_RecordMonograph takes player p,integer raw returns nothing
    local integer index=Chronicles_MonographIndex(raw)
    local integer pid=GetPlayerId(p)+1
    local integer key=pid*10+index
    local player previousPlayer=udg_TempPlayer
    local integer previousTitle=udg_TempInteger
    if index<0 or IsPlayerInForce(p,udg_PlayingPlayers)==false or IsPlayerInForce(p,udg_TitleForce[59]) then
        return
    endif
    if not ChroniclesMonographSeen[key] then
        set ChroniclesMonographSeen[key]=true
        set ChroniclesMonographCount[pid]=ChroniclesMonographCount[pid]+1
        if ChroniclesMonographCount[pid]==10 then
            set udg_TempPlayer=p
            set udg_TempInteger=59
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
            set udg_TempPlayer=previousPlayer
            set udg_TempInteger=previousTitle
        endif
    endif
    set previousPlayer=null
endfunction

function Chronicles_MonographPickup takes nothing returns nothing
    local unit u=GetTriggerUnit()
    local player p=GetOwningPlayer(u)
    if u==Player_GetHero(p) or u==udg_SpiritOfGaya[GetPlayerId(p)+1] then
        if UnitHasItem(u,GetManipulatedItem()) then
            call Chronicles_RecordMonograph(p,GetItemTypeId(GetManipulatedItem()))
        endif
    endif
    set u=null
    set p=null
endfunction

function Chronicles_CheckInventory takes player p returns nothing
    local integer i=0
    local unit hero=Player_GetHero(p)
    local unit spirit=udg_SpiritOfGaya[GetPlayerId(p)+1]
    if IsPlayerInForce(p,udg_TitleForce[59]) or hero==null then
        set hero=null
        set spirit=null
        return
    endif
    loop
        exitwhen i>=6
        call Chronicles_RecordMonograph(p,GetItemTypeId(UnitItemInSlot(hero,i)))
        call Chronicles_RecordMonograph(p,GetItemTypeId(UnitItemInSlot(spirit,i)))
        set i=i+1
    endloop
    set hero=null
    set spirit=null
endfunction

function Chronicles_Progress takes player p,integer category returns string
    local integer i=1
    local integer unlocked=0
    local integer total=0
    loop
        exitwhen i>65
        if udg_TitleName[i]!="" and udg_TitleChronicleIndex[i]>0 and (category==0 or udg_TitleChronicleIndex[i]==category) then
            set total=total+1
            if udg_TitleChronicleIndex[i]!=11 and IsPlayerInForce(p,udg_TitleForce[i]) then
                set unlocked=unlocked+1
            endif
        endif
        set i=i+1
    endloop
    if category==0 or category==11 then
        set unlocked=unlocked+IMinBJ(udg_SpeedrunLevel[GetPlayerId(p)+1],5)
    endif
    return I2S(unlocked)+" / "+I2S(total)
endfunction

function Chronicles_RestoreSecrets takes player p returns nothing
    local unit spirit=udg_SpiritOfGaya[GetPlayerId(p)+1]
    if spirit!=null then
        if IsPlayerInForce(p,udg_TitleForce[59]) then
            call SetUnitAbilityLevel(spirit,'cKeg',2)
            call SetPlayerAbilityAvailable(p,'A0AR',true)
            call SetPlayerAbilityAvailable(p,'cSec',true)
            call SetPlayerAbilityAvailable(p,'cKeg',true)
        else
            call SetUnitAbilityLevel(spirit,'cKeg',1)
            call SetPlayerAbilityAvailable(p,'cSec',false)
            call SetPlayerAbilityAvailable(p,'cKeg',false)
        endif
        call SetUnitAbilityLevel(spirit,'A10C',udg_SpeedrunLevel[GetPlayerId(p)+1]+1)
    endif
    set spirit=null
endfunction

function Chronicles_RefreshTooltips takes nothing returns nothing
    local player p=GetLocalPlayer()
    local integer category=1
    local integer level
    local integer key
    local integer found=ChroniclesMonographCount[GetPlayerId(p)+1]
    local string progress
    local string tooltip
    if IsPlayerInForce(p,udg_TitleForce[59]) then
        set found=10
    endif
    loop
        exitwhen category>12
        set progress=Chronicles_Progress(p,category)
        set level=GetUnitAbilityLevel(udg_SpiritOfGaya[GetPlayerId(p)+1],udg_ChronicleAbility[category])-1
        if level>=0 and level<ChroniclesLevels[category] then
            set key=category*64+level
            set tooltip=ChroniclesTooltipBase[key]+"|n|n|cffffcc00Chronicles unlocked:|r "+progress
            if category==12 then
                set tooltip=tooltip+"|nMonographs held this game: "+I2S(found)+" / 10"
            endif
            if tooltip!=ChroniclesTooltipShown[key] then
                call BlzSetAbilityTooltip(udg_ChronicleAbility[category],ChroniclesNameBase[key],level+ChroniclesTooltipOffset)
                call BlzSetAbilityExtendedTooltip(udg_ChronicleAbility[category],tooltip,level+ChroniclesTooltipOffset)
                set ChroniclesTooltipShown[key]=tooltip
            endif
        endif
        set category=category+1
    endloop
    set tooltip=ChroniclesSecretsBase
    if tooltip!=ChroniclesSecretsShown then
        call BlzSetAbilityExtendedTooltip('cSec',tooltip,ChroniclesTooltipOffset)
        call BlzSetAbilityTooltip('cSec',"Secrets",ChroniclesTooltipOffset)
        set ChroniclesSecretsShown=tooltip
    endif
    set tooltip=ChroniclesRootBase+"|n|n|cffffcc00Chronicles unlocked:|r "+Chronicles_Progress(p,0)
    if tooltip!=ChroniclesRootShown then
        call BlzSetAbilityExtendedTooltip('A0AR',tooltip,ChroniclesTooltipOffset)
        set ChroniclesRootShown=tooltip
    endif
    set p=null
endfunction

function Chronicles_Tick takes nothing returns nothing
    local integer i=0
    loop
        exitwhen i>=8
        call Chronicles_CheckInventory(Player(i))
        call Chronicles_RestoreSecrets(Player(i))
        set i=i+1
    endloop
    call Chronicles_RefreshTooltips()
endfunction

function Chronicles_Init takes nothing returns nothing
    local integer category=1
    local integer level
    local integer key
    // Tooltip natives index levels from 0 in Reforged; if level 0 reads empty (seen in 1.29.2),
    // the game counts from 1, so read and write the tooltip one index higher.
    if StringLength(BlzGetAbilityExtendedTooltip('A0AR',0))==0 then
        set ChroniclesTooltipOffset=1
    endif
    set ChroniclesLevels[1]=8
    set ChroniclesLevels[2]=8
    set ChroniclesLevels[3]=8
    set ChroniclesLevels[4]=7
    set ChroniclesLevels[5]=32
    set ChroniclesLevels[6]=19
    set ChroniclesLevels[7]=20
    set ChroniclesLevels[8]=32
    set ChroniclesLevels[9]=8
    set ChroniclesLevels[10]=20
    set ChroniclesLevels[11]=6
    set ChroniclesLevels[12]=2
    loop
        exitwhen category>12
        set level=0
        loop
            exitwhen level>=ChroniclesLevels[category]
            set key=category*64+level
            set ChroniclesTooltipBase[key]=BlzGetAbilityExtendedTooltip(udg_ChronicleAbility[category],level+ChroniclesTooltipOffset)
            set ChroniclesNameBase[key]=BlzGetAbilityTooltip(udg_ChronicleAbility[category],level+ChroniclesTooltipOffset)
            set level=level+1
        endloop
        set category=category+1
    endloop
    set ChroniclesRootBase=BlzGetAbilityExtendedTooltip('A0AR',ChroniclesTooltipOffset)
    set ChroniclesSecretsBase=BlzGetAbilityExtendedTooltip('cSec',ChroniclesTooltipOffset)
    call Chronicles_Tick()
    call TimerStart(CreateTimer(),1.,true,function Chronicles_Tick)
endfunction

function Trig_Titles_Init_Title_BoostsPrimaryOnly takes nothing returns boolean
    return(udg_TitlePrimaryStatOnly[GetForLoopIndexA()])
endfunction

function Trig_Titles_Init_Title_HasStatBonus takes nothing returns boolean
    return(udg_BonusValue[GetForLoopIndexA()]>0)
endfunction

function Trig_Titles_Init_HideChronicleAbilities takes nothing returns nothing
    call SetPlayerAbilityAvailableBJ(false,'A0AR',GetEnumPlayer()) // 'A0AR': ability "Hero Chronicles"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call SetPlayerAbilityAvailableBJ(false,udg_ChronicleAbility[GetForLoopIndexA()],GetEnumPlayer())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call SetPlayerAbilityAvailableBJ(false,'cSec',GetEnumPlayer())
endfunction

function Trig_Titles_Init_Actions takes nothing returns nothing
    set udg_ChronicleAbility[1]='A0ZK' // 'A0ZK': ability "Warrior Prowess"
    set udg_ChronicleAbility[2]='A0ZL' // 'A0ZL': ability "Mage Prowess"
    set udg_ChronicleAbility[3]='A0ZJ' // 'A0ZJ': ability "Spirit of Gaya"
    set udg_ChronicleAbility[4]='A0ZI' // 'A0ZI': ability "General Mastery"
    set udg_ChronicleAbility[5]='A10D' // 'A10D': ability "Demons"
    set udg_ChronicleAbility[6]='A12B' // 'A12B': ability "Arena Conquest"
    set udg_ChronicleAbility[7]='A108' // 'A108': ability "Interdimensional Fiends"
    set udg_ChronicleAbility[8]='A109' // 'A109': ability "Summoning"
    set udg_ChronicleAbility[9]='A10A' // 'A10A': ability "Gear Collection"
    set udg_ChronicleAbility[$A]='A10B' // $A = 10; 'A10B': ability "Quests"
    set udg_ChronicleAbility[$B]='A10C' // $B = 11; 'A10C': ability "Time Trial"
    set udg_ChronicleAbility[12]='cKeg'
    set udg_TitleChronicleIndex[59]=12
    set udg_BonusValue[1]=$A // $A = 10
    set udg_BonusValue[4]=$A // $A = 10
    set udg_BonusValue[$B]=$A // $B = 11; $A = 10
    set udg_BonusValue[$F]=$A // $F = 15; $A = 10
    set udg_BonusValue[17]=20
    set udg_BonusValue[18]=$A // $A = 10
    set udg_BonusValue[20]=$A // $A = 10
    set udg_TitlePrimaryStatOnly[21]=true
    set udg_TitlePrimaryStatOnly[23]=true
    set udg_BonusValue[24]=$A // $A = 10
    set udg_TitlePrimaryStatOnly[24]=true
    set udg_BonusValue[25]=5
    set udg_TitlePrimaryStatOnly[25]=true
    set udg_BonusValue[26]=5
    set udg_TitlePrimaryStatOnly[26]=true
    set udg_BonusValue[27]=$A // $A = 10
    set udg_TitlePrimaryStatOnly[27]=true
    set udg_BonusValue[28]=$A // $A = 10
    set udg_TitlePrimaryStatOnly[28]=true
    set udg_BonusValue[29]=20
    set udg_TitlePrimaryStatOnly[29]=true
    set udg_BonusValue[39]=$A // $A = 10
    set udg_BonusValue[41]=5
    set udg_BonusValue[42]=$A // $A = 10
    set udg_BonusValue[43]=$A // $A = 10
    set udg_BonusValue[44]=20
    set udg_BonusValue[46]=20
    set udg_BonusValue[49]=$A // $A = 10
    set udg_BonusValue[53]=$A // $A = 10
    set udg_TitlePrimaryStatOnly[53]=true
    set udg_BonusValue[54]=20
    set udg_TitlePrimaryStatOnly[54]=true
    set udg_BonusValue[55]=5
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=3
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=1
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=4
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=2
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=7
    set bj_forLoopAIndexEnd=9
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=3
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=$A // $A = 10
    set bj_forLoopAIndexEnd=$E // $E = 14
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=4
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=$F // $F = 15
    set bj_forLoopAIndexEnd=20
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=5
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=21
    set bj_forLoopAIndexEnd=24
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=6
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=25
    set bj_forLoopAIndexEnd=29
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=7
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=30
    set bj_forLoopAIndexEnd=34
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=8
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=35
    set bj_forLoopAIndexEnd=38
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=9
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=39
    set bj_forLoopAIndexEnd=43
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=$A // $A = 10
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TitleChronicleIndex[44]=1
    set udg_TitleChronicleIndex[45]=1
    set udg_TitleChronicleIndex[46]=2
    set udg_TitleChronicleIndex[47]=2
    set udg_TitleChronicleIndex[48]=4
    set bj_forLoopAIndex=49
    set bj_forLoopAIndexEnd=51
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=8
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TitleChronicleIndex[52]=3
    set udg_TitleChronicleIndex[53]=7
    set udg_TitleChronicleIndex[54]=6
    set udg_TitleChronicleIndex[55]=$A // $A = 10
    set bj_forLoopAIndex=56
    set bj_forLoopAIndexEnd=58
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=9
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=60
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChroniclePoints[GetForLoopIndexA()]=1
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TitleChroniclePoints[18]=4
    set udg_TitleChroniclePoints[19]=0
    set udg_TitleChroniclePoints[20]=16
    set udg_TitleChroniclePoints[29]=5
    set udg_TitleChroniclePoints[34]=8
    set udg_TitleChroniclePoints[43]=5
    set udg_TitleChroniclePoints[44]=3
    set udg_TitleChroniclePoints[46]=3
    set udg_TitleChroniclePoints[50]=16
    set udg_TitleChroniclePoints[51]=2
    set udg_TitleChroniclePoints[52]=4
    set udg_TitleChroniclePoints[53]=$A // $A = 10
    set udg_TitleChroniclePoints[54]=5
    set udg_TitleChroniclePoints[55]=$A // $A = 10
    set udg_SpeedrunTitleBase=60
    set bj_forLoopAIndex=(udg_SpeedrunTitleBase+1)
    set bj_forLoopAIndexEnd=(udg_SpeedrunTitleBase+5)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TitleChroniclePoints[GetForLoopIndexA()]=1
        set udg_TitleChronicleIndex[GetForLoopIndexA()]=$B // $B = 11
        set udg_BonusValue[GetForLoopIndexA()]=5
        set udg_TitleName[GetForLoopIndexA()]=("Speedrunner Level "+I2S((GetForLoopIndexA()-udg_SpeedrunTitleBase)))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_SpeedrunBoss[1]=gg_unit_Hpb1_0013
    set udg_SpeedrunTimeLimit[1]=120.
    set udg_SpeedrunBoss[2]=gg_unit_U000_0248
    set udg_SpeedrunTimeLimit[2]=480.
    set udg_SpeedrunBoss[3]=gg_unit_U00J_0209
    set udg_SpeedrunTimeLimit[3]=900.
    set udg_SpeedrunBoss[4]=gg_unit_E002_0075
    set udg_SpeedrunTimeLimit[4]=1200.
    set udg_SpeedrunTimeLimit[5]=1800.
    set udg_TitleName[1]="Warlord"
    set udg_TitleName[2]="Warchief"
    set udg_TitleName[3]="Wargod"
    set udg_TitleName[4]="Magus"
    set udg_TitleName[5]="Sage"
    set udg_TitleName[6]="Mage Master"
    set udg_TitleName[7]="Gaya Apprentice"
    set udg_TitleName[8]="Gaya Hero"
    set udg_TitleName[9]="Gaya Champion"
    set udg_TitleName[$A]="Master" // $A = 10
    set udg_TitleName[$B]="Ultimate Master" // $B = 11
    set udg_TitleName[$C]="Grandmaster" // $C = 12
    set udg_TitleName[$D]="Grindmaster" // $D = 13
    set udg_TitleName[$E]="High Guardian" // $E = 14
    set udg_TitleName[$F]="Demon Slayer" // $F = 15
    set udg_TitleName[16]="Lightbringer"
    set udg_TitleName[17]="Zodiac Legend"
    set udg_TitleName[18]="Serpent Slayer"
    set udg_TitleName[20]="Lucifer's General"
    set udg_TitleName[21]="Arena Challenger"
    set udg_TitleName[22]="Arena Champion"
    set udg_TitleName[23]="Arena Completionist"
    set udg_TitleName[24]="Arena Usurper"
    set udg_TitleName[25]="Proof of Ultima"
    set udg_TitleName[26]="Proof of Omega"
    set udg_TitleName[27]="Monster King"
    set udg_TitleName[28]="Quadra King"
    set udg_TitleName[29]="The Apocalypse"
    set udg_TitleName[30]="Apprentice Summoner"
    set udg_TitleName[31]="High Summoner"
    set udg_TitleName[32]="Full Exorcist"
    set udg_TitleName[33]="Final Arbiter"
    set udg_TitleName[34]="Magic God"
    set udg_TitleName[35]="Weaponsmith"
    set udg_TitleName[36]="Arms Beginner"
    set udg_TitleName[37]="Arms Collector"
    set udg_TitleName[38]="Arms Hoarder"
    set udg_TitleName[39]="Junior Adventurer"
    set udg_TitleName[40]="Rumored Adventurer"
    set udg_TitleName[41]="Senior Adventurer"
    set udg_TitleName[42]="Heroic Spirit"
    set udg_TitleName[43]="Brave Ender"
    set udg_TitleName[44]="Warrior of Legend"
    set udg_TitleName[45]="Ultimate Warrior"
    set udg_TitleName[46]="Mage of Legend"
    set udg_TitleName[47]="Ultimate Mage"
    set udg_TitleName[48]="Legendary Guardian"
    set udg_TitleName[49]="Extreme Challenger"
    set udg_TitleName[50]="Monster Hunter"
    set udg_TitleName[51]="Blue Exorcist"
    set udg_TitleName[52]="Gaya Master"
    set udg_TitleName[53]="Godbeast Slayer"
    set udg_TitleName[54]="Rule Breaker"
    set udg_TitleName[55]="Master Chef"
    set udg_TitleName[56]="Arms Completionist"
    set udg_TitleName[57]="Arms Connoisseur"
    set udg_TitleName[58]="Arms Expert"
    set udg_TitleName[59]="Keg Hunter"
    set bj_forLoopAIndex=$A // $A = 10
    set bj_forLoopAIndexEnd=75
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Titles_Init_Title_HasStatBonus())then
            if(Trig_Titles_Init_Title_BoostsPrimaryOnly())then
                set udg_BonusText[GetForLoopIndexA()]=("Your base primary attribute increases by "+(I2S(udg_BonusValue[GetForLoopIndexA()])+"!"))
            else
                set udg_BonusText[GetForLoopIndexA()]=("All your base stats increase by "+(I2S(udg_BonusValue[GetForLoopIndexA()])+"!"))
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_BonusText[1]="The Holy Swordsman job is now available! Additionally, all your jobs' base Strength and Agility increase by 10!"
    set udg_BonusText[2]="The EXP gained from enemies killed with a Tech Finish is now doubled!"
    set udg_BonusText[3]="You now lose less gold when dying!"
    set udg_BonusText[4]="The Sorcerer job is now available! Additionally, all your jobs' base Intelligence increases by 10!"
    set udg_BonusText[5]="The EXP bonus given by your hero's Intelligence is now doubled!"
    set udg_BonusText[6]="You now lose less gold when dying!"
    set udg_BonusText[7]="Your hero's movement speed increases by 10%!"
    set udg_BonusText[8]="Your Spirit of Gaya can now use the Scan ability to analyze enemy properties!"
    set udg_BonusText[9]="Your EXP gained from enemies increases by 20%!"
    set udg_BonusText[$A]="You can now use the Shrine of Individuality next to the other job changers!" // $A = 10
    set udg_BonusText[$C]="You now get double Gold and EXP from quest rewards!" // $C = 12
    set udg_BonusText[$D]="You now get triple Gold and EXP from quest rewards!" // $D = 13
    set udg_BonusText[$E]="You may now enter New Game Plus mode!" // $E = 14
    set udg_BonusText[16]="You unlock the two dark jobs: Dark Knight and Necromancer!"
    set udg_BonusText[20]="All your base stats increase by 10! Additionally, you may now enter New Game Minus mode!"
    set udg_BonusText[21]="You can now instantly unlock all Arena Cups on replays!"
    set udg_BonusText[22]="You now gain double Battle Points in the Arena!"
    set udg_BonusText[23]="You can now instantly unlock all Arena Teams on replays!"
    set udg_BonusText[30]="All of your summons' base stats increase by 30%!"
    set udg_BonusText[31]="All of your summons' base stats increase by 20%!"
    set udg_BonusText[32]="All of your summons' base stats increase by 20%!"
    set udg_BonusText[33]="All of your summons' base stats increase by 20%!"
    set udg_BonusText[34]="All of your summons' base stats increase by 50%!"
    set udg_BonusText[35]="You unlock the Armory at your House!"
    set udg_BonusText[36]="Your base damage increases by 20 and defense by 5!"
    set udg_BonusText[37]="Your base damage increases by 20 and defense by 5!"
    set udg_BonusText[38]="Your base damage increases by 20 and defense by 5!"
    set udg_BonusText[40]="Your hero's movement speed increases by 15%!"
    set udg_BonusText[44]="Your base Strength and Agility increase by 20! You also obtain one piece of |cffffcc00Celestium|r!"
    set udg_BonusText[45]="Enemies will now drop items more frequently!"
    set udg_BonusText[46]="Your base Intelligence increases by 20! You also obtain one piece of |cffffcc00Celestium|r!"
    set udg_BonusText[47]="Enemies will now drop items more frequently!"
    set udg_BonusText[48]="You now never lose more than 10000 Gold when dying! Entering New Game Plus mode henceforth always has double effect!"
    set udg_BonusText[49]="Your base primary attribute increases by 10 and your summons' base stats increase by 30%!"
    set udg_BonusText[50]="All of your summons' base stats increase by 20%!"
    set udg_BonusText[51]="All of your summons' base stats increase by 30%!"
    set udg_BonusText[52]="Your Spirit of Gaya's MP Regeneration increases by 50%!"
    set udg_BonusText[55]="You unlock all food recipes permanently, now always create 5 stacks of Food items at once, and all of your base stats increase by 5!"
    set udg_BonusText[56]="There is no longer any penalty for death and you always revive with full HP and MP!"
    set udg_BonusText[57]="Your base damage increases by 20 and defense by 5!"
    set udg_BonusText[58]="Your base damage increases by 20 and defense by 5!"
    set udg_BonusText[59]="All ten monograph effects are now permanently active without carrying the books!"
    set udg_BonusText[(udg_SpeedrunTitleBase+1)]=(udg_BonusText[(udg_SpeedrunTitleBase+1)]+" Next Speedrun Challenge: Defeat Zalera within 8 minutes of game time.")
    set udg_BonusText[(udg_SpeedrunTitleBase+2)]=(udg_BonusText[(udg_SpeedrunTitleBase+2)]+" Next Speedrun Challenge: Defeat Zeromus within 15 minutes of game time.")
    set udg_BonusText[(udg_SpeedrunTitleBase+3)]=(udg_BonusText[(udg_SpeedrunTitleBase+3)]+" Next Speedrun Challenge: Defeat Hashmalum within 20 minutes of game time.")
    set udg_BonusText[(udg_SpeedrunTitleBase+4)]=(udg_BonusText[(udg_SpeedrunTitleBase+4)]+" Next Speedrun Challenge: Defeat Echele (Level 50 Final Form) within 30 minutes of game time.")
    set udg_BonusText[(udg_SpeedrunTitleBase+5)]=(udg_BonusText[(udg_SpeedrunTitleBase+5)]+" You cleared all speedrun challenges! Congratulations!")
    call ForForce(udg_ActivePlayers,function Trig_Titles_Init_HideChronicleAbilities)
    call DestroyTrigger(GetTriggeringTrigger())
    call Chronicles_Init()
endfunction

function Trig_Titles_CheckAll_Wargod_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H000')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H003')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H001')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00M')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H02X')>=99) // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Titles_CheckAll_Warchief_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H000')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H003')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H001')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00M')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H02X')>=50) // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Titles_CheckAll_Warlord_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H000')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H003')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H001')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>=udg_JobLevelTier1) // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"
endfunction

function Trig_Titles_CheckAll_MageMaster_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H002')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H004')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H005')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H009')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H008')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00L')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H02Y')>=99) // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Titles_CheckAll_Sage_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H002')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H004')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H005')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H009')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H008')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00L')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H02Y')>=50) // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Titles_CheckAll_Magus_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H002')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H004')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H005')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H009')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H008')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>=udg_JobLevelTier1) // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"
endfunction

function Trig_Titles_CheckAll_GayaChampion_Met takes nothing returns boolean
    return(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=99)
endfunction

function Trig_Titles_CheckAll_GayaHero_Met takes nothing returns boolean
    return(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=50)
endfunction

function Trig_Titles_CheckAll_GayaApprentice_Met takes nothing returns boolean
    return(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=20)
endfunction

function Trig_Titles_CheckAll_GayaMaster_Met takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0B4',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=3)and(GetUnitAbilityLevelSwapped('A02K',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=3)and(GetUnitAbilityLevelSwapped('A02L',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=3)and(GetUnitAbilityLevelSwapped('A058',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=1)and(GetUnitAbilityLevelSwapped('S004',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=1)and(GetUnitAbilityLevelSwapped('A07E',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=1) // 'A0B4': ability "Break Stun"; 'A02K': ability "Mana Transfer"; 'A02L': ability "Mega Heal"; 'A058': ability "Tarugaya"; 'S004': ability "Sukugaya"; 'A07E': ability "Rakugaya"
endfunction

function Trig_Titles_CheckAll_HighGuardian_Met takes nothing returns boolean
    return(GetPlayerState(udg_TempPlayer,PLAYER_STATE_RESOURCE_FOOD_USED)>=(udg_JobCount+1))
endfunction

function Trig_Titles_CheckAll_Grindmaster_Met takes nothing returns boolean
    return(GetPlayerState(udg_TempPlayer,PLAYER_STATE_RESOURCE_FOOD_USED)>=8)
endfunction

function Trig_Titles_CheckAll_Grandmaster_Met takes nothing returns boolean
    return(GetPlayerState(udg_TempPlayer,PLAYER_STATE_RESOURCE_FOOD_USED)>=3)
endfunction

function Trig_Titles_CheckAll_AnyPhysJobAt100_Inner takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H003')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H001')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00A')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00B')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00C')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00D')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00E')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00F')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00M')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H02X')>='d') // 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Titles_CheckAll_AnyPhysJobAt100 takes nothing returns boolean
    return(Trig_Titles_CheckAll_AnyPhysJobAt100_Inner())
endfunction

function Trig_Titles_CheckAll_UltimateWarrior_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H003')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H001')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00M')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H02X')>='d') // 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Titles_CheckAll_Squire_At100 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H000')>='d') // 'H000': unit "Squire"
endfunction

function Trig_Titles_CheckAll_AnyMageJobAt100_Inner takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H004')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H005')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H009')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H008')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00G')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00I')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00H')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00J')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H00L')>='d')or(Job_GetSavedLevel(udg_TempPlayer,'H02Y')>='d') // 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Titles_CheckAll_AnyMageJobAt100 takes nothing returns boolean
    return(Trig_Titles_CheckAll_AnyMageJobAt100_Inner())
endfunction

function Trig_Titles_CheckAll_UltimateMage_Met takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H004')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H005')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H009')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H008')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00L')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H02Y')>='d') // 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Titles_CheckAll_Chemist_At100 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H002')>='d') // 'H002': unit "Chemist"
endfunction

function Trig_Titles_CheckAll_LegendaryGuardian_Met takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[45]))and(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[47]))and(GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[GetConvertedPlayerId(udg_TempPlayer)])>=4) // 'A02F': ability "Mastery"
endfunction

function Trig_Titles_CheckAll_AllJobsAt100 takes nothing returns boolean
    return(udg_HighestJobLevel[GetConvertedPlayerId(udg_TempPlayer)]>='d')
endfunction

function Trig_Titles_CheckAll_UltimateMaster_Met takes nothing returns boolean
    return(udg_HighestJobLevel[GetConvertedPlayerId(udg_TempPlayer)]>=99)
endfunction

function Trig_Titles_CheckAll_Master_Met takes nothing returns boolean
    return(udg_HighestJobLevel[GetConvertedPlayerId(udg_TempPlayer)]>=50)
endfunction

function Trig_Titles_CheckAll_AnyWeaponUpgradeAt10 takes nothing returns boolean
    return(GetPlayerTechCountSimple('R000',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R001',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R002',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R008',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R009',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00A',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00B',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00N',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R003',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R004',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00M',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00L',udg_TempPlayer)>=$A) // 'R000': upgrade "Tools"; $A = 10; 'R001': upgrade "Sword"; 'R002': upgrade "Bow"; 'R008': upgrade "Axe"; 'R009': upgrade "Spear"; 'R00A': upgrade "Katana"; 'R00B': upgrade "Dagger"; 'R00N': upgrade "Greatsword"; 'R003': upgrade "Rod"; 'R004': upgrade "Staff"; 'R00M': upgrade "Gun"; 'R00L': upgrade "Inner Mana"
endfunction

function Trig_Titles_CheckAll_Weaponsmith_Met takes nothing returns boolean
    return(Trig_Titles_CheckAll_AnyWeaponUpgradeAt10())
endfunction

function Trig_Titles_CheckAll_Endless_Applies takes nothing returns boolean
    return(udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]>0)and(udg_SpeedrunMode==false)
endfunction

function Trig_Titles_CheckAll_HasSpeedrunClears takes nothing returns boolean
    return(udg_SpeedrunLevel[GetConvertedPlayerId(udg_TempPlayer)]>0)and(udg_SpeedrunLevel[GetConvertedPlayerId(udg_TempPlayer)]<=5)
endfunction

function Trig_Titles_CheckAll_HasTitle_Low takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[udg_TempInteger]))
endfunction

function Trig_Titles_CheckAll_HasTitle_High takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[udg_TempInteger]))
endfunction

function Trig_Titles_CheckAll_Actions takes nothing returns nothing
    if(Trig_Titles_CheckAll_Warlord_Met())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[1])
        if(Trig_Titles_CheckAll_Warchief_Met())then
            call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[2])
            if(Trig_Titles_CheckAll_Wargod_Met())then
                call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[3])
            endif
        endif
    endif
    if(Trig_Titles_CheckAll_Magus_Met())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[4])
        if(Trig_Titles_CheckAll_Sage_Met())then
            call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[5])
            if(Trig_Titles_CheckAll_MageMaster_Met())then
                call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[6])
            endif
        endif
    endif
    if(Trig_Titles_CheckAll_GayaApprentice_Met())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[7])
        if(Trig_Titles_CheckAll_GayaHero_Met())then
            call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[8])
            if(Trig_Titles_CheckAll_GayaChampion_Met())then
                call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[9])
            endif
        endif
    endif
    if(Trig_Titles_CheckAll_GayaMaster_Met())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[52])
    endif
    if(Trig_Titles_CheckAll_Master_Met())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[$A]) // $A = 10
        if(Trig_Titles_CheckAll_UltimateMaster_Met())then
            call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[$B]) // $B = 11
            if(Trig_Titles_CheckAll_Grandmaster_Met())then
                call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[$C]) // $C = 12
                if(Trig_Titles_CheckAll_Grindmaster_Met())then
                    call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[$D]) // $D = 13
                    if(Trig_Titles_CheckAll_HighGuardian_Met())then
                        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[$E]) // $E = 14
                    endif
                endif
            endif
            if(Trig_Titles_CheckAll_AllJobsAt100())then
                if(Trig_Titles_CheckAll_Squire_At100())then
                    call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[44])
                    if(Trig_Titles_CheckAll_UltimateWarrior_Met())then
                        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[45])
                    endif
                else
                    if(Trig_Titles_CheckAll_AnyPhysJobAt100())then
                        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[44])
                    endif
                endif
                if(Trig_Titles_CheckAll_Chemist_At100())then
                    call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[46])
                    if(Trig_Titles_CheckAll_UltimateMage_Met())then
                        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[47])
                    endif
                else
                    if(Trig_Titles_CheckAll_AnyMageJobAt100())then
                        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[46])
                    endif
                endif
                if(Trig_Titles_CheckAll_LegendaryGuardian_Met())then
                    call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[48])
                endif
            endif
        endif
    endif
    if(Trig_Titles_CheckAll_Weaponsmith_Met())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[35])
    endif
    if(Trig_Titles_CheckAll_Endless_Applies())then
        call UnitAddAbilityBJ('A10E',Player_GetHero(udg_TempPlayer)) // 'A10E': ability "Endless"
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,1)
        call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,1)
        call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,1)
        call SetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer),GetHeroLevel(Player_GetHero(udg_TempPlayer))) // 'A10E': ability "Endless"
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
        call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
        call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]*GetUnitAbilityLevelSwapped('A10E',Player_GetHero(udg_TempPlayer))))*.1))) // 'A10E': ability "Endless"
    endif
    if(Trig_Titles_CheckAll_HasSpeedrunClears())then
        set udg_TempInteger=(udg_SpeedrunTitleBase+1)
        loop
            exitwhen udg_TempInteger>(udg_SpeedrunTitleBase+udg_SpeedrunLevel[GetConvertedPlayerId(udg_TempPlayer)])
            call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[udg_TempInteger])
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
            set udg_TempInteger=udg_TempInteger+1
        endloop
    endif
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>35
        if(Trig_Titles_CheckAll_HasTitle_Low())then
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    set udg_TempInteger=39
    loop
        exitwhen udg_TempInteger>55
        if(Trig_Titles_CheckAll_HasTitle_High())then
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    call Chronicles_RestoreSecrets(udg_TempPlayer)
endfunction

function Trig_Titles_CheckBasic_Warlord_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[1])==false)and(Job_GetSavedLevel(udg_TempPlayer,'H000')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H003')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H001')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>=udg_JobLevelTier1) // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"
endfunction

function Trig_Titles_CheckBasic_Warchief_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[2])==false)and(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[1]))and(Job_GetSavedLevel(udg_TempPlayer,'H000')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H003')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H001')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00M')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H02X')>=50) // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Titles_CheckBasic_Wargod_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[3])==false)and(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[2]))and(Job_GetSavedLevel(udg_TempPlayer,'H000')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H003')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H001')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00M')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H02X')>=99) // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Titles_CheckBasic_Magus_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[4])==false)and(Job_GetSavedLevel(udg_TempPlayer,'H002')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H004')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H005')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H009')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H008')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>=udg_JobLevelTier1)and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>=udg_JobLevelTier1) // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"
endfunction

function Trig_Titles_CheckBasic_Sage_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[5])==false)and(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[4]))and(Job_GetSavedLevel(udg_TempPlayer,'H002')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H004')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H005')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H009')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H008')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H00L')>=50)and(Job_GetSavedLevel(udg_TempPlayer,'H02Y')>=50) // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Titles_CheckBasic_MageMaster_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[6])==false)and(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[5]))and(Job_GetSavedLevel(udg_TempPlayer,'H002')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H004')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H005')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H009')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H008')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H00L')>=99)and(Job_GetSavedLevel(udg_TempPlayer,'H02Y')>=99) // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Titles_CheckBasic_GayaApprentice_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[7])==false)and(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=20)
endfunction

function Trig_Titles_CheckBasic_GayaHero_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[8])==false)and(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=50)
endfunction

function Trig_Titles_CheckBasic_GayaChampion_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[9])==false)and(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])>=99)
endfunction

function Trig_Titles_CheckBasic_Master_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[$A])==false)and(udg_HighestJobLevel[GetConvertedPlayerId(udg_TempPlayer)]>=50) // $A = 10
endfunction

function Trig_Titles_CheckBasic_UltimateMaster_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[$B])==false)and(udg_HighestJobLevel[GetConvertedPlayerId(udg_TempPlayer)]>=99) // $B = 11
endfunction

function Trig_Titles_CheckBasic_Grandmaster_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[$C])==false)and(GetPlayerState(udg_TempPlayer,PLAYER_STATE_RESOURCE_FOOD_USED)>=3) // $C = 12
endfunction

function Trig_Titles_CheckBasic_Grindmaster_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[$D])==false)and(GetPlayerState(udg_TempPlayer,PLAYER_STATE_RESOURCE_FOOD_USED)>=8) // $D = 13
endfunction

function Trig_Titles_CheckBasic_HighGuardian_Ready takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[$E])==false)and(GetPlayerState(udg_TempPlayer,PLAYER_STATE_RESOURCE_FOOD_USED)>=(udg_JobCount+1)) // $E = 14
endfunction

function Trig_Titles_CheckBasic_Actions takes nothing returns nothing
    if(Trig_Titles_CheckBasic_Warlord_Ready())then
        set udg_TempInteger=1
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_Warchief_Ready())then
        set udg_TempInteger=2
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_Wargod_Ready())then
        set udg_TempInteger=3
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_Magus_Ready())then
        set udg_TempInteger=4
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_Sage_Ready())then
        set udg_TempInteger=5
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_MageMaster_Ready())then
        set udg_TempInteger=6
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_GayaApprentice_Ready())then
        set udg_TempInteger=7
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_GayaHero_Ready())then
        set udg_TempInteger=8
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_GayaChampion_Ready())then
        set udg_TempInteger=9
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_Master_Ready())then
        set udg_TempInteger=$A // $A = 10
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_UltimateMaster_Ready())then
        set udg_TempInteger=$B // $B = 11
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_Grandmaster_Ready())then
        set udg_TempInteger=$C // $C = 12
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_Grindmaster_Ready())then
        set udg_TempInteger=$D // $D = 13
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    if(Trig_Titles_CheckBasic_HighGuardian_Ready())then
        set udg_TempInteger=$E // $E = 14
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

// World Editor calls InitTrig_Titles automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Titles (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Titles takes nothing returns nothing
endfunction

function Register_Titles_Init takes nothing returns nothing
    set gg_trg_Titles_Init=CreateTrigger()
    call DisableTrigger(gg_trg_Titles_Init)
    call TriggerAddAction(gg_trg_Titles_Init,function Trig_Titles_Init_Actions)
endfunction

function Register_Titles_CheckAll takes nothing returns nothing
    set gg_trg_Titles_CheckAll=CreateTrigger()
    call DisableTrigger(gg_trg_Titles_CheckAll)
    call TriggerAddAction(gg_trg_Titles_CheckAll,function Trig_Titles_CheckAll_Actions)
endfunction

function Register_Titles_CheckBasic takes nothing returns nothing
    set gg_trg_Titles_CheckBasic=CreateTrigger()
    call DisableTrigger(gg_trg_Titles_CheckBasic)
    call TriggerAddAction(gg_trg_Titles_CheckBasic,function Trig_Titles_CheckBasic_Actions)
endfunction

function Register_Titles_MonographPickup takes nothing returns nothing
    set gg_trg_Titles_MonographPickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Titles_MonographPickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(gg_trg_Titles_MonographPickup,function Chronicles_MonographPickup)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Titles takes nothing returns nothing
    call Register_Titles_Init() // starts off; run by Init
    call Register_Titles_CheckAll() // starts off; run by Cmd
    call Register_Titles_CheckBasic() // starts off; run by JobLevels
    call Register_Titles_MonographPickup()
endfunction

endlibrary

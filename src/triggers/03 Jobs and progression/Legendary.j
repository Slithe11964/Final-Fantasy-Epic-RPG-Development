library TLegendary requires TPlayerHero, TJob
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legendary_Unlock=null
    string array LegendTaskText
    string array LegendElementName
endglobals

function Trig_Legendary_Unlock_IsShrineUnlocked takes nothing returns boolean
    return(udg_ShrineUnlocked)
endfunction

function Trig_Legendary_Unlock_Actions takes nothing returns nothing
    set udg_LegendaryUnlocked=true
    call ShowUnitShow(udg_ShrineMenuUnit[18])
    if(Trig_Legendary_Unlock_IsShrineUnlocked())then
        call ShowUnitShow(udg_ShrineMenuUnit[19])
    endif
    call GroupAddUnitSimple(udg_ShrineMenuUnit[19],udg_SecondShrineUnits)
    call AddUnitToStockBJ('n0KL',gg_unit_n04U_0204,1,1) // 'n0KL': unit "Legendary Bonus Menu"
    call AddUnitToStockBJ('n0KL',gg_unit_n04U_0189,1,1) // 'n0KL': unit "Legendary Bonus Menu"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Legendary automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Legendary (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function Legend_Line takes player viewer,string text,boolean done returns nothing
    local string color="|cffffffff"
    local string mark="[ ] "
    if done then
        set color="|cff00ff00"
        set mark="[Done] "
    endif
    call DisplayTimedTextToPlayer(viewer,0,0,35,color+mark+text+"|r")
endfunction


function Legend_Command takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local unit hero=Player_GetHero(viewer)
    local integer job=Job_GetIndex(hero)
    local integer i=0
    local boolean done
    if GetEventPlayerChatString()!="-legendary" then
        return
    endif
    if hero==null or GetHeroLevel(hero)<99 or job<0 or job>22 then
        call DisplayTimedTextToPlayer(viewer,0,0,10,"Legendary tasks are available at level 99 on your current job.")
    else
        set done=IsPlayerInForce(viewer,udg_JobMasterForce[job]) or GetUnitAbilityLevel(hero,'A02F')>=4
        if job==14 and udg_NewGamePlusLevel[GetPlayerId(viewer)+1]>0 then
            set done=true
        endif
        call DisplayTimedTextToPlayer(viewer,0,0,35,"|cffffcc00Legendary "+udg_JobName[job]+"|r")
        call Legend_Line(viewer,LegendTaskText[job],done)
        if job==11 or job==17 then
            set i=1
            loop
                exitwhen i>6
                if job==11 then
                    call Legend_Line(viewer,LegendElementName[i],done or IsPlayerInForce(viewer,udg_WeakElementForce[i]))
                else
                    call Legend_Line(viewer,LegendElementName[i],done or IsPlayerInForce(viewer,udg_NullElementForce[i]))
                endif
                set i=i+1
            endloop
        elseif job==22 then
            loop
                exitwhen i>=22
                call Legend_Line(viewer,udg_JobName[i],LoadInteger(udg_JobLevelHash,udg_JobUnitType[i],GetPlayerId(viewer))==100 or GetUnitAbilityLevel(LoadUnitHandle(udg_JobHeroHash,udg_JobUnitType[i],GetPlayerId(viewer)),'A02F')>=4)
                set i=i+1
            endloop
        elseif job==13 then
            call Legend_Line(viewer,"Shiva: normal attack for at least 10,000 damage",done or IsPlayerInForce(viewer,udg_EidolonAwardForce[0]))
            call Legend_Line(viewer,"Ifrit: normal attack for at least 10,000 damage",done or IsPlayerInForce(viewer,udg_EidolonAwardForce[1]))
            call Legend_Line(viewer,"Cyclops: normal attack for at least 10,000 damage",done or IsPlayerInForce(viewer,udg_EidolonAwardForce[2]))
        endif
    endif
    set hero=null
    set viewer=null
endfunction


function Legend_InitCommand takes nothing returns nothing
    local trigger command=CreateTrigger()
    local integer i=0
    set LegendElementName[1]="Fire"
    set LegendElementName[2]="Ice"
    set LegendElementName[3]="Thunder"
    set LegendElementName[4]="Water"
    set LegendElementName[5]="Wind"
    set LegendElementName[6]="Earth"
    set LegendTaskText[0]="Cover an ally with the 'Focus' or 'Serenity' passive abilities and have them attack enemies with the 50% boost for being over 99% HP for 30 hits, without using Cover again inbetween."
    set LegendTaskText[1]="Reduce an enemy's armor to 0 with Armor Breaker and then deal over 200'000 damage with your hero in the following 4 seconds while the enemy is stunned or dazed."
    set LegendTaskText[2]="Hit enemy Blind Spots 60 times in the duration of a single Aim."
    set LegendTaskText[3]="Attain 1000 or more total Strength during Strength Burst."
    set LegendTaskText[4]="Successfully hit Evade & Counter on 20 hits in succession without missing a single one or letting the MP cost drop back down."
    set LegendTaskText[5]="Hit for over 200'000 total damage with a single strike, including Blitz cleave."
    set LegendTaskText[6]="Kill an enemy by Iainuki finishing a combo of at least 20 hits."
    set LegendTaskText[7]="Kill 10 dragons in a single minute."
    set LegendTaskText[8]="Reach DPS of over 99'999 in a time period of at least 5 seconds."
    set LegendTaskText[9]="Within the duration of one Holy Power, recover over 4000 MP by doing at least 40 normal attacks while below max MP, and also use over 4000 MP in abilities."
    set LegendTaskText[10]="Make food that grants two buffs at once."
    set LegendTaskText[11]="Deal technical damage in all 6 elements by hitting enemies with the respective element while they are afflicted with the required status."
    set LegendTaskText[12]="Heal over 50'000 HP in total with a single Cure spell."
    set LegendTaskText[13]="Deal over 10'000 damage with a normal attack from Shiva, Ifrit and Cyclops."
    set LegendTaskText[14]="Master the forbidden spell of traveling back through time (New Game Plus)."
    set LegendTaskText[15]="Give an allied unit 6 or more buffs at once with Spell Shot."
    set LegendTaskText[16]="Use your hero abilities to bestow units with Blind, Bravery, Pain, Faith and Fog at least 20 times in a single minute. The targets must not already have the buff or debuff on them to count."
    set LegendTaskText[17]="Get an instant death hit on normal enemies for all 6 elements by inflicting them with Imperil and then striking them with an element they were already weak to."
    set LegendTaskText[18]="Block over 500'000 total damage (neglecting armor and hero magic defense) with one cast of Infinity."
    set LegendTaskText[19]="Put an enemy with at least 30'000 HP to Sleep. Then kill the enemy in less than 0.5 seconds of breaking its Sleep."
    set LegendTaskText[20]="Drain over 30'000 HP with a single strike in Drain Attack."
    set LegendTaskText[21]="Restore over 50'000 collective lost HP (healing over a unit's max HP does NOT count) through Zombie Release without raising more zombies inbetween."
    set LegendTaskText[22]="Achieve Legendary Mastery in every other job, then complete the Freelancer ritual."
    loop
        exitwhen i>=8
        call TriggerRegisterPlayerChatEvent(command,Player(i),"-legendary",true)
        set i=i+1
    endloop
    call TriggerAddAction(command,function Legend_Command)
    set command=null
endfunction

function InitTrig_Legendary takes nothing returns nothing
endfunction

function Register_Legendary_Unlock takes nothing returns nothing
    set gg_trg_Legendary_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Legendary_Unlock)
    call TriggerAddAction(gg_trg_Legendary_Unlock,function Trig_Legendary_Unlock_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Legendary takes nothing returns nothing
    call Register_Legendary_Unlock() // starts off; run by Title
    call Legend_InitCommand()
endfunction

endlibrary

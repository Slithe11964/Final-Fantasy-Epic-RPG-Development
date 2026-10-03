library TAtkSpd requires TForce, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_AtkSpd_Command=null
endglobals

function Trig_AtkSpd_Command_Cond_HasCommandAura takes nothing returns boolean
    return(UnitHasBuffBJ(udg_CurrentHero,'B01Q')) // 'B01Q': buff tooltip "Sukugaya"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeedMinus50 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0VH',udg_CurrentHero)>0) // 'A0VH': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeedMinus100 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1A6',udg_CurrentHero)>0) // 'A1A6': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasWyrmhero takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HS',udg_CurrentHero)>0) // 'A0HS': ability "Wyrmhero Effect"
endfunction

function Trig_AtkSpd_Command_Cond_HasAdamantArmor takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0EI',udg_CurrentHero)>0) // 'A0EI': ability "Adamant Armor"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed10 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0NO',udg_CurrentHero)>0) // 'A0NO': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed100 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0CM',udg_CurrentHero)>0) // 'A0CM': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed120 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A16G',udg_CurrentHero)>0) // 'A16G': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed140 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1BU',udg_CurrentHero)>0) // 'A1BU': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed150 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1BO',udg_CurrentHero)>0) // 'A1BO': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed16 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('AIsx',udg_CurrentHero)>0) // 'AIsx': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed20 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1ZZ',udg_CurrentHero)>0) // 'A1ZZ': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed24 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A04V',udg_CurrentHero)>0) // 'A04V': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed30 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A04W',udg_CurrentHero)>0) // 'A04W': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed40 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A04X',udg_CurrentHero)>0) // 'A04X': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed50 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A04Y',udg_CurrentHero)>0) // 'A04Y': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed60 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0AI',udg_CurrentHero)>0) // 'A0AI': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed70 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1CN',udg_CurrentHero)>0) // 'A1CN': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed74 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A07X',udg_CurrentHero)>0) // 'A07X': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed76 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A04Z',udg_CurrentHero)>0) // 'A04Z': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed80 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WI',udg_CurrentHero)>0) // 'A0WI': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasSpeed90 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0GO',udg_CurrentHero)>0) // 'A0GO': editor label "Item Attack Speed Bonus"
endfunction

function Trig_AtkSpd_Command_Cond_HasIncreasedSpeed takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0VI',udg_CurrentHero)>0) // 'A0VI': ability "Increased Speed"
endfunction

function Trig_AtkSpd_Command_Cond_SpeedAboveCap takes nothing returns boolean
    return(udg_StatCalcValue>$3E8) // $3E8 = 1000
endfunction

function Trig_AtkSpd_Command_Cond_SpeedBelowFloor takes nothing returns boolean
    return(udg_StatCalcValue<40)
endfunction

function Trig_AtkSpd_Command_Cond_IsFastAttackJob takes nothing returns boolean
    return(GetUnitTypeId(udg_CurrentHero)=='H001')or(GetUnitTypeId(udg_CurrentHero)=='H00B')or(GetUnitTypeId(udg_CurrentHero)=='H00E')or(GetUnitTypeId(udg_CurrentHero)=='H00F') // 'H001': unit "Archer"; 'H00B': unit "Thief"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"
endfunction

function Trig_AtkSpd_Command_Cond_UsesFastBaseSpeed takes nothing returns boolean
    return(Trig_AtkSpd_Command_Cond_IsFastAttackJob())
endfunction

function Trig_AtkSpd_Command_Cond_HasDualWield takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HP',udg_CurrentHero)>0) // 'A0HP': ability "Dual Wield"
endfunction

function Trig_AtkSpd_Command_Actions takes nothing returns nothing
    local force l_tempForce
    set udg_CurrentHero=Player_GetHero(GetTriggerPlayer())
    call ConditionalTriggerExecute(gg_trg_AttackSpeed_Update)
    // Increase udg_StatCalcValue by 100.
    set udg_StatCalcValue=(udg_StatCalcValue+'d')
    if(Trig_AtkSpd_Command_Cond_HasCommandAura())then
        // Increase udg_StatCalcValue by 20.
        set udg_StatCalcValue=(udg_StatCalcValue+20)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeedMinus50())then
        // Decrease udg_StatCalcValue by 50.
        set udg_StatCalcValue=(udg_StatCalcValue-50)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeedMinus100())then
        // Decrease udg_StatCalcValue by 100.
        set udg_StatCalcValue=(udg_StatCalcValue-'d')
    endif
    if(Trig_AtkSpd_Command_Cond_HasWyrmhero())then
        // Decrease udg_StatCalcValue by 1000.
        set udg_StatCalcValue=(udg_StatCalcValue-$3E8) // $3E8 = 1000
    endif
    if(Trig_AtkSpd_Command_Cond_HasAdamantArmor())then
        // Decrease udg_StatCalcValue by 60.
        set udg_StatCalcValue=(udg_StatCalcValue-60)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed10())then
        // Increase udg_StatCalcValue by 10.
        set udg_StatCalcValue=(udg_StatCalcValue+$A) // $A = 10
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed100())then
        // Increase udg_StatCalcValue by 100.
        set udg_StatCalcValue=(udg_StatCalcValue+'d')
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed120())then
        // Increase udg_StatCalcValue by 120.
        set udg_StatCalcValue=(udg_StatCalcValue+'x')
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed140())then
        // Increase udg_StatCalcValue by 140.
        set udg_StatCalcValue=(udg_StatCalcValue+$8C) // $8C = 140
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed150())then
        // Increase udg_StatCalcValue by 150.
        set udg_StatCalcValue=(udg_StatCalcValue+$96) // $96 = 150
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed16())then
        // Increase udg_StatCalcValue by 16.
        set udg_StatCalcValue=(udg_StatCalcValue+16)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed20())then
        // Increase udg_StatCalcValue by 20.
        set udg_StatCalcValue=(udg_StatCalcValue+20)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed24())then
        // Increase udg_StatCalcValue by 24.
        set udg_StatCalcValue=(udg_StatCalcValue+24)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed30())then
        // Increase udg_StatCalcValue by 30.
        set udg_StatCalcValue=(udg_StatCalcValue+30)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed40())then
        // Increase udg_StatCalcValue by 40.
        set udg_StatCalcValue=(udg_StatCalcValue+40)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed50())then
        // Increase udg_StatCalcValue by 50.
        set udg_StatCalcValue=(udg_StatCalcValue+50)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed60())then
        // Increase udg_StatCalcValue by 60.
        set udg_StatCalcValue=(udg_StatCalcValue+60)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed70())then
        // Increase udg_StatCalcValue by 70.
        set udg_StatCalcValue=(udg_StatCalcValue+70)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed74())then
        // Increase udg_StatCalcValue by 74.
        set udg_StatCalcValue=(udg_StatCalcValue+74)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed76())then
        // Increase udg_StatCalcValue by 76.
        set udg_StatCalcValue=(udg_StatCalcValue+76)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed80())then
        // Increase udg_StatCalcValue by 80.
        set udg_StatCalcValue=(udg_StatCalcValue+80)
    endif
    if(Trig_AtkSpd_Command_Cond_HasSpeed90())then
        // Increase udg_StatCalcValue by 90.
        set udg_StatCalcValue=(udg_StatCalcValue+90)
    endif
    if(Trig_AtkSpd_Command_Cond_HasIncreasedSpeed())then
        // Increase udg_StatCalcValue by 50.
        set udg_StatCalcValue=(udg_StatCalcValue+50)
    endif
    if(Trig_AtkSpd_Command_Cond_SpeedBelowFloor())then
        set udg_StatCalcValue=40
    else
        if(Trig_AtkSpd_Command_Cond_SpeedAboveCap())then
            set udg_StatCalcValue=$3E8 // $3E8 = 1000
        endif
    endif
    if(Trig_AtkSpd_Command_Cond_UsesFastBaseSpeed())then
        set udg_TempReal=1.5
    else
        set udg_TempReal=2.
    endif
    // ((udg_StatCalcValue treated as a decimal-capable number) times (0.01)) divided by (udg_TempReal).
    set udg_TempReal=((I2R(udg_StatCalcValue)*.01)/ udg_TempReal)
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(udg_CurrentHero))
    if(Trig_AtkSpd_Command_Cond_HasDualWield())then
        call DisplayTextToForce(l_tempForce,(("Your attack speed is "+I2S(udg_StatCalcValue))+("% ("+(R2SW(udg_TempReal,1,1)+" attacks per second), may not include identical attack speed bonuses from both weapons."))))
    else
        call DisplayTextToForce(l_tempForce,(("Your attack speed is "+I2S(udg_StatCalcValue))+("% ("+(R2SW(udg_TempReal,1,1)+" attacks per second)"))))
    endif
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_AtkSpd automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_AtkSpd (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_AtkSpd takes nothing returns nothing
endfunction

function Register_AtkSpd_Command takes nothing returns nothing
    set gg_trg_AtkSpd_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(0),"-atkspd",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(1),"-atkspd",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(2),"-atkspd",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(3),"-atkspd",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(4),"-atkspd",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(5),"-atkspd",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(6),"-atkspd",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_AtkSpd_Command,Player(7),"-atkspd",true)
    call TriggerAddAction(gg_trg_AtkSpd_Command,function Trig_AtkSpd_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_AtkSpd takes nothing returns nothing
    call Register_AtkSpd_Command()
endfunction

endlibrary

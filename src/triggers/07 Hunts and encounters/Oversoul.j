library TOversoul requires TItemShared
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Oversoul_Tables_Init=null
    trigger gg_trg_Oversoul_OnMonsterDeath=null
    trigger gg_trg_Oversoul_Activate=null
endglobals

function Trig_Oversoul_Tables_Init_Actions takes nothing returns nothing
    set udg_SpeciesName[1]="Goblin"
    set udg_SpeciesName[2]="Triton"
    set udg_SpeciesName[3]="Gnoll"
    set udg_SpeciesName[4]="Spider"
    set udg_SpeciesName[5]="Wolf"
    set udg_SpeciesName[6]="Centaur"
    set udg_SpeciesName[7]="Lizard"
    set udg_SpeciesName[8]="Boar"
    set udg_SpeciesName[9]="Wildekin"
    set udg_SpeciesName[$A]="Harpy" // $A = 10
    set udg_SpeciesName[$B]="Crab" // $B = 11
    set udg_SpeciesName[$C]="Sea Spirit" // $C = 12
    set udg_SpeciesName[$D]="Sea Giant" // $D = 13
    set udg_SpeciesName[$E]="Hydra" // $E = 14
    set udg_SpeciesName[$F]="Revenant" // $F = 15
    set udg_SpeciesName[16]="Turtle"
    set udg_SpeciesName[17]="Wendigo"
    set udg_SpeciesName[18]="Flan"
    set udg_SpeciesName[19]="Human"
    set udg_SpeciesName[20]="Kobold"
    set udg_SpeciesName[21]="Ogre"
    set udg_SpeciesName[22]="Golem"
    set udg_SpeciesName[23]="Naga"
    set udg_SpeciesName[24]="Serpent"
    set udg_SpeciesName[25]="Satyr"
    set udg_SpeciesName[26]="Ancient"
    set udg_SpeciesName[27]="Troll"
    set udg_SpeciesName[28]="Dragon"
    set udg_SpeciesName[29]="Chocobo"
    set udg_SpeciesName[30]="Tonberry"
    set udg_SpeciesName[31]="Cactuar"
    set udg_SpeciesName[32]="Malboro"
    set udg_SpeciesName[33]="Behemoth"
    set udg_SpeciesName[34]="Bomb"
    set udg_OversoulKillsNeeded[1]=45
    set udg_OversoulKillsNeeded[2]=25
    set udg_OversoulKillsNeeded[3]=60
    set udg_OversoulKillsNeeded[4]=20
    set udg_OversoulKillsNeeded[5]=20
    set udg_OversoulKillsNeeded[6]=35
    set udg_OversoulKillsNeeded[7]=25
    set udg_OversoulKillsNeeded[8]=30
    set udg_OversoulKillsNeeded[9]=20
    set udg_OversoulKillsNeeded[$A]=25 // $A = 10
    set udg_OversoulKillsNeeded[$B]=25 // $B = 11
    set udg_OversoulKillsNeeded[$C]=$F // $C = 12; $F = 15
    set udg_OversoulKillsNeeded[$D]=$F // $D = 13; $F = 15
    set udg_OversoulKillsNeeded[$E]=$F // $E = 14; $F = 15
    set udg_OversoulKillsNeeded[$F]=$F // $F = 15
    set udg_OversoulKillsNeeded[16]=$F // $F = 15
    set udg_OversoulKillsNeeded[17]=25
    set udg_OversoulKillsNeeded[18]=20
    set udg_OversoulKillsNeeded[19]=25
    set udg_OversoulKillsNeeded[20]=25
    set udg_OversoulKillsNeeded[21]=25
    set udg_OversoulKillsNeeded[22]=25
    set udg_OversoulKillsNeeded[23]=25
    set udg_OversoulKillsNeeded[24]=25
    set udg_OversoulKillsNeeded[25]=25
    set udg_OversoulKillsNeeded[26]=20
    set udg_OversoulKillsNeeded[27]=20
    set udg_OversoulKillsNeeded[28]=25
    set udg_OversoulKillsNeeded[29]=$A // $A = 10
    set udg_OversoulKillsNeeded[30]=8
    set udg_OversoulKillsNeeded[31]=8
    set udg_OversoulKillsNeeded[32]=8
    set udg_OversoulKillsNeeded[33]=$A // $A = 10
    set udg_OversoulKillsNeeded[34]=$A // $A = 10
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Oversoul_OnMonsterDeath_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_STRUCTURE)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_SUMMONED)==false))!=null
endfunction

function Trig_Oversoul_OnMonsterDeath_Cond_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Oversoul_OnMonsterDeath_Cond_ShardIsCharged takes nothing returns boolean
    return(GetItemType(GetLastCreatedItem())==ITEM_TYPE_CHARGED)
endfunction

function Trig_Oversoul_OnMonsterDeath_Cond_VictimOversouled takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A134',GetTriggerUnit())>0) // 'A134': ability "Oversoul"
endfunction

function Trig_Oversoul_OnMonsterDeath_Cond_HasSpecies takes nothing returns boolean
    return(LoadIntegerBJ(1,udg_DropTempInt,udg_MonsterDataHash)>0)
endfunction

function Trig_Oversoul_OnMonsterDeath_Actions takes nothing returns nothing
    set udg_DropTempInt=GetUnitTypeId(GetTriggerUnit())
    if(Trig_Oversoul_OnMonsterDeath_Cond_HasSpecies())then
        if(Trig_Oversoul_OnMonsterDeath_Cond_VictimOversouled())then
            set udg_SpeciesKillCount[LoadIntegerBJ(1,udg_DropTempInt,udg_MonsterDataHash)]=(udg_SpeciesKillCount[LoadIntegerBJ(1,udg_DropTempInt,udg_MonsterDataHash)]/ 2)
            set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
            if(Trig_Oversoul_OnMonsterDeath_Cond_CoinFlip())then
                call CreateItemLoc('I01Z',udg_TempPoint3) // 'I01Z': item "Crystal Shard"
            else
                call CreateItemLoc(udg_LevelItemIdTable[(R2I(SquareRoot(I2R((GetUnitLevel(GetTriggerUnit())/ 2))))+5)],udg_TempPoint3)
            endif
            call RemoveLocation(udg_TempPoint3)
            if(Trig_Oversoul_OnMonsterDeath_Cond_ShardIsCharged())then
                set bj_lastStartedTimer=CreateTimer()
                call TimerStart(bj_lastStartedTimer,1200.,false,function Item_ExpireDrop)
                call SaveBooleanBJ(true,0,GetHandleIdBJ(GetLastCreatedItem()),udg_DropItemHash)
                call SaveBooleanBJ(true,0,GetHandleIdBJ(GetLastCreatedTimerBJ()),udg_DropItemHash)
                call SaveTimerHandleBJ(GetLastCreatedTimerBJ(),1,GetHandleIdBJ(GetLastCreatedItem()),udg_DropItemHash)
                call SaveItemHandleBJ(GetLastCreatedItem(),2,GetHandleIdBJ(GetLastCreatedTimerBJ()),udg_DropItemHash)
            endif
        else
            set udg_SpeciesKillCount[LoadIntegerBJ(1,udg_DropTempInt,udg_MonsterDataHash)]=(udg_SpeciesKillCount[LoadIntegerBJ(1,udg_DropTempInt,udg_MonsterDataHash)]+1)
        endif
    endif
endfunction

function Trig_Oversoul_Activate_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_STRUCTURE)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_SUMMONED)==false)and(GetUnitAbilityLevelSwapped('A134',GetTriggerUnit())<=0))!=null // 'A134': ability "Oversoul"
endfunction

function Trig_Oversoul_Activate_Cond_OversoulReady takes nothing returns boolean
    return(udg_TempInteger>0)and(udg_SpeciesKillCount[udg_TempInteger]>udg_OversoulKillsNeeded[udg_TempInteger])
endfunction

function Trig_Oversoul_Activate_Actions takes nothing returns nothing
    set udg_TempInteger=GetUnitTypeId(GetTriggerUnit())
    set udg_TempInteger=LoadIntegerBJ(1,udg_TempInteger,udg_MonsterDataHash)
    if(Trig_Oversoul_Activate_Cond_OversoulReady())then
        set udg_SpeciesKillCount[udg_TempInteger]=0
        call UnitAddAbilityBJ('ACrk',GetTriggerUnit()) // 'ACrk': object name not found in map data
        call UnitAddAbilityBJ('A134',GetTriggerUnit()) // 'A134': ability "Oversoul"
        call UnitAddAbilityBJ('A133',GetTriggerUnit()) // 'A133': ability "Oversoul Attack Speed"
        call UnitAddAbilityBJ('A0MV',GetTriggerUnit()) // 'A0MV': ability "Plentiful"
        call UnitAddAbilityBJ('A0WN',GetTriggerUnit()) // 'A0WN': ability "Physical Hardness"
        call UnitAddAbilityBJ('A0WP',GetTriggerUnit()) // 'A0WP': ability "Magical Hardness"
        call UnitAddAbilityBJ('ACev',GetTriggerUnit()) // 'ACev': ability "Swiftness"
        call UnitAddAbilityBJ('A0SF',GetTriggerUnit()) // 'A0SF': ability "Command AI"
        call BlzSetUnitBaseDamage(GetTriggerUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetTriggerUnit(),0))*2.2)),0)
        call BlzSetUnitBaseDamage(GetTriggerUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetTriggerUnit(),1))*2.2)),1)
        call BlzSetUnitArmor(GetTriggerUnit(),(BlzGetUnitArmor(GetTriggerUnit())+40.))
        call BlzSetUnitMaxHP(GetTriggerUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())*2.5)))
        call SetUnitLifePercentBJ(GetTriggerUnit(),'d')
        call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
        call UnitResetCooldown(GetTriggerUnit())
        call SetUnitVertexColorBJ(GetTriggerUnit(),.0,.0,40.,10.)
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,$FF) // $FF = 255
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl")
        call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,$FF) // $FF = 255
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateTextTagLocBJ(("|cffffcc00"+(StringCase(udg_SpeciesName[udg_TempInteger],true)+" OVERSOUL")),udg_TempPoint,0,13.,'d','d','d',0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    endif
endfunction

// World Editor calls InitTrig_Oversoul automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Oversoul (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Oversoul takes nothing returns nothing
endfunction

function Register_Oversoul_Tables_Init takes nothing returns nothing
    set gg_trg_Oversoul_Tables_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Oversoul_Tables_Init,5)
    call TriggerAddAction(gg_trg_Oversoul_Tables_Init,function Trig_Oversoul_Tables_Init_Actions)
endfunction

function Register_Oversoul_OnMonsterDeath takes nothing returns nothing
    set gg_trg_Oversoul_OnMonsterDeath=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Oversoul_OnMonsterDeath,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Oversoul_OnMonsterDeath,Condition(function Trig_Oversoul_OnMonsterDeath_Conditions))
    call TriggerAddAction(gg_trg_Oversoul_OnMonsterDeath,function Trig_Oversoul_OnMonsterDeath_Actions)
endfunction

function Register_Oversoul_Activate takes nothing returns nothing
    set gg_trg_Oversoul_Activate=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Oversoul_Activate,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Oversoul_Activate,Condition(function Trig_Oversoul_Activate_Conditions))
    call TriggerAddAction(gg_trg_Oversoul_Activate,function Trig_Oversoul_Activate_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Oversoul takes nothing returns nothing
    call Register_Oversoul_Tables_Init()
    call Register_Oversoul_OnMonsterDeath()
    call Register_Oversoul_Activate()
endfunction

endlibrary

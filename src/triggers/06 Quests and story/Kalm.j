library TKalm requires TForce, TGroup
function Trig_Kalm_News_Init_Filter_IsPlaying takes nothing returns boolean
    return(GetPlayerSlotState(GetFilterPlayer())==PLAYER_SLOT_STATE_PLAYING)
endfunction

function Trig_Kalm_News_Init_Filter_IsUser takes nothing returns boolean
    return(GetPlayerController(GetFilterPlayer())==MAP_CONTROL_USER)
endfunction

function Trig_Kalm_News_Init_Filter_ActivePlayer takes nothing returns boolean
    return GetBooleanAnd(Trig_Kalm_News_Init_Filter_IsPlaying(),Trig_Kalm_News_Init_Filter_IsUser())
endfunction

function Trig_Kalm_News_Init_HasMultiplePlayers takes nothing returns boolean
    return(CountPlayersInForceBJ(Force_Matching(Condition(function Trig_Kalm_News_Init_Filter_ActivePlayer)))>1)
endfunction

function Trig_Kalm_News_Init_Actions takes nothing returns nothing
    set udg_NewsText[1]="|cffffcc00Outsiders Have Arrived|r"
    if(Trig_Kalm_News_Init_HasMultiplePlayers())then
        set udg_NewsText[4]=("At 6:30, outsiders have arrived in Kalm. It is unknown where they came from. One is a night elf huntress. The other "+(I2S(CountPlayersInForceBJ(udg_PlayingPlayers))+" are adventurers, having a Spirit Of Gaya floating behind them."))
    else
        set udg_NewsText[4]="At 6:30, outsiders have arrived in Kalm. It is unknown where they came from. One is a night elf huntress. The other one is an adventurer, having a Spirit Of Gaya floating behind him."
    endif
    set udg_NewsText[2]="|cffffcc00People Went Missing|r"
    set udg_NewsText[5]="Two people went missing recently. Their names are Link and Mid. Link is a swordsman, last seen at the Northern Mountains-Gate. Mid, nephew of Cid, went into Guardia Forest. Know anything? Contact Cid."
    set udg_NewsText[3]="|cffffcc00Dangerous Guardia Forest (Yesterday)|r"
    set udg_NewsText[6]="The fiends in Guardia Forest have recently become more and more aggressive. Four people have been found dead, a number of people cannot fulfill their duties. Can you help? Contact Cid."
    set udg_KalmNpc[1]=gg_unit_n00C_0047
    set udg_KalmNpc[2]=gg_unit_n00Y_0161
    set udg_KalmNpc[3]=gg_unit_n00Z_0055
    set udg_KalmNpc[4]=gg_unit_n00X_0058
    set udg_KalmNpc[5]=gg_unit_n001_0012
    call AddItemToStockBJ('I02V',gg_unit_n001_0012,3,3) // 'I02V': item "Nectar"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Kalm_News_Read_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03R') // 'I03R': item "Kalm News"
endfunction

function Trig_Kalm_News_Read_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call DisplayTimedTextToForce(udg_TempForce,30,udg_NewsText[1])
    call DisplayTimedTextToForce(udg_TempForce,30,udg_NewsText[4])
    call DisplayTimedTextToForce(udg_TempForce,30," ")
    call DisplayTimedTextToForce(udg_TempForce,30,udg_NewsText[2])
    call DisplayTimedTextToForce(udg_TempForce,30,udg_NewsText[5])
    call DisplayTimedTextToForce(udg_TempForce,30," ")
    call DisplayTimedTextToForce(udg_TempForce,30,udg_NewsText[3])
    call DisplayTimedTextToForce(udg_TempForce,30,udg_NewsText[6])
    call DisplayTimedTextToForce(udg_TempForce,30," ")
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Kalm_Init_IsTownUnit takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player(9))
endfunction

function Trig_Kalm_Init_NotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Kalm_Init_NotHero takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_Kalm_Init_NotStructureOrHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Kalm_Init_NotStructure(),Trig_Kalm_Init_NotHero())
endfunction

function Trig_Kalm_Init_IsTownNonHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Kalm_Init_IsTownUnit(),Trig_Kalm_Init_NotStructureOrHero())
endfunction

function Trig_Kalm_Init_HasDevaluingAttack takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QX',GetFilterUnit())>0) // 'A0QX': ability "Devaluing Attack"
endfunction

function Trig_Kalm_Init_IsKalmGuard takes nothing returns boolean
    return GetBooleanAnd(Trig_Kalm_Init_IsTownNonHero(),Trig_Kalm_Init_HasDevaluingAttack())
endfunction

function Trig_Kalm_Init_Actions takes nothing returns nothing
    set udg_SpecialEffect[19]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0010,true)
    call ShowUnitHide(gg_unit_h02G_0160)
    call ShowUnitHide(gg_unit_h02T_0064)
    call PauseUnitBJ(true,gg_unit_h02G_0160)
    call PauseUnitBJ(true,gg_unit_h02T_0064)
    call ShowUnitHide(gg_unit_e01C_0027)
    call ShowUnitHide(gg_unit_e01D_0026)
    call UnitAddAbilityBJ('A0MV',gg_unit_nbld_0014) // 'A0MV': ability "Plentiful"
    call UnitAddAbilityBJ('A0MV',gg_unit_nass_0015) // 'A0MV': ability "Plentiful"
    set udg_CidQuestStage=0
    set udg_TempPoint=GetUnitLoc(gg_unit_Hpb1_0013)
    set udg_KalmGuards=Group_UnitsInRangeOfLoc(8192.,udg_TempPoint,Condition(function Trig_Kalm_Init_IsKalmGuard))
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Kalm takes nothing returns nothing
endfunction
function RegisterR11_Kalm_News_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Kalm_News_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Kalm_News_Init,5.)
    call TriggerAddAction(gg_trg_Kalm_News_Init,function Trig_Kalm_News_Init_Actions)
endfunction
function RegisterR11_Kalm_News_Read takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Kalm_News_Read=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Kalm_News_Read,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Kalm_News_Read,Condition(function Trig_Kalm_News_Read_Conditions))
    call TriggerAddAction(gg_trg_Kalm_News_Read,function Trig_Kalm_News_Read_Actions)
endfunction
function RegisterR11_Kalm_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Kalm_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Kalm_Init,function Trig_Kalm_Init_Actions)
endfunction




endlibrary

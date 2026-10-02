library TNpcTrio requires TPlayerPart01
function Trig_NpcTrio_Group_Init_Actions takes nothing returns nothing
    call GroupAddUnitSimple(gg_unit_n01V_0168,udg_NpcTrioGroup)
    call GroupAddUnitSimple(gg_unit_n01W_0135,udg_NpcTrioGroup)
    call GroupAddUnitSimple(gg_unit_n01X_0134,udg_NpcTrioGroup)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_NpcTrio_Turn_Face_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_NpcTrioGroup))
endfunction

function Trig_NpcTrio_Turn_Face_Cond_TrioAllTurned takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_NpcTrioGroup))
endfunction

function Trig_NpcTrio_Turn_Face_Cond_InTalkRange takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<=udg_TalkRange)
endfunction

function Trig_NpcTrio_Turn_Face_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(Player_GetHero(GetTriggerPlayer()))
    set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
    if(Trig_NpcTrio_Turn_Face_Cond_InTalkRange())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_NpcTrioGroup)
        call SetUnitFacingToFaceLocTimed(GetTriggerUnit(),udg_TempPoint,.25)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        if(Trig_NpcTrio_Turn_Face_Cond_TrioAllTurned())then
            call DisableTrigger(GetTriggeringTrigger())
            call SaveIntegerBJ(1,2,$8C,udg_GameStateHash) // $8C = 140
            call DestroyTrigger(GetTriggeringTrigger())
        endif
    else
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_NpcTrio takes nothing returns nothing
endfunction
function RegisterR11_NpcTrio_Group_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_NpcTrio_Group_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_NpcTrio_Group_Init,2.)
    call TriggerAddAction(gg_trg_NpcTrio_Group_Init,function Trig_NpcTrio_Group_Init_Actions)
endfunction
function RegisterR11_NpcTrio_Turn_Face takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_NpcTrio_Turn_Face=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_NpcTrio_Turn_Face,Player(7),true)
    call TriggerAddCondition(gg_trg_NpcTrio_Turn_Face,Condition(function Trig_NpcTrio_Turn_Face_Conditions))
    call TriggerAddAction(gg_trg_NpcTrio_Turn_Face,function Trig_NpcTrio_Turn_Face_Actions)
endfunction




endlibrary

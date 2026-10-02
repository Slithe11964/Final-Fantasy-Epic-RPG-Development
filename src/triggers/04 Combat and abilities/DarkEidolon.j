library TDarkEidolon
function Trig_DarkEidolon_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_DarkEidolonGroup))
endfunction

function Trig_DarkEidolon_Death_NeedsAward_51 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[51])==false)
endfunction

function Trig_DarkEidolon_Death_AwardPlayer_51 takes nothing returns nothing
    if(Trig_DarkEidolon_Death_NeedsAward_51())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=51
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_DarkEidolon_Death_NeedsAward_32 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[32])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[31]))and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[51]))
endfunction

function Trig_DarkEidolon_Death_AwardPlayer_32 takes nothing returns nothing
    if(Trig_DarkEidolon_Death_NeedsAward_32())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=32
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_DarkEidolon_Death_AllEidolonsDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_DarkEidolonGroup))
endfunction

function Trig_DarkEidolon_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_DarkEidolonGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc(udg_DropItemIdTable[GetUnitPointValue(GetTriggerUnit())],udg_TempPoint)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    call ForForce(udg_PlayingPlayers,function Trig_DarkEidolon_Death_AwardPlayer_51)
    if(Trig_DarkEidolon_Death_AllEidolonsDead())then
        call DisableTrigger(GetTriggeringTrigger())
        call ForceAddPlayerSimple(Player($A),udg_TitleForce[32]) // $A = 10
        call ForForce(udg_PlayingPlayers,function Trig_DarkEidolon_Death_AwardPlayer_32)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DarkEidolon takes nothing returns nothing
endfunction
function RegisterR11_DarkEidolon_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_DarkEidolon_Death=CreateTrigger()
    call DisableTrigger(gg_trg_DarkEidolon_Death)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_E00C_0046,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01S_0045,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01T_0044,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_E00D_0043,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01V_0041,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_U00B_0042,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01U_0040,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01Z_0036,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01N_0035,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H021_0034,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_O00B_0032,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_O00A_0033,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_N02Z_0031,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01W_0039,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01X_0038,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_DarkEidolon_Death,gg_unit_H01Y_0037,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_DarkEidolon_Death,Condition(function Trig_DarkEidolon_Death_Conditions))
    call TriggerAddAction(gg_trg_DarkEidolon_Death,function Trig_DarkEidolon_Death_Actions)
endfunction




endlibrary

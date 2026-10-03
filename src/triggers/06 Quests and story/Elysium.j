library TElysium requires TGroup, TJob, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Elysium_Prepare=null
    trigger gg_trg_Elysium_AssignLegends=null
    trigger gg_trg_Elysium_MarkerTick=null
    // Variables only this module uses.
    trigger array udg_LegendTrigger
    integer array udg_LegendTaskAbility
endglobals

function Trig_Elysium_Prepare_MakeLegendarySpirit takes nothing returns nothing
    call SetUnitVertexColorBJ(GetEnumUnit(),'d',90.,20.,20.)
    call BlzSetUnitName(GetEnumUnit(),("Legendary "+GetUnitName(GetEnumUnit())))
    call UnitRemoveAbilityBJ('AInv',GetEnumUnit()) // 'AInv': standard ability reference "Inventory"
    call SetUnitInvulnerable(GetEnumUnit(),true)
    call UnitAddAbilityBJ('A0VJ',GetEnumUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
endfunction

function Trig_Elysium_Prepare_HideEnumUnit takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
endfunction

function Trig_Elysium_Prepare_Actions takes nothing returns nothing
    set udg_NpcUnit[22]=gg_unit_H00O_0259
    call ShowDestructableBJ(false,gg_dest_DTsb_0068)
    set udg_DarkShopGroup=Group_UnitsInRectOfPlayer(gg_rct_671,Player(9))
    call ForGroupBJ(udg_DarkShopGroup,function Trig_Elysium_Prepare_MakeLegendarySpirit)
    call ShowUnitHide(gg_unit_n0M2_0264)
    call GroupAddUnitSimple(gg_unit_n04U_0189,udg_SecondShrineUnits)
    call GroupAddUnitSimple(gg_unit_n006_0066,udg_SecondShrineUnits)
    call GroupAddUnitSimple(gg_unit_n000_0261,udg_SecondShrineUnits)
    call ForGroupBJ(udg_SecondShrineUnits,function Trig_Elysium_Prepare_HideEnumUnit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Elysium_AssignLegends_IndexLegendByJob takes nothing returns nothing
    local integer l_tempInteger
    set l_tempInteger=Job_GetIndex(GetEnumUnit())
    set udg_NpcUnit[l_tempInteger]=GetEnumUnit()
endfunction

function Trig_Elysium_AssignLegends_Actions takes nothing returns nothing
    call ForGroupBJ(udg_DarkShopGroup,function Trig_Elysium_AssignLegends_IndexLegendByJob)
    set udg_LegendTrigger[0]=gg_trg_Legend_Squire_Talk
    call BlzSetHeroProperName(udg_NpcUnit[0],"Maximilian")
    set udg_LegendTaskAbility[0]='A0KG' // 'A0KG': ability "Legendary Squire Task"
    set udg_LegendTrigger[1]=gg_trg_Legend_Knight_Talk
    call BlzSetHeroProperName(udg_NpcUnit[1],"Siegfried")
    set udg_LegendTaskAbility[1]='A1EE' // 'A1EE': ability "Legendary Knight Task"
    set udg_LegendTrigger[2]=gg_trg_Legend_Archer_Talk
    call BlzSetHeroProperName(udg_NpcUnit[2],"Nevius")
    set udg_LegendTaskAbility[2]='A1CI' // 'A1CI': ability "Legendary Archer Task"
    set udg_LegendTrigger[3]=gg_trg_Legend_Monk_Talk
    call BlzSetHeroProperName(udg_NpcUnit[3],"Trema")
    set udg_LegendTaskAbility[3]='A1EL' // 'A1EL': ability "Legendary Monk Task"
    set udg_LegendTrigger[4]=gg_trg_Legend_Thief_Talk
    call BlzSetHeroProperName(udg_NpcUnit[4],"Rikku")
    set udg_LegendTaskAbility[4]='A1DC' // 'A1DC': ability "Legendary Thief Task"
    set udg_LegendTrigger[5]=gg_trg_Legend_Geomancer_Talk
    call BlzSetHeroProperName(udg_NpcUnit[5],"Ken Madoushi")
    set udg_LegendTaskAbility[5]='A1E1' // 'A1E1': ability "Legendary Geomancer Task"
    set udg_LegendTrigger[6]=gg_trg_Legend_Samurai_Talk
    call BlzSetHeroProperName(udg_NpcUnit[6],"Kildor")
    set udg_LegendTaskAbility[6]='A1CJ' // 'A1CJ': ability "Legendary Samurai Task"
    set udg_LegendTrigger[7]=gg_trg_Legend_Lancer_Talk
    call BlzSetHeroProperName(udg_NpcUnit[7],"Highwind")
    set udg_LegendTaskAbility[7]='A1EM' // 'A1EM': ability "Legendary Lancer Task"
    set udg_LegendTrigger[8]=gg_trg_Legend_Ninja_Talk
    call BlzSetHeroProperName(udg_NpcUnit[8],"Dana")
    set udg_LegendTaskAbility[8]='A1CK' // 'A1CK': ability "Legendary Ninja Task"
    set udg_LegendTrigger[9]=gg_trg_Legend_HolySwordsman_Talk
    call BlzSetHeroProperName(udg_NpcUnit[9],"Cecil")
    set udg_LegendTaskAbility[9]='A1EN' // 'A1EN': ability "Legendary Holy Swordsman Task"
    set udg_LegendTrigger[$A]=gg_trg_Legend_Chemist_Talk // $A = 10
    call BlzSetHeroProperName(udg_NpcUnit[$A],"Quina") // $A = 10
    set udg_LegendTaskAbility[$A]='A1DF' // $A = 10; 'A1DF': ability "Legendary Chemist Task"
    set udg_LegendTrigger[$B]=gg_trg_Legend_Wizard_Talk // $B = 11
    call BlzSetHeroProperName(udg_NpcUnit[$B],"Rubicante") // $B = 11
    set udg_LegendTaskAbility[$B]='A1DD' // $B = 11; 'A1DD': ability "Legendary Wizard Task"
    set udg_LegendTrigger[$C]=gg_trg_Legend_Priest_Talk // $C = 12
    call BlzSetHeroProperName(udg_NpcUnit[$C],"Minwu") // $C = 12
    set udg_LegendTaskAbility[$C]='A1EO' // $C = 12; 'A1EO': ability "Legendary Priest Task"
    set udg_LegendTrigger[$D]=gg_trg_Legend_Summoner_Talk // $D = 13
    call BlzSetHeroProperName(udg_NpcUnit[$D],"Priscilla") // $D = 13
    set udg_LegendTaskAbility[$D]='A1EK' // $D = 13; 'A1EK': ability "Legendary Summoner Task"
    set udg_NpcUnit[$E]=gg_unit_H00O_0259 // $E = 14
    set udg_LegendTrigger[$E]=gg_trg_Legend_TimeMage_Talk // $E = 14
    set udg_LegendTrigger[$F]=gg_trg_Legend_Mediator_Talk // $F = 15
    call BlzSetHeroProperName(udg_NpcUnit[$F],"Alberich") // $F = 15
    set udg_LegendTaskAbility[$F]='A1E3' // $F = 15; 'A1E3': ability "Legendary Mediator Task"
    set udg_LegendTrigger[16]=gg_trg_Legend_Oracle_Talk
    call BlzSetHeroProperName(udg_NpcUnit[16],"Zeratul")
    set udg_LegendTaskAbility[16]='A0KC' // 'A0KC': ability "Legendary Oracle Task"
    set udg_LegendTrigger[17]=gg_trg_Legend_Calculator_Talk
    call BlzSetHeroProperName(udg_NpcUnit[17],"Mid")
    set udg_LegendTaskAbility[17]='A1DE' // 'A1DE': ability "Legendary Calculator Task"
    set udg_LegendTrigger[18]=gg_trg_Legend_Prophet_Talk
    call BlzSetHeroProperName(udg_NpcUnit[18],"Medivh")
    set udg_LegendTaskAbility[18]='A0KE' // 'A0KE': ability "Legendary Prophet Task"
    set udg_LegendTrigger[19]=gg_trg_Legend_Sorcerer_Talk
    call BlzSetHeroProperName(udg_NpcUnit[19],"Hugo Fact")
    set udg_LegendTaskAbility[19]='A0KD' // 'A0KD': ability "Legendary Sorcerer Task"
    set udg_LegendTrigger[20]=gg_trg_Legend_DarkKnight_Talk
    call BlzSetHeroProperName(udg_NpcUnit[20],"Cecil")
    set udg_LegendTaskAbility[20]='A1DY' // 'A1DY': ability "Legendary Dark Knight Task"
    set udg_LegendTrigger[21]=gg_trg_Legend_Necromancer_Talk
    call BlzSetHeroProperName(udg_NpcUnit[21],"Enuo")
    set udg_LegendTaskAbility[21]='A1E2' // 'A1E2': ability "Legendary Necromancer Task"
    set udg_LegendTrigger[22]=gg_trg_Legend_Freelancer_Talk
    call UnitRemoveAbilityBJ('A1FD',udg_NpcUnit[5]) // 'A1FD': ability "Gaya Strength Aura"
    call UnitRemoveAbilityBJ('A1EP',udg_NpcUnit[6]) // 'A1EP': ability "Rendan Aura"
    call GroupRemoveUnitSimple(udg_NpcUnit[20],udg_DarkShopGroup)
    call GroupRemoveUnitSimple(udg_NpcUnit[21],udg_DarkShopGroup)
    set udg_NullElementForce[0]=GetPlayersAll()
    set udg_NullElementForce[7]=GetPlayersAll()
    set udg_WeakElementForce[0]=GetPlayersAll()
    set udg_WeakElementForce[7]=GetPlayersAll()
    set udg_LegendMarker[22]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H00O_0259,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_QuestStage[$E]=5 // $E = 14
    set udg_QuestStage[22]=6
    call EnableTrigger(gg_trg_Andre_Elysium_Reveal)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Elysium_MarkerTick_Cond_TimeMageTalked takes nothing returns boolean
    return(udg_QuestStage[$E]==2)or(udg_QuestStage[$E]==4) // $E = 14
endfunction

function Trig_Elysium_MarkerTick_Cond_IsUltimateFreelancer takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A15I',Player_GetHero(GetEnumPlayer()))>0)and(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(GetEnumPlayer()))==3) // 'A15I': ability "Versatility"; 'A02F': ability "Mastery"
endfunction

function Trig_Elysium_MarkerTick_FlagFreelancerFound takes nothing returns nothing
    if(Trig_Elysium_MarkerTick_Cond_IsUltimateFreelancer())then
        set udg_TempBoolean=true
    endif
endfunction

function Trig_Elysium_MarkerTick_Cond_FreelancerMarkerStale takes nothing returns boolean
    return(udg_QuestStage[24]==1)and(udg_TempBoolean==false)
endfunction

function Trig_Elysium_MarkerTick_Cond_TimeMage_State2 takes nothing returns boolean
    return(udg_QuestStage[$E]==2) // $E = 14
endfunction

function Trig_Elysium_MarkerTick_Cond_FreelancerMarkerNeeded takes nothing returns boolean
    return(udg_QuestStage[24]==0)and(udg_TempBoolean)
endfunction

function Trig_Elysium_MarkerTick_Cond_FreelancerStepOpen takes nothing returns boolean
    return(Trig_Elysium_MarkerTick_Cond_TimeMageTalked())and(udg_QuestStage[22]==7)and(udg_QuestStage[23]==1)and(udg_QuestStage[24]<=1)
endfunction

function Trig_Elysium_MarkerTick_Cond_AnyJobStarted takes nothing returns boolean
    return(GetForLoopIndexA()!=$E)and(udg_QuestStage[GetForLoopIndexA()]>=2) // $E = 14
endfunction

function Trig_Elysium_MarkerTick_Cond_AndreState5 takes nothing returns boolean
    return(udg_QuestStage[22]==5)
endfunction

function Trig_Elysium_MarkerTick_Cond_JobTalked takes nothing returns boolean
    return(udg_QuestStage[GetForLoopIndexA()]==2)or(udg_QuestStage[GetForLoopIndexA()]==4)
endfunction

function Trig_Elysium_MarkerTick_Cond_IsUltimateMaster takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetEnumPlayer()))==udg_JobUnitType[GetForLoopIndexA()])and(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(GetEnumPlayer()))==3) // 'A02F': ability "Mastery"
endfunction

function Trig_Elysium_MarkerTick_FlagUltimateMasterFound takes nothing returns nothing
    if(Trig_Elysium_MarkerTick_Cond_IsUltimateMaster())then
        set udg_TempBoolean=true
    endif
endfunction

function Trig_Elysium_MarkerTick_Cond_MasterFound takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Elysium_MarkerTick_Cond_JobTaskGiven takes nothing returns boolean
    return(udg_QuestStage[GetForLoopIndexA()]==4)
endfunction

function Trig_Elysium_MarkerTick_Cond_JobTalkedAndBriefed takes nothing returns boolean
    return(Trig_Elysium_MarkerTick_Cond_JobTalked())and(udg_QuestStage[22]==7)
endfunction

function Trig_Elysium_MarkerTick_Cond_IsJobHero takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetEnumPlayer()))==udg_JobUnitType[GetForLoopIndexA()])
endfunction

function Trig_Elysium_MarkerTick_FlagJobHeroFound takes nothing returns nothing
    if(Trig_Elysium_MarkerTick_Cond_IsJobHero())then
        set udg_TempBoolean=true
    endif
endfunction

function Trig_Elysium_MarkerTick_Cond_JobUntouched takes nothing returns boolean
    return(udg_QuestStage[GetForLoopIndexA()]==0)
endfunction

function Trig_Elysium_MarkerTick_Cond_NoMatchFound takes nothing returns boolean
    return(udg_TempBoolean==false)
endfunction

function Trig_Elysium_MarkerTick_Cond_MatchFound takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Elysium_MarkerTick_Cond_JobStateEven takes nothing returns boolean
    // The remainder after dividing (udg_QuestStage at position loop counter A) by (2).
    return(ModuloInteger(udg_QuestStage[GetForLoopIndexA()],2)==0)
endfunction

function Trig_Elysium_MarkerTick_Cond_JobStateBelow4 takes nothing returns boolean
    return(udg_QuestStage[GetForLoopIndexA()]<=3)
endfunction

function Trig_Elysium_MarkerTick_Cond_JobStateBelow5 takes nothing returns boolean
    return(udg_QuestStage[GetForLoopIndexA()]<=4)
endfunction

function Trig_Elysium_MarkerTick_Actions takes nothing returns nothing
    if(Trig_Elysium_MarkerTick_Cond_AndreState5())then
        set bj_forLoopAIndex=0
        // (udg_JobCount) minus (1).
        set bj_forLoopAIndexEnd=(udg_JobCount-1)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Elysium_MarkerTick_Cond_AnyJobStarted())then
                set udg_QuestStage[22]=6
                call StartTimerBJ(udg_UnitUpdateTimer,false,.2)
                set udg_LegendMarker[22]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H00O_0259,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                call EnableTrigger(gg_trg_Andre_Legendary_Rules)
                return
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    else
        if(Trig_Elysium_MarkerTick_Cond_FreelancerStepOpen())then
            set udg_TempBoolean=false
            call ForForce(udg_PlayingPlayers,function Trig_Elysium_MarkerTick_FlagFreelancerFound)
            if(Trig_Elysium_MarkerTick_Cond_FreelancerMarkerNeeded())then
                if(Trig_Elysium_MarkerTick_Cond_TimeMage_State2())then
                    set udg_QuestStage[$E]=4 // $E = 14
                endif
                set udg_LegendMarker[22]=AddSpecialEffectTargetUnitBJ("overhead",udg_NpcUnit[22],"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                set udg_QuestStage[24]=1
                call EnableTrigger(udg_LegendTrigger[22])
            else
                if(Trig_Elysium_MarkerTick_Cond_FreelancerMarkerStale())then
                    call DestroyEffectBJ(udg_LegendMarker[22])
                    set udg_QuestStage[24]=0
                    call DisableTrigger(udg_LegendTrigger[22])
                endif
            endif
        endif
    endif
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_JobCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Elysium_MarkerTick_Cond_JobStateBelow5())then
            set udg_TempBoolean=false
            if(Trig_Elysium_MarkerTick_Cond_JobUntouched())then
                call ForForce(udg_PlayingPlayers,function Trig_Elysium_MarkerTick_FlagJobHeroFound)
            else
                if(Trig_Elysium_MarkerTick_Cond_JobTalkedAndBriefed())then
                    call ForForce(udg_PlayingPlayers,function Trig_Elysium_MarkerTick_FlagUltimateMasterFound)
                    if(Trig_Elysium_MarkerTick_Cond_JobTaskGiven())then
                        if(Trig_Elysium_MarkerTick_Cond_MasterFound())then
                            call UnitAddAbilityBJ(udg_LegendTaskAbility[GetForLoopIndexA()],gg_unit_H00O_0259)
                        else
                            call UnitRemoveAbilityBJ(udg_LegendTaskAbility[GetForLoopIndexA()],gg_unit_H00O_0259)
                        endif
                    endif
                endif
            endif
            if(Trig_Elysium_MarkerTick_Cond_JobStateBelow4())then
                if(Trig_Elysium_MarkerTick_Cond_JobStateEven())then
                    if(Trig_Elysium_MarkerTick_Cond_MatchFound())then
                        set udg_LegendMarker[GetForLoopIndexA()]=AddSpecialEffectTargetUnitBJ("overhead",udg_NpcUnit[GetForLoopIndexA()],"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                        set udg_QuestStage[GetForLoopIndexA()]=(udg_QuestStage[GetForLoopIndexA()]+1)
                        call EnableTrigger(udg_LegendTrigger[GetForLoopIndexA()])
                    endif
                else
                    if(Trig_Elysium_MarkerTick_Cond_NoMatchFound())then
                        call DestroyEffectBJ(udg_LegendMarker[GetForLoopIndexA()])
                        set udg_QuestStage[GetForLoopIndexA()]=(udg_QuestStage[GetForLoopIndexA()]-1)
                        call DisableTrigger(udg_LegendTrigger[GetForLoopIndexA()])
                    endif
                endif
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

// World Editor calls InitTrig_Elysium automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Elysium (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Elysium takes nothing returns nothing
endfunction

function Register_Elysium_Prepare takes nothing returns nothing
    set gg_trg_Elysium_Prepare=CreateTrigger()
    call TriggerAddAction(gg_trg_Elysium_Prepare,function Trig_Elysium_Prepare_Actions)
endfunction

function Register_Elysium_AssignLegends takes nothing returns nothing
    set gg_trg_Elysium_AssignLegends=CreateTrigger()
    call DisableTrigger(gg_trg_Elysium_AssignLegends)
    call TriggerAddAction(gg_trg_Elysium_AssignLegends,function Trig_Elysium_AssignLegends_Actions)
endfunction

function Register_Elysium_MarkerTick takes nothing returns nothing
    set gg_trg_Elysium_MarkerTick=CreateTrigger()
    call DisableTrigger(gg_trg_Elysium_MarkerTick)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Elysium_MarkerTick,udg_UnitUpdateTimer)
    call TriggerAddAction(gg_trg_Elysium_MarkerTick,function Trig_Elysium_MarkerTick_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Elysium takes nothing returns nothing
    call Register_Elysium_Prepare() // run by MapBootstrap
    call Register_Elysium_AssignLegends() // starts off; run by Init
    call Register_Elysium_MarkerTick() // starts off; enabled by Andre
endfunction

endlibrary

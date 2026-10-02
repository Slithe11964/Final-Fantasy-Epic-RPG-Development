library TFreelancer requires TJob, TPlayerPart01
function Trig_Freelancer_Stats_Conditions takes nothing returns boolean
    return(GetUnitName(Player_GetHero(ConvertedPlayer(udg_TempInteger)))=="Freelancer")
endfunction

function Trig_Freelancer_Stats_MasteryIsThree takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(ConvertedPlayer(udg_TempInteger)))==3) // 'A02F': ability "Mastery"
endfunction

function Trig_Freelancer_Stats_MasteryIsTwo takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(ConvertedPlayer(udg_TempInteger)))==2) // 'A02F': ability "Mastery"
endfunction

function Trig_Freelancer_Stats_HasMastery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(ConvertedPlayer(udg_TempInteger)))>1) // 'A02F': ability "Mastery"
endfunction

function Trig_Freelancer_Stats_IsOddIndex takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (2).
    return(ModuloInteger(GetForLoopIndexA(),2)==1)
endfunction

function Trig_Freelancer_Stats_IsNinthIndex takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (9).
    return(ModuloInteger(GetForLoopIndexA(),9)==0)
endfunction

function Trig_Freelancer_Stats_IsJobMastered takes nothing returns boolean
    return(Job_GetSavedLevel(ConvertedPlayer(udg_TempInteger),udg_JobUnitType[GetForLoopIndexA()])>=99)
endfunction

function Trig_Freelancer_Stats_IsMageJobMastered takes nothing returns boolean
    return(Job_GetSavedLevel(ConvertedPlayer(udg_TempInteger),udg_JobUnitType[GetForLoopIndexA()])>=99)
endfunction

function Trig_Freelancer_Stats_IsJob20Mastered takes nothing returns boolean
    return(Job_GetSavedLevel(ConvertedPlayer(udg_TempInteger),udg_JobUnitType[20])>=99)
endfunction

function Trig_Freelancer_Stats_IsJob21Mastered takes nothing returns boolean
    return(Job_GetSavedLevel(ConvertedPlayer(udg_TempInteger),udg_JobUnitType[21])>=99)
endfunction

function Trig_Freelancer_Stats_MasteryIsFour takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(ConvertedPlayer(udg_TempInteger)))==4) // 'A02F': ability "Mastery"
endfunction

function Trig_Freelancer_Stats_IsAgilityFreelancer takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(ConvertedPlayer(udg_TempInteger)))=='H02M')or(GetUnitTypeId(Player_GetHero(ConvertedPlayer(udg_TempInteger)))=='H02P') // 'H02M': unit "Freelancer"; 'H02P': unit "Freelancer"
endfunction

function Trig_Freelancer_Stats_IsAgilityVariant takes nothing returns boolean
    return(Trig_Freelancer_Stats_IsAgilityFreelancer())
endfunction

function Trig_Freelancer_Stats_IsStrengthFreelancer takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(ConvertedPlayer(udg_TempInteger)))=='H02L')or(GetUnitTypeId(Player_GetHero(ConvertedPlayer(udg_TempInteger)))=='H02O') // 'H02L': unit "Freelancer"; 'H02O': unit "Freelancer"
endfunction

function Trig_Freelancer_Stats_IsStrengthVariant takes nothing returns boolean
    return(Trig_Freelancer_Stats_IsStrengthFreelancer())
endfunction

function Trig_Freelancer_Stats_RangedCheck36 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Freelancer_Stats_RangedCheck37 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Freelancer_Stats_RangedCheck38 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Freelancer_Stats_RangedCheck57 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Freelancer_Stats_RangedCheck58 takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Freelancer_Stats_InBonusGroup58 takes nothing returns boolean
    return(IsUnitInGroup(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[58]))
endfunction

function Trig_Freelancer_Stats_InBonusGroup57 takes nothing returns boolean
    return(IsUnitInGroup(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[57]))
endfunction

function Trig_Freelancer_Stats_InBonusGroup38 takes nothing returns boolean
    return(IsUnitInGroup(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[38]))
endfunction

function Trig_Freelancer_Stats_InBonusGroup37 takes nothing returns boolean
    return(IsUnitInGroup(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[37]))
endfunction

function Trig_Freelancer_Stats_InBonusGroup36 takes nothing returns boolean
    return(IsUnitInGroup(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[36]))and(IsPlayerInForce(ConvertedPlayer(udg_TempInteger),udg_CheaterForce)==false)
endfunction

function Trig_Freelancer_Stats_HasBonusValue takes nothing returns boolean
    return(udg_BonusValue[GetForLoopIndexA()]>0)
endfunction

function Trig_Freelancer_Stats_Actions takes nothing returns nothing
    call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_SET,$A) // $A = 10
    call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_SET,$A) // $A = 10
    call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_SET,$A) // $A = 10
    if(Trig_Freelancer_Stats_HasMastery())then
        if(Trig_Freelancer_Stats_MasteryIsTwo())then
            call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,20)
            call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,20)
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,20)
        else
            if(Trig_Freelancer_Stats_MasteryIsThree())then
                call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,50)
                call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,50)
                call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,50)
            else
                call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,90)
                call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,90)
                call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,90)
            endif
        endif
    endif
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=9
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Freelancer_Stats_IsJobMastered())then
            if(Trig_Freelancer_Stats_IsNinthIndex())then
                call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,24)
                call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,24)
            else
                if(Trig_Freelancer_Stats_IsOddIndex())then
                    call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,48)
                else
                    call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,48)
                endif
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=$A // $A = 10
    set bj_forLoopAIndexEnd=19
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Freelancer_Stats_IsMageJobMastered())then
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,24)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Freelancer_Stats_IsJob20Mastered())then
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,16)
        call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,16)
    endif
    if(Trig_Freelancer_Stats_IsJob21Mastered())then
        call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,16)
    endif
    if(Trig_Freelancer_Stats_MasteryIsFour())then
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,$A) // $A = 10
        call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,$A) // $A = 10
        call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,$A) // $A = 10
    endif
    if(Trig_Freelancer_Stats_IsStrengthVariant())then
        // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) plus (39).
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))+39))
        // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) divided by (2).
        call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))/ 2))
        // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) divided by (2).
        call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))/ 2))
    else
        // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) divided by (2).
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))/ 2))
        if(Trig_Freelancer_Stats_IsAgilityVariant())then
            // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) plus (39).
            call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))+39))
            // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) divided by (2).
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))/ 2))
        else
            // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) divided by (2).
            call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))/ 2))
            // (hero level of Player_GetHero(ConvertedPlayer(udg_TempInteger))) plus (39).
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),bj_MODIFYMETHOD_ADD,(GetHeroLevel(Player_GetHero(ConvertedPlayer(udg_TempInteger)))+39))
        endif
    endif
    call UnitRemoveAbilityBJ('A10E',Player_GetHero(ConvertedPlayer(udg_TempInteger))) // 'A10E': ability "Endless"
    if(Trig_Freelancer_Stats_InBonusGroup36())then
        if(Trig_Freelancer_Stats_RangedCheck36())then
            // Calculation 1:
            // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 0)) minus (20).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),0)-20),(1-1))
        else
            // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 1)) minus (20).
            call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),1)-20),1)
        endif
        // (BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))) minus (5).
        call BlzSetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))-5.))
        call GroupRemoveUnitSimple(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[36])
        if(Trig_Freelancer_Stats_InBonusGroup37())then
            if(Trig_Freelancer_Stats_RangedCheck37())then
                // Calculation 1:
                // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 0)) minus (20).
                // Calculation 2:
                // (1) minus (1).
                call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),0)-20),(1-1))
            else
                // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 1)) minus (20).
                call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),1)-20),1)
            endif
            // (BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))) minus (5).
            call BlzSetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))-5.))
            call GroupRemoveUnitSimple(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[37])
            if(Trig_Freelancer_Stats_InBonusGroup38())then
                if(Trig_Freelancer_Stats_RangedCheck38())then
                    // Calculation 1:
                    // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 0)) minus (20).
                    // Calculation 2:
                    // (1) minus (1).
                    call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),0)-20),(1-1))
                else
                    // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 1)) minus (20).
                    call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),1)-20),1)
                endif
                // (BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))) minus (5).
                call BlzSetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))-5.))
                call GroupRemoveUnitSimple(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[38])
                if(Trig_Freelancer_Stats_InBonusGroup57())then
                    if(Trig_Freelancer_Stats_RangedCheck57())then
                        // Calculation 1:
                        // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 0)) minus (20).
                        // Calculation 2:
                        // (1) minus (1).
                        call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),0)-20),(1-1))
                    else
                        // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 1)) minus (20).
                        call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),1)-20),1)
                    endif
                    // (BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))) minus (5).
                    call BlzSetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))-5.))
                    call GroupRemoveUnitSimple(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[57])
                    if(Trig_Freelancer_Stats_InBonusGroup58())then
                        if(Trig_Freelancer_Stats_RangedCheck58())then
                            // Calculation 1:
                            // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 0)) minus (20).
                            // Calculation 2:
                            // (1) minus (1).
                            call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),0)-20),(1-1))
                        else
                            // (BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 1)) minus (20).
                            call BlzSetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitBaseDamage(Player_GetHero(ConvertedPlayer(udg_TempInteger)),1)-20),1)
                        endif
                        // (BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))) minus (5).
                        call BlzSetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)),(BlzGetUnitArmor(Player_GetHero(ConvertedPlayer(udg_TempInteger)))-5.))
                        call GroupRemoveUnitSimple(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[58])
                    endif
                endif
            endif
        endif
    endif
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd='d'
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Freelancer_Stats_HasBonusValue())then
            call GroupRemoveUnitSimple(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_BonusGroup[GetForLoopIndexA()])
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Freelancer takes nothing returns nothing
endfunction
function RegisterR11_Freelancer_Stats takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Freelancer_Stats=CreateTrigger()
    call DisableTrigger(gg_trg_Freelancer_Stats)
    call TriggerAddCondition(gg_trg_Freelancer_Stats,Condition(function Trig_Freelancer_Stats_Conditions))
    call TriggerAddAction(gg_trg_Freelancer_Stats,function Trig_Freelancer_Stats_Actions)
endfunction




endlibrary

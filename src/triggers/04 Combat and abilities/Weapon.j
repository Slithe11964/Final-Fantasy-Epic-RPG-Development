library TWeapon requires TPlayerPart01
function Trig_Weapon_Research_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))
endfunction

function Trig_Weapon_Research_HasWeaponSkill10 takes nothing returns boolean
    return(GetPlayerTechCountSimple('R000',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R001',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R002',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R008',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R009',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00A',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00B',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00N',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R003',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R004',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00M',udg_TempPlayer)>=$A)or(GetPlayerTechCountSimple('R00L',udg_TempPlayer)>=$A) // 'R000': upgrade "Tools"; $A = 10; 'R001': upgrade "Sword"; 'R002': upgrade "Bow"; 'R008': upgrade "Axe"; 'R009': upgrade "Spear"; 'R00A': upgrade "Katana"; 'R00B': upgrade "Dagger"; 'R00N': upgrade "Greatsword"; 'R003': upgrade "Rod"; 'R004': upgrade "Staff"; 'R00M': upgrade "Gun"; 'R00L': upgrade "Inner Mana"
endfunction

function Trig_Weapon_Research_CanCompleteWeaponQuest takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[35])==false)and(Trig_Weapon_Research_HasWeaponSkill10())
endfunction

function Trig_Weapon_Research_Actions takes nothing returns nothing
    set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
    if(Trig_Weapon_Research_CanCompleteWeaponQuest())then
        set udg_TempInteger=35
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
        call ConditionalTriggerExecute(gg_trg_Title_ArmsCollection)
    endif
    set udg_CurrentHero=Player_GetHero(GetOwningPlayer(GetTriggerUnit()))
    call ConditionalTriggerExecute(gg_trg_Unit_ApplyUpgradeBonuses)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Weapon takes nothing returns nothing
endfunction
function RegisterR11_Weapon_Research takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Weapon_Research=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Weapon_Research,EVENT_PLAYER_UNIT_RESEARCH_FINISH)
    call TriggerAddCondition(gg_trg_Weapon_Research,Condition(function Trig_Weapon_Research_Conditions))
    call TriggerAddAction(gg_trg_Weapon_Research,function Trig_Weapon_Research_Actions)
endfunction




endlibrary

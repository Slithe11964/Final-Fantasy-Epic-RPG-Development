library TJob requires TBerserk, TForce, TGayaShared, TGroup, THeroSkills, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Job_Change=null
    trigger gg_trg_Job_XP_Handicap=null
    // Variables only this module uses.
    real udg_SavedLifePercent=0
    real udg_SavedManaPercent=0
    unit udg_NewHero=null
    boolean udg_JobUnlocked=false
    location udg_HeroLoc=null
    item array udg_SavedItem
    real udg_SavedFacing=0
    integer udg_SelectedJobId=0
endglobals

function Job_GetIndex takes unit u returns integer
    local integer i=0
    if(GetUnitAbilityLevel(u,'A15I')>0)then // 'A15I': ability "Versatility"
        return udg_JobCount
    endif
    loop
        exitwhen udg_JobUnitType[i]==null
        if(udg_JobUnitType[i]==GetUnitTypeId(u))then
            return i
        endif
        set i=i+1
    endloop
    return-1
endfunction

function Job_MaxSkills takes unit l_hero returns nothing
    local integer i
    local integer l_variantLevel=0
    local player p
    if(GetHeroLevel(l_hero)<50)then
        return
    endif
    set i=Job_GetIndex(l_hero)
    if(i==-1)then
        return
    endif
    set l_variantLevel=GetUnitAbilityLevel(l_hero,'A0SI') // 'A0SI': ability "Enchantment Variant"
    if l_variantLevel>1 then
        call SetUnitAbilityLevel(l_hero,'A0SI',1) // 'A0SI': ability "Enchantment Variant"
    endif
    // ((i) times (5)) plus (1).
    call Hero_LearnSkillTo(l_hero,udg_JobSkill[i*5+1],$B) // $B = 11
    // ((i) times (5)) plus (2).
    call Hero_LearnSkillTo(l_hero,udg_JobSkill[i*5+2],$B) // $B = 11
    // ((i) times (5)) plus (3).
    call Hero_LearnSkillTo(l_hero,udg_JobSkill[i*5+3],$B) // $B = 11
    // ((i) times (5)) plus (4).
    call Hero_LearnSkillTo(l_hero,udg_JobSkill[i*5+4],$B) // $B = 11
    // ((i) times (5)) plus (5).
    call Hero_LearnSkillTo(l_hero,udg_JobSkill[i*5+5],6)
    if l_variantLevel>1 then
        call SetUnitAbilityLevel(l_hero,'A0SI',l_variantLevel) // 'A0SI': ability "Enchantment Variant"
    endif
    if i==$A then // $A = 10
        set i=1
        set p=GetOwningPlayer(l_hero)
        loop
            exitwhen i>$A // $A = 10
            call SetPlayerAbilityAvailable(p,udg_BrewAbility[i],true)
            set i=i+1
        endloop
        call UnitRemoveAbility(l_hero,'A1AJ') // 'A1AJ': ability "Alchemy"
        call UnitAddAbility(l_hero,'A1AI') // 'A1AI': ability "Alchemy"
        set p=null
    endif
endfunction

function Job_GetSavedLevel takes player l_p,integer l_jobID returns integer
    local unit l_jobUnit=LoadUnitHandle(udg_JobHeroHash,l_jobID,GetPlayerId(l_p))
    if(l_jobUnit!=null)then
        if(GetUnitAbilityLevel(l_jobUnit,'A02F')>=4)then // 'A02F': ability "Mastery"
            return 'd'
        else
            return GetHeroLevel(l_jobUnit)
        endif
    endif
    return LoadInteger(udg_JobLevelHash,l_jobID,GetPlayerId(l_p))
endfunction

function Job_GetHero takes player l_owner,integer l_jobId returns unit
    local unit l_hero=LoadUnitHandle(udg_JobHeroHash,l_jobId,GetPlayerId(l_owner))
    local integer l_savedLevel
    if(l_hero!=null)then
        return l_hero
    endif
    set l_hero=CreateUnit(l_owner,l_jobId,GetUnitX(gg_unit_Hpb1_0013),GetUnitY(gg_unit_Hpb1_0013),0)
    // (GetPlayerId(l_owner)) plus (1).
    call BlzSetHeroProperName(l_hero,udg_PlayerName[GetPlayerId(l_owner)+1])
    set l_savedLevel=LoadInteger(udg_JobLevelHash,l_jobId,GetPlayerId(l_owner))
    if(l_savedLevel>1)then
        if(l_savedLevel=='d')then
            call SetUnitAbilityLevel(l_hero,'A02F',4) // 'A02F': ability "Mastery"
            // (Strength of l_hero) plus (100).
            call SetHeroStr(l_hero,GetHeroStr(l_hero,false)+'d',true)
            // (Agility of l_hero) plus (100).
            call SetHeroAgi(l_hero,GetHeroAgi(l_hero,false)+'d',true)
            // (Intelligence of l_hero) plus (100).
            call SetHeroInt(l_hero,GetHeroInt(l_hero,false)+'d',true)
            set l_savedLevel=99
        elseif(l_savedLevel==99)then
            call SetUnitAbilityLevel(l_hero,'A02F',3) // 'A02F': ability "Mastery"
            // (Strength of l_hero) plus (50).
            call SetHeroStr(l_hero,GetHeroStr(l_hero,false)+50,true)
            // (Agility of l_hero) plus (50).
            call SetHeroAgi(l_hero,GetHeroAgi(l_hero,false)+50,true)
            // (Intelligence of l_hero) plus (50).
            call SetHeroInt(l_hero,GetHeroInt(l_hero,false)+50,true)
        elseif(l_savedLevel>=50)then
            call SetUnitAbilityLevel(l_hero,'A02F',2) // 'A02F': ability "Mastery"
            // (Strength of l_hero) plus (20).
            call SetHeroStr(l_hero,GetHeroStr(l_hero,false)+20,true)
            // (Agility of l_hero) plus (20).
            call SetHeroAgi(l_hero,GetHeroAgi(l_hero,false)+20,true)
            // (Intelligence of l_hero) plus (20).
            call SetHeroInt(l_hero,GetHeroInt(l_hero,false)+20,true)
        endif
        call SetHeroLevel(l_hero,l_savedLevel,false)
        call Job_MaxSkills(l_hero)
    endif
    if(IsPlayerInForce(l_owner,udg_CheaterForce))then
        call SetHeroStr(l_hero,5,true)
        call SetHeroAgi(l_hero,5,true)
        call SetHeroInt(l_hero,5,true)
    endif
    call SaveUnitHandle(udg_JobHeroHash,l_jobId,GetPlayerId(l_owner),l_hero)
    call Gaya_RecreateSpirit(l_owner)
    return l_hero
endfunction

// ---- Job ----
function Trig_Job_Change_IsJobShrine takes nothing returns boolean
    return(GetSellingUnit()==gg_unit_n006_0063)or(GetSellingUnit()==gg_unit_n000_0010)or(GetSellingUnit()==gg_unit_n04U_0204)or(GetSellingUnit()==gg_unit_n006_0066)or(GetSellingUnit()==gg_unit_n000_0261)or(GetSellingUnit()==gg_unit_n04U_0189)
endfunction

function Trig_Job_Change_Conditions takes nothing returns boolean
    return(Trig_Job_Change_IsJobShrine())and(GetUnitTypeId(GetSoldUnit())!='n00W')and(GetUnitTypeId(GetSoldUnit())!='n07I')and(GetUnitTypeId(GetSoldUnit())!='n0KL') // 'n00W': unit "Help"; 'n07I': unit "Ability Menu"; 'n0KL': unit "Legendary Bonus Menu"
endfunction

function Trig_Job_Change_IsSameJob takes nothing returns boolean
    return(udg_SelectedJobId==GetUnitTypeId(Player_GetHero(udg_TempPlayer)))
endfunction

function Trig_Job_Change_IsBuyerOwnHero takes nothing returns boolean
    return(GetBuyingUnit()==Player_GetHero(udg_TempPlayer))or(GetBuyingUnit()==udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])
endfunction

function Trig_Job_Change_IsValidBuyer takes nothing returns boolean
    return(GetBuyingUnit()!=null)and(GetOwningPlayer(GetBuyingUnit())==udg_TempPlayer)and(IsUnitHiddenBJ(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))==false)and(Trig_Job_Change_IsBuyerOwnHero())
endfunction

function Trig_Job_Change_IsBaseJob takes nothing returns boolean
    return(udg_SelectedJobId=='H000')or(udg_SelectedJobId=='H002') // 'H000': unit "Squire"; 'H002': unit "Chemist"
endfunction

function Trig_Job_Change_IsBaseJobUnlocked takes nothing returns boolean
    return(Trig_Job_Change_IsBaseJob())
endfunction

function Trig_Job_Change_IsKnightOrArcher takes nothing returns boolean
    return(udg_SelectedJobId=='H003')or(udg_SelectedJobId=='H001') // 'H003': unit "Knight"; 'H001': unit "Archer"
endfunction

function Trig_Job_Change_HasSquire8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H000')>=8) // 'H000': unit "Squire"
endfunction

function Trig_Job_Change_IsKnightOrArcherPick takes nothing returns boolean
    return(Trig_Job_Change_IsKnightOrArcher())
endfunction

function Trig_Job_Change_HasKnight8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H003')>=8) // 'H003': unit "Knight"
endfunction

function Trig_Job_Change_IsMonk takes nothing returns boolean
    return(udg_SelectedJobId=='H00A') // 'H00A': unit "Monk"
endfunction

function Trig_Job_Change_HasArcher8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H001')>=8) // 'H001': unit "Archer"
endfunction

function Trig_Job_Change_IsThief takes nothing returns boolean
    return(udg_SelectedJobId=='H00B') // 'H00B': unit "Thief"
endfunction

function Trig_Job_Change_IsWizardOrPriest takes nothing returns boolean
    return(udg_SelectedJobId=='H004')or(udg_SelectedJobId=='H005') // 'H004': unit "Wizard"; 'H005': unit "Priest"
endfunction

function Trig_Job_Change_HasChemist8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H002')>=8) // 'H002': unit "Chemist"
endfunction

function Trig_Job_Change_IsWizardOrPriestPick takes nothing returns boolean
    return(Trig_Job_Change_IsWizardOrPriest())
endfunction

function Trig_Job_Change_HasWizard8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H004')>=8) // 'H004': unit "Wizard"
endfunction

function Trig_Job_Change_IsSummoner takes nothing returns boolean
    return(udg_SelectedJobId=='H009') // 'H009': unit "Summoner"
endfunction

function Trig_Job_Change_HasPriest8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H005')>=8) // 'H005': unit "Priest"
endfunction

function Trig_Job_Change_IsTimeMage takes nothing returns boolean
    return(udg_SelectedJobId=='H008') // 'H008': unit "Time Mage"
endfunction

function Trig_Job_Change_HasMonk8Archer8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H001')>=8) // 'H00A': unit "Monk"; 'H001': unit "Archer"
endfunction

function Trig_Job_Change_IsGeomancer takes nothing returns boolean
    return(udg_SelectedJobId=='H00D') // 'H00D': unit "Geomancer"
endfunction

function Trig_Job_Change_HasThief8Knight8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H003')>=8) // 'H00B': unit "Thief"; 'H003': unit "Knight"
endfunction

function Trig_Job_Change_IsSamurai takes nothing returns boolean
    return(udg_SelectedJobId=='H00E') // 'H00E': unit "Samurai"
endfunction

function Trig_Job_Change_HasGeomancer8Thief8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H00D')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>=8) // 'H00D': unit "Geomancer"; 'H00B': unit "Thief"
endfunction

function Trig_Job_Change_IsLancer takes nothing returns boolean
    return(udg_SelectedJobId=='H00C') // 'H00C': unit "Lancer"
endfunction

function Trig_Job_Change_HasSamurai8Monk8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H00E')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>=8) // 'H00E': unit "Samurai"; 'H00A': unit "Monk"
endfunction

function Trig_Job_Change_IsNinja takes nothing returns boolean
    return(udg_SelectedJobId=='H00F') // 'H00F': unit "Ninja"
endfunction

function Trig_Job_Change_IsHolySwordsman takes nothing returns boolean
    return(udg_SelectedJobId=='H00M') // 'H00M': unit "Holy Swordsman"
endfunction

function Trig_Job_Change_HasSummoner8Priest8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H009')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H005')>=8) // 'H009': unit "Summoner"; 'H005': unit "Priest"
endfunction

function Trig_Job_Change_IsMediator takes nothing returns boolean
    return(udg_SelectedJobId=='H00G') // 'H00G': unit "Mediator"
endfunction

function Trig_Job_Change_HasTimeMage8Wizard8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H008')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H004')>=8) // 'H008': unit "Time Mage"; 'H004': unit "Wizard"
endfunction

function Trig_Job_Change_IsOracle takes nothing returns boolean
    return(udg_SelectedJobId=='H00I') // 'H00I': unit "Oracle"
endfunction

function Trig_Job_Change_HasMediator8TimeMage8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H00G')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H008')>=8) // 'H00G': unit "Mediator"; 'H008': unit "Time Mage"
endfunction

function Trig_Job_Change_IsCalculator takes nothing returns boolean
    return(udg_SelectedJobId=='H00H') // 'H00H': unit "Calculator"
endfunction

function Trig_Job_Change_HasOracle8Summoner8 takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,'H00I')>=8)and(Job_GetSavedLevel(udg_TempPlayer,'H009')>=8) // 'H00I': unit "Oracle"; 'H009': unit "Summoner"
endfunction

function Trig_Job_Change_IsProphet takes nothing returns boolean
    return(udg_SelectedJobId=='H00J') // 'H00J': unit "Prophet"
endfunction

function Trig_Job_Change_IsSorcerer takes nothing returns boolean
    return(udg_SelectedJobId=='H00L') // 'H00L': unit "Sorcerer"
endfunction

function Trig_Job_Change_CanBeDarkKnight takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[16]))and(Job_GetSavedLevel(udg_TempPlayer,'H00M')>=20) // 'H00M': unit "Holy Swordsman"
endfunction

function Trig_Job_Change_IsDarkKnight takes nothing returns boolean
    return(udg_SelectedJobId=='H02X') // 'H02X': unit "Dark Knight"
endfunction

function Trig_Job_Change_CanBeNecromancer takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[16]))and(Job_GetSavedLevel(udg_TempPlayer,'H00L')>=20) // 'H00L': unit "Sorcerer"
endfunction

function Trig_Job_Change_IsNecromancer takes nothing returns boolean
    return(udg_SelectedJobId=='H02Y') // 'H02Y': unit "Necromancer"
endfunction

function Trig_Job_Change_IsFreelancerId takes nothing returns boolean
    return(udg_SelectedJobId=='H02L')or(udg_SelectedJobId=='H02M')or(udg_SelectedJobId=='H02N')or(udg_SelectedJobId=='H02O')or(udg_SelectedJobId=='H02P')or(udg_SelectedJobId=='H02Q') // 'H02L': unit "Freelancer"; 'H02M': unit "Freelancer"; 'H02N': unit "Freelancer"; 'H02O': unit "Freelancer"; 'H02P': unit "Freelancer"; 'H02Q': unit "Freelancer"
endfunction

function Trig_Job_Change_IsFreelancerPick takes nothing returns boolean
    return(Trig_Job_Change_IsFreelancerId())
endfunction

function Trig_Job_Change_HasJobLevel takes nothing returns boolean
    return(Job_GetSavedLevel(udg_TempPlayer,udg_SelectedJobId)>1)
endfunction

function Trig_Job_Change_IsJobLocked takes nothing returns boolean
    return(udg_JobUnlocked==false)
endfunction

function Trig_Job_Change_IsNewHeroDead takes nothing returns boolean
    return(IsUnitDeadBJ(udg_NewHero))
endfunction

function Trig_Job_Change_NewHeroMissing takes nothing returns boolean
    return(udg_NewHero==null)
endfunction

function Trig_Job_Change_HasDivineShield takes nothing returns boolean
    return(LoadBooleanBJ(0,GetHandleIdBJ(Player_GetHero(udg_TempPlayer)),udg_DivineShieldHash))
endfunction

function Trig_Job_Change_HasEnchantment takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SI',Player_GetHero(udg_TempPlayer))>=1) // 'A0SI': ability "Enchantment Variant"
endfunction

function Trig_Job_Change_OldMasteryIsFour takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))==4) // 'A02F': ability "Mastery"
endfunction

function Trig_Job_Change_OldMasteryAtLeast4 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))>=4) // 'A02F': ability "Mastery"
endfunction

function Trig_Job_Change_IsMainAlchemy takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]==51)
endfunction

function Trig_Job_Change_IsMainEnchant takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]==26)
endfunction

function Trig_Job_Change_IsSubAlchemy takes nothing returns boolean
    return(udg_SubSkillSlot[udg_TempInteger]==51)
endfunction

function Trig_Job_Change_HasBorrowedSkills takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]>0)and(udg_SubSkillSlot[udg_TempInteger]>0)
endfunction

function Trig_Job_Change_IsSlot1Alchemy takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]==51)
endfunction

function Trig_Job_Change_IsSlot1Enchant takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]==26)
endfunction

function Trig_Job_Change_IsFreelancerHero takes nothing returns boolean
    return(GetUnitName(Player_GetHero(udg_TempPlayer))=="Freelancer")
endfunction

function Trig_Job_Change_IsHeroDarkKnight takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(udg_TempPlayer))=='H02X') // 'H02X': unit "Dark Knight"
endfunction

function Trig_Job_Change_NewHeroMissingAfter takes nothing returns boolean
    return(udg_NewHero==null)
endfunction

function Trig_Job_Change_NewMasteryIsFour takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))==4) // 'A02F': ability "Mastery"
endfunction

function Trig_Job_Change_NewMasteryAtLeast4 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))>=4) // 'A02F': ability "Mastery"
endfunction

function Trig_Job_Change_NewMasteryAtLeast5 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))>=5) // 'A02F': ability "Mastery"
endfunction

function Trig_Job_Change_NewSlot1Alchemy takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]==51)
endfunction

function Trig_Job_Change_HasSlot1Ability takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]!=0)
endfunction

function Trig_Job_Change_HasSlot2Ability takes nothing returns boolean
    return(udg_AbilitySlot2[udg_TempInteger]!=0)
endfunction

function Trig_Job_Change_HasSlot3Ability takes nothing returns boolean
    return(udg_AbilitySlot3[udg_TempInteger]!=0)
endfunction

function Trig_Job_Change_HasSlot4Ability takes nothing returns boolean
    return(udg_AbilitySlot4[udg_TempInteger]!=0)
endfunction

function Trig_Job_Change_NewIsFreelancer takes nothing returns boolean
    return(GetUnitName(Player_GetHero(udg_TempPlayer))=="Freelancer")
endfunction

function Trig_Job_Change_NewIsDarkKnight takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(udg_TempPlayer))=='H02X') // 'H02X': unit "Dark Knight"
endfunction

function Trig_Job_Change_HasEvadeCounter takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0R3',Player_GetHero(udg_TempPlayer))>0) // 'A0R3': ability "Evade & Counter"
endfunction

function Trig_Job_Change_IsChargedItem takes nothing returns boolean
    return(GetItemType(udg_SavedItem[GetForLoopIndexA()])==ITEM_TYPE_CHARGED)and(GetItemCharges(udg_SavedItem[GetForLoopIndexA()])>0)
endfunction

function Trig_Job_Change_HasSavedItem takes nothing returns boolean
    return(udg_SavedItem[GetForLoopIndexA()]!=null)
endfunction

function Trig_Job_Change_IsStatLocked takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_CheaterForce))
endfunction

function Trig_Job_Change_HasSummonUnit takes nothing returns boolean
    return(udg_SummonUnit[GetConvertedPlayerId(udg_TempPlayer)]!=null)
endfunction

function Trig_Job_Change_FilterSummoned takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_SUMMONED))!=null
endfunction

function Trig_Job_Change_KillEnumSummon takes nothing returns nothing
    call UnitApplyTimedLifeBJ(.01,'BTLF',GetEnumUnit()) // 'BTLF': object name not found in map data
endfunction

function Trig_Job_Change_Actions takes nothing returns nothing
    local group l_tempGroup
    set udg_SelectedJobId=GetUnitTypeId(GetSoldUnit())
    set udg_TempPlayer=GetOwningPlayer(GetSoldUnit())
    call RemoveUnit(GetSoldUnit())
    if(Trig_Job_Change_IsSameJob())then
        set udg_TempForce=Force_OfPlayer(udg_TempPlayer)
        call DisplayTextToForce(udg_TempForce,"You are already using this job.")
        call DestroyForce(udg_TempForce)
        set l_tempGroup=null
        return
    endif
    if(Trig_Job_Change_IsValidBuyer())then
    else
        set udg_TempForce=Force_OfPlayer(udg_TempPlayer)
        call DisplayTextToForce(udg_TempForce,"The unit interacting with the shrine is not your hero.")
        call DestroyForce(udg_TempForce)
        set l_tempGroup=null
        return
    endif
    if(Trig_Job_Change_HasJobLevel())then
        set udg_JobUnlocked=true
    else
        if(Trig_Job_Change_IsBaseJobUnlocked())then
            set udg_JobUnlocked=true
        endif
        if(Trig_Job_Change_IsKnightOrArcherPick())then
            set udg_JobRequirementText="Level 8 Squire"
            if(Trig_Job_Change_HasSquire8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsMonk())then
            set udg_JobRequirementText="Level 8 Knight"
            if(Trig_Job_Change_HasKnight8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsThief())then
            set udg_JobRequirementText="Level 8 Archer"
            if(Trig_Job_Change_HasArcher8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsWizardOrPriestPick())then
            set udg_JobRequirementText="Level 8 Chemist"
            if(Trig_Job_Change_HasChemist8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsSummoner())then
            set udg_JobRequirementText="Level 8 Wizard"
            if(Trig_Job_Change_HasWizard8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsTimeMage())then
            set udg_JobRequirementText="Level 8 Priest"
            if(Trig_Job_Change_HasPriest8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsGeomancer())then
            set udg_JobRequirementText="Level 8 Monk, Level 8 Archer"
            if(Trig_Job_Change_HasMonk8Archer8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsSamurai())then
            set udg_JobRequirementText="Level 8 Thief, Level 8 Knight"
            if(Trig_Job_Change_HasThief8Knight8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsLancer())then
            set udg_JobRequirementText="Level 8 Geomancer, Level 8 Thief"
            if(Trig_Job_Change_HasGeomancer8Thief8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsNinja())then
            set udg_JobRequirementText="Level 8 Samurai, Level 8 Monk"
            if(Trig_Job_Change_HasSamurai8Monk8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsHolySwordsman())then
            set udg_JobRequirementText="All previous Warrior jobs at Level 15"
            set udg_JobUnlocked=IsPlayerInForce(udg_TempPlayer,udg_TitleForce[1])
        endif
        if(Trig_Job_Change_IsMediator())then
            set udg_JobRequirementText="Level 8 Summoner, Level 8 Priest"
            if(Trig_Job_Change_HasSummoner8Priest8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsOracle())then
            set udg_JobRequirementText="Level 8 Time Mage, Level 8 Wizard"
            if(Trig_Job_Change_HasTimeMage8Wizard8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsCalculator())then
            set udg_JobRequirementText="Level 8 Mediator, Level 8 Time Mage"
            if(Trig_Job_Change_HasMediator8TimeMage8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsProphet())then
            set udg_JobRequirementText="Level 8 Oracle, Level 8 Summoner"
            if(Trig_Job_Change_HasOracle8Summoner8())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
        endif
        if(Trig_Job_Change_IsSorcerer())then
            set udg_JobUnlocked=IsPlayerInForce(udg_TempPlayer,udg_TitleForce[4])
            set udg_JobRequirementText="All previous Mage jobs at Level 15"
        endif
        if(Trig_Job_Change_IsDarkKnight())then
            if(Trig_Job_Change_CanBeDarkKnight())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
            set udg_JobRequirementText="Finish Main Questline, Level 20 Holy Swordsman"
        endif
        if(Trig_Job_Change_IsNecromancer())then
            if(Trig_Job_Change_CanBeNecromancer())then
                set udg_JobUnlocked=true
            else
                set udg_JobUnlocked=false
            endif
            set udg_JobRequirementText="Finish Main Questline, Level 20 Sorcerer"
        endif
        if(Trig_Job_Change_IsFreelancerPick())then
            set udg_JobUnlocked=IsPlayerInForce(udg_TempPlayer,udg_TitleForce[$A]) // $A = 10
            set udg_JobRequirementText="Any job mastered"
        endif
    endif
    if(Trig_Job_Change_IsJobLocked())then
        set udg_TempForce=Force_OfPlayer(udg_TempPlayer)
        call DisplayTextToForce(udg_TempForce,"You can't use this job yet.")
        call DisplayTextToForce(udg_TempForce,("You must meet following requirements: "+udg_JobRequirementText))
        call DestroyForce(udg_TempForce)
        set l_tempGroup=null
        return
    endif
    set udg_SpeedrunFlag[3]=true
    set udg_NewHero=Job_GetHero(udg_TempPlayer,udg_SelectedJobId)
    if(Trig_Job_Change_NewHeroMissing())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: Chosen hero does not exist. Please report to the map developer.")
        call DisplayTextToForce(GetPlayersAll(),((("Player "+I2S(GetConvertedPlayerId(udg_TempPlayer)))+": ")+((udg_PlayerName[GetConvertedPlayerId(udg_TempPlayer)]+" (")+(GetPlayerName(udg_TempPlayer)+")"))))
        set udg_TempInteger=udg_SelectedJobId
        call DisplayTextToForce(GetPlayersAll(),((("Hero "+I2S(udg_TempInteger))+": ")+UnitId2StringBJ(udg_SelectedJobId)))
    else
        if(Trig_Job_Change_IsNewHeroDead())then
            call ReviveHeroLoc(udg_NewHero,udg_TempPoint,true)
        endif
    endif
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_SavedItem[GetForLoopIndexA()]=UnitItemInSlotBJ(Player_GetHero(udg_TempPlayer),GetForLoopIndexA())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    // Result 1: current health divided by maximum health for Player_GetHero(udg_TempPlayer), times 100 (or 0 if
    // the unit is missing or its maximum is 0).
    set udg_SavedLifePercent=GetUnitLifePercent(Player_GetHero(udg_TempPlayer))
    // Result 1: current mana divided by maximum mana for Player_GetHero(udg_TempPlayer), times 100 (or 0 if the
    // unit is missing or its maximum is 0).
    set udg_SavedManaPercent=GetUnitManaPercent(Player_GetHero(udg_TempPlayer))
    if(Trig_Job_Change_HasDivineShield())then
        call UnitRemoveBuffBJ('B051',LoadUnitHandleBJ(1,GetHandleIdBJ(Player_GetHero(udg_TempPlayer)),udg_DivineShieldHash)) // 'B051': buff "Divine Shield"
    endif
    set udg_SavedFacing=GetUnitFacing(Player_GetHero(udg_TempPlayer))
    set udg_HeroLoc=GetUnitLoc(Player_GetHero(udg_TempPlayer))
    call UnitShareVisionBJ(false,Player_GetHero(udg_TempPlayer),Player($B)) // $B = 11
    call SetUnitOwner(Player_GetHero(udg_TempPlayer),Player(PLAYER_NEUTRAL_PASSIVE),true)
    call AddSpecialEffectLocBJ(udg_HeroLoc,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitVertexColorBJ(Player_GetHero(udg_TempPlayer),'d','d','d',0)
    call SetUnitPathing(Player_GetHero(udg_TempPlayer),false)
    call SetUnitInvulnerable(Player_GetHero(udg_TempPlayer),true)
    call ShowUnitHide(Player_GetHero(udg_TempPlayer))
    call SetUnitPositionLocFacingBJ(Player_GetHero(udg_TempPlayer),GetPlayerStartLocationLoc(udg_TempPlayer),bj_UNIT_FACING)
    call SetUnitPositionLocFacingBJ(udg_NewHero,udg_HeroLoc,udg_SavedFacing)
    call SetUnitOwner(udg_NewHero,udg_TempPlayer,true)
    call SetUnitPathing(udg_NewHero,true)
    call SetUnitInvulnerable(udg_NewHero,false)
    call ShowUnitShow(udg_NewHero)
    call Berserk_Remove(Player_GetHero(udg_TempPlayer))
    call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL,Player_GetHero(udg_TempPlayer))
    if(Trig_Job_Change_HasEnchantment())then
        call SetUnitAbilityLevelSwapped('A0SI',Player_GetHero(udg_TempPlayer),1) // 'A0SI': ability "Enchantment Variant"
        call BlzSetAbilityIcon('A0S8',BlzGetAbilityIcon(udg_EnchantAbility[1])) // 'A0S8': ability "Enfire"
        call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
        call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
        call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
        call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
        call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
        call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
    endif
    if(Trig_Job_Change_OldMasteryAtLeast4())then
        if(Trig_Job_Change_OldMasteryIsFour())then
            call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SUB,$A) // $A = 10
            call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SUB,$A) // $A = 10
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SUB,$A) // $A = 10
        else
            call UnitRemoveAbilityBJ(udg_MasteryBonusAbility[GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))],Player_GetHero(udg_TempPlayer)) // 'A02F': ability "Mastery"
        endif
    endif
    set udg_TempInteger=GetConvertedPlayerId(udg_TempPlayer)
    if(Trig_Job_Change_IsFreelancerHero())then
        if(Trig_Job_Change_IsSlot1Enchant())then
            call UnitRemoveAbilityBJ('A0SI',Player_GetHero(udg_TempPlayer)) // 'A0SI': ability "Enchantment Variant"
        else
            if(Trig_Job_Change_IsSlot1Alchemy())then
                call UnitRemoveAbilityBJ('A1AJ',Player_GetHero(udg_TempPlayer)) // 'A1AJ': ability "Alchemy"
            endif
        endif
        call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot1[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
        call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot2[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
        call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot3[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
        call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot4[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
    else
        if(Trig_Job_Change_HasBorrowedSkills())then
            if(Trig_Job_Change_IsMainEnchant())then
                call UnitRemoveAbilityBJ('A0SI',Player_GetHero(udg_TempPlayer)) // 'A0SI': ability "Enchantment Variant"
            else
                if(Trig_Job_Change_IsMainAlchemy())then
                    call UnitRemoveAbilityBJ('A1AJ',Player_GetHero(udg_TempPlayer)) // 'A1AJ': ability "Alchemy"
                endif
            endif
            call UnitRemoveAbilityBJ(udg_JobSkill[udg_MainSkillSlot[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
            call BlzUnitDisableAbility(Player_GetHero(udg_TempPlayer),udg_JobSkill[udg_SubSkillSlot[udg_TempInteger]],false,false)
            if(Trig_Job_Change_IsSubAlchemy())then
                call UnitAddAbilityBJ('A1AI',Player_GetHero(udg_TempPlayer)) // 'A1AI': ability "Alchemy"
            endif
            set udg_MainSkillSlot[udg_TempInteger]=0
            set udg_SubSkillSlot[udg_TempInteger]=0
        endif
    endif
    if(Trig_Job_Change_IsHeroDarkKnight())then
        call GroupRemoveUnitSimple(Player_GetHero(udg_TempPlayer),udg_BossGroup)
    endif
    if(Trig_Job_Change_NewHeroMissingAfter())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: Chosen hero does not exist. (Aftercheck)")
    endif
    set udg_PlayerHero[udg_TempInteger]=udg_NewHero
    call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL,Player_GetHero(udg_TempPlayer))
    call UnitShareVisionBJ(true,Player_GetHero(udg_TempPlayer),Player(9))
    if(Trig_Job_Change_NewIsFreelancer())then
        call SetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer),GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[udg_TempInteger])) // 'A02F': ability "Mastery"
        if(Trig_Job_Change_NewMasteryAtLeast5())then
            call UnitAddAbilityBJ(udg_MasteryBonusAbility[GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))],Player_GetHero(udg_TempPlayer)) // 'A02F': ability "Mastery"
        endif
        call SetHeroXP(Player_GetHero(udg_TempPlayer),GetHeroXP(udg_FreelancerHero[udg_TempInteger]),false)
        set udg_FreelancerHero[udg_TempInteger]=Player_GetHero(udg_TempPlayer)
        call ConditionalTriggerExecute(gg_trg_Freelancer_Stats)
        if(Trig_Job_Change_HasSlot1Ability())then
            call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot1[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
            call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot1[udg_TempInteger]],Player_GetHero(udg_TempPlayer),$A) // $A = 10
            if(Trig_Job_Change_NewSlot1Alchemy())then
                call UnitAddAbilityBJ('A1AJ',Player_GetHero(udg_TempPlayer)) // 'A1AJ': ability "Alchemy"
            endif
        endif
        if(Trig_Job_Change_HasSlot2Ability())then
            call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot2[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
            call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot2[udg_TempInteger]],Player_GetHero(udg_TempPlayer),$A) // $A = 10
        endif
        if(Trig_Job_Change_HasSlot3Ability())then
            call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot3[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
            call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot3[udg_TempInteger]],Player_GetHero(udg_TempPlayer),$A) // $A = 10
        endif
        if(Trig_Job_Change_HasSlot4Ability())then
            call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot4[udg_TempInteger]],Player_GetHero(udg_TempPlayer))
            call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot4[udg_TempInteger]],Player_GetHero(udg_TempPlayer),$A) // $A = 10
        endif
    else
        if(Trig_Job_Change_NewMasteryAtLeast4())then
            if(Trig_Job_Change_NewMasteryIsFour())then
                call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,$A) // $A = 10
                call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,$A) // $A = 10
                call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,$A) // $A = 10
            else
                call UnitAddAbilityBJ(udg_MasteryBonusAbility[GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_TempPlayer))],Player_GetHero(udg_TempPlayer)) // 'A02F': ability "Mastery"
            endif
        endif
    endif
    if(Trig_Job_Change_NewIsDarkKnight())then
        call GroupAddUnitSimple(Player_GetHero(udg_TempPlayer),udg_BossGroup)
    endif
    if(Trig_Job_Change_HasEvadeCounter())then
        call StartTimerBJ(udg_DodgeFaceTimer[GetConvertedPlayerId(udg_TempPlayer)],false,.1)
    endif
    call ConditionalTriggerExecute(gg_trg_Hero_EndlessGrowth)
    call SetUnitLifePercentBJ(Player_GetHero(udg_TempPlayer),udg_SavedLifePercent)
    call SetUnitManaPercentBJ(Player_GetHero(udg_TempPlayer),udg_SavedManaPercent)
    set udg_TempInteger=0
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),Player_GetHero(udg_TempPlayer))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Job_Change_HasSavedItem())then
            if(Trig_Job_Change_IsChargedItem())then
                set udg_TempInteger=GetItemCharges(udg_SavedItem[GetForLoopIndexA()])
                call SetItemCharges(udg_SavedItem[GetForLoopIndexA()],0)
                call UnitAddItemSwapped(udg_SavedItem[GetForLoopIndexA()],Player_GetHero(udg_TempPlayer))
                call SetItemCharges(udg_SavedItem[GetForLoopIndexA()],udg_TempInteger)
            else
                call UnitAddItemSwapped(udg_SavedItem[GetForLoopIndexA()],Player_GetHero(udg_TempPlayer))
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempInteger=0
    if(Trig_Job_Change_IsStatLocked())then
        call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SET,5)
        call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SET,5)
        call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_SET,5)
    endif
    set udg_CurrentHero=Player_GetHero(udg_TempPlayer)
    call ConditionalTriggerExecute(gg_trg_AttackSpeed_Update)
    call ConditionalTriggerExecute(gg_trg_MagicDefense_Calc)
    call ConditionalTriggerExecute(gg_trg_Unit_ApplyUpgradeBonuses)
    call StartTimerBJ(udg_JobChangeTimer,false,.01)
    call EnableTrigger(gg_trg_Cloak_UpdateStats)
    if(Trig_Job_Change_HasSummonUnit())then
        call UnitApplyTimedLifeBJ(.01,'BTLF',udg_SummonUnit[GetConvertedPlayerId(udg_TempPlayer)]) // 'BTLF': object name not found in map data
    endif
    set l_tempGroup=Group_UnitsOfPlayer(udg_TempPlayer,Condition(function Trig_Job_Change_FilterSummoned))
    call ForGroupBJ(l_tempGroup,function Trig_Job_Change_KillEnumSummon)
    call DestroyGroup(l_tempGroup)
    call SelectUnitForPlayerSingle(Player_GetHero(udg_TempPlayer),udg_TempPlayer)
    call PanCameraToTimedLocForPlayer(udg_TempPlayer,udg_HeroLoc,0)
    call RemoveLocation(udg_HeroLoc)
    call StartTimerBJ(udg_JobLevelTimer,false,.01)
    call StartTimerBJ(udg_UnitUpdateTimer,false,.1)
    call TriggerExecute(gg_trg_Multiboard_Refresh)
    set l_tempGroup=null
endfunction

function Trig_Job_XP_Handicap_ApplyJobXPRate takes nothing returns nothing
    local player p=GetEnumPlayer()
    local unit u=Player_GetHero(p)
    local real l_rate
    if(u==null)then
        set p=null
        return
    endif
    if GetUnitTypeId(u)=='H000' or GetUnitTypeId(u)=='H002' then // 'H000': unit "Squire"; 'H002': unit "Chemist"
        set l_rate=1.2
    elseif GetUnitTypeId(u)=='H003' or GetUnitTypeId(u)=='H001' or GetUnitTypeId(u)=='H004' or GetUnitTypeId(u)=='H005' then // 'H003': unit "Knight"; 'H001': unit "Archer"; 'H004': unit "Wizard"; 'H005': unit "Priest"
        set l_rate=1.
    elseif GetUnitTypeId(u)=='H00A' or GetUnitTypeId(u)=='H00B' or GetUnitTypeId(u)=='H009' or GetUnitTypeId(u)=='H008' then // 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"
        set l_rate=.9
    elseif GetUnitTypeId(u)=='H00E' or GetUnitTypeId(u)=='H00D' or GetUnitTypeId(u)=='H00G' or GetUnitTypeId(u)=='H00I' then // 'H00E': unit "Samurai"; 'H00D': unit "Geomancer"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"
        set l_rate=.8
    elseif GetUnitTypeId(u)=='H00C' or GetUnitTypeId(u)=='H00F' or GetUnitTypeId(u)=='H00H' or GetUnitTypeId(u)=='H00J' then // 'H00C': unit "Lancer"; 'H00F': unit "Ninja"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"
        set l_rate=.7
    elseif GetUnitTypeId(u)=='H00M' or GetUnitTypeId(u)=='H00L' then // 'H00M': unit "Holy Swordsman"; 'H00L': unit "Sorcerer"
        set l_rate=.6
    elseif GetUnitTypeId(u)=='H02X' or GetUnitTypeId(u)=='H02Y' then // 'H02X': unit "Dark Knight"; 'H02Y': unit "Necromancer"
        set l_rate=.5
    else
        set l_rate=1.
    endif
    // (l_rate) times (udg_ExpRate).
    call SetPlayerHandicapXP(p,l_rate*udg_ExpRate)
    set u=null
    set p=null
endfunction

function Trig_Job_XP_Handicap_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Job_XP_Handicap_ApplyJobXPRate)
    call TriggerExecute(gg_trg_Multiboard_Refresh)
endfunction

// World Editor calls InitTrig_Job automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Job_Part1 / RegisterTriggers_Job_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Job takes nothing returns nothing
endfunction

function Register_Job_Change takes nothing returns nothing
    set gg_trg_Job_Change=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Job_Change,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Job_Change,Condition(function Trig_Job_Change_Conditions))
    call TriggerAddAction(gg_trg_Job_Change,function Trig_Job_Change_Actions)
endfunction

function Register_Job_XP_Handicap takes nothing returns nothing
    set gg_trg_Job_XP_Handicap=CreateTrigger()
    call DisableTrigger(gg_trg_Job_XP_Handicap)
    call TriggerAddAction(gg_trg_Job_XP_Handicap,function Trig_Job_XP_Handicap_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Job_Part1 takes nothing returns nothing
    call Register_Job_Change()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Job_Part2 takes nothing returns nothing
    call Register_Job_XP_Handicap() // starts off; enabled by Game; run by Exp, Game, JobLevels +2 more
endfunction

endlibrary

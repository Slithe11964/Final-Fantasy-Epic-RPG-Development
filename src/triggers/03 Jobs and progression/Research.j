library TResearch requires TForce, TJob
function Trig_Research_Requirements_IsHouse takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='h006')or(GetUnitTypeId(GetTriggerUnit())=='h00N') // 'h006': unit "House"; 'h00N': unit "House"
endfunction

function Trig_Research_Requirements_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetPlayerTechCountSimple(GetResearched(),GetOwningPlayer(GetTriggerUnit()))>0)and(Trig_Research_Requirements_IsHouse())
endfunction

function Trig_Research_Requirements_MysticIncludesNecro takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_Research_Requirements_IsMysticArmor takes nothing returns boolean
    return(GetResearched()=='R007') // 'R007': upgrade "Mystic Armor"
endfunction

function Trig_Research_Requirements_IsInnerMana takes nothing returns boolean
    return(GetResearched()=='R00L') // 'R00L': upgrade "Inner Mana"
endfunction

function Trig_Research_Requirements_IsGun takes nothing returns boolean
    return(GetResearched()=='R00M') // 'R00M': upgrade "Gun"
endfunction

function Trig_Research_Requirements_StaffIncludesNecro takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_Research_Requirements_IsStaff takes nothing returns boolean
    return(GetResearched()=='R004') // 'R004': upgrade "Staff"
endfunction

function Trig_Research_Requirements_IsRod takes nothing returns boolean
    return(GetResearched()=='R003') // 'R003': upgrade "Rod"
endfunction

function Trig_Research_Requirements_PlateIncludesDarkKnight takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_Research_Requirements_IsPlateArmor takes nothing returns boolean
    return(GetResearched()=='R005') // 'R005': upgrade "Plate Armor"
endfunction

function Trig_Research_Requirements_IsLeatherArmor takes nothing returns boolean
    return(GetResearched()=='R006') // 'R006': upgrade "Leather Armor"
endfunction

function Trig_Research_Requirements_GreatswordIncludesDarkKnight takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_Research_Requirements_IsGreatsword takes nothing returns boolean
    return(GetResearched()=='R00N') // 'R00N': upgrade "Greatsword"
endfunction

function Trig_Research_Requirements_IsKatana takes nothing returns boolean
    return(GetResearched()=='R00A') // 'R00A': upgrade "Katana"
endfunction

function Trig_Research_Requirements_IsAxe takes nothing returns boolean
    return(GetResearched()=='R008') // 'R008': upgrade "Axe"
endfunction

function Trig_Research_Requirements_IsSpear takes nothing returns boolean
    return(GetResearched()=='R009') // 'R009': upgrade "Spear"
endfunction

function Trig_Research_Requirements_IsDagger takes nothing returns boolean
    return(GetResearched()=='R00B') // 'R00B': upgrade "Dagger"
endfunction

function Trig_Research_Requirements_IsBow takes nothing returns boolean
    return(GetResearched()=='R002') // 'R002': upgrade "Bow"
endfunction

function Trig_Research_Requirements_IsSword takes nothing returns boolean
    return(GetResearched()=='R001') // 'R001': upgrade "Sword"
endfunction

function Trig_Research_Requirements_IsTools takes nothing returns boolean
    return(GetResearched()=='R000') // 'R000': upgrade "Tools"
endfunction

function Trig_Research_Requirements_LevelsMissing takes nothing returns boolean
    return(udg_TempInteger>0)
endfunction

function Trig_Research_Requirements_Actions takes nothing returns nothing
    // Result 1: (GetPlayerTechCountSimple(GetResearched(), GetOwningPlayer(the triggering unit))) plus (1).
    // Result 2: (result 1) times (GetPlayerTechCountSimple(GetResearched(), GetOwningPlayer(the triggering
    // unit))).
    // Result 3: (result 2) divided by (2); drop the remainder.
    // Result 4: (result 3) plus (5).
    set udg_ResearchReqLevel=((((GetPlayerTechCountSimple(GetResearched(),GetOwningPlayer(GetTriggerUnit()))+1)*GetPlayerTechCountSimple(GetResearched(),GetOwningPlayer(GetTriggerUnit())))/ 2)+5)
    set udg_TempInteger=udg_ResearchReqLevel
    if(Trig_Research_Requirements_IsTools())then
        // ((udg_ResearchReqLevel treated as a decimal-capable number) times (1.5)) with its decimal part removed.
        set udg_ResearchReqLevel=R2I((I2R(udg_ResearchReqLevel)*1.5))
        set udg_TempInteger=udg_ResearchReqLevel
        set udg_JobRequirementText="Tools"
        set udg_TempString="s (Squire, Chemist) must have a combined"
        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H000')).
        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H000')) // 'H000': unit "Squire"
        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H002')).
        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H002')) // 'H002': unit "Chemist"
    else
        if(Trig_Research_Requirements_IsSword())then
            set udg_JobRequirementText="Sword"
            set udg_TempString=" (Knight) must have a"
            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H003')).
            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H003')) // 'H003': unit "Knight"
        else
            if(Trig_Research_Requirements_IsBow())then
                set udg_JobRequirementText="Bow"
                set udg_TempString=" (Archer) must have a"
                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H001')).
                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H001')) // 'H001': unit "Archer"
            else
                if(Trig_Research_Requirements_IsDagger())then
                    // ((udg_ResearchReqLevel treated as a decimal-capable number) times (1.5)) with its decimal part removed.
                    set udg_ResearchReqLevel=R2I((I2R(udg_ResearchReqLevel)*1.5))
                    set udg_TempInteger=udg_ResearchReqLevel
                    set udg_JobRequirementText="Dagger"
                    set udg_TempString="s (Thief, Ninja) must have a combined"
                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00B')).
                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00B')) // 'H00B': unit "Thief"
                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00F')).
                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00F')) // 'H00F': unit "Ninja"
                else
                    if(Trig_Research_Requirements_IsSpear())then
                        set udg_JobRequirementText="Spear"
                        set udg_TempString=" (Lancer) must have a"
                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00C')).
                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00C')) // 'H00C': unit "Lancer"
                    else
                        if(Trig_Research_Requirements_IsAxe())then
                            set udg_JobRequirementText="Axe"
                            set udg_TempString=" (Geomancer) must have a"
                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00D')).
                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00D')) // 'H00D': unit "Geomancer"
                        else
                            if(Trig_Research_Requirements_IsKatana())then
                                set udg_JobRequirementText="Katana"
                                set udg_TempString=" (Samurai) must have a"
                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00E')).
                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00E')) // 'H00E': unit "Samurai"
                            else
                                if(Trig_Research_Requirements_IsGreatsword())then
                                    // ((udg_ResearchReqLevel treated as a decimal-capable number) times (1.5)) with its decimal part removed.
                                    set udg_ResearchReqLevel=R2I((I2R(udg_ResearchReqLevel)*1.5))
                                    set udg_TempInteger=udg_ResearchReqLevel
                                    set udg_JobRequirementText="Greatsword"
                                    if(Trig_Research_Requirements_GreatswordIncludesDarkKnight())then
                                        set udg_TempString="s (Holy Swordsman, Dark Knight) must have a combined"
                                    else
                                        set udg_TempString=" (Holy Swordsman) must have a"
                                    endif
                                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00M')).
                                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00M')) // 'H00M': unit "Holy Swordsman"
                                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H02X')).
                                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H02X')) // 'H02X': unit "Dark Knight"
                                else
                                    if(Trig_Research_Requirements_IsLeatherArmor())then
                                        // (udg_ResearchReqLevel) times (4).
                                        set udg_ResearchReqLevel=(udg_ResearchReqLevel*4)
                                        set udg_TempInteger=udg_ResearchReqLevel
                                        set udg_JobRequirementText="Leather Armor"
                                        set udg_TempString="s (Chemist, Archer, Monk, Thief, Geomancer, Mediator, Ninja) must have a combined"
                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H002')).
                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H002')) // 'H002': unit "Chemist"
                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H001')).
                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H001')) // 'H001': unit "Archer"
                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00A')).
                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00A')) // 'H00A': unit "Monk"
                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00B')).
                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00B')) // 'H00B': unit "Thief"
                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00D')).
                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00D')) // 'H00D': unit "Geomancer"
                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00G')).
                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00G')) // 'H00G': unit "Mediator"
                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00F')).
                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00F')) // 'H00F': unit "Ninja"
                                    else
                                        if(Trig_Research_Requirements_IsPlateArmor())then
                                            // ((udg_ResearchReqLevel treated as a decimal-capable number) times (3.5)) with its decimal part removed.
                                            set udg_ResearchReqLevel=R2I((I2R(udg_ResearchReqLevel)*3.5))
                                            set udg_TempInteger=udg_ResearchReqLevel
                                            set udg_JobRequirementText="Plate Armor"
                                            set udg_TempString="s (Squire, Knight, Lancer, Samurai, Holy Swordsman, Dark Knight) must have a combined"
                                            if(Trig_Research_Requirements_PlateIncludesDarkKnight())then
                                                set udg_TempString="s (Squire, Knight, Lancer, Samurai, Holy Swordsman, Dark Knight) must have a combined"
                                            else
                                                set udg_TempString="s (Squire, Knight, Lancer, Samurai, Holy Swordsman) must have a combined"
                                            endif
                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H000')).
                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H000')) // 'H000': unit "Squire"
                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H003')).
                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H003')) // 'H003': unit "Knight"
                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00C')).
                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00C')) // 'H00C': unit "Lancer"
                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00E')).
                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00E')) // 'H00E': unit "Samurai"
                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00M')).
                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00M')) // 'H00M': unit "Holy Swordsman"
                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H02X')).
                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H02X')) // 'H02X': unit "Dark Knight"
                                        else
                                            if(Trig_Research_Requirements_IsRod())then
                                                // ((udg_ResearchReqLevel treated as a decimal-capable number) times (1.5)) with its decimal part removed.
                                                set udg_ResearchReqLevel=R2I((I2R(udg_ResearchReqLevel)*1.5))
                                                set udg_TempInteger=udg_ResearchReqLevel
                                                set udg_JobRequirementText="Rod"
                                                set udg_TempString="s (Wizard, Calculator) must have a combined"
                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H004')).
                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H004')) // 'H004': unit "Wizard"
                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00H')).
                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00H')) // 'H00H': unit "Calculator"
                                            else
                                                if(Trig_Research_Requirements_IsStaff())then
                                                    // ((udg_ResearchReqLevel treated as a decimal-capable number) times (2.5)) with its decimal part removed.
                                                    set udg_ResearchReqLevel=R2I((I2R(udg_ResearchReqLevel)*2.5))
                                                    set udg_TempInteger=udg_ResearchReqLevel
                                                    set udg_JobRequirementText="Staff"
                                                    if(Trig_Research_Requirements_StaffIncludesNecro())then
                                                        set udg_TempString="s (Priest, Time Mage, Prophet, Necromancer) must have a combined"
                                                    else
                                                        set udg_TempString="s (Priest, Time Mage, Prophet) must have a combined"
                                                    endif
                                                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H005')).
                                                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H005')) // 'H005': unit "Priest"
                                                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H008')).
                                                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H008')) // 'H008': unit "Time Mage"
                                                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00J')).
                                                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00J')) // 'H00J': unit "Prophet"
                                                    // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H02Y')).
                                                    set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H02Y')) // 'H02Y': unit "Necromancer"
                                                else
                                                    if(Trig_Research_Requirements_IsGun())then
                                                        set udg_JobRequirementText="Gun"
                                                        set udg_TempString=" (Mediator) must have a"
                                                        // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00G')).
                                                        set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00G')) // 'H00G': unit "Mediator"
                                                    else
                                                        if(Trig_Research_Requirements_IsInnerMana())then
                                                            // (udg_ResearchReqLevel) times (2).
                                                            set udg_ResearchReqLevel=(udg_ResearchReqLevel*2)
                                                            set udg_TempInteger=udg_ResearchReqLevel
                                                            set udg_JobRequirementText="Inner Mana"
                                                            set udg_TempString="s (Summoner, Oracle, Sorcerer) must have a combined"
                                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H009')).
                                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H009')) // 'H009': unit "Summoner"
                                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00I')).
                                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00I')) // 'H00I': unit "Oracle"
                                                            // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00L')).
                                                            set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00L')) // 'H00L': unit "Sorcerer"
                                                        else
                                                            if(Trig_Research_Requirements_IsMysticArmor())then
                                                                // (udg_ResearchReqLevel) times (5).
                                                                set udg_ResearchReqLevel=(udg_ResearchReqLevel*5)
                                                                set udg_TempInteger=udg_ResearchReqLevel
                                                                set udg_JobRequirementText="Mystic Armor"
                                                                if(Trig_Research_Requirements_MysticIncludesNecro())then
                                                                    set udg_TempString="s (Wizard, Priest, Summoner, Time Mage, Oracle, Calculator, Prophet, Sorcerer, Necromancer) must have a combined"
                                                                else
                                                                    set udg_TempString="s (Wizard, Priest, Summoner, Time Mage, Oracle, Calculator, Prophet, Sorcerer) must have a combined"
                                                                endif
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H004')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H004')) // 'H004': unit "Wizard"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H005')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H005')) // 'H005': unit "Priest"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H009')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H009')) // 'H009': unit "Summoner"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H008')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H008')) // 'H008': unit "Time Mage"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00I')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00I')) // 'H00I': unit "Oracle"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00H')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00H')) // 'H00H': unit "Calculator"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00J')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00J')) // 'H00J': unit "Prophet"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H00L')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00L')) // 'H00L': unit "Sorcerer"
                                                                // (udg_TempInteger) minus (Job_GetSavedLevel(GetOwningPlayer(the triggering unit), 'H02Y')).
                                                                set udg_TempInteger=(udg_TempInteger-Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H02Y')) // 'H02Y': unit "Necromancer"
                                                            else
                                                                set udg_TempInteger=0
                                                            endif
                                                        endif
                                                    endif
                                                endif
                                            endif
                                        endif
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
    if(Trig_Research_Requirements_LevelsMissing())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        // (GetPlayerTechCountSimple(GetResearched(), GetOwningPlayer(the triggering unit))) plus (1).
        set udg_JobRequirementText=(("In order to research |cffffcc00"+udg_JobRequirementText)+((" Level "+I2S((GetPlayerTechCountSimple(GetResearched(),GetOwningPlayer(GetTriggerUnit()))+1)))+(("|r the user"+(udg_TempString+" level of |cffffcc00"))+(I2S(udg_ResearchReqLevel)+"|r!"))))
        call DisplayTextToForce(udg_TempForce,udg_JobRequirementText)
        set udg_JobRequirementText=("(|cffffcc00"+(I2S(udg_TempInteger)+"|r levels remaining)"))
        call DisplayTextToForce(udg_TempForce,udg_JobRequirementText)
        call DestroyForce(udg_TempForce)
        set udg_TempInteger=1
        loop
            exitwhen udg_TempInteger>7
            call IssueImmediateOrderById(GetTriggerUnit(),$D0008) // $D0008 = 851976
            set udg_TempInteger=udg_TempInteger+1
        endloop
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Research takes nothing returns nothing
endfunction
function RegisterR11_Research_Requirements takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Research_Requirements=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Research_Requirements,EVENT_PLAYER_UNIT_RESEARCH_START)
    call TriggerAddCondition(gg_trg_Research_Requirements,Condition(function Trig_Research_Requirements_Conditions))
    call TriggerAddAction(gg_trg_Research_Requirements,function Trig_Research_Requirements_Actions)
endfunction




endlibrary

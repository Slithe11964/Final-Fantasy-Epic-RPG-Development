library TMateria requires TWait
function Trig_Materia_Altar_Ritual_Conditions takes nothing returns boolean
    // (StringLength(GetItemName(the item being used or moved))) minus (6).
    return(SubStringBJ(GetItemName(GetManipulatedItem()),(StringLength(GetItemName(GetManipulatedItem()))-6),StringLength(GetItemName(GetManipulatedItem())))=="Materia")
endfunction

function Trig_Materia_Altar_Ritual_NotOnAltar takes nothing returns boolean
    return(RectContainsLoc(gg_rct_422,udg_TempPoint)==false)and(RectContainsLoc(gg_rct_423,udg_TempPoint)==false)and(RectContainsLoc(gg_rct_424,udg_TempPoint)==false)and(RectContainsLoc(gg_rct_425,udg_TempPoint)==false)
endfunction

function Trig_Materia_Altar_Ritual_IsDemiLowGrade takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03L')or(GetItemTypeId(GetManipulatedItem())=='I03M') // 'I03L': item "Demi Materia"; 'I03M': item "Demira Materia"
endfunction

function Trig_Materia_Altar_Ritual_IsDemiTooWeak takes nothing returns boolean
    return(Trig_Materia_Altar_Ritual_IsDemiLowGrade())
endfunction

function Trig_Materia_Altar_Ritual_IsDemigaMateria takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03N') // 'I03N': item "Demiga Materia"
endfunction

function Trig_Materia_Altar_Ritual_DemiAltarFree takes nothing returns boolean
    return(RectContainsLoc(gg_rct_422,udg_TempPoint))and(udg_MateriaAltarDone[1]==false)
endfunction

function Trig_Materia_Altar_Ritual_IsWaterLowGrade takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I023')or(GetItemTypeId(GetManipulatedItem())=='I024') // 'I023': item "Water Materia"; 'I024': item "Watera Materia"
endfunction

function Trig_Materia_Altar_Ritual_IsWaterTooWeak takes nothing returns boolean
    return(Trig_Materia_Altar_Ritual_IsWaterLowGrade())
endfunction

function Trig_Materia_Altar_Ritual_IsWateragaMateria takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I025') // 'I025': item "Wateraga Materia"
endfunction

function Trig_Materia_Altar_Ritual_WaterAltarFree takes nothing returns boolean
    return(RectContainsLoc(gg_rct_423,udg_TempPoint))and(udg_MateriaAltarDone[2]==false)
endfunction

function Trig_Materia_Altar_Ritual_IsQuakeLowGrade takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03G')or(GetItemTypeId(GetManipulatedItem())=='I03H') // 'I03G': item "Quake Materia"; 'I03H': item "Quakera Materia"
endfunction

function Trig_Materia_Altar_Ritual_IsQuakeTooWeak takes nothing returns boolean
    return(Trig_Materia_Altar_Ritual_IsQuakeLowGrade())
endfunction

function Trig_Materia_Altar_Ritual_IsQuakeragaMateria takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03F') // 'I03F': item "Quakeraga Materia"
endfunction

function Trig_Materia_Altar_Ritual_QuakeAltarFree takes nothing returns boolean
    return(RectContainsLoc(gg_rct_424,udg_TempPoint))and(udg_MateriaAltarDone[3]==false)
endfunction

function Trig_Materia_Altar_Ritual_IsAeroLowGrade takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I07N')or(GetItemTypeId(GetManipulatedItem())=='I07O') // 'I07N': item "Aero Materia"; 'I07O': item "Aerora Materia"
endfunction

function Trig_Materia_Altar_Ritual_IsAeroTooWeak takes nothing returns boolean
    return(Trig_Materia_Altar_Ritual_IsAeroLowGrade())
endfunction

function Trig_Materia_Altar_Ritual_IsAerogaMateria takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I07P') // 'I07P': item "Aeroga Materia"
endfunction

function Trig_Materia_Altar_Ritual_AeroAltarFree takes nothing returns boolean
    return(RectContainsLoc(gg_rct_425,udg_TempPoint))and(udg_MateriaAltarDone[4]==false)
endfunction

function Trig_Materia_Altar_Ritual_AllAltarsDone takes nothing returns boolean
    return(udg_MateriaAltarDone[1])and(udg_MateriaAltarDone[2])and(udg_MateriaAltarDone[3])and(udg_MateriaAltarDone[4])
endfunction

function Trig_Materia_Altar_Ritual_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Wait_Polled(.2)
    set udg_TempPoint=GetItemLoc(GetManipulatedItem())
    if(Trig_Materia_Altar_Ritual_NotOnAltar())then
        call EnableTrigger(GetTriggeringTrigger())
        call RemoveLocation(udg_TempPoint)
        return
    endif
    if(Trig_Materia_Altar_Ritual_DemiAltarFree())then
        if(Trig_Materia_Altar_Ritual_IsDemigaMateria())then
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveItem(GetManipulatedItem())
            set udg_MateriaAltarDone[1]=true
        else
            if(Trig_Materia_Altar_Ritual_IsDemiTooWeak())then
                call CreateTextTagLocBJ("There is not enough power...",udg_TempPoint,0,9.,'d','d','d',0)
                call SetTextTagLifespanBJ(GetLastCreatedTextTag(),3.)
                call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            endif
        endif
    endif
    if(Trig_Materia_Altar_Ritual_WaterAltarFree())then
        if(Trig_Materia_Altar_Ritual_IsWateragaMateria())then
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveItem(GetManipulatedItem())
            set udg_MateriaAltarDone[2]=true
        else
            if(Trig_Materia_Altar_Ritual_IsWaterTooWeak())then
                call CreateTextTagLocBJ("There is not enough power...",udg_TempPoint,0,9.,'d','d','d',0)
                call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
                call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            endif
        endif
    endif
    if(Trig_Materia_Altar_Ritual_QuakeAltarFree())then
        if(Trig_Materia_Altar_Ritual_IsQuakeragaMateria())then
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveItem(GetManipulatedItem())
            set udg_MateriaAltarDone[3]=true
        else
            if(Trig_Materia_Altar_Ritual_IsQuakeTooWeak())then
                call CreateTextTagLocBJ("There is not enough power...",udg_TempPoint,0,9.,'d','d','d',0)
                call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
                call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            endif
        endif
    endif
    if(Trig_Materia_Altar_Ritual_AeroAltarFree())then
        if(Trig_Materia_Altar_Ritual_IsAerogaMateria())then
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveItem(GetManipulatedItem())
            set udg_MateriaAltarDone[4]=true
        else
            if(Trig_Materia_Altar_Ritual_IsAeroTooWeak())then
                call CreateTextTagLocBJ("There is not enough power...",udg_TempPoint,0,9.,'d','d','d',0)
                call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
                call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            endif
        endif
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Materia_Altar_Ritual_AllAltarsDone())then
        call Wait_Polled(1.)
    else
        call EnableTrigger(GetTriggeringTrigger())
        return
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_422)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_423)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_424)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_425)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set udg_TempPoint=GetRectCenter(gg_rct_422)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_423)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_424)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_425)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set udg_TempPoint=GetRectCenter(gg_rct_422)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_423)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_424)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_425)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2.)
    set udg_TempPoint=GetRectCenter(gg_rct_426)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.33)
    set udg_TempPoint=GetRectCenter(gg_rct_426)
    call CreateItemLoc('I062',udg_TempPoint) // 'I062': item "Aire Tam Enib Moc"
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(GetTriggeringTrigger())
    set udg_MateriaAltarDone[1]=false
    set udg_MateriaAltarDone[2]=false
    set udg_MateriaAltarDone[3]=false
    set udg_MateriaAltarDone[4]=false
endfunction

// World Editor calls InitTrig_Materia automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Materia (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Materia takes nothing returns nothing
endfunction

function Register_Materia_Altar_Ritual takes nothing returns nothing
    set gg_trg_Materia_Altar_Ritual=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Materia_Altar_Ritual,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Materia_Altar_Ritual,Condition(function Trig_Materia_Altar_Ritual_Conditions))
    call TriggerAddAction(gg_trg_Materia_Altar_Ritual,function Trig_Materia_Altar_Ritual_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Materia takes nothing returns nothing
    call Register_Materia_Altar_Ritual()
endfunction

endlibrary

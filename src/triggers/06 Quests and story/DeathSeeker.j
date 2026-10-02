library TDeathSeeker requires TCam, TCine, TPlayerPart01, TText, TWait
function Trig_DeathSeeker_Give_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DeathSeeker_Give_HasFreeSlot takes nothing returns boolean
    return(UnitItemInSlotBJ(GetTriggerUnit(),1)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),2)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),3)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),4)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),5)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),6)==null)
endfunction

function Trig_DeathSeeker_Give_CanCarryItem takes nothing returns boolean
    return(Trig_DeathSeeker_Give_HasFreeSlot())
endfunction

function Trig_DeathSeeker_Give_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DeathSeeker_Give_CanCarryItem())then
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call UnitAddItemByIdSwapped('I067',GetTriggerUnit()) // 'I067': item "Death Seeker"
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call CreateItemLoc('I067',udg_TempPoint) // 'I067': item "Death Seeker"
        call RemoveLocation(udg_TempPoint)
    endif
    // A random whole number from 1 through 3.
    call SetItemCharges(GetLastCreatedItem(),GetRandomInt(1,3))
    call Wait_Polled(180.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_DeathSeeker_TurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I067'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I067': item "Death Seeker"
endfunction

function Trig_DeathSeeker_TurnIn_Cond_ItemHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067'))>=2) // 'I067': item "Death Seeker"
endfunction

function Trig_DeathSeeker_TurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DeathSeeker_TurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DeathSeeker_TurnIn_Cond_ItemHasCharges())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I067')) minus (1).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067'))-1)) // 'I067': item "Death Seeker"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067')) // 'I067': item "Death Seeker"
    endif
    if(Trig_DeathSeeker_TurnIn_Cond_ShowDialogue())then
        call DestroyEffectBJ(udg_SpecialEffect[62])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go. One Death Seeker.",false)
        call Text_Say(gg_unit_n034_0109,"Wow you found it! That's great!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It wasn't easy. We're kind of in a pickle right now, so if you want us to keep helping you it better be worth it.",false)
        call Text_Say(gg_unit_n034_0109,"I know. But it's just one more artifact I need. And this one can't possibly be that hard to find.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That sounds like you have absolutely no idea where to find it.",false)
        call Text_Say(gg_unit_n034_0109,"It's just a Qu Frog's Head. A head of a Qu's Frog. You just need to find a Qu Frog and then kill it. Simple enough right?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hmm, I see. Well I'll try to find one then.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Bring a Qu's Frog Head to Shinra.")
    call QuestSetDescriptionBJ(udg_SideQuest[40],"Shinra, an Al Bhed child from Spira, has asked you to find many artifacts so he can create a portal that can be used to warp through dimensions.\r\nShinra now needs a |cffffcc00Qu's Frog Head|r. So you need to find Qu Frogs, Shinra said there could be some \"around here\".")
    call EnableTrigger(gg_trg_QuFrog_DrainTick)
    call EnableTrigger(gg_trg_QuFrog_Death)
    call ShowUnitShow(gg_unit_n03A_0136)
    call ShowUnitShow(gg_unit_n039_0095)
    call ShowUnitShow(gg_unit_n039_0083)
    call ShowUnitShow(gg_unit_n039_0175)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DeathSeeker takes nothing returns nothing
endfunction

function RegisterR11_DeathSeeker_Give takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DeathSeeker_Give=CreateTrigger()

call DisableTrigger(gg_trg_DeathSeeker_Give)

call TriggerRegisterEnterRectSimple(gg_trg_DeathSeeker_Give,gg_rct_550)

call TriggerAddCondition(gg_trg_DeathSeeker_Give,Condition(function Trig_DeathSeeker_Give_Conditions))

call TriggerAddAction(gg_trg_DeathSeeker_Give,function Trig_DeathSeeker_Give_Actions)

endfunction




function RegisterR11_DeathSeeker_TurnIn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DeathSeeker_TurnIn=CreateTrigger()

call DisableTrigger(gg_trg_DeathSeeker_TurnIn)

call TriggerRegisterUnitInRangeSimple(gg_trg_DeathSeeker_TurnIn,250.,gg_unit_n034_0109)

call TriggerAddCondition(gg_trg_DeathSeeker_TurnIn,Condition(function Trig_DeathSeeker_TurnIn_Conditions))

call TriggerAddAction(gg_trg_DeathSeeker_TurnIn,function Trig_DeathSeeker_TurnIn_Actions)

endfunction




endlibrary

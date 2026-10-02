library THuntEncounters requires TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hunt_Thextera_Escort=null
    trigger gg_trg_Hunt_Tonberry_Setup=null
    trigger gg_trg_Hunt_Demon_Setup=null
    trigger gg_trg_Hunt_Parvati_Setup=null
    trigger gg_trg_Hunt_PhantomDancer_Setup=null
    trigger gg_trg_Hunt_Exdeath_Setup=null
    trigger gg_trg_Hunt_Mephorash_Setup=null
    trigger gg_trg_Hunt_Trickster_Unlock=null
    trigger gg_trg_Hunt_Melaiduma_Setup=null
    trigger gg_trg_Hunt_BlackPearl_Setup=null
    trigger gg_trg_Hunt_Rabite_Setup=null
    trigger gg_trg_Hunt_Verci_Setup=null
    trigger gg_trg_Hunt_Okuu_Setup=null
endglobals

function Trig_Hunt_Thextera_Escort_Actions takes nothing returns nothing
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-256.,64.)
    call CreateNUnitsAtLoc(1,'nwld',Player($B),udg_TempPoint2,180.) // 'nwld': object name not found in map data; $B = 11
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-256.,-64.)
    call CreateNUnitsAtLoc(1,'nwld',Player($B),udg_TempPoint2,180.) // 'nwld': object name not found in map data; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Tonberry_Setup_Actions takes nothing returns nothing
    call TriggerRegisterUnitEvent(gg_trg_Tonberry_Gate_Open,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call ConditionalTriggerExecute(gg_trg_Hunt_Shard_Register)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Demon_Setup_Actions takes nothing returns nothing
    call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),900.)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Demon_Drop_Magatama,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
endfunction

function Trig_Hunt_Parvati_Setup_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('A12T',GetLastCreatedUnit()) // 'A12T': ability "Summon Bandersnatch"
    call ConditionalTriggerExecute(gg_trg_Hunt_Demon_Setup)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-256.,64.)
    call CreateNUnitsAtLoc(1,'n0CG',Player($B),udg_TempPoint2,180.) // 'n0CG': unit "Bandersnatch"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-256.,-64.)
    call CreateNUnitsAtLoc(1,'n0CG',Player($B),udg_TempPoint2,180.) // 'n0CG': unit "Bandersnatch"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_PhantomDancer_Setup_IsFreeCastMode takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Hunt_PhantomDancer_Setup_Actions takes nothing returns nothing
    if(Trig_Hunt_PhantomDancer_Setup_IsFreeCastMode())then
        // (1) minus (1).
        call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0R3',(1-1),0) // 'A0R3': ability "Evade & Counter"
    else
        call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0R3',1,0) // 'A0R3': ability "Evade & Counter"
    endif
    call TriggerRegisterUnitEvent(gg_trg_PhantomDancer_Berserk,GetLastCreatedUnit(),EVENT_UNIT_ATTACKED)
    call EnableTrigger(gg_trg_PhantomDancer_Berserk)
    call TriggerRegisterUnitEvent(gg_trg_PhantomDancer_Blink,GetLastCreatedUnit(),EVENT_UNIT_ATTACKED)
    call EnableTrigger(gg_trg_PhantomDancer_Blink)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Exdeath_Setup_Actions takes nothing returns nothing
    call TriggerRegisterUnitEvent(gg_trg_Exdeath_Drop_Scroll,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
endfunction

function Trig_Hunt_Mephorash_Setup_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    call UnitAddAbilityBJ('A0ZR',GetLastCreatedUnit()) // 'A0ZR': ability "Immortal"
    call TriggerRegisterUnitLifeEvent(gg_trg_Mephorash_Split,GetLastCreatedUnit(),LESS_THAN,5000.)
endfunction

function Trig_Hunt_Trickster_Unlock_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n02U') // 'n02U': unit "Chocobo"
endfunction

function Trig_Hunt_Trickster_Unlock_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call AddUnitToStockBJ('n0BJ',gg_unit_h030_0243,1,1) // 'n0BJ': unit "Hunt: Trickster"
    set udg_HuntStock[8]=(udg_HuntStock[8]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Melaiduma_Setup_FreeCastEnabled takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Hunt_Melaiduma_Setup_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Melaiduma_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    if(Trig_Hunt_Melaiduma_Setup_FreeCastEnabled())then
        // (1) minus (1).
        call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0ZQ',(1-1),0) // 'A0ZQ': ability "!Thunder Rush"
    else
        call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0ZQ',1,0) // 'A0ZQ': ability "!Thunder Rush"
    endif
    call Music_SetTrack(37)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_BlackPearl_Setup_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    call SetHeroLevelBJ(GetLastCreatedUnit(),90,false)
    call UnitAddItemByIdSwapped('I0KW',GetLastCreatedUnit()) // 'I0KW': item "Siphoning Staff"
    call UnitAddItemByIdSwapped('I0H5',GetLastCreatedUnit()) // 'I0H5': item "Dark Energy"
    call UnitAddItemByIdSwapped('I02U',GetLastCreatedUnit()) // 'I02U': item "Helm of the Necromancer"
    call UnitAddItemByIdSwapped('I0K9',GetLastCreatedUnit()) // 'I0K9': item "Vishnu Vest"
    call UnitAddItemByIdSwapped('I063',GetLastCreatedUnit()) // 'I063': item "Charming Banner"
    call TriggerRegisterUnitEvent(gg_trg_BlackPearl_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"stomp")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Rabite_Setup_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",GetLastCreatedUnit())
    call TriggerRegisterUnitEvent(gg_trg_Rabite_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Verci_Setup_Actions takes nothing returns nothing
    set udg_Vercingetorix=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Verci_Awaken,800.,GetLastCreatedUnit())
    call TriggerRegisterUnitInRangeSimple(gg_trg_Verci_Awaken,250.,GetLastCreatedUnit())
    call TriggerRegisterUnitEvent(gg_trg_Verci_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call PauseUnitBJ(true,udg_Vercingetorix)
    call SetUnitInvulnerable(udg_Vercingetorix,true)
    call SetUnitAnimation(udg_Vercingetorix,"stand alternate")
    call EnableTrigger(gg_trg_Verci_Awaken)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Okuu_Setup_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Okuu_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    set udg_OkuuStage=1
    call EnableTrigger(gg_trg_Okuu_Leash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Hunt_Encounters takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hunt (module Hunt),
// which keeps the original registration order.

function Register_Hunt_Thextera_Escort takes nothing returns nothing
    set gg_trg_Hunt_Thextera_Escort=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Thextera_Escort)
    call TriggerAddAction(gg_trg_Hunt_Thextera_Escort,function Trig_Hunt_Thextera_Escort_Actions)
endfunction

function Register_Hunt_Tonberry_Setup takes nothing returns nothing
    set gg_trg_Hunt_Tonberry_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Tonberry_Setup)
    call TriggerAddAction(gg_trg_Hunt_Tonberry_Setup,function Trig_Hunt_Tonberry_Setup_Actions)
endfunction

function Register_Hunt_Demon_Setup takes nothing returns nothing
    set gg_trg_Hunt_Demon_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Demon_Setup)
    call TriggerAddAction(gg_trg_Hunt_Demon_Setup,function Trig_Hunt_Demon_Setup_Actions)
endfunction

function Register_Hunt_Parvati_Setup takes nothing returns nothing
    set gg_trg_Hunt_Parvati_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Parvati_Setup)
    call TriggerAddAction(gg_trg_Hunt_Parvati_Setup,function Trig_Hunt_Parvati_Setup_Actions)
endfunction

function Register_Hunt_PhantomDancer_Setup takes nothing returns nothing
    set gg_trg_Hunt_PhantomDancer_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_PhantomDancer_Setup)
    call TriggerAddAction(gg_trg_Hunt_PhantomDancer_Setup,function Trig_Hunt_PhantomDancer_Setup_Actions)
endfunction

function Register_Hunt_Exdeath_Setup takes nothing returns nothing
    set gg_trg_Hunt_Exdeath_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Exdeath_Setup)
    call TriggerAddAction(gg_trg_Hunt_Exdeath_Setup,function Trig_Hunt_Exdeath_Setup_Actions)
endfunction

function Register_Hunt_Mephorash_Setup takes nothing returns nothing
    set gg_trg_Hunt_Mephorash_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Mephorash_Setup)
    call TriggerAddAction(gg_trg_Hunt_Mephorash_Setup,function Trig_Hunt_Mephorash_Setup_Actions)
endfunction

function Register_Hunt_Trickster_Unlock takes nothing returns nothing
    set gg_trg_Hunt_Trickster_Unlock=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hunt_Trickster_Unlock,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Hunt_Trickster_Unlock,Condition(function Trig_Hunt_Trickster_Unlock_Conditions))
    call TriggerAddAction(gg_trg_Hunt_Trickster_Unlock,function Trig_Hunt_Trickster_Unlock_Actions)
endfunction

function Register_Hunt_Melaiduma_Setup takes nothing returns nothing
    set gg_trg_Hunt_Melaiduma_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Melaiduma_Setup)
    call TriggerAddAction(gg_trg_Hunt_Melaiduma_Setup,function Trig_Hunt_Melaiduma_Setup_Actions)
endfunction

function Register_Hunt_BlackPearl_Setup takes nothing returns nothing
    set gg_trg_Hunt_BlackPearl_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_BlackPearl_Setup)
    call TriggerAddAction(gg_trg_Hunt_BlackPearl_Setup,function Trig_Hunt_BlackPearl_Setup_Actions)
endfunction

function Register_Hunt_Rabite_Setup takes nothing returns nothing
    set gg_trg_Hunt_Rabite_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Rabite_Setup)
    call TriggerAddAction(gg_trg_Hunt_Rabite_Setup,function Trig_Hunt_Rabite_Setup_Actions)
endfunction

function Register_Hunt_Verci_Setup takes nothing returns nothing
    set gg_trg_Hunt_Verci_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Verci_Setup)
    call TriggerAddAction(gg_trg_Hunt_Verci_Setup,function Trig_Hunt_Verci_Setup_Actions)
endfunction

function Register_Hunt_Okuu_Setup takes nothing returns nothing
    set gg_trg_Hunt_Okuu_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Okuu_Setup)
    call TriggerAddAction(gg_trg_Hunt_Okuu_Setup,function Trig_Hunt_Okuu_Setup_Actions)
endfunction

endlibrary

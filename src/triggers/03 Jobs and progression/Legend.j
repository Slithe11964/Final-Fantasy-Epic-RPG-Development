library TLegend requires TLegendArcher, TLegendCalculator, TLegendChemist, TLegendDarkKnight, TLegendFreelancer, TLegendGeomancer, TLegendHolySwordsman, TLegendKnight, TLegendLancer, TLegendMediator, TLegendMonk, TLegendNecromancer, TLegendNinja, TLegendOracle, TLegendPriest, TLegendProphet, TLegendSamurai, TLegendSorcerer, TLegendSquire, TLegendSummoner, TLegendThief, TLegendTimeMage, TLegendWizard
function InitTrig_Legend takes nothing returns nothing
endfunction
function RegisterR11_Legend_Archer_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Archer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Archer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Archer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Archer_Talk,Condition(function Trig_Legend_Archer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Archer_Talk,function Trig_Legend_Archer_Talk_Actions)
endfunction
function RegisterR11_Legend_Calculator_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Calculator_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Calculator_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Calculator_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Calculator_Talk,Condition(function Trig_Legend_Calculator_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Calculator_Talk,function Trig_Legend_Calculator_Talk_Actions)
endfunction
function RegisterR11_Legend_Chemist_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Chemist_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Chemist_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Chemist_Talk,Condition(function Trig_Legend_Chemist_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Chemist_Talk,function Trig_Legend_Chemist_Talk_Actions)
endfunction
function RegisterR11_Legend_DarkKnight_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_DarkKnight_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_DarkKnight_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_DarkKnight_Talk,Condition(function Trig_Legend_DarkKnight_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_DarkKnight_Talk,function Trig_Legend_DarkKnight_Talk_Actions)
endfunction
function RegisterR11_Legend_Freelancer_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Freelancer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Freelancer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Freelancer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Freelancer_Talk,Condition(function Trig_Legend_Freelancer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Freelancer_Talk,function Trig_Legend_Freelancer_Talk_Actions)
endfunction
function RegisterR11_Legend_Geomancer_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Geomancer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Geomancer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Geomancer_Talk,Condition(function Trig_Legend_Geomancer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Geomancer_Talk,function Trig_Legend_Geomancer_Talk_Actions)
endfunction
function RegisterR11_Legend_HolySwordsman_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_HolySwordsman_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_HolySwordsman_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_HolySwordsman_Talk,Condition(function Trig_Legend_HolySwordsman_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_HolySwordsman_Talk,function Trig_Legend_HolySwordsman_Talk_Actions)
endfunction
function RegisterR11_Legend_Knight_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Knight_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Knight_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Knight_Talk,Condition(function Trig_Legend_Knight_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Knight_Talk,function Trig_Legend_Knight_Talk_Actions)
endfunction
function RegisterR11_Legend_Lancer_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Lancer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Lancer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Lancer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Lancer_Talk,Condition(function Trig_Legend_Lancer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Lancer_Talk,function Trig_Legend_Lancer_Talk_Actions)
endfunction
function RegisterR11_Legend_Mediator_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Mediator_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Mediator_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Mediator_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Mediator_Talk,Condition(function Trig_Legend_Mediator_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Mediator_Talk,function Trig_Legend_Mediator_Talk_Actions)
endfunction
function RegisterR11_Legend_Monk_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Monk_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Monk_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Monk_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Monk_Talk,Condition(function Trig_Legend_Monk_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Monk_Talk,function Trig_Legend_Monk_Talk_Actions)
endfunction
function RegisterR11_Legend_Necromancer_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Necromancer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Necromancer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Necromancer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Necromancer_Talk,Condition(function Trig_Legend_Necromancer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Necromancer_Talk,function Trig_Legend_Necromancer_Talk_Actions)
endfunction
function RegisterR11_Legend_Ninja_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Ninja_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Ninja_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Ninja_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Ninja_Talk,Condition(function Trig_Legend_Ninja_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Ninja_Talk,function Trig_Legend_Ninja_Talk_Actions)
endfunction
function RegisterR11_Legend_Oracle_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Oracle_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Oracle_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Oracle_Talk,Condition(function Trig_Legend_Oracle_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Oracle_Talk,function Trig_Legend_Oracle_Talk_Actions)
endfunction
function RegisterR11_Legend_Priest_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Priest_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Priest_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Priest_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Priest_Talk,Condition(function Trig_Legend_Priest_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Priest_Talk,function Trig_Legend_Priest_Talk_Actions)
endfunction
function RegisterR11_Legend_Prophet_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Prophet_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Prophet_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Prophet_Talk,Condition(function Trig_Legend_Prophet_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Prophet_Talk,function Trig_Legend_Prophet_Talk_Actions)
endfunction
function RegisterR11_Legend_Samurai_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Samurai_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Samurai_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Samurai_Talk,Condition(function Trig_Legend_Samurai_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Samurai_Talk,function Trig_Legend_Samurai_Talk_Actions)
endfunction
function RegisterR11_Legend_Sorcerer_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Sorcerer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Sorcerer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Sorcerer_Talk,Condition(function Trig_Legend_Sorcerer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Sorcerer_Talk,function Trig_Legend_Sorcerer_Talk_Actions)
endfunction
function RegisterR11_Legend_Squire_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Squire_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Squire_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Squire_Talk,Condition(function Trig_Legend_Squire_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Squire_Talk,function Trig_Legend_Squire_Talk_Actions)
endfunction
function RegisterR11_Legend_Summoner_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Summoner_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Summoner_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Summoner_Talk,Condition(function Trig_Legend_Summoner_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Summoner_Talk,function Trig_Legend_Summoner_Talk_Actions)
endfunction
function RegisterR11_Legend_Thief_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Thief_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Thief_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Thief_Talk,Condition(function Trig_Legend_Thief_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Thief_Talk,function Trig_Legend_Thief_Talk_Actions)
endfunction
function RegisterR11_Legend_TimeMage_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_TimeMage_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_TimeMage_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_TimeMage_Talk,Condition(function Trig_Legend_TimeMage_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_TimeMage_Talk,function Trig_Legend_TimeMage_Talk_Actions)
endfunction
function RegisterR11_Legend_Wizard_Talk takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Legend_Wizard_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Wizard_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Wizard_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Wizard_Talk,Condition(function Trig_Legend_Wizard_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Wizard_Talk,function Trig_Legend_Wizard_Talk_Actions)
endfunction





endlibrary

library TWrap requires TBlizzaga, TClione, TCode, TKnock, TLiquidSteel, TMissile, TRapidFire, TShuriken, TTatsumaki, TWickedWhirl
function Wrap_InitTriggers takes nothing returns nothing
    set udg_KnockRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_KnockRemoveTrig,Condition(function Knock_Remove))
    set udg_ClioneRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_ClioneRemoveTrig,Condition(function Clione_Remove))
    set udg_WickedWhirlDamageTrig=CreateTrigger()
    call TriggerAddCondition(udg_WickedWhirlDamageTrig,Condition(function WickedWhirl_Damage))
    set udg_WickedWhirlRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_WickedWhirlRemoveTrig,Condition(function WickedWhirl_Remove))
    set udg_LiquidSteelRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_LiquidSteelRemoveTrig,Condition(function LiquidSteel_Remove))
    set udg_TatsumakiPullTrig=CreateTrigger()
    call TriggerAddCondition(udg_TatsumakiPullTrig,Condition(function Tatsumaki_Pull))
    set udg_TatsumakiStompTrig=CreateTrigger()
    call TriggerAddCondition(udg_TatsumakiStompTrig,Condition(function Tatsumaki_Stomp))
    set udg_TatsumakiRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_TatsumakiRemoveTrig,Condition(function Tatsumaki_Remove))
    set udg_ShurikenDamageTrig=CreateTrigger()
    call TriggerAddCondition(udg_ShurikenDamageTrig,Condition(function Shuriken_Damage))
    set udg_ShurikenRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_ShurikenRemoveTrig,Condition(function Shuriken_Remove))
    set udg_RapidFireRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_RapidFireRemoveTrig,Condition(function RapidFire_Remove))
    set udg_BlizzagaDamageTrig=CreateTrigger()
    call TriggerAddCondition(udg_BlizzagaDamageTrig,Condition(function Blizzaga_Damage))
    set udg_BlizzagaRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_BlizzagaRemoveTrig,Condition(function Blizzaga_Remove))
    set udg_MissileCollisionTrig=CreateTrigger()
    call TriggerAddCondition(udg_MissileCollisionTrig,Condition(function Missile_CheckCollision))
    set udg_MissileDamageTrig=CreateTrigger()
    call TriggerAddCondition(udg_MissileDamageTrig,Condition(function Missile_DamageWrap))
    set udg_MissileImpactTrig=CreateTrigger()
    call TriggerAddCondition(udg_MissileImpactTrig,Condition(function Missile_Impact))
    set udg_CodeCreateTrig=CreateTrigger()
    call TriggerAddCondition(udg_CodeCreateTrig,Condition(function Code_Create))
    set udg_CodeFreeTrig[2]=null
    set udg_CodeFreeTrig[7]=null
    set udg_CodeWriteIntTrig=CreateTrigger()
    call TriggerAddCondition(udg_CodeWriteIntTrig,Condition(function Code_WriteInt))
    set udg_CodeFreeTrig[3]=CreateTrigger()
    call TriggerAddCondition(udg_CodeFreeTrig[3],Condition(function Code_FreeSlot))
    set udg_CodeReadIntTrig=CreateTrigger()
    call TriggerAddCondition(udg_CodeReadIntTrig,Condition(function Code_ReadInt))
endfunction

function InitTrig_Wrap takes nothing returns nothing
endfunction

endlibrary

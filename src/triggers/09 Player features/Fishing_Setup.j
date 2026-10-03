library TFishingSetup requires TGroup, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Fishing_Pole_Found=null
    trigger gg_trg_Fishing_Unlock=null
endglobals

function Trig_Fishing_Setup_HideFishingSpot takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call SetUnitLifePercentBJ(GetEnumUnit(),'d')
endfunction

function Trig_Fishing_Setup_Actions takes nothing returns nothing
    call SetDestructableInvulnerableBJ(gg_dest_LTcr_0058,true)
    set udg_FishLoot[0]='I0FI' // 'I0FI': item "Tiny Fish"
    set udg_FishLoot[1]='I0FI' // 'I0FI': item "Tiny Fish"
    set udg_FishLoot[2]='I0GS' // 'I0GS': item "Small Fish"
    set udg_FishLoot[3]='I0GS' // 'I0GS': item "Small Fish"
    set udg_FishLoot[4]='I0GT' // 'I0GT': item "Nebra Fish"
    set udg_FishLoot[5]='I0GT' // 'I0GT': item "Nebra Fish"
    set udg_FishLoot[6]='I0GU' // 'I0GU': item "Strong Fish"
    set udg_FishLoot[7]='I0GV' // 'I0GV': item "Great Fish"
    set udg_FishLoot[8]='I0GV' // 'I0GV': item "Great Fish"
    set udg_FishLoot[9]='I0GW' // 'I0GW': item "Gold Fish"
    set udg_FishLoot[$A]='I02V' // $A = 10; 'I02V': item "Nectar"
    set udg_FishLoot[$B]='I000' // $B = 11; 'I000': item "X-Potion"
    set udg_FishLoot[$C]='I002' // $C = 12; 'I002': item "Turbo Ether"
    set udg_FishLoot[$D]='sror' // $D = 13; 'sror': item "Spirit of Lowtown"
    set udg_FishLoot[$E]='I0DI' // $E = 14; 'I0DI': item "Remedy"
    set udg_FishLoot[$F]='I02X' // $F = 15; 'I02X': item "Greater Nectar"
    set udg_FishLoot[16]='I05I' // 'I05I': item "Spirit Potion"
    set udg_FishLoot[17]='I05H' // 'I05H': item "Blood Ether"
    set udg_FishLoot[18]='pdiv' // 'pdiv': item "Hero Drink"
    set udg_FishLoot[19]='pres' // 'pres': item "Elixir"
    set udg_FishLoot[20]='I08J' // 'I08J': item "Damaged Turtle Tail"
    set udg_FishLoot[21]='I07E' // 'I07E': item "Triton Head"
    set udg_FishLoot[22]='I08J' // 'I08J': item "Damaged Turtle Tail"
    set udg_FishLoot[23]='I06S' // 'I06S': item "Damaged Adamantite"
    set udg_FishLoot[24]='I0GY' // 'I0GY': item "Naga Hide"
    set udg_FishLoot[25]='I0GX' // 'I0GX': item "Nebra Ore"
    set udg_FishLoot[26]='I0GX' // 'I0GX': item "Nebra Ore"
    set udg_FishLoot[27]='I082' // 'I082': item "Serpent Skin"
    set udg_FishLoot[28]='I07D' // 'I07D': item "Turtle Tail"
    set udg_FishLoot[29]='I07D' // 'I07D': item "Turtle Tail"
    set udg_FishLoot[30]='I004' // 'I004': item "100 Gold Coins"
    set udg_FishLoot[31]='I004' // 'I004': item "100 Gold Coins"
    set udg_FishLoot[32]='I005' // 'I005': item "150 Gold Coins"
    set udg_FishLoot[33]='I003' // 'I003': item "200 Gold Coins"
    set udg_FishLoot[34]='I006' // 'I006': item "250 Gold Coins"
    set udg_FishLoot[35]='I00X' // 'I00X': item "500 Gold Coins"
    set udg_FishLoot[36]='I00Y' // 'I00Y': item "1000 Gold Coins"
    set udg_FishLoot[37]='I021' // 'I021': item "1500 Gold Coins"
    set udg_FishLoot[38]='I0CV' // 'I0CV': item "10000 Gold Coins"
    set udg_FishLoot[39]='I0CV' // 'I0CV': item "10000 Gold Coins"
    set udg_FishLoot[40]='I0FJ' // 'I0FJ': item "Angry Tritons"
    set udg_FishLoot[41]='I0FJ' // 'I0FJ': item "Angry Tritons"
    set udg_FishLoot[42]='I0GL' // 'I0GL': item "Sneaky Tritons"
    set udg_FishLoot[43]='I0GL' // 'I0GL': item "Sneaky Tritons"
    set udg_FishLoot[44]='I0GN' // 'I0GN': item "Water Flans"
    set udg_FishLoot[45]='I0GO' // 'I0GO': item "Big Pudding"
    set udg_FishLoot[46]='I0GM' // 'I0GM': item "Poisonous Fiends"
    set udg_FishLoot[47]='I0GP' // 'I0GP': item "Black Flan"
    set udg_FishLoot[48]='I0GQ' // 'I0GQ': item "a Huge Turtle"
    set udg_FishLoot[49]='I0GQ' // 'I0GQ': item "a Huge Turtle"
    set udg_FishLoot[50]='I01Z' // 'I01Z': item "Crystal Shard"
    set udg_FishLoot[60]='I0FU' // 'I0FU': item "Earth Gem"
    set udg_FishLoot[61]='I0FU' // 'I0FU': item "Earth Gem"
    set udg_FishLoot[62]='I0FT' // 'I0FT': item "Water Gem"
    set udg_FishLoot[63]='I0FT' // 'I0FT': item "Water Gem"
    set udg_FishLoot[64]='I0G2' // 'I0G2': item "Holy Gem"
    set udg_FishLoot[65]='I0GX' // 'I0GX': item "Nebra Ore"
    set udg_FishLoot[66]='I0G8' // 'I0G8': item "Dark Gem"
    set udg_FishLoot[67]='I0GX' // 'I0GX': item "Nebra Ore"
    set udg_FishLoot[68]='I0GX' // 'I0GX': item "Nebra Ore"
    set udg_FishLoot[69]='I08B' // 'I08B': item "Serpent Gem"
    set udg_FishLoot[70]='I0FG' // 'I0FG': item "Gilgamesh"
    set udg_FishLoot[80]='I07C' // 'I07C': item "Nethril"
    set udg_FishLoot[81]='I06P' // 'I06P': item "Scarletite"
    set udg_FishLoot[82]='I07C' // 'I07C': item "Nethril"
    set udg_FishLoot[83]='I06P' // 'I06P': item "Scarletite"
    set udg_FishLoot[84]='I085' // 'I085': item "Wild Cry"
    set udg_FishLoot[85]='I085' // 'I085': item "Wild Cry"
    set udg_FishLoot[86]='I085' // 'I085': item "Wild Cry"
    set udg_FishLoot[87]='I084' // 'I084': item "Adamantite"
    set udg_FishLoot[88]='I084' // 'I084': item "Adamantite"
    set udg_FishLoot[89]='I084' // 'I084': item "Adamantite"
    set udg_FishLoot[90]='I0FH' // 'I0FH': item "The Nebra King"
    set udg_FishLoot['d']='I0BT' // 'I0BT': item "Brotherhood"
    set udg_FishMonster[0]='nmrr' // 'nmrr': unit "Triton Huntsman"
    set udg_FishMonster[1]='nmrm' // 'nmrm': unit "Triton Nightcrawler"
    set udg_FishMonster[2]='n01Q' // 'n01Q': unit "Aqua Flan"
    set udg_FishMonster[3]='n01N' // 'n01N': unit "Greater Flan"
    set udg_FishMonster[4]='n03I' // 'n03I': unit "Toxic Triton"
    set udg_FishMonster[5]='n042' // 'n042': unit "Dark Flan"
    set udg_FishMonster[6]='n02P' // 'n02P': unit "Adamantoise"
    set udg_SeaKingQuestStarted=false
    set udg_GilgameshDefeated=false
    set udg_GenjiGiftStage=0
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0244,$186A0) // $186A0 = 100000
    call SetUnitFacingTimed(gg_unit_n0AQ_0244,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0249,$30D40) // $30D40 = 200000
    call SetUnitFacingTimed(gg_unit_n0AQ_0249,.0,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0250,$493E0) // $493E0 = 300000
    call SetUnitFacingTimed(gg_unit_n0AQ_0250,90.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0251,$B71B0) // $B71B0 = 750000
    call SetUnitFacingTimed(gg_unit_n0AQ_0251,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0016,$493E0) // $493E0 = 300000
    call SetUnitFacingTimed(gg_unit_n0AQ_0016,180.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0173,$249F0) // $249F0 = 150000
    call SetUnitFacingTimed(gg_unit_n0AQ_0173,90.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0177,$61A80) // $61A80 = 400000
    call SetUnitFacingTimed(gg_unit_n0AQ_0177,90.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0212,$249F0) // $249F0 = 150000
    call SetUnitFacingTimed(gg_unit_n0AQ_0212,180.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0213,$30D40) // $30D40 = 200000
    call SetUnitFacingTimed(gg_unit_n0AQ_0213,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0214,$C3500) // $C3500 = 800000
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0215,$927C0) // $927C0 = 600000
    call SetUnitFacingTimed(gg_unit_n0AQ_0215,.0,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0216,$55730) // $55730 = 350000
    call SetUnitFacingTimed(gg_unit_n0AQ_0216,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0217,$7A120) // $7A120 = 500000
    call SetUnitFacingTimed(gg_unit_n0AQ_0217,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0218,$7A120) // $7A120 = 500000
    call SetUnitFacingTimed(gg_unit_n0AQ_0218,180.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0219,$61A80) // $61A80 = 400000
    call SetUnitFacingTimed(gg_unit_n0AQ_0219,90.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0224,$493E0) // $493E0 = 300000
    call SetUnitFacingTimed(gg_unit_n0AQ_0224,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0225,$9EB10) // $9EB10 = 650000
    call SetUnitFacingTimed(gg_unit_n0AQ_0225,180.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0226,$6DDD0) // $6DDD0 = 450000
    call SetUnitFacingTimed(gg_unit_n0AQ_0226,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0241,$30D40) // $30D40 = 200000
    call SetUnitFacingTimed(gg_unit_n0AQ_0241,270.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0242,$927C0) // $927C0 = 600000
    call SetUnitFacingTimed(gg_unit_n0AQ_0242,180.,0)
    call BlzSetUnitMaxHP(gg_unit_n0AQ_0245,$6DDD0) // $6DDD0 = 450000
    call SetUnitFacingTimed(gg_unit_n0AQ_0245,90.,0)
    set udg_FishingSpots=Group_UnitsOfType('n0AQ') // 'n0AQ': unit "Fishing Spot"
    call ForGroupBJ(udg_FishingSpots,function Trig_Fishing_Setup_HideFishingSpot)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Fishing_Pole_Found_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Fishing_Pole_Found_RukselHintPending takes nothing returns boolean
    return(udg_RukselHintShown==false)
endfunction

function Trig_Fishing_Pole_Found_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetDestructableLoc(gg_dest_LTcr_0058)
    call CreateItemLoc('I0EY',l_tempPoint) // 'I0EY': item "Fishing Pole"
    call RemoveLocation(l_tempPoint)
    call KillDestructable(gg_dest_LTcr_0058)
    if(Trig_Fishing_Pole_Found_RukselHintPending())then
        call DestroyEffectBJ(udg_QuestMarkerEffect[23])
        call DisableTrigger(gg_trg_Npc_Talk_Ruksel)
        call DestroyTrigger(gg_trg_Npc_Talk_Ruksel)
    endif
    set udg_SpecialEffect[92]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0AW_0223,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_FishyDeals_Start)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Fishing_Unlock_IsFishingRod takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0EY')or(GetItemTypeId(GetManipulatedItem())=='I0EZ')or(GetItemTypeId(GetManipulatedItem())=='I0GB')or(GetItemTypeId(GetManipulatedItem())=='I0GC') // 'I0EY': item "Fishing Pole"; 'I0EZ': item "Muramata"; 'I0GB': item "Matamune"; 'I0GC': item "Lu Shang"
endfunction

function Trig_Fishing_Unlock_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit())))and(Trig_Fishing_Unlock_IsFishingRod())
endfunction

function Trig_Fishing_Unlock_ShowFishingSpot takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_Fishing_Unlock_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForGroupBJ(udg_FishingSpots,function Trig_Fishing_Unlock_ShowFishingSpot)
    call AddItemToStockBJ('I0HB',gg_unit_n02Y_0052,1,1) // 'I0HB': item "Information: Fishing"
    call EnableTrigger(gg_trg_Fishing_Cast)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Fishing_Setup takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Fishing_Part1 (module Fishing),
// which keeps the original registration order.

function Register_Fishing_Setup takes nothing returns nothing
    set gg_trg_Fishing_Setup=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Fishing_Setup,2.)
    call TriggerAddAction(gg_trg_Fishing_Setup,function Trig_Fishing_Setup_Actions)
endfunction

function Register_Fishing_Pole_Found takes nothing returns nothing
    set gg_trg_Fishing_Pole_Found=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Fishing_Pole_Found,gg_rct_581)
    call TriggerAddCondition(gg_trg_Fishing_Pole_Found,Condition(function Trig_Fishing_Pole_Found_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Pole_Found,function Trig_Fishing_Pole_Found_Actions)
endfunction

function Register_Fishing_Unlock takes nothing returns nothing
    set gg_trg_Fishing_Unlock=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fishing_Unlock,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Fishing_Unlock,Condition(function Trig_Fishing_Unlock_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Unlock,function Trig_Fishing_Unlock_Actions)
endfunction

endlibrary

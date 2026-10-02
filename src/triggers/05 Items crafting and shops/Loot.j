library TLoot requires TForce, TItemShared, TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Loot_MonsterDrop=null
    trigger gg_trg_Loot_CancelDespawn=null
    trigger gg_trg_Loot_Tables_Init=null
    trigger gg_trg_Loot_EssenceDrop=null
    trigger gg_trg_Loot_BlockLeaverItems=null
    trigger gg_trg_Loot_Cuchulainn_EyeDrop=null
    // Variables only this module uses.
    integer array udg_MonographItem
    integer array udg_ZonePowerupItem
    boolean udg_MonographBonusDrop=false
    item udg_LastLootItem=null
endglobals

function Loot_CreateItem takes unit l_source,integer itemTypeId returns item
    if(itemTypeId==-1)then
        return null
    endif
    // Scatter the item by up to 32 map units left/right and up/down from its source.
    set udg_LastLootItem=CreateItem(itemTypeId,GetUnitX(l_source)+GetRandomReal(-32,32),GetUnitY(l_source)+GetRandomReal(-32,32))
    call SetItemDropID(udg_LastLootItem,GetUnitTypeId(l_source))
    call UpdateStockAvailability(udg_LastLootItem)
    return udg_LastLootItem
endfunction

function Loot_DropEthers takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('pgma',50) // 'pgma': item "Hi-Ether"
        call RandomDistAddItem('pman',50) // 'pman': item "Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropPotionOrEther takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('phea',50) // 'phea': item "Potion"
        call RandomDistAddItem('pman',50) // 'pman': item "Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropSmallGold takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',$A) // 'gold': item "50 Gold Coins"; $A = 10
        call RandomDistAddItem('gold',$A) // 'gold': item "50 Gold Coins"; $A = 10
        call RandomDistAddItem('gold',$A) // 'gold': item "50 Gold Coins"; $A = 10
        call RandomDistAddItem('gold',$A) // 'gold': item "50 Gold Coins"; $A = 10
        call RandomDistAddItem('gold',$A) // 'gold': item "50 Gold Coins"; $A = 10
        call RandomDistAddItem('gold',$A) // 'gold': item "50 Gold Coins"; $A = 10
        call RandomDistAddItem('gold',$A) // 'gold': item "50 Gold Coins"; $A = 10
        call RandomDistAddItem('I004',$A) // 'I004': item "100 Gold Coins"; $A = 10
        call RandomDistAddItem('I005',$A) // 'I005': item "150 Gold Coins"; $A = 10
        call RandomDistAddItem('I01Z',$A) // 'I01Z': item "Crystal Shard"; $A = 10
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropMediumGold takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',20) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I004',20) // 'I004': item "100 Gold Coins"
        call RandomDistAddItem('I005',24) // 'I005': item "150 Gold Coins"
        call RandomDistAddItem('I003',9) // 'I003': item "200 Gold Coins"
        call RandomDistAddItem('I006',9) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('I00X',9) // 'I00X': item "500 Gold Coins"
        call RandomDistAddItem('I00Y',9) // 'I00Y': item "1000 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropElixirOrGold takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('pres',$A) // 'pres': item "Elixir"; $A = 10
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I004',20) // 'I004': item "100 Gold Coins"
        call RandomDistAddItem('I005',20) // 'I005': item "150 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropPotion takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('phea','d') // 'phea': item "Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropCrushersBelt takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I031','d') // 'I031': item "Crusher's Belt"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I001',50) // 'I001': item "Mega Potion"
        call RandomDistAddItem('sman',50) // 'sman': item "Mega Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropMolotovShot takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I0HL','d') // 'I0HL': item "Molotov Shot"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropKikuIchimonji takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I00Y',67) // 'I00Y': item "1000 Gold Coins"
        call RandomDistAddItem('I01Z',33) // 'I01Z': item "Crystal Shard"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I00X','d') // 'I00X': item "500 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I02V',34) // 'I02V': item "Nectar"
        call RandomDistAddItem('I001',33) // 'I001': item "Mega Potion"
        call RandomDistAddItem('sman',33) // 'sman': item "Mega Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I05T','d') // 'I05T': item "Kiku-Ichimonji"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Drop500Gold takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I00X','d') // 'I00X': item "500 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropTotemAndBubbleShot takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I00L',50) // 'I00L': item "Totem of Power"
        call RandomDistAddItem('I00P',50) // 'I00P': item "Greater Totem of Power"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0HM','d') // 'I0HM': item "Bubble Shot"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropRingOfRejuvenation takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('rhe3','d') // 'rhe3': item "Healaga"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rma2','d') // 'rma2': item "Greater Mana"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0KD','d') // 'I0KD': item "Ring of Rejuvenation"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropWandOfTheWind takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('rhe3','d') // 'rhe3': item "Healaga"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rma2','d') // 'rma2': item "Greater Mana"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0KX','d') // 'I0KX': item "Wand of the Wind"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropRockShot takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('rhe3','d') // 'rhe3': item "Healaga"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rma2','d') // 'rma2': item "Greater Mana"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0HK','d') // 'I0HK': item "Rock Shot"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropSummonersHorn takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',34) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I02X',33) // 'I02X': item "Greater Nectar"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',34) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('sror',33) // 'sror': item "Spirit of Lowtown"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',34) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('I001',33) // 'I001': item "Mega Potion"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0CN','d') // 'I0CN': item "Summoner's Horn"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_DropWhiteMateria takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('pres','d') // 'pres': item "Elixir"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I01Z',20) // 'I01Z': item "Crystal Shard"
        call RandomDistAddItem(-1,80)
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0EC','d') // 'I0EC': item "White Materia"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I003',50) // 'I003': item "200 Gold Coins"
        call RandomDistAddItem('I005',50) // 'I005': item "150 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I004',50) // 'I004': item "100 Gold Coins"
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('gold',34) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I003',33) // 'I003': item "200 Gold Coins"
        call RandomDistAddItem(-1,33)
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_Aldebaran takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I0C1','d') // 'I0C1': item "Aldebaran"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I004',50) // 'I004': item "100 Gold Coins"
        call RandomDistAddItem('I02X',50) // 'I02X': item "Greater Nectar"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I003',34) // 'I003': item "200 Gold Coins"
        call RandomDistAddItem('I004',33) // 'I004': item "100 Gold Coins"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I004',50) // 'I004': item "100 Gold Coins"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_GoldCache takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I00X',50) // 'I00X': item "500 Gold Coins"
        call RandomDistAddItem('I003',50) // 'I003': item "200 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I00Y',50) // 'I00Y': item "1000 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('gold',34) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I004',33) // 'I004': item "100 Gold Coins"
        call RandomDistAddItem(-1,33)
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_GnollHut_Ether takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('pman','d') // 'pman': item "Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_GnollHut_Potion takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('phea','d') // 'phea': item "Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_GnollHut_Gold takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I004','d') // 'I004': item "100 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_CatsBell takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I000',50) // 'I000': item "X-Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('I00R',50) // 'I00R': item "Cat's Bell"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',50) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('I001',50) // 'I001': item "Mega Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I000',20) // 'I000': item "X-Potion"
        call RandomDistAddItem('rsps',20) // 'rsps': item "Faithga"
        call RandomDistAddItem('gold',20) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I01Z',20) // 'I01Z': item "Crystal Shard"
        call RandomDistAddItem('gold',20) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pres',$A) // 'pres': item "Elixir"; $A = 10
        call RandomDistAddItem(-1,90)
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_Restoration takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('I005',50) // 'I005': item "150 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I003',50) // 'I003': item "200 Gold Coins"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rhe2',50) // 'rhe2': item "Healara"
        call RandomDistAddItem('I000',50) // 'I000': item "X-Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rres',50) // 'rres': item "Restoration"
        call RandomDistAddItem('I005',50) // 'I005': item "150 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_SetzersCoin takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I000','d') // 'I000': item "X-Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I002','d') // 'I002': item "Turbo Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0D0','d') // 'I0D0': item "Setzer's Coin"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_SprintShoes takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('pman',50) // 'pman': item "Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I005',50) // 'I005': item "150 Gold Coins"
        call RandomDistAddItem('I000',50) // 'I000': item "X-Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I003',50) // 'I003': item "200 Gold Coins"
        call RandomDistAddItem('I00E',50) // 'I00E': item "Sprint Shoes"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_ChimesOfPiercing takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I003','d') // 'I003': item "200 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I005','d') // 'I005': item "150 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I00J','d') // 'I00J': item "Chimes of Piercing"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rres',50) // 'rres': item "Restoration"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_TotemOfPower takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I003',50) // 'I003': item "200 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rma2',50) // 'rma2': item "Greater Mana"
        call RandomDistAddItem('I00L',50) // 'I00L': item "Totem of Power"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rspl',34) // 'rspl': item "Growth"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I006',33) // 'I006': item "250 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_CrystalShard takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I000',50) // 'I000': item "X-Potion"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I000',50) // 'I000': item "X-Potion"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I000',50) // 'I000': item "X-Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I002',50) // 'I002': item "Turbo Ether"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I002',50) // 'I002': item "Turbo Ether"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('I004',50) // 'I004': item "100 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',25) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I01Z',25) // 'I01Z': item "Crystal Shard"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_OrcCamp_Fortress takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('pres','d') // 'pres': item "Elixir"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rres',75) // 'rres': item "Restoration"
        call RandomDistAddItem('I00X',25) // 'I00X': item "500 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rhe3',25) // 'rhe3': item "Healaga"
        call RandomDistAddItem('gold',75) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I01Z','d') // 'I01Z': item "Crystal Shard"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_OrcCamp_Altar takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I006','d') // 'I006': item "250 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_OrcCamp_Barracks1 takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I003','d') // 'I003': item "200 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_OrcCamp_Barracks2 takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I003','d') // 'I003': item "200 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_OrcCamp_PigFarm takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I01Z',50) // 'I01Z': item "Crystal Shard"
        call RandomDistAddItem('I004',50) // 'I004': item "100 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_CentaurTent_Gold takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold','d') // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_CentaurTent_GoldCache takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I003',$B) // 'I003': item "200 Gold Coins"; $B = 11
        call RandomDistAddItem('gold',$B) // 'gold': item "50 Gold Coins"; $B = 11
        call RandomDistAddItem('gold',$B) // 'gold': item "50 Gold Coins"; $B = 11
        call RandomDistAddItem('I01Z',$B) // 'I01Z': item "Crystal Shard"; $B = 11
        call RandomDistAddItem('I00X',$B) // 'I00X': item "500 Gold Coins"; $B = 11
        call RandomDistAddItem('I00Y',$C) // 'I00Y': item "1000 Gold Coins"; $C = 12
        call RandomDistAddItem('gold',$B) // 'gold': item "50 Gold Coins"; $B = 11
        call RandomDistAddItem('gold',$B) // 'gold': item "50 Gold Coins"; $B = 11
        call RandomDistAddItem('gold',$B) // 'gold': item "50 Gold Coins"; $B = 11
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_Potions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',34) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I000',33) // 'I000': item "X-Potion"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',34) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('I001',33) // 'I001': item "Mega Potion"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I000',$F) // 'I000': item "X-Potion"; $F = 15
        call RandomDistAddItem('rsps',$F) // 'rsps': item "Faithga"; $F = 15
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('I01Z',$E) // 'I01Z': item "Crystal Shard"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_Scrolls takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('rdis',34) // 'rdis': item "Bravega"
        call RandomDistAddItem('rhe3',33) // 'rhe3': item "Healaga"
        call RandomDistAddItem('rsps',33) // 'rsps': item "Faithga"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006','d') // 'I006': item "250 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',50) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('pgma',50) // 'pgma': item "Hi-Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_RuneBlade takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I01Z',25) // 'I01Z': item "Crystal Shard"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('rhe3',25) // 'rhe3': item "Healaga"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',34) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('I005',33) // 'I005': item "150 Gold Coins"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',25) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('I001',25) // 'I001': item "Mega Potion"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I00F',25) // 'I00F': item "Jade Collar"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I000',$D) // 'I000': item "X-Potion"; $D = 13
        call RandomDistAddItem('rsps',$D) // 'rsps': item "Faithga"; $D = 13
        call RandomDistAddItem('gold',$C) // 'gold': item "50 Gold Coins"; $C = 12
        call RandomDistAddItem('I00Z',$C) // 'I00Z': item "Rune Blade"; $C = 12
        call RandomDistAddItem('gold',$C) // 'gold': item "50 Gold Coins"; $C = 12
        call RandomDistAddItem('I004',$C) // 'I004': item "100 Gold Coins"; $C = 12
        call RandomDistAddItem('gold',$D) // 'gold': item "50 Gold Coins"; $D = 13
        call RandomDistAddItem('gold',$D) // 'gold': item "50 Gold Coins"; $D = 13
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_BlazerGloves takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I01Z',25) // 'I01Z': item "Crystal Shard"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I000',25) // 'I000': item "X-Potion"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',34) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',25) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('I00C',25) // 'I00C': item "Blazer Gloves"
        call RandomDistAddItem('I001',25) // 'I001': item "Mega Potion"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I000',$F) // 'I000': item "X-Potion"; $F = 15
        call RandomDistAddItem('rsps',$F) // 'rsps': item "Faithga"; $F = 15
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_Stopwatch takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I0GJ','d') // 'I0GJ': item "Stopwatch"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',50) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',50) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',25) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('I001',25) // 'I001': item "Mega Potion"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('gold',25) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I000',$F) // 'I000': item "X-Potion"; $F = 15
        call RandomDistAddItem('rsps',$F) // 'rsps': item "Faithga"; $F = 15
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        call RandomDistAddItem('gold',$E) // 'gold': item "50 Gold Coins"; $E = 14
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_DemonAxe takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I0EW','d') // 'I0EW': item "Demon Axe"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I01Z','d') // 'I01Z': item "Crystal Shard"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I00Y',50) // 'I00Y': item "1000 Gold Coins"
        call RandomDistAddItem('I021',50) // 'I021': item "1500 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I05I',50) // 'I05I': item "Spirit Potion"
        call RandomDistAddItem('I05H',50) // 'I05H': item "Blood Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_SpiritOfLowtown takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('gold',34) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('I02X',33) // 'I02X': item "Greater Nectar"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I006',34) // 'I006': item "250 Gold Coins"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        call RandomDistAddItem('sror',33) // 'sror': item "Spirit of Lowtown"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('pghe',34) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('I001',33) // 'I001': item "Mega Potion"
        call RandomDistAddItem('gold',33) // 'gold': item "50 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I0DL','d') // 'I0DL': item "Turtleshell Choker"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_Scarletite takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I0CV','d') // 'I0CV': item "10000 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I021','d') // 'I021': item "1500 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I01Z','d') // 'I01Z': item "Crystal Shard"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I05I',50) // 'I05I': item "Spirit Potion"
        call RandomDistAddItem('I05H',50) // 'I05H': item "Blood Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rdis',50) // 'rdis': item "Bravega"
        call RandomDistAddItem('rsps',50) // 'rsps': item "Faithga"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I06P','d') // 'I06P': item "Scarletite"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Loot_Vault_Nethril takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer itemTypeId=0
    local boolean l_canDrop=true
    set l_dyingWidget=bj_lastDyingWidget
    if(l_dyingWidget==null)then
        set l_dyingUnit=GetTriggerUnit()
    endif
    if(l_dyingUnit!=null)then
        set l_canDrop=not IsUnitHidden(l_dyingUnit)
        if(l_canDrop and GetChangingUnit()!=null)then
            set l_canDrop=(GetChangingUnitPrevOwner()==Player(PLAYER_NEUTRAL_AGGRESSIVE))
        endif
    endif
    if(l_canDrop)then
        call RandomDistReset()
        call RandomDistAddItem('I00Y','d') // 'I00Y': item "1000 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I00X','d') // 'I00X': item "500 Gold Coins"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I05I',50) // 'I05I': item "Spirit Potion"
        call RandomDistAddItem('I05H',50) // 'I05H': item "Blood Ether"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('rdis',50) // 'rdis': item "Bravega"
        call RandomDistAddItem('rsps',50) // 'rsps': item "Faithga"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
        call RandomDistReset()
        call RandomDistAddItem('I07C','d') // 'I07C': item "Nethril"
        set itemTypeId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,itemTypeId)
        else
            call WidgetDropItem(l_dyingWidget,itemTypeId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Loot_MonsterDrop_HasItemOfType takes unit u,integer l_itemTypeID returns boolean
    local integer i=0
    local item l_slotItem
    loop
        set l_slotItem=UnitItemInSlot(u,i)
        if GetItemTypeId(l_slotItem)==l_itemTypeID then
            return true
        endif
        set i=i+1
        exitwhen i>=6
    endloop
    return false
endfunction

function Trig_Loot_MonsterDrop_Cond_MonographBonus takes nothing returns boolean
    if(((GetUnitUserData(GetTriggerUnit())>0)and(GetUnitUserData(GetTriggerUnit())<=9))and(GetKillingUnit()==Player_GetHero(GetOwningPlayer(GetKillingUnit()))))then
        // (GetPlayerId(GetOwningPlayer(GetKillingUnit()))) plus (1).
        if(((Trig_Loot_MonsterDrop_HasItemOfType(GetKillingUnit(),udg_MonographItem[GetUnitUserData(GetTriggerUnit())]))or(Trig_Loot_MonsterDrop_HasItemOfType(udg_SpiritOfGaya[GetPlayerId(GetOwningPlayer(GetKillingUnit()))+1],udg_MonographItem[GetUnitUserData(GetTriggerUnit())]))))then
            return true
        endif
    endif
    return false
endfunction

function Trig_Loot_MonsterDrop_PickDropItem takes nothing returns nothing
    local integer l_dropSlot=2
    local real l_elapsed=TimerGetElapsed(udg_GameClock)
    // Starting value for l_timeSeed:
    // The remainder after dividing (((elapsed time) times (1000)) with its decimal part removed) by (400).
    local integer l_timeSeed=ModuloInteger(R2I(l_elapsed*1000.),400)
    // Starting value for l_roll:
    // Result 1: (l_timeSeed) divided by (20); drop the remainder.
    // Result 2: a random whole number from 0 through 19.
    // Result 3: (result 1) plus (result 2).
    // Result 4: the remainder after dividing (result 3) by (20).
    // Result 5: (result 4) plus (1).
    local integer l_roll=ModuloInteger((l_timeSeed/ 20)+GetRandomInt(0,19),20)+1
    local boolean l_killerShardHunter=(GetUnitAbilityLevel(GetKillingUnit(),'A132')>0) // 'A132': ability "Shard Hunter"
    local boolean l_victimOversoul=(GetUnitAbilityLevel(GetTriggerUnit(),'A134')>0) // 'A134': ability "Oversoul"
    local integer l_victimTypeID=GetUnitTypeId(GetTriggerUnit())
    if(l_roll>udg_DropTempInt)then
        return
    endif
    set udg_MonographBonusDrop=false
    // The remainder after dividing ((udg_DropRollSeed) plus (7)) by (20).
    set udg_DropRollSeed=ModuloInteger(udg_DropRollSeed+7,20)
    // Combine the seeds, elapsed whole seconds, and a random value; wrap the result to a roll from 1 to 20.
    set l_roll=ModuloInteger(l_timeSeed+udg_DropRollSeed+R2I(l_elapsed)+GetRandomInt(0,19),20)+1
    if(Trig_Loot_MonsterDrop_Cond_MonographBonus())then
        if(l_roll<=9)then
            set l_dropSlot=2
            set udg_MonographBonusDrop=true
        elseif(l_roll<=16)then
            set l_dropSlot=3
        else
            set l_dropSlot=4
        endif
    else
        if(l_roll<=$D)then // $D = 13
            set l_dropSlot=2
        elseif(l_roll<=18)then
            set l_dropSlot=3
        else
            set l_dropSlot=4
        endif
    endif
    if(l_victimOversoul and l_dropSlot<4)then
        set l_dropSlot=l_dropSlot+1
    elseif(l_killerShardHunter and l_dropSlot==4)then
        set udg_LootItemID='I01Z' // 'I01Z': item "Crystal Shard"
        return
    endif
    set l_dropSlot=LoadInteger(udg_MonsterDataHash,l_victimTypeID,l_dropSlot)
    if(l_dropSlot>0)then
        set udg_LootItemID=Item_IdFromIndex(l_dropSlot)
    endif
endfunction

function Trig_Loot_CancelDespawn_ClearDespawnTimer takes nothing returns nothing
    local item l_pickedItem=GetManipulatedItem()
    local timer t=LoadTimerHandle(udg_DropItemHash,GetHandleId(l_pickedItem),1)
    call FlushChildHashtable(udg_DropItemHash,GetHandleId(t))
    call FlushChildHashtable(udg_DropItemHash,GetHandleId(l_pickedItem))
    call PauseTimer(t)
    call DestroyTimer(t)
    set t=null
    set l_pickedItem=null
endfunction

function Trig_Loot_MonsterDrop_Conditions takes nothing returns boolean
    return(GetKillingUnitBJ()!=null)and(GetUnitAbilityLevelSwapped('A0QY',GetTriggerUnit())<=0) // 'A0QY': ability "Devalued"
endfunction

function Trig_Loot_MonsterDrop_Cond_EternityMode takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Loot_MonsterDrop_Cond_KillerHasImmolation takes nothing returns boolean
    return(UnitHasBuffBJ(GetKillingUnitBJ(),'B04D')) // 'B04D': buff tooltip "Thievery"
endfunction

function Trig_Loot_MonsterDrop_Cond_KillerHasTreasureHunter takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A12V',GetKillingUnitBJ())>0) // 'A12V': ability "Treasure Hunter"
endfunction

function Trig_Loot_MonsterDrop_Cond_KillerMasteredJobsA takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_TitleForce[45]))
endfunction

function Trig_Loot_MonsterDrop_Cond_KillerMasteredJobsB takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_TitleForce[47]))
endfunction

function Trig_Loot_MonsterDrop_Cond_VictimNotPlentiful takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0MV',GetTriggerUnit())<=0) // 'A0MV': ability "Plentiful"
endfunction

function Trig_Loot_MonsterDrop_Cond_KillerHasGreed takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A131',GetKillingUnitBJ())>0)and(GetUnitAbilityLevelSwapped('A0MV',GetTriggerUnit())<=0) // 'A131': ability "Greed"; 'A0MV': ability "Plentiful"
endfunction

function Trig_Loot_MonsterDrop_Cond_BonusChargesItem takes nothing returns boolean
    return(udg_MonographBonusDrop)and(CheckItemStatus(GetLastCreatedItem(),bj_ITEM_STATUS_POWERUP)==false)
endfunction

function Trig_Loot_MonsterDrop_Cond_ItemIsSpiderLeg takes nothing returns boolean
    return(GetItemTypeId(GetLastCreatedItem())=='I06F') // 'I06F': item "Spider Leg"
endfunction

function Trig_Loot_MonsterDrop_Cond_ItemIsCharged takes nothing returns boolean
    return(GetItemType(GetLastCreatedItem())==ITEM_TYPE_CHARGED)
endfunction

function Trig_Loot_MonsterDrop_Cond_ItemNotTomeOfPower takes nothing returns boolean
    return(udg_LootItemID!='tkno') // 'tkno': object name not found in map data
endfunction

function Trig_Loot_MonsterDrop_Cond_MonsterRegistered takes nothing returns boolean
    return(LoadBooleanBJ(0,udg_DropTempInt,udg_MonsterDataHash))
endfunction

function Trig_Loot_MonsterDrop_Actions takes nothing returns nothing
    set udg_PlayerKillCount[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_PlayerKillCount[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
    call TriggerExecute(gg_trg_Multiboard_Refresh)
    set udg_DropTempInt=GetUnitTypeId(GetTriggerUnit())
    if(Trig_Loot_MonsterDrop_Cond_MonsterRegistered())then
        set udg_LootItemID='tkno' // 'tkno': object name not found in map data
        if(Trig_Loot_MonsterDrop_Cond_KillerHasGreed())then
            // Take the square root of the enemy level, drop decimals, then add a random 0, 1, or 2 to choose the loot-table entry.
            // A level-64 enemy therefore selects entry 8, 9, or 10.
            set udg_LootItemID=udg_LevelItemIdTable[(R2I(SquareRoot(I2R(GetUnitLevel(GetTriggerUnit()))))+GetRandomInt(0,2))]
        else
            if(Trig_Loot_MonsterDrop_Cond_VictimNotPlentiful())then
                set udg_DropTempInt=4
                if(Trig_Loot_MonsterDrop_Cond_EternityMode())then
                    // Increase udg_DropTempInt by 4.
                    set udg_DropTempInt=(udg_DropTempInt+4)
                endif
                if(Trig_Loot_MonsterDrop_Cond_KillerHasImmolation())then
                    // Increase udg_DropTempInt by 2.
                    set udg_DropTempInt=(udg_DropTempInt+2)
                endif
                if(Trig_Loot_MonsterDrop_Cond_KillerHasTreasureHunter())then
                    // Increase udg_DropTempInt by 4.
                    set udg_DropTempInt=(udg_DropTempInt+4)
                endif
                if(Trig_Loot_MonsterDrop_Cond_KillerMasteredJobsA())then
                    // Increase udg_DropTempInt by 2.
                    set udg_DropTempInt=(udg_DropTempInt+2)
                endif
                if(Trig_Loot_MonsterDrop_Cond_KillerMasteredJobsB())then
                    // Increase udg_DropTempInt by 2.
                    set udg_DropTempInt=(udg_DropTempInt+2)
                endif
            else
                set udg_DropTempInt=20
            endif
            call Trig_Loot_MonsterDrop_PickDropItem()
        endif
        if(Trig_Loot_MonsterDrop_Cond_ItemNotTomeOfPower())then
            set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
            call CreateItemLoc(udg_LootItemID,udg_TempPoint3)
            call RemoveLocation(udg_TempPoint3)
            if(Trig_Loot_MonsterDrop_Cond_ItemIsCharged())then
                set bj_lastStartedTimer=CreateTimer()
                call TimerStart(bj_lastStartedTimer,1200.,false,function Item_ExpireDrop)
                call SaveBooleanBJ(true,0,GetHandleIdBJ(GetLastCreatedItem()),udg_DropItemHash)
                call SaveBooleanBJ(true,0,GetHandleIdBJ(GetLastCreatedTimerBJ()),udg_DropItemHash)
                call SaveTimerHandleBJ(GetLastCreatedTimerBJ(),1,GetHandleIdBJ(GetLastCreatedItem()),udg_DropItemHash)
                call SaveItemHandleBJ(GetLastCreatedItem(),2,GetHandleIdBJ(GetLastCreatedTimerBJ()),udg_DropItemHash)
                if(Trig_Loot_MonsterDrop_Cond_ItemIsSpiderLeg())then
                    // A random whole number from 1 through 8.
                    call SetItemCharges(GetLastCreatedItem(),GetRandomInt(1,8))
                else
                    if(Trig_Loot_MonsterDrop_Cond_BonusChargesItem())then
                        // (item charges of the last created item) times (2).
                        call SetItemCharges(GetLastCreatedItem(),(GetItemCharges(GetLastCreatedItem())*2))
                    endif
                endif
            endif
        endif
    endif
endfunction

function Trig_Loot_CancelDespawn_Conditions takes nothing returns boolean
    return(LoadBooleanBJ(0,GetHandleIdBJ(GetManipulatedItem()),udg_DropItemHash))
endfunction

function Trig_Loot_CancelDespawn_Actions takes nothing returns nothing
    call Trig_Loot_CancelDespawn_ClearDespawnTimer()
endfunction

function Trig_Loot_Tables_Init_Actions takes nothing returns nothing
    set udg_ZoneEssenceItem[1]='I06G' // 'I06G': item "Forest Essence"
    set udg_ZoneEssenceItem[2]='I06K' // 'I06K': item "Barrens' Sand"
    set udg_ZoneEssenceItem[3]='I06N' // 'I06N': item "Tropical Essence"
    set udg_ZoneEssenceItem[4]='I074' // 'I074': item "Mine Mineral"
    set udg_ZoneEssenceItem[5]='I06R' // 'I06R': item "Wild Soul"
    set udg_ZoneEssenceItem[6]='I06T' // 'I06T': item "Theurgic Water"
    set udg_ZoneEssenceItem[7]='I068' // 'I068': item "Ancient Spirit"
    set udg_ZoneEssenceItem[8]='I06X' // 'I06X': item "Unique Ice Shard"
    set udg_ZoneEssenceItem[9]='I01Z' // 'I01Z': item "Crystal Shard"
    set udg_MonographItem[0]='I0EI' // 'I0EI': item "Knight's Monograph"
    set udg_MonographItem[1]='I0EF' // 'I0EF': item "Hunter's Monograph"
    set udg_MonographItem[2]='I0EG' // 'I0EG': item "Traveller's Monograph"
    set udg_MonographItem[3]='I0EJ' // 'I0EJ': item "Sentinel's Monograph"
    set udg_MonographItem[4]='I0EH' // 'I0EH': item "Warmage's Monograph"
    set udg_MonographItem[5]='I0EM' // 'I0EM': item "Berserker's Monograph"
    set udg_MonographItem[6]='I0EK' // 'I0EK': item "Scholar's Monograph"
    set udg_MonographItem[7]='I0EL' // 'I0EL': item "Sage's Monograph"
    set udg_MonographItem[8]='I0EO' // 'I0EO': item "Elder's Monograph"
    set udg_MonographItem[9]='I0EN' // 'I0EN': item "Dragoon's Monograph"
    set udg_ZonePowerupItem[1]='rhe1' // 'rhe1': item "Heal"
    set udg_ZonePowerupItem[2]='rman' // 'rman': item "Mana"
    set udg_ZonePowerupItem[3]='rhe2' // 'rhe2': item "Healara"
    set udg_ZonePowerupItem[4]='rspl' // 'rspl': item "Growth"
    set udg_ZonePowerupItem[5]='rspd' // 'rspd': item "Move Fast"
    set udg_ZonePowerupItem[6]='rdis' // 'rdis': item "Bravega"
    set udg_ZonePowerupItem[7]='rwat' // 'rwat': item "Watcher"
    set udg_ZonePowerupItem[8]='rsps' // 'rsps': item "Faithga"
    set udg_ZonePowerupItem[9]='rma2' // 'rma2': item "Greater Mana"
    set udg_ZonePowerupItem[$A]='rhe3' // $A = 10; 'rhe3': item "Healaga"
    set udg_ZonePowerupItem[$B]='rspl' // $B = 11; 'rspl': item "Growth"
    set udg_ZonePowerupItem[$C]='rres' // $C = 12; 'rres': item "Restoration"
    set udg_ZonePowerupItem[$D]='rres' // $D = 13; 'rres': item "Restoration"
    set udg_ZonePowerupItem[$E]='rma2' // $E = 14; 'rma2': item "Greater Mana"
    set udg_ZonePowerupItem[$F]='rdis' // $F = 15; 'rdis': item "Bravega"
    set udg_ZonePowerupItem[16]='rsps' // 'rsps': item "Faithga"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Loot_EssenceDrop_Conditions takes nothing returns boolean
    return(GetKillingUnitBJ()!=null)and(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))and(GetUnitUserData(GetTriggerUnit())>0)and(GetUnitUserData(GetTriggerUnit())<=9)
endfunction

function Trig_Loot_EssenceDrop_Cond_NoStreakSameZone takes nothing returns boolean
    return(udg_ZoneStreakID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==-7)
endfunction

function Trig_Loot_EssenceDrop_Cond_NoStreakNewZone takes nothing returns boolean
    return(udg_ZoneStreakID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==-7)
endfunction

function Trig_Loot_EssenceDrop_Cond_ZoneChanged takes nothing returns boolean
    return(udg_LastKillZoneID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]!=GetUnitUserData(GetTriggerUnit()))
endfunction

function Trig_Loot_EssenceDrop_HasMonograph takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetKillingUnitBJ(),udg_MonographItem[GetUnitUserData(GetTriggerUnit())]))or(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_MonographItem[GetUnitUserData(GetTriggerUnit())]))
endfunction

function Trig_Loot_EssenceDrop_Cond_DoubleEssenceCharges takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetUnitUserData(GetTriggerUnit())<=8)and(GetKillingUnitBJ()==Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())))and(Trig_Loot_EssenceDrop_HasMonograph())and(GetRandomInt(1,2)==1)
endfunction

function Trig_Loot_EssenceDrop_Cond_DropEssence takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetUnitUserData(GetTriggerUnit())!=9)and(GetRandomInt(1,2)==1)
endfunction

function Trig_Loot_EssenceDrop_Cond_EssenceIsCharged takes nothing returns boolean
    return(GetItemType(GetLastCreatedItem())==ITEM_TYPE_CHARGED)
endfunction

function Trig_Loot_EssenceDrop_Cond_EternityOrCoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(udg_EternityMode)or(GetRandomInt(1,2)==1)
endfunction

function Trig_Loot_EssenceDrop_Cond_EssenceDropChance takes nothing returns boolean
    // The essence roll compares 0-100 with 250 x (kill streak - 2 x streak ID) / (kill streak + 500 + 50 x streak ID).
    // This is only one requirement: the other checks on this line must also pass. The formula itself is not capped at 100.
    return(GetUnitAbilityLevelSwapped('A0QY',GetTriggerUnit())<=0)and(Trig_Loot_EssenceDrop_Cond_EternityOrCoinFlip())and(GetRandomReal(0,100.)<=((I2R((udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]-(udg_ZoneStreakID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]*2)))/ I2R(((udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+500)+(50*udg_ZoneStreakID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]))))*250.)) // 'A0QY': ability "Devalued"
endfunction

function Trig_Loot_EssenceDrop_Actions takes nothing returns nothing
    if(Trig_Loot_EssenceDrop_Cond_ZoneChanged())then
        if(Trig_Loot_EssenceDrop_Cond_NoStreakNewZone())then
            set udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
        else
            set udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=2
            set udg_ZoneStreakID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=-7
        endif
    else
        if(Trig_Loot_EssenceDrop_Cond_NoStreakSameZone())then
            set udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=2
            set udg_ZoneStreakID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=GetUnitUserData(GetTriggerUnit())
        else
            set udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_ZoneKillStreak[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
        endif
    endif
    set udg_LastKillZoneID[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=GetUnitUserData(GetTriggerUnit())
    if(Trig_Loot_EssenceDrop_Cond_EssenceDropChance())then
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        if(Trig_Loot_EssenceDrop_Cond_DropEssence())then
            call CreateItemLoc(udg_ZoneEssenceItem[GetUnitUserData(GetTriggerUnit())],udg_TempPoint3)
            if(Trig_Loot_EssenceDrop_Cond_DoubleEssenceCharges())then
                // (item charges of the last created item) times (2).
                call SetItemCharges(GetLastCreatedItem(),(GetItemCharges(GetLastCreatedItem())*2))
            endif
        else
            // (GetUnitUserData(the triggering unit)) plus (a random whole number from 0 through 7).
            call CreateItemLoc(udg_ZonePowerupItem[(GetUnitUserData(GetTriggerUnit())+GetRandomInt(0,7))],udg_TempPoint3)
        endif
        call RemoveLocation(udg_TempPoint3)
        if(Trig_Loot_EssenceDrop_Cond_EssenceIsCharged())then
            set bj_lastStartedTimer=CreateTimer()
            call TimerStart(bj_lastStartedTimer,1200.,false,function Item_ExpireDrop)
            call SaveBooleanBJ(true,0,GetHandleIdBJ(GetLastCreatedItem()),udg_DropItemHash)
            call SaveBooleanBJ(true,0,GetHandleIdBJ(GetLastCreatedTimerBJ()),udg_DropItemHash)
            call SaveTimerHandleBJ(GetLastCreatedTimerBJ(),1,GetHandleIdBJ(GetLastCreatedItem()),udg_DropItemHash)
            call SaveItemHandleBJ(GetLastCreatedItem(),2,GetHandleIdBJ(GetLastCreatedTimerBJ()),udg_DropItemHash)
        endif
    endif
endfunction

function Trig_Loot_BlockLeaverItems_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetItemUserData(GetManipulatedItem())!=0)and(GetItemUserData(GetManipulatedItem())!=GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))and(IsPlayerInForce(ConvertedPlayer(GetItemUserData(GetManipulatedItem())),udg_PlayingPlayers)==false)
endfunction

function Trig_Loot_BlockLeaverItems_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call DisplayTimedTextToForce(udg_TempForce,10.,"You may not pick up items that belong to players that have already left!")
    call DestroyForce(udg_TempForce)
    call RemoveItem(GetManipulatedItem())
endfunction

function Trig_Loot_Cuchulainn_EyeDrop_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='uabc') // 'uabc': unit "Tainted Cúchulainn"
endfunction

function Trig_Loot_Cuchulainn_EyeDrop_RollPotion takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Loot_Cuchulainn_EyeDrop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I00M',udg_TempPoint) // 'I00M': item "Poison Spear"
    if(Trig_Loot_Cuchulainn_EyeDrop_RollPotion())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    set udg_QuestItem[$B]=CreateItemLoc('gmfr',udg_TempPoint) // $B = 11; 'gmfr': item "Eye of Jenova"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call DisableTrigger(gg_trg_Ping_ArenaTarget)
    call DestroyTrigger(gg_trg_Ping_ArenaTarget)
    call EnableTrigger(gg_trg_Ping_EyeOfJenova)
    call EnableTrigger(gg_trg_Quest_EyeOfJenova_PickUp)
    set udg_BossDefeated[8]=true
    call SaveIntegerBJ(0,2,$8B,udg_GameStateHash) // $8B = 139
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Loot automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Loot_Part1 / RegisterTriggers_Loot_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Loot takes nothing returns nothing
endfunction

function Register_Loot_MonsterDrop takes nothing returns nothing
    set gg_trg_Loot_MonsterDrop=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Loot_MonsterDrop,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Loot_MonsterDrop,Condition(function Trig_Loot_MonsterDrop_Conditions))
    call TriggerAddAction(gg_trg_Loot_MonsterDrop,function Trig_Loot_MonsterDrop_Actions)
endfunction

function Register_Loot_CancelDespawn takes nothing returns nothing
    set gg_trg_Loot_CancelDespawn=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Loot_CancelDespawn,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Loot_CancelDespawn,Condition(function Trig_Loot_CancelDespawn_Conditions))
    call TriggerAddAction(gg_trg_Loot_CancelDespawn,function Trig_Loot_CancelDespawn_Actions)
endfunction

function Register_Loot_Tables_Init takes nothing returns nothing
    set gg_trg_Loot_Tables_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Loot_Tables_Init,2.)
    call TriggerAddAction(gg_trg_Loot_Tables_Init,function Trig_Loot_Tables_Init_Actions)
endfunction

function Register_Loot_EssenceDrop takes nothing returns nothing
    set gg_trg_Loot_EssenceDrop=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Loot_EssenceDrop,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Loot_EssenceDrop,Condition(function Trig_Loot_EssenceDrop_Conditions))
    call TriggerAddAction(gg_trg_Loot_EssenceDrop,function Trig_Loot_EssenceDrop_Actions)
endfunction

function Register_Loot_BlockLeaverItems takes nothing returns nothing
    set gg_trg_Loot_BlockLeaverItems=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Loot_BlockLeaverItems,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Loot_BlockLeaverItems,Condition(function Trig_Loot_BlockLeaverItems_Conditions))
    call TriggerAddAction(gg_trg_Loot_BlockLeaverItems,function Trig_Loot_BlockLeaverItems_Actions)
endfunction

function Register_Loot_Cuchulainn_EyeDrop takes nothing returns nothing
    set gg_trg_Loot_Cuchulainn_EyeDrop=CreateTrigger()
    call DisableTrigger(gg_trg_Loot_Cuchulainn_EyeDrop)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Loot_Cuchulainn_EyeDrop,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Loot_Cuchulainn_EyeDrop,Condition(function Trig_Loot_Cuchulainn_EyeDrop_Conditions))
    call TriggerAddAction(gg_trg_Loot_Cuchulainn_EyeDrop,function Trig_Loot_Cuchulainn_EyeDrop_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Loot_Part1 takes nothing returns nothing
    call Register_Loot_MonsterDrop()
    call Register_Loot_CancelDespawn()
    call Register_Loot_Tables_Init()
    call Register_Loot_EssenceDrop()
    call Register_Loot_BlockLeaverItems()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Loot_Part2 takes nothing returns nothing
    call Register_Loot_Cuchulainn_EyeDrop() // starts off; enabled by Quest_AoMadoushi
endfunction

endlibrary

library TDrop requires TLoot
function Trig_Drop_Barrel_HiPotionHiEther_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('pghe',50) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('pgma',50) // 'pgma': item "Hi-Ether"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_Potions_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('pghe',50) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem('phea',50) // 'phea': item "Potion"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Crate_Gold500b_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_Gold200_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_HighPotions2_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I05I',$F) // 'I05I': item "Spirit Potion"; $F = 15
        call RandomDistAddItem('I000',40) // 'I000': item "X-Potion"
        call RandomDistAddItem('I00Y',$F) // 'I00Y': item "1000 Gold Coins"; $F = 15
        call RandomDistAddItem('I001',30) // 'I001': item "Mega Potion"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_Ethers_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I002',40) // 'I002': item "Turbo Ether"
        call RandomDistAddItem('sman',30) // 'sman': item "Mega Ether"
        call RandomDistAddItem('I00Y',$F) // 'I00Y': item "1000 Gold Coins"; $F = 15
        call RandomDistAddItem('I05H',$F) // 'I05H': item "Blood Ether"; $F = 15
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_Elixir_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_HighPotions_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I05I',$F) // 'I05I': item "Spirit Potion"; $F = 15
        call RandomDistAddItem('I000',40) // 'I000': item "X-Potion"
        call RandomDistAddItem('I00Y',$F) // 'I00Y': item "1000 Gold Coins"; $F = 15
        call RandomDistAddItem('I001',30) // 'I001': item "Mega Potion"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Crate_Equipment_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I00E',25) // 'I00E': item "Sprint Shoes"
        call RandomDistAddItem('I00G',25) // 'I00G': item "Armguard"
        call RandomDistAddItem('I003',20) // 'I003': item "200 Gold Coins"
        call RandomDistAddItem('I005',30) // 'I005': item "150 Gold Coins"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Crate_CrystalShard_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I01Z','d') // 'I01Z': item "Crystal Shard"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Crate_Gold500_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_PotionOrNothing_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('pghe',25) // 'pghe': item "Hi-Potion"
        call RandomDistAddItem(-1,25)
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Crate_ShardOrGold_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I01Z',80) // 'I01Z': item "Crystal Shard"
        call RandomDistAddItem('I021',20) // 'I021': item "1500 Gold Coins"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_Gold50_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Igloo_Gold1500_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I021','d') // 'I021': item "1500 Gold Coins"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_CrystalShard_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        call RandomDistAddItem('I01Z',80) // 'I01Z': item "Crystal Shard"
        call RandomDistAddItem('I00M',20) // 'I00M': item "Poison Spear"
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_Potion_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Drop_Barrel_Ether_Actions takes nothing returns nothing
    local widget l_dyingWidget=null
    local unit l_dyingUnit=null
    local integer l_itemId=0
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
        set l_itemId=RandomDistChoose()
        if(l_dyingUnit!=null)then
            call Loot_CreateItem(l_dyingUnit,l_itemId)
        else
            call WidgetDropItem(l_dyingWidget,l_itemId)
        endif
    endif
    set bj_lastDyingWidget=null
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Drop takes nothing returns nothing
endfunction

endlibrary

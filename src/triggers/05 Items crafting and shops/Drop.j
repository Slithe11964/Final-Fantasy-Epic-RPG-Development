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

// Owned setup helpers; bootstrap controls their original execution order.
function Drop_CreateMapDestructables takes nothing returns nothing
    local destructable destructableHandle
    local trigger eventTrigger
    set gg_dest_ATg3_0012=CreateDestructable('ATg3',-2048.,-1088.,.0,.9,0) // 'ATg3': object name not found in map data
    set gg_dest_B001_0051=CreateDestructable('B001',26560.,-15552.,305.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0047=CreateDestructable('B001',1472.,-28416.,70.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0053=CreateDestructable('B001',13632.,-3776.,164.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0054=CreateDestructable('B001',6656.,-14976.,314.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0050=CreateDestructable('B001',15744.,-8896.,272.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0056=CreateDestructable('B001',23360.,-4096.,201.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0048=CreateDestructable('B001',10944.,-12864.,242.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0055=CreateDestructable('B001',-960.,-20544.,213.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0049=CreateDestructable('B001',14976.,-21888.,86.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B001_0057=CreateDestructable('B001',16192.,-5888.,129.,.8,0) // 'B001': destructable "Secret Barrel"
    set gg_dest_B002_0040=CreateDestructable('B002',25600.,2496.,270.,.991,8) // 'B002': buff tooltip "Burn"
    set gg_dest_B002_0026=CreateDestructable('B002',24832.,-5696.,270.,.968,2) // 'B002': buff tooltip "Burn"
    set gg_dest_BTrx_0011=CreateDestructable('BTrx',18240.,-5952.,270.,1.,0) // 'BTrx': object name not found in map data
    set gg_dest_DTg6_0052=CreateDestructable('DTg6',17568.,-19552.,270.,1.,0) // 'DTg6': object name not found in map data
    set gg_dest_DTg7_0013=CreateDestructable('DTg7',17984.,1472.,.0,.9,0) // 'DTg7': object name not found in map data
    set gg_dest_DTg8_0028=CreateDestructable('DTg8',26912.,-23200.,180.,1.,0) // 'DTg8': object name not found in map data
    set gg_dest_DTsb_0068=CreateDestructableZ('DTsb',.0,-9632.,-190.2,90.,1.,0) // 'DTsb': object name not found in map data
    set gg_dest_Dofw_0016=CreateDestructable('Dofw',-1984.,-1088.,.0,1.,0) // 'Dofw': object name not found in map data
    set destructableHandle=CreateDestructable('ITig',24448.,3008.,281.89,1.,0) // 'ITig': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Igloo_Gold1500_Actions)
    set gg_dest_ITig_0030=CreateDestructable('ITig',26304.,-2432.,67.,1.,0) // 'ITig': object name not found in map data
    set gg_dest_ITtw_0059=CreateDestructable('ITtw',24768.,-5952.,270.,.993,0) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0036=CreateDestructable('ITtw',25408.,2560.,270.,.865,5) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0039=CreateDestructable('ITtw',24960.,-5760.,270.,.913,3) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0035=CreateDestructable('ITtw',25472.,2816.,270.,.947,7) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0034=CreateDestructable('ITtw',25408.,2688.,270.,.947,3) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0041=CreateDestructable('ITtw',24768.,-5824.,270.,.804,6) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0037=CreateDestructable('ITtw',25664.,2624.,270.,.92,1) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0018=CreateDestructable('ITtw',24896.,-5888.,270.,.936,0) // 'ITtw': object name not found in map data
    set gg_dest_ITtw_0043=CreateDestructable('ITtw',25536.,2368.,270.,.809,6) // 'ITtw': object name not found in map data
    set gg_dest_ITx1_0022=CreateDestructable('ITx1',27008.,896.,270.,.9,0) // 'ITx1': object name not found in map data
    set gg_dest_ITx3_0033=CreateDestructable('ITx3',25472.,1920.,.0,.9,0) // 'ITx3': object name not found in map data
    set gg_dest_LOcg_0070=CreateDestructable('LOcg',26240.,3008.,270.,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0031=CreateDestructable('LOcg',26624.,3008.,270.,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0024=CreateDestructable('LOcg',-64.,-14912.,33.05,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0069=CreateDestructable('LOcg',27392.,2304.,180.,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0029=CreateDestructable('LOcg',27392.,2048.,180.,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0071=CreateDestructable('LOcg',26368.,3008.,270.,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0032=CreateDestructable('LOcg',27392.,2176.,180.,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0010=CreateDestructable('LOcg',12672.,-11136.,323.,1.2,0) // 'LOcg': object name not found in map data
    set gg_dest_LOcg_0042=CreateDestructable('LOcg',26496.,3008.,270.,1.031,0) // 'LOcg': object name not found in map data
    set gg_dest_LTba_0045=CreateDestructable('LTba',.0,-15616.,245.,1.2,1) // 'LTba': object name not found in map data
    set gg_dest_LTba_0044=CreateDestructable('LTba',-128.,-15552.,245.,1.2,1) // 'LTba': object name not found in map data
    set destructableHandle=CreateDestructable('LTbr',12896.,-1824.,.0,1.386,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set destructableHandle=CreateDestructable('LTbr',11488.,-8736.,135.,1.368,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropSmallGold)
    set destructableHandle=CreateDestructable('LTbr',27552.,2016.,280.,1.155,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_HighPotions_Actions)
    set destructableHandle=CreateDestructable('LTbr',7072.,-6112.,122.,1.32,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set destructableHandle=CreateDestructable('LTbr',12064.,-14624.,153.,1.233,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set destructableHandle=CreateDestructable('LTbr',672.,-8928.,276.,1.347,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set destructableHandle=CreateDestructable('LTbr',26464.,-2592.,280.,1.155,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_HighPotions2_Actions)
    set destructableHandle=CreateDestructable('LTbr',6176.,-7584.,200.,1.35,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropEthers)
    set destructableHandle=CreateDestructable('LTbr',6176.,-7520.,119.,1.396,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_Gold50_Actions)
    set destructableHandle=CreateDestructable('LTbr',6240.,-7520.,315.,1.336,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropSmallGold)
    set destructableHandle=CreateDestructable('LTbr',6240.,-7584.,187.,1.302,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropPotionOrEther)
    set gg_dest_LTbr_0009=CreateDestructable('LTbr',18016.,-7200.,199.,1.146,0) // 'LTbr': object name not found in map data
    set destructableHandle=CreateDestructable('LTbr',13152.,-11040.,39.,1.439,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_Potions_Actions)
    set destructableHandle=CreateDestructable('LTbr',17888.,-12832.,135.,1.368,0) // 'LTbr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropSmallGold)
    set destructableHandle=CreateDestructable('LTbs',15968.,-6944.,316.,1.184,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_Ether_Actions)
    set destructableHandle=CreateDestructable('LTbs',10976.,-1312.,246.,1.245,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set destructableHandle=CreateDestructable('LTbs',17952.,-12832.,174.,1.13,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_HiPotionHiEther_Actions)
    set gg_dest_LTbs_0006=CreateDestructable('LTbs',17696.,-5536.,181.,1.36,0) // 'LTbs': object name not found in map data
    set destructableHandle=CreateDestructable('LTbs',20384.,-21728.,45.,1.348,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_Gold200_Actions)
    set destructableHandle=CreateDestructable('LTbs',11552.,-8672.,174.,1.13,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_HiPotionHiEther_Actions)
    set gg_dest_LTbs_0023=CreateDestructable('LTbs',16352.,-14752.,188.,1.124,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,gg_dest_LTbs_0023)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_PotionOrNothing_Actions)
    set gg_dest_LTbs_0046=CreateDestructable('LTbs',16736.,-7520.,316.,1.184,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,gg_dest_LTbs_0046)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_Potion_Actions)
    set gg_dest_LTbs_0060=CreateDestructable('LTbs',17632.,-1824.,73.,1.246,0) // 'LTbs': object name not found in map data
    set gg_dest_LTbs_0063=CreateDestructable('LTbs',17760.,-5472.,35.,1.224,0) // 'LTbs': object name not found in map data
    set destructableHandle=CreateDestructable('LTbs',12192.,-10912.,240.,1.35,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropEthers)
    set destructableHandle=CreateDestructable('LTbs',6240.,-7456.,270.,1.22,0) // 'LTbs': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropSmallGold)
    set destructableHandle=CreateDestructable('LTbx',11040.,-1248.,171.,1.261,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropSmallGold)
    set gg_dest_LTbx_0008=CreateDestructable('LTbx',18592.,-7968.,198.,1.417,0) // 'LTbx': object name not found in map data
    set gg_dest_LTbx_0004=CreateDestructable('LTbx',17504.,-1888.,207.,1.371,0) // 'LTbx': object name not found in map data
    set gg_dest_LTbx_0015=CreateDestructable('LTbx',18080.,-7200.,116.,1.33,0) // 'LTbx': object name not found in map data
    set destructableHandle=CreateDestructable('LTbx',17888.,-12960.,125.,1.276,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropEthers)
    set destructableHandle=CreateDestructable('LTbx',26400.,-2528.,289.,1.272,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_Ethers_Actions)
    set destructableHandle=CreateDestructable('LTbx',6176.,-7648.,142.,1.167,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropMediumGold)
    set destructableHandle=CreateDestructable('LTbx',1824.,-7136.,61.,1.225,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropEthers)
    set gg_dest_LTbx_0038=CreateDestructable('LTbx',25248.,2976.,25.,1.245,0) // 'LTbx': object name not found in map data
    set destructableHandle=CreateDestructable('LTbx',11296.,-18272.,9.,1.209,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_Elixir_Actions)
    set gg_dest_LTbx_0017=CreateDestructable('LTbx',18592.,-8032.,148.,1.311,0) // 'LTbx': object name not found in map data
    set destructableHandle=CreateDestructable('LTbx',11680.,-8864.,125.,1.276,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropEthers)
    set destructableHandle=CreateDestructable('LTbx',24224.,2976.,240.,1.184,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropSmallGold)
    set destructableHandle=CreateDestructable('LTbx',25504.,-6240.,31.,1.217,0) // 'LTbx': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Barrel_CrystalShard_Actions)
    set destructableHandle=CreateDestructable('LTcr',13440.,384.,150.,1.074,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Crate_Equipment_Actions)
    set destructableHandle=CreateDestructable('LTcr',11392.,-18368.,97.,1.166,0) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Crate_CrystalShard_Actions)
    set destructableHandle=CreateDestructable('LTcr',11392.,-18240.,345.,.811,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Crate_Gold500_Actions)
    set gg_dest_LTcr_0003=CreateDestructable('LTcr',20288.,-7552.,165.,.813,1) // 'LTcr': object name not found in map data
    set gg_dest_LTcr_0019=CreateDestructable('LTcr',20608.,-320.,240.,1.148,0) // 'LTcr': object name not found in map data
    set destructableHandle=CreateDestructable('LTcr',10944.,-1152.,89.,.906,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set destructableHandle=CreateDestructable('LTcr',3712.,-7744.,269.,1.155,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropMediumGold)
    set destructableHandle=CreateDestructable('LTcr',4160.,-7616.,269.,1.096,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Crate_Gold500b_Actions)
    set destructableHandle=CreateDestructable('LTcr',2880.,-3648.,131.,.89,0) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropMediumGold)
    set gg_dest_LTcr_0027=CreateDestructable('LTcr',23744.,-8512.,151.,1.115,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,gg_dest_LTcr_0027)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Trig_Drop_Crate_ShardOrGold_Actions)
    set destructableHandle=CreateDestructable('LTcr',5632.,-20864.,227.,1.128,0) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set destructableHandle=CreateDestructable('LTcr',17792.,-12864.,251.,1.102,0) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropEthers)
    set destructableHandle=CreateDestructable('LTcr',17792.,-12928.,170.,1.179,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropPotionOrEther)
    set destructableHandle=CreateDestructable('LTcr',8128.,-1536.,147.,.918,0) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropSmallGold)
    set gg_dest_LTcr_0067=CreateDestructable('LTcr',18176.,-2752.,103.,.973,0) // 'LTcr': object name not found in map data
    set gg_dest_LTcr_0066=CreateDestructable('LTcr',18176.,-2624.,97.,.88,1) // 'LTcr': object name not found in map data
    set gg_dest_LTcr_0058=CreateDestructable('LTcr',22016.,-26560.,153.,1.133,0) // 'LTcr': object name not found in map data
    set gg_dest_LTcr_0002=CreateDestructable('LTcr',20288.,-7488.,83.,.839,0) // 'LTcr': object name not found in map data
    set destructableHandle=CreateDestructable('LTcr',11584.,-8768.,251.,1.102,0) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropEthers)
    set gg_dest_LTcr_0061=CreateDestructable('LTcr',18880.,-4416.,126.,1.088,0) // 'LTcr': object name not found in map data
    set gg_dest_LTcr_0062=CreateDestructable('LTcr',18816.,-4288.,84.,.821,1) // 'LTcr': object name not found in map data
    set destructableHandle=CreateDestructable('LTcr',11584.,-8832.,170.,1.179,1) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropPotionOrEther)
    set gg_dest_LTcr_0064=CreateDestructable('LTcr',20800.,-9472.,175.,1.06,1) // 'LTcr': object name not found in map data
    set gg_dest_LTcr_0065=CreateDestructable('LTcr',20928.,-9344.,74.,.969,1) // 'LTcr': object name not found in map data
    set destructableHandle=CreateDestructable('LTcr',7616.,-10240.,279.,.963,0) // 'LTcr': object name not found in map data
    set eventTrigger=CreateTrigger()
    call TriggerRegisterDeathEvent(eventTrigger,destructableHandle)
    call TriggerAddAction(eventTrigger,function SaveDyingWidget)
    call TriggerAddAction(eventTrigger,function Loot_DropElixirOrGold)
    set gg_dest_LTe2_0020=CreateDestructable('LTe2',15968.,-3744.,270.,1.,0) // 'LTe2': object name not found in map data
    set gg_dest_LTg2_0021=CreateDestructable('LTg2',23712.,-9248.,270.,1.,0) // 'LTg2': object name not found in map data
    set gg_dest_LTg4_0005=CreateDestructable('LTg4',16608.,-6944.,180.,1.,0) // 'LTg4': object name not found in map data
    set gg_dest_LTlt_0007=CreateDestructable('LTlt',16192.,-5120.,270.,1.12,8) // 'LTlt': object name not found in map data
    set gg_dest_LTt1_0014=CreateDestructable('LTt1',19712.,-10560.,90.,1.,0) // 'LTt1': object name not found in map data
    set gg_dest_ZTsg_0025=CreateDestructable('ZTsg',1024.,-25984.,180.,1.,0) // 'ZTsg': object name not found in map data
endfunction

function InitTrig_Drop takes nothing returns nothing
endfunction

endlibrary

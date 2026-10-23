function MaidenEye_Update takes unit holder returns nothing
    if holder==null then
        return
    endif
    if Carry_Has(holder,'I0HS') then
        if GetUnitAbilityLevel(holder,'aMEy')==0 then
            call UnitAddAbility(holder,'aMEy')
            call UnitMakeAbilityPermanent(holder,true,'aMEy')
        endif
    elseif GetUnitAbilityLevel(holder,'aMEy')>0 then
        call UnitRemoveAbility(holder,'aMEy')
    endif
endfunction

function MaidenEye_Changed takes nothing returns nothing
    local integer pid=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if pid>=0 and pid<8 and GetItemTypeId(GetManipulatedItem())=='I0HS' then
        set MaidenEyeDirty[pid]=true
    endif
endfunction

function MaidenEye_Tick takes nothing returns nothing
    local integer pid=0
    local unit hero
    local unit gaya
    set MaidenEyeSweep=MaidenEyeSweep+1
    if MaidenEyeSweep>=20 then
        set MaidenEyeSweep=0
    endif
    loop
        exitwhen pid>=8
        if IsPlayerInForce(Player(pid),udg_PlayingPlayers) then
            set hero=Player_GetHero(Player(pid))
            set gaya=udg_SpiritOfGaya[pid+1]
            if hero!=MaidenEyeHero[pid] then
                if MaidenEyeHero[pid]!=null then
                    call UnitRemoveAbility(MaidenEyeHero[pid],'aMEy')
                endif
                set MaidenEyeHero[pid]=hero
                set MaidenEyeDirty[pid]=true
            endif
            if gaya!=MaidenEyeGaya[pid] then
                if MaidenEyeGaya[pid]!=null then
                    call UnitRemoveAbility(MaidenEyeGaya[pid],'aMEy')
                endif
                set MaidenEyeGaya[pid]=gaya
                set MaidenEyeDirty[pid]=true
            endif
            if MaidenEyeDirty[pid] or MaidenEyeSweep==0 then
                set MaidenEyeDirty[pid]=false
                call MaidenEye_Update(hero)
                call MaidenEye_Update(gaya)
            endif
        endif
        set pid=pid+1
    endloop
    set hero=null
    set gaya=null
endfunction

function MaidenEye_Init takes nothing returns nothing
    if MaidenEyeTimer!=null then
        return
    endif
    set MaidenEyeEvents=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(MaidenEyeEvents,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(MaidenEyeEvents,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddAction(MaidenEyeEvents,function MaidenEye_Changed)
    set MaidenEyeTimer=CreateTimer()
    call TimerStart(MaidenEyeTimer,.25,true,function MaidenEye_Tick)
endfunction

library TGayaShared
function Gaya_RecreateSpirit takes player p returns nothing
    local unit l_oldSpirit=udg_SpiritOfGaya[GetPlayerId(p)+1]
    local unit l_newSpirit
    local integer i=0
    local item l_carried
    if(l_oldSpirit==null)then
        return
    endif
    call ShowUnit(l_oldSpirit,false)
    set l_newSpirit=CreateUnit(p,'H01D',GetUnitX(l_oldSpirit),GetUnitY(l_oldSpirit),GetUnitFacing(l_oldSpirit)) // 'H01D': unit "Spirit of Gaya"
    call SetUnitState(l_newSpirit,UNIT_STATE_MANA,GetUnitState(l_oldSpirit,UNIT_STATE_MANA))
    call SetHeroXP(l_newSpirit,GetHeroXP(l_oldSpirit),false)
    loop
        set l_carried=UnitItemInSlot(l_oldSpirit,i)
        if(l_carried!=null)then
            call UnitAddItem(l_newSpirit,l_carried)
        endif
        set i=i+1
        exitwhen i>=bj_MAX_INVENTORY
    endloop
    set i=1
    loop
        exitwhen i>=$C // $C = 12
        call SetUnitAbilityLevel(l_newSpirit,udg_ChronicleAbility[i],GetUnitAbilityLevel(l_oldSpirit,udg_ChronicleAbility[i]))
        set i=i+1
    endloop
    call SetUnitAbilityLevel(l_newSpirit,'S009',GetUnitAbilityLevel(l_oldSpirit,'S009')) // 'S009': ability "Spirit Blessing"
    call SetUnitAbilityLevel(l_newSpirit,'A10U',GetUnitAbilityLevel(l_oldSpirit,'A10U')) // 'A10U': ability "MP Regeneration"
    call SetUnitAbilityLevel(l_newSpirit,'A0B4',GetUnitAbilityLevel(l_oldSpirit,'A0B4')) // 'A0B4': ability "Break Stun"
    call SetUnitAbilityLevel(l_newSpirit,'A02K',GetUnitAbilityLevel(l_oldSpirit,'A02K')) // 'A02K': ability "Mana Transfer"
    call SetUnitAbilityLevel(l_newSpirit,'A02L',GetUnitAbilityLevel(l_oldSpirit,'A02L')) // 'A02L': ability "Mega Heal"
    if(GetUnitAbilityLevel(l_oldSpirit,'A058')==1)then // 'A058': ability "Tarugaya"
        call UnitAddAbility(l_newSpirit,'A058') // 'A058': ability "Tarugaya"
        call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
        call SetUnitAbilityLevel(l_newSpirit,'A10F',GetUnitAbilityLevel(l_newSpirit,'A10F')+1) // 'A10F': ability "Spiritual Power"
    endif
    if(GetUnitAbilityLevel(l_oldSpirit,'S004')==1)then // 'S004': ability "Sukugaya"
        call UnitAddAbility(l_newSpirit,'S004') // 'S004': ability "Sukugaya"
        call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
        call SetUnitAbilityLevel(l_newSpirit,'A10F',GetUnitAbilityLevel(l_newSpirit,'A10F')+2) // 'A10F': ability "Spiritual Power"
    endif
    if(GetUnitAbilityLevel(l_oldSpirit,'A07E')==1)then // 'A07E': ability "Rakugaya"
        call UnitAddAbility(l_newSpirit,'A07E') // 'A07E': ability "Rakugaya"
        call SetPlayerAbilityAvailable(p,'A10F',true) // 'A10F': ability "Spiritual Power"
        call SetUnitAbilityLevel(l_newSpirit,'A10F',GetUnitAbilityLevel(l_newSpirit,'A10F')+4) // 'A10F': ability "Spiritual Power"
    endif
    call RemoveUnit(l_oldSpirit)
    set udg_SpiritOfGaya[GetPlayerId(p)+1]=l_newSpirit
    set l_oldSpirit=null
    set l_newSpirit=null
    set l_carried=null
endfunction

function InitTrig_Gaya_Shared takes nothing returns nothing
endfunction

endlibrary

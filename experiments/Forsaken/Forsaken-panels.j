function Forsaken_UpdatePanels takes unit hero returns nothing
    local player owner=GetOwningPlayer(hero)
    local integer playerIndex=GetPlayerId(owner)
    local integer job=Job_GetIndex(hero)
    local integer tree=LoadInteger(ForsakenGearTypes,2,playerIndex)
    local integer slot=0
    local integer skill
    local integer preview
    local integer rank
    local integer tooltipLevel
    local string title
    if tree==0 or job<0 then
        set owner=null
        return
    endif
    call UnitAddAbility(hero,tree)
    call UnitMakeAbilityPermanent(hero,true,tree)
    loop
        exitwhen slot>=6
        set skill=0
        if slot==5 then
            set skill='A02F'
        elseif job<udg_JobCount then
            set skill=udg_JobSkill[job*5+slot+1]
        elseif slot==0 then
            set skill=udg_JobSkill[udg_AbilitySlot1[playerIndex+1]]
        elseif slot==1 then
            set skill=udg_JobSkill[udg_AbilitySlot2[playerIndex+1]]
        elseif slot==2 then
            set skill=udg_JobSkill[udg_AbilitySlot3[playerIndex+1]]
        elseif slot==3 then
            set skill=udg_JobSkill[udg_AbilitySlot4[playerIndex+1]]
        endif
        set preview=LoadInteger(ForsakenGearTypes,3,playerIndex*6+slot)
        set rank=GetUnitAbilityLevel(hero,skill)
        if rank>0 then
            call UnitAddAbility(hero,preview)
            call UnitMakeAbilityPermanent(hero,true,preview)
        else
            call UnitRemoveAbility(hero,preview)
        endif
        if GetLocalPlayer()==owner then
            if skill!=0 then
                set tooltipLevel=IMaxBJ(0,rank-1)
                set title=BlzGetAbilityTooltip(skill,tooltipLevel)
                call BlzSetAbilityIcon(preview,BlzGetAbilityIcon(skill))
                call BlzSetAbilityTooltip(preview,title+" |cffffcc00[Rank "+I2S(rank)+"]|r",0)
                call BlzSetAbilityExtendedTooltip(preview,BlzGetAbilityExtendedTooltip(skill,tooltipLevel)+"|n|n|cffffcc00Preview only.|r Learn and upgrade this skill through the existing job system. Future talent paths can be added here.",0)
            else
                call BlzSetAbilityIcon(preview,"ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp")
                call BlzSetAbilityTooltip(preview,"Future upgrade path",0)
                call BlzSetAbilityExtendedTooltip(preview,"A space for a future job talent. This preview grants no bonuses.",0)
            endif
        endif
        set slot=slot+1
    endloop
    if GetLocalPlayer()==owner then
        call BlzSetAbilityTooltip(tree,GetUnitName(hero)+" Talents",0)
    endif
    set owner=null
endfunction

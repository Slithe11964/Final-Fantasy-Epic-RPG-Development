library THeroPart01
// Hero

function Hero_LearnSkillTo takes unit l_hero,integer l_skillId,integer l_targetLevel returns nothing
    local integer l_curLevel=GetUnitAbilityLevel(l_hero,l_skillId)
    local integer l_missing
    // (l_targetLevel) minus (l_curLevel).
    set l_missing=l_targetLevel-l_curLevel
    loop
        exitwhen l_missing<=0
        call SelectHeroSkill(l_hero,l_skillId)
        set l_missing=l_missing-1
    endloop
endfunction

function InitTrig_Hero_Part01 takes nothing returns nothing
endfunction

endlibrary

library TFilter
globals
    // Variables only this module uses.
    real udg_EnumDestX=.0
    real udg_EnumDestY=.0
endglobals

function Filter_DestInRange takes nothing returns boolean
    local real dx=GetDestructableX(GetFilterDestructable())-udg_EnumDestX
    local real dy=GetDestructableY(GetFilterDestructable())-udg_EnumDestY
    // (the square of (dx)) plus (the square of (dy)).
    return(dx*dx+dy*dy<=bj_enumDestructableRadius)
endfunction

function Filter_True takes nothing returns boolean
    return true
endfunction

function Filter_OwnedByPlayers takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Filter_MissileTarget takes nothing returns boolean
    local unit u=GetFilterUnit()
    return(not BlzIsUnitInvulnerable(u)and not IsUnitHidden(u)and not IsUnitType(u,UNIT_TYPE_FLYING)and not IsUnitType(u,UNIT_TYPE_MAGIC_IMMUNE)and not IsUnitType(u,UNIT_TYPE_STRUCTURE)and GetWidgetLife(u)>.405 and GetUnitTypeId(u)!='h020')!=null // 'h020': unit "Dummy Missile"
endfunction

function Filter_KillDestructable takes nothing returns boolean
    local destructable d=GetFilterDestructable()
    if GetWidgetLife(d)>.405 and not IsDestructableInvulnerable(d)then
        call KillDestructable(d)
    endif
    set d=null
    return false
endfunction

function Filter_AliveNotInvul takes nothing returns boolean
    return GetUnitAbilityLevel(GetFilterUnit(),'Avul')<=0 and GetWidgetLife(GetFilterUnit())>.405 // 'Avul': standard ability reference "Invulnerable"
endfunction

function Filter_AliveNonStructure takes nothing returns boolean
    return(GetUnitAbilityLevel(GetFilterUnit(),'Avul')<=0 and not IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)and GetWidgetLife(GetFilterUnit())>.405)!=null // 'Avul': standard ability reference "Invulnerable"
endfunction

function Filter_ValidUnit takes nothing returns boolean
    return(GetUnitAbilityLevel(GetFilterUnit(),'Avul')<=0 and not IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)and GetWidgetLife(GetFilterUnit())>.405)!=null // 'Avul': standard ability reference "Invulnerable"
endfunction

function Filter_EnemyOfOwner takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),udg_FilterOwner)and GetUnitAbilityLevel(GetFilterUnit(),'Avul')<=0 and not IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)and GetWidgetLife(GetFilterUnit())>.405 and GetUnitTypeId(GetFilterUnit())!='uplg')!=null // 'Avul': standard ability reference "Invulnerable"; 'uplg': object name not found in map data
endfunction

function Filter_EnemyOfHostile takes nothing returns boolean
    return(GetUnitAbilityLevel(GetFilterUnit(),'Avul')<=0 and not IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)and GetWidgetLife(GetFilterUnit())>.405 and IsUnitEnemy(GetFilterUnit(),Player($B)))!=null // 'Avul': standard ability reference "Invulnerable"; $B = 11
endfunction

function InitTrig_Filter takes nothing returns nothing
endfunction

endlibrary

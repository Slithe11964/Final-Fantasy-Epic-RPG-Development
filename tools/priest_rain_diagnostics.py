"""Opt-in live evidence for Acid Rain; counters never affect gameplay."""
from performance_runtime import put
from jtok import functions

def refresh(source):
    fs=functions(source)
    if 'Priest_RainTick' not in fs:return source
    if 'boolean array PriestRainDebug' not in source:source=source.replace('endglobals','    boolean array PriestRainDebug\nendglobals',1)
    helpers='''function Priest_RainDebugChat takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local integer pid=GetPlayerId(owner)
    set PriestRainDebug[pid]=not PriestRainDebug[pid]
    if PriestRainDebug[pid] then
        call DisplayTimedTextToPlayer(owner,0,0,15,"Rain diagnostic ON. Cast Tranquility near an enemy.")
    else
        call DisplayTimedTextToPlayer(owner,0,0,15,"Rain diagnostic OFF.")
    endif
    set owner=null
endfunction

function Priest_RainDebugInit takes nothing returns nothing
    local trigger listener=CreateTrigger()
    local integer pid=0
    loop
        exitwhen pid>=8
        call TriggerRegisterPlayerChatEvent(listener,Player(pid),"-raindebug",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(listener,function Priest_RainDebugChat)
    set listener=null
endfunction'''
    if 'Priest_RainDebugChat' not in fs:source=source.replace('function Priest_RainTick takes',helpers+'\n\nfunction Priest_RainTick takes',1)
    body=functions(source)['Priest_RainTick']
    if 'local integer rainEnemies' not in body:
        body=body.replace('    local boolean damagePulse','    local integer rainEnemies=0\n    local integer rainImmune=0\n    local integer rainHits=0\n    local real rainLost=0.\n    local real rainBefore=0.\n    local boolean rainHit=false\n    local string rainTalent="off"\n    local boolean damagePulse',1)
        body=body.replace('        set caster=PriestRainCaster[pid]','        set damagePulse=false\n        set rainEnemies=0\n        set rainImmune=0\n        set rainHits=0\n        set rainLost=0.\n        set rainTalent="off"\n        set caster=PriestRainCaster[pid]',1)
        line='                        if healPulse and IsUnitAlly'
        count='''                        if damagePulse and IsUnitEnemy(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 then
                            set rainEnemies=rainEnemies+1
                            if IsUnitType(target,UNIT_TYPE_MAGIC_IMMUNE) then
                                set rainImmune=rainImmune+1
                            endif
                        endif
'''
        body=body.replace(line,count+line,1)
        line='                            call UnitDamageTarget(caster,target,PriestRainHealing[rank]*5.,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)'
        replacement='''                            set rainBefore=GetWidgetLife(target)
                            set rainHit=UnitDamageTarget(caster,target,PriestRainHealing[rank]*5.,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                            if rainHit then
                                set rainHits=rainHits+1
                            endif
                            set rainLost=rainLost+RMaxBJ(0.,rainBefore-GetWidgetLife(target))'''
        if line not in body:raise ValueError('Rain damage call changed')
        body=body.replace(line,replacement,1)
        line='        set pid=pid+1'
        report='''        if caster!=null and PriestRainCaster[pid]!=null and damagePulse and PriestRainDebug[pid] then
            if Talent_Active(caster,12,2,1,'A0OM') then
                set rainTalent="on"
            endif
            call DisplayTimedTextToPlayer(GetOwningPlayer(caster),0,0,8,"Rain: talent="+rainTalent+" rank="+I2S(rank)+" radius="+R2SW(PriestRainRadius[rank],1,0)+" enemies="+I2S(rainEnemies)+" immune="+I2S(rainImmune)+" hits="+I2S(rainHits)+" HP lost="+R2SW(rainLost,1,0))
        endif
'''
        body=body.replace(line,report+line,1)
    source=put(source,'Priest_RainTick',body)
    body=functions(source)['Priest_MasterInit']
    if 'call Priest_RainDebugInit()' not in body:body=body.replace('    call Priest_MasterData()','    call Priest_MasterData()\n    call Priest_RainDebugInit()',1)
    return put(source,'Priest_MasterInit',body)

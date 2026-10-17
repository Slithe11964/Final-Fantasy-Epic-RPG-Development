"""Shared requested stat-page ordering and explicit percentage presentation."""
from jtok import functions
from performance_runtime import put


def refresh(source,*,native=False):
    fs=functions(source)
    name='Forsaken_RenderStatsUncached' if 'Forsaken_RenderStatsUncached' in fs else 'Stats_Fill' if 'Stats_Fill' in fs else None
    if name is None:return source
    p='Forsaken' if native else 'Stats'
    row='Forsaken_StatRow' if native else 'Stats_Row'
    get='Forsaken_StatAbilityLevel' if native else 'GetUnitAbilityLevel'
    page='ForsakenStatsPage' if native else 'page'
    names='ForsakenStatName' if native else 'StatsElementName'
    from proficiency import stat_helper
    prof=stat_helper(p,row)
    prof_name=p+'_RenderProficiencies'
    if prof_name in functions(source):source=put(source,prof_name,prof)
    else:source=source.replace('function '+name+' takes',prof+'\n\nfunction '+name+' takes',1)
    helpers=f"""function {p}_StatElementAt takes integer row returns integer
    if row==2 then
        return 4
    elseif row==3 then
        return 3
    elseif row==4 then
        return 6
    elseif row==5 then
        return 5
    endif
    return row+1
endfunction

function {p}_StatSignedPercent takes real value returns string
    if value>0. then
        return "+"+{p}_StatPercent(value)
    endif
    return {p}_StatPercent(value)
endfunction
"""
    for helper,body in functions(helpers).items():
        if helper in functions(source):source=put(source,helper,body)
        else:source=source.replace('function '+name+' takes',body+'\n\nfunction '+name+' takes',1)
    body=functions(source)[name]
    if 'local integer statElementId' not in body:
        body=body.replace('    local integer i=0','    local integer i=0\n    local integer statElementId',1)
    # Always rebuild the defense section, keeping its effect rows compact after the base rows.
    start=body.index('    if '+page+'==1 then')
    end=body.index('    elseif '+page+'==2 then',start)
    defense=f"""    if {page}==1 then
        call {row}(0,"Evasion",{p}_StatPenalty(R2SW({p}_Stat_GetEvasion(hero),1,2),{get}(hero,'A1DB')>0))
        call {row}(1,"Armor",R2SW(BlzGetUnitArmor(hero),1,2))
        call {row}(2,"Armor Defense %",{p}_StatPenalty({p}_StatPercent({p}_StatEffectiveDefense({p}_StatArmorDefense(BlzGetUnitArmor(hero)),physicalDefense)),physicalDefense>1.))
        if hero==Player_GetHero(GetOwningPlayer(hero)) then
            call {row}(3,"Magic Defense",I2S(udg_MagicDefense[playerIndex]))
            call {row}(4,"Magic Defense %",{p}_StatPenalty({p}_StatPercent({p}_StatEffectiveDefense({p}_DefensePercent(udg_MagicDefense[playerIndex]),magicalDefense)),magicalDefense>1.))
        else
            call {row}(3,"Magic Defense","Native armor")
            call {row}(4,"Magic Defense %",{p}_StatPercent({p}_StatArmorDefense(BlzGetUnitArmor(hero))))
        endif
        call {row}(5,"Physical Block",{p}_StatPercent({p}_StatBlock(hero,true)))
        call {row}(6,"Magical Block",{p}_StatPercent({p}_StatBlock(hero,false)))
        set i=7
        set value=0.
        if {get}(hero,'A0RV')>0 or {get}(hero,'A0EI')>0 then
            set value=25.
        elseif {get}(hero,'A0RU')>0 then
            set value=10.
        endif
        if value>0. then
            call {row}(i,"Flat damage",R2SW(value,1,0))
            set i=i+1
        endif
        if {get}(hero,'A0T9')>0 and GetUnitState(hero,UNIT_STATE_LIFE)<=.3*GetUnitState(hero,UNIT_STATE_MAX_LIFE) then
            call {row}(i,"Damage taken","Halved")
            set i=i+1
        endif
        call {p}_RenderJob(hero,1,i)
"""
    body=body[:start]+defense+body[end:]
    # Reorder display elements without changing the game's elemental IDs.
    old='            set name='+names+'[i]'
    body=body.replace(old+'+" damage"', '            set statElementId='+p+'_StatElementAt(i)\n            set name='+names+'[statElementId-1]+" damage"')
    body=body.replace(old+'\n', '            set statElementId='+p+'_StatElementAt(i)\n            set name='+names+'[statElementId-1]\n')
    body=body.replace('if element==i+1 then','if element==statElementId then')
    body=body.replace(row+'(i,name,'+p+'_StatElementText(hero,i+1))',row+'(i+4,name,'+p+'_StatElementText(hero,statElementId))')
    body=body.replace(p+'_StatResistance(hero,i+1)',p+'_StatResistance(hero,statElementId)')
    for old_index,new_index,label,new_label in [(6,2,'Physical damage','Physical Damage'),(7,3,'Magical damage','Magical Damage'),
            (8,1,'Attack speed','Attack speed'),(9,0,'Accuracy rating','Accuracy')]:
        body=body.replace(row+'('+str(old_index)+',"'+label+'",',row+'('+str(new_index)+',"'+new_label+'",')
    # Other bonuses have the same seven positions in both clients. 1.29.2 cannot read live regeneration.
    start=body.index('    elseif '+page+'==4 then') if '    elseif '+page+'==4 then' in body else body.index('    else\n        set title="Other bonuses"')
    end=body.index('    set twoHandedWeapon=null',start)
    regen=(f"""        if hero==Player_GetHero(GetOwningPlayer(hero)) then
            call {row}(0,"Health regen",R2SW(ForsakenHeroHPRegen[playerIndex],1,2))
            call {row}(3,"Mana Regen",R2SW(ForsakenHeroMPRegen[playerIndex],1,2))
        else
            call {row}(0,"Health regen",R2SW(BlzGetUnitRealField(hero,UNIT_RF_HIT_POINTS_REGENERATION_RATE),1,2))
            call {row}(3,"Mana Regen",R2SW(BlzGetUnitRealField(hero,UNIT_RF_MANA_REGENERATION),1,2))
        endif
""" if native else f"""        call {row}(0,"Health regen","Unavailable")
        call {row}(3,"Mana Regen","Unavailable")
""")
    other=f"""    elseif {page}==4 then
        set title="Proficiencies"
        call {p}_RenderProficiencies(hero)
    else
        set title="Other bonuses"
"""+regen+f"""        call {row}(1,"Health healing efficiency",{p}_StatSignedPercent({p}_StatHealing(hero,false)))
        call {row}(2,"Healing received",{p}_StatPenalty({p}_StatPercent({p}_StatHealingReceived(hero)),{get}(hero,'B070')>0))
        call {row}(4,"Mana efficiency",{p}_StatSignedPercent({p}_StatHealing(hero,true)))
        call {row}(5,"Move speed",{p}_StatPenalty(R2SW(GetUnitMoveSpeed(hero),1,0),{get}(hero,'B08Y')>0 or {get}(hero,'Bslo')>0 or {get}(hero,'B05M')>0 or {get}(hero,'B05N')>0))
        call {row}(6,"Cooldown reduction",{p}_StatPenalty({p}_StatPercent({p}_StatCooldown(hero)),({get}(hero,'B08Y')>0 or {get}(hero,'Bslo')>0) and {get}(hero,'B08T')==0 and {get}(hero,'B00F')==0 and {get}(hero,'B07F')==0 and {get}(hero,'A0GJ')==0))
        call {p}_RenderGearOther(hero,{p}_RenderJob(hero,3,7))
    endif
"""
    body=body[:start]+other+body[end:]
    source=put(source,name,body)
    if native:
        source=source.replace('I2S(ForsakenStatsPage+1)+"/4)"','I2S(ForsakenStatsPage+1)+"/5)"')
        source=native_navigation(source)
    else:
        source=classic_navigation(source)
    if native:
        name='Forsaken_StatRow';body=functions(source)[name]
        if 'SubString(value,StringLength(value)-1' not in body:
            body=body.replace('    if value=="" then','    if StringLength(value)>0 and SubString(value,StringLength(value)-1,StringLength(value))=="%" then\n        set valueWidth=.05\n    endif\n    if value=="" then',1)
        source=put(source,name,body)
    return source


def native_navigation(source):
    fs=functions(source)
    if 'Forsaken_PanelClick' not in fs:return source
    if 'framehandle ForsakenStatsPrevious' not in source:
        source=source.replace('endglobals','    framehandle ForsakenStatsPrevious=null\nendglobals',1)
    helper='''function Forsaken_ChangeStats takes unit hero,integer direction returns nothing
    if direction>0 then
        if ForsakenStatsPage==2 and not ForsakenConditionPage and Forsaken_ConditionCount(hero)>4 then
            set ForsakenConditionPage=true
        else
            set ForsakenConditionPage=false
            set ForsakenStatsPage=ModuloInteger(ForsakenStatsPage+1,5)
        endif
    else
        if ForsakenStatsPage==2 and ForsakenConditionPage then
            set ForsakenConditionPage=false
        else
            set ForsakenStatsPage=ModuloInteger(ForsakenStatsPage+4,5)
            set ForsakenConditionPage=ForsakenStatsPage==2 and Forsaken_ConditionCount(hero)>4
        endif
    endif
    call Forsaken_RenderStats(hero)
endfunction'''
    if 'Forsaken_ChangeStats' in fs:source=put(source,'Forsaken_ChangeStats',helper)
    else:source=source.replace('function Forsaken_PanelClick takes',helper+'\n\nfunction Forsaken_PanelClick takes',1)
    body=functions(source)['Forsaken_PanelClick']
    start=body.index('        elseif BlzGetTriggerFrame()==ForsakenStatsNext')
    end=body.index('        else\n            set hero=null',start)
    body=body[:start]+'''        elseif BlzGetTriggerFrame()==ForsakenStatsNext or BlzGetTriggerFrame()==ForsakenStatsPrevious then
            if ForsakenInspectTarget!=null then
                set hero=ForsakenInspectTarget
            endif
            if hero!=null then
                if BlzGetTriggerFrame()==ForsakenStatsPrevious then
                    call Forsaken_ChangeStats(hero,-1)
                else
                    call Forsaken_ChangeStats(hero,1)
                endif
            endif
'''+body[end:]
    source=put(source,'Forsaken_PanelClick',body)
    name='Register_Forsaken_PanelAccess';body=functions(source)[name]
    if 'set ForsakenStatsPrevious=BlzCreateFrame' not in body:
        body=body.replace('    set ForsakenStatsNext=BlzCreateFrame', '''    set ForsakenStatsPrevious=BlzCreateFrame("ScriptDialogButton",ForsakenTalentRoot,0,0)
    call BlzFrameSetPoint(ForsakenStatsPrevious,FRAMEPOINT_TOP,ForsakenTalentRoot,FRAMEPOINT_TOP,-.047,-.367)
    call BlzFrameSetSize(ForsakenStatsPrevious,.085,.025)
    call BlzFrameSetText(ForsakenStatsPrevious,"< Back")
    call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_TalentClick,ForsakenStatsPrevious,FRAMEEVENT_CONTROL_CLICK)
    set ForsakenStatsNext=BlzCreateFrame''',1)
        body=body.replace('ForsakenStatsNext,FRAMEPOINT_TOP,ForsakenTalentRoot,FRAMEPOINT_TOP,0,-.367','ForsakenStatsNext,FRAMEPOINT_TOP,ForsakenTalentRoot,FRAMEPOINT_TOP,.047,-.367')
        body=body.replace('ForsakenStatsNext,.15,.025','ForsakenStatsNext,.085,.025').replace('ForsakenStatsNext,"More stats >"','ForsakenStatsNext,"Next >"')
    return put(source,name,body)


def classic_navigation(source):
    fs=functions(source)
    if 'Stats_Show' not in fs:return source
    if 'integer array StatsLastPage' not in source:source=source.replace('endglobals','    integer array StatsLastPage\nendglobals',1)
    name='Stats_Show';body=fs[name]
    body=body.replace('ModuloInteger(page+1,4)','ModuloInteger(page+1,5)').replace('I2S(page+1)+"/4)','I2S(page+1)+"/5)')
    if 'set StatsLastPage[' not in body:body=body.replace('    set title=Stats_Fill(hero,page)','    set StatsLastPage[GetPlayerId(p)]=page\n    set title=Stats_Fill(hero,page)',1)
    lines=body.splitlines()
    lines=[('    call DisplayTimedTextToPlayer(p,0.,0.,30.,"|cff808080-stats back / -stats next. Pages: 1 damage, 2 defenses, 3 resistances, 4 other, 5 proficiencies.|r")' if 'Pages: 1 damage' in line else line) for line in lines]
    source=put(source,name,'\n'.join(lines))
    name='Stats_PageName';body=functions(source)[name]
    if 'return "proficiencies"' not in body:body=body.replace('    return "other bonuses"','    if page==4 then\n        return "proficiencies"\n    endif\n    return "other bonuses"')
    source=put(source,name,body)
    name='Stats_OnCommand';body=functions(source)[name].replace('page>3','page>4')
    if 'text=="-stats next"' not in body:
        body=body.replace('    if page<0 or page>4 then','    if text=="-stats next" then\n        set page=ModuloInteger(StatsLastPage[GetPlayerId(GetTriggerPlayer())]+1,5)\n    elseif text=="-stats back" then\n        set page=ModuloInteger(StatsLastPage[GetPlayerId(GetTriggerPlayer())]+4,5)\n    endif\n    if page<0 or page>4 then',1)
    return put(source,name,body)

"""Final Priest talent layout and visible remaining overheal shield."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
from priest_ultimate import declarations

HOLY='All life spell power increases also increase basic-attack damage.'
CLEANSE='Esuna protects its target against new negative status ailments for 10 seconds.'
REFRESH='Esuna refreshes food and stat buffs already on its target; special hero effects gain 3 seconds instead. Base cooldown becomes 45 seconds.'


def refresh(source,*,native=False):
    fs=functions(source)
    if 'Text_FloatingDamage' in fs:
        body=fs['Text_FloatingDamage']
        if 'set x=x-80.' not in body:body=body.replace('    if mp then\n        call SetTextTagPos', '    if l_isHeal then\n        set x=x-80.\n    endif\n    if mp then\n        call SetTextTagPos',1)
        source=put(source,'Text_FloatingDamage',body)
    if 'Trig_Regen_Periodic_RegenUnit' in fs:
        body=fs['Trig_Regen_Periodic_RegenUnit']
        # A shielding heal consumes the accumulator. Zero does not mean the
        # active Regen buff expired; otherwise it gets removed after tick one.
        old='''            else
                call GroupAddUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
            endif'''
        new='''            elseif not Trig_Regen_Periodic_HasRegenBuff() then
                call GroupAddUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
            endif'''
        body=body.replace(old,new,1)
        source=put(source,'Trig_Regen_Periodic_RegenUnit',body)
    if 'Priest_RainTick' in fs:
        source=dependency(source,'TDamage')
        body=functions(source)['Priest_RainTick']
        # Resolve healing directly through the existing heal pipeline on each
        # script pulse; do not depend on a second native damage callback.
        body=re.sub(r'call UnitDamageTarget\(caster,target,(PriestRainHealing\[rank\](?:\*\.5)?),false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS\)',
                    r'call Trig_Damage_Engine_CalcDamage(\1,caster,target,false,3,false,0,false,false,true,false,false)',body)
        source=put(source,'Priest_RainTick',body)
    if 'Talents_InitData' in fs:
        body=fs['Talents_InitData']
        for row,col,name,text in [(2,2,'Holy Bolts',HOLY),(3,3,'Prolonged Cleansing',CLEANSE),(4,3,'Refresh',REFRESH)]:
            for field,value in [('Name',name),('Text',text)]:
                pattern=r'(set Talent'+field+r'\[Talent_Index\(job,'+str(row)+','+str(col)+r'\)\]=)"[^"\n]*"'
                body,n=re.subn(pattern,lambda m:m[1]+'"'+value+'"',body)
                if n!=1:raise ValueError('missing Priest talent slot '+str((row,col,field)))
        source=put(source,'Talents_InitData',body)
    if 'Talent_PriestChoice' in fs:
        source=put(source,'Talent_PriestChoice','''function Talent_PriestChoice takes unit hero,integer choice returns boolean
    if choice==3 then
        return hero!=null and Job_GetIndex(hero)==12 and Talent_Has(hero,2,2)
    endif
    return hero!=null and Job_GetIndex(hero)==12 and Talent_Has(hero,3,choice)
endfunction''')
        helper='''function Talent_ShieldAmount takes unit target returns real
    if target==null or GetWidgetLife(target)<=.405 then
        return 0.
    endif
    return RMaxBJ(0.,LoadReal(TalentShieldState,GetHandleId(target),0))
endfunction'''
        if 'Talent_ShieldAmount' in functions(source):source=put(source,'Talent_ShieldAmount',helper)
        else:source=source.replace('function Talent_AddShield takes',helper+'\n\nfunction Talent_AddShield takes',1)
        source=declarations(source,['group TalentShieldDisplayGroup=CreateGroup()','timer TalentShieldDisplayTimer=CreateTimer()'])
        fragment=(Path(__file__).resolve().parents[1]/'experiments/Forsaken/PriestShieldDisplay.j').read_text()
        for line in fragment.splitlines():
            if line.startswith('//'):source=source.replace(line+'\n','')
        for name in functions(fragment):
            source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
        source=source.replace('function Talent_ShieldExpire takes',fragment.strip()+'\n\nfunction Talent_ShieldExpire takes',1)
        for name in ['Talent_ShieldExpire','Talent_ShieldDeath']:
            body=functions(source)[name]
            if 'Talent_ShieldDisplayClear(target)' not in body:
                body=body.replace('    call FlushChildHashtable(TalentShieldState,GetHandleId(target))','    call Talent_ShieldDisplayClear(target)\n    call FlushChildHashtable(TalentShieldState,GetHandleId(target))')
                if name=='Talent_ShieldDeath':body=body.replace('        call FlushChildHashtable(TalentShieldState,GetHandleId(target))','        call Talent_ShieldDisplayClear(target)\n        call FlushChildHashtable(TalentShieldState,GetHandleId(target))')
            source=put(source,name,body)
        for name in ['Talent_AddShield','Talent_AbsorbShield']:
            body=functions(source)[name]
            if 'Talent_ShieldDisplayUpdate(target)' not in body:
                body=re.sub(r'(call SaveReal\(TalentShieldState,key,0,[^\n]+\))',r'\1\n        call Talent_ShieldDisplayUpdate(target)',body)
            source=put(source,name,body)
        body=functions(source)['Talents_InitData']
        body=re.sub(r'(set TalentText\[Talent_Index\(job,3,1\)\]=)"[^"\n]*"',lambda m:m[1]+'"Cure, Regen and Tranquility convert 25% of overhealing into a damage shield. Shields stack and expire 30 seconds after the latest addition."',body)
        source=put(source,'Talents_InitData',body)
    if 'Trig_Damage_Engine_Step19_Apply' in fs:
        body=functions(source)['Trig_Damage_Engine_Step19_Apply']
        body=re.sub(r'call Talent_AddShield\(t,(RMaxBJ\(0\.,l_amount-RMaxBJ\(0\.,GetUnitState\(t,UNIT_STATE_MAX_LIFE\)-GetUnitState\(t,UNIT_STATE_LIFE\)\)\))\)',r'call Talent_AddShield(t,.25*\1)',body)
        source=put(source,'Trig_Damage_Engine_Step19_Apply',body)
    if 'Talent_ProlongedCleansing' in fs:
        body=functions(source)['Talent_ProlongedCleansing'].replace('Talent_LegendChoice(caster,3)','(Job_GetIndex(caster)==12 and Talent_Has(caster,3,3))')
        source=put(source,'Talent_ProlongedCleansing',body)
    source=source.replace(",12,2,2,'A0W9')",",12,4,3,'A0W9')")
    source=source.replace("Priest_AbilityTalentTip(hero,'A0W9',2,2)","Priest_AbilityTalentTip(hero,'A0W9',4,3)")
    source=source.replace("SaveInteger(SpellCalcData,'A0W9',-1,2)","SaveInteger(SpellCalcData,'A0W9',-1,4)")
    source=source.replace("SaveInteger(SpellCalcData,'A0W9',-2,2)","SaveInteger(SpellCalcData,'A0W9',-2,3)")
    if 'SpellCalc_Tooltip' in fs:
        body=functions(source)['SpellCalc_Tooltip'].replace("raw=='A0W9' and Talent_LegendChoice(hero,3)","raw=='A0W9' and Job_GetIndex(hero)==12 and Talent_Has(hero,3,3)")
        source=put(source,'SpellCalc_Tooltip',body)
    for name,prefix,row in [('Forsaken_RenderStatsUncached','Forsaken','Forsaken_StatRow'),('Stats_Fill','Stats','Stats_Row')]:
        if name not in fs:continue
        source=dependency(source,'TTalents')
        body=functions(source)[name]
        if '"Shielding"' not in body:body=body.replace('        set i=7',f'''        set i=7
        if Talent_ShieldAmount(hero)>0. then
            call {row}(i,"Shielding",R2SW(Talent_ShieldAmount(hero),1,0))
            set i=i+1
        endif''',1)
        source=put(source,name,body)
    if native and 'Forsaken_DrawPanels' in fs:
        for name in ['Forsaken_DrawPanels','Forsaken_UpdatePanels']:
            if name not in fs:continue
            body=functions(source)[name]
            if 'infocard-attack-magic.blp' not in body:
                pattern=r'(?m)^( +)call BlzFrameSetTexture\(ForsakenTalentIcon\[node\],BlzGetAbilityIcon\(skill\),0,true\)'
                def icon(m):
                    indent=m[1]
                    lines=['if job==TALENT_JOB_PRIEST and (node==4 or node==9) then',
                        r'    call BlzFrameSetTexture(ForsakenTalentIcon[node],"UI\\Widgets\\Console\\Human\\infocard-attack-magic.blp",0,true)',
                        'elseif job==TALENT_JOB_PRIEST and node==6 then',
                        "    call BlzFrameSetTexture(ForsakenTalentIcon[node],BlzGetAbilityIcon('A00M'),0,true)",
                        'elseif job==TALENT_JOB_PRIEST and node==8 then',
                        "    call BlzFrameSetTexture(ForsakenTalentIcon[node],BlzGetAbilityIcon('A0W9'),0,true)",
                        'else','    call BlzFrameSetTexture(ForsakenTalentIcon[node],BlzGetAbilityIcon(skill),0,true)','endif']
                    return '\n'.join(indent+line for line in lines)
                body=re.sub(pattern,icon,body)
            source=put(source,name,body)
        if 'Forsaken_HolyBoltsTooltip' in fs:
            body=functions(source)['Forsaken_HolyBoltsTooltip']
            body=body.replace('BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,3)','ForsakenAttackCommand')
            body=re.sub(r'call BlzFrameSetText\(ForsakenHolyBoltsText,"\|cffffcc00Attack\|r\|nOrders your hero to attack\.\|n\|n\|cffffcc00Holy Bolts\|r\|n[^\n]*',
                lambda m:'call BlzFrameSetText(ForsakenHolyBoltsText,"|cffffcc00Attack|r|nOrders your hero to attack.|n|n|cffffcc00Holy Bolts|r|n'+HOLY+'|nCurrent basic-attack damage: +"+R2SW(Talent_LifeAttackPower(hero)*100.,1,0)+"%.")',body)
            source=put(source,'Forsaken_HolyBoltsTooltip',body)
        source=declarations(source,['framehandle ForsakenShieldReadout=null'])
        helper='''function Forsaken_ShieldReadout takes unit hero returns nothing
    // Remaining shield is now a shared world texttag that follows its target.
    if ForsakenShieldReadout!=null then
        call BlzFrameSetVisible(ForsakenShieldReadout,false)
    endif
endfunction'''
        if 'Forsaken_ShieldReadout' in functions(source):source=put(source,'Forsaken_ShieldReadout',helper)
        else:source=source.replace('function Forsaken_PollPanels takes',helper+'\n\nfunction Forsaken_PollPanels takes',1)
        body=functions(source)['Forsaken_PollPanels']
        if 'call Forsaken_ShieldReadout(hero)' not in body:body=body.replace('    call Forsaken_BackpackInputControl(hero,viewer)','    call Forsaken_BackpackInputControl(hero,viewer)\n    call Forsaken_ShieldReadout(hero)',1)
        source=put(source,'Forsaken_PollPanels',body)
        body=functions(source)['Register_Forsaken_PanelAccess']
        if 'set ForsakenShieldReadout=' not in body:body=body.replace('    call Forsaken_RegisterBackpackActivity()',r'''    call Forsaken_RegisterBackpackActivity()
    set ForsakenShieldReadout=BlzCreateFrameByType("TEXT","ShieldingReadout",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetPoint(ForsakenShieldReadout,FRAMEPOINT_LEFT,BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR,0),FRAMEPOINT_RIGHT,.004,0.)
    call BlzFrameSetSize(ForsakenShieldReadout,.10,.016)
    call BlzFrameSetFont(ForsakenShieldReadout,"Fonts\\FRIZQT__.TTF",.010,0)
    call BlzFrameSetLevel(ForsakenShieldReadout,60)
    call BlzFrameSetVisible(ForsakenShieldReadout,false)''',1)
        source=put(source,'Register_Forsaken_PanelAccess',body)
        body=functions(source)['Forsaken_RebuildPanels']
        if 'BlzDestroyFrame(ForsakenShieldReadout)' not in body:body=body.replace('    call Forsaken_ResetBackpackControls()','    call BlzDestroyFrame(ForsakenShieldReadout)\n    set ForsakenShieldReadout=null\n    call Forsaken_ResetBackpackControls()',1)
        source=put(source,'Forsaken_RebuildPanels',body)
    return source

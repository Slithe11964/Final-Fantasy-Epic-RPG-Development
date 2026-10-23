"""Priest life-power attacks and Legendary choices, shared by both profiles."""
import copy,re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
from priest_ultimate import declarations
ROOT=Path(__file__).resolve().parents[1]


def refresh(source,*,native=False):
    fs=functions(source)
    if 'Talents_InitData' in fs:
        source=dependency(source,'TRemove')
        decl,helper=(ROOT/'experiments/Forsaken/PriestLegendary.j').read_text().split('// FUNCTIONS\n',1)
        remove=next((ROOT/'src/triggers').rglob('Remove.j')).read_text()
        bad=re.findall(r"call UnitRemoveBuffBJ\('(.{4})',udg_DispelTarget\)",functions(remove)['Trig_Remove_Debuffs_Actions'])
        helper=helper.replace('CLEANSE','\n'.join("    call UnitRemoveAbility(target,'"+raw+"')" for raw in bad))
        source=declarations(source,decl.strip().splitlines())
        for name,body in functions(helper).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function Talents_InitData takes',body+'\n\nfunction Talents_InitData takes',1)
        body=functions(source)['Talents_InitData']
        if '"Healing Bolts"' not in body:body=body.replace('endfunction','''    set TalentName[Talent_Index(job,4,1)]="Healing Bolts"
    set TalentText[Talent_Index(job,4,1)]="Basic attacks heal every living ally along their path for 25% of health damage actually dealt."
    set TalentName[Talent_Index(job,4,2)]="Tranquility of Life"
    set TalentText[Talent_Index(job,4,2)]="Other allies (not the caster) killed inside your active Tranquility are revived where they died, with full health and mana."
    set TalentName[Talent_Index(job,4,3)]="Prolonged Cleansing"
    set TalentText[Talent_Index(job,4,3)]="Esuna protects its target against new negative status ailments for 10 seconds."
endfunction''')
        body=body.replace('Your healing increase percentage also increases basic-attack damage, including Rejuvenation. Attack damage type is unchanged.',
            'All Life spell-power increases also increase basic-attack damage: Staff proficiency, equipped Staff bonuses, White Robe, healing buffs and Rejuvenation. Attack damage type is unchanged.')
        source=put(source,'Talents_InitData',body)
        body=functions(source)['Talents_Init']
        if 'call Talent_LegendInit()' not in body:body=body.replace('    call Talent_UltimateInit()','    call Talent_UltimateInit()\n    call Talent_LegendInit()')
        source=put(source,'Talents_Init',body)
    if 'Prof_StaffPower' in fs:
        source=dependency(source,'TTalents')
        helper='''function Talent_LifeAttackPower takes unit hero returns real
    if Talent_PriestChoice(hero,3) then
        return (1.+Talent_HealingPower(hero))*Prof_StaffPower(hero)-1.
    endif
    return 0.
endfunction'''
        if 'Talent_LifeAttackPower' in fs:source=put(source,'Talent_LifeAttackPower',helper)
        else:source=source.replace('endlibrary',helper+'\n\nendlibrary')
    if 'library TMissile ' in source:source=declarations(source,['boolean PriestBasicHit=false'])
    if 'Trig_Damage_Engine_CalcDamage' in fs:
        source=declarations(source,['boolean array DmgCtx_PriestBasic'])
        body=functions(source)['Trig_Damage_Engine_CalcDamage']
        if 'set DmgCtx_PriestBasic[c]' not in body:body=body.replace('    set DmgCtx_PriestShield[c]=PriestShieldHealSource','    set DmgCtx_PriestBasic[c]=PriestBasicHit\n    set PriestBasicHit=false\n    set DmgCtx_PriestShield[c]=PriestShieldHealSource')
        source=put(source,'Trig_Damage_Engine_CalcDamage',body)
        body=functions(source)['Trig_Damage_Engine_FreeContext']
        if 'DmgCtx_PriestBasic[c]=false' not in body:body=body.replace('    set DmgCtx_PriestShield[c]=null','    set DmgCtx_PriestBasic[c]=false\n    set DmgCtx_PriestShield[c]=null')
        source=put(source,'Trig_Damage_Engine_FreeContext',body)
        body=functions(source)['Trig_Damage_Engine_Actions']
        if 'local boolean priestBasic' not in body:
            body=body.replace('    local integer l_dmgKind=0','    local integer l_dmgKind=0\n    local boolean priestBasic=false')
            body=body.replace('        if l_dmgKind==1 and not udg_IsPhysicalAttack and not udg_IsPureDamage then','        set priestBasic=l_dmgKind==1 and not udg_IsPhysicalAttack and not udg_IsPureDamage\n        if priestBasic then')
            body=body.replace('        set l_amount=Trig_Damage_Engine_CalcDamage','        set PriestBasicHit=priestBasic\n        set l_amount=Trig_Damage_Engine_CalcDamage',1)
        body=body.replace('Talent_HolyBolts(u)','Talent_LifeAttackPower(u)')
        if 'Talent_CleansingProtected' not in body:body=body.replace('    if(GetUnitAbilityLevel(triggeringUnit,', '    if Talent_CleansingProtected(triggeringUnit) then\n        call Talent_CleanseStatus(triggeringUnit)\n    endif\n    if(GetUnitAbilityLevel(triggeringUnit,',1)
        source=put(source,'Trig_Damage_Engine_Actions',body)
        body=functions(source)['Trig_Damage_Engine_Step19_Apply']
        if 'Talent_HealingBolt(u,t,' not in body:body=body.replace('    // DPS meter for players.','    if DmgCtx_PriestBasic[c] and not l_heal and not l_manaDamage and l_amount>0. then\n        call Talent_HealingBolt(u,t,RMinBJ(l_amount,GetWidgetLife(t)))\n    endif\n    // DPS meter for players.')
        source=put(source,'Trig_Damage_Engine_Step19_Apply',body)
    if 'Trig_Hero_Death_Revive_Actions' in fs:
        source=dependency(source,'TTalents')
        body=functions(source)['Trig_Hero_Death_Revive_Actions']
        if 'Talent_TryRainRevive' not in body:body=body.replace('    call DialogDisplay','    if Talent_TryRainRevive(GetTriggerUnit()) then\n        return\n    endif\n    call DialogDisplay',1)
        source=put(source,'Trig_Hero_Death_Revive_Actions',body)
    if 'Priest_MasterEsuna' in fs:
        body=functions(source)['Priest_MasterEsuna']
        if 'Talent_ProlongedCleansing' not in body:body=body.replace('endfunction',"    if GetSpellAbilityId()=='A0W9' then\n        call Talent_ProlongedCleansing(GetTriggerUnit(),GetSpellTargetUnit())\n    endif\nendfunction")
        source=put(source,'Priest_MasterEsuna',body)
    if native and 'Forsaken_TalentCanPurchase' in fs:
        for name in ['Forsaken_TalentCanPurchase','Forsaken_DrawPanels','Forsaken_UpdatePanels']:
            if name not in functions(source):continue
            body=functions(source)[name].replace('node<9','node<12')
            marker='                if node>=6 and node<12 then'
            if 'if node>=9 and node<12 then' not in body:body=body.replace(marker,"                if node>=9 and node<12 then\n                    if column==0 then\n                        set skill='A00M'\n                    elseif column==1 then\n                        set skill='A0OM'\n                    else\n                        set skill='A0W9'\n                    endif\n                elseif node>=6 and node<12 then")
            source=put(source,name,body)
        body=functions(source)['Forsaken_HolyBoltsTooltip']
        body=body.replace('and Talent_PriestChoice(hero,3)','and (Talent_PriestChoice(hero,3) or Talent_LegendChoice(hero,1))')
        body=body.replace('Talent_HealingPower(hero)*100.','Talent_LifeAttackPower(hero)*100.')
        if 'show and not Talent_PriestChoice' not in body:body=body.replace('    if show!=ForsakenHolyBoltsAttached then','    if show and not Talent_PriestChoice(hero,3) then\n        call BlzFrameSetText(ForsakenHolyBoltsText,"|cffffcc00Attack|r|nOrders your hero to attack.")\n    endif\n    if show!=ForsakenHolyBoltsAttached then')
        if 'Healing Bolts|r' not in body:body=body.replace('    if show!=ForsakenHolyBoltsAttached then','    if show and Talent_LegendChoice(hero,1) then\n        call BlzFrameSetText(ForsakenHolyBoltsText,BlzFrameGetText(ForsakenHolyBoltsText)+"|n|n|cffffcc00Healing Bolts|r|nHeals allies along the attack path for 25% of actual damage dealt.")\n    endif\n    if show!=ForsakenHolyBoltsAttached then')
        source=put(source,'Forsaken_HolyBoltsTooltip',body)
        body=functions(source)['Register_Forsaken_PanelAccess'].replace('BlzFrameSetSize(ForsakenHolyBoltsTip,.24,.105)','BlzFrameSetSize(ForsakenHolyBoltsTip,.24,.17)').replace('BlzFrameSetSize(ForsakenHolyBoltsText,.216,.081)','BlzFrameSetSize(ForsakenHolyBoltsText,.204,.134)')
        source=put(source,'Register_Forsaken_PanelAccess',body)
    return source


def objects(data):
    if not data:return data
    from objdata import read_objects,write_objects
    from priest_master import setf
    table=read_objects(data,'w3a')
    obj=dict(id='pRiv',base='AHre',sets=[dict(flag=0,mods=[])])
    for key,value in [('alev',1),('aher',0),('anam','Tranquility resurrection')]:setf(obj,key,value,0)
    for key,value in [('amcs',0),('acdn',0.),('acas',0.),('aran',99999.),('aare',8.),('Hre1',1),('atar','air,ground,dead,friend,organic')]:setf(obj,key,value,1,data=1 if key=='Hre1' else 0)
    table['custom'][:]=[o for o in table['custom'] if o['id']!='pRiv'];table['custom'].append(obj)
    return write_objects(table,table['version'],'w3a')

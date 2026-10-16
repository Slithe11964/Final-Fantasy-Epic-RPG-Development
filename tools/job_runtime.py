"""Shared job behavior and rank-aware stat presentation for both paired profiles."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put,replace_once
from gameplay_runtime import dependency
ROOT=Path(__file__).resolve().parents[1]
HERE=ROOT/'experiments/Forsaken'


def refresh(source,*,native=False):
    fs=functions(source)
    if 'Abil_GetLevel' in fs:
        source=dependency(source,'TText')
        if 'JobFX_RageSpeed' not in fs:
            source=source.replace('function Abil_CopyOne', 'globals\n    hashtable JobFXData=null\nendglobals\n\n'+(HERE/'JobEffects.j').read_text()+'\nfunction Abil_CopyOne',1)
        for name,body in functions((HERE/'JobEffects.j').read_text()).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function Abil_CopyOne',body+'\n\nfunction Abil_CopyOne',1)
    if 'RegisterTriggers_Aim' in fs:
        body=fs['RegisterTriggers_Aim']
        body=replace_once(body,'    call Register_Aim_Cast()', '    call Register_Aim_Cast()\n    call JobFX_Register()')
        source=put(source,'RegisterTriggers_Aim',body)
    if 'Trig_Chemist_TakeItem_Actions' in fs:
        source=dependency(source,'TItemStack')
        body='''function Trig_Chemist_TakeItem_Actions takes nothing returns nothing
    local integer slot=0
    local integer size=Carry_Size(udg_CurrentHero)
    set udg_TempItemId='tkno'
    set udg_ChemistItem=null
    loop
        exitwhen slot>=size
        set udg_ChemistItem=Carry_At(udg_CurrentHero,slot)
        if Trig_Chemist_TakeItem_Cond_IsChemistItem() then
            set udg_TempItemId=Carry_Type(udg_ChemistItem)
            if GetItemCharges(udg_ChemistItem)>1 then
                call SetItemCharges(udg_ChemistItem,GetItemCharges(udg_ChemistItem)-1)
            else
                call Fix_ChemistItem_RemoveLater(udg_ChemistItem)
            endif
            return
        endif
        set slot=slot+1
    endloop
endfunction'''
        source=put(source,'Trig_Chemist_TakeItem_Actions',body)
        body=functions(source)['Trig_Chemist_NoxiousMixture_Actions']
        body=body.replace("    set l_tempItemId='tkno'", "    set udg_TempItemId='tkno'")
        if '    set l_tempItemId=udg_TempItemId' not in body:
            body=body.replace('    call ConditionalTriggerExecute(gg_trg_Chemist_TakeItem)', '    call ConditionalTriggerExecute(gg_trg_Chemist_TakeItem)\n    set l_tempItemId=udg_TempItemId')
        source=put(source,'Trig_Chemist_NoxiousMixture_Actions',body)
        source=source.replace('call Medicine_ApplyTimed(GetSpellTargetUnit(),true)','call Medicine_ApplyTimed(udg_TempUnit2,true)')
    for name in ['Trig_Myriad_Arrows_Actions','Trig_Meteor_Cast_Actions','Trig_Spell_Meteor_Wide_Actions']:
        if name in fs:
            # h01B already has an invisible model and Locust. Hidden units cannot channel.
            body=fs[name]
            body=re.sub(r'^    call ShowUnitHide\(GetLastCreatedUnit\(\)\)[^\n]*\n','',body,flags=re.M)
            body=body.replace('    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)',
                '    call SetUnitState(GetLastCreatedUnit(),UNIT_STATE_MANA,GetUnitState(GetLastCreatedUnit(),UNIT_STATE_MAX_MANA))\n    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)') if '    call SetUnitState(GetLastCreatedUnit(),UNIT_STATE_MANA' not in body else body
            source=put(source,name,body)
    if 'Trig_Damage_Engine_Step02_HealingUndead' in fs:
        body=fs['Trig_Damage_Engine_Step02_HealingUndead']
        body=body.replace('if(l_heal and not l_healUndead and(', 'if(l_heal and not DmgCtx_ManaDamage[c] and not l_healUndead and(')
        source=put(source,'Trig_Damage_Engine_Step02_HealingUndead',body)
        body=fs['Trig_Damage_Engine_PostDamageEffects']
        body=body.replace('                call Wait_Polled(30.)','                call Wait_Polled(90.)')
        # Endure's marker must stay present during cooldown; use the shared group as the gate.
        body=body.replace("(triggeringUnit,'A14S')>0 and", "(triggeringUnit,'A14T')>0 and")
        body=re.sub(r'^                call BlzUnitDisableAbility\(triggeringUnit,\'A14T\'[^\n]*\n','',body,flags=re.M)
        body=body.replace('                call GroupAddUnit(udg_UndyingGroup,triggeringUnit)','                call JobFX_UndyingStart(triggeringUnit)')
        body=body.replace('                call Wait_Polled(90.)\n                call GroupRemoveUnit(udg_UndyingGroup,triggeringUnit)\n', '')
        source=put(source,'Trig_Damage_Engine_PostDamageEffects',body)
        name='Trig_Damage_Engine_Step18_FinalModifiers'
        body=functions(source)[name]
        read='Forsaken_ElementAbilityLevel' if native else 'GetUnitAbilityLevel'
        start=body.index("        if(l_amount>.0 and "+read+"(t,'B051')")
        end=body.index("        if("+read+"(u,'B04B')",start)
        body=body[:start]+f'''        if(l_amount>.0 and {read}(t,'B051')>0 and not l_heal and not l_manaDamage and LoadBoolean(udg_DivineShieldHash,th,3))then
            set l_amount=JobFX_Shield(t,l_amount)
        endif
'''+body[end:]
        source=put(source,name,body)
    if 'Trig_Prophet_DivineShield_Actions' in fs:
        body=fs['Trig_Prophet_DivineShield_Actions']
        body=replace_once(body,'    if(abilityLevel==$B)then', '    if l_ward==null then\n        set l_ward=triggeringUnit\n    endif\n    if(abilityLevel==$B)then')
        before,after=body.split('    if(LoadBoolean(udg_DivineShieldHash,GetHandleId(l_ward),3))then',1)
        after=after.replace("call SaveBoolean(udg_DivineShieldHash,GetHandleId(l_prevUnit),3,false)","call SaveBoolean(udg_DivineShieldHash,GetHandleId(l_prevUnit),0,false)")
        body=before+'    if(LoadBoolean(udg_DivineShieldHash,GetHandleId(l_ward),3))then'+after
        body=body.replace('        call DestroyTimer(l_prevTimer)\n', '        call DestroyTimer(l_prevTimer)\n        call FlushChildHashtable(udg_DivineShieldHash,GetHandleId(l_prevTimer))\n') if '        call FlushChildHashtable(udg_DivineShieldHash,GetHandleId(l_prevTimer))' not in body else body
        source=put(source,'Trig_Prophet_DivineShield_Actions',body)
        body=fs['Trig_Prophet_DivineShield_ExpireLink']
        body=replace_once(body,'    call DestroyTimer(expiredTimer)','    call UnitRemoveAbility(l_ward,\'B051\')\n    call FlushChildHashtable(udg_DivineShieldHash,GetHandleId(expiredTimer))\n    call DestroyTimer(expiredTimer)')
        source=put(source,'Trig_Prophet_DivineShield_ExpireLink',body)
    prefix='Forsaken' if 'Forsaken_RenderStatsUncached' in fs else 'Stats' if 'Stats_Fill' in fs else None
    if prefix:
        source=dependency(source,'TAbil')
        p=prefix;getter='Forsaken_StatAbilityLevel' if native else 'GetUnitAbilityLevel'
        helper=(HERE/'JobStats.j').read_text().replace('JSTAT',p).replace('JGET',getter).replace('JROW','Forsaken_StatRow' if native else 'Stats_Row')
        if p+'_RenderJob' not in fs:
            at=source.index('function '+('Forsaken_RenderStatsUncached' if native else 'Stats_Fill'))
            source=source[:at]+helper+'\n'+source[at:]
        else:source=put(source,p+'_RenderJob',functions(helper)[p+'_RenderJob'])
        name='Forsaken_RenderStatsUncached' if native else 'Stats_Fill'
        body=functions(source)[name]
        page='ForsakenStatsPage' if native else 'page'
        if f'{p}_RenderJob(hero,' not in body:
            body=body.replace(f'        call {p}_RenderGearDamage(hero,i)',f'        set i={p}_RenderJob(hero,0,i)\n        call {p}_RenderGearDamage(hero,i)')
            start=7 if native else 5
            body=body.replace(f'        call {p}_RenderGearOther(hero,{start})',f'        call {p}_RenderGearOther(hero,{p}_RenderJob(hero,3,{start}))')
            body=body.replace(f'    elseif {page}==2 then',f'        call {p}_RenderJob(hero,1,9)\n    elseif {page}==2 then')
        source=put(source,name,body)
        name=p+'_StatAttackSpeed';body=functions(source)[name]
        if 'JobFX_RageSpeed' not in body:
            body=body.replace('    return I2R(',f"    if {getter}(hero,'B01F')>0 then\n        set speed=speed-R2I(30.+6.*I2R(IMaxBJ(1,{getter}(hero,'A14B'))-1))\n    endif\n    if {getter}(hero,'B00K')>0 or {getter}(hero,'B07P')>0 then\n        set speed=speed+R2I(JobFX_RageSpeed(hero))\n    endif\n    if {getter}(hero,'B082')>0 then\n        set speed=speed+R2I(JobFX_DarkSpeed(hero))\n    endif\n    return I2R(")
            source=put(source,name,body)
        name=p+'_StatOutgoing';body=functions(source)[name]
        if 'JobFX outgoing modifiers' not in body:
            extra=f'''    // JobFX outgoing modifiers match the physical-hit and final-drain steps.
    if {getter}(hero,'B00K')>0 or {getter}(hero,'B07P')>0 then
        set mult=mult*1.1
    endif
    if physical and {getter}(hero,'B01F')>0 then
        set mult=mult*1.2
    endif
    if physical and {getter}(hero,'B04B')>0 and {getter}(hero,'A0R2')>0 then
        if {getter}(hero,'A0R2')>=11 then
            set mult=mult*.75
        else
            set mult=mult*(.58+.02*I2R({getter}(hero,'A0R2')))
        endif
    endif
'''
            body=body.replace('    return (mult-1.)*100.',extra+'    return (mult-1.)*100.')
            source=put(source,name,body)
    return source

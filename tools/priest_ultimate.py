"""Priest level-99 choices and exact, context-isolated healing shields."""
from pathlib import Path
import re
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
ROOT=Path(__file__).resolve().parents[1]


def declarations(source,lines):
    for line in lines:
        name=line.split('=')[0].split()[-1]
        if not re.search(r'^\s*\w+\s+(?:array )?'+name+r'\b',source,re.M):
            source=source.replace('endglobals','    '+line.strip()+'\nendglobals',1)
    return source


def refresh(source,*,native=False):
    fs=functions(source)
    if 'Talents_InitData' in fs:
        decl,helpers=(ROOT/'experiments/Forsaken/PriestUltimate.j').read_text().split('// FUNCTIONS\n',1)
        source=declarations(source,decl.strip().splitlines())
        for name,body in functions(helpers).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function Talents_InitData takes',body+'\n\nfunction Talents_InitData takes',1)
        body=functions(source)['Talents_InitData']
        if '"Shielding"' not in body:
            body=body.replace('endfunction','''    set TalentName[Talent_Index(job,3,1)]="Shielding"
    set TalentText[Talent_Index(job,3,1)]="Cure, Regen and Tranquility turn healing beyond maximum health into an equal damage shield. Shields add together and expire 30 seconds after the latest addition."
    set TalentName[Talent_Index(job,3,2)]="Blessed Rain"
    set TalentText[Talent_Index(job,3,2)]="Allies in your Tranquility take 10% less damage while affected. Multiple Blessed Rains do not stack."
    set TalentName[Talent_Index(job,3,3)]="Holy Bolts"
    set TalentText[Talent_Index(job,3,3)]="Your healing increase percentage also increases basic-attack damage, including Rejuvenation. Attack damage type is unchanged."
endfunction''')
        source=put(source,'Talents_InitData',body)
        body=functions(source)['Talents_Init']
        if 'call Talent_UltimateInit()' not in body:body=body.replace('    call Talents_InitData()','    call Talents_InitData()\n    call Talent_UltimateInit()')
        source=put(source,'Talents_Init',body)
    if 'Missile_InitIndex' in fs or 'library TMissile ' in source:
        source=declarations(source,['unit PriestShieldHealSource=null','boolean array PriestShieldMissile'])
        source=source.replace('    set udg_MissileHealCredit[l_idx]=0','    set udg_MissileHealCredit[l_idx]=0\n    set PriestShieldMissile[l_idx]=false') if '    set PriestShieldMissile[l_idx]=false' not in source else source
        # Snapshot the eligible Cure source only for this synchronous hit.
        lines=source.splitlines();out=[]
        for line in lines:
            if 'call UnitDamageTarget(udg_MissileCaster[l_idx],' in line and (not out or 'PriestShieldHealSource' not in out[-1]):
                indent=line[:len(line)-len(line.lstrip())]
                out.extend([indent+'if PriestShieldMissile[l_idx] then',indent+'    set PriestShieldHealSource=udg_MissileCaster[l_idx]',indent+'endif',line,indent+'set PriestShieldHealSource=null'])
            else:out.append(line)
        # Repeated refresh must not duplicate the per-hit wrapper.
        if 'set PriestShieldHealSource=udg_MissileCaster[l_idx]' not in source:source='\n'.join(out)+'\n'
    if 'Trig_Spell_Cure_Actions' in fs:
        body=functions(source)['Trig_Spell_Cure_Actions']
        if 'set PriestShieldMissile[d]' not in body:
            body=body.replace('    if blinding then',"    set PriestShieldMissile[d]=Talent_PriestChoice(triggeringUnit,1)\n    if blinding then",1)
        source=put(source,'Trig_Spell_Cure_Actions',body)
    if 'Priest_RainTick' in fs:
        body=functions(source)['Priest_RecordUnit']
        if 'call RemoveSavedHandle(udg_HealOverTimeHash,GetHandleId(target),12)' not in body:
            body=body.replace('            call SaveBoolean(udg_HealOverTimeHash,GetHandleId(target),10,false)',
                '            call RemoveSavedHandle(udg_HealOverTimeHash,GetHandleId(target),12)\n            call SaveBoolean(udg_HealOverTimeHash,GetHandleId(target),10,false)',1)
        source=put(source,'Priest_RecordUnit',body)
        source=source.replace('                        set udg_IsPureDamage=false','                        set PriestShieldHealSource=null\n                        set udg_IsPureDamage=false',1) if 'set PriestShieldHealSource=caster' not in source else source
        if 'set PriestShieldHealSource=caster' not in source:
            source=source.replace('                            set udg_IsPureDamage=true','                            set udg_IsPureDamage=true\n                            if Talent_PriestChoice(caster,1) then\n                                set PriestShieldHealSource=caster\n                            endif',1)
            source=source.replace('                        // Damage events normally reset this.','                        set PriestShieldHealSource=null\n                        // Damage events normally reset this.',1)
        body=functions(source)['Priest_RainEvent']
        if 'set TalentRainCaster[pid]=caster' not in body:
            body=body.replace('            set PriestRainCaster[pid]=caster','            set PriestRainCaster[pid]=caster\n            set TalentRainCaster[pid]=caster\n            set TalentRainRadius[pid]=PriestRainRadius[rank]')
            body=body.replace('            set PriestRainCaster[pid]=null','            set PriestRainCaster[pid]=null\n            set TalentRainCaster[pid]=null')
        source=put(source,'Priest_RainEvent',body)
        body=functions(source)['Priest_RainTick']
        if 'set TalentRainCaster[pid]=null' not in body:body=body.replace('                set PriestRainCaster[pid]=null','                set PriestRainCaster[pid]=null\n                set TalentRainCaster[pid]=null')
        source=put(source,'Priest_RainTick',body)
        body=functions(source)['Priest_Swiftmend']
        if 'GetHandleId(target),12' not in body:body=body.replace('    if swift then','    call SaveUnitHandle(udg_HealOverTimeHash,GetHandleId(target),12,caster)\n    if swift then',1)
        source=put(source,'Priest_Swiftmend',body)
        body=functions(source)['Trig_Regen_Periodic_RegenUnit']
        if 'local unit shieldCaster' not in body:
            body=body.replace(' returns nothing\n',' returns nothing\n    local unit shieldCaster=LoadUnitHandle(udg_HealOverTimeHash,GetHandleId(GetEnumUnit()),12)\n',1)
            marker='        if(Trig_Regen_Periodic_LacksNegateHeals())then'
            body=body.replace(marker,'''        if udg_TempReal>0. and Talent_PriestChoice(shieldCaster,1) then
            set PriestShieldHealSource=shieldCaster
            set udg_IsPureDamage=true
            set udg_DmgFlagPure=true
            call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),udg_TempReal*(GetRandomReal(15.,16.)/16.),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            set PriestShieldHealSource=null
            set udg_TempReal=0.
        endif
'''+marker,1)
            body=body.replace('endfunction','    set shieldCaster=null\nendfunction')
        source=put(source,'Trig_Regen_Periodic_RegenUnit',body)
    if 'Trig_Damage_Engine_CalcDamage' in fs:
        source=dependency(source,'TTalents')
        source=declarations(source,['unit array DmgCtx_PriestShield'])
        body=functions(source)['Trig_Damage_Engine_CalcDamage']
        if 'set DmgCtx_PriestShield[c]' not in body:
            body=body.replace('    set DmgCtx_Heal[c]=l_heal','    set DmgCtx_PriestShield[c]=PriestShieldHealSource\n    set PriestShieldHealSource=null\n    set DmgCtx_Heal[c]=l_heal',1)
        # Release the extra context reference together with the normal result.
        body=body.replace('    set DmgCtx_PriestShield[c]=null\n','')
        body=body.replace('    set DmgCtx_Depth=DmgCtx_Depth-1','    set DmgCtx_PriestShield[c]=null\n    set DmgCtx_Depth=DmgCtx_Depth-1')
        source=put(source,'Trig_Damage_Engine_CalcDamage',body)
        body=functions(source)['Trig_Damage_Engine_FreeContext']
        if 'DmgCtx_PriestShield[c]=null' not in body:body=body.replace('    set DmgCtx_Depth=c-1','    set DmgCtx_PriestShield[c]=null\n    set DmgCtx_Depth=c-1')
        source=put(source,'Trig_Damage_Engine_FreeContext',body)
        body=functions(source)['Trig_Damage_Engine_Step18_FinalModifiers']
        if 'Talent_BlessedRain' not in body:body=body.replace('    if l_amount>.0 then','    if l_amount>.0 and not l_heal and not l_manaDamage and Talent_BlessedRain(t) then\n        set l_amount=l_amount*.9\n    endif\n    if l_amount>.0 then',1)
        source=put(source,'Trig_Damage_Engine_Step18_FinalModifiers',body)
        body=functions(source)['Trig_Damage_Engine_Step19_Apply']
        if 'Talent_AddShield' not in body:
            body=body.replace('            call SetUnitState(t,UNIT_STATE_LIFE,', '            if Talent_PriestChoice(DmgCtx_PriestShield[c],1) and GetWidgetLife(t)>.405 then\n                call Talent_AddShield(t,RMaxBJ(0.,l_amount-RMaxBJ(0.,GetUnitState(t,UNIT_STATE_MAX_LIFE)-GetUnitState(t,UNIT_STATE_LIFE))))\n            endif\n            call SetUnitState(t,UNIT_STATE_LIFE,',1)
            body=body.replace('    // DPS meter for players.','    if l_amount>0. and not l_manaDamage and not l_heal then\n        set l_amount=Talent_AbsorbShield(t,l_amount)\n    endif\n    // DPS meter for players.',1)
        source=put(source,'Trig_Damage_Engine_Step19_Apply',body)
        body=functions(source)['Trig_Damage_Engine_Actions']
        if 'Talent_HolyBolts' not in body:body=body.replace('    else\n        if(l_dmgKind==0)then','    else\n        if l_dmgKind==1 and not udg_IsPhysicalAttack and not udg_IsPureDamage then\n            set l_amount=l_amount*(1.+Talent_HolyBolts(u))\n        endif\n        if(l_dmgKind==0)then',1)
        source=put(source,'Trig_Damage_Engine_Actions',body)
    if native and 'Forsaken_TalentCanPurchase' in fs:
        for name in ['Forsaken_TalentCanPurchase','Forsaken_DrawPanels','Forsaken_UpdatePanels']:
            if name not in functions(source):continue
            body=functions(source)[name].replace('node<6','node<9')
            if name!='Forsaken_TalentCanPurchase':
                marker="                if node>=3 and node<9 then"
                body=body.replace(marker,"                if node>=6 and node<9 then\n                    if column==0 then\n                        set skill='A00G'\n                    elseif column==1 then\n                        set skill='A0OM'\n                    else\n                        set skill='A00M'\n                    endif\n                elseif node>=3 and node<9 then")
            source=put(source,name,body)
    if native and 'Forsaken_PollPanels' in fs:
        source=declarations(source,['framehandle ForsakenHolyBoltsTip=null','framehandle ForsakenHolyBoltsText=null','boolean ForsakenHolyBoltsAttached=false'])
        helper='''function Forsaken_HolyBoltsTooltip takes unit hero,player viewer returns nothing
    local boolean show=hero!=null and IsUnitSelected(hero,viewer) and Talent_PriestChoice(hero,3)
    local framehandle attack=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,3)
    if show then
        call BlzFrameSetText(ForsakenHolyBoltsText,"|cffffcc00Attack|r|nOrders your hero to attack.|n|n|cffffcc00Holy Bolts|r|nBasic-attack damage +"+R2SW(Talent_HealingPower(hero)*100.,1,0)+"% from healing increases. Attack damage type is unchanged.")
    endif
    if show!=ForsakenHolyBoltsAttached then
        if show then
            call BlzFrameSetTooltip(attack,ForsakenHolyBoltsTip)
        else
            call BlzFrameSetTooltip(attack,null)
            call BlzFrameSetVisible(ForsakenHolyBoltsTip,false)
        endif
        set ForsakenHolyBoltsAttached=show
    endif
    set attack=null
endfunction'''
        if 'Forsaken_HolyBoltsTooltip' in functions(source):source=put(source,'Forsaken_HolyBoltsTooltip',helper)
        else:source=source.replace('function Forsaken_PollPanels takes',helper+'\n\nfunction Forsaken_PollPanels takes',1)
        body=functions(source)['Forsaken_PollPanels']
        if 'call Forsaken_HolyBoltsTooltip' not in body:body=body.replace('    call Forsaken_BackpackInputControl(hero,viewer)','    call Forsaken_BackpackInputControl(hero,viewer)\n    call Forsaken_HolyBoltsTooltip(hero,viewer)',1)
        source=put(source,'Forsaken_PollPanels',body)
        body=functions(source)['Register_Forsaken_PanelAccess']
        if 'set ForsakenHolyBoltsTip=' not in body:body=body.replace('    call Forsaken_RegisterBackpackActivity()', '''    call Forsaken_RegisterBackpackActivity()
    set ForsakenHolyBoltsTip=BlzCreateFrame("EscMenuBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetAbsPoint(ForsakenHolyBoltsTip,FRAMEPOINT_BOTTOMRIGHT,.79,.17)
    call BlzFrameSetSize(ForsakenHolyBoltsTip,.24,.105)
    set ForsakenHolyBoltsText=BlzCreateFrameByType("TEXT","HolyBoltsTooltip",ForsakenHolyBoltsTip,"",0)
    call BlzFrameSetPoint(ForsakenHolyBoltsText,FRAMEPOINT_TOPLEFT,ForsakenHolyBoltsTip,FRAMEPOINT_TOPLEFT,.018,-.018)
    call BlzFrameSetSize(ForsakenHolyBoltsText,.216,.081)
    call BlzFrameSetFont(ForsakenHolyBoltsText,"Fonts\\\\FRIZQT__.TTF",.010,0)
    call BlzFrameSetVisible(ForsakenHolyBoltsTip,false)''',1)
        source=put(source,'Register_Forsaken_PanelAccess',body)
        body=functions(source)['Forsaken_RebuildPanels']
        if 'BlzDestroyFrame(ForsakenHolyBoltsTip)' not in body:body=body.replace('    call Forsaken_ResetBackpackControls()', '''    call BlzFrameSetTooltip(BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,3),null)
    call BlzDestroyFrame(ForsakenHolyBoltsTip)
    set ForsakenHolyBoltsTip=null
    set ForsakenHolyBoltsText=null
    set ForsakenHolyBoltsAttached=false
    call Forsaken_ResetBackpackControls()''',1)
        source=put(source,'Forsaken_RebuildPanels',body)
    return source

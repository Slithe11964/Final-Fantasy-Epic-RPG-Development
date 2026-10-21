"""One-second Acid Rain and independently expiring shared shield contributions."""
from pathlib import Path
import re
from jtok import functions
from performance_runtime import put


def refresh(source):
    fs=functions(source)
    if 'Talent_AddShield' in fs:
        fragment=(Path(__file__).resolve().parents[1]/'experiments/Forsaken/PriestShieldChunks.j').read_text()
        helper=functions(fragment)['Talent_ShieldRemove']
        source=re.sub(r'^function Talent_ShieldRemove takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
        source=source.replace('function Talent_ShieldExpire takes',helper+'\n\nfunction Talent_ShieldExpire takes',1)
        for name,body in functions(fragment).items():source=put(source,name,body)
        body=functions(source)['Talents_InitData']
        body=re.sub(r'(set TalentText\[Talent_Index\(job,3,1\)\]=)"[^"\n]*"',lambda m:m[1]+'"Cure, Regen and Tranquility convert 25% of overhealing into a damage shield. Shields stack; each contribution expires separately after 30 seconds. Damage consumes the oldest shield first."',body)
        body=re.sub(r'(set TalentText\[Talent_Index\(job,2,1\)\]=)"[^"\n]*"',lambda m:m[1]+'"Tranquility heals allies and deals magic damage to enemies once per second. Each pulse is half the original per-second healing: 2,000 healing and 2,000 damage at master rank, before modifiers."',body)
        source=put(source,'Talents_InitData',body)
    if 'Priest_RainTick' in fs:
        body=functions(source)['Priest_RainTick']
        # Half of original 0.1-second healing, accumulated for one second.
        body=body.replace('PriestRainHealing[rank]*.5','PriestRainHealing[rank]*5.')
        body=body.replace('PriestRainHealing[rank]*(.5/PriestRainPeriod[rank])','PriestRainHealing[rank]*5.')
        line='                set damagePulse=PriestRainDamageNext[pid]<=.0001'
        extra="\n                if Talent_Active(caster,12,2,1,'A0OM') then\n                    set healPulse=damagePulse\n                endif"
        if extra.strip() not in body:body=body.replace(line,line+extra)
        # A direct healing calculation can leave a failed armor probe armed
        # (e.g. an invulnerable NPC). It must not consume the following enemy hit.
        reset='''                        set udg_DmgArmorProbe=false
                        set udg_DmgFlagManaDamage=false
                        set udg_DmgFlagHealUndead=false
                        set udg_DmgFlagPure=false
                        set udg_IsPhysicalAttack=false
                        set udg_DmgFlagMelee=false
                        set udg_DmgFlagRedirected=false
                        set udg_IgnoresReduction=false
                        set udg_DmgFlagUnavoidable=0
                        set udg_DmgFlagNoCrit=1.
                        set udg_DamageElement=0'''
        if reset not in body:
            body=body.replace('                        set udg_IsPureDamage=false',reset+'\n                        set udg_IsPureDamage=false')
        body=body.replace('PriestRainHealing[rank]*5.,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS',
                          'PriestRainHealing[rank]*5.,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS')
        body=body.replace('if healPulse and IsUnitAlly(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_STRUCTURE) then','if healPulse and IsUnitAlly(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_STRUCTURE) and (not BlzIsUnitInvulnerable(target) or target==Player_GetHero(GetOwningPlayer(target))) then')
        source=put(source,'Priest_RainTick',body)
    if 'Priest_AbilityTalentTip' in fs:
        body=functions(source)['Priest_AbilityTalentTip']
        line='            if Talent_Active(hero,12,2,1,raw) then'
        if 'set amount=PriestRainHealing[rank]*10.' not in body:
            body=body.replace(line,line+'\n                set amount=PriestRainHealing[rank]*10.')
        source=put(source,'Priest_AbilityTalentTip',body)
    if 'SpellCalc_Tooltip' in fs:
        body=functions(source)['SpellCalc_Tooltip']
        body=body.replace('PriestRainHealing[rank]/PriestRainPeriod[rank]*.5','PriestRainHealing[rank]*5.')
        body=re.sub(r'            set tip=tip\+"\|nHealing: "[^\n]*',lambda m:'            set tip=tip+"|nHealing: "+R2SW(amount,1,0)+" base HP every 1 second. Damage: "+R2SW(amount,1,0)+" base magic damage every 1 second."',body)
        body=body.replace('Healing beyond maximum health adds to a damage shield. Expires 30 seconds after the latest addition.','25% of healing beyond maximum health becomes a damage shield. Each contribution expires separately after 30 seconds; damage consumes the oldest first.')
        source=put(source,'SpellCalc_Tooltip',body)
    if 'Trig_Spell_Cure_Actions' in fs:
        # Change only Cure's travelling light; retain impact effects and mechanics.
        source=source.replace(r'Abilities\\Weapons\\WitchDoctorMissile\\WitchDoctorMissile.mdl',
                              r'Abilities\\Weapons\\PriestMissile\\PriestMissile.mdl')
    return source

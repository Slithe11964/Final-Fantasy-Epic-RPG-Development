"""Runtime edits for V37 monster roles and cast paths."""
from pathlib import Path
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parent

def refresh(source):
    fs = functions(source)

    def change(name, old, new):
        nonlocal source
        if name not in fs:
            return
        body = fs[name]
        assert old in body, (name, old)
        fs[name] = body.replace(old, new, 1)
        source = put(source, name, fs[name])

    change('Forest86_Evasion', " if Forest86Data!=null and GetUnitTypeId(u)=='ngnb' and Forest86Now<LoadReal(Forest86Data,GetHandleId(u),22) then\n return 70.\n endif",
           """ if GetUnitTypeId(u)=='nftr' then
 return 20.
 elseif GetUnitTypeId(u)=='ndtr' or GetUnitTypeId(u)=='nrzs' then
 return 30.
 elseif GetUnitTypeId(u)=='nmbg' then
 return 40.
 endif""")
    change('Forest86_Taunt', " if (GetUnitTypeId(caster)=='ngnv' or GetUnitTypeId(caster)=='nsgg' or GetUnitTypeId(caster)=='nhyc' or GetUnitTypeId(caster)=='qI99') then\n set duration=5.\n endif",
           """ if GetUnitTypeId(caster)=='nhyc' then
 set duration=5.
 elseif GetUnitTypeId(caster)=='ncnk' then
 set duration=2.
 elseif GetUnitTypeId(caster)=='nenf' then
 set duration=1.
 endif""")
    change('Forest86_Taunt', """ if duration>3. then
 call M89_Dummy(caster,victim,'xT95',"curse")
 else""", """ if duration>3. then
 call M89_Dummy(caster,victim,'xT95',"curse")
 elseif duration==1. then
 call M89_Dummy(caster,victim,'vT37',"curse")
 elseif duration==2. then
 call M89_Dummy(caster,victim,'vU37',"curse")
 else""")
    change('Forest86_Spell', " elseif raw=='fT86' then\n call Forest86_Taunt(caster)", """ elseif raw=='fT86' and Forest86_Enemy(caster,victim) then
 call V37_Sweep(caster,victim,false)
 elseif raw=='vF37' then
 call V37_Fira(caster,GetSpellTargetX(),GetSpellTargetY())""")
    change('Forest86_Spell', "\n elseif raw=='fN86' and Forest86_Alive(victim) then\n call Forest86_Stun(caster,victim)", '')
    change('Forest86_AI', """ elseif raw=='ngnb' and Forest86_Ready(u,'fT86',25) and (GetUnitX(victim)-GetUnitX(u))*(GetUnitX(victim)-GetUnitX(u))+(GetUnitY(victim)-GetUnitY(u))*(GetUnitY(victim)-GetUnitY(u))<=450.*450. then
 call IssueImmediateOrder(u,"roar")""", """ elseif raw=='ngnb' and Forest86_Ready(u,'fT86',0) and IsUnitInRange(u,victim,400.) then
 call IssueTargetOrder(u,"cripple",victim)""")
    change('Forest86_AI'," if raw=='nfsp' and Forest86_Ready(u,'fH86',10) then", """ if F99_Pool(raw) and not V37_ForestCaster(raw) then
 set u=null
 return
 endif
 if raw=='nfsp' and Forest86_Ready(u,'fH86',10) then""")
    change('B88_AI', """ elseif raw=='nowe' and Forest86_Ready(u,'bT88',0) then
 call IssueImmediateOrder(u,"roar")""",'')
    change('B88_AI', """ elseif raw=='nhrh' and Forest86_Ready(u,'ACcs',40) then
 call IssueTargetOrder(u,"curse",victim)""", """ elseif raw=='nhrh' and Forest86_Ready(u,'vF37',40) then
 call IssuePointOrder(u,"flamestrike",GetUnitX(victim),GetUnitY(victim))""")
    change('B88_Spell', """ elseif raw=='bT88' or raw=='bK88' then
 call Forest86_Taunt(caster)
 if raw=='bT88' then
 call B88_Buff(caster,42,5.)
 else
 call UnitAddAbility(caster,'bA88')
 call B88_Buff(caster,45,15.)
 endif""", """ elseif raw=='bK88' then
 call Forest86_Taunt(caster)
 call UnitAddAbility(caster,'bA88')
 call B88_Buff(caster,45,15.)""")
    change('B88_Spell', """ call B88_Damage(caster,victim,300.,true)
 call SaveUnitHandle(Forest86Data,GetHandleId(victim),48,caster)
 call B88_Buff(victim,47,3.)
 call M89_Dummy(caster,victim,'xB93',"curse")"""," call V37_Sweep(caster,victim,true)")
    change('B88_BuffTick','I2R(BlzGetUnitMaxHP(u))*.01,true','I2R(BlzGetUnitMaxHP(u))*.02,true')
    change('B88_ChargeEnd'," elseif GetUnitTypeId(u)=='nrzg' then\n call B88_Buff", " elseif GetUnitTypeId(u)=='nrzg' then\n call M89_Damage(u,victim,200.,1)\n call B88_Buff")
    change('B88_Thorns',' and B88_Active(target,42)','')
    change('B88_Thorns','amount*.2,false','amount*.3,false')
    for name in ('Forsaken_Stat_GetEvasion','Trig_Damage_Engine_GetEvasion'):
        change(name,'set l_eva=l_eva*.9','set l_eva=l_eva*.75')
    change('C95_Poison','local real amount=10.+6.*I2R(GetUnitLevel(attacker))','local real amount=50.+6.*I2R(GetHeroLevel(victim))')
    change('C95_Poison',' if not HaveSavedReal(Forest86Data,id,11)',""" if raw=='nahy' or raw=='nehy' then
 call V37_Dot(attacker,victim,amount,10,1)
 return
 endif
 if not HaveSavedReal(Forest86Data,id,11)""")
    change('C95_TickUnit',' call C95_Buff(u,42,3.)\n call M89_Dummy(u,u,\'cEV5\',"curse")',' call C95_Buff(u,42,10.)')
    change('C95_Evasion',' if C95_Active(u,42) then\n return 80.\n endif','')
    change('C95_Block',' if physical and C95_Active(u,10) then', ' if physical and C95_Active(u,42) then\n set value=value+25\n endif\n if physical and C95_Active(u,10) then')
    change('N98_Spell'," elseif raw=='nWV8' then", " elseif raw=='nBO8' and Forest86_Enemy(caster,victim) then\n call M89_Projectile(caster,victim,'vW37',1000.,4,false)\n elseif raw=='nWV8' then")
    change('Trig_Damage_Engine_Actions','        call B88_Thorns(u,triggeringUnit,l_amount)', '''        if l_amount>0. and GetUnitAbilityLevel(GetEventDamageSource(),'vW37')>0 then
            call C95_Buff(triggeringUnit,143,10.)
        endif
        if l_dmgKind>=1 and l_dmgKind<=3 and not udg_DmgFlagManaDamage then
            call B88_Thorns(u,triggeringUnit,l_amount)
        endif''')
    change('Trig_Damage_Engine_Step18_FinalModifiers','if B88_Active(t,82) and (l_magical or l_element>0) then','if B88_Active(t,82) and l_element>0 then')
    change('Trig_Damage_Engine_Step18_FinalModifiers','        if B88_Active(u,40) then','        if l_element==4 and C95_Active(t,143) then\n            set l_amount=l_amount*1.25\n        endif\n        if B88_Active(u,40) then')
    change('M89_Spell',""" elseif raw=='mTE9' or raw=='mTV9' then
 call Forest86_Taunt(caster)
 if raw=='mTE9' then
 call M89_Buff(caster,81,10.)
 else
 call M89_Buff(caster,82,15.)
 endif""",""" elseif raw=='mTE9' then
 call Forest86_Taunt(caster)
 call M89_Buff(caster,81,10.)
 elseif raw=='mTV9' then
 call M89_Buff(caster,82,15.)""")
    change('M89_Spell',' call M89_Heal(caster,caster,250.)',' call M89_Heal(caster,caster,500.)')
    change('M89_Spell',' call M89_Area(caster,GetUnitX(caster),GetUnitY(caster),300.,600.,5,true)',' call V37_EarthSlam(caster)')
    change('M89_Spell',""" set udg_TempUnit=caster
 set udg_TempUnit2=victim
 call ExecuteFunc("R93_Firebolt")""", """ call V37_Fx("Abilities\\\\Spells\\\\Other\\\\Tornado\\\\TornadoElementalSmall.mdl",GetUnitX(victim),GetUnitY(victim),0.,1.)
 call M89_Damage(caster,victim,1000.,6)""")
    change('M89_AI','call IssueTargetOrder(u,"firebolt",victim)','call IssueTargetOrder(u,"cyclone",victim)')
    change('H90_Spell',""" if raw=='hTT0' then
 call Forest86_Taunt(caster)
 call H90_Buff(caster,100,5.)
 call IssueImmediateOrder(caster,"stop")
 call SaveBoolean(Forest86Data,id,109,true)
 call PauseUnit(caster,true)
 elseif raw=='hBI0'"""," if raw=='hBI0'")
    change('H90_AI',""" if raw=='nsgg' and Forest86_Ready(u,'hTT0',0) and IsUnitInRange(u,victim,150.) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='narg'"""," if raw=='narg'")
    change('Forest86_Death',' if not IsUnitInGroup(u,Forest86Actors)',""" if GetUnitTypeId(u)=='nsgg' then
 call V37_Deconstruct(u)
 endif
 if not IsUnitInGroup(u,Forest86Actors)""")
    change('F99_Spell',"F99_Summon(caster,'qS99',x+100.,y,60.)","F99_Summon(caster,'qS99',x+100.,y,120.)")
    change('F99_Spell',' call M89_Absorb(caster,target)',' call M89_Absorb(caster,target)\n call UnitAddAbility(caster,\'zIM9\')')
    change('F99_Spell',""" elseif raw=='zIC9' then
 call M89_Area(caster,GetUnitX(target),GetUnitY(target),200.,2000.,2,false)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Undead\\\\FrostNova\\\\FrostNovaTarget.mdl",target,"origin"))
 elseif raw=='zAB9' then
 call M89_Projectile(caster,target,'zQB9',1500.,4,false)""", """ elseif raw=='zIC9' and Forest86_Enemy(caster,target) then
 call V37_Scourge(caster,target)
 elseif raw=='zAB9' and Forest86_Enemy(caster,target) then
 call M89_Projectile(caster,target,'vH37',2000.,0,false)""")
    change('F99_AI',' if D2_FindEnemy(u,2000.)==null then',' if victim==null and D2_FindEnemy(u,2000.)==null then')
    change('F99_AI'," if Forest86_Ready(u,'zDY9',250) then"," if victim!=null and Forest86_Ready(u,'zIM9',100) then\n call IssueTargetOrder(u,\"drunkenhaze\",victim)\n elseif Forest86_Ready(u,'zDY9',250) then")
    change('F99_AI',""" elseif victim!=null and Forest86_Ready(u,'zIM9',100) then
 call IssueTargetOrder(u,"drunkenhaze",victim)""",'')
    change('F99_AI','call IssueTargetOrder(u,"frostnova",victim)','call IssueTargetOrder(u,"acidbomb",victim)')
    change('F99_OnHit','call F99_AddStack(source,target,2,45.)','call F99_AddStack(source,target,2,60.)')
    change('F99_AddStack',""" if kind==1 then
 call M89_Dummy(source,u,'zAM9',"curse")
 elseif kind==2 then
 if count>=15 then
 call F99_ClearStack(u,2)
 call M89_Dummy(source,u,'zST9',"thunderbolt")
 else
 call F99_Dummy(source,u,'zSL9',count,"slow")
 endif
 else""",""" if kind==2 then
 if count>=20 then
 call F99_ClearStack(u,2)
 call V37_Dot(source,u,0.,5,2)
 else
 call SaveBoolean(F99Data,id,3702,true)
 endif
 elseif kind==3 then""")
    change('F99_ExpireStacks',""" elseif kind==2 then
 call F99_Dummy(u,u,'zSL9',count,"slow")""",""" elseif kind==2 then
 call SaveBoolean(F99Data,id,3702,true)""")
    change('F99_TickUnit',' call F99_ExpireStacks(u,2)',""" call F99_ExpireStacks(u,2)
 if LoadBoolean(F99Data,id,3702) then
 call RemoveSavedBoolean(F99Data,id,3702)
 if F99_Count(u,2)>0 then
 call F99_Dummy(u,u,'zSL9',F99_Count(u,2),"slow")
 endif
 endif""")
    change('D2_PoisonAdd','\n call M89_Dummy(source,victim,\'dPB2\',"curse")','')
    change('I2_WaveHit',""" elseif Forest86_Enemy(caster,victim) then
 call M89_Dummy(caster,victim,'jST2',"thunderbolt")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Other\\\\FrostDamage\\\\FrostDamage.mdl",victim,"chest"))""",'')
    change('I2_Spell'," elseif raw=='jCL2' then"," elseif raw=='jRO2' and Forest86_Enemy(caster,victim) then\n call V37_Jump(caster,victim)\n elseif raw=='jCL2' then")
    change('I2_AI',""" elseif raw=='n026' and Forest86_Ready(u,'jRO2',75) then
 call IssueTargetOrder(u,"thunderbolt",victim)""",""" elseif raw=='n026' and Forest86_Ready(u,'jRO2',75) then
 call IssueTargetOrder(u,"clap",victim)""")
    change('M2_AI',' set victim=A19_FindHero(u,800.)',' set ally=A19_FindHero(u,800.)\n if ally!=null then\n set victim=ally\n endif\n set ally=null')
    change('M2_Spell'," if raw=='kLB2' then\n call D5_ForkBreath(caster)"," if raw=='kLB2' or raw=='kOB2' or raw=='kWB2' or raw=='kFB2' then\n call V37_Breath(caster,GetSpellTargetX(),GetSpellTargetY(),raw)")
    change('C20_DragonCast',' or not IsUnitType(target,UNIT_TYPE_HERO)','')
    change('C20_DragonCast',' // Use a native spell on an invisible proxy',""" if point then
 call SetUnitState(caster,UNIT_STATE_MANA,GetUnitState(caster,UNIT_STATE_MANA)-I2R(cost))
 call BlzStartUnitAbilityCooldown(caster,raw,cooldown)
 call V37_Breath(caster,GetUnitX(target),GetUnitY(target),raw)
 return true
 endif
 // Use a native spell on an invisible proxy""")
    change('C20_DragonCast',""" if point then
 set success=IssuePointOrder(proxy,"breathoffire",GetUnitX(target),GetUnitY(target))
 else
 set success=IssueTargetOrder(proxy,"thunderbolt",target)
 endif""",' set success=IssueTargetOrder(proxy,"thunderbolt",target)')
    change('Forest86_Tick',' call ForGroup(Forest86Poisoned,function Forest86_PoisonTick)',' call ForGroup(Forest86Poisoned,function Forest86_PoisonTick)\n call ForGroup(V37Poison,function V37_DotTick)')
    change('Forest86_Init',' set F99Active=CreateGroup()',' set F99Active=CreateGroup()\n set V37Data=InitHashtable()\n set V37Dots=InitHashtable()\n set V37Poison=CreateGroup()')

    if 'F99_AddStack' in fs:
        globals_ = '''    hashtable V37Data=null
    hashtable V37Dots=null
    group V37Poison=null
    integer V37Serial=0
'''
        source=source.replace('endglobals',globals_+'endglobals',1)
        helpers=functions((ROOT/'creature_spells37.j').read_text(encoding='utf-8-sig'))
        dots='\n'.join(helpers.pop(name) for name in ['V37_Dot','V37_DotTick'])
        source=source.replace('function F99_AddStack takes',dots+'\nfunction F99_AddStack takes',1)
        lightning=fs['D5_ForkBreath'].replace('D5_ForkBreath takes unit u','V37_LightningBreath takes unit u,real angle')
        lightning=lightning.replace(' local real angle=Atan2(GetSpellTargetY()-y,GetSpellTargetX()-x)\n','')
        slam=fs['M89_Area'].replace('M89_Area takes unit caster,real x,real y,real radius,real amount,integer element,boolean stun','V37_EarthSlam takes unit caster').replace(' local unit u',' local unit u\n local real x=GetUnitX(caster)\n local real y=GetUnitY(caster)').replace('g,x,y,radius,null','g,x,y,300.,null').replace('caster,u,amount,element','caster,u,600.,5').replace(' if stun then\n call M89_Dummy(caster,u,\'mST9\',"thunderbolt")\n endif',' call M89_Dummy(caster,u,\'vE37\',"thunderbolt")')
        source=source.replace('function C95_Poison takes',lightning+'\n'+slam+'\n'+'\n'.join(helpers.values())+'\nfunction C95_Poison takes',1)
    return source

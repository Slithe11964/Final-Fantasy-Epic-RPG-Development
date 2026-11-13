"""UI41 integration, preserving job/skill identities and the original dragon summon."""
import copy
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from damage_tooltips import merged
from objdata import read_objects,write_objects
from priest_master import setf,fields
from build_thief_daggers import ability

ROOT=Path(__file__).resolve().parents[1]
EYE_ICON='ReplaceableTextures\\CommandButtons\\BTNedricseye.blp'
SKILLS={
 'A11R':('Sonic Thrust','Q',0,2,'channel',1,'BTNValiantCharge.blp',4.,900.,0.,'Charge at your target damaging enemies caught in the path and thrust your spear into the target. The target is intimidated and reduces their ability to evade attacks. The evasion reduction stacks until it gets to 0.|n|n|cffffcc00Damage Calculation|r|n(5 x MP cost + 3 x STR) x (1 + 0.1 x Spear Technique).|nEvasion reduction: 10 per stack; effective evasion cannot fall below 0.'),
 'A03M':('Drakesbane','W',1,2,'sweepingstrike',2,'BTNSweepingStrike.blp',5.,99999.,400.,'Sweep your spear across your enemies dealing moderate damage. Has a high chance to draw out the Life of the Dragon which increases your damage and allows you to cast Rise of the Dragon.|n|n|cffffcc00Damage Calculation|r|n(3 x MP cost + 4 x STR) x (1 + 0.1 x Spear Technique) + max(0, Accuracy - target Evasion).|n180 degree sweep, reach 400. Life: 50% chance per landed cast; guaranteed after 3 failures. Lasts 5 seconds and increases physical damage by 10%.'),
 'A1E6':('Jump','R',3,2,'blizzard',1,'BTNAttackGround.blp',15.,900.,0.,'Leap with all the momentum of a dragon and crash into your target dealing moderate damage.|n|n|cffffcc00Damage Calculation|r|n(MP cost + STR) x 0.02 x (min(1000, starting distance) + 200) x (1 + 0.1 x Spear Technique).|nImpact diameter: 200 (radius 100).'),
 'A14D':('Rise of the Dragon','T',3,1,'flamestrike',2,'BTNDragonRoost.blp',90.,800.,300.,'Use the Life of the Dragon to erupt an area with overwhelming fire dealing high fire damage in an area. Enemies that are unable to evade attacks take more damage.|n|n|cffffcc00Damage Calculation|r|nFire damage: (4 x MP cost + 4 x STR) x (1 + 0.1 x Spear Technique) + max(0, Accuracy - target Evasion).|n50% extra damage below 30% HP. Radius: 300. Stun: 1.5 seconds. Requires and consumes Life of the Dragon.'),
}

def mana_cost(raw,level):
    if raw in ['A11R','A03M']:return 150
    if raw=='A14D':return (460,580,700,820,940,1200)[max(0,min(5,level-1))]
    return 300 if level>=11 else 40+20*level

def rename_text(source):
    return re.sub(r'"(?:\\.|[^"\\])*"',lambda m:re.sub(r'\bLancer(s)?\b',lambda x:'Dragoon'+(x[1] or ''),m[0]),source)

def refresh(source):
    fs=functions(source)
    if 'Trig_Damage_Engine_GetEvasion' in fs:
        core=(ROOT/'experiments/Dragoon/DragoonRPG.j').read_text()
        header=source.splitlines()[0]
        if 'TCooldown' not in header:source=source.replace(header,header+', TCooldown',1)
        ui=(ROOT/'experiments/Dragoon/DragoonUI.j').read_text()
        cf=functions(core)
        declarations=''
        for fragment in [core,ui]:declarations+=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
        source=source.replace('endglobals',declarations+'endglobals',1)
        anchor='function Trig_Damage_Engine_GetEvasion takes'
        early='\n\n'.join(cf[name] for name in ['DG_Alive','DG_Reduction'])
        source=source.replace(anchor,early+'\n\n'+anchor,1)
        remaining='\n\n'.join(body for name,body in cf.items() if name not in ['DG_Alive','DG_Reduction'])
        uif='\n\n'.join(functions(ui).values())
        source=source.replace('function Trig_Damage_Engine_RollMiss takes',uif+'\n\n'+remaining+'\n\nfunction Trig_Damage_Engine_RollMiss takes',1)
        name='Trig_Damage_Engine_GetEvasion';body=functions(source)[name].replace('return l_eva','return RMaxBJ(0.,l_eva-DG_Reduction(u))');source=put(source,name,body)
        # Eye of the Dragon replaces the old ranged distance damage multiplier.
        for name,body in list(functions(source).items()):
            edited=re.sub(r"^        if\((?:GetUnitAbilityLevel|Forsaken_ElementAbilityLevel)\(u,'A11T'\)>0\)then.*?^        endif\n",'',body,flags=re.S|re.M)
            if edited!=body:source=put(source,name,edited)
        name='Trig_Damage_Engine_RollMiss';body=functions(source)[name]
        for buff in ['B00P','B02V']:
            body=re.sub(r"((?:GetUnitAbilityLevel|Forsaken_ElementAbilityLevel)\(l_attacker,'"+buff+r"'\)>0)",r"\1 and GetUnitAbilityLevel(l_attacker,'A11T')<=0",body)
        source=put(source,name,body)
        name='Trig_Damage_Engine_Step12_PhysicalSkills'
        body=functions(source)[name].replace('if(l_physical and l_amount>.0)then', 'if(l_physical and l_amount>.0)then\n        if GetPlayerId(GetOwningPlayer(u))<8 and DG_Hero[GetPlayerId(GetOwningPlayer(u))]==u and DG_Life[GetPlayerId(GetOwningPlayer(u))]>DG_Now then\n            set l_amount=l_amount*1.1\n        endif',1)
        source=put(source,name,body)
        name='RegisterTriggers_Damage';source=put(source,name,functions(source)[name].replace('endfunction','    call DG_Init()\nendfunction'))
    if 'Trig_Lancer_DragonBreath_IsCastAbility' in fs:
        source=put(source,'Trig_Lancer_DragonBreath_IsCastAbility',"function Trig_Lancer_DragonBreath_IsCastAbility takes nothing returns boolean\n return GetSpellAbilityId()=='A0SL'\nendfunction")
        for name in ['Trig_Lancer_DragonSlam_Conditions','Trig_Lancer_Jump_Conditions','Trig_Lancer_Jump_RangeCheck_Conditions']:
            source=put(source,name,'function '+name+' takes nothing returns boolean\n return false\nendfunction')
    if 'Trig_Passive_Bonus_Sync_NeedsAttackSpeedBonus' in fs:
        name='Trig_Passive_Bonus_Sync_NeedsAttackSpeedBonus'
        source=put(source,name,'function '+name+' takes nothing returns boolean\n return false\nendfunction')
    if 'Trig_Cooldown_Scaling_Conditions' in fs:
        name='Trig_Cooldown_Scaling_Conditions';body=functions(source)[name]
        guard=" and GetSpellAbilityId()!='A11R' and GetSpellAbilityId()!='A03M' and GetSpellAbilityId()!='A1E6' and GetSpellAbilityId()!='A14D'"
        body=re.sub(r'(^[ \t]*return[^\n]*?)([ \t]*//[^\n]*)?$',lambda m:m[1].rstrip()+guard+(' '+m[2].lstrip() if m[2] else ''),body,flags=re.M)
        source=put(source,name,body)
    if 'Forsaken_Stat_GetEvasion' in fs:
        name='Forsaken_Stat_GetEvasion';body=functions(source)[name]
        body=body.replace('    return l_eva',"    if DG_Data!=null and LoadUnitHandle(DG_Data,GetHandleId(u),0)==u and GetWidgetLife(u)>.405 then\n        set l_eva=l_eva-LoadReal(DG_Data,GetHandleId(u),1)\n    endif\n    return RMaxBJ(0.,l_eva)")
        source=put(source,name,body)
        for buff in ['B00P','B02V']:
            source=source.replace("Forsaken_StatAbilityLevel(hero,'"+buff+"')>0", "(Forsaken_StatAbilityLevel(hero,'"+buff+"')>0 and GetUnitAbilityLevel(hero,'A11T')<=0)")
    if 'Stats_Stat_GetEvasion' in fs:
        name='Stats_Stat_GetEvasion';source=put(source,name,functions(source)[name].replace('return l_eva','return RMaxBJ(0.,l_eva-DG_Reduction(u))'))
        for raw in ['B00P','B02V']:
            source=source.replace("GetUnitAbilityLevel(hero,'"+raw+"')>0", "(GetUnitAbilityLevel(hero,'"+raw+"')>0 and GetUnitAbilityLevel(hero,'A11T')<=0)")
    if 'Trig_Oracle_Blind_TargetIsBlindproof' in fs:
        name='Trig_Oracle_Blind_TargetIsBlindproof';body=functions(source)[name].replace("return(","return(GetUnitAbilityLevel(GetSpellTargetUnit(),'A11T')>0)or(",1);source=put(source,name,body)
    if 'Trig_Status_AutoCleanse_HasBlindproof' in fs:
        name='Trig_Status_AutoCleanse_HasBlindproof';body=functions(source)[name].replace('return(',"return(GetUnitAbilityLevel(GetEnumUnit(),'A11T')>0)or(",1);source=put(source,name,body)
        name='Trig_Status_AutoCleanse_CleanseEnum';body=functions(source)[name].replace("call UnitRemoveBuffBJ('B00P',GetEnumUnit())","call UnitRemoveBuffBJ('B00P',GetEnumUnit())\n        call UnitRemoveAbility(GetEnumUnit(),'B02V')");source=put(source,name,body)
    # Prevent the periodic spell calculator from restoring obsolete Lancer text.
    for raw,spec in SKILLS.items():
        desc=spec[-1]
        source=re.sub(r"call SaveStr\(SpellCalcData,'"+raw+r"',(\d+),\"(?:\\.|[^\"\\])*\"\)",lambda m:'call SaveStr(SpellCalcData,\''+raw+'\','+m[1]+',"'+(desc if int(m[1])<100 else '')+'")',source)
    return rename_text(source)

def patch_objects(archive):
    resolved=merged(archive.read('war3map.w3a'),archive.read('war3mapSkin.w3a'),'w3a')
    replacements={}
    for raw,spec in SKILLS.items():
        name,key,x,y,order,target,icon,cd,cast_range,area,tip=spec
        old=fields(resolved[raw]);levels=old.get(('alev',0),1)
        new=ability(raw,name,key,x,y,order,target,'ReplaceableTextures\\CommandButtons\\'+icon,tip)
        for field in ['aher','arlv','alsk','alev']:
            if (field,0) in old:setf(new,field,old[field,0])
        setf(new,'ansf','[Dragoon]');setf(new,'arhk',key);setf(new,'arpx',x);setf(new,'arpy',y)
        setf(new,'arar','ReplaceableTextures\\CommandButtons\\'+icon)
        setf(new,'aret','Learn '+name+' (|cffffcc00'+key+'|r) - [Level %d]');setf(new,'arut',tip)
        if raw=='A03M':
            new['base']='AHsw'
            for entry in new['sets']:entry['mods']=[m for m in entry['mods'] if not m['field'].startswith('Ncl')]
        if raw=='A11R':setf(new,'aani','walk')
        elif raw=='A1E6':setf(new,'aani','stand ready')
        for level in range(1,levels+1):
            for k,v in {'acdn':cd,'amcs':mana_cost(raw,level),'aran':cast_range,'aare':area,'acas':0.,'adur':0.,'ahdu':0.,'abuf':'','aub1':tip,'atp1':name+' (|cffffcc00'+key+'|r) - ['+('Level '+str(level) if level<levels else '|cffffcc00MASTER|r')+']'}.items():setf(new,k,v,level)
            if raw=='A03M':
                for k,v,data in [('swp1',0.,1),('swp2',400.,0),('swp3',180.,2),('swp4',.1,3),('swp5',0,4),('swp6',0.,5),('swp7',0,6),('swp8',0.,7),('swp9',0,8),('swpa',0.,9),('swpb',0.,10),('swpe',0.,11),('swpf',0.,12),('swpg',0.,13),('swph',0.,14)]:setf(new,k,v,level,data=data)
                for k,v in [('swpc',0.),('swpd',0.)]:setf(new,k,v,level)
            else:
                for k,v,data in [('Ncl1',0.,1),('Ncl2',target,2),('Ncl3',19 if raw=='A14D' else 17,3),('Ncl4',0.,4),('Ncl5',0,5),('Ncl6',order,6)]:setf(new,k,v,level,data=data)
        replacements[raw]=new
    for raw in ['A11S','A11T']:
        new=copy.deepcopy(resolved[raw])
        for k,v in {'anam':'Eye of the Dragon','aart':EYE_ICON,'atp1':'Eye of the Dragon','aub1':'The Dragoon is enhanced by his affinity with dragons and immune to the blind status.','Eev1':0.}.items():setf(new,k,v,1 if k in ['atp1','aub1','Eev1'] else 0)
        replacements[raw]=new
    summon=copy.deepcopy(resolved['A14G'])
    setf(summon,'ahky','E');setf(summon,'abpx',2);setf(summon,'abpy',2);setf(summon,'arhk','E')
    setf(summon,'aret','Learn Dragon Ally (|cffffcc00E|r) - [Level %d]')
    for st in summon['sets']:
        for mod in st['mods']:
            if mod['type']==3:mod['value']=mod['value'].replace('|cffffcc00E|r','|cffffcc00E|r')
    summon_levels=fields(summon).get(('alev',0),11)
    for level in range(1,summon_levels+1):
        setf(summon,'atp1','Dragon Ally (|cffffcc00E|r) - ['+('Level '+str(level) if level<summon_levels else '|cffffcc00MASTER|r')+']',level)
        oldtip=fields(summon).get(('aub1',level),'Summon a dragon ally to fight at your side.')
        if 'Damage' not in oldtip:oldtip+='|n|n|cffffcc00Damage Calculation|r|nUses the summoned dragon\'s attack damage and the original ranked Dragon Ally scaling.'
        setf(summon,'aub1',oldtip,level)
    replacements['A14G']=summon
    assert 'dGSt' not in resolved
    stun={'base':'AHtb','id':'dGSt','sets':[{'flag':0,'mods':[]}]}
    for k,v in {'anam':'Dragoon Rise stun','aher':0,'alev':1,'aart':'','acat':'','atat':'','amat':'','aani':''}.items():setf(stun,k,v)
    for k,v in {'Htb1':0.,'adur':1.5,'ahdu':1.5,'amcs':0,'acdn':0.,'aran':99999.,'atar':'air,ground,enemy,organic,mechanical'}.items():setf(stun,k,v,1,data=1 if k=='Htb1' else 0)
    replacements['dGSt']=stun
    life={'base':'Ablo','id':'dGLf','sets':[{'flag':0,'mods':[]}]}
    for k,v in {'anam':'Life of the Dragon status','aher':0,'alev':1}.items():setf(life,k,v)
    for k,v in {'Blo1':0.,'Blo2':0.,'Blo3':0.,'adur':5.,'ahdu':5.,'amcs':0,'acdn':0.,'aran':99999.,'abuf':'BdGL','atar':'friend,self,air,ground,organic,mechanical'}.items():setf(life,k,v,1)
    replacements['dGLf']=life
    files={}
    for file in ['war3map.w3a','war3mapSkin.w3a']:
        table=read_objects(archive.read(file),'w3a')
        if file=='war3map.w3a':
            table['custom']=[replacements.get(o['id'],o) for o in table['custom']]+[stun,life]
        else:table['custom']=[o for o in table['custom'] if o['id'] not in replacements]
        files[file]=write_objects(table,table['version'],'w3a')
    units=merged(archive.read('war3map.w3u'),archive.read('war3mapSkin.w3u'),'w3u');hero=copy.deepcopy(units['H00C'])
    f=fields(hero)
    for k,v in {'unam':'Dragoon','upro':'Dragoon','umdl':'Units\\Human\\CityGuard\\CityGuard.mdl','ucpt':0.,'ua1w':'normal','ua1r':100.,'ua1m':'','ucs1':'MetalMediumSlice','uabi':f['uabi',None]+',A0RA','utip':'Change job to: |cffffcc00Dragoon','utub':'Melee spellcaster who fights with spear techniques and a dragon ally.|n|n|cffff4080Requirements|r: Level 8 Geomancer, Level 8 Thief|n|n|cff00ff00Weapon|r: Spear|n|cff00ff00Armor|r: Plate Armor|n|cff00ff00Special|r: Eye of the Dragon|n|n|cffff8040Abilities|r: Sonic Thrust, Drakesbane, Dragon Ally, Jump and Rise of the Dragon'}.items():setf(hero,k,v,None)
    setf(hero,'utub',fields(hero)['utub',None]+'|n|n|cff8040ffTier 5 Strength Warrior|r',None)
    unit_changes={'H00C':hero}
    for raw,obj in units.items():
        f=fields(obj)
        desc=f.get(('utub',None),'')
        if 'Thievery' in desc:
            clone=copy.deepcopy(obj);setf(clone,'utub',desc.replace('Thievery','1000 Cuts'),None);unit_changes[raw]=clone

    for unit_id,skill in [('n05G','A11R'),('n05F','A03M'),('n05I','A1E6')]:
        proxy=copy.deepcopy(units[unit_id]);spec=SKILLS[skill]
        for k,v in {'unam':spec[0],'utip':spec[0],'utub':spec[-1],'uico':'ReplaceableTextures\\CommandButtons\\'+spec[6]}.items():setf(proxy,k,v,None)
        unit_changes[unit_id]=proxy
    for file in ['war3map.w3u','war3mapSkin.w3u']:
        table=read_objects(archive.read(file),'w3u')
        if file=='war3map.w3u':table['custom']=[unit_changes.get(o['id'],o) for o in table['custom']]
        else:table['custom']=[o for o in table['custom'] if o['id'] not in unit_changes]
        files[file]=write_objects(table,table['version'],'w3u')
    buff={'base':'Bblo','id':'BdGL','sets':[{'flag':0,'mods':[]}]}
    for k,v in {'fnam':'Life of the Dragon','ftip':'Life of the Dragon','fube':'Physical damage increased by 10%. Rise of the Dragon is available.','fart':EYE_ICON,'ftat':'','fta0':''}.items():setf(buff,k,v)
    table=read_objects(archive.read('war3map.w3h'),'w3h');table['custom'].append(buff)
    files['war3map.w3h']=write_objects(table,table['version'],'w3h')
    return files

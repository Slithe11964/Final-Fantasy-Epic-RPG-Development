"""Dragoon-only spear balance, gameplay and matching UI text, based on QuickUI78."""
import copy,hashlib,json,re,subprocess
from pathlib import Path
from editor_pair import View,runtime_for
from order_libraries import order
from jtok import functions,tokens
from performance_runtime import put
from objdata import read_objects,write_objects
from priest_master import fields,setf
from damage_tooltips import merged
from downgrade import wts_read,wts_write
from wct import text_of,raw_of,write_wct
from mpq import MPQ,write_files,compact
from add_header import read_header,build_header
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI78/FFERPG-QuickUI78.w3x'
OUT=ROOT/'release/development/QuickUI79/FFERPG-QuickUI79.w3x'
# raw: name, damage, accuracy, physical bonus, element, element bonus, extra
SPEARS={
'I0FO':('Short Lance',120,20,.10,0,0.,''),
'I00M':('Poison Spear',180,20,.10,0,0.,'Normal attacks poison enemies.'),
'I0JY':('Heroic Lance',360,25,.10,0,0.,''),
'I0L6':('Shimmering Spear',500,40,.20,0,0.,''),
'I033':('Trident',560,50,0.,4,.25,'Attacks deal Water-elemental damage.'),
'I0F6':('Wildfire Spear',600,50,0.,1,.25,'Attacks deal Fire-elemental damage.'),
'I060':('Halberd of Justice',450,75,.30,0,0.,'Increases Strength by 80.'),
'I05S':('Holy Lance',600,80,0.,0,0.,'Increases all stats by 25. Adds 50% of total healing effectiveness as physical damage (100% healing effectiveness grants +50% physical damage).'),
'I07Z':('Zodiac Spear',800,100,.50,0,0.,''),
'I0D1':('Storm Lance',750,80,0.,3,.50,'Attacks deal Thunder-elemental damage and may Shock enemies.'),
'I0LB':('Longinus',1000,125,.60,0,0.,''),
}
ACC={'A19E':20,'A19G':25,'A19F':40,'A19H':50,'A1A1':75,'A19J':80,'A19I':100,'A19D':125}

def resolve(s,w):return w.get(int(s[8:]),s) if isinstance(s,str) and s.startswith('TRIGSTR_') else s

def objects(v,w):
    items=merged(v.archive.read('war3map.w3t'),v.archive.read('war3mapSkin.w3t'),'w3t')
    aliases={}
    for raw,o in items.items():
        name=re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',resolve(fields(o).get(('unam',None),''),w))
        for base,spec in SPEARS.items():
            if name==spec[0]:aliases[raw]=base
    assert all(raw in aliases for raw in SPEARS)
    files={}
    for ext in ['w3t','w3a','w3h']:
      for prefix in ['war3map','war3mapSkin']:
        file=prefix+'.'+ext;data=v.archive.read(file)
        if not data:continue
        t=read_objects(data,ext)
        for o in t['original']+t['custom']:
          raw=o['id'] or o['base'];f=fields(o)
          if ext=='w3t' and raw in aliases:
            spec=SPEARS[aliases[raw]];name,dmg,acc,phys,element,boost,extra=spec
            old=resolve(f.get(('utub',None),''),w)
            suffix=old[old.index('|n|n'): ] if '|n|n' in old else old[old.index('|n|cffffcc00Information'): ] if '|n|cffffcc00Information' in old else old[old.index('|n|cffffcc00Required'): ] if '|n|cffffcc00Required' in old else ''
            tip=f'Increases damage by {dmg} and accuracy by {acc}.'
            if phys:tip+=f' Increases physical damage by {round(phys*100)}%.'
            if element:tip+=f' Increases { {1:"Fire",3:"Thunder",4:"Water"}[element]} damage by {round(boost*100)}%.'
            if extra:tip+=' '+extra
            setf(o,'utub',tip+suffix,None)
            if ('iabi',None) in f:
                ab=f['iabi',None].split(',')
                if aliases[raw]=='I00M' and 'A19E' not in ab:ab.append('A19E')
                if aliases[raw]=='I060':ab=[x for x in ab if x!='A0OD']
                if aliases[raw]=='I05S':ab=[x for x in ab if x!='A0WQ']
                setf(o,'iabi',','.join(ab),None)
          if ext=='w3a':
            if raw=='A1CP':setf(o,'Iatt',800,1,data=1);setf(o,'ansf','(+800)')
            if raw in ACC:setf(o,'ansf',f'[+{ACC[raw]} ACC]'+(' [Axe/Spear Hybrid]' if raw=='A1A1' else ''))
            if raw in ['A11R','A1E6','A03M','dGLf']:
              for st in o['sets']:
                for m in st['mods']:
                  if m['field']=='acdn' and raw in ['A11R','A1E6']:m['value']=20. if raw=='A11R' else 30.
                  if raw=='dGLf' and m['field'] in ['adur','ahdu']:m['value']=15.
                  if isinstance(m['value'],str):m['value']=spelltext(resolve(m['value'],w))
          if ext=='w3h' and raw=='BdGL':
            setf(o,'fube','Physical damage increased by 10% for 15 seconds. Rise of the Dragon is available.',None)
            for st in o['sets']:
              for m in st['mods']:
                if isinstance(m['value'],str):m['value']=spelltext(resolve(m['value'],w))
        if ext=='w3a' and prefix=='war3map':
          assert not any(o['id']=='sM80' for o in t['custom'])
          mana={'base':'AIrm','id':'sM80','sets':[{'flag':0,'mods':[]}]}
          for k,val in {'anam':'Spear proficiency mana regeneration','alev':2,'aite':0,'aart':'','abpy':-11,'abpx':0}.items():setf(mana,k,val)
          for level in [1,2]:setf(mana,'Imrp',0.,level,data=1)
          t['custom'].append(mana)
        files[file]=write_objects(t,t['version'],ext)
    return files,aliases

def spelltext(s):
    return s.replace('0.02 x (min(1000, starting distance) + 200)','0.01 x (min(1000, starting distance) + 200)').replace('Impact diameter: 200 (radius 100).','Impact radius: 200 (diameter 400).').replace('Lasts 5 seconds and increases physical damage','Lasts 15 seconds and increases physical damage').replace('180 degree sweep, reach 400.','180 degree sweep, reach 400. Damage uses your current attack element.')

HELPERS='''
function Spear80_PhysicalBonus takes unit hero returns real
 local integer slot=0
 local integer raw
 local real bonus=0.
 local item gear
 loop
 exitwhen slot>=15
 set gear=Forsaken_ActiveGear(hero,slot)
 if gear!=null and (slot>=6 or BlzGetItemEquipmentType(gear)==EQUIPMENT_TYPE_NONE) then
 set raw=LoadInteger(ForsakenElementSources,80,GetItemTypeId(gear))
 PHYSICAL_CASES
 endif
 set slot=slot+1
 endloop
 set gear=null
 return bonus
endfunction
function Spear80_ElementBonus takes unit hero,integer element returns real
 local integer slot=0
 local integer raw
 local real bonus=0.
 local item gear
 loop
 exitwhen slot>=15
 set gear=Forsaken_ActiveGear(hero,slot)
 if gear!=null and (slot>=6 or BlzGetItemEquipmentType(gear)==EQUIPMENT_TYPE_NONE) then
 set raw=LoadInteger(ForsakenElementSources,80,GetItemTypeId(gear))
 ELEMENT_CASES
 endif
 set slot=slot+1
 endloop
 set gear=null
 return bonus
endfunction
'''
MANA='''function Spear80_SyncMana takes unit hero returns nothing
 local integer prof
 local ability regen
 if hero==null or GetUnitTypeId(hero)==0 then
 return
 endif
 set prof=Prof_GetLevel(hero,'R009')
 if prof<=0 then
 if GetUnitAbilityLevel(hero,'sM80')>0 then
 call UnitRemoveAbility(hero,'sM80')
 endif
 if HaveSavedInteger(ForsakenElementSources,81,GetHandleId(hero)) then
 call RemoveSavedInteger(ForsakenElementSources,81,GetHandleId(hero))
 endif
 return
 endif
 if GetUnitAbilityLevel(hero,'sM80')==0 or LoadInteger(ForsakenElementSources,81,GetHandleId(hero))!=prof then
 call UnitAddAbility(hero,'sM80')
 call UnitMakeAbilityPermanent(hero,true,'sM80')
 set regen=BlzGetUnitAbility(hero,'sM80')
 call BlzSetAbilityRealLevelField(regen,ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL,0,.1*I2R(prof))
 call BlzSetAbilityRealLevelField(regen,ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL,1,.1*I2R(prof))
 call SetUnitAbilityLevel(hero,'sM80',2)
 call SetUnitAbilityLevel(hero,'sM80',1)
 call SaveInteger(ForsakenElementSources,81,GetHandleId(hero),prof)
 endif
 set regen=null
endfunction
'''

def refresh(s,aliases):
    fs=functions(s)
    for n,b in list(fs.items()):
      new=spelltext(b)
      if n in ['Trig_Damage_Engine_GetAccuracy','Forsaken_Stat_GetAccuracy','Stats_Stat_GetAccuracy']:
        for raw,acc in ACC.items():
          pattern=r"(if\([^\n]*'"+raw+r"'[^\n]*\)then[^\n]*\n\s*set l_acc=l_acc\+)\d+\."
          new=re.sub(pattern,lambda m:m[1]+str(acc)+'.',new)
      if n=='DG_BaseDamage':new=new.replace('*.02*(RMinBJ','*.01*(RMinBJ')
      if n=='DG_Area':
        new=new.replace('elseif kind==4 then\n set radius=100.','elseif kind==4 then\n set radius=200.').replace('DG_Life[p]=DG_Now+5.','DG_Life[p]=DG_Now+15.')
      if n=='DG_Cast':new=new.replace('set duration=4.','set duration=20.').replace('set duration=15.','set duration=30.')
      if n=='DG_Deal':
        # Only Drakesbane inherits attack element; Sonic/Jump/Rise remain untouched.
        new=new.replace('boolean technique returns','boolean technique, integer kind returns').replace(' set udg_DamageElement=0',' set udg_DamageElement=0\n if kind==2 then\n set udg_DamageElement=Element_GetOfUnit(caster,true)\n endif',1)
      if n=='DG_Area':new=new.replace('DG_Deal(caster,target,amount,kind!=3)','DG_Deal(caster,target,amount,kind!=3,kind)')
      if n=='Trig_Damage_Engine_Step12_PhysicalSkills':new=new.replace('if(l_physical and l_amount>.0)then','if(l_physical and l_amount>.0)then\n        set l_amount=l_amount*(1.+Spear80_PhysicalBonus(u))',1)
      if n=='Forsaken_StatOutgoing':new=new.replace('    return (mult-1.)*100.','    if physical then\n        set mult=mult*(1.+Spear80_PhysicalBonus(hero))\n    endif\n    return (mult-1.)*100.')
      if n in ['Trig_Damage_Engine_GetElementBonus','Forsaken_Stat_GetElementBonus']:
        new=new.replace('    return l_bonus','    return l_bonus+Spear80_ElementBonus(u,l_element)',1)
      if n=='Trig_Damage_Engine_RollBlock':
        new=new.replace('boolean l_magical returns','boolean l_magical, integer reduction returns')
        new=new.replace('GetRandomInt(1,$A)<=3','GetRandomInt(1,100)<=30-reduction')
        lines=[]
        for line in new.splitlines():
          if "GetRandomInt(1,'d')<=" in line:
            left,sep,right=line.partition('//');i=left.rfind(')then');assert i>=0
            left=left[:i]+'-reduction'+left[i:];line=left+(sep+right if sep else '')
          lines.append(line)
        new='\n'.join(lines)
      if n=='Trig_Damage_Engine_CheckBlock':
        new=new.replace('local integer l_prof','local integer l_prof\n    local integer reduction=Prof_GetLevel(u,\'R009\')',1)
        new=new.replace('RollBlock(t,l_physical,l_magical)','RollBlock(t,l_physical,l_magical,reduction)').replace('RollBlock(t,true,false)','RollBlock(t,true,false,reduction)')
      if n=='Register_Forsaken_Equipment':
        extra=''
        for raw,base in aliases.items():extra+=f"    call SaveInteger(ForsakenElementSources,80,'{raw}','{base}')\n"
        for raw in ['I033','I0D1']:
          for alias,base in aliases.items():
            if base==raw:
              new=re.sub(r"(SaveInteger\(ForsakenElementSources,41,'"+alias+r"',)\d+",lambda m:m[1]+str(SPEARS[raw][2]),new)
        # Holy Lance loses its old regen effect in the authored UI lookup too.
        holy={raw for raw,base in aliases.items() if base=='I05S'}
        for raw in holy:
          new=re.sub(r"^.*SaveInteger\(ForsakenRegenData,'"+raw+r"',100[01],[^\n]*\n",'',new,flags=re.M)
        new=new.replace('endfunction',extra+'endfunction')
      if n=='Forsaken_PrepareInventories':new=new.replace('call Inventory71_Reconcile(hero,i)','call Inventory71_Reconcile(hero,i)\n        call Spear80_SyncMana(hero)')
      if n=='Forsaken_ReadRegeneration':new=new.replace('set ForsakenMPRegen=mp*(1.+ForsakenMPPercent)+mpAura',"set ForsakenMPRegen=mp*(1.+ForsakenMPPercent+.1*I2R(Prof_GetLevel(hero,'R009')))+mpAura")
      if new!=b:s=put(s,n,new)
    if 'Prof_GetLevel' in fs:
      phys=[];elems=[]
      for raw,(_,_,_,bonus,element,boost,_) in SPEARS.items():
        if bonus:phys+= [f" if raw=='{raw}' then",f' set bonus=bonus+{bonus}', ' endif']
        if raw=='I05S':phys += [" if raw=='I05S' then",' set bonus=bonus+.5*(1.+Talent_HealingPower(hero))',' endif']
        if element:elems += [f" if raw=='{raw}' and element=={element} then",f' set bonus=bonus+{boost}',' endif']
      s+=HELPERS.replace('PHYSICAL_CASES','\n'.join(phys)).replace('ELEMENT_CASES','\n'.join(elems))
      # Helpers must remain inside the editor library.
      s=s.replace('endlibrary','',1)+'\nendlibrary\n'
    if 'Forsaken_PrepareInventories' in fs:s=s.replace('function Inventory71_Reconcile takes',MANA+'\nfunction Inventory71_Reconcile takes',1)
    return s

def build():
    assert not OUT.exists(),'Preserve previous candidate'
    v=View(BASE);w=wts_read(v.archive.read('war3map.wts'));files,aliases=objects(v,w)
    modules={lib:refresh(s,aliases) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]}
    assert changed=={'TDamage','TProf','TEquip','TRegen'},changed
    runtime,_=order(runtime_for(v,v,v,modules));runtime=re.sub(r'\n{3,}','\n\n',runtime)
    for i,raw in enumerate(v.wct['entries']):
      m=re.match(r'\s*library (\w+)',text_of(raw))
      if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
    for i,s in list(w.items()):
      if 'Spear is used by' in s and 'Proficiency Bonus:' in s:
        w[i]=s.replace('Lancer','Dragoon').replace('Greatly increases the power of Dragon Techniques.','Increases mana regen and reduces enemies chance to block.')
    label='FFERPG QuickUI79 (Dragoon)';w[38788]=label
    files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
    OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
    result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True)
    print(result.stdout[-2500:]);print(result.stderr);assert result.returncode==0
    temp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(temp),files);compact(str(temp),str(OUT))
    _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    archive=MPQ(str(OUT))
    for name in v.archive.read('(listfile)').decode().splitlines():
      if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert archive.read(name)==files.get(name,v.archive.read(name)),name
    before,after=functions(v.runtime),functions(runtime)
    report=dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),new_functions=sorted(after.keys()-before.keys()),spears=SPEARS,aliases=aliases,compile='PASS',archive_readback='PASS',acceptance='Native gameplay/multiplayer testing pending. Bag cross-close remains confirmed and unresolved. No new timer, local UI callback, F/G, inventory targeting or bag changes.')
    OUT.with_suffix('.json').write_text(json.dumps(report,indent=2));print(OUT)
if __name__=='__main__':build()

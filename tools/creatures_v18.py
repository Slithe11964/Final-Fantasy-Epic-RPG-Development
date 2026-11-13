"""Highroad balance, forest spider removal, no stack badges, innate mastery."""
import re,copy
from jtok import functions
from performance_runtime import put
from build_removals91 import pool_blocks
from priest_master import fields,setf
from build_forest86 import all_objects

CHOICES={5:'A0T9',6:'A0P9',7:'A0PA',8:'A0RF',9:'A0RG'}

def mastery(s):
 fs=functions(s)
 if 'Forsaken_ElementAbilityLevel' not in fs:return s
 b=fs['Forsaken_ElementAbilityLevel'];marker='    if holder!=Player_GetHero(GetOwningPlayer(holder))'
 assert marker in b
 clauses=' or '.join("(GetUnitAbilityLevel(holder,'A02F')==%d and raw=='%s')"%(rank,raw) for rank,raw in CHOICES.items())
 b=b.replace(marker,'''    // The shrine's selected Legendary bonus is innate, not a worn item.
    if rank>0 and ('''+clauses+''') then
        return rank
    endif
'''+marker,1)
 return put(s,'Forsaken_ElementAbilityLevel',b)

def refresh(lib,s,dev=False):
 s=mastery(s)
 if not dev:return s
 fs=functions(s)
 if 'Trig_Spawn_Pools_Init_Actions' in fs:
  b=fs['Trig_Spawn_Pools_Init_Actions'];removed=0
  for m,day,zone in reversed(list(pool_blocks(b))):
   if zone!=1:continue
   block,count=re.subn(r"(?m)^\s*call UnitPoolAddUnitType\(l_pool,'nspb',[^\n]+\n?",'',m[0]);removed+=count
   b=b[:m.start()]+block+b[m.end():]
  assert removed==1,removed
  s=put(s,'Trig_Spawn_Pools_Init_Actions',b)
 if 'Forest86_Pool' in fs:
  b=fs['Forest86_Pool'];assert " or raw=='nspb'" in b
  s=put(s,'Forest86_Pool',b.replace(" or raw=='nspb'",'',1))
 if 'H90_Whirl' in fs:
  b=fs['H90_Whirl'];assert 'B88_Damage(caster,u,500.,true)' in b
  s=put(s,'H90_Whirl',b.replace('B88_Damage(caster,u,500.,true)','B88_Damage(caster,u,300.,true)',1))
 if 'Trig_Spell_LiquidSteel_Actions' in fs:
  b=fs['Trig_Spell_LiquidSteel_Actions'];assert 'set udg_LiquidSteelDmg[d]=150.' in b
  s=put(s,'Trig_Spell_LiquidSteel_Actions',b.replace('set udg_LiquidSteelDmg[d]=150.','set udg_LiquidSteelDmg[d]=120.',1))
 # Remove only the display feature. Keep D7ReviewNoCollision, difficulty scaling
 # and the underlying poison/slow/dagger/other stack gameplay intact.
 for n,b in functions(s).items():
  if n.startswith('D7_Badge'):s=s.replace(b,'',1)
 s=re.sub(r'(?m)^\s*call D7_Badge(?:Init|Draw)\(\)\s*\n','',s)
 s=re.sub(r'(?m)^\s*(?:framehandle(?: array)?|integer array|trigger|unit|boolean) D7Badge[^\n]*\n','',s)
 assert 'D7Badge' not in s and 'D7_Badge' not in s
 return s

def objects(v):
 a=all_objects(v,'w3a');u=all_objects(v,'w3u');abilities={};units={};text_changes=[]
 for raw,old,new in [('hWW0','500 physical damage per second','300 physical damage per second'),('hAA0','150 wind-elemental physical damage per bounce','120 wind-elemental physical damage per bounce')]:
  o=copy.deepcopy(a[raw]);text=fields(o)['aub1',1];assert old in text,(raw,text)
  updated=text.replace(old,new);setf(o,'aub1',updated,1);abilities[raw]=o;text_changes.append((text,updated))
 for raw,o in u.items():
  text=fields(o).get(('utub',None),'');updated=text
  for old,new in text_changes:updated=updated.replace(old,new)
  if updated!=text:
   units[raw]=copy.deepcopy(o);setf(units[raw],'utub',updated,None)
 return units,abilities

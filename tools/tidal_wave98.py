"""Restore the five native Tidal Wave projectiles without changing its damage."""
import copy
from build_forest86 import all_objects,mod
from jtok import functions
from performance_runtime import put
RAW='nTW8'
MODEL=r'Abilities\Spells\Other\CrushingWave\CrushingWaveMissile.mdl'
def objects(v):
 old=all_objects(v,'w3a');assert RAW not in old
 o=copy.deepcopy(old['A0PZ']);o['id']=RAW
 for k,val in [('anam','Tidal Wave projectile'),('ansf','[Tidal Wave live proxy]'),('amat',MODEL),('amsp',1100),('amho',0),('amcs',0),('acdn',0.)]:mod(o,k,val)
 return {RAW:o}
def refresh(s):
 f=functions(s)
 if 'Trig_Famfrit_TidalWave_Actions' not in f:return s
 b=f['Trig_Famfrit_TidalWave_Actions'];anchor='        call ShowUnitHide(GetLastCreatedUnit())';assert b.count(anchor)==1
 b=b.replace(anchor,'        call SetUnitVertexColor(GetLastCreatedUnit(),255,255,255,0)\n        call SetUnitPathing(GetLastCreatedUnit(),false)',1)
 b=b.replace("call UnitAddAbilityBJ('A0PZ',GetLastCreatedUnit())","call UnitAddAbilityBJ('nTW8',GetLastCreatedUnit())",1)
 return put(s,'Trig_Famfrit_TidalWave_Actions',b)

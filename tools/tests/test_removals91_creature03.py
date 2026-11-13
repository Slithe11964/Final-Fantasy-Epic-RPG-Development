import collections,json,re,sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from build_removals91 import BASE,OUT,GLOBAL_REMOVALS,CENTRAL_REMOVALS,pool_blocks
from build_forest86 import all_objects
from priest_master import fields

ROOT=Path(__file__).resolve().parents[2]
REVIEW=ROOT/'release/development/CreatureReview03'

class Removals91Creature03Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.before=View(BASE);c.world=View(OUT);c.review=View(REVIEW/'FFERPG-Creature-Review-03.w3x')
  c.fs=functions(c.review.runtime)
  c.catalogue=json.loads((REVIEW/'Creature-Catalogue.json').read_text())
  c.rows=c.catalogue['creatures'];c.origins=json.loads((REVIEW/'Encounter-Origins.json').read_text())
 def test_world_only_changes_spawn_pool_function(self):
  old=functions(self.before.runtime);new=functions(self.world.runtime)
  self.assertEqual(set(old),set(new))
  self.assertEqual({n for n in old if tokens(old[n])!=tokens(new[n])},{'Trig_Spawn_Pools_Init_Actions'})
  self.assertEqual({n for n in self.before.modules if self.before.modules[n]!=self.world.modules[n]},{'TSpawn'})
 def test_each_world_pool_preserves_all_other_weights(self):
  def pools(v):
   body=functions(v.runtime)['Trig_Spawn_Pools_Init_Actions']
   return {(day,zone):re.findall(r"UnitPoolAddUnitType\(l_pool,\s*'(.{4})',\s*([^)]*)\)",m[0]) for m,day,zone in pool_blocks(body)}
  before=pools(self.before);after=pools(self.world)
  self.assertEqual(set(before),set(after));removed=0
  for key,items in before.items():
   forbidden=GLOBAL_REMOVALS|(CENTRAL_REMOVALS if key[1]==3 else set())
   expected=[x for x in items if x[0] not in forbidden]
   removed+=len(items)-len(expected);self.assertEqual(after[key],expected,key)
  self.assertGreater(removed,0)
  for raw in ['ndtr','ndtp']:self.assertIn(raw,[r for r,w in after[4,1]])
 def test_arena_and_world_objects_unchanged(self):
  for module in ['TArenaTeamData','TArena','TMonsterData']:
   self.assertEqual(self.before.modules[module],self.world.modules[module],module)
  for name in self.before.archive.read('(listfile)').decode().splitlines():
   if name.lower().endswith(('.w3u','.w3a','.w3h','.w3t','.w3q','.w3b','.w3d','.w3e','.doo')):
    self.assertEqual(self.before.archive.read(name),self.world.archive.read(name),name)
 def test_named_teams_and_roster_only_units_preserved(self):
  teams=self.origins['arena_teams']
  self.assertIn('Dark Fish Clan',teams['nmrv']);self.assertIn('Dark Fish Clan',teams['nmsn'])
  self.assertIn('Top Gang',teams['ndtp'])
  for raw in ['nmrv','nmsn','ndth']:
   entries=[r for r in self.rows if r['raw']==raw]
   self.assertTrue(entries,raw);self.assertEqual({r['area'] for r in entries},{12},raw)
 def test_requested_removals_not_review_world_exhibits(self):
  for r in self.rows:
   if r['area']<10:
    self.assertNotIn(r['raw'],GLOBAL_REMOVALS)
    if r['area']==3:self.assertNotIn(r['raw'],CENTRAL_REMOVALS)
 def test_all_rare_hunts_and_nilrem_near_area(self):
  hunts=self.origins['hunts'];self.assertEqual(len(hunts),28)
  for raw,h in hunts.items():
   self.assertTrue(any(r['raw']==raw and r['area']==h['area'] and r['section']=='Rare hunts' for r in self.rows),raw)
  self.assertTrue(any(r['raw']=='U006' and r['area']==1 and r['section']=='Area bosses / summons' for r in self.rows))
  self.assertFalse(any(r['raw']=='U006' and r['area']==11 for r in self.rows))
  self.assertTrue(any(r['raw']=='mH89' and r['area']==4 for r in self.rows))
 def test_layout_separates_regions_and_subgroups(self):
  occupied=set()
  for r in self.rows:
   if not r['valid_object']:continue
   a=r['area'];x=-2800+((a-1)%3)*10300;y=2900-((a-1)//3)*6000
   self.assertGreaterEqual(r['x'],x);self.assertLess(r['x'],x+10000)
   self.assertLess(r['y'],y);self.assertGreater(r['y'],y-5900)
   position=(r['x'],r['y']);self.assertNotIn(position,occupied);occupied.add(position)
   if a<10:
    if r['section'] in ['Rare hunts','Area bosses / summons']:self.assertLess(r['y'],y-3500)
    else:self.assertGreater(r['y'],y-3500)
 def test_latest_normal_unit_data_and_ability_payloads(self):
  self.assertEqual(self.world.archive.read('war3map.w3u'),self.review.archive.read('war3map.w3u'))
  a=all_objects(self.world,'w3a');b=all_objects(self.review,'w3a')
  for raw,obj in a.items():
   keep=lambda o:{k:v for k,v in fields(o).items() if k[0]!='aub1'}
   self.assertEqual(keep(obj),keep(b[raw]),raw)
  self.assertIn('Normal / one player',self.catalogue['coverage']['normal_baseline'])
 def test_review_controlled_damageable_silent_and_combat_ready(self):
  self.assertNotIn('DisplayTimedText',self.fs['Review_Select'])
  self.assertIn('Player(0)',self.fs['Review_Add'])
  self.assertIn('SetUnitInvulnerable(u,false)',self.fs['Review_Add'])
  for n in ['Register_Damage_Engine','Register_Damage_RegisterEnter','Register_Damage_RegisterAttacked','Register_Damage_ProxyCleanup','Register_Damage_Splash','Forest86_Init']:
   self.assertEqual(len(re.findall(r'\bcall '+n+r'\(',self.review.runtime)),1,n)
  for n in ['Review03_Combat','Review02_Load']:self.assertIn(n,self.fs['Review_Start'])
  for command in ['-enemy','-wound','-info','-spells','-abilities','-test']:self.assertIn(command,self.fs['Review_Chat'])
  self.assertNotIn('Register_All',self.fs['main'])
  self.assertNotIn('GetLocalPlayer',self.fs['Review03_Combat'])

if __name__=='__main__':unittest.main()

import json
import test_autosave100
from build_v1 import BASE,OUT
from mpq import MPQ
from jtok import functions,tokens
class V1Tests(test_autosave100.Autosave100Tests):
 @classmethod
 def setUpClass(c):
  old=MPQ(str(BASE));new=MPQ(str(OUT));c.maps=[(old,new,functions(new.read('war3map.j').decode().replace('\r\n','\n')))]
 def test_v1_name_and_next_version(self):
  r=json.loads(OUT.with_suffix('.json').read_text());self.assertEqual(r['version'],'V1');self.assertEqual(r['next_development_version'],'V2');self.assertEqual(OUT.name,'FFERPG-V1.w3x');self.assertIn(b'FFERPG V1',OUT.read_bytes()[:512])
 def test_all_dragoon_ancient_forest_objects_assets_and_gameplay_preserved(self):
  old,new,f=self.maps[0]
  for name in old.read('(listfile)').decode().splitlines():
   if name.lower() not in ['war3map.j','war3map.wct','war3map.wts','(listfile)','(attributes)','(signature)']:self.assertEqual(old.read(name),new.read(name),name)
  before=functions(old.read('war3map.j').decode().replace('\r\n','\n'));changed={n for n in before if tokens(before[n])!=tokens(f[n])}
  self.assertEqual(changed,{'Forsaken_PrepareInventories','FFL_Autosave','FFL_Guard','FFL_CloseWindow','InitTrig_ForsakenFreshLoad'})
  self.assertEqual(set(f)-set(before),{'FFL_TryAutosave','FFL_RetryAutosaves'})
  production=functions(MPQ(str(test_autosave100.ROOT/'release/0.9.7.5g/FFERPG-0.9.7.5g.w3x')).read('war3map.j').decode().replace('\r\n','\n'))
  for n in ['FFL_TryAutosave','FFL_RetryAutosaves','FFL_Autosave']:self.assertEqual(tokens(f[n]),tokens(production[n]),n)

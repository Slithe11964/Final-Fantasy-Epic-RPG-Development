"""Casting proxies stay active without revealing deferred boss-spell scenery."""
from pathlib import Path
import sys,unittest,re
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from channel_casting import refresh
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class BossChannelTests(unittest.TestCase):
    def test_all_source_modules_repeat_cleanly_and_preserve_registration(self):
        changed=0
        for p in (ROOT/'src/triggers').rglob('*.j'):
            s=p.read_text();r=refresh(s)
            self.assertEqual(refresh(r),r,p.name)
            if r!=s:changed+=1
            a,b=functions(s),functions(r)
            for name in a:
                if name.startswith(('Register','InitTrig')):self.assertEqual(tokens(a[name]),tokens(b[name]),name)
        self.assertGreater(changed,5)
    def test_casting_proxy_is_active_with_mana_but_following_rock_remains_hidden(self):
        s=next((ROOT/'src/triggers/06 Quests and story').rglob('Exodus.j')).read_text();s=refresh(s)
        name='Trig_Exodus_Cometeorite_Actions';body=functions(s)[name]
        # Execute the allocation/cast prefix; later boss animation timers are unrelated.
        body=body[:body.index('    call Wait_')]+'endfunction'
        state={'last':None};units=[];casts=[]
        def create(count,raw,*args):
            u=dict(raw=raw,visible=True,mana=0);units.append(u);state['last']=u
        e=mocks(s);e.update(GetTriggerUnit=lambda:'boss',GetSpellTargetLoc=lambda:'point',
            GetUnitLoc=lambda u:'point',GetSpellTargetUnit=lambda:None,GetOwningPlayer=lambda u:11,
            Prof_InnerManaPower=lambda u:1.,GetHandleIdBJ=lambda u:123,CreateNUnitsAtLocFacingLocBJ=create,CreateNUnitsAtLoc=create,
            GetLastCreatedUnit=lambda:state['last'],ShowUnitHide=lambda u:u.__setitem__('visible',False),
            bj_UNIT_FACING=270.,UNIT_STATE_MANA='mana',UNIT_STATE_MAX_MANA='maxmana',GetUnitState=lambda *a:1000.,
            SetUnitState=lambda u,k,v:u.__setitem__('mana',v),
            IssuePointOrderLocBJ=lambda u,o,p:casts.append((u['raw'],u['visible'],u['mana'],o)),Player=lambda p:p)
        e=execute(body,[name],e);e[name]()
        self.assertEqual(casts,[('h01B',True,1000.,'blizzard')])
        self.assertEqual(units[-1]['raw'],'n0D6');self.assertFalse(units[-1]['visible'])
    def test_actual_boss_channel_keeps_its_damage_and_order(self):
        s=next((ROOT/'src/triggers/06 Quests and story').rglob('McBurn.j')).read_text()
        a=functions(s)['Trig_McBurn_Volcano_Actions'];b=functions(refresh(s))['Trig_McBurn_Volcano_Actions']
        stripped=re.sub(r'^\s*call ShowUnitHide\(GetLastCreatedUnit\(\)\)[^\n]*\n','',a,flags=re.M)
        restored=re.sub(r'^\s*call SetUnitState\(GetLastCreatedUnit\(\),UNIT_STATE_MANA,GetUnitState\(GetLastCreatedUnit\(\),UNIT_STATE_MAX_MANA\)\)[^\n]*\n','',b,flags=re.M)
        self.assertEqual(tokens(stripped),tokens(restored))

if __name__=='__main__':unittest.main()

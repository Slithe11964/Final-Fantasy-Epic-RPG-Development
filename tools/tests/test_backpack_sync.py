"""Opening a local bag must not allocate native frame handles or issue commands."""
from pathlib import Path
import re,sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from test_armory_materia import execute
from test_backpack_visibility import HELPER,ROOT
import test_backpack_visibility as fixtures

FORBIDDEN={
    'BlzGetFrameByName','BlzGetOriginFrame','BlzFrameGetChild','BlzFrameGetParent',
    'BlzFrameGetChildrenCount','BlzCreateFrame','BlzCreateFrameByType',
    'BlzCreateSimpleFrame','BlzDestroyFrame','BlzFrameClick','CreateTrigger',
    'DestroyTrigger','CreateGroup','CreateTimer','InitHashtable','CreateUnit',
    'CreateItem','GetRandomInt','GetRandomReal','IssueImmediateOrder',
    'IssuePointOrder','IssueTargetOrder','UnitAddAbility','UnitRemoveAbility',
    'SetUnitState','SetWidgetLife','SetPlayerTechResearched'}


def calls(source):
    words=tokens(source,normalize=False)
    return {word for word,nxt in zip(words,words[1:])
            if nxt=='(' and re.fullmatch(r'\w+',word)}


def unsafe_paths(fs,roots):
    pending=[(root,[root]) for root in roots];seen=set();bad=[]
    while pending:
        name,path=pending.pop()
        if name in seen or name not in fs:continue
        seen.add(name)
        for callee in calls(fs[name]):
            if callee in FORBIDDEN:bad.append(' -> '.join(path+[callee]))
            elif callee in fs:pending.append((callee,path+[callee]))
        if re.search(r'\bset\s+(?:udg_|bj_)',fs[name]):bad.append(name+' writes gameplay scratch globals')
    return bad


class BackpackSyncTests(unittest.TestCase):
    def test_shared_discovery_uses_fixed_order_before_local_visibility(self):
        orders=[]
        for visible in [False,True]:
            queries=[]
            def lookup(name,context):
                queries.append((name,context))
                return name+str(context) if context in (3,7) else None
            env=dict(ForsakenNativeFrame={},ForsakenNativeFrameCount={},ForsakenCachedEquipment=None,ForsakenCachedBackdrop=None,
                     ForsakenLinkedBag=None,ForsakenFrameSearchRequested=True,
                     BlzGetFrameByName=lookup,BlzFrameIsVisible=lambda f:visible)
            e=execute(HELPER,['Forsaken_FindFrameUncached','Forsaken_ResolveInventory','Forsaken_SelectCachedFrame','Forsaken_FindFrame'],env)
            e['Forsaken_ResolveInventory']()
            self.assertEqual(len(queries),768)
            for attempt in range(100):
                e['ForsakenFrameSearchRequested']=True
                self.assertEqual(e['Forsaken_FindFrame']('SimpleEquipmentPanel'),'SimpleEquipmentPanel3')
                self.assertEqual(e['Forsaken_FindFrame']('SimpleEquipmentInventoryPanel'),'SimpleEquipmentInventoryPanel3')
            self.assertEqual(len(queries),768);orders.append(queries)
        self.assertEqual(*orders)
        registration=functions(HELPER)['Forsaken_RegisterBackpackActivity']
        self.assertIn('call Forsaken_ResolveInventory()',registration)
        self.assertNotIn('GetLocalPlayer',registration)

    def test_one_client_open_close_does_not_allocate_handles_or_click_commands(self):
        clients=[fixtures.BackpackVisibilityTests().runtime() for _ in range(2)]
        def forbidden(*args):raise AssertionError('local native handle discovery/command activation')
        for e,*_ in clients:
            for native in FORBIDDEN:e[native]=forbidden
        e,state,visibility,_,_,_,poll,_=clients[0]
        # The real engine mouse/hotkey input opens its panes; JASS only observes.
        e['Forsaken_RequestBackpackToggle'](2)
        visibility.update(gear=True,bag=True)
        self.assertTrue(poll(10.1))
        e['Forsaken_BackpackControls']('gear','backdrop',True)
        e['Forsaken_CloseBackpack']();self.assertFalse(poll(12.))
        state['now']=13.;e['Forsaken_RequestBackpackToggle'](2)
        self.assertTrue(poll(13.1))
        other,_,other_visibility,*_=clients[1]
        self.assertFalse(other['ForsakenBackpackWanted'])
        self.assertFalse(other_visibility['gear'] or other_visibility['bag'])

    def test_binding_and_close_controls_do_not_walk_native_children_or_click(self):
        fs=functions(HELPER)
        for name in ['Forsaken_BindInventory','Forsaken_BackpackControls','Forsaken_BackpackVisible','Forsaken_NativeInventoryClick']:
            self.assertFalse(calls(fs[name])&FORBIDDEN,name)
        self.assertEqual(calls(fs['Forsaken_HookBackpackClose']),set())

    def test_native_local_ui_call_graph_is_presentation_only(self):
        fs={}
        for p in (ROOT/'src/triggers').rglob('*.j'):fs.update(functions(p.read_text()))
        if 'Forsaken_PollPanels' not in fs:self.skipTest('native UI graph runs in the native profile')
        roots=['Forsaken_PollPanels','Forsaken_PanelClick','Forsaken_PanelAccess',
               'Forsaken_BackpackToggleAction','Forsaken_BackpackCloseAction',
               'Forsaken_BackpackDebug','SpellCalc_Update']
        self.assertEqual(unsafe_paths(fs,roots),[])


if __name__=='__main__':unittest.main()

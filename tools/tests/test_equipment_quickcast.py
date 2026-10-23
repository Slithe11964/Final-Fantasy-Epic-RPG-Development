"""Local shortcuts cannot cast directly; synchronized requests validate worn items."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
from test_backpack_sync import unsafe_paths
from equipment_quickcast import catalogue,refresh
ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Forsaken/EquipmentQuickCast.j').read_text().split('// FUNCTIONS\n',1)[1]

class QuickCastTests(unittest.TestCase):
    def runtime(self):
        state=dict(now=10.,local=0,owner=0,hero='hero',key='F',down=True,event='key',frame='F',mode=0,raw=101,mark=7,target=0,x=100.,y=100.,cooldown=0.,mana=1000.,selected=True)
        worn={0:'weapon',1:'offhand'};store={(0,101):201,(1,101):0,(0,102):202,(1,102):1}
        calls=[];packets=[];visible={};texts={"fl":"F","gl":"G"};targets=['enemy'];hitpoints={'hero':1000.,'enemy':1000.}
        env=mocks(SOURCE)
        env.update(QuickGearIconState=defaultdict(lambda:-1),QuickGearReadyIcon=defaultdict(str),QuickGearDisabledIcon=defaultdict(str))
        publication={'value':None,'end':0.}
        def published(h,parent,child):
            if state['cooldown']!=publication['value']:
                publication.update(value=state['cooldown'],end=state['now']+state['cooldown'] if state['cooldown']>0 else 0.)
            if 32<=parent<40:return publication['end']
            if 48<=parent<56:return state['cooldown']
            return 0.
        env.update(QuickGearReady=False,QuickGearHero=None,QuickGearSeenRevision=-1,QuickGearRevision=defaultdict(int),QuickGearEnds=defaultdict(float),FFL_Phase=defaultdict(int),FFN_State=defaultdict(int),GetPlayerId=lambda p:p,QuickGearRoot='dock',QuickGearScreenWidth=0,QuickGearScreenHeight=0,BlzGetLocalClientWidth=lambda:1920,BlzGetLocalClientHeight=lambda:1080,I2R=float,RMinBJ=min,FRAMEPOINT_BOTTOMLEFT='bottomleft',FRAMEPOINT_BOTTOMRIGHT='bottomright',BlzFrameClearAllPoints=lambda f:None,BlzFrameSetAbsPoint=lambda *a:None,QuickGearChatEdit=None,QuickGearLastPress=defaultdict(lambda:-1.),ForsakenPanelClock='clock',TimerGetElapsed=lambda t:state['now'],BlzFrameIsVisible=lambda f:visible.get(f,False),QuickGearLastRaw=defaultdict(int),QuickGearLastSeconds=defaultdict(int),R2I=int,I2S=str,R2S=str,S2I=int,S2R=float,RMaxBJ=max,R2SW=lambda n,*a:str(n),
            StringLength=len,SubString=lambda s,a,b:s[a:b],
            UNIT_STATE_MANA=1,bj_mapInitialPlayableArea='bounds',QuickGearData='data',QuickGearPending=-1,QuickGearPendingHero=0,QuickGearPendingItem=0,QuickGearPendingMark=0,
            QuickGearChatOpen=False,QuickGearHeld=defaultdict(bool),QuickGearButton={0:'F',1:'G'},QuickGearIcon={0:'fi',1:'gi'},
            QuickGearTipText={0:'ft',1:'gt'},QuickGearCooldownPanel={0:'fclock',1:'gclock'},
            GetLocalPlayer=lambda:state['local'],GetTriggerPlayer=lambda:state['owner'],Player_GetHero=lambda p:state['hero'],
            GetOwningPlayer=lambda u:state['owner'],GetUnitTypeId=lambda u:55,GetWidgetLife=lambda u:hitpoints.get(u,1000.),
            IsUnitSelected=lambda *a:state['selected'],BlzUnitItemInEquipmentSlot=lambda u,s:worn.get(s),
            EQUIPMENT_LOADOUT_SLOT_PRIMARY=0,EQUIPMENT_LOADOUT_SLOT_OFFHAND=1,
            GetItemTypeId=lambda i:state['raw'] if i=='weapon' else 102 if i=='offhand' else 0,
            GetItemUserData=lambda i:state['mark'],GetItemName=lambda i:i,
            LoadInteger=lambda h,p,c:store.get((p,c),0),GetUnitState=lambda *a:state['mana'],BlzGetAbilityManaCost=lambda *a:50,
            NativeCD_Pool=lambda raw:123,NativeCD_Left=lambda *a:state['cooldown'],BlzGetUnitAbilityCooldownRemaining=lambda *a:0.,
            UnitUseItem=lambda *a:calls.append(('instant',a)) or True,UnitUseItemTarget=lambda *a:calls.append(('target',a)) or True,
            UnitUseItemPoint=lambda *a:calls.append(('point',a)) or True,
            BlzSendSyncData=lambda prefix,data:packets.append(data),BlzGetTriggerSyncData=lambda:state['data'],
            GetHandleId=lambda u:99 if u=='enemy' else 55,
            CreateGroup=lambda:[],GroupEnumUnitsInRange=lambda g,*a:g.extend(targets),FirstOfGroup=lambda g:g[0] if g else None,
            GroupRemoveUnit=lambda g,u:g.remove(u),DestroyGroup=lambda g:None,
            GetRectMinX=lambda r:-1000.,GetRectMaxX=lambda r:1000.,GetRectMinY=lambda r:-1000.,GetRectMaxY=lambda r:1000.,
            BlzFrameSetVisible=lambda f,v:visible.__setitem__(f,v),BlzFrameSetText=lambda f,t:texts.__setitem__(f,t),
            BlzGetItemIconPath=lambda i:'icon',BlzGetAbilityExtendedTooltip=lambda *a:'effect',
            BlzGetTriggerPlayerKey=lambda:state['key'],BlzGetTriggerPlayerIsKeyDown=lambda:state['down'],GetTriggerEventId=lambda:state['event'],
            OSKEY_F='F',OSKEY_G='G',OSKEY_RETURN='enter',OSKEY_ESCAPE='esc',EVENT_PLAYER_CHAT='chat',
            BlzGetTriggerFrame=lambda:state['frame'],BlzGetTriggerPlayerMouseButton=lambda:state.get('mouse','left'),
            MOUSE_BUTTON_TYPE_LEFT='left',MOUSE_BUTTON_TYPE_RIGHT='right',BlzGetMouseFocusUnit=lambda:'enemy',
            BlzGetTriggerPlayerMouseX=lambda:100.,BlzGetTriggerPlayerMouseY=lambda:100.)
        env.update(QuickGearNumberPanel={0:"np0",1:"np1"},QuickGearNumberText={0:"ni0",1:"ni1"},QuickGearNumberInitTimer=None,QuickGearArtTest=False,QuickGearInitTimer=None,QuickGearNumberImage={0:'ni0',1:'ni1'},NativeCDClock='cooldown-clock',BlzFrameSetTexture=lambda f,path,*a:texts.__setitem__(f,path),QuickGearWheelPanel={0:'fw',1:'gw'},QuickGearWheelImage={0:'fiw',1:'giw'},QuickGearWheelStep=defaultdict(lambda:-1),QuickGearDuration=defaultdict(float),QuickGearRetryUntil=0.,QuickGearWeaponKey=defaultdict(lambda:70),QuickGearOffhandKey=defaultdict(lambda:71),TravelVisible=defaultdict(bool),ConvertOsKeyType=chr,StringCase=lambda text,upper:text.upper() if upper else text.lower(),QuickGearLabel={0:'fl',1:'gl'},IMinBJ=min,QuickGearPreviewImage=defaultdict(lambda:None),QuickGearPreviewRadius=defaultdict(float),QuickGearPreviewCount=0,QuickGearPreview=0,QuickGearMouseKnown=False,QuickGearMouseX=0.,QuickGearMouseY=0.,EVENT_PLAYER_MOUSE_MOVE='move',IMaxBJ=max,GetUnitAbilityLevel=lambda *a:1,InventoryCinematicActive=False,udg_InCinematicMode=False,bj_cineModeAlreadyIn=False,QuickGearClockPool=defaultdict(int),QuickGearCast=defaultdict(int),QuickGearActive=defaultdict(bool),QuickGearShown=False,
                 QuickGearSeenCooldownRevision=-1,NativeCDData='native-data',LoadReal=published)
        e=execute(SOURCE,list(functions(SOURCE)),env)
        return e,state,worn,store,calls,packets,visible,texts

    def countdown(self,e,slot,textures):
        path=textures.get('ni0' if slot==0 else 'ni1','')
        import re
        match=re.search(r'QuickGearNumber(\d+)\.tga$',path)
        return match[1] if match and match[1]!='0' else ''

    def test_engine_hidden_root_recovers_and_numbers_keep_independent_clocks(self):
        e,s,w,db,calls,packets,v,texts=self.runtime()
        e['QuickGear_Poll']();v['dock']=False
        e['QuickGear_Poll']();self.assertTrue(v['dock'])
        e['QuickGearEnds'].update({0:26.,1:18.})
        e['QuickGear_Poll']()
        self.assertEqual((self.countdown(e,0,texts),self.countdown(e,1,texts)),('16','8'))
        s['now']=18.;e['QuickGear_Poll']()
        self.assertEqual((self.countdown(e,0,texts),self.countdown(e,1,texts)),('8',''))
        s['now']=26.;e['QuickGear_Poll']()
        self.assertEqual((self.countdown(e,0,texts),self.countdown(e,1,texts)),('',''))

    def test_hidden_countdown_recovers_without_inventory_rescan(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();s['cooldown']=16.
        e['QuickGear_Poll']();self.assertEqual(self.countdown(e,0,texts),'16')
        s['selected']=False;e['QuickGear_Poll']()
        e['BlzUnitItemInEquipmentSlot']=lambda *a:self.fail('idle slot rescan')
        texts['ni0']='';s['selected']=True;e['QuickGear_Poll']()
        self.assertTrue(v['F']);self.assertEqual(self.countdown(e,0,texts),'16')

    def test_rebinding_changes_only_the_issuing_players_keys_and_labels(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();messages=[]
        e.update(GetEventPlayerChatString=lambda:'-gearhotkeys X C',DisplayTimedTextToPlayer=lambda *a:messages.append(a))
        e['QuickGear_Bindings']()
        self.assertEqual((e['QuickGearWeaponKey'][0],e['QuickGearOffhandKey'][0]),(88,67))
        self.assertEqual((texts['fl'],texts['gl']),('X','C'))
        s['key']='F';e['QuickGear_Input']();self.assertFalse(packets)
        s['key']='X';e['QuickGear_Input']();self.assertEqual(len(packets),1)
        s['now']+=1.;s['key']='C';e['QuickGear_Input']();self.assertEqual(e['QuickGearPending'],1)
        self.assertEqual(e['QuickGearWeaponKey'][1],70)
        s['owner']=1;e['QuickGear_Bindings']();self.assertEqual(e['QuickGearWeaponKey'][1],88)
        e['GetEventPlayerChatString']=lambda:'-gearhotkeys X X';e['QuickGear_Bindings']()
        self.assertEqual(e['QuickGearOffhandKey'][1],67)
        e['TravelVisible'][1]=True;s['local']=1;s['now']+=1.;s['key']='X'
        e['QuickGear_Input']();self.assertEqual(len(packets),1)

    def test_number_bindings_and_digit_images_are_cached_between_ticks(self):
        e,s,w,db,calls,packets,v,textures=self.runtime()
        e.update(GetEventPlayerChatString=lambda:'-gearhotkeys 1 0',DisplayTimedTextToPlayer=lambda *a:None)
        e['QuickGear_Bindings']()
        self.assertEqual((e['QuickGearWeaponKey'][0],e['QuickGearOffhandKey'][0]),(49,48))
        self.assertEqual((textures['fl'],textures['gl']),('1','0'))
        s['key']='1';e['QuickGear_Input']();self.assertEqual(len(packets),1)
        s['key']='0';e['QuickGear_Input']();self.assertEqual(e['QuickGearPending'],1)
        s['cooldown']=101.;e['QuickGear_Poll']();self.assertEqual(self.countdown(e,0,textures),'101')
        writes=[];original=e['BlzFrameSetTexture']
        e['BlzFrameSetTexture']=lambda *a:(writes.append(a),original(*a))
        for _ in range(10):e['QuickGear_Poll']()
        self.assertFalse(writes)
        s['now']+=2.;e['QuickGear_Poll']();self.assertEqual(self.countdown(e,0,textures),'99')
        self.assertEqual(textures['fl'],'1')
        self.assertEqual(self.countdown(e,0,textures),'99')
        from PIL import Image
        folder=ROOT/'experiments/Forsaken/QuickGearUI/wheel'
        with Image.open(folder/'CD64.tga') as image:self.assertEqual(image.getextrema()[3],(225,225))
        with Image.open(folder/'CD00.tga') as image:self.assertEqual(image.getextrema()[3],(0,0))
        with Image.open(folder/'Number88.tga') as image:self.assertIsNotNone(image.getbbox())

    def test_original_two_child_setup_reaches_timer_and_working_hotkey(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();timers=[];lookups=[]
        def child(name,context):
            lookups.append(name)
            if name in ['QuickGearItemImage','QuickGearItemKey']:
                return name+str(context)
            return None
        e.update(ORIGIN_FRAME_GAME_UI=0,ORIGIN_FRAME_COMMAND_BUTTON=1,FRAMEPOINT_TOPLEFT=2,FRAMEPOINT_TOPRIGHT=3,
            FRAMEEVENT_CONTROL_CLICK=4,EVENT_PLAYER_UNIT_EQUIP_ITEM=5,EVENT_PLAYER_UNIT_UNEQUIP_ITEM=6,EVENT_PLAYER_MOUSE_DOWN=7,
            QuickGearClick=None,QuickGear_InitPreviews=lambda:None,
            BlzGetFrameByName=child,BlzCreateSimpleFrame=lambda name,parent,context:name+str(context),
            CreateTrigger=lambda:'trigger',CreateTimer=lambda:'timer',TimerStart=lambda *a:timers.append(a))
        import re
        for name in re.findall(r'\bset (\w+)=',functions(SOURCE)['QuickGear_Init']):
            e.setdefault(name,None)
        e=execute(SOURCE,['QuickGear_Init'],e)
        e['QuickGear_Init']()
        self.assertEqual(e['QuickGearUITimer'],'timer')
        self.assertEqual(timers[-1][1:3],(.1,True))
        self.assertNotIn('QuickGearItemCooldown',lookups)
        e['QuickGear_Poll']();e['QuickGear_Input']()
        self.assertEqual(len(packets),1)

    def test_separate_countdown_never_changes_key_or_item(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();s['cooldown']=35.
        texts.update(fl='F',gl='G')
        e['QuickGear_Poll']()
        self.assertEqual((self.countdown(e,0,texts),self.countdown(e,1,texts)),('35','35'))
        self.assertEqual((texts['fl'],texts['gl']),('F','G'))
        self.assertEqual((texts['fi'],texts['gi']),('icon','icon'))
        self.assertNotIn('-geararttest',SOURCE)

    def test_local_input_only_sends_and_other_client_ignores_it(self):
        e,s,w,db,calls,packets,*_=self.runtime()
        e['QuickGear_Input']();e['QuickGear_Input']()
        self.assertEqual(len(packets),1);self.assertEqual(calls,[])
        s['data']=packets[-1];e['QuickGear_Receive']()
        self.assertEqual(calls,[('instant',('hero','weapon'))])
        other,os,*_=self.runtime();os['local']=1
        other['QuickGear_Input']();self.assertFalse(other['QuickGearHeld'][0])

    def test_stale_chat_and_missed_key_release_do_not_disable_shortcuts(self):
        e,s,w,db,calls,packets,*_=self.runtime()
        e['QuickGearChatEdit']='chat';e['QuickGearChatOpen']=True;e['QuickGearHeld'][0]=True
        e['QuickGear_Input']();self.assertEqual(len(packets),1)
        s['now']+=1.;e['QuickGear_Input']();self.assertEqual(len(packets),2)
        e['BlzFrameIsVisible']=lambda f:True
        s['now']+=1.;e['QuickGear_Input']();self.assertEqual(len(packets),2)
        self.assertFalse(calls)

    def test_swapped_item_wrong_owner_dead_hero_and_cooldown_reject(self):
        for case in ['swapped','mark','hero','owner','dead','cooldown','mana']:
            e,s,w,db,calls,packets,*_=self.runtime();e['QuickGear_Request'](0);s['data']=packets[0]
            if case=='swapped':s['raw']=999
            elif case=='mark':s['mark']=99
            elif case=='hero':s['data']=s['data'].replace(':55:',':99:',1)
            elif case=='owner':e['GetOwningPlayer']=lambda u:1
            elif case=='dead':e['GetWidgetLife']=lambda u:0.
            elif case=='cooldown':s['cooldown']=10.
            elif case=='mana':s['mana']=0.
            e['QuickGear_Receive']();self.assertFalse(calls,case)

    def test_offhand_target_and_point_orders_use_the_equipped_item(self):
        e,s,w,db,calls,packets,*_=self.runtime();e['QuickGear_Request'](1)
        self.assertEqual(packets,[]);self.assertEqual(e['QuickGearPending'],1)
        e['QuickGear_Mouse']();self.assertEqual(calls,[])
        s['data']=packets[-1];e['QuickGear_Receive']()
        self.assertEqual(calls,[('target',('hero','offhand','enemy'))])
        db[1,102]=2;e['QuickGear_Request'](1);e['QuickGear_Mouse']();s['data']=packets[-1];e['QuickGear_Receive']()
        self.assertEqual(calls[-1],('point',('hero','offhand',100.,100.)))

    def test_area_preview_follows_mouse_and_cancels_without_creating_local_handles(self):
        e,s,w,db,calls,packets,*_=self.runtime();draws=[]
        e['QuickGearPreviewImage'][1]='ring';e['QuickGearPreviewRadius'][1]=400.
        db[33,201]=1;db[1,101]=2
        e.update(SetImagePosition=lambda *a:draws.append(a),ShowImage=lambda *a:draws.append(a),SetImageRenderAlways=lambda *a:None)
        e['QuickGear_Request'](0);self.assertEqual(e['QuickGearPreview'],1);self.assertFalse(packets)
        s['event']='move';e['QuickGear_Mouse']()
        self.assertIn(('ring',-300.,-300.,0.),draws);self.assertIn(('ring',True),draws)
        s['event']='key';s['mouse']='right';e['QuickGear_Mouse']()
        self.assertEqual(e['QuickGearPreview'],0);self.assertIn(('ring',False),draws);self.assertFalse(packets)
        db[1,101]=1;e['QuickGear_Request'](0);self.assertEqual(e['QuickGearPreview'],0)

    def test_passive_and_empty_slots_are_hidden_but_active_offhand_remains(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();db.pop((0,101))
        e['QuickGear_Poll']();self.assertTrue(v['dock']);self.assertFalse(v['F']);self.assertTrue(v['G'])
        s['cooldown']=8.;e['QuickGearRevision'][0]+=1;e['QuickGear_Poll']();self.assertIn('8',self.countdown(e,1,texts))
        e['QuickGear_Request'](1);s['mouse']='right';e['QuickGear_Mouse']();self.assertEqual(e['QuickGearPending'],-1)
        s['key']='enter';e['QuickGear_Input']();s['key']='G';e['QuickGear_Input']();self.assertFalse(packets)
        s['key']='esc';e['QuickGear_Input']();self.assertFalse(e['QuickGearChatOpen'])
        w.pop(1);e['QuickGearRevision'][0]+=1;e['QuickGear_Poll']();self.assertFalse(v['G']);self.assertFalse(v['dock'])

    def test_custom_dock_is_right_of_spells_without_occupying_native_slots(self):
        e,s,*_=self.runtime();positions=[]
        e.update(QuickGearAnchor='inventory-slot-0',FRAMEPOINT_TOPLEFT='topleft',FRAMEPOINT_TOPRIGHT='topright',
            BlzFrameSetPoint=lambda *args:positions.append(args))
        e=execute(SOURCE,['QuickGear_Layout'],e);e['QuickGear_Layout']()
        self.assertEqual(positions,[('dock','topleft','inventory-slot-0','topright',.012,0.)])
    def test_ui03_button_keeps_optional_countdown_out_of_critical_startup(self):
        import re
        init=functions(SOURCE)['QuickGear_Init']
        self.assertIn('BlzCreateSimpleFrame("QuickGearItemButton",QuickGearRoot,slot+900)',init)
        self.assertNotIn('QuickGearItemCooldown',init)
        self.assertNotIn('QuickGear_InitNumbers',SOURCE)
        self.assertNotIn('BlzCreateFrameByType',init)
        fdf=(ROOT/'experiments/Forsaken/QuickGearUI/QuickGear.fdf').read_text()
        self.assertIn('String "QuickGearItemKey"',fdf)
        self.assertNotIn('QuickGearItemCooldown',fdf)
        for op in ['Visible','Alpha','Level','Enable','Scale','Parent']:
            self.assertIsNone(re.search(r'BlzFrameSet'+op+r'\(QuickGear(?:Icon|Label|NumberImage)\[',SOURCE))
        self.assertNotIn('BlzDestroyFrame(QuickGearNumberImage',SOURCE)
        self.assertNotIn('BlzDestroyFrame(QuickGearLabel',SOURCE)

    def test_cached_countdown_does_not_read_items_until_equipment_or_use_event(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();reads=[]
        e['BlzUnitItemInEquipmentSlot']=lambda u,slot:reads.append((u,slot)) or w.get(slot)
        s['cooldown']=8.;e['QuickGear_Poll']();self.assertEqual(len(reads),2)
        s['now']+=2.;e['QuickGear_Poll']();self.assertEqual(self.countdown(e,1,texts),'6')
        for _ in range(100):e['QuickGear_Poll']()
        self.assertEqual(len(reads),2)
        e['QuickGearRevision'][1]+=1;e['QuickGear_Poll']();self.assertEqual(len(reads),2)
        e['QuickGearRevision'][0]+=1;e['QuickGear_Poll']();self.assertEqual(len(reads),4)
        s['selected']=False;e['QuickGear_Poll']();self.assertFalse(v['dock'])
        s['selected']=True;e['QuickGear_Poll']();self.assertTrue(v['dock']);self.assertEqual(len(reads),4)
    def test_load_hides_display_and_never_reads_transient_heroes(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();reads=[]
        e['BlzUnitItemInEquipmentSlot']=lambda u,slot:reads.append((u,slot)) or w.get(slot)
        e['QuickGear_Poll']();self.assertTrue(v['dock']);reads.clear()
        e['FFL_Phase'][0]=6;s['hero']='temporary hero';e['QuickGearRevision'][0]+=1
        e['QuickGear_Poll']();self.assertFalse(v['dock']);self.assertFalse(reads)
        e['FFL_Phase'][0]=0;e['FFN_State'][0]=1;e['QuickGear_Poll']();self.assertFalse(reads)
        e['FFN_State'][0]=0;s['hero']='loaded hero';e['QuickGear_Poll']()
        self.assertEqual(reads,[('loaded hero',0),('loaded hero',1)]);self.assertTrue(v['dock'])
    def test_stale_general_cinematic_flags_do_not_hide_icons_but_actual_cutscene_does(self):
        from inventory_ui import refresh as inventory_refresh
        source='''library TCine
globals
endglobals
function Cine_Enter takes nothing returns nothing
    set udg_InCinematicMode=true
endfunction
function Cine_Exit takes nothing returns nothing
    set udg_InCinematicMode=false
endfunction
endlibrary'''
        source=inventory_refresh(source);self.assertEqual(inventory_refresh(source),source)
        e,s,w,db,calls,packets,v,texts=self.runtime()
        e['bj_cineModeAlreadyIn']=True;e['udg_InCinematicMode']=True
        e=execute(SOURCE+'\n'+source,['QuickGear_Poll','Cine_Enter','Cine_Exit'],e)
        e['QuickGear_Poll']();self.assertTrue(v['dock'])
        e['Cine_Enter']();e['QuickGear_Poll']();self.assertFalse(v['dock'])
        e['Cine_Exit']();e['QuickGear_Poll']();self.assertTrue(v['dock'])
    def test_shared_equipment_events_only_dirty_the_owning_player(self):
        e,s,*_=self.runtime()
        e.update(GetTriggerUnit=lambda:'hero',EVENT_PLAYER_UNIT_SPELL_EFFECT='spell',GetSpellAbilityId=lambda:999)
        e['QuickGear_Changed']();self.assertEqual(e['QuickGearRevision'][0],1)
        s['owner']=1;e['QuickGear_Changed']();self.assertEqual(e['QuickGearRevision'][0],1)
        self.assertEqual(e['QuickGearRevision'][1],1)
        init=functions(SOURCE)['QuickGear_Init']
        self.assertNotIn('QuickGearChanges,EVENT_PLAYER_UNIT_SPELL_EFFECT',init)
        self.assertNotIn('QuickGearChanges,EVENT_PLAYER_UNIT_USE_ITEM',init)
    def test_offhand_admitted_cast_updates_its_clock_without_clearing_weapon_or_reading_gear(self):
        e,s,w,db,calls,packets,v,texts=self.runtime();reads=[];shared={}
        e['BlzUnitItemInEquipmentSlot']=lambda u,slot:reads.append((u,slot)) or w.get(slot)
        e.update(NativeCD_Pool=lambda raw:raw,
            GetTriggerUnit=lambda:'hero',GetSpellAbilityId=lambda:s['cast'],NativeCDClock='clock',
            NativeCD_Queue=lambda *a:None,NativeCD_Category=lambda *a:None,NativeCD_PlayerCaster=lambda u:True,NativeCD_Allowed=lambda:s['allowed'],
            NativeCD_DurationForCast=lambda u,raw:40. if raw==201 else 20.,
            SaveReal=lambda h,p,c,value:shared.__setitem__((p,c),value),
            LoadReal=lambda h,p,c:shared.get((p,c),0.),
            SaveInteger=lambda h,p,c,value:shared.__setitem__((p,c),value),
            LoadInteger=lambda h,p,c:shared.get((p,c),0) if h=='native-data' else db.get((p,c),0),
            NativeCD_Left=lambda u,p:max(0.,shared.get((32,p),0.)-s['now']))
        src=(ROOT/'experiments/Forsaken/SharedItemCooldown.j').read_text()
        e=execute(src,['NativeCD_Effect'],e)
        e['QuickGear_Poll']();self.assertEqual(len(reads),2)
        s.update(cast=201,allowed=True);e['NativeCD_Effect']();e['QuickGear_Poll']()
        self.assertEqual(self.countdown(e,0,texts),'40');self.assertEqual(self.countdown(e,1,texts),'')
        s['now']+=3.;s['cast']=202;e['NativeCD_Effect']();e['QuickGear_Poll']()
        self.assertEqual(self.countdown(e,0,texts),'37');self.assertEqual(self.countdown(e,1,texts),'20')
        self.assertEqual(len(reads),2);self.assertEqual(shared[32,0],2)
        s['allowed']=False;e['NativeCD_Effect']();self.assertEqual(shared[32,0],2)
        s['now']+=21.;e['QuickGear_Poll']()
        self.assertEqual(self.countdown(e,0,texts),'16');self.assertEqual(self.countdown(e,1,texts),'')
    def test_unrelated_casts_do_not_restart_clocks_and_exact_gear_deadlines_win(self):
        e,s,w,db,calls,packets,v,texts=self.runtime()
        pools={201:101,202:126};published={(32,101):26.,(48,101):16.,(32,126):18.,(48,126):8.}
        e['NativeCD_Pool']=lambda raw:pools.get(raw,0)
        e['LoadReal']=lambda h,p,c:published.get((p,c),0.)
        # UI initialization/rebuild has its own time origin; it cannot shift item clocks.
        e['TimerGetElapsed']=lambda timer:s['now'] if timer=='cooldown-clock' else s['now']+500.
        e['QuickGear_Poll']();self.assertEqual(self.countdown(e,0,texts),'16');self.assertEqual(self.countdown(e,1,texts),'8')
        s['now']+=3.;db[32,0]=1;e['QuickGear_Poll']()
        self.assertEqual(self.countdown(e,0,texts),'13');self.assertEqual(self.countdown(e,1,texts),'5')
        # Casting the book again publishes only its own new deadline.
        published[32,126]=33.;db[32,0]=2;e['QuickGear_Poll']()
        self.assertEqual(self.countdown(e,0,texts),'13');self.assertEqual(self.countdown(e,1,texts),'20')
        # Accept a shorter authoritative cooldown; never preserve an older maximum.
        published[32,101]=16.;db[32,0]=3;e['QuickGear_Poll']()
        self.assertEqual(self.countdown(e,0,texts),'3');self.assertEqual(self.countdown(e,1,texts),'20')
        s['now']=16.;e['QuickGear_Poll']();self.assertEqual(self.countdown(e,0,texts),'')
        self.assertEqual(self.countdown(e,1,texts),'17')

    def test_shared_cooldown_veto_remains_enforced_without_chat(self):
        src=(ROOT/'experiments/Forsaken/SharedItemCooldown.j').read_text();events=[]
        e=mocks(src);e.update(PauseUnit=lambda u,b:events.append(('pause',b)),
            IssueImmediateOrder=lambda u,o:events.append(('order',o)),
            DisplayTimedTextToPlayer=lambda *a:self.fail('cooldown wrote to chat'))
        e=execute(src,['NativeCD_Stop'],e);e['NativeCD_Stop']('hero',100)
        self.assertEqual(events,[('pause',True),('order','stop'),('pause',False)])
    def test_shortcut_use_has_no_custom_chat_messages(self):
        e,s,w,db,calls,packets,*_=self.runtime()
        e['DisplayTimedTextToPlayer']=lambda *a:self.fail('shortcut wrote to chat')
        e['QuickGear_Request'](1);e['QuickGear_Mouse']()
        s['data']=packets[-1];e['QuickGear_Receive']()
        self.assertTrue(calls)

    def test_local_call_graph_never_creates_handles_or_issues_game_orders(self):
        fs=functions(SOURCE)
        self.assertEqual(unsafe_paths(fs,['QuickGear_Click','QuickGear_Input','QuickGear_Mouse','QuickGear_Poll']),[])
        self.assertNotIn('UnitUseItem',fs['QuickGear_Request'])

if __name__=='__main__':unittest.main()

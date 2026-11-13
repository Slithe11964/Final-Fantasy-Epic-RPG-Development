"""Native six-slot visuals, owner-bound panes and shared NG+ experience bonus."""
import copy,re
from functools import lru_cache
from build_forest86 import ROOT,all_objects,ability,mod
from build_f1030_inventory_rollback import view
from jtok import functions,tokens
from performance_runtime import put
from priest_master import fields,setf
from selective_f_restore import guard,GATED
import quick75,slots76,preview77

@lru_cache(maxsize=1)
def native_preview_delta():
 old=view(str(ROOT/'release/development/QuickUI74/FFERPG-QuickUI74.w3x')).modules['TEquip']
 new=preview77.refresh(slots76.refresh(quick75.refresh(old)))
 a,b=functions(old),functions(new)
 return {n:s for n,s in b.items() if n not in a or tokens(a[n])!=tokens(s)},set(b)-set(a)

XP='''function NG19_Factor takes integer pid returns real
    return 1.+.1*I2R(IMaxBJ(0,udg_NewGamePlusLevel[pid+1]))
endfunction
function NG19_AddXP takes unit hero,integer amount,boolean show returns nothing
    if amount>0 then
        set amount=R2I(I2R(amount)*NG19_Factor(GetPlayerId(GetOwningPlayer(hero))))
    endif
    call AddHeroXP(hero,amount,show)
endfunction
function NG19_AddXPSwapped takes integer amount,unit hero,boolean show returns nothing
    call NG19_AddXP(hero,amount,show)
endfunction
function NG19_Buff takes unit hero,integer cycles returns nothing
    if hero==null or GetUnitTypeId(hero)==0 then
        return
    endif
    if cycles>0 then
        if GetUnitAbilityLevel(hero,'aE19')==0 then
            call UnitAddAbility(hero,'aE19')
            call UnitMakeAbilityPermanent(hero,true,'aE19')
        endif
        if GetUnitAbilityLevel(hero,'aE19')!=IMinBJ(10,cycles) then
            call SetUnitAbilityLevel(hero,'aE19',IMinBJ(10,cycles))
        endif
    elseif GetUnitAbilityLevel(hero,'aE19')>0 then
        call UnitRemoveAbility(hero,'aE19')
    endif
endfunction
function NG19_SyncBuffs takes nothing returns nothing
    local integer pid=0
    loop
        exitwhen pid>=8
        call NG19_Buff(udg_PlayerHero[pid+1],udg_NewGamePlusLevel[pid+1])
        call NG19_Buff(udg_SpiritOfGaya[pid+1],udg_NewGamePlusLevel[pid+1])
        set pid=pid+1
    endloop
endfunction
'''

HIDE='''function Forsaken_HideInventory takes nothing returns nothing
    // Close only the trio bound to this viewer's own hero, never all contexts.
    if ForsakenInventoryHero!=Player_GetHero(GetLocalPlayer()) then
        return
    endif
    if ForsakenCachedEquipment!=null then
        call BlzFrameSetVisible(ForsakenCachedEquipment,false)
    endif
    if ForsakenCachedBackdrop!=null then
        call BlzFrameSetVisible(ForsakenCachedBackdrop,false)
    endif
    if ForsakenLinkedBag!=null then
        call BlzFrameSetVisible(ForsakenLinkedBag,false)
    endif
endfunction'''

def refresh(lib,s,classic=False):
 fs=functions(s)
 if lib=='TEquip' and 'BagScreen_Update66' in fs:
  delta,added=native_preview_delta()
  s=s.replace('endglobals',quick75.GLOBALS+preview77.GLOBALS+'endglobals',1)
  for n,b in delta.items():
   if n in added:continue
   if n in GATED:b=guard(b)
   s=put(s,n,b)
  new_helpers='\n\n'.join(delta[n] for n in delta if n in added)
  s=s.replace('function GearWave_Clear takes',new_helpers+'\n\nfunction GearWave_Clear takes',1)
  s=put(s,'Forsaken_HideInventory',HIDE)
  b=functions(s)['Forsaken_BackpackVisible']
  b=b.replace('        call Forsaken_HideInventory()\n','')
  # Polls observe the native view; they never close panes or clear local intent
  # because another player's engine view caused a transient visibility change.
  b=b.replace('''    elseif now>=ForsakenInventoryBindUntil then
        // B/mouse have already closed the real native view. Do not restore it.
        set ForsakenBackpackWanted=false
''','')
  # Only an explicit local B/button request may adopt another native context.
  marker='    elseif visible then\n'
  assert marker in b
  b=b.replace(marker,'''    elseif visible and (ForsakenInventoryHero!=hero or gear!=ForsakenCachedEquipment or backdrop!=ForsakenCachedBackdrop or bag!=ForsakenLinkedBag) and now>=ForsakenInventoryBindUntil then
        set visible=false
'''+marker,1)
  s=put(s,'Forsaken_BackpackVisible',b)
 if lib=='TExp':
  # Shared gameplay helpers; not called from preview/frame/key callbacks.
  s=s.replace('function Trig_Exp_Distribution_Conditions takes',XP+'\nfunction Trig_Exp_Distribution_Conditions takes',1)
  b=fs['Trig_Exp_Distribution_Actions']
  marker='                if(Trig_Exp_Distribution_CanGainExp())then'
  assert marker in b
  b=b.replace(marker,'                set udg_ExpAmount=udg_ExpAmount*NG19_Factor(udg_PlayerIndex-1)\n'+marker,1)
  s=put(s,'Trig_Exp_Distribution_Actions',b)
 if lib=='TReward':
  s=s.replace('call AddHeroXP(','call NG19_AddXP(')
  s=s.replace(s.splitlines()[0],s.splitlines()[0]+', TExp' if 'requires' in s.splitlines()[0] else s.splitlines()[0]+' requires TExp',1)
 if lib=='TArenaRewards':
  s=s.replace('call AddHeroXPSwapped(','call NG19_AddXPSwapped(')
  s=s.replace(s.splitlines()[0],s.splitlines()[0]+', TExp' if 'requires' in s.splitlines()[0] else s.splitlines()[0]+' requires TExp',1)
 if lib=='TPassive':
  b=fs['Trig_Passive_Bonus_Sync_Actions']
  # A blocked one-shot callback must re-arm even during a cinematic; its game
  # reads still wait behind the shared guard. No new timer or polling rate.
  b=b.replace('    call StartTimerBJ(udg_StatsRefreshTimer,false,2.)\n','')
  marker='    if udg_InCinematicMode or InventoryCinematicActive then'
  assert marker in b
  b=b.replace(marker,'    call StartTimerBJ(udg_StatsRefreshTimer,false,2.)\n'+marker,1)
  b=b.replace('    call ForForce(udg_PlayingPlayers,','    call ExecuteFunc("NG19_SyncBuffs")\n    call ForForce(udg_PlayingPlayers,',1)
  s=put(s,'Trig_Passive_Bonus_Sync_Actions',b)
 return s

def objects(v):
 a=all_objects(v,'w3a');buffs=all_objects(v,'w3h')
 assert 'aE19' not in a
 q=ability('aE19','AOae','New Game Plus Experience','Experience gain increases by 10% per New Game Plus cycle. Stacks additively; NG+9 gives +90% experience.','BTNTomeOfRetraining.blp',area=1.,target='air,ground,self')
 mod(q,'alev',10,0);mod(q,'abpy',-11,0)
 new_buffs={}
 for level in range(1,11):
  raw='bE%02d'%level;assert raw not in buffs
  o=dict(base='BOae',id=raw,sets=[dict(flag=0,mods=[])])
  for k,val in {'fnam':'New Game Plus Experience','ftip':'New Game Plus '+str(level)+': +'+str(level*10)+'% Experience','fube':'Experience gained is increased by '+str(level*10)+'%. Each completed New Game Plus adds 10%; the bonuses add together.','fart':r'ReplaceableTextures\CommandButtons\BTNTomeOfRetraining.blp','ftat':'','feat':'','fcat':''}.items():setf(o,k,val,None)
  new_buffs[raw]=o
  for k,val in {'Oae1':0.,'Oae2':0.,'aare':1.,'atar':'air,ground,self','abuf':raw,'atp1':'New Game Plus Experience','aub1':'Experience gain +'+str(level*10)+'% from '+str(level)+' New Game Plus cycles.'}.items():mod(q,k,val,level)
 return {'aE19':q},new_buffs

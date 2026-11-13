globals
 unit Review03Enemy=null
endglobals
function Review03_AreaAt takes real x,real y returns integer
 local integer i=1
 loop
 exitwhen i>12
 if x>=ReviewX[i]-100. and x<ReviewX[i]+10000. and y<=ReviewY[i]+100. and y>ReviewY[i]-5900. then
 return i
 endif
 set i=i+1
 endloop
 return 13
endfunction
function Review03_Combat takes nothing returns nothing
 local group g=CreateGroup()
 local rect world=GetWorldBounds()
 set udg_ComboHash=InitHashtable()
 set udg_ProxyDamageHash=InitHashtable()
 set udg_DpsHash=InitHashtable()
 call SaveInteger(udg_DpsHash,0,2,1)
 call SaveInteger(udg_DpsHash,0,3,15)
 call Register_Damage_RegisterEnter()
 call Register_Damage_RegisterAttacked()
 call Register_Damage_Engine()
 call Register_Damage_ProxyCleanup()
 call Register_Damage_Splash()
 call GroupEnumUnitsInRect(g,world,null)
 call ForGroup(g,function Trig_Damage_Init_RegisterDamageUnit)
 call DestroyGroup(g)
 call RemoveRect(world)
 call EnableTrigger(gg_trg_Damage_RegisterEnter)
 call EnableTrigger(gg_trg_Damage_RegisterAttacked)
 call EnableTrigger(gg_trg_Damage_Engine)
 call Forest86_Init()
 set g=null
 set world=null
endfunction
function Review03_Hostile takes unit model returns nothing
 local integer area=LoadInteger(ReviewHash,GetHandleId(model),2)
 if model==null then
 return
 endif
 if Review03Enemy!=null then
 call RemoveUnit(Review03Enemy)
 endif
 call Review_Targets()
 set Review03Enemy=CreateUnit(Player(11),GetUnitTypeId(model),18000.,-22200.,0.)
 call Review02_Setup(Review03Enemy)
 call SetUnitInvulnerable(Review03Enemy,false)
 call UnitRemoveAbility(Review03Enemy,'Avul')
 call SetUnitAcquireRange(Review03Enemy,800.)
 if GetUnitAbilityLevel(Review03Enemy,'fL86')>0 or GetUnitAbilityLevel(Review03Enemy,'mAL9')>0 or GetUnitAbilityLevel(Review03Enemy,'hAL0')>0 or GetUnitAbilityLevel(Review03Enemy,'bAL8')>0 then
 set area=B88_AlertZone(Review03Enemy)
 endif
 call SetUnitUserData(Review03Enemy,area)
 call SaveStr(ReviewHash,GetHandleId(Review03Enemy),0,LoadStr(ReviewHash,GetHandleId(model),0))
 call SaveInteger(ReviewHash,GetHandleId(Review03Enemy),2,area)
 call IssueTargetOrder(Review03Enemy,"attack",ReviewFriend)
 call PanCameraToTimedForPlayer(Player(0),18500.,-22200.,.4)
 call DisplayTimedTextToPlayer(Player(0),0.,0.,12.,"Hostile practice copy uses combat AI. The friendly practice hero is a valid poison/Alert target. -test creates a player-controlled copy; -wound injures the selected unit for healing/Devour.")
endfunction

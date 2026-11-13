globals
 hashtable DG_Data=null
 group DG_Debuffed=null
 timer DG_Timer=null
 real DG_Now=0.
 unit array DG_Hero
 unit array DG_Target
 integer array DG_Action
 real array DG_End
 real array DG_X
 real array DG_Y
 real array DG_FromX
 real array DG_FromY
 real array DG_Distance
 real array DG_Angle
 unit array DG_GatedHero
 boolean array DG_RiseLocked
 real array DG_Life
 integer array DG_Fails
 effect array DG_Aura
 group array DG_Hits
endglobals

function DG_Alive takes unit u returns boolean
 return u!=null and GetUnitTypeId(u)!=0 and GetWidgetLife(u)>.405
endfunction
function DG_Reduction takes unit u returns real
 if DG_Data!=null and LoadUnitHandle(DG_Data,GetHandleId(u),0)==u and DG_Alive(u) then
 return LoadReal(DG_Data,GetHandleId(u),1)
 endif
 return 0.
endfunction
function DG_Enemy takes unit caster, unit target returns boolean
 return DG_Alive(target) and IsUnitEnemy(target,GetOwningPlayer(caster)) and not BlzIsUnitInvulnerable(target) and not IsUnitType(target,UNIT_TYPE_STRUCTURE)
endfunction
function DG_Cone takes real dx, real dy, real angle, real radius returns boolean
 // A 180-degree sector is the forward half-disc.
 return dx*dx+dy*dy<=radius*radius and dx*Cos(angle)+dy*Sin(angle)>=-.01
endfunction
function DG_Line takes real x, real y, real ax, real ay, real bx, real by returns boolean
 local real dx=bx-ax
 local real dy=by-ay
 local real length=dx*dx+dy*dy
 local real t=0.
 if length>.01 then
 set t=RMaxBJ(0.,RMinBJ(1.,((x-ax)*dx+(y-ay)*dy)/length))
 endif
 set dx=x-ax-t*dx
 set dy=y-ay-t*dy
 return dx*dx+dy*dy<=10000.
endfunction
function DG_FxEnd takes nothing returns nothing
 local timer t=GetExpiredTimer()
 call DestroyEffect(LoadEffectHandle(DG_Data,GetHandleId(t),0))
 call FlushChildHashtable(DG_Data,GetHandleId(t))
 call DestroyTimer(t)
 set t=null
endfunction
function DG_Fx takes string model, real x, real y, real angle, real scale returns nothing
 local effect e=AddSpecialEffect(model,x,y)
 local timer t=CreateTimer()
 call BlzSetSpecialEffectYaw(e,angle)
 call BlzSetSpecialEffectScale(e,scale)
 call SaveEffectHandle(DG_Data,GetHandleId(t),0,e)
 call TimerStart(t,1.2,false,function DG_FxEnd)
 set t=null
 set e=null
endfunction
function DG_Sound takes string file, real x, real y returns nothing
 local sound s=CreateSound(file,false,true,true,0,0,"")
 call SetSoundVolume(s,110)
 call SetSoundDistances(s,600.,2500.)
 call SetSoundPosition(s,x,y,80.)
 call StartSound(s)
 call KillSoundWhenDone(s)
 set s=null
endfunction
function DG_EndMotion takes integer p returns nothing
 local unit u=DG_Hero[p]
 if u!=null and GetUnitTypeId(u)!=0 then
 call SetUnitFlyHeight(u,0.,0.)
 call PauseUnit(u,false)
 call IssueImmediateOrder(u,"stop")
 call SetUnitAnimation(u,"stand ready")
 endif
 set DG_Action[p]=0
 set DG_Target[p]=null
 call GroupClear(DG_Hits[p])
 set u=null
endfunction
function DG_Gate takes unit u, boolean ready returns nothing
 local integer p
 if u==null then
 return
 endif
 set p=GetPlayerId(GetOwningPlayer(u))
 if p>=8 or BlzGetUnitAbility(u,'A14D')==null then
 return
 endif
 if DG_GatedHero[p]!=u then
 set DG_GatedHero[p]=u
 set DG_RiseLocked[p]=false
 endif
 if ready and DG_RiseLocked[p] then
 call BlzUnitDisableAbility(u,'A14D',false,false)
 set DG_RiseLocked[p]=false
 elseif not ready and not DG_RiseLocked[p] then
 call BlzUnitDisableAbility(u,'A14D',true,false)
 set DG_RiseLocked[p]=true
 endif
endfunction
function DG_Clear takes integer p returns nothing
 if DG_Action[p]==1 or DG_Action[p]==4 then
 call DG_EndMotion(p)
 endif
 set DG_Action[p]=0
 set DG_Life[p]=0.
 call UnitRemoveAbility(DG_Hero[p],'BdGL')
 call DG_Gate(DG_Hero[p],false)
 set DG_Fails[p]=0
 call DestroyEffect(DG_Aura[p])
 set DG_Aura[p]=null
 set DG_Hero[p]=null
 set DG_Target[p]=null
endfunction
function DG_Deal takes unit caster, unit target, real amount, boolean technique returns nothing
 set udg_IsPhysicalAttack=technique
 set udg_DmgFlagMelee=false
 set udg_DamageElement=0
 if not technique then
 set udg_DamageElement=1
 endif
 set udg_DmgFlagUnavoidable=-1
 set udg_DmgFlagNoCrit=-1.
 if technique then
 call UnitDamageTarget(caster,target,amount,true,false,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,null)
 else
 call UnitDamageTarget(caster,target,amount,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
 endif
endfunction
function DG_Impact takes unit caster, unit target returns nothing
 local real dx=GetUnitX(target)-GetUnitX(caster)
 local real dy=GetUnitY(target)-GetUnitY(caster)
 local real d=SquareRoot(dx*dx+dy*dy)
 if d>.01 and DG_Alive(target) then
 call SetUnitPathing(target,false)
 call SetUnitPosition(target,GetUnitX(target)+5.*dx/d,GetUnitY(target)+5.*dy/d)
 call SetUnitPathing(target,true)
 endif
 call DG_Sound("DragoonStab.ogg",GetUnitX(target),GetUnitY(target))
endfunction
function DG_Status takes unit caster returns nothing
 local unit dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(caster),GetUnitY(caster),0.)
 call ShowUnit(dummy,false)
 call UnitAddAbility(dummy,'dGLf')
 call IssueTargetOrder(dummy,"bloodlust",caster)
 call UnitApplyTimedLife(dummy,'BTLF',2.)
 set dummy=null
endfunction
function DG_Proc takes integer p returns boolean
 if DG_Fails[p]>=3 or GetRandomInt(1,100)<=50 then
 set DG_Fails[p]=0
 return true
 endif
 set DG_Fails[p]=DG_Fails[p]+1
 return false
endfunction
function DG_Stun takes unit caster, unit target returns nothing
 local unit dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(target),GetUnitY(target),0.)
 call ShowUnit(dummy,false)
 call UnitAddAbility(dummy,'dGSt')
 call IssueTargetOrder(dummy,"thunderbolt",target)
 call UnitApplyTimedLife(dummy,'BTLF',3.)
 set dummy=null
endfunction
function DG_BaseDamage takes unit caster, integer kind, real distance returns real
 local integer raw='A11R'
 local real cost
 local real power=1.+.1*I2R(Prof_GetLevel(caster,'R009'))
 if kind==2 then
 set raw='A03M'
 elseif kind==3 then
 set raw='A14D'
 elseif kind==4 then
 set raw='A1E6'
 endif
 set cost=I2R(BlzGetAbilityManaCost(raw,Abil_GetLevel(caster,raw)))
 if kind==1 then
 return (5.*cost+3.*I2R(GetHeroStr(caster,true)))*power
 elseif kind==2 then
 return (3.*cost+4.*I2R(GetHeroStr(caster,true)))*power
 elseif kind==3 then
 return (4.*cost+4.*I2R(GetHeroStr(caster,true)))*power
 endif
 return (cost+I2R(GetHeroStr(caster,true)))*.02*(RMinBJ(1000.,distance)+200.)*power
endfunction
function DG_Area takes integer p, integer kind, real ax, real ay, real bx, real by, boolean impact returns nothing
 local unit caster=DG_Hero[p]
 local group g=CreateGroup()
 local unit target
 local real dx
 local real dy
 local real amount
 local real radius=400.
 local boolean hit
 local integer count=0
 if kind==1 then
 set radius=SquareRoot((bx-ax)*(bx-ax)+(by-ay)*(by-ay))*.5+200.
 call GroupEnumUnitsInRange(g,(ax+bx)*.5,(ay+by)*.5,radius,null)
 else
 if kind==3 then
 set radius=300.
 elseif kind==4 then
 set radius=100.
 endif
 call GroupEnumUnitsInRange(g,ax,ay,radius+200.,null)
 endif
 loop
 set target=FirstOfGroup(g)
 exitwhen target==null
 call GroupRemoveUnit(g,target)
 if DG_Enemy(caster,target) then
 set dx=GetUnitX(target)-ax
 set dy=GetUnitY(target)-ay
 set hit=false
 if kind==1 then
 set hit=not IsUnitInGroup(target,DG_Hits[p]) and (target!=DG_Target[p] or impact) and DG_Line(GetUnitX(target),GetUnitY(target),ax,ay,bx,by)
 elseif kind==2 then
 set hit=DG_Cone(dx,dy,DG_Angle[p],400.)
 else
 set hit=dx*dx+dy*dy<=radius*radius
 endif
 if hit then
 set count=count+1
 if kind==1 then
 call GroupAddUnit(DG_Hits[p],target)
 if target==DG_Target[p] then
 if LoadUnitHandle(DG_Data,GetHandleId(target),0)!=target then
 call SaveReal(DG_Data,GetHandleId(target),1,0.)
 endif
 call SaveUnitHandle(DG_Data,GetHandleId(target),0,target)
 call SaveReal(DG_Data,GetHandleId(target),1,DG_Reduction(target)+10.)
 call GroupAddUnit(DG_Debuffed,target)
 endif
 set amount=DG_BaseDamage(caster,1,0.)
 elseif kind==2 then
 set amount=DG_BaseDamage(caster,2,0.)+RMaxBJ(0.,Trig_Damage_Engine_GetAccuracy(caster)-Trig_Damage_Engine_GetEvasion(target))
 elseif kind==3 then
 set amount=DG_BaseDamage(caster,3,0.)+RMaxBJ(0.,Trig_Damage_Engine_GetAccuracy(caster)-Trig_Damage_Engine_GetEvasion(target))
 if GetWidgetLife(target)/GetUnitState(target,UNIT_STATE_MAX_LIFE)<.30 then
 set amount=amount*1.5
 endif
 call DG_Stun(caster,target)
 else
 set amount=DG_BaseDamage(caster,4,DG_Distance[p])
 endif
 call DG_Deal(caster,target,amount,kind!=3)
 if kind==1 and target==DG_Target[p] then
 call DG_Impact(caster,target)
 elseif kind==2 then
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\SweepingStrike\\SweepingStrikeTarget.mdl",target,"chest"))
 endif
 endif
 endif
 endloop
 call DestroyGroup(g)
 if kind==2 then
 call DG_Fx("Abilities\\Spells\\Human\\SweepingStrike\\SweepingStrike.mdl",ax,ay,DG_Angle[p],1.)
 if count>0 and DG_Proc(p) then
 set DG_Life[p]=DG_Now+5.
 call DG_Gate(caster,true)
 call DG_Status(caster)
 if DG_Aura[p]==null then
 set DG_Aura[p]=AddSpecialEffectTarget("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedTarget.mdl",caster,"origin")
 endif
 endif
 elseif kind==3 then
 call DG_Fx("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl",ax,ay,0.,1.)
 elseif kind==4 then
 call DG_Fx("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",ax,ay,0.,1.)
 endif
 set g=null
 set caster=null
 set target=null
endfunction
function DG_Tick takes nothing returns nothing
 local integer p=0
 local unit u
 local unit target
 local group g=CreateGroup()
 local real x
 local real y
 local real dx
 local real dy
 local real distance
 local real step
 local real endX
 local real endY
 local boolean impact
 set DG_Now=DG_Now+.03
 loop
 exitwhen p>=8
 set u=Player_GetHero(Player(p))
 if DG_Hero[p]!=null and (DG_Hero[p]!=u or not DG_Alive(DG_Hero[p])) then
 call DG_Clear(p)
 endif
 call DG_Gate(u,DG_Hero[p]==u and DG_Life[p]>DG_Now)
 if u!=null and GetUnitAbilityLevel(u,'A11T')>0 then
 call UnitRemoveAbility(u,'B00P')
 call UnitRemoveAbility(u,'B02V')
 endif
 set u=DG_Hero[p]
 if DG_Life[p]<=DG_Now and DG_Aura[p]!=null then
 call DestroyEffect(DG_Aura[p])
 set DG_Aura[p]=null
 endif
 if DG_Action[p]==1 then
 set target=DG_Target[p]
 if not DG_Enemy(u,target) or DG_Now>=DG_End[p] then
 call DG_EndMotion(p)
 else
 set x=GetUnitX(u)
 set y=GetUnitY(u)
 set dx=GetUnitX(target)-x
 set dy=GetUnitY(target)-y
 set distance=SquareRoot(dx*dx+dy*dy)
 if distance>.01 then
 call BlzSetUnitFacingEx(u,Atan2(dy,dx)*bj_RADTODEG)
 set endX=GetUnitX(target)+150.*dx/distance
 set endY=GetUnitY(target)+150.*dy/distance
 set step=RMinBJ(30.,RMaxBJ(0.,distance-90.))
 call SetUnitX(u,x+dx/distance*step)
 call SetUnitY(u,y+dy/distance*step)
 else
 set endX=x
 set endY=y
 endif
 set impact=distance<=120.
 if not impact then
 set endX=GetUnitX(u)
 set endY=GetUnitY(u)
 endif
 call DG_Area(p,1,x,y,endX,endY,impact)
 if impact then
 call DG_EndMotion(p)
 if GetUnitTypeId(u)=='H00C' then
 call SetUnitAnimationByIndex(u,1)
 else
 call SetUnitAnimation(u,"attack")
 endif
 endif
 endif
 elseif DG_Action[p]==4 then
 if DG_Alive(DG_Target[p]) then
 set DG_X[p]=GetUnitX(DG_Target[p])
 set DG_Y[p]=GetUnitY(DG_Target[p])
 endif
 set dx=DG_X[p]-GetUnitX(u)
 set dy=DG_Y[p]-GetUnitY(u)
 if dx*dx+dy*dy>.01 then
 call BlzSetUnitFacingEx(u,Atan2(dy,dx)*bj_RADTODEG)
 endif
 set step=RMaxBJ(0.,RMinBJ(1.,1.-(DG_End[p]-DG_Now)/.8))
 call SetUnitX(u,DG_FromX[p]+(DG_X[p]-DG_FromX[p])*step)
 call SetUnitY(u,DG_FromY[p]+(DG_Y[p]-DG_FromY[p])*step)
 call SetUnitFlyHeight(u,350.*Sin(step*bj_PI),0.)
 if DG_Now>=DG_End[p] then
 call DG_EndMotion(p)
 call DG_Area(p,4,DG_X[p],DG_Y[p],0.,0.,true)
 endif
 elseif DG_Action[p]>0 and DG_Now>=DG_End[p] then
 set distance=I2R(DG_Action[p])
 set DG_Action[p]=0
 call DG_Area(p,R2I(distance),DG_X[p],DG_Y[p],0.,0.,true)
 endif
 set p=p+1
 endloop
 // Purge dead/deleted targets so handle reuse cannot inherit evasion stacks.
 call GroupAddGroup(DG_Debuffed,g)
 loop
 set target=FirstOfGroup(g)
 exitwhen target==null
 call GroupRemoveUnit(g,target)
 if not DG_Alive(target) then
 call FlushChildHashtable(DG_Data,GetHandleId(target))
 call GroupRemoveUnit(DG_Debuffed,target)
 endif
 endloop
 call DestroyGroup(g)
 call DG_UIUpdate()
 set g=null
 set u=null
 set target=null
endfunction
function DG_Refund takes unit u, integer raw returns nothing
 local real paid=I2R(BlzGetUnitAbilityManaCost(u,raw,IMaxBJ(0,GetUnitAbilityLevel(u,raw)-1)))
 call SetUnitState(u,UNIT_STATE_MANA,RMinBJ(GetUnitState(u,UNIT_STATE_MAX_MANA),GetUnitState(u,UNIT_STATE_MANA)+paid))
 call BlzEndUnitAbilityCooldown(u,raw)
endfunction
function DG_Cast takes nothing returns nothing
 local unit u=GetTriggerUnit()
 local integer raw=GetSpellAbilityId()
 local integer p=GetPlayerId(GetOwningPlayer(u))
 local real duration=0.
 if p>=8 or u!=Player_GetHero(GetOwningPlayer(u)) or (raw!='A11R' and raw!='A03M' and raw!='A1E6' and raw!='A14D') then
 set u=null
 return
 endif
 if DG_Hero[p]!=u then
 call DG_Clear(p)
 set DG_Hero[p]=u
 endif
 if DG_Action[p]!=0 then
 call DG_Refund(u,raw)
 set u=null
 return
 endif
 if raw=='A14D' and DG_Life[p]<=DG_Now then
 call DG_Refund(u,raw)
 set u=null
 return
 endif
 set DG_FromX[p]=GetUnitX(u)
 set DG_FromY[p]=GetUnitY(u)
 set DG_X[p]=GetSpellTargetX()
 set DG_Y[p]=GetSpellTargetY()
 set DG_Angle[p]=Atan2(DG_Y[p]-DG_FromY[p],DG_X[p]-DG_FromX[p])
 if raw=='A11R' then
 set DG_Target[p]=GetSpellTargetUnit()
 if not DG_Enemy(u,DG_Target[p]) then
 call DG_Refund(u,raw)
 set u=null
 return
 endif
 call GroupClear(DG_Hits[p])
 set DG_Action[p]=1
 set DG_End[p]=DG_Now+3.
 set duration=4.
 call DG_Sound("DragoonCharge.ogg",DG_FromX[p],DG_FromY[p])
 call DG_Fx("Abilities\\Spells\\Other\\Stampede\\StampedeImpactDust.mdl",DG_FromX[p],DG_FromY[p],DG_Angle[p],.65)
 elseif raw=='A03M' then
 set DG_Action[p]=2
 set DG_X[p]=DG_FromX[p]
 set DG_Y[p]=DG_FromY[p]
 set DG_End[p]=DG_Now
 set duration=5.
 call BlzSetUnitFacingEx(u,DG_Angle[p]*bj_RADTODEG)
 call SetUnitAnimation(u,"attack")
 call DG_Area(p,2,DG_X[p],DG_Y[p],0.,0.,true)
 set DG_Action[p]=0
 elseif raw=='A14D' then
 set DG_Action[p]=3
 set DG_End[p]=DG_Now+.1
 set DG_Life[p]=0.
 call UnitRemoveAbility(DG_Hero[p],'BdGL')
 call DG_Gate(DG_Hero[p],false)
 call DestroyEffect(DG_Aura[p])
 set DG_Aura[p]=null
 set duration=90.
 else
 set DG_Target[p]=GetSpellTargetUnit()
 if not DG_Enemy(u,DG_Target[p]) then
 call DG_Refund(u,raw)
 set u=null
 return
 endif
 set DG_X[p]=GetUnitX(DG_Target[p])
 set DG_Y[p]=GetUnitY(DG_Target[p])
 set DG_Distance[p]=SquareRoot((DG_X[p]-DG_FromX[p])*(DG_X[p]-DG_FromX[p])+(DG_Y[p]-DG_FromY[p])*(DG_Y[p]-DG_FromY[p]))
 set DG_Action[p]=4
 set DG_End[p]=DG_Now+.8
 set duration=15.
 call UnitAddAbility(u,'Amrf')
 call UnitRemoveAbility(u,'Amrf')
 endif
 if DG_Action[p]==1 or DG_Action[p]==4 then
 call IssueImmediateOrder(u,"stop")
 call PauseUnit(u,true)
 call BlzSetUnitFacingEx(u,DG_Angle[p]*bj_RADTODEG)
 if GetUnitTypeId(u)=='H00C' then
 if DG_Action[p]==1 then
 call SetUnitAnimationByIndex(u,3)
 else
 call SetUnitAnimationByIndex(u,5)
 endif
 else
 call SetUnitAnimation(u,"stand ready")
 endif
 endif
 if GetUnitAbilityLevel(u,'Avul')>0 then
 call BlzStartUnitAbilityCooldown(u,raw,duration)
 else
 call Trig_Cooldown_Scaling_Actions()
 endif
 set u=null
endfunction
function DG_Validate takes nothing returns nothing
 local unit u=GetTriggerUnit()
 local integer raw=GetSpellAbilityId()
 local integer p=GetPlayerId(GetOwningPlayer(u))
 if p<8 and u==Player_GetHero(GetOwningPlayer(u)) then
 if (raw=='A14D' and (DG_Hero[p]!=u or DG_Life[p]<=DG_Now)) or (raw=='A1E6' and not DG_Enemy(u,GetSpellTargetUnit())) then
 call IssueImmediateOrder(u,"stop")
 endif
 endif
 set u=null
endfunction
function DG_Init takes nothing returns nothing
 local integer p=0
 local trigger t=CreateTrigger()
 set DG_Data=InitHashtable()
 set DG_Debuffed=CreateGroup()
 loop
 exitwhen p>=8
 set DG_Hits[p]=CreateGroup()
 set p=p+1
 endloop
 call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
 call TriggerAddAction(t,function DG_Cast)
 set t=CreateTrigger()
 call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
 call TriggerAddAction(t,function DG_Validate)
 call DG_UIInit()
 set DG_Timer=CreateTimer()
 call TimerStart(DG_Timer,.03,true,function DG_Tick)
 set t=null
endfunction

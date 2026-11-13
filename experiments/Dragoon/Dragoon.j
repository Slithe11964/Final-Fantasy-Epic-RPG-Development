globals
 unit Hero=null
 unit Pet=null
 unit array Foe
 integer array Stacks
 real array Stun
 texttag array Label
 integer SweepAbility='pDrB'
 integer RiseAbility='pRoD'
 integer Variant=1
 integer ProcMode=0
 real Clock=0.
 real LifeUntil=0.
 real Accuracy=100.
 real Evasion=60.
 real NextQ=0.
 real NextW=0.
 real NextR=0.
 real NextJ=0.
 unit DashTarget=null
 real DashUntil=0.
 real DashSpeed=0.
 real PendingAt=0.
 real Aim=0.
 real AimX=0.
 real AimY=0.
 integer Pending=0
 real JumpUntil=0.
 real JumpStartX=0.
 real JumpStartY=0.
 real DashImpactX=0.
 real DashImpactY=0.
 integer PreviewMode=0
 real MouseX=0.
 real MouseY=0.
 image array Rune
 framehandle ThrustButton=null
 framehandle SweepButton=null
 framehandle RiseButton=null
 framehandle RiseReady=null
 real JumpX=0.
 real JumpY=0.
 effect Aura=null
 effect ChargeAura=null
 real DashEndX=0.
 real DashEndY=0.
 real DashWidth=100.
 boolean array DashHit
 real OriginX=0.
 real OriginY=0.
 effect array TimedFx
 real array TimedFxUntil
 integer FxSlot=0
 texttag VariantTag=null
endglobals
function Say takes string s returns nothing
 call DisplayTimedTextToPlayer(Player(0),0.,0.,8.,s)
endfunction
function Fx takes string path, real x, real y returns nothing
 call DestroyEffect(AddSpecialEffect(path,x,y))
endfunction
function VariantName takes nothing returns string
 return "Campaign Dragon - selected effects"
endfunction
function SweepReach takes nothing returns real
 return 450.
endfunction
function RiseRadius takes nothing returns real
 return 300.
endfunction
function InCone takes real dx, real dy, real angle, real reach returns boolean
 local real dist=SquareRoot(dx*dx+dy*dy)
 if dist<=.01 then
 return true
 endif
 return dist<=reach and (dx*Cos(angle)+dy*Sin(angle))/dist>=.70710678
endfunction
function InCapsule takes real px, real py, real ax, real ay, real bx, real by, real radius returns boolean
 local real dx=bx-ax
 local real dy=by-ay
 local real len=dx*dx+dy*dy
 local real t=0.
 if len>.01 then
 set t=RMaxBJ(0.,RMinBJ(1.,((px-ax)*dx+(py-ay)*dy)/len))
 endif
 set dx=px-(ax+t*dx)
 set dy=py-(ay+t*dy)
 return dx*dx+dy*dy<=radius*radius
endfunction
function ConeHits takes real dx, real dy, real angle, real reach, real body returns boolean
 local real dist=SquareRoot(dx*dx+dy*dy)
 local real relative=Atan2(dy,dx)-angle
 local real nearest
 loop
 exitwhen relative<=bj_PI
 set relative=relative-2.*bj_PI
 endloop
 loop
 exitwhen relative>=-bj_PI
 set relative=relative+2.*bj_PI
 endloop
 set nearest=angle+RMaxBJ(-bj_PI/4.,RMinBJ(bj_PI/4.,relative))
 if InCone(dx,dy,angle,reach) then
 return true
 endif
 return InCapsule(dx,dy,0.,0.,reach*Cos(nearest),reach*Sin(nearest),body)
endfunction
function UpdatePreview takes nothing returns nothing
 local integer i=1
 local real x=MouseX
 local real y=MouseY
 local real startX=GetUnitX(Hero)
 local real startY=GetUnitY(Hero)
 local real a=Atan2(y-startY,x-startX)
 local real r=RiseRadius()
 local real t
 local real width=100.
 local real length
 local unit target=null
 if PreviewMode==3 then
 set target=BlzGetMouseFocusUnit()
 if target!=null and IsUnitEnemy(target,Player(0)) then
 set x=GetUnitX(target)
 set y=GetUnitY(target)
 endif
 set a=Atan2(y-startY,x-startX)
 set length=SquareRoot((x-startX)*(x-startX)+(y-startY)*(y-startY))+150.
 endif
 loop
 exitwhen i>64
 if PreviewMode==1 then
 if i<=32 then
 set t=a-bj_PI/4.+bj_PI/2.*I2R(i-1)/31.
 set x=startX+SweepReach()*Cos(t)
 set y=startY+SweepReach()*Sin(t)
 else
 set t=a-bj_PI/4.
 if i>48 then
 set t=a+bj_PI/4.
 endif
 set r=SweepReach()*I2R(ModuloInteger(i-33,16))/15.
 set x=startX+r*Cos(t)
 set y=startY+r*Sin(t)
 endif
 elseif PreviewMode==3 then
 // Only the centre line extends through the selected target.
 set t=length*I2R(i-1)/31.
 set x=startX+t*Cos(a)
 set y=startY+t*Sin(a)
 endif
 call SetImagePosition(Rune[i],x-12.,y-12.,0.)
 call ShowImage(Rune[i],PreviewMode==1 or (PreviewMode==3 and i<=32))
 set i=i+1
 endloop
 set target=null
endfunction
function PreviewKey takes nothing returns nothing
 if BlzGetTriggerPlayerKey()==OSKEY_Q then
 set PreviewMode=3
 elseif BlzGetTriggerPlayerKey()==OSKEY_W then
 set PreviewMode=1
 elseif BlzGetTriggerPlayerKey()==OSKEY_R then
 set PreviewMode=2
 else
 set PreviewMode=0
 endif
 call UpdatePreview()
endfunction
function PreviewButton takes nothing returns nothing
 if BlzGetTriggerFrame()==ThrustButton then
 set PreviewMode=3
 elseif BlzGetTriggerFrame()==SweepButton then
 set PreviewMode=1
 else
 set PreviewMode=2
 endif
 call UpdatePreview()
endfunction
function PreviewMouse takes nothing returns nothing
 if GetTriggerEventId()==EVENT_PLAYER_MOUSE_MOVE then
 if BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0. then
 set MouseX=BlzGetTriggerPlayerMouseX()
 set MouseY=BlzGetTriggerPlayerMouseY()
 endif
 else
 set PreviewMode=0
 endif
 call UpdatePreview()
endfunction
function UpdateRiseReady takes nothing returns nothing
 if RiseReady!=null then
 call BlzFrameSetVisible(RiseReady,LifeUntil>Clock and Clock>=NextR and GetWidgetLife(Hero)>.405 and IsUnitSelected(Hero,Player(0)))
 endif
endfunction
function InitPreview takes nothing returns nothing
 local integer i=1
 local trigger t=CreateTrigger()
 loop
 exitwhen i>64
 set Rune[i]=CreateImage("DragoonRune.tga",24.,24.,0.,0.,0.,0.,0.,0.,0.,2)
 call SetImageRenderAlways(Rune[i],true)
 call SetImageAboveWater(Rune[i],true,true)
 call ShowImage(Rune[i],false)
 set i=i+1
 endloop
 call BlzTriggerRegisterPlayerKeyEvent(t,Player(0),OSKEY_Q,0,true)
 call BlzTriggerRegisterPlayerKeyEvent(t,Player(0),OSKEY_W,0,true)
 call BlzTriggerRegisterPlayerKeyEvent(t,Player(0),OSKEY_R,0,true)
 call BlzTriggerRegisterPlayerKeyEvent(t,Player(0),OSKEY_ESCAPE,0,true)
 call TriggerAddAction(t,function PreviewKey)
 set t=CreateTrigger()
 call TriggerRegisterPlayerEvent(t,Player(0),EVENT_PLAYER_MOUSE_MOVE)
 call TriggerRegisterPlayerEvent(t,Player(0),EVENT_PLAYER_MOUSE_DOWN)
 call TriggerAddAction(t,function PreviewMouse)
 set ThrustButton=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,8)
 set SweepButton=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,9)
 set RiseButton=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,11)
 set RiseReady=BlzCreateFrameByType("SPRITE","DragoonRiseReady",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
 call BlzFrameSetModel(RiseReady,"UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl",0)
 call BlzFrameSetPoint(RiseReady,FRAMEPOINT_CENTER,RiseButton,FRAMEPOINT_CENTER,0.,0.)
 call BlzFrameSetSize(RiseReady,.039,.039)
 call BlzFrameSetLevel(RiseReady,5)
 call BlzFrameSetEnable(RiseReady,false)
 call BlzFrameSetVisible(RiseReady,false)
 set t=CreateTrigger()
 call BlzTriggerRegisterFrameEvent(t,ThrustButton,FRAMEEVENT_CONTROL_CLICK)
 call BlzTriggerRegisterFrameEvent(t,SweepButton,FRAMEEVENT_CONTROL_CLICK)
 call BlzTriggerRegisterFrameEvent(t,RiseButton,FRAMEEVENT_CONTROL_CLICK)
 call TriggerAddAction(t,function PreviewButton)
endfunction
function FacingFx takes string model, real x, real y, real yaw, real scale returns nothing
 set FxSlot=ModuloInteger(FxSlot,32)+1
 call DestroyEffect(TimedFx[FxSlot])
 set TimedFx[FxSlot]=AddSpecialEffect(model,x,y)
 call BlzSetSpecialEffectYaw(TimedFx[FxSlot],yaw)
 call BlzSetSpecialEffectScale(TimedFx[FxSlot],scale)
 set TimedFxUntil[FxSlot]=Clock+1.2
endfunction
function CastVisual takes integer spell returns nothing
 local string model="Abilities\\Spells\\Other\\Stampede\\StampedeImpactDust.mdl"
 local sound cue
 if spell==1 then
 call FacingFx(model,GetUnitX(Hero),GetUnitY(Hero),GetUnitFacing(Hero)*bj_DEGTORAD,.65)
 set cue=CreateSound("DragoonCharge.ogg",false,false,false,0,0,"")
 call SetSoundVolume(cue,110)
 call StartSound(cue)
 call KillSoundWhenDone(cue)
 set cue=null
 endif
endfunction
function SweepVisual takes nothing returns nothing
 call FacingFx("Abilities\\Spells\\Human\\SweepingStrike\\SweepingStrike.mdl",OriginX,OriginY,Aim,1.)
endfunction
function RiseVisual takes nothing returns nothing
 call FacingFx("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl",AimX,AimY,0.,1.)
endfunction
function LandingVisual takes nothing returns nothing
 call Fx("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",JumpX,JumpY)
endfunction
function ThrustImpact takes unit target, real fromX, real fromY returns nothing
 local real dx=GetUnitX(target)-fromX
 local real dy=GetUnitY(target)-fromY
 local real distance=SquareRoot(dx*dx+dy*dy)
 local sound cue=CreateSound("DragoonStab.ogg",false,false,false,0,0,"")
 if distance>.01 then
 call SetUnitPathing(target,false)
 call SetUnitPosition(target,GetUnitX(target)+20.*dx/distance,GetUnitY(target)+20.*dy/distance)
 call SetUnitPathing(target,true)
 endif
 call SetSoundVolume(cue,110)
 call StartSound(cue)
 call KillSoundWhenDone(cue)
 set cue=null
endfunction
function EndCharge takes nothing returns nothing
 set DashTarget=null
 call PauseUnit(Hero,false)
 call IssueImmediateOrder(Hero,"stop")
 call DestroyEffect(ChargeAura)
 set ChargeAura=null
 call SetUnitAnimationByIndex(Hero,1)
endfunction
function EndJump takes nothing returns nothing
 set JumpUntil=0.
 call SetUnitFlyHeight(Hero,0.,0.)
 call PauseUnit(Hero,false)
 call IssueImmediateOrder(Hero,"stop")
 call SetUnitAnimationByIndex(Hero,0)
endfunction
function SetupVariant takes nothing returns nothing
 call UnitRemoveAbility(Hero,'pDrB')
 call UnitRemoveAbility(Hero,'pDr2')
 call UnitRemoveAbility(Hero,'pDr3')
 call UnitRemoveAbility(Hero,'pRoD')
 call UnitRemoveAbility(Hero,'pRo2')
 call UnitRemoveAbility(Hero,'pRo3')
 set SweepAbility='pDrB'
 set RiseAbility='pRoD'
 if Variant==2 then
 set SweepAbility='pDr2'
 set RiseAbility='pRo2'
 elseif Variant==3 then
 set SweepAbility='pDr3'
 set RiseAbility='pRo3'
 endif
 call UnitAddAbility(Hero,SweepAbility)
 call UnitAddAbility(Hero,RiseAbility)
 call BlzSetAbilityRealLevelField(BlzGetUnitAbility(Hero,SweepAbility),ABILITY_RLF_ATTACK_DISTANCE_SWP2,0,SweepReach())
 call BlzSetAbilityRealLevelField(BlzGetUnitAbility(Hero,SweepAbility),ABILITY_RLF_ATTACK_ANGLE_SWP3,0,90.)
 call BlzSetAbilityRealLevelField(BlzGetUnitAbility(Hero,RiseAbility),ABILITY_RLF_AREA_OF_EFFECT,0,RiseRadius())
 call BlzSetUnitName(Hero,"Dragoon - "+VariantName())
 call BlzSetAbilityExtendedTooltip(SweepAbility,"Garek-style Sweeping Strike. 90-degree cone, reach "+R2SW(SweepReach(),1,0)+". Adds max(0, accuracy - target evasion). One 50% Life of the Dragon roll per cast that hits.",0)
 call BlzSetAbilityExtendedTooltip(RiseAbility,"Requires Life of the Dragon. Radius "+R2SW(RiseRadius(),1,0)+"; 1.5s stun. Adds accuracy minus target evasion. 50% extra damage strictly below 30% HP.",0)
 call SetUnitVertexColor(Hero,255,255,255,255)
 call Say("Selected campaign effects. Q centre-line charge; W 90-degree/450 sweep; R single native targeting rune.")
endfunction

function EffectiveEvasion takes integer i returns real
 return RMaxBJ(0.,Evasion-10.*I2R(Stacks[i]))
endfunction
function PrecisionBonus takes integer i returns real
 return RMaxBJ(0.,Accuracy-EffectiveEvasion(i))
endfunction
function Hit takes integer i, real amount returns nothing
 call UnitDamageTarget(Hero,Foe[i],amount,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
 call Say("Target "+I2S(i)+": "+R2SW(amount,1,0)+" damage; evasion "+R2SW(EffectiveEvasion(i),1,0)+"; stacks "+I2S(Stacks[i]))
endfunction
function Reset takes nothing returns nothing
 local integer i=1
 call PauseUnit(Hero,false)
 call IssueImmediateOrder(Hero,"stop")
 call DestroyEffect(ChargeAura)
 set ChargeAura=null
 set DashTarget=null
 set PreviewMode=0
 set Pending=0
 set JumpUntil=0.
 call SetUnitFlyHeight(Hero,0.,0.)
 call SetUnitVertexColor(Hero,255,255,255,255)
 call SetUnitPosition(Hero,-450.,0.)
 call SetUnitState(Hero,UNIT_STATE_LIFE,5000.)
 call SetUnitState(Hero,UNIT_STATE_MANA,2000.)
 set LifeUntil=0.
 set NextQ=0.
 set NextW=0.
 set NextR=0.
 set NextJ=0.
 call DestroyEffect(Aura)
 set Aura=null
 call RemoveUnit(Pet)
 set Pet=null
 loop
 exitwhen i>7
 if Foe[i]!=null then
 call RemoveUnit(Foe[i])
 endif
 if i==1 then
 set Foe[i]=CreateUnit(Player(11),'u01M',250.,0.,180.)
 elseif i==2 then
 set Foe[i]=CreateUnit(Player(11),'u01M',-100.,0.,180.)
 elseif i==3 then
 set Foe[i]=CreateUnit(Player(11),'u01M',360.,0.,180.)
 elseif i==4 then
 set Foe[i]=CreateUnit(Player(11),'u01M',650.,0.,180.)
 elseif i==5 then
 set Foe[i]=CreateUnit(Player(11),'u01M',-450.+300.*Cos(29.*bj_DEGTORAD),300.*Sin(29.*bj_DEGTORAD),180.)
 elseif i==6 then
 set Foe[i]=CreateUnit(Player(11),'u01M',-450.+300.*Cos(-29.*bj_DEGTORAD),300.*Sin(-29.*bj_DEGTORAD),180.)
 else
 set Foe[i]=CreateUnit(Player(11),'u01M',-450.+300.*Cos(40.*bj_DEGTORAD),300.*Sin(40.*bj_DEGTORAD),180.)
 endif
 set Stacks[i]=0
 set Stun[i]=0.
 set DashHit[i]=false
 set i=i+1
 endloop
 call BlzEndUnitAbilityCooldown(Hero,'pSTh')
 call BlzEndUnitAbilityCooldown(Hero,SweepAbility)
 call BlzEndUnitAbilityCooldown(Hero,RiseAbility)
 call BlzEndUnitAbilityCooldown(Hero,'pJmp')
 call SetUnitTimeScale(Hero,1.)
 call SetupVariant()
 call UpdateRiseReady()
 call Say("Reset. Variant "+I2S(Variant)+". Q thrust, W sweep, E Jump, R Rise, D dragon. -help for controls.")
endfunction
function Resolve takes nothing returns nothing
 local integer i=1
 local integer count=0
 local real dx
 local real dy
 local real dist
 local real dot
 local real damage
 local real reach=SweepReach()
 loop
 exitwhen i>7
 if GetWidgetLife(Foe[i])>.405 then
 if Pending==1 then
 set dx=GetUnitX(Foe[i])-OriginX
 set dy=GetUnitY(Foe[i])-OriginY
 set dist=SquareRoot(dx*dx+dy*dy)
 set dot=(dx*Cos(Aim)+dy*Sin(Aim))/RMaxBJ(1.,dist)
 if ConeHits(dx,dy,Aim,reach,BlzGetUnitCollisionSize(Foe[i])) then
 set damage=120.+2.*I2R(GetHeroInt(Hero,true))+PrecisionBonus(i)
 call Fx("Abilities\\Spells\\Human\\SweepingStrike\\SweepingStrikeTarget.mdl",GetUnitX(Foe[i]),GetUnitY(Foe[i]))
 call Hit(i,damage)
 set count=count+1
 endif
 else
 set dx=GetUnitX(Foe[i])-AimX
 set dy=GetUnitY(Foe[i])-AimY
 if dx*dx+dy*dy<=RiseRadius()*RiseRadius() then
 set damage=250.+4.*I2R(GetHeroInt(Hero,true))+PrecisionBonus(i)
 if GetWidgetLife(Foe[i])/GetUnitState(Foe[i],UNIT_STATE_MAX_LIFE)<.30 then
 set damage=damage*1.5
 call Say("Below 30%: Rise bonus!")
 endif
 call Hit(i,damage)
 set Stun[i]=Clock+1.5
 call PauseUnit(Foe[i],true)
 call Fx("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",GetUnitX(Foe[i]),GetUnitY(Foe[i]))
 endif
 endif
 endif
 set i=i+1
 endloop
 if Pending==1 then
 call SweepVisual()
 if count>0 and (ProcMode==1 or (ProcMode==0 and GetRandomInt(1,100)<=50)) then
 set LifeUntil=Clock+5.
 if Aura==null then
 set Aura=AddSpecialEffectTarget("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedTarget.mdl",Hero,"origin")
 endif
 call Say("Life of the Dragon! 5 seconds to cast R.")
 elseif count>0 then
 call Say("Drakesbane hit; Life of the Dragon did not proc.")
 else
 call Say("Drakesbane missed: no proc roll.")
 endif
 else
 call RiseVisual()
 endif
 call SetUnitTimeScale(Hero,1.)
 set Pending=0
 call UpdateRiseReady()
endfunction
function Tick takes nothing returns nothing
 local integer i=1
 local real dx
 local real dy
 local real dist
 local real oldX
 local real oldY
 local real step
 local real damage
 call UpdatePreview()
 set Clock=Clock+.03
 call UpdateRiseReady()
 if LifeUntil<=Clock and Aura!=null then
 call DestroyEffect(Aura)
 set Aura=null
 call Say("Life of the Dragon ended.")
 endif
 if Pending!=0 and Clock>=PendingAt then
 call Resolve()
 endif
 if DashTarget!=null then
 if GetWidgetLife(Hero)<=.405 then
 call EndCharge()
 else
 set oldX=GetUnitX(Hero)
 set oldY=GetUnitY(Hero)
 set dx=GetUnitX(DashTarget)-oldX
 set dy=GetUnitY(DashTarget)-oldY
 set dist=SquareRoot(dx*dx+dy*dy)
 if dist>.01 then
 call BlzSetUnitFacingEx(Hero,Atan2(dy,dx)*bj_RADTODEG)
 set DashEndX=oldX+RMaxBJ(0.,dist-90.)*dx/dist
 set DashEndY=oldY+RMaxBJ(0.,dist-90.)*dy/dist
 set DashImpactX=GetUnitX(DashTarget)+150.*dx/dist
 set DashImpactY=GetUnitY(DashTarget)+150.*dy/dist
 endif
 set dx=DashEndX-oldX
 set dy=DashEndY-oldY
 set dist=SquareRoot(dx*dx+dy*dy)
 set step=RMinBJ(dist,DashSpeed*.03)
 if dist>.01 then
 call SetUnitX(Hero,oldX+dx/dist*step)
 call SetUnitY(Hero,oldY+dy/dist*step)
 endif
 set dx=GetUnitX(Hero)
 set dy=GetUnitY(Hero)
 if dist<=step+.01 then
 set dx=DashImpactX
 set dy=DashImpactY
 endif
 set i=1
 loop
 exitwhen i>7
 if not DashHit[i] and (Foe[i]!=DashTarget or dist<=step+.01) and GetWidgetLife(Foe[i])>.405 and InCapsule(GetUnitX(Foe[i]),GetUnitY(Foe[i]),oldX,oldY,dx,dy,DashWidth) then
 set DashHit[i]=true
 if Foe[i]==DashTarget then
 set Stacks[i]=Stacks[i]+1
 endif
 set damage=100.+2.*I2R(GetHeroInt(Hero,true))
 call Hit(i,damage)
 if Foe[i]==DashTarget then
 call ThrustImpact(Foe[i],oldX,oldY)
 endif
 endif
 set i=i+1
 endloop
 if dist<=step+.01 or Clock>=DashUntil then
 call EndCharge()
 endif
 endif
 endif
 if JumpUntil>0. then
 if GetWidgetLife(Hero)<=.405 then
 call EndJump()
 else
 set dx=JumpX-GetUnitX(Hero)
 set dy=JumpY-GetUnitY(Hero)
 if dx*dx+dy*dy>.01 then
 call BlzSetUnitFacingEx(Hero,Atan2(dy,dx)*bj_RADTODEG)
 endif
 if Clock>=JumpUntil then
 call SetUnitX(Hero,JumpX)
 call SetUnitY(Hero,JumpY)
 call EndJump()
 set i=1
 loop
 exitwhen i>7
 set dx=GetUnitX(Foe[i])-JumpX
 set dy=GetUnitY(Foe[i])-JumpY
 if dx*dx+dy*dy<=22500. and GetWidgetLife(Foe[i])>.405 then
 call Hit(i,300.+3.*I2R(GetHeroInt(Hero,true)))
 endif
 set i=i+1
 endloop
 call LandingVisual()
 else
 set step=RMaxBJ(0.,RMinBJ(1.,1.-(JumpUntil-Clock)/.8))
 call SetUnitX(Hero,JumpStartX+(JumpX-JumpStartX)*step)
 call SetUnitY(Hero,JumpStartY+(JumpY-JumpStartY)*step)
 call SetUnitFlyHeight(Hero,350.*Sin(step*bj_PI),0.)
 endif
 endif
 endif
 set i=1
 loop
 exitwhen i>32
 if TimedFx[i]!=null and Clock>=TimedFxUntil[i] then
 call DestroyEffect(TimedFx[i])
 set TimedFx[i]=null
 endif
 set i=i+1
 endloop
 call SetTextTagText(VariantTag,VariantName(),.022)
 call SetTextTagPosUnit(VariantTag,Hero,160.)
 set i=1
 loop
 exitwhen i>7
 if Stun[i]>0. and Clock>=Stun[i] then
 call PauseUnit(Foe[i],false)
 set Stun[i]=0.
 endif
 call SetTextTagText(Label[i],I2S(i)+" | evasion "+R2SW(EffectiveEvasion(i),1,0)+" | stacks "+I2S(Stacks[i]),.018)
 call SetTextTagPosUnit(Label[i],Foe[i],100.)
 set i=i+1
 endloop
endfunction
function Cast takes nothing returns nothing
 local integer id=GetSpellAbilityId()
 local real dx
 local real dy
 local real dist
 local integer i=1
 if GetTriggerUnit()!=Hero then
 return
 endif
 if DashTarget!=null or Pending!=0 or JumpUntil>0. then
 call Say("Finish the current action first.")
 return
 endif
 set PreviewMode=0
 call UpdatePreview()
 if id=='pSTh' then
 if Clock<NextQ then
 call Say("Sonic Thrust cooldown: "+R2SW(NextQ-Clock,1,1))
 return
 endif
 set DashTarget=GetSpellTargetUnit()
 if DashTarget==null then
 return
 endif
 set dx=GetUnitX(DashTarget)-GetUnitX(Hero)
 set dy=GetUnitY(DashTarget)-GetUnitY(Hero)
 set dist=SquareRoot(dx*dx+dy*dy)
 if dist<1. then
 set dx=Cos(GetUnitFacing(Hero)*bj_DEGTORAD)
 set dy=Sin(GetUnitFacing(Hero)*bj_DEGTORAD)
 set dist=1.
 endif
 set DashEndX=GetUnitX(Hero)+RMaxBJ(0.,dist-90.)*dx/dist
 set DashEndY=GetUnitY(Hero)+RMaxBJ(0.,dist-90.)*dy/dist
 set DashImpactX=GetUnitX(DashTarget)+150.*dx/dist
 set DashImpactY=GetUnitY(DashTarget)+150.*dy/dist
 set DashSpeed=1000.
 set DashWidth=100.
 set NextQ=Clock+4.
 set DashUntil=Clock+3.
 loop
 exitwhen i>7
 set DashHit[i]=false
 set i=i+1
 endloop
 call IssueImmediateOrder(Hero,"stop")
 call PauseUnit(Hero,true)
 call BlzSetUnitFacingEx(Hero,Atan2(dy,dx)*bj_RADTODEG)
 call SetUnitAnimationByIndex(Hero,3)
 call CastVisual(1)
 call BlzStartUnitAbilityCooldown(Hero,'pSTh',NextQ-Clock)
 elseif id==SweepAbility or id==RiseAbility then
 if id==RiseAbility and (LifeUntil<=Clock or Clock<NextR) then
 call Say("Rise requires Life of the Dragon and a ready cooldown.")
 return
 endif
 if id==SweepAbility and Clock<NextW then
 call Say("Drakesbane cooldown: "+R2SW(NextW-Clock,1,1))
 return
 endif
 set OriginX=GetUnitX(Hero)
 set OriginY=GetUnitY(Hero)
 set AimX=GetSpellTargetX()
 set AimY=GetSpellTargetY()
 set Aim=Atan2(AimY-GetUnitY(Hero),AimX-GetUnitX(Hero))
 call SetUnitFacing(Hero,Aim*bj_RADTODEG)
 call SetUnitAnimation(Hero,"attack")
 set Pending=1
 if id==SweepAbility then
 set NextW=Clock+5.
 endif
 if id==RiseAbility then
 set Pending=2
 set LifeUntil=0.
 call UpdateRiseReady()
 set NextR=Clock+10.
 endif
 set PendingAt=Clock+.1
 if Pending==1 then
 call BlzStartUnitAbilityCooldown(Hero,SweepAbility,NextW-Clock)
 else
 call BlzStartUnitAbilityCooldown(Hero,RiseAbility,NextR-Clock)
 endif
 elseif id=='pJmp' then
 if Clock<NextJ then
 call Say("Jump cooldown: "+R2SW(NextJ-Clock,1,1))
 return
 endif
 set JumpStartX=GetUnitX(Hero)
 set JumpStartY=GetUnitY(Hero)
 set JumpX=GetSpellTargetX()
 set JumpY=GetSpellTargetY()
 call IssueImmediateOrder(Hero,"stop")
 call PauseUnit(Hero,true)
 call BlzSetUnitFacingEx(Hero,Atan2(JumpY-JumpStartY,JumpX-JumpStartX)*bj_RADTODEG)
 call SetUnitAnimationByIndex(Hero,5)
 set JumpUntil=Clock+.8
 set NextJ=Clock+15.
 call BlzStartUnitAbilityCooldown(Hero,'pJmp',15.)
 call UnitAddAbility(Hero,'Amrf')
 call UnitRemoveAbility(Hero,'Amrf')
 elseif id=='pSum' then
 call RemoveUnit(Pet)
 set Pet=CreateUnit(Player(0),'nrdr',GetUnitX(Hero)-100.,GetUnitY(Hero),0.)
 call Say("Prototype dragon companion summoned.")
 endif
endfunction
function Chat takes nothing returns nothing
 local string s=GetEventPlayerChatString()
 local integer i=1
 if s=="-variant 1" or s=="-variant 2" or s=="-variant 3" then
 set Variant=1
 call Reset()
 elseif s=="-reset" then
 call Reset()
 elseif s=="-proc on" then
 set ProcMode=1
 elseif s=="-proc off" then
 set ProcMode=2
 elseif s=="-proc random" or s=="-combo" then
 set ProcMode=0
 call Say("Combo mode: real 50% proc chance.")
 elseif SubString(s,0,4)=="-hp " then
 loop
 exitwhen i>7
 call SetUnitState(Foe[i],UNIT_STATE_LIFE,GetUnitState(Foe[i],UNIT_STATE_MAX_LIFE)*S2R(SubString(s,4,StringLength(s)))/100.)
 set i=i+1
 endloop
 elseif SubString(s,0,10)=="-accuracy " then
 set Accuracy=S2R(SubString(s,10,StringLength(s)))
 elseif SubString(s,0,9)=="-evasion " then
 set Evasion=S2R(SubString(s,9,StringLength(s)))
 elseif s=="-life" then
 call Say("Life remaining: "+R2SW(RMaxBJ(0.,LifeUntil-Clock),1,1))
 else
 call Say("Q thrust / W 90-degree sweep / R Rise / E Jump / D dragon. -variant 1/2/3; -reset; -proc on/off/random; -combo; -hp 29/30/31/100; -accuracy 100; -evasion 60; -life. Stacks last until reset in this prototype.")
 endif
endfunction
function main_old takes nothing returns nothing
 local trigger t
 local integer i=1
 call SetCameraBounds(-2304.,-2304.,2304.,2304.,-2304.,2304.,2304.,-2304.)
 call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl","Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
 call InitBlizzard()
 call FogEnable(false)
 call FogMaskEnable(false)
 set Hero=CreateUnit(Player(0),'H00C',-450.,0.,0.)
 call SetHeroInt(Hero,100,true)
 set VariantTag=CreateTextTag()
 call SetTextTagPermanent(VariantTag,true)
 call Reset()
 loop
 exitwhen i>7
 set Label[i]=CreateTextTag()
 call SetTextTagPermanent(Label[i],true)
 set i=i+1
 endloop
 set t=CreateTrigger()
 call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
 call TriggerAddAction(t,function Cast)
 set t=CreateTrigger()
 call TriggerRegisterPlayerChatEvent(t,Player(0),"-",false)
 call TriggerAddAction(t,function Chat)
 call InitPreview()
 call TimerStart(CreateTimer(),.03,true,function Tick)
 if GetLocalPlayer()==Player(0) then
 call ClearSelection()
 call SelectUnit(Hero,true)
 call SetCameraPosition(0.,0.)
 call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,1650.,0.)
 endif
endfunction
function InitTrig_DaggerPrototype takes nothing returns nothing
 call main_old()
endfunction
function main takes nothing returns nothing
 call main_old()
endfunction
function config takes nothing returns nothing
endfunction

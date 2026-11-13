globals
 boolean D7ReviewNoCollision=false
 framehandle D7BadgeRoot=null
 framehandle D7BadgeBuffBar=null
 framehandle array D7BadgeIcon
 framehandle array D7BadgeText
 integer array D7BadgeLastKind
 integer array D7BadgeLastCount
 trigger D7BadgeEvents=null
 trigger D7BadgeLoad=null
 unit D7BadgeSelected=null
 boolean D7BadgeShown=false
endglobals

function D7_BadgeCount takes unit u,integer kind returns integer
 local integer id=GetHandleId(u)
 local integer pid=GetPlayerId(GetLocalPlayer())
 if kind==0 then
 return LoadInteger(I2Data,id,72)
 elseif kind==1 then
 return LoadInteger(D2Data,id,82)
 elseif kind==2 then
 return F99_Count(u,2)
 elseif kind==3 then
 return F99_Count(u,1)
 elseif kind==4 then
 return F99_Count(u,3)
 elseif kind==5 then
 return LoadInteger(D2Data,id,90)
 elseif kind==6 then
 if DG_Data!=null and LoadUnitHandle(DG_Data,id,0)==u then
 return R2I(LoadReal(DG_Data,id,1)/5.)
 endif
 return 0
 elseif pid<8 and CutsTarget[pid]==u then
 // Each viewer sees only their own Thief's daggers, never pooled damage.
 return CutsCount[pid]
 endif
 return 0
endfunction

function D7_BadgeArt takes integer kind returns string
 if kind==0 then
 return BlzGetAbilityIcon('jIM2')
 elseif kind==1 then
 return BlzGetAbilityIcon('dPB2')
 elseif kind==2 then
 return BlzGetAbilityIcon('zSL9')
 elseif kind==3 then
 return BlzGetAbilityIcon('zAM9')
 elseif kind==4 then
 return BlzGetAbilityIcon('zAS9')
 elseif kind==5 then
 return BlzGetAbilityIcon('dFR2')
 elseif kind==6 then
 return "ReplaceableTextures\\CommandButtons\\BTNImpale.blp"
 endif
 return BlzGetAbilityIcon('A0KY')
endfunction

function D7_BadgeDraw takes nothing returns nothing
 local integer kind=0
 local integer slot=0
 local integer count=0
 local boolean available=true
 if D7BadgeRoot==null then
 return
 endif
 if D7BadgeSelected==null or GetUnitTypeId(D7BadgeSelected)==0 or GetWidgetLife(D7BadgeSelected)<=.405 or not IsUnitSelected(D7BadgeSelected,GetLocalPlayer()) or Inventory94Paused or InventoryCinematicActive or udg_InCinematicMode then
 set available=false
 elseif D7BadgeBuffBar!=null and not BlzFrameIsVisible(D7BadgeBuffBar) then
 set available=false
 endif
 if available then
 loop
 exitwhen kind>=8
 set count=D7_BadgeCount(D7BadgeSelected,kind)
 if count>0 then
 if D7BadgeLastKind[slot]!=kind then
 call BlzFrameSetTexture(D7BadgeIcon[slot],D7_BadgeArt(kind),0,true)
 set D7BadgeLastKind[slot]=kind
 endif
 if D7BadgeLastCount[slot]!=count then
 call BlzFrameSetText(D7BadgeText[slot],I2S(count))
 set D7BadgeLastCount[slot]=count
 endif
 call BlzFrameSetVisible(D7BadgeIcon[slot],true)
 call BlzFrameSetVisible(D7BadgeText[slot],true)
 set slot=slot+1
 endif
 set kind=kind+1
 endloop
 endif
 if (slot>0)!=D7BadgeShown then
 set D7BadgeShown=slot>0
 call BlzFrameSetVisible(D7BadgeRoot,D7BadgeShown)
 endif
 loop
 exitwhen slot>=8
 call BlzFrameSetVisible(D7BadgeIcon[slot],false)
 call BlzFrameSetVisible(D7BadgeText[slot],false)
 set slot=slot+1
 endloop
endfunction

function D7_BadgeSelection takes nothing returns nothing
 if GetLocalPlayer()==GetTriggerPlayer() then
 if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED then
 set D7BadgeSelected=GetTriggerUnit()
 elseif D7BadgeSelected==GetTriggerUnit() then
 set D7BadgeSelected=null
 endif
 call D7_BadgeDraw()
 endif
endfunction

function D7_BadgeFrames takes nothing returns nothing
 local framehandle parent=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
 local integer i=0
 if D7BadgeRoot!=null then
 return
 endif
 // Resolve native anchors once, and create every custom frame on all clients.
 set D7BadgeBuffBar=BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR,0)
 set D7BadgeRoot=BlzCreateFrameByType("FRAME","D7StackBadges",parent,"",0)
 call BlzFrameSetSize(D7BadgeRoot,.148,.038)
 call BlzFrameSetEnable(D7BadgeRoot,false)
 call BlzFrameSetLevel(D7BadgeRoot,60)
 if D7BadgeBuffBar!=null then
 call BlzFrameSetPoint(D7BadgeRoot,FRAMEPOINT_BOTTOMLEFT,D7BadgeBuffBar,FRAMEPOINT_TOPLEFT,0.,.003)
 else
 call BlzFrameSetAbsPoint(D7BadgeRoot,FRAMEPOINT_BOTTOMLEFT,.255,.07)
 endif
 loop
 exitwhen i>=8
 set D7BadgeIcon[i]=BlzCreateFrameByType("BACKDROP","D7StackIcon",D7BadgeRoot,"",i)
 call BlzFrameSetSize(D7BadgeIcon[i],.016,.016)
 call BlzFrameSetPoint(D7BadgeIcon[i],FRAMEPOINT_TOPLEFT,D7BadgeRoot,FRAMEPOINT_TOPLEFT,.037*I2R(ModuloInteger(i,4)),-.019*I2R(i/4))
 call BlzFrameSetEnable(D7BadgeIcon[i],false)
 set D7BadgeText[i]=BlzCreateFrameByType("TEXT","D7StackCount",D7BadgeRoot,"",i)
 call BlzFrameSetSize(D7BadgeText[i],.021,.016)
 call BlzFrameSetPoint(D7BadgeText[i],FRAMEPOINT_LEFT,D7BadgeIcon[i],FRAMEPOINT_RIGHT,.001,0.)
 call BlzFrameSetFont(D7BadgeText[i],"Fonts\\FRIZQT__.TTF",.011,0)
 call BlzFrameSetTextAlignment(D7BadgeText[i],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_LEFT)
 call BlzFrameSetEnable(D7BadgeText[i],false)
 set D7BadgeLastKind[i]=-1
 set D7BadgeLastCount[i]=-1
 set i=i+1
 endloop
 set D7BadgeShown=false
 call BlzFrameSetVisible(D7BadgeRoot,false)
 set parent=null
endfunction

function D7_BadgeRebuild takes nothing returns nothing
 // Warcraft saved games discard frame objects, but retain synchronized triggers.
 call DestroyTimer(GetExpiredTimer())
 set D7BadgeRoot=null
 set D7BadgeSelected=null
 call D7_BadgeFrames()
endfunction

function D7_BadgeLoaded takes nothing returns nothing
 // Let the native UI finish restoring before resolving its anchors again.
 call TimerStart(CreateTimer(),0.,false,function D7_BadgeRebuild)
endfunction

function D7_BadgeInit takes nothing returns nothing
 local integer i=0
 call D7_BadgeFrames()
 if D7BadgeEvents==null then
 set D7BadgeEvents=CreateTrigger()
 loop
 exitwhen i>=8
 call TriggerRegisterPlayerUnitEvent(D7BadgeEvents,Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
 call TriggerRegisterPlayerUnitEvent(D7BadgeEvents,Player(i),EVENT_PLAYER_UNIT_DESELECTED,null)
 set i=i+1
 endloop
 call TriggerAddAction(D7BadgeEvents,function D7_BadgeSelection)
 set D7BadgeLoad=CreateTrigger()
 call TriggerRegisterGameEvent(D7BadgeLoad,EVENT_GAME_LOADED)
 call TriggerAddAction(D7BadgeLoad,function D7_BadgeLoaded)
 endif
endfunction

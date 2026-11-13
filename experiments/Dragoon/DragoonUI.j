globals
 integer DG_UIMode=0
 real DG_MouseX=0.
 real DG_MouseY=0.
 image array DG_Rune
 framehandle Cuts_Ready=null
 framehandle DG_Ready=null
 framehandle DG_Q=null
 framehandle DG_W=null
 framehandle DG_R=null
endglobals

function DG_UIUpdate takes nothing returns nothing
 local integer p=GetPlayerId(GetLocalPlayer())
 local unit u=Player_GetHero(GetLocalPlayer())
 local unit focus=null
 local integer i=1
 local real x=DG_MouseX
 local real y=DG_MouseY
 local real angle=0.
 local real length=0.
 local real t
 local real radius
 local boolean show=false
 call BlzFrameSetVisible(Cuts_Ready,p<8 and u!=null and CutsCaster[p]==u and CutsActive[p] and not CutsRipping[p] and DG_Alive(u) and IsUnitSelected(u,GetLocalPlayer()))
 if p<8 and u!=null then
 call BlzFrameSetVisible(DG_Ready,GetUnitAbilityLevel(u,'A14D')>0 and DG_Hero[p]==u and DG_Life[p]>DG_Now and DG_Alive(u) and IsUnitSelected(u,GetLocalPlayer()) and BlzGetUnitAbilityCooldownRemaining(u,'A14D')<=0.)
 if DG_UIMode>0 and not IsUnitSelected(u,GetLocalPlayer()) then
 set DG_UIMode=0
 endif
 if DG_UIMode==1 and GetUnitAbilityLevel(u,'A03M')>0 then
 set show=true
 elseif DG_UIMode==3 and GetUnitAbilityLevel(u,'A11R')>0 then
 set show=true
 set focus=BlzGetMouseFocusUnit()
 if focus!=null and IsUnitEnemy(focus,GetLocalPlayer()) then
 set x=GetUnitX(focus)
 set y=GetUnitY(focus)
 endif
 endif
 set angle=Atan2(y-GetUnitY(u),x-GetUnitX(u))
 set length=SquareRoot((x-GetUnitX(u))*(x-GetUnitX(u))+(y-GetUnitY(u))*(y-GetUnitY(u)))+150.
 else
 call BlzFrameSetVisible(DG_Ready,false)
 endif
 loop
 exitwhen i>64
 if show then
 if DG_UIMode==1 then
 if i<=32 then
 set t=angle-bj_PI/2.+bj_PI*I2R(i-1)/31.
 set x=GetUnitX(u)+400.*Cos(t)
 set y=GetUnitY(u)+400.*Sin(t)
 else
 set t=angle-bj_PI/2.
 if i>48 then
 set t=angle+bj_PI/2.
 endif
 set radius=400.*I2R(ModuloInteger(i-33,16))/15.
 set x=GetUnitX(u)+radius*Cos(t)
 set y=GetUnitY(u)+radius*Sin(t)
 endif
 else
 set t=length*I2R(i-1)/31.
 set x=GetUnitX(u)+t*Cos(angle)
 set y=GetUnitY(u)+t*Sin(angle)
 endif
 call SetImagePosition(DG_Rune[i],x-12.,y-12.,0.)
 endif
 call ShowImage(DG_Rune[i],show and (DG_UIMode==1 or i<=32))
 set i=i+1
 endloop
 set u=null
 set focus=null
endfunction
function DG_UIKey takes nothing returns nothing
 if GetLocalPlayer()==GetTriggerPlayer() then
 if BlzGetTriggerPlayerKey()==OSKEY_Q then
 set DG_UIMode=3
 elseif BlzGetTriggerPlayerKey()==OSKEY_W then
 set DG_UIMode=1
 else
 set DG_UIMode=0
 endif
 endif
endfunction
function DG_UIMouse takes nothing returns nothing
 if GetLocalPlayer()==GetTriggerPlayer() then
 if GetTriggerEventId()==EVENT_PLAYER_MOUSE_MOVE then
 if BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0. then
 set DG_MouseX=BlzGetTriggerPlayerMouseX()
 set DG_MouseY=BlzGetTriggerPlayerMouseY()
 endif
 else
 set DG_UIMode=0
 endif
 endif
endfunction
function DG_UIButton takes nothing returns nothing
 if GetLocalPlayer()==GetTriggerPlayer() then
 if BlzGetTriggerFrame()==DG_Q then
 set DG_UIMode=3
 elseif BlzGetTriggerFrame()==DG_W then
 set DG_UIMode=1
 else
 set DG_UIMode=0
 endif
 endif
endfunction
function DG_UIInit takes nothing returns nothing
 local integer i=1
 local integer p=0
 local trigger keys=CreateTrigger()
 local trigger mouse=CreateTrigger()
 local trigger buttons=CreateTrigger()
 loop
 exitwhen i>64
 set DG_Rune[i]=CreateImage("DragoonRune.tga",24.,24.,0.,0.,0.,0.,0.,0.,0.,2)
 call SetImageRenderAlways(DG_Rune[i],true)
 call SetImageAboveWater(DG_Rune[i],true,true)
 call ShowImage(DG_Rune[i],false)
 set i=i+1
 endloop
 set DG_Q=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,8)
 set DG_W=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,9)
 set DG_R=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,5)
 set Cuts_Ready=BlzCreateFrameByType("SPRITE","ThousandCutsActive",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
 call BlzFrameSetModel(Cuts_Ready,"UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl",0)
 call BlzFrameSetPoint(Cuts_Ready,FRAMEPOINT_CENTER,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,5),FRAMEPOINT_CENTER,0.,0.)
 call BlzFrameSetSize(Cuts_Ready,.039,.039)
 call BlzFrameSetLevel(Cuts_Ready,5)
 call BlzFrameSetEnable(Cuts_Ready,false)
 call BlzFrameSetVisible(Cuts_Ready,false)
 set DG_Ready=BlzCreateFrameByType("SPRITE","DragoonRiseReady",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
 call BlzFrameSetModel(DG_Ready,"UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl",0)
 call BlzFrameSetPoint(DG_Ready,FRAMEPOINT_CENTER,DG_R,FRAMEPOINT_CENTER,0.,0.)
 call BlzFrameSetSize(DG_Ready,.039,.039)
 call BlzFrameSetLevel(DG_Ready,5)
 call BlzFrameSetEnable(DG_Ready,false)
 call BlzFrameSetVisible(DG_Ready,false)
 loop
 exitwhen p>=8
 call BlzTriggerRegisterPlayerKeyEvent(keys,Player(p),OSKEY_Q,0,true)
 call BlzTriggerRegisterPlayerKeyEvent(keys,Player(p),OSKEY_W,0,true)
 call BlzTriggerRegisterPlayerKeyEvent(keys,Player(p),OSKEY_R,0,true)
 call BlzTriggerRegisterPlayerKeyEvent(keys,Player(p),OSKEY_ESCAPE,0,true)
 call TriggerRegisterPlayerEvent(mouse,Player(p),EVENT_PLAYER_MOUSE_MOVE)
 call TriggerRegisterPlayerEvent(mouse,Player(p),EVENT_PLAYER_MOUSE_DOWN)
 set p=p+1
 endloop
 call TriggerAddAction(keys,function DG_UIKey)
 call TriggerAddAction(mouse,function DG_UIMouse)
 call BlzTriggerRegisterFrameEvent(buttons,DG_Q,FRAMEEVENT_CONTROL_CLICK)
 call BlzTriggerRegisterFrameEvent(buttons,DG_W,FRAMEEVENT_CONTROL_CLICK)
 call BlzTriggerRegisterFrameEvent(buttons,DG_R,FRAMEEVENT_CONTROL_CLICK)
 call TriggerAddAction(buttons,function DG_UIButton)
 set keys=null
 set mouse=null
 set buttons=null
endfunction

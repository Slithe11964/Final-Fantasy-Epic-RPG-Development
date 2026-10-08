function Forsaken_DefensePercent takes integer defense returns real
    return 100.*I2R(defense)/I2R(defense+50)
endfunction

function Forsaken_TalentRank takes unit hero returns integer
    return IMinBJ(4,IMaxBJ(1,GetUnitAbilityLevel(hero,'A02F')))
endfunction

function Forsaken_TalentCanPurchase takes integer key,integer node,integer rank returns boolean
    local integer row=node/3
    local integer column=0
    if node<0 or node>=12 or row>=rank then
        return false
    endif
    loop
        exitwhen column>=3
        if LoadBoolean(ForsakenTalentState,key,row*3+column) then
            return false
        endif
        set column=column+1
    endloop
    if node>=3 then
        return LoadBoolean(ForsakenTalentState,key,node-3)
    endif
    return true
endfunction

function Forsaken_TalentClick takes nothing returns nothing
    local integer node=0
    local unit hero=Player_GetHero(GetTriggerPlayer())
    loop
        exitwhen node>=12
        if BlzGetTriggerFrame()==ForsakenTalentButton[node] then
            if GetLocalPlayer()==GetTriggerPlayer() and hero!=null and ForsakenInspectTarget==null then
                call BlzSendSyncData("FFERPGTAL",I2S(Job_GetIndex(hero)*100+node))
                call BlzFrameSetEnable(ForsakenTalentButton[node],false)
                call BlzFrameSetEnable(ForsakenTalentButton[node],true)
            endif
            set hero=null
            return
        endif
        set node=node+1
    endloop
    set hero=null
endfunction

function Forsaken_TalentSync takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local unit hero=Player_GetHero(owner)
    local integer packet=S2I(BlzGetTriggerSyncData())
    local integer job=packet/100
    local integer node=ModuloInteger(packet,100)
    local integer key=GetPlayerId(owner)*100+job
    if hero!=null and job==Job_GetIndex(hero) and job>=0 and job<=udg_JobCount and Forsaken_TalentCanPurchase(key,node,Forsaken_TalentRank(hero)) then
        call SaveBoolean(ForsakenTalentState,key,node,true)
        call SaveInteger(ForsakenTalentState,key,20,LoadInteger(ForsakenTalentState,key,20)+1)
    endif
    set hero=null
    set owner=null
endfunction

function Register_Forsaken_TalentClick takes nothing returns nothing
    set ForsakenTalentState=InitHashtable()
    set gg_trg_Forsaken_TalentClick=CreateTrigger()
    call TriggerAddAction(gg_trg_Forsaken_TalentClick,function Forsaken_TalentClick)
endfunction

function Register_Forsaken_TalentSync takes nothing returns nothing
    local integer i=0
    set gg_trg_Forsaken_TalentSync=CreateTrigger()
    loop
        exitwhen i>=8
        call BlzTriggerRegisterPlayerSyncEvent(gg_trg_Forsaken_TalentSync,Player(i),"FFERPGTAL",false)
        set i=i+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_TalentSync,function Forsaken_TalentSync)
endfunction

function Forsaken_FindFrame takes string name returns framehandle
    local integer context=0
    local framehandle found
    loop
        exitwhen context>255
        set found=BlzGetFrameByName(name,context)
        if found!=null then
            return found
        endif
        set context=context+1
    endloop
    return null
endfunction

function Forsaken_RegenAbility takes ability regenAbility,integer level returns nothing
    local integer raw=BlzGetAbilityId(regenAbility)
    local integer kind=LoadInteger(ForsakenGearTypes,30,raw)
    local integer buffId=LoadInteger(ForsakenGearTypes,31,raw)
    local real value
    local boolean percent=false
    if kind==1 then
        set ForsakenHPFlat=ForsakenHPFlat+I2R(BlzGetAbilityIntegerLevelField(regenAbility,ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND,level))
    elseif kind==2 then
        set ForsakenMPPercent=ForsakenMPPercent+BlzGetAbilityRealLevelField(regenAbility,ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL,level)
    elseif kind==3 or kind==4 then
        if kind==3 then
            set value=BlzGetAbilityRealLevelField(regenAbility,ABILITY_RLF_MANA_REGENERATION_INCREASE,level)
            set percent=BlzGetAbilityBooleanLevelField(regenAbility,ABILITY_BLF_PERCENT_BONUS_HAB2,level)
        else
            set value=BlzGetAbilityRealLevelField(regenAbility,ABILITY_RLF_LIFE_REGENERATION_INCREASE_PERCENT,level)
            set percent=BlzGetAbilityBooleanLevelField(regenAbility,ABILITY_BLF_PERCENT_BONUS_UAU3,level)
        endif
        if not HaveSavedReal(ForsakenRegenScratch,0,buffId) or value>LoadReal(ForsakenRegenScratch,0,buffId) then
            call SaveReal(ForsakenRegenScratch,0,buffId,value)
            call SaveInteger(ForsakenRegenScratch,1,buffId,kind)
            call SaveBoolean(ForsakenRegenScratch,2,buffId,percent)
        endif
    endif
endfunction

function Forsaken_ReadRegeneration takes unit hero returns nothing
    local integer index=0
    local integer slot=0
    local integer raw
    local integer buffId
    local ability regenAbility
    local item carried
    local real hp=BlzGetUnitRealField(hero,UNIT_RF_HIT_POINTS_REGENERATION_RATE)+I2R(GetHeroStr(hero,true))*LoadReal(ForsakenGearTypes,40,0)
    local real mp=BlzGetUnitRealField(hero,UNIT_RF_MANA_REGENERATION)+I2R(GetHeroInt(hero,true))*LoadReal(ForsakenGearTypes,40,1)
    local real hpPercent=0.
    local real hpAura=0.
    local real mpAura=0.
    local real value
    set ForsakenHPFlat=0.
    set ForsakenMPPercent=0.
    call FlushChildHashtable(ForsakenRegenScratch,0)
    call FlushChildHashtable(ForsakenRegenScratch,1)
    call FlushChildHashtable(ForsakenRegenScratch,2)
    loop
        set regenAbility=BlzGetUnitAbilityByIndex(hero,index)
        exitwhen regenAbility==null
        set raw=BlzGetAbilityId(regenAbility)
        if not LoadBoolean(ForsakenGearTypes,32,raw) then
            call Forsaken_RegenAbility(regenAbility,IMaxBJ(0,GetUnitAbilityLevel(hero,raw)-1))
        endif
        set index=index+1
    endloop
    loop
        exitwhen slot>=15
        if slot<6 then
            set carried=UnitItemInSlot(hero,slot)
        else
            set carried=UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot-6))
        endif
        if carried!=null then
            set index=0
            loop
                set regenAbility=BlzGetItemAbilityByIndex(carried,index)
                exitwhen regenAbility==null
                call Forsaken_RegenAbility(regenAbility,0)
                set index=index+1
            endloop
        endif
        set slot=slot+1
    endloop
    set index=1
    loop
        exitwhen index>LoadInteger(ForsakenGearTypes,34,0)
        set buffId=LoadInteger(ForsakenGearTypes,34,index)
        set value=LoadReal(ForsakenRegenScratch,0,buffId)
        if LoadInteger(ForsakenRegenScratch,1,buffId)==3 then
            if LoadBoolean(ForsakenRegenScratch,2,buffId) then
                set ForsakenMPPercent=ForsakenMPPercent+value
            else
                set mpAura=mpAura+value
            endif
        elseif LoadInteger(ForsakenRegenScratch,1,buffId)==4 then
            if LoadBoolean(ForsakenRegenScratch,2,buffId) then
                set hpPercent=hpPercent+value
            else
                set hpAura=hpAura+value
            endif
        endif
        set index=index+1
    endloop
    // Same-buffId auras contribute once; items in the bag contribute nothing.
    set ForsakenHPRegen=(hp+ForsakenHPFlat)*(1.+hpPercent)+hpAura
    set ForsakenMPRegen=mp*(1.+ForsakenMPPercent)+mpAura
    set regenAbility=null
    set carried=null
endfunction

function Forsaken_PanelAccess takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local unit hero=Player_GetHero(viewer)
    local unit selected=GetTriggerUnit()
    if GetLocalPlayer()==viewer then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED then
            set ForsakenSelectedTarget=selected
            if ForsakenInspectTarget!=selected then
                set ForsakenInspectTarget=null
                call BlzFrameSetVisible(ForsakenInspectRoot,false)
                set ForsakenPanelOpen=false
            endif
            call BlzFrameSetVisible(ForsakenInspectButton,Forsaken_CanInspect(selected,viewer))
        elseif GetTriggerEventId()==EVENT_PLAYER_UNIT_DESELECTED then
            if ForsakenSelectedTarget==selected then
                set ForsakenSelectedTarget=null
                set ForsakenInspectTarget=null
                set ForsakenPanelOpen=false
                call BlzFrameSetVisible(ForsakenInspectButton,false)
                call BlzFrameSetVisible(ForsakenInspectRoot,false)
            endif
        elseif BlzGetTriggerFrame()==ForsakenInspectButton and Forsaken_CanInspect(ForsakenSelectedTarget,viewer) then
            set ForsakenInspectTarget=ForsakenSelectedTarget
            set ForsakenPanelOpen=true
            set ForsakenPanelNeedsRefresh=true
            call Forsaken_RenderInspection(ForsakenInspectTarget)
            call BlzFrameSetVisible(ForsakenInspectRoot,true)
        elseif BlzGetTriggerFrame()==ForsakenEquipButton then
            if hero!=null and ForsakenInspectTarget==null and IsUnitSelected(hero,viewer) then
                call BlzSendSyncData("FFERPGEQUIP","equip")
            endif
        elseif BlzGetTriggerFrame()==ForsakenInspectClose or BlzGetTriggerPlayerKey()==OSKEY_ESCAPE then
            set ForsakenInspectTarget=null
            set ForsakenPanelOpen=false
            call BlzFrameSetVisible(ForsakenInspectRoot,false)
        elseif BlzGetTriggerFrame()==ForsakenPanelClose then
            set ForsakenPanelOpen=false
            set ForsakenBackpackWasVisible=true
        elseif BlzGetTriggerFrame()==ForsakenStatsNext then
            if ForsakenInspectTarget!=null then
                set hero=ForsakenInspectTarget
            endif
            if hero!=null then
                set ForsakenStatsPage=ModuloInteger(ForsakenStatsPage+1,4)
                call Forsaken_RenderStats(hero)
            endif
            call BlzFrameSetEnable(ForsakenStatsNext,false)
            call BlzFrameSetEnable(ForsakenStatsNext,true)
        elseif hero!=null and IsUnitSelected(hero,viewer) then
            set ForsakenInspectTarget=null
            set ForsakenPanelOpen=true
        endif
        call BlzFrameSetVisible(ForsakenTalentRoot,ForsakenPanelOpen and not ForsakenPanelNeedsRefresh)
    endif
    set selected=null
    set hero=null
    set viewer=null
endfunction

function Forsaken_PollPanels takes nothing returns nothing
    local player viewer=GetLocalPlayer()
    local unit hero=Player_GetHero(viewer)
    local framehandle nativePanel=Forsaken_FindFrame("SimpleEquipmentPanel")
    local boolean visible=false
    if ForsakenInspectTarget!=null then
        if not Forsaken_CanInspect(ForsakenInspectTarget,viewer) or not IsUnitSelected(ForsakenInspectTarget,viewer) then
            set ForsakenInspectTarget=null
            set ForsakenPanelOpen=false
            call BlzFrameSetVisible(ForsakenInspectRoot,false)
        endif
    elseif hero!=null and IsUnitSelected(hero,viewer) then
        if nativePanel!=null then
            set visible=BlzFrameIsVisible(nativePanel)
            if visible and not ForsakenBackpackWasVisible then
                set ForsakenPanelOpen=true
            elseif not visible then
                set ForsakenPanelOpen=false
            endif
        endif
    else
        set ForsakenPanelOpen=false
    endif
    set ForsakenBackpackWasVisible=visible
    call BlzFrameSetVisible(ForsakenEquipButton,visible and ForsakenInspectTarget==null)
    call BlzFrameSetVisible(ForsakenTalentRoot,ForsakenPanelOpen and not ForsakenPanelNeedsRefresh)
    call BlzFrameSetVisible(ForsakenInspectButton,Forsaken_CanInspect(ForsakenSelectedTarget,viewer))
    set nativePanel=null
    set hero=null
    set viewer=null
endfunction

function Register_Forsaken_PanelAccess takes nothing returns nothing
    local integer i=0
    local integer node=0
    local integer row
    local integer column
    local framehandle label
    local framehandle line
    local framehandle heading
    set ForsakenStatName[0]="Fire"
    set ForsakenStatName[1]="Ice"
    set ForsakenStatName[2]="Thunder"
    set ForsakenStatName[3]="Water"
    set ForsakenStatName[4]="Earth"
    set ForsakenStatName[5]="Wind"
    set gg_trg_Forsaken_PanelAccess=CreateTrigger()
    loop
        exitwhen i>=8
        call TriggerRegisterPlayerUnitEvent(gg_trg_Forsaken_PanelAccess,Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
        call TriggerRegisterPlayerUnitEvent(gg_trg_Forsaken_PanelAccess,Player(i),EVENT_PLAYER_UNIT_DESELECTED,null)
        call BlzTriggerRegisterPlayerKeyEvent(gg_trg_Forsaken_PanelAccess,Player(i),OSKEY_B,0,true)
        call BlzTriggerRegisterPlayerKeyEvent(gg_trg_Forsaken_PanelAccess,Player(i),OSKEY_ESCAPE,0,true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_PanelAccess,Player(i),"-forsaken-panels",true)
        set i=i+1
    endloop
    call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_PanelAccess,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,4),FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(gg_trg_Forsaken_PanelAccess,function Forsaken_PanelAccess)
    set ForsakenPanelClock=CreateTimer()
    call TimerStart(ForsakenPanelClock,86400.,false,null)
    set ForsakenTalentRoot=BlzCreateFrame("EscMenuBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetAbsPoint(ForsakenTalentRoot,FRAMEPOINT_TOPRIGHT,.385,.585)
    call BlzFrameSetSize(ForsakenTalentRoot,.21,.49)
    call BlzFrameSetLevel(ForsakenTalentRoot,30)
    set ForsakenPanelClose=BlzCreateFrame("ScriptDialogButton",ForsakenTalentRoot,0,0)
    call BlzFrameSetPoint(ForsakenPanelClose,FRAMEPOINT_TOPRIGHT,ForsakenTalentRoot,FRAMEPOINT_TOPRIGHT,-.026,-.022)
    call BlzFrameSetSize(ForsakenPanelClose,.016,.016)
    call BlzFrameSetText(ForsakenPanelClose,"X")
    call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_PanelAccess,ForsakenPanelClose,FRAMEEVENT_CONTROL_CLICK)
    set heading=BlzCreateFrameByType("TEXT","ForsakenHeading",ForsakenTalentRoot,"",0)
    call BlzFrameSetPoint(heading,FRAMEPOINT_TOP,ForsakenTalentRoot,FRAMEPOINT_TOP,0,-.026)
    call BlzFrameSetSize(heading,.14,.016)
    call BlzFrameSetFont(heading,"Fonts\\FRIZQT__.TTF",.013,0)
    call BlzFrameSetTextAlignment(heading,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(heading,"Talents")
    set ForsakenTalentPoints=BlzCreateFrameByType("TEXT","ForsakenPoints",ForsakenTalentRoot,"",0)
    call BlzFrameSetPoint(ForsakenTalentPoints,FRAMEPOINT_TOP,ForsakenTalentRoot,FRAMEPOINT_TOP,0,-.049)
    call BlzFrameSetSize(ForsakenTalentPoints,.15,.018)
    call BlzFrameSetFont(ForsakenTalentPoints,"Fonts\\FRIZQT__.TTF",.007,0)
    call BlzFrameSetTextAlignment(ForsakenTalentPoints,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
    loop
        exitwhen node>=12
        set row=node/3
        set column=ModuloInteger(node,3)
        set ForsakenTalentButton[node]=BlzCreateFrame("ScriptDialogButton",ForsakenTalentRoot,0,node+1)
        call BlzFrameSetPoint(ForsakenTalentButton[node],FRAMEPOINT_TOPLEFT,ForsakenTalentRoot,FRAMEPOINT_TOPLEFT,.034+I2R(column)*.054,-.08-I2R(row)*.043)
        call BlzFrameSetSize(ForsakenTalentButton[node],.034,.034)
        set ForsakenTalentIcon[node]=BlzCreateFrameByType("BACKDROP","ForsakenTalentIcon",ForsakenTalentButton[node],"",node+1)
        call BlzFrameSetPoint(ForsakenTalentIcon[node],FRAMEPOINT_TOPLEFT,ForsakenTalentButton[node],FRAMEPOINT_TOPLEFT,.003,-.003)
        call BlzFrameSetPoint(ForsakenTalentIcon[node],FRAMEPOINT_BOTTOMRIGHT,ForsakenTalentButton[node],FRAMEPOINT_BOTTOMRIGHT,-.003,.003)
        call BlzFrameSetEnable(ForsakenTalentIcon[node],false)
        set ForsakenTalentLabel[node]=BlzCreateFrameByType("TEXT","ForsakenTalentLabel",ForsakenTalentButton[node],"",node+1)
        call BlzFrameSetAllPoints(ForsakenTalentLabel[node],ForsakenTalentButton[node])
        call BlzFrameSetFont(ForsakenTalentLabel[node],"Fonts\\FRIZQT__.TTF",.008,0)
        call BlzFrameSetTextAlignment(ForsakenTalentLabel[node],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetEnable(ForsakenTalentLabel[node],false)
        call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_TalentClick,ForsakenTalentButton[node],FRAMEEVENT_CONTROL_CLICK)
        if row<3 then
            set line=BlzCreateFrameByType("TEXT","ForsakenTalentLink",ForsakenTalentRoot,"",node+1)
            call BlzFrameSetPoint(line,FRAMEPOINT_TOP,ForsakenTalentButton[node],FRAMEPOINT_BOTTOM,0,.001)
            call BlzFrameSetSize(line,.012,.009)
            call BlzFrameSetFont(line,"Fonts\\FRIZQT__.TTF",.007,0)
            call BlzFrameSetTextAlignment(line,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
            call BlzFrameSetText(line,"|cffffcc00v|r")
            call BlzFrameSetEnable(line,false)
        endif
        set node=node+1
    endloop
    set node=0
    loop
        exitwhen node>=12
        set ForsakenStatLabel[node]=BlzCreateFrameByType("TEXT","ForsakenStatLabel",ForsakenTalentRoot,"",node+1)
        set label=ForsakenStatLabel[node]
        call BlzFrameSetPoint(label,FRAMEPOINT_TOPLEFT,ForsakenTalentRoot,FRAMEPOINT_TOPLEFT,.028,-.266-I2R(node)*.014)
        call BlzFrameSetSize(label,.102,.014)
        call BlzFrameSetFont(label,"Fonts\\FRIZQT__.TTF",.0065,0)
        call BlzFrameSetText(label,"")
        set ForsakenStatValue[node]=BlzCreateFrameByType("TEXT","ForsakenStatValue",ForsakenTalentRoot,"",node+1)
        call BlzFrameSetPoint(ForsakenStatValue[node],FRAMEPOINT_TOPRIGHT,ForsakenTalentRoot,FRAMEPOINT_TOPRIGHT,-.028,-.266-I2R(node)*.014)
        call BlzFrameSetSize(ForsakenStatValue[node],.05,.014)
        call BlzFrameSetFont(ForsakenStatValue[node],"Fonts\\FRIZQT__.TTF",.0065,0)
        call BlzFrameSetTextAlignment(ForsakenStatValue[node],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_RIGHT)
        set node=node+1
    endloop
    set ForsakenStatsHeading=BlzCreateFrameByType("TEXT","ForsakenStatsHeading",ForsakenTalentRoot,"",0)
    call BlzFrameSetPoint(ForsakenStatsHeading,FRAMEPOINT_TOP,ForsakenTalentRoot,FRAMEPOINT_TOP,0,-.244)
    call BlzFrameSetSize(ForsakenStatsHeading,.15,.016)
    call BlzFrameSetFont(ForsakenStatsHeading,"Fonts\\FRIZQT__.TTF",.008,0)
    call BlzFrameSetTextAlignment(ForsakenStatsHeading,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
    set ForsakenStatsNext=BlzCreateFrame("ScriptDialogButton",ForsakenTalentRoot,0,0)
    call BlzFrameSetPoint(ForsakenStatsNext,FRAMEPOINT_TOP,ForsakenTalentRoot,FRAMEPOINT_TOP,0,-.443)
    call BlzFrameSetSize(ForsakenStatsNext,.15,.025)
    call BlzFrameSetText(ForsakenStatsNext,"More stats >")
    call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_PanelAccess,ForsakenStatsNext,FRAMEEVENT_CONTROL_CLICK)
    call Forsaken_CreateInspection()
    set ForsakenUITimer=CreateTimer()
    call TimerStart(ForsakenUITimer,.1,true,function Forsaken_PollPanels)
    call BlzFrameSetVisible(ForsakenTalentRoot,false)
    set heading=null
    set label=null
    set line=null
endfunction

function Forsaken_UpdatePanels takes unit hero returns nothing
    local player owner=GetOwningPlayer(hero)
    local integer playerIndex=GetPlayerId(owner)
    local integer job=Job_GetIndex(hero)
    local unit previous=udg_CurrentHero
    local integer previousCalc=udg_StatCalcValue
    local integer key=playerIndex*100+job
    local integer rank=Forsaken_TalentRank(hero)
    local integer node=0
    local integer column
    local integer skill
    local string letter
    local string mastery="Normal"
    local framehandle anchor
    if job<0 then
        set owner=null
        set previous=null
        return
    endif
    set udg_CurrentHero=hero
    call Trig_MagicDefense_Calc_Actions()
    set udg_CurrentHero=previous
    set udg_StatCalcValue=previousCalc
    call Forsaken_ReadRegeneration(hero)
    set ForsakenHeroHPRegen[playerIndex+1]=ForsakenHPRegen
    set ForsakenHeroMPRegen[playerIndex+1]=ForsakenMPRegen
    if rank==2 then
        set mastery="Master"
    elseif rank==3 then
        set mastery="Ultimate"
    elseif rank==4 then
        set mastery="Legendary"
    endif
    if (ForsakenInspectTarget==null and GetLocalPlayer()==owner) or ForsakenInspectTarget==hero then
        if ForsakenInspectTarget==null and not IsUnitSelected(hero,owner) then
            set ForsakenPanelOpen=false
        endif
        set ForsakenPanelNeedsRefresh=false
        set anchor=Forsaken_FindFrame("EquipmentPanelBackdrop")
        if ForsakenInspectTarget!=null then
            call BlzFrameClearAllPoints(ForsakenTalentRoot)
            call BlzFrameSetAbsPoint(ForsakenTalentRoot,FRAMEPOINT_TOPRIGHT,.39,.585)
            call Forsaken_RenderInspection(hero)
        elseif anchor!=null then
            call BlzFrameClearAllPoints(ForsakenTalentRoot)
            call BlzFrameSetPoint(ForsakenTalentRoot,FRAMEPOINT_TOPRIGHT,anchor,FRAMEPOINT_TOPLEFT,-.002,0)
        endif
        call BlzFrameSetVisible(ForsakenTalentRoot,ForsakenPanelOpen and not ForsakenPanelNeedsRefresh)
        call Forsaken_RenderStats(hero)
        if ForsakenInspectTarget!=null then
            call BlzFrameSetText(ForsakenTalentPoints,GetPlayerName(owner)+" / "+mastery+"|nInspect: read only")
        else
            call BlzFrameSetText(ForsakenTalentPoints,"Choices: "+I2S(rank-LoadInteger(ForsakenTalentState,key,20))+" / "+mastery+"|nPreview: no bonuses")
        endif
        loop
            exitwhen node>=12
            call BlzFrameSetEnable(ForsakenTalentButton[node],ForsakenInspectTarget==null)
            set column=ModuloInteger(node,3)
            set skill=0
            if job<udg_JobCount then
                set skill=udg_JobSkill[job*5+column+1]
            elseif column==0 then
                set skill=udg_JobSkill[udg_AbilitySlot1[playerIndex+1]]
            elseif column==1 then
                set skill=udg_JobSkill[udg_AbilitySlot2[playerIndex+1]]
            else
                set skill=udg_JobSkill[udg_AbilitySlot3[playerIndex+1]]
            endif
            if skill!=0 then
                call BlzFrameSetTexture(ForsakenTalentIcon[node],BlzGetAbilityIcon(skill),0,true)
            else
                call BlzFrameSetTexture(ForsakenTalentIcon[node],"ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",0,true)
            endif
            set letter=SubString("ABCDFGHIJKLM",node,node+1)
            if LoadBoolean(ForsakenTalentState,key,node) then
                call BlzFrameSetText(ForsakenTalentLabel[node],"|cff00ff00"+letter+" +|r")
                call BlzFrameSetAlpha(ForsakenTalentIcon[node],255)
            elseif Forsaken_TalentCanPurchase(key,node,rank) then
                call BlzFrameSetText(ForsakenTalentLabel[node],"|cffffcc00"+letter+"|r")
                call BlzFrameSetAlpha(ForsakenTalentIcon[node],255)
            else
                call BlzFrameSetText(ForsakenTalentLabel[node],"|cffaaaaaa"+letter+"|r")
                call BlzFrameSetAlpha(ForsakenTalentIcon[node],90)
            endif
            set node=node+1
        endloop
    endif
    set anchor=null
    set owner=null
    set previous=null
endfunction

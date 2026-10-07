function Forsaken_DefensePercent takes integer defense returns real
    return 100.*I2R(defense)/I2R(defense+50)
endfunction

function Forsaken_TalentCanPurchase takes integer key,integer node returns boolean
    if node<0 or node>=12 or LoadInteger(ForsakenTalentState,key,20)>=4 or LoadBoolean(ForsakenTalentState,key,node) then
        return false
    endif
    if node>=3 then
        return LoadBoolean(ForsakenTalentState,key,node-3)
    endif
    return true
endfunction

function Forsaken_TalentClick takes nothing returns nothing
    local integer node=0
    local unit hero=Player_GetHero(GetTriggerPlayer())
    local integer job=Job_GetIndex(hero)
    loop
        exitwhen node>=12
        if BlzGetTriggerFrame()==ForsakenTalentButton[node] then
            if GetLocalPlayer()==GetTriggerPlayer() and hero!=null and job>=0 then
                call BlzSendSyncData("FFERPGTAL",I2S(job*100+node))
            endif
            call BlzFrameSetEnable(ForsakenTalentButton[node],false)
            call BlzFrameSetEnable(ForsakenTalentButton[node],true)
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
    if hero!=null and job==Job_GetIndex(hero) and job>=0 and job<=udg_JobCount and Forsaken_TalentCanPurchase(key,node) then
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

function Forsaken_CreatePanelFrames takes nothing returns nothing
    local framehandle nativeTree=BlzGetFrameByName("SimpleTalentsPanel",0)
    local framehandle rawRow=BlzGetFrameByName("SimpleStatDetailsAbilityVampPercentage",0)
    local framehandle percentRow=BlzGetFrameByName("SimpleStatDetailsMagicResistance",0)
    local framehandle line
    local integer node=0
    local integer child=0
    local integer row
    local integer column
    if nativeTree==null or rawRow==null or percentRow==null then
        set nativeTree=null
        set rawRow=null
        set percentRow=null
        return
    endif
    call BlzLoadTOCFile("ForsakenPanels.toc")
    loop
        exitwhen child>=BlzFrameGetChildrenCount(rawRow)
        call BlzFrameSetVisible(BlzFrameGetChild(rawRow,child),false)
        set child=child+1
    endloop
    set child=0
    loop
        exitwhen child>=BlzFrameGetChildrenCount(percentRow)
        call BlzFrameSetVisible(BlzFrameGetChild(percentRow,child),false)
        set child=child+1
    endloop
    set ForsakenDefenseRow=BlzCreateSimpleFrame("ForsakenDefenseRow",rawRow,0)
    call BlzFrameSetAllPoints(ForsakenDefenseRow,rawRow)
    set ForsakenReductionRow=BlzCreateSimpleFrame("ForsakenReductionRow",percentRow,0)
    call BlzFrameSetAllPoints(ForsakenReductionRow,percentRow)
    set ForsakenDefenseValue=BlzGetFrameByName("ForsakenDefenseValue",0)
    set ForsakenReductionValue=BlzGetFrameByName("ForsakenReductionValue",0)
    call BlzFrameSetVisible(BlzGetFrameByName("PointsAvailableText",0),false)
    set ForsakenTalentRoot=BlzCreateFrameByType("FRAME","ForsakenPaths",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetAllPoints(ForsakenTalentRoot,nativeTree)
    call BlzFrameSetLevel(ForsakenTalentRoot,20)
    set ForsakenTalentPoints=BlzCreateFrameByType("TEXT","ForsakenPoints",ForsakenTalentRoot,"",0)
    call BlzFrameSetPoint(ForsakenTalentPoints,FRAMEPOINT_TOP,nativeTree,FRAMEPOINT_TOP,0,-.032)
    call BlzFrameSetSize(ForsakenTalentPoints,.13,.018)
    call BlzFrameSetFont(ForsakenTalentPoints,"Fonts\\FRIZQT__.TTF",.007,0)
    call BlzFrameSetTextAlignment(ForsakenTalentPoints,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
    loop
        exitwhen node>=12
        set row=node/3
        set column=ModuloInteger(node,3)
        set ForsakenTalentButton[node]=BlzCreateFrame("ScriptDialogButton",ForsakenTalentRoot,0,node+1)
        call BlzFrameSetPoint(ForsakenTalentButton[node],FRAMEPOINT_TOPLEFT,nativeTree,FRAMEPOINT_TOPLEFT,.012+I2R(column)*.042,-.058-I2R(row)*.045)
        call BlzFrameSetSize(ForsakenTalentButton[node],.034,.034)
        set ForsakenTalentIcon[node]=BlzCreateFrameByType("BACKDROP","ForsakenTalentIcon",ForsakenTalentButton[node],"",node+1)
        call BlzFrameSetPoint(ForsakenTalentIcon[node],FRAMEPOINT_TOPLEFT,ForsakenTalentButton[node],FRAMEPOINT_TOPLEFT,.003,-.003)
        call BlzFrameSetPoint(ForsakenTalentIcon[node],FRAMEPOINT_BOTTOMRIGHT,ForsakenTalentButton[node],FRAMEPOINT_BOTTOMRIGHT,-.003,.003)
        call BlzFrameSetEnable(ForsakenTalentIcon[node],false)
        set ForsakenTalentLabel[node]=BlzCreateFrameByType("TEXT","ForsakenTalentLabel",ForsakenTalentButton[node],"",node+1)
        call BlzFrameSetAllPoints(ForsakenTalentLabel[node],ForsakenTalentButton[node])
        call BlzFrameSetFont(ForsakenTalentLabel[node],"Fonts\\FRIZQT__.TTF",.009,0)
        call BlzFrameSetTextAlignment(ForsakenTalentLabel[node],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetEnable(ForsakenTalentLabel[node],false)
        call BlzTriggerRegisterFrameEvent(gg_trg_Forsaken_TalentClick,ForsakenTalentButton[node],FRAMEEVENT_CONTROL_CLICK)
        if row<3 then
            set line=BlzCreateFrameByType("TEXT","ForsakenTalentLink",ForsakenTalentRoot,"",node+1)
            call BlzFrameSetPoint(line,FRAMEPOINT_TOP,ForsakenTalentButton[node],FRAMEPOINT_BOTTOM,0,0)
            call BlzFrameSetSize(line,.012,.012)
            call BlzFrameSetFont(line,"Fonts\\FRIZQT__.TTF",.009,0)
            call BlzFrameSetTextAlignment(line,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
            call BlzFrameSetText(line,"|cffffcc00v|r")
            call BlzFrameSetEnable(line,false)
        endif
        set node=node+1
    endloop
    call BlzFrameSetVisible(ForsakenTalentRoot,false)
    set ForsakenPanelFramesReady=true
    set nativeTree=null
    set rawRow=null
    set percentRow=null
    set line=null
endfunction

function Forsaken_UpdatePanels takes unit hero returns nothing
    local player owner=GetOwningPlayer(hero)
    local integer playerIndex=GetPlayerId(owner)
    local integer job=Job_GetIndex(hero)
    local integer tree=LoadInteger(ForsakenGearTypes,2,playerIndex)
    local unit previous=udg_CurrentHero
    local integer previousCalc=udg_StatCalcValue
    local integer key=playerIndex*100+job
    local integer node=0
    local integer skill=0
    local integer column
    local string letter
    if tree==0 or job<0 then
        set owner=null
        set previous=null
        return
    endif
    call UnitAddAbility(hero,tree)
    call UnitMakeAbilityPermanent(hero,true,tree)
    set udg_CurrentHero=hero
    call Trig_MagicDefense_Calc_Actions()
    set udg_CurrentHero=previous
    set udg_StatCalcValue=previousCalc
    if not ForsakenPanelFramesReady then
        call Forsaken_CreatePanelFrames()
    endif
    if GetLocalPlayer()==owner and ForsakenPanelFramesReady then
        call BlzSetAbilityTooltip(tree,GetUnitName(hero)+" Talents",0)
        call BlzFrameSetText(ForsakenDefenseValue,I2S(udg_MagicDefense[playerIndex+1]))
        call BlzFrameSetText(ForsakenReductionValue,R2SW(Forsaken_DefensePercent(udg_MagicDefense[playerIndex+1]),1,2)+"%")
        call BlzFrameSetVisible(ForsakenTalentRoot,BlzFrameIsVisible(BlzGetFrameByName("SimpleTalentsPanel",0)) and IsUnitSelected(hero,owner))
        call BlzFrameSetText(ForsakenTalentPoints,"Preview points: "+I2S(4-LoadInteger(ForsakenTalentState,key,20))+"|nNo combat bonuses")
        loop
            exitwhen node>=12
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
            elseif Forsaken_TalentCanPurchase(key,node) then
                call BlzFrameSetText(ForsakenTalentLabel[node],"|cffffcc00"+letter+"|r")
                call BlzFrameSetAlpha(ForsakenTalentIcon[node],255)
            else
                call BlzFrameSetText(ForsakenTalentLabel[node],"|cffaaaaaa"+letter+"|r")
                call BlzFrameSetAlpha(ForsakenTalentIcon[node],90)
            endif
            set node=node+1
        endloop
    endif
    set owner=null
    set previous=null
endfunction

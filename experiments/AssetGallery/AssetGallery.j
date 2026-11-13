globals
    integer GalModelCount=0
    integer GalIconCount=0
    integer GalBankCount=0
    integer array GalRaw
    string array GalPath
    string array GalName
    string array GalIconPath
    string array GalIconName
    integer array GalGroup
    integer array GalFirst
    integer array GalLast
    string array GalGroupName
    real array GalScale
    integer GalCategory=1
    integer GalPage=0
    integer GalIconPage=0
    integer GalMode=0
    integer GalCity=1
    integer GalGround=-1
    unit GalExplorer=null
    unit GalIconWall=null
    unit array GalDisplay
    integer GalDisplayCount=0
    texttag array GalLabels
    integer GalLabelCount=0
    unit array GalSelected
    integer array GalIconRaw
    integer array GalCityFirst
    integer array GalCityLast
    string array GalCityName
    integer array GalCityRaw
    real array GalCityX
    real array GalCityY
    real array GalCityAngle
    real array GalCityScale
    player GalUser=null
    timer GalSearchTimer=null
    string GalSearchWord=""
    integer GalSearchCursor=1
    integer GalSearchMode=0
    player GalSearchUser=null
endglobals

// Generated catalogue data functions are inserted here by the builder.

function Gal_Message takes player p,string text returns nothing
    call DisplayTimedTextToPlayer(p,0.,0.,18.,text)
endfunction

function Gal_Select takes player p,unit selected,real x,real y returns nothing
    if GetLocalPlayer()==p then
        call ClearSelection()
        call SelectUnit(selected,true)
        call SetCameraPosition(x,y)
    endif
endfunction

function Gal_Clear takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>GalDisplayCount
        call RemoveUnit(GalDisplay[i])
        set GalDisplay[i]=null
        set i=i+1
    endloop
    set GalDisplayCount=0
    set i=1
    loop
        exitwhen i>GalLabelCount
        call DestroyTextTag(GalLabels[i])
        set GalLabels[i]=null
        set i=i+1
    endloop
    set GalLabelCount=0
    set i=0
    loop
        exitwhen i>=8
        set GalSelected[i]=GalExplorer
        set i=i+1
    endloop
    call PauseTimer(GalSearchTimer)
    call ShowUnit(GalIconWall,false)
endfunction

function Gal_Label takes string text,real x,real y,real height,real size returns nothing
    set GalLabelCount=GalLabelCount+1
    set GalLabels[GalLabelCount]=CreateTextTag()
    call SetTextTagText(GalLabels[GalLabelCount],text,size)
    call SetTextTagPos(GalLabels[GalLabelCount],x,y,height)
    call SetTextTagColor(GalLabels[GalLabelCount],255,235,170,255)
    call SetTextTagPermanent(GalLabels[GalLabelCount],true)
endfunction

function Gal_Place takes integer id,real x,real y,real angle,real scale returns unit
    local unit shown=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE),GalRaw[id],x,y,angle)
    call SetUnitPathing(shown,false)
    call SetUnitScale(shown,scale,scale,scale)
    call SetUnitUserData(shown,id)
    call SetUnitAcquireRange(shown,0.)
    set GalDisplayCount=GalDisplayCount+1
    set GalDisplay[GalDisplayCount]=shown
    return shown
endfunction

function Gal_Paint takes integer theme returns nothing
    local real x=-3200.
    local real y
    local integer lawn='Lgrs'
    local integer road='Ygsb'
    local integer tile
    if GalGround==theme then
        return
    endif
    if theme==2 then
        set road='Yrtl'
    elseif theme==3 then
        set lawn='Ldro'
        set road='Adrd'
    elseif theme==4 then
        set lawn='Ldro'
        set road='Lrok'
    endif
    loop
        exitwhen x>3200.
        set y=-3200.
        loop
            exitwhen y>3200.
            set tile=lawn
            if theme>0 and (RAbsBJ(x)<270. or RAbsBJ(y)<230. or (x*x+y*y<600.*600.)) then
                set tile=road
            endif
            call SetTerrainType(x,y,tile,-1,1,0)
            set y=y+128.
        endloop
        set x=x+128.
    endloop
    set GalGround=theme
endfunction

function Gal_ShowModels takes nothing returns nothing
    local integer count=GalLast[GalCategory]-GalFirst[GalCategory]+1
    local integer pages=(count+23)/24
    local integer i=0
    local integer id
    local real x
    local real y
    local unit shown
    call Gal_Clear()
    call Gal_Paint(0)
    set GalMode=0
    if GalPage<0 then
        set GalPage=pages-1
    elseif GalPage>=pages then
        set GalPage=0
    endif
    loop
        exitwhen i>=24
        set id=GalFirst[GalCategory]+GalPage*24+i
        exitwhen id>GalLast[GalCategory]
        set x=-2250.+900.*I2R(ModuloInteger(i,6))
        set y=1400.-850.*I2R(i/6)
        set shown=Gal_Place(id,x,y,270.,GalScale[id])
        call Gal_Label("#"+I2S(id)+" "+SubString(GalName[id],0,28),x-180.,y-180.,120.,.016)
        set i=i+1
    endloop
    call Gal_Label(GalGroupName[GalCategory]+" - "+I2S(GalPage+1)+" / "+I2S(pages),-1500.,2450.,100.,.026)
    call Gal_Message(GalUser,GalGroupName[GalCategory]+": page "+I2S(GalPage+1)+" / "+I2S(pages)+". Click a model for its path. F1 returns to the Curator controls.")
    call Gal_Select(GalUser,GalExplorer,0.,-100.)
    set shown=null
endfunction

function Gal_ShowIcons takes nothing returns nothing
    local integer i=0
    local integer id
    local integer pages=(GalIconCount+8)/9
    local string tip
    call Gal_Clear()
    call Gal_Paint(0)
    set GalMode=1
    if GalIconPage<0 then
        set GalIconPage=pages-1
    elseif GalIconPage>=pages then
        set GalIconPage=0
    endif
    loop
        exitwhen i>=9
        set id=GalIconPage*9+i+1
        if id<=GalIconCount then
            call BlzSetAbilityIcon(GalIconRaw[i],GalIconPath[id])
            call BlzSetAbilityTooltip(GalIconRaw[i],"#"+I2S(id)+" "+GalIconName[id],1)
            call BlzSetAbilityExtendedTooltip(GalIconRaw[i],GalIconPath[id]+"|n|nClick to print this icon's ID and path.",1)
            call BlzUnitHideAbility(GalIconWall,GalIconRaw[i],false)
        else
            call BlzUnitHideAbility(GalIconWall,GalIconRaw[i],true)
        endif
        set i=i+1
    endloop
    call ShowUnit(GalIconWall,true)
    call Gal_Label("ICON LIBRARY - "+I2S(GalIconPage+1)+" / "+I2S(pages),-1300.,600.,100.,.030)
    call Gal_Label("The nine icons appear in the normal command card below.",-1500.,200.,80.,.021)
    call Gal_Message(GalUser,"Icons "+I2S(GalIconPage*9+1)+"-"+I2S(IMinBJ(GalIconCount,GalIconPage*9+9))+" / "+I2S(GalIconCount)+". Q/W: pages. E: return. -find <word> searches names and paths.")
    call Gal_Select(GalUser,GalIconWall,0.,-200.)
endfunction

function Gal_ShowCity takes nothing returns nothing
    local integer i
    local unit shown
    call Gal_Clear()
    call Gal_Paint(GalCity)
    set GalMode=2
    set i=GalCityFirst[GalCity]
    loop
        exitwhen i>GalCityLast[GalCity]
        set shown=Gal_Place(GalCityRaw[i],GalCityX[i],GalCityY[i],GalCityAngle[i],GalCityScale[i])
        set i=i+1
    endloop
    call Gal_Label(GalCityName[GalCity],-1600.,2850.,150.,.032)
    call Gal_Message(GalUser,GalCityName[GalCity]+". Walk around with the Curator; click buildings for their asset paths. Q/W: city examples. -zoom 3500: overview. E: gallery.")
    call SetUnitPosition(GalExplorer,0.,-2700.)
    call Gal_Select(GalUser,GalExplorer,0.,-200.)
    set shown=null
endfunction

function Gal_Step takes integer direction returns nothing
    if GalMode==1 then
        set GalIconPage=GalIconPage+direction
        call Gal_ShowIcons()
    elseif GalMode==2 then
        set GalCity=ModuloInteger(GalCity+direction+3,4)+1
        call Gal_ShowCity()
    else
        set GalPage=GalPage+direction
        call Gal_ShowModels()
    endif
endfunction

function Gal_Help takes nothing returns nothing
    call Gal_Message(GalUser,"REFORGED ASSET GALLERY|nF1: Curator. Q/W: previous/next page. E: next category. R: icons. T: next city.|nChat: -units, -buildings, -props, -effects, -nature, -parts, -cinema, -all, -icons [page], -city 1-4, -page N.")
    call Gal_Message(GalUser,"Find and inspect: -find <word>, -model <ID>, -info, -anim stand/walk/attack/spell/birth/death, -scale 1.5, -turn 90, -zoom 2500.|nCity examples may combine familiar and unused assets. New art requires Reforged HD graphics. All catalogue files are included beside the workspace build.")
endfunction

function Gal_SearchChunk takes nothing returns nothing
    local integer processed=0
    local integer j
    local integer id
    local string path
    local integer limit=GalModelCount
    local integer length=StringLength(GalSearchWord)
    if GalSearchMode==1 then
        set limit=GalIconCount
    endif
    loop
        exitwhen processed>=48 or GalSearchCursor>limit
        set id=GalSearchCursor
        if GalSearchMode==1 then
            set path=GalIconPath[id]
        else
            set path=GalPath[id]
        endif
        set j=0
        loop
            exitwhen j+length>StringLength(path)
            if SubString(path,j,j+length)==GalSearchWord then
                call PauseTimer(GalSearchTimer)
                set GalUser=GalSearchUser
                if GalSearchMode==1 then
                    set GalIconPage=(id-1)/9
                    call Gal_ShowIcons()
                else
                    set GalCategory=GalGroup[id]
                    set GalPage=(id-GalFirst[GalCategory])/24
                    call Gal_ShowModels()
                endif
                call Gal_Message(GalUser,"Found #"+I2S(id)+": "+path)
                return
            endif
            set j=j+1
        endloop
        set GalSearchCursor=GalSearchCursor+1
        set processed=processed+1
    endloop
    if GalSearchCursor>limit then
        call PauseTimer(GalSearchTimer)
        call Gal_Message(GalSearchUser,"No matching catalogue entry for: "+GalSearchWord)
    endif
endfunction

function Gal_Find takes string word returns nothing
    set GalSearchWord=StringCase(word,false)
    set GalSearchCursor=1
    set GalSearchMode=GalMode
    set GalSearchUser=GalUser
    if StringLength(word)>0 then
        call TimerStart(GalSearchTimer,.01,true,function Gal_SearchChunk)
    endif
endfunction

function Gal_Info takes player p,unit shown returns nothing
    local integer id=GetUnitUserData(shown)
    if id>0 and id<=GalBankCount then
        call Gal_Message(p,"#"+I2S(id)+" "+GalName[id]+"|n"+GalPath[id])
    endif
endfunction

function Gal_Selected takes nothing returns nothing
    set GalSelected[GetPlayerId(GetTriggerPlayer())]=GetTriggerUnit()
    call Gal_Info(GetTriggerPlayer(),GetTriggerUnit())
endfunction

function Gal_Cast takes nothing returns nothing
    local integer raw=GetSpellAbilityId()
    local integer i=0
    local integer id
    set GalUser=GetOwningPlayer(GetTriggerUnit())
    if raw=='vN00' or raw=='vB00' then
        call Gal_Step(-1)
    elseif raw=='vN01' or raw=='vB01' then
        call Gal_Step(1)
    elseif raw=='vN02' or raw=='vB02' then
        if GalMode==0 then
            set GalCategory=ModuloInteger(GalCategory,7)+1
            set GalPage=0
        endif
        call Gal_ShowModels()
    elseif raw=='vN03' then
        call Gal_ShowIcons()
    elseif raw=='vN04' then
        if GalMode==2 then
            set GalCity=ModuloInteger(GalCity,4)+1
        else
            set GalCity=1
        endif
        call Gal_ShowCity()
    elseif raw=='vN05' then
        call Gal_Help()
    else
        loop
            exitwhen i>=9
            if raw==GalIconRaw[i] then
                set id=GalIconPage*9+i+1
                if id<=GalIconCount then
                    call Gal_Message(GalUser,"ICON #"+I2S(id)+" "+GalIconName[id]+"|n"+GalIconPath[id])
                endif
                return
            endif
            set i=i+1
        endloop
    endif
endfunction

function Gal_Chat takes nothing returns nothing
    local string text=GetEventPlayerChatString()
    local string cmd=StringCase(text,false)
    local integer i=0
    local integer id
    local real value
    local unit chosen=GalSelected[GetPlayerId(GetTriggerPlayer())]
    set GalUser=GetTriggerPlayer()
    if cmd=="-next" then
        call Gal_Step(1)
    elseif cmd=="-prev" then
        call Gal_Step(-1)
    elseif cmd=="-help" then
        call Gal_Help()
    elseif SubString(cmd,0,5)=="-city" then
        set GalCity=IMaxBJ(1,IMinBJ(4,S2I(SubString(cmd,6,StringLength(cmd)))))
        call Gal_ShowCity()
    elseif SubString(cmd,0,6)=="-icons" then
        if StringLength(cmd)>7 then
            set GalIconPage=IMaxBJ(0,S2I(SubString(cmd,7,StringLength(cmd)))-1)
        endif
        call Gal_ShowIcons()
    elseif SubString(cmd,0,6)=="-find " then
        call Gal_Find(SubString(cmd,6,StringLength(cmd)))
    elseif SubString(cmd,0,6)=="-page " then
        if GalMode==1 then
            set GalIconPage=IMaxBJ(0,S2I(SubString(cmd,6,StringLength(cmd)))-1)
            call Gal_ShowIcons()
        else
            set GalPage=IMaxBJ(0,S2I(SubString(cmd,6,StringLength(cmd)))-1)
            call Gal_ShowModels()
        endif
    elseif SubString(cmd,0,7)=="-model " then
        set id=S2I(SubString(cmd,7,StringLength(cmd)))
        if id>=1 and id<=GalModelCount then
            set GalCategory=GalGroup[id]
            set GalPage=(id-GalFirst[GalCategory])/24
            call Gal_ShowModels()
        endif
    elseif SubString(cmd,0,6)=="-zoom " then
        set value=RMaxBJ(600.,RMinBJ(5000.,S2R(SubString(cmd,6,StringLength(cmd)))))
        if GetLocalPlayer()==GalUser then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,value,.2)
        endif
    elseif SubString(cmd,0,6)=="-anim " and chosen!=null then
        call SetUnitAnimation(chosen,SubString(cmd,6,StringLength(cmd)))
    elseif SubString(cmd,0,7)=="-scale " and chosen!=null then
        set value=RMaxBJ(.05,RMinBJ(4.,S2R(SubString(cmd,7,StringLength(cmd)))))
        call SetUnitScale(chosen,value,value,value)
    elseif SubString(cmd,0,6)=="-turn " and chosen!=null then
        call SetUnitFacing(chosen,S2R(SubString(cmd,6,StringLength(cmd))))
    elseif cmd=="-info" then
        call Gal_Info(GalUser,chosen)
    else
        if cmd=="-all" then
            set i=0
        elseif cmd=="-units" then
            set i=1
        elseif cmd=="-buildings" then
            set i=2
        elseif cmd=="-props" then
            set i=3
        elseif cmd=="-effects" then
            set i=4
        elseif cmd=="-nature" then
            set i=5
        elseif cmd=="-parts" then
            set i=6
        elseif cmd=="-cinema" then
            set i=7
        else
            set chosen=null
            return
        endif
        set GalCategory=i
        set GalPage=0
        call Gal_ShowModels()
    endif
    set chosen=null
endfunction

function Gal_Ready takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call Gal_ShowModels()
    call Gal_Help()
endfunction

function main_old takes nothing returns nothing
    local trigger chat=CreateTrigger()
    local trigger cast=CreateTrigger()
    local trigger select=CreateTrigger()
    local integer i=0
    local quest help
    call SetCameraBounds(-3500.,-3500.,3500.,3500.,-3500.,3500.,3500.,-3500.)
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl","Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call InitBlizzard()
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY,12.)
    call SuspendTimeOfDay(true)
    call FogEnable(false)
    call FogMaskEnable(false)
    call Gal_LoadData()
    set GalUser=Player(0)
    set GalSearchTimer=CreateTimer()
    set GalExplorer=CreateUnit(Player(0),'YEXP',0.,-2700.,90.)
    call SetUnitPathing(GalExplorer,false)
    set GalIconWall=CreateUnit(Player(0),'yICO',0.,-500.,270.)
    call SetUnitPathing(GalIconWall,false)
    call ShowUnit(GalIconWall,false)
    loop
        exitwhen i>=8
        call TriggerRegisterPlayerChatEvent(chat,Player(i),"-",false)
        call TriggerRegisterPlayerUnitEvent(select,Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
        if GetLocalPlayer()==Player(i) then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,2200.,0.)
        endif
        set i=i+1
    endloop
    call TriggerRegisterAnyUnitEventBJ(cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(chat,function Gal_Chat)
    call TriggerAddAction(cast,function Gal_Cast)
    call TriggerAddAction(select,function Gal_Selected)
    set help=CreateQuest()
    call QuestSetTitle(help,"Asset Gallery - controls and catalogue")
    call QuestSetRequired(help,false)
    call QuestSetDiscovered(help,true)
    call QuestSetDescription(help,"Use Reforged HD graphics. F1 selects the Curator. Q/W browse pages; E changes category; R opens the icon library; T visits a city. -help lists commands. Click a display to print its ID and asset path. -find <word> searches the current library. -city 1/2/3/4 visits human, elven, orc and undead examples. -anim walk/attack/spell/birth/death previews animation. -scale 1.5 and -turn 90 change the selected display. -zoom 3500 gives a city overview. Displays are paged to bound HD model memory use.")
    call TimerStart(CreateTimer(),.5,false,function Gal_Ready)
    set chat=null
    set cast=null
    set select=null
    set help=null
endfunction

function InitTrig_AssetShowcase takes nothing returns nothing
    call main_old()
endfunction

function main takes nothing returns nothing
    call main_old()
endfunction

// The builder supplies the known-working native player configuration unchanged.

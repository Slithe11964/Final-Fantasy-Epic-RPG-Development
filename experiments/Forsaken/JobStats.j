// Effect rows use the active buff and source rank, independently of panel visibility.
function JSTAT_RenderJob takes unit hero,integer page,integer row returns integer
    local integer rank
    local real amount
    if page==0 then
        if JGET(hero,'B01F')>0 then
            call JROW(row,"Aim tech damage","+20% | +"+I2S(JGET(hero,'A0RH')*50))
            set row=row+1
            call JROW(row,"Aim attack speed","-"+R2SW(30.+6.*I2R(IMaxBJ(1,JGET(hero,'A14B'))-1),1,0)+"%")
            set row=row+1
        endif
        if JGET(hero,'B00K')>0 or JGET(hero,'B07P')>0 then
            call JROW(row,"Rage attack speed","+"+R2SW(JobFX_RageSpeed(hero),1,0)+"%")
            set row=row+1
            call JROW(row,"Rage damage","+10%")
            set row=row+1
        endif
        if JGET(hero,'B082')>0 then
            call JROW(row,"Dark Power attack speed","+"+R2SW(JobFX_DarkSpeed(hero),1,0)+"%")
            set row=row+1
        endif
        if JGET(hero,'B04B')>0 then
            set rank=JGET(hero,'A0R2')
            set amount=42.-2.*I2R(rank)
            if rank>=11 then
                set amount=25.
            endif
            call JROW(row,"Drain Attack damage","-"+R2SW(amount,1,0)+"%")
            set row=row+1
        endif
        if JGET(hero,'A16K')>0 and GetUnitState(hero,UNIT_STATE_MAX_MANA)>0. and GetUnitState(hero,UNIT_STATE_MANA)>=GetUnitState(hero,UNIT_STATE_MAX_MANA) then
            call JROW(row,"Next spell is stronger","+50%")
            set row=row+1
        endif
        if JGET(hero,'B06N')>0 then
            call JROW(row,"Mind Charge spell potency","+100%")
            set row=row+1
        endif
    elseif page==1 then
        if JGET(hero,'B01F')>0 then
            set amount=30.
            if JGET(hero,'A0RH')>=11 then
                set amount=20.
            endif
            call JROW(row,"Aim damage taken","+"+R2SW(amount,1,0)+"%")
            set row=row+1
        endif
        if JGET(hero,'B00K')>0 or JGET(hero,'B07P')>0 then
            call JROW(row,"Rage damage taken","+60%")
            set row=row+1
        endif
        if JGET(hero,'B082')>0 then
            set amount=90.*(1.-GetUnitState(hero,UNIT_STATE_LIFE)/GetUnitState(hero,UNIT_STATE_MAX_LIFE))
            call JROW(row,"Dark Power damage reduction",R2SW(amount,1,2)+"%")
            set row=row+1
        endif
        if JGET(hero,'B04B')>0 then
            call JROW(row,"Lifesteal","+50%")
            set row=row+1
        endif
        if JGET(hero,'B06N')>0 then
            call JROW(row,"Mind Charge armor","-30")
            set row=row+1
        endif
        if JGET(hero,'B051')>0 and LoadBoolean(udg_DivineShieldHash,GetHandleId(hero),3) then
            call JROW(row,"Damage taken from mana","50%")
            set row=row+1
        endif
        if JGET(hero,'B052')>0 then
            call JROW(row,"Infinity damage reduction","100%")
            set row=row+1
        endif
    elseif page==3 then
        if JGET(hero,'B082')>0 then
            set rank=JobFX_Rank(hero,'B082','A1AA')
            set amount=I2R((rank+3)*10)
            if rank>=6 then
                set amount=100.
            endif
            call JROW(row,"Mana gain on hit","+"+R2SW(amount,1,0))
            set row=row+1
            call JROW(row,"Dark Power move speed","+50%")
            set row=row+1
        endif
        if JGET(hero,'B01A')>0 then
            call JROW(row,"Mana Regen","10% / second")
            set row=row+1
        endif
        if JGET(hero,'B00X')>0 then
            call JROW(row,"Blessing health regen","+100%")
            set row=row+1
        endif
    endif
    return row
endfunction

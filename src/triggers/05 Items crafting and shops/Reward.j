library TReward requires TPlayerHero, TText
function Reward_GiveAll takes integer l_gold,integer xp,unit l_speaker returns nothing
    local string l_msg="|cffffcc00All players get "
    local integer i=0
    local player p
    local integer l_mult=1
    loop
        set p=Player(i)
        if(IsPlayerInForce(p,udg_PlayingPlayers))then
            set l_mult=1
            // Use the best matching title reward: triple, double, or normal. These two title bonuses do not multiply together.
            if(IsPlayerInForce(p,udg_TitleForce[$D]))then // $D = 13
                set l_mult=3
            elseif(IsPlayerInForce(p,udg_TitleForce[$C]))then // $C = 12
                set l_mult=2
            endif
            if(l_gold>0)then
                call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+(l_gold*l_mult))
                call SetPlayerState(p,PLAYER_STATE_GOLD_GATHERED,GetPlayerState(p,PLAYER_STATE_GOLD_GATHERED)+(l_gold*l_mult))
            endif
            if(xp>0)then
                if(GetUnitAbilityLevel(Player_GetHero(p),'A14Q')<=0)then // 'A14Q': ability "Pointless"
                    call AddHeroXP(Player_GetHero(p),(xp*l_mult),false)
                    // The secondary hero gets the title-adjusted XP times the secondary-XP rate, with decimals dropped.
                    call AddHeroXP(udg_SpiritOfGaya[i+1],R2I(I2R((xp*l_mult))*udg_SecondaryXPRate),false)
                else
                    set udg_BankedXP[i+1]=udg_BankedXP[i+1]+I2R(xp*l_mult)
                endif
            endif
        endif
        set i=i+1
        exitwhen i>=8
    endloop
    if(l_speaker!=null)then
        if(l_gold>0)then
            set l_msg=l_msg+I2S(l_gold)+" gold"
            if(xp>0)then
                set l_msg=l_msg+" and "
            endif
        endif
        if(xp>0)then
            set l_msg=l_msg+I2S(xp)+" exp"
        endif
        set l_msg=l_msg+".|r"
        if(udg_CinematicsDisabled or l_speaker==udg_NarratorUnit)then
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,l_msg)
        else
            call Text_Transmission(l_speaker,null,"|n"+l_msg,null,null,0,true)
        endif
    endif
    set l_msg=null
endfunction

function Reward_Give takes integer l_gold,integer xp,unit l_speaker returns nothing
    if udg_EternityMode then
        if(l_gold>0 and l_gold<=6000)then
            // The remainder after dividing (l_gold) by (500).
            if(ModuloInteger(l_gold,500)>0)then
                // (((l_gold) divided by (500); drop the remainder) plus (1)) times (500).
                set l_gold=((l_gold/ 500)+1)*500
            endif
            set l_gold=l_gold+$7D0 // $7D0 = 2000
        endif
        if(xp>0 and xp<=6000)then
            // The remainder after dividing (xp) by (500).
            if(ModuloInteger(xp,500)>0)then
                // (((xp) divided by (500); drop the remainder) plus (1)) times (500).
                set xp=((xp/ 500)+1)*500
            endif
            set xp=xp+$7D0 // $7D0 = 2000
        endif
    endif
    call Reward_GiveAll(l_gold,xp,l_speaker)
endfunction

function InitTrig_Reward takes nothing returns nothing
endfunction

endlibrary

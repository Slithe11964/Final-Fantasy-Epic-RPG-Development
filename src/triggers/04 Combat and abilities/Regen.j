library TRegen requires TProf, TTalents, TProphet, TRunic, TWait, TCooldown
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Regen_Cast=null
    trigger gg_trg_Regen_Periodic=null
    hashtable PriestBuffTypes=InitHashtable()
    hashtable PriestBuffSource=InitHashtable()
    hashtable PriestBuffRanks=InitHashtable()
    hashtable PriestBuffClone=InitHashtable()
    hashtable PriestBuffUntil=InitHashtable()
    hashtable PriestBuffExpiry=InitHashtable()
    hashtable PriestReplay=InitHashtable()
    hashtable PriestDeferred=InitHashtable()
    hashtable PriestAbilityText=InitHashtable()
    integer array PriestBuffIds
    integer PriestBuffCount=0
    integer PriestRefreshSerial=0
    real array PriestRainHealing
    real array PriestRainRadius
    real array PriestRainPeriod
    real array PriestRainDuration
    real array PriestRegenDuration
    unit array PriestRainCaster
    real array PriestRainLeft
    real array PriestRainNext
    group array PriestRainEnemies
    timer PriestRainTimer=null
    integer PriestRainCount=0
    integer PriestTooltipOffset=1
endglobals

function Priest_MasterData0 takes nothing returns nothing
    set PriestBuffIds[0]='B005'
    set PriestBuffIds[1]='B006'
    set PriestBuffIds[2]='B007'
    set PriestBuffIds[3]='B00F'
    set PriestBuffIds[4]='B00K'
    set PriestBuffIds[5]='B00S'
    set PriestBuffIds[6]='B00X'
    set PriestBuffIds[7]='B018'
    set PriestBuffIds[8]='B01A'
    set PriestBuffIds[9]='B01W'
    set PriestBuffIds[10]='B04B'
    set PriestBuffIds[11]='B04X'
    set PriestBuffIds[12]='B051'
    set PriestBuffIds[13]='B052'
    set PriestBuffIds[14]='B05A'
    set PriestBuffIds[15]='B06F'
    set PriestBuffIds[16]='B06L'
    set PriestBuffIds[17]='B06N'
    set PriestBuffIds[18]='B06T'
    set PriestBuffIds[19]='B06W'
    set PriestBuffIds[20]='B076'
    set PriestBuffIds[21]='B07F'
    set PriestBuffIds[22]='B07G'
    set PriestBuffIds[23]='B07H'
    set PriestBuffIds[24]='B07I'
    set PriestBuffIds[25]='B07J'
    set PriestBuffIds[26]='B07P'
    set PriestBuffIds[27]='B07R'
    set PriestBuffIds[28]='B07S'
    set PriestBuffIds[29]='B082'
    set PriestBuffIds[30]='B08P'
    set PriestBuffIds[31]='B08Q'
    set PriestBuffIds[32]='B08R'
    set PriestBuffIds[33]='B08S'
    set PriestBuffIds[34]='B08T'
    set PriestBuffIds[35]='BUfa'
    set PriestBuffIds[36]='Broa'
    call SaveBoolean(PriestBuffTypes,0,'B018',true)
    call SaveBoolean(PriestBuffTypes,0,'B04B',true)
    call SaveBoolean(PriestBuffTypes,0,'B051',true)
    call SaveBoolean(PriestBuffTypes,0,'B052',true)
    call SaveBoolean(PriestBuffTypes,0,'B06L',true)
    call SaveBoolean(PriestBuffTypes,0,'B06N',true)
    call SaveBoolean(PriestBuffTypes,0,'B076',true)
    call SaveBoolean(PriestBuffTypes,0,'B07R',true)
    call SaveBoolean(PriestBuffTypes,0,'B07S',true)
    call SaveBoolean(PriestBuffTypes,0,'B082',true)
    set PriestBuffCount=37
    set PriestRegenDuration[1]=12.0
    set PriestRegenDuration[2]=16.0
    set PriestRegenDuration[3]=20.0
    set PriestRegenDuration[4]=24.0
    set PriestRegenDuration[5]=28.0
    set PriestRegenDuration[6]=32.0
    set PriestRegenDuration[7]=36.0
    set PriestRegenDuration[8]=40.0
    set PriestRegenDuration[9]=44.0
    set PriestRegenDuration[10]=48.0
    set PriestRegenDuration[11]=60.0
    call SaveStr(PriestAbilityText,'A00G',1,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 15 seconds.")
    call SaveStr(PriestAbilityText,'A00G',2,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 20 seconds.")
    call SaveStr(PriestAbilityText,'A00G',3,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 25 seconds.")
    call SaveStr(PriestAbilityText,'A00G',4,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 30 seconds.")
    call SaveStr(PriestAbilityText,'A00G',5,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 35 seconds.")
    call SaveStr(PriestAbilityText,'A00G',6,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 40 seconds.")
    call SaveStr(PriestAbilityText,'A00G',7,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 45 seconds.")
    call SaveStr(PriestAbilityText,'A00G',8,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 50 seconds.")
    call SaveStr(PriestAbilityText,'A00G',9,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 55 seconds.")
    call SaveStr(PriestAbilityText,'A00G',10,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 60 seconds.")
    call SaveStr(PriestAbilityText,'A00G',11,"Increases friendly unit's defenses, reducing all physical damage taken by 33% for 75 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',1,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 15 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',2,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 20 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',3,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 25 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',4,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 30 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',5,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 35 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',6,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 40 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',7,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 45 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',8,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 50 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',9,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 55 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',10,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 60 seconds.")
    call SaveStr(PriestAbilityText,'A0TZ',11,"Encloses the target in a protective shell, reducing all magic damage they take by 33% for 75 seconds.")
    call SaveStr(PriestAbilityText,'A00M',1,"|cffffcc00Life Spell|r|nHeals [(5 x 80 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',2,"|cffffcc00Life Spell|r|nHeals [(5 x 110 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',3,"|cffffcc00Life Spell|r|nHeals [(5 x 140 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',4,"|cffffcc00Life Spell|r|nHeals [(5 x 170 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',5,"|cffffcc00Life Spell|r|nHeals [(5 x 200 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',6,"|cffffcc00Life Spell|r|nHeals [(5 x 230 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',7,"|cffffcc00Life Spell|r|nHeals [(5 x 260 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',8,"|cffffcc00Life Spell|r|nHeals [(5 x 290 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',9,"|cffffcc00Life Spell|r|nHeals [(5 x 320 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',10,"|cffffcc00Life Spell|r|nHeals [(5 x 350 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A00M',11,"|cffffcc00Life Spell|r|nHeals [(5 x 400 mana cost + 5 x caster Intelligence) x Staff power] HP on impact. Units along the path receive 25% of that heal. Target healing modifiers apply.")
    call SaveStr(PriestAbilityText,'A0OM',1,"Channels 500 base HP per second to nearby allies for 15 seconds. Acid Rain converts half: 250 base HP/sec to allies and 250 magic damage/sec to enemies in the same radius. Target healing/defense modifiers apply.")
    call SaveStr(PriestAbilityText,'A0OM',2,"Channels 1000 base HP per second to nearby allies for 15 seconds. Acid Rain converts half: 500 base HP/sec to allies and 500 magic damage/sec to enemies in the same radius. Target healing/defense modifiers apply.")
    call SaveStr(PriestAbilityText,'A0OM',3,"Channels 1500 base HP per second to nearby allies for 15 seconds. Acid Rain converts half: 750 base HP/sec to allies and 750 magic damage/sec to enemies in the same radius. Target healing/defense modifiers apply.")
    call SaveStr(PriestAbilityText,'A0OM',4,"Channels 2000 base HP per second to nearby allies for 15 seconds. Acid Rain converts half: 1000 base HP/sec to allies and 1000 magic damage/sec to enemies in the same radius. Target healing/defense modifiers apply.")
    call SaveStr(PriestAbilityText,'A0OM',5,"Channels 2500 base HP per second to nearby allies for 15 seconds. Acid Rain converts half: 1250 base HP/sec to allies and 1250 magic damage/sec to enemies in the same radius. Target healing/defense modifiers apply.")
    call SaveStr(PriestAbilityText,'A0OM',6,"Channels 4000 base HP per second to nearby allies for 15 seconds. Acid Rain converts half: 2000 base HP/sec to allies and 2000 magic damage/sec to enemies in the same radius. Target healing/defense modifiers apply.")
    call SaveStr(PriestAbilityText,'A0W9',1,"Cures all negative status ailments from the target.")
    call SaveStr(PriestAbilityText,'A0PC',1,"Channels until cancelled. Every second, adds P = floor[(50 + floor(caster Intelligence / 4)) x Staff power] to nearby allies' queued HP recovery. HP ticks roll 93.75%-100%; queued MP recovery rolls 23.4375%-25%. Healing modifiers and other queued recovery apply.")
    call SaveStr(PriestAbilityText,'A089',1,"|cffffcc00Life Spell|r|nRestores floor[(3 x 140 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',2,"|cffffcc00Life Spell|r|nRestores floor[(3 x 180 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',3,"|cffffcc00Life Spell|r|nRestores floor[(3 x 220 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',4,"|cffffcc00Life Spell|r|nRestores floor[(3 x 260 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',5,"|cffffcc00Life Spell|r|nRestores floor[(3 x 300 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',6,"|cffffcc00Life Spell|r|nRestores floor[(3 x 340 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',7,"|cffffcc00Life Spell|r|nRestores floor[(3 x 380 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',8,"|cffffcc00Life Spell|r|nRestores floor[(3 x 420 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',9,"|cffffcc00Life Spell|r|nRestores floor[(3 x 460 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',10,"|cffffcc00Life Spell|r|nRestores floor[(3 x 500 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveStr(PriestAbilityText,'A089',11,"|cffffcc00Life Spell|r|nRestores floor[(3 x 600 mana cost + 3 x caster Intelligence) x Staff power] HP and 25% of that amount as MP to nearby allies. The caster receives HP only. Cleanses ailments. Target recovery modifiers apply.")
    call SaveInteger(PriestBuffTypes,'A00L',1,'pB00')
    call SaveInteger(PriestBuffClone,'A00L','B006','pB00')
    call SaveStr(PriestBuffTypes,'A00L',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A00L',3,false)
    call SaveInteger(PriestBuffTypes,'A00L',17,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',16,1)
    call SaveReal(PriestBuffTypes,'A00L',25,0.0)
    call SaveReal(PriestBuffTypes,'A00L',26,12.0)
    call SaveInteger(PriestBuffTypes,'A00L',33,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',32,1)
    call SaveReal(PriestBuffTypes,'A00L',41,0.0)
    call SaveReal(PriestBuffTypes,'A00L',42,16.0)
    call SaveInteger(PriestBuffTypes,'A00L',49,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',48,1)
    call SaveReal(PriestBuffTypes,'A00L',57,0.0)
    call SaveReal(PriestBuffTypes,'A00L',58,20.0)
    call SaveInteger(PriestBuffTypes,'A00L',65,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',64,1)
    call SaveReal(PriestBuffTypes,'A00L',73,0.0)
    call SaveReal(PriestBuffTypes,'A00L',74,24.0)
    call SaveInteger(PriestBuffTypes,'A00L',81,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',80,1)
    call SaveReal(PriestBuffTypes,'A00L',89,0.0)
    call SaveReal(PriestBuffTypes,'A00L',90,28.0)
    call SaveInteger(PriestBuffTypes,'A00L',97,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',96,1)
    call SaveReal(PriestBuffTypes,'A00L',105,0.0)
    call SaveReal(PriestBuffTypes,'A00L',106,32.0)
    call SaveInteger(PriestBuffTypes,'A00L',113,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',112,1)
    call SaveReal(PriestBuffTypes,'A00L',121,0.0)
    call SaveReal(PriestBuffTypes,'A00L',122,36.0)
    call SaveInteger(PriestBuffTypes,'A00L',129,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',128,1)
    call SaveReal(PriestBuffTypes,'A00L',137,0.0)
    call SaveReal(PriestBuffTypes,'A00L',138,40.0)
    call SaveInteger(PriestBuffTypes,'A00L',145,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',144,1)
    call SaveReal(PriestBuffTypes,'A00L',153,0.0)
    call SaveReal(PriestBuffTypes,'A00L',154,44.0)
    call SaveInteger(PriestBuffTypes,'A00L',161,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',160,1)
    call SaveReal(PriestBuffTypes,'A00L',169,0.0)
    call SaveReal(PriestBuffTypes,'A00L',170,48.0)
    call SaveInteger(PriestBuffTypes,'A00L',177,'B006')
    call SaveInteger(PriestBuffTypes,'A00L',176,1)
    call SaveReal(PriestBuffTypes,'A00L',185,0.0)
    call SaveReal(PriestBuffTypes,'A00L',186,60.0)
    call SaveInteger(PriestBuffTypes,'A025',1,'pB01')
endfunction


function Priest_MasterData1 takes nothing returns nothing
    call SaveInteger(PriestBuffClone,'A025','B00K','pB01')
    call SaveStr(PriestBuffTypes,'A025',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A025',3,false)
    call SaveInteger(PriestBuffTypes,'A025',17,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',16,1)
    call SaveReal(PriestBuffTypes,'A025',25,0.0)
    call SaveReal(PriestBuffTypes,'A025',26,25.0)
    call SaveInteger(PriestBuffTypes,'A025',33,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',32,1)
    call SaveReal(PriestBuffTypes,'A025',41,0.0)
    call SaveReal(PriestBuffTypes,'A025',42,25.0)
    call SaveInteger(PriestBuffTypes,'A025',49,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',48,1)
    call SaveReal(PriestBuffTypes,'A025',57,0.0)
    call SaveReal(PriestBuffTypes,'A025',58,25.0)
    call SaveInteger(PriestBuffTypes,'A025',65,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',64,1)
    call SaveReal(PriestBuffTypes,'A025',73,0.0)
    call SaveReal(PriestBuffTypes,'A025',74,25.0)
    call SaveInteger(PriestBuffTypes,'A025',81,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',80,1)
    call SaveReal(PriestBuffTypes,'A025',89,0.0)
    call SaveReal(PriestBuffTypes,'A025',90,25.0)
    call SaveInteger(PriestBuffTypes,'A025',97,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',96,1)
    call SaveReal(PriestBuffTypes,'A025',105,0.0)
    call SaveReal(PriestBuffTypes,'A025',106,25.0)
    call SaveInteger(PriestBuffTypes,'A025',113,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',112,1)
    call SaveReal(PriestBuffTypes,'A025',121,0.0)
    call SaveReal(PriestBuffTypes,'A025',122,25.0)
    call SaveInteger(PriestBuffTypes,'A025',129,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',128,1)
    call SaveReal(PriestBuffTypes,'A025',137,0.0)
    call SaveReal(PriestBuffTypes,'A025',138,25.0)
    call SaveInteger(PriestBuffTypes,'A025',145,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',144,1)
    call SaveReal(PriestBuffTypes,'A025',153,0.0)
    call SaveReal(PriestBuffTypes,'A025',154,25.0)
    call SaveInteger(PriestBuffTypes,'A025',161,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',160,1)
    call SaveReal(PriestBuffTypes,'A025',169,0.0)
    call SaveReal(PriestBuffTypes,'A025',170,25.0)
    call SaveInteger(PriestBuffTypes,'A025',177,'B00K')
    call SaveInteger(PriestBuffTypes,'A025',176,1)
    call SaveReal(PriestBuffTypes,'A025',185,0.0)
    call SaveReal(PriestBuffTypes,'A025',186,25.0)
    call SaveInteger(PriestBuffTypes,'A02V',1,'pB02')
    call SaveInteger(PriestBuffClone,'A02V','B00S','pB02')
    call SaveStr(PriestBuffTypes,'A02V',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A02V',3,false)
    call SaveInteger(PriestBuffTypes,'A02V',17,'B00S')
    call SaveInteger(PriestBuffTypes,'A02V',16,1)
    call SaveReal(PriestBuffTypes,'A02V',25,0.0)
    call SaveReal(PriestBuffTypes,'A02V',26,20.0)
    call SaveInteger(PriestBuffTypes,'A03B',1,'pB03')
    call SaveInteger(PriestBuffClone,'A03B','B00X','pB03')
    call SaveStr(PriestBuffTypes,'A03B',2,"battleroar")
    call SaveBoolean(PriestBuffTypes,'A03B',3,true)
    call SaveInteger(PriestBuffTypes,'A03B',17,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',16,1)
    call SaveReal(PriestBuffTypes,'A03B',25,900.0)
    call SaveReal(PriestBuffTypes,'A03B',26,20.0)
    call SaveInteger(PriestBuffTypes,'A03B',33,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',32,1)
    call SaveReal(PriestBuffTypes,'A03B',41,900.0)
    call SaveReal(PriestBuffTypes,'A03B',42,22.0)
    call SaveInteger(PriestBuffTypes,'A03B',49,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',48,1)
    call SaveReal(PriestBuffTypes,'A03B',57,900.0)
    call SaveReal(PriestBuffTypes,'A03B',58,24.0)
    call SaveInteger(PriestBuffTypes,'A03B',65,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',64,1)
    call SaveReal(PriestBuffTypes,'A03B',73,900.0)
    call SaveReal(PriestBuffTypes,'A03B',74,26.0)
    call SaveInteger(PriestBuffTypes,'A03B',81,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',80,1)
    call SaveReal(PriestBuffTypes,'A03B',89,900.0)
    call SaveReal(PriestBuffTypes,'A03B',90,28.0)
    call SaveInteger(PriestBuffTypes,'A03B',97,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',96,1)
    call SaveReal(PriestBuffTypes,'A03B',105,900.0)
    call SaveReal(PriestBuffTypes,'A03B',106,30.0)
    call SaveInteger(PriestBuffTypes,'A03B',113,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',112,1)
    call SaveReal(PriestBuffTypes,'A03B',121,900.0)
    call SaveReal(PriestBuffTypes,'A03B',122,32.0)
    call SaveInteger(PriestBuffTypes,'A03B',129,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',128,1)
    call SaveReal(PriestBuffTypes,'A03B',137,900.0)
    call SaveReal(PriestBuffTypes,'A03B',138,34.0)
    call SaveInteger(PriestBuffTypes,'A03B',145,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',144,1)
    call SaveReal(PriestBuffTypes,'A03B',153,900.0)
    call SaveReal(PriestBuffTypes,'A03B',154,36.0)
    call SaveInteger(PriestBuffTypes,'A03B',161,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',160,1)
    call SaveReal(PriestBuffTypes,'A03B',169,900.0)
    call SaveReal(PriestBuffTypes,'A03B',170,38.0)
    call SaveInteger(PriestBuffTypes,'A03B',177,'B00X')
    call SaveInteger(PriestBuffTypes,'A03B',176,1)
    call SaveReal(PriestBuffTypes,'A03B',185,900.0)
    call SaveReal(PriestBuffTypes,'A03B',186,40.0)
    call SaveInteger(PriestBuffTypes,'A056',1,'pB04')
    call SaveInteger(PriestBuffClone,'A056','B007','pB04')
    call SaveStr(PriestBuffTypes,'A056',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A056',3,false)
    call SaveInteger(PriestBuffTypes,'A056',17,'B007')
    call SaveInteger(PriestBuffTypes,'A056',16,1)
    call SaveReal(PriestBuffTypes,'A056',25,0.0)
    call SaveReal(PriestBuffTypes,'A056',26,20.0)
    call SaveInteger(PriestBuffTypes,'A059',1,'pB05')
    call SaveInteger(PriestBuffClone,'A059','B00F','pB05')
    call SaveStr(PriestBuffTypes,'A059',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A059',3,false)
    call SaveInteger(PriestBuffTypes,'A059',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A059',16,1)
    call SaveReal(PriestBuffTypes,'A059',25,0.0)
    call SaveReal(PriestBuffTypes,'A059',26,20.0)
    call SaveInteger(PriestBuffTypes,'A05W',1,'pB06')
    call SaveInteger(PriestBuffClone,'A05W','B018','pB06')
    call SaveStr(PriestBuffTypes,'A05W',2,"roar")
    call SaveBoolean(PriestBuffTypes,'A05W',3,true)
    call SaveInteger(PriestBuffTypes,'A05W',17,'B018')
    call SaveInteger(PriestBuffTypes,'A05W',16,1)
    call SaveReal(PriestBuffTypes,'A05W',25,10.0)
    call SaveReal(PriestBuffTypes,'A05W',26,10.0)
    call SaveInteger(PriestBuffTypes,'A05W',33,'B018')
    call SaveInteger(PriestBuffTypes,'A05W',32,1)
    call SaveReal(PriestBuffTypes,'A05W',41,10.0)
    call SaveReal(PriestBuffTypes,'A05W',42,12.0)
    call SaveInteger(PriestBuffTypes,'A05W',49,'B018')
    call SaveInteger(PriestBuffTypes,'A05W',48,1)
    call SaveReal(PriestBuffTypes,'A05W',57,10.0)
    call SaveReal(PriestBuffTypes,'A05W',58,14.0)
    call SaveInteger(PriestBuffTypes,'A05W',65,'B018')
    call SaveInteger(PriestBuffTypes,'A05W',64,1)
    call SaveReal(PriestBuffTypes,'A05W',73,10.0)
    call SaveReal(PriestBuffTypes,'A05W',74,16.0)
    call SaveInteger(PriestBuffTypes,'A05W',81,'B018')
    call SaveInteger(PriestBuffTypes,'A05W',80,1)
    call SaveReal(PriestBuffTypes,'A05W',89,10.0)
    call SaveReal(PriestBuffTypes,'A05W',90,18.0)
    call SaveInteger(PriestBuffTypes,'A05W',97,'B018')
    call SaveInteger(PriestBuffTypes,'A05W',96,1)
    call SaveReal(PriestBuffTypes,'A05W',105,10.0)
    call SaveReal(PriestBuffTypes,'A05W',106,20.0)
    call SaveInteger(PriestBuffTypes,'A06D',1,'pB07')
    call SaveInteger(PriestBuffClone,'A06D','B01A','pB07')
    call SaveStr(PriestBuffTypes,'A06D',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A06D',3,false)
    call SaveInteger(PriestBuffTypes,'A06D',17,'B01A')
    call SaveInteger(PriestBuffTypes,'A06D',16,1)
    call SaveReal(PriestBuffTypes,'A06D',25,0.0)
    call SaveReal(PriestBuffTypes,'A06D',26,10.0)
    call SaveInteger(PriestBuffTypes,'A070',1,'pB08')
    call SaveInteger(PriestBuffClone,'A070','B00K','pB08')
    call SaveStr(PriestBuffTypes,'A070',2,"frenzy")
    call SaveBoolean(PriestBuffTypes,'A070',3,false)
    call SaveInteger(PriestBuffTypes,'A070',17,'B00K')
endfunction


function Priest_MasterData2 takes nothing returns nothing
    call SaveInteger(PriestBuffTypes,'A070',16,1)
    call SaveReal(PriestBuffTypes,'A070',25,0.0)
    call SaveReal(PriestBuffTypes,'A070',26,15.0)
    call SaveInteger(PriestBuffTypes,'A070',33,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',32,1)
    call SaveReal(PriestBuffTypes,'A070',41,0.0)
    call SaveReal(PriestBuffTypes,'A070',42,20.0)
    call SaveInteger(PriestBuffTypes,'A070',49,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',48,1)
    call SaveReal(PriestBuffTypes,'A070',57,0.0)
    call SaveReal(PriestBuffTypes,'A070',58,20.0)
    call SaveInteger(PriestBuffTypes,'A070',65,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',64,1)
    call SaveReal(PriestBuffTypes,'A070',73,0.0)
    call SaveReal(PriestBuffTypes,'A070',74,20.0)
    call SaveInteger(PriestBuffTypes,'A070',81,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',80,1)
    call SaveReal(PriestBuffTypes,'A070',89,0.0)
    call SaveReal(PriestBuffTypes,'A070',90,20.0)
    call SaveInteger(PriestBuffTypes,'A070',97,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',96,1)
    call SaveReal(PriestBuffTypes,'A070',105,0.0)
    call SaveReal(PriestBuffTypes,'A070',106,20.0)
    call SaveInteger(PriestBuffTypes,'A070',113,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',112,1)
    call SaveReal(PriestBuffTypes,'A070',121,0.0)
    call SaveReal(PriestBuffTypes,'A070',122,20.0)
    call SaveInteger(PriestBuffTypes,'A070',129,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',128,1)
    call SaveReal(PriestBuffTypes,'A070',137,0.0)
    call SaveReal(PriestBuffTypes,'A070',138,20.0)
    call SaveInteger(PriestBuffTypes,'A070',145,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',144,1)
    call SaveReal(PriestBuffTypes,'A070',153,0.0)
    call SaveReal(PriestBuffTypes,'A070',154,20.0)
    call SaveInteger(PriestBuffTypes,'A070',161,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',160,1)
    call SaveReal(PriestBuffTypes,'A070',169,0.0)
    call SaveReal(PriestBuffTypes,'A070',170,20.0)
    call SaveInteger(PriestBuffTypes,'A070',177,'B00K')
    call SaveInteger(PriestBuffTypes,'A070',176,1)
    call SaveReal(PriestBuffTypes,'A070',185,0.0)
    call SaveReal(PriestBuffTypes,'A070',186,20.0)
    call SaveInteger(PriestBuffTypes,'A07D',1,'pB09')
    call SaveInteger(PriestBuffClone,'A07D','B007','pB09')
    call SaveStr(PriestBuffTypes,'A07D',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A07D',3,false)
    call SaveInteger(PriestBuffTypes,'A07D',17,'B007')
    call SaveInteger(PriestBuffTypes,'A07D',16,1)
    call SaveReal(PriestBuffTypes,'A07D',25,0.0)
    call SaveReal(PriestBuffTypes,'A07D',26,15.0)
    call SaveInteger(PriestBuffTypes,'A083',1,'pB0A')
    call SaveInteger(PriestBuffClone,'A083','B01W','pB0A')
    call SaveStr(PriestBuffTypes,'A083',2,"innerfire")
    call SaveBoolean(PriestBuffTypes,'A083',3,false)
    call SaveInteger(PriestBuffTypes,'A083',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',16,1)
    call SaveReal(PriestBuffTypes,'A083',25,0.0)
    call SaveReal(PriestBuffTypes,'A083',26,15.0)
    call SaveInteger(PriestBuffTypes,'A083',33,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',32,1)
    call SaveReal(PriestBuffTypes,'A083',41,0.0)
    call SaveReal(PriestBuffTypes,'A083',42,20.0)
    call SaveInteger(PriestBuffTypes,'A083',49,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',48,1)
    call SaveReal(PriestBuffTypes,'A083',57,0.0)
    call SaveReal(PriestBuffTypes,'A083',58,25.0)
    call SaveInteger(PriestBuffTypes,'A083',65,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',64,1)
    call SaveReal(PriestBuffTypes,'A083',73,0.0)
    call SaveReal(PriestBuffTypes,'A083',74,30.0)
    call SaveInteger(PriestBuffTypes,'A083',81,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',80,1)
    call SaveReal(PriestBuffTypes,'A083',89,0.0)
    call SaveReal(PriestBuffTypes,'A083',90,35.0)
    call SaveInteger(PriestBuffTypes,'A083',97,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',96,1)
    call SaveReal(PriestBuffTypes,'A083',105,0.0)
    call SaveReal(PriestBuffTypes,'A083',106,40.0)
    call SaveInteger(PriestBuffTypes,'A083',113,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',112,1)
    call SaveReal(PriestBuffTypes,'A083',121,0.0)
    call SaveReal(PriestBuffTypes,'A083',122,45.0)
    call SaveInteger(PriestBuffTypes,'A083',129,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',128,1)
    call SaveReal(PriestBuffTypes,'A083',137,0.0)
    call SaveReal(PriestBuffTypes,'A083',138,50.0)
    call SaveInteger(PriestBuffTypes,'A083',145,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',144,1)
    call SaveReal(PriestBuffTypes,'A083',153,0.0)
    call SaveReal(PriestBuffTypes,'A083',154,55.0)
    call SaveInteger(PriestBuffTypes,'A083',161,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',160,1)
    call SaveReal(PriestBuffTypes,'A083',169,0.0)
    call SaveReal(PriestBuffTypes,'A083',170,60.0)
    call SaveInteger(PriestBuffTypes,'A083',177,'B01W')
    call SaveInteger(PriestBuffTypes,'A083',176,1)
    call SaveReal(PriestBuffTypes,'A083',185,0.0)
    call SaveReal(PriestBuffTypes,'A083',186,75.0)
    call SaveInteger(PriestBuffTypes,'A09A',1,'pB0B')
    call SaveInteger(PriestBuffClone,'A09A','B05A','pB0B')
    call SaveStr(PriestBuffTypes,'A09A',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A09A',3,false)
    call SaveInteger(PriestBuffTypes,'A09A',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A09A',16,1)
    call SaveReal(PriestBuffTypes,'A09A',25,0.0)
    call SaveReal(PriestBuffTypes,'A09A',26,60.0)
    call SaveInteger(PriestBuffTypes,'A09K',1,'pB0C')
    call SaveInteger(PriestBuffClone,'A09K','B007','pB0C')
    call SaveStr(PriestBuffTypes,'A09K',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A09K',3,false)
    call SaveInteger(PriestBuffTypes,'A09K',17,'B007')
    call SaveInteger(PriestBuffTypes,'A09K',16,1)
    call SaveReal(PriestBuffTypes,'A09K',25,0.0)
    call SaveReal(PriestBuffTypes,'A09K',26,15.0)
    call SaveInteger(PriestBuffTypes,'A0A7',1,'pB0D')
    call SaveInteger(PriestBuffClone,'A0A7','B00F','pB0D')
    call SaveStr(PriestBuffTypes,'A0A7',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A0A7',3,false)
    call SaveInteger(PriestBuffTypes,'A0A7',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A0A7',16,1)
    call SaveReal(PriestBuffTypes,'A0A7',25,0.0)
    call SaveReal(PriestBuffTypes,'A0A7',26,45.0)
    call SaveInteger(PriestBuffTypes,'A0AA',1,'pB0E')
    call SaveInteger(PriestBuffClone,'A0AA','B007','pB0E')
    call SaveStr(PriestBuffTypes,'A0AA',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A0AA',3,false)
    call SaveInteger(PriestBuffTypes,'A0AA',17,'B007')
    call SaveInteger(PriestBuffTypes,'A0AA',16,1)
    call SaveReal(PriestBuffTypes,'A0AA',25,0.0)
    call SaveReal(PriestBuffTypes,'A0AA',26,15.0)
    call SaveInteger(PriestBuffTypes,'A0B6',1,'pB0F')
    call SaveInteger(PriestBuffClone,'A0B6','B006','pB0F')
    call SaveStr(PriestBuffTypes,'A0B6',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A0B6',3,false)
    call SaveInteger(PriestBuffTypes,'A0B6',17,'B006')
    call SaveInteger(PriestBuffTypes,'A0B6',16,1)
    call SaveReal(PriestBuffTypes,'A0B6',25,0.0)
    call SaveReal(PriestBuffTypes,'A0B6',26,60.0)
    call SaveInteger(PriestBuffTypes,'A0BJ',1,'pB10')
    call SaveInteger(PriestBuffClone,'A0BJ','B007','pB10')
    call SaveStr(PriestBuffTypes,'A0BJ',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A0BJ',3,false)
    call SaveInteger(PriestBuffTypes,'A0BJ',17,'B007')
    call SaveInteger(PriestBuffTypes,'A0BJ',16,1)
    call SaveReal(PriestBuffTypes,'A0BJ',25,0.0)
    call SaveReal(PriestBuffTypes,'A0BJ',26,60.0)
    call SaveInteger(PriestBuffTypes,'A0D9',1,'pB11')
    call SaveInteger(PriestBuffClone,'A0D9','B00F','pB11')
    call SaveStr(PriestBuffTypes,'A0D9',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A0D9',3,false)
    call SaveInteger(PriestBuffTypes,'A0D9',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',16,1)
    call SaveReal(PriestBuffTypes,'A0D9',25,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',26,10.0)
    call SaveInteger(PriestBuffTypes,'A0D9',33,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',32,1)
    call SaveReal(PriestBuffTypes,'A0D9',41,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',42,12.0)
    call SaveInteger(PriestBuffTypes,'A0D9',49,'B00F')
endfunction


function Priest_MasterData3 takes nothing returns nothing
    call SaveInteger(PriestBuffTypes,'A0D9',48,1)
    call SaveReal(PriestBuffTypes,'A0D9',57,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',58,14.0)
    call SaveInteger(PriestBuffTypes,'A0D9',65,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',64,1)
    call SaveReal(PriestBuffTypes,'A0D9',73,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',74,16.0)
    call SaveInteger(PriestBuffTypes,'A0D9',81,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',80,1)
    call SaveReal(PriestBuffTypes,'A0D9',89,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',90,18.0)
    call SaveInteger(PriestBuffTypes,'A0D9',97,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',96,1)
    call SaveReal(PriestBuffTypes,'A0D9',105,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',106,20.0)
    call SaveInteger(PriestBuffTypes,'A0D9',113,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',112,1)
    call SaveReal(PriestBuffTypes,'A0D9',121,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',122,22.0)
    call SaveInteger(PriestBuffTypes,'A0D9',129,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',128,1)
    call SaveReal(PriestBuffTypes,'A0D9',137,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',138,24.0)
    call SaveInteger(PriestBuffTypes,'A0D9',145,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',144,1)
    call SaveReal(PriestBuffTypes,'A0D9',153,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',154,26.0)
    call SaveInteger(PriestBuffTypes,'A0D9',161,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',160,1)
    call SaveReal(PriestBuffTypes,'A0D9',169,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',170,28.0)
    call SaveInteger(PriestBuffTypes,'A0D9',177,'B00F')
    call SaveInteger(PriestBuffTypes,'A0D9',176,1)
    call SaveReal(PriestBuffTypes,'A0D9',185,0.0)
    call SaveReal(PriestBuffTypes,'A0D9',186,30.0)
    call SaveInteger(PriestBuffTypes,'A0ED',1,'pB12')
    call SaveInteger(PriestBuffClone,'A0ED','B00F','pB12')
    call SaveStr(PriestBuffTypes,'A0ED',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A0ED',3,false)
    call SaveInteger(PriestBuffTypes,'A0ED',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A0ED',16,1)
    call SaveReal(PriestBuffTypes,'A0ED',25,0.0)
    call SaveReal(PriestBuffTypes,'A0ED',26,55.0)
    call SaveInteger(PriestBuffTypes,'A0EE',1,'pB13')
    call SaveInteger(PriestBuffClone,'A0EE','B007','pB13')
    call SaveStr(PriestBuffTypes,'A0EE',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A0EE',3,false)
    call SaveInteger(PriestBuffTypes,'A0EE',17,'B007')
    call SaveInteger(PriestBuffTypes,'A0EE',16,1)
    call SaveReal(PriestBuffTypes,'A0EE',25,0.0)
    call SaveReal(PriestBuffTypes,'A0EE',26,55.0)
    call SaveInteger(PriestBuffTypes,'A0EV',1,'pB14')
    call SaveInteger(PriestBuffClone,'A0EV','B00F','pB14')
    call SaveStr(PriestBuffTypes,'A0EV',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A0EV',3,false)
    call SaveInteger(PriestBuffTypes,'A0EV',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A0EV',16,1)
    call SaveReal(PriestBuffTypes,'A0EV',25,0.0)
    call SaveReal(PriestBuffTypes,'A0EV',26,30.0)
    call SaveInteger(PriestBuffTypes,'A0FW',1,'pB15')
    call SaveInteger(PriestBuffClone,'A0FW','B006','pB15')
    call SaveStr(PriestBuffTypes,'A0FW',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A0FW',3,false)
    call SaveInteger(PriestBuffTypes,'A0FW',17,'B006')
    call SaveInteger(PriestBuffTypes,'A0FW',16,1)
    call SaveReal(PriestBuffTypes,'A0FW',25,0.0)
    call SaveReal(PriestBuffTypes,'A0FW',26,30.0)
    call SaveInteger(PriestBuffTypes,'A0IG',1,'pB16')
    call SaveInteger(PriestBuffClone,'A0IG','B06W','pB16')
    call SaveStr(PriestBuffTypes,'A0IG',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0IG',3,false)
    call SaveInteger(PriestBuffTypes,'A0IG',17,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',16,1)
    call SaveReal(PriestBuffTypes,'A0IG',25,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',26,6.0)
    call SaveInteger(PriestBuffTypes,'A0IG',33,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',32,1)
    call SaveReal(PriestBuffTypes,'A0IG',41,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',42,8.0)
    call SaveInteger(PriestBuffTypes,'A0IG',49,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',48,1)
    call SaveReal(PriestBuffTypes,'A0IG',57,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',58,10.0)
    call SaveInteger(PriestBuffTypes,'A0IG',65,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',64,1)
    call SaveReal(PriestBuffTypes,'A0IG',73,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',74,12.0)
    call SaveInteger(PriestBuffTypes,'A0IG',81,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',80,1)
    call SaveReal(PriestBuffTypes,'A0IG',89,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',90,14.0)
    call SaveInteger(PriestBuffTypes,'A0IG',97,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',96,1)
    call SaveReal(PriestBuffTypes,'A0IG',105,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',106,16.0)
    call SaveInteger(PriestBuffTypes,'A0IG',113,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',112,1)
    call SaveReal(PriestBuffTypes,'A0IG',121,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',122,18.0)
    call SaveInteger(PriestBuffTypes,'A0IG',129,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',128,1)
    call SaveReal(PriestBuffTypes,'A0IG',137,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',138,20.0)
    call SaveInteger(PriestBuffTypes,'A0IG',145,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',144,1)
    call SaveReal(PriestBuffTypes,'A0IG',153,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',154,22.0)
    call SaveInteger(PriestBuffTypes,'A0IG',161,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',160,1)
    call SaveReal(PriestBuffTypes,'A0IG',169,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',170,24.0)
    call SaveInteger(PriestBuffTypes,'A0IG',177,'B06W')
    call SaveInteger(PriestBuffTypes,'A0IG',176,1)
    call SaveReal(PriestBuffTypes,'A0IG',185,0.0)
    call SaveReal(PriestBuffTypes,'A0IG',186,30.0)
    call SaveInteger(PriestBuffTypes,'A0L1',1,'pB17')
    call SaveInteger(PriestBuffClone,'A0L1','B005','pB17')
    call SaveStr(PriestBuffTypes,'A0L1',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A0L1',3,false)
    call SaveInteger(PriestBuffTypes,'A0L1',17,'B005')
    call SaveInteger(PriestBuffTypes,'A0L1',16,1)
    call SaveReal(PriestBuffTypes,'A0L1',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0L1',26,45.0)
    call SaveInteger(PriestBuffTypes,'A0L2',1,'pB18')
    call SaveInteger(PriestBuffClone,'A0L2','B052','pB18')
    call SaveStr(PriestBuffTypes,'A0L2',2,"curse")
    call SaveBoolean(PriestBuffTypes,'A0L2',3,false)
    call SaveInteger(PriestBuffTypes,'A0L2',17,'B052')
    call SaveInteger(PriestBuffTypes,'A0L2',16,1)
    call SaveReal(PriestBuffTypes,'A0L2',25,0.0)
    call SaveReal(PriestBuffTypes,'A0L2',26,5.0)
    call SaveInteger(PriestBuffTypes,'A0L2',33,'B052')
    call SaveInteger(PriestBuffTypes,'A0L2',32,1)
    call SaveReal(PriestBuffTypes,'A0L2',41,0.0)
    call SaveReal(PriestBuffTypes,'A0L2',42,6.0)
    call SaveInteger(PriestBuffTypes,'A0L2',49,'B052')
    call SaveInteger(PriestBuffTypes,'A0L2',48,1)
    call SaveReal(PriestBuffTypes,'A0L2',57,0.0)
    call SaveReal(PriestBuffTypes,'A0L2',58,7.0)
    call SaveInteger(PriestBuffTypes,'A0L2',65,'B052')
    call SaveInteger(PriestBuffTypes,'A0L2',64,1)
    call SaveReal(PriestBuffTypes,'A0L2',73,0.0)
    call SaveReal(PriestBuffTypes,'A0L2',74,8.0)
    call SaveInteger(PriestBuffTypes,'A0L2',81,'B052')
    call SaveInteger(PriestBuffTypes,'A0L2',80,1)
    call SaveReal(PriestBuffTypes,'A0L2',89,0.0)
    call SaveReal(PriestBuffTypes,'A0L2',90,9.0)
    call SaveInteger(PriestBuffTypes,'A0L2',97,'B052')
    call SaveInteger(PriestBuffTypes,'A0L2',96,1)
    call SaveReal(PriestBuffTypes,'A0L2',105,0.0)
    call SaveReal(PriestBuffTypes,'A0L2',106,10.0)
    call SaveInteger(PriestBuffTypes,'A0MZ',1,'pB19')
    call SaveInteger(PriestBuffClone,'A0MZ','B01W','pB19')
    call SaveStr(PriestBuffTypes,'A0MZ',2,"innerfire")
    call SaveBoolean(PriestBuffTypes,'A0MZ',3,false)
    call SaveInteger(PriestBuffTypes,'A0MZ',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A0MZ',16,1)
    call SaveReal(PriestBuffTypes,'A0MZ',25,0.0)
    call SaveReal(PriestBuffTypes,'A0MZ',26,15.0)
    call SaveInteger(PriestBuffTypes,'A0N0',1,'pB1A')
endfunction


function Priest_MasterData4 takes nothing returns nothing
    call SaveInteger(PriestBuffClone,'A0N0','B05A','pB1A')
    call SaveStr(PriestBuffTypes,'A0N0',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0N0',3,false)
    call SaveInteger(PriestBuffTypes,'A0N0',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A0N0',16,1)
    call SaveReal(PriestBuffTypes,'A0N0',25,0.0)
    call SaveReal(PriestBuffTypes,'A0N0',26,60.0)
    call SaveInteger(PriestBuffTypes,'A0PL',1,'pB1B')
    call SaveInteger(PriestBuffClone,'A0PL','B04X','pB1B')
    call SaveStr(PriestBuffTypes,'A0PL',2,"roar")
    call SaveBoolean(PriestBuffTypes,'A0PL',3,true)
    call SaveInteger(PriestBuffTypes,'A0PL',17,'B04X')
    call SaveInteger(PriestBuffTypes,'A0PL',16,1)
    call SaveReal(PriestBuffTypes,'A0PL',25,1000.0)
    call SaveReal(PriestBuffTypes,'A0PL',26,60.0)
    call SaveInteger(PriestBuffTypes,'A0QL',1,'pB1C')
    call SaveInteger(PriestBuffClone,'A0QL','B08P','pB1C')
    call SaveStr(PriestBuffTypes,'A0QL',2,"innerfire")
    call SaveBoolean(PriestBuffTypes,'A0QL',3,false)
    call SaveInteger(PriestBuffTypes,'A0QL',17,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',16,1)
    call SaveReal(PriestBuffTypes,'A0QL',25,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',26,6.0)
    call SaveInteger(PriestBuffTypes,'A0QL',33,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',32,1)
    call SaveReal(PriestBuffTypes,'A0QL',41,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',42,8.0)
    call SaveInteger(PriestBuffTypes,'A0QL',49,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',48,1)
    call SaveReal(PriestBuffTypes,'A0QL',57,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',58,10.0)
    call SaveInteger(PriestBuffTypes,'A0QL',65,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',64,1)
    call SaveReal(PriestBuffTypes,'A0QL',73,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',74,12.0)
    call SaveInteger(PriestBuffTypes,'A0QL',81,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',80,1)
    call SaveReal(PriestBuffTypes,'A0QL',89,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',90,14.0)
    call SaveInteger(PriestBuffTypes,'A0QL',97,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',96,1)
    call SaveReal(PriestBuffTypes,'A0QL',105,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',106,16.0)
    call SaveInteger(PriestBuffTypes,'A0QL',113,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',112,1)
    call SaveReal(PriestBuffTypes,'A0QL',121,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',122,18.0)
    call SaveInteger(PriestBuffTypes,'A0QL',129,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',128,1)
    call SaveReal(PriestBuffTypes,'A0QL',137,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',138,20.0)
    call SaveInteger(PriestBuffTypes,'A0QL',145,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',144,1)
    call SaveReal(PriestBuffTypes,'A0QL',153,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',154,22.0)
    call SaveInteger(PriestBuffTypes,'A0QL',161,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',160,1)
    call SaveReal(PriestBuffTypes,'A0QL',169,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',170,24.0)
    call SaveInteger(PriestBuffTypes,'A0QL',177,'B08P')
    call SaveInteger(PriestBuffTypes,'A0QL',176,1)
    call SaveReal(PriestBuffTypes,'A0QL',185,0.0)
    call SaveReal(PriestBuffTypes,'A0QL',186,30.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',1,'pB1D')
    call SaveInteger(PriestBuffClone,'A0QZ','B08Q','pB1D')
    call SaveStr(PriestBuffTypes,'A0QZ',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0QZ',3,false)
    call SaveInteger(PriestBuffTypes,'A0QZ',17,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',16,1)
    call SaveReal(PriestBuffTypes,'A0QZ',25,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',26,6.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',33,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',32,1)
    call SaveReal(PriestBuffTypes,'A0QZ',41,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',42,8.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',49,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',48,1)
    call SaveReal(PriestBuffTypes,'A0QZ',57,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',58,10.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',65,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',64,1)
    call SaveReal(PriestBuffTypes,'A0QZ',73,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',74,12.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',81,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',80,1)
    call SaveReal(PriestBuffTypes,'A0QZ',89,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',90,14.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',97,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',96,1)
    call SaveReal(PriestBuffTypes,'A0QZ',105,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',106,16.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',113,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',112,1)
    call SaveReal(PriestBuffTypes,'A0QZ',121,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',122,18.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',129,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',128,1)
    call SaveReal(PriestBuffTypes,'A0QZ',137,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',138,20.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',145,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',144,1)
    call SaveReal(PriestBuffTypes,'A0QZ',153,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',154,22.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',161,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',160,1)
    call SaveReal(PriestBuffTypes,'A0QZ',169,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',170,24.0)
    call SaveInteger(PriestBuffTypes,'A0QZ',177,'B08Q')
    call SaveInteger(PriestBuffTypes,'A0QZ',176,1)
    call SaveReal(PriestBuffTypes,'A0QZ',185,0.0)
    call SaveReal(PriestBuffTypes,'A0QZ',186,30.0)
    call SaveInteger(PriestBuffTypes,'A0R1',1,'pB1E')
    call SaveInteger(PriestBuffClone,'A0R1','B04B','pB1E')
    call SaveStr(PriestBuffTypes,'A0R1',2,"battleroar")
    call SaveBoolean(PriestBuffTypes,'A0R1',3,true)
    call SaveInteger(PriestBuffTypes,'A0R1',17,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',16,1)
    call SaveReal(PriestBuffTypes,'A0R1',25,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',26,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',33,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',32,1)
    call SaveReal(PriestBuffTypes,'A0R1',41,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',42,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',49,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',48,1)
    call SaveReal(PriestBuffTypes,'A0R1',57,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',58,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',65,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',64,1)
    call SaveReal(PriestBuffTypes,'A0R1',73,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',74,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',81,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',80,1)
    call SaveReal(PriestBuffTypes,'A0R1',89,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',90,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',97,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',96,1)
    call SaveReal(PriestBuffTypes,'A0R1',105,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',106,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',113,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',112,1)
    call SaveReal(PriestBuffTypes,'A0R1',121,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',122,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',129,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',128,1)
    call SaveReal(PriestBuffTypes,'A0R1',137,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',138,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',145,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',144,1)
    call SaveReal(PriestBuffTypes,'A0R1',153,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',154,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',161,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',160,1)
    call SaveReal(PriestBuffTypes,'A0R1',169,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',170,15.0)
    call SaveInteger(PriestBuffTypes,'A0R1',177,'B04B')
    call SaveInteger(PriestBuffTypes,'A0R1',176,1)
    call SaveReal(PriestBuffTypes,'A0R1',185,10.0)
    call SaveReal(PriestBuffTypes,'A0R1',186,15.0)
    call SaveInteger(PriestBuffTypes,'A0R4',1,'pB1F')
endfunction


function Priest_MasterData5 takes nothing returns nothing
    call SaveInteger(PriestBuffClone,'A0R4','B08R','pB1F')
    call SaveStr(PriestBuffTypes,'A0R4',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A0R4',3,false)
    call SaveInteger(PriestBuffTypes,'A0R4',17,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',16,1)
    call SaveReal(PriestBuffTypes,'A0R4',25,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',26,6.0)
    call SaveInteger(PriestBuffTypes,'A0R4',33,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',32,1)
    call SaveReal(PriestBuffTypes,'A0R4',41,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',42,8.0)
    call SaveInteger(PriestBuffTypes,'A0R4',49,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',48,1)
    call SaveReal(PriestBuffTypes,'A0R4',57,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',58,10.0)
    call SaveInteger(PriestBuffTypes,'A0R4',65,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',64,1)
    call SaveReal(PriestBuffTypes,'A0R4',73,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',74,12.0)
    call SaveInteger(PriestBuffTypes,'A0R4',81,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',80,1)
    call SaveReal(PriestBuffTypes,'A0R4',89,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',90,14.0)
    call SaveInteger(PriestBuffTypes,'A0R4',97,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',96,1)
    call SaveReal(PriestBuffTypes,'A0R4',105,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',106,16.0)
    call SaveInteger(PriestBuffTypes,'A0R4',113,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',112,1)
    call SaveReal(PriestBuffTypes,'A0R4',121,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',122,18.0)
    call SaveInteger(PriestBuffTypes,'A0R4',129,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',128,1)
    call SaveReal(PriestBuffTypes,'A0R4',137,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',138,20.0)
    call SaveInteger(PriestBuffTypes,'A0R4',145,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',144,1)
    call SaveReal(PriestBuffTypes,'A0R4',153,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',154,22.0)
    call SaveInteger(PriestBuffTypes,'A0R4',161,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',160,1)
    call SaveReal(PriestBuffTypes,'A0R4',169,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',170,24.0)
    call SaveInteger(PriestBuffTypes,'A0R4',177,'B08R')
    call SaveInteger(PriestBuffTypes,'A0R4',176,1)
    call SaveReal(PriestBuffTypes,'A0R4',185,0.0)
    call SaveReal(PriestBuffTypes,'A0R4',186,30.0)
    call SaveInteger(PriestBuffTypes,'A0RW',1,'pB20')
    call SaveInteger(PriestBuffClone,'A0RW','B05A','pB20')
    call SaveStr(PriestBuffTypes,'A0RW',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0RW',3,false)
    call SaveInteger(PriestBuffTypes,'A0RW',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',16,1)
    call SaveReal(PriestBuffTypes,'A0RW',25,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',26,15.0)
    call SaveInteger(PriestBuffTypes,'A0RW',33,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',32,1)
    call SaveReal(PriestBuffTypes,'A0RW',41,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',42,20.0)
    call SaveInteger(PriestBuffTypes,'A0RW',49,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',48,1)
    call SaveReal(PriestBuffTypes,'A0RW',57,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',58,25.0)
    call SaveInteger(PriestBuffTypes,'A0RW',65,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',64,1)
    call SaveReal(PriestBuffTypes,'A0RW',73,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',74,30.0)
    call SaveInteger(PriestBuffTypes,'A0RW',81,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',80,1)
    call SaveReal(PriestBuffTypes,'A0RW',89,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',90,35.0)
    call SaveInteger(PriestBuffTypes,'A0RW',97,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',96,1)
    call SaveReal(PriestBuffTypes,'A0RW',105,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',106,40.0)
    call SaveInteger(PriestBuffTypes,'A0RW',113,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',112,1)
    call SaveReal(PriestBuffTypes,'A0RW',121,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',122,45.0)
    call SaveInteger(PriestBuffTypes,'A0RW',129,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',128,1)
    call SaveReal(PriestBuffTypes,'A0RW',137,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',138,50.0)
    call SaveInteger(PriestBuffTypes,'A0RW',145,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',144,1)
    call SaveReal(PriestBuffTypes,'A0RW',153,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',154,55.0)
    call SaveInteger(PriestBuffTypes,'A0RW',161,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',160,1)
    call SaveReal(PriestBuffTypes,'A0RW',169,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',170,60.0)
    call SaveInteger(PriestBuffTypes,'A0RW',177,'B05A')
    call SaveInteger(PriestBuffTypes,'A0RW',176,1)
    call SaveReal(PriestBuffTypes,'A0RW',185,0.0)
    call SaveReal(PriestBuffTypes,'A0RW',186,75.0)
    call SaveInteger(PriestBuffTypes,'A0RY',1,'pB21')
    call SaveInteger(PriestBuffClone,'A0RY','B051','pB21')
    call SaveStr(PriestBuffTypes,'A0RY',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A0RY',3,false)
    call SaveInteger(PriestBuffTypes,'A0RY',17,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',16,1)
    call SaveReal(PriestBuffTypes,'A0RY',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',26,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',33,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',32,1)
    call SaveReal(PriestBuffTypes,'A0RY',41,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',42,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',49,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',48,1)
    call SaveReal(PriestBuffTypes,'A0RY',57,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',58,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',65,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',64,1)
    call SaveReal(PriestBuffTypes,'A0RY',73,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',74,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',81,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',80,1)
    call SaveReal(PriestBuffTypes,'A0RY',89,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',90,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',97,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',96,1)
    call SaveReal(PriestBuffTypes,'A0RY',105,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',106,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',113,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',112,1)
    call SaveReal(PriestBuffTypes,'A0RY',121,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',122,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',129,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',128,1)
    call SaveReal(PriestBuffTypes,'A0RY',137,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',138,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',145,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',144,1)
    call SaveReal(PriestBuffTypes,'A0RY',153,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',154,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',161,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',160,1)
    call SaveReal(PriestBuffTypes,'A0RY',169,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',170,45.0)
    call SaveInteger(PriestBuffTypes,'A0RY',177,'B051')
    call SaveInteger(PriestBuffTypes,'A0RY',176,1)
    call SaveReal(PriestBuffTypes,'A0RY',185,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RY',186,45.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',1,'pB22')
    call SaveInteger(PriestBuffClone,'A0RZ','B08S','pB22')
    call SaveStr(PriestBuffTypes,'A0RZ',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A0RZ',3,false)
    call SaveInteger(PriestBuffTypes,'A0RZ',17,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',16,1)
    call SaveReal(PriestBuffTypes,'A0RZ',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',26,6.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',33,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',32,1)
    call SaveReal(PriestBuffTypes,'A0RZ',41,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',42,8.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',49,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',48,1)
    call SaveReal(PriestBuffTypes,'A0RZ',57,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',58,10.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',65,'B08S')
endfunction


function Priest_MasterData6 takes nothing returns nothing
    call SaveInteger(PriestBuffTypes,'A0RZ',64,1)
    call SaveReal(PriestBuffTypes,'A0RZ',73,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',74,10.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',81,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',80,1)
    call SaveReal(PriestBuffTypes,'A0RZ',89,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',90,14.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',97,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',96,1)
    call SaveReal(PriestBuffTypes,'A0RZ',105,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',106,16.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',113,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',112,1)
    call SaveReal(PriestBuffTypes,'A0RZ',121,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',122,18.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',129,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',128,1)
    call SaveReal(PriestBuffTypes,'A0RZ',137,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',138,20.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',145,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',144,1)
    call SaveReal(PriestBuffTypes,'A0RZ',153,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',154,22.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',161,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',160,1)
    call SaveReal(PriestBuffTypes,'A0RZ',169,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',170,24.0)
    call SaveInteger(PriestBuffTypes,'A0RZ',177,'B08S')
    call SaveInteger(PriestBuffTypes,'A0RZ',176,1)
    call SaveReal(PriestBuffTypes,'A0RZ',185,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0RZ',186,30.0)
    call SaveInteger(PriestBuffTypes,'A0TH',1,'pB23')
    call SaveInteger(PriestBuffClone,'A0TH','B05A','pB23')
    call SaveStr(PriestBuffTypes,'A0TH',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0TH',3,false)
    call SaveInteger(PriestBuffTypes,'A0TH',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A0TH',16,1)
    call SaveReal(PriestBuffTypes,'A0TH',25,0.0)
    call SaveReal(PriestBuffTypes,'A0TH',26,30.0)
    call SaveInteger(PriestBuffTypes,'A0TI',1,'pB24')
    call SaveInteger(PriestBuffClone,'A0TI','B08T','pB24')
    call SaveStr(PriestBuffTypes,'A0TI',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A0TI',3,false)
    call SaveInteger(PriestBuffTypes,'A0TI',17,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',16,1)
    call SaveReal(PriestBuffTypes,'A0TI',25,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',26,6.0)
    call SaveInteger(PriestBuffTypes,'A0TI',33,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',32,1)
    call SaveReal(PriestBuffTypes,'A0TI',41,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',42,8.0)
    call SaveInteger(PriestBuffTypes,'A0TI',49,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',48,1)
    call SaveReal(PriestBuffTypes,'A0TI',57,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',58,10.0)
    call SaveInteger(PriestBuffTypes,'A0TI',65,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',64,1)
    call SaveReal(PriestBuffTypes,'A0TI',73,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',74,12.0)
    call SaveInteger(PriestBuffTypes,'A0TI',81,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',80,1)
    call SaveReal(PriestBuffTypes,'A0TI',89,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',90,14.0)
    call SaveInteger(PriestBuffTypes,'A0TI',97,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',96,1)
    call SaveReal(PriestBuffTypes,'A0TI',105,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',106,16.0)
    call SaveInteger(PriestBuffTypes,'A0TI',113,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',112,1)
    call SaveReal(PriestBuffTypes,'A0TI',121,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',122,18.0)
    call SaveInteger(PriestBuffTypes,'A0TI',129,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',128,1)
    call SaveReal(PriestBuffTypes,'A0TI',137,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',138,20.0)
    call SaveInteger(PriestBuffTypes,'A0TI',145,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',144,1)
    call SaveReal(PriestBuffTypes,'A0TI',153,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',154,22.0)
    call SaveInteger(PriestBuffTypes,'A0TI',161,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',160,1)
    call SaveReal(PriestBuffTypes,'A0TI',169,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',170,24.0)
    call SaveInteger(PriestBuffTypes,'A0TI',177,'B08T')
    call SaveInteger(PriestBuffTypes,'A0TI',176,1)
    call SaveReal(PriestBuffTypes,'A0TI',185,0.0)
    call SaveReal(PriestBuffTypes,'A0TI',186,30.0)
    call SaveInteger(PriestBuffTypes,'A0TL',1,'pB25')
    call SaveInteger(PriestBuffClone,'A0TL','B01W','pB25')
    call SaveStr(PriestBuffTypes,'A0TL',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0TL',3,false)
    call SaveInteger(PriestBuffTypes,'A0TL',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A0TL',16,1)
    call SaveReal(PriestBuffTypes,'A0TL',25,0.0)
    call SaveReal(PriestBuffTypes,'A0TL',26,60.0)
    call SaveInteger(PriestBuffTypes,'A0TQ',1,'pB26')
    call SaveInteger(PriestBuffClone,'A0TQ','B007','pB26')
    call SaveStr(PriestBuffTypes,'A0TQ',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A0TQ',3,false)
    call SaveInteger(PriestBuffTypes,'A0TQ',17,'B007')
    call SaveInteger(PriestBuffTypes,'A0TQ',16,1)
    call SaveReal(PriestBuffTypes,'A0TQ',25,0.0)
    call SaveReal(PriestBuffTypes,'A0TQ',26,300.0)
    call SaveInteger(PriestBuffTypes,'A0U0',1,'pB27')
    call SaveInteger(PriestBuffClone,'A0U0','B005','pB27')
    call SaveStr(PriestBuffTypes,'A0U0',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A0U0',3,false)
    call SaveInteger(PriestBuffTypes,'A0U0',17,'B005')
    call SaveInteger(PriestBuffTypes,'A0U0',16,1)
    call SaveReal(PriestBuffTypes,'A0U0',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A0U0',26,45.0)
    call SaveInteger(PriestBuffTypes,'A0UB',1,'pB28')
    call SaveInteger(PriestBuffClone,'A0UB','B007','pB28')
    call SaveStr(PriestBuffTypes,'A0UB',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A0UB',3,false)
    call SaveInteger(PriestBuffTypes,'A0UB',17,'B007')
    call SaveInteger(PriestBuffTypes,'A0UB',16,1)
    call SaveReal(PriestBuffTypes,'A0UB',25,0.0)
    call SaveReal(PriestBuffTypes,'A0UB',26,55.0)
    call SaveInteger(PriestBuffTypes,'A0UC',1,'pB29')
    call SaveInteger(PriestBuffClone,'A0UC','B05A','pB29')
    call SaveStr(PriestBuffTypes,'A0UC',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0UC',3,false)
    call SaveInteger(PriestBuffTypes,'A0UC',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A0UC',16,1)
    call SaveReal(PriestBuffTypes,'A0UC',25,0.0)
    call SaveReal(PriestBuffTypes,'A0UC',26,30.0)
    call SaveInteger(PriestBuffTypes,'A0UD',1,'pB2A')
    call SaveInteger(PriestBuffClone,'A0UD','B007','pB2A')
    call SaveStr(PriestBuffTypes,'A0UD',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A0UD',3,false)
    call SaveInteger(PriestBuffTypes,'A0UD',17,'B007')
    call SaveInteger(PriestBuffTypes,'A0UD',16,1)
    call SaveReal(PriestBuffTypes,'A0UD',25,0.0)
    call SaveReal(PriestBuffTypes,'A0UD',26,55.0)
    call SaveInteger(PriestBuffTypes,'A0UH',1,'pB2B')
    call SaveInteger(PriestBuffClone,'A0UH','B01W','pB2B')
    call SaveStr(PriestBuffTypes,'A0UH',2,"innerfire")
    call SaveBoolean(PriestBuffTypes,'A0UH',3,false)
    call SaveInteger(PriestBuffTypes,'A0UH',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A0UH',16,1)
    call SaveReal(PriestBuffTypes,'A0UH',25,0.0)
    call SaveReal(PriestBuffTypes,'A0UH',26,30.0)
    call SaveInteger(PriestBuffTypes,'A0Z0',1,'pB2C')
    call SaveInteger(PriestBuffClone,'A0Z0','B06F','pB2C')
    call SaveStr(PriestBuffTypes,'A0Z0',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A0Z0',3,false)
    call SaveInteger(PriestBuffTypes,'A0Z0',17,'B06F')
    call SaveInteger(PriestBuffTypes,'A0Z0',16,1)
    call SaveReal(PriestBuffTypes,'A0Z0',25,0.0)
    call SaveReal(PriestBuffTypes,'A0Z0',26,3.0)
    call SaveInteger(PriestBuffTypes,'A0Z9',1,'pB2D')
    call SaveInteger(PriestBuffClone,'A0Z9','B01W','pB2D')
    call SaveStr(PriestBuffTypes,'A0Z9',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0Z9',3,false)
    call SaveInteger(PriestBuffTypes,'A0Z9',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A0Z9',16,1)
    call SaveReal(PriestBuffTypes,'A0Z9',25,0.0)
    call SaveReal(PriestBuffTypes,'A0Z9',26,15.0)
    call SaveInteger(PriestBuffTypes,'A0ZA',1,'pB2E')
endfunction


function Priest_MasterData7 takes nothing returns nothing
    call SaveInteger(PriestBuffClone,'A0ZA','B05A','pB2E')
    call SaveStr(PriestBuffTypes,'A0ZA',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A0ZA',3,false)
    call SaveInteger(PriestBuffTypes,'A0ZA',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A0ZA',16,1)
    call SaveReal(PriestBuffTypes,'A0ZA',25,0.0)
    call SaveReal(PriestBuffTypes,'A0ZA',26,15.0)
    call SaveInteger(PriestBuffTypes,'A0ZF',1,'pB2F')
    call SaveInteger(PriestBuffClone,'A0ZF','B00F','pB2F')
    call SaveStr(PriestBuffTypes,'A0ZF',2,"cripple")
    call SaveBoolean(PriestBuffTypes,'A0ZF',3,false)
    call SaveInteger(PriestBuffTypes,'A0ZF',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A0ZF',16,1)
    call SaveReal(PriestBuffTypes,'A0ZF',25,0.0)
    call SaveReal(PriestBuffTypes,'A0ZF',26,45.0)
    call SaveInteger(PriestBuffTypes,'A0ZH',1,'pB30')
    call SaveInteger(PriestBuffClone,'A0ZH','B01W','pB30')
    call SaveStr(PriestBuffTypes,'A0ZH',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A0ZH',3,false)
    call SaveInteger(PriestBuffTypes,'A0ZH',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A0ZH',16,1)
    call SaveReal(PriestBuffTypes,'A0ZH',25,0.0)
    call SaveReal(PriestBuffTypes,'A0ZH',26,10.0)
    call SaveInteger(PriestBuffTypes,'A10H',1,'pB31')
    call SaveInteger(PriestBuffClone,'A10H','B05A','pB31')
    call SaveStr(PriestBuffTypes,'A10H',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A10H',3,false)
    call SaveInteger(PriestBuffTypes,'A10H',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A10H',16,1)
    call SaveReal(PriestBuffTypes,'A10H',25,0.0)
    call SaveReal(PriestBuffTypes,'A10H',26,30.0)
    call SaveInteger(PriestBuffTypes,'A10T',1,'pB32')
    call SaveInteger(PriestBuffClone,'A10T','B06N','pB32')
    call SaveStr(PriestBuffTypes,'A10T',2,"roar")
    call SaveBoolean(PriestBuffTypes,'A10T',3,true)
    call SaveInteger(PriestBuffTypes,'A10T',17,'B06N')
    call SaveInteger(PriestBuffTypes,'A10T',16,1)
    call SaveReal(PriestBuffTypes,'A10T',25,100.0)
    call SaveReal(PriestBuffTypes,'A10T',26,10.0)
    call SaveInteger(PriestBuffTypes,'A11I',1,'pB33')
    call SaveInteger(PriestBuffClone,'A11I','B06T','pB33')
    call SaveStr(PriestBuffTypes,'A11I',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A11I',3,false)
    call SaveInteger(PriestBuffTypes,'A11I',17,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',16,1)
    call SaveReal(PriestBuffTypes,'A11I',25,0.0)
    call SaveReal(PriestBuffTypes,'A11I',26,6.0)
    call SaveInteger(PriestBuffTypes,'A11I',33,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',32,1)
    call SaveReal(PriestBuffTypes,'A11I',41,0.0)
    call SaveReal(PriestBuffTypes,'A11I',42,8.0)
    call SaveInteger(PriestBuffTypes,'A11I',49,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',48,1)
    call SaveReal(PriestBuffTypes,'A11I',57,0.0)
    call SaveReal(PriestBuffTypes,'A11I',58,10.0)
    call SaveInteger(PriestBuffTypes,'A11I',65,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',64,1)
    call SaveReal(PriestBuffTypes,'A11I',73,0.0)
    call SaveReal(PriestBuffTypes,'A11I',74,12.0)
    call SaveInteger(PriestBuffTypes,'A11I',81,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',80,1)
    call SaveReal(PriestBuffTypes,'A11I',89,0.0)
    call SaveReal(PriestBuffTypes,'A11I',90,14.0)
    call SaveInteger(PriestBuffTypes,'A11I',97,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',96,1)
    call SaveReal(PriestBuffTypes,'A11I',105,0.0)
    call SaveReal(PriestBuffTypes,'A11I',106,16.0)
    call SaveInteger(PriestBuffTypes,'A11I',113,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',112,1)
    call SaveReal(PriestBuffTypes,'A11I',121,0.0)
    call SaveReal(PriestBuffTypes,'A11I',122,18.0)
    call SaveInteger(PriestBuffTypes,'A11I',129,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',128,1)
    call SaveReal(PriestBuffTypes,'A11I',137,0.0)
    call SaveReal(PriestBuffTypes,'A11I',138,20.0)
    call SaveInteger(PriestBuffTypes,'A11I',145,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',144,1)
    call SaveReal(PriestBuffTypes,'A11I',153,0.0)
    call SaveReal(PriestBuffTypes,'A11I',154,22.0)
    call SaveInteger(PriestBuffTypes,'A11I',161,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',160,1)
    call SaveReal(PriestBuffTypes,'A11I',169,0.0)
    call SaveReal(PriestBuffTypes,'A11I',170,24.0)
    call SaveInteger(PriestBuffTypes,'A11I',177,'B06T')
    call SaveInteger(PriestBuffTypes,'A11I',176,1)
    call SaveReal(PriestBuffTypes,'A11I',185,0.0)
    call SaveReal(PriestBuffTypes,'A11I',186,30.0)
    call SaveInteger(PriestBuffTypes,'A11Y',1,'pB34')
    call SaveInteger(PriestBuffClone,'A11Y','B006','pB34')
    call SaveStr(PriestBuffTypes,'A11Y',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A11Y',3,false)
    call SaveInteger(PriestBuffTypes,'A11Y',17,'B006')
    call SaveInteger(PriestBuffTypes,'A11Y',16,1)
    call SaveReal(PriestBuffTypes,'A11Y',25,0.0)
    call SaveReal(PriestBuffTypes,'A11Y',26,30.0)
    call SaveInteger(PriestBuffTypes,'A13P',1,'pB35')
    call SaveInteger(PriestBuffClone,'A13P','B005','pB35')
    call SaveStr(PriestBuffTypes,'A13P',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A13P',3,false)
    call SaveInteger(PriestBuffTypes,'A13P',17,'B005')
    call SaveInteger(PriestBuffTypes,'A13P',16,1)
    call SaveReal(PriestBuffTypes,'A13P',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A13P',26,45.0)
    call SaveInteger(PriestBuffTypes,'A140',1,'pB36')
    call SaveInteger(PriestBuffClone,'A140','B06N','pB36')
    call SaveStr(PriestBuffTypes,'A140',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A140',3,false)
    call SaveInteger(PriestBuffTypes,'A140',17,'B06N')
    call SaveInteger(PriestBuffTypes,'A140',16,1)
    call SaveReal(PriestBuffTypes,'A140',25,0.0)
    call SaveReal(PriestBuffTypes,'A140',26,10.0)
    call SaveInteger(PriestBuffTypes,'A14M',1,'pB37')
    call SaveInteger(PriestBuffClone,'A14M','B076','pB37')
    call SaveStr(PriestBuffTypes,'A14M',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A14M',3,false)
    call SaveInteger(PriestBuffTypes,'A14M',17,'B076')
    call SaveInteger(PriestBuffTypes,'A14M',16,1)
    call SaveReal(PriestBuffTypes,'A14M',25,0.0)
    call SaveReal(PriestBuffTypes,'A14M',26,8.0)
    call SaveInteger(PriestBuffTypes,'A14M',33,'B076')
    call SaveInteger(PriestBuffTypes,'A14M',32,1)
    call SaveReal(PriestBuffTypes,'A14M',41,0.0)
    call SaveReal(PriestBuffTypes,'A14M',42,10.0)
    call SaveInteger(PriestBuffTypes,'A14M',49,'B076')
    call SaveInteger(PriestBuffTypes,'A14M',48,1)
    call SaveReal(PriestBuffTypes,'A14M',57,0.0)
    call SaveReal(PriestBuffTypes,'A14M',58,12.0)
    call SaveInteger(PriestBuffTypes,'A14M',65,'B076')
    call SaveInteger(PriestBuffTypes,'A14M',64,1)
    call SaveReal(PriestBuffTypes,'A14M',73,0.0)
    call SaveReal(PriestBuffTypes,'A14M',74,14.0)
    call SaveInteger(PriestBuffTypes,'A14M',81,'B076')
    call SaveInteger(PriestBuffTypes,'A14M',80,1)
    call SaveReal(PriestBuffTypes,'A14M',89,0.0)
    call SaveReal(PriestBuffTypes,'A14M',90,16.0)
    call SaveInteger(PriestBuffTypes,'A14M',97,'B076')
    call SaveInteger(PriestBuffTypes,'A14M',96,1)
    call SaveReal(PriestBuffTypes,'A14M',105,0.0)
    call SaveReal(PriestBuffTypes,'A14M',106,18.0)
    call SaveInteger(PriestBuffTypes,'A14O',1,'pB38')
    call SaveInteger(PriestBuffClone,'A14O','B06L','pB38')
    call SaveStr(PriestBuffTypes,'A14O',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A14O',3,false)
    call SaveInteger(PriestBuffTypes,'A14O',17,'B06L')
    call SaveInteger(PriestBuffTypes,'A14O',16,1)
    call SaveReal(PriestBuffTypes,'A14O',25,0.0)
    call SaveReal(PriestBuffTypes,'A14O',26,8.0)
    call SaveInteger(PriestBuffTypes,'A158',1,'pB39')
    call SaveInteger(PriestBuffClone,'A158','B01W','pB39')
    call SaveStr(PriestBuffTypes,'A158',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A158',3,false)
    call SaveInteger(PriestBuffTypes,'A158',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A158',16,1)
    call SaveReal(PriestBuffTypes,'A158',25,0.0)
    call SaveReal(PriestBuffTypes,'A158',26,4.0)
    call SaveInteger(PriestBuffTypes,'A162',1,'pB3A')
    call SaveInteger(PriestBuffClone,'A162','B00F','pB3A')
    call SaveStr(PriestBuffTypes,'A162',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A162',3,false)
    call SaveInteger(PriestBuffTypes,'A162',17,'B00F')
endfunction


function Priest_MasterData8 takes nothing returns nothing
    call SaveInteger(PriestBuffTypes,'A162',16,1)
    call SaveReal(PriestBuffTypes,'A162',25,0.0)
    call SaveReal(PriestBuffTypes,'A162',26,15.0)
    call SaveInteger(PriestBuffTypes,'A162',33,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',32,1)
    call SaveReal(PriestBuffTypes,'A162',41,0.0)
    call SaveReal(PriestBuffTypes,'A162',42,20.0)
    call SaveInteger(PriestBuffTypes,'A162',49,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',48,1)
    call SaveReal(PriestBuffTypes,'A162',57,0.0)
    call SaveReal(PriestBuffTypes,'A162',58,25.0)
    call SaveInteger(PriestBuffTypes,'A162',65,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',64,1)
    call SaveReal(PriestBuffTypes,'A162',73,0.0)
    call SaveReal(PriestBuffTypes,'A162',74,30.0)
    call SaveInteger(PriestBuffTypes,'A162',81,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',80,1)
    call SaveReal(PriestBuffTypes,'A162',89,0.0)
    call SaveReal(PriestBuffTypes,'A162',90,35.0)
    call SaveInteger(PriestBuffTypes,'A162',97,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',96,1)
    call SaveReal(PriestBuffTypes,'A162',105,0.0)
    call SaveReal(PriestBuffTypes,'A162',106,40.0)
    call SaveInteger(PriestBuffTypes,'A162',113,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',112,1)
    call SaveReal(PriestBuffTypes,'A162',121,0.0)
    call SaveReal(PriestBuffTypes,'A162',122,45.0)
    call SaveInteger(PriestBuffTypes,'A162',129,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',128,1)
    call SaveReal(PriestBuffTypes,'A162',137,0.0)
    call SaveReal(PriestBuffTypes,'A162',138,50.0)
    call SaveInteger(PriestBuffTypes,'A162',145,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',144,1)
    call SaveReal(PriestBuffTypes,'A162',153,0.0)
    call SaveReal(PriestBuffTypes,'A162',154,55.0)
    call SaveInteger(PriestBuffTypes,'A162',161,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',160,1)
    call SaveReal(PriestBuffTypes,'A162',169,0.0)
    call SaveReal(PriestBuffTypes,'A162',170,60.0)
    call SaveInteger(PriestBuffTypes,'A162',177,'B00F')
    call SaveInteger(PriestBuffTypes,'A162',176,1)
    call SaveReal(PriestBuffTypes,'A162',185,0.0)
    call SaveReal(PriestBuffTypes,'A162',186,75.0)
    call SaveInteger(PriestBuffTypes,'A163',1,'pB3B')
    call SaveInteger(PriestBuffClone,'A163','B007','pB3B')
    call SaveStr(PriestBuffTypes,'A163',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A163',3,false)
    call SaveInteger(PriestBuffTypes,'A163',17,'B007')
    call SaveInteger(PriestBuffTypes,'A163',16,1)
    call SaveReal(PriestBuffTypes,'A163',25,0.0)
    call SaveReal(PriestBuffTypes,'A163',26,15.0)
    call SaveInteger(PriestBuffTypes,'A163',33,'B007')
    call SaveInteger(PriestBuffTypes,'A163',32,1)
    call SaveReal(PriestBuffTypes,'A163',41,0.0)
    call SaveReal(PriestBuffTypes,'A163',42,20.0)
    call SaveInteger(PriestBuffTypes,'A163',49,'B007')
    call SaveInteger(PriestBuffTypes,'A163',48,1)
    call SaveReal(PriestBuffTypes,'A163',57,0.0)
    call SaveReal(PriestBuffTypes,'A163',58,25.0)
    call SaveInteger(PriestBuffTypes,'A163',65,'B007')
    call SaveInteger(PriestBuffTypes,'A163',64,1)
    call SaveReal(PriestBuffTypes,'A163',73,0.0)
    call SaveReal(PriestBuffTypes,'A163',74,30.0)
    call SaveInteger(PriestBuffTypes,'A163',81,'B007')
    call SaveInteger(PriestBuffTypes,'A163',80,1)
    call SaveReal(PriestBuffTypes,'A163',89,0.0)
    call SaveReal(PriestBuffTypes,'A163',90,35.0)
    call SaveInteger(PriestBuffTypes,'A163',97,'B007')
    call SaveInteger(PriestBuffTypes,'A163',96,1)
    call SaveReal(PriestBuffTypes,'A163',105,0.0)
    call SaveReal(PriestBuffTypes,'A163',106,40.0)
    call SaveInteger(PriestBuffTypes,'A163',113,'B007')
    call SaveInteger(PriestBuffTypes,'A163',112,1)
    call SaveReal(PriestBuffTypes,'A163',121,0.0)
    call SaveReal(PriestBuffTypes,'A163',122,40.0)
    call SaveInteger(PriestBuffTypes,'A163',129,'B007')
    call SaveInteger(PriestBuffTypes,'A163',128,1)
    call SaveReal(PriestBuffTypes,'A163',137,0.0)
    call SaveReal(PriestBuffTypes,'A163',138,50.0)
    call SaveInteger(PriestBuffTypes,'A163',145,'B007')
    call SaveInteger(PriestBuffTypes,'A163',144,1)
    call SaveReal(PriestBuffTypes,'A163',153,0.0)
    call SaveReal(PriestBuffTypes,'A163',154,55.0)
    call SaveInteger(PriestBuffTypes,'A163',161,'B007')
    call SaveInteger(PriestBuffTypes,'A163',160,1)
    call SaveReal(PriestBuffTypes,'A163',169,0.0)
    call SaveReal(PriestBuffTypes,'A163',170,60.0)
    call SaveInteger(PriestBuffTypes,'A163',177,'B007')
    call SaveInteger(PriestBuffTypes,'A163',176,1)
    call SaveReal(PriestBuffTypes,'A163',185,0.0)
    call SaveReal(PriestBuffTypes,'A163',186,75.0)
    call SaveInteger(PriestBuffTypes,'A179',1,'pB3C')
    call SaveInteger(PriestBuffClone,'A179','B005','pB3C')
    call SaveStr(PriestBuffTypes,'A179',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A179',3,false)
    call SaveInteger(PriestBuffTypes,'A179',17,'B005')
    call SaveInteger(PriestBuffTypes,'A179',16,1)
    call SaveReal(PriestBuffTypes,'A179',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',26,15.0)
    call SaveInteger(PriestBuffTypes,'A179',33,'B005')
    call SaveInteger(PriestBuffTypes,'A179',32,1)
    call SaveReal(PriestBuffTypes,'A179',41,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',42,20.0)
    call SaveInteger(PriestBuffTypes,'A179',49,'B005')
    call SaveInteger(PriestBuffTypes,'A179',48,1)
    call SaveReal(PriestBuffTypes,'A179',57,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',58,25.0)
    call SaveInteger(PriestBuffTypes,'A179',65,'B005')
    call SaveInteger(PriestBuffTypes,'A179',64,1)
    call SaveReal(PriestBuffTypes,'A179',73,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',74,30.0)
    call SaveInteger(PriestBuffTypes,'A179',81,'B005')
    call SaveInteger(PriestBuffTypes,'A179',80,1)
    call SaveReal(PriestBuffTypes,'A179',89,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',90,35.0)
    call SaveInteger(PriestBuffTypes,'A179',97,'B005')
    call SaveInteger(PriestBuffTypes,'A179',96,1)
    call SaveReal(PriestBuffTypes,'A179',105,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',106,40.0)
    call SaveInteger(PriestBuffTypes,'A179',113,'B005')
    call SaveInteger(PriestBuffTypes,'A179',112,1)
    call SaveReal(PriestBuffTypes,'A179',121,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',122,45.0)
    call SaveInteger(PriestBuffTypes,'A179',129,'B005')
    call SaveInteger(PriestBuffTypes,'A179',128,1)
    call SaveReal(PriestBuffTypes,'A179',137,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',138,50.0)
    call SaveInteger(PriestBuffTypes,'A179',145,'B005')
    call SaveInteger(PriestBuffTypes,'A179',144,1)
    call SaveReal(PriestBuffTypes,'A179',153,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',154,55.0)
    call SaveInteger(PriestBuffTypes,'A179',161,'B005')
    call SaveInteger(PriestBuffTypes,'A179',160,1)
    call SaveReal(PriestBuffTypes,'A179',169,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',170,60.0)
    call SaveInteger(PriestBuffTypes,'A179',177,'B005')
    call SaveInteger(PriestBuffTypes,'A179',176,1)
    call SaveReal(PriestBuffTypes,'A179',185,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A179',186,75.0)
    call SaveInteger(PriestBuffTypes,'A17F',1,'pB3D')
    call SaveInteger(PriestBuffClone,'A17F','B07J','pB3D')
    call SaveStr(PriestBuffTypes,'A17F',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A17F',3,false)
    call SaveInteger(PriestBuffTypes,'A17F',17,'B07J')
    call SaveInteger(PriestBuffTypes,'A17F',16,1)
    call SaveReal(PriestBuffTypes,'A17F',25,0.0)
    call SaveReal(PriestBuffTypes,'A17F',26,60.0)
    call SaveInteger(PriestBuffTypes,'A17G',1,'pB3E')
    call SaveInteger(PriestBuffClone,'A17G','B07J','pB3E')
    call SaveStr(PriestBuffTypes,'A17G',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A17G',3,false)
    call SaveInteger(PriestBuffTypes,'A17G',17,'B07J')
    call SaveInteger(PriestBuffTypes,'A17G',16,1)
    call SaveReal(PriestBuffTypes,'A17G',25,0.0)
    call SaveReal(PriestBuffTypes,'A17G',26,90.0)
    call SaveInteger(PriestBuffTypes,'A17H',1,'pB3F')
    call SaveInteger(PriestBuffClone,'A17H','B07I','pB3F')
    call SaveStr(PriestBuffTypes,'A17H',2,"innerfire")
    call SaveBoolean(PriestBuffTypes,'A17H',3,false)
    call SaveInteger(PriestBuffTypes,'A17H',17,'B07I')
endfunction


function Priest_MasterData9 takes nothing returns nothing
    call SaveInteger(PriestBuffTypes,'A17H',16,1)
    call SaveReal(PriestBuffTypes,'A17H',25,0.0)
    call SaveReal(PriestBuffTypes,'A17H',26,15.0)
    call SaveInteger(PriestBuffTypes,'A17I',1,'pB40')
    call SaveInteger(PriestBuffClone,'A17I','B07I','pB40')
    call SaveStr(PriestBuffTypes,'A17I',2,"innerfire")
    call SaveBoolean(PriestBuffTypes,'A17I',3,false)
    call SaveInteger(PriestBuffTypes,'A17I',17,'B07I')
    call SaveInteger(PriestBuffTypes,'A17I',16,1)
    call SaveReal(PriestBuffTypes,'A17I',25,0.0)
    call SaveReal(PriestBuffTypes,'A17I',26,90.0)
    call SaveInteger(PriestBuffTypes,'A17J',1,'pB41')
    call SaveInteger(PriestBuffClone,'A17J','B07G','pB41')
    call SaveStr(PriestBuffTypes,'A17J',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A17J',3,false)
    call SaveInteger(PriestBuffTypes,'A17J',17,'B07G')
    call SaveInteger(PriestBuffTypes,'A17J',16,1)
    call SaveReal(PriestBuffTypes,'A17J',25,0.0)
    call SaveReal(PriestBuffTypes,'A17J',26,60.0)
    call SaveInteger(PriestBuffTypes,'A17K',1,'pB42')
    call SaveInteger(PriestBuffClone,'A17K','B07G','pB42')
    call SaveStr(PriestBuffTypes,'A17K',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A17K',3,false)
    call SaveInteger(PriestBuffTypes,'A17K',17,'B07G')
    call SaveInteger(PriestBuffTypes,'A17K',16,1)
    call SaveReal(PriestBuffTypes,'A17K',25,0.0)
    call SaveReal(PriestBuffTypes,'A17K',26,90.0)
    call SaveInteger(PriestBuffTypes,'A17L',1,'pB43')
    call SaveInteger(PriestBuffClone,'A17L','B07F','pB43')
    call SaveStr(PriestBuffTypes,'A17L',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A17L',3,false)
    call SaveInteger(PriestBuffTypes,'A17L',17,'B07F')
    call SaveInteger(PriestBuffTypes,'A17L',16,1)
    call SaveReal(PriestBuffTypes,'A17L',25,0.0)
    call SaveReal(PriestBuffTypes,'A17L',26,15.0)
    call SaveInteger(PriestBuffTypes,'A17M',1,'pB44')
    call SaveInteger(PriestBuffClone,'A17M','B07F','pB44')
    call SaveStr(PriestBuffTypes,'A17M',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A17M',3,false)
    call SaveInteger(PriestBuffTypes,'A17M',17,'B07F')
    call SaveInteger(PriestBuffTypes,'A17M',16,1)
    call SaveReal(PriestBuffTypes,'A17M',25,0.0)
    call SaveReal(PriestBuffTypes,'A17M',26,90.0)
    call SaveInteger(PriestBuffTypes,'A17N',1,'pB45')
    call SaveInteger(PriestBuffClone,'A17N','B07H','pB45')
    call SaveStr(PriestBuffTypes,'A17N',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A17N',3,false)
    call SaveInteger(PriestBuffTypes,'A17N',17,'B07H')
    call SaveInteger(PriestBuffTypes,'A17N',16,1)
    call SaveReal(PriestBuffTypes,'A17N',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A17N',26,60.0)
    call SaveInteger(PriestBuffTypes,'A17O',1,'pB46')
    call SaveInteger(PriestBuffClone,'A17O','B07H','pB46')
    call SaveStr(PriestBuffTypes,'A17O',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A17O',3,false)
    call SaveInteger(PriestBuffTypes,'A17O',17,'B07H')
    call SaveInteger(PriestBuffTypes,'A17O',16,1)
    call SaveReal(PriestBuffTypes,'A17O',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A17O',26,90.0)
    call SaveInteger(PriestBuffTypes,'A17P',1,'pB47')
    call SaveInteger(PriestBuffClone,'A17P','B07R','pB47')
    call SaveStr(PriestBuffTypes,'A17P',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A17P',3,false)
    call SaveInteger(PriestBuffTypes,'A17P',17,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',16,1)
    call SaveReal(PriestBuffTypes,'A17P',25,0.0)
    call SaveReal(PriestBuffTypes,'A17P',26,15.0)
    call SaveInteger(PriestBuffTypes,'A17P',33,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',32,1)
    call SaveReal(PriestBuffTypes,'A17P',41,0.0)
    call SaveReal(PriestBuffTypes,'A17P',42,14.0)
    call SaveInteger(PriestBuffTypes,'A17P',49,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',48,1)
    call SaveReal(PriestBuffTypes,'A17P',57,0.0)
    call SaveReal(PriestBuffTypes,'A17P',58,16.0)
    call SaveInteger(PriestBuffTypes,'A17P',65,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',64,1)
    call SaveReal(PriestBuffTypes,'A17P',73,0.0)
    call SaveReal(PriestBuffTypes,'A17P',74,18.0)
    call SaveInteger(PriestBuffTypes,'A17P',81,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',80,1)
    call SaveReal(PriestBuffTypes,'A17P',89,0.0)
    call SaveReal(PriestBuffTypes,'A17P',90,20.0)
    call SaveInteger(PriestBuffTypes,'A17P',97,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',96,1)
    call SaveReal(PriestBuffTypes,'A17P',105,0.0)
    call SaveReal(PriestBuffTypes,'A17P',106,22.0)
    call SaveInteger(PriestBuffTypes,'A17P',113,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',112,1)
    call SaveReal(PriestBuffTypes,'A17P',121,0.0)
    call SaveReal(PriestBuffTypes,'A17P',122,24.0)
    call SaveInteger(PriestBuffTypes,'A17P',129,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',128,1)
    call SaveReal(PriestBuffTypes,'A17P',137,0.0)
    call SaveReal(PriestBuffTypes,'A17P',138,26.0)
    call SaveInteger(PriestBuffTypes,'A17P',145,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',144,1)
    call SaveReal(PriestBuffTypes,'A17P',153,0.0)
    call SaveReal(PriestBuffTypes,'A17P',154,28.0)
    call SaveInteger(PriestBuffTypes,'A17P',161,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',160,1)
    call SaveReal(PriestBuffTypes,'A17P',169,0.0)
    call SaveReal(PriestBuffTypes,'A17P',170,30.0)
    call SaveInteger(PriestBuffTypes,'A17P',177,'B07R')
    call SaveInteger(PriestBuffTypes,'A17P',176,1)
    call SaveReal(PriestBuffTypes,'A17P',185,0.0)
    call SaveReal(PriestBuffTypes,'A17P',186,32.0)
    call SaveInteger(PriestBuffTypes,'A17R',1,'pB48')
    call SaveInteger(PriestBuffClone,'A17R','B07S','pB48')
    call SaveStr(PriestBuffTypes,'A17R',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A17R',3,false)
    call SaveInteger(PriestBuffTypes,'A17R',17,'B07S')
    call SaveInteger(PriestBuffTypes,'A17R',16,1)
    call SaveReal(PriestBuffTypes,'A17R',25,0.0)
    call SaveReal(PriestBuffTypes,'A17R',26,8.0)
    call SaveInteger(PriestBuffTypes,'A18I',1,'pB49')
    call SaveInteger(PriestBuffClone,'A18I','B07R','pB49')
    call SaveStr(PriestBuffTypes,'A18I',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A18I',3,false)
    call SaveInteger(PriestBuffTypes,'A18I',17,'B07R')
    call SaveInteger(PriestBuffTypes,'A18I',16,1)
    call SaveReal(PriestBuffTypes,'A18I',25,0.0)
    call SaveReal(PriestBuffTypes,'A18I',26,22.0)
    call SaveInteger(PriestBuffTypes,'A18V',1,'pB4A')
    call SaveInteger(PriestBuffClone,'A18V','B005','pB4A')
    call SaveStr(PriestBuffTypes,'A18V',2,"drunkenhaze")
    call SaveBoolean(PriestBuffTypes,'A18V',3,false)
    call SaveInteger(PriestBuffTypes,'A18V',17,'B005')
    call SaveInteger(PriestBuffTypes,'A18V',16,1)
    call SaveReal(PriestBuffTypes,'A18V',25,0.009999999776482582)
    call SaveReal(PriestBuffTypes,'A18V',26,30.0)
    call SaveInteger(PriestBuffTypes,'A18W',1,'pB4B')
    call SaveInteger(PriestBuffClone,'A18W','B007','pB4B')
    call SaveStr(PriestBuffTypes,'A18W',2,"frostarmor")
    call SaveBoolean(PriestBuffTypes,'A18W',3,false)
    call SaveInteger(PriestBuffTypes,'A18W',17,'B007')
    call SaveInteger(PriestBuffTypes,'A18W',16,1)
    call SaveReal(PriestBuffTypes,'A18W',25,0.0)
    call SaveReal(PriestBuffTypes,'A18W',26,30.0)
    call SaveInteger(PriestBuffTypes,'A18Y',1,'pB4C')
    call SaveInteger(PriestBuffClone,'A18Y','B00F','pB4C')
    call SaveStr(PriestBuffTypes,'A18Y',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A18Y',3,false)
    call SaveInteger(PriestBuffTypes,'A18Y',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A18Y',16,1)
    call SaveReal(PriestBuffTypes,'A18Y',25,0.0)
    call SaveReal(PriestBuffTypes,'A18Y',26,30.0)
    call SaveInteger(PriestBuffTypes,'A190',1,'pB4D')
    call SaveInteger(PriestBuffClone,'A190','B006','pB4D')
    call SaveStr(PriestBuffTypes,'A190',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A190',3,false)
    call SaveInteger(PriestBuffTypes,'A190',17,'B006')
    call SaveInteger(PriestBuffTypes,'A190',16,1)
    call SaveReal(PriestBuffTypes,'A190',25,0.0)
    call SaveReal(PriestBuffTypes,'A190',26,30.0)
    call SaveInteger(PriestBuffTypes,'A1AA',1,'pB4E')
    call SaveInteger(PriestBuffClone,'A1AA','B082','pB4E')
    call SaveStr(PriestBuffTypes,'A1AA',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A1AA',3,false)
    call SaveInteger(PriestBuffTypes,'A1AA',17,'B082')
endfunction


function Priest_MasterData10 takes nothing returns nothing
    call SaveInteger(PriestBuffTypes,'A1AA',16,1)
    call SaveReal(PriestBuffTypes,'A1AA',25,0.0)
    call SaveReal(PriestBuffTypes,'A1AA',26,10.0)
    call SaveInteger(PriestBuffTypes,'A1AA',33,'B082')
    call SaveInteger(PriestBuffTypes,'A1AA',32,1)
    call SaveReal(PriestBuffTypes,'A1AA',41,0.0)
    call SaveReal(PriestBuffTypes,'A1AA',42,12.0)
    call SaveInteger(PriestBuffTypes,'A1AA',49,'B082')
    call SaveInteger(PriestBuffTypes,'A1AA',48,1)
    call SaveReal(PriestBuffTypes,'A1AA',57,0.0)
    call SaveReal(PriestBuffTypes,'A1AA',58,14.0)
    call SaveInteger(PriestBuffTypes,'A1AA',65,'B082')
    call SaveInteger(PriestBuffTypes,'A1AA',64,1)
    call SaveReal(PriestBuffTypes,'A1AA',73,0.0)
    call SaveReal(PriestBuffTypes,'A1AA',74,16.0)
    call SaveInteger(PriestBuffTypes,'A1AA',81,'B082')
    call SaveInteger(PriestBuffTypes,'A1AA',80,1)
    call SaveReal(PriestBuffTypes,'A1AA',89,0.0)
    call SaveReal(PriestBuffTypes,'A1AA',90,18.0)
    call SaveInteger(PriestBuffTypes,'A1AA',97,'B082')
    call SaveInteger(PriestBuffTypes,'A1AA',96,1)
    call SaveReal(PriestBuffTypes,'A1AA',105,0.0)
    call SaveReal(PriestBuffTypes,'A1AA',106,20.0)
    call SaveInteger(PriestBuffTypes,'A1AO',1,'pB4F')
    call SaveInteger(PriestBuffClone,'A1AO','B01W','pB4F')
    call SaveStr(PriestBuffTypes,'A1AO',2,"innerfire")
    call SaveBoolean(PriestBuffTypes,'A1AO',3,false)
    call SaveInteger(PriestBuffTypes,'A1AO',17,'B01W')
    call SaveInteger(PriestBuffTypes,'A1AO',16,1)
    call SaveReal(PriestBuffTypes,'A1AO',25,0.0)
    call SaveReal(PriestBuffTypes,'A1AO',26,30.0)
    call SaveInteger(PriestBuffTypes,'A1AP',1,'pB50')
    call SaveInteger(PriestBuffClone,'A1AP','B05A','pB50')
    call SaveStr(PriestBuffTypes,'A1AP',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A1AP',3,false)
    call SaveInteger(PriestBuffTypes,'A1AP',17,'B05A')
    call SaveInteger(PriestBuffTypes,'A1AP',16,1)
    call SaveReal(PriestBuffTypes,'A1AP',25,0.0)
    call SaveReal(PriestBuffTypes,'A1AP',26,30.0)
    call SaveInteger(PriestBuffTypes,'A1AQ',1,'pB51')
    call SaveInteger(PriestBuffClone,'A1AQ','B07R','pB51')
    call SaveStr(PriestBuffTypes,'A1AQ',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A1AQ',3,false)
    call SaveInteger(PriestBuffTypes,'A1AQ',17,'B07R')
    call SaveInteger(PriestBuffTypes,'A1AQ',16,1)
    call SaveReal(PriestBuffTypes,'A1AQ',25,0.0)
    call SaveReal(PriestBuffTypes,'A1AQ',26,30.0)
    call SaveInteger(PriestBuffTypes,'A1AR',1,'pB52')
    call SaveInteger(PriestBuffClone,'A1AR','B06W','pB52')
    call SaveStr(PriestBuffTypes,'A1AR',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A1AR',3,false)
    call SaveInteger(PriestBuffTypes,'A1AR',17,'B06W')
    call SaveInteger(PriestBuffTypes,'A1AR',16,1)
    call SaveReal(PriestBuffTypes,'A1AR',25,0.0)
    call SaveReal(PriestBuffTypes,'A1AR',26,30.0)
    call SaveInteger(PriestBuffTypes,'A1AS',1,'pB53')
    call SaveInteger(PriestBuffClone,'A1AS','B06T','pB53')
    call SaveStr(PriestBuffTypes,'A1AS',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A1AS',3,false)
    call SaveInteger(PriestBuffTypes,'A1AS',17,'B06T')
    call SaveInteger(PriestBuffTypes,'A1AS',16,1)
    call SaveReal(PriestBuffTypes,'A1AS',25,0.0)
    call SaveReal(PriestBuffTypes,'A1AS',26,30.0)
    call SaveInteger(PriestBuffTypes,'A1B5',1,'pB54')
    call SaveInteger(PriestBuffClone,'A1B5','B076','pB54')
    call SaveStr(PriestBuffTypes,'A1B5',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A1B5',3,false)
    call SaveInteger(PriestBuffTypes,'A1B5',17,'B076')
    call SaveInteger(PriestBuffTypes,'A1B5',16,1)
    call SaveReal(PriestBuffTypes,'A1B5',25,0.0)
    call SaveReal(PriestBuffTypes,'A1B5',26,6.0)
    call SaveInteger(PriestBuffTypes,'A1B5',33,'B076')
    call SaveInteger(PriestBuffTypes,'A1B5',32,1)
    call SaveReal(PriestBuffTypes,'A1B5',41,0.0)
    call SaveReal(PriestBuffTypes,'A1B5',42,7.0)
    call SaveInteger(PriestBuffTypes,'A1B5',49,'B076')
    call SaveInteger(PriestBuffTypes,'A1B5',48,1)
    call SaveReal(PriestBuffTypes,'A1B5',57,0.0)
    call SaveReal(PriestBuffTypes,'A1B5',58,8.0)
    call SaveInteger(PriestBuffTypes,'A1B5',65,'B076')
    call SaveInteger(PriestBuffTypes,'A1B5',64,1)
    call SaveReal(PriestBuffTypes,'A1B5',73,0.0)
    call SaveReal(PriestBuffTypes,'A1B5',74,9.0)
    call SaveInteger(PriestBuffTypes,'A1B5',81,'B076')
    call SaveInteger(PriestBuffTypes,'A1B5',80,1)
    call SaveReal(PriestBuffTypes,'A1B5',89,0.0)
    call SaveReal(PriestBuffTypes,'A1B5',90,10.0)
    call SaveInteger(PriestBuffTypes,'A1B5',97,'B076')
    call SaveInteger(PriestBuffTypes,'A1B5',96,1)
    call SaveReal(PriestBuffTypes,'A1B5',105,0.0)
    call SaveReal(PriestBuffTypes,'A1B5',106,12.0)
    call SaveInteger(PriestBuffTypes,'A1BH',1,'pB55')
    call SaveInteger(PriestBuffClone,'A1BH','B06N','pB55')
    call SaveStr(PriestBuffTypes,'A1BH',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A1BH',3,false)
    call SaveInteger(PriestBuffTypes,'A1BH',17,'B06N')
    call SaveInteger(PriestBuffTypes,'A1BH',16,1)
    call SaveReal(PriestBuffTypes,'A1BH',25,0.0)
    call SaveReal(PriestBuffTypes,'A1BH',26,4.0)
    call SaveInteger(PriestBuffTypes,'A1BL',1,'pB56')
    call SaveInteger(PriestBuffClone,'A1BL','B076','pB56')
    call SaveStr(PriestBuffTypes,'A1BL',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A1BL',3,false)
    call SaveInteger(PriestBuffTypes,'A1BL',17,'B076')
    call SaveInteger(PriestBuffTypes,'A1BL',16,1)
    call SaveReal(PriestBuffTypes,'A1BL',25,0.0)
    call SaveReal(PriestBuffTypes,'A1BL',26,9.0)
    call SaveInteger(PriestBuffTypes,'A1BL',33,'B076')
    call SaveInteger(PriestBuffTypes,'A1BL',32,1)
    call SaveReal(PriestBuffTypes,'A1BL',41,0.0)
    call SaveReal(PriestBuffTypes,'A1BL',42,10.5)
    call SaveInteger(PriestBuffTypes,'A1BL',49,'B076')
    call SaveInteger(PriestBuffTypes,'A1BL',48,1)
    call SaveReal(PriestBuffTypes,'A1BL',57,0.0)
    call SaveReal(PriestBuffTypes,'A1BL',58,12.0)
    call SaveInteger(PriestBuffTypes,'A1BL',65,'B076')
    call SaveInteger(PriestBuffTypes,'A1BL',64,1)
    call SaveReal(PriestBuffTypes,'A1BL',73,0.0)
    call SaveReal(PriestBuffTypes,'A1BL',74,13.5)
    call SaveInteger(PriestBuffTypes,'A1BL',81,'B076')
    call SaveInteger(PriestBuffTypes,'A1BL',80,1)
    call SaveReal(PriestBuffTypes,'A1BL',89,0.0)
    call SaveReal(PriestBuffTypes,'A1BL',90,15.0)
    call SaveInteger(PriestBuffTypes,'A1BL',97,'B076')
    call SaveInteger(PriestBuffTypes,'A1BL',96,1)
    call SaveReal(PriestBuffTypes,'A1BL',105,0.0)
    call SaveReal(PriestBuffTypes,'A1BL',106,18.0)
    call SaveInteger(PriestBuffTypes,'A1C5',1,'pB57')
    call SaveInteger(PriestBuffClone,'A1C5','Broa','pB57')
    call SaveStr(PriestBuffTypes,'A1C5',2,"battleroar")
    call SaveBoolean(PriestBuffTypes,'A1C5',3,true)
    call SaveInteger(PriestBuffTypes,'A1C5',17,'Broa')
    call SaveInteger(PriestBuffTypes,'A1C5',16,1)
    call SaveReal(PriestBuffTypes,'A1C5',25,500.0)
    call SaveReal(PriestBuffTypes,'A1C5',26,20.0)
    call SaveInteger(PriestBuffTypes,'A1C6',1,'pB58')
    call SaveInteger(PriestBuffClone,'A1C6','Broa','pB58')
    call SaveStr(PriestBuffTypes,'A1C6',2,"battleroar")
    call SaveBoolean(PriestBuffTypes,'A1C6',3,true)
    call SaveInteger(PriestBuffTypes,'A1C6',17,'Broa')
    call SaveInteger(PriestBuffTypes,'A1C6',16,1)
    call SaveReal(PriestBuffTypes,'A1C6',25,500.0)
    call SaveReal(PriestBuffTypes,'A1C6',26,15.0)
    call SaveInteger(PriestBuffTypes,'A1ES',1,'pB59')
    call SaveInteger(PriestBuffClone,'A1ES','B06F','pB59')
    call SaveStr(PriestBuffTypes,'A1ES',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A1ES',3,false)
    call SaveInteger(PriestBuffTypes,'A1ES',17,'B06F')
    call SaveInteger(PriestBuffTypes,'A1ES',16,1)
    call SaveReal(PriestBuffTypes,'A1ES',25,0.0)
    call SaveReal(PriestBuffTypes,'A1ES',26,5.0)
    call SaveInteger(PriestBuffTypes,'A1F1',1,'pB5A')
    call SaveInteger(PriestBuffClone,'A1F1','B00K','pB5A')
    call SaveStr(PriestBuffTypes,'A1F1',2,"unholyfrenzy")
    call SaveBoolean(PriestBuffTypes,'A1F1',3,false)
    call SaveInteger(PriestBuffTypes,'A1F1',17,'B00K')
    call SaveInteger(PriestBuffTypes,'A1F1',16,1)
    call SaveReal(PriestBuffTypes,'A1F1',25,0.0)
    call SaveReal(PriestBuffTypes,'A1F1',26,20.0)
    call SaveInteger(PriestBuffTypes,'A1F4',1,'pB5B')
endfunction


function Priest_MasterData11 takes nothing returns nothing
    call SaveInteger(PriestBuffClone,'A1F4','B006','pB5B')
    call SaveStr(PriestBuffTypes,'A1F4',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'A1F4',3,false)
    call SaveInteger(PriestBuffTypes,'A1F4',17,'B006')
    call SaveInteger(PriestBuffTypes,'A1F4',16,1)
    call SaveReal(PriestBuffTypes,'A1F4',25,0.0)
    call SaveReal(PriestBuffTypes,'A1F4',26,25.0)
    call SaveInteger(PriestBuffTypes,'A1F5',1,'pB5C')
    call SaveInteger(PriestBuffClone,'A1F5','B00F','pB5C')
    call SaveStr(PriestBuffTypes,'A1F5',2,"bloodlust")
    call SaveBoolean(PriestBuffTypes,'A1F5',3,false)
    call SaveInteger(PriestBuffTypes,'A1F5',17,'B00F')
    call SaveInteger(PriestBuffTypes,'A1F5',16,1)
    call SaveReal(PriestBuffTypes,'A1F5',25,0.0)
    call SaveReal(PriestBuffTypes,'A1F5',26,15.0)
    call SaveInteger(PriestBuffTypes,'pReg',1,'pReg')
    call SaveInteger(PriestBuffClone,'pReg','B006','pReg')
    call SaveStr(PriestBuffTypes,'pReg',2,"rejuvination")
    call SaveBoolean(PriestBuffTypes,'pReg',3,false)
    call SaveInteger(PriestBuffTypes,'pReg',17,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',16,1)
    call SaveReal(PriestBuffTypes,'pReg',25,0.0)
    call SaveReal(PriestBuffTypes,'pReg',26,6.0)
    call SaveInteger(PriestBuffTypes,'pReg',33,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',32,1)
    call SaveReal(PriestBuffTypes,'pReg',41,0.0)
    call SaveReal(PriestBuffTypes,'pReg',42,8.0)
    call SaveInteger(PriestBuffTypes,'pReg',49,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',48,1)
    call SaveReal(PriestBuffTypes,'pReg',57,0.0)
    call SaveReal(PriestBuffTypes,'pReg',58,10.0)
    call SaveInteger(PriestBuffTypes,'pReg',65,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',64,1)
    call SaveReal(PriestBuffTypes,'pReg',73,0.0)
    call SaveReal(PriestBuffTypes,'pReg',74,12.0)
    call SaveInteger(PriestBuffTypes,'pReg',81,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',80,1)
    call SaveReal(PriestBuffTypes,'pReg',89,0.0)
    call SaveReal(PriestBuffTypes,'pReg',90,14.0)
    call SaveInteger(PriestBuffTypes,'pReg',97,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',96,1)
    call SaveReal(PriestBuffTypes,'pReg',105,0.0)
    call SaveReal(PriestBuffTypes,'pReg',106,16.0)
    call SaveInteger(PriestBuffTypes,'pReg',113,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',112,1)
    call SaveReal(PriestBuffTypes,'pReg',121,0.0)
    call SaveReal(PriestBuffTypes,'pReg',122,18.0)
    call SaveInteger(PriestBuffTypes,'pReg',129,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',128,1)
    call SaveReal(PriestBuffTypes,'pReg',137,0.0)
    call SaveReal(PriestBuffTypes,'pReg',138,20.0)
    call SaveInteger(PriestBuffTypes,'pReg',145,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',144,1)
    call SaveReal(PriestBuffTypes,'pReg',153,0.0)
    call SaveReal(PriestBuffTypes,'pReg',154,22.0)
    call SaveInteger(PriestBuffTypes,'pReg',161,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',160,1)
    call SaveReal(PriestBuffTypes,'pReg',169,0.0)
    call SaveReal(PriestBuffTypes,'pReg',170,24.0)
    call SaveInteger(PriestBuffTypes,'pReg',177,'B006')
    call SaveInteger(PriestBuffTypes,'pReg',176,1)
    call SaveReal(PriestBuffTypes,'pReg',185,0.0)
    call SaveReal(PriestBuffTypes,'pReg',186,30.0)
    set PriestRainHealing[1]=50.0
    set PriestRainRadius[1]=900.0
    set PriestRainPeriod[1]=0.10000000149011612
    set PriestRainDuration[1]=15.0
    set PriestRainHealing[2]=100.0
    set PriestRainRadius[2]=900.0
    set PriestRainPeriod[2]=0.10000000149011612
    set PriestRainDuration[2]=15.0
    set PriestRainHealing[3]=150.0
    set PriestRainRadius[3]=900.0
    set PriestRainPeriod[3]=0.10000000149011612
    set PriestRainDuration[3]=15.0
    set PriestRainHealing[4]=200.0
    set PriestRainRadius[4]=900.0
    set PriestRainPeriod[4]=0.10000000149011612
    set PriestRainDuration[4]=15.0
    set PriestRainHealing[5]=250.0
    set PriestRainRadius[5]=900.0
    set PriestRainPeriod[5]=0.10000000149011612
    set PriestRainDuration[5]=15.0
    set PriestRainHealing[6]=400.0
    set PriestRainRadius[6]=900.0
    set PriestRainPeriod[6]=0.10000000149011612
    set PriestRainDuration[6]=15.0
endfunction


function Priest_MasterData takes nothing returns nothing
    call ExecuteFunc("Priest_MasterData0")
    call ExecuteFunc("Priest_MasterData1")
    call ExecuteFunc("Priest_MasterData2")
    call ExecuteFunc("Priest_MasterData3")
    call ExecuteFunc("Priest_MasterData4")
    call ExecuteFunc("Priest_MasterData5")
    call ExecuteFunc("Priest_MasterData6")
    call ExecuteFunc("Priest_MasterData7")
    call ExecuteFunc("Priest_MasterData8")
    call ExecuteFunc("Priest_MasterData9")
    call ExecuteFunc("Priest_MasterData10")
    call ExecuteFunc("Priest_MasterData11")
endfunction

function Priest_CooldownBase takes unit caster,integer raw,integer level returns real
    if raw=='A0W9' and Talent_Active(caster,12,2,2,'A0W9') then
        return 45.
    endif
    return BlzGetAbilityCooldown(raw,level)
endfunction


function Priest_EsunaChannel takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    if GetSpellAbilityId()=='A0W9' then
        if Talent_Active(caster,12,2,2,'A0W9') then
            call SaveReal(CooldownTalentBase,GetHandleId(caster),'A0W9',45.)
        else
            call RemoveSavedReal(CooldownTalentBase,GetHandleId(caster),'A0W9')
        endif
        call BlzSetUnitAbilityCooldown(caster,'A0W9',udg_AbilityLevelIndex,Priest_CooldownBase(caster,'A0W9',udg_AbilityLevelIndex))
    endif
    set caster=null
endfunction


function Priest_SpecialExpire takes nothing returns nothing
    local timer expiry=GetExpiredTimer()
    local unit target=LoadUnitHandle(PriestBuffExpiry,GetHandleId(expiry),0)
    local integer buffId=LoadInteger(PriestBuffExpiry,GetHandleId(expiry),1)
    if LoadTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId)==expiry then
        call UnitRemoveAbility(target,buffId)
        call RemoveSavedHandle(PriestBuffExpiry,GetHandleId(target),buffId)
    endif
    call FlushChildHashtable(PriestBuffExpiry,GetHandleId(expiry))
    call DestroyTimer(expiry)
    set expiry=null
    set target=null
endfunction


function Priest_RecordUnit takes unit target,integer raw,integer rank returns nothing
    local integer i=0
    local integer buffId
    local timer previous
    loop
        exitwhen i>=LoadInteger(PriestBuffTypes,raw,rank*16)
        set buffId=LoadInteger(PriestBuffTypes,raw,rank*16+i+1)
        if buffId=='B006' and raw!='A00L' and raw!='pReg' then
            call SaveBoolean(udg_HealOverTimeHash,GetHandleId(target),10,false)
            call SaveInteger(udg_HealOverTimeHash,GetHandleId(target),11,LoadInteger(udg_HealOverTimeHash,GetHandleId(target),11)+1)
        endif
        set previous=LoadTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId)
        if previous!=null then
            call PauseTimer(previous)
            call FlushChildHashtable(PriestBuffExpiry,GetHandleId(previous))
            call DestroyTimer(previous)
            call RemoveSavedHandle(PriestBuffExpiry,GetHandleId(target),buffId)
        endif
        call SaveInteger(PriestBuffSource,GetHandleId(target),buffId,raw)
        call SaveInteger(PriestBuffRanks,GetHandleId(target),buffId,rank)
        call SaveReal(PriestBuffUntil,GetHandleId(target),buffId,SupportBuff_Now()+LoadReal(PriestBuffTypes,raw,rank*16+10))
        set i=i+1
    endloop
    set previous=null
endfunction


function Priest_RecordBuff takes nothing returns nothing
    local integer raw=GetSpellAbilityId()
    local integer rank=IMaxBJ(1,GetUnitAbilityLevel(GetTriggerUnit(),raw))
    local unit target=GetSpellTargetUnit()
    local group nearby
    local unit member
    local real radius
    if not HaveSavedInteger(PriestBuffTypes,raw,1) then
        set target=null
        return
    endif
    if target==null then
        set target=GetTriggerUnit()
    endif
    call Priest_RecordUnit(target,raw,rank)
    set radius=LoadReal(PriestBuffTypes,raw,rank*16+9)
    if radius>1. then
        set nearby=CreateGroup()
        call GroupEnumUnitsInRange(nearby,GetUnitX(target),GetUnitY(target),radius,null)
        loop
            set member=FirstOfGroup(nearby)
            exitwhen member==null
            call GroupRemoveUnit(nearby,member)
            if IsUnitAlly(member,GetOwningPlayer(GetTriggerUnit())) and GetWidgetLife(member)>.405 then
                call Priest_RecordUnit(member,raw,rank)
            endif
        endloop
        call DestroyGroup(nearby)
        set nearby=null
    endif
    set target=null
    set member=null
endfunction


function Priest_Reapply takes unit target,integer raw,integer rank returns nothing
    local unit dummy=CreateUnit(GetOwningPlayer(target),'h02S',GetUnitX(target),GetUnitY(target),0.)
    local integer clone=LoadInteger(PriestBuffTypes,raw,1)
    call UnitAddAbility(dummy,clone)
    call SetUnitAbilityLevel(dummy,clone,rank)
    call SetUnitState(dummy,UNIT_STATE_MANA,GetUnitState(dummy,UNIT_STATE_MAX_MANA))
    if LoadBoolean(PriestBuffTypes,raw,3) then
        call IssueImmediateOrder(dummy,LoadStr(PriestBuffTypes,raw,2))
    else
        call IssueTargetOrder(dummy,LoadStr(PriestBuffTypes,raw,2),target)
    endif
    call UnitApplyTimedLife(dummy,'BTLF',1.)
    set dummy=null
endfunction


function Priest_ReapplyBuff takes unit target,integer raw,integer rank,integer buffId returns nothing
    local integer clone=LoadInteger(PriestBuffClone,raw,buffId)
    local unit dummy
    local timer expiry
    local real remaining
    local boolean accepted
    if clone==0 then
        return
    endif
    set dummy=CreateUnit(GetOwningPlayer(target),'h02S',GetUnitX(target),GetUnitY(target),0.)
    call UnitAddAbility(dummy,clone)
    call SetUnitAbilityLevel(dummy,clone,rank)
    call SetUnitState(dummy,UNIT_STATE_MANA,GetUnitState(dummy,UNIT_STATE_MAX_MANA))
    if LoadBoolean(PriestBuffTypes,raw,3) then
        set accepted=IssueImmediateOrder(dummy,LoadStr(PriestBuffTypes,raw,2))
    else
        set accepted=IssueTargetOrder(dummy,LoadStr(PriestBuffTypes,raw,2),target)
    endif
    if accepted and LoadBoolean(PriestBuffTypes,0,buffId) then
        set remaining=RMaxBJ(0.,LoadReal(PriestBuffUntil,GetHandleId(target),buffId)-SupportBuff_Now())+3.
        call SaveReal(PriestBuffUntil,GetHandleId(target),buffId,SupportBuff_Now()+remaining)
        set expiry=LoadTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId)
        if expiry==null then
            set expiry=CreateTimer()
            call SaveTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId,expiry)
            call SaveUnitHandle(PriestBuffExpiry,GetHandleId(expiry),0,target)
            call SaveInteger(PriestBuffExpiry,GetHandleId(expiry),1,buffId)
        endif
        call TimerStart(expiry,remaining,false,function Priest_SpecialExpire)
    endif
    call UnitApplyTimedLife(dummy,'BTLF',1.)
    set dummy=null
    set expiry=null
endfunction


function Priest_Refresh takes unit target returns nothing
    local integer i=0
    local integer buffId
    local integer raw
    local integer rank
    local unit source
    local timer expiry
    if target==null then
        return
    endif
    set PriestRefreshSerial=PriestRefreshSerial+1
    loop
        exitwhen i>=PriestBuffCount
        set buffId=PriestBuffIds[i]
        if GetUnitAbilityLevel(target,buffId)>0 then
            set raw=LoadInteger(PriestBuffSource,GetHandleId(target),buffId)
            set rank=LoadInteger(PriestBuffRanks,GetHandleId(target),buffId)
            if raw!=0 and rank>0 then
                call Priest_ReapplyBuff(target,raw,rank,buffId)
            endif
        endif
        set i=i+1
    endloop
    // These buffs also own script timers. Restart those timers without reapplying
    // the gameplay action, resetting accumulated power, or creating another link.
    if GetUnitAbilityLevel(target,'B051')>0 and LoadBoolean(udg_DivineShieldHash,GetHandleId(target),3) then
        set source=LoadUnitHandle(udg_DivineShieldHash,GetHandleId(target),4)
        set expiry=LoadTimerHandle(udg_DivineShieldHash,GetHandleId(source),2)
        if expiry!=null then
            call TimerStart(expiry,TimerGetRemaining(expiry)+3.,false,function Trig_Prophet_DivineShield_ExpireLink)
        endif
    endif
    if GetUnitAbilityLevel(target,'B07R')>0 and IsUnitInGroup(target,udg_RunicGroup) then
        set expiry=LoadTimerHandle(udg_RunicHash,GetHandleId(target),7)
        if expiry!=null then
            call TimerStart(expiry,TimerGetRemaining(expiry)+3.,false,function Trig_Runic_Shield_Expire)
        endif
    endif
    call SupportBuff_Refresh(target)
    set expiry=null
    set source=null
endfunction


function Priest_SwiftApply takes nothing returns nothing
    local timer pending=GetExpiredTimer()
    local unit target=LoadUnitHandle(PriestDeferred,GetHandleId(pending),0)
    local integer rank=LoadInteger(PriestDeferred,GetHandleId(pending),1)
    if GetWidgetLife(target)>.405 and GetUnitAbilityLevel(target,'B006')>0 and LoadInteger(udg_HealOverTimeHash,GetHandleId(target),11)==LoadInteger(PriestDeferred,GetHandleId(pending),2) then
        call UnitRemoveAbility(target,'B006')
        call Priest_Reapply(target,'pReg',rank)
    endif
    call FlushChildHashtable(PriestDeferred,GetHandleId(pending))
    call DestroyTimer(pending)
    set target=null
    set pending=null
endfunction


function Priest_Swiftmend takes unit caster,unit target,integer raw returns nothing
    local timer pending
    local boolean swift=raw=='A00L' and Talent_Active(caster,12,2,3,'A00L')
    local integer castVersion=LoadInteger(udg_HealOverTimeHash,GetHandleId(target),11)+1
    call SaveInteger(udg_HealOverTimeHash,GetHandleId(target),11,castVersion)
    call SaveBoolean(udg_HealOverTimeHash,GetHandleId(target),10,swift)
    if swift then
        set pending=CreateTimer()
        call SaveUnitHandle(PriestDeferred,GetHandleId(pending),0,target)
        call SaveInteger(PriestDeferred,GetHandleId(pending),1,GetUnitAbilityLevel(caster,raw))
        call SaveInteger(PriestDeferred,GetHandleId(pending),2,castVersion)
        call TimerStart(pending,.01,false,function Priest_SwiftApply)
        set pending=null
    endif
endfunction


function Priest_RainTick takes nothing returns nothing
    local integer pid=0
    local integer rank
    local unit caster
    local unit target
    loop
        exitwhen pid>=8
        set caster=PriestRainCaster[pid]
        if caster!=null then
            if GetWidgetLife(caster)<=.405 or GetUnitCurrentOrder(caster)!=OrderId("tranquility") or PriestRainLeft[pid]<=.0001 then
                set PriestRainCaster[pid]=null
                set PriestRainCount=PriestRainCount-1
            else
                set rank=GetUnitAbilityLevel(caster,'A0OM')
                set PriestRainNext[pid]=PriestRainNext[pid]-.1
                set PriestRainLeft[pid]=PriestRainLeft[pid]-.1
                if PriestRainNext[pid]<=.0001 then
                    set PriestRainNext[pid]=PriestRainNext[pid]+PriestRainPeriod[rank]
                    call GroupEnumUnitsInRange(PriestRainEnemies[pid],GetUnitX(caster),GetUnitY(caster),PriestRainRadius[rank],null)
                    loop
                        set target=FirstOfGroup(PriestRainEnemies[pid])
                        exitwhen target==null
                        call GroupRemoveUnit(PriestRainEnemies[pid],target)
                        set udg_IsPureDamage=false
                        if IsUnitAlly(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_STRUCTURE) then
                            set udg_IsPureDamage=true
                            if Talent_Active(caster,12,2,1,'A0OM') then
                                call UnitDamageTarget(caster,target,PriestRainHealing[rank]*.5,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                            else
                                call UnitDamageTarget(caster,target,PriestRainHealing[rank],false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                            endif
                        elseif Talent_Active(caster,12,2,1,'A0OM') and IsUnitEnemy(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_MAGIC_IMMUNE) then
                            call UnitDamageTarget(caster,target,PriestRainHealing[rank]*.5,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        endif
                        // Damage events normally reset this. Also clear after
                        // invulnerable/ignored targets that may emit no event.
                        set udg_IsPureDamage=false
                    endloop
                endif
            endif
        endif
        set pid=pid+1
    endloop
    if PriestRainCount==0 then
        call PauseTimer(PriestRainTimer)
    endif
    set caster=null
    set target=null
endfunction


function Priest_RainEvent takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local integer rank=GetUnitAbilityLevel(caster,'A0OM')
    if pid>=0 and pid<8 and GetSpellAbilityId()=='A0OM' then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_EFFECT then
            if PriestRainCaster[pid]==null then
                set PriestRainCount=PriestRainCount+1
            endif
            set PriestRainCaster[pid]=caster
            set PriestRainLeft[pid]=PriestRainDuration[rank]
            set PriestRainNext[pid]=PriestRainPeriod[rank]
            call TimerStart(PriestRainTimer,.1,true,function Priest_RainTick)
        elseif PriestRainCaster[pid]==caster then
            set PriestRainCaster[pid]=null
            set PriestRainCount=PriestRainCount-1
            if PriestRainCount==0 then
                call PauseTimer(PriestRainTimer)
            endif
        endif
    endif
    set caster=null
endfunction


function Priest_AbilityTalentTip takes unit hero,integer raw,integer row,integer choice returns nothing
    local integer rank=GetUnitAbilityLevel(hero,raw)
    local string tip
    local real amount
    local integer mana
    if rank>0 then
        set tip=LoadStr(PriestAbilityText,raw,rank)
        set mana=BlzGetAbilityManaCost(raw,rank-1)
        if raw=='A00M' then
            set amount=(I2R(mana)*5.+I2R(GetHeroInt(hero,true))*5.)*Prof_StaffPower(hero)
            set tip=tip+"|n|nCurrent caster: "+R2SW(amount,1,0)+" HP on impact; "+R2SW(amount*.25,1,0)+" HP along its path, before target modifiers."
        elseif raw=='A0OM' then
            set amount=I2R(R2I(PriestRainHealing[rank]/PriestRainPeriod[rank]+.5))
            if Talent_Active(hero,12,2,1,raw) then
                set tip=tip+"|n|nCurrent rank: "+R2SW(amount*.5,1,0)+" base HP/sec and "+R2SW(amount*.5,1,0)+" magic damage/sec."
            else
                set tip=tip+"|n|nCurrent rank: "+R2SW(amount,1,0)+" base HP/sec."
            endif
        elseif raw=='A0PC' then
            set amount=I2R(R2I(I2R(50+GetHeroInt(hero,true)/4)*Prof_StaffPower(hero)))
            set tip=tip+"|n|nCurrent caster contributes "+R2SW(amount,1,0)+" queued HP per second; up to "+R2SW(amount*.25,1,0)+" MP per second before recovery rolls and modifiers."
        elseif raw=='A089' then
            set amount=I2R(R2I((I2R(mana)*3.+I2R(GetHeroInt(hero,true))*3.)*Prof_StaffPower(hero)))
            set tip=tip+"|n|nCurrent caster: "+R2SW(amount,1,0)+" HP and "+R2SW(amount*.25,1,0)+" MP before target modifiers. Caster receives HP only."
        endif
        if row>0 and Talent_Active(hero,12,row,choice,raw) then
            set tip=tip+"|n|n|cffffcc00Talent: "+TalentName[Talent_Index(12,row,choice)]+"|r|n"+TalentText[Talent_Index(12,row,choice)]
        endif
        call BlzSetAbilityExtendedTooltip(raw,tip,rank-1+PriestTooltipOffset)
    endif
endfunction


function Priest_RegenTooltip takes nothing returns nothing
    local player viewer=GetLocalPlayer()
    local unit hero=Player_GetHero(viewer)
    local integer rank=GetUnitAbilityLevel(hero,'A00L')
    local real rate
    local real duration
    local string strength="25%"
    local string talent=""
    if hero!=null then
        call Priest_AbilityTalentTip(hero,'A00G',1,1)
        call Priest_AbilityTalentTip(hero,'A0TZ',1,2)
        call Priest_AbilityTalentTip(hero,'A00M',1,3)
        call Priest_AbilityTalentTip(hero,'A0OM',2,1)
        call Priest_AbilityTalentTip(hero,'A0W9',2,2)
        call Priest_AbilityTalentTip(hero,'A0PC',0,0)
        call Priest_AbilityTalentTip(hero,'A089',0,0)
    endif
    if hero!=null and rank>0 then
        set rate=I2R(25+GetHeroInt(hero,true)/3)*Prof_StaffPower(hero)
        set duration=PriestRegenDuration[rank]
        if Talent_Active(hero,12,2,3,'A00L') then
            set rate=rate*2.
            set duration=duration*.5
            set strength="50%"
            set talent="|n|n|cffffcc00Talent: Swiftmend|r|nSame total healing in half the time."
        endif
        call BlzSetAbilityExtendedTooltip('A00L',"|cffffcc00Life Spell|r|nHeals "+R2SW(rate,1,1)+" + "+strength+" of target Strength HP per second for "+R2SW(duration,1,0)+" seconds at this rank. Each tick rolls 93.75% to 100%; healing modifiers still apply."+talent,rank-1+PriestTooltipOffset)
    endif
    set hero=null
    set viewer=null
endfunction


function Priest_MasterEsuna takes nothing returns nothing
    if GetSpellAbilityId()=='A0W9' and Talent_Active(GetTriggerUnit(),12,2,2,'A0W9') then
        call Priest_Refresh(GetSpellTargetUnit())
    endif
endfunction


function Priest_MasterInit takes nothing returns nothing
    local trigger capture=CreateTrigger()
    local trigger rain=CreateTrigger()
    local trigger channel=CreateTrigger()
    local trigger esuna=CreateTrigger()
    local integer pid=0
    call Priest_MasterData()
    set PriestRainTimer=CreateTimer()
    loop
        exitwhen pid>=8
        set PriestRainEnemies[pid]=CreateGroup()
        set pid=pid+1
    endloop
    call TriggerRegisterAnyUnitEventBJ(capture,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(capture,function Priest_RecordBuff)
    call TriggerRegisterAnyUnitEventBJ(rain,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterAnyUnitEventBJ(rain,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    call TriggerRegisterAnyUnitEventBJ(rain,EVENT_PLAYER_UNIT_SPELL_FINISH)
    call TriggerAddAction(rain,function Priest_RainEvent)
    call TriggerRegisterAnyUnitEventBJ(channel,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddAction(channel,function Priest_EsunaChannel)
    call TriggerRegisterAnyUnitEventBJ(esuna,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(esuna,function Priest_MasterEsuna)
    call TimerStart(CreateTimer(),1.,true,function Priest_RegenTooltip)
    set capture=null
    set rain=null
    set channel=null
    set esuna=null
endfunction

function Trig_Regen_Cast_IsRegen takes nothing returns boolean
    return(GetSpellAbilityId()=='A00L')or(GetSpellAbilityId()=='A0B6')or(GetSpellAbilityId()=='A1F4')or(GetSpellAbilityId()=='A0FW') // 'A00L': ability "Regen"; 'A0B6': ability "Regen"; 'A1F4': ability "Regen"; 'A0FW': ability "Regen"
endfunction

function Trig_Regen_Cast_Conditions takes nothing returns boolean
    return(Trig_Regen_Cast_IsRegen())
endfunction

function Trig_Regen_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Regen_Cast_Actions takes nothing returns nothing
    local integer l_tempInteger
    local real l_tempReal
    set l_tempInteger=25
    if(Trig_Regen_Cast_IsHero())then
        // Add 1 point for each complete group of 3 Intelligence; leftover points do not count.
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 3))
    else
        set l_tempInteger=(l_tempInteger+GetUnitLevel(GetTriggerUnit()))
    endif
    set l_tempReal=Prof_StaffPower(GetTriggerUnit())
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,GetHandleIdBJ(GetSpellTargetUnit()),udg_HealOverTimeHash)
    call GroupAddUnitSimple(GetSpellTargetUnit(),udg_RegenGroup)
    call Priest_Swiftmend(GetTriggerUnit(),GetSpellTargetUnit(),GetSpellAbilityId())
endfunction

function Trig_Regen_Periodic_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_RegenGroup)==false)
endfunction

function Trig_Regen_Periodic_IsEnumHero takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Regen_Periodic_IsHostileOwned takes nothing returns boolean
    return(GetOwningPlayer(GetEnumUnit())==Player($B)) // $B = 11
endfunction

function Trig_Regen_Periodic_HasNegateHeals takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Regen_Periodic_HasRegenBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B006')) // 'B006': buff "Regen"
endfunction

function Trig_Regen_Periodic_LacksClarityBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B01A')==false) // 'B01A': buff tooltip "Mana Spring"
endfunction

function Trig_Regen_Periodic_HasStoredRegen takes nothing returns boolean
    return(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)>.0)
endfunction

function Trig_Regen_Periodic_HasRegenAmount takes nothing returns boolean
    return(udg_TempReal>.0)
endfunction

function Trig_Regen_Periodic_LacksNegateHeals takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())<=0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Regen_Periodic_IsAlreadyQueued takes nothing returns boolean
    return(IsUnitInGroup(GetEnumUnit(),udg_PendingEffectGroup))
endfunction

function Trig_Regen_Periodic_HasClarityBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B01A')) // 'B01A': buff tooltip "Mana Spring"
endfunction

function Trig_Regen_Periodic_IsNotPaused takes nothing returns boolean
    return(IsUnitPausedBJ(GetEnumUnit())==false)
endfunction

function Trig_Regen_Periodic_RegenUnit takes nothing returns nothing
    if(Trig_Regen_Periodic_IsNotPaused())then
        set udg_TempReal=.0
        if(Trig_Regen_Periodic_HasRegenBuff())then
            if(Trig_Regen_Periodic_HasNegateHeals())then
                call AddSpecialEffectTargetUnitBJ("overhead",GetEnumUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call UnitRemoveBuffBJ('B006',GetEnumUnit()) // 'B006': buff "Regen"
            else
                set udg_TempReal=(udg_TempReal+LoadRealBJ(1,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash))
                if(Trig_Regen_Periodic_IsEnumHero())then
                    // Heroes add one quarter of their Strength to this regeneration amount.
                    set udg_TempReal=(udg_TempReal+(I2R(GetHeroStatBJ(bj_HEROSTAT_STR,GetEnumUnit(),true))*.25))
                else
                    // Non-heroes add 2 points per unit level instead.
                    set udg_TempReal=(udg_TempReal+(I2R(GetUnitLevel(GetEnumUnit()))*2.))
                endif
                if LoadBoolean(udg_HealOverTimeHash,GetHandleId(GetEnumUnit()),10) then
                    set udg_TempReal=udg_TempReal*2.
                endif
                if(Trig_Regen_Periodic_IsHostileOwned())then
                    // For this hostile-owned unit, increase the current amount by 80%: 10 becomes 18.
                    set udg_TempReal=(udg_TempReal*1.8)
                endif
            endif
        endif
        if(Trig_Regen_Periodic_LacksNegateHeals())then
            if(Trig_Regen_Periodic_HasStoredRegen())then
                set udg_TempReal=((udg_TempReal+1)+LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash))
                if(Trig_Regen_Periodic_LacksClarityBuff())then
                    set udg_DmgFlagManaDamage=true
                    set udg_IsPureDamage=true
                    set udg_DmgFlagPure=true
                    call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)*(GetRandomReal(15.,16.)/ 64.)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                endif
            endif
            if(Trig_Regen_Periodic_HasRegenAmount())then
                set udg_IsPureDamage=true
                set udg_DmgFlagPure=true
                call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),(udg_TempReal*(GetRandomReal(15.,16.)/ 16.)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            else
                call GroupAddUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
            endif
        else
            call GroupAddUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
        endif
        if(Trig_Regen_Periodic_HasClarityBuff())then
            set udg_IsPureDamage=true
            set udg_DmgFlagPure=true
            set udg_DmgFlagManaDamage=true
            if(Trig_Regen_Periodic_IsAlreadyQueued())then
                call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetEnumUnit())*.1),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                call GroupRemoveUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
            else
                // Result 1: (maximum mana of the unit being visited) times (0.1).
                // Result 2: (LoadRealBJ(2, GetHandleIdBJ(the unit being visited), udg_HealOverTimeHash)) plus (1).
                // Result 3: a random decimal number between 15 and 16.
                // Result 4: (result 3) divided by (64).
                // Result 5: (result 2) times (result 4).
                // Result 6: (result 1) plus (result 5).
                call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),((GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetEnumUnit())*.1)+((LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)+1)*(GetRandomReal(15.,16.)/ 64.))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            endif
        endif
        call SaveRealBJ(-1.,2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)
    endif
endfunction

function Trig_Regen_Periodic_Actions takes nothing returns nothing
    call GroupClear(udg_PendingEffectGroup)
    call ForGroupBJ(udg_RegenGroup,function Trig_Regen_Periodic_RegenUnit)
    call GroupRemoveGroup(udg_PendingEffectGroup,udg_RegenGroup)
    call GroupClear(udg_PendingEffectGroup)
endfunction

// World Editor calls InitTrig_Regen automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Regen_Part1 / RegisterTriggers_Regen_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Regen takes nothing returns nothing
endfunction

function Register_Regen_Cast takes nothing returns nothing
    set gg_trg_Regen_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Regen_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Regen_Cast,Condition(function Trig_Regen_Cast_Conditions))
    call TriggerAddAction(gg_trg_Regen_Cast,function Trig_Regen_Cast_Actions)
endfunction

function Register_Regen_Periodic takes nothing returns nothing
    set gg_trg_Regen_Periodic=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Regen_Periodic,1.)
    call TriggerAddCondition(gg_trg_Regen_Periodic,Condition(function Trig_Regen_Periodic_Conditions))
    call TriggerAddAction(gg_trg_Regen_Periodic,function Trig_Regen_Periodic_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Regen_Part1 takes nothing returns nothing
    call Register_Regen_Cast()
    call Priest_MasterInit()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Regen_Part2 takes nothing returns nothing
    call Register_Regen_Periodic()
endfunction

endlibrary

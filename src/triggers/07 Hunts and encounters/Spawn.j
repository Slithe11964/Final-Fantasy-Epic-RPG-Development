library TSpawn requires TCam, TLoc, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spawn_Pools_Init=null
    trigger gg_trg_Spawn_Gafgarion=null
    trigger gg_trg_Spawn_KalmDefenders=null
endglobals

function Trig_Spawn_Pools_Init_Actions takes nothing returns nothing
    local unitpool l_pool
    local integer i=1
    local timer l_zoneTimer
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nftr',1.5) // 'nftr': unit "Forest Goblin"
    call UnitPoolAddUnitType(l_pool,'nmrl',1.5) // 'nmrl': unit "Forest Triton"
    call UnitPoolAddUnitType(l_pool,'ngnb',1.5) // 'ngnb': unit "Forest Gnoll"
    call UnitPoolAddUnitType(l_pool,'nspg',2) // 'nspg': editor label "Forest Spider"
    call UnitPoolAddUnitType(l_pool,'nwlt',1.5) // 'nwlt': unit "Forest Wolf"
    call UnitPoolAddUnitType(l_pool,'nftt',1.5) // 'nftt': unit "Forest Goblin Trapper"
    call UnitPoolAddUnitType(l_pool,'nfsp',1.5) // 'nfsp': unit "Forest Goblin Shaman"
    call UnitPoolAddUnitType(l_pool,'nftb',1) // 'nftb': unit "Forest Goblin Berserker"
    call UnitPoolAddUnitType(l_pool,'nfsh',1) // 'nfsh': unit "Forest Goblin Great Shaman"
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,1,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nftr',.5) // 'nftr': unit "Forest Goblin"
    call UnitPoolAddUnitType(l_pool,'nmrl',.5) // 'nmrl': unit "Forest Triton"
    call UnitPoolAddUnitType(l_pool,'ngnb',.5) // 'ngnb': unit "Forest Gnoll"
    call UnitPoolAddUnitType(l_pool,'nspg',1) // 'nspg': editor label "Forest Spider"
    call UnitPoolAddUnitType(l_pool,'nwlt',1.5) // 'nwlt': unit "Forest Wolf"
    call UnitPoolAddUnitType(l_pool,'nftt',1) // 'nftt': unit "Forest Goblin Trapper"
    call UnitPoolAddUnitType(l_pool,'nfsp',1) // 'nfsp': unit "Forest Goblin Shaman"
    call UnitPoolAddUnitType(l_pool,'nftb',2) // 'nftb': unit "Forest Goblin Berserker"
    call UnitPoolAddUnitType(l_pool,'nfsh',2) // 'nfsh': unit "Forest Goblin Great Shaman"
    call UnitPoolAddUnitType(l_pool,'nspb',1) // 'nspb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ndtr',.5) // 'ndtr': unit "Dark Goblin"
    call UnitPoolAddUnitType(l_pool,'ndtp',.5) // 'ndtp': unit "Dark Goblin Shaman"
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,1,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'ncea',3) // 'ncea': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncer',3) // 'ncer': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncim',2) // 'ncim': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncen',2) // 'ncen': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncks',1.5) // 'ncks': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncnk',1) // 'ncnk': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nltl',2) // 'nltl': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nthl',1.5) // 'nthl': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nstw',1) // 'nstw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzt',2) // 'nrzt': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzs',2) // 'nrzs': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nqbh',2) // 'nqbh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzb',1.5) // 'nrzb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzm',1) // 'nrzm': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzg',1) // 'nrzg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nowb',2) // 'nowb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nowe',1.5) // 'nowe': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhar',2) // 'nhar': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhrr',2) // 'nhrr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhrw',1.5) // 'nhrw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhrh',1) // 'nhrh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhrq',1) // 'nhrq': object name not found in map data
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,2,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'ncea',.5) // 'ncea': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncer',.5) // 'ncer': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncim',1) // 'ncim': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncen',1) // 'ncen': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncks',1.5) // 'ncks': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ncnk',1.5) // 'ncnk': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n0MN',1.5) // 'n0MN': unit "Centaur Berserker"
    call UnitPoolAddUnitType(l_pool,'nltl',1) // 'nltl': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nthl',1.5) // 'nthl': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nstw',2) // 'nstw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzt',1) // 'nrzt': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzs',1) // 'nrzs': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nqbh',1) // 'nqbh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzb',1.5) // 'nrzb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzm',2) // 'nrzm': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrzg',2) // 'nrzg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nowb',1) // 'nowb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nowe',1.5) // 'nowe': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nowk',2) // 'nowk': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhar',1) // 'nhar': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhrr',1) // 'nhrr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhrw',1.5) // 'nhrw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhrh',2) // 'nhrh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n0L0',1) // 'n0L0': unit "Harpy Trickster"
    call UnitPoolAddUnitType(l_pool,'nhrq',2) // 'nhrq': object name not found in map data
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,2,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nscb',2) // 'nscb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsc2',2) // 'nsc2': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsc3',2) // 'nsc3': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrel',1) // 'nrel': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsel',1) // 'nsel': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgn',1) // 'nsgn': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgh',1) // 'nsgh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgb',1) // 'nsgb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nehy',2) // 'nehy': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nahy',2.5) // 'nahy': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nlpr',1.5) // 'nlpr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nlpd',1.5) // 'nlpd': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nltc',1.5) // 'nltc': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nlds',1.5) // 'nlds': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nlsn',1.5) // 'nlsn': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nlkl',1.5) // 'nlkl': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrv',2) // 'ntrv': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsrv',2) // 'nsrv': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrh',1) // 'ntrh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrs',1) // 'ntrs': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrt',1) // 'ntrt': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrg',2) // 'ntrg': unit "Adamanchelid"
    call UnitPoolAddUnitType(l_pool,'ntrd',.5) // 'ntrd': unit "Adaman Tortoise"
    call UnitPoolAddUnitType(l_pool,'njg1',1.5) // 'njg1': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'njga',1.5) // 'njga': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'njgb',1.5) // 'njgb': object name not found in map data
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,3,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nrel',1) // 'nrel': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsel',1) // 'nsel': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgn',1) // 'nsgn': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgh',1) // 'nsgh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgb',1) // 'nsgb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nehy',1) // 'nehy': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nahy',2) // 'nahy': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmcf',1.5) // 'nmcf': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmbg',1.5) // 'nmbg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmtw',1.5) // 'nmtw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmsn',1.5) // 'nmsn': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmrv',1.5) // 'nmrv': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmsc',1.5) // 'nmsc': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ndrv',2) // 'ndrv': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nlrv',2) // 'nlrv': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrh',1) // 'ntrh': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrs',1) // 'ntrs': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrt',1) // 'ntrt': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ntrg',2.5) // 'ntrg': unit "Adamanchelid"
    call UnitPoolAddUnitType(l_pool,'ntrd',1.5) // 'ntrd': unit "Adaman Tortoise"
    call UnitPoolAddUnitType(l_pool,'ndtr',2) // 'ndtr': unit "Dark Goblin"
    call UnitPoolAddUnitType(l_pool,'ndtp',2) // 'ndtp': unit "Dark Goblin Shaman"
    call UnitPoolAddUnitType(l_pool,'ndtt',2.5) // 'ndtt': unit "Dark Goblin Trapper"
    call UnitPoolAddUnitType(l_pool,'ndth',2.5) // 'ndth': unit "Dark Goblin Great Shaman"
    call UnitPoolAddUnitType(l_pool,'ndtb',2.5) // 'ndtb': unit "Dark Goblin Berserker"
    call UnitPoolAddUnitType(l_pool,'n01O',1.5) // 'n01O': unit "Flan"
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,3,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nban',.5) // 'nban': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nbrg',.5) // 'nbrg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrog',1) // 'nrog': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nass',1) // 'nass': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nenf',1) // 'nenf': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nbld',.5) // 'nbld': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhfp',1.5) // 'nhfp': unit "Kultist"
    call UnitPoolAddUnitType(l_pool,'nhdc',1.5) // 'nhdc': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhhr',2.5) // 'nhhr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkob',1.5) // 'nkob': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkog',1.5) // 'nkog': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkot',1.5) // 'nkot': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkol',1) // 'nkol': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwiz',1) // 'nwiz': unit "Apprentice Dark Wizard"
    call UnitPoolAddUnitType(l_pool,'nwzr',2) // 'nwzr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwzg',1) // 'nwzg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwzd',1) // 'nwzd': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nogr',3) // 'nogr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nomg',2) // 'nomg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nogm',2) // 'nogm': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nogl',2) // 'nogl': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngns',1) // 'ngns': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngno',1) // 'ngno': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnw',1) // 'ngnw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnv',1) // 'ngnv': object name not found in map data
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,4,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nban',2) // 'nban': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nbrg',2) // 'nbrg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nrog',2) // 'nrog': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nass',2) // 'nass': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nenf',2) // 'nenf': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nbld',2) // 'nbld': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhfp',1) // 'nhfp': unit "Kultist"
    call UnitPoolAddUnitType(l_pool,'nhdc',1) // 'nhdc': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhhr',2) // 'nhhr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkob',.5) // 'nkob': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkog',.5) // 'nkog': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkot',.5) // 'nkot': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nkol',.5) // 'nkol': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwiz',1) // 'nwiz': unit "Apprentice Dark Wizard"
    call UnitPoolAddUnitType(l_pool,'nwzr',2) // 'nwzr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwzg',1) // 'nwzg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwzd',1) // 'nwzd': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nogr',1) // 'nogr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nomg',1) // 'nomg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nogm',1) // 'nogm': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nogl',1) // 'nogl': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n0MO',1) // 'n0MO': unit "Ogre Berserker"
    call UnitPoolAddUnitType(l_pool,'ngns',1) // 'ngns': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngno',1) // 'ngno': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnw',1) // 'ngnw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnv',1) // 'ngnv': object name not found in map data
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,4,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nwlg',3) // 'nwlg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwld',3) // 'nwld': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nspb',3) // 'nspb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngrk',1) // 'ngrk': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngst',1) // 'ngst': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nggr',1) // 'nggr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'narg',1) // 'narg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwrg',1) // 'nwrg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgg',1) // 'nsgg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngno',3) // 'ngno': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngns',3) // 'ngns': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnw',3) // 'ngnw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnv',3) // 'ngnv': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n01P',1) // 'n01P': unit "Lesser Flan"
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,5,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nwlg',1) // 'nwlg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwld',1) // 'nwld': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nspb',1) // 'nspb': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngrk',3) // 'ngrk': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngst',3) // 'ngst': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nggr',3) // 'nggr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'narg',3) // 'narg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwrg',3) // 'nwrg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsgg',3) // 'nsgg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngno',1) // 'ngno': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngns',1) // 'ngns': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnw',1) // 'ngnw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngnv',1) // 'ngnv': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'ngna',1) // 'ngna': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n01P',3) // 'n01P': unit "Lesser Flan"
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,5,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nnmg',1) // 'nnmg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nwgs',1) // 'nwgs': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nnsw',1) // 'nnsw': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nsnp',1.5) // 'nsnp': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmyr',1) // 'nmyr': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nnrg',1) // 'nnrg': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nhyc',1) // 'nhyc': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'nmpe',1) // 'nmpe': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n01Q',1.5) // 'n01Q': unit "Aqua Flan"
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,6,l_pool)
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,6,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nsty',2) // 'nsty': editor label "Satyr"
    call UnitPoolAddUnitType(l_pool,'nsat',2) // 'nsat': editor label "Satyr Trickster"
    call UnitPoolAddUnitType(l_pool,'nsts',2) // 'nsts': editor label "Satyr Shadowdancer"
    call UnitPoolAddUnitType(l_pool,'nstl',2) // 'nstl': editor label "Satyr Soulstealer"
    call UnitPoolAddUnitType(l_pool,'nsth',2) // 'nsth': editor label "Satyr Hellcaller"
    call UnitPoolAddUnitType(l_pool,'nenp',1) // 'nenp': editor label "Poison Treant"
    call UnitPoolAddUnitType(l_pool,'nenc',1) // 'nenc': editor label "Corrupted Treant"
    call UnitPoolAddUnitType(l_pool,'nepl',1) // 'nepl': editor label "Plague Treant"
    call UnitPoolAddUnitType(l_pool,'n00N',1) // 'n00N': unit "Corrupted Ancient of War"
    call UnitPoolAddUnitType(l_pool,'n00O',1) // 'n00O': unit "Corrupted Ancient Protector"
    call UnitPoolAddUnitType(l_pool,'n00P',1) // 'n00P': unit "Corrupted Tree of Life"
    call UnitPoolAddUnitType(l_pool,'n010',2) // 'n010': unit "Vile Spider"
    call UnitPoolAddUnitType(l_pool,'n01N',.5) // 'n01N': unit "Greater Flan"
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,7,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'nsty',1) // 'nsty': editor label "Satyr"
    call UnitPoolAddUnitType(l_pool,'nsat',1) // 'nsat': editor label "Satyr Trickster"
    call UnitPoolAddUnitType(l_pool,'nsts',1) // 'nsts': editor label "Satyr Shadowdancer"
    call UnitPoolAddUnitType(l_pool,'nstl',1) // 'nstl': editor label "Satyr Soulstealer"
    call UnitPoolAddUnitType(l_pool,'nsth',1) // 'nsth': editor label "Satyr Hellcaller"
    call UnitPoolAddUnitType(l_pool,'n0ML',1) // 'n0ML': unit "Satyr Assassin"
    call UnitPoolAddUnitType(l_pool,'nenp',1.5) // 'nenp': editor label "Poison Treant"
    call UnitPoolAddUnitType(l_pool,'nenc',1.5) // 'nenc': editor label "Corrupted Treant"
    call UnitPoolAddUnitType(l_pool,'nepl',1.5) // 'nepl': editor label "Plague Treant"
    call UnitPoolAddUnitType(l_pool,'n00N',2) // 'n00N': unit "Corrupted Ancient of War"
    call UnitPoolAddUnitType(l_pool,'n00O',2) // 'n00O': unit "Corrupted Ancient Protector"
    call UnitPoolAddUnitType(l_pool,'n00P',2) // 'n00P': unit "Corrupted Tree of Life"
    call UnitPoolAddUnitType(l_pool,'n010',1) // 'n010': unit "Vile Spider"
    call UnitPoolAddUnitType(l_pool,'n01N',2) // 'n01N': unit "Greater Flan"
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,7,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'n028',1.5) // 'n028': unit "Great Polar Bear"
    call UnitPoolAddUnitType(l_pool,'n027',2) // 'n027': unit "Elder Wendigo"
    call UnitPoolAddUnitType(l_pool,'n026',2) // 'n026': unit "Wendigo"
    call UnitPoolAddUnitType(l_pool,'n025',2) // 'n025': unit "Wendigo Shaman"
    call UnitPoolAddUnitType(l_pool,'n029',2) // 'n029': unit "Ice Troll"
    call UnitPoolAddUnitType(l_pool,'n02D',3) // 'n02D': unit "Ice Troll Priest"
    call UnitPoolAddUnitType(l_pool,'m02A',1.5) // 'm02A': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n02C',1) // 'n02C': unit "Icy Whelp"
    call UnitPoolAddUnitType(l_pool,'n02B',.5) // 'n02B': object name not found in map data
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,8,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'n028',1.5) // 'n028': unit "Great Polar Bear"
    call UnitPoolAddUnitType(l_pool,'n027',1.5) // 'n027': unit "Elder Wendigo"
    call UnitPoolAddUnitType(l_pool,'n026',1.5) // 'n026': unit "Wendigo"
    call UnitPoolAddUnitType(l_pool,'n025',1.5) // 'n025': unit "Wendigo Shaman"
    call UnitPoolAddUnitType(l_pool,'n0MQ',2) // 'n0MQ': unit "Wendigo Berserker"
    call UnitPoolAddUnitType(l_pool,'n029',1.5) // 'n029': unit "Ice Troll"
    call UnitPoolAddUnitType(l_pool,'n02D',1.5) // 'n02D': unit "Ice Troll Priest"
    call UnitPoolAddUnitType(l_pool,'m02A',1.5) // 'm02A': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n02C',1) // 'n02C': unit "Icy Whelp"
    call UnitPoolAddUnitType(l_pool,'n02B',1) // 'n02B': object name not found in map data
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,8,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'n03E',1) // 'n03E': unit "Nether Drake"
    call UnitPoolAddUnitType(l_pool,'n03F',2) // 'n03F': unit "Marsh Whelp"
    call UnitPoolAddUnitType(l_pool,'n03G',2) // 'n03G': unit "Dusk Wyrm"
    call UnitPoolAddUnitType(l_pool,'n03H',1) // 'n03H': unit "Black Dragon"
    call UnitPoolAddUnitType(l_pool,'n03I',2) // 'n03I': unit "Toxic Triton"
    call UnitPoolAddUnitType(l_pool,'n03J',1) // 'n03J': unit "Marsh Crawler"
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,9,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'n03E',2) // 'n03E': unit "Nether Drake"
    call UnitPoolAddUnitType(l_pool,'n03F',1) // 'n03F': unit "Marsh Whelp"
    call UnitPoolAddUnitType(l_pool,'n03G',1) // 'n03G': unit "Dusk Wyrm"
    call UnitPoolAddUnitType(l_pool,'n03H',2) // 'n03H': unit "Black Dragon"
    call UnitPoolAddUnitType(l_pool,'n03I',1) // 'n03I': unit "Toxic Triton"
    call UnitPoolAddUnitType(l_pool,'n03J',2) // 'n03J': unit "Marsh Crawler"
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,9,l_pool)
    set l_pool=CreateUnitPool()
    call UnitPoolAddUnitType(l_pool,'n02B',1) // 'n02B': object name not found in map data
    call UnitPoolAddUnitType(l_pool,'n0CB',3) // 'n0CB': unit "Vulcan"
    call UnitPoolAddUnitType(l_pool,'n0CK',3) // 'n0CK': unit "Cerberus"
    call UnitPoolAddUnitType(l_pool,'n0CU',2) // 'n0CU': unit "Hell Beast"
    call UnitPoolAddUnitType(l_pool,'n0CV',2) // 'n0CV': unit "Hell Shaman"
    call UnitPoolAddUnitType(l_pool,'n0CW',2) // 'n0CW': unit "Elder Hell Beast"
    call UnitPoolAddUnitType(l_pool,'n041',1) // 'n041': unit "Ruby Dragon"
    call UnitPoolAddUnitType(l_pool,'n040',1) // 'n040': unit "Aeshma"
    call SaveUnitPoolHandle(udg_SpawnDataHash,3,$A,l_pool) // $A = 10
    call SaveUnitPoolHandle(udg_SpawnDataHash,4,$A,l_pool) // $A = 10
    loop
        exitwhen i>9
        set l_zoneTimer=CreateTimer()
        call SaveTimerHandle(udg_SpawnTimerHash,1,i,l_zoneTimer)
        call SaveInteger(udg_SpawnTimerHash,GetHandleId(l_zoneTimer),0,i)
        set l_zoneTimer=CreateTimer()
        call SaveTimerHandle(udg_SpawnTimerHash,3,i,l_zoneTimer)
        call SaveInteger(udg_SpawnTimerHash,GetHandleId(l_zoneTimer),0,i)
        call SaveGroupHandle(udg_SpawnTimerHash,5,i,CreateGroup())
        set i=i+1
    endloop
    call SaveInteger(udg_SpawnDataHash,5,1,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,5,2,$C) // $C = 12
    call SaveInteger(udg_SpawnDataHash,5,3,8)
    call SaveInteger(udg_SpawnDataHash,5,4,$E) // $E = 14
    call SaveInteger(udg_SpawnDataHash,5,5,8)
    call SaveInteger(udg_SpawnDataHash,5,6,8)
    call SaveInteger(udg_SpawnDataHash,5,7,4)
    call SaveInteger(udg_SpawnDataHash,5,8,4)
    call SaveInteger(udg_SpawnDataHash,5,9,4)
    call SaveInteger(udg_SpawnDataHash,6,1,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,6,2,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,6,3,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,6,4,$F) // $F = 15
    call SaveInteger(udg_SpawnDataHash,6,5,$F) // $F = 15
    call SaveInteger(udg_SpawnDataHash,6,6,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,6,7,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,6,8,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,6,9,$A) // $A = 10
    call SaveInteger(udg_SpawnDataHash,7,1,20)
    call SaveInteger(udg_SpawnDataHash,7,2,25)
    call SaveInteger(udg_SpawnDataHash,7,3,$F) // $F = 15
    call SaveInteger(udg_SpawnDataHash,7,4,40)
    call SaveInteger(udg_SpawnDataHash,7,5,30)
    call SaveInteger(udg_SpawnDataHash,7,6,25)
    call SaveInteger(udg_SpawnDataHash,7,7,$F) // $F = 15
    call SaveInteger(udg_SpawnDataHash,7,8,$F) // $F = 15
    call SaveInteger(udg_SpawnDataHash,7,9,$F) // $F = 15
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Spawn_Gafgarion_IsGafgarionRevived takes nothing returns boolean
    return(udg_GafgarionRevived)
endfunction

function Trig_Spawn_Gafgarion_Actions takes nothing returns nothing
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_Spawn_Gafgarion_IsGafgarionRevived())then
        call CreateNUnitsAtLoc(1,'Uear',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'Uear': unit "Dark Knight"
        call SetHeroLevelBJ(GetLastCreatedUnit(),45,false)
        call UnitAddAbilityBJ('A0KS',GetLastCreatedUnit()) // 'A0KS': ability "Darkness"
        call UnitAddAbilityBJ('A0R1',GetLastCreatedUnit()) // 'A0R1': ability "Drain Attack"
        call UnitAddAbilityBJ('A1AA',GetLastCreatedUnit()) // 'A1AA': ability "!Dark Power"
        call UnitAddAbilityBJ('A1EF',GetLastCreatedUnit()) // 'A1EF': ability "HP Regeneration Burst"
        call SetUnitAbilityLevelSwapped('A0KS',GetLastCreatedUnit(),$A) // 'A0KS': ability "Darkness"; $A = 10
        call SetUnitAbilityLevelSwapped('A0R1',GetLastCreatedUnit(),$A) // 'A0R1': ability "Drain Attack"; $A = 10
        call SetUnitAbilityLevelSwapped('A1AA',GetLastCreatedUnit(),5) // 'A1AA': ability "!Dark Power"
    else
        call CreateNUnitsAtLoc(1,'Uear',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'Uear': unit "Dark Knight"; $B = 11
        call SetHeroLevelBJ(GetLastCreatedUnit(),40,false)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call UnitAddAbilityBJ('A0KS',GetLastCreatedUnit()) // 'A0KS': ability "Darkness"
        call UnitAddAbilityBJ('A0R1',GetLastCreatedUnit()) // 'A0R1': ability "Drain Attack"
        call UnitAddAbilityBJ('A1AA',GetLastCreatedUnit()) // 'A1AA': ability "!Dark Power"
        call SetUnitAbilityLevelSwapped('A0KS',GetLastCreatedUnit(),2) // 'A0KS': ability "Darkness"
    endif
    call UnitAddAbilityBJ('A0Z5',GetLastCreatedUnit()) // 'A0Z5': ability "Minus Strike"
    call UnitAddAbilityBJ('A0TU',GetLastCreatedUnit()) // 'A0TU': ability "HP Regeneration Bonus"
    call SetUnitAbilityLevelSwapped('A0Z5',GetLastCreatedUnit(),$A) // 'A0Z5': ability "Minus Strike"; $A = 10
    call SetUnitAbilityLevelSwapped('A0TU',GetLastCreatedUnit(),$A) // 'A0TU': ability "HP Regeneration Bonus"; $A = 10
    set udg_StoryBoss=GetLastCreatedUnit()
    call UnitAddItemByIdSwapped('I0EQ',GetLastCreatedUnit()) // 'I0EQ': item "Deathbringer"
    call UnitAddItemByIdSwapped('I016',GetLastCreatedUnit()) // 'I016': item "Platinum Shield"
    call UnitAddItemByIdSwapped('I01K',GetLastCreatedUnit()) // 'I01K': item "Platinum Helmet"
    call UnitAddItemByIdSwapped('I01T',GetLastCreatedUnit()) // 'I01T': item "Platinum Mail"
    call UnitAddItemByIdSwapped('I00G',GetLastCreatedUnit()) // 'I00G': item "Armguard"
    call UnitAddItemByIdSwapped('I02V',GetLastCreatedUnit()) // 'I02V': item "Nectar"
    call SetItemCharges(GetLastCreatedItem(),99)
    call SetUnitManaPercentBJ(udg_StoryBoss,'d')
endfunction

function Trig_Spawn_KalmDefenders_HideOldAlly takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionRanger takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HasBomberSupport takes nothing returns boolean
    return(udg_KalmTechLevel>=3)and(IsUnitHiddenBJ(gg_unit_hbla_0158)==false)
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionCleric takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HasCleric takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_Hjai_0093,udg_RecruitedAllies))
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionPriest takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionGolem takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HasGolemQuest takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[16]))
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionBladeKnight takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_IsMidStoryDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[9]))
endfunction

function Trig_Spawn_KalmDefenders_IsLateStoryDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$A])) // $A = 10
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionBrother takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_MidStoryCleared takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[9]))
endfunction

function Trig_Spawn_KalmDefenders_LateStoryCleared takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$A])) // $A = 10
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionBrother2 takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionBiggs takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionBiggsAlt takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_BrothersMissing takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_Ocbh_0148,udg_RecruitedAllies)==false)
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionFriend1 takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HasFriend1 takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01I_0070,udg_RecruitedAllies))
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionFriend2 takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HasFriend2 takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01J_0069,udg_RecruitedAllies))
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionFriend3 takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HasFriend3 takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01K_0068,udg_RecruitedAllies))
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionFriend4 takes nothing returns nothing
    call UnitShareVisionBJ(true,GetLastCreatedUnit(),GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HasFriend4 takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01L_0067,udg_RecruitedAllies))
endfunction

function Trig_Spawn_KalmDefenders_HasGunnerSupport takes nothing returns boolean
    return(udg_KalmTechLevel>=3)and(IsUnitHiddenBJ(gg_unit_hbla_0158)==false)
endfunction

function Trig_Spawn_KalmDefenders_IsNotHero takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_Spawn_KalmDefenders_SetupEngineerUnit takes nothing returns nothing
    if(Trig_Spawn_KalmDefenders_IsNotHero())then
        // (BlzGetUnitBaseDamage(the unit being visited, udg_AbilityLevelIndex)) times (2).
        call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),udg_AbilityLevelIndex)*2),udg_AbilityLevelIndex)
    endif
    call Unit_ScaleToLevel60(GetEnumUnit())
    call SetUnitAcquireRangeBJ(GetEnumUnit(),900.)
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call PauseUnitBJ(true,GetEnumUnit())
    call UnitRemoveAbilityBJ('A0VJ',GetEnumUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Trig_Spawn_KalmDefenders_ShareVisionEngineer takes nothing returns nothing
    call UnitShareVisionBJ(true,udg_EngineerHero,GetEnumPlayer())
endfunction

function Trig_Spawn_KalmDefenders_HideEngineerGroup takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
endfunction

function Trig_Spawn_KalmDefenders_LateStoryPending takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$A])==false) // $A = 10
endfunction

function Trig_Spawn_KalmDefenders_MidStoryReached takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[9]))
endfunction

function Trig_Spawn_KalmDefenders_IsNotHeroUnit takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_Spawn_KalmDefenders_SetupFrontUnit takes nothing returns nothing
    if(Trig_Spawn_KalmDefenders_IsNotHeroUnit())then
        // (BlzGetUnitBaseDamage(the unit being visited, udg_AbilityLevelIndex)) times (2).
        call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),udg_AbilityLevelIndex)*2),udg_AbilityLevelIndex)
    endif
    call Unit_ScaleToLevel60(GetEnumUnit())
    call SetUnitAcquireRangeBJ(GetEnumUnit(),900.)
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call PauseUnitBJ(true,GetEnumUnit())
    call UnitRemoveAbilityBJ('A0VJ',GetEnumUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Trig_Spawn_KalmDefenders_IsNotHeroMember takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_Spawn_KalmDefenders_SetupRearUnit takes nothing returns nothing
    if(Trig_Spawn_KalmDefenders_IsNotHeroMember())then
        // (BlzGetUnitBaseDamage(the unit being visited, udg_AbilityLevelIndex)) times (2).
        call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),udg_AbilityLevelIndex)*2),udg_AbilityLevelIndex)
    endif
    call Unit_ScaleToLevel60(GetEnumUnit())
    call SetUnitAcquireRangeBJ(GetEnumUnit(),750.)
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call PauseUnitBJ(true,GetEnumUnit())
    call UnitRemoveAbilityBJ('A0VJ',GetEnumUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Trig_Spawn_KalmDefenders_Actions takes nothing returns nothing
    call ForGroupBJ(udg_RecruitedAllies,function Trig_Spawn_KalmDefenders_HideOldAlly)
    set udg_TempPoint=GetRectCenter(gg_rct_584)
    call CreateNUnitsAtLoc(1,'Hvwd',Player(9),udg_TempPoint,135.) // 'Hvwd': unit "First Ranger"
    set udg_RangerHero=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    call SetHeroLevelBJ(GetLastCreatedUnit(),25,false)
    call UnitAddItemByIdSwapped('I0F4',GetLastCreatedUnit()) // 'I0F4': item "Longbow"
    call UnitAddItemByIdSwapped('I0HN',GetLastCreatedUnit()) // 'I0HN': item "Onion Arrows"
    call UnitAddItemByIdSwapped('I01I',GetLastCreatedUnit()) // 'I01I': item "Mithril Helmet"
    call UnitAddItemByIdSwapped('I01T',GetLastCreatedUnit()) // 'I01T': item "Platinum Mail"
    call UnitAddItemByIdSwapped('I00Q',GetLastCreatedUnit()) // 'I00Q': item "Steel Gorget"
    call UnitAddItemByIdSwapped('pghe',GetLastCreatedUnit()) // 'pghe': item "Hi-Potion"
    call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionRanger)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,45.)
    call CreateNUnitsAtLoc(1,'nhea',Player(9),udg_TempPoint2,135.) // 'nhea': object name not found in map data
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,225.)
    call CreateNUnitsAtLoc(1,'nhea',Player(9),udg_TempPoint2,135.) // 'nhea': object name not found in map data
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    if(Trig_Spawn_KalmDefenders_HasBomberSupport())then
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,192.,.0)
        call CreateNUnitsAtLoc(1,'hmtm',Player(9),udg_TempPoint2,135.) // 'hmtm': unit "Bomber"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,192.,270.)
        call CreateNUnitsAtLoc(1,'hmtm',Player(9),udg_TempPoint2,135.) // 'hmtm': unit "Bomber"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Spawn_KalmDefenders_HasCleric())then
        set udg_TempPoint=GetRectCenter(gg_rct_586)
        call CreateNUnitsAtLoc(1,'Hjai',Player(9),udg_TempPoint,150.) // 'Hjai': unit "Cleric"
        set udg_ClericAlly=GetLastCreatedUnit()
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call SetHeroLevelBJ(GetLastCreatedUnit(),$F,false) // $F = 15
        call UnitAddItemByIdSwapped('I01D',GetLastCreatedUnit()) // 'I01D': item "Poison Wand"
        call UnitAddItemByIdSwapped('I012',GetLastCreatedUnit()) // 'I012': item "Round Shield"
        call UnitAddItemByIdSwapped('I01H',GetLastCreatedUnit()) // 'I01H': item "Iron Helmet"
        call UnitAddItemByIdSwapped('I01U',GetLastCreatedUnit()) // 'I01U': item "Wizard's Robe"
        call UnitAddItemByIdSwapped('I04D',GetLastCreatedUnit()) // 'I04D': item "Leather Gorget"
        call UnitAddItemByIdSwapped('pgma',GetLastCreatedUnit()) // 'pgma': item "Hi-Ether"
        call SelectHeroSkill(GetLastCreatedUnit(),'A00M') // 'A00M': ability "Cure"
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionCleric)
        call RemoveLocation(udg_TempPoint)
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_587)
    call CreateNUnitsAtLoc(1,'H00T',Player(9),udg_TempPoint,180.) // 'H00T': unit "High Priest"
    set udg_HighPriestAlly=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    call SetHeroLevelBJ(GetLastCreatedUnit(),20,false)
    call UnitAddItemByIdSwapped('I01F',GetLastCreatedUnit()) // 'I01F': item "Thunder Wand"
    call UnitAddItemByIdSwapped('I015',GetLastCreatedUnit()) // 'I015': item "Aegis Shield"
    call UnitAddItemByIdSwapped('I01I',GetLastCreatedUnit()) // 'I01I': item "Mithril Helmet"
    call UnitAddItemByIdSwapped('I01U',GetLastCreatedUnit()) // 'I01U': item "Wizard's Robe"
    call UnitAddItemByIdSwapped('I037',GetLastCreatedUnit()) // 'I037': item "Magic Gloves"
    call UnitAddItemByIdSwapped('sman',GetLastCreatedUnit()) // 'sman': item "Mega Ether"
    call SelectHeroSkill(GetLastCreatedUnit(),'A00M') // 'A00M': ability "Cure"
    call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionPriest)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,128.)
    call CreateNUnitsAtLoc(1,'nhea',Player(9),udg_TempPoint2,180.) // 'nhea': object name not found in map data
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-128.)
    call CreateNUnitsAtLoc(1,'nhea',Player(9),udg_TempPoint2,180.) // 'nhea': object name not found in map data
    call RemoveLocation(udg_TempPoint2)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_585)
    if(Trig_Spawn_KalmDefenders_HasGolemQuest())then
        call CreateNUnitsAtLoc(1,'n015',Player(9),udg_TempPoint,135.) // 'n015': unit "Mithril Golem"
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
        // (maximum health of GetLastCreatedUnit()) divided by (3).
        call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 3))
        // (BlzGetUnitArmor(GetLastCreatedUnit())) divided by (3).
        call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())/ 3.))
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionGolem)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,135.)
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,128.,45.)
        call CreateNUnitsAtLoc(1,'hhes',Player(9),udg_TempPoint,135.) // 'hhes': unit "Knight"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,128.,225.)
        call CreateNUnitsAtLoc(1,'hhes',Player(9),udg_TempPoint,135.) // 'hhes': unit "Knight"
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call CreateNUnitsAtLoc(1,'Hdgo',Player(9),udg_TempPoint2,135.) // 'Hdgo': unit "Blade Knight"
        set udg_BladeKnightAlly=GetLastCreatedUnit()
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
    else
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,45.)
        call CreateNUnitsAtLoc(1,'hhes',Player(9),udg_TempPoint2,135.) // 'hhes': unit "Knight"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,225.)
        call CreateNUnitsAtLoc(1,'hhes',Player(9),udg_TempPoint2,135.) // 'hhes': unit "Knight"
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
        call CreateNUnitsAtLoc(1,'Hdgo',Player(9),udg_TempPoint,135.) // 'Hdgo': unit "Blade Knight"
        set udg_BladeKnightAlly=GetLastCreatedUnit()
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyRangerGroup)
    endif
    call SetHeroLevelBJ(GetLastCreatedUnit(),25,false)
    call UnitAddItemByIdSwapped('I00V',GetLastCreatedUnit()) // 'I00V': item "Mithril Sword"
    call UnitAddItemByIdSwapped('I013',GetLastCreatedUnit()) // 'I013': item "Iron Shield"
    call UnitAddItemByIdSwapped('I01I',GetLastCreatedUnit()) // 'I01I': item "Mithril Helmet"
    call UnitAddItemByIdSwapped('I01T',GetLastCreatedUnit()) // 'I01T': item "Platinum Mail"
    call UnitAddItemByIdSwapped('I00G',GetLastCreatedUnit()) // 'I00G': item "Armguard"
    call UnitAddItemByIdSwapped('I001',GetLastCreatedUnit()) // 'I001': item "Mega Potion"
    call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionBladeKnight)
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_588)
    if(Trig_Spawn_KalmDefenders_BrothersMissing())then
        call CreateNUnitsAtLoc(1,'h007',Player(9),udg_TempPoint,135.) // 'h007': unit "Biggs"
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call Cam_PanToUnit(GetLastCreatedUnit(),.0)
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionBiggsAlt)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,45.)
        call CreateNUnitsAtLoc(1,'hfoo',Player(9),udg_TempPoint2,135.) // 'hfoo': object name not found in map data
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,225.)
        call CreateNUnitsAtLoc(1,'hfoo',Player(9),udg_TempPoint2,135.) // 'hfoo': object name not found in map data
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,165.)
        call CreateNUnitsAtLoc(1,'hfoo',Player(9),udg_TempPoint2,135.) // 'hfoo': object name not found in map data
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,105.)
        call CreateNUnitsAtLoc(1,'hfoo',Player(9),udg_TempPoint2,135.) // 'hfoo': object name not found in map data
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
    else
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,45.)
        call CreateNUnitsAtLoc(1,'Ocbh',Player(9),udg_TempPoint2,135.) // 'Ocbh': unit "Brother"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call UnitRemoveAbilityBJ('A0TT',GetLastCreatedUnit()) // 'A0TT': ability "Gaya Lifestream"
        if(Trig_Spawn_KalmDefenders_IsLateStoryDone())then
            call SetHeroLevelBJ(GetLastCreatedUnit(),45,false)
        else
            if(Trig_Spawn_KalmDefenders_IsMidStoryDone())then
                call SetHeroLevelBJ(GetLastCreatedUnit(),35,false)
            else
                call SetHeroLevelBJ(GetLastCreatedUnit(),25,false)
            endif
        endif
        call UnitAddItemByIdSwapped('I01B',GetLastCreatedUnit()) // 'I01B': item "Mithril Axe"
        call UnitAddItemByIdSwapped('I012',GetLastCreatedUnit()) // 'I012': item "Round Shield"
        call UnitAddItemByIdSwapped('I01H',GetLastCreatedUnit()) // 'I01H': item "Iron Helmet"
        call UnitAddItemByIdSwapped('I01N',GetLastCreatedUnit()) // 'I01N': item "Reinforced Leather Armor"
        call UnitAddItemByIdSwapped('I00Q',GetLastCreatedUnit()) // 'I00Q': item "Steel Gorget"
        call UnitAddItemByIdSwapped('pghe',GetLastCreatedUnit()) // 'pghe': item "Hi-Potion"
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionBrother)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,225.)
        call CreateNUnitsAtLoc(1,'Ocb2',Player(9),udg_TempPoint2,135.) // 'Ocb2': unit "Brother"
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call UnitRemoveAbilityBJ('A0TT',GetLastCreatedUnit()) // 'A0TT': ability "Gaya Lifestream"
        if(Trig_Spawn_KalmDefenders_LateStoryCleared())then
            call SetHeroLevelBJ(GetLastCreatedUnit(),50,false)
        else
            if(Trig_Spawn_KalmDefenders_MidStoryCleared())then
                call SetHeroLevelBJ(GetLastCreatedUnit(),45,false)
            else
                call SetHeroLevelBJ(GetLastCreatedUnit(),35,false)
            endif
        endif
        call UnitAddItemByIdSwapped('I01B',GetLastCreatedUnit()) // 'I01B': item "Mithril Axe"
        call UnitAddItemByIdSwapped('I014',GetLastCreatedUnit()) // 'I014': item "Mithril Shield"
        call UnitAddItemByIdSwapped('I01I',GetLastCreatedUnit()) // 'I01I': item "Mithril Helmet"
        call UnitAddItemByIdSwapped('I01R',GetLastCreatedUnit()) // 'I01R': item "Mithril Mail"
        call UnitAddItemByIdSwapped('I00C',GetLastCreatedUnit()) // 'I00C': item "Blazer Gloves"
        call UnitAddItemByIdSwapped('I02V',GetLastCreatedUnit()) // 'I02V': item "Nectar"
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionBrother2)
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,135.)
        call CreateNUnitsAtLoc(1,'h007',Player(9),udg_TempPoint2,135.) // 'h007': unit "Biggs"
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call Cam_PanToUnit(GetLastCreatedUnit(),.0)
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionBiggs)
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256.,45.)
        call CreateNUnitsAtLoc(1,'hfoo',Player(9),udg_TempPoint,135.) // 'hfoo': object name not found in map data
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256.,225.)
        call CreateNUnitsAtLoc(1,'hfoo',Player(9),udg_TempPoint,135.) // 'hfoo': object name not found in map data
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
    endif
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    if(Trig_Spawn_KalmDefenders_HasFriend1())then
        set udg_TempPoint=GetRectCenter(gg_rct_588)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,512.,75.)
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,'H01I',Player(9),udg_TempPoint2,105.) // 'H01I': unit "Friend of Brothers"
        call RemoveLocation(udg_TempPoint2)
        call SetHeroLevelBJ(GetLastCreatedUnit(),25,false)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionFriend1)
    endif
    if(Trig_Spawn_KalmDefenders_HasFriend2())then
        set udg_TempPoint=GetRectCenter(gg_rct_588)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,512.,45.)
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,'H01J',Player(9),udg_TempPoint2,105.) // 'H01J': unit "Friend of Brothers"
        call RemoveLocation(udg_TempPoint2)
        call SetHeroLevelBJ(GetLastCreatedUnit(),35,false)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionFriend2)
    endif
    if(Trig_Spawn_KalmDefenders_HasFriend3())then
        set udg_TempPoint=GetRectCenter(gg_rct_588)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,512.,215.)
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,'H01K',Player(9),udg_TempPoint2,165.) // 'H01K': unit "Friend of Brothers"
        call RemoveLocation(udg_TempPoint2)
        call SetHeroLevelBJ(GetLastCreatedUnit(),25,false)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionFriend3)
    endif
    if(Trig_Spawn_KalmDefenders_HasFriend4())then
        set udg_TempPoint=GetRectCenter(gg_rct_588)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,512.,185.)
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,'H01L',Player(9),udg_TempPoint2,165.) // 'H01L': unit "Friend of Brothers"
        call RemoveLocation(udg_TempPoint2)
        call SetHeroLevelBJ(GetLastCreatedUnit(),40,false)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyBrothersGroup)
        call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionFriend4)
    endif
    if(Trig_Spawn_KalmDefenders_MidStoryReached())then
        set udg_TempPoint=GetRectCenter(gg_rct_635)
        call CreateNUnitsAtLoc(1,'Hpb1',Player(9),udg_TempPoint,225.) // 'Hpb1': unit "Engineer"
        set udg_EngineerHero=GetLastCreatedUnit()
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
        call SetHeroLevelBJ(GetLastCreatedUnit(),30,false)
        call UnitAddItemByIdSwapped('I01B',GetLastCreatedUnit()) // 'I01B': item "Mithril Axe"
        call UnitAddItemByIdSwapped('I014',GetLastCreatedUnit()) // 'I014': item "Mithril Shield"
        call UnitAddItemByIdSwapped('I01I',GetLastCreatedUnit()) // 'I01I': item "Mithril Helmet"
        call UnitAddItemByIdSwapped('I01R',GetLastCreatedUnit()) // 'I01R': item "Mithril Mail"
        call UnitAddItemByIdSwapped('I00Q',GetLastCreatedUnit()) // 'I00Q': item "Steel Gorget"
        call UnitAddItemByIdSwapped('pghe',GetLastCreatedUnit()) // 'pghe': item "Hi-Potion"
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,135.)
        call CreateNUnitsAtLoc(1,'h00K',Player(9),udg_TempPoint2,225.) // 'h00K': unit "Wedge"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,315.)
        call CreateNUnitsAtLoc(1,'n00D',Player(9),udg_TempPoint2,225.) // 'n00D': unit "Jessie"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,195.)
        call CreateNUnitsAtLoc(1,'hhes',Player(9),udg_TempPoint2,225.) // 'hhes': unit "Knight"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,255.)
        call CreateNUnitsAtLoc(1,'hhes',Player(9),udg_TempPoint2,225.) // 'hhes': unit "Knight"
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
        if(Trig_Spawn_KalmDefenders_HasGunnerSupport())then
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,30.)
            call CreateNUnitsAtLoc(1,'hmtm',Player(9),udg_TempPoint2,225.) // 'hmtm': unit "Bomber"
            call RemoveLocation(udg_TempPoint2)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,60.)
            call CreateNUnitsAtLoc(1,'hmtm',Player(9),udg_TempPoint2,225.) // 'hmtm': unit "Bomber"
            call RemoveLocation(udg_TempPoint2)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,90.)
            call CreateNUnitsAtLoc(1,'hrif',Player(9),udg_TempPoint2,225.) // 'hrif': unit "Gunner"
            call RemoveLocation(udg_TempPoint2)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,.0)
            call CreateNUnitsAtLoc(1,'hrif',Player(9),udg_TempPoint2,225.) // 'hrif': unit "Gunner"
            call RemoveLocation(udg_TempPoint2)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_AllyEngineerGroup)
        endif
        call RemoveLocation(udg_TempPoint)
        call ForGroupBJ(udg_AllyEngineerGroup,function Trig_Spawn_KalmDefenders_SetupEngineerUnit)
        if(Trig_Spawn_KalmDefenders_LateStoryPending())then
            call ForGroupBJ(udg_AllyEngineerGroup,function Trig_Spawn_KalmDefenders_HideEngineerGroup)
        else
            call ForForce(udg_PlayingPlayers,function Trig_Spawn_KalmDefenders_ShareVisionEngineer)
        endif
    endif
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_Spawn_KalmDefenders_SetupFrontUnit)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_Spawn_KalmDefenders_SetupRearUnit)
endfunction

// World Editor calls InitTrig_Spawn automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Spawn_Part1 / RegisterTriggers_Spawn_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Spawn takes nothing returns nothing
endfunction

function Register_Spawn_Pools_Init takes nothing returns nothing
    set gg_trg_Spawn_Pools_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Spawn_Pools_Init,function Trig_Spawn_Pools_Init_Actions)
endfunction

function Register_Spawn_Gafgarion takes nothing returns nothing
    set gg_trg_Spawn_Gafgarion=CreateTrigger()
    call DisableTrigger(gg_trg_Spawn_Gafgarion)
    call TriggerAddAction(gg_trg_Spawn_Gafgarion,function Trig_Spawn_Gafgarion_Actions)
endfunction

function Register_Spawn_KalmDefenders takes nothing returns nothing
    set gg_trg_Spawn_KalmDefenders=CreateTrigger()
    call DisableTrigger(gg_trg_Spawn_KalmDefenders)
    call TriggerAddAction(gg_trg_Spawn_KalmDefenders,function Trig_Spawn_KalmDefenders_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Spawn_Part1 takes nothing returns nothing
    call Register_Spawn_Pools_Init() // run by MapBootstrap
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Spawn_Part2 takes nothing returns nothing
    call Register_Spawn_Gafgarion() // starts off; run by Boss_Belias, Boss_Hashmalum, Cine +1 more
    call Register_Spawn_KalmDefenders() // starts off; run by KalmSiege1, KalmSiege2, KalmSiege3
endfunction

endlibrary

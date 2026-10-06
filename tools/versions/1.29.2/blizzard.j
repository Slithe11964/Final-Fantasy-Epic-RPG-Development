//===========================================================================
// Blizzard.j ( define Jass2 functions that need to be in every map script )
//===========================================================================


globals
    //-----------------------------------------------------------------------
    // Constants
    //

    // Misc constants

    constant real      bj_PI                            = 3.14159

    constant real      bj_E                             = 2.71828

    constant real      bj_CELLWIDTH                     = 128.0

    constant real      bj_CLIFFHEIGHT                   = 128.0

    constant real      bj_UNIT_FACING                   = 270.0

    constant real      bj_RADTODEG                      = 180.0/bj_PI

    constant real      bj_DEGTORAD                      = bj_PI/180.0

    constant real      bj_TEXT_DELAY_QUEST              = 20.00

    constant real      bj_TEXT_DELAY_QUESTUPDATE        = 20.00

    constant real      bj_TEXT_DELAY_QUESTDONE          = 20.00

    constant real      bj_TEXT_DELAY_QUESTFAILED        = 20.00

    constant real      bj_TEXT_DELAY_QUESTREQUIREMENT   = 20.00

    constant real      bj_TEXT_DELAY_MISSIONFAILED      = 20.00

    constant real      bj_TEXT_DELAY_ALWAYSHINT         = 12.00

    constant real      bj_TEXT_DELAY_HINT               = 12.00

    constant real      bj_TEXT_DELAY_SECRET             = 10.00

    constant real      bj_TEXT_DELAY_UNITACQUIRED       = 15.00

    constant real      bj_TEXT_DELAY_UNITAVAILABLE      = 10.00

    constant real      bj_TEXT_DELAY_ITEMACQUIRED       = 10.00

    constant real      bj_TEXT_DELAY_WARNING            = 12.00

    constant real      bj_QUEUE_DELAY_QUEST             =  5.00

    constant real      bj_QUEUE_DELAY_HINT              =  5.00

    constant real      bj_QUEUE_DELAY_SECRET            =  3.00

    constant real      bj_HANDICAP_EASY                 = 60.00





    constant real      bj_GAME_STARTED_THRESHOLD        =  0.01

    constant real      bj_WAIT_FOR_COND_MIN_INTERVAL    =  0.10

    constant real      bj_POLLED_WAIT_INTERVAL          =  0.10

    constant real      bj_POLLED_WAIT_SKIP_THRESHOLD    =  2.00

    // Game constants

    constant integer   bj_MAX_INVENTORY                 =  6



    constant integer   bj_MAX_PLAYERS                   =  GetBJMaxPlayers()

    constant integer   bj_PLAYER_NEUTRAL_VICTIM         =  GetBJPlayerNeutralVictim()

    constant integer   bj_PLAYER_NEUTRAL_EXTRA          =  GetBJPlayerNeutralExtra()

    constant integer   bj_MAX_PLAYER_SLOTS              =  GetBJMaxPlayerSlots()

    constant integer   bj_MAX_SKELETONS                 =  25

    constant integer   bj_MAX_STOCK_ITEM_SLOTS          =  11

    constant integer   bj_MAX_STOCK_UNIT_SLOTS          =  11

    constant integer   bj_MAX_ITEM_LEVEL                =  10
    
    // Auto Save constants


    // Ideally these would be looked up from Units/MiscData.txt,
    // but there is currently no script functionality exposed to do that

    constant real      bj_TOD_DAWN                      = 6.00

    constant real      bj_TOD_DUSK                      = 18.00

    // Melee game settings:
    //   - Starting Time of Day (TOD)
    //   - Starting Gold
    //   - Starting Lumber
    //   - Starting Hero Tokens (free heroes)
    //   - Max heroes allowed per player
    //   - Max heroes allowed per hero type
    //   - Distance from start loc to search for nearby mines
    //

    constant real      bj_MELEE_STARTING_TOD            = 8.00

    constant integer   bj_MELEE_STARTING_GOLD_V0        = 750

    constant integer   bj_MELEE_STARTING_GOLD_V1        = 500

    constant integer   bj_MELEE_STARTING_LUMBER_V0      = 200

    constant integer   bj_MELEE_STARTING_LUMBER_V1      = 150

    constant integer   bj_MELEE_STARTING_HERO_TOKENS    = 1

    constant integer   bj_MELEE_HERO_LIMIT              = 3

    constant integer   bj_MELEE_HERO_TYPE_LIMIT         = 1

    constant real      bj_MELEE_MINE_SEARCH_RADIUS      = 2000

    constant real      bj_MELEE_CLEAR_UNITS_RADIUS      = 1500

    constant real      bj_MELEE_CRIPPLE_TIMEOUT         = 120.00

    constant real      bj_MELEE_CRIPPLE_MSG_DURATION    = 20.00

    constant integer   bj_MELEE_MAX_TWINKED_HEROES_V0   = 3

    constant integer   bj_MELEE_MAX_TWINKED_HEROES_V1   = 1

    // Delay between a creep's death and the time it may drop an item.

    constant real      bj_CREEP_ITEM_DELAY              = 0.50

    // Timing settings for Marketplace inventories.

    constant real      bj_STOCK_RESTOCK_INITIAL_DELAY   = 120

    constant real      bj_STOCK_RESTOCK_INTERVAL        = 30

    constant integer   bj_STOCK_MAX_ITERATIONS          = 20

    // Max events registered by a single "dest dies in region" event.

    constant integer   bj_MAX_DEST_IN_REGION_EVENTS     = 64

    // Camera settings

    constant integer   bj_CAMERA_MIN_FARZ               = 100

    constant integer   bj_CAMERA_DEFAULT_DISTANCE       = 1650

    constant integer   bj_CAMERA_DEFAULT_FARZ           = 5000

    constant integer   bj_CAMERA_DEFAULT_AOA            = 304

    constant integer   bj_CAMERA_DEFAULT_FOV            = 70

    constant integer   bj_CAMERA_DEFAULT_ROLL           = 0

    constant integer   bj_CAMERA_DEFAULT_ROTATION       = 90

    // Rescue

    constant real      bj_RESCUE_PING_TIME              = 2.00

    // Transmission behavior settings

    constant real      bj_NOTHING_SOUND_DURATION        = 5.00

    constant real      bj_TRANSMISSION_PING_TIME        = 1.00

    constant integer   bj_TRANSMISSION_IND_RED          = 255

    constant integer   bj_TRANSMISSION_IND_BLUE         = 255

    constant integer   bj_TRANSMISSION_IND_GREEN        = 255

    constant integer   bj_TRANSMISSION_IND_ALPHA        = 255

    constant real      bj_TRANSMISSION_PORT_HANGTIME    = 1.50

    // Cinematic mode settings

    constant real      bj_CINEMODE_INTERFACEFADE        = 0.50

    constant gamespeed bj_CINEMODE_GAMESPEED            = MAP_SPEED_NORMAL

    // Cinematic mode volume levels

    constant real      bj_CINEMODE_VOLUME_UNITMOVEMENT  = 0.40

    constant real      bj_CINEMODE_VOLUME_UNITSOUNDS    = 0.00

    constant real      bj_CINEMODE_VOLUME_COMBAT        = 0.40

    constant real      bj_CINEMODE_VOLUME_SPELLS        = 0.40

    constant real      bj_CINEMODE_VOLUME_UI            = 0.00

    constant real      bj_CINEMODE_VOLUME_MUSIC         = 0.55

    constant real      bj_CINEMODE_VOLUME_AMBIENTSOUNDS = 1.00

    constant real      bj_CINEMODE_VOLUME_FIRE          = 0.60

    // Speech mode volume levels

    constant real      bj_SPEECH_VOLUME_UNITMOVEMENT    = 0.25

    constant real      bj_SPEECH_VOLUME_UNITSOUNDS      = 0.00

    constant real      bj_SPEECH_VOLUME_COMBAT          = 0.25

    constant real      bj_SPEECH_VOLUME_SPELLS          = 0.25

    constant real      bj_SPEECH_VOLUME_UI              = 0.00

    constant real      bj_SPEECH_VOLUME_MUSIC           = 0.55

    constant real      bj_SPEECH_VOLUME_AMBIENTSOUNDS   = 1.00

    constant real      bj_SPEECH_VOLUME_FIRE            = 0.60

    // Smart pan settings

    constant real      bj_SMARTPAN_TRESHOLD_PAN         = 500

    constant real      bj_SMARTPAN_TRESHOLD_SNAP        = 3500

    // QueuedTriggerExecute settings

    constant integer   bj_MAX_QUEUED_TRIGGERS           = 100

    constant real      bj_QUEUED_TRIGGER_TIMEOUT        = 180.00

    // Campaign indexing constants

    constant integer   bj_CAMPAIGN_INDEX_T        = 0

    constant integer   bj_CAMPAIGN_INDEX_H        = 1

    constant integer   bj_CAMPAIGN_INDEX_U        = 2

    constant integer   bj_CAMPAIGN_INDEX_O        = 3

    constant integer   bj_CAMPAIGN_INDEX_N        = 4

    constant integer   bj_CAMPAIGN_INDEX_XN       = 5

    constant integer   bj_CAMPAIGN_INDEX_XH       = 6

    constant integer   bj_CAMPAIGN_INDEX_XU       = 7

    constant integer   bj_CAMPAIGN_INDEX_XO       = 8



    // Campaign offset constants (for mission indexing)

    constant integer   bj_CAMPAIGN_OFFSET_T       = 0

    constant integer   bj_CAMPAIGN_OFFSET_H       = 1

    constant integer   bj_CAMPAIGN_OFFSET_U       = 2

    constant integer   bj_CAMPAIGN_OFFSET_O       = 3

    constant integer   bj_CAMPAIGN_OFFSET_N       = 4

    constant integer   bj_CAMPAIGN_OFFSET_XN      = 5

    constant integer   bj_CAMPAIGN_OFFSET_XH      = 6

    constant integer   bj_CAMPAIGN_OFFSET_XU      = 7

    constant integer   bj_CAMPAIGN_OFFSET_XO      = 8



    // Mission indexing constants
    // Tutorial

    constant integer   bj_MISSION_INDEX_T00       = bj_CAMPAIGN_OFFSET_T * 1000 + 0

    constant integer   bj_MISSION_INDEX_T01       = bj_CAMPAIGN_OFFSET_T * 1000 + 1



    // Human

    constant integer   bj_MISSION_INDEX_H00       = bj_CAMPAIGN_OFFSET_H * 1000 + 0

    constant integer   bj_MISSION_INDEX_H01       = bj_CAMPAIGN_OFFSET_H * 1000 + 1

    constant integer   bj_MISSION_INDEX_H02       = bj_CAMPAIGN_OFFSET_H * 1000 + 2

    constant integer   bj_MISSION_INDEX_H03       = bj_CAMPAIGN_OFFSET_H * 1000 + 3

    constant integer   bj_MISSION_INDEX_H04       = bj_CAMPAIGN_OFFSET_H * 1000 + 4

    constant integer   bj_MISSION_INDEX_H05       = bj_CAMPAIGN_OFFSET_H * 1000 + 5

    constant integer   bj_MISSION_INDEX_H06       = bj_CAMPAIGN_OFFSET_H * 1000 + 6

    constant integer   bj_MISSION_INDEX_H07       = bj_CAMPAIGN_OFFSET_H * 1000 + 7

    constant integer   bj_MISSION_INDEX_H08       = bj_CAMPAIGN_OFFSET_H * 1000 + 8

    constant integer   bj_MISSION_INDEX_H09       = bj_CAMPAIGN_OFFSET_H * 1000 + 9

    constant integer   bj_MISSION_INDEX_H10       = bj_CAMPAIGN_OFFSET_H * 1000 + 10

    constant integer   bj_MISSION_INDEX_H11       = bj_CAMPAIGN_OFFSET_H * 1000 + 11
    // Undead

    constant integer   bj_MISSION_INDEX_U00       = bj_CAMPAIGN_OFFSET_U * 1000 + 0

    constant integer   bj_MISSION_INDEX_U01       = bj_CAMPAIGN_OFFSET_U * 1000 + 1

    constant integer   bj_MISSION_INDEX_U02       = bj_CAMPAIGN_OFFSET_U * 1000 + 2

    constant integer   bj_MISSION_INDEX_U03       = bj_CAMPAIGN_OFFSET_U * 1000 + 3

    constant integer   bj_MISSION_INDEX_U05       = bj_CAMPAIGN_OFFSET_U * 1000 + 4

    constant integer   bj_MISSION_INDEX_U07       = bj_CAMPAIGN_OFFSET_U * 1000 + 5

    constant integer   bj_MISSION_INDEX_U08       = bj_CAMPAIGN_OFFSET_U * 1000 + 6

    constant integer   bj_MISSION_INDEX_U09       = bj_CAMPAIGN_OFFSET_U * 1000 + 7

    constant integer   bj_MISSION_INDEX_U10       = bj_CAMPAIGN_OFFSET_U * 1000 + 8

    constant integer   bj_MISSION_INDEX_U11       = bj_CAMPAIGN_OFFSET_U * 1000 + 9
    // Orc

    constant integer   bj_MISSION_INDEX_O00       = bj_CAMPAIGN_OFFSET_O * 1000 + 0

    constant integer   bj_MISSION_INDEX_O01       = bj_CAMPAIGN_OFFSET_O * 1000 + 1

    constant integer   bj_MISSION_INDEX_O02       = bj_CAMPAIGN_OFFSET_O * 1000 + 2

    constant integer   bj_MISSION_INDEX_O03       = bj_CAMPAIGN_OFFSET_O * 1000 + 3

    constant integer   bj_MISSION_INDEX_O04       = bj_CAMPAIGN_OFFSET_O * 1000 + 4

    constant integer   bj_MISSION_INDEX_O05       = bj_CAMPAIGN_OFFSET_O * 1000 + 5

    constant integer   bj_MISSION_INDEX_O06       = bj_CAMPAIGN_OFFSET_O * 1000 + 6

    constant integer   bj_MISSION_INDEX_O07       = bj_CAMPAIGN_OFFSET_O * 1000 + 7

    constant integer   bj_MISSION_INDEX_O08       = bj_CAMPAIGN_OFFSET_O * 1000 + 8

    constant integer   bj_MISSION_INDEX_O09       = bj_CAMPAIGN_OFFSET_O * 1000 + 9

    constant integer   bj_MISSION_INDEX_O10       = bj_CAMPAIGN_OFFSET_O * 1000 + 10
    // Night Elf

    constant integer   bj_MISSION_INDEX_N00       = bj_CAMPAIGN_OFFSET_N * 1000 + 0

    constant integer   bj_MISSION_INDEX_N01       = bj_CAMPAIGN_OFFSET_N * 1000 + 1

    constant integer   bj_MISSION_INDEX_N02       = bj_CAMPAIGN_OFFSET_N * 1000 + 2

    constant integer   bj_MISSION_INDEX_N03       = bj_CAMPAIGN_OFFSET_N * 1000 + 3

    constant integer   bj_MISSION_INDEX_N04       = bj_CAMPAIGN_OFFSET_N * 1000 + 4

    constant integer   bj_MISSION_INDEX_N05       = bj_CAMPAIGN_OFFSET_N * 1000 + 5

    constant integer   bj_MISSION_INDEX_N06       = bj_CAMPAIGN_OFFSET_N * 1000 + 6

    constant integer   bj_MISSION_INDEX_N07       = bj_CAMPAIGN_OFFSET_N * 1000 + 7

    constant integer   bj_MISSION_INDEX_N08       = bj_CAMPAIGN_OFFSET_N * 1000 + 8

    constant integer   bj_MISSION_INDEX_N09       = bj_CAMPAIGN_OFFSET_N * 1000 + 9
    // Expansion Night Elf

    constant integer   bj_MISSION_INDEX_XN00       = bj_CAMPAIGN_OFFSET_XN * 1000 + 0

    constant integer   bj_MISSION_INDEX_XN01       = bj_CAMPAIGN_OFFSET_XN * 1000 + 1

    constant integer   bj_MISSION_INDEX_XN02       = bj_CAMPAIGN_OFFSET_XN * 1000 + 2

    constant integer   bj_MISSION_INDEX_XN03       = bj_CAMPAIGN_OFFSET_XN * 1000 + 3

    constant integer   bj_MISSION_INDEX_XN04       = bj_CAMPAIGN_OFFSET_XN * 1000 + 4

    constant integer   bj_MISSION_INDEX_XN05       = bj_CAMPAIGN_OFFSET_XN * 1000 + 5

    constant integer   bj_MISSION_INDEX_XN06       = bj_CAMPAIGN_OFFSET_XN * 1000 + 6

    constant integer   bj_MISSION_INDEX_XN07       = bj_CAMPAIGN_OFFSET_XN * 1000 + 7

    constant integer   bj_MISSION_INDEX_XN08       = bj_CAMPAIGN_OFFSET_XN * 1000 + 8

    constant integer   bj_MISSION_INDEX_XN09       = bj_CAMPAIGN_OFFSET_XN * 1000 + 9

    constant integer   bj_MISSION_INDEX_XN10       = bj_CAMPAIGN_OFFSET_XN * 1000 + 10
    // Expansion Human

    constant integer   bj_MISSION_INDEX_XH00       = bj_CAMPAIGN_OFFSET_XH * 1000 + 0

    constant integer   bj_MISSION_INDEX_XH01       = bj_CAMPAIGN_OFFSET_XH * 1000 + 1

    constant integer   bj_MISSION_INDEX_XH02       = bj_CAMPAIGN_OFFSET_XH * 1000 + 2

    constant integer   bj_MISSION_INDEX_XH03       = bj_CAMPAIGN_OFFSET_XH * 1000 + 3

    constant integer   bj_MISSION_INDEX_XH04       = bj_CAMPAIGN_OFFSET_XH * 1000 + 4

    constant integer   bj_MISSION_INDEX_XH05       = bj_CAMPAIGN_OFFSET_XH * 1000 + 5

    constant integer   bj_MISSION_INDEX_XH06       = bj_CAMPAIGN_OFFSET_XH * 1000 + 6

    constant integer   bj_MISSION_INDEX_XH07       = bj_CAMPAIGN_OFFSET_XH * 1000 + 7

    constant integer   bj_MISSION_INDEX_XH08       = bj_CAMPAIGN_OFFSET_XH * 1000 + 8

    constant integer   bj_MISSION_INDEX_XH09       = bj_CAMPAIGN_OFFSET_XH * 1000 + 9
    // Expansion Undead

    constant integer   bj_MISSION_INDEX_XU00       = bj_CAMPAIGN_OFFSET_XU * 1000 + 0

    constant integer   bj_MISSION_INDEX_XU01       = bj_CAMPAIGN_OFFSET_XU * 1000 + 1

    constant integer   bj_MISSION_INDEX_XU02       = bj_CAMPAIGN_OFFSET_XU * 1000 + 2

    constant integer   bj_MISSION_INDEX_XU03       = bj_CAMPAIGN_OFFSET_XU * 1000 + 3

    constant integer   bj_MISSION_INDEX_XU04       = bj_CAMPAIGN_OFFSET_XU * 1000 + 4

    constant integer   bj_MISSION_INDEX_XU05       = bj_CAMPAIGN_OFFSET_XU * 1000 + 5

    constant integer   bj_MISSION_INDEX_XU06       = bj_CAMPAIGN_OFFSET_XU * 1000 + 6

    constant integer   bj_MISSION_INDEX_XU07       = bj_CAMPAIGN_OFFSET_XU * 1000 + 7

    constant integer   bj_MISSION_INDEX_XU08       = bj_CAMPAIGN_OFFSET_XU * 1000 + 8

    constant integer   bj_MISSION_INDEX_XU09       = bj_CAMPAIGN_OFFSET_XU * 1000 + 9

    constant integer   bj_MISSION_INDEX_XU10       = bj_CAMPAIGN_OFFSET_XU * 1000 + 10

    constant integer   bj_MISSION_INDEX_XU11       = bj_CAMPAIGN_OFFSET_XU * 1000 + 11

    constant integer   bj_MISSION_INDEX_XU12       = bj_CAMPAIGN_OFFSET_XU * 1000 + 12

    constant integer   bj_MISSION_INDEX_XU13       = bj_CAMPAIGN_OFFSET_XU * 1000 + 13

    // Expansion Orc

    constant integer   bj_MISSION_INDEX_XO00       = bj_CAMPAIGN_OFFSET_XO * 1000 + 0




    // Rebirth Human





    // Rebirth Undead





    // Cinematic indexing constants
    constant integer   bj_CINEMATICINDEX_TOP      = 0

    constant integer   bj_CINEMATICINDEX_HOP      = 1

    constant integer   bj_CINEMATICINDEX_HED      = 2

    constant integer   bj_CINEMATICINDEX_OOP      = 3

    constant integer   bj_CINEMATICINDEX_OED      = 4

    constant integer   bj_CINEMATICINDEX_UOP      = 5

    constant integer   bj_CINEMATICINDEX_UED      = 6

    constant integer   bj_CINEMATICINDEX_NOP      = 7

    constant integer   bj_CINEMATICINDEX_NED      = 8

    constant integer   bj_CINEMATICINDEX_XOP      = 9

    constant integer   bj_CINEMATICINDEX_XED      = 10



    // Alliance settings

    constant integer   bj_ALLIANCE_UNALLIED        = 0

    constant integer   bj_ALLIANCE_UNALLIED_VISION = 1

    constant integer   bj_ALLIANCE_ALLIED          = 2

    constant integer   bj_ALLIANCE_ALLIED_VISION   = 3

    constant integer   bj_ALLIANCE_ALLIED_UNITS    = 4

    constant integer   bj_ALLIANCE_ALLIED_ADVUNITS = 5

    constant integer   bj_ALLIANCE_NEUTRAL         = 6

    constant integer   bj_ALLIANCE_NEUTRAL_VISION  = 7

    // Keyboard Event Types

    constant integer   bj_KEYEVENTTYPE_DEPRESS     = 0

    constant integer   bj_KEYEVENTTYPE_RELEASE     = 1

    // Keyboard Event Keys

    constant integer   bj_KEYEVENTKEY_LEFT         = 0

    constant integer   bj_KEYEVENTKEY_RIGHT        = 1

    constant integer   bj_KEYEVENTKEY_DOWN         = 2

    constant integer   bj_KEYEVENTKEY_UP           = 3


    // Mouse Event Types

    constant integer   bj_MOUSEEVENTTYPE_DOWN     = 0

    constant integer   bj_MOUSEEVENTTYPE_UP       = 1

    constant integer   bj_MOUSEEVENTTYPE_MOVE     = 2

    // Transmission timing methods

    constant integer   bj_TIMETYPE_ADD             = 0

    constant integer   bj_TIMETYPE_SET             = 1

    constant integer   bj_TIMETYPE_SUB             = 2

    // Camera bounds adjustment methods

    constant integer   bj_CAMERABOUNDS_ADJUST_ADD  = 0

    constant integer   bj_CAMERABOUNDS_ADJUST_SUB  = 1

    // Quest creation states

    constant integer   bj_QUESTTYPE_REQ_DISCOVERED   = 0

    constant integer   bj_QUESTTYPE_REQ_UNDISCOVERED = 1

    constant integer   bj_QUESTTYPE_OPT_DISCOVERED   = 2

    constant integer   bj_QUESTTYPE_OPT_UNDISCOVERED = 3

    // Quest message types

    constant integer   bj_QUESTMESSAGE_DISCOVERED    = 0

    constant integer   bj_QUESTMESSAGE_UPDATED       = 1

    constant integer   bj_QUESTMESSAGE_COMPLETED     = 2

    constant integer   bj_QUESTMESSAGE_FAILED        = 3

    constant integer   bj_QUESTMESSAGE_REQUIREMENT   = 4

    constant integer   bj_QUESTMESSAGE_MISSIONFAILED = 5

    constant integer   bj_QUESTMESSAGE_ALWAYSHINT    = 6

    constant integer   bj_QUESTMESSAGE_HINT          = 7

    constant integer   bj_QUESTMESSAGE_SECRET        = 8

    constant integer   bj_QUESTMESSAGE_UNITACQUIRED  = 9

    constant integer   bj_QUESTMESSAGE_UNITAVAILABLE = 10

    constant integer   bj_QUESTMESSAGE_ITEMACQUIRED  = 11

    constant integer   bj_QUESTMESSAGE_WARNING       = 12

    // Leaderboard sorting methods

    constant integer   bj_SORTTYPE_SORTBYVALUE     = 0

    constant integer   bj_SORTTYPE_SORTBYPLAYER    = 1

    constant integer   bj_SORTTYPE_SORTBYLABEL     = 2

    // Cinematic fade filter methods

    constant integer   bj_CINEFADETYPE_FADEIN      = 0

    constant integer   bj_CINEFADETYPE_FADEOUT     = 1

    constant integer   bj_CINEFADETYPE_FADEOUTIN   = 2

    // Buff removal methods

    constant integer   bj_REMOVEBUFFS_POSITIVE     = 0

    constant integer   bj_REMOVEBUFFS_NEGATIVE     = 1

    constant integer   bj_REMOVEBUFFS_ALL          = 2

    constant integer   bj_REMOVEBUFFS_NONTLIFE     = 3

    // Buff properties - polarity

    constant integer   bj_BUFF_POLARITY_POSITIVE   = 0

    constant integer   bj_BUFF_POLARITY_NEGATIVE   = 1

    constant integer   bj_BUFF_POLARITY_EITHER     = 2

    // Buff properties - resist type

    constant integer   bj_BUFF_RESIST_MAGIC        = 0

    constant integer   bj_BUFF_RESIST_PHYSICAL     = 1

    constant integer   bj_BUFF_RESIST_EITHER       = 2

    constant integer   bj_BUFF_RESIST_BOTH         = 3

    // Hero stats

    constant integer   bj_HEROSTAT_STR             = 0

    constant integer   bj_HEROSTAT_AGI             = 1

    constant integer   bj_HEROSTAT_INT             = 2

    // Hero skill point modification methods

    constant integer   bj_MODIFYMETHOD_ADD    = 0

    constant integer   bj_MODIFYMETHOD_SUB    = 1

    constant integer   bj_MODIFYMETHOD_SET    = 2

    // Unit state adjustment methods (for replaced units)

    constant integer   bj_UNIT_STATE_METHOD_ABSOLUTE = 0

    constant integer   bj_UNIT_STATE_METHOD_RELATIVE = 1

    constant integer   bj_UNIT_STATE_METHOD_DEFAULTS = 2

    constant integer   bj_UNIT_STATE_METHOD_MAXIMUM  = 3

    // Gate operations

    constant integer   bj_GATEOPERATION_CLOSE      = 0

    constant integer   bj_GATEOPERATION_OPEN       = 1

    constant integer   bj_GATEOPERATION_DESTROY    = 2

	// Game cache value types

	constant integer   bj_GAMECACHE_BOOLEAN                 = 0

	constant integer   bj_GAMECACHE_INTEGER                 = 1

	constant integer   bj_GAMECACHE_REAL                    = 2

	constant integer   bj_GAMECACHE_UNIT                    = 3

	constant integer   bj_GAMECACHE_STRING                  = 4
	
	// Hashtable value types

	constant integer   bj_HASHTABLE_BOOLEAN                 = 0

	constant integer   bj_HASHTABLE_INTEGER                 = 1

	constant integer   bj_HASHTABLE_REAL                    = 2

	constant integer   bj_HASHTABLE_STRING                  = 3

	constant integer   bj_HASHTABLE_HANDLE                  = 4

    // Item status types

    constant integer   bj_ITEM_STATUS_HIDDEN       = 0

    constant integer   bj_ITEM_STATUS_OWNED        = 1

    constant integer   bj_ITEM_STATUS_INVULNERABLE = 2

    constant integer   bj_ITEM_STATUS_POWERUP      = 3

    constant integer   bj_ITEM_STATUS_SELLABLE     = 4

    constant integer   bj_ITEM_STATUS_PAWNABLE     = 5

    // Itemcode status types

    constant integer   bj_ITEMCODE_STATUS_POWERUP  = 0

    constant integer   bj_ITEMCODE_STATUS_SELLABLE = 1

    constant integer   bj_ITEMCODE_STATUS_PAWNABLE = 2

    // Minimap ping styles

    constant integer   bj_MINIMAPPINGSTYLE_SIMPLE  = 0

    constant integer   bj_MINIMAPPINGSTYLE_FLASHY  = 1

    constant integer   bj_MINIMAPPINGSTYLE_ATTACK  = 2
	
    // Campaign Minimap icon styles










    // Corpse creation settings

    constant real      bj_CORPSE_MAX_DEATH_TIME    = 8.00

    // Corpse creation styles

    constant integer   bj_CORPSETYPE_FLESH         = 0

    constant integer   bj_CORPSETYPE_BONE          = 1

    // Elevator pathing-blocker destructable code

    constant integer   bj_ELEVATOR_BLOCKER_CODE    = 'DTep'

    constant integer   bj_ELEVATOR_CODE01          = 'DTrf'

    constant integer   bj_ELEVATOR_CODE02          = 'DTrx'

    // Elevator wall codes

    constant integer   bj_ELEVATOR_WALL_TYPE_ALL        = 0

    constant integer   bj_ELEVATOR_WALL_TYPE_EAST       = 1

    constant integer   bj_ELEVATOR_WALL_TYPE_NORTH      = 2

    constant integer   bj_ELEVATOR_WALL_TYPE_SOUTH      = 3

    constant integer   bj_ELEVATOR_WALL_TYPE_WEST       = 4

    //-----------------------------------------------------------------------
    // Variables
    //

    // Force predefs

    force              bj_FORCE_ALL_PLAYERS        = null

    force array        bj_FORCE_PLAYER


    integer            bj_MELEE_MAX_TWINKED_HEROES = 0

    // Map area rects

    rect               bj_mapInitialPlayableArea   = null

    rect               bj_mapInitialCameraBounds   = null

    // Utility function vars

    integer            bj_forLoopAIndex            = 0

    integer            bj_forLoopBIndex            = 0

    integer            bj_forLoopAIndexEnd         = 0

    integer            bj_forLoopBIndexEnd         = 0


    boolean            bj_slotControlReady         = false

    boolean array      bj_slotControlUsed

    mapcontrol array   bj_slotControl

    // Game started detection vars

    timer              bj_gameStartedTimer         = null

    boolean            bj_gameStarted              = false

    timer              bj_volumeGroupsTimer

    // Singleplayer check

    boolean            bj_isSinglePlayer           = false

    // Day/Night Cycle vars

    trigger            bj_dncSoundsDay             = null

    trigger            bj_dncSoundsNight           = null

    sound              bj_dayAmbientSound          = null

    sound              bj_nightAmbientSound        = null

    trigger            bj_dncSoundsDawn            = null

    trigger            bj_dncSoundsDusk            = null

    sound              bj_dawnSound                = null

    sound              bj_duskSound                = null

    boolean            bj_useDawnDuskSounds        = true

    boolean            bj_dncIsDaytime             = false

    // Triggered sounds
    //sound              bj_pingMinimapSound         = null

    sound              bj_rescueSound              = null

    sound              bj_questDiscoveredSound     = null

    sound              bj_questUpdatedSound        = null

    sound              bj_questCompletedSound      = null

    sound              bj_questFailedSound         = null

    sound              bj_questHintSound           = null

    sound              bj_questSecretSound         = null

    sound              bj_questItemAcquiredSound   = null

    sound              bj_questWarningSound        = null

    sound              bj_victoryDialogSound       = null

    sound              bj_defeatDialogSound        = null

    // Marketplace vars

    trigger            bj_stockItemPurchased       = null

    timer              bj_stockUpdateTimer         = null

    boolean array      bj_stockAllowedPermanent

    boolean array      bj_stockAllowedCharged

    boolean array      bj_stockAllowedArtifact

    integer            bj_stockPickedItemLevel     = 0

    itemtype           bj_stockPickedItemType

    // Melee vars

    trigger            bj_meleeVisibilityTrained   = null

    boolean            bj_meleeVisibilityIsDay     = true

    boolean            bj_meleeGrantHeroItems      = false

    location           bj_meleeNearestMineToLoc    = null

    unit               bj_meleeNearestMine         = null

    real               bj_meleeNearestMineDist     = 0.00

    boolean            bj_meleeGameOver            = false

    boolean array      bj_meleeDefeated

    boolean array      bj_meleeVictoried

    unit array         bj_ghoul

    timer array        bj_crippledTimer

    timerdialog array  bj_crippledTimerWindows

    boolean array      bj_playerIsCrippled

    boolean array      bj_playerIsExposed

    boolean            bj_finishSoonAllExposed     = false

    timerdialog        bj_finishSoonTimerDialog    = null

    integer array      bj_meleeTwinkedHeroes

    // Rescue behavior vars

    trigger            bj_rescueUnitBehavior       = null

    boolean            bj_rescueChangeColorUnit    = true

    boolean            bj_rescueChangeColorBldg    = true

    // Transmission vars

    timer              bj_cineSceneEndingTimer     = null

    sound              bj_cineSceneLastSound       = null

    trigger            bj_cineSceneBeingSkipped    = null

    // Cinematic mode vars

    gamespeed          bj_cineModePriorSpeed       = MAP_SPEED_NORMAL

    boolean            bj_cineModePriorFogSetting  = false

    boolean            bj_cineModePriorMaskSetting = false

    boolean            bj_cineModeAlreadyIn        = false

    boolean            bj_cineModePriorDawnDusk    = false

    integer            bj_cineModeSavedSeed        = 0

    // Cinematic fade vars

    timer              bj_cineFadeFinishTimer      = null

    timer              bj_cineFadeContinueTimer    = null

    real               bj_cineFadeContinueRed      = 0

    real               bj_cineFadeContinueGreen    = 0

    real               bj_cineFadeContinueBlue     = 0

    real               bj_cineFadeContinueTrans    = 0

    real               bj_cineFadeContinueDuration = 0

    string             bj_cineFadeContinueTex      = ""

    // QueuedTriggerExecute vars

    integer            bj_queuedExecTotal          = 0

    trigger array      bj_queuedExecTriggers

    boolean array      bj_queuedExecUseConds

    timer              bj_queuedExecTimeoutTimer

    trigger            bj_queuedExecTimeout        = null

    // Helper vars (for Filter and Enum funcs)

    integer            bj_destInRegionDiesCount    = 0

    trigger            bj_destInRegionDiesTrig     = null

    integer            bj_groupCountUnits          = 0

    integer            bj_forceCountPlayers        = 0

    integer            bj_groupEnumTypeId          = 0

    player             bj_groupEnumOwningPlayer    = null

    group              bj_groupAddGroupDest        = null

    group              bj_groupRemoveGroupDest     = null

    integer            bj_groupRandomConsidered    = 0

    unit               bj_groupRandomCurrentPick   = null

    group              bj_groupLastCreatedDest     = null

    group              bj_randomSubGroupGroup      = null

    integer            bj_randomSubGroupWant       = 0

    integer            bj_randomSubGroupTotal      = 0

    real               bj_randomSubGroupChance     = 0

    integer            bj_destRandomConsidered     = 0

    destructable       bj_destRandomCurrentPick    = null

    destructable       bj_elevatorWallBlocker      = null

    destructable       bj_elevatorNeighbor         = null

    integer            bj_itemRandomConsidered     = 0

    item               bj_itemRandomCurrentPick    = null

    integer            bj_forceRandomConsidered    = 0

    player             bj_forceRandomCurrentPick   = null

    unit               bj_makeUnitRescuableUnit    = null

    boolean            bj_makeUnitRescuableFlag    = true

    boolean            bj_pauseAllUnitsFlag        = true

    location           bj_enumDestructableCenter   = null

    real               bj_enumDestructableRadius   = 0

    playercolor        bj_setPlayerTargetColor     = null

    boolean            bj_isUnitGroupDeadResult    = true

    boolean            bj_isUnitGroupEmptyResult   = true

    boolean            bj_isUnitGroupInRectResult  = true

    rect               bj_isUnitGroupInRectRect    = null

    boolean            bj_changeLevelShowScores    = false

    string             bj_changeLevelMapName       = null

    group              bj_suspendDecayFleshGroup

    group              bj_suspendDecayBoneGroup

    timer              bj_delayedSuspendDecayTimer

    trigger            bj_delayedSuspendDecayTrig  = null

    integer            bj_livingPlayerUnitsTypeId  = 0

    widget             bj_lastDyingWidget          = null




    // Random distribution vars

    integer            bj_randDistCount            = 0

    integer array      bj_randDistID

    integer array      bj_randDistChance

    // Last X'd vars

    unit               bj_lastCreatedUnit          = null

    item               bj_lastCreatedItem          = null

    item               bj_lastRemovedItem          = null

    unit               bj_lastHauntedGoldMine      = null

    destructable       bj_lastCreatedDestructable  = null

    group              bj_lastCreatedGroup

    fogmodifier        bj_lastCreatedFogModifier   = null

    effect             bj_lastCreatedEffect        = null

    weathereffect      bj_lastCreatedWeatherEffect = null

    terraindeformation bj_lastCreatedTerrainDeformation = null

    quest              bj_lastCreatedQuest         = null

    questitem          bj_lastCreatedQuestItem     = null

    defeatcondition    bj_lastCreatedDefeatCondition = null

    timer              bj_lastStartedTimer

    timerdialog        bj_lastCreatedTimerDialog   = null

    leaderboard        bj_lastCreatedLeaderboard   = null

    multiboard         bj_lastCreatedMultiboard    = null

    sound              bj_lastPlayedSound          = null

    string             bj_lastPlayedMusic          = ""

    real               bj_lastTransmissionDuration = 0

    gamecache          bj_lastCreatedGameCache     = null

    hashtable          bj_lastCreatedHashtable     = null

    unit               bj_lastLoadedUnit           = null

    button             bj_lastCreatedButton        = null

    unit               bj_lastReplacedUnit         = null

    texttag            bj_lastCreatedTextTag       = null

    lightning          bj_lastCreatedLightning     = null

    image              bj_lastCreatedImage         = null

    ubersplat          bj_lastCreatedUbersplat     = null





    // Filter function vars

    boolexpr           filterIssueHauntOrderAtLocBJ      = null

    boolexpr           filterEnumDestructablesInCircleBJ = null

    boolexpr           filterGetUnitsInRectOfPlayer      = null

    boolexpr           filterGetUnitsOfTypeIdAll         = null

    boolexpr           filterGetUnitsOfPlayerAndTypeId   = null

    boolexpr           filterMeleeTrainedUnitIsHeroBJ    = null

    boolexpr           filterLivingPlayerUnitsOfTypeId   = null

    // Memory cleanup vars

    boolean            bj_wantDestroyGroup         = false



    // Instanced Operation Results

endglobals



//***************************************************************************
//*
//*  Debugging Functions
//*
//***************************************************************************

//===========================================================================

function BJDebugMsg takes string msg returns nothing
endfunction

//***************************************************************************
//*
//*  Memory Cleanup Functions
//*
//***************************************************************************







//***************************************************************************
//*
//*  Math Utility Functions
//*
//***************************************************************************

//===========================================================================

function RMinBJ takes real a, real b returns real
    return 0.
endfunction

//===========================================================================

function RMaxBJ takes real a, real b returns real
    return 0.
endfunction

//===========================================================================

function RAbsBJ takes real a returns real
    return 0.
endfunction

//===========================================================================

function RSignBJ takes real a returns real
    return 0.
endfunction

//===========================================================================

function IMinBJ takes integer a, integer b returns integer
    return 0
endfunction

//===========================================================================

function IMaxBJ takes integer a, integer b returns integer
    return 0
endfunction

//===========================================================================

function IAbsBJ takes integer a returns integer
    return 0
endfunction

//===========================================================================

function ISignBJ takes integer a returns integer
    return 0
endfunction

//===========================================================================

function SinBJ takes real degrees returns real
    return 0.
endfunction

//===========================================================================

function CosBJ takes real degrees returns real
    return 0.
endfunction

//===========================================================================

function TanBJ takes real degrees returns real
    return 0.
endfunction

//===========================================================================

function AsinBJ takes real degrees returns real
    return 0.
endfunction

//===========================================================================

function AcosBJ takes real degrees returns real
    return 0.
endfunction

//===========================================================================

function AtanBJ takes real degrees returns real
    return 0.
endfunction

//===========================================================================

function Atan2BJ takes real y, real x returns real
    return 0.
endfunction

//===========================================================================

function AngleBetweenPoints takes location locA, location locB returns real
    return 0.
endfunction

//===========================================================================

function DistanceBetweenPoints takes location locA, location locB returns real
    return 0.
endfunction

//===========================================================================

function PolarProjectionBJ takes location source, real dist, real angle returns location
    return null
endfunction

//===========================================================================

function GetRandomDirectionDeg takes nothing returns real
    return 0.
endfunction

//===========================================================================

function GetRandomPercentageBJ takes nothing returns real
    return 0.
endfunction

//===========================================================================

function GetRandomLocInRect takes rect whichRect returns location
    return null
endfunction

//===========================================================================
// Calculate the modulus/remainder of (dividend) divided by (divisor).
// Examples:  18 mod 5 = 3.  15 mod 5 = 0.  -8 mod 5 = 2.
//

function ModuloInteger takes integer dividend, integer divisor returns integer
    return 0
endfunction

//===========================================================================
// Calculate the modulus/remainder of (dividend) divided by (divisor).
// Examples:  13.000 mod 2.500 = 0.500.  -6.000 mod 2.500 = 1.500.
//

function ModuloReal takes real dividend, real divisor returns real
    return 0.
endfunction

//===========================================================================

function OffsetLocation takes location loc, real dx, real dy returns location
    return null
endfunction

//===========================================================================

function OffsetRectBJ takes rect r, real dx, real dy returns rect
    return null
endfunction

//===========================================================================

function RectFromCenterSizeBJ takes location center, real width, real height returns rect
    return null
endfunction

//===========================================================================

function RectContainsCoords takes rect r, real x, real y returns boolean
    return false
endfunction

//===========================================================================

function RectContainsLoc takes rect r, location loc returns boolean
    return false
endfunction

//===========================================================================

function RectContainsUnit takes rect r, unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function RectContainsItem takes item whichItem, rect r returns boolean
    return false
endfunction



//***************************************************************************
//*
//*  Utility Constructs
//*
//***************************************************************************

//===========================================================================
// Runs the trigger's actions if the trigger's conditions evaluate to true.
//

function ConditionalTriggerExecute takes trigger trig returns nothing
endfunction

//===========================================================================
// Runs the trigger's actions if the trigger's conditions evaluate to true.
//

function TriggerExecuteBJ takes trigger trig, boolean checkConditions returns boolean
    return false
endfunction

//===========================================================================
// Arranges for a trigger to fire almost immediately, except that the calling
// trigger is not interrupted as is the case with a TriggerExecute call.
// Since the trigger executes normally, its conditions are still evaluated.
//

function PostTriggerExecuteBJ takes trigger trig, boolean checkConditions returns boolean
    return false
endfunction

//===========================================================================
// Debug - Display the contents of the trigger queue (as either null or "x"
// for each entry).

function QueuedTriggerCheck takes nothing returns nothing
endfunction

//===========================================================================
// Searches the queue for a given trigger, returning the index of the
// trigger within the queue if it is found, or -1 if it is not found.
//

function QueuedTriggerGetIndex takes trigger trig returns integer
    return 0
endfunction

//===========================================================================
// Removes a trigger from the trigger queue, shifting other triggers down
// to fill the unused space.  If the currently running trigger is removed
// in this manner, this function does NOT attempt to run the next trigger.
//

function QueuedTriggerRemoveByIndex takes integer trigIndex returns boolean
    return false
endfunction

//===========================================================================
// Attempt to execute the first trigger in the queue.  If it fails, remove
// it and execute the next one.  Continue this cycle until a trigger runs,
// or until the queue is empty.
//

function QueuedTriggerAttemptExec takes nothing returns boolean
    return false
endfunction

//===========================================================================
// Queues a trigger to be executed, assuring that such triggers are not
// executed at the same time.
//

function QueuedTriggerAddBJ takes trigger trig, boolean checkConditions returns boolean
    return false
endfunction

//===========================================================================
// Denotes the end of a queued trigger. Be sure to call this only once per
// queued trigger, or risk stepping on the toes of other queued triggers.
//

function QueuedTriggerRemoveBJ takes trigger trig returns nothing
endfunction

//===========================================================================
// Denotes the end of a queued trigger. Be sure to call this only once per
// queued trigger, lest you step on the toes of other queued triggers.
//

function QueuedTriggerDoneBJ takes nothing returns nothing
endfunction

//===========================================================================
// Empty the trigger queue.
//

function QueuedTriggerClearBJ takes nothing returns nothing
endfunction

//===========================================================================
// Remove all but the currently executing trigger from the trigger queue.
//

function QueuedTriggerClearInactiveBJ takes nothing returns nothing
endfunction

//===========================================================================

function QueuedTriggerCountBJ takes nothing returns integer
    return 0
endfunction

//===========================================================================

function IsTriggerQueueEmptyBJ takes nothing returns boolean
    return false
endfunction

//===========================================================================

function IsTriggerQueuedBJ takes trigger trig returns boolean
    return false
endfunction

//===========================================================================

function GetForLoopIndexA takes nothing returns integer
    return 0
endfunction

//===========================================================================

function SetForLoopIndexA takes integer newIndex returns nothing
endfunction

//===========================================================================

function GetForLoopIndexB takes nothing returns integer
    return 0
endfunction

//===========================================================================

function SetForLoopIndexB takes integer newIndex returns nothing
endfunction

//===========================================================================
// We can't do game-time waits, so this simulates one by starting a timer
// and polling until the timer expires.

function PolledWait takes real duration returns nothing
endfunction

//===========================================================================

function IntegerTertiaryOp takes boolean flag, integer valueA, integer valueB returns integer
    return 0
endfunction


//***************************************************************************
//*
//*  General Utility Functions
//*  These functions exist purely to make the trigger dialogs cleaner and
//*  more comprehensible.
//*
//***************************************************************************

//===========================================================================

function DoNothing takes nothing returns nothing
endfunction

//===========================================================================
// This function does nothing.  WorldEdit should should eventually ignore
// CommentString triggers during script generation, but until such a time,
// this function will serve as a stub.
//

function CommentString takes string commentString returns nothing
endfunction

//===========================================================================
// This function returns the input string, converting it from the localized text, if necessary
//

function StringIdentity takes string theString returns string
    return ""
endfunction

//===========================================================================

function GetBooleanAnd takes boolean valueA, boolean valueB returns boolean
    return false
endfunction

//===========================================================================

function GetBooleanOr takes boolean valueA, boolean valueB returns boolean
    return false
endfunction

//===========================================================================
// Converts a percentage (real, 0..100) into a scaled integer (0..max),
// clipping the result to 0..max in case the input is invalid.
//

function PercentToInt takes real percentage, integer max returns integer
    return 0
endfunction

//===========================================================================

function PercentTo255 takes real percentage returns integer
    return 0
endfunction

//===========================================================================

function GetTimeOfDay takes nothing returns real
    return 0.
endfunction

//===========================================================================

function SetTimeOfDay takes real whatTime returns nothing
endfunction

//===========================================================================

function SetTimeOfDayScalePercentBJ takes real scalePercent returns nothing
endfunction

//===========================================================================

function GetTimeOfDayScalePercentBJ takes nothing returns real
    return 0.
endfunction

//===========================================================================

function PlaySound takes string soundName returns nothing
endfunction

//===========================================================================

function CompareLocationsBJ takes location A, location B returns boolean
    return false
endfunction

//===========================================================================

function CompareRectsBJ takes rect A, rect B returns boolean
    return false
endfunction

//===========================================================================
// Returns a square rect that exactly encompasses the specified circle.
//

function GetRectFromCircleBJ takes location center, real radius returns rect
    return null
endfunction



//***************************************************************************
//*
//*  Camera Utility Functions
//*
//***************************************************************************

//===========================================================================

function GetCurrentCameraSetup takes nothing returns camerasetup
    return null
endfunction

//===========================================================================

function CameraSetupApplyForPlayer takes boolean doPan, camerasetup whichSetup, player whichPlayer, real duration returns nothing
endfunction

//===========================================================================


//===========================================================================

function CameraSetupGetFieldSwap takes camerafield whichField, camerasetup whichSetup returns real
    return 0.
endfunction

//===========================================================================

function SetCameraFieldForPlayer takes player whichPlayer, camerafield whichField, real value, real duration returns nothing
endfunction

//===========================================================================


//===========================================================================

function SetCameraTargetControllerNoZForPlayer takes player whichPlayer, unit whichUnit, real xoffset, real yoffset, boolean inheritOrientation returns nothing
endfunction

//===========================================================================

function SetCameraPositionForPlayer takes player whichPlayer, real x, real y returns nothing
endfunction

//===========================================================================

function SetCameraPositionLocForPlayer takes player whichPlayer, location loc returns nothing
endfunction

//===========================================================================

function RotateCameraAroundLocBJ takes real degrees, location loc, player whichPlayer, real duration returns nothing
endfunction

//===========================================================================

function PanCameraToForPlayer takes player whichPlayer, real x, real y returns nothing
endfunction

//===========================================================================

function PanCameraToLocForPlayer takes player whichPlayer, location loc returns nothing
endfunction

//===========================================================================

function PanCameraToTimedForPlayer takes player whichPlayer, real x, real y, real duration returns nothing
endfunction

//===========================================================================

function PanCameraToTimedLocForPlayer takes player whichPlayer, location loc, real duration returns nothing
endfunction

//===========================================================================

function PanCameraToTimedLocWithZForPlayer takes player whichPlayer, location loc, real zOffset, real duration returns nothing
endfunction

//===========================================================================

function SmartCameraPanBJ takes player whichPlayer, location loc, real duration returns nothing
endfunction

//===========================================================================

function SetCinematicCameraForPlayer takes player whichPlayer, string cameraModelFile returns nothing
endfunction

//===========================================================================

function ResetToGameCameraForPlayer takes player whichPlayer, real duration returns nothing
endfunction

//===========================================================================

function CameraSetSourceNoiseForPlayer takes player whichPlayer, real magnitude, real velocity returns nothing
endfunction

//===========================================================================

function CameraSetTargetNoiseForPlayer takes player whichPlayer, real magnitude, real velocity returns nothing
endfunction

//===========================================================================

function CameraSetEQNoiseForPlayer takes player whichPlayer, real magnitude returns nothing
endfunction

//===========================================================================

function CameraClearNoiseForPlayer takes player whichPlayer returns nothing
endfunction

//===========================================================================
// Query the current camera bounds.
//

function GetCurrentCameraBoundsMapRectBJ takes nothing returns rect
    return null
endfunction

//===========================================================================
// Query the initial camera bounds, as defined at map init.
//

function GetCameraBoundsMapRect takes nothing returns rect
    return null
endfunction

//===========================================================================
// Query the playable map area, as defined at map init.
//

function GetPlayableMapRect takes nothing returns rect
    return null
endfunction

//===========================================================================
// Query the entire map area, as defined at map init.
//

function GetEntireMapRect takes nothing returns rect
    return null
endfunction

//===========================================================================

function SetCameraBoundsToRect takes rect r returns nothing
endfunction

//===========================================================================

function SetCameraBoundsToRectForPlayerBJ takes player whichPlayer, rect r returns nothing
endfunction

//===========================================================================

function AdjustCameraBoundsBJ takes integer adjustMethod, real dxWest, real dxEast, real dyNorth, real dySouth returns nothing
endfunction

//===========================================================================

function AdjustCameraBoundsForPlayerBJ takes integer adjustMethod, player whichPlayer, real dxWest, real dxEast, real dyNorth, real dySouth returns nothing
endfunction

//===========================================================================

function SetCameraQuickPositionForPlayer takes player whichPlayer, real x, real y returns nothing
endfunction

//===========================================================================

function SetCameraQuickPositionLocForPlayer takes player whichPlayer, location loc returns nothing
endfunction

//===========================================================================

function SetCameraQuickPositionLoc takes location loc returns nothing
endfunction

//===========================================================================

function StopCameraForPlayerBJ takes player whichPlayer returns nothing
endfunction

//===========================================================================

function SetCameraOrientControllerForPlayerBJ takes player whichPlayer, unit whichUnit, real xoffset, real yoffset returns nothing
endfunction

//===========================================================================

function CameraSetSmoothingFactorBJ takes real factor returns nothing
endfunction

//===========================================================================

function CameraResetSmoothingFactorBJ takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Text Utility Functions
//*
//***************************************************************************

//===========================================================================

function DisplayTextToForce takes force toForce, string message returns nothing
endfunction

//===========================================================================

function DisplayTimedTextToForce takes force toForce, real duration, string message returns nothing
endfunction

//===========================================================================

function ClearTextMessagesBJ takes force toForce returns nothing
endfunction

//===========================================================================
// The parameters for the API Substring function are unintuitive, so this
// merely performs a translation for the starting index.
//

function SubStringBJ takes string source, integer start, integer end returns string
    return ""
endfunction  
  

function GetHandleIdBJ takes handle h returns integer
    return 0
endfunction


function StringHashBJ takes string s returns integer
    return 0
endfunction



//***************************************************************************
//*
//*  Event Registration Utility Functions
//*
//***************************************************************************

//===========================================================================

function TriggerRegisterTimerEventPeriodic takes trigger trig, real timeout returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterTimerEventSingle takes trigger trig, real timeout returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterTimerExpireEventBJ takes trigger trig, timer t returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterPlayerUnitEventSimple takes trigger trig, player whichPlayer, playerunitevent whichEvent returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterAnyUnitEventBJ takes trigger trig, playerunitevent whichEvent returns nothing
endfunction

//===========================================================================

function TriggerRegisterPlayerSelectionEventBJ takes trigger trig, player whichPlayer, boolean selected returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterPlayerKeyEventBJ takes trigger trig, player whichPlayer, integer keType, integer keKey returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterPlayerMouseEventBJ takes trigger trig, player whichPlayer, integer meType returns event
    return null
endfunction

//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================

function TriggerRegisterPlayerEventVictory takes trigger trig, player whichPlayer returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterPlayerEventDefeat takes trigger trig, player whichPlayer returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterPlayerEventLeave takes trigger trig, player whichPlayer returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterPlayerEventAllianceChanged takes trigger trig, player whichPlayer returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterPlayerEventEndCinematic takes trigger trig, player whichPlayer returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterGameStateEventTimeOfDay takes trigger trig, limitop opcode, real limitval returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterEnterRegionSimple takes trigger trig, region whichRegion returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterLeaveRegionSimple takes trigger trig, region whichRegion returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterEnterRectSimple takes trigger trig, rect r returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterLeaveRectSimple takes trigger trig, rect r returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterDistanceBetweenUnits takes trigger trig, unit whichUnit, boolexpr condition, real range returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterUnitInRangeSimple takes trigger trig, real range, unit whichUnit returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterUnitLifeEvent takes trigger trig, unit whichUnit, limitop opcode, real limitval returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterUnitManaEvent takes trigger trig, unit whichUnit, limitop opcode, real limitval returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterDialogEventBJ takes trigger trig, dialog whichDialog returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterShowSkillEventBJ takes trigger trig returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterBuildSubmenuEventBJ takes trigger trig returns event
    return null
endfunction

//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================

function TriggerRegisterGameLoadedEventBJ takes trigger trig returns event
    return null
endfunction

//===========================================================================

function TriggerRegisterGameSavedEventBJ takes trigger trig returns event
    return null
endfunction

//===========================================================================

function RegisterDestDeathInRegionEnum takes nothing returns nothing
endfunction

//===========================================================================

function TriggerRegisterDestDeathInRegionEvent takes trigger trig, rect r returns nothing
endfunction



//***************************************************************************
//*
//*  Environment Utility Functions
//*
//***************************************************************************

//===========================================================================

function AddWeatherEffectSaveLast takes rect where, integer effectID returns weathereffect
    return null
endfunction

//===========================================================================

function GetLastCreatedWeatherEffect takes nothing returns weathereffect
    return null
endfunction

//===========================================================================

function RemoveWeatherEffectBJ takes weathereffect whichWeatherEffect returns nothing
endfunction

//===========================================================================

function TerrainDeformationCraterBJ takes real duration, boolean permanent, location where, real radius, real depth returns terraindeformation
    return null
endfunction

//===========================================================================

function TerrainDeformationRippleBJ takes real duration, boolean limitNeg, location where, real startRadius, real endRadius, real depth, real wavePeriod, real waveWidth returns terraindeformation
    return null
endfunction

//===========================================================================

function TerrainDeformationWaveBJ takes real duration, location source, location target, real radius, real depth, real trailDelay returns terraindeformation
    return null
endfunction

//===========================================================================

function TerrainDeformationRandomBJ takes real duration, location where, real radius, real minDelta, real maxDelta, real updateInterval returns terraindeformation
    return null
endfunction

//===========================================================================

function TerrainDeformationStopBJ takes terraindeformation deformation, real duration returns nothing
endfunction

//===========================================================================

function GetLastCreatedTerrainDeformation takes nothing returns terraindeformation
    return null
endfunction

//===========================================================================

function AddLightningLoc takes string codeName, location where1, location where2 returns lightning
    return null
endfunction

//===========================================================================

function DestroyLightningBJ takes lightning whichBolt returns boolean
    return false
endfunction

//===========================================================================

function MoveLightningLoc takes lightning whichBolt, location where1, location where2 returns boolean
    return false
endfunction

//===========================================================================

function GetLightningColorABJ takes lightning whichBolt returns real
    return 0.
endfunction

//===========================================================================

function GetLightningColorRBJ takes lightning whichBolt returns real
    return 0.
endfunction

//===========================================================================

function GetLightningColorGBJ takes lightning whichBolt returns real
    return 0.
endfunction

//===========================================================================

function GetLightningColorBBJ takes lightning whichBolt returns real
    return 0.
endfunction

//===========================================================================

function SetLightningColorBJ takes lightning whichBolt, real r, real g, real b, real a returns boolean
    return false
endfunction

//===========================================================================

function GetLastCreatedLightningBJ takes nothing returns lightning
    return null
endfunction

//===========================================================================

function GetAbilityEffectBJ takes integer abilcode, effecttype t, integer index returns string
    return ""
endfunction

//===========================================================================

function GetAbilitySoundBJ takes integer abilcode, soundtype t returns string
    return ""
endfunction


//===========================================================================

function GetTerrainCliffLevelBJ takes location where returns integer
    return 0
endfunction

//===========================================================================

function GetTerrainTypeBJ takes location where returns integer
    return 0
endfunction

//===========================================================================

function GetTerrainVarianceBJ takes location where returns integer
    return 0
endfunction

//===========================================================================

function SetTerrainTypeBJ takes location where, integer terrainType, integer variation, integer area, integer shape returns nothing
endfunction

//===========================================================================

function IsTerrainPathableBJ takes location where, pathingtype t returns boolean
    return false
endfunction

//===========================================================================

function SetTerrainPathableBJ takes location where, pathingtype t, boolean flag returns nothing
endfunction

//===========================================================================

function SetWaterBaseColorBJ takes real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================


//===========================================================================        	


//===========================================================================        	


//===========================================================================        	


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================

function CreateFogModifierRectSimple takes player whichPlayer, fogstate whichFogState, rect r, boolean afterUnits returns fogmodifier
    return null
endfunction

//===========================================================================

function CreateFogModifierRadiusLocSimple takes player whichPlayer, fogstate whichFogState, location center, real radius, boolean afterUnits returns fogmodifier
    return null
endfunction

//===========================================================================
// Version of CreateFogModifierRect that assumes use of sharedVision and
// gives the option of immediately enabling the modifier, so that triggers
// can default to modifiers that are immediately enabled.
//

function CreateFogModifierRectBJ takes boolean enabled, player whichPlayer, fogstate whichFogState, rect r returns fogmodifier
    return null
endfunction

//===========================================================================
// Version of CreateFogModifierRadius that assumes use of sharedVision and
// gives the option of immediately enabling the modifier, so that triggers
// can default to modifiers that are immediately enabled.
//

function CreateFogModifierRadiusLocBJ takes boolean enabled, player whichPlayer, fogstate whichFogState, location center, real radius returns fogmodifier
    return null
endfunction

//===========================================================================

function GetLastCreatedFogModifier takes nothing returns fogmodifier
    return null
endfunction

//===========================================================================

function FogEnableOn takes nothing returns nothing
endfunction

//===========================================================================

function FogEnableOff takes nothing returns nothing
endfunction

//===========================================================================

function FogMaskEnableOn takes nothing returns nothing
endfunction

//===========================================================================

function FogMaskEnableOff takes nothing returns nothing
endfunction

//===========================================================================

function UseTimeOfDayBJ takes boolean flag returns nothing
endfunction

//===========================================================================

function SetTerrainFogExBJ takes integer style, real zstart, real zend, real density, real red, real green, real blue returns nothing
endfunction

//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================
// It refers to max opacity


//===========================================================================


//===========================================================================


//===========================================================================

function ResetTerrainFogBJ takes nothing returns nothing
endfunction

//===========================================================================

function SetDoodadAnimationBJ takes string animName, integer doodadID, real radius, location center returns nothing
endfunction

//===========================================================================

function SetDoodadAnimationRectBJ takes string animName, integer doodadID, rect r returns nothing
endfunction

//===========================================================================



//===========================================================================

function AddUnitAnimationPropertiesBJ takes boolean add, string animProperties, unit whichUnit returns nothing
endfunction

//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================



//============================================================================

function CreateImageBJ takes string file, real size, location where, real zOffset, integer imageType returns image
    return null
endfunction

//============================================================================

function ShowImageBJ takes boolean flag, image whichImage returns nothing
endfunction

//============================================================================

function SetImagePositionBJ takes image whichImage, location where, real zOffset returns nothing
endfunction

//============================================================================

function SetImageColorBJ takes image whichImage, real red, real green, real blue, real alpha returns nothing
endfunction

//============================================================================

function GetLastCreatedImage takes nothing returns image
    return null
endfunction

//============================================================================

function CreateUbersplatBJ takes location where, string name, real red, real green, real blue, real alpha, boolean forcePaused, boolean noBirthTime returns ubersplat
    return null
endfunction

//============================================================================

function ShowUbersplatBJ takes boolean flag, ubersplat whichSplat returns nothing
endfunction

//============================================================================

function GetLastCreatedUbersplat takes nothing returns ubersplat
    return null
endfunction

//============================================================================


//============================================================================


//============================================================================


//============================================================================


//============================================================================



//============================================================================



//***************************************************************************
//*
//*  Sound Utility Functions
//*
//***************************************************************************

//===========================================================================

function PlaySoundBJ takes sound soundHandle returns nothing
endfunction

//===========================================================================

function StopSoundBJ takes sound soundHandle, boolean fadeOut returns nothing
endfunction

//===========================================================================

function SetSoundVolumeBJ takes sound soundHandle, real volumePercent returns nothing
endfunction

//===========================================================================

function SetSoundOffsetBJ takes real newOffset, sound soundHandle returns nothing
endfunction

//===========================================================================

function SetSoundDistanceCutoffBJ takes sound soundHandle, real cutoff returns nothing
endfunction

//===========================================================================

function SetSoundPitchBJ takes sound soundHandle, real pitch returns nothing
endfunction

//===========================================================================

function SetSoundPositionLocBJ takes sound soundHandle, location loc, real z returns nothing
endfunction

//===========================================================================

function AttachSoundToUnitBJ takes sound soundHandle, unit whichUnit returns nothing
endfunction

//===========================================================================

function SetSoundConeAnglesBJ takes sound soundHandle, real inside, real outside, real outsideVolumePercent returns nothing
endfunction

//===========================================================================

function KillSoundWhenDoneBJ takes sound soundHandle returns nothing
endfunction

//===========================================================================

function PlaySoundAtPointBJ takes sound soundHandle, real volumePercent, location loc, real z returns nothing
endfunction

//===========================================================================

function PlaySoundOnUnitBJ takes sound soundHandle, real volumePercent, unit whichUnit returns nothing
endfunction

//===========================================================================

function PlaySoundFromOffsetBJ takes sound soundHandle, real volumePercent, real startingOffset returns nothing
endfunction

//===========================================================================

function PlayMusicBJ takes string musicFileName returns nothing
endfunction

//===========================================================================

function PlayMusicExBJ takes string musicFileName, real startingOffset, real fadeInTime returns nothing
endfunction

//===========================================================================

function SetMusicOffsetBJ takes real newOffset returns nothing
endfunction

//===========================================================================

function PlayThematicMusicBJ takes string musicName returns nothing
endfunction

//===========================================================================

function PlayThematicMusicExBJ takes string musicName, real startingOffset returns nothing
endfunction

//===========================================================================

function SetThematicMusicOffsetBJ takes real newOffset returns nothing
endfunction

//===========================================================================

function EndThematicMusicBJ takes nothing returns nothing
endfunction

//===========================================================================

function StopMusicBJ takes boolean fadeOut returns nothing
endfunction

//===========================================================================

function ResumeMusicBJ takes nothing returns nothing
endfunction

//===========================================================================

function SetMusicVolumeBJ takes real volumePercent returns nothing
endfunction

//===========================================================================


//===========================================================================

function GetSoundDurationBJ takes sound soundHandle returns real
    return 0.
endfunction

//===========================================================================

function GetSoundFileDurationBJ takes string musicFileName returns real
    return 0.
endfunction

//===========================================================================

function GetLastPlayedSound takes nothing returns sound
    return null
endfunction

//===========================================================================

function GetLastPlayedMusic takes nothing returns string
    return ""
endfunction

//===========================================================================

function VolumeGroupSetVolumeBJ takes volumegroup vgroup, real percent returns nothing
endfunction

//===========================================================================

function SetCineModeVolumeGroupsImmediateBJ takes nothing returns nothing
endfunction

//===========================================================================

function SetCineModeVolumeGroupsBJ takes nothing returns nothing
endfunction

//===========================================================================

function SetSpeechVolumeGroupsImmediateBJ takes nothing returns nothing
endfunction

//===========================================================================

function SetSpeechVolumeGroupsBJ takes nothing returns nothing
endfunction

//===========================================================================

function VolumeGroupResetImmediateBJ takes nothing returns nothing
endfunction

//===========================================================================

function VolumeGroupResetBJ takes nothing returns nothing
endfunction

//===========================================================================

function GetSoundIsPlayingBJ takes sound soundHandle returns boolean
    return false
endfunction

//===========================================================================

function WaitForSoundBJ takes sound soundHandle, real offset returns nothing
endfunction

//===========================================================================

function SetMapMusicIndexedBJ takes string musicName, integer index returns nothing
endfunction

//===========================================================================

function SetMapMusicRandomBJ takes string musicName returns nothing
endfunction

//===========================================================================

function ClearMapMusicBJ takes nothing returns nothing
endfunction

//===========================================================================

function SetStackedSoundBJ takes boolean add, sound soundHandle, rect r returns nothing
endfunction

//===========================================================================

function StartSoundForPlayerBJ takes player whichPlayer, sound soundHandle returns nothing
endfunction

//===========================================================================

function VolumeGroupSetVolumeForPlayerBJ takes player whichPlayer, volumegroup vgroup, real scale returns nothing
endfunction

//===========================================================================

function EnableDawnDusk takes boolean flag returns nothing
endfunction

//===========================================================================

function IsDawnDuskEnabled takes nothing returns boolean
    return false
endfunction



//***************************************************************************
//*
//*  Day/Night ambient sounds
//*
//***************************************************************************

//===========================================================================

function SetAmbientDaySound takes string inLabel returns nothing
endfunction

//===========================================================================

function SetAmbientNightSound takes string inLabel returns nothing
endfunction



//***************************************************************************
//*
//*  Special Effect Utility Functions
//*
//***************************************************************************

//===========================================================================

function AddSpecialEffectLocBJ takes location where, string modelName returns effect
    return null
endfunction

//===========================================================================

function AddSpecialEffectTargetUnitBJ takes string attachPointName, widget targetWidget, string modelName returns effect
    return null
endfunction

//===========================================================================
// Two distinct trigger actions can't share the same function name, so this
// dummy function simply mimics the behavior of an existing call.
//
// Commented out - Destructibles have no attachment points.
//
//function AddSpecialEffectTargetDestructableBJ takes string attachPointName, widget targetWidget, string modelName returns effect
//    return AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName)
//endfunction

//===========================================================================
// Two distinct trigger actions can't share the same function name, so this
// dummy function simply mimics the behavior of an existing call.
//
// Commented out - Items have no attachment points.
//
//function AddSpecialEffectTargetItemBJ takes string attachPointName, widget targetWidget, string modelName returns effect
//    return AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName)
//endfunction

//===========================================================================

function DestroyEffectBJ takes effect whichEffect returns nothing
endfunction

//===========================================================================

function GetLastCreatedEffectBJ takes nothing returns effect
    return null
endfunction

//===========================================================================
// Note: this function should be used in conjunction with the one below, which is the only one that is really exposed in GUI





//***************************************************************************
//*
//*  Command Button Effect Utility Functions
//*
//***************************************************************************

//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================



//***************************************************************************
//*
//*  Hero and Item Utility Functions
//*
//***************************************************************************

//===========================================================================

function GetItemLoc takes item whichItem returns location
    return null
endfunction

//===========================================================================

function GetItemLifeBJ takes widget whichWidget returns real
    return 0.
endfunction

//===========================================================================

function SetItemLifeBJ takes widget whichWidget, real life returns nothing
endfunction

//===========================================================================

function AddHeroXPSwapped takes integer xpToAdd, unit whichHero, boolean showEyeCandy returns nothing
endfunction

//===========================================================================

function SetHeroLevelBJ takes unit whichHero, integer newLevel, boolean showEyeCandy returns nothing
endfunction

//===========================================================================

function DecUnitAbilityLevelSwapped takes integer abilcode, unit whichUnit returns integer
    return 0
endfunction

//===========================================================================

function IncUnitAbilityLevelSwapped takes integer abilcode, unit whichUnit returns integer
    return 0
endfunction

//===========================================================================

function SetUnitAbilityLevelSwapped takes integer abilcode, unit whichUnit, integer level returns integer
    return 0
endfunction

//===========================================================================

function GetUnitAbilityLevelSwapped takes integer abilcode, unit whichUnit returns integer
    return 0
endfunction

//===========================================================================

function UnitHasBuffBJ takes unit whichUnit, integer buffcode returns boolean
    return false
endfunction

//===========================================================================

function UnitRemoveBuffBJ takes integer buffcode, unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function UnitAddItemSwapped takes item whichItem, unit whichHero returns boolean
    return false
endfunction

//===========================================================================

function UnitAddItemByIdSwapped takes integer itemId, unit whichHero returns item
    return null
endfunction

//===========================================================================

function UnitRemoveItemSwapped takes item whichItem, unit whichHero returns nothing
endfunction

//===========================================================================


//===========================================================================


//===========================================================================
// Translates 0-based slot indices to 1-based slot indices.
//

function UnitRemoveItemFromSlotSwapped takes integer itemSlot, unit whichHero returns item
    return null
endfunction





//===========================================================================

function CreateItemLoc takes integer itemId, location loc returns item
    return null
endfunction

//===========================================================================

function GetLastCreatedItem takes nothing returns item
    return null
endfunction

//===========================================================================

function GetLastRemovedItem takes nothing returns item
    return null
endfunction

//===========================================================================


//===========================================================================


//===========================================================================

function SetItemPositionLoc takes item whichItem, location loc returns nothing
endfunction

//===========================================================================

function GetLearnedSkillBJ takes nothing returns integer
    return 0
endfunction

//===========================================================================

function SuspendHeroXPBJ takes boolean flag, unit whichHero returns nothing
endfunction

//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================

function SetPlayerHandicapXPBJ takes player whichPlayer, real handicapPercent returns nothing
endfunction

//===========================================================================

function GetPlayerHandicapXPBJ takes player whichPlayer returns real
    return 0.
endfunction

//===========================================================================

function SetPlayerHandicapBJ takes player whichPlayer, real handicapPercent returns nothing
endfunction

//===========================================================================

function GetPlayerHandicapBJ takes player whichPlayer returns real
    return 0.
endfunction

//===========================================================================

function GetHeroStatBJ takes integer whichStat, unit whichHero, boolean includeBonuses returns integer
    return 0
endfunction

//===========================================================================

function SetHeroStat takes unit whichHero, integer whichStat, integer value returns nothing
endfunction

//===========================================================================

function ModifyHeroStat takes integer whichStat, unit whichHero, integer modifyMethod, integer value returns nothing
endfunction

//===========================================================================

function ModifyHeroSkillPoints takes unit whichHero, integer modifyMethod, integer value returns boolean
    return false
endfunction

//===========================================================================

function UnitDropItemPointBJ takes unit whichUnit, item whichItem, real x, real y returns boolean
    return false
endfunction

//===========================================================================

function UnitDropItemPointLoc takes unit whichUnit, item whichItem, location loc returns boolean
    return false
endfunction

//===========================================================================

function UnitDropItemSlotBJ takes unit whichUnit, item whichItem, integer slot returns boolean
    return false
endfunction

//===========================================================================

function UnitDropItemTargetBJ takes unit whichUnit, item whichItem, widget target returns boolean
    return false
endfunction

//===========================================================================
// Two distinct trigger actions can't share the same function name, so this
// dummy function simply mimics the behavior of an existing call.
//

function UnitUseItemDestructable takes unit whichUnit, item whichItem, widget target returns boolean
    return false
endfunction

//===========================================================================

function UnitUseItemPointLoc takes unit whichUnit, item whichItem, location loc returns boolean
    return false
endfunction

//===========================================================================
// Translates 0-based slot indices to 1-based slot indices.
//

function UnitItemInSlotBJ takes unit whichUnit, integer itemSlot returns item
    return null
endfunction





//===========================================================================
// Translates 0-based slot indices to 1-based slot indices.
//

function GetInventoryIndexOfItemTypeBJ takes unit whichUnit, integer itemId returns integer
    return 0
endfunction

//===========================================================================

function GetItemOfTypeFromUnitBJ takes unit whichUnit, integer itemId returns item
    return null
endfunction

//===========================================================================

function UnitHasItemOfTypeBJ takes unit whichUnit, integer itemId returns boolean
    return false
endfunction

//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================

function UnitInventoryCount takes unit whichUnit returns integer
    return 0
endfunction

//===========================================================================

function UnitInventorySizeBJ takes unit whichUnit returns integer
    return 0
endfunction

//===========================================================================



//===========================================================================


//===========================================================================


//===========================================================================

function SetItemInvulnerableBJ takes item whichItem, boolean flag returns nothing
endfunction

//===========================================================================

function SetItemDropOnDeathBJ takes item whichItem, boolean flag returns nothing
endfunction

//===========================================================================

function SetItemDroppableBJ takes item whichItem, boolean flag returns nothing
endfunction

//===========================================================================

function SetItemPlayerBJ takes item whichItem, player whichPlayer, boolean changeColor returns nothing
endfunction

//===========================================================================

function SetItemVisibleBJ takes boolean show, item whichItem returns nothing
endfunction

//===========================================================================

function IsItemHiddenBJ takes item whichItem returns boolean
    return false
endfunction

//===========================================================================

function ChooseRandomItemBJ takes integer level returns integer
    return 0
endfunction

//===========================================================================

function ChooseRandomItemExBJ takes integer level, itemtype whichType returns integer
    return 0
endfunction

//===========================================================================


//===========================================================================

function ChooseRandomNPBuildingBJ takes nothing returns integer
    return 0
endfunction

//===========================================================================

function ChooseRandomCreepBJ takes integer level returns integer
    return 0
endfunction

//===========================================================================

function EnumItemsInRectBJ takes rect r, code actionFunc returns nothing
endfunction

//===========================================================================
// See GroupPickRandomUnitEnum for the details of this algorithm.
//

function RandomItemInRectBJEnum takes nothing returns nothing
endfunction

//===========================================================================
// Picks a random item from within a rect, matching a condition
//

function RandomItemInRectBJ takes rect r, boolexpr filter returns item
    return null
endfunction

//===========================================================================
// Picks a random item from within a rect
//

function RandomItemInRectSimpleBJ takes rect r returns item
    return null
endfunction

//===========================================================================

function CheckItemStatus takes item whichItem, integer status returns boolean
    return false
endfunction

//===========================================================================

function CheckItemcodeStatus takes integer itemId, integer status returns boolean
    return false
endfunction



//***************************************************************************
//*
//*  Unit Utility Functions
//*
//***************************************************************************

//===========================================================================

function UnitId2OrderIdBJ takes integer unitId returns integer
    return 0
endfunction

//===========================================================================

function String2UnitIdBJ takes string unitIdString returns integer
    return 0
endfunction

//===========================================================================

function UnitId2StringBJ takes integer unitId returns string
    return ""
endfunction

//===========================================================================

function String2OrderIdBJ takes string orderIdString returns integer
    return 0
endfunction

//===========================================================================

function OrderId2StringBJ takes integer orderId returns string
    return ""
endfunction

//===========================================================================

function GetIssuedOrderIdBJ takes nothing returns integer
    return 0
endfunction

//===========================================================================

function GetKillingUnitBJ takes nothing returns unit
    return null
endfunction

//===========================================================================

function CreateUnitAtLocSaveLast takes player id, integer unitid, location loc, real face returns unit
    return null
endfunction

//===========================================================================

function GetLastCreatedUnit takes nothing returns unit
    return null
endfunction

//===========================================================================

function CreateNUnitsAtLoc takes integer count, integer unitId, player whichPlayer, location loc, real face returns group
    return null
endfunction

//===========================================================================

function CreateNUnitsAtLocFacingLocBJ takes integer count, integer unitId, player whichPlayer, location loc, location lookAt returns group
    return null
endfunction

//===========================================================================

function GetLastCreatedGroupEnum takes nothing returns nothing
endfunction

//===========================================================================

function GetLastCreatedGroup takes nothing returns group
    return null
endfunction

//===========================================================================

function CreateCorpseLocBJ takes integer unitid, player whichPlayer, location loc returns unit
    return null
endfunction

//===========================================================================

function UnitSuspendDecayBJ takes boolean suspend, unit whichUnit returns nothing
endfunction

//===========================================================================

function DelayedSuspendDecayStopAnimEnum takes nothing returns nothing
endfunction

//===========================================================================

function DelayedSuspendDecayBoneEnum takes nothing returns nothing
endfunction

//===========================================================================
// Game code explicitly sets the animation back to "decay bone" after the
// initial corpse fades away, so we reset it now.  It's best not to show
// off corpses thus created until after this grace period has passed.
//

function DelayedSuspendDecayFleshEnum takes nothing returns nothing
endfunction

//===========================================================================
// Waits a short period of time to ensure that the corpse is decaying, and
// then suspend the animation and corpse decay.
//

function DelayedSuspendDecay takes nothing returns nothing
endfunction

//===========================================================================

function DelayedSuspendDecayCreate takes nothing returns nothing
endfunction

//===========================================================================

function CreatePermanentCorpseLocBJ takes integer style, integer unitid, player whichPlayer, location loc, real facing returns unit
    return null
endfunction

//===========================================================================

function GetUnitStateSwap takes unitstate whichState, unit whichUnit returns real
    return 0.
endfunction

//===========================================================================

function GetUnitStatePercent takes unit whichUnit, unitstate whichState, unitstate whichMaxState returns real
    return 0.
endfunction

//===========================================================================

function GetUnitLifePercent takes unit whichUnit returns real
    return 0.
endfunction

//===========================================================================

function GetUnitManaPercent takes unit whichUnit returns real
    return 0.
endfunction

//===========================================================================

function SelectUnitSingle takes unit whichUnit returns nothing
endfunction

//===========================================================================

function SelectGroupBJEnum takes nothing returns nothing
endfunction

//===========================================================================

function SelectGroupBJ takes group g returns nothing
endfunction

//===========================================================================

function SelectUnitAdd takes unit whichUnit returns nothing
endfunction

//===========================================================================

function SelectUnitRemove takes unit whichUnit returns nothing
endfunction

//===========================================================================

function ClearSelectionForPlayer takes player whichPlayer returns nothing
endfunction

//===========================================================================

function SelectUnitForPlayerSingle takes unit whichUnit, player whichPlayer returns nothing
endfunction

//===========================================================================

function SelectGroupForPlayerBJ takes group g, player whichPlayer returns nothing
endfunction

//===========================================================================

function SelectUnitAddForPlayer takes unit whichUnit, player whichPlayer returns nothing
endfunction

//===========================================================================

function SelectUnitRemoveForPlayer takes unit whichUnit, player whichPlayer returns nothing
endfunction

//===========================================================================

function SetUnitLifeBJ takes unit whichUnit, real newValue returns nothing
endfunction

//===========================================================================

function SetUnitManaBJ takes unit whichUnit, real newValue returns nothing
endfunction

//===========================================================================

function SetUnitLifePercentBJ takes unit whichUnit, real percent returns nothing
endfunction

//===========================================================================

function SetUnitManaPercentBJ takes unit whichUnit, real percent returns nothing
endfunction

//===========================================================================

function IsUnitDeadBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function IsUnitAliveBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function IsUnitGroupDeadBJEnum takes nothing returns nothing
endfunction

//===========================================================================
// Returns true if every unit of the group is dead.
//

function IsUnitGroupDeadBJ takes group g returns boolean
    return false
endfunction

//===========================================================================

function IsUnitGroupEmptyBJEnum takes nothing returns nothing
endfunction

//===========================================================================
// Returns true if the group contains no units.
//

function IsUnitGroupEmptyBJ takes group g returns boolean
    return false
endfunction

//===========================================================================

function IsUnitGroupInRectBJEnum takes nothing returns nothing
endfunction

//===========================================================================
// Returns true if every unit of the group is within the given rect.
//

function IsUnitGroupInRectBJ takes group g, rect r returns boolean
    return false
endfunction

//===========================================================================

function IsUnitHiddenBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function ShowUnitHide takes unit whichUnit returns nothing
endfunction

//===========================================================================

function ShowUnitShow takes unit whichUnit returns nothing
endfunction

//===========================================================================

function IssueHauntOrderAtLocBJFilter takes nothing returns boolean
    return false
endfunction

//===========================================================================

function IssueHauntOrderAtLocBJ takes unit whichPeon, location loc returns boolean
    return false
endfunction

//===========================================================================

function IssueBuildOrderByIdLocBJ takes unit whichPeon, integer unitId, location loc returns boolean
    return false
endfunction

//===========================================================================

function IssueTrainOrderByIdBJ takes unit whichUnit, integer unitId returns boolean
    return false
endfunction

//===========================================================================

function GroupTrainOrderByIdBJ takes group g, integer unitId returns boolean
    return false
endfunction

//===========================================================================

function IssueUpgradeOrderByIdBJ takes unit whichUnit, integer techId returns boolean
    return false
endfunction

//===========================================================================

function GetAttackedUnitBJ takes nothing returns unit
    return null
endfunction

//===========================================================================

function SetUnitFlyHeightBJ takes unit whichUnit, real newHeight, real rate returns nothing
endfunction

//===========================================================================

function SetUnitTurnSpeedBJ takes unit whichUnit, real turnSpeed returns nothing
endfunction

//===========================================================================

function SetUnitPropWindowBJ takes unit whichUnit, real propWindow returns nothing
endfunction

//===========================================================================

function GetUnitPropWindowBJ takes unit whichUnit returns real
    return 0.
endfunction

//===========================================================================

function GetUnitDefaultPropWindowBJ takes unit whichUnit returns real
    return 0.
endfunction

//===========================================================================

function SetUnitBlendTimeBJ takes unit whichUnit, real blendTime returns nothing
endfunction

//===========================================================================

function SetUnitAcquireRangeBJ takes unit whichUnit, real acquireRange returns nothing
endfunction

//===========================================================================

function UnitSetCanSleepBJ takes unit whichUnit, boolean canSleep returns nothing
endfunction

//===========================================================================

function UnitCanSleepBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function UnitWakeUpBJ takes unit whichUnit returns nothing
endfunction

//===========================================================================

function UnitIsSleepingBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function WakePlayerUnitsEnum takes nothing returns nothing
endfunction

//===========================================================================

function WakePlayerUnits takes player whichPlayer returns nothing
endfunction

//===========================================================================

function EnableCreepSleepBJ takes boolean enable returns nothing
endfunction

//===========================================================================

function UnitGenerateAlarms takes unit whichUnit, boolean generate returns boolean
    return false
endfunction

//===========================================================================

function DoesUnitGenerateAlarms takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function PauseAllUnitsBJEnum takes nothing returns nothing
endfunction

//===========================================================================
// Pause all units 

function PauseAllUnitsBJ takes boolean pause returns nothing
endfunction

//===========================================================================

function PauseUnitBJ takes boolean pause, unit whichUnit returns nothing
endfunction

//===========================================================================

function IsUnitPausedBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================


//===========================================================================


//===========================================================================

function UnitPauseTimedLifeBJ takes boolean flag, unit whichUnit returns nothing
endfunction

//===========================================================================

function UnitApplyTimedLifeBJ takes real duration, integer buffId, unit whichUnit returns nothing
endfunction

//===========================================================================

function UnitShareVisionBJ takes boolean share, unit whichUnit, player whichPlayer returns nothing
endfunction

//===========================================================================

function UnitRemoveBuffsBJ takes integer buffType, unit whichUnit returns nothing
endfunction

//===========================================================================

function UnitRemoveBuffsExBJ takes integer polarity, integer resist, unit whichUnit, boolean bTLife, boolean bAura returns nothing
endfunction

//===========================================================================

function UnitCountBuffsExBJ takes integer polarity, integer resist, unit whichUnit, boolean bTLife, boolean bAura returns integer
    return 0
endfunction

//===========================================================================

function UnitRemoveAbilityBJ takes integer abilityId, unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function UnitAddAbilityBJ takes integer abilityId, unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function UnitRemoveTypeBJ takes unittype whichType, unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function UnitAddTypeBJ takes unittype whichType, unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function UnitMakeAbilityPermanentBJ takes boolean permanent, integer abilityId, unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function SetUnitExplodedBJ takes unit whichUnit, boolean exploded returns nothing
endfunction

//===========================================================================

function ExplodeUnitBJ takes unit whichUnit returns nothing
endfunction

//===========================================================================

function GetTransportUnitBJ takes nothing returns unit
    return null
endfunction

//===========================================================================

function GetLoadedUnitBJ takes nothing returns unit
    return null
endfunction

//===========================================================================

function IsUnitInTransportBJ takes unit whichUnit, unit whichTransport returns boolean
    return false
endfunction

//===========================================================================

function IsUnitLoadedBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================

function IsUnitIllusionBJ takes unit whichUnit returns boolean
    return false
endfunction

//===========================================================================
// This attempts to replace a unit with a new unit type by creating a new
// unit of the desired type using the old unit's location, facing, etc.
//

function ReplaceUnitBJ takes unit whichUnit, integer newUnitId, integer unitStateMethod returns unit
    return null
endfunction

//===========================================================================

function GetLastReplacedUnitBJ takes nothing returns unit
    return null
endfunction

//===========================================================================

function SetUnitPositionLocFacingBJ takes unit whichUnit, location loc, real facing returns nothing
endfunction

//===========================================================================

function SetUnitPositionLocFacingLocBJ takes unit whichUnit, location loc, location lookAt returns nothing
endfunction

//===========================================================================

function AddItemToStockBJ takes integer itemId, unit whichUnit, integer currentStock, integer stockMax returns nothing
endfunction

//===========================================================================

function AddUnitToStockBJ takes integer unitId, unit whichUnit, integer currentStock, integer stockMax returns nothing
endfunction

//===========================================================================

function RemoveItemFromStockBJ takes integer itemId, unit whichUnit returns nothing
endfunction

//===========================================================================

function RemoveUnitFromStockBJ takes integer unitId, unit whichUnit returns nothing
endfunction

//===========================================================================

function SetUnitUseFoodBJ takes boolean enable, unit whichUnit returns nothing
endfunction

//===========================================================================

function UnitDamagePointLoc takes unit whichUnit, real delay, real radius, location loc, real amount, attacktype whichAttack, damagetype whichDamage returns boolean
    return false
endfunction

//===========================================================================

function UnitDamageTargetBJ takes unit whichUnit, unit target, real amount, attacktype whichAttack, damagetype whichDamage returns boolean
    return false
endfunction



//***************************************************************************
//*
//*  Destructable Utility Functions
//*
//***************************************************************************

//===========================================================================

function CreateDestructableLoc takes integer objectid, location loc, real facing, real scale, integer variation returns destructable
    return null
endfunction

//===========================================================================

function CreateDeadDestructableLocBJ takes integer objectid, location loc, real facing, real scale, integer variation returns destructable
    return null
endfunction

//===========================================================================

function GetLastCreatedDestructable takes nothing returns destructable
    return null
endfunction

//===========================================================================

function ShowDestructableBJ takes boolean flag, destructable d returns nothing
endfunction

//===========================================================================

function SetDestructableInvulnerableBJ takes destructable d, boolean flag returns nothing
endfunction

//===========================================================================

function IsDestructableInvulnerableBJ takes destructable d returns boolean
    return false
endfunction

//===========================================================================

function GetDestructableLoc takes destructable whichDestructable returns location
    return null
endfunction

//===========================================================================

function EnumDestructablesInRectAll takes rect r, code actionFunc returns nothing
endfunction

//===========================================================================

function EnumDestructablesInCircleBJFilter takes nothing returns boolean
    return false
endfunction

//===========================================================================

function IsDestructableDeadBJ takes destructable d returns boolean
    return false
endfunction

//===========================================================================

function IsDestructableAliveBJ takes destructable d returns boolean
    return false
endfunction

//===========================================================================
// See GroupPickRandomUnitEnum for the details of this algorithm.
//

function RandomDestructableInRectBJEnum takes nothing returns nothing
endfunction

//===========================================================================
// Picks a random destructable from within a rect, matching a condition
//

function RandomDestructableInRectBJ takes rect r, boolexpr filter returns destructable
    return null
endfunction

//===========================================================================
// Picks a random destructable from within a rect
//

function RandomDestructableInRectSimpleBJ takes rect r returns destructable
    return null
endfunction

//===========================================================================
// Enumerates within a rect, with a filter to narrow the enumeration down
// objects within a circular area.
//

function EnumDestructablesInCircleBJ takes real radius, location loc, code actionFunc returns nothing
endfunction

//===========================================================================

function SetDestructableLifePercentBJ takes destructable d, real percent returns nothing
endfunction

//===========================================================================

function SetDestructableMaxLifeBJ takes destructable d, real max returns nothing
endfunction

//===========================================================================

function ModifyGateBJ takes integer gateOperation, destructable d returns nothing
endfunction

//===========================================================================
// Determine the elevator's height from its occlusion height.
//

function GetElevatorHeight takes destructable d returns integer
    return 0
endfunction

//===========================================================================
// To properly animate an elevator, we must know not only what height we
// want to change to, but also what height we are currently at.  This code
// determines the elevator's current height from its occlusion height.
// Arbitrarily changing an elevator's occlusion height is thus inadvisable.
//

function ChangeElevatorHeight takes destructable d, integer newHeight returns nothing
endfunction

//===========================================================================
// Grab the unit and throw his own coords in his face, forcing him to push
// and shove until he finds a spot where noone will bother him.
//

function NudgeUnitsInRectEnum takes nothing returns nothing
endfunction

//===========================================================================

function NudgeItemsInRectEnum takes nothing returns nothing
endfunction

//===========================================================================
// Nudge the items and units within a given rect ever so gently, so as to
// encourage them to find locations where they can peacefully coexist with
// pathing restrictions and live happy, fruitful lives.
//

function NudgeObjectsInRect takes rect nudgeArea returns nothing
endfunction

//===========================================================================

function NearbyElevatorExistsEnum takes nothing returns nothing
endfunction

//===========================================================================

function NearbyElevatorExists takes real x, real y returns boolean
    return false
endfunction

//===========================================================================

function FindElevatorWallBlockerEnum takes nothing returns nothing
endfunction

//===========================================================================
// This toggles pathing on or off for one wall of an elevator by killing
// or reviving a pathing blocker at the appropriate location (and creating
// the pathing blocker in the first place, if it does not yet exist).
//

function ChangeElevatorWallBlocker takes real x, real y, real facing, boolean open returns nothing
endfunction

//===========================================================================

function ChangeElevatorWalls takes boolean open, integer walls, destructable d returns nothing
endfunction



//***************************************************************************
//*
//*  Neutral Building Utility Functions
//*
//***************************************************************************

//===========================================================================

function WaygateActivateBJ takes boolean activate, unit waygate returns nothing
endfunction

//===========================================================================

function WaygateIsActiveBJ takes unit waygate returns boolean
    return false
endfunction

//===========================================================================

function WaygateSetDestinationLocBJ takes unit waygate, location loc returns nothing
endfunction

//===========================================================================

function WaygateGetDestinationLocBJ takes unit waygate returns location
    return null
endfunction

//===========================================================================

function UnitSetUsesAltIconBJ takes boolean flag, unit whichUnit returns nothing
endfunction



//***************************************************************************
//*
//*  UI Utility Functions
//*
//***************************************************************************

//===========================================================================

function ForceUIKeyBJ takes player whichPlayer, string key returns nothing
endfunction

//===========================================================================

function ForceUICancelBJ takes player whichPlayer returns nothing
endfunction



//***************************************************************************
//*
//*  Group and Force Utility Functions
//*
//***************************************************************************

//===========================================================================

function ForGroupBJ takes group whichGroup, code callback returns nothing
endfunction

//===========================================================================

function GroupAddUnitSimple takes unit whichUnit, group whichGroup returns nothing
endfunction

//===========================================================================

function GroupRemoveUnitSimple takes unit whichUnit, group whichGroup returns nothing
endfunction

//===========================================================================

function GroupAddGroupEnum takes nothing returns nothing
endfunction

//===========================================================================

function GroupAddGroup takes group sourceGroup, group destGroup returns nothing
endfunction

//===========================================================================

function GroupRemoveGroupEnum takes nothing returns nothing
endfunction

//===========================================================================

function GroupRemoveGroup takes group sourceGroup, group destGroup returns nothing
endfunction

//===========================================================================

function ForceAddPlayerSimple takes player whichPlayer, force whichForce returns nothing
endfunction

//===========================================================================

function ForceRemovePlayerSimple takes player whichPlayer, force whichForce returns nothing
endfunction

//===========================================================================
// Consider each unit, one at a time, keeping a "current pick".   Once all units
// are considered, this "current pick" will be the resulting random unit.
//
// The chance of picking a given unit over the "current pick" is 1/N, where N is
// the number of units considered thusfar (including the current consideration).
//

function GroupPickRandomUnitEnum takes nothing returns nothing
endfunction

//===========================================================================
// Picks a random unit from a group.
//

function GroupPickRandomUnit takes group whichGroup returns unit
    return null
endfunction

//===========================================================================
// See GroupPickRandomUnitEnum for the details of this algorithm.
//

function ForcePickRandomPlayerEnum takes nothing returns nothing
endfunction

//===========================================================================
// Picks a random player from a force.
//

function ForcePickRandomPlayer takes force whichForce returns player
    return null
endfunction

//===========================================================================

function EnumUnitsSelected takes player whichPlayer, boolexpr enumFilter, code enumAction returns nothing
endfunction

//===========================================================================

function GetUnitsInRectMatching takes rect r, boolexpr filter returns group
    return null
endfunction

//===========================================================================

function GetUnitsInRectAll takes rect r returns group
    return null
endfunction

//===========================================================================

function GetUnitsInRectOfPlayerFilter takes nothing returns boolean
    return false
endfunction

//===========================================================================

function GetUnitsInRectOfPlayer takes rect r, player whichPlayer returns group
    return null
endfunction

//===========================================================================

function GetUnitsInRangeOfLocMatching takes real radius, location whichLocation, boolexpr filter returns group
    return null
endfunction

//===========================================================================

function GetUnitsInRangeOfLocAll takes real radius, location whichLocation returns group
    return null
endfunction

//===========================================================================

function GetUnitsOfTypeIdAllFilter takes nothing returns boolean
    return false
endfunction

//===========================================================================

function GetUnitsOfTypeIdAll takes integer unitid returns group
    return null
endfunction

//===========================================================================

function GetUnitsOfPlayerMatching takes player whichPlayer, boolexpr filter returns group
    return null
endfunction

//===========================================================================

function GetUnitsOfPlayerAll takes player whichPlayer returns group
    return null
endfunction

//===========================================================================

function GetUnitsOfPlayerAndTypeIdFilter takes nothing returns boolean
    return false
endfunction

//===========================================================================

function GetUnitsOfPlayerAndTypeId takes player whichPlayer, integer unitid returns group
    return null
endfunction

//===========================================================================

function GetUnitsSelectedAll takes player whichPlayer returns group
    return null
endfunction

//===========================================================================

function GetForceOfPlayer takes player whichPlayer returns force
    return null
endfunction

//===========================================================================

function GetPlayersAll takes nothing returns force
    return null
endfunction

//===========================================================================

function GetPlayersByMapControl takes mapcontrol whichControl returns force
    return null
endfunction

//===========================================================================

function GetPlayersAllies takes player whichPlayer returns force
    return null
endfunction

//===========================================================================

function GetPlayersEnemies takes player whichPlayer returns force
    return null
endfunction

//===========================================================================

function GetPlayersMatching takes boolexpr filter returns force
    return null
endfunction

//===========================================================================

function CountUnitsInGroupEnum takes nothing returns nothing
endfunction

//===========================================================================

function CountUnitsInGroup takes group g returns integer
    return 0
endfunction

//===========================================================================

function CountPlayersInForceEnum takes nothing returns nothing
endfunction

//===========================================================================

function CountPlayersInForceBJ takes force f returns integer
    return 0
endfunction

//===========================================================================

function GetRandomSubGroupEnum takes nothing returns nothing
endfunction

//===========================================================================

function GetRandomSubGroup takes integer count, group sourceGroup returns group
    return null
endfunction

//===========================================================================

function LivingPlayerUnitsOfTypeIdFilter takes nothing returns boolean
    return false
endfunction

//===========================================================================

function CountLivingPlayerUnitsOfTypeId takes integer unitId, player whichPlayer returns integer
    return 0
endfunction



//***************************************************************************
//*
//*  Animation Utility Functions
//*
//***************************************************************************

//===========================================================================

function ResetUnitAnimation takes unit whichUnit returns nothing
endfunction

//===========================================================================

function SetUnitTimeScalePercent takes unit whichUnit, real percentScale returns nothing
endfunction

//===========================================================================

function SetUnitScalePercent takes unit whichUnit, real percentScaleX, real percentScaleY, real percentScaleZ returns nothing
endfunction

//===========================================================================
// This version differs from the common.j interface in that the alpha value
// is reversed so as to be displayed as transparency, and all four parameters
// are treated as percentages rather than bytes.
//

function SetUnitVertexColorBJ takes unit whichUnit, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function UnitAddIndicatorBJ takes unit whichUnit, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function DestructableAddIndicatorBJ takes destructable whichDestructable, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function ItemAddIndicatorBJ takes item whichItem, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================
// Sets a unit's facing to point directly at a location.
//

function SetUnitFacingToFaceLocTimed takes unit whichUnit, location target, real duration returns nothing
endfunction

//===========================================================================
// Sets a unit's facing to point directly at another unit.
//

function SetUnitFacingToFaceUnitTimed takes unit whichUnit, unit target, real duration returns nothing
endfunction

//===========================================================================

function QueueUnitAnimationBJ takes unit whichUnit, string whichAnimation returns nothing
endfunction

//===========================================================================
// This version differs from the common.j interface in that the alpha value
// is reversed so as to be displayed as transparency, and all four parameters
// are treated as percentages rather than bytes.
//


//===========================================================================

function SetDestructableAnimationBJ takes destructable d, string whichAnimation returns nothing
endfunction

//===========================================================================

function QueueDestructableAnimationBJ takes destructable d, string whichAnimation returns nothing
endfunction

//===========================================================================

function SetDestAnimationSpeedPercent takes destructable d, real percentScale returns nothing
endfunction



//***************************************************************************
//*
//*  Dialog Utility Functions
//*
//***************************************************************************

//===========================================================================

function DialogDisplayBJ takes boolean flag, dialog whichDialog, player whichPlayer returns nothing
endfunction

//===========================================================================

function DialogSetMessageBJ takes dialog whichDialog, string message returns nothing
endfunction

//===========================================================================

function DialogAddButtonBJ takes dialog whichDialog, string buttonText returns button
    return null
endfunction

//===========================================================================

function DialogAddButtonWithHotkeyBJ takes dialog whichDialog, string buttonText, integer hotkey returns button
    return null
endfunction

//===========================================================================

function DialogClearBJ takes dialog whichDialog returns nothing
endfunction

//===========================================================================

function GetLastCreatedButtonBJ takes nothing returns button
    return null
endfunction

//===========================================================================

function GetClickedButtonBJ takes nothing returns button
    return null
endfunction

//===========================================================================

function GetClickedDialogBJ takes nothing returns dialog
    return null
endfunction



//***************************************************************************
//*
//*  Alliance Utility Functions
//*
//***************************************************************************

//===========================================================================

function SetPlayerAllianceBJ takes player sourcePlayer, alliancetype whichAllianceSetting, boolean value, player otherPlayer returns nothing
endfunction

//===========================================================================
// Set all flags used by the in-game "Ally" checkbox.
//

function SetPlayerAllianceStateAllyBJ takes player sourcePlayer, player otherPlayer, boolean flag returns nothing
endfunction

//===========================================================================
// Set all flags used by the in-game "Shared Vision" checkbox.
//

function SetPlayerAllianceStateVisionBJ takes player sourcePlayer, player otherPlayer, boolean flag returns nothing
endfunction

//===========================================================================
// Set all flags used by the in-game "Shared Units" checkbox.
//

function SetPlayerAllianceStateControlBJ takes player sourcePlayer, player otherPlayer, boolean flag returns nothing
endfunction

//===========================================================================
// Set all flags used by the in-game "Shared Units" checkbox with the Full
// Shared Unit Control feature enabled.
//

function SetPlayerAllianceStateFullControlBJ takes player sourcePlayer, player otherPlayer, boolean flag returns nothing
endfunction

//===========================================================================

function SetPlayerAllianceStateBJ takes player sourcePlayer, player otherPlayer, integer allianceState returns nothing
endfunction

//===========================================================================
// Set the alliance states for an entire force towards another force.
//

function SetForceAllianceStateBJ takes force sourceForce, force targetForce, integer allianceState returns nothing
endfunction

//===========================================================================
// Test to see if two players are co-allied (allied with each other).
//

function PlayersAreCoAllied takes player playerA, player playerB returns boolean
    return false
endfunction

//===========================================================================
// Force (whichPlayer) AI player to share vision and advanced unit control 
// with all AI players of its allies.
//

function ShareEverythingWithTeamAI takes player whichPlayer returns nothing
endfunction

//===========================================================================
// Force (whichPlayer) to share vision and advanced unit control with all of his/her allies.
//

function ShareEverythingWithTeam takes player whichPlayer returns nothing
endfunction

//===========================================================================
// Creates a 'Neutral Victim' player slot.  This slot is passive towards all
// other players, but all other players are aggressive towards him/her.
// 

function ConfigureNeutralVictim takes nothing returns nothing
endfunction

//===========================================================================

function MakeUnitsPassiveForPlayerEnum takes nothing returns nothing
endfunction

//===========================================================================
// Change ownership for every unit of (whichPlayer)'s team to neutral passive.
//

function MakeUnitsPassiveForPlayer takes player whichPlayer returns nothing
endfunction

//===========================================================================
// Change ownership for every unit of (whichPlayer)'s team to neutral passive.
//

function MakeUnitsPassiveForTeam takes player whichPlayer returns nothing
endfunction

//===========================================================================
// Determine whether or not victory/defeat is disabled via cheat codes.
//

function AllowVictoryDefeat takes playergameresult gameResult returns boolean
    return false
endfunction

//===========================================================================

function EndGameBJ takes nothing returns nothing
endfunction

//===========================================================================

function MeleeVictoryDialogBJ takes player whichPlayer, boolean leftGame returns nothing
endfunction

//===========================================================================

function MeleeDefeatDialogBJ takes player whichPlayer, boolean leftGame returns nothing
endfunction

//===========================================================================

function GameOverDialogBJ takes player whichPlayer, boolean leftGame returns nothing
endfunction

//===========================================================================

function RemovePlayerPreserveUnitsBJ takes player whichPlayer, playergameresult gameResult, boolean leftGame returns nothing
endfunction

//===========================================================================

function CustomVictoryOkBJ takes nothing returns nothing
endfunction

//===========================================================================

function CustomVictoryQuitBJ takes nothing returns nothing
endfunction

//===========================================================================

function CustomVictoryDialogBJ takes player whichPlayer returns nothing
endfunction

//===========================================================================

function CustomVictorySkipBJ takes player whichPlayer returns nothing
endfunction

//===========================================================================

function CustomVictoryBJ takes player whichPlayer, boolean showDialog, boolean showScores returns nothing
endfunction

//===========================================================================

function CustomDefeatRestartBJ takes nothing returns nothing
endfunction

//===========================================================================

function CustomDefeatReduceDifficultyBJ takes nothing returns nothing
endfunction

//===========================================================================

function CustomDefeatLoadBJ takes nothing returns nothing
endfunction

//===========================================================================

function CustomDefeatQuitBJ takes nothing returns nothing
endfunction

//===========================================================================

function CustomDefeatDialogBJ takes player whichPlayer, string message returns nothing
endfunction

//===========================================================================

function CustomDefeatBJ takes player whichPlayer, string message returns nothing
endfunction

//===========================================================================

function SetNextLevelBJ takes string nextLevel returns nothing
endfunction

//===========================================================================

function SetPlayerOnScoreScreenBJ takes boolean flag, player whichPlayer returns nothing
endfunction



//***************************************************************************
//*
//*  Quest Utility Functions
//*
//***************************************************************************

//===========================================================================

function CreateQuestBJ takes integer questType, string title, string description, string iconPath returns quest
    return null
endfunction

//===========================================================================

function DestroyQuestBJ takes quest whichQuest returns nothing
endfunction

//===========================================================================

function QuestSetEnabledBJ takes boolean enabled, quest whichQuest returns nothing
endfunction

//===========================================================================

function QuestSetTitleBJ takes quest whichQuest, string title returns nothing
endfunction

//===========================================================================

function QuestSetDescriptionBJ takes quest whichQuest, string description returns nothing
endfunction

//===========================================================================

function QuestSetCompletedBJ takes quest whichQuest, boolean completed returns nothing
endfunction

//===========================================================================

function QuestSetFailedBJ takes quest whichQuest, boolean failed returns nothing
endfunction

//===========================================================================

function QuestSetDiscoveredBJ takes quest whichQuest, boolean discovered returns nothing
endfunction

//===========================================================================

function GetLastCreatedQuestBJ takes nothing returns quest
    return null
endfunction

//===========================================================================

function CreateQuestItemBJ takes quest whichQuest, string description returns questitem
    return null
endfunction

//===========================================================================

function QuestItemSetDescriptionBJ takes questitem whichQuestItem, string description returns nothing
endfunction

//===========================================================================

function QuestItemSetCompletedBJ takes questitem whichQuestItem, boolean completed returns nothing
endfunction

//===========================================================================

function GetLastCreatedQuestItemBJ takes nothing returns questitem
    return null
endfunction

//===========================================================================

function CreateDefeatConditionBJ takes string description returns defeatcondition
    return null
endfunction

//===========================================================================

function DestroyDefeatConditionBJ takes defeatcondition whichCondition returns nothing
endfunction

//===========================================================================

function DefeatConditionSetDescriptionBJ takes defeatcondition whichCondition, string description returns nothing
endfunction

//===========================================================================

function GetLastCreatedDefeatConditionBJ takes nothing returns defeatcondition
    return null
endfunction

//===========================================================================

function FlashQuestDialogButtonBJ takes nothing returns nothing
endfunction

//===========================================================================

function QuestMessageBJ takes force f, integer messageType, string message returns nothing
endfunction



//***************************************************************************
//*
//*  Timer Utility Functions
//*
//***************************************************************************

//===========================================================================

function StartTimerBJ takes timer t, boolean periodic, real timeout returns timer
    return null
endfunction

//===========================================================================

function CreateTimerBJ takes boolean periodic, real timeout returns timer
    return null
endfunction

//===========================================================================

function DestroyTimerBJ takes timer whichTimer returns nothing
endfunction

//===========================================================================

function PauseTimerBJ takes boolean pause, timer whichTimer returns nothing
endfunction

//===========================================================================

function GetLastCreatedTimerBJ takes nothing returns timer
    return null
endfunction

//===========================================================================

function CreateTimerDialogBJ takes timer t, string title returns timerdialog
    return null
endfunction

//===========================================================================

function DestroyTimerDialogBJ takes timerdialog td returns nothing
endfunction

//===========================================================================

function TimerDialogSetTitleBJ takes timerdialog td, string title returns nothing
endfunction

//===========================================================================

function TimerDialogSetTitleColorBJ takes timerdialog td, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function TimerDialogSetTimeColorBJ takes timerdialog td, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function TimerDialogSetSpeedBJ takes timerdialog td, real speedMultFactor returns nothing
endfunction

//===========================================================================

function TimerDialogDisplayForPlayerBJ takes boolean show, timerdialog td, player whichPlayer returns nothing
endfunction

//===========================================================================

function TimerDialogDisplayBJ takes boolean show, timerdialog td returns nothing
endfunction

//===========================================================================

function GetLastCreatedTimerDialogBJ takes nothing returns timerdialog
    return null
endfunction



//***************************************************************************
//*
//*  Leaderboard Utility Functions
//*
//***************************************************************************

//===========================================================================

function LeaderboardResizeBJ takes leaderboard lb returns nothing
endfunction

//===========================================================================

function LeaderboardSetPlayerItemValueBJ takes player whichPlayer, leaderboard lb, integer val returns nothing
endfunction

//===========================================================================

function LeaderboardSetPlayerItemLabelBJ takes player whichPlayer, leaderboard lb, string val returns nothing
endfunction

//===========================================================================

function LeaderboardSetPlayerItemStyleBJ takes player whichPlayer, leaderboard lb, boolean showLabel, boolean showValue, boolean showIcon returns nothing
endfunction

//===========================================================================

function LeaderboardSetPlayerItemLabelColorBJ takes player whichPlayer, leaderboard lb, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function LeaderboardSetPlayerItemValueColorBJ takes player whichPlayer, leaderboard lb, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function LeaderboardSetLabelColorBJ takes leaderboard lb, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function LeaderboardSetValueColorBJ takes leaderboard lb, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function LeaderboardSetLabelBJ takes leaderboard lb, string label returns nothing
endfunction

//===========================================================================

function LeaderboardSetStyleBJ takes leaderboard lb, boolean showLabel, boolean showNames, boolean showValues, boolean showIcons returns nothing
endfunction

//===========================================================================

function LeaderboardGetItemCountBJ takes leaderboard lb returns integer
    return 0
endfunction

//===========================================================================

function LeaderboardHasPlayerItemBJ takes leaderboard lb, player whichPlayer returns boolean
    return false
endfunction

//===========================================================================

function ForceSetLeaderboardBJ takes leaderboard lb, force toForce returns nothing
endfunction

//===========================================================================

function CreateLeaderboardBJ takes force toForce, string label returns leaderboard
    return null
endfunction

//===========================================================================

function DestroyLeaderboardBJ takes leaderboard lb returns nothing
endfunction

//===========================================================================

function LeaderboardDisplayBJ takes boolean show, leaderboard lb returns nothing
endfunction

//===========================================================================

function LeaderboardAddItemBJ takes player whichPlayer, leaderboard lb, string label, integer value returns nothing
endfunction

//===========================================================================

function LeaderboardRemovePlayerItemBJ takes player whichPlayer, leaderboard lb returns nothing
endfunction

//===========================================================================

function LeaderboardSortItemsBJ takes leaderboard lb, integer sortType, boolean ascending returns nothing
endfunction

//===========================================================================

function LeaderboardSortItemsByPlayerBJ takes leaderboard lb, boolean ascending returns nothing
endfunction

//===========================================================================

function LeaderboardSortItemsByLabelBJ takes leaderboard lb, boolean ascending returns nothing
endfunction

//===========================================================================

function LeaderboardGetPlayerIndexBJ takes player whichPlayer, leaderboard lb returns integer
    return 0
endfunction

//===========================================================================
// Returns the player who is occupying a specified position in a leaderboard.
// The position parameter is expected in the range of 1..16.
//

function LeaderboardGetIndexedPlayerBJ takes integer position, leaderboard lb returns player
    return null
endfunction

//===========================================================================

function PlayerGetLeaderboardBJ takes player whichPlayer returns leaderboard
    return null
endfunction

//===========================================================================

function GetLastCreatedLeaderboard takes nothing returns leaderboard
    return null
endfunction

//***************************************************************************
//*
//*  Multiboard Utility Functions
//*
//***************************************************************************

//===========================================================================

function CreateMultiboardBJ takes integer cols, integer rows, string title returns multiboard
    return null
endfunction

//===========================================================================

function DestroyMultiboardBJ takes multiboard mb returns nothing
endfunction

//===========================================================================

function GetLastCreatedMultiboard takes nothing returns multiboard
    return null
endfunction

//===========================================================================

function MultiboardDisplayBJ takes boolean show, multiboard mb returns nothing
endfunction

//===========================================================================

function MultiboardMinimizeBJ takes boolean minimize, multiboard mb returns nothing
endfunction

//===========================================================================

function MultiboardSetTitleTextColorBJ takes multiboard mb, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function MultiboardAllowDisplayBJ takes boolean flag returns nothing
endfunction

//===========================================================================

function MultiboardSetItemStyleBJ takes multiboard mb, integer col, integer row, boolean showValue, boolean showIcon returns nothing
endfunction

//===========================================================================

function MultiboardSetItemValueBJ takes multiboard mb, integer col, integer row, string val returns nothing
endfunction

//===========================================================================

function MultiboardSetItemColorBJ takes multiboard mb, integer col, integer row, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function MultiboardSetItemWidthBJ takes multiboard mb, integer col, integer row, real width returns nothing
endfunction

//===========================================================================

function MultiboardSetItemIconBJ takes multiboard mb, integer col, integer row, string iconFileName returns nothing
endfunction



//***************************************************************************
//*
//*  Text Tag Utility Functions
//*
//***************************************************************************

//===========================================================================
// Scale the font size linearly such that size 10 equates to height 0.023.
// Screen-relative font heights are harder to grasp and than font sizes.
//

function TextTagSize2Height takes real size returns real
    return 0.
endfunction

//===========================================================================
// Scale the speed linearly such that speed 128 equates to 0.071.
// Screen-relative speeds are hard to grasp.
//

function TextTagSpeed2Velocity takes real speed returns real
    return 0.
endfunction

//===========================================================================

function SetTextTagColorBJ takes texttag tt, real red, real green, real blue, real transparency returns nothing
endfunction

//===========================================================================

function SetTextTagVelocityBJ takes texttag tt, real speed, real angle returns nothing
endfunction

//===========================================================================

function SetTextTagTextBJ takes texttag tt, string s, real size returns nothing
endfunction

//===========================================================================

function SetTextTagPosBJ takes texttag tt, location loc, real zOffset returns nothing
endfunction

//===========================================================================

function SetTextTagPosUnitBJ takes texttag tt, unit whichUnit, real zOffset returns nothing
endfunction

//===========================================================================

function SetTextTagSuspendedBJ takes texttag tt, boolean flag returns nothing
endfunction

//===========================================================================

function SetTextTagPermanentBJ takes texttag tt, boolean flag returns nothing
endfunction

//===========================================================================

function SetTextTagAgeBJ takes texttag tt, real age returns nothing
endfunction

//===========================================================================

function SetTextTagLifespanBJ takes texttag tt, real lifespan returns nothing
endfunction

//===========================================================================

function SetTextTagFadepointBJ takes texttag tt, real fadepoint returns nothing
endfunction

//===========================================================================

function CreateTextTagLocBJ takes string s, location loc, real zOffset, real size, real red, real green, real blue, real transparency returns texttag
    return null
endfunction

//===========================================================================

function CreateTextTagUnitBJ takes string s, unit whichUnit, real zOffset, real size, real red, real green, real blue, real transparency returns texttag
    return null
endfunction

//===========================================================================

function DestroyTextTagBJ takes texttag tt returns nothing
endfunction

//===========================================================================

function ShowTextTagForceBJ takes boolean show, texttag tt, force whichForce returns nothing
endfunction

//===========================================================================

function GetLastCreatedTextTag takes nothing returns texttag
    return null
endfunction



//***************************************************************************
//*
//*  Cinematic Utility Functions
//*
//***************************************************************************

//===========================================================================

function PauseGameOn takes nothing returns nothing
endfunction

//===========================================================================

function PauseGameOff takes nothing returns nothing
endfunction

//===========================================================================

function SetUserControlForceOn takes force whichForce returns nothing
endfunction

//===========================================================================

function SetUserControlForceOff takes force whichForce returns nothing
endfunction

//===========================================================================

function ShowInterfaceForceOn takes force whichForce, real fadeDuration returns nothing
endfunction

//===========================================================================

function ShowInterfaceForceOff takes force whichForce, real fadeDuration returns nothing
endfunction

//===========================================================================

function PingMinimapForForce takes force whichForce, real x, real y, real duration returns nothing
endfunction

//===========================================================================

function PingMinimapLocForForce takes force whichForce, location loc, real duration returns nothing
endfunction

//===========================================================================

function PingMinimapForPlayer takes player whichPlayer, real x, real y, real duration returns nothing
endfunction

//===========================================================================

function PingMinimapLocForPlayer takes player whichPlayer, location loc, real duration returns nothing
endfunction

//===========================================================================

function PingMinimapForForceEx takes force whichForce, real x, real y, real duration, integer style, real red, real green, real blue returns nothing
endfunction

//===========================================================================

function PingMinimapLocForForceEx takes force whichForce, location loc, real duration, integer style, real red, real green, real blue returns nothing
endfunction

//===========================================================================

function EnableWorldFogBoundaryBJ takes boolean enable, force f returns nothing
endfunction

//===========================================================================

function EnableOcclusionBJ takes boolean enable, force f returns nothing
endfunction



//***************************************************************************
//*
//*  Cinematic Transmission Utility Functions
//*
//***************************************************************************

//===========================================================================
// If cancelled, stop the sound and end the cinematic scene.
//

function CancelCineSceneBJ takes nothing returns nothing
endfunction

//===========================================================================
// Init a trigger to listen for END_CINEMATIC events and respond to them if
// a cinematic scene is in progress.  For performance reasons, this should
// only be called once a cinematic scene has been started, so that maps
// lacking such scenes do not bother to register for these events.
//

function TryInitCinematicBehaviorBJ takes nothing returns nothing
endfunction

//===========================================================================

function SetCinematicSceneBJ takes sound soundHandle, integer portraitUnitId, playercolor color, string speakerTitle, string text, real sceneDuration, real voiceoverDuration returns nothing
endfunction

//===========================================================================

function GetTransmissionDuration takes sound soundHandle, integer timeType, real timeVal returns real
    return 0.
endfunction

//===========================================================================

function WaitTransmissionDuration takes sound soundHandle, integer timeType, real timeVal returns nothing
endfunction

//===========================================================================

function DoTransmissionBasicsXYBJ takes integer unitId, playercolor color, real x, real y, sound soundHandle, string unitName, string message, real duration returns nothing
endfunction

//===========================================================================
// Display a text message to a Player Group with an accompanying sound,
// portrait, speech indicator, and all that good stuff.
//   - Query duration of sound
//   - Play sound
//   - Display text message for duration
//   - Display animating portrait for duration
//   - Display a speech indicator for the unit
//   - Ping the minimap
//

function TransmissionFromUnitWithNameBJ takes force toForce, unit whichUnit, string unitName, sound soundHandle, string message, integer timeType, real timeVal, boolean wait returns nothing
endfunction

//===========================================================================


//===========================================================================


//===========================================================================
// This operates like TransmissionFromUnitWithNameBJ, but for a unit type
// rather than a unit instance.  As such, no speech indicator is employed.
//

function TransmissionFromUnitTypeWithNameBJ takes force toForce, player fromPlayer, integer unitId, string unitName, location loc, sound soundHandle, string message, integer timeType, real timeVal, boolean wait returns nothing
endfunction

//===========================================================================

function GetLastTransmissionDurationBJ takes nothing returns real
    return 0.
endfunction

//===========================================================================


//===========================================================================
function ForceCinematicSubtitlesBJ takes boolean flag returns nothing
endfunction


//***************************************************************************
//*
//*  Cinematic Mode Utility Functions
//*
//***************************************************************************

//===========================================================================
// Makes many common UI settings changes at once, for use when beginning and
// ending cinematic sequences.  Note that some affects apply to all players,
// such as game speed.  This is unavoidable.
//   - Clear the screen of text messages
//   - Hide interface UI (letterbox mode)
//   - Hide game messages (ally under attack, etc.)
//   - Disable user control
//   - Disable occlusion
//   - Set game speed (for all players)
//   - Lock game speed (for all players)
//   - Disable black mask (for all players)
//   - Disable fog of war (for all players)
//   - Disable world boundary fog (for all players)
//   - Dim non-speech sound channels
//   - End any outstanding music themes
//   - Fix the random seed to a set value
//   - Reset the camera smoothing factor
//

function CinematicModeExBJ takes boolean cineMode, force forForce, real interfaceFadeTime returns nothing
endfunction

//===========================================================================

function CinematicModeBJ takes boolean cineMode, force forForce returns nothing
endfunction



//***************************************************************************
//*
//*  Cinematic Filter Utility Functions
//*
//***************************************************************************

//===========================================================================

function DisplayCineFilterBJ takes boolean flag returns nothing
endfunction

//===========================================================================

function CinematicFadeCommonBJ takes real red, real green, real blue, real duration, string tex, real startTrans, real endTrans returns nothing
endfunction

//===========================================================================

function FinishCinematicFadeBJ takes nothing returns nothing
endfunction

//===========================================================================

function FinishCinematicFadeAfterBJ takes real duration returns nothing
endfunction

//===========================================================================

function ContinueCinematicFadeBJ takes nothing returns nothing
endfunction

//===========================================================================

function ContinueCinematicFadeAfterBJ takes real duration, real red, real green, real blue, real trans, string tex returns nothing
endfunction

//===========================================================================

function AbortCinematicFadeBJ takes nothing returns nothing
endfunction

//===========================================================================

function CinematicFadeBJ takes integer fadetype, real duration, string tex, real red, real green, real blue, real trans returns nothing
endfunction

//===========================================================================

function CinematicFilterGenericBJ takes real duration, blendmode bmode, string tex, real red0, real green0, real blue0, real trans0, real red1, real green1, real blue1, real trans1 returns nothing
endfunction



//***************************************************************************
//*
//*  Rescuable Unit Utility Functions
//*
//***************************************************************************

//===========================================================================
// Rescues a unit for a player.  This performs the default rescue behavior,
// including a rescue sound, flashing selection circle, ownership change,
// and optionally a unit color change.
//

function RescueUnitBJ takes unit whichUnit, player rescuer, boolean changeColor returns nothing
endfunction

//===========================================================================

function TriggerActionUnitRescuedBJ takes nothing returns nothing
endfunction

//===========================================================================
// Attempt to init triggers for default rescue behavior.  For performance
// reasons, this should only be attempted if a player is set to Rescuable,
// or if a specific unit is thus flagged.
//

function TryInitRescuableTriggersBJ takes nothing returns nothing
endfunction

//===========================================================================
// Determines whether or not rescued units automatically change color upon
// being rescued.
//

function SetRescueUnitColorChangeBJ takes boolean changeColor returns nothing
endfunction

//===========================================================================
// Determines whether or not rescued buildings automatically change color
// upon being rescued.
//

function SetRescueBuildingColorChangeBJ takes boolean changeColor returns nothing
endfunction

//===========================================================================

function MakeUnitRescuableToForceBJEnum takes nothing returns nothing
endfunction

//===========================================================================

function MakeUnitRescuableToForceBJ takes unit whichUnit, boolean isRescuable, force whichForce returns nothing
endfunction

//===========================================================================

function InitRescuableBehaviorBJ takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Research and Upgrade Utility Functions
//*
//***************************************************************************

//===========================================================================

function SetPlayerTechResearchedSwap takes integer techid, integer levels, player whichPlayer returns nothing
endfunction

//===========================================================================

function SetPlayerTechMaxAllowedSwap takes integer techid, integer maximum, player whichPlayer returns nothing
endfunction

//===========================================================================

function SetPlayerMaxHeroesAllowed takes integer maximum, player whichPlayer returns nothing
endfunction

//===========================================================================

function GetPlayerTechCountSimple takes integer techid, player whichPlayer returns integer
    return 0
endfunction

//===========================================================================

function GetPlayerTechMaxAllowedSwap takes integer techid, player whichPlayer returns integer
    return 0
endfunction

//===========================================================================

function SetPlayerAbilityAvailableBJ takes boolean avail, integer abilid, player whichPlayer returns nothing
endfunction



//***************************************************************************
//*
//*  Campaign Utility Functions
//*
//***************************************************************************


function SetCampaignMenuRaceBJ takes integer campaignNumber returns nothing
endfunction

//===========================================================================
// Converts a single campaign mission designation into campaign and mission
// numbers.  The 1000's digit is considered the campaign index, and the 1's
// digit is considered the mission index within that campaign.  This is done
// so that the trigger for this can use a single drop-down to list all of
// the campaign missions.
//

function SetMissionAvailableBJ takes boolean available, integer missionIndex returns nothing
endfunction

//===========================================================================

function SetCampaignAvailableBJ takes boolean available, integer campaignNumber returns nothing
endfunction

//===========================================================================

function SetCinematicAvailableBJ takes boolean available, integer cinematicIndex returns nothing
endfunction

//===========================================================================

function InitGameCacheBJ takes string campaignFile returns gamecache
    return null
endfunction

//===========================================================================

function SaveGameCacheBJ takes gamecache cache returns boolean
    return false
endfunction

//===========================================================================

function GetLastCreatedGameCacheBJ takes nothing returns gamecache
    return null
endfunction

//===========================================================================

function InitHashtableBJ takes nothing returns hashtable
    return null
endfunction

//===========================================================================

function GetLastCreatedHashtableBJ takes nothing returns hashtable
    return null
endfunction

//===========================================================================

function StoreRealBJ takes real value, string key, string missionKey, gamecache cache returns nothing
endfunction

//===========================================================================

function StoreIntegerBJ takes integer value, string key, string missionKey, gamecache cache returns nothing
endfunction

//===========================================================================

function StoreBooleanBJ takes boolean value, string key, string missionKey, gamecache cache returns nothing
endfunction

//===========================================================================

function StoreStringBJ takes string value, string key, string missionKey, gamecache cache returns boolean
    return false
endfunction

//===========================================================================

function StoreUnitBJ takes unit whichUnit, string key, string missionKey, gamecache cache returns boolean
    return false
endfunction

//===========================================================================

function SaveRealBJ takes real value, integer key, integer missionKey, hashtable table returns nothing
endfunction

//===========================================================================

function SaveIntegerBJ takes integer value, integer key, integer missionKey, hashtable table returns nothing
endfunction

//===========================================================================

function SaveBooleanBJ takes boolean value, integer key, integer missionKey, hashtable table returns nothing
endfunction

//===========================================================================

function SaveStringBJ takes string value, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SavePlayerHandleBJ takes player whichPlayer, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveWidgetHandleBJ takes widget whichWidget, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveDestructableHandleBJ takes destructable whichDestructable, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveItemHandleBJ takes item whichItem, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveUnitHandleBJ takes unit whichUnit, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveAbilityHandleBJ takes ability whichAbility, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTimerHandleBJ takes timer whichTimer, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTriggerHandleBJ takes trigger whichTrigger, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTriggerConditionHandleBJ takes triggercondition whichTriggercondition, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTriggerActionHandleBJ takes triggeraction whichTriggeraction, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTriggerEventHandleBJ takes event whichEvent, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveForceHandleBJ takes force whichForce, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveGroupHandleBJ takes group whichGroup, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveLocationHandleBJ takes location whichLocation, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveRectHandleBJ takes rect whichRect, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveBooleanExprHandleBJ takes boolexpr whichBoolexpr, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveSoundHandleBJ takes sound whichSound, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveEffectHandleBJ takes effect whichEffect, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveUnitPoolHandleBJ takes unitpool whichUnitpool, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveItemPoolHandleBJ takes itempool whichItempool, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveQuestHandleBJ takes quest whichQuest, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveQuestItemHandleBJ takes questitem whichQuestitem, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveDefeatConditionHandleBJ takes defeatcondition whichDefeatcondition, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTimerDialogHandleBJ takes timerdialog whichTimerdialog, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveLeaderboardHandleBJ takes leaderboard whichLeaderboard, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveMultiboardHandleBJ takes multiboard whichMultiboard, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveMultiboardItemHandleBJ takes multiboarditem whichMultiboarditem, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTrackableHandleBJ takes trackable whichTrackable, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveDialogHandleBJ takes dialog whichDialog, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveButtonHandleBJ takes button whichButton, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveTextTagHandleBJ takes texttag whichTexttag, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveLightningHandleBJ takes lightning whichLightning, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveImageHandleBJ takes image whichImage, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveUbersplatHandleBJ takes ubersplat whichUbersplat, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveRegionHandleBJ takes region whichRegion, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveFogStateHandleBJ takes fogstate whichFogState, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveFogModifierHandleBJ takes fogmodifier whichFogModifier, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveAgentHandleBJ takes agent whichAgent, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function SaveHashtableHandleBJ takes hashtable whichHashtable, integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function GetStoredRealBJ takes string key, string missionKey, gamecache cache returns real
    return 0.
endfunction

//===========================================================================

function GetStoredIntegerBJ takes string key, string missionKey, gamecache cache returns integer
    return 0
endfunction

//===========================================================================

function GetStoredBooleanBJ takes string key, string missionKey, gamecache cache returns boolean
    return false
endfunction

//===========================================================================

function GetStoredStringBJ takes string key, string missionKey, gamecache cache returns string
    return ""
endfunction

//===========================================================================

function LoadRealBJ takes integer key, integer missionKey, hashtable table returns real
    return 0.
endfunction

//===========================================================================

function LoadIntegerBJ takes integer key, integer missionKey, hashtable table returns integer
    return 0
endfunction

//===========================================================================

function LoadBooleanBJ takes integer key, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function LoadStringBJ takes integer key, integer missionKey, hashtable table returns string
    return ""
endfunction

//===========================================================================

function LoadPlayerHandleBJ takes integer key, integer missionKey, hashtable table returns player
    return null
endfunction

//===========================================================================

function LoadWidgetHandleBJ takes integer key, integer missionKey, hashtable table returns widget
    return null
endfunction

//===========================================================================

function LoadDestructableHandleBJ takes integer key, integer missionKey, hashtable table returns destructable
    return null
endfunction

//===========================================================================

function LoadItemHandleBJ takes integer key, integer missionKey, hashtable table returns item
    return null
endfunction

//===========================================================================

function LoadUnitHandleBJ takes integer key, integer missionKey, hashtable table returns unit
    return null
endfunction

//===========================================================================

function LoadAbilityHandleBJ takes integer key, integer missionKey, hashtable table returns ability
    return null
endfunction

//===========================================================================

function LoadTimerHandleBJ takes integer key, integer missionKey, hashtable table returns timer
    return null
endfunction

//===========================================================================

function LoadTriggerHandleBJ takes integer key, integer missionKey, hashtable table returns trigger
    return null
endfunction

//===========================================================================

function LoadTriggerConditionHandleBJ takes integer key, integer missionKey, hashtable table returns triggercondition
    return null
endfunction

//===========================================================================

function LoadTriggerActionHandleBJ takes integer key, integer missionKey, hashtable table returns triggeraction
    return null
endfunction

//===========================================================================

function LoadTriggerEventHandleBJ takes integer key, integer missionKey, hashtable table returns event
    return null
endfunction

//===========================================================================

function LoadForceHandleBJ takes integer key, integer missionKey, hashtable table returns force
    return null
endfunction

//===========================================================================

function LoadGroupHandleBJ takes integer key, integer missionKey, hashtable table returns group
    return null
endfunction

//===========================================================================

function LoadLocationHandleBJ takes integer key, integer missionKey, hashtable table returns location
    return null
endfunction

//===========================================================================

function LoadRectHandleBJ takes integer key, integer missionKey, hashtable table returns rect
    return null
endfunction

//===========================================================================

function LoadBooleanExprHandleBJ takes integer key, integer missionKey, hashtable table returns boolexpr
    return null
endfunction

//===========================================================================

function LoadSoundHandleBJ takes integer key, integer missionKey, hashtable table returns sound
    return null
endfunction

//===========================================================================

function LoadEffectHandleBJ takes integer key, integer missionKey, hashtable table returns effect
    return null
endfunction

//===========================================================================

function LoadUnitPoolHandleBJ takes integer key, integer missionKey, hashtable table returns unitpool
    return null
endfunction

//===========================================================================

function LoadItemPoolHandleBJ takes integer key, integer missionKey, hashtable table returns itempool
    return null
endfunction

//===========================================================================

function LoadQuestHandleBJ takes integer key, integer missionKey, hashtable table returns quest
    return null
endfunction

//===========================================================================

function LoadQuestItemHandleBJ takes integer key, integer missionKey, hashtable table returns questitem
    return null
endfunction

//===========================================================================

function LoadDefeatConditionHandleBJ takes integer key, integer missionKey, hashtable table returns defeatcondition
    return null
endfunction

//===========================================================================

function LoadTimerDialogHandleBJ takes integer key, integer missionKey, hashtable table returns timerdialog
    return null
endfunction

//===========================================================================

function LoadLeaderboardHandleBJ takes integer key, integer missionKey, hashtable table returns leaderboard
    return null
endfunction

//===========================================================================

function LoadMultiboardHandleBJ takes integer key, integer missionKey, hashtable table returns multiboard
    return null
endfunction

//===========================================================================

function LoadMultiboardItemHandleBJ takes integer key, integer missionKey, hashtable table returns multiboarditem
    return null
endfunction

//===========================================================================

function LoadTrackableHandleBJ takes integer key, integer missionKey, hashtable table returns trackable
    return null
endfunction

//===========================================================================

function LoadDialogHandleBJ takes integer key, integer missionKey, hashtable table returns dialog
    return null
endfunction

//===========================================================================

function LoadButtonHandleBJ takes integer key, integer missionKey, hashtable table returns button
    return null
endfunction

//===========================================================================

function LoadTextTagHandleBJ takes integer key, integer missionKey, hashtable table returns texttag
    return null
endfunction

//===========================================================================

function LoadLightningHandleBJ takes integer key, integer missionKey, hashtable table returns lightning
    return null
endfunction

//===========================================================================

function LoadImageHandleBJ takes integer key, integer missionKey, hashtable table returns image
    return null
endfunction

//===========================================================================

function LoadUbersplatHandleBJ takes integer key, integer missionKey, hashtable table returns ubersplat
    return null
endfunction

//===========================================================================

function LoadRegionHandleBJ takes integer key, integer missionKey, hashtable table returns region
    return null
endfunction

//===========================================================================

function LoadFogStateHandleBJ takes integer key, integer missionKey, hashtable table returns fogstate
    return null
endfunction

//===========================================================================

function LoadFogModifierHandleBJ takes integer key, integer missionKey, hashtable table returns fogmodifier
    return null
endfunction

//===========================================================================

function LoadHashtableHandleBJ takes integer key, integer missionKey, hashtable table returns hashtable
    return null
endfunction

//===========================================================================

function RestoreUnitLocFacingAngleBJ takes string key, string missionKey, gamecache cache, player forWhichPlayer, location loc, real facing returns unit
    return null
endfunction

//===========================================================================

function RestoreUnitLocFacingPointBJ takes string key, string missionKey, gamecache cache, player forWhichPlayer, location loc, location lookAt returns unit
    return null
endfunction

//===========================================================================

function GetLastRestoredUnitBJ takes nothing returns unit
    return null
endfunction

//===========================================================================

function FlushGameCacheBJ takes gamecache cache returns nothing
endfunction

//===========================================================================

function FlushStoredMissionBJ takes string missionKey, gamecache cache returns nothing
endfunction

//===========================================================================

function FlushParentHashtableBJ takes hashtable table returns nothing
endfunction

//===========================================================================

function FlushChildHashtableBJ takes integer missionKey, hashtable table returns nothing
endfunction

//===========================================================================

function HaveStoredValue takes string key, integer valueType, string missionKey, gamecache cache returns boolean
    return false
endfunction

//===========================================================================

function HaveSavedValue takes integer key, integer valueType, integer missionKey, hashtable table returns boolean
    return false
endfunction

//===========================================================================

function ShowCustomCampaignButton takes boolean show, integer whichButton returns nothing
endfunction

//===========================================================================

function IsCustomCampaignButtonVisibile takes integer whichButton returns boolean
    return false
endfunction

//===========================================================================
// Placeholder function for auto save feature
//===========================================================================


//===========================================================================

function LoadGameBJ takes string loadFileName, boolean doScoreScreen returns nothing
endfunction

//===========================================================================

function SaveAndChangeLevelBJ takes string saveFileName, string newLevel, boolean doScoreScreen returns nothing
endfunction

//===========================================================================

function SaveAndLoadGameBJ takes string saveFileName, string loadFileName, boolean doScoreScreen returns nothing
endfunction

//===========================================================================

function RenameSaveDirectoryBJ takes string sourceDirName, string destDirName returns boolean
    return false
endfunction

//===========================================================================

function RemoveSaveDirectoryBJ takes string sourceDirName returns boolean
    return false
endfunction

//===========================================================================

function CopySaveGameBJ takes string sourceSaveName, string destSaveName returns boolean
    return false
endfunction



//***************************************************************************
//*
//*  Miscellaneous Utility Functions
//*
//***************************************************************************

//===========================================================================

function GetPlayerStartLocationX takes player whichPlayer returns real
    return 0.
endfunction

//===========================================================================

function GetPlayerStartLocationY takes player whichPlayer returns real
    return 0.
endfunction

//===========================================================================

function GetPlayerStartLocationLoc takes player whichPlayer returns location
    return null
endfunction

//===========================================================================

function GetRectCenter takes rect whichRect returns location
    return null
endfunction

//===========================================================================

function IsPlayerSlotState takes player whichPlayer, playerslotstate whichState returns boolean
    return false
endfunction

//===========================================================================

function GetFadeFromSeconds takes real seconds returns integer
    return 0
endfunction

//===========================================================================

function GetFadeFromSecondsAsReal takes real seconds returns real
    return 0.
endfunction

//===========================================================================

function AdjustPlayerStateSimpleBJ takes player whichPlayer, playerstate whichPlayerState, integer delta returns nothing
endfunction

//===========================================================================

function AdjustPlayerStateBJ takes integer delta, player whichPlayer, playerstate whichPlayerState returns nothing
endfunction

//===========================================================================

function SetPlayerStateBJ takes player whichPlayer, playerstate whichPlayerState, integer value returns nothing
endfunction

//===========================================================================

function SetPlayerFlagBJ takes playerstate whichPlayerFlag, boolean flag, player whichPlayer returns nothing
endfunction

//===========================================================================

function SetPlayerTaxRateBJ takes integer rate, playerstate whichResource, player sourcePlayer, player otherPlayer returns nothing
endfunction

//===========================================================================

function GetPlayerTaxRateBJ takes playerstate whichResource, player sourcePlayer, player otherPlayer returns integer
    return 0
endfunction

//===========================================================================

function IsPlayerFlagSetBJ takes playerstate whichPlayerFlag, player whichPlayer returns boolean
    return false
endfunction

//===========================================================================

function AddResourceAmountBJ takes integer delta, unit whichUnit returns nothing
endfunction

//===========================================================================

function GetConvertedPlayerId takes player whichPlayer returns integer
    return 0
endfunction

//===========================================================================

function ConvertedPlayer takes integer convertedPlayerId returns player
    return null
endfunction

//===========================================================================

function GetRectWidthBJ takes rect r returns real
    return 0.
endfunction

//===========================================================================

function GetRectHeightBJ takes rect r returns real
    return 0.
endfunction

//===========================================================================
// Replaces a gold mine with a blighted gold mine for the given player.
//

function BlightGoldMineForPlayerBJ takes unit goldMine, player whichPlayer returns unit
    return null
endfunction

//===========================================================================

function BlightGoldMineForPlayer takes unit goldMine, player whichPlayer returns unit
    return null
endfunction

//===========================================================================

function GetLastHauntedGoldMine takes nothing returns unit
    return null
endfunction

//===========================================================================

function IsPointBlightedBJ takes location where returns boolean
    return false
endfunction

//===========================================================================

function SetPlayerColorBJEnum takes nothing returns nothing
endfunction

//===========================================================================

function SetPlayerColorBJ takes player whichPlayer, playercolor color, boolean changeExisting returns nothing
endfunction

//===========================================================================

function SetPlayerUnitAvailableBJ takes integer unitId, boolean allowed, player whichPlayer returns nothing
endfunction

//===========================================================================

function LockGameSpeedBJ takes nothing returns nothing
endfunction

//===========================================================================

function UnlockGameSpeedBJ takes nothing returns nothing
endfunction

//===========================================================================

function IssueTargetOrderBJ takes unit whichUnit, string order, widget targetWidget returns boolean
    return false
endfunction

//===========================================================================

function IssuePointOrderLocBJ takes unit whichUnit, string order, location whichLocation returns boolean
    return false
endfunction

//===========================================================================
// Two distinct trigger actions can't share the same function name, so this
// dummy function simply mimics the behavior of an existing call.
//

function IssueTargetDestructableOrder takes unit whichUnit, string order, widget targetWidget returns boolean
    return false
endfunction


function IssueTargetItemOrder takes unit whichUnit, string order, widget targetWidget returns boolean
    return false
endfunction

//===========================================================================

function IssueImmediateOrderBJ takes unit whichUnit, string order returns boolean
    return false
endfunction

//===========================================================================

function GroupTargetOrderBJ takes group whichGroup, string order, widget targetWidget returns boolean
    return false
endfunction

//===========================================================================

function GroupPointOrderLocBJ takes group whichGroup, string order, location whichLocation returns boolean
    return false
endfunction

//===========================================================================

function GroupImmediateOrderBJ takes group whichGroup, string order returns boolean
    return false
endfunction

//===========================================================================
// Two distinct trigger actions can't share the same function name, so this
// dummy function simply mimics the behavior of an existing call.
//

function GroupTargetDestructableOrder takes group whichGroup, string order, widget targetWidget returns boolean
    return false
endfunction


function GroupTargetItemOrder takes group whichGroup, string order, widget targetWidget returns boolean
    return false
endfunction

//===========================================================================

function GetDyingDestructable takes nothing returns destructable
    return null
endfunction

//===========================================================================
// Rally point setting
//

function SetUnitRallyPoint takes unit whichUnit, location targPos returns nothing
endfunction

//===========================================================================

function SetUnitRallyUnit takes unit whichUnit, unit targUnit returns nothing
endfunction

//===========================================================================

function SetUnitRallyDestructable takes unit whichUnit, destructable targDest returns nothing
endfunction

//===========================================================================
// Utility function for use by editor-generated item drop table triggers.
// This function is added as an action to all destructable drop triggers,
// so that a widget drop may be differentiated from a unit drop.
//

function SaveDyingWidget takes nothing returns nothing
endfunction

//===========================================================================

function SetBlightRectBJ takes boolean addBlight, player whichPlayer, rect r returns nothing
endfunction

//===========================================================================

function SetBlightRadiusLocBJ takes boolean addBlight, player whichPlayer, location loc, real radius returns nothing
endfunction

//===========================================================================

function GetAbilityName takes integer abilcode returns string
    return ""
endfunction


//***************************************************************************
//*
//*  Melee Template Visibility Settings
//*
//***************************************************************************

//===========================================================================

function MeleeStartingVisibility takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Melee Template Starting Resources
//*
//***************************************************************************

//===========================================================================

function MeleeStartingResources takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Melee Template Hero Limit
//*
//***************************************************************************

//===========================================================================

function ReducePlayerTechMaxAllowed takes player whichPlayer, integer techId, integer limit returns nothing
endfunction

//===========================================================================

function MeleeStartingHeroLimit takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Melee Template Granted Hero Items
//*
//***************************************************************************

//===========================================================================

function MeleeTrainedUnitIsHeroBJFilter takes nothing returns boolean
    return false
endfunction

//===========================================================================
// The first N heroes trained or hired for each player start off with a
// standard set of items.  This is currently:
//   - 1x Scroll of Town Portal
//

function MeleeGrantItemsToHero takes unit whichUnit returns nothing
endfunction

//===========================================================================

function MeleeGrantItemsToTrainedHero takes nothing returns nothing
endfunction

//===========================================================================

function MeleeGrantItemsToHiredHero takes nothing returns nothing
endfunction

//===========================================================================

function MeleeGrantHeroItems takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Melee Template Clear Start Locations
//*
//***************************************************************************

//===========================================================================

function MeleeClearExcessUnit takes nothing returns nothing
endfunction

//===========================================================================

function MeleeClearNearbyUnits takes real x, real y, real range returns nothing
endfunction

//===========================================================================

function MeleeClearExcessUnits takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Melee Template Starting Units
//*
//***************************************************************************

//===========================================================================

function MeleeEnumFindNearestMine takes nothing returns nothing
endfunction

//===========================================================================

function MeleeFindNearestMine takes location src, real range returns unit
    return null
endfunction

//===========================================================================

function MeleeRandomHeroLoc takes player p, integer id1, integer id2, integer id3, integer id4, location loc returns unit
    return null
endfunction

//===========================================================================
// Returns a location which is (distance) away from (src) in the direction of (targ).
//

function MeleeGetProjectedLoc takes location src, location targ, real distance, real deltaAngle returns location
    return null
endfunction

//===========================================================================

function MeleeGetNearestValueWithin takes real val, real minVal, real maxVal returns real
    return 0.
endfunction

//===========================================================================

function MeleeGetLocWithinRect takes location src, rect r returns location
    return null
endfunction

//===========================================================================
// Starting Units for Human Players
//   - 1 Town Hall, placed at start location
//   - 5 Peasants, placed between start location and nearest gold mine
//

function MeleeStartingUnitsHuman takes player whichPlayer, location startLoc, boolean doHeroes, boolean doCamera, boolean doPreload returns nothing
endfunction

//===========================================================================
// Starting Units for Orc Players
//   - 1 Great Hall, placed at start location
//   - 5 Peons, placed between start location and nearest gold mine
//

function MeleeStartingUnitsOrc takes player whichPlayer, location startLoc, boolean doHeroes, boolean doCamera, boolean doPreload returns nothing
endfunction

//===========================================================================
// Starting Units for Undead Players
//   - 1 Necropolis, placed at start location
//   - 1 Haunted Gold Mine, placed on nearest gold mine
//   - 3 Acolytes, placed between start location and nearest gold mine
//   - 1 Ghoul, placed between start location and nearest gold mine
//   - Blight, centered on nearest gold mine, spread across a "large area"
//

function MeleeStartingUnitsUndead takes player whichPlayer, location startLoc, boolean doHeroes, boolean doCamera, boolean doPreload returns nothing
endfunction

//===========================================================================
// Starting Units for Night Elf Players
//   - 1 Tree of Life, placed by nearest gold mine, already entangled
//   - 5 Wisps, placed between Tree of Life and nearest gold mine
//

function MeleeStartingUnitsNightElf takes player whichPlayer, location startLoc, boolean doHeroes, boolean doCamera, boolean doPreload returns nothing
endfunction

//===========================================================================
// Starting Units for Players Whose Race is Unknown
//   - 12 Sheep, placed randomly around the start location
//

function MeleeStartingUnitsUnknownRace takes player whichPlayer, location startLoc, boolean doHeroes, boolean doCamera, boolean doPreload returns nothing
endfunction

//===========================================================================

function MeleeStartingUnits takes nothing returns nothing
endfunction

//===========================================================================

function MeleeStartingUnitsForPlayer takes race whichRace, player whichPlayer, location loc, boolean doHeroes returns nothing
endfunction



//***************************************************************************
//*
//*  Melee Template Starting AI Scripts
//*
//***************************************************************************

//===========================================================================

function PickMeleeAI takes player num, string s1, string s2, string s3 returns nothing
endfunction

//===========================================================================

function MeleeStartingAI takes nothing returns nothing
endfunction


function LockGuardPosition takes unit targ returns nothing
endfunction


//***************************************************************************
//*
//*  Melee Template Victory / Defeat Conditions
//*
//***************************************************************************

//===========================================================================

function MeleePlayerIsOpponent takes integer playerIndex, integer opponentIndex returns boolean
    return false
endfunction

//===========================================================================
// Count buildings currently owned by all allies, including the player themself.
//

function MeleeGetAllyStructureCount takes player whichPlayer returns integer
    return 0
endfunction

//===========================================================================
// Count allies, excluding dead players and the player themself.
//

function MeleeGetAllyCount takes player whichPlayer returns integer
    return 0
endfunction

//===========================================================================
// Counts key structures owned by a player and his or her allies, including
// structures currently upgrading or under construction.
//
// Key structures: Town Hall, Great Hall, Tree of Life, Necropolis
//

function MeleeGetAllyKeyStructureCount takes player whichPlayer returns integer
    return 0
endfunction

//===========================================================================
// Enum: Draw out a specific player.
//

function MeleeDoDrawEnum takes nothing returns nothing
endfunction

//===========================================================================
// Enum: Victory out a specific player.
//

function MeleeDoVictoryEnum takes nothing returns nothing
endfunction

//===========================================================================
// Defeat out a specific player.
//

function MeleeDoDefeat takes player whichPlayer returns nothing
endfunction

//===========================================================================
// Enum: Defeat out a specific player.
//

function MeleeDoDefeatEnum takes nothing returns nothing
endfunction

//===========================================================================
// A specific player left the game.
//

function MeleeDoLeave takes player whichPlayer returns nothing
endfunction

//===========================================================================
// Remove all observers
// 

function MeleeRemoveObservers takes nothing returns nothing
endfunction

//===========================================================================
// Test all players to determine if a team has won.  For a team to win, all
// remaining (read: undefeated) players need to be co-allied with all other
// remaining players.  If even one player is not allied towards another,
// everyone must be denied victory.
//

function MeleeCheckForVictors takes nothing returns force
    return null
endfunction

//===========================================================================
// Test each player to determine if anyone has been defeated.
//

function MeleeCheckForLosersAndVictors takes nothing returns nothing
endfunction

//===========================================================================
// Returns a race-specific "build X or be revealed" message.
//

function MeleeGetCrippledWarningMessage takes player whichPlayer returns string
    return ""
endfunction

//===========================================================================
// Returns a race-specific "build X" label for cripple timers.
//

function MeleeGetCrippledTimerMessage takes player whichPlayer returns string
    return ""
endfunction

//===========================================================================
// Returns a race-specific "build X" label for cripple timers.
//

function MeleeGetCrippledRevealedMessage takes player whichPlayer returns string
    return ""
endfunction

//===========================================================================

function MeleeExposePlayer takes player whichPlayer, boolean expose returns nothing
endfunction

//===========================================================================

function MeleeExposeAllPlayers takes nothing returns nothing
endfunction

//===========================================================================

function MeleeCrippledPlayerTimeout takes nothing returns nothing
endfunction

//===========================================================================

function MeleePlayerIsCrippled takes player whichPlayer returns boolean
    return false
endfunction

//===========================================================================
// Test each player to determine if anyone has become crippled.
//

function MeleeCheckForCrippledPlayers takes nothing returns nothing
endfunction

//===========================================================================
// Determine if the lost unit should result in any defeats or victories.
//

function MeleeCheckLostUnit takes unit lostUnit returns nothing
endfunction

//===========================================================================
// Determine if the gained unit should result in any defeats, victories,
// or cripple-status changes.
//

function MeleeCheckAddedUnit takes unit addedUnit returns nothing
endfunction

//===========================================================================

function MeleeTriggerActionConstructCancel takes nothing returns nothing
endfunction

//===========================================================================

function MeleeTriggerActionUnitDeath takes nothing returns nothing
endfunction

//===========================================================================

function MeleeTriggerActionUnitConstructionStart takes nothing returns nothing
endfunction

//===========================================================================

function MeleeTriggerActionPlayerDefeated takes nothing returns nothing
endfunction

//===========================================================================

function MeleeTriggerActionPlayerLeft takes nothing returns nothing
endfunction

//===========================================================================

function MeleeTriggerActionAllianceChange takes nothing returns nothing
endfunction

//===========================================================================

function MeleeTriggerTournamentFinishSoon takes nothing returns nothing
endfunction


//===========================================================================

function MeleeWasUserPlayer takes player whichPlayer returns boolean
    return false
endfunction

//===========================================================================

function MeleeTournamentFinishNowRuleA takes integer multiplier returns nothing
endfunction

//===========================================================================

function MeleeTriggerTournamentFinishNow takes nothing returns nothing
endfunction

//===========================================================================

function MeleeInitVictoryDefeat takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Player Slot Availability
//*
//***************************************************************************

//===========================================================================

function CheckInitPlayerSlotAvailability takes nothing returns nothing
endfunction

//===========================================================================

function SetPlayerSlotAvailable takes player whichPlayer, mapcontrol control returns nothing
endfunction



//***************************************************************************
//*
//*  Generic Template Player-slot Initialization
//*
//***************************************************************************

//===========================================================================

function TeamInitPlayerSlots takes integer teamCount returns nothing
endfunction

//===========================================================================

function MeleeInitPlayerSlots takes nothing returns nothing
endfunction

//===========================================================================

function FFAInitPlayerSlots takes nothing returns nothing
endfunction

//===========================================================================

function OneOnOneInitPlayerSlots takes nothing returns nothing
endfunction

//===========================================================================

function InitGenericPlayerSlots takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Blizzard.j Initialization
//*
//***************************************************************************

//===========================================================================

function SetDNCSoundsDawn takes nothing returns nothing
endfunction

//===========================================================================

function SetDNCSoundsDusk takes nothing returns nothing
endfunction

//===========================================================================

function SetDNCSoundsDay takes nothing returns nothing
endfunction

//===========================================================================

function SetDNCSoundsNight takes nothing returns nothing
endfunction

//===========================================================================

function InitDNCSounds takes nothing returns nothing
endfunction

//===========================================================================

function InitBlizzardGlobals takes nothing returns nothing
endfunction

//===========================================================================

function InitQueuedTriggers takes nothing returns nothing
endfunction

//===========================================================================

function InitMapRects takes nothing returns nothing
endfunction

//===========================================================================

function InitSummonableCaps takes nothing returns nothing
endfunction

//===========================================================================
// Update the per-class stock limits.
//

function UpdateStockAvailability takes item whichItem returns nothing
endfunction

//===========================================================================
// Find a sellable item of the given type and level, and then add it.
//

function UpdateEachStockBuildingEnum takes nothing returns nothing
endfunction

//===========================================================================

function UpdateEachStockBuilding takes itemtype iType, integer iLevel returns nothing
endfunction

//===========================================================================
// Update stock inventory.
//

function PerformStockUpdates takes nothing returns nothing
endfunction

//===========================================================================
// Perform the first update, and then arrange future updates.
//

function StartStockUpdates takes nothing returns nothing
endfunction

//===========================================================================

function RemovePurchasedItem takes nothing returns nothing
endfunction

//===========================================================================

function InitNeutralBuildings takes nothing returns nothing
endfunction

//===========================================================================

function MarkGameStarted takes nothing returns nothing
endfunction

//===========================================================================

function DetectGameStarted takes nothing returns nothing
endfunction

//===========================================================================

function InitBlizzard takes nothing returns nothing
endfunction



//***************************************************************************
//*
//*  Random distribution
//*
//*  Used to select a random object from a given distribution of chances
//*
//*  - RandomDistReset clears the distribution list
//*
//*  - RandomDistAddItem adds a new object to the distribution list
//*    with a given identifier and an integer chance to be chosen
//*
//*  - RandomDistChoose will use the current distribution list to choose
//*    one of the objects randomly based on the chance distribution
//*  
//*  Note that the chances are effectively normalized by their sum,
//*  so only the relative values of each chance are important
//*
//***************************************************************************

//===========================================================================

function RandomDistReset takes nothing returns nothing
endfunction

//===========================================================================

function RandomDistAddItem takes integer inID, integer inChance returns nothing
endfunction

//===========================================================================

function RandomDistChoose takes nothing returns integer
    return 0
endfunction



//***************************************************************************
//*
//*  Drop item
//*
//*  Makes the given unit drop the given item
//*
//*  Note: This could potentially cause problems if the unit is standing
//*        right on the edge of an unpathable area and happens to drop the
//*        item into the unpathable area where nobody can get it...
//*
//***************************************************************************


function UnitDropItem takes unit inUnit, integer inItemID returns item
    return null
endfunction

//===========================================================================

function WidgetDropItem takes widget inWidget, integer inItemID returns item
    return null
endfunction


//***************************************************************************
//*
//*  Instanced Object Operation Functions
//*
//*  Get/Set specific fields for single unit/item/ability instance
//*
//***************************************************************************

//===========================================================================


// Ability
//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


// Item 
//=============================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================



// Unit 
//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


// Unit Weapon
//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


//===========================================================================


